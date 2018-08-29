feature 'Orders index page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit orders_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }
    given(:states) { Ecomm::Order.aasm.states.map(&:name).unshift(:all) }

    background { login_as(user, scope: :user) }

    scenario 'has orders caption' do
      visit orders_path
      expect(page).to have_css('h1', text: t('orders.index.my_orders'))
    end

    scenario 'has orders filter select' do
      visit orders_path
      states.each do |state|
        expect(page).to have_css(
          'ul.dropdown-menu li a',
          visible: false, text: t("orders.orders_filters.#{state}")
        )
      end
    end

    scenario "has order filter 'All' option selected by default" do
      visit orders_path
      expect(page).to have_css(
        'a.dropdown-toggle.dropdown-btn', text: t('orders.orders_filters.all')
      )
    end

    context 'with some orders been placed previously' do
      background do
        create_list(:book_with_authors_and_materials, 5)
        states[1..-1].each.with_index do |state, index|
          order = build(:order, state: state, subtotal: (index + 1),
                                customer: user)
          order.shipment = build(:shipment)
          order.credit_card = build(:credit_card)
          order.addresses << build(:address)
          (index + 1).times do |count|
            order.line_items << build(:line_item, product_id: (count + 1))
          end
          order.save
        end
      end

      scenario 'has 5 order items on page' do
        visit orders_path
        expect(page).to have_css('tr.order-row', count: 5)
      end

      scenario 'has the latest order as the first in list' do
        visit orders_path
        expect(first('span.general-order-number').text).to eq('R00000005')
      end

      scenario 'click on filter option only leaves selected orders on page' do
        visit orders_path
        find('a.dropdown-toggle.dropdown-btn').click
        click_on(t('orders.orders_filters.in_delivery'))
        expect(page).to have_css('tr.order-row', count: 1)
        expect(page).to have_css(
          '.font-weight-light',
          text: t('orders.orders_filters.in_delivery')
        )
      end

      scenario 'does not show another user orders' do
        another_user = create(:user)
        order = build(:order)
        order.line_items << build(:line_item, product_id: 1)
        order.shipment = build(:shipment)
        order.customer = another_user
        order.save

        visit orders_path
        expect(page).not_to have_content('R00000006')
      end

      scenario 'click on order item redirects to order page',
               use_selenium: true do
        visit orders_path
        first('tr.order-row td').click
        expect(page).to have_current_path(/orders\/5/)
      end
    end
  end
end
