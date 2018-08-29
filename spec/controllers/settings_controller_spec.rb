describe SettingsController do
  describe 'GET show' do
    context 'with logged in user' do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        get :show
      end

      it 'renders :show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns values to @billing and @shipping' do
        expect(assigns(:billing)).to be_truthy
        expect(assigns(:shipping)).to be_truthy
      end
    end

    context 'with guest user' do
      it 'redirects to login page' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
