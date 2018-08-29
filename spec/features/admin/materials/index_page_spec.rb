require_relative '../../../support/admin/batch_actions'

feature 'Admin Materials index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_materials_path

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given(:ar_prefix) { 'activerecord.models.material.' }
    given(:material_label) { t("#{ar_prefix}one") }
    given(:materials_label) { t("#{ar_prefix}other") }

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows admin materials index' do
      visit admin_materials_path
      expect(page).to have_content(materials_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: material_label))
    end

    scenario 'shows list of available materials' do
      create_list(:material, 3, name: 'Vinyl')
      visit admin_materials_path
      expect(page).to have_content('Vinyl', count: 3)
    end

    scenario "click on 'new material' redirects to 'new material' page" do
      visit admin_materials_path
      click_link(t('active_admin.new_model', model: material_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: material_label)
      )
      expect(page).to have_field('material_name')
    end

    scenario "click on 'view' link redirects to 'show material' page" do
      material = create(:material)
      visit admin_materials_path
      click_link(t('active_admin.view'))
      expect(page).to have_content(material.name)
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: material_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: material_label))
    end

    scenario "click on 'edit' link redirects to 'edit material' page" do
      create(:material)
      visit admin_materials_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: material_label)
      )
      expect(page).to have_field('material_name')
    end

    scenario "click on 'delete' removes material from list",
             use_selenium: true do

      create(:material)
      visit admin_materials_path
      click_link(t('active_admin.delete'))
      accept_alert
      expect(page).to have_content(
        t('active_admin.blank_slate.content', resource_name: materials_label)
      )
    end

    context 'batch actions', use_selenium: true do
      given(:batch_prefix) { 'active_admin.batch_actions.' }

      scenario 'delete all' do
        create_list(:material, 4)
        visit admin_materials_path
        check_batch_all
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(count: 4, model: materials_label.downcase)
        )
        expect(page).to have_content(
          t('active_admin.blank_slate.content', resource_name: materials_label)
        )
      end

      scenario 'delete selected' do
        create_list(:material, 6, name: 'Lace')
        visit admin_materials_path
        check_batch_items(1, 5)
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(count: 2, model: materials_label.downcase)
        )
        expect(page).to have_content('Lace', count: 4)
      end
    end
  end
end
