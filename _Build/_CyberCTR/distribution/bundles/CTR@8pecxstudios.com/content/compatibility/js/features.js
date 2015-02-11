var Cc = Components.classes;
var Ci = Components.interfaces;
var Cu = Components.utils;
var Prefs = Cc["@mozilla.org/preferences-service;1"].getService(Ci.nsIPrefService).getBranch("extensions.classicthemerestorer.");

cyberctrFeatures = {

	initialize_features: function() {
	
		if (!Prefs.getBoolPref("features.firstrun")){
			document.getElementById("first_run_message").hidden = false;
			Prefs.setBoolPref("features.firstrun", true);
 		}
		
	},
	
get_localized_document: function(){

	window.location.assign("chrome://classic_theme_restorer/content/compatibility/documentation/CyberCTR_Documentation.pdf");
	
}


}
window.addEventListener("load", function () { cyberctrFeatures.initialize_features(); }, false);  