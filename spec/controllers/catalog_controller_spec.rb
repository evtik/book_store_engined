describe CatalogController do
  describe 'GET index' do
    before do
      get :index
    end

    it 'renders :index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns value to @books' do
      stored_books = create_list(:book_with_authors_and_materials, 4)
                     .map(&:title)
      books = assigns(:books).object.query.to_a.map(&:title)
      expect(books).to match_array(stored_books)
    end
  end
end
