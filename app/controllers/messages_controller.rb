class MessagesController < ApplicationController
  resource_controller   
  belongs_to :project
  
  index.before do
    @body_class = "messages forum"
    if params[:category_id]  && !params[:category_id].blank?                     
      @messages = current_project.messages.find(:all, :conditions => ["category_id = ?", params[:category_id]])
    else
      @messages = current_project.messages
    end
  end   
  
  new_action.before do
    current_project.users.each do |user|
        @message.notifies.build :user => user
    end
  end  
    
  
  create.before do
    @message.creator_id = current_user.id
    @message.project = @project
  end                        
  create.wants.html { redirect_to message_path(@message) }
         
  
  show.before do
    @body_class  =  "comments commentable message"
    @project = @message.project
  end             
  
  edit.before do
    current_project.users.each do |user|
      if !@message.notify_users.include?(user)
        @message.notifies.build :user => user
      end  
    end
  end  
  
  create.flash nil
  update.flash nil
  destroy.flash nil             
  
  destroy.wants.html { redirect_to project_messages_path(@message.project) }   
  
  private
  def set_body_class
    @body_class = "message_form"
  end
  
end
