shared_examples 'title' do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to allow_value('Book #3').for(:title) }
  it { is_expected.to allow_value('Лихобор').for(:title) }
  it { is_expected.not_to allow_value('<Book> #3').for(:title) }
  it { is_expected.not_to allow_value('a' * 81).for(:title) }
end
