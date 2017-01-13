(function(global) {
	
var Cc = Components.classes, Cu = Components.utils;
var {Services} = Cu.import("resource://gre/modules/Services.jsm", {});

if (typeof cyberctrFeatures == "undefined") {
    var cyberctrFeatures = {};
};
if (!cyberctrFeatures) {
    cyberctrFeatures = {};
};

cyberctrFeatures = {
			getMessage: Services.strings.createBundle("chrome://classic_theme_restorer/locale/features.file"),
    initialize_features: function() {

        if (!Services.prefs.getBoolPref("extensions.classicthemerestorer.features.firstrun")) {
            document.getElementById("first_run_message").hidden = false;
            Services.prefs.setBoolPref("extensions.classicthemerestorer.features.firstrun", true);
        }
		if (Services.appinfo.name.toLowerCase() === "Cyberfox".toLowerCase()) {
			this.updateCheck(false);
		}
        // Hide update check if firefox\other.
		if (Services.appinfo.name.toLowerCase() != "Cyberfox".toLowerCase()) {
			document.getElementById("up-check").hidden = true;
		}

		try {		
            // Localize UI elements.
            document.getElementById("btn-check-update").textContent =cyberctrFeatures.i18n("btn-check-update");
            document.getElementById("btn-Documentation").textContent =cyberctrFeatures.i18n("btn-Documentation");
            document.getElementById("btn-faq").textContent =cyberctrFeatures.i18n("btn-faq");
            document.getElementById("btn-support-forums").textContent =cyberctrFeatures.i18n("btn-support-forums");
            document.getElementById("btn-contact-us").textContent =cyberctrFeatures.i18n("btn-contact-us");
            // Updates
            document.getElementById("msg-firstrun-welcome").textContent =cyberctrFeatures.i18n("msg-firstrun-welcome");
            document.getElementById("msg-new-version-blob-a").textContent = cyberctrFeatures.i18n("msg-new-version-blob-a");
            document.getElementById("msg-new-version-blob-b").textContent = cyberctrFeatures.i18n("msg-new-version-blob-b");
            document.getElementById("url-new-notes").setAttribute('href', 'https://github.com/InternalError503/CyberCTR/releases/tag/' + Services.prefs.getCharPref("extensions.classicthemerestorer.version"));
            document.getElementById("msg-no-new-version").textContent =cyberctrFeatures.i18n("msg-no-new-version");
		} catch (e) {
			throw new Error("Error unable to setup event listeners!");
		}
    },
	
    // CyberCTR update check.
	updateCheck: function (manual) {
		
		 try {
            // If firefox or other then return and don't check for updates.
			if (Services.appinfo.name.toLowerCase() != "Cyberfox".toLowerCase()) {return;}
		 
            // Set Global to disable update checks entirely 
            if (Services.prefs.getBoolPref("extensions.classicthemerestorer.features.updatecheck")) {
				// Only allow check once per day as update is not a priority.
				var curTime = new Date()
				if (manual === true && document.getElementById("first_run_message").getAttribute("hidden") === "true"){ 
					Services.prefs.clearUserPref("extensions.classicthemerestorer.features.lastcheck");
				}
				if 	(Services.prefs.getCharPref("extensions.classicthemerestorer.features.lastcheck") != curTime.getDate()) {
					Services.prefs.setCharPref("extensions.classicthemerestorer.features.lastcheck", curTime.getDate())
					
                // Get Latest CyberCTR Version
                var url = Services.prefs.getCharPref("app.update.check.url");
                var request = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"]
                    .createInstance(Components.interfaces.nsIXMLHttpRequest);

                request.onload = function(aEvent) {

                    var text = aEvent.target.responseText;

                    // Need to check if json is valid, If json not valid don't continue and show error.
                    function IsJsonValid(text) {
                        try {
                            JSON.parse(text);
                        } catch (e) {
                            return false;
                        }
                        return true;
                    }

                    var _jsObject = "";

                    if (!IsJsonValid(text)) {
                        // Hide update notification 
                        document.getElementById("update_message").hidden = true;
                        // Throw error message	
                        console.log("Were sorry but something has gone wrong while trying to parse update.json (json is not valid!)");
                        // Return error
                        return;
                    } else {
                        _jsObject = JSON.parse(text);
                    }

                    if (_jsObject.cyberctr.toString() > Services.prefs.getCharPref("extensions.classicthemerestorer.version")) {
                        document.getElementById("update_message").hidden = false;
                    } else {
                        document.getElementById("update_message").hidden = true;
						document.getElementById("update_message_nou").hidden = false;
                    }

                };

                request.ontimeout = function(aEvent) {
                    // Log return failed check message for request time-out!
                    document.getElementById("update_message").hidden = true;
                    throw new Error("Request timed out");
                };

                request.onerror = function(aEvent) {

                    // Marked to add better error handling and messages.
                    switch (aEvent.target.status) {

                        case 0:
                            // Log return failed request message for status 0 unsent
                            throw new Error("Request failed " + aEvent.target.status);
                        case 1:
                            throw new Error("Error Status: " + aEvent.target.status);
                        case 2:
                            throw new Error("Error Status: " + aEvent.target.status);
                        case 3:
                            throw new Error("Error Status: " + aEvent.target.status);
                        case 4:
                            throw new Error("Error Status: " + aEvent.target.status);
                    }
                    // Hide message		  
                    document.getElementById("update_message").hidden = true;
                };

                // Only send async requests
                request.timeout = 10000;
                request.open("GET", url + ((/\?/).test(url) ? "&" : "?") + (new Date()).getTime(), true);
                request.setRequestHeader("Content-Type", "application/json");
                request.send(null);
				}
            }

        } catch (e) {
            throw new Error("Update Check: " + e);
        }
	},	
	
	// Localize single ID with string value.
	i18n: function(message_id){
		try {
            if (!document.getElementById(message_id)){
                return;
            }		
            return this.getMessage.GetStringFromName(message_id);
		} catch (e) {
			throw new Error("Error getting localized text!");
		}
	}

}

// Window load initialize features.
window.addEventListener("load", function() {
	window.removeEventListener("load", cyberctrFeatures.initialize_features(), false);
    cyberctrFeatures.initialize_features();
}, false);

  // Make cyberctrFeatures a global variable
  global.cyberctrFeatures = cyberctrFeatures;
}(this));