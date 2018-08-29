require_relative '../../../support/forms/admin_author_form'

feature 'Admin edit Author page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :edit_admin_author_path, 1

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    given(:form) { AdminAuthorForm.new }

    background do
      create(:author)
      visit admin_authors_path
      click_link(t('active_admin.edit'))
    end

    scenario 'with valid author data shows success message' do
      form.fill_in_with(attributes_for(:author)).submit('Update')
      expect(page).to have_content(aa_tr(:author, :update))
    end

    scenario 'with invalid author data shows errors' do
      form.fill_in_with(attributes_for(:author, first_name: '')).submit('Update')
      expect(page).to have_content(t('errors.messages.blank'))
    end
  end
end
