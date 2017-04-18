/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

 //Since the beta does not have a release notes page we will disable this.
pref("startup.homepage_override_url","");
pref("startup.homepage_welcome_url","");
pref("startup.homepage_welcome_url.additional", "");

//We have no manual update url.
pref("app.update.url.manual", ""); 
pref("app.update.url.details", "");

pref("app.update.check.url", "https://download.8pecxstudios.com/current_version/update.json");
// app.update.channel.type:
// release  current release channel version
// beta current beta channel version (Note: only if applicable meaning only if beta version is release with this setting enabled)
// esr current esr channel version (Note: only if applicable meaning only if we release cyberfox esr with this setting enabled)
pref("app.update.channel.type", "beta");
//Set if update available
pref("app.update.available", false);

 //Since the beta does not have a release notes page we will disable this.
pref("app.releaseNotesURL", "https://github.com/InternalError503/cyberfox-beta/releases");
pref("app.vendorURL", "https://8pecxstudios.com/");

//Disable default browser we don't want beta versions as default browser!.
pref("browser.shell.checkDefaultBrowser", false);

// Number of usages of the web console or scratchpad.
// If this is less than 5, then pasting code into the web console or scratchpad is disabled
pref("devtools.selfxss.count", 0);