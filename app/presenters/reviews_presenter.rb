class ReviewsPresenter < Rectify::Presenter
  def initialize
    @reviewers_names = {}
  end

  def reviewer_name(user)
    @reviewers_names[user.id] ||= construct_name(user)
  end

  def verified_reviewer?(book, user_id)
    book.line_items.find { |line_item| line_item.order.customer.id == user_id }
  end

  private

  def construct_name(user)
    address = user.billing_address
    address ? address.first_name << ' ' << address.last_name : mask(user.email)
  end

  def mask(email)
    email.first << email.gsub(/.+@/, '*******@')
  end
end
