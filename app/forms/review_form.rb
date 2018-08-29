class ReviewForm < Rectify::Form
  attribute(:score, Integer)
  attribute(:title, String)
  attribute(:body, String)
  attribute(:book_id, Integer)

  REGEXP = /\A([\p{Alnum}.,!#$%&'*+-\/=?^_`{|}~\s])+\z/

  validates(:title,
            presence: true,
            format: { with: REGEXP },
            length: { maximum: 80 })

  validates(:body,
            presence: true,
            format: { with: REGEXP },
            length: { maximum: 1000 })
end
