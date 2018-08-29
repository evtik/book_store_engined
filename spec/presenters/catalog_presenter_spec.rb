include AbstractController::Translation

describe CatalogPresenter do
  describe '#more_books?' do
    context 'with no filter on category' do
      it 'with available books number less or equal limit returns false' do
        presenter = described_class.new(
          params: ActionController::Parameters.new,
          categories: [['all', 10]]
        )
        expect(presenter.more_books?).to be false
      end

      it 'with available books number more than limit returns true' do
        presenter = described_class.new(
          params: ActionController::Parameters.new(limit: 20),
          categories: [['all', 25]]
        )
        expect(presenter.more_books?).to be true
      end
    end

    context 'with category filter set' do
      it 'with available books number less or equal limit returns false' do
        presenter = described_class.new(
          params: ActionController::Parameters.new(limit: 20, category: '1'),
          categories: [['all', 60], [['a', 1], 20], [['b', 2], 40]]
        )
        expect(presenter.more_books?).to be false
      end

      it 'with available books number more than limit returns true' do
        presenter = described_class.new(
          params: ActionController::Parameters.new(limit: 20, category: '2'),
          categories: [['all', 60], [['a', 1], 20], [['b', 2], 40]]
        )
        expect(presenter.more_books?).to be true
      end
    end
  end

  describe '#find_category' do
    subject do
      described_class.new(
        categories: [['all', 60], [['a', 3], 20], [['b', 7], 40]]
      )
    end

    it 'returns category when given category id' do
      expect(subject.find_category(3)).to eq([['a', 3], 20])
    end

    it "returns 'all' (nil.to_i = 0) pseudo category when no id given" do
      expect(subject.find_category(0)).to eq(['all', 60])
    end
  end

  describe '#current_category?' do
    let(:categories) do
      [['all', 10], [['a', 1], 1], [['b', 2], 2], [['c', 3], 3],
       [['d', 4], 4]]
    end

    context 'with category id not present in params' do
      subject do
        described_class.new(
          params: ActionController::Parameters.new,
          categories: categories
        )
      end

      it "only returns true for 'all' pseudo category" do
        expect(subject.current_category?(nil)).to be true
      end

      it 'returns false for any other category' do
        [1..4].each { |id| expect(subject.current_category?(id)).to be false }
      end
    end

    context 'with category id in params' do
      subject do
        described_class.new(
          params: ActionController::Parameters.new(category: '1'),
          categories: categories
        )
      end

      it "returns false for 'all' pseudo category" do
        expect(subject.current_category?(nil)).to be false
      end

      it 'only returns true for category with id from params' do
        expect(subject.current_category?(1)).to be true
      end

      it 'returns false for any other category' do
        [2..4].each { |id| expect(subject.current_category?(id)).to be false }
      end
    end
  end

  describe '#current_sorter' do
    it 'with no sorting values in params return default filter & sorting' do
      presenter = described_class.new
      expect(presenter.current_sorter).to eq(
        t('catalog.catalog_sorters.newest')
      )
    end

    it 'with particular values in params returns corresponding filter & sorting' do
      presenter = described_class.new(
        params: ActionController::Parameters.new(
          sort_by: 'price',
          order: 'desc').permit!
      )
      expect(presenter.current_sorter).to eq(
        t('catalog.catalog_sorters.price_high')
      )
    end
  end

  describe '#current_limit' do
    it 'with no limit value present in params returns 12' do
      presenter = described_class.new(params: ActionController::Parameters.new)
      expect(presenter.current_limit).to eq(12)
    end

    it 'with limit value present in params returns it' do
      presenter = described_class.new(
        params: ActionController::Parameters.new(limit: 36)
      )
      expect(presenter.current_limit).to eq(36)
    end
  end
end
