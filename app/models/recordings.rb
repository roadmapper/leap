class Recordings < ActiveRecord::Base
  belongs_to :utility_type_id
  belongs_to :act_num
end
