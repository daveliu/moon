class TimeEntriesController < ApplicationController
  resource_controller   
  belongs_to :todo
  
  
  new_action.wants.js
  edit.wants.js
  show.wants.js
  create.wants.js
  update.wants.js
  destroy.wants.js
  
  private
  def set_body_class
    @body_class = "time"
  end
end
