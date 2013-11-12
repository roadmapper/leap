class ApplicationController < ActionController::Base

  USER, PASSWORD = 'dhh', 'secret'
  before_filter :authentication_check   #, :except => :index

  protect_from_forgery


  private
  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end
end
