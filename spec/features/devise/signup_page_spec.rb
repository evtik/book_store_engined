require_relative '../../support/forms/signup_form'

feature 'Signup page' do
  given(:signup_form) { SignupForm.new }
  given(:valid_data) do
    {
      email: 'valid@example.com',
      password: '11111111',
      password_confirmation: '11111111'
    }
  end

  scenario 'with valid data registers new user' do
    create_list(:book_with_authors_and_materials, 4)
    signup_form.visit_page.fill_in_with(valid_data).submit
    expect(page).to have_content(t('devise.registrations.signed_up'))
  end

  scenario "with email taken by another user shows 'email taken' error" do
    create(:user, email: 'valid@example.com')
    signup_form.visit_page.fill_in_with(valid_data).submit
    expect(page).to have_content(t('errors.messages.taken'))
  end

  scenario "with empty email shows 'email empty' error" do
    signup_form.visit_page.fill_in_with(
      password: '11111111',
      password_confirmation: '11111111'
    ).submit
    expect(page).to have_content(
      t('errors.messages.blank', attribute: 'Email')
    )
  end

  scenario "with empty password shows 'password empty' error" do
    signup_form.visit_page.fill_in_with(email: 'user1@example.com').submit
    expect(page).to have_content(
      t('errors.messages.blank', attribute: 'Password')
    )
  end

  scenario 'with too short password shows appropriate error' do
    signup_form.visit_page.fill_in_with(
      email: 'user1@example.com',
      password: '111',
      password_confirmation: '111'
    ).submit
    expect(page).to have_content(
      t('errors.messages.too_short.other', count: 6)
    )
  end

  scenario 'with password not matching password confirmation shows error' do
    signup_form.visit_page.fill_in_with(
      email: 'user1@example.com',
      password: '11111111',
      password_confirmation: '4444'
    ).submit
    expect(page).to have_content(
      t('errors.messages.confirmation', attribute: 'Password')
    )
  end
end
