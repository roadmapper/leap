class ApplicationController < ActionController::Base

  USER, PASSWORD = 'dhh', 'secret'
  #only authenticated users can access the system
  before_filter :authenticate_user!, :unless => :devise_controller?

  protect_from_forgery

  #url path to direct to after the user is authenticated
  def after_sign_in_path_for(user)
	#redirect to home
	"/leap/"
	#has to be "" on local machine
	#""
  end

  private
  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end
end
