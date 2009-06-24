class MessagesController < ApplicationController
  resource_controller   
  
  def index
    @body_class = "messages forum"
    if params[:category_id]  && !params[:category_id].blank?                     
      @messages = Message.find(:all, :conditions => ["category_id = ?", params[:category_id]])
    else
      @messages = Message.all
    end
  end
  
  
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
  
  # edit.after do
  #   @message.assets
  # end  
  update.flash ""
  destroy.flash ""
  
  private
  def set_body_class
    @body_class = "message_form"
  end
end
