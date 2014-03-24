class InstalledMeasureTypesController < ApplicationController
  # GET /installed_measure_types
  # GET /installed_measure_types.json
  def index
    @installed_measure_types = InstalledMeasureType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @installed_measure_types }
    end
  end

  # GET /installed_measure_types/1
  # GET /installed_measure_types/1.json
  def show
    @installed_measure_type = InstalledMeasureType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @installed_measure_type }
    end
  end

  # GET /installed_measure_types/new
  # GET /installed_measure_types/new.json
  def new
    @installed_measure_type = InstalledMeasureType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @installed_measure_type }
    end
  end

  # GET /installed_measure_types/1/edit
  def edit
    @installed_measure_type = InstalledMeasureType.find(params[:id])
  end

  # POST /installed_measure_types
  # POST /installed_measure_types.json
  def create
    @installed_measure_type = InstalledMeasureType.new(params[:installed_measure_type])

    respond_to do |format|
      if @installed_measure_type.save
        format.html { redirect_to @installed_measure_type, notice: 'Installed measure type was successfully created.' }
        format.json { render json: @installed_measure_type, status: :created, location: @installed_measure_type }
      else
        format.html { render action: "new" }
        format.json { render json: @installed_measure_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /installed_measure_types/1
  # PUT /installed_measure_types/1.json
  def update
    @installed_measure_type = InstalledMeasureType.find(params[:id])

    respond_to do |format|
      if @installed_measure_type.update_attributes(params[:installed_measure_type])
        format.html { redirect_to @installed_measure_type, notice: 'Installed measure type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @installed_measure_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /installed_measure_types/1
  # DELETE /installed_measure_types/1.json
  def destroy
    @installed_measure_type = InstalledMeasureType.find(params[:id])
    @installed_measure_type.destroy

    respond_to do |format|
      format.html { redirect_to installed_measure_types_url }
      format.json { head :no_content }
    end
  end
end
