class OrdersController < ApplicationController
  include Rectify::ControllerHelpers

  before_action(:authenticate_user!)
  load_and_authorize_resource(class: Ecomm::Order, only: :index)

  def index
    present OrdersPresenter.new(params: order_params)
    return unless @orders
    filter = order_params[:filter]
    @orders = @orders.order('id desc')
    @orders = @orders.where(state: filter) if filter
    @orders = OrderDecorator.decorate_collection(@orders)
  end

  def show
    @order = Orders::GetOrderWithAssociated.call(order_params[:id])
    authorize!(:show, @order)
    @billing = @order.billing_address
    @shipping = @order.shipping_address || @billing
    @line_items = @order.line_items
    @order.credit_card = @order.credit_card.decorate
  end

  private

  def order_params
    params.permit(:id, :filter)
  end
end
