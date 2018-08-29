include AbstractController::Translation

describe AddressesController do
  describe 'PUT update' do
    context 'with logged in user' do
      let(:user) { create(:user) }

      shared_examples 'redirects back' do
        example 'redirects back to settings#show' do
          expect(response).to redirect_to(settings_path)
        end
      end

      before { sign_in(user) }

      context 'with existing address' do
        let(:address) { create(:address, customer: user) }

        context 'with valid params data' do
          before do
            put :update, params: {
              address: {
                billing: attributes_for(:address, city: 'Updated')
                  .merge(id: address.id),
                shipping: attributes_for(:address, address_type: 'shipping')
              },
              billing: t('settings.show.save'),
              id: user.id
            }
          end

          it 'updates address in database' do
            address.reload
            expect(address.city).to eq('Updated')
          end

          include_examples 'redirects back'
        end

        context 'with invalid params data' do
          before do
            put :update, params: {
              address: {
                billing: attributes_for(:address, city: 'Updated',
                                                  zip: 'abcdef')
                  .merge(id: address.id),
                shipping: attributes_for(:address, address_type: 'shipping')
              },
              billing: t('settings.show.save'),
              id: user.id
            }
          end

          it 'does not update address in database' do
            address.reload
            expect(address.city).not_to eq('Updated')
          end

          include_examples 'redirects back'
        end
      end

      context 'with non-existent address' do
        context 'with valid params data' do
          let(:valid_data) {
            {
              address: {
                billing: attributes_for(:address),
                shipping: attributes_for(:address, address_type: 'shipping')
              },
              shipping: t('settings.show.save'),
              id: user.id
            }
          }

          it 'creates new address in database' do
            expect {
              put :update, params: valid_data
            }.to change(Ecomm::Address, :count).by(1)
          end

          it 'redirects back to settings#show' do
            put :update, params: valid_data
            expect(response).to redirect_to settings_path
          end
        end

        context 'with invalid params data' do
          let(:invalid_data) {
            {
              address: {
                billing: attributes_for(:address),
                shipping: attributes_for(:address, address_type: 'shipping',
                                                   phone: 'myphone')
              },
              shipping: t('settings.show.save'),
              id: user.id
            }
          }

          it 'does not create new address in database' do
            expect {
              put :update, params: invalid_data
            }.not_to change(Ecomm::Address, :count)
          end

          it 'redirects back to settings#show' do
            put :update, params: invalid_data
            expect(response).to redirect_to settings_path
          end
        end
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
