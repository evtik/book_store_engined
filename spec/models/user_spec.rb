require 'cancan/matchers'

describe User do
  context 'association' do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }

    it do
      is_expected.to(have_many(:orders).class_name('Ecomm::Order')
                                       .with_foreign_key(:customer_id)
                                       .dependent(:destroy))
    end

    it do
      is_expected.to(have_many(:addresses).class_name('Ecomm::Address')
                                       .with_foreign_key(:customer_id)
                                       .dependent(:destroy))
    end

    it do
      is_expected.to(have_one(:billing_address).class_name('Ecomm::Address')
                                       .with_foreign_key(:customer_id))
    end
  end

  context 'abilities' do
    subject { Ability.new(user) }

    context 'admin' do
      let(:user) { create(:admin_user) }
      it { is_expected.to be_able_to(:manage, :all) }
    end

    context 'average user' do
      let(:user) { create(:user) }
      let(:his_own_order) { create(:order, customer: user) }
      let(:someone_elses_order) { create(:order, customer: create(:user)) }

      it { is_expected.not_to be_able_to(:manage, :all) }

      it 'can read his own order' do
        is_expected.to be_able_to(:read, his_own_order)
      end

      it "cannot read someone else's order" do
        is_expected.not_to be_able_to(:read, someone_elses_order)
      end
    end
  end

  context 'callbacks' do
    context 'after_create' do
      it 'logs error message when sending welcome email fails' do
        user = User.new(attributes_for(:user))
        allow(UserMailer).to(
          receive_message_chain(:user_email, :deliver).and_raise(StandardError,
                                                                 'weird error')
        )
        expect(Rails.logger).to receive(:error).with(/weird error/)
        user.save
      end
    end
  end
end
