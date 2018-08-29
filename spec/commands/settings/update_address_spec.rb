include AbstractController::Translation

describe Settings::UpdateAddress do
  describe '#call' do
    let(:user) { create(:user) }
    let(:address) { create(:address, customer_id: user.id) }
    let(:message) { 'updated!' }

    let(:command) do
      described_class.new(
        double('FindOrInitializeAddress', call: address),
        double('GenerateAddressUpdatedMessage', call: message)
      )
    end

    context 'with invalid address params' do
      it 'publishes :invalid event' do
        invalid_params = {
          'billing' => t('settings.show.save'),
          address: { 'billing' => attributes_for(:address, phone: 'abc') }
        }
        expect { command.call(invalid_params, user.id) }.to publish(:invalid)
      end
    end

    context 'with valid address params' do
      it 'publishes :ok event with updating success message' do
        params = {
          'billing' => t('settings.show.save'),
          address: {
            'billing' => attributes_for(:address)
          }
        }
        expect { command.call(params, user.id) }.to publish(:ok, message)
      end
    end
  end
end
