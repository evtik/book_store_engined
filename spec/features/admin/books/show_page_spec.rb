feature 'Admin Book show page' do
  include_examples 'not authorized', :admin_book_path, 1

  context 'with admin', use_selenium: true do
    background { login_as(create(:admin_user), scope: :user) }

    context "click on 'delete'" do
      given!(:book) { create(:book_with_authors_and_materials) }

      context 'when the book has no line items' do
        background do
          visit admin_book_path(book)
          click_link(t('active_admin.delete'))
          accept_alert
        end

        scenario 'deletes the book' do
          expect(page).to have_text(t('active_admin.books.destroyed'))
        end

        scenario 'redirects to books index page' do
          expect(page).to have_text('Books')
        end
      end

      context 'when the book has line items' do
        background do
          create(:line_item, product: book)
          visit admin_book_path(book)
          click_link(t('active_admin.delete'))
          accept_alert
        end

        scenario 'does not delete the book' do
          expect(page).to have_text(t('active_admin.books.cannot_destroy'))
        end

        scenario "stays on the book's show page" do
          expect(page).to have_text('Book Details')
        end
      end
    end
  end
end
