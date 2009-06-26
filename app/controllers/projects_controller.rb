class ProjectsController < ApplicationController
  resource_controller   

  index.after do
    current_project = nil
  end
      
  create.before do
    object.creator = current_user
  end
  
  show.before do
    @lates = @project.milestones.by_state("late")
    @upcomings = @project.milestones.by_state("upcoming")
    @events = @project.timeline_events

    @body_class = "overview"
    current_project = @project
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
        redirect_to "/projects/project_users"
      end
    else              
      User.all.each do |user|
        if !@project.users.include?(user)
          @project.project_users.build :user => user
        end  
      end
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
