class BugsController < ApplicationController
  before_action :set_project, only: [:new, :create]
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

  # GET /bugs/new
  def new
    authorize Bug
    # @bug = Bug.new
    @bug = @project.bugs.build
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

  def create
  @bug = @project.bugs.build(bug_params)  # Associate the bug with the selected project
  authorize @bug
  @bug.creator = current_user  # Set the creator as the logged-in user
  respond_to do |format|
    if @bug.save
      format.html { redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully created." }
      format.json { render :show, status: :created, location: @bug }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @bug.errors, status: :unprocessable_entity}
    end
  end
end

  # PATCH/PUT /bugs/1 or /bugs/1.json
  def update
  @bug = Bug.find(params[:id])
  authorize @bug
    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to project_bugs_path(@bug.project), notice: "Bug was successfully updated." }
        format.json { render :show, status: :ok, location: @bug }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bugs/1 or /bugs/1.json
  def destroy
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to project_bugs_path(@bug.project), status: :see_other, notice: "Bug was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bug
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
  end

   def set_project
    @project = Project.find(params[:project_id])  # Find the project by project_id
     rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end

  # Only allow a list of trusted parameters through.
  def bug_params
    params.require(:bug).permit(:title, :description, :project_id, :deadline, :bug_type, :creator_id, :developer_id, :status, :screenshot)
  end
end
