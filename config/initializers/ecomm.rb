Ecomm.setup do |config|
  config.customer_class = 'User'
  config.product_class = 'Book'
  config.current_customer_method = 'current_user'
  config.signin_path = '/users/sign_in'
  config.flash_login_return_to = 'user_return_to'
  config.i18n_unuathenticated_key = 'devise.failure.unauthenticated'
  config.catalog_path = '/catalog/index'
  config.completed_order_url_helper_method = 'order_url'
end