class DashboardController < ApplicationController
    #autocomplete :property, :owner_name
    #USER, PASSWORD = 'dhh', 'secret'
    #before_filter :authentication_check   #, :except => :index
    include DashboardHelper
    include PropertiesHelper

    def index
        @names = Property.find(:all, :select=>'owner_name').map(&:owner_name)
        @property = Property.find_by_owner_name(params[:owner])
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @property }
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
            
	    csvPath = nil 
	    csvName = nil
            Thread.new do
                Dir[path+"/*.xlsx"].each do |file|
                    file_path = "#{file}"
                    file_basename = File.basename(file, ".xlsx")
                    xlsx = Excelx.new(file_path.to_s)
                    $i = xlsx.sheets.length - 1
                    while $i >= 0 do
                        xlsx.default_sheet = xlsx.sheets[$i]
			csvName = "#{file_basename}#{$i}.csv"
			csvPath = path + "/" + csvName
                        xlsx.to_csv(csvPath)
                        Upload.where(:file_name => "#{file_basename}#{$i}.csv", :status => 'Not Processed', :upload_date => Time.now).first_or_create(:locked => false)
                        $i -=1
                    end
                    Upload.update_all( {:status => 'Converted'}, {:file_name => uploaded_io.original_filename})
                    ActiveRecord::Base.connection.close
                    end
                    #turn on if want to remove xlsx file after conversion (probably want to keep off so can check if xlsx file is already uploaded)
                    #FileUtils.remove(file)

############temp location############################
		Thread.new do
			fields_to_insert = %w{ ID_BA DT_READ AMT_KWH DAYS_USED ContractAcct. Consumption }
			rows_to_insert = []
		
			CSV.foreach(csvPath, headers: true) do |row|
			  row_to_insert = row.to_hash.select { |k, v| fields_to_insert.include?(k) }
			 #row.to_hash.values_at(*fields_to_insert)
			  #rows_to_insert << row_to_insert

			  stringdate = row_to_insert["DT_READ"]
		          date = DateTime.new(1899,12,30) + Integer(stringdate).days 
			  
	   		  #formatted_date = date.strftime('%a %b %d %Y')
			  
			Recording.where({"acctnum"=>row_to_insert["ID_BA"], "consumption"=>row_to_insert["AMT_KWH"], "days_in_month"=>row_to_insert["DAYS_USED"], "read_date"=>date}).first_or_create(:locked => false)
			end
			Upload.update_all( {:status => 'Processed'}, {:file_name => csvName})
		end
############temp location############################
                end
	        

                elsif File.exists?(path + "//" + filename)
                flash[:notice] = "Duplicate file exists. File was not uploaded successfully to: " + path
                else
                flash[:notice] = "File was not uploaded successfully to: " + path
            end
            
            redirect_to :action => 'index'
        end
    end
    
    def gaps
        @property = Property.find_by_owner_name(params[:owner])
        if (@property)
            @testoutdate = @property.finish_date
            if (@testoutdate)
                @startdate = start_date(@testoutdate);
                @enddate = end_date(@testoutdate);
                
                @months = gap_months(@startdate)
                
                @electric_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,1) #ID and Electric
                
                if (@electric_record_lookup)
                    @electric_recordings = get_records(@electric_record_lookup, @startdate, @enddate)
                    if(@electric_recordings)
                        if(@electric_recordings.length >= 0)
                            @electric_gap_data = get_data(@electric_recordings, @startdate)
                            # puts @electric_gap_data
                            else
                            @electric_recordings = nil;
                        end
                    end
                    
                end
                
                @gas_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,2)
                if (@gas_record_lookup)    
                    @gas_recordings = get_records(@gas_record_lookup, @startdate, @enddate)
                    if(@gas_recordings)
                        if(@gas_recordings.length >= 0)
                            @gas_gap_data = get_data(@gas_recordings, @startdate)
                            # puts @gas_gap_data
                        else
                            @gas_recordings = nil;
                        end
                    end
                end
                
            else
                flash[:alert] = "This property does not contain a listed test out date!"
                #Add testout date functionality here??
            end
            
            else
            flash[:alert] = "A property with that owner name does not exist. Try again."
            redirect_to :action => 'index'
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
		temp.acctnum,
        COUNT(temp.gooddata) AS acceptedDatapoints,
        IF(COUNT(temp.gooddata) >= 24,
           'Ready',
           'Not Ready') AS readyToAnalyze
           FROM
           (SELECT
           properties.owner_name,
            properties.customer_unique_id,
            properties.finish_date,
			DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY) AS first_day_of_month,
            record_lookups.company_name,
            recordings.acctnum,
            recordings.read_date,
            recordings.consumption,
            DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) AS datediffnum,
            IF(DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) <= 365
               AND DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) >= - 365, 1, NULL) AS gooddata
            FROM
            properties
            INNER JOIN record_lookups ON record_lookups.property_id = properties.id
            INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
            WHERE
            record_lookups.company_name = 'DOMINION'
            AND properties.finish_date IS NOT NULL) temp
            GROUP BY temp.owner_name, temp.acctnum
			ORDER BY acceptedDatapoints DESC;"
            @records_array = ActiveRecord::Base.connection.execute(sql)
            header = ["Owner Name", "Dominion Account Number", "Meter Readings", "Ready to Analyze"]
            fields = 4
            respond_to do |format|
                format.html
                format.csv { send_data csv_export(header, @records_array, fields) }
            end            
    end

    def analysis_ready_cvillegas_report
      sql = "SELECT
        temp.owner_name,
                temp.acctnum,
        COUNT(temp.gooddata) AS acceptedDatapoints,
        IF(COUNT(temp.gooddata) >= 24,
           'Ready',
           'Not Ready') AS readyToAnalyze
           FROM
           (SELECT
           properties.owner_name,
            properties.customer_unique_id,
            properties.finish_date,
                        DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY) AS first_day_of_month,
            record_lookups.company_name,
            recordings.acctnum,
            recordings.read_date,
            recordings.consumption,
            DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) AS datediffnum,
            IF(DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) <= 365
               AND DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) >= - 365, 1, NULL) AS gooddata
            FROM
            properties
            INNER JOIN record_lookups ON record_lookups.property_id = properties.id
            INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
            WHERE
            record_lookups.company_name = 'CVILLEGAS'
            AND properties.finish_date IS NOT NULL) temp
            GROUP BY temp.owner_name, temp.acctnum
                        ORDER BY acceptedDatapoints DESC;"
            @records_array = ActiveRecord::Base.connection.execute(sql)
            header = ["Owner Name", "Charlottesville Gas Account Number", "Meter Readings", "Ready to Analyze"]
            fields = 4
            respond_to do |format|
                format.html
                format.csv { send_data csv_export(header, @records_array, fields) }
            end
    end

    def utility_request_dominion_report
      sql = "SELECT
        temp.owner_name,
                        CONCAT(temp.street_address, ' ', temp.city, ', ', temp.state, ' ', temp.zipcode) AS address,
                temp.acctnum,
                COUNT(temp.gooddata) AS acceptedDatapoints
        FROM
           (SELECT
           properties.owner_name,
                        properties.street_address,
                        properties.city,
                        properties.state,
                        properties.zipcode,
            properties.customer_unique_id,
            properties.finish_date,
                        DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY) AS first_day_of_month,
            record_lookups.company_name,
            recordings.acctnum,
            recordings.read_date,
            recordings.consumption,
            DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) AS datediffnum,
            IF(DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) <= 365
               AND DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) >= - 365, 1, NULL) AS gooddata
            FROM
            properties
            INNER JOIN record_lookups ON record_lookups.property_id = properties.id
            INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
            WHERE
            record_lookups.company_name = 'DOMINION'
            AND properties.finish_date IS NOT NULL) temp
GROUP BY temp.owner_name, temp.acctnum
HAVING COUNT(temp.gooddata) < 24
                        ORDER BY acceptedDatapoints DESC;"
            @records_array = ActiveRecord::Base.connection.execute(sql)
            header = ["Owner Name", "Address", "Account Number", "Acceptable Meter Readings"]
            fields = 4
            respond_to do |format|
                format.html
                format.csv { send_data csv_export(header, @records_array, fields) }
            end
    end

    def utility_request_cvillegas_report
      sql = "SELECT
        temp.owner_name,
			CONCAT(temp.street_address, ' ', temp.city, ', ', temp.state, ' ', temp.zipcode) AS address,
                temp.acctnum,
                COUNT(temp.gooddata) AS acceptedDatapoints
        FROM
           (SELECT
           properties.owner_name,
			properties.street_address,
			properties.city,
			properties.state,
			properties.zipcode,
            properties.customer_unique_id,
            properties.finish_date,
                        DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY) AS first_day_of_month,
            record_lookups.company_name,
            recordings.acctnum,
            recordings.read_date,
            recordings.consumption,
            DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) AS datediffnum,
            IF(DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) <= 365
               AND DATEDIFF(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 1 DAY), recordings.read_date) >= - 365, 1, NULL) AS gooddata
            FROM
            properties
            INNER JOIN record_lookups ON record_lookups.property_id = properties.id
            INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
            WHERE
            record_lookups.company_name = 'CVILLEGAS'
            AND properties.finish_date IS NOT NULL) temp
GROUP BY temp.owner_name, temp.acctnum
HAVING COUNT(temp.gooddata) < 24
                        ORDER BY acceptedDatapoints DESC;"
            @records_array = ActiveRecord::Base.connection.execute(sql)
            header = ["Owner Name", "Address", "Account Number", "Acceptable Meter Readings"]
            fields = 4
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
