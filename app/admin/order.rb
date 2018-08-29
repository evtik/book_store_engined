ActiveAdmin.register Ecomm::Order, as: 'Order' do
  actions(:index, :show)

  config.batch_actions = false
  config.filters = false

  tr_key = 'activerecord.attributes.order.state.'
  scope(I18n.t('.active_admin.resource.index.all'), :all, default: true)
  scope(I18n.t("#{tr_key}in_progress")) do |scope|
    scope.where(state: %w(in_progress in_queue in_delivery))
  end
  scope(I18n.t("#{tr_key}delivered"), :delivered)
  scope(I18n.t("#{tr_key}canceled"), :canceled)

  index do
    column(t('.order.order')) do |order|
      link_to(order.decorate.number, admin_order_path(order))
    end
    column(t('.order.state')) do |order|
      span(t(tr_key + order.state), class: "status_tag #{order.state}")
    end
    column(t('.order.date'), :created_at)
    column(t('.order.customer'), :customer, sortable: :customer_id)
    column(t('.order.total')) do |order|
      number_to_currency(order.subtotal + order.shipment.price)
    end
    column(t('.actions')) { |order| aasm_events_select(order) }
  end

  show do
    attributes_table do
      row(t('.order.number')) { |order| order.decorate.number }
      row(t('.order.state')) do |order|
        span(t(tr_key + order.state), class: "status_tag #{order.state}")
      end
      row(t('activerecord.models.user.one')) do |order|
        link_to(order.customer.email, admin_user_path(order.customer))
      end
      row(t('.actions')) { |order| aasm_events_select(order) }
      table_for(order.line_items) do |t|
        column(t('active_admin.resource.index.book.image')) do |item|
          image_tag(item.product.main_image.url(:thumb))
        end
        t.column(t('ecomm.carts.product')) { |item| item.product.title }
        t.column(t('ecomm.carts.price')) do |item|
          number_to_currency item.product.price
        end
        t.column(t('ecomm.carts.quantity'), &:quantity)
        t.column(t('ecomm.carts.subtotal')) do |item|
          number_to_currency(item.quantity * item.product.price)
        end

        right_align_span = { style: 'text-align: right;', colspan: 4 }

        tr(class: 'odd') do
          td(t('.order.items_total'), right_align_span)
          items_total = order.line_items.sum do |line_item|
            line_item.quantity * line_item.product.price
          end
          td(number_to_currency(items_total))
        end
        tr(class: 'odd') do
          td(t('activerecord.models.coupon.one'), right_align_span)
          cut = order.coupon&.discount
          td(number_to_percentage((cut ? cut : 0.0), precision: 0))
        end
        tr(class: 'odd') do
          td(t('ecomm.checkout.order_subtotal'), right_align_span)
          td(number_to_currency(order.subtotal))
        end
        tr(class: 'odd') do
          td(t('activerecord.models.shipment.one'), right_align_span)
          td(number_to_currency(order.shipment.price))
        end
        tr(class: 'odd') do
          td(t('ecomm.carts.show.order_total'), right_align_span)
          td(number_to_currency(order.subtotal + order.shipment.price))
        end
      end
    end
  end

  sidebar(I18n.t('ecomm.checkout.address.billing_address'), only: :show) do
    render_address(order.billing_address)
  end

  sidebar(I18n.t('ecomm.checkout.address.shipping_address'), only: :show) do
    render_address(order.shipping_address || order.billing_address)
  end

  sidebar(I18n.t('ecomm.checkout.payment.credit_card'), only: :show) do
    render_credit_card(order.credit_card)
  end

  controller do
    def update
      Ecomm::Order.find(params[:id]).send(params[:event].to_s << '!')
      redirect_to(request.referrer)
    end
  end
end
