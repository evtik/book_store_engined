describe Category do
  context 'association' do
    it { is_expected.to have_many(:books) }
  end
end
