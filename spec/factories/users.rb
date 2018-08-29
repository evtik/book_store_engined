FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password '11111111'
    password_confirmation '11111111'

    factory :admin_user do
      admin true
    end

    factory :user_with_address do
      after(:build) do |user|
        user.addresses << build(:address)
      end
    end
  end
end
