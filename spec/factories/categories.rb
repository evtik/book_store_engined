FactoryBot.define do
  factory :category do
    cats = ['mobile development', 'photo', 'web design', 'web development']
    sequence(:name) { |n| cats[(n - 1) % cats.length] }
  end
end
