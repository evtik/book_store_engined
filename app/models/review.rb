class Review < ApplicationRecord
  include AASM

  belongs_to(:book)
  belongs_to(:user)

  scope(:approved,
        lambda {
          where(state: 'approved')
         .order(created_at: :desc)
         .includes(user: [:billing_address])
        })

  aasm(column: 'state', whiny_transitions: false) do
    state(:unprocessed, initial: true)
    state(:approved, :rejected)

    event(:approve) do
      transitions(from: :unprocessed, to: :approved)
    end

    event(:reject) do
      transitions(from: [:unprocessed, :approved], to: :rejected)
    end
  end
end
