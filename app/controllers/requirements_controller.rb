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
  		#redirect_to project_requirements_path(@project.id)  #this works redirect to index path
      redirect_to project_requirement_path(@project.id, @requirement.id) 
  	else
  		render :new
  	end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @requirement = @project.requirements.find(params[:id])
    @requirement.destroy #destroy all childre too?
    redirect_to project_requirement_path
  end

  def index
    @project = Project.find(params[:project_id])
    #@requirements = Requirement.scoped
    @requirements =@project.requirements.scoped 
    @requirement = Requirement.new
    
    #@project = Project.find(@requirements.first.proj_id) #might be shit code, do not ship?
  end

end
