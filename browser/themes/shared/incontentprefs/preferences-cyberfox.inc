/* header */

.header {
  margin-bottom: 15px;
}

.header-icon {
  width: 40px;
  max-height: 40px;
  margin-inline-end: 20px;
  list-style-image: url("chrome://global/skin/in-content/header.png");
}

.header-name {
  font-size: 2.5rem;
  font-weight: normal;
  line-height: 40px;
  margin: 0;
}

#header-general > .header-icon {
  -moz-image-region: rect(0, 40px, 40px, 0);
}

#header-content > .header-icon {
  -moz-image-region: rect(0, 80px, 40px, 40px);
}

#header-search > .header-icon {
  -moz-image-region: rect(0, 320px, 40px, 280px);
}

#header-application > .header-icon {
  -moz-image-region: rect(0, 120px, 40px, 80px);
}

#header-privacy > .header-icon {
  -moz-image-region: rect(0, 160px, 40px, 120px);
}

#header-security > .header-icon {
  -moz-image-region: rect(0, 200px, 40px, 160px);
}

#header-sync > .header-icon {
  -moz-image-region: rect(0, 240px, 40px, 200px);
}

#header-advanced > .header-icon {
  -moz-image-region: rect(0, 280px, 40px, 240px);
}

@media (min-resolution: 2dppx) {
  .header-icon {
    list-style-image: url("chrome://global/skin/in-content/header@2x.png");
  }

  #header-general > .header-icon {
    -moz-image-region: rect(0, 80px, 80px, 0);
  }

  #header-content > .header-icon {
    -moz-image-region: rect(0, 160px, 80px, 80px);
  }

#header-search > .header-icon {
  -moz-image-region: rect(0, 640px, 80px, 560px);
}  
  
  #header-application > .header-icon {
    -moz-image-region: rect(0, 240px, 80px, 160px);
  }

  #header-privacy > .header-icon {
    -moz-image-region: rect(0, 320px, 80px, 240px);
  }

  #header-security > .header-icon {
    -moz-image-region: rect(0, 400px, 80px, 320px);
  }

  #header-sync > .header-icon {
    -moz-image-region: rect(0, 480px, 80px, 400px);
  }

  #header-advanced > .header-icon {
    -moz-image-region: rect(0, 560px, 80px, 480px);
  }
}

/* buttons and menulists */

button,
menulist {
  -moz-appearance: none;
  height: 30px;
  color: #737980;
  line-height: 20px;
  text-shadow: 0 1px 1px #FEFFFE;
  border: 1px solid rgba(23,50,77,0.4);
  -moz-border-top-colors: none !important;
  -moz-border-right-colors: none !important;
  -moz-border-bottom-colors: none !important;
  -moz-border-left-colors: none !important;
  border-radius: 5px;
  box-shadow: 0 1px 1px 0 #FFFFFF, inset 0 2px 2px 0 #FFFFFF;
  background-color: #F1F1F1;
  background-image: linear-gradient(#FFFFFF, rgba(255,255,255,0.1));
}

button:not([disabled="true"]):hover,
menulist:not([disabled="true"]):hover {
  background-image: linear-gradient(#FFFFFF, rgba(255,255,255,0.6));
}

button:not([disabled="true"]):hover:active,
menulist[open="true"]:not([disabled="true"]) {
  background-image: linear-gradient(rgba(255,255,255,0.1),
                                    rgba(255,255,255,0.6));
}

button[disabled="true"],
menulist[disabled="true"] {
  background-image: linear-gradient(rgba(255,255,255,0.5),
                                    rgba(255,255,255,0.1));
  border-color: rgba(23,50,77,0.25);
  color: rgba(115,121,128,0.5);
  text-shadow: 0 1px 1px #FFFFFF;
}

button > .button-box,
menulist > .menulist-label-box {
  padding-right: 10px !important;
  padding-left: 10px !important;
}

/* Captions */

caption {
  -moz-appearance: none;
  margin: 0;
  color:#424E5A;
}

caption > label {
  font-size: 1.3rem;
  font-weight: bold;
  line-height: 22px;
  margin: 0 !important;
}

/* textboxes */

textbox {
  -moz-appearance: none;
  height: 30px;
  color: #737980;
  line-height: 20px;
  text-shadow: 0 1px 1px #FEFFFE;
  padding-right: 10px;
  padding-left: 10px;
  border: 1px solid rgba(23,50,77,0.4);
  -moz-border-top-colors: none !important;
  -moz-border-right-colors: none !important;
  -moz-border-bottom-colors: none !important;
  -moz-border-left-colors: none !important;
  border-radius: 5px;
  box-shadow: 0 1px 1px 0 #FFFFFF, inset 0 2px 2px 0 rgba(0,0,0,0.03);
  background-color: #F1F1F1;
  background-image: linear-gradient(#FFFFFF, rgba(255,255,255,0.8));
}

textbox[focused] {
  color: #424E5A;
  border-color: #0096DC;
  box-shadow: 0 0 2px 2px rgba(0,150,220,0.35), inset 0 0 2px 0 #0096DC;
}

textbox[disabled="true"] {
  color: rgba(115,121,128,0.5);
  border-color: rgba(23,50,77,0.25);
  background-image: linear-gradient(rgba(255,255,255,0.5), rgba(255,255,255,0.4));
}

/* Links */

.text-link,
.inline-link,
html|a.inline-link {
  font-size: 1.25rem;
  line-height: 22px;
  color: #0096DC;
}

.text-link:hover,
.inline-link:hover {
  color: #4CB1FF;
  text-decoration: none;
}

.text-link:hover:active,
.inline-link:hover:active {
  color: #FF9500;
  text-decoration: none;
}

/* Checkbox border */
.checkbox-check[checked] {
  border-color: #0096dc;
  box-shadow: 0 0 2px 2px rgba(0,150,220,0.35), inset 0 0 2px 0 #0096dc;
}