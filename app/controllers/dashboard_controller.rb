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
        #File.open("variables.json","w+") do |f|
        #    f.write(@variables.to_json)
        #end 
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @property }
        end
        
    end

    def property_report
        
        @utilitytypes = UtilityType.all.to_a
        @companynames= RecordLookup.uniq.pluck(:company_name)
        @recording = Recording.new
        @record_lookup = RecordLookup.new
        @num_electric_recordings = 0
        @num_gas_recordings = 0
        
        if params[:customer_unique_id]
            @property = Property.find_by_customer_unique_id(params[:customer_unique_id])
        elsif params[:owner]
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
                flash.now[:alert] = "This property does not contain a listed test out date!"
                #Add testout date functionality here??
            end
            
            else
            flash.now[:alert] = "A property with that owner name does not exist. Try again."
            redirect_to :action => 'index'
        end
    end

        
    def prism_report_electric
        if params[:owner]
            @property = Property.search(params[:owner])            
            @property = @property.shift
        end
        if @property
            sql = "select properties.customer_unique_id, MONTH(read_date),DAY(read_date),YEAR(recordings.read_date),recordings.consumption,utility_types.units,
    IF(recordings.read_date>properties.finish_date,'POST','PRE')
    ,'Carbon' as 'Group','R' as 'Flag'
    from properties 
    left join record_lookups on properties.id = record_lookups.property_id 
    left join recordings on record_lookups.acct_num = recordings.acctnum 
    left join utility_types on utility_types.id = recordings.utility_type_id 
    where customer_unique_id = '" + @property.customer_unique_id + "' and record_lookups.utility_type_id=1 
    ORDER BY ABS(UNIX_TIMESTAMP(recordings.read_date) - UNIX_TIMESTAMP(properties.finish_date)) 
    ASC LIMIT 22";
            @records_array = ActiveRecord::Base.connection.execute(sql)

            header = ["Building ID", "Month", "Day", "Year","Consumption","Units","P-Field","Group","Flag"]
            fields = 9
            respond_to do |format|
                format.html
                format.csv { send_data csv_export(header, @records_array, fields) }
            end
        else
            flash[:alert] = "A property with that owner name does not exist. Try again."
            redirect_to :action => 'index'
        end
    end

    def prism_report_gas
        if params[:owner]
            @property = Property.search(params[:owner])            
            @property = @property.shift
        end
        if @property
            sql = "select properties.customer_unique_id, MONTH(read_date),DAY(read_date),YEAR(recordings.read_date),recordings.consumption,utility_types.units,
    IF(recordings.read_date>properties.finish_date,'POST','PRE')
    ,'Carbon' as 'Group','R' as 'Flag'
    from properties 
    left join record_lookups on properties.id = record_lookups.property_id 
    left join recordings on record_lookups.acct_num = recordings.acctnum 
    left join utility_types on utility_types.id = recordings.utility_type_id 
    where customer_unique_id = '" << @property.customer_unique_id << "' and record_lookups.utility_type_id=2 
    ORDER BY ABS(UNIX_TIMESTAMP(recordings.read_date) - UNIX_TIMESTAMP(properties.finish_date)) 
    ASC LIMIT 22";
            @records_array = ActiveRecord::Base.connection.execute(sql)

            header = ["Building ID", "Month", "Day", "Year","Consumption","Units","P-Field","Group","Flag"]
            fields = 9
            respond_to do |format|
                format.html
                format.csv { send_data csv_export(header, @records_array, fields) }
            end
        else
            flash[:alert] = "A property with that owner name does not exist. Try again."
            redirect_to :action => 'index'
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
