class Book < ApplicationRecord
  belongs_to(:category)
  has_and_belongs_to_many(:authors)
  has_and_belongs_to_many(:materials)
  has_many(:line_items, class_name: 'Ecomm::LineItem', foreign_key: :product_id)
  has_many(:reviews, dependent: :destroy)
  has_many(:approved_reviews, -> { approved }, class_name: 'Review')

  before_destroy -> { throw :abort if line_items.exists? }

  mount_uploader(:main_image, ImageUploader)
  mount_uploaders(:images, ImageUploader)
end
