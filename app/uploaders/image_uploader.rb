class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  configure do |config|
    config.remove_previously_stored_files_after_update = false
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'https://s3.eu-central-1.amazonaws.com/sybse/images/' +
      [version_name, 'default.jpg'].compact.join('_')
  end

  process(resize_to_fit: [550, 550])

  version(:thumb) do
    process(resize_to_fit: [70, 70])
  end

  version(:small) do
    process(resize_to_fit: [120, 120])
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
