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
		$("#new-comment").toggle();
		
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
			break;
		case 39:
			NextImageId = $(".next").find("a").attr("href").match("\\d*$");
			window.location = "/photos/" + NextImageId
			break;
	}
}