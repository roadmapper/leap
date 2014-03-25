class DashboardController < ApplicationController
    #autocomplete :property, :owner_name
    #USER, PASSWORD = 'dhh', 'secret'
    #before_filter :authentication_check   #, :except => :index
    include DashboardHelper
    include PropertiesHelper
    
    def index
        @variables = Property.find(:all).map { |x| x.owner_name+" - "+x.street_address }#&:owner_name)
        #@addresses = Property.find(:all, :select=>'street_address').map(&:street_address)
        #@variables = @names+@addresses #Property.select([:owner_name, :street_address]).map {|e| {owner_name: e.owner_name, street_address: e.street_address} }
        #@property = Property.find_by_owner_name(params[:owner])
        #@property = Property.search(params[:owner])
        #city, state, zipcode
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @property }
        end
        
    end
    
    def property_report
        
        @utilitytypes = UtilityType.all.to_a
        @recording = Recording.new
        @record_lookup = RecordLookup.new
        @num_electric_recordings = 0
        @num_gas_recordings = 0
        
        if params[:owner]
            @property = Property.search(params[:owner])
            @property = @property.shift
        end
        if (@property)
            
            @testoutdate = @property.finish_date
            
            if (@testoutdate)
                @startdate = start_date(@testoutdate);
                @enddate = end_date(@testoutdate);
                
                @months = gap_months(@startdate)
                
                @electric_record_lookups = RecordLookup.where("property_id = ? AND utility_type_id = ?", @property.id, 1).to_a #ID and Electric
                
                if (!@electric_record_lookups.blank?)
                    
                    @electric_recordings = get_records(@electric_record_lookups, @startdate, @enddate)
                    
                    if(@electric_recordings)
                        if(@electric_recordings.length > 0)
                            @electric_gap_data = get_data(@electric_recordings, @startdate)
                            @num_electric_recordings = get_data_count(@electric_recordings, @startdate)
                            #@missing_electric_dates = get_missing_dates(@electric_recordings, @startdate)
                            else
                            @electric_recordings = nil;
                        end
                    end
                    
                end
                
                @gas_record_lookups = RecordLookup.where("property_id = ? AND utility_type_id = ?", @property.id, 2).to_a
                
                if (!@gas_record_lookups.blank?)
                    @gas_recordings = get_records(@gas_record_lookups, @startdate, @enddate)
                    if(@gas_recordings)
                        if(@gas_recordings.length > 0)
                            @gas_gap_data = get_data(@gas_recordings, @startdate)
                            @num_gas_recordings = get_data_count(@gas_recordings, @startdate)
                            #@missing_gas_dates = get_missing_dates(@gas_recordings, @startdate)
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
    
    def update
        
        respond_to do |format|
            if @property.update_attributes(params[:property])
                format.html { redirect_to(@property, :notice => 'Property was successfully updated.') }
                format.xml  { head :ok }
                else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
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
