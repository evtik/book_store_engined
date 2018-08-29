class UserMailer < ApplicationMailer
  default(from: 'support@bookstore.com')

  def user_email(user)
    @user = user
    mail(to: @user.email, subject: default_i18n_subject(email: @user.email))
  end
end
