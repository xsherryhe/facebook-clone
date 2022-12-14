class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
    added_attrs = %i[username email password password_confirmation remember_me]
    %i[sign_up account_update].each do |controller|
      devise_parameter_sanitizer.permit controller, keys: added_attrs
    end
  end

  def handle_unauthorized(action, options = {})
    @error = "You don't have permission to #{action} that #{controller_name.singularize.humanize.downcase}."
    @additional_info = options.fetch(:additional_info, nil)
    @additional_info_link = options.fetch(:additional_info_link, nil)
    @back_route = options.fetch(:back_route, nil)
    @error_persistent = options.fetch(:error_persistent, false)
    render 'shared/error', status: (request.get? ? nil : :unprocessable_entity)
  end

  def handle_not_found(exception)
    @error ||= "This #{exception.model.downcase} no longer exists."
    render 'shared/error', status: (request.get? ? nil : :unprocessable_entity)
  end
end
