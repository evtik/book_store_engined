require 'ecomm/factories'

feature 'Home page' do
  given!(:books) { create_list(:book_with_line_items, 4) }

  context 'with guest or logged in user' do
    background do
      visit root_path
    end

    scenario 'has brand' do
      expect(page).to have_css('.navbar-brand', text: t('layouts.header.brand'))
    end

    scenario 'has shop links' do
      expect(page).to have_link(t('layouts.header.shop'))
      expect(page).to have_link('Mobile Development', visible: false)
      expect(page).to have_link('Web Development', visible: false)
      expect(page).to have_link('Photo', visible: false)
      expect(page).to have_link('Web Design', visible: false)
    end

    context 'carousel slider' do
      scenario 'has 3 newest books' do
        expect(page).to have_css('.carousel-inner .item',
                                 visible: false, count: 3)
      end

      scenario 'has newest book as active item' do
        expect(page).to have_css(
          '.carousel-inner .item.active h1', text: books.last.title
        )
      end

      scenario 'click on buy now adds book to cart' do
        first(:link, t('home.carousel_book.buy_now')).click
        expect(page).to have_css(
          '.visible-xs .shop-quantity', visible: false, text: '1'
        )
        expect(page).to have_css('.hidden-xs .shop-quantity', text: '1')
      end
    end

    scenario 'get started navigates to catalog' do
      click_link(t('home.index.get_started'))
      expect(page).to have_css('h1', text: t('catalog.index.caption'))
    end

    context 'bestsellers' do
      scenario 'has caption' do
        expect(page).to have_css('h3', text: t('home.index.best_sellers'))
      end

      scenario 'has 4 items' do
        expect(page).to have_css('.general-thumb-wrap', count: 4)
      end

      scenario 'click on view button navigates to book page' do
        first('.thumb-hover-link', visible: false).click
        expect(page.current_path).to match(/\/books\//)
      end

      scenario 'click on cart button adds book to cart' do
        all('.thumb-hover-link', visible: false)[1].click
        expect(page).to have_css(
          '.visible-xs .shop-quantity', visible: false, text: '1'
        )
        expect(page).to have_css('.hidden-xs .shop-quantity', text: '1')
      end
    end

    context 'footer' do
      scenario 'has social media links' do
        within(:css, 'footer') do
          expect(page).to have_link(nil, href: 'https://twitter.com')
          expect(page).to have_link(nil, href: 'https://www.facebook.com')
          expect(page).to have_link(nil, href: 'https://plus.google.com')
          expect(page).to have_link(nil, href: 'https://www.instagram.com')
        end
      end
    end
  end

  context 'with guest user' do
    background do
      visit root_path
    end

    scenario 'has login/signup links' do
      expect(page).to have_link(t('layouts.login.login'))
      expect(page).to have_link(t('layouts.login.signup'))
      expect(page).not_to have_link(t('layouts.header.account'))
    end

    scenario 'has no my account links in header' do
      expect(page).not_to have_css(
        'header a', text: t('layouts.header.account')
      )
      expect(page).not_to have_css(
        'header a', text: t('layouts.my_account.orders')
      )
      expect(page).not_to have_css(
        'header a', text: t('layouts.my_account.settings')
      )
      expect(page).not_to have_css(
        'header a', text: t('layouts.my_account.logout')
      )
    end

    scenario 'has no orders and settings links in footer' do
      expect(page).not_to have_css(
        'footer a', text: t('layouts.my_account.orders')
      )
      expect(page).not_to have_css(
        'footer a', text: t('layouts.my_account.settings')
      )
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }

    background do
      login_as(user, scope: :user)
      visit root_path
    end

    scenario 'has no login/signup links' do
      expect(page).not_to have_link(t('layouts.login.login'))
      expect(page).not_to have_link(t('layouts.login.signup'))
      expect(page).to have_css(
        'a.dropdown-toggle', text: (t 'layouts.header.account')
      )
    end

    scenario 'has my account links in header' do
      expect(page).to have_css(
        'header a', text: t('layouts.header.account')
      )
      expect(page).to have_css(
        'header a', visible: false, text: t('layouts.my_account.orders')
      )
      expect(page).to have_css(
        'header a', visible: false, text: t('layouts.my_account.settings')
      )
      expect(page).to have_css(
        'header a', visible: false, text: t('layouts.my_account.logout')
      )
    end

    scenario 'has orders and settings links in footer' do
      expect(page).to have_css(
        'footer a', text: t('layouts.my_account.orders')
      )
      expect(page).to have_css(
        'footer a', text: t('layouts.my_account.settings')
      )
    end

    scenario 'has no admin panel link in my account section' do
      expect(page).not_to have_css(
        'header a', visible: false,
                    text: t('layouts.my_account.admin_panel')
      )
    end
  end

  context 'with admin user' do
    given!(:user) { create(:admin_user) }

    background do
      login_as(user, scope: :user)
      visit root_path
    end

    scenario 'has admin panel link in my account section' do
      expect(page).to have_css(
        'header a', visible: false,
                    text: t('layouts.my_account.admin_panel')
      )
    end

    scenario 'has no orders and settings links in header' do
      expect(page).not_to have_css(
        'header a', visible: false, text: t('layouts.my_account.orders')
      )
      expect(page).not_to have_css(
        'header a', visible: false, text: t('layouts.my_account.settings')
      )
    end

    scenario 'has no orders and settings links in footer' do
      expect(page).not_to have_css(
        'footer a', text: t('layouts.my_account.orders')
      )
      expect(page).not_to have_css(
        'footer a', text: t('layouts.my_account.settings')
      )
    end
  end
end
