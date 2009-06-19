class MessagesController < ApplicationController
  resource_controller
  
  
  def create
    @message = current_user.messages.build(params[:message])
    if @message.save
      redirect_to @message
    else
      render :action => "new"
    end
  end          
  
  def show
    @message = Message.find params[:id]
    #this is bad----------------
    @body_class  =  "comments commentable message"
  end
  
  private
  def set_body_class
    @body_class = "message_form"
  end
end
