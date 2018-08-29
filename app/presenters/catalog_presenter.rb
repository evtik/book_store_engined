class CatalogPresenter < Rectify::Presenter
  SORTERS = {
    { 'sort_by' => 'created_at', 'order' => 'desc' } =>
    I18n.t('catalog.catalog_sorters.newest'),
    { 'sort_by' => 'popular', 'order' => 'desc' } =>
    I18n.t('catalog.catalog_sorters.popular'),
    { 'sort_by' => 'price', 'order' => 'asc' } =>
    I18n.t('catalog.catalog_sorters.price_low'),
    { 'sort_by' => 'price', 'order' => 'desc' } =>
    I18n.t('catalog.catalog_sorters.price_high'),
    { 'sort_by' => 'title', 'order' => 'asc' } =>
    I18n.t('catalog.catalog_sorters.title_az'),
    { 'sort_by' => 'title', 'order' => 'desc' } =>
    I18n.t('catalog.catalog_sorters.title_za')
  }.freeze

  attribute(:params, ActionController::Parameters)
  attribute(:categories, Array)

  def sorters
    SORTERS
  end

  def more_books?
    limit = current_limit
    category_id = params[:category].to_i
    if category_id.zero?
      limit < categories.first.second
    else
      limit < find_category(category_id).second
    end
  end

  def find_category(id)
    categories.select { |category| category[0][1].to_i == id }.first
  end

  def current_category?(id)
    id == params[:category].to_i || (id.nil? && params[:category].nil?)
  end

  def current_sorter
    SORTERS[params.to_h.slice('sort_by', 'order')] ||
      I18n.t('catalog.catalog_sorters.newest')
  end

  def current_limit
    params[:limit] ? params[:limit].to_i : 12
  end
end
