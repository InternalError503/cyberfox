/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// IndexedDB storage constants.
const DATABASE_NAME = "abouthome";
const DATABASE_VERSION = 1;

// This global tracks if the page has been set up before, to prevent double inits
let gInitialized = false;
let gObserver = new MutationObserver(function (mutations) {
  for (let mutation of mutations) {
    if (mutation.attributeName == "searchEngineName") {
      setupSearchEngine();
      if (!gInitialized) {
        gInitialized = true;
      }
      return;
    }
  }
});

window.addEventListener("pageshow", function () {
  // Delay search engine setup, cause browser.js::BrowserOnAboutPageLoad runs
  // later and may use asynchronous getters.
  window.gObserver.observe(document.documentElement, { attributes: true });
  fitToWidth();
  window.addEventListener("resize", fitToWidth);

  // Ask chrome to update snippets.
  var event = new CustomEvent("AboutHomeLoad", {bubbles:true});
  document.dispatchEvent(event);
});

window.addEventListener("pagehide", function() {
  window.gObserver.disconnect();
  window.removeEventListener("resize", fitToWidth);
});

function onSearchSubmit(aEvent)
{
  let searchText = document.getElementById("searchText");
  let searchTerms = searchText.value;
  let engineName = document.documentElement.getAttribute("searchEngineName");

  if (engineName && searchTerms.length > 0) {
    // Send an event that will perform a search and Firefox Health Report will
    // record that a search from about:home has occurred.

    let eventData = {
      engineName: engineName,
      searchTerms: searchTerms
    };

    if (searchText.hasAttribute("selection-index")) {
      eventData.selection = {
        index: searchText.getAttribute("selection-index"),
        kind: searchText.getAttribute("selection-kind")
      };
    }

    eventData = JSON.stringify(eventData);

    let event = new CustomEvent("AboutHomeSearchEvent", {detail: eventData});
    document.dispatchEvent(event);
  }

  gSearchSuggestionController.addInputValueToFormHistory();

  if (aEvent) {
    aEvent.preventDefault();
  }
}


let gSearchSuggestionController;

function setupSearchEngine()
{
  // The "autofocus" attribute doesn't focus the form element
  // immediately when the element is first drawn, so the
  // attribute is also used for styling when the page first loads.
  let searchText = document.getElementById("searchText");
  searchText.addEventListener("blur", function searchText_onBlur() {
    searchText.removeEventListener("blur", searchText_onBlur);
    searchText.removeAttribute("autofocus");
  });
 
  let searchEngineName = document.documentElement.getAttribute("searchEngineName");
  let searchEngineInfo = searchEngineName;
  let logoElt = document.getElementById("searchEngineLogo");

  // Add search engine logo.
  if (searchEngineInfo && searchEngineInfo.image) {
    logoElt.parentNode.hidden = false;
    logoElt.src = searchEngineInfo.image;
    logoElt.alt = searchEngineName;
    searchText.placeholder = "";
  }
  else {
    logoElt.parentNode.hidden = true;
    searchText.placeholder = searchEngineName;
  }

  if (!gSearchSuggestionController) {
    gSearchSuggestionController =
      new SearchSuggestionUIController(searchText, searchText.parentNode,
                                       onSearchSubmit);
  }
  gSearchSuggestionController.engineName = searchEngineName;
}

function fitToWidth() {
  if (window.scrollMaxX) {
    document.body.setAttribute("narrow", "true");
  } else if (document.body.hasAttribute("narrow")) {
    document.body.removeAttribute("narrow");
    fitToWidth();
  }
}
