describe Settings::UpdatePassword do
  describe '#call' do
    let(:user) { spy('User') }
    let(:flash) { {} }

    context 'with no password in params' do
      let(:args) { [{}, user, flash, nil] }

      before { described_class.call(*args) }

      it "adds 'password blank' error to User instance errors collection" do
        expect(user.errors).to have_received(:add).with(:password, :blank)
      end

      it "sets flash alert to 'password blank' error message" do
        expect(flash[:alert]).to include(t('errors.messages.blank'))
      end
    end

    context 'with password in params' do
      context 'and update failure' do
        let(:user) { spy('User', update_with_password: false) }
        let(:args) { [{ password: 1 }, user, flash, nil] }

        it 'ensures User instance to clear entered passwords' do
          described_class.call(*args)
          expect(user).to have_received(:clean_up_passwords)
        end

        it 'sets flash alert to update error message' do
          error = 'update error'
          allow(user).to(
            receive_message_chain('errors.full_messages.first') { error }
          )
          described_class.call(*args)
          expect(flash[:alert]).to eq(error)
        end
      end

      context 'and update success' do
        let(:user) { spy('User', update_with_password: true) }
        let(:controller) { spy('RegistrationsController') }
        let(:args) { [{ password: 1 }, user, flash, controller] }

        before { described_class.call(*args) }

        it 'sets flash notice to update success message' do
          expect(flash[:notice]).to(
            eq(I18n.t('settings.change_password.changed_message'))
          )
        end

        it 'ensures controller to re-sign in user with new credentials' do
          expect(controller).to have_received(:bypass_sign_in).with(user)
        end
      end
    end
  end
end
