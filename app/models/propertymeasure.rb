class Propertymeasure < ActiveRecord::Base
  belongs_to :property
  belongs_to :installed_measure_type
  attr_accessible :comment, :property_id, :installed_measure_type_id
end
