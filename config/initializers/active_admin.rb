ActiveAdmin.setup do |config|
  config.site_title = 'Book Store'

  config.authentication_method = :authenticate_active_admin_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.logout_link_method = :get
  config.comments = false
  config.comments_menu = false
  config.batch_actions = true
  config.localize_format = :long
end

module ActiveAdmin::ViewHelpers
  include ApplicationHelper
end
