class RequirementsController < ApplicationController
  def new
  	@requirement = Requirement.new(params[:requirement])
  end

  def show
  	#will need to add a project_id here too
  	@requirement = Requirement.find(5)
 
  end

  def create
  	@requirement = Requirement.new(params[:requirement])
  	if @requirement.save
  		#successful save
  	else
  		render :new
  	end
  end

  def destroy
  end

  def index
       @requirement = Requirement.all
  end

end
