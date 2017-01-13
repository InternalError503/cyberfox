/* - This Source Code Form is subject to the terms of the Mozilla Public
   - License, v. 2.0. If a copy of the MPL was not distributed with this file,
   - You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";
var Cc = Components.classes;
var Ci = Components.interfaces;
var Cu = Components.utils;
var Cr = Components.results;
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/AppConstants.jsm");

// Put up a confirm dialog with "ok to restart", "revert without restarting"
// and "restart later" buttons and returns the index of the button chosen.
// We can choose not to display the "restart later", or "revert" buttons,
// altough the later still lets us revert by using the escape key.
//
// The constants are useful to interpret the return value of the function.
const CONFIRM_RESTART_PROMPT_RESTART_NOW = 0;
const CONFIRM_RESTART_PROMPT_CANCEL = 1;
const CONFIRM_RESTART_PROMPT_RESTART_LATER = 2;
function confirmRestartPrompt(aRestartToEnable, aDefaultButtonIndex,
                              aWantRevertAsCancelButton,
			      aWantRestartLaterButton) {
  let brandName = document.getElementById("bundleBrand").getString("brandShortName");
  let bundle = document.getElementById("bundlePreferences");
  let msg = bundle.getFormattedString(aRestartToEnable ?
                                      "featureEnableRequiresRestart" :
                                      "featureDisableRequiresRestart",
                                      [brandName]);
  let title = bundle.getFormattedString("shouldRestartTitle", [brandName]);
  let prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"].getService(Ci.nsIPromptService);

  // Set up the first (index 0) button:
  let button0Text = bundle.getFormattedString("okToRestartButton", [brandName]);
  let buttonFlags = (Services.prompt.BUTTON_POS_0 *
                     Services.prompt.BUTTON_TITLE_IS_STRING);


  // Set up the second (index 1) button:
  let button1Text = null;
  if (aWantRevertAsCancelButton) {
    button1Text = bundle.getString("revertNoRestartButton");
    buttonFlags += (Services.prompt.BUTTON_POS_1 *
                    Services.prompt.BUTTON_TITLE_IS_STRING);
  } else {
    buttonFlags += (Services.prompt.BUTTON_POS_1 *
                    Services.prompt.BUTTON_TITLE_CANCEL);
  }

  // Set up the third (index 2) button:
  let button2Text = null;
  if (aWantRestartLaterButton) {
    button2Text = bundle.getString("restartLater");
    buttonFlags += (Services.prompt.BUTTON_POS_2 *
                    Services.prompt.BUTTON_TITLE_IS_STRING);
  }

  switch (aDefaultButtonIndex) {
    case 0:
      buttonFlags += Services.prompt.BUTTON_POS_0_DEFAULT;
      break;
    case 1:
      buttonFlags += Services.prompt.BUTTON_POS_1_DEFAULT;
      break;
    case 2:
      buttonFlags += Services.prompt.BUTTON_POS_2_DEFAULT;
      break;
    default:
      break;
  }

  let buttonIndex = prompts.confirmEx(window, title, msg, buttonFlags,
                                      button0Text, button1Text, button2Text,
                                      null, {});

  // If we have the second confirmation dialog for restart, see if the user
  // cancels out at that point.
  if (buttonIndex == CONFIRM_RESTART_PROMPT_RESTART_NOW) {
    let cancelQuit = Cc["@mozilla.org/supports-PRBool;1"]
                       .createInstance(Ci.nsISupportsPRBool);
    Services.obs.notifyObservers(cancelQuit, "quit-application-requested",
                                  "restart");
    if (cancelQuit.data) {
      buttonIndex = CONFIRM_RESTART_PROMPT_CANCEL;
    }
  }
  return buttonIndex;
}
