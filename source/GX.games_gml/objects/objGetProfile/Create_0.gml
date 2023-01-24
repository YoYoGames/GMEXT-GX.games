/// @description CODE IS HERE

// Inherit the parent event
event_inherited();

text = "Query Profile";

// Definition of onClick function that will be executed
// when the button is clicked.
onClick = function() {
	
	// We can now get the current profile information
	gxc_profile_get_info(function(_status, _result) {
		
		// _status: is the http response status code.
		// _result: is the struct representation of the body.
		// Consulte the manual for more details.
		show_message(_result);
	});
}