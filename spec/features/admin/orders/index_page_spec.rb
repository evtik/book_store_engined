feature 'Admin Order index page', :include_aasm_helpers do
  include_context 'aasm order variables'

  include_examples 'not authorized', :admin_orders_path

  given(:admin_user) { create(:admin_user) }

  context 'with admin' do
    context 'redirecting to order show page' do
      scenario 'click order link forwards to show page', use_selenium: true do
        order = create(:order, shipment: build(:shipment),
                               customer: admin_user,
                               addresses: build_list(:address, 1),
                               credit_card: build(:credit_card),
                               subtotal: 20.0)
        login_as(admin_user, scope: :user)
        visit admin_orders_path
        click_link(order.decorate.number)
        expect(page).to have_text(
          "#{t('activerecord.models.order.one')} ##{order.id}"
        )
      end
    end

    context 'orders list' do
      background do
        shipment = create(:shipment)
        aasm_states.each_with_index do |state, index|
          create_list(:order, index + 1, shipment: shipment,
                                         state: state, subtotal: 10.0,
                                         customer: admin_user)
        end
        login_as(admin_user, scope: :user)
        visit admin_orders_path
      end

      scenario 'shows list of orders with appropriate states',
               use_selenium: true do
        {
          /r0000/i => 15,
          state_label(state_tr_prefix, :canceled) => 5,
          state_label(state_tr_prefix, :delivered) => 4,
          state_label(state_tr_prefix, :in_delivery) => 3,
          state_label(state_tr_prefix, :in_queue) => 2,
          state_label(state_tr_prefix, :in_progress) => 1
        }.each { |key, value| expect(page).to have_text(key, count: value) }
      end

      context 'filters' do
        scenario 'shows order list filters' do
          [
            'All (15)',
            t("#{state_tr_prefix}in_progress") + ' (6)',
            t("#{state_tr_prefix}delivered") + ' (4)',
            t("#{state_tr_prefix}canceled") + ' (5)'
          ].each do |text|
            expect(page).to have_css('.table_tools_button', text: text)
          end
        end

        include_examples 'active admin filters',
                         filters: %i(in_progress delivered canceled),
                         entity: :orders
      end
    end

    context 'aasm actions' do
      background { login_as(admin_user, scope: :user) }

      params = order_config.merge(
        path_helper: :admin_orders_path,
        resource_path: false
      )

      include_examples 'aasm actions', params do
        given(:entity) do
          create(:order, shipment: build(:shipment), customer: admin_user,
                         subtotal: 10.0)
        end
      end
    end
  end
end
