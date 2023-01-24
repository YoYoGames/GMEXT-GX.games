/// @description Process the input

// Early exit if requestID doesn't match.
if (async_load[? "id"] != requestID) exit;

// Early exit if 'Cancel' was pressed.
if (async_load[? "status"] != true) exit;

// Round the value (NOTE: the value needs to be an integer, otherwise it will be converted)
var _value = round(async_load[? "value"]);


// We can now submit the new score to the current active challenge
// On a development environment you will need to:
// 1. Publish the game 
// 2. Make it private (to generate a playing link)
// 3. Create a new challenge
// 4. Copy the parameters from the website
// 5. Append them to the runner URL after "http://localhost:51264/runner.html"
gxc_challenge_submit_score(_value, function(_status, _result) {
	
	// _status: is the http response status code.
	// _result: is the struct representation of the body.
	// Consulte the manual for more details.
	show_message(_result);
});
