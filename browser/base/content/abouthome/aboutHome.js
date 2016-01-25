/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// IndexedDB storage constants.
const DATABASE_NAME = "abouthome";
const DATABASE_VERSION = 1;
var searchText;

window.addEventListener("pageshow", function () {
  fitToWidth();
  setupSearch();
  window.addEventListener("resize", fitToWidth);

  // Load complete.
  var event = new CustomEvent("AboutHomeLoad", {bubbles:true});
  document.dispatchEvent(event);
});

window.addEventListener("pagehide", function() {
  window.removeEventListener("resize", fitToWidth);
});

window.addEventListener("keypress", ev => {
  // focus the search-box on keypress
  if (document.activeElement.id == "searchText") // unless already focussed
    return;

  let modifiers = ev.ctrlKey + ev.altKey + ev.metaKey;
  // ignore Ctrl/Cmd/Alt, but not Shift
  // also ignore Tab, Insert, PageUp, etc., and Space
  if (modifiers != 0 || ev.charCode == 0 || ev.charCode == 32)
    return;

  searchText.focus();
  // need to send the first keypress outside the search-box manually to it
  searchText.value += ev.key;
});

function onSearchSubmit(aEvent)
{
  gContentSearchController.search(aEvent);
}


var gContentSearchController;

function setupSearch()
{
  // The "autofocus" attribute doesn't focus the form element
  // immediately when the element is first drawn, so the
  // attribute is also used for styling when the page first loads.
  searchText = document.getElementById("searchText");
  searchText.addEventListener("blur", function searchText_onBlur() {
    searchText.removeEventListener("blur", searchText_onBlur);
    searchText.removeAttribute("autofocus");
  });

  if (!gContentSearchController) {
    gContentSearchController =
      new ContentSearchUIController(searchText, searchText.parentNode,
                                    "abouthome", "homepage");
  }
}

function fitToWidth() {
  if (window.scrollMaxX != window.scrollMinX) {
    document.body.setAttribute("narrow", "true");
  } else if (document.body.hasAttribute("narrow")) {
    document.body.removeAttribute("narrow");
    fitToWidth();
  }
}
