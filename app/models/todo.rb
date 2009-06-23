class Todo < ActiveRecord::Base
  belongs_to :todo_list                              
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  
  state_machine :initial => :pending do

    event :complete do
      transition  all => :completed
    end
    
    event :reopen do
      transition :completed => :reopened
    end
  end                   
  
  named_scope :by_state, lambda {|state| {:conditions => ["state = ?", state]}}
  named_scope :uncompleted, :conditions => ["state = 'pending' OR state = 'reopened'"]
end
