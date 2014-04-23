class RequirementsController < ApplicationController
  before_filter :find_project, only: [:new, :create, :index]
  before_filter :find_requirement, except: [:new, :create, :index, :new_child]
  
  def new
    @requirement = @project.requirements.new() 
  end

  def new_child
    @requirement = Requirement.new(parent_id: params[:id])
  end  

  def show
  	@requirement
  end

  def create
  	@requirement = @project.requirements.new(params[:requirement])
  	if @requirement.save
      @requirement.update_range_parents(@requirement,@requirement.minimum,
                           @requirement.most_likely,
                           @requirement.maximum)
  	
      redirect_to project_requirements_path(@project.id) #index path
  	else
  		render :new
  	end
  end

  def children #create children
    #@requirement = @requirement.requirements.new(params[:requirement])
    #@requirement = Requirement.new(params[:requirement],proj_id: @requirement.proj_id)
    @project = Project.find(@requirement.proj_id)
     @requirement = @project.requirements.new(params[:requirement])
    if @requirement.save

      @requirement.add_range_parents(@requirement,@requirement.minimum,
                           @requirement.most_likely,
                           @requirement.maximum)
      redirect_to project_requirements_path(@requirement.proj_id) #index path
    else
      render :new_child
    end    
  end 

  def edit
   # @requirement
  end

  def update
    old_requirement = @requirement.clone
    
    @requirement.update!(params[:requirement])

    @requirement.update_tree_range_after_edit(old_requirement,@requirement)

    redirect_to project_requirements_path(@requirement.proj_id)
  end

  def destroy
    @requirement.add_range_parents(@requirement,-(@requirement.minimum),
                           -(@requirement.most_likely),
                           -(@requirement.maximum))
    @requirement.destroy #destroy all children too? yes
    redirect_to project_requirements_path(@requirement.project)
  end

  def index
    @requirements =@project.requirements.scoped 
    @requirement = @project.requirements.new
  end

private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def find_requirement
    @requirement = current_user.requirements.find(params[:id])
  end   

end
