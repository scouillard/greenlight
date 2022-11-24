# frozen_string_literal: true

<<<<<<< HEAD
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
=======
require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

<<<<<<< HEAD
  # Show custom error pages in development.
  config.consider_all_requests_local = false

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
=======
  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

<<<<<<< HEAD
  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't wrap form components in field_with_error divs
  ActionView::Base.field_error_proc = proc do |html_tag|
    html_tag.html_safe
  end

  # Tell Action Mailer to use smtp server, if configured
  config.action_mailer.delivery_method = ENV['SMTP_SERVER'].present? ? :smtp : :sendmail

  ActionMailer::Base.smtp_settings = {
    address: ENV['SMTP_SERVER'],
    port: ENV["SMTP_PORT"],
    domain: ENV['SMTP_DOMAIN'],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: ENV['SMTP_AUTH'],
    enable_starttls_auto: ENV['SMTP_STARTTLS_AUTO'],
  }

  # Do care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

=======
  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  if ENV['SMTP_SERVER'].present?
    config.action_mailer.perform_deliveries = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV.fetch('SMTP_SERVER', nil),
      port: ENV.fetch('SMTP_PORT', nil),
      domain: ENV.fetch('SMTP_DOMAIN', nil),
      user_name: ENV.fetch('SMTP_USERNAME', nil),
      password: ENV.fetch('SMTP_PASSWORD', nil),
      authentication: ENV.fetch('SMTP_AUTH', nil),
      enable_starttls_auto: ENV.fetch('SMTP_STARTTLS_AUTO', true),
      enable_starttls: ENV.fetch('SMTP_STARTTLS', false),
      tls: ENV.fetch('SMTP_TLS', 'false') != 'false',
      openssl_verify_mode: ENV.fetch('SMTP_SSL_VERIFY', 'true') == 'false' ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
    }
    config.action_mailer.default_options = {
      from: ActionMailer::Base.email_address_with_name(ENV.fetch('SMTP_SENDER_EMAIL'), ENV.fetch('SMTP_SENDER_NAME', nil))
    }
  else
    config.action_mailer.perform_deliveries = false
  end

  config.action_mailer.raise_delivery_errors = true
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

<<<<<<< HEAD
=======
  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

<<<<<<< HEAD
  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
=======
  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8

  config.hosts = nil
end
