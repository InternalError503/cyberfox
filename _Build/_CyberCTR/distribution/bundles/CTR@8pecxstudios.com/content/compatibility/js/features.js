//Import services use one service for preferences.
Components.utils.import("resource://gre/modules/Services.jsm");

if (typeof cyberctrFeatures == "undefined") {
    var cyberctrFeatures = {};
};
if (!cyberctrFeatures) {
    cyberctrFeatures = {};
};

cyberctrFeatures = {

    initialize_features: function() {

        if (!Services.prefs.getBoolPref("extensions.classicthemerestorer.features.firstrun")) {
            document.getElementById("first_run_message").hidden = false;
            Services.prefs.setBoolPref("extensions.classicthemerestorer.features.firstrun", true);
        }
		if (Services.appinfo.name.toLowerCase() === "Cyberfox".toLowerCase()) {
			this.updateCheck(false);
		}
		if (Services.appinfo.name.toLowerCase() === "Firefox".toLowerCase()) {
			document.getElementById("up-check").hidden = true;
			document.getElementById("up-check-oc").hidden = true;
		}	
    },
	
	updateCheck: function (manual) {
		
		 try {

			if (Services.appinfo.name.toLowerCase() === "Firefox".toLowerCase()) {return;}
		 
            //Set Global to disable update checks entirely 
            if (Services.prefs.getBoolPref("extensions.classicthemerestorer.features.updatecheck")) {
				//Only allow check once per day as update is not a priority.
				var curTime = new Date()
				if (manual === true && document.getElementById("first_run_message").getAttribute("hidden") === "true"){ 
					Services.prefs.clearUserPref("extensions.classicthemerestorer.features.lastcheck");
				}
				if 	(Services.prefs.getCharPref("extensions.classicthemerestorer.features.lastcheck") != curTime.getDate()) {
					Services.prefs.setCharPref("extensions.classicthemerestorer.features.lastcheck", curTime.getDate())
					
                //Get Latest CyberCTR Version
                var url = Services.prefs.getCharPref("app.update.check.url");
                var request = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"]
                    .createInstance(Components.interfaces.nsIXMLHttpRequest);

                request.onload = function(aEvent) {

                    var text = aEvent.target.responseText;

                    //Need to check if json is valid, If json not valid don't continue and show error.
                    function IsJsonValid(text) {
                        try {
                            JSON.parse(text);
                        } catch (e) {
                            return false;
                        }
                        return true;
                    }

                    var jsObject = "";

                    if (!IsJsonValid(text)) {
                        //hide update notification 
                        document.getElementById("update_message").hidden = true;
                        //Throw error message	
                        console.log("Were sorry but something has gone wrong while trying to parse update.json (json is not valid!)");
                        //Return error
                        return;
                    } else {
                        jsObject = JSON.parse(text);
                    }

                    if (jsObject.cyberctr.toString() > Services.prefs.getCharPref("extensions.classicthemerestorer.version")) {
                        document.getElementById("update_message").hidden = false;
                    } else {
                        document.getElementById("update_message").hidden = true;
						document.getElementById("update_message_nou").hidden = false;
                    }

                };

                request.ontimeout = function(aEvent) {

                    //Log return failed check message for request time-out!
                    console.log("Request timed out");
                    document.getElementById("update_message").hidden = true;
                };

                request.onerror = function(aEvent) {

                    //Marked to add better error handling and messages.
                    switch (aEvent.target.status) {

                        case 0:
                            //log return failed request message for status 0 unsent
                            console.log("Request failed " + this.target.status);
                            break;

                        case 1:
                            console.log("Error Status: " + this.target.status);
                            break;

                        case 2:
                            console.log("Error Status: " + this.target.status);
                            break;

                        case 3:
                            console.log("Error Status: " + this.target.status);
                            break;

                        case 4:
                            console.log("Error Status: " + this.target.status);
                            break;

                        default:
                            aEvent.target.status
                            console.log("Error Status: " + this.target.status);
                            break;

                    }
                    //hide message		  
                    document.getElementById("update_message").hidden = true;
                };

                //Only send async requests
                request.timeout = 5000;
                request.open("GET", url, true);
                request.setRequestHeader("Content-Type", "application/json");
                request.send(null);
				}
            }

        } catch (eve) {
            //Show error
            Components.utils.reportError(eve);
        }
	},	

    get_localized_document: function() {

        window.location.assign("chrome://classic_theme_restorer/content/compatibility/documentation/CyberCTR_Documentation.pdf");

    }

}
window.addEventListener("load", function() {
	window.removeEventListener("load", cyberctrFeatures.initialize_features(), false);
    cyberctrFeatures.initialize_features();
}, false);