feature 'Admin Review index page', :include_aasm_helpers do
  include_context 'aasm review variables'

  include_examples 'not authorized', :admin_reviews_path

  let(:admin_user) { create(:admin_user) }

  context 'with admin' do
    context 'redirecting to review show page' do
      scenario 'click review link forwards to show page', use_selenium: true do
        review = create(:review, book: build(:book_with_authors_and_materials),
                                 user: admin_user)
        login_as(admin_user, scope: :user)
        visit admin_reviews_path
        click_link(review.title[0..10])
        expect(page).to have_text(review.body[-1..-20])
      end
    end

    context 'reviews list' do
      let(:book) { create(:book_with_authors_and_materials) }

      background do
        aasm_states.each_with_index do |state, index|
          create_list(:review, index + 1, book: book, user: admin_user,
                                          state: state)
        end
        login_as(admin_user, scope: :user)
        visit admin_reviews_path
      end

      scenario 'shows list of reviews with proper states', use_selenium: true do
        {
          book.title => 6,
          state_label(state_tr_prefix, :rejected) => 3,
          state_label(state_tr_prefix, :approved) => 2,
          state_label(state_tr_prefix, :unprocessed) => 1
        }.each { |key, value| expect(page).to have_text(key, count: value) }
      end

      context 'filters' do
        scenario 'shows review list filters' do
          [
            'All (6)',
            t("#{state_tr_prefix}rejected") + ' (3)',
            t("#{state_tr_prefix}approved") + ' (2)',
            t("#{state_tr_prefix}unprocessed") + ' (1)'
          ].each do |text|
            expect(page).to have_css('.table_tools_button', text: text)
          end
        end

        include_examples 'active admin filters',
                         filters: Review.aasm.states.map(&:name),
                         entity: :reviews
      end
    end

    context 'aasm actions' do
      background { login_as(admin_user, scope: :user) }

      params = review_config.merge(
        path_helper: :admin_reviews_path,
        resource_path: false
      )

      include_examples 'aasm actions', params do
        given(:entity) do
          create(:review, book: build(:book_with_authors_and_materials),
                          user: admin_user)
        end
      end
    end
  end
end
