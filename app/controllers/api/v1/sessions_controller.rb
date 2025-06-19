# app/controllers/api/v1/sessions_controller.rb
module Api::V1
  class SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(resource, _)
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: resource
      }, status: :ok
    end

    def respond_to_on_destroy
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    end
  end
end