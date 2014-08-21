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

		newForm.appendChild(yearInput);
		newForm.appendChild(nameInput);
		newForm.appendChild(colorInput);
		newForm.appendChild(themeInput);

		$("#form"+highestFormNumber).fadeIn();
	});
});