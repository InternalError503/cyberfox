if ("undefined" == typeof (gDownloadsCustom)) {var gDownloadsCustom = {};};
if (!gDownloadsCustom) {gDownloadsCustom = {};};

var gDownloadsCustom = {

init: function(e){

gDownloadsCustom.onSearch = function(searchFilter) {
  if (this._searchTerm != searchFilter) {
    for (let element of document.getElementById("downloadsRichListBox").childNodes) {
      element.hidden = !element._shell.matchesSearchTerm(searchFilter);
    }
   
  }
  return this._searchTerm = searchFilter;
}	
	
	}
	
}
window.addEventListener("load", function () {
	window.removeEventListener("load", gDownloadsCustom.init(), false);	
	gDownloadsCustom.init(); 
}, false);