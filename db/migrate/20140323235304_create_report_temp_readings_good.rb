class CreateReportTempReadingsGood < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW temp_readings_good
	    SELECT 
                temp_readings.owner_name,
                temp_readings.acctnum,
                temp_readings.read_date,
                temp_readings.start_date,
                temp_readings.end_date,
                IF(temp_readings.read_date > temp_readings.start_date
                    AND temp_readings.read_date < temp_readings.end_date, 1, NULL) AS gooddata
            FROM
                temp_readings;
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS temp_readings_good;"
  end
end
