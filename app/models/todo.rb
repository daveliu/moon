class Todo < ActiveRecord::Base
  belongs_to :todo_list
  
  state_machine :initial => :pending do

    event :complete do
      transition  all => :completed
    end
    
    event :reopen do
      transition :completed => :reopened
    end
  end                   
  
  named_scope :by_state, lambda {|state| {:conditions => ["state = ?", state]}}
end
