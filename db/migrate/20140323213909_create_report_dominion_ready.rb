class CreateReportDominionReady < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW dominion_ready AS 
	SELECT 
	    temp_readings_good.owner_name,
	    temp_readings_good.acctnum,
	    COUNT(temp_readings_good.gooddata) AS acceptedDatapoints
	FROM
	    temp_readings_good
	GROUP BY temp_readings_good.owner_name , temp_readings_good.acctnum
	ORDER BY acceptedDatapoints DESC;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS dominion_ready;"
  end
end
