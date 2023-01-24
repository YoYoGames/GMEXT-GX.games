/// @description CODE IS HERE

// Inherit the parent event
event_inherited();

text = "User Scores";

trackId = undefined;

var _game = gxc_get_query_param("game");
var _challenge = gxc_get_query_param("challenge");

var _track = trackId ? trackId : gxc_get_query_param("track");

locked = is_undefined(_game) || is_undefined(_track) || is_undefined(_challenge);

// Definition of onClick function that will be executed
// when the button is clicked.
onClick = function() {

	var _options = {};

	// Passing a trackId will override the current query params
	// otherwise the 'track' value in the query params will be used.
	// (you can get those from query params into your game by pasting
	// them in front of your URL during development tests;
	// check the manual for more information)
	//
	// In this example we use the 'trackId' defined above for a custom track Id.
	// Fill the value above and uncomment the line below.
	// _options.trackId = trackId;

	// We can now get the signed user scores for the current challenge
	gxc_challenge_get_user_scores(function(_status, _result) {
		
		// _status: is the http response status code.
		// _result: is the struct representation of the body.
		// Consulte the manual for more details.
		show_message(_result);
	}, _options);
}