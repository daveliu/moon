class ReportsController < ApplicationController

  
  def index 
    if params[:search]
      @project = Project.find_by_id(params[:search][:project_id_equals])  
      @receiver = User.find_by_id(params[:search][:receiver_id_equals])
    end
      
    set_search
    
    @search  = TimeEntry.search(@conditions)
  end
  
  def milestones
    @milestones = Milestone.by_state('completed')
  end           
  
  def milestone
    @milestone = Milestone.find_by_id(params[:milestone_id])
    @milestones = Milestone.by_state('completed')
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
   
   def column_data_for_milestones      
     @milestones = Milestone.all
     ary = @milestones.collect {|milestone| [milestone.title, milestone.total_hours]} 

     chart = Ambling::Data::ColumnChart.new               
     ary.each_with_index do |data, index|
       chart.series << Ambling::Data::Value.new(data.first, :xid => index, :show => true)
     end                                               
     
     #for the column
     chart.graphs << Ambling::Data::ColumnGraph.new([], :gid => 1)
     ary.each_with_index do |data, index|
       chart.graphs.last << Ambling::Data::Value.new(data.last, {:xid => index})
     end                                                            
     render :xml => chart.to_xml
    end        
    
    def line_data_for_milestones      
      @milestones = Milestone.by_state('completed')
      ary = @milestones.collect {|milestone| [milestone.title, milestone.spent_time]}
      
      chart = Ambling::Data::ColumnChart.new               
      ary.each_with_index do |data, index|
        chart.series << Ambling::Data::Value.new(data.first, :xid => index, :show => true)
      end

      chart.graphs << Ambling::Data::ColumnGraph.new([], :gid => 1)
      ary.each_with_index do |data, index|
        chart.graphs.last << Ambling::Data::Value.new(data.last, {:xid => index})
      end   
      render :xml => chart.to_xml   
    end

   def pie_data         
     milestone = Milestone.find params[:milestone_id]
     
     ary = milestone.todo_lists.group_by(&:receiver).collect do |user, lists|
       next if user.nil?
       hours = 0.0
       lists.each do |todo_list|
         hours += todo_list.todos.inject(0.0) {|sum, todo| sum += todo.total_hours}
       end     
       [user.login, hours]
     end                                   
     chart = Ambling::Data::Pie.new
     ary.compact.each do |data|
       chart.slices << Ambling::Data::Slice.new(data.last, :title => data.first)
     end
     render :xml => chart.to_xml
   end         
   
   def pie_data_for_todo_lists         
     milestone = Milestone.find params[:milestone_id]
     
     ary = milestone.todo_lists.group_by(&:receiver).collect do |user, lists|
       next if user.nil?
       [user.login, lists.size]
     end                      
                  
     chart = Ambling::Data::Pie.new
     ary.compact.each do |data|
       chart.slices << Ambling::Data::Slice.new(data.last, :title => data.first)
     end
     render :xml => chart.to_xml
   end
   
   def week_report                 
     
     @week = Time.now
     @todo_lists = TodoList.by_week
     
     ary = []
     @todo_lists.group_by(&:receiver).each do |receiver, lists|
       lists.each do |list|
          ary << [receiver.try(:login), list.title, list.state]     
       end
     end
                                 
     name = "xx.pdf"
     Prawn::Document.generate(name) do                 
     	font "#{Prawn::BASEDIR}/data/fonts/simfang.ttf"  
#     	text "fsfsd"
      text "任务周"  #, :size => 30, :style => :bold
      
      table ary, :border_style => :grid,
        :widths => { 0 => 300, 1 => 300, 2 => 300}, 
        :row_colors => ["FFFFFF","DDDDDD"],
        :headers => ["Name", "Task", "Status"],
        :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
     end
     
     respond_to do |wants|
       wants.html
       wants.pdf  { send_file(File.join(Rails.root, name), :type => 'application/pdf', :disposition => 'inline') }
     end
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
