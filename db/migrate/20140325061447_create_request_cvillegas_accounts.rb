class CreateRequestCvillegasAccounts < ActiveRecord::Migration
  def up
    self.connection.execute %Q(CREATE OR REPLACE VIEW cvillegas_request_accounts AS 
        SELECT 
            temp_cvillegas_readings_good.owner_name,
            temp_cvillegas_readings_good.acctnum,
			-- temp_cvillegas_readings_good.finish_date,
			-- temp_cvillegas_readings_good.start_date,
			-- temp_cvillegas_readings_good.end_date,
			IF (temp_cvillegas_readings_good.start_date < CURDATE() 
				AND temp_cvillegas_readings_good.start_date > DATE_SUB(CURDATE(), INTERVAL 18 MONTH), 
				temp_cvillegas_readings_good.start_date, IF(temp_cvillegas_readings_good.start_date < DATE_SUB(CURDATE(), INTERVAL 18 MONTH), DATE_SUB(CURDATE(), INTERVAL 18 MONTH), NULL)) AS request_start_date,
			IF (temp_cvillegas_readings_good.end_date < CURDATE() 
				AND temp_cvillegas_readings_good.end_date > DATE_SUB(CURDATE(), INTERVAL 18 MONTH), 
				temp_cvillegas_readings_good.end_date, IF(temp_cvillegas_readings_good.end_date < DATE_SUB(CURDATE(), INTERVAL 18 MONTH), NULL, CURDATE())) AS request_end_date,
            COUNT(temp_cvillegas_readings_good.gooddata) AS acceptedDatapoints
        FROM
            temp_cvillegas_readings_good
        GROUP BY temp_cvillegas_readings_good.owner_name , temp_cvillegas_readings_good.acctnum
		HAVING request_end_date IS NOT NULL AND acceptedDatapoints < 24
        ORDER BY acceptedDatapoints DESC;)
  end

  def down
  	self.connection.execute "DROP VIEW IF EXISTS cvillegas_request_accounts;"
  end
end
