class OrdersPresenter < Rectify::Presenter
  FILTERS = %w(in_progress in_queue in_delivery delivered canceled).freeze

  attribute(:params, ActionController::Parameters)

  def filters
    FILTERS
  end

  def current_orders_filter
    params[:filter] || 'all'
  end
end
