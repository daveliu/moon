class TimeEntry < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
    
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  belongs_to :todo                         
  belongs_to :project
  
end
