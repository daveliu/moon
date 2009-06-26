class ProjectsController < ApplicationController
    resource_controller   
    
    show.before do
      @lates = @project.milestones.by_state("late")
      @upcomings = @project.milestones.by_state("upcoming")
      @events = @project.timeline_events

      @body_class = "overview"
    end  
    

    
    private
    def set_body_class
      @body_class = "projects dashboard unprintable"
    end
end
