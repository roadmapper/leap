class FilteringController < ApplicationController

  helper_method :sort_column, :sort_direction, :reset

  def index
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

    puts("measurescount > 0: " + measuretest.to_s)
    puts("has zip: " + ziptest.to_s)
    puts("has startdate: " + startdatetest.to_s)
    puts("has enddate:" + enddatetest.to_s)
    puts("full clause: " + fullclausetest.to_s)

    if (measuretest) then 
      @sql = "SELECT * From ((Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "

      @measures_array.each do |mid|
        @sql = @sql + mid.to_s + " ) Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "       
      end

      @sql = @sql.chomp("Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = ")

      @sql = @sql + ") AS tbl "

      if(params.has_key?(:zip) and params[:zip] != "") then
        puts("zip")
        @sql = @sql + "where tbl.zipcode=" + params[:zip]
        #date validation
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + " and tbl.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + " and tbl.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + " and tbl.finish_date < " + params[:enddate]
        end 
      elsif(params.has_key?(:enddate) and params[:enddate] != "")
        puts("nozip")
        puts("startdate or enddate")
        @sql = @sql + " where "
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + "tbl.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + "tbl.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + "tbl.finish_date < " + params[:enddate]
        end 
      end
      @sql = @sql + " GROUP BY tbl.ID HAVING COUNT(*)=" + @measurescount.to_s
    else
      if (ziptest and !(startdatetest or enddatetest)) then
        @sql = "select * from properties where properties.zipcode = " + params[:zip]
      elsif (ziptest and (startdatetest or enddatetest))
        @sql = @sql + "where properties.zipcode=" + params[:zip]
        #date validation
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + " and properties.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + " and properties.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + " and properties.finish_date < " + params[:enddate]
        end 
      else
        @sql = "select * from properties"
      end
    end
    puts("===========================================")
    puts(@sql)
    puts("===========================================")
    @properties = Property.paginate_by_sql(@sql, :page => params[:page],:per_page => 30)
    #@properties = ActiveRecord::Base.connection.execute(@sql).paginate(:page => params[:page])
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

    puts("measurescount > 0: " + measuretest.to_s)
    puts("has zip: " + ziptest.to_s)
    puts("has startdate: " + startdatetest.to_s)
    puts("has enddate:" + enddatetest.to_s)
    puts("full clause: " + fullclausetest.to_s)

    if (measuretest) then 
      @sql = "SELECT * From ((Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "

      @measures_array.each do |mid|
        @sql = @sql + mid.to_s + " ) Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "       
      end

      @sql = @sql.chomp("Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = ")

      @sql = @sql + ") AS tbl "

      if(params.has_key?(:zip) and params[:zip] != "") then
        puts("zip")
        @sql = @sql + "where tbl.zipcode=" + params[:zip]
        #date validation
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + " and tbl.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + " and tbl.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + " and tbl.finish_date < " + params[:enddate]
        end 
      elsif(params.has_key?(:enddate) and params[:enddate] != "")
        puts("nozip")
        puts("startdate or enddate")
        @sql = @sql + " where "
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + "tbl.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + "tbl.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + "tbl.finish_date < " + params[:enddate]
        end 
      end
      @sql = @sql + " GROUP BY tbl.ID HAVING COUNT(*)=" + @measurescount.to_s + ";"
    else
      if (ziptest and !(startdatetest or enddatetest)) then
        @sql = "select * from properties where properties.zipcode = " + params[:zip]
      elsif (ziptest and (startdatetest or enddatetest))
        @sql = @sql + "where properties.zipcode=" + params[:zip]
        #date validation
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + " and properties.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + " and properties.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + " and properties.finish_date < " + params[:enddate]
        end 
      else
        @sql = "select * from properties;"
      end
    end
    puts("===========================================")
    puts(@sql)
    puts("===========================================")
    @properties = ActiveRecord::Base.connection.execute(@sql)

    @IDCollection = ""
    @properties.each do |property|
        @IDCollection = @IDCollection + "'" + property[1] + "'" + ","
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

    puts("measurescount > 0: " + measuretest.to_s)
    puts("has zip: " + ziptest.to_s)
    puts("has startdate: " + startdatetest.to_s)
    puts("has enddate:" + enddatetest.to_s)
    puts("full clause: " + fullclausetest.to_s)

    if (measuretest) then 
      @sql = "SELECT * From ((Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "

      @measures_array.each do |mid|
        @sql = @sql + mid.to_s + " ) Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = "       
      end

      @sql = @sql.chomp("Union All (Select properties.* From properties Inner Join propertymeasures ON `propertymeasures`.`property_id` = `properties`.`id` WHERE `propertymeasures`.`installed_measure_type_id` = ")

      @sql = @sql + ") AS tbl "

      if(params.has_key?(:zip) and params[:zip] != "") then
        puts("zip")
        @sql = @sql + "where tbl.zipcode=" + params[:zip]
        #date validation
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + " and tbl.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + " and tbl.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + " and tbl.finish_date < " + params[:enddate]
        end 
      elsif(params.has_key?(:enddate) and params[:enddate] != "")
        puts("nozip")
        puts("startdate or enddate")
        @sql = @sql + " where "
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + "tbl.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + "tbl.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + "tbl.finish_date < " + params[:enddate]
        end 
      end
      @sql = @sql + " GROUP BY tbl.ID HAVING COUNT(*)=" + @measurescount.to_s + ";"
    else
      if (ziptest and !(startdatetest or enddatetest)) then
        @sql = "select * from properties where properties.zipcode = " + params[:zip]
      elsif (ziptest and (startdatetest or enddatetest))
        @sql = @sql + "where properties.zipcode=" + params[:zip]
        #date validation
        if params[:startdate] != "" and params.has_key?(:startdate) and params.has_key?(:enddate) and params[:enddate] != "" then
          @sql = @sql + " and properties.finish_date BETWEEN " + params[:startdate] + " AND " + params[:enddate]
        elsif params[:startdate] != "" and params.has_key?(:startdate)
          @sql = @sql + " and properties.finish_date > " + params[:startdate]
        elsif params[:enddate] != "" and params.has_key?(:enddate) 
          @sql = @sql + " and properties.finish_date < " + params[:enddate]
        end 
      else
        @sql = "select * from properties;"
      end
    end
    puts("===========================================")
    puts(@sql)
    puts("===========================================")
    @properties = ActiveRecord::Base.connection.execute(@sql)

    @IDCollection = ""
    @properties.each do |property|
        @IDCollection = @IDCollection + "'" + property[1] + "'" + ","
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
  format.csv { send_data csv_export(header, @records_array, fields), filename: "PRISM_Gas.csv" }
end
end

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

