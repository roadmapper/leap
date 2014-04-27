class FilteringController < ApplicationController

  helper_method :sort_column, :sort_direction, :reset

  def index
    @measures = InstalledMeasureType.all

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
        @properties = Property.where('finish_date' != nil)

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
        @IDCollection = ""
        for @property in @properties
          if params[:owner]
              @property = Property.search(params[:owner])            
              @property = @property.shift
          end
          if @property
              @IDCollection = @IDCollection + "'" + @property.customer_unique_id + "'" + ","
          end
 
        end
         @IDCollection.chop!
          sql = "SELECT
              temp.customer_unique_id,
              temp.date_month,
              temp.date_day,
              temp.date_year,
              temp.consumption,
              temp.units,
              temp.date_PRE_POST,
              temp.group_field,
              temp.flag
          FROM
              (SELECT
                  temp.customer_unique_id,
                      MONTH(temp.read_date) AS date_month,
                      DAY(temp.read_date) AS date_day,
                      YEAR(temp.read_date) AS date_year,
                      temp.consumption,
                      temp.units,
                      IF(temp.read_date > temp.finish_date, 'POST', 'PRE') AS date_PRE_POST,
                      '' AS 'group_field',
                      'R' AS 'flag',
                      IF(temp.read_date > temp.start_date
                          AND temp.read_date < temp.end_date, 1, NULL) AS gooddata
              FROM
                  (SELECT
                  properties.owner_name,
                      properties.id,
                      properties.customer_unique_id,
                      properties.finish_date,
                      record_lookups.company_name,
                      recordings.acctnum,
                      recordings.read_date,
                      recordings.consumption,
                      utility_types.units,
                      IF(EXTRACT(DAY FROM properties.finish_date) < 15, DATE_SUB(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), DATE_ADD(DATE_SUB(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), INTERVAL 1 MONTH)) AS start_date,
                      IF(EXTRACT(DAY FROM properties.finish_date) < 15, DATE_ADD(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), DATE_ADD(DATE_ADD(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), INTERVAL 1 MONTH)) AS end_date
              FROM
                  properties
              INNER JOIN record_lookups ON record_lookups.property_id = properties.id
              INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
              LEFT JOIN utility_types ON utility_types.id = recordings.utility_type_id
              WHERE
                  record_lookups.utility_type_id = '1'
                      AND properties.finish_date IS NOT NULL) temp) temp
          WHERE
              temp.gooddata IS NOT NULL
                  AND temp.customer_unique_id IN (" + @IDCollection + ")
          ORDER BY temp.customer_unique_id ASC , temp.date_year ASC , temp.date_month ASC , temp.date_day ASC;";
          @records_array = ActiveRecord::Base.connection.execute(sql)
          header = ["Building ID", "Month", "Day", "Year","Consumption","Units","P-Field","Group","Flag"]
          fields = 9
          respond_to do |format|
              format.html
              format.csv { send_data csv_export(header, @records_array, fields) }
          end
    end

    def prism_report_gas
        @properties = Property.where('finish_date' != nil)

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
        @IDCollection = ""
        for @property in @properties
          if params[:owner]
              @property = Property.search(params[:owner])            
              @property = @property.shift
          end
          if @property
              @IDCollection = @IDCollection + "'" + @property.customer_unique_id + "'" + ","
          end
 
        end
         @IDCollection.chop!
          sql = "SELECT
              temp.customer_unique_id,
              temp.date_month,
              temp.date_day,
              temp.date_year,
              temp.consumption,
              temp.units,
              temp.date_PRE_POST,
              temp.group_field,
              temp.flag
          FROM
              (SELECT
                  temp.customer_unique_id,
                      MONTH(temp.read_date) AS date_month,
                      DAY(temp.read_date) AS date_day,
                      YEAR(temp.read_date) AS date_year,
                      temp.consumption,
                      temp.units,
                      IF(temp.read_date > temp.finish_date, 'POST', 'PRE') AS date_PRE_POST,
                      '' AS 'group_field',
                      'R' AS 'flag',
                      IF(temp.read_date > temp.start_date
                          AND temp.read_date < temp.end_date, 1, NULL) AS gooddata
              FROM
                  (SELECT
                  properties.owner_name,
                      properties.id,
                      properties.customer_unique_id,
                      properties.finish_date,
                      record_lookups.company_name,
                      recordings.acctnum,
                      recordings.read_date,
                      recordings.consumption,
                      utility_types.units,
                      IF(EXTRACT(DAY FROM properties.finish_date) < 15, DATE_SUB(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), DATE_ADD(DATE_SUB(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), INTERVAL 1 MONTH)) AS start_date,
                      IF(EXTRACT(DAY FROM properties.finish_date) < 15, DATE_ADD(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), DATE_ADD(DATE_ADD(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), INTERVAL 1 MONTH)) AS end_date
              FROM
                  properties
              INNER JOIN record_lookups ON record_lookups.property_id = properties.id
              INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
              LEFT JOIN utility_types ON utility_types.id = recordings.utility_type_id
              WHERE
                  record_lookups.utility_type_id = '2'
                      AND properties.finish_date IS NOT NULL) temp) temp
          WHERE
              temp.gooddata IS NOT NULL
                  AND temp.customer_unique_id IN (" + @IDCollection + ")
          ORDER BY temp.customer_unique_id ASC , temp.date_year ASC , temp.date_month ASC , temp.date_day ASC;";
          @records_array = ActiveRecord::Base.connection.execute(sql)
          header = ["Building ID", "Month", "Day", "Year","Consumption","Units","P-Field","Group","Flag"]
          fields = 9
          respond_to do |format|
              format.html
              format.csv { send_data csv_export(header, @records_array, fields) }
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
