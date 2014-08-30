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

		for(var i = 0; i < divs.length; i++) {
			var jqDiv = $("#"+divs[i]);
			/* set its width to 0, 
				grab its score,
				and add it to the scores list */
			jqDiv.css('width', '0%');
			var score = parseInt(jqDiv.attr('data-score'));
			scores.push(score);
		}

		var scoreboard = new Scoreboard(scores);

		for(var i = 0; i < divs.length; i++) {
			scoreboard.createSlidebar($("#"+divs[i]), scores[i]);
		}
	});
});