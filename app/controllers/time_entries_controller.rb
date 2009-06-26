class TimeEntriesController < ApplicationController
  resource_controller   
  belongs_to :todo, :project
  
  
  new_action.wants.js
  edit.wants.js
  show.wants.js      
  
  create.before do
    object.creator_id = current_user.id
    object.project = @project
  end                        
  create.wants.js                                         
  
  update.wants.js
  destroy.wants.js
  
  private
  def set_body_class
    @body_class = "time"
  end
end
