class TodoListsController < ApplicationController
  resource_controller           
  belongs_to :project
  
  index.after do
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

  
  create.before do
    object.creator_id = current_user.id
    object.project = @project
  end                        
  create.wants.html { redirect_to project_todo_lists_path(@project) }
  create.flash "" 
  
  edit.wants.js    
  
  show.before do
    @project = @todo_list.project
  end
  show.wants.js
  update.wants.js
  
  update.flash ""
  
  destroy.wants.html { redirect_to project_todo_lists_path(@todo_list.project) }   
  destroy.flash ""       
  
  
  private
  def set_body_class
    @body_class = "todos nubbins"
  end
  
end
