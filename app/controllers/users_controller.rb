# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!

    def destroy_with_projects
        service = UserDeletionService.new(current_user)
        if service.call
            sign_out current_user
            redirect_to new_user_registration_path, notice: 'Your account and all projects were successfully deleted.'
        else
            flash[:error_title] = "Account Deletion Failed"
            flash[:error_message] = "We couldn't delete your account. Please contact support."
            redirect_to error_display_path
        end
    end
end