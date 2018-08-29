describe Book do
  context 'association' do
    it { is_expected.to have_and_belong_to_many(:authors) }
    it { is_expected.to have_and_belong_to_many(:materials) }
  end
end
