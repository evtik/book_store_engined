class EmailsController < ApplicationController
  before_action(:authenticate_user!)

  def update
    user = User.find(current_user.id)
    user.email = params.require(:user).permit(:email)[:email]
    flash[:show_privacy] = true
    if user.save
      flash[:notice] = t('settings.change_email.email_updated')
    else
      flash[:alert] = user.errors.full_messages.first
    end
    redirect_to(settings_path)
  end
end
