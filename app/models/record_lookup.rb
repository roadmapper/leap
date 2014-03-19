class RecordLookup < ActiveRecord::Base
  belongs_to :property
  belongs_to :utility_type
  attr_accessible :acct_num, :company_name, :property_id, :utility_type_id
  
  def company_name_with_acctnum
        company_name << ": " <<acct_num
  end
  
end
