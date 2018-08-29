describe EmailsController do
  describe 'PUT update' do
    context 'with logged in user' do
      let(:user) { create(:user) }

      shared_examples 'redirects back' do
        example 'redirects back to settings#show' do
          expect(response).to redirect_to(settings_path)
        end
      end

      before { sign_in(user) }

      context 'with valid email params' do
        before do
          put :update, params: {
            user: { email: 'some@email.com' },
            id: user.id
          }
        end

        it 'updates user email in database' do
          user.reload
          expect(user.email).to eq('some@email.com')
        end

        include_examples 'redirects back'
      end

      context 'with invalid email params' do
        before do
          put :update, params: {
            user: { email: 'email.com' },
            id: user.id
          }
        end

        it 'does not update user email in database' do
          user.reload
          expect(user.email).not_to eq('email.com')
        end

        include_examples 'redirects back'
      end

      context 'with email taken by another user' do
        let(:another_user) { create(:user) }

        before do
          put :update, params: {
            user: { email: another_user.email },
            id: user.id
          }
        end

        it 'does not update user email in database' do
          user.reload
          expect(user.email).not_to eq(another_user.email)
        end

        include_examples 'redirects back'
      end
    end

    context 'with guest user' do
      it 'redirects to login page' do
        put :update, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
