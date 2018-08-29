module Reviews
  class CreateReview < Ecomm::BaseCommand
    def call(params, user)
      review = ReviewForm.from_params(params)
      if review.invalid?
        publish(:invalid, review,
                BookWithAssociated.new(params[:book_id]).first.decorate)
      else
        Review.create(review.attributes.merge(user: user))
        publish(:ok, I18n.t('reviews.form.success_message'))
      end
    end
  end
end
