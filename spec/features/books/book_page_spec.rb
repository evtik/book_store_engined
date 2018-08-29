require_relative '../../support/forms/new_review_form'

feature 'Book page' do
  shared_examples 'add to cart' do
    scenario 'click add to cart adds books to cart' do
      click_button(t('books.book_details.add_to_cart'))
      expect(page).to have_css(
        '.visible-xs .shop-quantity',
        visible: false, text: '1'
      )
      expect(page).to have_css('.hidden-xs .shop-quantity', text: '1')
    end
  end

  context "'back to results' link", use_selenium: true do
    background do
      create_list(:book_with_authors_and_materials, 4)
    end

    scenario 'returns to home page' do
      visit root_path
      first('.fa-eye.thumb-icon').click
      click_button(t('books.book_details.add_to_cart'))
      click_link(t('books.book_details.back_to_results'))
      expect(page).to have_text(t('home.index.welcome'))
    end

    scenario 'returns to catalog page' do
      visit catalog_index_path
      first('.fa-eye.thumb-icon').click
      click_button(t('books.book_details.add_to_cart'))
      click_link(t('books.book_details.back_to_results'))
      expect(page).to have_text(t('catalog.index.caption'))
    end
  end

  context 'without reviews' do
    given!(:book) do
      create(:book_with_authors_and_materials,
             description: Faker::Hipster.paragraph(20)[0..990])
    end

    background { visit book_path(book) }

    scenario 'has book title' do
      expect(page).to have_css('h1', text: book.title)
    end

    scenario 'has authors with their full names' do
      expect(page).to have_css(
        'p.in-grey-600.small', text: book.decorate.authors_full
      )
    end

    scenario 'has book price' do
      expect(page).to have_css('p.h1', text: book.price)
    end

    context 'quantity controls' do
      scenario 'has defualt value of 1' do
        expect(find_field("quantities-#{book.id}").value).to eq('1')
      end

      scenario 'clicked plus button adds 1 to quantity', use_selenium: true do
        find("a.quantity-increment[data-target='quantities-#{book.id}']").click
        expect(find_field("quantities-#{book.id}").value).to eq('2')
      end

      context 'clicked minus button', use_selenium: true do
        scenario 'subtract 1 from quantity if it is greater than 1' do
          3.times do
            find("a.quantity-increment[data-target='quantities-#{book.id}']")
              .click
          end
          find("a.quantity-decrement[data-target='quantities-#{book.id}']")
            .click
          expect(find_field("quantities-#{book.id}").value).to eq('3')
        end

        scenario 'does not subtract 1 from quatity if it is 1' do
          find("a.quantity-decrement[data-target='quantities-#{book.id}']")
            .click
          expect(find_field("quantities-#{book.id}").value).to eq('1')
        end
      end
    end

    include_examples 'add to cart'

    scenario 'has book publication year' do
      expect(page).to have_css('p.general-item-info', text: book.year)
    end

    scenario 'has book dimensions' do
      expect(page).to have_css(
        'p.general-item-info', text: book.decorate.dimensions
      )
    end

    scenario 'has book materials' do
      expect(page).to have_css(
        'p.general-item-info', text: book.decorate.materials_string
      )
    end

    context 'description' do
      scenario 'has description paragraph' do
        expect(page).to have_css(
          '#book-description', text: book.description[0..100]
        )
      end

      scenario 'has read more button', use_selenium: true do
        expect(page).to have_link(t('books.book_details.read_more'))
      end

      scenario 'clicked read more link shows read less', use_selenium: true do
        click_link(t('books.book_details.read_more'))
        expect(page).to have_link(t('books.book_details.read_less'))
      end

      scenario 'has empty reviews header' do
        expect(page).to have_css(
          'h3', text: "#{t 'books.book_reviews.reviews'} (0)"
        )
      end
    end

    context 'with guest user' do
      scenario 'click write review redirects to login page' do
        click_link(t('books.book_reviews.write_review'))
        expect(page).to have_content(t('devise.failure.unauthenticated'))
      end
    end
  end

  context 'with reviews' do
    given(:user) do
      user = build(:user, email: 'yyy@gmail.com')
      user.addresses << build(:address, first_name: 'John', last_name: 'Doe')
      user.save
      user
    end

    given(:another_user) { create(:user, email: 'zzz@gmail.com') }

    given!(:book) do
      book = build(:book_with_authors_and_materials)
      book.reviews << [build(:review, user: user),
                       build(:review, user: another_user)]
      book.save
      book
    end

    background do
      visit book_path(book)
    end

    scenario 'has review header with reviews count' do
      expect(page).to have_css(
        'h3', text: "#{t 'books.book_reviews.reviews'} (2)"
      )
    end

    scenario "has user's first name's first letter in circle image" do
      expect(page).to have_css('.img-circle', text: 'J')
      expect(page).not_to have_css('.img-circle', text: 'y')
    end

    scenario "has user's email's first letter when no first name exists" do
      expect(page).to have_css('.img-circle', text: 'z')
    end

    scenario "has users's first and last name in review header",
             use_selenium: true do
      expect(page).to have_css('h4.media-heading', text: 'John Doe')
    end

    scenario "has users's masked email in review header when names not given",
             use_selenium: true do
      expect(page).to have_css('h4.media-heading', text: 'z*******@gmail.com')
    end

    scenario 'has markdown in reviews' do
      expect(page).to have_css('em', text: 'italic text')
      expect(page).to have_css('strong', text: 'bold text')
    end
  end

  context 'with review verified by user' do
    given!(:book) do
      book = create(:book_with_reviews, reviews_count: 1)
      line_item = create(:line_item, product_id: 1)
      order = create(:order)
      order.line_items << line_item
      user = User.first
      user.orders << order
      user.save
      book
    end

    scenario 'it has verified reviewer mark' do
      visit book_path(book)
      expect(page).to have_css(
        '.general-message-verified',
        text: t('books.book_reviews.verified_reviewer')
      )
    end
  end

  context 'write review' do
    given!(:user) { create(:user) }
    given!(:book) { create(:book_with_authors_and_materials) }
    given(:new_review_form) { NewReviewForm.new }

    background do
      login_as(user, scope: :user)
      visit book_path(book)
    end

    scenario 'with valid review data shows success message' do
      new_review_form.visit_page.fill_in_with(attributes_for(:review)).submit
      expect(page).to have_content(t('reviews.form.success_message'))
    end

    context 'with invalid review data' do
      background do
        new_review_form.visit_page.fill_in_with(
          attributes_for(:review, body: nil)
        ).submit
      end

      scenario 'shows review form errors' do
        expect(page).to have_content(t('errors.messages.blank'))
      end

      context "and then click on 'Add to cart'" do
        include_examples 'add to cart'

        scenario 'redirects back to new review' do
          click_button(t('books.book_details.add_to_cart'))
          expect(page).to have_field('review_title')
        end
      end
    end
  end
end
