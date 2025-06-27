module Api::V1
    class SessionsController < DeviseTokenAuth::SessionsController
      def create
        # Normalize parameters
        auth_params = if params[:session].present?
                       params.require(:session).permit(:email, :password)
                     else
                       params.permit(:email, :password)
                     end

        # Find user
        @resource = User.find_for_database_authentication(login: auth_params[:email]&.downcase)

        # Validate credentials
        unless @resource&.valid_password?(auth_params[:password])
          return render json: {
            success: false,
            errors: ["Invalid login credentials. Please try again."]
          }, status: :unauthorized
        end

        # Manually generate token response to avoid parameter issues
        @token = @resource.create_token
        @resource.save!

        puts "Generated token: #{@token}"
        

        render json: {
          data: @resource.as_json(),
          # token: @token.token,
          # token_type: 'Bearer',
          # uid: @resource.uid,
          # client_id: @token.client,
          # expiry: @token.expiry
        }
      end

      private

      def resource_params
        params.permit(:email, :password)
      end
  end
end