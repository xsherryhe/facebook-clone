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

  def unauthorized_redirect(action, redirect_path, options = {})
    respond_to do |format|
      error = "You don't have permission to #{action} that #{controller_name.singularize.humanize.downcase}."
      error += " #{options[:additional_info]}" if options[:additional_info]
      flash[:error] = error
      format.html { redirect_to redirect_path }
    end
  end
end
