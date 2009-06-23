class TodoListsController < ApplicationController
  resource_controller           
  
  def index
    if params[:responsible_party]  && !params[:responsible_party].blank?                     
      @user = User.find(params[:responsible_party])
      @todo_lists = TodoList.find(:all, :joins => :todos, 
                    :conditions => ["todos.receiver_id = ?", params[:responsible_party]],
                    :group => "todo_lists.id"
                    )
    else
      @todo_lists = TodoList.all
    end    
  end

  
  create.after do
    object.creator = current_user
  end
  create.wants.html { redirect_to collection_url }
  create.flash "" 
  
  update.flash ""
  destroy.flash ""
  
  private
  def set_body_class
    @body_class = "todos nubbins"
  end
  
end
