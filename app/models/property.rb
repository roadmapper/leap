class Property < ActiveRecord::Base
  validates :owner_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state,  presence: true
  validates :zipcode, presence: true

  has_many :record_lookups
  has_many :propertymeasures
  
  accepts_nested_attributes_for :record_lookups, :allow_destroy => true, :reject_if => proc {|attributes| attributes.all? {|k,v| v.blank?}}

   def self.search(owner)
        #if search
        	array = owner.split(' - ',2)
        	test1=array[0]
        	test2=array[1]
            find(:all, :conditions => ["owner_name like ? AND street_address like ?", "%#{test1}%","%#{test2}%"])
        #end
    end    
end
