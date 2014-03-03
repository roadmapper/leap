class AnalysisController < ApplicationController

  def index
  end

  def null_accounts
    @accounts = Report::NullAccount.paginate(:page => params[:page])
    respond_to do |format|
      format.js
      ajax_respond format, :section_id => "null_accounts"
    end
  end

end
