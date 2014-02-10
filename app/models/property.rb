class Property < ActiveRecord::Base
  has_many :record_lookups
  accepts_nested_attributes_for :record_lookups, :reject_if => lambda { |a| a[:content].blank? }
end
