module ApplicationHelper
  def body_class
   # "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
     @body_class || ""
  end
  
  def tab_fu(name, path='',  highlight=false, right=false)
    html = ""   
    if right
      html << "<li style='float:right;'>"
    else
      html << "<li>"
    end            
    
    if highlight
      html << link_to(name, path, :class => "current")
    else
      html << link_to(name, path)   
    end  
    html << "</li>"
  end
  
  def state_path(milestone)           
    milestone.completed? ? reopen_milestone_path(milestone) : complete_milestone_path(milestone)
  end
  
  def today?(date)
    Time.now.to_date == date
  end
  
  
  # This method demonstrates the use of the :child_index option to render a
  # form partial for, for instance, client side addition of new nested
  # records.
  #
  # This specific example creates a link which uses javascript to add a new
  # form partial to the DOM.
  #
  #   <% form_for @project do |project_form| -%>
  #     <div id="tasks">
  #       <% project_form.fields_for :tasks do |task_form| %>
  #         <%= render :partial => 'task', :locals => { :f => task_form } %>
  #       <% end %>
  #     </div>
  #   <% end -%>


  def generate_html(form_builder, method, partial, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= partial.to_s.singularize
    options[:form_builder_local] ||= :f  

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end

  end


  def generate_template(form_builder, method, partial, options = {})
    escape_javascript generate_html(form_builder, method, partial, options = {})
  end
  
end
