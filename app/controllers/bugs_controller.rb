class BugsController < ApplicationController
  before_action :set_project, only: [:new, :create, :edit, :update, :show, :index]
  before_action :set_bug, only: %i[show edit update destroy]

  # GET /bugs or /bugs.json
  def index 
    @project = Project.find(params[:project_id])
    @bugs = policy_scope(@project.bugs)

    @bugs.each do |bug|
      authorize bug  # Authorize each individual bug
    end
  end

  # GET /bugs/1 or /bugs/1.json
  def show

  end

  def new
    @bug = @project.bugs.build
    authorize @bug
  end

  # POST /bugs
  def create
    @bug = @project.bugs.build(bug_params)
    @bug.creator = current_user
    # debugger
    authorize @bug
    
    if @bug.save
      redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /bugs/1 or /bugs/1.json
  def update
    @bug = Bug.find(params[:id])
    authorize @bug
    
    if @bug.update(bug_params)
      redirect_to project_bugs_path(@bug.project), notice: "Bug was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

 # GET /bugs/1/edit
  def edit
  end
  
  def assign_user
    @bug = Bug.find(params[:id])
    authorize @bug, :assign_to_self?
    
    if @bug.developer_id.nil? || @bug.developer_id != current_user.id
      @bug.update(developer: current_user) # Assign current_user as the developer
      redirect_to request.referrer || project_bugs_path, notice: "Bug successfully assigned to you."
    else
      redirect_to project_bugs_path, notice: "You are already assigned to this bug."
    end
  end

  def mark_done
    @bug = Bug.find(params[:id])
    authorize @bug, :mark_resolved?
    @bug.update(status: 'resolved')
    redirect_to project_bugs_path, notice: "Bug marked as resolved"
  end

  # DELETE /bugs/1 or /bugs/1.json
  def destroy
    @bug.destroy
    redirect_to project_bugs_path(@bug.project), status: :see_other, notice: "Bug was successfully destroyed."
  end


  private
  # Use callbacks to share common setup or constraints between actions.
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
