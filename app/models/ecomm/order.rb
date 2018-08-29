require Ecomm::Engine.models_path(:order)

module Ecomm
  class Order
    include AASM

    aasm(column: 'state', whiny_transitions: false) do
      state(:in_progress, initial: true)
      state(:in_queue, :in_delivery, :delivered, :canceled)

      event(:queue) do
        transitions(from: :in_progress, to: :in_queue)
      end

      event(:deliver) do
        transitions(from: :in_queue, to: :in_delivery)
      end

      event(:complete) do
        transitions(from: :in_delivery, to: :delivered)
      end

      event(:cancel) do
        transitions(from: [:in_progress, :in_queue], to: :canceled)
      end
    end
  end
end
