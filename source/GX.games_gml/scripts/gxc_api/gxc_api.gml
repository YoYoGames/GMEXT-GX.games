
// feather ignore GM2017

// Lock file execution
function gxc_api() {}

// ###################### API FUNCTIONS ######################

/// @function gxc_get_query_param(key)
/// @description Returns the parameter value corresponding to the given key.
/// @param {String} key The parameter string key
/// @returns {String} The string value of the parameter or undefined if not found.
/// @notes Parameters will only be available during remote playing or if passed
///		through the browser's URL manually. In order to understand how this works use
///		the provided guide link, mainly the section on "Testing Challenges Locally":
/// 
///		https://help.yoyogames.com/hc/en-us/articles/4408214631697
///
function gxc_get_query_param(_key) {
	
	// Cached parameters static variable.
	static cachedParams = undefined;

	// Auxiliar function to split key-value pairs.
	static keyValueSplit = function(_str, _ch) {
	
		var _idx = string_pos(_ch, _str);
  
		if (_idx = 0) return [_str, true];
	
		return [string_copy(_str, 1, _idx - 1), string_copy(_str, _idx + 1, string_length(_str) - 1)];
	}

	// If cached parameters is 'undefined' populate it.
	if (is_undefined(cachedParams)) {
		cachedParams = {};
		for (var i = 0; i < parameter_count(); ++i) {
			
			var _parameterStr = parameter_string(i);
			var _keyValuePair = keyValueSplit(_parameterStr, "=");
			
			cachedParams[$ _keyValuePair[0]] = _keyValuePair[1];
		}
	}
	
	return cachedParams[$ _key];
}

/// @function gxc_profile_get_info(callback)
/// @description Queries for the current player profile information.
/// @param {Function} callback The function to be called upon task completion.
/// @returns {Real} The http request unique identifier.
function gxc_profile_get_info(_callback = undefined) {

	// Validate input paramenters
	if (!is_undefined(_callback) && !is_method(_callback)) { show_message("[ERROR] gxc_profile_get_info, param 'callback' must be of type method."); return -1; }

	var _listener = _callback ? __gxc_callback_asyncListener : __gxc_event_asyncListener;
	
	// This is the profile URL
	var _domain = __gxc_get_domain();
	var _url = _domain + "/gg/profile";
	
	return __gxc_http_request(_url, "GET", _listener, _callback);
}

/// @function gxc_challenge_get_challenges(callback, options)
/// @description Get list current game's challenges.
/// @param {Function} callback The function to be called upon task completion.
/// @param {Struct} options This struct can contain pagination (page, pageSize) and track (trackId) values.
/// @returns {Real} The http request unique identifier.
function gxc_challenge_get_challenges(_callback = undefined, _options = undefined) {
	
	static _defaultOptions = {
		trackId: gxc_get_query_param("track"),
		pageSize: undefined,
		page: undefined,
	}
	
	// Validate input paramenters
	if (!is_undefined(_callback) && !is_method(_callback)) {
		show_message("[ERROR] gxc_challenge_get_challenges, param 'callback' must be of type method.");
		return -1;
	}
	
	// Check if callback should be user instead of event
	var _listener = !is_undefined(_callback) ? __gxc_callback_asyncListener : __gxc_event_asyncListener;

	// Build options struct from defaults
	_options = __gxc_struct_from_default(_defaultOptions, _options);

	// Get required query parameters
	var _game = gxc_get_query_param("game");
	var _track = _options.trackId;
	
	// Make sure the required query params are all available
	if (is_undefined(_game)) { show_message("[ERROR] gxc_challenge_get_challenges, required query params 'game' not found."); return -1; }
	if (is_undefined(_track)) { show_message("[ERROR] gxc_challenge_get_challenges, required query params 'track' not found (use 'options.trackId' to provide one)."); return -1; }

	// This is the query URL
	var _domain = __gxc_get_domain();
	var _url = _domain + "/gg/games/" + _game + "/challenges";
	_url += __gxc_struct_to_params(_options, ["page", "pageSize", "trackId"]);

	return __gxc_http_request(_url, "GET", _listener, _callback);
}

/// @function gxc_challenge_submit_score(score, callback, options)
/// @description Submits a new challenge score.
/// @param {Real} score The new score to be submitted.
/// @param {Function} callback The function to be called upon task completion.
/// @param {Struct} options This struct can contain the challenge (challengeId) to submit to.
/// @returns {Real} The http request unique identifier.
function gxc_challenge_submit_score(_score, _callback = undefined, _options = undefined) {

	static _defaultOptions = {
		challengeId: gxc_get_query_param("challenge"),
		trackId: gxc_get_query_param("track")
	}

	// Validate input paramenters
	if (!is_undefined(_callback) && !is_method(_callback)) { show_message("[ERROR] gxc_challenge_submit_score, param 'callback' must be of type method."); return -1; }
	
	// Check if callback should be user instead of event
	var _listener = !is_undefined(_callback) ? __gxc_callback_asyncListener : __gxc_event_asyncListener;

	// Make sure to only send integer scores.
	_score = round(_score);
	
	// Build options struct from defaults
	_options = __gxc_struct_from_default(_defaultOptions, _options);
	
	// Get required query parameters.
	var _game =  gxc_get_query_param("game");
	var _challenge = _options.challengeId;
	var _track = _options._trackId;
	
	// Make sure the required query params are all available
	if (is_undefined(_game)) { show_message("[ERROR] gxc_challenge_submit_score, required query params 'game' not found."); return -1; }
	if (is_undefined(_track)) { show_message("[ERROR] gxc_challenge_submit_score, required query params 'track' not found (use 'options.trackId' to provide one)."); return -1; }
	if (is_undefined(_challenge)) { show_message("[ERROR] gxc_challenge_submit_score, required query params 'challenge' not found (use 'options.challengeId' to provide one)."); return -1 }

	// Create SHA1 hash 
	var _hash = sha1_string_utf8(_game + _challenge + _track + string(_score));

	// Check API version configuration (v2 vs legacy)
	var _domain = __gxc_get_domain();
	var _base = _domain + (GXC_SUBMIT_SCORE_V2 ? "/gg/v2" : "/gg");

	// This is the challenge URL
	var _url = _base + "/games/" + _game + "/challenges/" + _challenge + "/scores";
	
	// This is the data we want to POST
	var _data = { releaseTrackId: _track, score: _score, hash: _hash };

	return __gxc_http_request(_url, "POST", _listener, _callback, json_stringify(_data));
}

/// @function gxc_challenge_get_global_scores(callback, options)
/// @description Get current challenge top scores.
/// @param {Function} callback The function to be called upon task completion.
/// @param {Struct} options This struct can contain pagination (page, pageSize), track (trackId) and challenge (challengeId) values.
/// @returns {Real} The http request unique identifier.
function gxc_challenge_get_global_scores(_callback = undefined, _options = undefined) {
	
	static _defaultOptions = {
		trackId: gxc_get_query_param("track"),
		challengeId: gxc_get_query_param("challenge"),
		pageSize: undefined,
		page: undefined,
	}
	
	// Validate input paramenters
	if (!is_undefined(_callback) && !is_method(_callback)) { show_message("[ERROR] gxc_challenge_get_global_scores, param 'callback' must be of type method."); return -1; }
	
	// Check if callback should be user instead of event
	var _listener = !is_undefined(_callback) ? __gxc_callback_asyncListener : __gxc_event_asyncListener;

	// Build options struct from defaults
	_options = __gxc_struct_from_default(_defaultOptions, _options);

	// Get required query parameters.
	var _game = gxc_get_query_param("game");
	var _track = _options.trackId;
	var _challenge = _options.challengeId;
	
	// Make sure the required query params are all available
	if (is_undefined(_game)) { show_message("[ERROR] gxc_challenge_get_global_scores, required query params 'game' not found."); return -1; }
	if (is_undefined(_track)) { show_message("[ERROR] gxc_challenge_get_global_scores, required query params 'track' not found (use 'options.trackId' to provide one)."); return -1; }
	if (is_undefined(_challenge)) { show_message("[ERROR] gxc_challenge_get_global_scores, required query params 'challenge' not found (use 'options.challengeId' to provide one)."); return -1 }

	// This is the query URL
	var _domain = __gxc_get_domain();
	var _url = _domain + "/gg/games/" + _game + "/challenges/" + _challenge + "/scores";
	_url += __gxc_struct_to_params(_options, ["page", "pageSize", "trackId"]);

	return __gxc_http_request(_url, "GET", _listener, _callback);
}

/// @function gxc_challenge_get_user_scores(callback, options)
/// @description Get signed in user's challenge scores
/// @param {Function} callback The function to be called upon task completion.
/// @param {Struct} options This struct can contain pagination (page, pageSize), track (trackId) and challenge (challengeId) values.
/// @returns {Real} The http request unique identifier.
function gxc_challenge_get_user_scores(_callback = undefined, _options = undefined) {
	
	static _defaultOptions = {
		trackId: gxc_get_query_param("track"),
		challengeId: gxc_get_query_param("challenge"),
		pageSize: undefined,
		page: undefined,
	}
	
	// Validate input paramenters
	if (!is_undefined(_callback) && !is_method(_callback)) { show_message("[ERROR] gxc_challenge_get_user_scores, param 'callback' must be of type method."); return -1; }
	
	// Check if callback should be user instead of event
	var _listener = !is_undefined(_callback) ? __gxc_callback_asyncListener : __gxc_event_asyncListener;

	// Build options struct from defaults
	_options = __gxc_struct_from_default(_defaultOptions, _options);

	// Get required query parameters.
	var _game =  gxc_get_query_param("game");
	var _track = _options.trackId;
	var _challenge = _options.challengeId;
	
	// Make sure the required query params are all available
	if (is_undefined(_game)) { show_message("[ERROR] gxc_challenge_get_user_scores, required query params 'game' not found."); return -1; }
	if (is_undefined(_track)) { show_message("[ERROR] gxc_challenge_get_user_scores, required query params 'track' not found (use 'options.trackId' to provide one)."); return -1; }
	if (is_undefined(_challenge)) { show_message("[ERROR] gxc_challenge_get_user_scores, required query params 'challenge' not found (use 'options.challengeId' to provide one)."); return -1 }

	// This is the query URL
	var _domain = __gxc_get_domain();
	var _url = _domain + "/gg/games/" + _game + "/challenges/" + _challenge + "/user-scores";
	_url += __gxc_struct_to_params(_options, ["page", "pageSize", "trackId"]);
	
	return __gxc_http_request(_url, "GET", _listener, _callback);
}

/// @function gxc_payment_get_status(callback, options)
/// @description Queries details on whether the user bought the full version of the game
/// @param {Function} callback The function to be called upon task completion.
/// @param {Struct} options This struct can contain game (gameId, trackId) information.
/// @returns {Real} The http request unique identifier.
/// @notes By default this function checks the payment status of the current game
///		however this behavior can be changed by providing a different gameId in the
///		options struct.
///
function gxc_payment_get_status(_callback = undefined, _options = undefined) {
	
	static _defaultOptions = {
		gameId: gxc_get_query_param("game"),
		trackId: gxc_get_query_param("track"),
	}
	
	// Validate input paramenters
	if (!is_undefined(_callback) && !is_method(_callback)) { show_message("[ERROR] gxc_payment_get_status, param 'callback' must be of type method."); return -1; }
	
	// Check if callback should be user instead of event
	var _listener = !is_undefined(_callback) ? __gxc_callback_asyncListener : __gxc_event_asyncListener;

	// Build options struct from defaults
	_options = __gxc_struct_from_default(_defaultOptions, _options);

	// Get required query parameters
	var _game = _options.gameId;
	
	// Make sure the required query params are all available
	if (is_undefined(_game)) { show_message("[ERROR] gxc_payment_get_status, required query params 'game' not found (use 'options.gameId' to provide one)."); return -1 }

	// This is the query URL
	var _domain = __gxc_get_domain();
	var _url = _domain + "/gg/games/" + _game + "/full-version";
	_url += __gxc_struct_to_params(_options, ["trackId"]);

	return __gxc_http_request(_url, "GET", _listener, _callback);
}

// ######################## CONSTANTS ########################

// HTTP Status: 400
#macro gxc_error_challenge_not_active "challenge_not_active"
#macro gxc_error_challenge_not_published "challenge_not_published"
#macro gxc_error_invalid_hash "invalid_hash"
#macro gxc_error_negative_score "negative_score"

#macro gxc_error_page_invalid "page_invalid"
#macro gxc_error_page_less_than_0 "page_less_than_0"
#macro gxc_error_page_size_invalid "page_size_invalid"
#macro gxc_error_page_size_less_than_1 "page_size_less_than_1"
#macro gxc_error_page_size_too_high "page_size_too_high"

#macro gxc_error_game_full_version_already_bought	"game_full_version_already_bought"
#macro gxc_error_game_full_version_disabled "game_full_version_disabled"	
#macro gxc_error_game_full_version_not_allowed "game_full_version_not_allowed"

#macro gxc_error_game_paid_not_allowed "game_paid_not_allowed"

#macro gxc_error_payments_disabled "payments_disabled"

// HTTP Status: 403
#macro gxc_error_sign_in_required "sign_in_required"

// HTTP Status: 404
#macro gxc_error_challenge_not_found "challenge_not_found"
#macro gxc_error_game_not_found "game_not_found"
#macro gxc_error_tack_not_found "tack_not_found"


// ################### DEPRECATED METHODS ####################

/// @function gxc_get_profile(callback)
/// @description Queries for the current player profile information.
/// @param {Function} callback The function to be called upon task completion.
/// @returns {Real} The http request unique identifier.
/// @notes This method is being DEPRECATED (avoid using it)
function gxc_get_profile(_callback = undefined) {
	show_debug_message("[WARNING] gxc_get_profile, function is deprecated and will be removed in the future; use 'gxc_profile_get_info' instead.");
	gxc_profile_get_info(_callback);
}

/// @function gxc_submit_challenge_score(score, callback)
/// @description Submits a new challenge score.
/// @param {Real} score The new score to be submitted.
/// @param {Function} callback The function to be called upon task completion.
/// @returns {Real} The http request unique identifier.
/// @notes This method is being DEPRECATED (avoid using it)
function gxc_submit_challenge_score(_score, _callback = undefined) {
	show_debug_message("[WARNING] gxc_submit_challenge_score, function is deprecated and will be removed in the future; use 'gxc_challenge_submit_score' instead.");
	gxc_challenge_submit_score(_score, _callback);
}

// ##################### PRIVATE METHODS #####################

function __gxc_get_domain() {
	
	static domain = GXC_USE_SANDBOX_ENVIRONMENT ? "https://api.sandbox.gx.games" : "https://api.gx.games";
	return domain;
}

function __gxc_struct_to_params(_struct, _names) {
	
	var _params = "?";
	var _count = array_length(_names);
	repeat(_count) {
		var _name = _names[--_count];
		var _value = _struct[$ _name];
		
		// we need to check for both undefined or null (TODO this is a bug)
		if (is_undefined(_value)) continue;
		
		_params += _name + "=" + string(_value) + "&";
	}
	return _params;
}

function __gxc_struct_from_default(_default, _input = {}) {

	// Create copy of input struct
	var _output = {};

	// Go through all properties in the 'default' struct.
	var _names = variable_struct_get_names(_default);
	var _count = array_length(_names);
	repeat(_count) {
		var _name = _names[--_count];
		
		var _inputValue = _input[$ _name];
		
		if (is_undefined(_inputValue) || _inputValue == pointer_null) {
			_output[$ _name] = _default[$ _name];
		}
		else _output[$ _name] = _inputValue;
	}
	return _output;
}

function __gxc_http_request(_url, _method, _listener, _callback, _body = "") {
	
	// Create the header information
	var _header = ds_map_create();
	_header[? "Content-Type"] = "application/json";
	_header[? "Access-Control-Allow-Credentials"] = "true";
	
	// Make the request
	var _requestId = http_request(_url, _method, _header, _body);
	
	// Destroy the header map
	ds_map_destroy(_header);

	// Register the HTTP request for further process.
	return HttpManager.register(_requestId, _listener, _callback);
}

// ##################### ASYNC LISTENERS #####################

// This is the default listener for all the async calls that use callbacks.
// The information is delivered in a struct conatining all the information.
function __gxc_callback_asyncListener(_payload, _callback) {
	
	// Check if the result is not empty before trying to parse it
	var _result = _payload[? "result"];
	if (_result != "") {
		_result = json_parse(_result);
	}
	else _result = {};
	
	var _httpStatus = _payload[? "http_status"];	
	_result.success = _httpStatus == 200;
		
	_callback(_httpStatus, _result);
}

// This is the default listener for all the async calls that use events.
// The information is delivered in the async_load map.
function __gxc_event_asyncListener(_payload) {
	
	static structToMap = function(_struct, _map) {
	
		var _names = variable_struct_get_names(_struct);
		var _count = array_length(_names);
		repeat(_count) {
			var _name = _names[--_count];
			_map[? _name] = _struct[$ _name];
		}
		return _map;
	}
	
	var _asyncMap = ds_map_create();

	_asyncMap[? "id"] = _payload[? "id"];

	var _httpStatus = _payload[? "http_status"];
	_asyncMap[? "httpStatus"] = _httpStatus;
	_asyncMap[? "success"] = _httpStatus == 200;
	
	// Check if the result is not empty before trying to parse it
	var _result = _payload[? "result"];
	if (_result != "") {
		_result = json_parse(_result);
		if (is_struct(_result)) {
			structToMap(_result, _asyncMap);
		}
	}
	
	event_perform_async(ev_async_social, _asyncMap);
}

