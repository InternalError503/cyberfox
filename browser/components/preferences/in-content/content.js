/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

XPCOMUtils.defineLazyGetter(this, "AlertsServiceDND", function () {
  try {
    let alertsService = Cc["@mozilla.org/alerts-service;1"]
                          .getService(Ci.nsIAlertsService)
                          .QueryInterface(Ci.nsIAlertsDoNotDisturb);
    // This will throw if manualDoNotDisturb isn't implemented.
    alertsService.manualDoNotDisturb;
    return alertsService;
  } catch (ex) {
    return undefined;
  }
});

var gContentPane = {
  init: function ()
  {
    function setEventListener(aId, aEventType, aCallback)
    {
      document.getElementById(aId)
              .addEventListener(aEventType, aCallback.bind(gContentPane));
    }

    // Initializes the fonts dropdowns displayed in this pane.
    this._rebuildFonts();
    var menulist = document.getElementById("defaultFont");
    if (menulist.selectedIndex == -1) {
      menulist.value = FontBuilder.readFontSelection(menulist);
    }

    // Show translation preferences if we may:
    const prefName = "browser.translation.ui.show";
    if (Services.prefs.getBoolPref(prefName)) {
      let row = document.getElementById("translationBox");
      row.removeAttribute("hidden");
      // Showing attribution only for Bing Translator.
      Components.utils.import("resource:///modules/translation/Translation.jsm");
      if (Translation.translationEngine == "bing") {
        document.getElementById("bingAttribution").removeAttribute("hidden");
      }
    }
	
    // Grab current set locale from 'general.useragent.locale'
    this.updateDefaultLocale();

    let doNotDisturbAlertsEnabled = false;
    if (AlertsServiceDND) {
      let notificationsDoNotDisturbRow =
        document.getElementById("notificationsDoNotDisturbRow");
      notificationsDoNotDisturbRow.removeAttribute("hidden");
      if (AlertsServiceDND.manualDoNotDisturb) {
        let notificationsDoNotDisturb =
          document.getElementById("notificationsDoNotDisturb");
        notificationsDoNotDisturb.setAttribute("checked", true);
      }
    }

    setEventListener("font.language.group", "change",
      gContentPane._rebuildFonts);
    setEventListener("notificationsPolicyButton", "command",
      gContentPane.showNotificationExceptions);
    setEventListener("popupPolicyButton", "command",
      gContentPane.showPopupExceptions);
    setEventListener("advancedFonts", "command",
      gContentPane.configureFonts);
    setEventListener("colors", "command",
      gContentPane.configureColors);
    setEventListener("chooseLanguage", "command",
      gContentPane.showLanguages);
    setEventListener("translationAttributionImage", "click",
      gContentPane.openTranslationProviderAttribution);
    setEventListener("translateButton", "command",
      gContentPane.showTranslationExceptions);
    setEventListener("notificationsDoNotDisturb", "command",
      gContentPane.toggleDoNotDisturbNotifications);
    setEventListener("languageMenu", "popuphidden", function () {
      gContentPane.setDefaultLocale();
    });
    setEventListener("languageMenu", "keypress", function (e) {
      gContentPane._setDefaultLocale(e);
    });
	
    let notificationInfoURL =
      Services.urlFormatter.formatURLPref("app.helpdoc.baseURI") + "push";
    document.getElementById("notificationsPolicyLearnMore").setAttribute("href",
                                                                         notificationInfoURL);

    let drmInfoURL =
      Services.urlFormatter.formatURLPref("app.helpdoc.baseURI") + "drm-content";
    document.getElementById("playDRMContentLink").setAttribute("href", drmInfoURL);
    let emeUIEnabled = Services.prefs.getBoolPref("browser.eme.ui.enabled");
    // Force-disable/hide on WinXP:
    if (navigator.platform.toLowerCase().startsWith("win")) {
      emeUIEnabled = emeUIEnabled && parseFloat(Services.sysinfo.get("version")) >= 6;
    }
    if (!emeUIEnabled) {
      // Don't want to rely on .hidden for the toplevel groupbox because
      // of the pane hiding/showing code potentially interfering:
      document.getElementById("drmGroup").setAttribute("style", "display: none !important");
    }
  },

  // UTILITY FUNCTIONS

  /**
   * Utility function to enable/disable the button specified by aButtonID based
   * on the value of the Boolean preference specified by aPreferenceID.
   */
  updateButtons: function (aButtonID, aPreferenceID)
  {
    var button = document.getElementById(aButtonID);
    var preference = document.getElementById(aPreferenceID);
    button.disabled = preference.value != true;
    return undefined;
  },

  // BEGIN UI CODE

  /*
   * Preferences:
   *
   * dom.disable_open_during_load
   * - true if popups are blocked by default, false otherwise
   */

  // NOTIFICATIONS

  /**
   * Displays the notifications exceptions dialog where specific site notification
   * preferences can be set.
   */
  showNotificationExceptions()
  {
    let bundlePreferences = document.getElementById("bundlePreferences");
    let params = { permissionType: "desktop-notification" };
    params.windowTitle = bundlePreferences.getString("notificationspermissionstitle");
    params.introText = bundlePreferences.getString("notificationspermissionstext4");

    gSubDialog.open("chrome://browser/content/preferences/permissions.xul",
                    "resizable=yes", params);
  },


  // POP-UPS

  /**
   * Displays the popup exceptions dialog where specific site popup preferences
   * can be set.
   */
// Disable Javascript & Block Images Feature Dont Remove
  showPopupExceptions: function ()
  {
    var bundlePreferences = document.getElementById("bundlePreferences");
    var params = { blockVisible: false, sessionVisible: false, allowVisible: true,
                   prefilledHost: "", permissionType: "popup" }
    params.windowTitle = bundlePreferences.getString("popuppermissionstitle");
    params.introText = bundlePreferences.getString("popuppermissionstext");

    gSubDialog.open("chrome://browser/content/preferences/permissions.xul",
                    "resizable=yes", params);
  },

  // IMAGES

  /**
   * Converts the value of the permissions.default.image preference into a
   * Boolean value for use in determining the state of the "load images"
   * checkbox, returning true if images should be loaded and false otherwise.
   */
  readLoadImages: function ()
  {
    var pref = document.getElementById("permissions.default.image");
    return (pref.value == 1 || pref.value == 3);
  },

  /**
   * Returns the "load images" preference value which maps to the state of the
   * preferences UI.
   */
  writeLoadImages: function ()
  { 
    return (document.getElementById("loadImages").checked) ? 1 : 2;
  },

  /**
   * Displays image exception preferences for which websites can and cannot
   * load images.
   */
  showImageExceptions: function ()
  {
    var bundlePreferences = document.getElementById("bundlePreferences");
    var params = { 
					blockVisible: true, 
					sessionVisible: false, 
					allowVisible: true,
					prefilledHost: "", 
					permissionType: "image"};
    params.windowTitle = bundlePreferences.getString("imagepermissionstitle");
    params.introText = bundlePreferences.getString("imagepermissionstext");

    gSubDialog.open("chrome://browser/content/preferences/permissions.xul", 
                    null, params);
  },

  // JAVASCRIPT

  /**
   * Displays the advanced JavaScript preferences for enabling or disabling
   * various annoying behaviors.
   */
  showAdvancedJS: function ()
  {
    gSubDialog.open("chrome://browser/content/preferences/advanced-scripts.xul", 
                    "resizable=no", null);  
  },
//End Disable Javascript & Block Images Feature Dont Remove
  // FONTS

  /**
   * Populates the default font list in UI.
   */
  _rebuildFonts: function ()
  {
    var preferences = document.getElementById("contentPreferences");
    // Ensure preferences are "visible" to ensure bindings work.
    preferences.hidden = false;
    // Force flush:
    preferences.clientHeight;
    var langGroupPref = document.getElementById("font.language.group");
    this._selectDefaultLanguageGroup(langGroupPref.value,
                                     this._readDefaultFontTypeForLanguage(langGroupPref.value) == "serif");
  },

  /**
   * 
   */
  _selectDefaultLanguageGroup: function (aLanguageGroup, aIsSerif)
  {
    const kFontNameFmtSerif         = "font.name.serif.%LANG%";
    const kFontNameFmtSansSerif     = "font.name.sans-serif.%LANG%";
    const kFontNameListFmtSerif     = "font.name-list.serif.%LANG%";
    const kFontNameListFmtSansSerif = "font.name-list.sans-serif.%LANG%";
    const kFontSizeFmtVariable      = "font.size.variable.%LANG%";

    var preferences = document.getElementById("contentPreferences");
    var prefs = [{ format   : aIsSerif ? kFontNameFmtSerif : kFontNameFmtSansSerif,
                   type     : "fontname",
                   element  : "defaultFont",
                   fonttype : aIsSerif ? "serif" : "sans-serif" },
                 { format   : aIsSerif ? kFontNameListFmtSerif : kFontNameListFmtSansSerif,
                   type     : "unichar",
                   element  : null,
                   fonttype : aIsSerif ? "serif" : "sans-serif" },
                 { format   : kFontSizeFmtVariable,
                   type     : "int",
                   element  : "defaultFontSize",
                   fonttype : null }];
    for (var i = 0; i < prefs.length; ++i) {
      var preference = document.getElementById(prefs[i].format.replace(/%LANG%/, aLanguageGroup));
      if (!preference) {
        preference = document.createElement("preference");
        var name = prefs[i].format.replace(/%LANG%/, aLanguageGroup);
        preference.id = name;
        preference.setAttribute("name", name);
        preference.setAttribute("type", prefs[i].type);
        preferences.appendChild(preference);
      }

      if (!prefs[i].element)
        continue;

      var element = document.getElementById(prefs[i].element);
      if (element) {
        element.setAttribute("preference", preference.id);

        if (prefs[i].fonttype)
          FontBuilder.buildFontList(aLanguageGroup, prefs[i].fonttype, element);

        preference.setElementValue(element);
      }
    }
  },

  /**
   * Returns the type of the current default font for the language denoted by
   * aLanguageGroup.
   */
  _readDefaultFontTypeForLanguage: function (aLanguageGroup)
  {
    const kDefaultFontType = "font.default.%LANG%";
    var defaultFontTypePref = kDefaultFontType.replace(/%LANG%/, aLanguageGroup);
    var preference = document.getElementById(defaultFontTypePref);
    if (!preference) {
      preference = document.createElement("preference");
      preference.id = defaultFontTypePref;
      preference.setAttribute("name", defaultFontTypePref);
      preference.setAttribute("type", "string");
      preference.setAttribute("onchange", "gContentPane._rebuildFonts();");
      document.getElementById("contentPreferences").appendChild(preference);
    }
    return preference.value;
  },

  /**
   * Displays the fonts dialog, where web page font names and sizes can be
   * configured.
   */
  configureFonts: function ()
  {
    gSubDialog.open("chrome://browser/content/preferences/fonts.xul", "resizable=no");
  },

  /**
   * Displays the colors dialog, where default web page/link/etc. colors can be
   * configured.
   */
  configureColors: function ()
  {
    gSubDialog.open("chrome://browser/content/preferences/colors.xul", "resizable=no");
  },

  // LANGUAGES

  /**
   * Shows a dialog in which the preferred language for web content may be set.
   */
  showLanguages: function ()
  {
    gSubDialog.open("chrome://browser/content/preferences/languages.xul");
  },

  /**
   * Displays the translation exceptions dialog where specific site and language
   * translation preferences can be set.
   */
  showTranslationExceptions: function ()
  {
    gSubDialog.open("chrome://browser/content/preferences/translation.xul");
  },

  openTranslationProviderAttribution: function ()
  {
    Components.utils.import("resource:///modules/translation/Translation.jsm");
    Translation.openProviderAttribution();
  },

  toggleDoNotDisturbNotifications: function (event)
  {
    AlertsServiceDND.manualDoNotDisturb = event.target.checked;
  },
  
  // Grab current set locale from 'general.useragent.locale'
  updateDefaultLocale: function ()
  {
	  document.getElementById("languageMenu").value = Services.prefs.getCharPref('general.useragent.locale');
  },
  setDefaultLocale: function ()
  {	  
	  var languageMenu = document.getElementById("languageMenu");
	  var currentLocale = Services.prefs.getCharPref('general.useragent.locale');
		function revertChange(error) {
			languageMenu.value = Services.prefs.getCharPref('general.useragent.locale');
			if (error) {
			  Cu.reportError("Failed to reset localization selection: " + error);
			}
		}		
		// Don't fire on same value
		if (currentLocale === languageMenu.value) return;

	  var button_index = confirmRestartPrompt(languageMenu.value,
                                              0, false, true);
      switch (button_index) {
        case CONFIRM_RESTART_PROMPT_CANCEL:
          revertChange();
          return;
        case CONFIRM_RESTART_PROMPT_RESTART_NOW:
          const Cc = Components.classes, Ci = Components.interfaces;
          var cancelQuit = Cc["@mozilla.org/supports-PRBool;1"]
                             .createInstance(Ci.nsISupportsPRBool);
          Services.obs.notifyObservers(cancelQuit, "quit-application-requested",
                                        "restart");
          if (!cancelQuit.data) {
            Services.prefs.setCharPref('general.useragent.locale', languageMenu.value);
			Services.startup.quit(Ci.nsIAppStartup.eAttemptQuit |  Ci.nsIAppStartup.eRestart);
            return;
          }
          // Revert the value in case we didn't quit
          revertChange();
          return;
        case CONFIRM_RESTART_PROMPT_RESTART_LATER:
          Services.prefs.setCharPref('general.useragent.locale', languageMenu.value);
          return;
      }  
  },
    _setDefaultLocale: function (e)
  {
    if (e.which == 13 || e.keyCode == 13)
		this.setDefaultLocale();
  },
};
