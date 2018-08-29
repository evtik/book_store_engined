feature 'Catalog page' do
  context 'with less than 12 available books' do
    given(:categories) do
      ['All', 'Mobile Development', 'Photo',
       'Web Design', 'Web Development']
    end

    background do
      create_list(:book_with_authors_and_materials, 4)
      visit catalog_index_path
    end

    scenario 'has catalog filter links' do
      categories.each do |category|
        expect(page).to have_css('a.filter-link', text: category)
      end
    end

    scenario 'has catalog filter dropdown in xs layout' do
      categories.each do |category|
        expect(page).to have_css(
          '.visible-xs ul.dropdown-menu li a',
          visible: false, text: category
        )
      end
    end

    scenario 'has 4 book items' do
      expect(page).to have_css('.general-thumb-wrap', count: 4)
    end

    context 'click on category link' do
      scenario 'makes it rendered with bold' do
        find('a.filter-link', text: 'Mobile Development').click
        expect(page).to have_css('a.filter-link b', text: 'Mobile Development')
      end

      scenario 'only leaves books of that category on page' do
        find('a.filter-link', text: 'Photo').click
        expect(page).to have_css('.general-thumb-wrap', count: 1)
      end
    end

    context 'click on category menu item in xs layout' do
      scenario 'makes it current menu item' do
        find('.visible-xs a.dropdown-toggle.dropdown-btn',
             visible: false, text: 'All').click
        find('.visible-xs ul.dropdown-menu li a',
             visible: false, text: 'Web Development').click
        expect(page).to have_css(
          '.visible-xs a.dropdown-toggle',
          visible: false, text: 'Web Development'
        )
      end

      scenario 'only leaves books of that category on page' do
        find('.visible-xs a.dropdown-toggle.dropdown-btn',
             visible: false, text: 'All').click
        find('.visible-xs ul.dropdown-menu li a',
             visible: false, text: 'Web Design').click
        expect(page).to have_css('.general-thumb-wrap', count: 1)
      end
    end

    scenario 'has no view more button' do
      expect(page).not_to have_link(t('catalog.index.view_more'))
    end
  end

  context 'with more than 12 available books' do
    before do
      create_list(:book_with_authors_and_materials, 20)
      visit catalog_index_path
    end

    scenario 'has view more button' do
      expect(page).to have_link(t('catalog.index.view_more'))
    end
  end
end
