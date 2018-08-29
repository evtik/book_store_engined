class BookForm < Rectify::Form
  attribute(:title, String)
  attribute(:category_id, Integer)
  attribute(:main_image, String)
  attribute(:images, String)
  attribute(:description, String)
  attribute(:year, Integer)
  attribute(:height, Integer)
  attribute(:width, Integer)
  attribute(:thickness, Integer)
  attribute(:price, Decimal)
  attribute(:author_ids, Array[Integer])
  attribute(:material_ids, Array[Integer])

  REGEXP = /\A([\p{Alnum}.,!#$%&'*+-\/=?^_`{|}~\s])+\z/

  validate(:must_have_category, :must_have_authors, :must_have_materials)

  validates(:title,
            presence: true,
            format: { with: REGEXP },
            length: { maximum: 80 })
  validates(:description,
            presence: true,
            format: { with: REGEXP },
            length: { maximum: 1000 })
  validates(:year, numericality: {
              only_integer: true,
              greater_than: Date.today.years_ago(30).year,
              less_than_or_equal_to: Date.today.year
            })
  validates(:height, numericality: {
              greater_than: 7,
              less_than: 16
            })
  validates(:width, numericality: {
              greater_than: 3,
              less_than: 8
            })
  validates(:thickness, numericality: {
              greater_than: 0,
              less_than: 4
            })
  validates(:price, numericality: {
              greater_than_or_equal_to: 0.50,
              less_than_or_equal_to: 199.95
            })

  def must_have_category
    errors.add(:base, tr('.empty_category')) if category_id.blank?
  end

  def must_have_authors
    errors.add(:base, tr('.empty_authors')) if author_ids.all?(&:blank?)
  end

  def must_have_materials
    errors.add(:base, tr('.empty_materials')) if material_ids.all?(&:blank?)
  end

  private

  def tr(arg)
    I18n.t('.activerecord.errors.models.book' + arg)
  end
end
