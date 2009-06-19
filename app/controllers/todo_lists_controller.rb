class TodoListsController < ApplicationController
  resource_controller           

  new_action.before do
    @body_class = "message_form"
  end  
  
  create.after do
    object.creator = current_user
  end
  create.wants.html { redirect_to collection_url }
  create.flash ""
  
  private
  def set_body_class
    @body_class = "todos nubbins"
  end
  
end
