module ApplicationHelper
  def body_class
   # "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
     @body_class || ""
  end
  
  def tab_fu(name, path='', right=false)
    html = ""   
    if right
      html << "<li style='float:right;'>"
    else
      html << "<li>"
    end            
    
    html << link_to(name, path)
    html << "</li>"
  end
  
  def state_path(milestone)           
    milestone.completed? ? reopen_milestone_path(milestone) : complete_milestone_path(milestone)
  end
end
