describe Common::GetCategoriesWithCounters do
  context '#call' do
    it 'returns array of categeroies with their ids and books count' do
      ['mobile development',
       'photo',
       'web design',
       'web development'].each_with_index do |name, index|
        category = build(:category, name: name)
        category.books << build_list(:book_with_authors_and_materials,
                                     index + 1)
        category.save
      end

      expect(described_class.call).to eq(
        [
          [['all'], 10],
          [['mobile development', 1], 1],
          [['photo', 2], 2],
          [['web design', 3], 3],
          [['web development', 4], 4]
        ]
      )
    end
  end
end
