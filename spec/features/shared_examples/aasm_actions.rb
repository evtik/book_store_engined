shared_examples 'aasm actions' do |params|
  params[:set].each_cons(2) do |curr, nxt|
    current_state = curr[0]
    next_state = nxt[0]
    allowed_actions = curr[1]
    next_allowed_actions = nxt[1]

    context "#{params[:entity_label]} in #{current_state} state",
            use_selenium: true do
      background do
        entity.state = current_state
        entity.save
        path_helper = params[:path_helper]
        resource_path = params[:resource_path]
        visit resource_path ? send(path_helper, entity) : send(path_helper)
      end

      include_examples 'aasm state events', current_state, allowed_actions

      allowed_actions&.each do |action|
        if action == params[:last_action]
          next_state = params[:last_state]
          next_allowed_actions = nil
        end

        context "click on #{action} option changes state to #{next_state}" do
          background { select(t("#{event_tr_prefix}#{action}", from: 'event')) }

          include_examples 'aasm state events', next_state, next_allowed_actions
        end
      end
    end
  end
end
