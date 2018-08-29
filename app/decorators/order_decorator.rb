class OrderDecorator < Draper::Decorator
  decorates Ecomm::Order
  delegate_all

  def number
    id = model.id.to_s
    'R' << '0' * (8 - id.length) << id
  end
end
