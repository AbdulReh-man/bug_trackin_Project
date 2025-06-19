module Api::V1
  class ProjectsController < ApiBaseController
    before_action :set_project, only: [:update, :destroy]
    
    # GET /projects or /projects.json
    def index
      authorize Project
      if current_user.manager?
        @projects = Project.all
      else
        @projects = current_user.projects
      end
      @projects = policy_scope(Project).distinct

      @bug_counts = Bug.group(:bug_type).count

      render json: {bug_counts: @bug_counts, data: @projects }, status: :ok
    end
    
    # POST /projects
    def create
      authorize Project, :create?
      @project = Project.new(project_params)

      if @project.save
        UserProject.create(user: current_user, project: @project)
        render json:{message:"Project Created Successfully" ,data: @project }, status: :created
      else
        render_error(@project.errors.full_messages.to_sentence, :unprocessable_entity)
      end
    end

    # PATCH/PUT /projects/:id
    def update
      authorize @project, :update?

      if @project.update(project_params)
        render json:{ message: "Project was Successfully Updated", data: @project }, status: :ok
      else
        render_error(@project.errors.full_messages.to_sentence, :unprocessable_entity)
      end
    end

    # DELETE /projects/:id
    def destroy
      authorize @project, :destroy?

      if @project.destroy
        render json: { message: "Project was successfully deleted" }, status: :ok
      else
        render_error(@project.errors.full_messages.to_sentence, :unprocessable_entity)
      end
    end

    private

    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description)
    end

  end
end