class Staging < ActiveRecord::Base
  belongs_to :utility_type
  attr_accessible :acctnum, :consumption, :days_in_month, :read_date
end
