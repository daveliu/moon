class AssetsController < ApplicationController
    resource_controller   
    
    destroy.flash ""
    destroy.wants.js {render :text => ""}
end
