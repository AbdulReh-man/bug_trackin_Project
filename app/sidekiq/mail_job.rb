class MailJob
  include Sidekiq::Job

  def perform(user_id, project_id)
    # Do something
    user = User.find(user_id)
    project = Project.find(project_id)
    ProjectMailer.project_assigned(user, project).deliver_later
  end
end
