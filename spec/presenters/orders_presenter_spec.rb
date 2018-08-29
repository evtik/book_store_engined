describe OrdersPresenter do
  describe '#current_orders_filter' do
    it "returns 'all' filter with no filter present in params" do
      presenter = described_class.new(
        params: ActionController::Parameters.new
      )
      expect(presenter.current_orders_filter).to eq('all')
    end

    it 'returns orders filter from params' do
      presenter = described_class.new(
        params: ActionController::Parameters.new(filter: 'foo')
      )
      expect(presenter.current_orders_filter).to eq('foo')
    end
  end
end
