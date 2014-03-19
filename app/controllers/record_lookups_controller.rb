class RecordLookupsController < ApplicationController
  # GET /record_lookups
  # GET /record_lookups.json
  def index
    @record_lookups = RecordLookup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @record_lookups }
    end
  end

  # GET /record_lookups/1
  # GET /record_lookups/1.json
  def show
    @record_lookup = RecordLookup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @record_lookup }
    end
  end

  # GET /record_lookups/new
  # GET /record_lookups/new.json
  def new
    @record_lookup = RecordLookup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @record_lookup }
    end
  end

  # GET /record_lookups/1/edit
  def edit
    @record_lookup = RecordLookup.find(params[:id])
  end

  # POST /record_lookups
  # POST /record_lookups.json
  def create
    @record_lookup = RecordLookup.new(params[:record_lookup])

    respond_to do |format|
      if @record_lookup.save
        format.html { redirect_to dashboard_gaps_path(:commit => "Search", :owner => params[:record_lookup][:owner]), notice: 'Record lookup was successfully created.' }
        format.json { render json: @record_lookup, status: :created, location: @record_lookup }
      else
        format.html { render action: "new" }
        format.json { render json: @record_lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /record_lookups/1
  # PUT /record_lookups/1.json
  def update
    @record_lookup = RecordLookup.find(params[:id])

    respond_to do |format|
      if @record_lookup.update_attributes(params[:record_lookup])
        format.html { redirect_to @record_lookup, notice: 'Record lookup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @record_lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /record_lookups/1
  # DELETE /record_lookups/1.json
  def destroy
    @record_lookup = RecordLookup.find(params[:id])
    @record_lookup.destroy

    respond_to do |format|
      format.html { redirect_to record_lookups_url }
      format.json { head :no_content }
    end
  end
end
