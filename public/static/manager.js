$(function() {
	var highestFormNumber = 1;

	$("#addform").click(function() {

		highestFormNumber++;

		var newForm = document.createElement("form");
		newForm.setAttribute("action", "");
		newForm.setAttribute("method", "post");
		newForm.setAttribute("id", "form"+highestFormNumber);
		newForm.setAttribute("style", "display:none;");

		document.getElementById("forms").appendChild(newForm);

		// add input fields

		var deleteP = document.createElement("p");
		deleteP.setAttribute("id", "x");
		deleteP.appendChild(document.createTextNode("x"));

		var yearInput = document.createElement("input");
		yearInput.setAttribute("type", "text");
		yearInput.setAttribute("name", "year");
		yearInput.setAttribute("placeholder", "Class year");

		var nameInput = document.createElement("input");
		nameInput.setAttribute("type", "text");
		nameInput.setAttribute("name", "name");
		nameInput.setAttribute("placeholder", "Class name (e.g. seniors, juniors)");

		var colorInput = document.createElement("input");
		colorInput.setAttribute("type", "text");
		colorInput.setAttribute("name", "color");
		colorInput.setAttribute("placeholder", "Class color");

		var themeInput = document.createElement("input");
		themeInput.setAttribute("type", "text");
		themeInput.setAttribute("name", "theme");
		themeInput.setAttribute("placeholder", "Class theme");

		var hr = document.createElement("hr");

		newForm.appendChild(deleteP);
		newForm.appendChild(yearInput);
		newForm.appendChild(nameInput);
		newForm.appendChild(colorInput);
		newForm.appendChild(themeInput);
		newForm.appendChild(hr);

		$(deleteP).click(function() {
			$(this).parent().hide();
		});

		$("#form"+highestFormNumber).fadeIn();
	});

	$("#save").click(function() {
		var formData = [];
		for(var i = 1; i <= highestFormNumber; i++) {
			var ithForm = document.getElementById("form"+i);
			formData.push({'year': ithForm.year.value, 'name': ithForm.name.value, 'color': ithForm.color.value, 'theme': ithForm.theme.value});
		}
		$.post('/manager', {'data': formData}, function(data) {
			if(data == "ok") {
				// ...
			}
			else {
				console.log("there was an error.");
			}
		});
	});

	$("#x").on('click', function() {
		$(this).parent().hide();
		$.post('/api/grade/' + $(this).attr('data-grade') + '/delete', function(data) {
			if(data == "ok") {
				// ...
			}
			else {
				console.log("there was an error.");
			}
		});
	});
});