FactoryBot.define do
  factory :book do
    title { Faker::Book.title }

    factory :loose_book do
      year 2001
      description { Faker::Hipster.paragraph(5, false, 10) }
      height 10
      width 6
      thickness 1
      price 1.0
      main_image { load_images('31') }

      factory :book_with_authors_and_materials do
        association :category, strategy: :build
        transient do
          authors_count 2
          materials_count 2
        end

        after(:build) do |book, evaluator|
          book.authors << build_list(:author, evaluator.authors_count)
          book.materials << build_list(:material, evaluator.materials_count)
        end

        factory :book_with_line_items do
          transient do
            line_items_count 2
          end

          after(:build) do |book, evaluator|
            book.line_items << build_list(
              :line_item, evaluator.line_items_count
            )
          end
        end

        factory :book_with_reviews do
          transient do
            reviews_count 2
          end

          after(:build) do |book, evaluator|
            book.reviews << build_list(:review, evaluator.reviews_count)
          end
        end
      end
    end
  end
end
