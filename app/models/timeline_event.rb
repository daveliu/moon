class TimelineEvent < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  before_save :set_project
  
  def day
    self.created_at.to_date
  end              
  
  private
    def set_project
      self.project_id = subject.project_id
    end
end
