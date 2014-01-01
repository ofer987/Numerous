# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

DisplayAllPhotos = ->
	$(photoItem).css "display", "block" for photoItem in $("#photos").children("div.photo")

# index
# Display only the photos that have the selected tags 
DisplaySelectedPhotos = ->
	selectedTags = []
	for button in $("#tags").children("button.tag")
		if $(button).prop("selected") == true
			# Put the name of the selected tag in the list
			selectedTags.push $(button).attr("value")
	
	# If no tags were selected then
	# show all the photos
	if selectedTags.length == 0
		DisplayAllPhotos()
	else
		# Only display photos (DIVs) that have a tag in the selected tag list
		for photoItem in $("#photos").children("div.photo")
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
			$(photoItem).css("display",
        if isDisplayPhoto then "block" else "none")

# index:
# Add the click event handlers to the tags (both checkboxes and the adjecent text span)
# Add the functionality to the clear button (to show all the photos)
$ ->
	$("#tags").children("button.tag").click ->
    if $(this).prop("selected") == true
      unselectTag(this)
    else
      selectTag(this)
    DisplaySelectedPhotos()

	$("#tags > button#clear").click ->
		unselectTag(button) for button in $("#tags").children("button.tag")
		
		DisplayAllPhotos()
		
		# Do not refresh the page
		false

# index:
# Display the photos with the selected tag
# One tag can be passed in the query string
$ ->
  DisplaySelectedPhotos()

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
	fixNavigationKeys()

# show:
# the left keyboard button: go to previous photo
# the right keyboard button: go to next photo
$ ->
  document.onkeyup = NavigatePhoto

unselectTag = (tagButton) ->
  $(tagButton).removeClass("btn-primary")
  $(tagButton).addClass('btn-default')
  $(tagButton).prop("selected", false)

selectTag = (tagButton) ->
  $(tagButton).addClass("btn-primary")
  $(tagButton).removeClass('btn-default')
  $(tagButton).prop("selected", true)


NavigatePhoto = (e) ->
	keyCode = if window.event then event.keyCode else e.keyCode
	
	switch keyCode
		when 37
			prevImageId = $(".prev").find("a").attr("href").match("\\d*$")
			window.location = "/photos/" + prevImageId
		when 39
			nextImageId = $(".next").find("a").attr("href").match("\\d*$")
			window.location = "/photos/" + nextImageId

fixNavigationKeys = ->
	$("#displayed-photo").load ->
		imageHeight = $(this).height()
		$(".navigate-photo-link").height(imageHeight)
		
		# -25px to align the image because it is 50px tall
		alignImage = imageHeight / 2 - 25
		$(".navigate-photo-link").children("a").css "bottom", alignImage	
