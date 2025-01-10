class ProjectsController < ApplicationController
  # before_action :set_project, only: %i[ show edit update destroy ]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :assign_users, :remove_user]
  # GET /projects or /projects.json
  def index
    authorize Project
    @projects = if current_user.manager?
                Project.all
              else
                 current_user.projects
              end
    @projects = policy_scope(@projects)
  end

  # GET /projects/1 or /projects/1.json
  def show

  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    authorize Project
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        UserProject.create(user: current_user, project: @project)
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    authorize set_project
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    authorize set_project
    @project.destroy!
    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def assign_users
    authorize Project
    @project = Project.find(params[:id])
    @users = User.where(role: ['developer', 'qa'])

    if request.post?
      if params[:user_ids].present?
        selected_users = User.find(params[:user_ids])
        manager_users = @project.users.where(role: 'manager')
          @project.users = manager_users + selected_users 

          selected_users.each do |user|
            MailJob.perform_async(user.id, @project.id)
          end

          redirect_to @project, notice: "Users assigned successfully to the project & email sent."
     
      else
        @project.users = @project.users.where(role: 'manager')
        redirect_to @project, alert: "No users selected."
      end
    end
  end

  def view_users
    @project = Project.find(params[:id]) 
    @users = @project.users.where.not(role: 'manager')
  end

  def remove_user
    authorize Project
    user = User.find(params[:user_id]) 
    if @project.users.include?(user)
      @project.users.delete(user) 
      redirect_to @project, notice: "#{user.name} has been removed from the project."
    else
      redirect_to @project, alert: "User is not part of this project."
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :name, :description ])
    end
end
