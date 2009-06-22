function log() {
  if (window && window.console && window.console.log)
    for(var i=0, len = arguments.length; i < len; i++)
      console.log(arguments[i]);
}

$(document).ready(function(){
	$("div.items_wrapper div.hover_container").hover(
		function() {        
			if(!$(this).hasClass("hover")){
		  	$(this).addClass("hover");
		  }
	  },                                         
		function() {
		  $(this).removeClass("hover");
	  }
	)
}) 
