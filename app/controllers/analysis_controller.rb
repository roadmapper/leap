class AnalysisController < ApplicationController

  def index
  end

  def null_accounts
    @accounts = Report::NullAccount.paginate(:page => params[:page])
    header = ["Owner Name", "Customer Unique ID", "Company Name", "Account Number"]
    column_names = Report::NullAccount.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::NullAccount.all, column_names) }
      ajax_respond format, :section_id => "null_accounts"
    end
  end

  def dominion_ready
    @accounts = Report::DominionReady.paginate(:page => params[:page])
    header = ["Owner Name", "Account Number", "Meter Readings"]
    column_names = Report::DominionReady.column_names
    respond_to do |format|
      format.js
      format.csv { send_data csv_export(header, Report::DominionReadyNullAccount.all, column_names) }
      ajax_respond format, :section_id => "dominion_ready"
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
