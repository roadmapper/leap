#! /usr/bin/ruby

require 'iconv'
require 'roo'


# change excel files to csv
begin
    #|  need to change this so it checks our leap directory where      	    v  files are stored
    Dir["/home/cpn2pf/leap/test/*.xlsx"].each do |file|  
      file_path = "#{file}"
      file_basename = File.basename(file, ".xlsx")
      xlsx = Roo::Excelx.new(file_path)
      $i = xlsx.sheets.length - 1
      while $i >= 0 do
	xlsx.default_sheet = xlsx.sheets[$i]
	xlsx.to_csv("/home/cpn2pf/leap/test/#{file_basename}#{$i}.csv")
	$i -=1	
	#need to change this so it stores in our leap directory^ 	 where files are stored                                 |
      end

      #xlsx.to_csv("/home/cpn2pf/leap/test/#{file_basename}.csv")
      FileUtils.remove(file)
      print "Converted file #{file} \n"
    end
end
