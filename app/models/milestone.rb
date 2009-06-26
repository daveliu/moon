class Milestone < ActiveRecord::Base
  default_scope :order => 'due ASC'
    
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  belongs_to :project
  
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
  
  before_save :set_due  # 00:00 to 23:59     
  
  def self.set_late
    update_all("state = 'late'", "due < '#{Time.now}' AND state = 'upcoming'")
  end
  
  def is_late?
    (Time.now > self.due) && upcoming?
  end       
  
  def time_ago                              
      "超过了#{Time.now.to_date - due.to_date}天"
  end
  
  
  private                               
  def set_due
    self.due = due + 23.hours + 59.minutes
  end

end
