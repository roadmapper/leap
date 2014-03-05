class Property < ActiveRecord::Base
  has_many :record_lookups
  accepts_nested_attributes_for :record_lookups, :reject_if => lambda { |a| a[:content].blank? }

   def self.search(owner)
        #if search
            find(:all, :conditions => ["owner_name like ? OR street_address like ?", "%#{owner}%","%#{owner}%"])
        #end
    end    
end
