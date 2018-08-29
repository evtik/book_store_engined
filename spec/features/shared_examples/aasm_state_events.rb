shared_examples 'aasm state events' do |current_state, allowed_actions|
  scenario 'has correct state label' do
    expect(page).to have_text(state_label(state_tr_prefix, current_state))

    (aasm_states - [current_state]).each do |state|
      expect(page).not_to have_text(state_label(state_tr_prefix, state))
    end
  end

  scenario 'has correct change state select options' do
    allowed_actions ||= []

    allowed_actions.each do |action|
      expect(page).to(
        have_css('option', text: t("#{event_tr_prefix}#{action}"))
      )
    end

    (aasm_events - allowed_actions).each do |action|
      expect(page).not_to(
        have_css('option', text: t("#{event_tr_prefix}#{action}"))
      )
    end
  end
end
