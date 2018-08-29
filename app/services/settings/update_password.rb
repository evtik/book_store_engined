module Settings
  class UpdatePassword < Ecomm::BaseService
    def call(*args)
      params, @user, @flash, @controller = args
      return empty_password if params[:password].blank?
      return update_failed unless @user.update_with_password(params)
      update_succeeded
    end

    private

    def set_error
      @flash[:alert] = @user.errors.full_messages.first
    end

    def empty_password
      @user.errors.add(:password, :blank)
      set_error
    end

    def update_failed
      @user.clean_up_passwords
      set_error
    end

    def update_succeeded
      @flash[:notice] = I18n.t('settings.change_password.changed_message')
      @controller.bypass_sign_in(@user)
    end
  end
end
