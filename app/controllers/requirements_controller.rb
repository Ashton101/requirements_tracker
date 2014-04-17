class RequirementsController < ApplicationController
  
  def new
    @project = Project.find(params[:project_id])
    @requirement = @project.requirements.new(parent_id: params[:parent_id])
      #@requirement = Requirement.new(parent_id: params[:parent_id][:proj_id])
  end

  def show
  	@project = Project.find(params[:project_id])
  	@requirement = @project.requirements.find(params[:id])
    
  end

  def create
   @project = Project.find(params[:project_id])
  	@requirement = @project.requirements.new(params[:requirement])
  	if @requirement.save
  		#redirect_to project_requirements_path(@project.id)  #index path
      redirect_to project_requirement_path(@project.id, @requirement.id) #show path
  	else
  		render :new
  	end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @requirement = @project.requirements.find(params[:id])
    @requirement.destroy #destroy all children too? yes
    redirect_to project_requirements_path
  end

  def index
    @project = Project.find(params[:project_id])
    @requirements =@project.requirements.scoped 
    @requirement = Requirement.new
  end

end
