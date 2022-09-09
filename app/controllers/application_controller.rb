class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
    added_attrs = %i[username email password password_confirmation remember_me]
    %i[sign_up account_update].each do |controller|
      devise_parameter_sanitizer.permit controller, keys: added_attrs
    end
  end

  def unauthorized_redirect(action, redirect_path)
    flash[:error] = "You don't have permission to #{action} that #{controller_name.classify.downcase}."
    redirect_to redirect_path
  end
end
