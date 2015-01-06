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

	//Clones current tab into new tab or window.
	CloneCurrent : function(type) {
	
	try{

			if (gURLBar.value){
					gBrowser.selectedTab = openUILinkIn(gURLBar.value, type);		
			}
			
		}catch (type){
			//Catch any nasty errors and output to console
			console.log("Were sorry but something has gone wrong with 'CloneCurrent' " + type +" " + e);

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
	
	_ElementState :  function (element, state){
	
	try{	
	
			if (!typeof true || !typeof false){return;}
			document.getElementById(element).hidden = state;
			
		}catch (e){
				//Catch any nasty errors and output to console
				console.log("Were sorry but something has gone wrong with '_ElementState' " + e);
		}			 
  },

customPrefSettings: function(e){
		
document.getElementById("tabContextMenu")
        .addEventListener("popupshowing", function (e) {
		
	try{
						
		//C.L.O.N.E
		if (Services.prefs.getBoolPref("browser.tabs.clonetab")){		
				gCyberfoxCustom._ElementState("context_CloneCurrentTab", false);
				gCyberfoxCustom._ElementState("context_CloneCurrentTabNewWindow", false);	
		}else{
				gCyberfoxCustom._ElementState("context_CloneCurrentTab", true);
				gCyberfoxCustom._ElementState("context_CloneCurrentTabNewWindow", true);
		}
		//Copy tab url
		if (Services.prefs.getBoolPref("browser.tabs.copyurl")){
				gCyberfoxCustom._ElementState("context_CopyCurrentTabUrl", false);
		}else{
				gCyberfoxCustom._ElementState("context_CopyCurrentTabUrl", true);
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
				gCyberfoxCustom._ElementState("context-sendLink", false);
		}else{
				gCyberfoxCustom._ElementState("context-sendLink", true);
		}
		
	}catch (e){
		//Catch any nasty errors and output to console
		console.log("Were sorry but something has gone wrong with 'browser.context.emaillink' " + e);
	}
	
  
  }, false);  

		
document.getElementById("menu_ToolsPopup")
        .addEventListener("popupshowing", function (e) {

	try{		
			
		//R.A.M
		if (Services.prefs.getBoolPref("clean.ram.cache")){
				gCyberfoxCustom._ElementState("minimizeMemoryUsage", false);
		}else{
				gCyberfoxCustom._ElementState("minimizeMemoryUsage", true);
		}
	
	}catch (e){
		//Catch any nasty errors and output to console
		console.log("Were sorry but something has gone wrong with 'clean.ram.cache' " + e);
	}	
			
  }, false);
  
document.getElementById("menu_FilePopup")
        .addEventListener("popupshowing", function (e) {

	try{		
			
		//R.M.F	
		if (Services.prefs.getBoolPref("browser.restart.enabled")){ 
				gCyberfoxCustom._ElementState("app_restartBrowser", false);
		}else{
				gCyberfoxCustom._ElementState("app_restartBrowser", true);
		}
	
	}catch (e){
		//Catch any nasty errors and output to console
		console.log("Were sorry but something has gone wrong with 'browser.restart.enabled' " + e);
	}	
			
  }, false);  
  
 document.getElementById("toolbar-context-menu")
        .addEventListener("popupshowing", function (e) {

	try{		
			
		//About:config
		if (Services.prefs.getBoolPref("browser.context.aboutconfig")){ 
				gCyberfoxCustom._ElementState("menu-aboutconfig", false);
		}else{
				gCyberfoxCustom._ElementState("menu-aboutconfig", true);
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
				gCyberfoxCustom._ElementState("AboutConfigMenuItem", false);
		}else{
				gCyberfoxCustom._ElementState("AboutConfigMenuItem", true);
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