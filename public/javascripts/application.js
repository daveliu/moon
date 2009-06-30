function log() {
  if (window && window.console && window.console.log)
    for(var i=0, len = arguments.length; i < len; i++)
      console.log(arguments[i]);
}

function resetForm(id) {
	$('#'+id).each(function(){
		this.reset();
	});
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


var TimeHandler = {
  HIGHLIGHT_CLASS: "donelink",
  CANCEL_REPORT_CREATION: "Cancel report creation",

  submit: function() {
  	if(TimeHandler.action.before) eval(TimeHandler.action.before);
		$.ajax({
	    type: TimeHandler.action.method, 
			url: TimeHandler.action.url, 
			dataType: 'script',
			data: $('#entry_adder').serialize()
		});

    return false;
  },

  toggleReport: function() {
    var link = $('#report_link')[0]
		if(link.className.indexOf(this.HIGHLIGHT_CLASS) < 0) {
      this.original_text = link.innerHTML
      this.original_class = link.className
      link.innerHTML = this.CANCEL_REPORT_CREATION
      link.className += " " + this.HIGHLIGHT_CLASS
      $('#original_title').hide();
      $('#new_time_report').show();
    } else {
      $('#original_title').show();
      $('#new_time_report').hide();
      link.innerHTML = TimeHandler.original_text
      link.className = TimeHandler.original_class
    }
  },

  updateTotals: function(by) {
    this.updateField('hours_subtotal', by);
    this.updateField('hours_total', by);
  },

  updateField: function(field, by) {
    field = $(field);
    if(field) {
      var amount = parseFloat(field.innerHTML) + by;
      field.innerHTML = amount.toFixed(2);
    }
  },

  checkBlankSlate: function() {
    if(this.isBlank()) {
      $('total').hide();
      if($('report_link_block')) Element.hide('report_link_block');
      if($('blank_slate')) {
        $('blank_slate').show();
      }
    } else {
      $('total').show();
      if($('report_link_block')) Element.show('report_link_block')
      if($('blank_slate')) {
        $('blank_slate').hide();
      }
    }
  },

  isBlank: function() {
    return $$("#entries tr.entry").length == 0;
  },

  disableForm: function() {
    if($('#new_time_entry')) {
      Form.disable('new_time_entry');
    }
  },

  enableForm: function() {
    if($('new_time_entry')) {
      Form.enable('new_time_entry');
    }
  }
}


categories = {
  toggleEdit: function() {
    if($('#edit_categories_link').hasClass('active')) {
      $('#CategoryList').removeClass("editing")
      $('#edit_categories_link').removeClass("active")
    } else {
      $('#CategoryList').addClass("editing")
      $('#edit_categories_link').addClass("active")
    }
    $('#add_new_category').toggle();
  },

  cancelEdit: function(id) {
    $('edit_category_' + id).remove()
    $('category_menu_item_' + id).show()
  },

  edit: function(id, name, url) {
    name = prompt("Rename this category", name);
    if(name) {
      $.ajax({
		    type: 'PUT', 
				url: url, 
				dataType: 'script',
				data: 'category[name]=' + encodeURIComponent(name),
			});
    }
  },

  addNew: function() {
//    toggle = function() { $('#add_new_category_link').each(Element.toggle); };
    categories.add({});
  },

  add: function(options) {
    options = options || {};
    var name = prompt("Enter the new category name:", "");
    if(name && name.length > 1) {    
	    $.ajax({
		    type: 'POST', 
				url: $('#add_new_category_link').attr('href'),
				dataType: 'script',
				data: 'category[name]=' + encodeURIComponent(name),
			});
    }
  },

  addFailed: function(request, options) {
    alert("An error prevented the category from being added. Please try again.")
    if(options.addFailed) options.addFailed(req);
  }
}
