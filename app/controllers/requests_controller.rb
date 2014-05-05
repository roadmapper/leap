class RequestsController < ApplicationController

  def index
  end


  #Gets all the Dominion accounts that need utility data requests for specific date ranges from the Report module, DominionRequestAccount class, paginated
  def dominion_request_accounts
    @accounts = Report::DominionRequestAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Request Start Date", "Request End Date", "Meter Readings"]
    column_names = Report::DominionRequestAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::DominionRequestAccount.all, column_names) }
      ajax_respond format, :section_id => "dominion_request_accounts"
    end
  end

  #Gets all the Charlottesville Gas accounts that need utility data requests for specific date ranges from the Report module, CvillegasRequestAccount class, paginated
  def cvillegas_request_accounts
    @accounts = Report::CvillegasRequestAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Request Start Date", "Request End Date", "Meter Readings"]
    column_names = Report::CvillegasRequestAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::CvillegasRequestAccount.all, column_names) }
      ajax_respond format, :section_id => "cvillegas_request_accounts"
    end
  end
  
  #Gets all the Washington Gas accounts that need utility data requests for specific date ranges from the Report module, WashingtongasRequestAccount class, paginated
  def washingtongas_request_accounts
    @accounts = Report::WashingtongasRequestAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Request Start Date", "Request End Date", "Meter Readings"]
    column_names = Report::WashingtongasRequestAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::WashingtongasRequestAccount.all, column_names) }
      ajax_respond format, :section_id => "washingtongas_request_accounts"
    end
  end

  private
  #CSV export function that takes in the header, data, and the fields from the ActiveRecord
  def csv_export(header, data, fields)
    CSV.generate do |csv|
      csv << header #["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
      data.each do |record|
        csv << record.attributes.values_at(*fields)
      end
    end
  end

end
