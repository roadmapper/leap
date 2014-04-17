class NewusersController < ApplicationController
	def index
		@user = User.new
		@userlist = User.all
  	end
  	def create
		@user = User.new(:email => params[:user][:email], :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
		if @user.save
	      		redirect_to newusers_path
      			flash[:notice] = "#{ @user.email } created."
    		else
    	    		@messages = "User was not able to be created. "
    	    		@user.errors.full_messages.each do |message|
    	    			@messages = @messages + message + ". "
    	    		end
    	    		flash[:notice] = @messages
      			redirect_to newusers_path
    		end
  	end
  
    	def show
    		@userlist = User.find(:email => params[:user][:email])

    		respond_to do |format|
      			format.html # show.html.erb
      			format.json { render json: @user }
    		end
  	end
  	
  	def edit
    		@user = User.find(params[:id])
    		@user.errors.full_messages.each do |message|
    	    			@messages = @messages + message + ". "
    	    		end
    	    	flash[:notice] = @messages
  	end
  	
  	def update
 		@user = User.find(params[:id])

    		respond_to do |format|
      			if @user.update_attributes(params[:user])
        			format.html { redirect_to @user, notice: 'User was successfully updated.' }
        			format.json { head :no_content }
      			else
        			format.html { render action: "edit" }
        			format.json { render json: @user.errors, status: :unprocessable_entity }
      			end
    		end
  	end
end
