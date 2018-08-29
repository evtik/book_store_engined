class LoginForm
  include Rails.application.routes.url_helpers
  include AbstractController::Translation
  include Capybara::DSL

  def visit_page
    visit login_path
    self
  end

  def fill_in_with(params)
    fill_in('user[email]', with: params[:email])
    fill_in('user[password]', with: params[:password])
    self
  end

  def submit
    click_button(t('devise.sessions.new.sign_in'))
  end
end
