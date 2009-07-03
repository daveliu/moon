class CategoriesController < ApplicationController
  resource_controller   
  belongs_to :project
  
  create.before do
    object.project = @project
  end     
  create.wants.js
  update.wants.js
  
  create.flash nil
  update.flash nil
  destroy.flash nil
end
