/// @description CODE IS HERE

// Inherit the parent event
event_inherited();

var _game = gxc_get_query_param("game");
var _track = gxc_get_query_param("track");

locked = is_undefined(_game) || is_undefined(_track);

text = "Get Challenges";

// Definition of onClick function that will be executed
// when the button is clicked.
onClick = function() {
	
	// We can now get the signed user scores for the current challenge
	gxc_challenge_get_challenges(function(_status, _result) {
		
		// _status: is the http response status code.
		// _result: is the struct representation of the body.
		// Consulte the manual for more details.
		show_message(_result);
	});
}