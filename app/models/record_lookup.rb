class RecordLookup < ActiveRecord::Base
  validates :property_id, presence: true
  validates :utility_type_id, presence: true
  validates :company_name, presence: true
  validates :acct_num,  presence: true

  belongs_to :property
  belongs_to :utility_type
  attr_accessible :acct_num, :company_name, :property_id, :utility_type_id
  
  def company_name_with_acctnum
        company_name << ": " <<acct_num
  end
  
end
