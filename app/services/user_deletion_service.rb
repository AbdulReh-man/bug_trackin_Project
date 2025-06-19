# app/services/user_deletion_service.rb
class UserDeletionService
    def initialize(user)
      @user = user
    end
    
    def call
      ActiveRecord::Base.transaction do
        # if @user.user_projects.exists?
          @user.destroy!
          # @user.user_projects.destroy_all
        # end
        # @user.destroy!
        Rails.logger.info "User deletion Success"
        true
      end
    
      rescue => e
        Rails.logger.error "Unexpected error during user deletion: #{e.message}"
        false

    end

end