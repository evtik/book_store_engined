class BookWithAssociated < Rectify::Query
  def initialize(id, options = {})
    @id = id
    @load_reviews = options[:load_reviews]
  end

  def query
    books = Book.where(id: @id).includes(:authors, :materials)
    return books unless @load_reviews
    books.includes(
      line_items: [order: :customer],
      approved_reviews: [user: :billing_address]
    )
  end
end
