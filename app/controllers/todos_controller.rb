class TodosController < ApplicationController
    resource_controller           
    belongs_to :todo_list
                                  
    create.wants.js
    edit.wants.js
    show.wants.js
    update.wants.js
    
    
    
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
      @todo.reopen!
      respond_to do |wants|
        wants.js
      end
    end
    
end
