class PropertymeasuresController < ApplicationController
  # GET /propertymeasures
  # GET /propertymeasures.json
  def index
    @propertymeasures = Propertymeasure.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @propertymeasures }
    end
  end

  # GET /propertymeasures/1
  # GET /propertymeasures/1.json
  def show
    @propertymeasure = Propertymeasure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @propertymeasure }
    end
  end

  # GET /propertymeasures/new
  # GET /propertymeasures/new.json
  def new
    @propertymeasure = Propertymeasure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @propertymeasure }
    end
  end

  # GET /propertymeasures/1/edit
  def edit
    @propertymeasure = Propertymeasure.find(params[:id])
  end

  # POST /propertymeasures
  # POST /propertymeasures.json
  def create
    @propertymeasure = Propertymeasure.new(params[:propertymeasure])

      if @propertymeasure.save
      		redirect_to propertymeasures_path
      		flash[:notice] = "Association was successfully created."
      else
     		@messages = "Association was not able to be created. "
    	    	#parse the error messages and put it into a user readable version
    	    	@propertymeasure.errors.full_messages.each do |message|
    	    		@messages = @messages + message + ". "
    	    	end
    	    	flash[:notice] = @messages
      		redirect_to new_propertymeasure_path
      end
  end

  # PUT /propertymeasures/1
  # PUT /propertymeasures/1.json
  def update
    @propertymeasure = Propertymeasure.find(params[:id])

    respond_to do |format|
      if @propertymeasure.update_attributes(params[:propertymeasure])
        format.html { redirect_to @propertymeasure, notice: 'Propertymeasure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @propertymeasure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /propertymeasures/1
  # DELETE /propertymeasures/1.json
  def destroy
    @propertymeasure = Propertymeasure.find(params[:id])
    @propertymeasure.destroy

    respond_to do |format|
      format.html { redirect_to propertymeasures_url }
      format.json { head :no_content }
    end
  end
end
