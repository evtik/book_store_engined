feature 'facebook oauth' do
  shared_examples 'logs in' do |path|
    scenario 'logs in with valid credentials' do
      create_list(:book_with_authors_and_materials, 4)
      stub_facebook
      visit send(path)
      click_link("#{t('devise.sessions.new.sign_in_with')} Facebook")
      expect(page).to have_text(
        t('devise.omniauth_callbacks.success', kind: 'Facebook')
      )
    end
  end

  context 'from login page' do
    include_examples 'logs in', :login_path
  end

  context 'from sign up page' do
    include_examples 'logs in', :new_user_registration_path
  end

  def stub_facebook
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '31415926',
      info: {
        email: 'fb@fb.com',
        first_name: 'Face',
        last_name: 'Book',
        hometown: 'Cairo'
      }
    )
  end
end
