# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Services = object with smart getters for common XPCOM services
const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;
Cu.import("resource://gre/modules/Services.jsm");

//Setup Localised Messages.
var _locMSG = Services.strings.createBundle("chrome://browser/locale/aboutDialog.properties");

const PREF_EM_HOTFIX_ID = "extensions.hotfix.id";

function init(aEvent) {
        if (aEvent.target != document)
            return;

        try {
            var distroId = Services.prefs.getCharPref("distribution.id");
            if (distroId) {
                var distroVersion = Services.prefs.getCharPref("distribution.version");

                var distroIdField = document.getElementById("distributionId");
                distroIdField.value = distroId + " - " + distroVersion;
                distroIdField.style.display = "block";

                try {
                    // This is in its own try catch due to bug 895473 and bug 900925.
                    var distroAbout = Services.prefs.getComplexValue("distribution.about",
                        Ci.nsISupportsString);
                    var distroField = document.getElementById("distribution");
                    distroField.value = distroAbout;
                    distroField.style.display = "block";
                } catch (ex) {
                    // Pref is unset
                    Cu.reportError(ex);
                }
            }
        } catch (e) {
            // Pref is unset
        }

        // Include the build ID and display warning if this is an "a#" (nightly or aurora) build
        var version = Services.appinfo.version;
        if (/a\d+$/.test(version)) {
            var buildID = Services.appinfo.appBuildID;
            var buildDate = buildID.slice(0, 4) + "-" + buildID.slice(4, 6) + "-" + buildID.slice(6, 8);
            document.getElementById("version").textContent += " (" + buildDate + ")";
            document.getElementById("communityDesc").hidden = true;
        }

        function ElementState(element, state) {

            if (!typeof true || !typeof false) {
                return;
            }
            document.getElementById(element).hidden = state;

        }

        ElementState("update-button-checkNow", true);
        ElementState("update-button-checking", false);
        ElementState("update-button-checking-throbber", false);
        ElementState("update-button-no-update", true);
        ElementState("update-button-download", true);

        //Clear any previous set urls
        Services.prefs.clearUserPref("app.update.url.manual");

        //If its disabled we don't want to see any buttons here.	
        if (!Services.prefs.getBoolPref("app.update.check.enabled")) {
            //hide buttons :P	  
            ElementState("updateBox", true);
        }
        if (Services.prefs.getCharPref("app.update.channel.type") === "beta") {
            document.getElementById("version").textContent += " beta";
        }


        if (Services.prefs.getBoolPref("app.update.autocheck")) {

            //Set manual update url from -firefox-branding.js so update in one location is uniform across all references.
            try {
                var manualCheck = document.getElementById("checkForUpdatesButton");
                manualCheck.setAttribute('href', Services.prefs.getCharPref("app.update.url.manual"));
            } catch (ex) {
                // Pref is unset
                Cu.reportError(ex);
            }

            //feature prototype

            try {

                //Set Global to disable update checks entirely 
                if (Services.prefs.getBoolPref("app.update.check.enabled")) {
			
			//Delay about cyberfox update check two & half seconds to allow time for the check to complete on slower connections
			window.setTimeout(function(){
				
                    //Get Latest Browser Version
                    //Unfortunately same origin policy's prevent us using HTTPS here.
                    var url = Services.prefs.getCharPref("app.update.check.url");
                    var request = new XMLHttpRequest();

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


                        var jsObject;
                        var currentVersion;

                        if (!IsJsonValid(text)) {
                            //hide buttons		  
                            ElementState("update-button-checkNow", false);
                            ElementState("update-button-checking-throbber", true);
                            ElementState("update-button-checking", true);
                            ElementState("update-button-no-update", true);
                            ElementState("update-button-download", true);
                            //Throw error message	
                            console.log("Were sorry but something has gone wrong while trying to parse update.json (json is not valid!)");
                            //Return error
                            return;
                        } else {
                            jsObject = JSON.parse(text);
                        }

                        switch (Services.prefs.getCharPref("app.update.channel.type")) {
                            case "release": currentVersion = jsObject.release; break;
                            case "beta":currentVersion = jsObject.beta;break;
                            case "esr":currentVersion = jsObject.esr;break;
                        }
						
                        var manualCheck = document.getElementById("checkForUpdatesButton");

                        switch (versions.compareVersions(Services.appinfo.version, currentVersion.toString())) {

                            case false:
                                ElementState("update-button-checking-throbber", true);
                                ElementState("update-button-checking", true);
                                ElementState("update-button-download", false);
                                break;


                            case true:
                                ElementState("update-button-checking-throbber", true);
                                ElementState("update-button-checking", true);
                                Services.prefs.setCharPref("app.update.url.manual", "https://cyberfox.8pecxstudios.com/hooray-your-cyberfox-is-up-to-date?version=" + Services.appinfo.version);
                                ElementState("update-button-no-update", false);
                                //set the browsers core version in-case "app.update.url.manual" is not changed from a browser update or switched versions.
                                manualCheck.setAttribute('href', Services.prefs.getCharPref("app.update.url.manual"));
                                break;



                        }


                    };


                    request.ontimeout = function(aEvent) {

                        //Log return failed check message for request time-out!
                        console.log(_locMSG.GetStringFromName("updateCheckErrorTitle") + " " + _locMSG.GetStringFromName("updateCheckError"));
                        ElementState("update-button-checkNow", true);
                        ElementState("update-button-checking-throbber", true);
                        ElementState("update-button-checking", true);
                        ElementState("update-button-no-update", true);
                        ElementState("update-button-download", false);
                    };

                    request.onerror = function(aEvent) {

                        //Marked to add better error handling and messages.
                        switch (aEvent.target.status) {
                            case 0:
                                //Log return failed request message for status 0 unsent
                                console.log(_locMSG.GetStringFromName("updateCheckErrorTitle") + " " + _locMSG.GetStringFromName("updateRequestError"));break;
                            case 1: console.log("Error Status: " + aEvent.target.status);break;
                            case 2:console.log("Error Status: " + aEvent.target.status);break;
                            case 3:console.log("Error Status: " + aEvent.target.status);break;
                            case 4:console.log("Error Status: " + aEvent.target.status);break;
                            default:console.log("Error Status: " + aEvent.target.status);break;
                        }
                        //hide buttons		  
                        ElementState("update-button-checkNow", true);
                        ElementState("update-button-checking-throbber", true);
                        ElementState("update-button-checking", true);
                        ElementState("update-button-no-update", true);
                        ElementState("update-button-download", true);
                    };

                    //Only send async POST requests, Must declare the request header forcing the request to only be for content type json.
                    request.timeout = 5000;
                    request.open("GET", url, true);
                    request.setRequestHeader("Content-Type", "application/json");
                    request.send(null);

            }, 2500);
				}

            } catch (eve) {
                //Show error
                Cu.reportError(eve);
            }

        } else {

            //Clear any previous set urls
            Services.prefs.clearUserPref("app.update.url.manual");

            //Set manual update url from -firefox-branding.js so update in one location is uniform across all references.
            try {
                var manualCheck = document.getElementById("checkForUpdatesButton");
                manualCheck.setAttribute('href', Services.prefs.getCharPref("app.update.url.manual"));
            } catch (ex) {
                // Pref is unset
                Cu.reportError(ex);
            }
            //hide buttons		  
            ElementState("update-button-checkNow", false);
            ElementState("update-button-checking-throbber", true);
            ElementState("update-button-checking", true);
            ElementState("update-button-no-update", true);
            ElementState("update-button-download", true);

        }

    }
    //Versions.compareVersions where the numeric comparison happens.
    //Takes 2 variables installed version number as string & required version number as string, The required version comes from update.json
    //Update.json will in future have versions support for esr, beta & alpha builds.
    //We will continue using our method over https://developer.mozilla.org/en/docs/Using_nsIXULAppInfo#Version as its working effectively for version.minor version.major revision.
var versions = {
    compareVersions: function(_Installed, _Required) {

        try {
            var _Installed_Version = _Installed.split('.');
            var _Required_Version = _Required.split('.');

            for (var i = 0; i < _Installed_Version.length; ++i) {
                _Installed_Version[i] = Number(_Installed_Version[i]);
            }
            for (var i = 0; i < _Required_Version.length; ++i) {
                _Required_Version[i] = Number(_Required_Version[i]);
            }
            if (_Installed_Version.length == 2) {
                _Installed_Version[2] = 0;
            }

            if (_Installed_Version[0] > _Required_Version[0]) return true;
            if (_Installed_Version[0] < _Required_Version[0]) return false;

            if (_Installed_Version[1] > _Required_Version[1]) return true;
            if (_Installed_Version[1] < _Required_Version[1]) return false;

            if (_Installed_Version[2] > _Required_Version[2]) return true;
            if (_Installed_Version[2] < _Required_Version[2]) return false;

            return true;

        } catch (rv) {
            //Show error
            Cu.reportError(rv);
        }
    }
}