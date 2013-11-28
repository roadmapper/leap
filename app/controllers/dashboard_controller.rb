class DashboardController < ApplicationController
  USER, PASSWORD = 'dhh', 'secret'
  before_filter :authentication_check   #, :except => :index

  def index
    #@property = Property.find_by_owner_name(params[:owner])
    #respond_to do |format|
      #format.html # index.html.erb
      #format.xml  { render :xml => @property }
    #end
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
  
  def gaps
    @property = Property.find_by_owner_name(params[:owner])
    @testoutdate = @property.finish_date
    if (@testoutdate)
    	@startdate = @testoutdate.to_time.advance(:years=>-1).to_date
    end
    @power_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,2) #ID and Power
    if (@power_record_lookup)
    	@power_recordings = Recording.find_all_by_acctnum_and_utility_type_id(@power_record_lookup.acct_num,2)
    end
    #render :partial => 'report'
    respond_to do |format|
      format.html # gaps.html.erb
      format.xml  { render :xml => @property }
    end
  end

  private
  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end

end
