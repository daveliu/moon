class Milestone < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  
  has_many :todo_lists, :dependent => :destroy, :order => 'created_at ASC'
end
