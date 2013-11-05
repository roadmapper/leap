class DashboardController < ApplicationController
  def index
    @property = Property.where(:owner_name => "Vinay")
  end
  def upload
    uploaded_io = params[:picture]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
      file.write(uploaded_io.read)
    end
    render :text => "File has been uploaded successfully"    
  end
end
