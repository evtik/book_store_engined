feature 'Admin edit Material page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :edit_admin_material_path, 1

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    background do
      create(:material)
      visit admin_materials_path
      click_link(t('active_admin.edit'))
    end

    scenario 'with valid material name shows success message' do
      fill_in('material_name', with: 'Cloth')
      click_on('Update Material')
      expect(page).to have_content(aa_tr(:material, :update))
    end

    scenario 'with invalid material name shows errors' do
      fill_in('material_name', with: '987*')
      click_on('Update Material')
      expect(page).to have_content(t('errors.messages.invalid'))
    end
  end
end
