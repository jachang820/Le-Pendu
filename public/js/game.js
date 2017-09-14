$(document).ready(function() {
	let count = 0;
	let count_max = $(".source").text().length;
	let beep = new Audio('js/sfx_sounds_Blip9.wav');
	let bloop = new Audio('js/sfx_exp_short_hard10.wav')
	beep.volume = 0.1;
	bloop.volume = 0.1;
	const RIGHT = 39;
	const DEFAULT_PERIOD = 100;

	setInterval(function() {
		if (count < count_max) {
			let next_char = $(".source").text().charAt(count);
			if (next_char != " ") {
				beep.play();
			}
			$(".sink").text(
				$(".sink").text().concat(next_char)
			);
			count++;
		}
	}, DEFAULT_PERIOD);

	$(".begin").click(function() {
		beep.volume = 0;
		bloop.play();
		$(".begin").hide();
		$(".sink, .plot, h1").animate({
			left: "+=30rem",
			width: "-=30rem"
		}, 1000, function() {
			$(".sink, .plot, h1").hide();
		});
	});
});