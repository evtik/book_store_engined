describe MaterialForm, type: :form do
  context 'name' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value('Ivory').for(:name) }
    it { is_expected.to allow_value('Low-white').for(:name) }
    it { is_expected.to allow_value('Glossy paper').for(:name) }
    it { is_expected.to allow_value('Оксамит').for(:name) }
    it { is_expected.not_to allow_value('Paper/leather').for(:name) }
    it { is_expected.not_to allow_value('Fur 12').for(:name) }
    it { is_expected.not_to allow_value('a' * 16).for(:name) }
  end
end
