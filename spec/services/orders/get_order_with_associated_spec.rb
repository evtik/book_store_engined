describe Orders::GetOrderWithAssociated do
  describe '#call' do
    subject do
      create_list(:book_with_authors_and_materials, 3)
      order = build(:order)
      order.addresses = build_list(:address, 2)
      order.credit_card = build(:credit_card)
      order.shipment = build(:shipment)
      order.coupon = build(:coupon)
      order.line_items = build_list(:line_item, 3)
      order.save
      described_class.call(order.id)
    end

    it 'returns Ecomm::OrderDecorator instance' do
      is_expected.to be_instance_of(Ecomm::OrderDecorator)
    end

    it 'ensures to have preloaded order`s associated entities' do
      %i(billing_address shipping_address credit_card shipment
         coupon line_items).each do |associated|
        expect(subject.association_cached?(associated)).to be true
      end
    end

    it 'also ensures to have loaded line items` books' do
      expect(subject.line_items.first.association_cached?(:product)).to be true
    end
  end
end
