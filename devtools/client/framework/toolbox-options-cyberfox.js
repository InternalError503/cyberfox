(function(global) {
	
const { classes: Cc, interfaces: Ci, utils: Cu } = Components;

var {Services} = Cu.import("resource://gre/modules/Services.jsm");
var {FileUtils} = Cu.import("resource://gre/modules/FileUtils.jsm");
var {NetUtil} = Cu.import("resource://gre/modules/NetUtil.jsm");

if (typeof gCustomAgentOptions == "undefined") {
    var gCustomAgentOptions = {};
};
if (!gCustomAgentOptions) {
    gCustomAgentOptions = {};
};

var gCustomAgentOptions = {

    init: function(e) {

        try {

            var jsonContent;
			// Get, Load and parse agents.json
            NetUtil.asyncFetch(NetUtil.newChannel(FileUtils.getFile("CurProcD", ["agents.json"]),
                            null, // aCharset
                            null, // aBaseURI
                            null, // aLoadingNode
                            Services.scriptSecurityManager.getSystemPrincipal(),
                            null, // aTriggeringPrincipal
                            Ci.nsILoadInfo.SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL,
							Ci.nsIContentPolicy.TYPE_OTHER), function(aInputStream, aResult) {

                if (!Components.isSuccessCode(aResult)) {
                    // Prevent panel activation if agents.json not found!
                    document.getElementById("custom-useragent-options").hidden = true;
                    console.log("Were sorry but something has gone wrong while trying to load agents.json (agents.json not found!) " + aResult);
                    return;
                }

                jsonContent = NetUtil.readInputStreamToString(aInputStream, aInputStream.available());

                var myJson;

                if (!gCustomAgentOptions.IsJsonValid(jsonContent)) {
                    // Need to throw error message and disable agentID if not valid json.
                    document.getElementById("devtools-agent-menu").disabled = true;
                    console.log("Were sorry but something has gone wrong while trying to parse agents.json (json is not valid!)");
                    return;
                } else {
                    myJson = JSON.parse(jsonContent);
                }

                var browserListArray = myJson.userAgents[0].browsers;
				var optionsListArrayVersion = myJson.userAgents[0].options[0].version;

				for (var i = 0;optionsListArrayVersion[i]; i++) {
						var optionsItemsList = document.getElementById("devtools-agent-version");
						var addNewVersionItem = document.createElement("option");
						addNewVersionItem.textContent = optionsListArrayVersion[i];
						addNewVersionItem.value = optionsListArrayVersion[i];
						optionsItemsList.appendChild(addNewVersionItem);
				}

                for (var i = 0; browserListArray[i]; i++) {

                    var menuItemsList = document.getElementById("devtools-agent-menu");
					var addNewBrowserItem = document.createElement("option");
					addNewBrowserItem.textContent = browserListArray[i].name;
					addNewBrowserItem.value = browserListArray[i].agent;
					menuItemsList.appendChild(addNewBrowserItem);
                }

            });
            // Only if known in list will it show only in current panel session, all other cases select user-agent item is set.
            document.getElementById("devtools-agent-menu").value = window.navigator.userAgent;

           document.getElementById("devtools-agent-options-other").value = "";
           document.getElementById("devtools-agent-options-other").value = window.navigator.userAgent;


        } catch (e) {
            // Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while trying to load agents.json " + e);
        }

    },
	
    IsJsonValid: function(json) {
        try {
            JSON.parse(json);
        } catch (e) {
            return false;
        }
        return true;
    },

    isEnabled: function(element) {
        document.getElementById(element).disabled = false;
    },

    isDisabled: function(element) {
        document.getElementById(element).disabled = true;
    },

    itemSelectedChanged: function() {
        try {
			
			let selectedBrowserItem = document.getElementById("devtools-agent-menu");
			var selectedBrowserItemIndex = selectedBrowserItem.selectedIndex;
			var selectedBrowserItemText = selectedBrowserItem.options[selectedBrowserItemIndex].text;
			
			if (selectedBrowserItem.value === "0") {
				return;
			}
			
            Services.prefs.setCharPref("general.useragent.override", selectedBrowserItem.value);
            document.getElementById("devtools-agent-options-other").value = selectedBrowserItem.value;
			
			if(selectedBrowserItemText  === "Cyberfox (Configurable)" || selectedBrowserItemText  === "Firefox (Configurable)"){
				document.getElementById("configurableAgent").hidden = false;
			}else{
				document.getElementById("configurableAgent").hidden = true;
			}
			
            this.showOtherUserAgent();
			
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong selected item changed event! " + e);
        }
    },
	
    configurableAgentChanged: function() {
        try {
			
			let selectedBrowserItem = document.getElementById("devtools-agent-menu");
			var selectedBrowserItemIndex = selectedBrowserItem.selectedIndex;
			var selectedBrowserItemText = selectedBrowserItem.options[selectedBrowserItemIndex].text;
			
			// All items must be set to continue
			if (document.getElementById("devtools-agent-os").value === "0" || 
				document.getElementById("devtools-agent-arch").value === "0" || 
				document.getElementById("devtools-agent-version").value === "0") {
					return;
			}
					
			switch (selectedBrowserItemText) {
				case "Cyberfox (Configurable)":				
					var newAgent = "Mozilla/5.0 (Windows NT "+document.getElementById("devtools-agent-os").value+"; "+document.getElementById("devtools-agent-arch").value+" rv:"+document.getElementById("devtools-agent-version").value+") Gecko/20100101 Firefox/"+document.getElementById("devtools-agent-version").value+" Cyberfox/"+document.getElementById("devtools-agent-version").value;
					Services.prefs.setCharPref("general.useragent.override", newAgent);
					document.getElementById("devtools-agent-options-other").value = newAgent;
				break;
				
				case "Firefox (Configurable)":
					var newAgent = "Mozilla/5.0 (Windows NT "+document.getElementById("devtools-agent-os").value+"; "+document.getElementById("devtools-agent-arch").value+" rv:"+document.getElementById("devtools-agent-version").value+") Gecko/20100101 Firefox/"+document.getElementById("devtools-agent-version").value;
					Services.prefs.setCharPref("general.useragent.override", newAgent);
					document.getElementById("devtools-agent-options-other").value = newAgent;
				break;
				
			}
			this.showOtherUserAgent();
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong selected item changed event! " + e);
        }
    },


    restoreDefaultUserAgent: function() {
        try {
            Services.prefs.clearUserPref("general.useragent.override");
            document.getElementById("devtools-agent-options-other").value = "";
            document.getElementById("devtools-agent-options-other").value = window.navigator.userAgent;
			document.getElementById("configurableAgent").hidden = true; // If visible
            this.hideOtherUserAgent();
        } catch (e) {
            // Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting restore default useragent! " + e);
        }
    },

    applyOtherUserAgent: function() {
        try {
            Services.prefs.setCharPref("general.useragent.override", document.getElementById("devtools-agent-options-other").value);
            this.hideOtherUserAgent();
        } catch (e) {
            // Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting to set custom useragent! " + e);
        }
    },
    showOtherUserAgent: function() {
        try {

            this.isEnabled("devtools-agent-options-other");
            this.isEnabled("applyOtherUserAgent");
            this.isEnabled("clearOtherUserAgent");

        } catch (e) {
            // Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting to showOtherUserAgent! " + e);
        }
    },

    hideOtherUserAgent: function() {
        try {

            this.isDisabled("devtools-agent-options-other");
            this.isDisabled("applyOtherUserAgent");
            this.isDisabled("clearOtherUserAgent");

        } catch (e) {
            // Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting to hideOtherUserAgent! " + e);
        }
    },

    clearOtherUserAgent: function() {
        this.restoreDefaultUserAgent();
    }

}
window.addEventListener("load", function() {
    gCustomAgentOptions.init();
}, false);

  global.gCustomAgentOptions = gCustomAgentOptions;
}(this));