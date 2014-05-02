class FilteringController < ApplicationController

  helper_method :sort_column, :sort_direction, :reset

  def index
    @measures = InstalledMeasureType.all

  	#@properties = Property.paginate(:page => params[:page])
    @measurescount = 0
    @sql = ""
    @measures_array = []
    #Figure out which parameters are in the URL
    @measures.each do |measure|
      if params[eval(":attr" + measure.id.to_s)] == 'on' and params.has_key?(eval(":attr" + measure.id.to_s)) then
        @measurescount = @measurescount + 1
        @measures_array.push(measure.id)
      end
    end
    
    #These will store the start and end date in string format
    @startdate
    @enddate

    #Whether to flash errors about zip, start, end date format
    zipflash = false
    startdateflash = false
    enddateflash = false

    #These will be used to create the SQL query
    measuretest = (@measurescount > 0)
    ziptest = (params.has_key?(:zip) and params[:zip] != "")
    startdatetest = (params[:startdate] != "" and params.has_key?(:startdate))
    enddatetest = (params[:enddate] != "" and params.has_key?(:enddate))

    #Validate zip code
    if (ziptest) then
      if params[:zip] =~ /\d{5}/ then
      else
        ziptest = false
        zipflash = true
      end
    end

    #Validate Start Date
    if (startdatetest) then
      begin 
        # try format mm/dd/yyyy. single digit m/d allowed also
        @startdate = Date.strptime(params[:startdate],"%m/%d/%y").to_s
        if @startdate == "" then
          startdatetest = false
          startdateflash = true
        end
      rescue ArgumentError
        startdatetest = false
        startdateflash = true
      end
    end

    #Validate Enddate
    if (enddatetest) then
      begin 
        # try format mm/dd/yyyy. single digit m/d allowed also
        @enddate = Date.strptime(params[:enddate],"%m/%d/%y").to_s
        if @enddate == "" then
          enddatetest = false
          enddateflash = true
        end
      rescue ArgumentError
        enddatetest = false
        enddateflash = true
      end
    end

    #Will contain the final message to flash
    flashmessage = "Improper "
    
    #Check to see if zip or start or end dates are invalid
    if ((zipflash and startdateflash) and enddateflash) then
      flashmessage = flashmessage + "Zip Code, Start Date, and End Date"
    elsif (startdateflash and enddateflash) then
      flashmessage = flashmessage + "Start Date and End Date"
    elsif (zipflash and startdateflash) then
      flashmessage = flashmessage + "Zip Code and Start Date"
    elsif (zipflash and enddateflash) then
      flashmessage = flashmessage + "Zip Code and End Date"
    elsif (zipflash) then
      flashmessage = flashmessage + "Zip Code"
    elsif (startdateflash) then
      flashmessage = flashmessage + "Start Date"
    elsif (enddateflash) then
      flashmessage = flashmessage + "End Date"
    end
    if ((zipflash or startdateflash) or enddateflash) then
      flashmessage = flashmessage + " Format."
      flash[:error] = flashmessage
    else
      flash[:error] = nil
    end


    #If filtering based on measures
    if (measuretest) then 
      #Subquery created for each measure we're looking for. Unioned together and if the count for the record is the same
      # as the number of measures we're looking for, then the property in question has all the measures
      @sql = "SELECT * From ((Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "

      @measures_array.each do |mid|
        @sql = @sql + mid.to_s + " ) Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "       
      end

      @sql = @sql.chomp("Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = ")

      @sql = @sql + ") AS tbl "
      
      #Add zip code
      if(ziptest) then
        @sql = @sql + "where tbl.zipcode=" + params[:zip]
        #zip and maybe dates
        if startdatetest and enddatetest then
          @sql = @sql + " and tbl.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " and tbl.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " and tbl.finish_date <= '" + @enddate + "'"
        end 
      elsif(startdatetest or enddatetest)
        #dates but no zip
        @sql = @sql + " where "
        if startdatetest and enddatetest then
          @sql = @sql + " tbl.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " tbl.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " tbl.finish_date <= '" + @enddate + "'"
        end 
      end
      @sql = @sql + " GROUP BY tbl.ID HAVING COUNT(*)=" + @measurescount.to_s;
    else
      #no measures to filter by
      if (ziptest and !(startdatetest or enddatetest)) then
        #zip but no dates
        @sql = "select * from properties where properties.zipcode = " + params[:zip]
      elsif (ziptest and (startdatetest or enddatetest))
        @sql = "select * from properties where properties.zipcode='" + params[:zip] + "'"
        #zip and maybe dates
        if startdatetest and enddatetest then
          @sql = @sql + " and (properties.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "')"
        elsif startdatetest
          @sql = @sql + " and properties.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " and properties.finish_date <= '" + @enddate + "'"
        end 
      elsif (!ziptest and (startdatetest or enddatetest)) then
        #no zip but dates
        @sql = "select * from properties"
        if startdatetest and enddatetest then
          @sql = @sql + " where properties.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " where properties.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " where properties.finish_date <= '" + @enddate + "'"
        end 
      else
        #no zip no dates no measures
        @sql = "select * from properties"
      end
    end
    #add pagination
    @properties = Property.paginate_by_sql(@sql, :page => params[:page],:per_page => 30)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
      format.csv { render :csv => @properties}
    end
  end


  def prism_report_electric
        @measures = InstalledMeasureType.all

    #@properties = Property.paginate(:page => params[:page])
    @measurescount = 0
    @sql = ""
    @measures_array = []
    @measures.each do |measure|
      if params[eval(":attr" + measure.id.to_s)] == 'on' and params.has_key?(eval(":attr" + measure.id.to_s)) then
        @measurescount = @measurescount + 1
        @measures_array.push(measure.id)
      end
    end
    measuretest = (@measurescount > 0)
    ziptest = (params.has_key?(:zip) and params[:zip] != "")
    startdatetest = (params[:startdate] != "" and params.has_key?(:startdate))
    enddatetest = (params[:enddate] != "" and params.has_key?(:enddate))
    fullclausetest = (measuretest or ziptest) or (startdatetest or enddatetest)

    @startdate
    @enddate

    if (startdatetest) then
      @startdate = Date.strptime(params[:startdate],"%m/%d/%y").to_s
      puts("\033[31mSTART DATE FROM PARAMS: " + params[:startdate] + "\033[0m")

      puts("\033[31mSTART DATE: " + @startdate + "\033[0m")
    end

    if enddatetest then
      @enddate = Date.strptime(params[:enddate],"%m/%d/%y").to_s
      puts("\033[31mEND DATE FROM PARAMS: " + params[:enddate] + "\033[0m")
      puts("\033[31mEND DATE: " + @enddate + "\033[0m")
    end

      #If filtering based on measures
    if (measuretest) then 
      #Subquery created for each measure we're looking for. Unioned together and if the count for the record is the same
      # as the number of measures we're looking for, then the property in question has all the measures
      @sql = "SELECT * From ((Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "

      @measures_array.each do |mid|
        @sql = @sql + mid.to_s + " ) Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "       
      end

      @sql = @sql.chomp("Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = ")

      @sql = @sql + ") AS tbl "
      
      #Add zip code
      if(ziptest) then
        @sql = @sql + "where tbl.zipcode=" + params[:zip]
        #zip and maybe dates
        if startdatetest and enddatetest then
          @sql = @sql + " and tbl.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " and tbl.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " and tbl.finish_date <= '" + @enddate + "'"
        end 
      elsif(startdatetest or enddatetest)
        #dates but no zip
        @sql = @sql + " where "
        if startdatetest and enddatetest then
          @sql = @sql + " tbl.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " tbl.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " tbl.finish_date <= '" + @enddate + "'"
        end 
      end
      @sql = @sql + " GROUP BY tbl.ID HAVING COUNT(*)=" + @measurescount.to_s;
    else
      #no measures to filter by
      if (ziptest and !(startdatetest or enddatetest)) then
        #zip but no dates
        @sql = "select * from properties where properties.zipcode = " + params[:zip]
      elsif (ziptest and (startdatetest or enddatetest))
        @sql = @sql + "select * from properties where properties.zipcode=" + params[:zip]
        #zip and maybe dates
        if startdatetest and enddatetest then
          @sql = @sql + " and properties.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " and properties.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " and properties.finish_date <= '" + @enddate + "'"
        end 
      elsif (!ziptest and (startdatetest or enddatetest)) then
        #no zip but dates
        @sql = "select * from properties"
        if startdatetest and enddatetest then
          @sql = @sql + " where properties.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " where properties.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " where properties.finish_date <= '" + @enddate + "'"
        end 
      else
        #no zip no dates no measures
        @sql = "select * from properties"
      end
    end

    #execute sql
    @properties = ActiveRecord::Base.connection.execute(@sql + ";")

    #collect IDs that we will create report for
    @IDCollection = ""
    @properties.each do |property|
        @IDCollection = @IDCollection + "'" + property[1] + "'" + ","
    end
    @IDCollection.chop!
    #Vinay made this SQL query, basically finds 12 closest records to test out date pre and post that have correct utility type
    # id, and adds other PRISM format info
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
    #returns result as CSV
    respond_to do |format|
      format.html
      format.csv { send_data csv_export(header, @records_array, fields),filename: "PRISM_Electric.csv" }
    end
end

def prism_report_gas
        @measures = InstalledMeasureType.all

    #@properties = Property.paginate(:page => params[:page])
    @measurescount = 0
    @sql = ""
    @measures_array = []
    @measures.each do |measure|
      if params[eval(":attr" + measure.id.to_s)] == 'on' and params.has_key?(eval(":attr" + measure.id.to_s)) then
        @measurescount = @measurescount + 1
        @measures_array.push(measure.id)
      end
    end
    measuretest = (@measurescount > 0)
    ziptest = (params.has_key?(:zip) and params[:zip] != "")
    startdatetest = (params[:startdate] != "" and params.has_key?(:startdate))
    enddatetest = (params[:enddate] != "" and params.has_key?(:enddate))
    fullclausetest = (measuretest or ziptest) or (startdatetest or enddatetest)

    @startdate
    @enddate

    if (startdatetest) then
      @startdate = Date.strptime(params[:startdate],"%m/%d/%y").to_s
    end

    if enddatetest then
      @enddate = Date.strptime(params[:enddate],"%m/%d/%y").to_s
    end


      #If filtering based on measures
    if (measuretest) then 
      #Subquery created for each measure we're looking for. Unioned together and if the count for the record is the same
      # as the number of measures we're looking for, then the property in question has all the measures
      @sql = "SELECT * From ((Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "

      @measures_array.each do |mid|
        @sql = @sql + mid.to_s + " ) Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "       
      end

      @sql = @sql.chomp("Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = ")

      @sql = @sql + ") AS tbl "
      
      #Add zip code
      if(ziptest) then
        @sql = @sql + "where tbl.zipcode=" + params[:zip]
        #zip and maybe dates
        if startdatetest and enddatetest then
          @sql = @sql + " and tbl.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " and tbl.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " and tbl.finish_date <= '" + @enddate + "'"
        end 
      elsif(startdatetest or enddatetest)
        #dates but no zip
        @sql = @sql + " where "
        if startdatetest and enddatetest then
          @sql = @sql + " tbl.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " tbl.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " tbl.finish_date <= '" + @enddate + "'"
        end 
      end
      @sql = @sql + " GROUP BY tbl.ID HAVING COUNT(*)=" + @measurescount.to_s;
    else
      #no measures to filter by
      if (ziptest and !(startdatetest or enddatetest)) then
        #zip but no dates
        @sql = "select * from properties where properties.zipcode = " + params[:zip]
      elsif (ziptest and (startdatetest or enddatetest))
        @sql = @sql + "select * from properties where properties.zipcode=" + params[:zip]
        #zip and maybe dates
        if startdatetest and enddatetest then
          @sql = @sql + " and properties.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " and properties.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " and properties.finish_date <= '" + @enddate + "'"
        end 
      elsif (!ziptest and (startdatetest or enddatetest)) then
        #no zip but dates
        @sql = "select * from properties"
        if startdatetest and enddatetest then
          @sql = @sql + " where properties.finish_date BETWEEN '" + @startdate + "' AND '" + @enddate + "'"
        elsif startdatetest
          @sql = @sql + " where properties.finish_date >= '" + @startdate + "'"
        elsif enddatetest
          @sql = @sql + " where properties.finish_date <= '" + @enddate + "'"
        end 
      else
        #no zip no dates no measures
        @sql = "select * from properties"
      end
    end
    #execute sql
    @properties = ActiveRecord::Base.connection.execute(@sql + ";")

    #collect IDs that we will create report for
    @IDCollection = ""
    @properties.each do |property|
        @IDCollection = @IDCollection + "'" + property[1] + "'" + ","
    end
    @IDCollection.chop!
    #Vinay made this SQL query, basically finds 12 closest records to test out date pre and post that have correct utility type
    # id, and adds other PRISM format info
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
    #returns result as CSV
    respond_to do |format|
      format.html
      format.csv { send_data csv_export(header, @records_array, fields),filename: "PRISM_Electric.csv" }
    end
end

#Function to Simplify CSV Export
def csv_export(header, data, fields)
  CSV.generate do |csv|
    csv << header #["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
    recordline = Array.new(fields)
    data.each do |record|
            #puts record
      fields.times{ |i| recordline[i] = record[i]}
        csv << recordline #[record[0], record[2], record[3], record[4]]
        recordline = Array.new(fields)
      end
    end
  end

end

