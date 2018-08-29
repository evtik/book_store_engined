class AdminUserForm
  include Capybara::DSL

  def fill_in_with(params)
    fill_in('user_email', with: params[:email])
    fill_in('user_password', with: params[:password])
    fill_in('user_password_confirmation', with: params[:password_confirmation])
    check('Admin') if params[:admin]
    self
  end

  def submit(action)
    click_on("#{action} User")
  end
end
