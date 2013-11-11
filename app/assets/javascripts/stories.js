function dragenter(e) {
	e.stopPropagation();
	e.preventDefault();
}

function dragover(e) {
	e.stopPropagation();
	e.preventDefault();
}

function drop(e) {
	e.stopPropagation();
	e.preventDefault();
	
	var dt = e.dataTransfer;
	var files = dt.files;
	
	handleFiles(files);
	//$.ajax(
	//	{
	//		type: "POST",
	//		url: "/stories/",
	//		data: files[0],
	//		processData: false			
	//	});
}

function handleFiles(files) {
	var preview = document.getElementById("preview");
	var imageType = /image.*/
	
	for (var i = 0; i < files.length; i++) {
		var file = files[i];
		
		if (file.type.match(imageType)) {		
			var img = document.createElement("img");
			img.classList.add("obj");
			img.file = file;
			preview.appendChild(img);
		
			var reader = new FileReader();
			reader.onload = (function (aImg) {
				return function (e) {
					aImg.src = e.target.result;
				};
			})(img);
			reader.readAsDataURL(file);		
		}
	}
}

$(document).ready(function () {
	$('#new_photo').fileupload();
})

//$(document).ready(function() {
//	var dropbox;
//
//	dropbox = document.getElementById("dropbox")
//	dropbox.addEventListener("dragenter", dragenter, false)
//	dropbox.addEventListener("dragover", dragover, false)
//	dropbox.addEventListener("drop", drop, false)
//});