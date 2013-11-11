class Property < ActiveRecord::Base
  has_many :gas_recordings
  has_many :power_recordings
end
