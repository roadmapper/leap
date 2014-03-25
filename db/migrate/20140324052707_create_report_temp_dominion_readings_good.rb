class CreateReportTempDominionReadingsGood < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW temp_dominion_readings_good AS
            SELECT 
                temp_dominion_readings.owner_name,
                temp_dominion_readings.acctnum,
                temp_dominion_readings.read_date,
                temp_dominion_readings.start_date,
                temp_dominion_readings.end_date,
                IF(temp_dominion_readings.read_date > temp_dominion_readings.start_date
                    AND temp_dominion_readings.read_date < temp_dominion_readings.end_date, 1, NULL) AS gooddata
            FROM
                temp_dominion_readings;
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS temp_dominion_readings_good;"
  end
end
