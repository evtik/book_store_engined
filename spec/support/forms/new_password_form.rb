class NewPasswordForm
  include AbstractController::Translation
  include Capybara::DSL

  def fill_in_with(params)
    fill_in('user[current_password]', with: params[:current_password])
    fill_in('user[password]', with: params[:password])
    fill_in('user[password_confirmation]', with: params[:password_confirmation])
    self
  end

  def submit
    click_on(t('settings.change_password.change'))
  end
end
