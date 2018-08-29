module Orders
  class GetOrderWithAssociated < Ecomm::BaseService
    def call(id)
      Ecomm::Order.includes(:billing_address, :shipping_address, :credit_card,
                            :shipment, :coupon, line_items: [:product])
                  .where(id: id)
                  .first
                  .decorate
    end
  end
end
