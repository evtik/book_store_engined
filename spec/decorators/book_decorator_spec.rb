describe BookDecorator do
  let(:book) do
    book = build(:book, height: 7, width: 4, thickness: 1)
    book.authors << build(:author, first_name: 'Marcellus', last_name: 'Wallace')
    book.authors << build(:author, first_name: 'Vincent', last_name: 'Vega')
    book.materials << build(:material, name: 'Leather')
    book.materials << build(:material, name: 'Glossy paper')
    book.decorate
  end

  it '#authors_short returns authors names with initials sorted by last name' do
    expect(book.authors_short).to eq('V. Vega, M. Wallace')
  end

  it '#authors_full returns full authors names sorted by last name' do
    expect(book.authors_full).to eq('Vincent Vega, Marcellus Wallace')
  end

  it '#materials_string returns coma separated sorted book materails string' do
    expect(book.materials_string).to eq('Glossy paper, leather')
  end

  it '#dimensions returns dimensions string' do
    expect(book.dimensions).to eq('H: 7" x W: 4" x D: 1"')
  end
end
