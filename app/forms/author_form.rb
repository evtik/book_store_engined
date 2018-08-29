class AuthorForm < Rectify::Form
  attribute(:first_name, String)
  attribute(:last_name, String)
  attribute(:description, String)

  NAME_REGEXP = /\A[\p{Alpha} `-]+\z/
  DESCRIPTION_REGEXP = /\A([\p{Alnum}!#$%&'*+-\/=?^_`{|}~\s])+\z/

  %i(first_name last_name).each do |field|
    validates(field,
              presence: true,
              format: { with: NAME_REGEXP },
              length: { maximum: 30 })
  end

  validates(:description,
            presence: true,
            format: { with: DESCRIPTION_REGEXP },
            length: { maximum: 1000 })
end
