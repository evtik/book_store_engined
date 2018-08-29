feature 'Admin new Category page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :new_admin_book_category_path

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    background do
      visit admin_book_categories_path
      click_on(t('active_admin.new_model',
                 model: 'Book ' + t('activerecord.models.category.one')))
    end

    scenario 'with valid category name shows success message' do
      fill_in('category_name', with: 'horror')
      click_on('Create Category')
      expect(page).to have_content(aa_tr(:book_category, :create))
    end

    scenario 'with empty category name shows errors' do
      click_on('Create Category')
      expect(page).to have_content(t('errors.messages.blank'))
    end
  end
end
