class TodosController < ApplicationController
    resource_controller           
    belongs_to :todo_list
                                  
    create.wants.js
    edit.wants.js
    show.wants.js
    update.wants.js  
    
    create.flash ""
    update.flash ""
    
    create.before do
      object.creator = current_user
    end
    
    show.before do
      @body_class = "comments commentable todo_item"
      @todo_list = @todo.todo_list
    end  
    
    
    def complete
      @todo = Todo.find(params[:id])
      @todo_list = @todo.todo_list
      @todo.complete!
      respond_to do |wants|
        wants.js
      end
    end         
    
    
    def reopen
      @todo = Todo.find(params[:id])
      @todo_list = @todo.todo_list
      @todo.reopen!
      respond_to do |wants|
        wants.js
      end
    end
    
end
