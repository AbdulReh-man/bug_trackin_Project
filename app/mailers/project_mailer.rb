class ProjectMailer < ApplicationMailer
  def project_assigned( ass_user,ass_project)
    @user = ass_user
    @project = ass_project
    mail(to: @user.email, subject: "You have been Added to a project #{@project.name}")
  end
end
