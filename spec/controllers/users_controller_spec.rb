# frozen_string_literal: true

<<<<<<< HEAD
# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
#
# Copyright (c) 2018 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.

require "rails_helper"

def random_valid_user_params
  pass = "#{Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)}1aB"
  {
    user: {
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: pass,
      password_confirmation: pass,
      accepted_terms: true,
      email_verified: true,
    },
  }
end

describe UsersController, type: :controller do
  let(:invalid_params) do
    {
      user: {
        name: "Invalid",
        email: "example.com",
        password: "pass",
        password_confirmation: "invalid",
        accepted_terms: false,
        email_verified: false,
      },
    }
  end

  describe "GET #edit" do
    it "renders the edit template" do
      user = create(:user)
      @request.session[:user_id] = user.id

      get :edit, params: { user_uid: user.uid }

      expect(response).to render_template(:edit)
    end

    it "does not allow you to edit other users if you're not an admin" do
      user = create(:user)
      user2 = create(:user)

      @request.session[:user_id] = user.id

      get :edit, params: { user_uid: user2.uid }

      expect(response).to redirect_to(root_path)
    end

    it "allows admins to edit other users" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:set_user_domain).and_return("provider1")
      controller.instance_variable_set(:@user_domain, "provider1")

      user = create(:user, provider: "provider1")
      user.set_role :admin
      user2 = create(:user, provider: "provider1")

      @request.session[:user_id] = user.id

      get :edit, params: { user_uid: user2.uid }

      expect(response).to render_template(:edit)
    end

    it "redirect to root if user isn't signed in" do
      user = create(:user)

      get :edit, params: { user_uid: user }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
    context "allow greenlight accounts" do
      before { allow(Rails.configuration).to receive(:allow_user_signup).and_return(true) }
      before { allow(Rails.configuration).to receive(:enable_email_verification).and_return(false) }

      it "redirects to user room on successful create" do
        params = random_valid_user_params
        post :create, params: params

        u = User.find_by(name: params[:user][:name], email: params[:user][:email])

        expect(u).to_not be_nil
        expect(u.name).to eql(params[:user][:name])

        expect(response).to redirect_to(room_path(u.main_room))
      end

      it "user saves with greenlight provider" do
        params = random_valid_user_params
        post :create, params: params

        u = User.find_by(name: params[:user][:name], email: params[:user][:email])

        expect(u.provider).to eql("greenlight")
      end

      it "renders #new on unsuccessful save" do
        post :create, params: invalid_params

        expect(response).to render_template(:new)
      end

      it "sends activation email if email verification is on" do
        allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)

        params = random_valid_user_params
        expect { post :create, params: params }.to change { ActionMailer::Base.deliveries.count }.by(1)

        u = User.find_by(name: params[:user][:name], email: params[:user][:email])

        expect(u).to_not be_nil
        expect(u.name).to eql(params[:user][:name])

        expect(flash[:success]).to be_present
        expect(response).to redirect_to(root_path)
      end

      it "correctly sets the last_login field after the user is created" do
        params = random_valid_user_params
        post :create, params: params

        u = User.find_by(name: params[:user][:name], email: params[:user][:email])

        expect(u.last_login).to_not be_nil
      end

      context "email mapping" do
        before do
          @role1 = Role.create(name: "role1", priority: 2, provider: "greenlight")
          @role2 = Role.create(name: "role2", priority: 3, provider: "greenlight")
          allow_any_instance_of(Setting).to receive(:get_value).and_return("-123@test.com=role1,@testing.com=role2")
        end

        it "correctly sets users role if email mapping is set" do
          params = random_valid_user_params
          params[:user][:email] = "test-123@test.com"

          post :create, params: params

          u = User.find_by(name: params[:user][:name], email: params[:user][:email])

          expect(u.role).to eq(@role1)
        end

        it "correctly sets users role if email mapping is set (second test)" do
          params = random_valid_user_params
          params[:user][:email] = "test@testing.com"

          post :create, params: params

          u = User.find_by(name: params[:user][:name], email: params[:user][:email])

          expect(u.role).to eq(@role2)
        end

        it "defaults to user if no mapping matches" do
          params = random_valid_user_params
          params[:user][:email] = "test@testing1.com"

          post :create, params: params

          u = User.find_by(name: params[:user][:name], email: params[:user][:email])

          expect(u.role).to eq(Role.find_by(name: "user", provider: "greenlight"))
        end
      end
    end

    context "disallow greenlight accounts" do
      before { allow(Rails.configuration).to receive(:allow_user_signup).and_return(false) }

      it "redirect to root on attempted create" do
        params = random_valid_user_params
        post :create, params: params

        u = User.find_by(name: params[:user][:name], email: params[:user][:email])

        expect(u).to be_nil
      end
    end

    context "allow email verification" do
      before do
        allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)
      end

      it "should raise if there there is a delivery failure" do
        params = random_valid_user_params

        expect do
          post :create, params: params
          raise :anyerror
        end.to raise_error { :anyerror }
      end

      context "enable invite registration" do
        before do
          allow_any_instance_of(Registrar).to receive(:invite_registration).and_return(true)
          allow(Rails.configuration).to receive(:allow_user_signup).and_return(true)
          @user = create(:user, provider: "greenlight")
          @admin = create(:user, provider: "greenlight", email: "test@example.com")
          @admin.set_role :admin
        end

        it "should notify admins that user signed up" do
          params = random_valid_user_params
          invite = Invitation.create(email: params[:user][:email], provider: "greenlight")
          @request.session[:invite_token] = invite.invite_token

          expect { post :create, params: params }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "allows the user to signup if they are invited" do
          allow(Rails.configuration).to receive(:enable_email_verification).and_return(false)
          params = random_valid_user_params
          invite = Invitation.create(email: params[:user][:name], provider: "greenlight")
          @request.session[:invite_token] = invite.invite_token

          post :create, params: params

          u = User.find_by(name: params[:user][:name], email: params[:user][:email])
          expect(response).to redirect_to(u.main_room)
        end

        it "verifies the user if they sign up with the email they receieved the invite with" do
          allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)

          params = random_valid_user_params
          invite = Invitation.create(email: params[:user][:email], provider: "greenlight")
          @request.session[:invite_token] = invite.invite_token

          post :create, params: params

          u = User.find_by(name: params[:user][:name], email: params[:user][:email])
          expect(response).to redirect_to(u.main_room)
        end

        it "asks the user to verify if they signup with a different email" do
          allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)

          params = random_valid_user_params
          invite = Invitation.create(email: Faker::Internet.email, provider: "greenlight")
          @request.session[:invite_token] = invite.invite_token

          post :create, params: params

          expect(User.exists?(name: params[:user][:name], email: params[:user][:email])).to eq(true)
          expect(flash[:success]).to be_present
          expect(response).to redirect_to(root_path)
        end
      end

      context "enable approval registration" do
        before do
          allow_any_instance_of(Registrar).to receive(:approval_registration).and_return(true)
          allow(Rails.configuration).to receive(:allow_user_signup).and_return(true)
          @user = create(:user, provider: "greenlight")
          @admin = create(:user, provider: "greenlight", email: "test@example.com")
          @admin.set_role :admin
        end

        it "allows any user to sign up" do
          allow(Rails.configuration).to receive(:enable_email_verification).and_return(false)

          params = random_valid_user_params

          post :create, params: params

          expect(User.exists?(name: params[:user][:name], email: params[:user][:email])).to eq(true)
          expect(flash[:success]).to be_present
          expect(response).to redirect_to(root_path)
        end

        it "sets the user to pending on sign up" do
          allow(Rails.configuration).to receive(:enable_email_verification).and_return(false)

          params = random_valid_user_params

          post :create, params: params

          u = User.find_by(name: params[:user][:name], email: params[:user][:email])

          expect(u.has_role?(:pending)).to eq(true)
        end

        it "notifies admins that a user signed up" do
          allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)

          params = random_valid_user_params

          expect { post :create, params: params }.to change { ActionMailer::Base.deliveries.count }.by(2)
        end
      end
    end

    it "redirects to main room if already authenticated" do
      user = create(:user)
      @request.session[:user_id] = user.id

      post :create, params: random_valid_user_params
      expect(response).to redirect_to(room_path(user.main_room))
    end
  end

  describe "POST #update" do
    before do
      @user = create(:user, accepted_terms: false)
      @request.session[:user_id] = @user.id
      allow(Rails.configuration).to receive(:terms).and_return "This is a dummy text!"
      allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)
    end
    it "properly updates usser attributes" do
      expect(@user.greenlight_account?).to be
      params = random_valid_user_params
      post :update, params: params.merge!(user_uid: @user)

      # Changing email should deactivate the greenlight account.
      expect(@user.activated?).not_to be unless @user.email == @user.reload.email
      expect(@user.name).to eql(params[:user][:name])
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(edit_user_path(@user))
    end

    it "properly updates user attributes" do
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(false)
      params = random_valid_user_params
      post :update, params: params.merge!(user_uid: @user)
      @user.reload

      expect(@user.name).not_to eql(params[:user][:name])
      expect(@user.email).not_to eql(params[:user][:email])
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(edit_user_path(@user))
    end

    it "allows admins to update a non local accounts name/email" do
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(false)
      admin = create(:user)
      admin.set_role :admin
      @request.session[:user_id] = admin.id

      params = random_valid_user_params
      post :update, params: params.merge!(user_uid: @user)
      @user.reload

      expect(@user.name).to eql(params[:user][:name])
      expect(@user.email).to eql(params[:user][:email])
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(admins_path)
    end

    it "renders #edit on unsuccessful save" do
      post :update, params: invalid_params.merge!(user_uid: @user)
      expect(response).to render_template(:edit)
    end

    context 'Roles updates' do
      it "should fail to update roles if users tries to add a role with a higher priority than their own" do
        user_role = @user.role

        user_role.update_permission("can_manage_users", "true")

        user_role.save!

        tmp_role = Role.create(name: "test", priority: -4, provider: "greenlight")

        params = random_valid_user_params
        post :update, params: params.merge!(user_uid: @user, user: { role_id: tmp_role.id.to_s })

        expect(flash[:alert]).to eq(I18n.t("administrator.roles.invalid_assignment"))
        expect(response).to render_template(:edit)
      end

      it "should successfuly add roles to the user" do
        admin = create(:user)
        admin.set_role :admin
        @request.session[:user_id] = admin.id

        tmp_role1 = Role.create(name: "test1", priority: 2, provider: "greenlight")
        tmp_role1.update_permission("send_promoted_email", "true")

        params = random_valid_user_params
        params.merge!(user_uid: @user, user: { role_id: tmp_role1.id.to_s })

        expect { post :update, params: params }.to change { ActionMailer::Base.deliveries.count }.by(1)

        @user.reload
        expect(@user.role.name).to eq("test1")
        expect(response).to redirect_to(admins_path)
      end

      it "creates the home room for a user if needed" do
        old_role = Role.create(name: "test1", priority: 2, provider: "greenlight")
        old_role.update_permission("can_create_rooms", "false")

        new_role = Role.create(name: "test2", priority: 3, provider: "greenlight")
        new_role.update_permission("can_create_rooms", "true")

        @user = create(:user, role: old_role)
        admin = create(:user)

        admin.set_role :admin

        @request.session[:user_id] = admin.id

        params = random_valid_user_params
        params.merge!(user_uid: @user, user: { role_id: new_role.id.to_s })

        expect(@user.role.name).to eq("test1")
        expect(@user.main_room).to be_nil

        post :update, params: params

        @user.reload
        expect(@user.role.name).to eq("test2")
        expect(@user.main_room).not_to be_nil
        expect(response).to redirect_to(admins_path)
      end
    end
  end

  describe "POST #update_password" do
    def params(mode = 0)
      {
        user: {
          old_password: mode == 0 ? @user.password : "incorrect_password",
          password: @password,
          password_confirmation: mode == 2 ? "#{@password}_random_string" : @password,
        }
      }
    end
    context "with 'terms and conditions' exist and without acceptance." do
      before do
        @user = create(:user, accepted_terms: false)
        @request.session[:user_id] = @user.id
        allow(Rails.configuration).to receive(:terms).and_return "This is a dummy text!"
        @password = "#{Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)}1aB"
      end
      it "properly updates users password" do
        post :update_password, params: params.merge!(user_uid: @user)
        @user.reload

        expect(@user.authenticate(@password)).not_to be false
        expect(@user.errors).to be_empty
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(change_password_path(@user))
      end
      it "doesn't update the users password if initial password is incorrect" do
        post :update_password, params: params(1).merge!(user_uid: @user)
        @user.reload
        expect(@user.authenticate(@password)).to be false
        expect(response).to render_template(:change_password)
      end
      it "doesn't update the users password if new passwords don't match" do
        post :update_password, params: params(2).merge!(user_uid: @user)
        @user.reload
        expect(@user.authenticate(@password)).to be false
        expect(response).to render_template(:change_password)
=======
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_with_manage_users_permission) { create(:user, :with_manage_users_permission) }
  let(:fake_setting_getter) { instance_double(SettingGetter) }

  before do
    request.headers['ACCEPT'] = 'application/json'
  end

  describe '#create' do
    let(:user_params) do
      {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: 'Password123+',
          language: 'language'
        }
      }
    end

    before do
      create(:role, name: 'User') # Needed for admin#create
      clear_enqueued_jobs
      allow(SettingGetter).to receive(:new).and_call_original
      allow(SettingGetter).to receive(:new).with(setting_name: 'DefaultRole', provider: 'greenlight').and_return(fake_setting_getter)
      allow(fake_setting_getter).to receive(:call).and_return('User')

      reg_method = instance_double(SettingGetter) # TODO: - ahmad: Completely refactor how setting getter can be mocked
      allow(SettingGetter).to receive(:new).with(setting_name: 'RegistrationMethod', provider: 'greenlight').and_return(reg_method)
      allow(reg_method).to receive(:call).and_return('open')
    end

    context 'valid user params' do
      it 'creates a user account for valid params' do
        expect { post :create, params: user_params }.to change(User, :count).from(0).to(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['errors']).to be_nil
      end

      it 'assigns the User role to the user' do
        post :create, params: user_params
        expect(User.find_by(email: user_params[:user][:email]).role.name).to eq('User')
      end

      context 'User language' do
        it 'Persists the user language in the user record' do
          post :create, params: user_params
          expect(User.find_by(email: user_params[:user][:email]).language).to eq('language')
        end

        it 'defaults user language to default_locale if the language isn\'t specified' do
          allow(I18n).to receive(:default_locale).and_return(:default_language)
          user_params[:user][:language] = nil
          post :create, params: user_params
          expect(User.find_by(email: user_params[:user][:email]).language).to eq('default_language')
        end
      end

      context 'activation' do
        it 'generates an activation token for the user' do
          freeze_time

          post :create, params: user_params
          user = User.find_by email: user_params[:user][:email]
          expect(user.verification_digest).to be_present
          expect(user.verification_sent_at).to eq(Time.current)
          expect(user).not_to be_verified
        end

        it 'sends activation email to and signs in the created user' do
          session[:session_token] = nil
          expect { post :create, params: user_params }.to change(User, :count).by(1)
          expect(ActionMailer::MailDeliveryJob).to have_been_enqueued.at(:no_wait).exactly(:once).with('UserMailer', 'activate_account_email',
                                                                                                       'deliver_now', Hash)
          expect(response).to have_http_status(:created)
          expect(session[:session_token]).to be_present
          expect(session[:session_token]).not_to eql(user.session_token)
        end
      end

      context 'Admin creation' do
        it 'sends activation email to but does NOT signin the created user' do
          sign_in_user(user)

          expect { post :create, params: user_params }.to change(User, :count).by(1)
          expect(ActionMailer::MailDeliveryJob).to have_been_enqueued.at(:no_wait).exactly(:once).with('UserMailer', 'activate_account_email',
                                                                                                       'deliver_now', Hash)
          expect(response).to have_http_status(:created)
          expect(session[:session_token]).to eql(user.session_token)
        end
      end
    end

    context 'invalid user params' do
      it 'fails for invalid values' do
        invalid_user_params = {
          user: { name: '', email: 'invalid', password: 'something' }
        }
        expect { post :create, params: invalid_user_params }.not_to change(User, :count)

        expect(ActionMailer::MailDeliveryJob).not_to have_been_enqueued
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end

    context 'Role mapping' do
      before do
        role_map = instance_double(SettingGetter)
        allow(SettingGetter).to receive(:new).with(setting_name: 'RoleMapping', provider: 'greenlight').and_return(role_map)
        allow(role_map).to receive(:call).and_return('Decepticons=@decepticons.cybertron,Autobots=autobots.cybertron')
      end

      it 'Creates a User and assign a role if a rule matches their email' do
        autobots = create(:role, name: 'Autobots')
        user_params = {
          name: 'Optimus Prime',
          email: 'optimus@autobots.cybertron',
          password: 'Autobots1!',
          language: 'teletraan'
        }

        expect { post :create, params: { user: user_params } }.to change(User, :count).from(0).to(1)

        expect(User.find_by(email: user_params[:email]).role).to eq(autobots)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['errors']).to be_nil
      end
    end

    context 'Registration Method' do
      context 'invite' do
        before do
          reg_method = instance_double(SettingGetter)
          allow(SettingGetter).to receive(:new).with(setting_name: 'RegistrationMethod', provider: 'greenlight').and_return(reg_method)
          allow(reg_method).to receive(:call).and_return('invite')
        end

        it 'creates a user account if they have a valid invitation' do
          invite = create(:invitation, email: user_params[:user][:email])
          user_params[:user][:invite_token] = invite.token

          expect { post :create, params: user_params }.to change(User, :count).from(0).to(1)

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['errors']).to be_nil
        end

        it 'deletes an invitation after using it' do
          invite = create(:invitation, email: user_params[:user][:email])
          user_params[:user][:invite_token] = invite.token

          expect { post :create, params: user_params }.to change(Invitation, :count).by(-1)
        end

        it 'returns an InviteInvalid error if no invite is passed' do
          expect { post :create, params: user_params }.not_to change(User, :count)

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['errors']).to eq('InviteInvalid')
        end

        it 'returns an InviteInvalid error if the token is wrong' do
          user_params[:user][:invite_token] = 'fake-token'
          expect { post :create, params: user_params }.not_to change(User, :count)

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['errors']).to eq('InviteInvalid')
        end
      end

      context 'approval' do
        before do
          reg_method = instance_double(SettingGetter)
          allow(SettingGetter).to receive(:new).with(setting_name: 'RegistrationMethod', provider: 'greenlight').and_return(reg_method)
          allow(reg_method).to receive(:call).and_return('approval')
        end

        it 'sets a user to pending when registering' do
          expect { post :create, params: user_params }.to change(User, :count).from(0).to(1)

          expect(User.find_by(email: user_params[:user][:email]).status).to eq('pending')
        end
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
      end
    end
  end

<<<<<<< HEAD
  describe "DELETE #user" do
    before do
      allow(Rails.configuration).to receive(:allow_user_signup).and_return(true)
      Role.create_default_roles("provider1")
    end

    it "permanently deletes user" do
      user = create(:user)
      @request.session[:user_id] = user.id

      delete :destroy, params: { user_uid: user.uid }

      expect(User.include_deleted.find_by(uid: user.uid)).to be_nil
      expect(response).to redirect_to(root_path)
    end

    it "allows admins to tombstone users" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:set_user_domain).and_return("provider1")
      controller.instance_variable_set(:@user_domain, "provider1")

      user = create(:user, provider: "provider1")
      admin = create(:user, provider: "provider1")
      admin.set_role :admin
      @request.session[:user_id] = admin.id

      delete :destroy, params: { user_uid: user.uid }

      expect(User.deleted.find_by(uid: user.uid)).to be_present
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(admins_path)
    end

    it "allows admins to permanently delete users" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)
      allow_any_instance_of(BbbServer).to receive(:delete_all_recordings).and_return("")
      allow_any_instance_of(ApplicationController).to receive(:set_user_domain).and_return("provider1")
      controller.instance_variable_set(:@user_domain, "provider1")

      user = create(:user, provider: "provider1")
      admin = create(:user, provider: "provider1")
      admin.set_role :admin
      @request.session[:user_id] = admin.id

      delete :destroy, params: { user_uid: user.uid, permanent: "true" }

      expect(User.include_deleted.find_by(uid: user.uid)).to be_nil
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(admins_path)
    end

    it "permanently deletes the users rooms if the user is permanently deleted" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)
      allow_any_instance_of(BbbServer).to receive(:delete_all_recordings).and_return("")
      allow_any_instance_of(ApplicationController).to receive(:set_user_domain).and_return("provider1")
      controller.instance_variable_set(:@user_domain, "provider1")

      user = create(:user, provider: "provider1")
      admin = create(:user, provider: "provider1")
      admin.set_role :admin
      @request.session[:user_id] = admin.id
      uid = user.main_room.uid

      expect(Room.find_by(uid: uid)).to be_present

      delete :destroy, params: { user_uid: user.uid, permanent: "true" }

      expect(Room.include_deleted.find_by(uid: uid)).to be_nil
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(admins_path)
    end

    it "doesn't allow admins of other providers to delete users" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:set_user_domain).and_return("provider2")
      controller.instance_variable_set(:@user_domain, "provider2")

      user = create(:user, provider: "provider1")
      admin = create(:user, provider: "provider2")
      admin.set_role :admin
      @request.session[:user_id] = admin.id

      delete :destroy, params: { user_uid: user.uid }

      expect(flash[:alert]).to be_present
      expect(response).to redirect_to(admins_path)
    end

    it "allows user deletion with shared access to rooms" do
      owner = create(:user)
      guest = create(:user)
      room  = create(:room, owner: owner)
      SharedAccess.create(room_id: room.id, user_id: guest.id)

      @request.session[:user_id] = guest.id
      delete :destroy, params: { user_uid: guest.uid }

      expect(User.include_deleted.find_by(uid: guest.uid)).to be_nil
      expect(SharedAccess.exists?(room_id: room.id, user_id: guest.id)).to be false
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET | POST #terms" do
    before { allow(Rails.configuration).to receive(:allow_user_signup).and_return(true) }
    before { allow(Rails.configuration).to receive(:terms).and_return(false) }

    it "Redirects to 404 if terms is disabled" do
      post :terms, params: { accept: "false" }

      expect(response).to redirect_to('/404')
    end
  end

  describe "GET #recordings" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
    end

    it "redirects to root if the incorrect user tries to access the page" do
      get :recordings, params: { current_user: @user2, user_uid: @user1.uid }

      expect(response).to redirect_to(root_path)
=======
  describe '#show' do
    before do
      sign_in_user(user)
    end

    it 'returns a user if id is valid' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['id']).to eq(user.id)
    end
  end

  describe '#update' do
    before do
      sign_in_user(user)
    end

    it 'updates the users attributes' do
      updated_params = {
        name: 'New Name',
        email: 'newemail@gmail.com',
        language: 'gl',
        role_id: create(:role, name: 'New Role').id
      }
      patch :update, params: { id: user.id, user: updated_params }
      expect(response).to have_http_status(:ok)

      user.reload

      expect(user.name).to eq(updated_params[:name])
      expect(user.email).to eq(updated_params[:email])
      expect(user.language).to eq(updated_params[:language])
      expect(user.role_id).to eq(updated_params[:role_id])
    end

    it 'returns an error if the user update fails' do
      patch :update, params: { id: user.id, user: { name: nil } }
      expect(response).to have_http_status(:bad_request)
      expect(user.reload.name).to eq(user.name)
    end

    it 'updates the avatar' do
      patch :update, params: { id: user.id, user: { avatar: fixture_file_upload(file_fixture('default-avatar.png'), 'image/png') } }
      expect(user.reload.avatar).to be_attached
    end

    it 'deletes the avatar' do
      user.avatar.attach(io: fixture_file_upload('default-avatar.png'), filename: 'default-avatar.png', content_type: 'image/png')
      expect(user.reload.avatar).to be_attached
      delete :purge_avatar, params: { id: user.id }
      expect(user.reload.avatar).not_to be_attached
    end
  end

  describe '#destroy' do
    before do
      sign_in_user(user)
    end

    it 'deletes the current_user account' do
      expect(response).to have_http_status(:ok)
      expect { delete :destroy, params: { id: user.id } }.to change(User, :count).by(-1)
    end

    it 'returns status code forbidden if the user tries to delete another user' do
      new_user = create(:user)
      expect { delete :destroy, params: { id: new_user.id } }.not_to change(User, :count)
      expect(response).to have_http_status(:forbidden)
    end

    context 'user with ManageUsers permission' do
      before do
        sign_in_user(user_with_manage_users_permission)
      end

      it 'deletes a user' do
        new_user = create(:user)
        expect { delete :destroy, params: { id: new_user.id } }.to change(User, :count).by(-1)
      end

      it 'returns status code not found if the user does not exists' do
        expect { delete :destroy, params: { id: 'invalid-id' } }.not_to change(User, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'change_password' do
    before do
      sign_in_user(user)
    end

    let!(:user) { create(:user, password: 'Test12345678+') }

    it 'changes current_user password if the params are valid' do
      valid_params = { old_password: 'Test12345678+', new_password: 'Glv3IsAwesome!' }
      post :change_password, params: { user: valid_params }

      expect(response).to have_http_status(:ok)
      expect(user.reload.authenticate(valid_params[:new_password])).to be_truthy
    end

    it 'returns :bad_request response for invalid old_password' do
      invalid_params = { old_password: 'NotMine!', new_password: 'ThisIsMine!' }
      post :change_password, params: { user: invalid_params }

      expect(response).to have_http_status(:bad_request)
      expect(user.reload.authenticate(invalid_params[:new_password])).to be_falsy
    end

    it 'returns :bad_request response for missing params' do
      invalid_params = { old_password: '', new_password: '' }
      post :change_password, params: { user: invalid_params }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns :unauthorized response for unauthenticated requests' do
      session[:session_token] = nil
      post :change_password, params: {}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns :forbidden response for external accounts' do
      external_user = create(:user, external_id: 'EXTERAL_ID')
      sign_in_user(external_user)
      post :change_password, params: {}
      expect(response).to have_http_status(:forbidden)
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
    end
  end
end
