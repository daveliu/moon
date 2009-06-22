function results(html){                 
	$("#item_<%= @todo.id %>").replaceWith(html)
}
results("<%=escape_javascript render_to_string(:partial => 'todos/todo', :locals => {:todo => @todo}) %>")

$("#item_<%= @todo.id %>").removeClass("busy")
