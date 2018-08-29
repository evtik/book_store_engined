class MaterialForm < Rectify::Form
  attribute(:name, String)

  validates(:name,
            presence: true,
            format: { with: /\A[\p{Alpha} -]*\z/ },
            length: { maximum: 15 })
end
