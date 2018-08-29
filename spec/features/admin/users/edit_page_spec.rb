require_relative '../../../support/forms/admin_user_form'

feature 'Admin edit User page' do
  include_examples 'not authorized', :edit_admin_user_path, 1

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    given(:form) { AdminUserForm.new }

    background do
      create(:user)
      visit admin_users_path
      first('a', text: t('active_admin.edit')).click
    end

    scenario 'with valid user data shows success message' do
      form.fill_in_with(attributes_for(:user, email: 'x@i.ua')).submit('Update')
      expect(page).to have_content('User was successfully updated')
    end

    scenario 'with invalid user data shows errors' do
      form.fill_in_with(attributes_for(:user, email: ''))
          .submit('Update')
      expect(page).to have_content(t('errors.messages.blank'))
    end
  end
end
