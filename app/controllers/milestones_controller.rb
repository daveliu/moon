class MilestonesController < ApplicationController
    resource_controller  
    belongs_to :project
    
    index.before do
      get_milestones      
      Milestone.set_late # upcoming to late
    end
    
    create.before do
      object.creator = current_user
      object.project = @project
    end
    create.wants.html { redirect_to milestones_path(@project) }
    create.flash ""   
    
    show.before do
      @body_class = "comments commentable milestone"
    end                            
    
    show.wants.js
    edit.wants.js
    update.wants.js
    
    update.flash nil
    create.flash nil
    
    
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
      @lates = current_project.milestones.by_state("late")
      @upcomings = current_project.milestones.by_state("upcoming")
      @completes = current_project.milestones.by_state("completed")
    end
end
