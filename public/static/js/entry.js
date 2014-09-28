$(function() {

	$("#add-score-form").hide();
	$("#deduct-form").hide();
	$("#rescore-form").hide();

	$(".button").show();

	$(".action").click(function() {
		$(this).parent().parent().parent().fadeOut(500);
		$(".centered").fadeOut(500);
	});

	$("#add-scores").click(function() {
		$("#add-score-form").fadeIn();
	});

	$("#deduct").click(function() {
		$("#deduct-form").fadeIn();
	});

	$("#rescore").click(function() {
		$("#rescore-form").fadeIn();
	});

	$("#back-button").click(function() {
		$("#add-score-form").hide();
		$("#deduct-form").hide();
		$("#rescore-form").hide();
		$(".buttons").show();
		$(".centered").show();
	});

	$("#save-deduction").click(function(e) {
		e.preventDefault();
		var deductionForm = document.getElementById("deduction");
		$.post('/api/deduct', {'grade': deductionForm.grade.value, 'points': deductionForm.points.value}, function(data) {
			if(data == "ok") {
				alert("Changes saved.");
			}
		});
	})

	var validated = function(form) {
		var result = true;

		firstPlace = form.firstPlace.value;
		secondPlace = form.secondPlace.value;
		thirdPlace = form.thirdPlace.value;
		fourthPlace = form.fourthPlace.value;

		places = [firstPlace, secondPlace, thirdPlace, fourthPlace];
		for(var i = 0; i < places.length; i++) {
			for(var j = 0; j < places.length; j++) {
				if(i != j && places[i] == places[j]) {
					// we have two equal place values
					result = false;
				}
			}
		}

		for(var k = 0; k < places.length; k++) {
			if(places[k].indexOf("...") > -1) {
				// one of the placeholder values has been selected
				// invalid
				result = false;
			}
		}

		return result;
	}

	$("#save-scores").click(function(e) {
		e.preventDefault();
		var scoreForm = document.getElementById("score-form");
		if(validated(scoreForm)) {
			$.post('/api/scores', {'event': scoreForm.eventName.value, 'firstplace': scoreForm.firstPlace.value, 'secondplace': scoreForm.secondPlace.value, 'thirdplace': scoreForm.thirdPlace.value, 'fourthplace': scoreForm.fourthPlace.value}, function(data) {
				alert("Changes saved.");
			});
		}
	});
});