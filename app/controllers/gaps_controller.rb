class GapsController < ApplicationController

  USER, PASSWORD = 'dhh', 'secret'
  before_filter :authentication_check   #, :except => :index
  def index
    @property = Property.find_by_owner_name(params[:owner])
    #respond_to do |format|
      #format.html # index.html.erb
      #format.xml  { render :xml => @property }
    #end
  end

  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end

  def search
    @property = Property.find_by_owner_name(params[:owner])

    #redirect_to :action => :index    
    render :partial => 'gaps_report'
    #respond_to do |format|
      #format.js
    #end
  end

end
