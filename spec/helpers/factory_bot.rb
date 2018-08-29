module FactoryBot
  module Syntax
    module Methods
      def image_path(name)
        Rack::Test::UploadedFile.new(
          File.join(Rails.root, 'spec', 'fixtures', "#{name}.jpg"), 'image/jpg'
        )
      end

      def load_images(names)
        return image_path(names) unless names.instance_of?(Array)
        names.map { |name| image_path(name) }
      end
    end
  end
end
