# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
<<<<<<< HEAD
  def initialize(_params)
    super
    @settings = Setting.find_by(provider: "greenlight")
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    url = "http://example.com/password_resets/#{user.reset_token}/edit?email=#{user.email}"
    UserMailer.password_reset(user, url, @logo, @color)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/verify_email
  def verify_email
    user = User.first
    url = "http://example.com/u/verify/confirm/#{user.uid}"
    UserMailer.verify_email(user, url, @logo, @color)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/invite_email
  def invite_email
    UserMailer.invite_email("Example User", "from@example.com", DateTime.now, "http://example.com/signup", @settings)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/approve_user
  def approve_user
    user = User.first
    UserMailer.approve_user(user, "http://example.com/", @logo, @color)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/approval_user_signup
  def approval_user_signup
    user = User.first
    UserMailer.approval_user_signup(user, "http://example.com/", @logo, @color, "test@example.com")
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/invite_user_signup
  def invite_user_signup
    user = User.first
    UserMailer.invite_user_signup(user, "http://example.com/", @logo, @color, "test@example.com")
  end

  # http://localhost:3000/rails/mailers/user_mailer/user_promoted
  def user_promoted
    user = User.first
    role = Role.first
    url = "http://example.com"
    logo_image = "https://raw.githubusercontent.com/bigbluebutton/greenlight/master/app/assets/images/logo_with_text.png"
    user_color = "#467fcf"
    UserMailer.user_promoted(user, role, url, logo_image, user_color)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/user_demoted
  def user_demoted
    user = User.first
    role = Role.first
    url = "http://example.com"
    logo_image = "https://raw.githubusercontent.com/bigbluebutton/greenlight/master/app/assets/images/logo_with_text.png"
    user_color = "#467fcf"
    UserMailer.user_demoted(user, role, url, logo_image, user_color)
=======
  def test_email
    UserMailer.with(to: 'user@users.com', subject: 'Test Subject').test_email
  end

  def reset_password_email
    fake_user = Struct.new(:name, :email)

    UserMailer.with(user: fake_user.new('user', 'user@users.com'), expires_in: 1.hour.from_now, reset_url: 'https://example.com/reset').reset_password_email
  end

  def activate_account_email
    fake_user = Struct.new(:name, :email)

    UserMailer.with(user: fake_user.new('user', 'user@users.com'), expires_in: 1.hour.from_now, activation_url: 'https://example.com/activate').activate_account_email
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
  end
end
