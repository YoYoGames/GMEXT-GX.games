/// @description CODE IS HERE

// Inherit the parent event
event_inherited();

// This property values are overwritten in the
// [instance creation code] window in the room editor.
text = "Get 'paramKey'";
paramKey = "paramKey";

// Definition of onClick function that will be executed
// when the button is clicked.
onClick = function() {
	
	// With this function we can query the paraeters passed into the runner.
	// @notes: parameters will only be available during remote playing or if passed
	// through the browser's URL manually. In order to understand how this works use
	// the provided guide link, mainly the section on "Testing Challenges Locally":
	// 
	// https://help.yoyogames.com/hc/en-us/articles/4408214631697
	//
	var _paramValue = gxc_get_query_param(paramKey);
	show_message("The '" + paramKey + "' value is: " + string(_paramValue));
}
