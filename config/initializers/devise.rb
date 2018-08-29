Devise.setup do |config|
  config.mailer_sender = 'admin@bookstore.com'

  require 'devise/orm/active_record'

  # config.secret_key = ENV['DEVISE_SECRET_KEY'] if Rails.env.production?

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A(([\p{L}0-9]+_+)|([\p{L}0-9]+\-+)|([\p{L}0-9]+\.+)|([\p{L}0-9]+\++))*[\p{L}0-9]+@(([\p{L}0-9]+\-+)|([\p{L}0-9]+\.))*[\p{L}0-9]{1,63}\.[\p{L}]{2,6}\z/i

  config.reset_password_within = 6.hours

  config.sign_out_via = :get

  config.omniauth :facebook, Figaro.env.facebook_app_id,
                  Figaro.env.facebook_app_secret,
                  info_fields: 'email,first_name,last_name,hometown'
end
