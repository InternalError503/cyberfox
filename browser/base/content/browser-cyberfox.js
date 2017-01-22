(function (global) {
	Cu.import("resource://gre/modules/Services.jsm");
	Cu.import("resource://gre/modules/AppConstants.jsm");
	if (typeof gCyberfoxCustom == "undefined") { var gCyberfoxCustom = {}; };
	if (!gCyberfoxCustom) { gCyberfoxCustom = {}; };
	var gCyberfoxCustom = {

		// Note: We are using pre-existing strings for the message to reduce edits to language packs.
		RestartMsg: Services.strings.createBundle("chrome://browser/locale/browser.properties"),
		Branding: Services.strings.createBundle("chrome://branding/locale/brand.properties").GetStringFromName("brandShortName"),
		UplodateLocal: Services.strings.createBundle("chrome://browser/locale/cyberfox.properties"),
		urlArray: { url: [] },
		DownloadsWindow: null,

		init: function () {
			function setEventListener(aId, aEventType, aCallback) {
				document.getElementById(aId)
					.addEventListener(aEventType, aCallback.bind(gCyberfoxCustom));
			}

			setEventListener("toolbar-context-menu", "popupshowing",
				gCyberfoxCustom.updateToolbarContextMenu);
			setEventListener("tabContextMenu", "popupshowing",
				gCyberfoxCustom.updateTabContextMenu);
			setEventListener("contentAreaContextMenu", "popupshowing",
				gCyberfoxCustom.updateContentAreaContextMenu);
			setEventListener("menu_ToolsPopup", "popupshowing",
				gCyberfoxCustom.updateMenu_ToolsPopup);
			setEventListener("menu_FilePopup", "popupshowing",
				gCyberfoxCustom.updateMenu_FilePopup);
			setEventListener("menu_viewPopup", "popupshowing",
				gCyberfoxCustom.updateMenu_viewPopup);
			setEventListener("PanelUI-popup", "popupshowing",
				gCyberfoxCustom.updatePanelUI_popup);

			window.addEventListener("beforecustomization", function () {
				try {
					document.getElementById("panelUI_menu_restartBrowser").setAttribute('disabled', true);
				} catch (e) { }
			}, false);
			window.addEventListener("aftercustomization", function () {
				try {
					document.getElementById("panelUI_menu_restartBrowser").removeAttribute('disabled');
				} catch (e) { }
			}, false);

		},

		// ToolbarContextMenu
		updateToolbarContextMenu: function () {
			try {
				// Menu item About:config
				if (Services.prefs.getBoolPref("browser.context.aboutconfig")) {
					gCyberfoxCustom.toggleState("menu-aboutconfig", false);
				} else {
					gCyberfoxCustom.toggleState("menu-aboutconfig", true);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'browser.context.aboutconfig' " + e);
			}
		},

		// TabContextMenu
		updateTabContextMenu: function () {
			try {
				// Clone current tab\window + private
				if (Services.prefs.getBoolPref("browser.tabs.clonetab")) {
					gCyberfoxCustom.toggleState("context_CloneCurrentTab", false);
					gCyberfoxCustom.toggleState("context_CloneCurrentTabNewWindow", false);
					gCyberfoxCustom.toggleState("context_CloneCurrentTabNewWindowpb", false);
				} else {
					gCyberfoxCustom.toggleState("context_CloneCurrentTab", true);
					gCyberfoxCustom.toggleState("context_CloneCurrentTabNewWindow", true);
					gCyberfoxCustom.toggleState("context_CloneCurrentTabNewWindowpb", true);
				}
				// Copy current tab url
				if (Services.prefs.getBoolPref("browser.tabs.copyurl")) {
					gCyberfoxCustom.toggleState("context_CopyCurrentTabUrl", false);
				} else {
					gCyberfoxCustom.toggleState("context_CopyCurrentTabUrl", true);
				}
				// Copy all tab urls
				if (Services.prefs.getBoolPref("browser.tabs.copyallurls")) {
					gCyberfoxCustom.toggleState("context_CopyAllTabUrls", false);
				} else {
					gCyberfoxCustom.toggleState("context_CopyAllTabUrls", true);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'browser.tabs.clonetab' | browser.tabs.copyurl | browser.tabs.copyallurls " + e);
			}
		},

		// ContentAreaContextMenu
		updateContentAreaContextMenu: function () {
			try {
				// Email page or selected link
				if (Services.prefs.getBoolPref("browser.context.emaillink")) {
					gCyberfoxCustom.toggleState("context-sendLink", false);
				} else {
					gCyberfoxCustom.toggleState("context-sendLink", true);
				}
				// Toggle tab JavaScript
				if (Services.prefs.getBoolPref("browser.context.togglejavascript")) {
					gCyberfoxCustom.toggleState("context-javascript", false);
				} else {
					gCyberfoxCustom.toggleState("context-javascript", true);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'browser.context.emaillink' | 'browser.context.togglejavascript' " + e);
			}
		},

		// Menu_ToolsPopup
		updateMenu_ToolsPopup: function () {
			try {
				// Minimize memory usage
				if (Services.prefs.getBoolPref("clean.ram.cache")) {
					gCyberfoxCustom.toggleState("minimizeMemoryUsage", false);
				} else {
					gCyberfoxCustom.toggleState("minimizeMemoryUsage", true);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'clean.ram.cache' " + e);
			}
		},

		// Menu_FilePopup
		updateMenu_FilePopup: function () {
			try {
				// Restart browser
				if (Services.prefs.getBoolPref("browser.restart.enabled")) {
					gCyberfoxCustom.toggleState("app_restartBrowser", false);
				} else {
					gCyberfoxCustom.toggleState("app_restartBrowser", true);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'browser.restart.enabled' " + e);
			}
		},

		// Menu_viewPopup
		updateMenu_viewPopup: function () {
			try {
				// Menu item About:config
				if (Services.prefs.getBoolPref("browser.menu.aboutconfig")) {
					gCyberfoxCustom.toggleState("AboutConfigMenuItem", false);
				} else {
					gCyberfoxCustom.toggleState("AboutConfigMenuItem", true);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'browser.menu.aboutconfig' " + e);
			}
		},

		// PanelUI-popup
		updatePanelUI_popup: function () {
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
				throw new Error("Were sorry but something has gone wrong with 'browser.restart.showpanelmenubtn' | 'browser.restart.smallpanelmenubtn' " + e);
			}
		},

		// Restart browser
		restartBrowser: function () {
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
				throw new Error("Were sorry but something has gone wrong with 'restartBrowser' " + e);
			}
		},
		
		// Clones current tab into new tab or window.
		CloneCurrent: function (type, isprivate) {
			try {
				if (gURLBar.value) {
					gBrowser.selectedTab = openUILinkIn(gURLBar.value, type, { relatedToCurrent: true, private: isprivate });
				}
			} catch (type) {
				throw new Error("Were sorry but something has gone wrong with 'CloneCurrent' " + type + " " + e);
			}
		},
		
		// Copies current tab url to clipboard	
		CopyCurrentTabUrl: function (uri) {
			try {
				var gClipboardHelper = Cc["@mozilla.org/widget/clipboardhelper;1"]
					.getService(Ci.nsIClipboardHelper);
				if (Services.prefs.getBoolPref("browser.tabs.copyurl.activetab")) {
					gClipboardHelper.copyString(gBrowser.currentURI.spec);
				} else {
					gClipboardHelper.copyString(uri);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'CopyCurrentTabUrl' " + e);
			}
		},
		
		// Get all the tab urls into a json array.
		getAllUrls: function () {
			// We don't want to copy about uri's
			var blacklist = /^about:(about|accounts|addons|app-manager|buildconfig|cache|config|customizing|checkerboard|debugging|downloads|home|newtab|license|logo|memory|mozilla|networking|newaddon|permissions|plugins|preferences|performance|privatebrowsing|profiles|rights|robots|sessionrestore|support|serviceworkers|sync|sync-log|sync-tabs|telemetry|webrtc|welcomeback)/i;
			var tabCount = gBrowser.browsers.length;
			for (var i = 0; i < tabCount; i++) {
				try {
					var urlItems = gBrowser.getBrowserAtIndex(i).currentURI.spec;
					if (!blacklist.test(urlItems)) {
						this.urlArray.url.push({
							"url": urlItems
						});
					}
				} catch (e) {
					Cu.reportError(e);
				}
			}
		},
		
		// Copies all tab urls to clipboard	
		CopyAllTabUrls: function () {
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
						Cu.reportError(e);
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
				throw new Error("Were sorry but something has gone wrong with 'CopyAllTabUrls' " + e);
			}
		},

		// Toggle element state by ID
		toggleState: function (element, state) {
			try {
				if (!typeof true || !typeof false) {
					return;
				}
				document.getElementById(element).hidden = state;
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'toggleState' " + e);
			}
		},
		
		// Toggle tab javascript
		toggleTabJavascript: function () {
			try {
				if (gBrowser.docShell.allowJavascript) {
					gBrowser.docShell.allowJavascript = false;
					var delayedTrigger = setTimeout(function () {
						gBrowser.reload();
					}, 10);
				} else {
					gBrowser.docShell.allowJavascript = true;
					var delayedTrigger = setTimeout(function () {
						gBrowser.reload();
					}, 10);
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'toggleTabJavascript' " + e);
			}
		},
		
		// Always open about:config a new tab.
		openAboutConfig: function () {
			try {
				gBrowser.selectedTab = openUILinkIn("about:config", 'tab');
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'openAboutConfig' " + e);
			}
		},
		
		// Download window style helper
		toolsDownloads: function (tools) {
			try {
				if (Services.prefs.getBoolPref("browser.download.useToolkitUI")) {
					if (this.DownloadsWindow == null || this.DownloadsWindow.closed) {
						window.open("chrome://browser/content/downloads/downloadsWindow.xul", "Downloads", "resizable=yes,chrome=yes,centerscreen=yes,top=yes,alwaysRaised=no");
					} else {
						this.DownloadsWindow.focus();
					}
				} else {
					if (tools === true) {
						BrowserDownloadsUI();
					} else if (tools === false) {
						DownloadsPanel.showDownloadsHistory();
					}
				}
			} catch (e) {
				throw new Error("Were sorry but something has gone wrong with 'toolsDownloads' " + e);
			}
		},
		
		// Version comparison
		compareVersions: function (_Installed, _Required) {
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
				Cu.reportError(rv);
			}
		},
		
		// Version build comparison
		compareBuildVersions: function (_Installed, _Required) {
			try {
				var installed = Number(_Installed.substring(_Installed.indexOf("b") + 1, _Installed.length));
				var required = Number(_Required.substring(_Required.indexOf("b") + 1, _Required.length));
				if (installed === required || installed > required) return true;
				if (installed < required) return false;

				return true;
			} catch (rv) {
				Cu.reportError(rv);
			}
		},
		
		getUpdates: function () {
			try {
				var appDir = Cc["@mozilla.org/file/directory_service;1"]
					.getService(Ci.nsIProperties).get("GreD", Ci.nsILocalFile);
				appDir.append("updater.exe");

				// create an nsIFile for the executable
				var file = Cc["@mozilla.org/file/local;1"]
					.createInstance(Ci.nsIFile);
				file.initWithPath(appDir.path.toString());

				// create an nsIProcess
				var process = Cc["@mozilla.org/process/util;1"]
					.createInstance(Ci.nsIProcess);
				if (file.exists()) {
					process.init(file);

					// Run the process.
					// If first param is true, calling thread will be blocked until
					// called process terminates.
					// Second and third params are used to pass command-line arguments
					// to the process.
					var args = ["--checknow"];
					if (!Services.prefs.getBoolPref("app.update.verifysha")) {
						args.push("--nosha");
					}
					process.run(false, args, args.length);
				} else {
					throw new Error('Whoops! Hey somethings is not right maybe contact support!');
				}
			} catch (rv) {
				Cu.reportError(rv);
			}
		},
			
		// Update notification notify
		updateNotification: function () {
			if (Services.prefs.getBoolPref("app.update.autocheck") &&
				Services.prefs.getBoolPref("app.update.available") &&
				Services.prefs.getBoolPref("app.update.check.enabled")) {
				// Clear any previous set urls
				Services.prefs.clearUserPref("app.update.url.manual");

				var alertsService = Cc["@mozilla.org/alerts-service;1"].
					getService(Ci.nsIAlertsService);

				// Set button text by platform
				var buttonText = "";
				if (AppConstants.platform == "win") {
					buttonText = this.UplodateLocal.GetStringFromName("update.notification.button.win");
				} else {
					buttonText = this.UplodateLocal.GetStringFromName("update.notification.button");
				}

				// Set notification bar button.
				var button = [];
				button = [{
					label: buttonText,
					accessKey: "v",
					callback: function () {
						if (AppConstants.platform == "win") {
							Services.prefs.setBoolPref("app.update.available", false);
							gCyberfoxCustom.getUpdates();
						} else {
							Services.prefs.setBoolPref("app.update.available", false);
							openUILinkIn(Services.prefs.getCharPref("app.update.url.manual"), 'tab');
						}
					}
				}];

				if (Services.prefs.getBoolPref("app.update.notification-new")) {

					if (AppConstants.platform == "win") {
						alertsService.showAlertNotification('chrome://branding/content/icon48.png', this.UplodateLocal.formatStringFromName("update.notification.new.title", [this.Branding], 1),
							this.UplodateLocal.formatStringFromName("update.notification.message", [this.Branding], 1), false, '', null, '');
					} else if (AppConstants.platform == "linux") {
						try {
							var nb = gBrowser.getNotificationBox();
							nb.appendNotification(this.UplodateLocal.formatStringFromName("update.notification.message", [this.Branding], 1), 'cyberfoxupdate', 'chrome://branding/content/icon16.png', nb.PRIORITY_WARNING_HIGH, button);
						} catch (e) { }
					}

				} else {
					try {
						var nb = gBrowser.getNotificationBox();
						nb.appendNotification(this.UplodateLocal.formatStringFromName("update.notification.message", [this.Branding], 1), 'cyberfoxupdate', 'chrome://branding/content/icon16.png', nb.PRIORITY_WARNING_HIGH, button);
					} catch (e) { }
				}
				Services.prefs.setBoolPref("app.update.available", false);
			}
		},

		startupUpdateCheck: function (aBoolean) {
			function IsJsonValid(text) {
				try {
					JSON.parse(text);
				} catch (e) {
					return false;
				}
				return true;
			}

			if (!Services.prefs.getBoolPref("app.update.startup.check")) return;
			if (Services.prefs.getBoolPref("app.update.autocheck")) {
				try {
					// Set Global to disable update checks entirely 
					if (Services.prefs.getBoolPref("app.update.check.enabled") && aBoolean === true) {

						var curTime = new Date().getHours();
						if (Services.prefs.getCharPref("app.update.startup.lastcheck") != curTime) {
							Services.prefs.setCharPref("app.update.startup.lastcheck", curTime);
							// Get Latest Browser Version
							var url = Services.prefs.getCharPref("app.update.check.url");
							var request = new XMLHttpRequest();
							request.onload = function (aEvent) {
								var text = aEvent.target.responseText;
								// Need to check if json is valid, If json not valid don't continue and show error.
								var jsObject = null;
								var currentVersion = null;
								if (!IsJsonValid(text)) {
									// Throw error message	
									throw new Error("Were sorry but something has gone wrong while trying to parse update.json (json is not valid!)");
									// Return error
									return;
								} else {
									jsObject = JSON.parse(text);
								}
								switch (Services.prefs.getCharPref("app.update.channel.type")) {
									case "release": currentVersion = jsObject.release; break;
									case "beta": currentVersion = jsObject.beta; break;
									case "esr": currentVersion = jsObject.esr; break;
								}
								var updateAvailable = false;

								if (Services.prefs.getCharPref("app.update.channel.type") === "beta") {
									updateAvailable = (gCyberfoxCustom.compareVersions(Services.appinfo.version, currentVersion.toString().replace(/b[0-9]+/g, '')) &&
										gCyberfoxCustom.compareBuildVersions(AppConstants.MOZ_APP_VERSION_DISPLAY, currentVersion.toString()));
								} else if (Services.prefs.getCharPref("app.update.channel.type") === "release") {
									updateAvailable = (gCyberfoxCustom.compareVersions(Services.appinfo.version, currentVersion.toString()));
								}

								switch (updateAvailable) {
									case true:
										// Set update available
										Services.prefs.setBoolPref("app.update.available", false);
										break;
									case false:
										try {
											// Set update available
											Services.prefs.setBoolPref("app.update.available", true);
											gCyberfoxCustom.updateNotification();
										} catch (e) {
											// Prevents runtime error on platforms that don't implement nsIAlertsService
										}
										break;
								}


							};
							request.ontimeout = function (aEvent) {
								// Log return failed check message for request time-out!
								throw new Error("Startup update check failed! timed out");
							};
							request.onerror = function (aEvent) {
								switch (aEvent.target.status) {
									case 0: throw new Error("Startup update check failed! no connection or blocked. " + aEvent.target.status); break;
									case 1: throw new Error("Error Status: " + aEvent.target.status); break;
									case 2: throw new Error("Error Status: " + aEvent.target.status); break;
									case 3: throw new Error("Error Status: " + aEvent.target.status); break;
									case 4: throw new Error("Error Status: " + aEvent.target.status); break;
									default: throw new Error("Error Status: " + aEvent.target.status); break;
								}
							};
							request.timeout = Services.prefs.getIntPref("app.update.startup-timeout");
							request.open("GET", url + ((/\?/).test(url) ? "&" : "?") + (new Date()).getTime(), true);
							request.setRequestHeader("Content-Type", "application/json");
							request.send(null);
						} else {
							// Set update notification
							Services.prefs.setBoolPref("app.update.available", false);
						}
					}
				} catch (eve) {
					Cu.reportError(eve);
				}
			} else {
				// Set update notification (Additional fallback)
				Services.prefs.setBoolPref("app.update.available", false);
			}
		}
	}
	
	window.addEventListener("load", function () {
		gCyberfoxCustom.init();
		Services.prefs.setBoolPref("app.update.available", false);
		window.removeEventListener("load", gCyberfoxCustom.startupUpdateCheck(), false);
		window.setTimeout(function () {
			gCyberfoxCustom.startupUpdateCheck(true);
		}, Services.prefs.getIntPref("app.update.startup-delay"));
	}, false);
	
	global.gCyberfoxCustom = gCyberfoxCustom;
} (this));