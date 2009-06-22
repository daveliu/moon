function results(html){                 
	$("#item_<%= @todo.id %>_content").html(html)
}
results("<%=escape_javascript render_to_string(:partial => 'todos/edit_form', :locals => {:todo => @todo}) %>")

$("#item_<%= @todo.id %>_nubbin").removeClass("busy")
$("item_<%= @todo.id %>_content_field").focus();

