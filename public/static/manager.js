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
		

		newForm.appendChild(yearInput);
		newForm.appendChild(nameInput);

		$("#form"+highestFormNumber).fadeIn();
	});
});