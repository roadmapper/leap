class Property < ActiveRecord::Base
  has_many :record_lookups
  accepts_nested_attributes_for :record_lookups, :reject_if => lambda { |a| a[:content].blank? }

   def self.search(owner)
        #if search
        	array = owner.split(' - ',2)
        	test1=array[0]
        	test2=array[1]
            find(:all, :conditions => ["owner_name like ? AND street_address like ?", "%#{test1}%","%#{test2}%"])
        #end
    end    
end
