class TodoList < ActiveRecord::Base
  default_scope :order => 'todo_lists.created_at DESC'
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :project
  belongs_to :milestone
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  
  has_many :todos, :dependent => :destroy, :order => 'created_at ASC'
  
  # fires :new_todo,      :on                 => :create,
  #                       :actor              => :creator
  # fires_manually        :complete,      
  #                       :actor              => :creator
  
  state_machine :initial => :pending do
    after_transition :on => :complete, :do => :fire_complete              
        
    event :complete do
      transition  all => :completed
    end
    
    event :reopen do
      transition :completed => :reopened
    end
  end                                                  
  
  named_scope :by_state, lambda {|state| {:conditions => ["state = ?", state]}}
  
end
