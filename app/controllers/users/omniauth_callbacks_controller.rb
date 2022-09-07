class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  def facebook
    @auth = request.env['omniauth.auth']
    @user = User.from_omniauth(@auth)

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Facebook')
    else
      store_facebook_data
      set_flash_message(:error, :failure, kind: 'Facebook')
      redirect_to new_user_registration_path
    end
  end

  def failure
    set_flash_message(:error, :general_failure)
    redirect_to new_user_registration_path
  end

  private

  def store_facebook_data
    session['devise.facebook_data'] = @auth.except(:extra)
    session['devise.facebook_data']['info']['location'] = @auth.dig(:extra, :raw_info, :location, :name)
    session['devise.facebook_data']['info']['birthdate'] = @auth.dig(:extra, :raw_info, :birthday)
  end
end
