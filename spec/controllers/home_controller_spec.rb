require 'ecomm/factories'

describe HomeController do
  describe 'GET index' do
    before do
      get :index
    end

    it 'renders :index template' do
      expect(response).to render_template(:index)
    end

    context 'controller instance variables' do
      it 'assigns 3 latest books to @latest_books' do
        create_list(:book_with_authors_and_materials, 4)
        latest = assigns(:latest_books).object.query.to_a
        expect(latest).to be_an_instance_of(Array)
        expect(latest.length).to eq(3)
      end

      it 'assigns 4 most popular books to @most_popular_books' do
        create_list(:book_with_line_items, 4)
        popular = assigns(:most_popular_books).object.query.to_a
        expect(popular).to be_an_instance_of(Array)
        expect(popular.length).to eq(4)
      end
    end
  end
end
