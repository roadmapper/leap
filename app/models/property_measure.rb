class PropertyMeasure < ActiveRecord::Base
  belongs_to :property
  belongs_to :measure
  attr_accessible :comment
end
