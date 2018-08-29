require 'factory_bot_rails'
require 'ecomm/factories'

include FactoryBot::Syntax::Methods

numbers = { users: 5, categories: 4, authors: 20, books: 50 }

User.skip_callback(:create, :after, :send_welcome_user)

create(:user, admin: true, email: 'admin@bookstore.com', password: '11111111')
create_list(:user, numbers[:users])

User.set_callback(:create, :after, :send_welcome_user)

categories = create_list(:category, numbers[:categories])

materials =
  ['hardcover', 'paperback', 'leather', 'vinyl', 'ivory',
   'off-white paper', 'low-white paper', 'glossy paper'].map do |material|
    create(:material, name: material)
  end

authors = create_list(:author, numbers[:authors])

def image_url(format, number)
  "https://s3.eu-central-1.amazonaws.com/sybseimages/#{format}/#{number}.jpg"
end

numbers[:books].times do |i|
  book = Book.new
  book.remote_main_image_url = image_url('portrait', i + 1)

  book.remote_images_urls = [*1..numbers[:books]].sample(3).map do |n|
    image_url('landscape', n)
  end

  book.title = Faker::Book.title.truncate(70)
  book.year = (1997..2016).to_a.sample
  book.description = Faker::Hipster.paragraph(9, false, 17).truncate(990)
  book.height = rand(8..15)
  book.width = rand(4..7)
  book.thickness = rand(1..3)
  book.category = categories.sample
  book.price = (rand(4.99..119.99) * 20).round / 20.0
  book.materials.concat [materials[rand(0..4)], materials[rand(5..7)]]
  book.authors.concat authors.sample(rand(1..3))
  book.created_at = DateTime.now - (numbers[:books] - i).days
  book.save!
end

[
  { method: 'Delivery next day!', days_min: 3, days_max: 7, price: 5.00 },
  { method: 'Pick Up In-Store', days_min: 5, days_max: 20, price: 10.00 },
  { method: 'Expressit', days_min: 2, days_max: 3, price: 15.00 }
].each { |shipment| Ecomm::Shipment.create!(shipment) }

10.times { |i| create(:coupon, code: i.to_s * 6, expires: DateTime.now + 2.year) }
