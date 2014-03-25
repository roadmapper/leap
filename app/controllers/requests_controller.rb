class RequestsController < ApplicationController

  def index
  end

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
  def csv_export(header, data, fields)
    CSV.generate do |csv|
      csv << header #["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
      data.each do |record|
        csv << record.attributes.values_at(*fields)
      end
    end
  end

end
