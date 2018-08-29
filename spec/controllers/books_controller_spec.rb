describe BooksController do
  describe 'GET show' do
    let!(:stored_book) { create(:book_with_reviews) }

    before do
      get :show, params: { id: stored_book }
    end

    it 'renders :show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns value to @book' do
      book = assigns(:book)
      expect(book).to be_truthy
      expect(book.authors.count).to be > 0
      expect(book.materials.count).to be > 0
      expect(book.approved_reviews.count).to eq(2)
    end
  end
end
