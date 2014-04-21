class UsersController < ApplicationController
	def index
		@user = User.new
		@userlist = User.all
  	end
  	
  	def destroy
    		@user = User.find(params[:id])
    		if @user.destroy
    			redirect_to newusers_path
      			flash[:notice] = "#{ @user.email } destroyed."
    		else   	    		
    			@messages = "User was not able to be destroyed. "
    	    		@user.errors.full_messages.each do |message|
    	    			@messages = @messages + message + ". "
    	    		end
    	    		flash[:notice] = @messages
      			redirect_to newusers_path
    		end
    		
  		#User.find(params[:id]).destroy
    		#flash[:success] = "User deleted."
    		#redirect_to newusers_path
  	end
end
