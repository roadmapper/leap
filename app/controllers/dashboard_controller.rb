class DashboardController < ApplicationController
  def index
    @property = Property.where(:owner_name => "Vinay")
  end
  def upload
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
      file.force_encoding('UTF-8')
      file.write(uploaded_io.read)
    end
    render :text => "File has been uploaded successfully"    
    update_page do |page|
      page.redirect_to(:action => 'index')
    end
  end
end
