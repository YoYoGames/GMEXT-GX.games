
// Lock file execution
function gxc_api_config() {}

// ##################### VERSION OPTIONS #####################

/// @notes This option will let you choose API domain to use.
///		You will want to query different domains depending whether 
///		your game is published or during testing.
///
///		[IMPORTANT] When building to publish you might want to set this to 'false'.

#macro GXC_USE_SANDBOX_ENVIRONMENT false


/// @notes This option will let you choose which API version should be used.
///		Don't change this unless you already have an old game that uses the old
///		API and you don't want to update to the new API.
///
///		[IMPORTANT] Legacy APIs are deprecated and may eventually stop working.

#macro GXC_SUBMIT_SCORE_V2 true // set to true to use latest version
