class GasRecordingsController < ApplicationController
  # GET /gas_recordings
  # GET /gas_recordings.xml
  def index
    @gas_recordings = GasRecording.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gas_recordings }
    end
  end

  # GET /gas_recordings/1
  # GET /gas_recordings/1.xml
  def show
    @gas_recording = GasRecording.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gas_recording }
    end
  end

  # GET /gas_recordings/new
  # GET /gas_recordings/new.xml
  def new
    @gas_recording = GasRecording.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gas_recording }
    end
  end

  # GET /gas_recordings/1/edit
  def edit
    @gas_recording = GasRecording.find(params[:id])
  end

  # POST /gas_recordings
  # POST /gas_recordings.xml
  def create
    @gas_recording = GasRecording.new(params[:gas_recording])

    respond_to do |format|
      if @gas_recording.save
        format.html { redirect_to(@gas_recording, :notice => 'Gas recording was successfully created.') }
        format.xml  { render :xml => @gas_recording, :status => :created, :location => @gas_recording }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gas_recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gas_recordings/1
  # PUT /gas_recordings/1.xml
  def update
    @gas_recording = GasRecording.find(params[:id])

    respond_to do |format|
      if @gas_recording.update_attributes(params[:gas_recording])
        format.html { redirect_to(@gas_recording, :notice => 'Gas recording was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gas_recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gas_recordings/1
  # DELETE /gas_recordings/1.xml
  def destroy
    @gas_recording = GasRecording.find(params[:id])
    @gas_recording.destroy

    respond_to do |format|
      format.html { redirect_to(gas_recordings_url) }
      format.xml  { head :ok }
    end
  end
end
