class DashboardController < ApplicationController
    #USER, PASSWORD = 'dhh', 'secret'
    #before_filter :authentication_check   #, :except => :index
    include DashboardHelper
    
    def index
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
            
            Thread.new do
                Dir[path+"/*.xlsx"].each do |file|
                    file_path = "#{file}"
                    file_basename = File.basename(file, ".xlsx")
                    xlsx = Excelx.new(file_path.to_s)
                    $i = xlsx.sheets.length - 1
                    while $i >= 0 do
                        xlsx.default_sheet = xlsx.sheets[$i]
                        xlsx.to_csv(path +"/#{file_basename}#{$i}.csv")
                        Upload.where(:file_name => "#{file_basename}#{$i}.csv", :status => 'Not Processed', :upload_date => Time.now).first_or_create(:locked => false)
                        $i -=1
                    end
                    Upload.update_all( {:status => 'Converted'}, {:file_name => uploaded_io.original_filename})
                    ActiveRecord::Base.connection.close
                    end
                    #turn on if want to remove xlsx file after conversion (probably want to keep off so can check if xlsx file is already uploaded)
                    #FileUtils.remove(file)
                    #print "Converted file #{file} \n"
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
                @startdate = @testoutdate - 1.years 
                @enddate = @testoutdate + 1.years
                @electric_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,1) #ID and Electric
                if (@electric_record_lookup)
                    @electric_recordings = Recording.where("read_date >= :start_date AND read_date <= :end_date AND acctnum = :acct_num", {start_date: @startdate, end_date: @enddate, acct_num: @electric_record_lookup.acct_num}).order("read_date ASC")
                    
                end
                @gas_record_lookup = RecordLookup.find_by_property_id_and_utility_type_id(@property.id,2)
                if (@gas_record_lookup)    
                    @gas_recordings = Recording.where("read_date >= :start_date AND read_date <= :end_date AND acctnum = :acct_num", {start_date: @startdate, end_date: @enddate, acct_num: @gas_record_lookup.acct_num}).order("read_date ASC")
                end
                
                @months = Array.new
                for i in 0..23

                    @months.push(@startdate + i.months)

                end

                @startdate = @startdate.beginning_of_month 
                @enddate = @enddate.beginning_of_month 
                

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
