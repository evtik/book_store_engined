describe ReviewsController do
  context 'with logged in user' do
    let(:user) { create(:user) }
    let(:book) { create(:book_with_authors_and_materials) }

    before { sign_in(user) }

    context 'GET index' do
      it 'ensures flash to keep its state' do
        expect_any_instance_of(ActionDispatch::Flash::FlashHash).to receive(:keep)
        get :index, params: { book_id: 1 }
      end

      it 'redirects to new book review path' do
        get :index, params: { book_id: 1 }
        expect(response).to redirect_to(new_book_review_path(1))
      end
    end

    context 'GET new' do
      before { get :new, params: { book_id: book } }

      it 'renders :new template' do
        expect(response).to render_template(:new)
      end

      it 'assigns values to @book and @review' do
        expect(assigns(:book)).to be_truthy
        expect(assigns(:review)).to be_truthy
      end
    end

    context 'POST create' do
      context 'with valid data' do
        let(:valid_data) { attributes_for(:review) }

        it 'creates new review in database' do
          expect {
            post :create, params: { book_id: book, review: valid_data }
          }.to change(Review, :count).by(1)
        end

        it 'redirects to book page' do
          post :create, params: { book_id: book, review: valid_data }
          expect(response).to redirect_to(book_path(book))
        end
      end

      context 'with invalid data' do
        let(:invalid_data) { attributes_for(:review, title: '') }

        it 'does not create new review in database' do
          expect {
            post :create, params: { book_id: book, review: invalid_data }
          }.not_to change(Review, :count)
        end

        it 'renders :new template' do
          post :create, params: { book_id: book, review: invalid_data }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  context 'with guest user' do
    it 'GET :new redirects to login page' do
      get :new, params: { book_id: 1 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'POST :create redirects to login page' do
      post :create, params: { book_id: 1 }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
