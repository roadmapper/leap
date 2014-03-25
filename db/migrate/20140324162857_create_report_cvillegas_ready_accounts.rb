class CreateReportCvillegasReadyAccounts < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW cvillegas_ready_accounts AS 
        SELECT 
            temp_cvillegas_readings_good.owner_name,
            temp_cvillegas_readings_good.acctnum,
            COUNT(temp_cvillegas_readings_good.gooddata) AS acceptedDatapoints
        FROM
            temp_cvillegas_readings_good
        GROUP BY temp_cvillegas_readings_good.owner_name , temp_cvillegas_readings_good.acctnum
        ORDER BY acceptedDatapoints DESC;)
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS cvillegas_ready_accounts;"
  end
end
