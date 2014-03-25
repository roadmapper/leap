class CreateReportTempDominionReadings < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW temp_dominion_readings AS 
        SELECT 
                properties.owner_name,
                    properties.customer_unique_id,
                    properties.finish_date,
                    record_lookups.company_name,
                    recordings.acctnum,
                    recordings.read_date,
                    recordings.consumption,
                    IF(EXTRACT(DAY from properties.finish_date) < 15, DATE_SUB(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), DATE_ADD(DATE_SUB(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), INTERVAL 1 MONTH)) AS start_date,
                    IF(EXTRACT(DAY from properties.finish_date) < 15, DATE_ADD(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), DATE_ADD(DATE_ADD(DATE_ADD(LAST_DAY(DATE_SUB(properties.finish_date, INTERVAL 1 MONTH)), INTERVAL 15 DAY), INTERVAL 1 YEAR), INTERVAL 1 MONTH)) AS end_date
            FROM
                properties
            INNER JOIN record_lookups ON record_lookups.property_id = properties.id
            INNER JOIN recordings ON recordings.acctnum = record_lookups.acct_num
            WHERE
                record_lookups.company_name = 'DOMINION'
                    AND properties.finish_date IS NOT NULL;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS temp_dominion_readings;"
  end
end
