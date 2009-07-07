class ReportsController < ApplicationController
  def index 
    if params[:search]
      @project = Project.find_by_id(params[:search][:project_id_equals])  
      @receiver = User.find_by_id(params[:search][:receiver_id_equals])
    end
      
    set_search
    
    @search  = TimeEntry.search(@conditions)
  end
  
  def milestone
    @milestone = Milestone.find_by_id(params[:milestone_id]) || Milestone.first
  end
  
  def column_data      
    @search = TimeEntry.search(params[:search])                
    ary = @search.all
    hash = ary.group_by(&:day)   
    days = hash.keys
    hours = hash.values.collect do |entries|
      entries.sum(&:hours)
    end  
    
    chart = Ambling::Data::ColumnChart.new               
    days.each_with_index do |day, index|
      chart.series << Ambling::Data::Value.new(day, :xid => index, :show => true)
    end                                               
    
    chart.graphs << Ambling::Data::ColumnGraph.new([], :gid => 0)
    hours.each_with_index do |hour, index|
      chart.graphs.last << Ambling::Data::Value.new(hour, {:xid => index})
    end
    render :xml => chart.to_xml
   end          

   def pie_data         
     milestone = Milestone.find params[:milestone_id]
     
     ary = milestone.todo_lists.group_by(&:creator).collect do |user, lists|
       hours = 0.0
       lists.each do |todo_list|
         hours += todo_list.todos.inject(0.0) {|sum, todo| sum += todo.total_hours}
       end     
       [user.login, hours]
     end                                   
     chart = Ambling::Data::Pie.new
     ary.each do |data|
       chart.slices << Ambling::Data::Slice.new(data.last, :title => data.first)
     end
     render :xml => chart.to_xml
   end         


  private
   def set_body_class
     @body_class = "time"
   end
   
   def set_search
     @start_date =   1.month.ago.to_date
     @end_date = Time.now.tomorrow.to_date
     @user_name = "所有人"
     @project_name = "所有项目"
     if params[:date]
       @start_date = Date.civil(params[:date][:"start_date(1i)"].to_i,params[:date][:"start_date(2i)"].to_i,params[:date][:"start_date(3i)"].to_i)
       @end_date = Date.civil(params[:date][:"end_date(1i)"].to_i,params[:date][:"end_date(2i)"].to_i,params[:date][:"end_date(3i)"].to_i)
     end                                                                                     
     date_conditions = {:created_at_greater_than => @start_date, :created_at_less_than => @end_date + 1.day}

     if params[:search]
       @conditions = params[:search].merge(date_conditions)
       @user_name = @receiver.try(:login)
       @project_name = @project.try(:name)
     else
       @conditions = date_conditions
     end
   end
end
