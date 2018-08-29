require_relative '../../../support/forms/admin_book_form'

feature 'Admin new Book page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :new_admin_book_path

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    given(:form) { AdminBookForm.new }
    given(:extra_params) do
      {
        add_images: true,
        main_image: '31',
        images: %w(16 24 32),
        category: 'Photo',
        author_ids: [1, 3],
        material_ids: [2, 4]
      }
    end

    background do
      create_list(:category, 4)
      create_list(:author, 5)
      create_list(:material, 6)
      visit admin_books_path
      click_on(t('active_admin.new_model',
                 model: t('activerecord.models.book.one')))
    end

    scenario 'with valid book data shows success message' do
      book_attributes = attributes_for(:loose_book).merge(extra_params)
      form.fill_in_with(book_attributes).submit('Create')
      expect(page).to have_content(aa_tr(:book, :create))
    end

    scenario 'with invalid book data shows errors' do
      book_attributes = attributes_for(:book, title: '').merge(extra_params)
      form.fill_in_with(book_attributes).submit('Create')
      expect(page).to have_content(t('errors.messages.blank'))
    end
  end
end
