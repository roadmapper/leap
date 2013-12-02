module UploadsHelper
require 'iconv'
require 'roo'

	# change excel files to csv
	def xls2csv
	    Dir["/tmp/*.xls"].each do |file|  
	      file_path = "#{file}"
	      file_basename = File.basename(file, ".xls")
	      xls = Excel.new(file_path)
	      xls.to_csv = ("/tmp/#{file_basename}.csv")
	    end
	end
end
