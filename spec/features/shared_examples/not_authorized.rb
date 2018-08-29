shared_examples 'not authorized' do |path, id|
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit id ? send(path, id) : send(path)
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with non-admin user' do
    scenario "redirects back to root with 'not authorized' message" do
      create_list(:book_with_authors_and_materials, 3)
      login_as(create(:user), scope: :user)
      visit id ? send(path, id) : send(path)
      expect(page).to have_content(t('active_admin.not_authorized'))
    end
  end
end
