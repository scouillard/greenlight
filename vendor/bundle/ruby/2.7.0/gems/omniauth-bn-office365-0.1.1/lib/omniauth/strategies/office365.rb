# frozen_string_literal: true

require 'omniauth'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    # Implements an OmniAuth strategy to get a Microsoft Graph
    # compatible token from Azure AD
    class Office365 < OmniAuth::Strategies::OAuth2
      option :name, 'office365'

      DEFAULT_SCOPE = 'openid email profile User.Read'

      # Configure the Azure v2 endpoints
      option  :client_options,
              site:          'https://login.microsoftonline.com',
              authorize_url: '/common/oauth2/v2.0/authorize',
              token_url:     '/common/oauth2/v2.0/token'

      # Send the scope parameter during authorize
      option :authorize_options, [:scope, :hd]

      # Unique ID for the user is the id field
      uid { raw_info['id'] }

      # Get additional information after token is retrieved
      extra do
        raw_info
      end

      info do
        {
          name: raw_info['displayName'],
          username: raw_info['displayName'],
          email: raw_info['mail'] || raw_info['userPrincipalName'],
          image: avatar_file
        }
      end

      def raw_info
        # Get user profile information from the /me endpoint
        @raw_info ||= verify_hd
        @raw_info
      end

      def authorize_params
        super.tap do |params|
          %w[display hd scope auth_type].each do |v|
            params[v.to_sym] = request.params[v] if request.params[v]
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      # Override callback URL
      # OmniAuth by default passes the entire URL of the callback, including
      # query parameters. Azure fails validation because that doesn't match the
      # registered callback.
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      private

      def avatar_file
        photo = access_token.get("https://graph.microsoft.com/v1.0/me/photo/$value")
        ext   = photo.content_type.sub("image/", "") # "image/jpeg" => "jpeg"

        Tempfile.new(["avatar", ".#{ext}"]).tap do |file|
          file.binmode
          file.write(photo.body)
          file.rewind
        end
      rescue ::OAuth2::Error => e
        if e.response.status == 404
          nil
        elsif e.code['code'] == 'GetUserPhoto' && e.code['message'].match('not supported')
          nil
        else
          raise
        end
      end

      def verify_hd
        token = access_token.get('https://graph.microsoft.com/v1.0/me').parsed

        return token unless options.hd

        email = token["mail"] || token["userPrincipalName"]

        current_host_domain = email.split("@")[1]

        unless options.hd.split(',').any?{ |hd| hd.casecmp(current_host_domain)==0 }
          raise CallbackError.new(:invalid_hd, "Invalid Hosted Domain - Received HD(#{current_host_domain}) - Allowed HD(#{options.hd})")
        end

        token
      end
    end
  end
end
