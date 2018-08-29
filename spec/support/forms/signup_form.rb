class SignupForm
  include Rails.application.routes.url_helpers
  include AbstractController::Translation
  include Capybara::DSL

  def visit_page
    visit new_user_registration_path
    self
  end

  def fill_in_with(params)
    fill_in('user[email]', with: params[:email])
    fill_in('user[password]', with: params[:password])
    fill_in('user[password_confirmation]', with: params[:password_confirmation])
    self
  end

  def submit
    click_button(t('devise.registrations.new.sign_up'))
  end
end
