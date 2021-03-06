class TodoListsController < ApplicationController
  resource_controller           
  belongs_to :project                            
  
  after_filter :set_current_project
  
  index.before do
    if params[:responsible_party]  && !params[:responsible_party].blank?                     
      @user = User.find(params[:responsible_party])
      @todo_lists = current_project.todo_lists.find(:all,:conditions => ["receiver_id = ?", params[:responsible_party]])
    else
      @todo_lists = current_project.todo_lists
    end    
  end

  
  create.before do
    object.creator_id = current_user.id
    object.project = @project
  end                        
  create.wants.html { redirect_to project_todo_lists_path(@project) }
  create.flash nil 
  
  edit.wants.js    
  
  show.before do
    @project = @todo_list.project
  end
  show.wants.js
  update.wants.js
  
  update.flash nil
  
  destroy.wants.html { redirect_to project_todo_lists_path(@todo_list.project) }   
  destroy.flash nil       
  
  def complete
    @todo_list = TodoList.find(params[:id])
    @todo_list.complete!
    respond_to do |wants|
      wants.js
    end
  end         
  
  
  def reopen
    @todo_list = TodoList.find(params[:id])
    @todo_list.reopen!
    respond_to do |wants|
      wants.js
    end
  end
  
  
  private
  def set_body_class
    @body_class = "todos nubbins"
  end
 
  
end
