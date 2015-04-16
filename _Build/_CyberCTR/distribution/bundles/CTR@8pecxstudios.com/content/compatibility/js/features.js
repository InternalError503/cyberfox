//Import services use one service for preferences.
Components.utils.import("resource://gre/modules/Services.jsm");

if (typeof cyberctrFeatures == "undefined") {var cyberctrFeatures  = {};};
if (!cyberctrFeatures) {cyberctrFeatures  = {};};

cyberctrFeatures = {

	initialize_features: function() {
	
		if (!Services.prefs.getBoolPref("extensions.classicthemerestorer.features.firstrun")){
			document.getElementById("first_run_message").hidden = false;
			Services.prefs.setBoolPref("extensions.classicthemerestorer.features.firstrun", true);
 		}
	},
	
get_localized_document: function(){

	window.location.assign("chrome://classic_theme_restorer/content/compatibility/documentation/CyberCTR_Documentation.pdf");
	
}


}
window.addEventListener("load", function () { cyberctrFeatures.initialize_features(); }, false);  