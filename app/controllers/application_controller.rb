class ApplicationController < ActionController::Base 
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :beneficiary_history
  def after_sign_in_path_for(resource)
    if current_user.has_role? :admin
        admin_path
    else
        root_path
    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

end
