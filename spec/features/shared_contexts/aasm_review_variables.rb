shared_context 'aasm review variables' do
  given(:aasm_states) { Review.aasm.states.map(&:name) }
  given(:aasm_events) { Review.aasm.events.map(&:name) }
  given(:state_tr_prefix) { 'activerecord.attributes.review.state.' }
  given(:event_tr_prefix) { 'active_admin.aasm.events.' }
end
