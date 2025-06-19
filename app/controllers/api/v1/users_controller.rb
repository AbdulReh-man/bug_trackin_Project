module Api::V1
  class UsersController < ApiBaseController

    def destroy_with_projects
      service = UserDeletionService.new(current_user)
      if service.call
        sign_out current_user
        render json: { message: 'Your account and all projects were successfully deleted.' }, status: :ok
      else
        render_error("We couldn't delete your account. Please contact support.")
      end
    end
  end
end