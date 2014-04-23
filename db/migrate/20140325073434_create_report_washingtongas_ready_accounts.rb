class CreateReportWashingtongasReadyAccounts < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW washingtongas_ready_accounts AS 
        SELECT 
            temp_washingtongas_readings_good.owner_name,
            temp_washingtongas_readings_good.customer_unique_id,
            temp_washingtongas_readings_good.acctnum,
            COUNT(temp_washingtongas_readings_good.gooddata) AS acceptedDatapoints
        FROM
            temp_washingtongas_readings_good
        GROUP BY temp_washingtongas_readings_good.owner_name , temp_washingtongas_readings_good.acctnum
	HAVING acceptedDatapoints >= 20
        ORDER BY acceptedDatapoints DESC;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS washingtongas_ready_accounts;"
  end
end
