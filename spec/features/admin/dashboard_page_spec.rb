feature 'Admin dashboard page' do
  include_examples 'not authorized', :admin_root_path

  context 'with admin' do
    let(:admin_user) { create(:admin_user) }

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows dashbord page' do
      visit admin_root_path
      expect(page).to have_content(t('active_admin.dashboard'))
      expect(page).to have_content(t('active_admin.page.index.recent_orders'))
      expect(page).to have_content(t('active_admin.page.index.recent_reviews'))
    end

    scenario 'shows 10 most recent orders on dashboard page' do
      shipment = create(:shipment)
      create_list(:order, 11, shipment: shipment, customer: admin_user,
                              subtotal: 10.0)
      visit admin_root_path
      expect(page).to have_content('R00000011')
      expect(page).not_to have_content('R00000001')
      expect(page).to have_content('15.0', count: 10)
      expect(page).to have_content(
        /#{t('activerecord.attributes.order.state.in_progress')}/i, count: 10
      )
    end

    scenario 'shows 10 most recent reviews on dashboard page' do
      book = create(:book_with_authors_and_materials)
      another_book = create(:book_with_authors_and_materials)
      create(:review, book: another_book, user: admin_user)
      create_list(:review, 10, book: book, user: admin_user)
      visit admin_root_path
      expect(page).to have_content(book.title, count: 10)
      expect(page).not_to have_content(another_book.title)
      expect(page).to have_content(
        /#{t('activerecord.attributes.review.state.approved')}/i, count: 10
      )
    end
  end
end
