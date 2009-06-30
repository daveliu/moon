class TimeEntriesController < ApplicationController
  resource_controller   
  belongs_to :todo, :project
  
  def index       
    @project = Project.find params[:project_id]   
    
    if params[:date]
      @start_date = Date.civil(params[:date][:"start_date(1i)"].to_i,params[:date][:"start_date(2i)"].to_i,params[:date][:"start_date(3i)"].to_i)
      @end_date = Date.civil(params[:date][:"end_date(1i)"].to_i,params[:date][:"end_date(2i)"].to_i,params[:date][:"end_date(3i)"].to_i)
                                                           
      date_conditions = {:created_at_greater_than => @start_date, :created_at_less_than => @end_date}
      conditions = params[:search].merge(date_conditions)
      
      @user_name = User.find_by_id(params[:search][:creator_id_equals]).try(:login) || "所有人"
#      @days = end_date - start_date 
    end
    @search  = @project.time_entries.search(conditions || {})
    @time_entries = @search.all
    
    if params[:search]
      render :template => "time_entries/report"
    end  
  end
  
  new_action.wants.js
  edit.wants.js
  show.wants.js      
  
  create.before do
    object.creator_id = current_user.id
    object.project = @project
  end                        
  create.wants.js                                         
  
  update.wants.js
  destroy.wants.js
  
  private
  def set_body_class
    @body_class = "time"
  end
end
