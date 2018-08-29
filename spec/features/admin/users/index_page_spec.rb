require_relative '../../../support/admin/batch_actions'

feature 'Admin User index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_users_path

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given(:ar_prefix) { 'activerecord.models.user.' }
    given(:user_label) { t("#{ar_prefix}one") }
    given(:users_label) { t("#{ar_prefix}other") }

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows admin users index' do
      visit admin_users_path
      expect(page).to have_content(users_label)
      expect(page).to have_link(t('active_admin.new_model', model: user_label))
    end

    scenario 'shows list of available users' do
      create_list(:user, 3)
      visit admin_users_path
      # there always are +2 user labels: admin and his label in aa header
      expect(page).to have_content('@example.com', count: 5)
    end

    scenario "click on 'new user' redirects to 'new user' page" do
      visit admin_users_path
      click_link(t('active_admin.new_model', model: user_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: user_label)
      )
      expect(page).to have_field('user_email')
    end

    scenario "click on 'view' link redirects to 'show user' page" do
      user = create(:user)
      visit admin_users_path
      first('a', text: t('active_admin.view')).click
      expect(page).to have_content(user.email)
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: user_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: user_label))
    end

    scenario "click on 'edit' link redirects to 'edit user' page" do
      create(:user)
      visit admin_users_path
      first('a', text: t('active_admin.edit')).click
      expect(page).to have_content(
        t('active_admin.edit_model', model: user_label)
      )
      expect(page).to have_field('user_password')
    end

    scenario "click on 'delete' removes user from list", use_selenium: true do
      create(:user)
      visit admin_users_path
      first('a', text: t('active_admin.delete')).click
      accept_alert
      expect(page).to have_content('@example.com', count: 2)
    end

    context 'batch actions', use_selenium: true do
      given(:batch_prefix) { 'active_admin.batch_actions.' }

      scenario 'delete all' do
        create_list(:user, 4)
        visit admin_users_path
        check_batch_all
        click_batch_delete
        # since 'delete all' also destroys the current admin :-)
        expect(page).to have_content(t('devise.failure.unauthenticated'))
      end

      scenario 'delete selected' do
        create_list(:user, 7)
        visit admin_users_path
        check_batch_items(2, 3)
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(count: 2, model: users_label.downcase)
        )
        expect(page).to have_content('@example.com', count: 7)
      end
    end
  end
end
