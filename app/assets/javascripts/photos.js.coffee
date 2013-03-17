# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

DisplayAllPhotos = ->
	$(photoItem).css "display", "inline-block" for photoItem in $(".photos-list").children(".photos-list-item")

# index:
# Display only the photos that have the selected tags 
$ ->
	$(".select-tags-form").children("input.checkbox").click ->
		selectedTags = []
		for tagCheckBox in $(".select-tags-form").children("input.checkbox")
			if $(tagCheckBox).prop("checked") == true
				# Put the name of the selected tag in the list
				selectedTags.push $(tagCheckBox).attr("value")
		
		# If no tags were selected then
		# show all the photos
		if selectedTags.length == 0
			DisplayAllPhotos()
		else
			# Only display photos (DIVs) that have a tag in the selected tag list
			for photoItem in $(".photos-list").children(".photos-list-item")
				isDisplayPhoto = false
				# Get the photos tags; 
				# remove the trailing space;
				# store the tags in an array.
				photoTags = $(photoItem).attr("tags").trim().split " "
				
				# Does the photo have a tag in the selected tags?
				for photoTag in photoTags
					for selectedTag in selectedTags 
						if photoTag == selectedTag
							isDisplayPhoto = true
				
				# Display the photo or not?
				$(photoItem).css("display", if isDisplayPhoto then "inline-block" else "none");

	$(".clear-tags-form").click ->
		$(tagCheckBox).prop "checked", false for tagCheckBox in $(".select-tags-form").children("input.checkbox")
		
		DisplayAllPhotos()
		
		# Do not refresh the page
		false;

# show: 
# Pressing the new comment button, displays a text area
# and scrolls to it 
$ ->
	$("#add-comment-button").click ->
		$('#new-comment').toggle()
		$("#comment_content").focus()
		$.scrollTo $("#new_comment")[0], 0

# show:
# Set the height of the navigate left and right buttons to be 
# at the middle of the photos' height	
$ ->
	$("#displayed-photo").load ->
		imageHeight = $(this).height()
		$(".navigate-photo-link").css "bottom", imageHeight / 2

# show:
# the left keyboard button: go to previous photo
# the right keyboard button: go to next photo
$ ->
  document.onkeyup = NavigatePhoto

NavigatePhoto = (e) ->
	keyCode = if window.event then event.keyCode else e.keyCode
	
	switch keyCode
		when 37
			prevImageId = $(".prev").find("a").attr("href").match("\\d*$")
			window.location = "/photos/" + prevImageId
		when 39
			nextImageId = $(".next").find("a").attr("href").match("\\d*$")
			window.location = "/photos/" + nextImageId