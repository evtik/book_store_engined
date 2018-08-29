describe Reviews::CreateReview do
  describe '#call' do
    let(:user) { create(:user) }
    let(:book) { create(:book_with_authors_and_materials) }

    context 'with invalid review data' do
      let(:params) do
        attributes_for(:review, user: nil, title: '').merge(book_id: book.id)
      end

      it 'publishes :invalid event along with review and book' do
        expect { subject.call(params, user) }.to publish(
          :invalid, instance_of(ReviewForm), instance_of(BookDecorator)
        )
      end

      it 'does not create new review in db' do
        expect { subject.call(params, user) }.not_to change(Review, :count)
      end
    end

    context 'with valid review data' do
      let(:params) do
        attributes_for(:review, user: nil).merge(book_id: book.id)
      end

      it 'publishes :ok event passing in success message' do
        expect { subject.call(params, user) }.to publish(
          :ok, I18n.t('reviews.form.success_message')
        )
      end

      it 'creates new review in db' do
        expect { subject.call(params, user) }.to change(Review, :count).by(1)
      end
    end
  end
end
