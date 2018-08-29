require_relative '../../../support/forms/admin_user_form'

feature 'Admin new User page' do
  include_examples 'not authorized', :new_admin_user_path

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    given(:form) { AdminUserForm.new }

    background do
      visit admin_users_path
      click_on(t('active_admin.new_model',
                 model: t('activerecord.models.user.one')))
    end

    scenario 'with valid user data shows success message' do
      form.fill_in_with(attributes_for(:user)).submit('Create')
      expect(page).to have_content('User was successfully created')
    end

    scenario 'with invalid user data shows errors' do
      form.fill_in_with(attributes_for(:user, email: '1234'))
          .submit('Create')
      expect(page).to have_content(t('errors.messages.invalid'))
    end
  end
end
