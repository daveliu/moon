class RolesController < ApplicationController
  resource_controller   
  
  create.before do
    object.project = current_project
  end  
  create.wants.js
  update.wants.js
  
  create.flash nil
  update.flash nil
  destroy.flash nil
end
