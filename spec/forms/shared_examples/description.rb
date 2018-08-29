shared_examples 'description' do |attribute|
  it { is_expected.to validate_presence_of(attribute) }

  it do
    is_expected.to allow_value(
      "Some **weird** *long* #{attribute}"
    ).for(attribute)
  end

  it { is_expected.to allow_value('Довільний опис').for(attribute) }

  it do
    is_expected.not_to allow_value(
      "Some <weird> long; #{attribute}"
    ).for(attribute)
  end

  it { is_expected.not_to allow_value('a' * 1001).for(attribute) }
end
