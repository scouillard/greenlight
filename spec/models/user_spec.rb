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
require 'bigbluebutton_api'

describe User, type: :model do
  before do
    @user = create(:user)
    @secure_pwd = "#{Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)}1aB"
    @insecure_pwd = Faker::Internet.password(min_length: 8, mix_case: true).to_s
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(256) }
    it { should_not allow_value("https://www.bigbluebutton.org").for(:name) }

    it { should validate_presence_of(:provider) }

    it { should validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    it { should validate_length_of(:email).is_at_most(256) }
    it { should allow_value("valid@email.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }
    it { should allow_value(true).for(:accepted_terms) }
    it {
      expect(@user.greenlight_account?).to be
      allow(Rails.configuration).to receive(:terms).and_return("something")
      should_not allow_value(false).for(:accepted_terms)
      allow(Rails.configuration).to receive(:terms).and_return(false)
      should allow_value(false).for(:accepted_terms)
    }

    it { should allow_value("valid.jpg").for(:image) }
    it { should allow_value("valid.png").for(:image) }
    it { should allow_value("random_file.txt").for(:image) }
    it { should allow_value("", nil).for(:image) }

    it "should convert email to downcase on save" do
      user = create(:user, email: "DOWNCASE@DOWNCASE.COM")
      expect(user.email).to eq("downcase@downcase.com")
    end
    context 'is greenlight account' do
      before { allow(subject).to receive(:greenlight_account?).and_return(true) }
      it { should validate_length_of(:password).is_at_least(8) }
      it { should validate_confirmation_of(:password) }
      it "should validate password complexity" do
        @user.update(password: @secure_pwd, password_confirmation: @secure_pwd)
        expect(@user).to be_valid
        @user.update(password: @insecure_pwd, password_confirmation: @insecure_pwd)
        expect(@user).to be_invalid
      end
    end

    context 'is not greenlight account' do
      before { allow(subject).to receive(:greenlight_account?).and_return(false) }
      it { should_not validate_presence_of(:password) }
    end
  end

  context 'associations' do
    it { should belong_to(:main_room).class_name("Room").with_foreign_key("room_id") }
    it { should have_many(:rooms) }
  end

  context '#initialize_main_room' do
    it 'creates random uid and main_room' do
      expect(@user.uid).to_not be_nil
      expect(@user.main_room).to be_a(Room)
    end
  end

  context "#to_param" do
    it "uses uid as the default identifier for routes" do
      expect(@user.to_param).to eq(@user.uid)
    end
  end

  unless Rails.configuration.omniauth_bn_launcher
    context '#from_omniauth' do
      let(:auth) do
        {
          "uid" => "123456789",
          "provider" => "twitter",
          "info" => {
            "name" => "Test Name",
            "nickname" => "username",
            "email" => "test@example.com",
            "image" => "example.png",
          },
        }
      end

      it "should create user from omniauth" do
        expect do
          user = User.from_omniauth(auth)

          expect(user.name).to eq("Test Name")
          expect(user.email).to eq("test@example.com")
          expect(user.image).to eq("example.png")
          expect(user.provider).to eq("twitter")
          expect(user.social_uid).to eq("123456789")
        end.to change { User.count }.by(1)
=======
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to belong_to(:role) }

    it { is_expected.to have_many(:rooms).dependent(:destroy) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:provider) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:reset_digest) }
    it { is_expected.to validate_uniqueness_of(:verification_digest) }
    it { is_expected.to validate_presence_of(:password).on(:create) }

    it { is_expected.to validate_presence_of(:session_token) }
    it { is_expected.to validate_presence_of(:session_expiry) }
    it { is_expected.to validate_presence_of(:language) }

    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(255) }
    it { is_expected.to validate_length_of(:email).is_at_least(5).is_at_most(255) }

    context 'password complexity' do
      it 'passes if there is atleast 1 capital, 1 lowercase, 1 number, 1 symbol' do
        user = build(:user, password: 'Password1!')
        expect(user).to be_valid
      end

      it 'fails if there is no capitals' do
        user = build(:user, password: 'password1!')
        expect(user).to be_invalid
      end

      it 'fails if there is no symbols' do
        user = build(:user, password: 'Password1')
        expect(user).to be_invalid
      end

      it 'fails if there is no lowercase' do
        user = build(:user, password: 'PASSWORD1!')
        expect(user).to be_invalid
      end

      it 'fails if there is no numbers' do
        user = build(:user, password: 'Password!')
        expect(user).to be_invalid
      end

      context 'update' do
        context 'password changed' do
          it 'fails if new password is invalid' do
            user = create(:user)

            user.update(name: 'TOUCHED', password: 'INVALID')
            expect(user).to be_invalid
            expect(user.reload.name).not_to eq('TOUCHED')
            expect(user.authenticate('INVALID')).not_to be_truthy
          end

          it 'passes if new password is valid' do
            user = create(:user)

            user.update(name: 'TOUCHED', password: 'Password1!')
            expect(user).to be_valid
            expect(user.reload.name).to eq('TOUCHED')
            expect(user.authenticate('Password1!')).to be_truthy
          end
        end

        context 'password unchanged' do
          it 'does not validate password' do
            user = create(:user)

            user.update(name: 'TOUCHED')
            expect(user).to be_valid
            expect(user.reload.name).to eq('TOUCHED')
          end
        end
      end
    end

    context 'email format' do
      it 'accepts valid email format' do
        user = build(:user, email: 'user-1.dep-1@users.org-1.tld')
        expect(user).to be_valid
      end

      it 'refuses invalid email formats' do
        user = build(:user, email: 'INVALID')
        expect(user).to be_invalid
        expect(user.errors.attribute_names).to match_array([:email])
      end
    end

    context 'avatar validations' do
      it 'fails if the avatar is not an image' do
        user = build(:user, avatar: fixture_file_upload(file_fixture('default-pdf.pdf'), 'pdf'))
        expect(user).to be_invalid
      end

      it 'fails if the image is too large' do
        user = build(:user, avatar: fixture_file_upload(file_fixture('large-avatar.jpg'), 'jpg'))
        expect(user).to be_invalid
      end
    end

    describe 'before_validations' do
      describe '#set_session_token' do
        it 'sets a rooms session_token and session_expiry before creating' do
          user = create(:user, session_token: nil, session_expiry: nil)
          expect(user.session_token).to be_present
          expect(user.session_expiry).to be_present
        end
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
      end
    end
  end

<<<<<<< HEAD
  context '#name_chunk' do
    it 'properly finds the first three characters of the users name' do
      user = create(:user, name: "Example User")
      expect(user.name_chunk).to eq("exa")
    end
  end

  context '#ordered_rooms' do
    it 'correctly orders the users rooms' do
      user = create(:user)
      room1 = create(:room, owner: user)
      room2 = create(:room, owner: user)
      room3 = create(:room, owner: user)
      room4 = create(:room, owner: user)

      room4.update_attributes(sessions: 1, last_session: "2020-02-24 19:52:57")
      room3.update_attributes(sessions: 1, last_session: "2020-01-25 19:52:57")
      room2.update_attributes(sessions: 1, last_session: "2019-09-05 19:52:57")
      room1.update_attributes(sessions: 1, last_session: "2015-02-24 19:52:57")

      rooms = user.ordered_rooms
      expect(rooms[0]).to eq(user.main_room)
      expect(rooms[1]).to eq(room4)
      expect(rooms[2]).to eq(room3)
      expect(rooms[3]).to eq(room2)
      expect(rooms[4]).to eq(room1)
    end
  end

  context 'password reset' do
    it 'creates token and respective reset digest' do
      user = create(:user)

      expect(user.create_reset_digest).to be_truthy
    end

    it 'correctly verifies the token' do
      user = create(:user)
      token = user.create_reset_digest
      expect(User.exists?(reset_digest: User.hash_token(token))).to be true
    end

    it 'verifies if password reset link expired' do
      user = create(:user)
      user.create_reset_digest

      expired = user.password_reset_expired?
      expect(expired).to be_in([true, false])
    end
  end

  context '#roles' do
    it "defaults the user to a user role" do
      expect(@user.has_role?(:user)).to be true
    end

    it "does not give the user an admin role" do
      expect(@user.has_role?(:admin)).to be false
    end

    it "returns true if the user is an admin of another" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)

      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.admin_of?(@user, "can_manage_users")).to be true

      @super_admin = create(:user, provider: "test")
      @super_admin.set_role :super_admin

      expect(@super_admin.admin_of?(@user, "can_manage_users")).to be true
    end

    it "returns false if the user is NOT an admin of another" do
      @admin = create(:user)

      expect(@admin.admin_of?(@user, "can_manage_users")).to be false
    end

    it "should get the highest priority role" do
      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.role.name).to eq("admin")
    end

    it "should add the role if the user doesn't already have the role" do
      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.has_role?(:admin)).to eq(true)
    end

    it "has_role? should return false if the user doesn't have the role" do
      expect(@user.has_role?(:admin)).to eq(false)
    end

    it "has_role? should return true if the user has the role" do
      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.has_role?(:admin)).to eq(true)
    end

    it "with_role should return all users with the role" do
      @admin1 = create(:user, provider: @user.provider)
      @admin2 = create(:user, provider: @user.provider)
      @admin1.set_role :admin
      @admin2.set_role :admin

      expect(User.with_role(:admin).count).to eq(2)
    end

    it "without_role should return all users without the role" do
      @admin1 = create(:user, provider: @user.provider)
      @admin2 = create(:user, provider: @user.provider)
      @admin1.set_role :admin
      @admin2.set_role :admin

      expect(User.without_role(:admin).count).to eq(1)
    end
  end

  context 'blank email' do
    it "allows a blank email if the provider is not greenlight" do
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(false)

      user = create(:user, email: "", provider: "ldap")
      expect(user.valid?).to be true
    end

    it "does not allow a blank email if the provider is greenlight" do
      expect { create(:user, email: "", provider: "greenlight") }
        .to raise_exception(ActiveRecord::RecordInvalid, "Validation failed: Email can't be blank")
    end
  end

  context "#locked_out?" do
    it "returns true if there has been more than 5 login attempts in the past 24 hours" do
      @user.update(failed_attempts: 6, last_failed_attempt: 10.hours.ago)
      expect(@user.locked_out?).to be true
    end

    it "returns false if there has been less than 6 login attempts in the past 24 hours" do
      @user.update(failed_attempts: 3, last_failed_attempt: 10.hours.ago)
      expect(@user.locked_out?).to be false
    end

    it "returns false if the last failed attempt was older than 24 hours" do
      @user.update(failed_attempts: 6, last_failed_attempt: 30.hours.ago)
      expect(@user.locked_out?).to be false
    end

    it "resets the counter if the last failed attempt was over 24 hours ago" do
      @user.update(failed_attempts: 3, last_failed_attempt: 30.hours.ago)

      expect(@user.locked_out?).to be false
      expect(@user.reload.failed_attempts).to eq(0)
    end
  end

  context 'class methods' do
    context "#secure_password?" do
      it "should return true for secure passwords" do
        expect(User.secure_password?(@secure_pwd)).to be
      end
      it "should return false for insecure passwords" do
        expect(User.secure_password?(@insecure_pwd)).not_to be
=======
  describe 'scopes' do
    context 'with_provider' do
      it 'only includes users with the specified provider' do
        create_list(:user, 5, provider: 'greenlight')
        role_with_provider_test = create(:role, provider: 'test')
        create_list(:user, 5, provider: 'test', role: role_with_provider_test)

        users = described_class.with_provider('greenlight')
        expect(users.count).to eq(5)
        expect(users.pluck(:provider).uniq).to eq(['greenlight'])
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
      end
    end
  end

<<<<<<< HEAD
  context "#without_terms_acceptance" do
    before {
      @user.update accepted_terms: false
      allow(Rails.configuration).to receive(:terms).and_return("something")
    }
    it "runs blocks with terms acceptance validation disabled" do
      expect(@user.accepted_terms).not_to be
      expect(@user.valid?).not_to be
      @user.without_terms_acceptance { expect(@user.valid?).to be }
=======
  describe '#search' do
    it 'returns the searched users' do
      searched_users = create_list(:user, 5, name: 'Jane Doe')
      create_list(:user, 5)
      expect(described_class.search('jane doe').pluck(:id)).to match_array(searched_users.pluck(:id))
    end

    it 'returns all users if input is empty' do
      create_list(:user, 10)
      expect(described_class.search('').pluck(:id)).to match_array(described_class.all.pluck(:id))
    end
  end

  context 'instance methods' do
    describe '#generate_reset_token!' do
      let!(:user) { create(:user, email: 'test@greenlight.com') }

      it 'generates/returns a token and saves its digest' do
        freeze_time
        token = 'ZekpWTPGFsuaP1WngE6LVCc69Zs7YSKoOJFLkfKu'
        allow(SecureRandom).to receive(:alphanumeric).and_return token

        expect(user.generate_reset_token!).to eq(token)
        expect(user.reload.reset_digest).to eq(described_class.generate_digest(token))
        expect(user.reset_sent_at).to eq(Time.current)
      end
    end

    describe '#generate_activation_token!' do
      let!(:user) { create(:user, email: 'test@greenlight.com') }

      it 'generates/returns a token and saves its digest' do
        freeze_time
        token = 'ZekpWTPGFsuaP1WngE6LVCc69Zs7YSKoOJFLkfKu'
        allow(SecureRandom).to receive(:alphanumeric).and_return token

        expect(user.generate_activation_token!).to eq(token)
        expect(user.reload.verification_digest).to eq(described_class.generate_digest(token))
        expect(user.verification_sent_at).to eq(Time.current)
      end
    end

    describe '#invalidate_reset_token' do
      it 'removes the user token data and returns the record' do
        user = create(:user, reset_digest: 'something', reset_sent_at: Time.current)
        expect(user.invalidate_reset_token).to be(true)
        expect(user.reload.reset_digest).to be_nil
        expect(user.reset_sent_at).to be_nil
      end
    end

    describe '#invalidate_activation_token' do
      it 'removes the user activation token data and returns the record' do
        user = create(:user, verification_digest: 'something', verification_sent_at: Time.current)

        expect(user.invalidate_activation_token).to be(true)
        expect(user.reload.verification_digest).to be_nil
        expect(user.verification_sent_at).to be_nil
      end
    end

    describe '#verify!' do
      it 'activates the user' do
        user = create(:user)
        user.verify!
        expect(user).to be_verified
      end
    end

    describe '#deverify!' do
      it 'deactivates the user' do
        user = create(:user)
        user.deverify!
        expect(user).not_to be_verified
      end
    end
  end

  context 'static methods' do
    describe '#generate_digest' do
      it 'calls Digest::SHA2#hexdigest to generate a digest' do
        expect(described_class.generate_digest('test')).to eq(Digest::SHA2.hexdigest('test'))
      end
    end

    describe '#reset_token_expired?' do
      let(:period) { User::RESET_TOKEN_VALIDITY_PERIOD }

      it 'returns FALSE when the current time does not exceed the given time within the allowed period' do
        freeze_time
        expect(described_class).not_to be_reset_token_expired(Time.current - period)
      end

      it 'returns TRUE when the current time exceed the given time within the allowed period' do
        freeze_time
        expect(described_class).to be_reset_token_expired(Time.current - (period + 1.second))
      end
    end

    describe '#activation_token_expired?' do
      let(:period) { User::ACTIVATION_TOKEN_VALIDITY_PERIOD }

      it 'returns FALSE when the current time does not exceed the given time within the allowed period' do
        freeze_time
        expect(described_class).not_to be_activation_token_expired(Time.current - period)
      end

      it 'returns TRUE when the current time exceed the given time within the allowed period' do
        freeze_time
        expect(described_class).to be_activation_token_expired(Time.current - (period + 1.second))
      end
    end

    describe '#verify_reset_token' do
      let(:period) { User::RESET_TOKEN_VALIDITY_PERIOD }
      let!(:user) do
        create(:user, reset_digest: 'token_digest', reset_sent_at: Time.zone.at(1_655_290_260))
      end

      before do
        travel_to Time.zone.at(1_655_290_260)
        allow(described_class).to receive(:generate_digest).and_return('random_stuff')
        allow(described_class).to receive(:generate_digest).with('token').and_return('token_digest')
      end

      it 'returns the user found by token digest when the token is valid' do
        travel period

        expect(described_class.verify_reset_token('token')).to eq(user)
        expect(user.reload.reset_digest).to be_present
        expect(user.reset_sent_at).to be_present
      end

      it 'does not return the user but reset its token if expired' do
        travel period + 1.second

        expect(described_class.verify_reset_token('token')).to be(false)
        expect(user.reload.reset_digest).to be_blank
        expect(user.reset_sent_at).to be_blank
      end

      it 'return FALSE for inexistent tokens' do
        travel period

        expect(described_class.verify_reset_token('SOME_BAD_TOKEN')).to be(false)
      end
    end

    describe '#verify_activation_token' do
      let(:period) { User::ACTIVATION_TOKEN_VALIDITY_PERIOD }
      let!(:user) do
        create(:user, verification_digest: 'token_digest', verification_sent_at: Time.zone.at(1_655_290_260))
      end

      before do
        travel_to Time.zone.at(1_655_290_260)
        allow(described_class).to receive(:generate_digest).and_return('random_stuff')
        allow(described_class).to receive(:generate_digest).with('token').and_return('token_digest')
      end

      it 'returns the user found by token digest when the token is valid' do
        travel period

        expect(described_class.verify_activation_token('token')).to eq(user)
        expect(user.reload.verification_digest).to be_present
        expect(user.verification_sent_at).to be_present
      end

      it 'does not return the user but reset its token if expired' do
        travel period + 1.second

        expect(described_class.verify_activation_token('token')).to be(false)
        expect(user.reload.verification_digest).to be_blank
        expect(user.verification_sent_at).to be_blank
      end

      it 'return FALSE for inexistent tokens' do
        travel period

        expect(described_class.verify_activation_token('SOME_BAD_TOKEN')).to be(false)
      end
    end
  end

  describe '#check_user_role_provider' do
    it 'returns a user if the user provider is the same as its role' do
      role = create(:role, provider: 'google')
      user = build(:user, provider: 'google', role:)
      expect(user).to be_valid
      expect(user.provider).to eq(user.role.provider)
    end

    it 'fails if the user provider is not the same as its role provider' do
      role = create(:role, provider: 'google')
      user = build(:user, provider: 'microsoft', role:)
      expect(user).to be_invalid
      expect(user.provider).not_to eq(user.role.provider)
      expect(user.errors[:user_provider]).not_to be_empty
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
    end
  end
end
