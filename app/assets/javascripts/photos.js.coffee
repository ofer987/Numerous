# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

DisplayAllPhotos = ->
	$(photoItem).css "display", "inline-block" for photoItem in $(".photos-list").children(".photo-item")

# index
# Display only the photos that have the selected tags 
DisplaySelectedPhotos = ->
	selectedTags = []
	for tagCheckBox in $(".select-tags-list").find("input.checkbox")
		if $(tagCheckBox).prop("checked") == true
			# Put the name of the selected tag in the list
			selectedTags.push $(tagCheckBox).attr("value")
	
	# If no tags were selected then
	# show all the photos
	if selectedTags.length == 0
		DisplayAllPhotos()
	else
		# Only display photos (DIVs) that have a tag in the selected tag list
		for photoItem in $(".photos-list").children(".photo-item")
			isDisplayPhoto = false
			# Get the photos tags; 
			# remove the trailing space;
			# store the tags in an array.
			photoTags = $(photoItem).attr("tags").split ","
			
			# Does the photo have a tag in the selected tags?
			for photoTag in photoTags
				for selectedTag in selectedTags 
					if photoTag == selectedTag
						isDisplayPhoto = true
			
			# Display the photo or not?
			$(photoItem).css("display", if isDisplayPhoto then "inline-block" else "none");

# index:
# Add the click event handlers to the tags (both checkboxes and the adjecent text span)
# Add the functionality to the clear button (to show all the photos)
$ ->
	$(".select-tags-list").find("input.checkbox").click ->
		DisplaySelectedPhotos()

	$(".select-tags-list").find("span.text").click ->
		tagCheckBox = $(this).prev()
		isClicked = tagCheckBox.prop "checked"
		tagCheckBox.prop "checked", !isClicked
		DisplaySelectedPhotos()

	$(".clear-tags-button").click ->
		$(tagCheckBox).prop "checked", false for tagCheckBox in $(".select-tags-list").find("input.checkbox")
		
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
		$(".navigate-photo-link").height(imageHeight)
		
		# -25px to align the image because it is 50px tall
		alignImage = imageHeight / 2 - 25
		$(".navigate-photo-link").children("a").css "bottom", alignImage

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