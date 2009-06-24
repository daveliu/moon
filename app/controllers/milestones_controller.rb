class MilestonesController < ApplicationController
    resource_controller  
    
    def index
      get_milestones
    end
    
    create.before do
      object.creator = current_user
    end
    create.wants.html { redirect_to collection_url }
    create.flash ""   
    
    show.before do
      @body_class = "comments commentable milestone"
    end                            
    
    show.wants.js
    edit.wants.js
    update.wants.js
    
    update.flash ""
    create.flash ""
    
    
    def complete
      @milestone = Milestone.find(params[:id])
      @milestone.complete!
      get_milestones
      respond_to do |wants|
        wants.js
      end
    end         
    
    
    def reopen
      @milestone = Milestone.find(params[:id])    
      @milestone.reopen!
      get_milestones
      respond_to do |wants|
        wants.js
      end
    end
    
    private
    def set_body_class
      @body_class = "milestones nubbins"
    end  
    
    def get_milestones
      @lates = Milestone.by_state("late")
      @upcomings = Milestone.by_state("upcoming")
      @completes = Milestone.by_state("completed")
    end
end
