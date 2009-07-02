class ProjectsController < ApplicationController
#  before_filter :require_no_user, :only => [:add_user]
  skip_before_filter :require_user, :only => [:add_user]
  resource_controller   

  index.before do
    session[:project_id] = nil
    @body_class = "projects dashboard unprintable has_flash_support"
    
    @lates = Milestone.by_state("late")
    @upcomings = Milestone.by_state("upcoming")
    @events = TimelineEvent.all
  end
      
  create.before do
    object.creator = current_user
  end
  
  show.before do
    @lates = @project.milestones.by_state("late")
    @upcomings = @project.milestones.by_state("upcoming")
    @events = @project.timeline_events

    @body_class = "overview"
    session[:project_id] = @project.id
  end            
  
  def project_users
    @project = current_project
    User.all.each do |user|
      if !@project.users.include?(user)
        @project.project_users.build :user => user
      end  
    end
    
    @body_class = "candidates"
  end              
  
  def add_user    
    @project = Project.find params[:id]
    if request.post?
      @user = @project.users.build(params[:user])
      if @user.save
        redirect_to "/user_sessions/new"
      else
        render :layout => "simple"  
      end
    else              
      @user = User.new
      if params[:invitation_token] 
        invitation = Invitation.find_by_token(params[:invitation_token])     
        @user = User.new(:email => invitation.recipient_email) if invitation
      end
      render :layout => "simple"
    end                                                 
  end
  
  def update_project_user
    @project_user = ProjectUser.find_by_project_id_and_user_id(params[:id], params[:user_id])
    if @project_user
      @project_user.destroy
    else
      ProjectUser.create!({:project_id => params[:id], :user_id => params[:user_id]})  
    end  
    respond_to do |wants|
      wants.js
    end
  end
  
  private
  def set_body_class
    @body_class = "projects dashboard unprintable"
  end
end
