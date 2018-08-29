class AdminAuthorForm
  include Capybara::DSL

  def fill_in_with(params)
    fill_in('author_first_name', with: params[:first_name])
    fill_in('author_last_name', with: params[:last_name])
    fill_in('author_description', with: params[:description])
    self
  end

  def submit(action)
    click_on("#{action} Author")
  end
end
