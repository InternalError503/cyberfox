(function(global) {
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/AppConstants.jsm");
if (typeof gCyberfoxCustom == "undefined") { var gCyberfoxCustom = {}; };
if (!gCyberfoxCustom) { gCyberfoxCustom = {}; };
var gCyberfoxCustom = {

    // Note: We are using pre-existing strings for the message to reduce edits to language packs.
    RestartMsg: Services.strings.createBundle("chrome://browser/locale/browser.properties"),
    Branding: Services.strings.createBundle("chrome://branding/locale/brand.properties").GetStringFromName("brandShortName"),
    UplodateLocal: Services.strings.createBundle("chrome://browser/locale/cyberfox.properties"),
	urlArray: {url:[]},
	DownloadsWindow: null,

    restartBrowser: function(e) {
        try {
            if (Services.prefs.getBoolPref("browser.restart.requireconfirm")) {
                if (Services.prompt.confirm(null, this.RestartMsg.formatStringFromName("appmenu.restartBrowserButton.label", [this.Branding], 1),
                        this.RestartMsg.GetStringFromName("addonInstallRestartButton"))) {
                    if (Services.prefs.getBoolPref("browser.restart.purgecache")) {
                        Services.appinfo.invalidateCachesOnRestart();
                        Services.startup.quit(Services.startup.eRestart | Services.startup.eAttemptQuit);
                    } else {
                        Services.startup.quit(Services.startup.eRestart | Services.startup.eAttemptQuit);
                    }
                }
            } else {
                if (Services.prefs.getBoolPref("browser.restart.purgecache")) {
                    Services.appinfo.invalidateCachesOnRestart();
                    Services.startup.quit(Services.startup.eRestart | Services.startup.eAttemptQuit);
                } else {
                    Services.startup.quit(Services.startup.eRestart | Services.startup.eAttemptQuit);
                }
            }
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'restartBrowser' " + e);
        }
    },
    // Clones current tab into new tab or window.
    CloneCurrent: function(type) {
        try {

            if (gURLBar.value) {
                gBrowser.selectedTab = openUILinkIn(gURLBar.value, type, { relatedToCurrent: true });
            }
        } catch (type) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'CloneCurrent' " + type + " " + e);
        }
    },
    // Copies current tab url to clipboard	
    CopyCurrentTabUrl: function(e) {
        try {
            var gClipboardHelper = Cc["@mozilla.org/widget/clipboardhelper;1"]
                .getService(Ci.nsIClipboardHelper);
            gClipboardHelper.copyString(gBrowser.currentURI.spec);
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'CopyCurrentTabUrl' " + e);
        }
    },
    // Copies all tab urls to clipboard	
    CopyAllTabUrls: function(e) {
        //Get all urls
        this.getAllUrls();
        try {
            // Enumerate all urls in to a list.
            var urlItems = this.urlArray.url;
            var urlList = "";
            for (i = 0; urlItems[i]; i++) {
                try {
                    urlList += urlItems[i].url + "\n";
                } catch (e) {
                    // Catch any nasty errors and output to dialogue
                    Components.utils.reportError(e);
                }
            }
            // Send list to clipboard.				
            var gClipboardHelper = Cc["@mozilla.org/widget/clipboardhelper;1"]
                .getService(Ci.nsIClipboardHelper);
            gClipboardHelper.copyString(urlList.trim());
            // Reset the array.
            this.urlArray = {
                url: []
            };
			     // Clear url list after clipbaord event
		       urlList = "";
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'CopyAllTabUrls' " + e);
        }
    },
    // Get all the tab urls into a json array.
    getAllUrls: function() {
		// We don't want to copy about uri's
        var blacklist = /^about:(about|accounts|addons|app-manager|buildconfig|cache|config|customizing|checkerboard|debugging|downloads|home|newtab|license|logo|memory|mozilla|networking|newaddon|permissions|plugins|preferences|performance|privatebrowsing|profiles|rights|robots|sessionrestore|support|serviceworkers|sync|sync-log|sync-tabs|telemetry|webrtc|welcomeback)/i;		
        var tabCount = gBrowser.browsers.length;
        for (var i = 0; i < tabCount; i++) {
            try {
                var urlItems = gBrowser.getBrowserAtIndex(i).currentURI.spec;				
				if (!blacklist.test(urlItems)){
					this.urlArray.url.push({
						"url": urlItems
					});
				}				
            } catch (e) {
                // Catch any nasty errors and output to dialogue
                Cu.reportError(e);
            }
        }
    },
	// Toggle element state by ID
    _ElementState: function(element, state) {
        try {
            if (!typeof true || !typeof false) {
                return;
            }
            document.getElementById(element).hidden = state;
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with '_ElementState' " + e);
        }
    },
    toggleTabJavascript: function() {
        try {
            if (gBrowser.docShell.allowJavascript) {
                gBrowser.docShell.allowJavascript = false;
                var delayedTrigger = setTimeout(function() {
                    gBrowser.reload();
                }, 10);
            } else {
                gBrowser.docShell.allowJavascript = true;
                var delayedTrigger = setTimeout(function() {
                    gBrowser.reload();
                }, 10);
            }
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'toggleTabJavascript' " + e);
        }
    },
    // Always open about:config a new tab.
    openAboutConfig: function() {
        try {
                gBrowser.selectedTab = openUILinkIn("about:config", 'tab');
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'openAboutConfig' " + e);
        }
    },
    customPrefSettings: function(e) {
        document.getElementById("tabContextMenu")
            .addEventListener("popupshowing", function(e) {
                try {
                    // Clone current tab\window
                    if (Services.prefs.getBoolPref("browser.tabs.clonetab")) {
                        gCyberfoxCustom._ElementState("context_CloneCurrentTab", false);
                        gCyberfoxCustom._ElementState("context_CloneCurrentTabNewWindow", false);
                    } else {
                        gCyberfoxCustom._ElementState("context_CloneCurrentTab", true);
                        gCyberfoxCustom._ElementState("context_CloneCurrentTabNewWindow", true);
                    }
                    // Copy current tab url
                    if (Services.prefs.getBoolPref("browser.tabs.copyurl")) {
                        gCyberfoxCustom._ElementState("context_CopyCurrentTabUrl", false);
                    } else {
                        gCyberfoxCustom._ElementState("context_CopyCurrentTabUrl", true);
                    }
                    // Copy all tab urls
                    if (Services.prefs.getBoolPref("browser.tabs.copyallurls")) {
                        gCyberfoxCustom._ElementState("context_CopyAllTabUrls", false);
                    } else {
                        gCyberfoxCustom._ElementState("context_CopyAllTabUrls", true);
                    }
                } catch (e) {
                    // Catch any nasty errors and output to console
                    console.log("Were sorry but something has gone wrong with 'browser.tabs.clonetab' | browser.tabs.copyurl | browser.tabs.copyallurls " + e);
                }
            }, false);
        document.getElementById("contentAreaContextMenu")
            .addEventListener("popupshowing", function(e) {
                try {
                    // Email page or selected link
                    if (Services.prefs.getBoolPref("browser.context.emaillink")) {
                        gCyberfoxCustom._ElementState("context-sendLink", false);
                    } else {
                        gCyberfoxCustom._ElementState("context-sendLink", true);
                    }
                    // Toggle tab JavaScript
                    if (Services.prefs.getBoolPref("browser.context.togglejavascript")) {
                        gCyberfoxCustom._ElementState("context-javascript", false);
                    } else {
                        gCyberfoxCustom._ElementState("context-javascript", true);
                    }
                } catch (e) {
                    // Catch any nasty errors and output to console
                    console.log("Were sorry but something has gone wrong with 'browser.context.emaillink' | 'browser.context.togglejavascript' " + e);
                }
            }, false);
        document.getElementById("menu_ToolsPopup")
            .addEventListener("popupshowing", function(e) {
                try {
                    // Minimize memory usage
                    if (Services.prefs.getBoolPref("clean.ram.cache")) {
                        gCyberfoxCustom._ElementState("minimizeMemoryUsage", false);
                    } else {
                        gCyberfoxCustom._ElementState("minimizeMemoryUsage", true);
                    }
                } catch (e) {
                    // Catch any nasty errors and output to console
                    console.log("Were sorry but something has gone wrong with 'clean.ram.cache' " + e);
                }
            }, false);
        document.getElementById("menu_FilePopup")
            .addEventListener("popupshowing", function(e) {
                try {
                    // Restart browser
                    if (Services.prefs.getBoolPref("browser.restart.enabled")) {
                        gCyberfoxCustom._ElementState("app_restartBrowser", false);
                    } else {
                        gCyberfoxCustom._ElementState("app_restartBrowser", true);
                    }
                } catch (e) {
                    // Catch any nasty errors and output to console
                    console.log("Were sorry but something has gone wrong with 'browser.restart.enabled' " + e);
                }
            }, false);
        document.getElementById("toolbar-context-menu")
            .addEventListener("popupshowing", function(e) {
                try {
                    // Menu item About:config
                    if (Services.prefs.getBoolPref("browser.context.aboutconfig")) {
                        gCyberfoxCustom._ElementState("menu-aboutconfig", false);
                    } else {
                        gCyberfoxCustom._ElementState("menu-aboutconfig", true);
                    }
                } catch (e) {
                    // Catch any nasty errors and output to console
                    console.log("Were sorry but something has gone wrong with 'browser.context.aboutconfig' " + e);
                }
            }, false);
        document.getElementById("menu_viewPopup")
            .addEventListener("popupshowing", function(e) {
                try {
                    // Menu item About:config
                    if (Services.prefs.getBoolPref("browser.menu.aboutconfig")) {
                        gCyberfoxCustom._ElementState("AboutConfigMenuItem", false);
                    } else {
                        gCyberfoxCustom._ElementState("AboutConfigMenuItem", true);
                    }
                } catch (e) {
                    // Catch any nasty errors and output to console
                    console.log("Were sorry but something has gone wrong with 'browser.menu.aboutconfig' " + e);
                }
            }, false);
        // Restart browser panel UI		
        document.getElementById("PanelUI-popup").addEventListener("popupshowing", function(e) {
            try {
                if (!Services.prefs.getBoolPref("browser.restart.showpanelmenubtn")) {
                    document.getElementById("panelUI_menu_restartBrowser").hidden = true;
                } else {
                    document.getElementById("panelUI_menu_restartBrowser").hidden = false;
                }
                if (Services.prefs.getBoolPref("browser.restart.smallpanelmenubtn")) {
                    document.getElementById("panelUI_menu_restartBrowser").className = "rb_panelUI_menu_small_icon";
                } else {
                    document.getElementById("panelUI_menu_restartBrowser").removeAttribute('class');
                }
            } catch (e) {
                // Catch any nasty errors and output to console
                console.log("Were sorry but something has gone wrong with 'browser.restart.showpanelmenubtn' | 'browser.restart.smallpanelmenubtn' " + e);
            }
        });
        window.addEventListener("beforecustomization", function(e) {
            try {
                document.getElementById("panelUI_menu_restartBrowser").setAttribute('disabled', true);
            } catch (e) {}
        }, false);
        window.addEventListener("aftercustomization", function(e) {
            try {
                document.getElementById("panelUI_menu_restartBrowser").removeAttribute('disabled');
            } catch (e) {}
        }, false);
    },
	// Download window style helper
    toolsDownloads: function(tools) {
        try {
            if (Services.prefs.getBoolPref("browser.download.useToolkitUI")) {
                if (this.DownloadsWindow == null || this.DownloadsWindow.closed) {
                    window.open("chrome://browser/content/downloads/downloadsWindow.xul", "Downloads", "resizable=yes,chrome=yes,centerscreen=yes,top=yes,alwaysRaised=no");
                } else {
                    this.DownloadsWindow.focus();
                }
            } else {
				if (tools === true){
					BrowserDownloadsUI();
				} else if (tools === false){
					DownloadsPanel.showDownloadsHistory();
				}				
            }
        } catch (e) {
            // Catch any nasty errors and output to console
            console.log("Were sorry but something has gone wrong with 'toolsDownloads' " + e);
        }
    },
	// Version comparison
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
            // Catch any nasty errors
            Cu.reportError(rv);
        }
    },
	// Update notification notify
	updateNotification: function(){
		if (Services.prefs.getBoolPref("app.update.autocheck") && 
			Services.prefs.getBoolPref("app.update.available") && 
			Services.prefs.getBoolPref("app.update.check.enabled")){			
        // Clear any previous set urls
        Services.prefs.clearUserPref("app.update.url.manual");	
			// Set notification bar button.
			var button = [];
			button = [{
				label: this.UplodateLocal.GetStringFromName("update.notification.button"),
				accessKey: "v",
				callback: function() { openUILinkIn(Services.prefs.getCharPref("app.update.url.manual"), 'tab'); }
			}];		
			try {
				if(Services.prefs.getBoolPref("app.update.notification-new")){
						if(AppConstants.platform == "win"){
							Cc['@mozilla.org/alerts-service;1'].getService(Ci.nsIAlertsService)
							.showAlertNotification('chrome://branding/content/icon48.png', this.UplodateLocal.formatStringFromName("update.notification.new.title", [this.Branding], 1), 
								this.UplodateLocal.formatStringFromName("update.notification.message", [this.Branding], 1), false,  '',  null, '');
						}else if(AppConstants.platform == "linux"){
							var nb = gBrowser.getNotificationBox();
							var iupdateNotification = nb.getNotificationWithValue('cyberfoxupdate');	
							if (iupdateNotification) {
								return;
							}else{
								nb.appendNotification(this.UplodateLocal.formatStringFromName("update.notification.message", [this.Branding], 1), 'cyberfoxupdate', 'chrome://branding/content/icon16.png', nb.PRIORITY_WARNING_HIGH, button);
							}
						}
					}else{
						var nb = gBrowser.getNotificationBox();
						var iupdateNotification = nb.getNotificationWithValue('cyberfoxupdate');	
						if (iupdateNotification) {
							return;
						}else{
							nb.appendNotification(this.UplodateLocal.formatStringFromName("update.notification.message", [this.Branding], 1), 'cyberfoxupdate', 'chrome://branding/content/icon16.png', nb.PRIORITY_WARNING_HIGH, button);
						}						
					}
				} catch(e) {
					// Prevents runtime error on platforms that don't implement nsIAlertsService
			}
		}else{Services.prefs.setBoolPref("app.update.available", false);}		
	},
	startupUpdateCheck: function(aBoolean){
		if (Services.prefs.getBoolPref("app.update.startup.check") === false) {
			return;
		}	
		// We are skipping update checks entirely if cyberfox beta for now.
        if (Services.prefs.getCharPref("app.update.channel.type") === "beta") {
            return;
        }
        if (Services.prefs.getBoolPref("app.update.autocheck")) {
            try {
                // Set Global to disable update checks entirely 
                if (Services.prefs.getBoolPref("app.update.check.enabled") && aBoolean === true) {
														
						var curTime = new Date();
						if 	(Services.prefs.getCharPref("app.update.startup.lastcheck") != curTime.getHours()) {
											Services.prefs.setCharPref("app.update.startup.lastcheck", curTime.getHours());
							// Get Latest Browser Version
							var url = Services.prefs.getCharPref("app.update.check.url");
							var request = new XMLHttpRequest();
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
								var jsObject = null;
								var currentVersion = null;
								if (!IsJsonValid(text)) { 
									// Throw error message	
									console.log("Were sorry but something has gone wrong while trying to parse update.json (json is not valid!)");
									// Return error
									return;
								} else {
									jsObject = JSON.parse(text);
								}
								switch (Services.prefs.getCharPref("app.update.channel.type")) {
									case "release": currentVersion = jsObject.release; break;
									case "beta":currentVersion = jsObject.beta;break;
									case "esr":currentVersion = jsObject.esr;break;
								}
								if (gCyberfoxCustom.compareVersions(Services.appinfo.version, currentVersion.toString()) === false && aBoolean === true) {
									try {
										// Set update available
										Services.prefs.setBoolPref("app.update.available", true);
										gCyberfoxCustom.updateNotification();
									  } catch(e) {
										// Prevents runtime error on platforms that don't implement nsIAlertsService
									  }								
								}else{
									// Set update available
									Services.prefs.setBoolPref("app.update.available", false);	
									console.log("Update check event was spawned!");									
								}	
							};
							request.ontimeout = function(aEvent) {
								// Log return failed check message for request time-out!
								console.log("Startup update check failed! timed out");
							};
							request.onerror = function(aEvent) {
								switch (aEvent.target.status) {
									case 0:console.log("Startup update check failed! no connection or blocked. " + aEvent.target.status);break;
									case 1:console.log("Error Status: " + aEvent.target.status);break;
									case 2:console.log("Error Status: " + aEvent.target.status);break;
									case 3:console.log("Error Status: " + aEvent.target.status);break;
									case 4:console.log("Error Status: " + aEvent.target.status);break;
									default:console.log("Error Status: " + aEvent.target.status);break;
								}
							};
							request.timeout = Services.prefs.getIntPref("app.update.startup-timeout");
							request.open("GET", url + ((/\?/).test(url) ? "&" : "?") + (new Date()).getTime(), true);
							request.setRequestHeader("Content-Type", "application/json");
							request.send(null);
					} else {
						// Set update notification
						Services.prefs.setBoolPref("app.update.available", false);							
						console.log("Update check deferred!");
					}					
                }
            } catch (eve) {
                // Catch any nasty errors
                Cu.reportError(eve);
            }
        }
	}
}
window.addEventListener("load", function() {
    gCyberfoxCustom.customPrefSettings();
	window.removeEventListener("load",gCyberfoxCustom.startupUpdateCheck(), false);
	window.setTimeout(function(){
		gCyberfoxCustom.startupUpdateCheck(true);
		if (AppConstants.platform == "win" || AppConstants.platform == "linux"){
			gCyberfoxCustom.updateNotification();
		}
	},Services.prefs.getIntPref("app.update.startup-delay"));	
}, false);
  global.gCyberfoxCustom = gCyberfoxCustom;
}(this));