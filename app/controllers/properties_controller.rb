class PropertiesController < ApplicationController
  #USER, PASSWORD = 'dhh', 'secret'
  #before_filter :authentication_check   #, :except => :index

  #http_basic_authenticate_with :name =>"username", :password => "secret"

  helper_method :sort_column, :sort_direction

  # GET /properties
  # GET /properties.xml
  def index
    @properties = Property.paginate(:page => params[:page]).order(sort_column + ' ' + sort_direction)
    @variables = Property.find(:all).map { |x| x.owner_name+" - "+x.street_address }#&:owner_name)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
      format.json { render :json => @variables }
    end
  end

  # GET /properties/1
  # GET /properties/1.xml
  def show
    @property = Property.find(params[:id])

    respond_to do |format|
        format.html { redirect_to(:controller => "dashboard", :action => "property_report", :owner => @property.owner_name)}
      format.xml  { render :xml => @property }
    end
  end

  # GET /properties/new
  # GET /properties/new.xml
  def new
    @utilitytypes = UtilityType.all.to_a
    @company_names = RecordLookup.uniq.pluck(:company_name)
    @property = Property.new
    @property.record_lookups.build
    @property.record_lookups.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @property }
    end
  end

  # GET /properties/1/edit
  def edit
    @utilitytypes = UtilityType.all.to_a
    @company_names = RecordLookup.uniq.pluck(:company_name)
    @property = Property.find(params[:id])
    @property.record_lookups.build;
  end

  # POST /properties
  # POST /properties.xml
  def create
    @property = Property.new(params[:property])

    respond_to do |format|
      if @property.save
        format.html { redirect_to(:controller => "dashboard", :action => "property_report", :owner => @property.owner_name, :notice => 'Property was successfully created.') }
        format.xml  { render :xml => @property, :status => :created, :location => @property }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.xml
  def update
    @property = Property.find(params[:id])

    respond_to do |format|
      if @property.update_attributes(params[:property])
          format.html { redirect_to(:controller => "dashboard", :action => "property_report", :owner => @property.owner_name, :notice => 'Property was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.xml
  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to(properties_url) }
      format.xml  { head :ok }
    end
  end

  private
  def authentication_check
   authenticate_or_request_with_http_basic do |user, password|
     user == USER && password == PASSWORD
   end
 end

  def sort_column
    Property.column_names.include?(params[:sort]) ? params[:sort] : "customer_unique_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end
