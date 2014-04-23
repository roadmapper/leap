class InstalledMeasureType < ActiveRecord::Base
  attr_accessible :installed_measures
  has_many :propertymeasures
end
