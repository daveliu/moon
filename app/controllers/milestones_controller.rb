class MilestonesController < ApplicationController
    resource_controller  
    
    create.after do
      object.creator = current_user
    end
    create.wants.html { redirect_to collection_url }
    create.flash ""
    
    private
    def set_body_class
      @body_class = "milestones nubbins"
    end
end
