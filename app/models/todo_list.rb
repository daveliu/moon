class TodoList < ActiveRecord::Base
  default_scope :order => 'todo_lists.created_at DESC'
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :milestone
  
  has_many :todos, :dependent => :destroy, :order => 'created_at ASC'  
end
