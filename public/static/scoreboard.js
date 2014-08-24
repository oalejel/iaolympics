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

	Scoreboard.prototype.createSlidebar = function(domElement, score) {
		// takes a div and stretches it (with animation) to the appropriate score width
		var relativeWidth = (score*1.0)/this.highestScore;
		var percentageString = (relativeWidth*100).toString() + "%";
		$(domElement).animate({'width': percentageString}, 1000);
	}
});