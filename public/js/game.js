$(document).ready(function() {
	/* count, count_max
	   Used to show plot letter by letter
	*/ 
	let count = 0;
	let count_max = $(".source").text().length;

	/* *_sound
	   Create HTML/DOM objects for all audio
	*/
	let text_sound = new Audio('sounds/msg_beep.wav');
	let begin_sound = new Audio('sounds/begin.wav');
	let correct_sound = new Audio('sounds/correct.wav');
	let wrong_sound = new Audio('sounds/wrong.wav');
	
	/* Lower volume */
	text_sound.volume = 0.2;
	begin_sound.volume = 0.2;
	correct_sound.volume = 0.2;
	wrong_sound.volume = 0.2;

	/* Restore sound preferences from ajax */
	let muted = ($("#volume-status").text() == "false") ? false : true;
	toggle_vol_button(muted);
	mute_volume(muted);

	/* Right-key ASCII and text-speed (unused) */
	const RIGHT = 39;
	const DEFAULT_PERIOD = 100;

	/* Cut off for when guess form is visible */
	const MIN_WINDOW_WIDTH = 576;

	animate_begin();
	handle_guess_form();

	if (window.location.pathname == "/game") {
		shout_msg();
		guess_status();
	}
	else {
		/* Without JS: source visible, sink hidden
			 With JS: sink visible, source hidden
		*/
		$(".source").hide();
		$(".sink").show();
	}

	/* Apply blur to background img in css */
	if (window.location.pathname == "/lose") {
		$("img").addClass("lose");
	}
	else {
		$("img").removeClass("lose");
	}

	/* Move each character from source to sink divs */
	setInterval(function() {
		if (count < count_max) {
			let next_char = $(".source").text().charAt(count);
			if (next_char != " ") {
				text_sound.play();
			}
			$(".sink").text(
				$(".sink").text().concat(next_char)
			);
			count++;
		}
	}, DEFAULT_PERIOD);

	/* Animate "Cast a spell" button:
	   1. Moves all elements to right and collapse
	      until they disappear.
	   2. POST form to initialize game.
	*/
	$(".begin").click(function() {
		text_sound.volume = 0;
		begin_sound.play();
		$(".begin").hide();
		$(".sink, .plot, h1, .volume").animate({
			left: "+=30rem",
			width: "-=30rem"
		}, 1000, function() {
			$("#cast-spell").submit();
			$(".sink, .plot, h1, .volume").hide();
		});
	});

	/* Allow keypresses to be registered for guessing.
	   Enter key starts new game besides on game screen.
	*/
	$(document).keypress(function(e) {
		if ($(window).width() > MIN_WINDOW_WIDTH) {
			if (window.location.pathname == "/game") {
				$("#guess").val(String.fromCharCode(e.which));
				$("#guess-form").submit();
			}
			else {
				$(".begin").click();
			}
		}
	});

	/* Volume buttons do 3 things:
		 1. Toggle the buttons. If audio on is clicked,
		    show mute button, and vice versa.
		 2. AddEventHandler to mute or turn on volume for
		    each sound.
		 3. PUT a json request through ajax so that user
		    preference is stored.
	*/
	$("#audio").click(function() {
		$("#audio").hide();
		$("#mute").show();
	});
	$("#audio").on("click", false, mute_volume);
	$("#audio").click(function() {
		$.ajax({
			url: window.location.pathname,
			type: 'PUT',
			dataType: 'json',
			data: {muted: false}
		});
	});

	$("#mute").click(function() {
		$("#mute").hide();
		$("#audio").show();
	});
	$("#mute").on("click", true, mute_volume);
	$("#mute").click(function() {
		$.ajax({
			url: window.location.pathname,
			type: 'PUT',
			dataType: 'json',
			data: {muted: true}
		});
	});

	$(window).resize(handle_guess_form);

	/* Plays sound after guess */
	function guess_status() {
		if ($("#guess-status").text() == "correct") {
			correct_sound.play();
		}
		else {
			wrong_sound.play();
		}
	}

	/* Without JS: Witch's speech bubble always visible.
	   With JS: Speech bubble only visible for 2 seconds
	            when there is text. Valid guesses appear
	            larger.
	*/
	function shout_msg() {
		if ($("span.bubble").text().length > 0) {
			if ($("span.bubble").text().length == 2) {
				$("span.bubble").attr("id", "letter");
			}
			$(".bubble").show();
			setTimeout(function() {
				$(".bubble").hide();
				$("span.bubble").removeAttr("id");
			}, 2000);
		}
		else {
			$(".bubble").hide();
		}
	}

  /* Accepts either boolean or ajax data */
	function mute_volume(event) {
		let status = (typeof event === "boolean") ?
			event : event.data;
		text_sound.muted = status;
		begin_sound.muted = status;
		correct_sound.muted = status;
		wrong_sound.muted = status;
	}

	function toggle_vol_button(status) {
		if (status) {
			$("#audio").show();
			$("#mute").hide();
		}
		else {
			$("#mute").show();
			$("#audio").hide();
		}
	}

	/* Without JS: "Cast a spell" button POSTs immediately.
     With JS: Animation moves all elements to right before
              POSTing.
	*/
	function animate_begin() {
		$(".js").addClass("begin");
		$("#cast-spell button").removeClass("begin");
		$("#cast-spell").hide();
		$(".js").show();
	}

	/* Without JS: Guess form visible for guessing.
	   With JS: Type on keyboard to guess. Guess form
	            hidden except in mobile (browser width
	            is small).
	*/
	function handle_guess_form() {
		if ($(window).width() > MIN_WINDOW_WIDTH) {
			$("#guess-form").hide();
		}
		else {
			$("#guess-form").show();
		}
	}

});

	