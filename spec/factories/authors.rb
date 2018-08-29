FactoryBot.define do
  factory :author do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    description { Faker::Hipster.paragraph(3, false, 5) }
  end
end
