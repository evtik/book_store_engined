feature 'Admin new Material page' do
  include ActiveAdmin::TranslationHelpers

  include_examples 'not authorized', :new_admin_material_path

  context 'with admin' do
    before { login_as(create(:admin_user), scope: :user) }

    background do
      visit admin_materials_path
      click_on(t('active_admin.new_model',
                 model: t('activerecord.models.material.one')))
    end

    scenario 'with valid material name shows success message' do
      fill_in('material_name', with: 'white paper')
      click_on('Create Material')
      expect(page).to have_content(aa_tr(:material, :create))
    end

    scenario 'with empty material name shows errors' do
      click_on('Create Material')
      expect(page).to have_content(t('errors.messages.blank'))
    end
  end
end
