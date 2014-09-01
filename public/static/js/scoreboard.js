$(function() {
	// ...

	var Scoreboard = function(scores) {
		this.scores = scores;
		this.highestScore = this.max(scores);
	}

	Scoreboard.prototype.max = function(arr) {
		var highest = -Infinity;
		for(var i = 0; i < arr.length; i++) {
			if(arr[i] > highest) {
				highest = arr[i];
			}
		}
		return highest;
	}

	Scoreboard.prototype.createSlidebar = function(jqElement, score) {
		// takes a div and stretches it (with animation) to the appropriate score width
		var relativeWidth = (score*1.0)/this.highestScore;
		var percentageString = (relativeWidth*100).toString().slice(0, 4) + "%";
		jqElement.animate({'width': percentageString}, 1000);
	}

	$.get('/api/grades', function(jsonData) {

		var data = JSON.parse(jsonData);

		freshmanGrade = data[0];
		sophomoreGrade = data[1];
		juniorGrade = data[2];
		seniorGrade = data[3];

		$("#freshman-score").css('background-color', JSON.parse(freshmanGrade)["colorhex"]);
		$("#sophomore-score").css('background-color', JSON.parse(sophomoreGrade)["colorhex"]);
		$("#junior-score").css('background-color', JSON.parse(juniorGrade)["colorhex"]);
		$("#senior-score").css('background-color', JSON.parse(seniorGrade)["colorhex"]);
	});

	var originalScores = [$("#freshman-score").attr('data-score'), $("#sophomore-score").attr('data-score'),
								  $("#junior-score").attr('data-score'), $("#senior-score").attr('data-score')];

	var loadScores = function() {
		$.get('/api/scores', function(jsonData) {

			data = JSON.parse(jsonData);

			freshmanScore = data["freshman"];
			sophomoreScore = data["sophomore"];
			juniorScore = data["junior"];
			seniorScore = data["senior"];

			$("#freshman-score").attr('data-score', freshmanScore);
			$("#sophomore-score").attr('data-score', sophomoreScore);
			$("#junior-score").attr('data-score', juniorScore);
			$("#senior-score").attr('data-score', seniorScore);

			var divs = ["senior-score", "junior-score", "sophomore-score", "freshman-score"];
			var scores = [];

			var divsToNames = {"senior-score": "Seniors", "junior-score": "Juniors", "sophomore-score": "Sophomores", "freshman-score": "Freshmen"}



			for(var i = 0; i < divs.length; i++) {
				var jqDiv = $("#"+divs[i]);
				jqDiv.text(divsToNames[divs[i]] + ": " + jqDiv.attr('data-score'));
				var score = parseInt(jqDiv.attr('data-score'));
				scores.push(score);
			}

			var hasChanged = false;

			for(var i = 0; i < divs.length; i++) {
				if(originalScores[i] != scores[i]) {
					hasChanged = true;
					break;
				}
			}

			if(hasChanged) {
				var scoreboard = new Scoreboard(scores);
				for(var i = 0; i < divs.length; i++) {
					var jqDiv = $("#"+divs[i]);
					jqDiv.css('width', '0%');
					originalScores[i] = scores[i];
					scoreboard.createSlidebar($("#"+divs[i]), scores[i]);
				}
			}
		});
	}

	loadScores();
	setInterval(loadScores, 5000);

	$(".score").click(function() {
		var endpointUrl;
		if($(this).attr('id') == 'freshman-score') {
			endpointUrl = '/api/freshman';
		}
		else if($(this).attr('id') == 'sophomore-score') {
			endpointUrl = '/api/sophomore';
		}
		else if($(this).attr('id') == 'junior-score') {
			endpointUrl = '/api/junior';
		}
		else if($(this).attr('id') == 'senior-score') {
			endpointUrl = '/api/senior';
		}
		$.get(endpointUrl, function(data) {
			var detailText;
			var scores = JSON.parse(data);
			for(var score in scores) {
				if(scores.hasOwnProperty(score)) {
					text += score + ": " + scores[score] + "\n";
				}
			}
			$(this).text($(this).text + "\n" + detailText);
		});
	});
});