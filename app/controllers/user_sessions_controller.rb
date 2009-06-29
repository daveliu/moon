class UserSessionsController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
  skip_before_filter :require_user, :only => [:destroy, :new, :create]
  
  def new
    @user_session = UserSession.new
    render :layout => "simple"
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to projects_path
    else
      render :action => :new, :layout => "simple"
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end        
  
  private
  def set_body_class
    @body_class = "login"
  end
end
