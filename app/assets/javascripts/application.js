// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require_tree .

// Navbar: Set active item
$(document).ready(function() {
  findPageNameRegExp = /^\/{1}(\w+)/i;
	
	pageNameMatch = window.location.pathname.match(findPageNameRegExp);
	
	if (pageNameMatch !== null && pageNameMatch.length > 1) {
		pageName = pageNameMatch[1];
		pageNameItem = pageName + "-item";
    if (pageName === 'countries' || pageName == 'cities' || 
       pageName === 'places') {
      $('li#destinations-item').addClass('active');
    }
    else {
		  $("li#" + pageNameItem).addClass("active");
    }
	}
	else if (window.location.pathname === "/") {
		// Special case: the blogs#index page is the default page
		$("li#articles-item").addClass("active");
	}
});

// If a row has a checkbox, then clicking anywhere in the row behaves
// like clicking on the checkbox
$(document).ready(function() {
    $(".clickable-parent:checkbox").each(function () {
        var checkbox = this;
        $(this).parent().click(function() {
            $(checkbox).click();
        });
    });
});


