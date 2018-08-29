require_relative '../../../support/admin/batch_actions'

feature 'Admin Books index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_books_path

  context 'with admin' do
    given(:ar_prefix) { 'activerecord.models.book.' }
    given(:book_label) { t("#{ar_prefix}one") }
    given(:books_label) { t("#{ar_prefix}other") }

    background { login_as(create(:admin_user), scope: :user) }

    scenario 'shows admin books index' do
      visit admin_books_path
      expect(page).to have_content(books_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: book_label))
    end

    scenario 'shows list of available books' do
      create_list(:book_with_authors_and_materials, 3, title: 'Thetis')
      visit admin_books_path
      expect(page).to have_content('Thetis', count: 3)
    end

    scenario "click on 'new book' redirects to 'new book' page" do
      visit admin_books_path
      click_link(t('active_admin.new_model', model: book_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: book_label)
      )
      expect(page).to have_field('book_title')
    end

    scenario "click on 'view' link redirects to 'show book' page" do
      create(:book_with_authors_and_materials,
             title: 'Dwarf',
             images: load_images(%w(16 24 32)))
      visit admin_books_path
      click_link(t('active_admin.view'))
      expect(page).to have_content('Dwarf')
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: book_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: book_label))
    end

    scenario "click on 'edit' link redirects to 'edit book' page" do
      create(:book_with_authors_and_materials)
      visit admin_books_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: book_label)
      )
      expect(page).to have_field('book_year')
    end

    context "click on 'delete'", use_selenium: true do
      given!(:book) { create(:book_with_authors_and_materials) }

      scenario 'removes book from list' do
        visit admin_books_path
        click_link(t('active_admin.delete'))
        accept_alert
        expect(page).to have_text(t('active_admin.books.destroyed'))
      end

      scenario 'does not remove book from list if it has line items' do
        create(:line_item, product: book)
        visit admin_books_path
        click_link(t('active_admin.delete'))
        accept_alert
        expect(page).to have_text(t('active_admin.books.cannot_destroy'))
      end
    end

    context 'batch actions', use_selenium: true do
      given(:batch_prefix) { 'active_admin.batch_actions.' }

      context 'delete all' do
        scenario 'with no books present in orders' do
          create_list(:book_with_authors_and_materials, 5)
          visit admin_books_path
          check_batch_all
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 5, model: books_label.downcase)
          )
        end

        scenario 'with one book present in orders' do
          books = create_list(:book_with_authors_and_materials, 5)
          create(:line_item, product: books.first)
          visit admin_books_path
          check_batch_all
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 5, rejected: 1,
                                  model: books_label.downcase)
          )
        end

        scenario 'with more than 1 book present in orders' do
          books = create_list(:book_with_authors_and_materials, 5)
          books[1..3].each { |book| create(:line_item, product: book) }
          visit admin_books_path
          check_batch_all
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 5, rejected: 3,
                                  model: books_label.downcase)
          )
        end
      end

      context 'delete selected' do
        scenario 'exactly one book' do
          create_list(:book_with_authors_and_materials, 5)
          visit admin_books_path
          check_batch_items(2)
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 1, model: book_label.downcase)
          )
        end

        scenario 'with no books present in orders' do
          create_list(:book_with_authors_and_materials, 5)
          visit admin_books_path
          check_batch_items(2, 5)
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 2, model: books_label.downcase)
          )
        end

        scenario 'with one book present in orders' do
          books = create_list(:book_with_authors_and_materials, 5)
          create(:line_item, product: books[3])
          visit admin_books_path
          check_batch_items(1, 2, 4)
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 3, rejected: 1,
                                  model: books_label.downcase)
          )
        end

        scenario 'with more than 1 book present in orders' do
          books = create_list(:book_with_authors_and_materials, 5)
          books[3..4].each { |book| create(:line_item, product: book) }
          visit admin_books_path
          check_batch_items(3, 4, 5)
          click_batch_delete
          expect(page).to have_content(
            batch_destroyed_label(count: 3, rejected: 2,
                                  model: books_label.downcase)
          )
        end
      end
    end
  end
end
