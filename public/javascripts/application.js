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


/* ------------------------------------------------------------------------
 * pending_attachments.js
 * Copyright (c) 2004-2008 37signals, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

var PendingAttachments = {
  add: function(file_selector, div_id) {       
	  id = "#" + div_id
    var offscreen = $(id).find("p.offscreen"), template = $(id).find("p.template");
    var templateHTML = template.html();

    var last_key = (offscreen.children().size() > 0) ? Number(offscreen.children('input:last').attr('name').match(/(\d+)/)[1]) : 0;
    $(file_selector).attr('name',  $(file_selector).attr('name').replace(/[\d+]/, last_key + 1)) ;

   this.updatePendingAttachments(div_id);  

   offscreen.append($(file_selector));   
   template.html(templateHTML);  
  },      

  updatePendingAttachments: function(div_id) {
		id = "#" + div_id
		var files = $.map($(id).find('input.file_selectors'), function(input){
			if($(input).val() != ""){
			 return "files[]=" + encodeURIComponent($(input).val());
			}
	 })    
		$.ajax({
	    type:'POST', 
			url: '/javascripts/pending_assets', 
			dataType: 'script',
			data:  files.join("&") + "&id=" + div_id                     
	  })
	},

  remove: function(path, div_id) {
    this.removeFileSelector(path, div_id);
    this.updatePendingAttachments(div_id);
  },

  removeFileSelector: function(path, div_id) {
    $(this.findFileSelector(path, div_id)).remove();
  },

  hasPendingAttachments: function(id) {
    if ($(id).down('.pending_attachments')) {
      var pending_attachments = $(id).down('.pending_attachments').down();
      return pending_attachments && pending_attachments.down();
    } else {
      return false;
    }
  },

  hasExistingAttachments: function(id) {
    if ($(id).getElementsBySelector('.attachments li')) {
      var existing_attachments = $(id).getElementsBySelector('.attachments li');
      return existing_attachments.detect(function(item) { return item.visible(); });
    } else {
      return false;
    }
  },

  findFileSelector: function(path, div_id) {
	  id = "#" + div_id
		var files = $.map($(id).find("input.file_selectors"), function(input){
			if($(input).val() == decodeURIComponent(path)){
				return  input
			}
		})
		return files[0]
  }

}
