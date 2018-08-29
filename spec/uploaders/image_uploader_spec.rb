describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:book) { create(:book_with_authors_and_materials) }
  let(:uploader) { ImageUploader.new(book, :main_image) }

  around do |example|
    ImageUploader.enable_processing = true
    File.open(File.join(Rails.root, 'spec', 'fixtures', '31.jpg')) do |file|
      uploader.store!(file)
    end

    example.run

    ImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'thumb version' do
    it 'scales down image to fit within 70x70 pixels' do
      expect(uploader.thumb).to be_no_larger_than(70, 70)
    end
  end

  context 'small version' do
    it 'scales down image to fit within 120x120 pixels' do
      expect(uploader.small).to be_no_larger_than(120, 120)
    end
  end

  it 'has correct format' do
    expect(uploader).to be_format('jpeg')
  end
end
