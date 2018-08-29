class Users::RegistrationsController < Devise::RegistrationsController
  def update
    Settings::UpdatePassword.call(permitted, resource, flash, self)
    flash[:show_privacy] = true
    redirect_to(settings_path)
  end

  def destroy
    super
    flash[:notice] = t('settings.remove_account.removed_message')
  end

  private

  def permitted
    params.require(resource_name).permit(:current_password, :password,
                                         :password_confirmation)
  end
end
