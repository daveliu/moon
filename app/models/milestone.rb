class Milestone < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  
  has_many :todo_lists, :dependent => :destroy, :order => 'created_at ASC'
  has_many :messages                                        
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  
  fires :new_milestone, :on                 => :create,
                        :actor              => :creator
  fires_manually        :complete,      
                        :actor              => :creator                      
  
  state_machine :initial => :upcoming do
    after_transition :on => :complete, :do => :fire_complete

    event :out_date do
      transition  all => :late
    end
    
    event :reopen do
      transition all => :upcoming
    end             
    
    event :complete do
      transition  all => :completed
    end  
  end                   
  
  named_scope :by_state, lambda {|state| {:conditions => ["state = ?", state]}}
  
  before_save :set_state
  
  def is_late?
    (Time.now > self.due) && upcoming?
  end
  
  
  private
   def set_state
     out_date! if(is_late?)
   end
end
