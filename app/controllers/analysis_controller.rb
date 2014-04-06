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
    @records_array = Array.new
    customers.each do |i|
      sql = "SELECT 
		    *
		FROM
		    (SELECT 
			properties.customer_unique_id,
			    MONTH(read_date) AS date_month,
			    DAY(read_date) AS date_day,
			    YEAR(recordings.read_date) AS date_year,
			    recordings.consumption,
			    utility_types.units,
			    IF(recordings.read_date > properties.finish_date, 'POST', 'PRE') AS date_PRE_POST,
			    'Carbon' AS 'Group',
			    'R' AS 'Flag'
		    FROM
			properties
		    LEFT JOIN record_lookups ON properties.id = record_lookups.property_id
		    LEFT JOIN recordings ON record_lookups.acct_num = recordings.acctnum
		    LEFT JOIN utility_types ON utility_types.id = recordings.utility_type_id
		    WHERE
			customer_unique_id IN ('" + i + "')
			    AND record_lookups.utility_type_id = 1
		    ORDER BY ABS(UNIX_TIMESTAMP(recordings.read_date) - UNIX_TIMESTAMP(properties.finish_date)) ASC
		    LIMIT 22) temp
		ORDER BY customer_unique_id ASC , date_year ASC , date_month ASC , date_day ASC;"
		      
      current = ActiveRecord::Base.connection.execute(sql)
      @records_array = @records_array.concat current.to_a
    end

    header = ["Building ID", "Month", "Day", "Year", "Consumption", "Units", "P-Field",	"Group", "Flag"]
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

  private
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
