require_relative '../../../support/forms/admin_book_form'

feature 'Admin edit Book page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :edit_admin_book_path, 1

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    given(:form) { AdminBookForm.new }
    given(:extra_params) do
      {
        add_images: false,
        category: 'Web design',
        author_ids: [3, 4],
        material_ids: [5, 6]
      }
    end

    background do
      create_list(:category, 3)
      create_list(:author, 4)
      create_list(:material, 6)
      create(:book_with_authors_and_materials, images: load_images(%w(16 24 32)))
      visit admin_books_path
      click_link(t('active_admin.edit'))
    end

    scenario 'with valid book data shows success message' do
      book_attributes = attributes_for(:loose_book).merge(extra_params)
      form.fill_in_with(book_attributes).submit('Update')
      expect(page).to have_content(aa_tr(:book, :update))
    end

    scenario 'with invalid book data shows errors' do
      book_attributes = attributes_for(:book, title: '(!#&*)').merge(extra_params)
      form.fill_in_with(book_attributes).submit('Update')
      expect(page).to have_content(t('errors.messages.invalid'))
    end
  end
end
