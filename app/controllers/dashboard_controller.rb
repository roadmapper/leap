class DashboardController < ApplicationController
  #USER, PASSWORD = 'dhh', 'secret'
  #before_filter :authentication_check   #, :except => :index
  include DashboardHelper  

  def index
    #@property = Property.find_by_owner_name(params[:owner])
    #respond_to do |format|
      #format.html # index.html.erb
      #format.xml  { render :xml => @property }
    #end
  end
  def upload
    uploaded_io = params[:file]
    railspath =  Rails.root.join('..', 'uploads')
    path = railspath.to_s
    filename = uploaded_io.original_filename
    #print path
    #print File.exists?(path)
    #print File.directory?(path)
    #print "holla holla get dolla"
    if !File.exists?(path + "//" + filename) && File.directory?(path)
      File.open(path + "//" + filename, 'w') do |file|
        input = uploaded_io.read
        input.force_encoding('UTF-8')
        file.write(input)
      end
      flash[:notice] = "File has been uploaded successfully, check the uploaded files to see its processing status."
      Upload.where(:file_name => uploaded_io.original_filename, :status => 'Not Processed', :upload_date => Time.now).first_or_create(:locked => false)
      #Would prefer to put in seperate helper function but failure on that...
      
#      Dir.foreach(path + "/*.xlsx") do |file|  
#	      file_path = "#{file}"
#	      file_basename = File.basename(file, ".xlsx")
#	      xlsx = Roo::Excelx.new(file_path)
#	      $i = xlsx.sheets.length - 1
#	      while $i >= 0 do
#		xlsx.default_sheet = xlsx.sheets[$i]
#		xlsx.to_csv(path + "/#{file_basename}#{$i}.csv")
#		$i -=1			
#	      end
#	      FileUtils.remove(file)
#	      print "Converted file #{file} \n"
 #     end
    elsif File.exists?(path + "//" + filename)
      flash[:notice] = "Duplicate file exists. File was not uploaded successfully to: " + path
    else
      flash[:notice] = "File was not uploaded successfully to: " + path
    end

      redirect_to :action => 'index'
  end
  
  def gaps
    @property = Property.find_by_owner_name(params[:owner])
    if (@property)
	    @testoutdate = @property.finish_date
	    if (@testoutdate)
	    	@startdate = @testoutdate.to_time.advance(:years=>-1).to_date
	    end
	    @power_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,2) #ID and Power
	    if (@power_record_lookup)
	    	@power_recordings = Recording.find_all_by_acctnum_and_utility_type_id(@power_record_lookup.acct_num,2)
	    end
	    @gas_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,1)
	    if (@gas_record_lookup)
	    	@gas_recordings = Recording.find_all_by_acctnum_and_utility_type_id(@gas_record_lookup.acct_num,1)
	    end
	end
    #if (@power_record_lookup && @gas_record_lookup)
    	#@recordings = Recording.where(:acct_num => [@power_record_lookup.acct_num, @gas_record_lookup.acct_num])
    #elsif (@power_record_lookup && !@gas_record_lookup)

    #elsif (!@power_record_lookup && @gas_record_lookup)
    	
    #else

    #end

    #render :partial => 'report'
    respond_to do |format|
      format.html # gaps.html.erb
      #format.xml  { render :xml => @property }
    end
  end

  def null_account_export_report
    sql = "select 
	    owner_name,
	    -- property_id,
	    customer_unique_id,
	    company_name,
	    acct_num
	    -- record_lookups.utility_type_id
	from
	    properties
		left join
	    record_lookups ON properties.id = record_lookups.property_id
	where
	    company_name IS NULL OR acct_num IS NULL
	order by owner_name;"

    @records_array = ActiveRecord::Base.connection.execute(sql)
    header = ["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
    fields = 4
    
    respond_to do |format|
      format.html
      format.csv { send_data csv_export(header, @records_array, fields) }
    end
  end

  def analysis_ready_dominion_report
    sql = "SELECT 
	    temp.owner_name,
	    COUNT(temp.gooddata) AS acceptedDatapoints,
	    IF(COUNT(temp.gooddata) >= 24,
		'Ready',
		'Not Ready') AS readyToAnalyze
	FROM
	    (SELECT 
		properties.owner_name,
		    properties.customer_unique_id,
		    properties.finish_date,
		    record_lookups.company_name,
		    recordings.acctnum,
		    recordings.read_date,
		    recordings.consumption,
		    DATEDIFF(properties.finish_date, recordings.read_date) AS datediffnum,
		    IF(DATEDIFF(properties.finish_date, recordings.read_date) <= 395
			AND DATEDIFF(properties.finish_date, recordings.read_date) >= - 395, 1, 0) AS gooddata
	    FROM
		properties
	    INNER JOIN record_lookups ON record_lookups.property_id = properties.id
	    INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
	    WHERE
		record_lookups.company_name = 'DOMINION'
		    AND properties.finish_date IS NOT NULL) temp
	GROUP BY temp.owner_name;"
    @records_array = ActiveRecord::Base.connection.execute(sql)
    header = ["Owner Name", "Meter Readings", "Ready to Analyze"]
    fields = 3
    respond_to do |format|
      format.html
      format.csv { send_data csv_export(header, @records_array, fields) }
    end
 
  end
  
  def csv_export(header, data, fields)
    CSV.generate do |csv|
      csv << header #["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
      recordline = Array.new(fields)
      data.each do |record|
        puts record
        fields.times{ |i| recordline[i] = record[i]}
        csv << recordline #[record[0], record[2], record[3], record[4]]
        recordline = Array.new(fields)
      end
    end
  end  

  private
  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end

end
