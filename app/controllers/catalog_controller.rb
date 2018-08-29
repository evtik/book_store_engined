class CatalogController < ApplicationController
  include Rectify::ControllerHelpers

  def index
    present(CatalogPresenter.new(params: catalog_params,
                                 categories: @categories))
    @books = BookDecorator.decorate_collection(category_books | sorted)
  end

  private

  def catalog_params
    params.permit(:category, :sort_by, :order, :limit)
  end

  def category_books
    CategoryBooks.new(catalog_params[:category])
  end

  def sorted
    BooksSorter.new({
      'sort_by' => 'created_at',
      'order' => 'desc',
      'limit' => 12
    }.merge(catalog_params.to_h))
  end
end
