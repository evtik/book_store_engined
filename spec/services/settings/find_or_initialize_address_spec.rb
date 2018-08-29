describe Settings::FindOrInitializeAddress do
  describe '#call' do
    let(:user) { create(:user) }
    subject { described_class.call(attributes, user.id) }

    shared_examples 'returns model instance' do
      example 'returns Ecomm::Address instance' do
        is_expected.to be_instance_of(Ecomm::Address)
      end
    end

    context 'with existing address' do
      let(:address) { create(:address, customer_id: user.id) }
      let(:attributes) do
        attributes_for(:address, zip: '11111').merge(id: address.id)
      end

      include_examples 'returns model instance'

      it 'returns saved address' do
        is_expected.to be_persisted
      end

      it 'updates existing address' do
        expect(subject.zip).to eq('11111')
      end
    end

    context 'with non-existing address' do
      let(:attributes) { attributes_for(:address, country: 'Greece') }

      include_examples 'returns model instance'

      it 'returns new address' do
        is_expected.not_to be_persisted
      end

      it 'populates address fields' do
        expect(subject.country).to eq('Greece')
      end

      it 'sets proper user_id' do
        expect(subject.customer_id).to eq(user.id)
      end

      it 'sets proper address_type' do
        expect(subject.address_type).to eq('billing')
      end
    end
  end
end
