module ActiveAdmin
  module ViewsHelper
    def aasm_events_select(resource)
      events = resource.aasm.events.map do |event|
        [t("active_admin.aasm.events.#{event.name}"), event.name]
      end

      path = send("admin_#{resource.class.name.demodulize.underscore}_path",
                  resource)

      render(partial: 'admin/aasm/events',
             locals: { resource: resource, path: path, collection: events })
    end

    def render_address(address)
      to_p_with_br(["#{address.first_name} #{address.last_name}",
                    address.street_address,
                    address.city,
                    address.country,
                    "Phone #{address.phone}"])
    end

    def render_credit_card(card)
      to_p_with_br([card.number.scan(/(....)/).join(' '),
                    card.cardholder,
                    card.month_year])
    end

    private

    def to_p_with_br(details)
      raw("<p>#{details.join('<br>')}</p>")
    end
  end
end
