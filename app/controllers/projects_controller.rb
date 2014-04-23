class ProjectsController < ApplicationController
  def new
  	@project = current_user.projects.new
  end	

  def create
    #@user = User.find(params[:user_id]) 
    #@user = User.find(current_user.id)
    #@project = @user.projects.create(params[:project])
    @project = current_user.projects.create(params[:project])
   	redirect_to user_projects_path(current_user)

  end	

  def index
  	@projects = current_user.projects
  end
end
