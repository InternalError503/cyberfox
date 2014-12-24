var Cc = Components.classes;
var Ci = Components.interfaces;
var Cu = Components.utils;

cyberctrFeatures = {

	initialize_features: function() {
	
		console.log("Core Loaded");
 		
	},
	
get_localized_document: function(){

	window.location.assign("chrome://classic_theme_restorer/locale/CyberCTR_Documentation.pdf");
	
}


}
window.addEventListener("load", function () { cyberctrFeatures.initialize_features(); }, false);  