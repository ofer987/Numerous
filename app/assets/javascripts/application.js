// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  findPageNameRegExp = /\/{1}(\w+)/i;
	
	pageNameMatch = window.location.pathname.match(findPageNameRegExp);
	
	if (pageNameMatch != null && pageNameMatch.length > 1) {
		pageName = pageNameMatch[1];
		pageNameItem = pageName + "-item";
		
		$("li#" + pageNameItem).addClass("selected-item");
	}	else if (window.location.pathname == "/") {
		// Special case: the photos page is the index page
		$("li#photos-item").addClass("selected-item");
	}
});

