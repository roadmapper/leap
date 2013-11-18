class RecordLookup < ActiveRecord::Base
  belongs_to :property
  belongs_to :utility_type
  attr_accessible :acct_num
end
