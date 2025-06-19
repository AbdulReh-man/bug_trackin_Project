module Api::V1
  class BugsController < ApiBaseController
    before_action :set_bug, only: [:new, :create, :update, :destroy]

    # GET /bugs or /bugs.json
    def index
      @project = Project.find(params[:project_id])
      @bugs = policy_scope(@project.bugs)
      
      @bugs.each do |bug|
        authorize bug  # Authorize each individual bug
      end
      render json: {data: @bugs }, status: :ok

    end

    def new 
      @bug = @project.bugs.build
      authorize @bug, :create?
      render json: {data: @bug}, status: :ok
    end

    # POST /bugs
    def create
      @bug = @project.bugs.build(bug_params)
      @bug.creator = current_user
      authorize @bug

      if @bug.save
        render json:{message:"Bug Created Successfully" ,data: @bug }, status: :created
      else
        render_error(@bug.errors.full_messages.to_sentence, :unprocessable_entity)
      end
    end

    # PATCH/PUT /bugs/:id
    def update
      @bug = Bug.find(params[:id])
      authorize @bug

      if @bug.update(bug_params)
        render json:{ message: "Bug was Successfully Updated", data: @bug }, status: :ok
      else
        render_error(@bug.errors.full_messages.to_sentence, :unprocessable_entity)
      end
    end

    # DELETE /bugs/:id
    def destroy
      authorize @bug

      if @bug.destroy
        render json: { message: "Bug was successfully deleted" }, status: 200
      else
        render_error(@bug.errors.full_messages.to_sentence, :unprocessable_entity)
      end
    end
    
    private

    def set_bug
      @project = Project.find(params[:project_id])
      @bug = @project.bugs.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def bug_params
      # First permit all attributes
      permitted = params.require(:bug).permit(
        :title,
        :description,
        :deadline,
        :status,
        :bug_type,
        :developer_id,
        :screenshot,
      )
    
      # Convert string enum values to integers
      if permitted[:bug_type].present? && permitted[:bug_type].is_a?(String)
        permitted[:bug_type] = Bug.bug_types[permitted[:bug_type]] || permitted[:bug_type]
      end
    
      # Remove project_id and creator_id as they should come from the URL/session
      permitted.except(:project_id, :creator_id)
    end

  end
end
