class UploadsController < ApplicationController
  # GET /uploads
  # GET /uploads.json 
#thought I should have stagings directly in here but maybe should link instead... bleh
  def index
    @uploads = Upload.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = Upload.new(params[:upload])

    respond_to do |format|
      if @upload.save
        format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
        format.json { render json: @upload, status: :created, location: @upload }
	
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end
  #		#electricity = 1 gas = 2
  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload = Upload.find(params[:id])
	if File.exists?(Rails.root.join('..', 'uploads', @upload.file_name))
		File.delete(Rails.root.join('..', 'uploads', @upload.file_name))	
	end
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  def upload
        uploaded_io = params[:file]
        railspath =  Rails.root.join('..', 'uploads')
        path = railspath.to_s
        filename = uploaded_io.original_filename

	status = upload_file filename, path, uploaded_io
        

        if status != "Duplicate file found in uploads, file not uploaded"
		flash[:notice] = status
		Thread.new do		
			if uploaded_io.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
				Upload.update_all( {:status => 'Processing'}, {:file_name => uploaded_io.original_filename})
				convert_to_stagingsXLSX path, uploaded_io, 1
			elsif uploaded_io.content_type == 'application/vnd.ms-excel'
				Upload.update_all( {:status => 'Processing'}, {:file_name => uploaded_io.original_filename})
				convert_to_stagingsXLS path, uploaded_io, 1
			elsif uploaded_io.content_type == 'text/csv'
				Upload.update_all( {:status => 'Processing'}, {:file_name => uploaded_io.original_filename})
				convert_to_stagingsCSV path, uploaded_io, 1 
			end
		end	
	else flash[:alert] = status end

	redirect_to :action => 'index'	
  end

  def uploadGas
        uploaded_io = params[:file]
        railspath =  Rails.root.join('..', 'uploads')
        path = railspath.to_s
        filename = uploaded_io.original_filename

	status = upload_file filename, path, uploaded_io
        

        if status != "Duplicate file found in uploads, file not uploaded"
		flash[:notice] = status
		Thread.new do
			if uploaded_io.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
				Upload.update_all( {:status => 'Processing'}, {:file_name => uploaded_io.original_filename})
				convert_to_stagingsXLSX path, uploaded_io, 2
			elsif uploaded_io.content_type == 'application/vnd.ms-excel'
				Upload.update_all( {:status => 'Processing'}, {:file_name => uploaded_io.original_filename})
				convert_to_stagingsXLS path, uploaded_io, 2
			elsif uploaded_io.content_type == 'text/csv'
				Upload.update_all( {:status => 'Processing'}, {:file_name => uploaded_io.original_filename})
				convert_to_stagingsCSV path, uploaded_io, 2 
			end
		end	
	else flash[:alert] = status end
	
	redirect_to :action => 'index'	
  end            

  def upload_file(filename, path, uploaded_io)
	status = "Duplicate file found in uploads, file not uploaded"	
	if !File.exists?(path + "//" + filename) && File.directory?(path)
            File.open(path + "//" + filename, 'w') do |file|
                input = uploaded_io.read
                input.force_encoding('UTF-8')
                file.write(input)
            end
            Upload.create(:file_name => uploaded_io.original_filename, :status => 'Not Processed', :upload_date => Time.now)
	    status = "File has been uploaded successfully, check the uploaded files to see its processing status."
	end
	status
  end

  def convert_to_stagingsXLSX(path, uploaded_io, type)
	fields_to_insert = %w{ ID_BA DT_READ AMT_KWH DAYS_USED Consumption }
	rows_to_insert = []
	Dir[path+"/*.xlsx"].each do |file|
                    file_path = "#{file}"
                    file_basename = File.basename(file, ".xlsx")
                    xlsx = Excelx.new(file_path.to_s)
                    $i = xlsx.sheets.length - 1
		    xlsx.default_sheet = xlsx.sheets[0]
		    headers = Hash.new
		    xlsx.row(1).each_with_index {|header,i|
		    headers[header] = i
	            }
 

                    ((xlsx.first_row + 1)..xlsx.last_row).each do |row|

		            acctnum = xlsx.row(row)[headers['ID_BA']]
		            date = xlsx.row(row)[headers['DT_READ']]
			    amt_kwh = xlsx.row(row)[headers['AMT_KWH']]
			    days_used = xlsx.row(row)[headers['DAYS_USED']]
		            
			    date = DateTime.new(1899,12,30) + Integer(date).days 
 			    if !Recording.exists?(:acctnum => acctnum, :read_date=>date)
			    	Staging.where({"acctnum"=>acctnum, "consumption"=>amt_kwh, "days_in_month"=>days_used, "read_date"=>date, "utility_type_id" => type}).first_or_create(:locked => false)
			    end
                    end
		   
		    
                    Upload.update_all( {:status => 'Processed', :process_date => Time.now}, {:file_name => uploaded_io.original_filename})

        end

  end

	def convert_to_stagingsXLS(path, uploaded_io, type)
		fields_to_insert = %w{ ID_BA DT_READ AMT_KWH DAYS_USED Consumption }
		rows_to_insert = []
		Dir[path+"/*.xls"].each do |file|
		            file_path = "#{file}"
		            file_basename = File.basename(file, ".xls")
		            xls = Excel.new(file_path.to_s)
		            $i = xls.sheets.length - 1
			    xls.default_sheet = xls.sheets[0]
			    headers = Hash.new
			    xls.row(1).each_with_index {|header,i|
			    headers[header] = i
			    }
	 

		            ((xls.first_row + 1)..xls.last_row).each do |row|

				    acctnum = xls.row(row)[headers['ID_BA']]
				    date = xls.row(row)[headers['DT_READ']]
				    amt_kwh = xls.row(row)[headers['AMT_KWH']]
				    days_used = xls.row(row)[headers['DAYS_USED']]
				    
				    date = DateTime.new(1899,12,30) + Integer(date).days  
				    Staging.where({"acctnum"=>acctnum, "consumption"=>amt_kwh, "days_in_month"=>days_used, "read_date"=>date, "utility_type_id" => type}).first_or_create(:locked => false)
		            end
			   # to be removed depending on if want to continue using multiple sheets... 
			   # $i = xlsx.sheets.length - 1
		           #while $i >= 0 do
		           #     xlsx.default_sheet = xlsx.sheets[$i]
		           #     $i -=1
		           # end
		            Upload.update_all( {:status => 'Processed', :process_date => Time.now}, {:file_name => uploaded_io.original_filename})

		end

	  end

	def convert_to_stagingsCSV(path, uploaded_io, type)
			fields_to_insert = %w{ ID_BA DT_READ AMT_KWH DAYS_USED Consumption }
			rows_to_insert = []
		
			CSV.foreach(uploaded_io, headers: true) do |row|
			  row_to_insert = row.to_hash.select { |k, v| fields_to_insert.include?(k) }
			 #row.to_hash.values_at(*fields_to_insert)
			  #rows_to_insert << row_to_insert

			  stringdate = row_to_insert["DT_READ"]
		          date = DateTime.new(1899,12,30) + Integer(stringdate).days 
			  
	   		  #formatted_date = date.strftime('%a %b %d %Y')
			  
			Staging.where({"acctnum"=>row_to_insert["ID_BA"], "consumption"=>row_to_insert["AMT_KWH"], "days_in_month"=>row_to_insert["DAYS_USED"], "read_date"=>date, "utility_type_id" => type}).first_or_create(:locked => false)
			end
			Upload.update_all( {:status => 'Processed', :process_date => Time.now}, {:file_name => uploaded_io.original_filename})
	end

end
