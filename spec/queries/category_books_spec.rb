describe CategoryBooks do
  context '#query' do
    it 'filters out books by given category name' do
      books = []
      [*'a'..'d'].each do |char|
        books << create(:book_with_authors_and_materials,
                        title: "#{char} title")
      end
      books = books.map(&:title)
      returned_books = CategoryBooks.new(2).query.to_a.map(&:title)
      expect(returned_books.length).to eq(1)
      expect(returned_books.first).to eq('b title')
    end

    it 'returns all books if category not given' do
      books = create_list(:book_with_authors_and_materials, 4).map(&:title)
      returned_books = CategoryBooks.new.query.to_a.map(&:title)
      expect(returned_books).to match_array(books)
    end
  end
end
