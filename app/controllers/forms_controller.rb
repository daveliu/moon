class FormsController < ApplicationController
  resource_controller
  belongs_to :project
  
  index.before do
    @body_class = "messages forum"
  end
  
  new_action.before do
    object.custom_fields.build
    current_project.users.each do |user|
        @form.notifies.build :user => user
    end
  end                 
  
  
  create.before do
    object.creator_id = current_user.id
    object.project = @project
  end                        
  create.wants.html { redirect_to form_path(@form) }
  create.flash nil
  
  show.before do
    @project = @form.project
  end        
  
  edit.before do
    current_project.users.each do |user|
      if !@form.notify_users.include?(user)
        @form.notifies.build :user => user
      end  
    end
  end
  
  update.flash nil
  
  private
  def set_body_class
    @body_class = "message_form"
  end
end
