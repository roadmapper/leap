class NewusersController < ApplicationController
  def index
 	 @user = User.new
  end
  def create
	@user = User.new(:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
	#@user = User.new(:email => 'working2@test.com', :password => 'password', :password_confirmation => 'password')
	#@user.save
	if @user.save
	      	redirect_to newusers_path
      		flash[:notice] = "#{ @user.email } created."

    	else
    	    	flash[:notice] = "#{ @user.email } #{@user.password} #{@user.password_confirmation} was not able to be created.  An unexpected error occurred.  Please try again."
    	    	@messages = "User was not able to be created. "
    	    	@user.errors.full_messages.each do |message|
    	    		@messages = @messages + message + ". "
    	    	end
    	    	flash[:notice] = @messages
      		redirect_to newusers_path
    	end
  end
end
