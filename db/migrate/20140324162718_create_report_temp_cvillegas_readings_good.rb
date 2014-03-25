class CreateReportTempCvillegasReadingsGood < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW temp_cvillegas_readings_good AS
            SELECT 
                temp_cvillegas_readings.owner_name,
                temp_cvillegas_readings.acctnum,
                temp_cvillegas_readings.read_date,
                temp_cvillegas_readings.start_date,
                temp_cvillegas_readings.end_date,
                IF(temp_cvillegas_readings.read_date > temp_cvillegas_readings.start_date
                    AND temp_cvillegas_readings.read_date < temp_cvillegas_readings.end_date, 1, NULL) AS gooddata
            FROM
                temp_cvillegas_readings;
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS temp_cvillegas_readings_good;"
  end
end
