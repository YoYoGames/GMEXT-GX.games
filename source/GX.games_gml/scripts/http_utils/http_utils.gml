
// Lock file execution
function http_utils() {};

#region Macros

// Define a macro for getting HttpManager singleton
#macro HttpManager HttpManagerInstance()

#endregion

#region Singleton

// Get the singleton instance of the HttpManager
function HttpManagerInstance() {
	with (objHttpManager) return id;
	return instance_create_depth(0,0,0, objHttpManager);
}

#endregion

