/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = [
  "Translation",
];

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;

const TRANSLATION_PREF_SHOWUI = "browser.translation.ui.show";
const TRANSLATION_PREF_DETECT_LANG = "browser.translation.detectLanguage";

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Promise.jsm");
Cu.import("resource://gre/modules/Task.jsm", this);

this.Translation = {
  STATE_OFFER: 0,
  STATE_TRANSLATING: 1,
  STATE_TRANSLATED: 2,
  STATE_ERROR: 3,
  STATE_UNAVAILABLE: 4,

  serviceUnavailable: false,

  supportedSourceLanguages: ["bg", "cs", "de", "en", "es", "fr", "ja", "ko", "nl", "no", "pl", "pt", "ru", "tr", "vi", "zh"],
  supportedTargetLanguages: ["bg", "cs", "de", "en", "es", "fr", "ja", "ko", "nl", "no", "pl", "pt", "ru", "tr", "vi", "zh"],

  _defaultTargetLanguage: "",
  get defaultTargetLanguage() {
    if (!this._defaultTargetLanguage) {
      this._defaultTargetLanguage = Cc["@mozilla.org/chrome/chrome-registry;1"]
                                      .getService(Ci.nsIXULChromeRegistry)
                                      .getSelectedLocale("global")
                                      .split("-")[0];
    }
    return this._defaultTargetLanguage;
  },

  documentStateReceived: function(aBrowser, aData) {
    if (aData.state == this.STATE_OFFER) {
      if (aData.detectedLanguage == this.defaultTargetLanguage) {
        // Detected language is the same as the user's locale.
        return;
      }

      if (this.supportedSourceLanguages.indexOf(aData.detectedLanguage) == -1) {
        return;
      }

    }

    if (!Services.prefs.getBoolPref(TRANSLATION_PREF_SHOWUI))
      return;

    if (!aBrowser.translationUI)
      aBrowser.translationUI = new TranslationUI(aBrowser);
    let trUI = aBrowser.translationUI;

    // Set all values before showing a new translation infobar.
    trUI._state = Translation.serviceUnavailable ? Translation.STATE_UNAVAILABLE
                                                 : aData.state;
    trUI.detectedLanguage = aData.detectedLanguage;
    trUI.translatedFrom = aData.translatedFrom;
    trUI.translatedTo = aData.translatedTo;
    trUI.originalShown = aData.originalShown;

    trUI.showURLBarIcon();

    if (trUI.shouldShowInfoBar(aBrowser.currentURI))
      trUI.showTranslationInfoBar();
  },

  openProviderAttribution: function() {
    let attribution = this.supportedEngines[this.translationEngine];
    Cu.import("resource:///modules/RecentWindow.jsm");
    RecentWindow.getMostRecentBrowserWindow().openUILinkIn(attribution, "tab");
  },

  /**
   * The list of translation engines and their attributions.
   */
  supportedEngines: {
    "bing"    : "http://aka.ms/MicrosoftTranslatorAttribution",
    "yandex"  : "http://translate.yandex.com/"
  },

  /**
   * Fallback engine (currently Bing Translator) if the preferences seem
   * confusing.
   */
  get defaultEngine() {
    return this.supportedEngines.keys[0];
  },

  /**
   * Returns the name of the preferred translation engine.
   */
  get translationEngine() {
    let engine = Services.prefs.getCharPref("browser.translation.engine");
    return Object.keys(this.supportedEngines).indexOf(engine) == -1 ? this.defaultEngine : engine;
  },
};

/* TranslationUI objects keep the information related to translation for
 * a specific browser.  This object is passed to the translation
 * infobar so that it can initialize itself.  The properties exposed to
 * the infobar are:
 * - detectedLanguage, code of the language detected on the web page.
 * - state, the state in which the infobar should be displayed
 * - translatedFrom, if already translated, source language code.
 * - translatedTo, if already translated, target language code.
 * - translate, method starting the translation of the current page.
 * - showOriginalContent, method showing the original page content.
 * - showTranslatedContent, method showing the translation for an
 *   already translated page whose original content is shown.
 * - originalShown, boolean indicating if the original or translated
 *   version of the page is shown.
 */
function TranslationUI(aBrowser) {
  this.browser = aBrowser;
}

TranslationUI.prototype = {
  get browser() {
    return this._browser;
  },
  set browser(aBrowser) {
    if (this._browser)
      this._browser.messageManager.removeMessageListener("Translation:Finished", this);
    aBrowser.messageManager.addMessageListener("Translation:Finished", this);
    this._browser = aBrowser;
  },
  translate: function(aFrom, aTo) {
    if (aFrom == aTo ||
        (this.state == Translation.STATE_TRANSLATED &&
         this.translatedFrom == aFrom && this.translatedTo == aTo)) {
      // Nothing to do.
      return;
    }

    this.state = Translation.STATE_TRANSLATING;
    this.translatedFrom = aFrom;
    this.translatedTo = aTo;

    this.browser.messageManager.sendAsyncMessage(
      "Translation:TranslateDocument",
      { from: aFrom, to: aTo }
    );
  },

  showURLBarIcon: function() {
    let chromeWin = this.browser.ownerGlobal;
    let PopupNotifications = chromeWin.PopupNotifications;
    let removeId = this.originalShown ? "translated" : "translate";
    let notification =
      PopupNotifications.getNotification(removeId, this.browser);
    if (notification)
      PopupNotifications.remove(notification);

    let callback = (aTopic, aNewBrowser) => {
      if (aTopic == "swapping") {
        let infoBarVisible =
          this.notificationBox.getNotificationWithValue("translation");
        aNewBrowser.translationUI = this;
        this.browser = aNewBrowser;
        if (infoBarVisible)
          this.showTranslationInfoBar();
        return true;
      }

      if (aTopic != "showing")
        return false;
      let translationNotification = this.notificationBox.getNotificationWithValue("translation");
      if (translationNotification)
        translationNotification.close();
      else
        this.showTranslationInfoBar();
      return true;
    };

    let addId = this.originalShown ? "translate" : "translated";
    PopupNotifications.show(this.browser, addId, null,
                            addId + "-notification-icon", null, null,
                            {dismissed: true, eventCallback: callback});
  },

  _state: 0,
  get state() {
    return this._state;
  },
  set state(val) {
    let notif = this.notificationBox.getNotificationWithValue("translation");
    if (notif)
      notif.state = val;
    this._state = val;
  },

  originalShown: true,
  showOriginalContent: function() {
    this.originalShown = true;
    this.showURLBarIcon();
    this.browser.messageManager.sendAsyncMessage("Translation:ShowOriginal");
  },

  showTranslatedContent: function() {
    this.originalShown = false;
    this.showURLBarIcon();
    this.browser.messageManager.sendAsyncMessage("Translation:ShowTranslation");
  },

  get notificationBox() {
    return this.browser.ownerGlobal.gBrowser.getNotificationBox(this.browser);
  },

  showTranslationInfoBar: function() {
    let notificationBox = this.notificationBox;
    let notif = notificationBox.appendNotification("", "translation", null,
                                                   notificationBox.PRIORITY_INFO_HIGH);
    notif.init(this);
    return notif;
  },

  shouldShowInfoBar: function(aURI) {
    // Never show the infobar automatically while the translation
    // service is temporarily unavailable.
    if (Translation.serviceUnavailable)
      return false;

    // Check if we should never show the infobar for this language.
    let neverForLangs =
      Services.prefs.getCharPref("browser.translation.neverForLanguages");
    if (neverForLangs.split(",").indexOf(this.detectedLanguage) != -1) {
      return false;
    }

    // or if we should never show the infobar for this domain.
    let perms = Services.perms;
    if (perms.testExactPermission(aURI, "translate") == perms.DENY_ACTION) {
      return false;
    }

    return true;
  },

  receiveMessage: function(msg) {
    switch (msg.name) {
      case "Translation:Finished":
        if (msg.data.success) {
          this.originalShown = false;
          this.state = Translation.STATE_TRANSLATED;
          this.showURLBarIcon();
        } else if (msg.data.unavailable) {
          Translation.serviceUnavailable = true;
          this.state = Translation.STATE_UNAVAILABLE;
        } else {
          this.state = Translation.STATE_ERROR;
        }
        break;
    }
  }
};
