class TodoList < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  has_many :todos, :dependent => :destroy, :order => 'created_at ASC'  
end