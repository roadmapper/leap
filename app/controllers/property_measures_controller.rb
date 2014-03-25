class PropertyMeasuresController < ApplicationController
  # GET /property_measures
  # GET /property_measures.json
  def index
    @property_measures = PropertyMeasure.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @property_measures }
    end
  end

  # GET /property_measures/1
  # GET /property_measures/1.json
  def show
    @property_measure = PropertyMeasure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property_measure }
    end
  end

  # GET /property_measures/new
  # GET /property_measures/new.json
  def new
    @property_measure = PropertyMeasure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @property_measure }
    end
  end

  # GET /property_measures/1/edit
  def edit
    @property_measure = PropertyMeasure.find(params[:id])
  end

  # POST /property_measures
  # POST /property_measures.json
  def create
    @property_measure = PropertyMeasure.new(params[:property_measure])

    respond_to do |format|
      if @property_measure.save
        format.html { redirect_to @property_measure, notice: 'Property measure was successfully created.' }
        format.json { render json: @property_measure, status: :created, location: @property_measure }
      else
        format.html { render action: "new" }
        format.json { render json: @property_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /property_measures/1
  # PUT /property_measures/1.json
  def update
    @property_measure = PropertyMeasure.find(params[:id])

    respond_to do |format|
      if @property_measure.update_attributes(params[:property_measure])
        format.html { redirect_to @property_measure, notice: 'Property measure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @property_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /property_measures/1
  # DELETE /property_measures/1.json
  def destroy
    @property_measure = PropertyMeasure.find(params[:id])
    @property_measure.destroy

    respond_to do |format|
      format.html { redirect_to property_measures_url }
      format.json { head :no_content }
    end
  end
end
