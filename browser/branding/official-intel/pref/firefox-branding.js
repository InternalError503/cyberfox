/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

pref("startup.homepage_override_url","https://cyberfox.8pecxstudios.com/hooray-your-cyberfox-is-up-to-date?version=%VERSION%&oldversion=%OLD_VERSION%");
pref("startup.homepage_welcome_url","https://cyberfox.8pecxstudios.com/hooray-your-cyberfox-is-up-to-date?version=%VERSION%");
pref("startup.homepage_welcome_url.additional", "");

pref("app.update.url.manual", "https://cyberfox.8pecxstudios.com#selection"); 
pref("app.update.url.details", "https://cyberfox.8pecxstudios.com#selection");

pref("app.update.check.url", "https://download.8pecxstudios.com/current_version/update.json");
// app.update.channel.type:
// release  current release channel version
// beta current beta channel version (Note: only if applicable meaning only if beta version is release with this setting enabled)
// esr current esr channel version (Note: only if applicable meaning only if we release cyberfox esr with this setting enabled)
pref("app.update.channel.type", "release");
//Set if update available
pref("app.update.available", false);


pref("app.releaseNotesURL", "https://cyberfox.8pecxstudios.com/hooray-your-cyberfox-is-up-to-date?version=%VERSION%");
pref("app.vendorURL", "https://8pecxstudios.com/");

// Number of usages of the web console or scratchpad.
// If this is less than 5, then pasting code into the web console or scratchpad is disabled
pref("devtools.selfxss.count", 0);