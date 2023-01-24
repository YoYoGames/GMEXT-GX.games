/// @description Execute callback

// Cache HTTP request id
var _requestId = async_load[? "id"];

// Check if there is a callback available
if (variable_struct_exists(requestHandlers, _requestId)) {
	
	var _requestHandler = requestHandlers[$ _requestId];
	
	var _asyncListener = _requestHandler.asyncListener;
	var _asyncCallback = _requestHandler.asyncCallback;
	
	// Execute the listener function which is resposible for processing
	// the pararameters and call the callback function.
	_asyncListener(async_load, _asyncCallback);
	
	// Remove callback from lookup.
	variable_struct_remove(requestHandlers, _requestId);
}

