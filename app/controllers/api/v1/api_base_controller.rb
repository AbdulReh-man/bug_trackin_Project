module Api::V1
  class ApiBaseController < ActionController::API
    respond_to :json
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    include DeviseTokenAuth::Concerns::SetUserByToken
    before_action :authenticate_user!

    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
    
    def configure_permitted_parameters
      # added_attrs = [:username, :email, :password, :password_confirmation, :role]
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end

    private

    def render_error(message, status = :unprocessable_entity)
      render json: { error: message }, status: status
    end

  end
end