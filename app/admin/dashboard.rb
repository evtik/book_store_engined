ActiveAdmin.register_page 'Dashboard' do
  menu(priority: 1, label: proc { t('active_admin.dashboard') })

  content(title: proc { t('active_admin.dashboard') }) do
    tr_key = 'activerecord.attributes.'

    columns do
      column do
        panel(t('.recent_orders')) do
          table_for(Ecomm::Order.order('id desc').limit(10)) do
            column(t('.order')) do |order|
              link_to(order.decorate.number, admin_order_path(order))
            end
            column(t('.state')) do |order|
              span(t(tr_key + 'order.state.' + order.state),
                   class: "status_tag #{order.state}")
            end
            column(t('.date'), :created_at)
            column(t('.customer'), :customer, sortable: :customer_id)
            column(t('.total')) do |order|
              number_to_currency(order.subtotal + order.shipment.price)
            end
          end
        end
      end
    end

    columns do
      column do
        panel(t('.recent_reviews')) do
          table_for(Review.order('id desc').limit(10)) do
            column(t('.book')) do |review|
              link_to(review.book.title, admin_book_path(review.book))
            end
            column(t('.title')) do |review|
              link_to(markdown_truncate(review.title, length: 30),
                      admin_review_path(review))
            end
            column(t('.body')) do |review|
              markdown_truncate(review.body, length: 90)
            end
            column(t('.date'), :created_at)
            column(t('.user'), :user, sortable: :user_id)
            column(t('.state')) do |review|
              span(t(tr_key + 'review.state.' + review.state),
                   class: "status_tag #{review.state}")
            end
          end
        end
      end
    end
  end
end
