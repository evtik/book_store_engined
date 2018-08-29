class ApplicationController < ActionController::Base
  protect_from_forgery(with: :exception)
  before_action { @categories = Common::GetCategoriesWithCounters.call }
  before_action(:store_current_location, unless: :devise_controller?)

  rescue_from CanCan::AccessDenied do
    render(file: "#{Rails.root}/public/403.html", status: 403, layout: false)
  end

  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.admin?
    flash.alert = t('active_admin.not_authorized')
    redirect_to(root_path)
  end

  private

  def store_current_location
    store_location_for(:user, request.url)
  end
end
