class ResponsesController < ApplicationController
  resource_controller
  belongs_to :form                                                
  
  create.before do
    object.creator_id = current_user.id
    object.form = @form
  end                        
  create.wants.html { redirect_to project_forms_path(@form.project) }
  create.flash "提交成功"                                             
  
  
  show.before do
    @body_class  =  "comments commentable message"
    @form = @response.form
  end
  
  
  
  private
  def set_body_class
    @body_class = "message_form"
  end
end
