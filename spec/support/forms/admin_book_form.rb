class AdminBookForm
  include Capybara::DSL

  def fill_in_with(params)
    if params[:add_images]
      attach_file('Main image',
                  "#{Rails.root}/spec/fixtures/" + params[:main_image])
      attach_file('Images',
                  "#{Rails.root}/spec/fixtures/" + params[:images])
    end
    select params[:category], from: 'book_category_id'
    fill_in('book_title', with: params[:title])
    params[:author_ids].each { |id| check("book_author_ids_#{id}") }
    fill_in('book_description', with: params[:description])
    params[:material_ids].each { |id| check("book_material_ids_#{id}") }
    fill_in('book_year', with: params[:year])
    fill_in('book_height', with: params[:height])
    fill_in('book_width', with: params[:width])
    fill_in('book_thickness', with: params[:thickness])
    fill_in('book_price', with: params[:price])
    self
  end

  def submit(action)
    click_on("#{action} Book")
  end
end
