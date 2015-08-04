#ifdef 0
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */
#endif

let gCustomize = {
  _nodeIDSuffixes: [
    "blank",
    "button",
    "classic",
    "panel",
    "overlay"
  ],

  _nodes: {},

  init: function() {
    for (let idSuffix of this._nodeIDSuffixes) {
      this._nodes[idSuffix] = document.getElementById("newtab-customize-" + idSuffix);
    }

    this._nodes.button.addEventListener("click", e => this.showPanel());
    this._nodes.blank.addEventListener("click", e => {
      gAllPages.enabled = false;
    });
    this._nodes.classic.addEventListener("click", e => {
      gAllPages.enabled = true;
    });

    this.updateSelected();
  },

  _onHidden: function() {
    let nodes = gCustomize._nodes;
    nodes.overlay.addEventListener("transitionend", function onTransitionEnd() {
      nodes.overlay.removeEventListener("transitionend", onTransitionEnd);
      nodes.overlay.style.display = "none";
    });
    nodes.overlay.style.opacity = 0;
    nodes.panel.removeEventListener("popuphidden", gCustomize._onHidden);
    nodes.panel.hidden = true;
    nodes.button.removeAttribute("active");
  },

  showPanel: function() {
    this._nodes.overlay.style.display = "block";
    setTimeout(() => {
      // Wait for display update to take place, then animate.
      this._nodes.overlay.style.opacity = 0.8;
    }, 0);

    let nodes = this._nodes;
    let {button, panel} = nodes;
    if (button.hasAttribute("active")) {
      return Promise.resolve(nodes);
    }

    panel.hidden = false;
    panel.openPopup(button);
    button.setAttribute("active", true);
    panel.addEventListener("popuphidden", this._onHidden);

    return new Promise(resolve => {
      panel.addEventListener("popupshown", function onShown() {
        panel.removeEventListener("popupshown", onShown);
        resolve(nodes);
      });
    });
  },

  updateSelected: function() {
    let {enabled} = gAllPages;
    let selected = enabled ? "classic" : "blank";
    ["classic", "blank"].forEach(id => {
      let node = this._nodes[id];
      if (id == selected) {
        node.setAttribute("selected", true);
      }
      else {
        node.removeAttribute("selected");
      }
    });
  },
};
