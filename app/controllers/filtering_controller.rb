class FilteringController < ApplicationController

  helper_method :sort_column, :sort_direction, :reset

  def index
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
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
    end
  end


  def reset

  end

  def sort_column
    Property.column_names.include?(params[:sort]) ? params[:sort] : "customer_unique_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

end
