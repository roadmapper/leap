module DashboardHelper
require 'iconv'
require 'roo'

	# change excel files to csv
	def xls2csv
	    print "start conversion....AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	    Dir["/leap/public/uploads/*.xlsx"].each do |file|  
	      file_path = "#{file}"
	      file_basename = File.basename(file, ".xlsx")
	      xlsx = Roo::Excelx.new(file_path)
	      $i = xlsx.sheets.length - 1
	      while $i >= 0 do
		xlsx.default_sheet = xlsx.sheets[$i]
		xlsx.to_csv("/leap/public/uploads/#{file_basename}#{$i}.csv")
		$i -=1	
	      end
	      FileUtils.remove(file)
	      print "Converted file #{file} \n"
	    end
	end
end
