class UploadsController < ApplicationController
  # GET /uploads
  # GET /uploads.json 

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
  #Main function of this page
  #Uploaded_io = the file information
  #Uploaded_io is used to access further information on the file
  #Status = Success of upload
  #There are two upload functions that are slightly different. This is done to handle the two different forms of input, Gas, and Electric, since there is nothing in the files to indicate which is which.
  #Currently both function identically besides uploadGas indicating a 2 to the convert_to_stagings Methods.
  def upload
        uploaded_io = params[:file]
        railspath =  Rails.root.join('..', 'uploads')
        path = railspath.to_s
        filename = uploaded_io.original_filename

	#Goes to the generic upload_file portion of the code, handles the actual file uploading
	status = upload_file filename, path, uploaded_io
        

	#Checks if the file uploaded properly and then handles them appropiately based on the file type. Processing unfortunately currently indicates that the file has attempted to process. If for some reason the file stops processing, it will remain in the processing status.
        if status != "Duplicate file found in uploads, file not uploaded" && status != "File not uploaded properly"
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
  #This method functions identical to the previous upload function but replaces 1 with 2 to indicate Gas to the conversion methods
  def uploadGas
        uploaded_io = params[:file]
        railspath =  Rails.root.join('..', 'uploads')
        path = railspath.to_s
        filename = uploaded_io.original_filename

	status = upload_file filename, path, uploaded_io
        

        if status != "Duplicate file found in uploads, file not uploaded" && status != "File not uploaded properly"
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

#handles actual file upload, creates the file and places it in an upload directory. Will fail if no upload directory exists. This needs to be in level above where your application is running. 
  def upload_file(filename, path, uploaded_io)
	status = "File not uploaded properly"	
	if !File.exists?(path + "//" + filename) && File.directory?(path)
            File.open(path + "//" + filename, 'w') do |file|
                input = uploaded_io.read
                input.force_encoding('UTF-8')
                file.write(input)
            end
            Upload.create(:file_name => uploaded_io.original_filename, :status => 'Not Processed', :upload_date => Time.now)
	    status = "File has been uploaded successfully, check the uploaded files to see its processing status."
	elsif File.exists?(path + "//" + filename)
	status = "Duplicate file found in uploads, file not uploaded" 
	end
	status
  end
  #PRocesses the xlsx file, looking for headers in the xlsx file named AccountNum, DateRead, Consumption, and DaysUsed. Order and additional columns do not matter as long as these match. Uses the gem roo's excelx class to handle reading the file.
  def convert_to_stagingsXLSX(path, uploaded_io, type)
	fields_to_insert = %w{ AccountNum DateRead Consumption DaysUsed }
	rows_to_insert = []

	Dir[path+"/" + uploaded_io.original_filename].each do |file|
		    #handles the first sheet and first sheet only
                    file_path = "#{file}"
                    file_basename = File.basename(file, ".xlsx")
                    xlsx = Roo::Excelx.new(file_path.to_s)
                    $i = xlsx.sheets.length - 1
		    xlsx.default_sheet = xlsx.sheets[0]
		    headers = Hash.new
		    xlsx.row(1).each_with_index {|header,i|
		    headers[header] = i
	            }

 
		    #Looks at each row and extracts the data
                    ((xlsx.first_row + 1)..xlsx.last_row).each do |row|
			    
		            acctnum = xlsx.row(row)[headers['AccountNum']]
		            date = xlsx.row(row)[headers['DateRead']]
			    amt_kwh = xlsx.row(row)[headers['Consumption']]
			    days_used = xlsx.row(row)[headers['DaysUsed']]
		            
			    #Handles excelx formate Dates
			    #date = DateTime.new(1899,12,30) + Integer(date).days 
			    #Creates a staging IF staging does not already exist AND IF recording with same date and acct num does not exist in the Database
 			    if !Recording.exists?(:acctnum => acctnum.to_i, :read_date=>date)
			    	Staging.where({"acctnum"=>acctnum.to_i, "consumption"=>amt_kwh, "days_in_month"=>days_used, "read_date"=>date, "utility_type_id" => type}).first_or_create(:locked => false)
			    end
                    end
		   
		    
                    Upload.update_all( {:status => 'Processed', :process_date => Time.now}, {:file_name => uploaded_io.original_filename})

        end

  end
#Functions virtually simular to XLSX but uses Roos Excel class instead. All xlsx and excelx instances replaced with xls and excel. Needs to handle date differently for XLS files than XLSX. 
	def convert_to_stagingsXLS(path, uploaded_io, type)
		fields_to_insert = %w{ AccountNum DateRead Consumption DaysUsed }
		rows_to_insert = []
		Dir[path+"/" + uploaded_io.original_filename].each do |file|
		            file_path = "#{file}"
		            file_basename = File.basename(file, ".xls")
		            xls = Roo::Excel.new(file_path.to_s)
		            $i = xls.sheets.length - 1
			    xls.default_sheet = xls.sheets[0]
			    headers = Hash.new
			    xls.row(1).each_with_index {|header,i|
			    headers[header] = i
			    }
	 

		            ((xls.first_row + 1)..xls.last_row).each do |row|

				    acctnum = xls.row(row)[headers['AccountNum']]
				    date = xls.row(row)[headers['DateRead']]
				    amt_kwh = xls.row(row)[headers['Consumption']]
				    days_used = xls.row(row)[headers['DaysUsed']]
				    
				    #Needs to handle date differently for XLS files than XLSX. 
				    #date = DateTime.new(1899,12,30) + Integer(date).days
				if !Recording.exists?(:acctnum => acctnum.to_i, :read_date=>date)  
				    Staging.where({"acctnum"=>acctnum.to_i, "consumption"=>amt_kwh, "days_in_month"=>days_used, "read_date"=>date, "utility_type_id" => type}).first_or_create(:locked => false)
				end
		            end

		            Upload.update_all( {:status => 'Processed', :process_date => Time.now}, {:file_name => uploaded_io.original_filename})

		end

	  end
#Handles csv input. Uses  Ruby's default CSV class to handle the processing. Simply reads each row based on the headers. Staging upload is similar to the other two processing functions
	def convert_to_stagingsCSV(path, uploaded_io, type)
			fields_to_insert = %w{ AccountNum DateRead Consumption DaysUsed }
			rows_to_insert = []
		
			CSV.foreach(uploaded_io, headers: true) do |row|
			  row_to_insert = row.to_hash.select { |k, v| fields_to_insert.include?(k) }

			  stringdate = row_to_insert["DateRead"]
			  
			Staging.where({"acctnum"=>row_to_insert["AccountNum"], "consumption"=>row_to_insert["Consumption"], "days_in_month"=>row_to_insert["DaysUsed"], "read_date"=>date, "utility_type_id" => type}).first_or_create(:locked => false)
			end
			Upload.update_all( {:status => 'Processed', :process_date => Time.now}, {:file_name => uploaded_io.original_filename})
	end

end
