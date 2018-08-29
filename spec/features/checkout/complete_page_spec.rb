feature 'Checkout complete page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit ecomm.checkout_complete_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 3) }
    given!(:shipment) { create(:shipment) }

    background do
      page.set_rack_session(
        cart: { 1 => 1, 2 => 2, 3 => 3 },
        order: {
          billing: attributes_for(:address),
          shipping: attributes_for(:address, address_type: 'shipping'),
          shipment: attributes_for(:shipment),
          shipment_id: 1,
          card: attributes_for(:credit_card),
          subtotal: 5.4
        },
        order_subtotal: 5.4
      )
      login_as(user, scope: :user)
      visit ecomm.checkout_confirm_path
      click_on(t('ecomm.checkout.confirm.place_order'))
    end

    include_examples 'order details'

    scenario 'has 5 as current checkout progress step' do
      expect(page).to have_css('li.step.done', count: 4)
      expect(page).to have_css('li.step.active span.step-number', text: '5')
    end

    scenario 'has thanks message' do
      expect(page).to have_css(
        'h3.general-subtitle', text: t('ecomm.checkout.complete.thanks')
      )
    end

    scenario 'has email sent message' do
      expect(page).to have_css(
        'p.font-weight-light', text: user.email
      )
    end

    scenario 'has order number set' do
      expect(page).to have_css('p.general-order-number', text: '#R00000001')
    end

    scenario 'has no address edit link' do
      expect(page).not_to have_link('edit', href: ecomm.checkout_address_path)
    end

    scenario 'click back to store goes to catalog index' do
      click_on(t('ecomm.checkout.complete.back_to_store'))
      expect(page).to have_css('h1', text: t('catalog.index.caption'))
    end
  end
end
