shared_context 'aasm order variables' do
  given(:aasm_states) { Ecomm::Order.aasm.states.map(&:name) }
  given(:aasm_events) { Ecomm::Order.aasm.events.map(&:name) }
  given(:state_tr_prefix) { 'activerecord.attributes.order.state.' }
  given(:event_tr_prefix) { 'active_admin.aasm.events.' }
end
