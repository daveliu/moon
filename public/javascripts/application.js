function log() {
  if (window && window.console && window.console.log)
    for(var i=0, len = arguments.length; i < len; i++)
      console.log(arguments[i]);
}

$(document).ready(function(){
	$("div.hover_container").live("mouseover", function(){
		$(this).addClass('hover'); 
	}).live("mouseout", function(){ 
    $(this).removeClass('hover'); 
 	});   

}) 
