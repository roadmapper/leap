class CreateReportNullAccounts < ActiveRecord::Migration
    def up
      self.connection.execute %Q( CREATE OR REPLACE VIEW null_accounts AS    
        select
        owner_name,
        -- property_id,
        customer_unique_id,
        company_name,
        acct_num
        -- record_lookups.utility_type_id
        from
        properties
        left join
        record_lookups ON properties.id = record_lookups.property_id
        where
        company_name IS NULL OR acct_num IS NULL
        order by owner_name;)
    end

    def down
      self.connection.execute "DROP VIEW IF EXISTS null_accounts;"
    end
  end
