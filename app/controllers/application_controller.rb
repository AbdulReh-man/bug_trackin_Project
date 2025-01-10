class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path) # Redirect to previous page or root
  end


  before_action :configure_permitted_parameters, if: :devise_controller? # The following code allows the user model to accept `role` as a parameter at the time of signup
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role, :name ]) # Permit `role` and `name` during sign up
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ]) # Permit `name` during account update
  end

end