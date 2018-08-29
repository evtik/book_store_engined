class ReviewsController < ApplicationController
  include Rectify::ControllerHelpers

  before_action(:authenticate_user!)

  def index
    flash.keep
    redirect_to new_book_review_path(params[:book_id])
  end

  def new
    @book = BookWithAssociated.new(params[:book_id]).first.decorate
    @review = ReviewForm.new(book_id: @book.id, score: 0)
  end

  def create
    Reviews::CreateReview.call(params, current_user) do
      on(:invalid) do |review, book|
        expose(review: review, book: book)
        render('new')
      end

      on(:ok) { |note| redirect_to book_path(params[:book_id]), notice: note }
    end
  end
end
