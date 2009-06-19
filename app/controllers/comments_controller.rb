class CommentsController < ApplicationController
  
  def create
    @model = to_model(params[:commentable_type])
    @commentable = @model.find(params[:commentable_id])
    @comment = Comment.new(params[:comment])
    @comment.creator = current_user  
    respond_to do |format|
      if @commentable.comments << @comment
        format.html do
          redirect_to :controller => to_controller(params[:commentable_type]), :action => 'show', :id => params[:commentable_id]
        end  
        format.js
      else
        format.html { redirect_to :controller => to_controller(params[:commentable_type]), :action => 'show', 
              :id => params[:commentable_id]}
      end
    end
  end   

  def destroy
    @comment  = Comment.find(params[:id])
    @comment.destroy
    respond_to do |wants|
      wants.js { render :text => "" }  
    end
  end                             
  
  private
  def set_body_class
    @body_class  =  "comments commentable message"
  end

end
