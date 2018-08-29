require 'ecomm/factories'
describe BooksSorter do
  context '#query' do
    context 'newest first' do
      it 'sorts books by their recency' do
        books = create_list(:book, 10)
        sorter = BooksSorter.new('sort_by' => 'created_at', 'order' => 'desc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse.map(&:title))
      end
    end

    context 'popular first' do
      let!(:books) do
        books = create_list(:book, 15)

        books[5..8].reverse_each.with_index do |book, i|
          book.line_items << create_list(:line_item, 5 - i,
                                         product: book, quantity: 4 - i)
        end

        books
      end

      let(:returned_books) do
        described_class.new('sort_by' => 'popular').query.to_a.map(&:id)
      end

      it 'returns ALL of the books, not only the ones ever ordered' do
        expect(returned_books.size).to eq(15)
      end

      context 'sorting order' do
        it 'ensures ever bought books to be the first ones' do
          set = books[5..8].reverse.map(&:id)
          expect(set).to eq(returned_books[0..3])
        end

        it 'arranges books by their line_items overall quantities (not count)' do
          books[9].line_items << create(:line_item, product: books[9],
                                                    quantity: 25)
          set = books[5..9].reverse.map(&:id)
          expect(set).to eq(returned_books[0..4])
        end
      end
    end

    context 'by price' do
      let!(:books) do
        books = []
        4.times { |n| books << create(:book, price: 1.0 + n) }
        books.map(&:title)
      end

      scenario 'sorts books by price from low to high' do
        sorter = BooksSorter.new('sort_by' => 'price', 'order' => 'asc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books)
      end

      scenario 'sorts books by price from high to low' do
        sorter = BooksSorter.new('sort_by' => 'price', 'order' => 'desc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse)
      end
    end

    context 'by title' do
      let!(:books) do
        books = []
        [*'a'..'f'].each do |char|
          books << create(:book, title: "#{char} title")
        end
        books.map(&:title)
      end

      scenario 'sorts books by title from a to z' do
        sorter = BooksSorter.new('sort_by' => 'title', 'order' => 'asc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books)
      end

      scenario 'sorts books by title from z to a' do
        sorter = BooksSorter.new('sort_by' => 'title', 'order' => 'desc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse)
      end
    end
  end
end
