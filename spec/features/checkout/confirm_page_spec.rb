feature 'Checkout confirm page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit ecomm.checkout_confirm_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 3) }
    given!(:shipment) { create(:shipment) }

    around do |example|
      login_as(user, scope: :user)
      page.set_rack_session(
        cart: { 1 => 1, 2 => 2, 3 => 3 },
        order: {
          billing: attributes_for(:address),
          shipping: attributes_for(:address, address_type: 'shipping'),
          shipment: attributes_for(:shipment)
        },
        order_subtotal: 5.4
      )
      example.run
      page.set_rack_session(order: nil)
    end

    context 'with no credit card set' do
      scenario 'redirects to checkout payment path' do
        visit ecomm.checkout_confirm_path
        expect(page).to have_css(
          'h3.general-subtitle', text: t('ecomm.checkout.payment.credit_card')
        )
      end
    end

    context 'with credit card set' do
      background do
        page.set_rack_session(
          order: {
            billing: attributes_for(:address),
            shipping: attributes_for(:address, address_type: 'shipping',
                                               country: 'Spain'),
            shipment: attributes_for(:shipment),
            shipment_id: 1,
            card: attributes_for(:credit_card),
            subtotal: 5.4
          },
          order_subtotal: 5.4
        )
        visit ecomm.checkout_confirm_path
      end

      include_examples 'order details'
      include_examples 'extended order details'

      scenario 'has addresses edit link' do
        expect(page).to have_link('edit', href: ecomm.checkout_address_path)
      end

      scenario 'has shipment edit link' do
        expect(page).to have_link('edit', href: ecomm.checkout_delivery_path)
      end

      scenario 'has payment edit link' do
        expect(page).to have_link('edit', href: ecomm.checkout_payment_path)
      end

      context 'click on place order' do
        scenario 'with no order errors redirects to order complete page' do
          click_on(t('ecomm.checkout.confirm.place_order'))
          expect(page).to have_css(
            'h3.general-subtitle',
            text: t('ecomm.checkout.complete.thanks')
          )
        end

        scenario 'with order errors redirects back to confirm page' do
          allow_any_instance_of(Ecomm::Order).to(
            receive(:save).and_return(false)
          )
          click_on(t('ecomm.checkout.confirm.place_order'))
          expect(page).to have_content(
            t('ecomm.checkout.submit_confirm.order_placement_error')
          )
          expect(page).to have_button(t('ecomm.checkout.confirm.place_order'))
        end
      end
    end
  end
end
