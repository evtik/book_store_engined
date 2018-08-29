feature 'Admin Review show page', :include_aasm_helpers do
  include_examples 'not authorized', :admin_review_path, 1

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given!(:book) { create(:book_with_authors_and_materials) }
    given!(:review) { create(:review, user: admin_user, book: book) }

    background { login_as(admin_user, scope: :user) }

    context 'review details' do
      scenario 'shows review details' do
        visit admin_review_path(review)

        [admin_user.email, book.title].each do |caption|
          expect(page).to have_link(caption)
        end

        [review.title, review.body[-1..-20]].each do |text|
          expect(page).to have_text(text)
        end
      end
    end

    context 'aasm actions' do
      include_context 'aasm review variables'

      params = review_config.merge(
        path_helper: :admin_review_path,
        resource_path: true
      )

      include_examples 'aasm actions', params do
        given(:entity) { review }
      end
    end
  end
end
