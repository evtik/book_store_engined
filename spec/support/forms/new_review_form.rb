class NewReviewForm
  include AbstractController::Translation
  include Capybara::DSL

  def visit_page
    click_on(t('books.book_reviews.write_review'))
    self
  end

  def fill_in_with(params)
    find("#star-#{params[:score]}").click
    fill_in('review_title', with: params[:title])
    fill_in('review_body', with: params[:body])
    self
  end

  def submit
    click_on(t('reviews.form.post'))
  end
end
