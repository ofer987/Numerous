// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

function clearTagSelections() {
	$(".photos-list").children(".photos-list-item").each(function() {
		$(this).css("display", "inline-block");
	});
}

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
  $("#kaka").submitWithAjax();
});

$(document).ready(function() {
	$("#displayed-photo").load(function() {
		imageHeight = $(this).height();
		$(".navigate-photo-link").css("bottom", imageHeight / 2);
	});
});

$(document).ready(function() {
	$("#add-comment-button").click(function () {
		//$("#new-comment").animate({ display: 'toggle' });
		$('#new-comment').toggle();
		$("#comment_content").focus();
		$.scrollTo($("#new_comment")[0], 0);
	});
});

$(document).ready(function() {	
	$(".select-tags-form").children("input.checkbox").click(function() {
		selectedTags = []
		
		$(".select-tags-form").children("input.checkbox").each(function() {
			if ($(this).prop("checked") == true) {
				// Put the name of the selected tag in the list
				selectedTags.push($(this).attr("value"))
			}
		});
		
		// If no tags were selected then
		// show all the photos
		if (selectedTags.length == 0) {
			clearTagSelections();
		} else {
			// Only display photos (DIVs) that have a tag in the selected tag list
			$(".photos-list").children(".photos-list-item").each(function() {
				isDisplayPhoto = false;
				// Get the photos tags; 
				// remove the trailing space;
				// store the tags in an array.
				photoTags = $(this).attr("tags").trim().split(" ");
				
				// Does the photo have a tag in the selected tags?
				for (i = 0; i < photoTags.length; i++) {
					for (j = 0; j < selectedTags.length; j++) {
						if (photoTags[i] == selectedTags[j]) {
							isDisplayPhoto = true;
						}
					}
				}
				
				// Display the photo or not?
				$(this).css("display", isDisplayPhoto ? "inline-block" : "none");
			});
		}
	
		//return false;
	});
	
	$(".clear-tags-form").click(function() {
		$(".select-tags-form").children("input.checkbox").each(function() {
			$(this).prop("checked", false);
		});
		
		clearTagSelections();
		
		return false;
	});
});

$(document).ready(function() {
  document.onkeyup = NavigatePhoto;
});

function NavigatePhoto(e)
{
  var KeyId = window.event ? event.keyCode : e.keyCode;

	switch (KeyId)
	{
		case 37:
			PrevImageId = $(".prev").find("a").attr("href").match("\\d*$");
			window.location = "/photos/" + PrevImageId;
			break;e 
		case 39:
			NextImageId = $(".next").find("a").attr("href").match("\\d*$");
			window.location = "/photos/" + NextImageId
			break;
	}
}