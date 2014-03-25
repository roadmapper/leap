class FilteringController < ApplicationController

  helper_method :sort_column, :sort_direction, :reset

  def index
  	@properties = Property.paginate(:page => params[:page]).order(sort_column + ' ' + sort_direction)
    #zip validation
    if params.has_key?(:zip) and params[:zip] != "" then 
      @properties = @properties.where(zipcode: params[:zip]) 
    end
    #date validation
    if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
      startdate = Date.strptime(params[:startdate],'%m/%d/%Y')
      enddate = Date.strptime(params[:enddate],'%m/%d/%Y')
      @properties = @properties.where(finish_date: (startdate..enddate))
    elsif params[:startdate] != "" and params.has_key?(:startdate)
      startdate = Date.strptime(params[:startdate],'%m/%d/%Y')
      @properties = @properties.where(finish_date: (startdate..Date.today))
    elsif params[:enddate] != "" and params.has_key?(:enddate) 
      startdate = Date.strptime("01/01/2001",'%m/%d/%Y')
      enddate = Date.strptime(params[:enddate],'%m/%d/%Y')
      @properties = @properties.where('finish_date < ?', enddate)
    end
    #installed measures validation

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
      format.csv { render :csv => @properties}
    end
  end


     def prism_report_electric
          @properties = Property.paginate(:page => params[:page]).order(sort_column + ' ' + sort_direction)

        if params.has_key?(:zip) and params[:zip] != "" then 
          @properties = @properties.where(zipcode: params[:zip]) 
        end
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          startdate = Date.strptime(params[:startdate],'%m/%d/%Y')
          enddate = Date.strptime(params[:enddate],'%m/%d/%Y')
          @properties = @properties.where(finish_date: (startdate..enddate))
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          startdate = Date.strptime(params[:startdate],'%m/%d/%Y')
          @properties = @properties.where(finish_date: (startdate..Date.today))
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          startdate = Date.strptime("01/01/2001",'%m/%d/%Y')
          enddate = Date.strptime(params[:enddate],'%m/%d/%Y')
          @properties = @properties.where('finish_date < ?', enddate)
        end
        @records_array = Array.new
        for @property in @properties
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
              current = ActiveRecord::Base.connection.execute(sql)
              @records_array = @records_array.concat current.to_a
          end
        end

          header = ["Building ID", "Month", "Day", "Year","Consumption","Units","P-Field","Group","Flag"]
          fields = 9
          respond_to do |format|
              format.html
              format.csv { send_data csv_export(header, @records_array, fields) }
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

  def sort_column
    Property.column_names.include?(params[:sort]) ? params[:sort] : "customer_unique_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
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
    
end
