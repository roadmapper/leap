class DashboardController < ApplicationController
  USER, PASSWORD = 'dhh', 'secret'
  before_filter :authentication_check   #, :except => :index

  def index
    @property = Property.where(:owner_name => "Vinay")
  end
  def upload
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
      #file.force_encoding('UTF-8')
      file.write(uploaded_io.read)
    end
    flash[:notice] = "File has been uploaded successfully"    
    #update_page do |page|
      redirect_to :action => 'index'
    #end
  end

  private
  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end

end
