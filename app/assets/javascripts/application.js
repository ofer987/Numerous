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
  findPageNameRegExp = /^\/{1}(\w+)/i;
	
	pageNameMatch = window.location.pathname.match(findPageNameRegExp);
	
	if (pageNameMatch !== null && pageNameMatch.length > 1) {
		pageName = pageNameMatch[1];
		if (pageName === "articles" || pageName === "gazettes") {
			pageName = "blogs";
		}
		
		pageNameItem = pageName + "-item";
		
		$("li#" + pageNameItem).addClass("selected-item");
	}
	else if (window.location.pathname === "/") {
		// Special case: the blogs#index page is the default page
		$("li#blogs-item").addClass("selected-item");
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
