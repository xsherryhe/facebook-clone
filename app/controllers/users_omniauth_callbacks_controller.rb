class UsersOmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    @auth = request.env['omniauth.auth']
    @user = User.from_omniauth(@auth)

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Facebook')
    else
      direct_new_omniauth_user
    end
  end

  def failure
    set_flash_message(:error, :general_failure)
    redirect_to new_user_registration_path
  end

  private

  def direct_new_omniauth_user
    session['devise.facebook_data'] = @auth.except(:extra)

    if @user.save
      set_flash_message(:notice, :success, kind: 'Facebook')
      redirect_to edit_profile_path
    else
      set_flash_message(:error, :failure, kind: 'Facebook')
      redirect_to new_user_registration_path
    end
  end
end
