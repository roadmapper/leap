#this controller provides the functionality to create a new user
class NewusersController < ApplicationController
	def index
		@user = User.new
		@userlist = User.all
  	end
  	
  	#creates a new user with the params entered into the newuser view
  	def create
		@user = User.new(:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
		#save the new user
		if @user.save
			#If successfully created, stay on the newuser page and flashmessage success.  
	      		redirect_to newusers_path
      			flash[:notice] = "#{ @user.email } created."
    		else
    			#if the new user was not able to be created, flash message all errors that made it unsuccessful 
    			#and stay on the newuserpage
    	    		@messages = "User was not able to be created. "
    	    		#parse the error messages and put it into a user readable version
    	    		@user.errors.full_messages.each do |message|
    	    			@messages = @messages + message + ". "
    	    		end
    	    		flash[:notice] = @messages
      			redirect_to newusers_path
    		end
  	end  	
end
