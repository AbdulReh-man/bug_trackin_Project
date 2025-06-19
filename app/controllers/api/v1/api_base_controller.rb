module Api::V1
  class ApiBaseController < ActionController::API
    respond_to :json
    
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :authenticate_user!

    before_action :configure_permitted_parameters, if: :devise_controller?

    private

    def render_error(message, status = :unprocessable_entity)
      render json: { error: message }, status: status
    end

    def user_not_authorized
      render_error("You are not authorized to perform this action.", :forbidden)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :name])
    end

  end
end