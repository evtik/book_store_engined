require_relative '../../../support/admin/batch_actions'

feature 'Admin Categories index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_book_categories_path

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given(:ar_prefix) { 'activerecord.models.category.' }
    given(:category_label) { 'Book ' + t("#{ar_prefix}one") }
    given(:categories_label) { 'Book ' + t("#{ar_prefix}other") }

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows admin categories index' do
      visit admin_book_categories_path
      expect(page).to have_content(categories_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: category_label))
    end

    scenario 'shows list of available categories' do
      create_list(:category, 4, name: 'Fiction')
      visit admin_book_categories_path
      expect(page).to have_content('Fiction', count: 4)
    end

    scenario "click on 'new category' redirects to 'new category' page" do
      visit admin_book_categories_path
      click_link(t('active_admin.new_model', model: category_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: category_label)
      )
      expect(page).to have_field('category_name')
    end

    scenario "click on 'view' link redirects to 'show category' page" do
      category = create(:category)
      visit admin_book_categories_path
      click_link(t('active_admin.view'))
      expect(page).to have_content(category.name)
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: category_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: category_label))
    end

    scenario "click on 'edit' link redirects to 'edit category' page" do
      create(:category)
      visit admin_book_categories_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: category_label)
      )
      expect(page).to have_field('category_name')
    end

    scenario "click on 'delete' removes category from list",
             use_selenium: true do
      create(:category)
      visit admin_book_categories_path
      click_link(t('active_admin.delete'))
      accept_alert
      expect(page).to have_content(
        t('active_admin.blank_slate.content', resource_name: categories_label)
      )
    end

    context 'batch actions', use_selenium: true do
      given(:batch_prefix) { 'active_admin.batch_actions.' }

      scenario 'delete all' do
        create_list(:category, 5)
        visit admin_book_categories_path
        check_batch_all
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(count: 5, model: categories_label.downcase)
        )
        expect(page).to have_content(
          t('active_admin.blank_slate.content', resource_name: categories_label)
        )
      end

      scenario 'delete selected' do
        create_list(:category, 4, name: 'Sports')
        visit admin_book_categories_path
        check_batch_items(1, 3)
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(count: 2, model: categories_label.downcase)
        )
        expect(page).to have_content('Sports', count: 2)
      end
    end
  end
end
