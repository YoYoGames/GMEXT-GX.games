/// @description Initialize variables

#region Singleton

if (instance_number(object_index) > 1) {
    var first = instance_find(object_index, 0);
    if (id != first) { instance_destroy(); exit; }
}

#endregion

#region Properties

requestHandlers = {};

#endregion

#region Functions

/// @function register(requestId, asyncListener, asyncCallback)
register = function(_requestId, _asyncListener, _asyncCallback) {
	
	// Make a container struct
	var _requestHandler = { asyncCallback: _asyncCallback, asyncListener: _asyncListener };
	
	// Add request handler to requests lookup
	requestHandlers[$ _requestId] = _requestHandler;
	
	return _requestId;
}

/// @function unregister(requestId)
unregister = function(_requestId) {
	variable_struct_remove(requestHandlers, _requestId);
} 

#endregion
