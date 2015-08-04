(function(global) {
	
const { classes: Cc, interfaces: Ci, utils: Cu } = Components;

let {Services} = Cu.import("resource://gre/modules/Services.jsm");
let {FileUtils} = Cu.import("resource://gre/modules/FileUtils.jsm");
let {NetUtil} = Cu.import("resource://gre/modules/NetUtil.jsm");

if (typeof gCustomOptionsPanel == "undefined") {
    var gCustomOptionsPanel = {};
};
if (!gCustomOptionsPanel) {
    gCustomOptionsPanel = {};
};

var gCustomOptionsPanel = {
		panelPopUpOther : "",
		agentID : "",
		agentOS : "",
		agentVersion : "",
		agentArch: "",

    init: function(e) {

        try {
			
            this.panelPopUpOther = document.getElementById("devtools-agent-options-other");
            this.agentID = document.getElementById("devtools-agent-menu");
			this.agentOS = document.getElementById("devtools-agent-os");
			this.agentVersion = document.getElementById("devtools-agent-version");
			this.agentArch = document.getElementById("devtools-agent-arch");

            //Get, Load and parse agents.json	
            var jsonFile = FileUtils.getFile("CurProcD", ["agents.json"]);

            var jsonContent;
            var contentChannel = NetUtil.newChannel(jsonFile);

            contentChannel.contentType = "application/json";

            NetUtil.asyncFetch(contentChannel, function(aInputStream, aResult) {

                if (!Components.isSuccessCode(aResult)) {
                    //Prevent panel activation if agents.json not found!
                    document.getElementById("showUserAgent").hidden = true;
                    console.log("Were sorry but something has gone wrong while trying to load agents.json (agents.json not found!)" + aResult);
                    return;
                }

                jsonContent = NetUtil.readInputStreamToString(aInputStream, aInputStream.available());

                var myJson;

                if (!gCustomOptionsPanel.IsJsonValid(jsonContent)) {
                    //Need to throw error message and disable agentID if not valid json.
                    this.agentID.disabled = true;
                    console.log("Were sorry but something has gone wrong while trying to parse agents.json (json is not valid!)");
                    return;
                } else {
                    myJson = JSON.parse(jsonContent);
                }

                var browserListArray = myJson.userAgents[0].browsers;
				var optionsListArrayVersion = myJson.userAgents[0].options[0].version;

				for (var i = 0;optionsListArrayVersion[i]; i++) {
						var optionsItemsList = document.getElementById("devtools-agent-version").appendItem(optionsListArrayVersion[i], optionsListArrayVersion[i]);
				}

                for (var i = 0; browserListArray[i]; i++) {

                    var menuItemsList = document.getElementById("devtools-agent-menu").appendItem(browserListArray[i].name, browserListArray[i].agent);
					
                }

            });
            //Only if known in list will it show only in current panel session, all other cases select user-agent item is set.
            this.agentID.label = window.navigator.userAgent;

            this.panelPopUpOther.value = "";
            this.panelPopUpOther.value = window.navigator.userAgent;


        } catch (e) {
            //Catch any nasty errors and output to dialogue and console
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
            Services.prefs.setCharPref("general.useragent.override", this.agentID.value);
            this.panelPopUpOther.value = this.agentID.value;
			if(this.agentID.label === "Cyberfox (Configurable)" || this.agentID.label === "Firefox (Configurable)"){
				document.getElementById("configurableAgent").hidden = false;
			}else{
				document.getElementById("configurableAgent").hidden = true;
			}
            this.showOtherUserAgent();
        } catch (e) {
            //Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong selected item changed event!" + e);
        }
    },
	
    configurableAgentChanged: function() {
        try {
			switch (this.agentID.label) {
				case "Cyberfox (Configurable)":
					var newAgent = "Mozilla/5.0 (Windows NT "+this.agentOS.value+"; "+this.agentArch.value+" rv:"+this.agentVersion.value+") Gecko/20100101 Firefox/"+this.agentVersion.value+" Cyberfox/"+this.agentVersion.value;
					Services.prefs.setCharPref("general.useragent.override", newAgent);
					this.panelPopUpOther.value = newAgent;
				break;
				
				case "Firefox (Configurable)":
					var newAgent = "Mozilla/5.0 (Windows NT "+this.agentOS.value+"; "+this.agentArch.value+" rv:"+this.agentVersion.value+") Gecko/20100101 Firefox/"+this.agentVersion.value;
					Services.prefs.setCharPref("general.useragent.override", newAgent);
					this.panelPopUpOther.value = newAgent;
				break;
				
			}
			this.showOtherUserAgent();
        } catch (e) {
            //Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong selected item changed event!" + e);
        }
    },


    restoreDefaultUserAgent: function() {
        try {
            Services.prefs.clearUserPref("general.useragent.override");
            this.panelPopUpOther.value = "";
            this.panelPopUpOther.value = window.navigator.userAgent;
            this.hideOtherUserAgent();
        } catch (e) {
            //Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting restore default useragent!" + e);
        }
    },

    applyOtherUserAgent: function() {
        try {
            Services.prefs.setCharPref("general.useragent.override", panelPopUpOther.value);
            this.hideOtherUserAgent();
        } catch (e) {
            //Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting to set custom useragent!" + e);
        }
    },
    showOtherUserAgent: function() {
        try {

            this.isEnabled("devtools-agent-options-other");
            this.isEnabled("applyOtherUserAgent");
            this.isEnabled("clearOtherUserAgent");

        } catch (e) {
            //Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting to showOtherUserAgent!" + e);
        }
    },

    hideOtherUserAgent: function() {
        try {

            this.isDisabled("devtools-agent-options-other");
            this.isDisabled("applyOtherUserAgent");
            this.isDisabled("clearOtherUserAgent");

        } catch (e) {
            //Catch any nasty errors and output to dialogue and console
            console.log("Were sorry but something has gone wrong while attempting to hideOtherUserAgent!" + e);
        }
    },

    clearOtherUserAgent: function() {
        this.restoreDefaultUserAgent();
    }

}
window.addEventListener("load", function() {
    gCustomOptionsPanel.init();
}, false);

  global.gCustomOptionsPanel = gCustomOptionsPanel;
}(this));