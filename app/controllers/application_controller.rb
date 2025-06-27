class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  protect_from_forgery unless: -> { request.format.json? }
  
  # Use modern browser features
  allow_browser versions: :modern

  # Include Pundit for authorization
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  before_action :configure_permitted_parameters, if: :devise_controller? # The following code allows the user model to accept `role` as a parameter at the time of signup

  private
  
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path) # Redirect to previous page or root
  end
  
  protected
  
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :role]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [ :role, :login ]) # Permit `role` and `name` during sign up
  #   devise_parameter_sanitizer.permit(:account_update, keys: [ :login ]) # Permit `name` during account update
  # end

end