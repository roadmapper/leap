class AnalysisController < ApplicationController

  def index
  end

  def null_accounts
    @n_accounts = Report::NullAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
    column_names = Report::NullAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::NullAccount.all, column_names) }
      ajax_respond format, :section_id => "null_accounts"
    end
  end

  def dominion_ready_accounts
    @accounts = Report::DominionReadyAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Meter Readings"]
    column_names = Report::DominionReadyAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::DominionReadyAccount.all, column_names) }
      ajax_respond format, :section_id => "dominion_ready_accounts"
    end
  end

  def dominion_ready_accounts_prism
    customers = Report::DominionReadyAccount.pluck(:customer_unique_id)
    @records_array = prism_report(customers, "DOMINION")
    header = ["Building ID", "Month", "Day", "Year", "Consumption", "Units", "P-Field", "Group", "Flag"]
    fields = 9 
    respond_to do |format|
      format.csv { send_data csv_export_raw_sql(header, @records_array, fields) }
    end
  end

  def cvillegas_ready_accounts
    @c_accounts = Report::CvillegasReadyAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Meter Readings"]
    column_names = Report::CvillegasReadyAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::CvillegasReadyAccount.all, column_names) }
      ajax_respond format, :section_id => "cvillegas_ready_accounts"
    end
  end

  def cvillegas_ready_accounts_prism
    customers = Report::CvillegasReadyAccount.pluck(:customer_unique_id)
    @records_array = prism_report(customers, "CVILLEGAS")
    header = ["Building ID", "Month", "Day", "Year", "Consumption", "Units", "P-Field", "Group", "Flag"]
    fields = 9 
    respond_to do |format|
      format.csv { send_data csv_export_raw_sql(header, @records_array, fields) }
    end
  end

  def washingtongas_ready_accounts
    @accounts = Report::WashingtongasReadyAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Meter Readings"]
    column_names = Report::WashingtongasReadyAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::WashingtongasReadyAccount.all, column_names) }
      ajax_respond format, :section_id => "cvillegas_ready_accounts"
    end
  end
  
  def washington_gas_ready_accounts_prism
    customers = Report::WashingtongasReadyAccount.pluck(:customer_unique_id)
    @records_array = prism_report(customers, "WASHINGTONGAS")
    header = ["Building ID", "Month", "Day", "Year", "Consumption", "Units", "P-Field", "Group", "Flag"]
    fields = 9 
    respond_to do |format|
      format.csv { send_data csv_export_raw_sql(header, @records_array, fields) }
    end
  end

  private
  def prism_report(customers, company_name)
    customers = customers.map(&:inspect).join(', ')
    records_array = Array.new
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
			        record_lookups.company_name = '" + company_name + "'
			            AND properties.finish_date IS NOT NULL) temp) temp
			WHERE
			    temp.gooddata IS NOT NULL
			        AND temp.customer_unique_id IN (" + customers + ")
			ORDER BY temp.customer_unique_id ASC , temp.date_year ASC , temp.date_month ASC , temp.date_day ASC;"

   records_array = ActiveRecord::Base.connection.execute(sql)
  end

  def csv_export(header, data, fields)
    CSV.generate do |csv|
      csv << header #["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
      data.each do |record|
        csv << record.attributes.values_at(*fields)
      end
    end
  end

  def csv_export_raw_sql(header, data, fields)
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
