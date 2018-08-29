class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauth_params = request.env['omniauth.auth']
    @user = User.from_omniauth(oauth_params)
    set_flash_message(:notice, :success,
                      kind: oauth_params[:provider].capitalize)
    sign_in_and_redirect(@user)
  end
end
