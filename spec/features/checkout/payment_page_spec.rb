require_relative '../../support/forms/new_credit_card_form'

feature 'Checkout payment page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit ecomm.checkout_payment_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    around do |example|
      login_as(create(:user), scope: :user)
      page.set_rack_session(order: {}, order_subtotal: 12.0)
      example.run
      page.set_rack_session(order: nil)
    end

    context 'with no shipment set' do
      scenario 'redirects to checkout delivery step' do
        create_list(:shipment, 3)
        visit ecomm.checkout_payment_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('ecomm.checkout.delivery.shipping_method')
        )
      end
    end

    context 'with shipment set' do
      background do
        page.set_rack_session(
          order: { shipment: attributes_for(:shipment, price: 5.0) },
          order_subtotal: 20.0
        )
      end

      scenario 'has 3 as current checkout progress step' do
        visit ecomm.checkout_payment_path
        expect(page).to have_css('li.step.done', count: 2)
        expect(page).to have_css('li.step.active span.step-number', text: '3')
      end

      scenario 'has credit card header' do
        visit ecomm.checkout_payment_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('ecomm.checkout.payment.credit_card')
        )
      end

      scenario 'has correct totals and shipment price' do
        visit ecomm.checkout_payment_path
        expect(page).to have_css('p.font-16', text: '20.00')
        expect(page).to have_css('p#shipment-label', text: '5.00')
        expect(page).to have_css('strong#order-total-label', text: '25.00')
      end

      context 'filling in credit card' do
        given(:credit_card_form) { NewCreditCardForm.new }

        scenario 'with valid data' do
          create_list(:book_with_authors_and_materials, 3)
          page.set_rack_session(
            cart: { 1 => 1, 2 => 2, 3 => 3 },
            order: {
              billing: attributes_for(:address),
              shipping: attributes_for(:address, address_type: 'shipping'),
              shipment: attributes_for(:shipment),
              subtotal: 30.0
            }
          )
          visit ecomm.checkout_payment_path
          credit_card_form.fill_in_with(attributes_for(:credit_card)).submit
          expect(page).to have_button(t('ecomm.checkout.confirm.place_order'))
        end

        scenario 'with invalid data' do
          page.set_rack_session(
            order: { shipment: attributes_for(:shipment),
                     subtotal: 50.0 }
          )
          visit ecomm.checkout_payment_path
          credit_card_form.fill_in_with(
            attributes_for(:credit_card, number: '1234567891011121')
          ).submit
          prefix = 'activemodel.errors.models.credit_card.attributes.'
          expect(page).to have_content(t("#{prefix}number.luhn_invalid"))
        end
      end
    end
  end
end
