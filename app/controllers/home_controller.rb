class HomeController < ApplicationController
  def index
    @latest_books = BookDecorator.decorate_collection(
      BooksSorter.new(
        'sort_by' => 'created_at', 'order' => 'desc', 'limit' => 3
      )
    )
    @most_popular_books = BookDecorator.decorate_collection(
      BooksSorter.new('sort_by' => 'popular', 'limit' => 4)
    )
  end
end
