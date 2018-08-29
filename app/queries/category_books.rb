class CategoryBooks < Rectify::Query
  def initialize(category_id = nil)
    @category_id = category_id
  end

  def query
    return Book.all unless @category_id
    Book.where(category_id: @category_id)
  end
end
