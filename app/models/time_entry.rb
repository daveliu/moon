class TimeEntry < ActiveRecord::Base    
  include Permissions
    
#  default_scope :order => 'time_entries.created_at DESC'
    
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  belongs_to :todo                         
  belongs_to :project
  
  before_save :set_project
  
  def day
    self.created_at.to_date
  end
  
  private
    def set_project       
      if todo     
        self.project_id = todo.todo_list.project_id
      end  
    end
end
