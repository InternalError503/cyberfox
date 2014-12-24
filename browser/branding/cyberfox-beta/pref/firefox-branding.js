/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

pref("startup.homepage_override_url","https://8pecxstudios.com/hooray-your-cyberfox-is-up-to-date-%VERSION%");
pref("startup.homepage_welcome_url","https://8pecxstudios.com/hooray-your-cyberfox-is-up-to-date-%VERSION%");

//We have no manual update url.
pref("app.update.url.manual", ""); 
pref("app.update.url.details", "");

pref("app.update.check.url", "http://download.8pecxstudios.com/current_version/update.json");
// app.update.channel.type:
// release  current release channel version
// beta current beta channel version (Note: only if applicable meaning only if beta version is release with this setting enabled)
// esr current esr channel version (Note: only if applicable meaning only if we release cyberfox esr with this setting enabled)
pref("app.update.channel.type", "beta");

//Disable update check beta versions not added yet!
pref("app.update.autocheck", false);

//Disable check browser version (Since we are not ready globally disable)
pref("app.update.check.enabled", false);

pref("app.releaseNotesURL", "https://8pecxstudios.com/hooray-your-cyberfox-is-up-to-date-%VERSION%");
pref("app.vendorURL", "https://8pecxstudios.com/");

//Disable default browser we don't want beta versions as default browser!.
pref("browser.shell.checkDefaultBrowser", false);

//Disable the OpenH264 plug-in support in the addon manager.
pref("media.gmp-gmpopenh264.provider.enabled", false);

// Number of usages of the web console or scratchpad.
// If this is less than 5, then pasting code into the web console or scratchpad is disabled
pref("devtools.selfxss.count", 0);