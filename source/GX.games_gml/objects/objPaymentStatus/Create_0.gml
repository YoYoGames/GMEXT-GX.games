/// @description CODE IS HERE

// Inherit the parent event
event_inherited();

text = "Get Status";

// Definition of onClick function that will be executed
// when the button is clicked.
onClick = function() {
	
	// With this function we can query the payment status for the current game.
	gxc_payment_get_status(function(_status, _result) {
		
		// _status: is the http response status code.
		// _result: is the struct representation of the body.
		// Consult the manual for more details.
		show_message(_result);
	});
}
