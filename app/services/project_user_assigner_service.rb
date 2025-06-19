class ProjectUserAssignerService
  def initialize(project, user_ids)
    @project = project
    @user_ids = user_ids
  end
  
  def call
    return false if @user_ids.blank?
    
    selected_users = User.find(@user_ids)
    
    @project.users =  selected_users
    selected_users.each do |user|
      MailJob.perform_async(user.id, @project.id)
    end
    true
  end
end  