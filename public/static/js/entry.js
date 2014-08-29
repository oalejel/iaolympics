$(function() {

	$("#add-score-form").hide();
	$("#deduct-form").hide();
	$("#rescore-form").hide();

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
});