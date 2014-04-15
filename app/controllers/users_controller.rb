class UsersController < ApplicationController
	before_action :authenticate_user!

  def home
  	@user = current_user
  end
  
end
