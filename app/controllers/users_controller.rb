#this controller provides the functionality to destroy a user
class UsersController < ApplicationController
	def index
		@user = User.new
		@userlist = User.all
  	end
  	#destroy a user from the database so they can no longer use the system
  	def destroy
  		#find the user that was selected
    		@user = User.find(params[:id])
    		#if the selected user can be destroyed successfully, stay on the same page, and flash a message saying the user was successfully destroyed
    		if @user.destroy
    			redirect_to newusers_path
      			flash[:notice] = "#{ @user.email } destroyed."
    		#if the user was not able to be destroyed, flash an error message saying it was not able to be destroyed and why and stay on the same page
    		else   	    	
    			#parse the error message and compile it into a readable form to be shown to the user	
    			@messages = "User was not able to be destroyed. "
    	    		@user.errors.full_messages.each do |message|
    	    			@messages = @messages + message + ". "
    	    		end
    	    		flash[:notice] = @messages
      			redirect_to newusers_path
    		end
  	end
end
