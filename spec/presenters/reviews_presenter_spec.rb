describe ReviewsPresenter do
  describe '#reviewer_name' do
    let(:user) { build(:user, email: 'my@email.com') }

    it 'returns masked user email when no names exist' do
      expect(subject.reviewer_name(user)).to eq('m*******@email.com')
    end

    it "returns user's first and last names if they exist" do
      user.billing_address = build(:address, first_name: 'Phil',
                                             last_name: 'Ivey')
      expect(subject.reviewer_name(user)).to eq('Phil Ivey')
    end
  end

  describe '#verified_reviewer?' do
    let!(:book) { create(:book_with_reviews, reviews_count: 1) }

    it 'returns falsey value (nil) if book wasn`t bought by this user' do
      expect(subject.verified_reviewer?(book, 1)).to be_falsey
    end

    it 'returns truthy (LineItem instance) if book was ever bought by user' do
      user = User.first
      order = build(:order, customer: user)
      order.line_items << build(:line_item, product: book)
      user.orders << order
      user.save
      expect(subject.verified_reviewer?(book, 1)).to be_truthy
    end
  end
end
