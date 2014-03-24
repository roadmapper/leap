class StagingsController < ApplicationController

  # GET /stagings
  # GET /stagings.json
  can_edit_on_the_spot
  respond_to :json
  def index
    
    @stagings = Staging.paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stagings }
    end
  end

  def insert
    Staging.all.each do |staging|
	Recording.where(:acctnum => staging.acctnum, :consumption =>staging.consumption, :days_in_month =>staging.days_in_month, :read_date => staging.read_date).first_or_create(:locked => false)
	Staging.destroy(staging)
    end
    

    redirect_to :action => 'index'
  end
  # GET /stagings/1
  # GET /stagings/1.json
  def show
    @staging = Staging.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @staging }
    end
  end

  # GET /stagings/new
  # GET /stagings/new.json
  def new
    @staging = Staging.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @staging }
    end
  end

  # GET /stagings/1/edit
  def edit
    @staging = Staging.find(params[:id])
  end

  # POST /stagings
  # POST /stagings.json
  def create
    @staging = Staging.new(params[:staging])

    respond_to do |format|
      if @staging.save
        format.html { redirect_to @staging, notice: 'Staging was successfully created.' }
        format.json { render json: @staging, status: :created, location: @staging }
      else
        format.html { render action: "new" }
        format.json { render json: @staging.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stagings/1
  # PUT /stagings/1.json
  def update
    @staging = Staging.find(params[:id])

    respond_to do |format|
      if @staging.update_attributes(params[:staging])
        format.html { redirect_to @staging, notice: 'Staging was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @staging.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stagings/1
  # DELETE /stagings/1.json
  def destroy
    @staging = Staging.find(params[:id])
    @staging.destroy

    respond_to do |format|
      format.html { redirect_to stagings_url }
      format.json { head :no_content }
    end
  end

  def destroyAll
    Staging.all.each do |staging|
	Staging.destroy(staging)
    end
  end
end
