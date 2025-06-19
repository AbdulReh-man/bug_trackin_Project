module Api::V1
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private
    def respond_with(resource, _options = {})
      if resource.persisted?
        render json: {
          status: { code: 200, message: 'Account Registered successfully.' },
          data: resource
        }, status: :ok
      else
        render json: {
          status: { code: 422, message: "Registration failed.", errors: resource.errors.full_messages }
        }, status: :unprocessable_entity
      end
    end

  end
end