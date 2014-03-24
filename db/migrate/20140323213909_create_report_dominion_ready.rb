class CreateReportDominionReady < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW dominion_ready AS 
	SELECT 
	    temp.owner_name,
	    temp.acctnum,
	    COUNT(temp.gooddata) AS acceptedDatapoints
	FROM
	    (SELECT 
		temp.owner_name,
		    temp.acctnum,
		    temp.read_date,
		    temp.start_date,
		    temp.end_date,
		    IF(temp.read_date > temp.start_date
			AND temp.read_date < temp.end_date, 1, NULL) AS gooddata
	    FROM
		temp_readings) temp
	GROUP BY temp.owner_name , temp.acctnum
	ORDER BY acceptedDatapoints DESC;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS dominion_ready;"
  end
end
