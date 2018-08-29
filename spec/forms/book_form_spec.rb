describe BookForm, type: :form do
  context 'title' do
    include_examples 'title'
  end

  context 'description' do
    include_examples 'description', :description
  end

  context 'year' do
    it do
      is_expected.to(validate_numericality_of(:year)
        .only_integer
        .is_greater_than(Date.today.years_ago(30).year)
        .is_less_than_or_equal_to(Date.today.year))
    end
  end

  context 'height' do
    it do
      is_expected.to(validate_numericality_of(:height)
        .is_greater_than(7).is_less_than(16))
    end
  end

  context 'width' do
    it do
      is_expected.to(validate_numericality_of(:width)
        .is_greater_than(3)
        .is_less_than(8))
    end
  end

  context 'thickness' do
    it do
      is_expected.to(validate_numericality_of(:thickness)
        .is_greater_than(0)
        .is_less_than(4))
    end
  end

  context 'custom validators' do
    context '#must_have_category' do
      it 'book without category is invalid' do
        book = described_class.from_model(build(:book)).tap(&:valid?)

        expect(book.errors[:base]).to include(
          I18n.t('.activerecord.errors.models.book.empty_category')
        )
      end

      it 'book with category is valid' do
        book_params = attributes_for(:book).merge(category_id: 1)
        book = described_class.from_params(book_params).tap(&:valid?)

        expect(book.errors[:base]).not_to include(
          I18n.t('.activerecord.errors.models.book.empty_category')
        )
      end
    end

    context '#must_have_authors' do
      it 'book without authors is invalid' do
        book = described_class.from_model(build(:book)).tap(&:valid?)

        expect(book.errors[:base]).to include(
          I18n.t('.activerecord.errors.models.book.empty_authors')
        )
      end

      it 'book with authors is valid' do
        book_params = attributes_for(:book).merge(author_ids: ['', 1])
        book = described_class.from_params(book_params).tap(&:valid?)

        expect(book.errors[:base]).not_to include(
          I18n.t('.activerecord.errors.models.book.empty_authors')
        )
      end
    end

    context '#must_have_materials' do
      it 'book without materials is invalid' do
        book = described_class.from_model(build(:book)).tap(&:valid?)

        expect(book.errors[:base]).to include(
          I18n.t('.activerecord.errors.models.book.empty_materials')
        )
      end

      it 'book with materials is valid' do
        book_params = attributes_for(:book).merge(material_ids: [2, 5])
        book = described_class.from_params(book_params).tap(&:valid?)

        expect(book.errors[:base]).not_to include(
          I18n.t('.activerecord.errors.models.book.empty_materials')
        )
      end
    end
  end
end
