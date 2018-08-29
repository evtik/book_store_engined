require_relative '../../../support/forms/admin_author_form'

feature 'Admin new Author page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :new_admin_author_path

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    given(:form) { AdminAuthorForm.new }

    background do
      visit admin_authors_path
      click_on(t('active_admin.new_model',
                 model: t('activerecord.models.author.one')))
    end

    scenario 'with valid author data shows success message' do
      form.fill_in_with(attributes_for(:author)).submit('Create')
      expect(page).to have_content(aa_tr(:author, :create))
    end

    scenario 'with invalid author data shows errors' do
      form.fill_in_with(attributes_for(:author, last_name: '#@!})'))
          .submit('Create')
      expect(page).to have_content(t('errors.messages.invalid'))
    end
  end
end
