module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
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
end
