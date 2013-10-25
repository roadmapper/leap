class PowerRecordingsController < ApplicationController
  # GET /power_recordings
  # GET /power_recordings.xml
  def index
    @power_recordings = PowerRecording.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @power_recordings }
    end
  end

  # GET /power_recordings/1
  # GET /power_recordings/1.xml
  def show
    @power_recording = PowerRecording.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @power_recording }
    end
  end

  # GET /power_recordings/new
  # GET /power_recordings/new.xml
  def new
    @power_recording = PowerRecording.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @power_recording }
    end
  end

  # GET /power_recordings/1/edit
  def edit
    @power_recording = PowerRecording.find(params[:id])
  end

  # POST /power_recordings
  # POST /power_recordings.xml
  def create
    @power_recording = PowerRecording.new(params[:power_recording])

    respond_to do |format|
      if @power_recording.save
        format.html { redirect_to(@power_recording, :notice => 'Power recording was successfully created.') }
        format.xml  { render :xml => @power_recording, :status => :created, :location => @power_recording }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @power_recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /power_recordings/1
  # PUT /power_recordings/1.xml
  def update
    @power_recording = PowerRecording.find(params[:id])

    respond_to do |format|
      if @power_recording.update_attributes(params[:power_recording])
        format.html { redirect_to(@power_recording, :notice => 'Power recording was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @power_recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /power_recordings/1
  # DELETE /power_recordings/1.xml
  def destroy
    @power_recording = PowerRecording.find(params[:id])
    @power_recording.destroy

    respond_to do |format|
      format.html { redirect_to(power_recordings_url) }
      format.xml  { head :ok }
    end
  end
end
