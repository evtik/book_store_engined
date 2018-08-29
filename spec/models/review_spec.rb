describe Review do
  context 'associtation' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
  end
end
