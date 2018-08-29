class CategoryForm < Rectify::Form
  attribute(:name, String)

  validates(:name,
            presence: true,
            format: { with: /\A[\p{Alpha} \/-]*\z/ },
            length: { maximum: 30 })
end
