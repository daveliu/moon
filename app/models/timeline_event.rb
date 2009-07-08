class TimelineEvent < ActiveRecord::Base
  default_scope :order => 'timeline_events.created_at DESC'
  
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true

  belongs_to :project
  
  before_save :set_project
  
  def day
    self.created_at.to_date
  end              
  
  private
    def set_project             
      if subject_type == "Todo"
        self.project_id = subject.todo_list.project_id
      else                                            
        self.project_id = subject.project_id
      end    
    end
end
