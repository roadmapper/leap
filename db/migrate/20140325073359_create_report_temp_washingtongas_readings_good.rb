class CreateReportTempWashingtongasReadingsGood < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW temp_washingtongas_readings_good AS
            SELECT 
                temp_washingtongas_readings.owner_name,
                temp_washingtongas_readings.customer_unique_id,
                temp_washingtongas_readings.acctnum,
                temp_washingtongas_readings.read_date,
                temp_washingtongas_readings.start_date,
                temp_washingtongas_readings.end_date,
                IF(temp_washingtongas_readings.read_date > temp_washingtongas_readings.start_date
                    AND temp_washingtongas_readings.read_date < temp_washingtongas_readings.end_date, 1, NULL) AS gooddata
            FROM
                temp_washingtongas_readings;
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS temp_washingtongas_readings_good;"
  end
end
