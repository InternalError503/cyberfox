XPCOMUtils.defineLazyGetter(this, "gPrefService", function() {
  return Services.prefs;
});

Cu.import("resource://gre/modules/Services.jsm");


if (typeof gCyberfoxCustom == "undefined") {var gCyberfoxCustom = {};};
if (!gCyberfoxCustom) {gCyberfoxCustom = {};};

let DownloadsWindow = null;	
let params = "resizable=yes,chrome=yes,centerscreen=yes,top=yes,alwaysRaised=no";

var gCyberfoxCustom = {

	restartBrowser: function (e) {	
			//Added in some general error handling by encapsulating it in try catch statements
try{
	//Minified its to fall in-line with restart my fox
	if (Services.prefs.getBoolPref("browser.restart.purgecache")){
		
			Services.appinfo.invalidateCachesOnRestart();
					Cc["@mozilla.org/toolkit/app-startup;1"].getService(Ci.nsIAppStartup).quit(Ci.nsIAppStartup.eRestart | Ci.nsIAppStartup.eAttemptQuit);		
			}else{
					Cc["@mozilla.org/toolkit/app-startup;1"].getService(Ci.nsIAppStartup).quit(Ci.nsIAppStartup.eRestart | Ci.nsIAppStartup.eAttemptQuit);;
	}
			}catch (e){
				//Catch any nasty errors and output to console
				console.log("Were sorry but something has gone wrong with 'restartBrowser' " + e);					
		}
        
},

	//Clones current tab into new tab
	CloneCurrentTab : function(e) {
	
try{

	if (gURLBar.value){
			gBrowser.selectedTab = openUILinkIn(gURLBar.value, 'tab');		
		}else{}
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'CloneCurrentTab' " + e);

	}
},


	//Clones current tab in new window	
	CloneCurrentTabNewWindow : function(e) {
	
try{

	if (gURLBar.value){	
			gBrowser.selectedTab = openUILinkIn(gURLBar.value, 'window');
		}else{}
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'CloneCurrentTabNewWindow' " + e);
	}		
},

	//Copies current tab url to clipboard	
	CopyCurrentTabUrl : function(e) {

try{	
	
	const gClipboardHelper = Components.classes["@mozilla.org/widget/clipboardhelper;1"]
                                   .getService(Components.interfaces.nsIClipboardHelper);
	gClipboardHelper.copyString(content.location.href);
		
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'CopyCurrentTabUrl' " + e);
	}			
},
	
isEnabled: function(element){
	document.getElementById(element).hidden = false;
},	
	
isDisabled: function(element){
	document.getElementById(element).hidden = true;
},	

customPrefSettings: function(e){
		
document.getElementById("tabContextMenu")
        .addEventListener("popupshowing", function (e) {
		
try{
						
	//C.L.O.N.E
	if (Services.prefs.getBoolPref("browser.tabs.clonetab")){		
			gCyberfoxCustom.isEnabled("context_CloneCurrentTab");
			gCyberfoxCustom.isEnabled("context_CloneCurrentTabNewWindow");			
	}else{
			gCyberfoxCustom.isDisabled("context_CloneCurrentTab");
			gCyberfoxCustom.isDisabled("context_CloneCurrentTabNewWindow");
	}
	//Copy tab url
	if (Services.prefs.getBoolPref("browser.tabs.copyurl")){
			gCyberfoxCustom.isEnabled("context_CopyCurrentTabUrl");	
	}else{
			gCyberfoxCustom.isDisabled("context_CopyCurrentTabUrl");
	}
	
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'browser.tabs.clonetab' | browser.tabs.copyurl " + e);
	}
	
  
  }, false);
  
document.getElementById("contentAreaContextMenu")
        .addEventListener("popupshowing", function (e) {
		
try{
						
	//Email link
	if (Services.prefs.getBoolPref("browser.context.emaillink")){		
			gCyberfoxCustom.isEnabled("context-sendLink");		
	}else{
			gCyberfoxCustom.isDisabled("context-sendLink");
	}
	
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'browser.context.emaillink' " + e);
	}
	
  
  }, false);  

		
document.getElementById("menu_ToolsPopup")
        .addEventListener("popupshowing", function (e) {

try{		
			
	//R.M.F	
	if (Services.prefs.getBoolPref("browser.restart.enabled")){ 
			gCyberfoxCustom.isEnabled("app_restartBrowser");
	}else{
			gCyberfoxCustom.isDisabled("app_restartBrowser");
	}
	
	//R.A.M
	if (Services.prefs.getBoolPref("clean.ram.cache")){
			gCyberfoxCustom.isEnabled("minimizeMemoryUsage");
	}else{
			gCyberfoxCustom.isDisabled("minimizeMemoryUsage");
    }
	
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'browser.restart.enabled | clean.ram.cache' " + e);
	}	
			
  }, false);
  
 document.getElementById("toolbar-context-menu")
        .addEventListener("popupshowing", function (e) {

try{		
			
	//About:config
	if (Services.prefs.getBoolPref("browser.context.aboutconfig")){ 
			gCyberfoxCustom.isEnabled("menu-aboutconfig");
	}else{
			gCyberfoxCustom.isDisabled("menu-aboutconfig");
	}
	
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'browser.context.aboutconfig' " + e);
	}	
			
  }, false); 
  
   document.getElementById("menu_viewPopup")
        .addEventListener("popupshowing", function (e) {

try{		
			
	//About:config
	if (Services.prefs.getBoolPref("browser.menu.aboutconfig")){ 
			gCyberfoxCustom.isEnabled("AboutConfigMenuItem");
	}else{
			gCyberfoxCustom.isDisabled("AboutConfigMenuItem");
	}
	
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'browser.menu.aboutconfig' " + e);
	}	
			
  }, false); 
  
},	


	toolsDownloads: function(e){	
	
try{		

	if (Services.prefs.getBoolPref("browser.download.useToolkitUI")) {	
		if(DownloadsWindow == null || DownloadsWindow.closed){
					window.open("chrome://browser/content/downloadUI.xul", "Downloads", params);					
				}else{
						DownloadsWindow.focus();
					}	
	  }else{
		    BrowserDownloadsUI();	  
	  }	  
	 		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'toolsDownloads' " + e);
	} 
},

customDownloadsOverlay: function(e){

try{		
	
	if (Services.prefs.getBoolPref("browser.download.useToolkitUI")) {		
				 	
			if(DownloadsWindow == null || DownloadsWindow.closed){
					window.open("chrome://browser/content/downloadUI.xul", "Downloads", params);
				}else{
						DownloadsWindow.focus();
					}					
	  }else{
		        DownloadsPanel.showDownloadsHistory();  
	  }	

	
		}catch (e){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'customDownloadsOverlay' " + e);
	}	

}	

}	
	
window.addEventListener("load", function () { gCyberfoxCustom.customPrefSettings(); }, false);