/* Cyberfox Config */

/* Tab Close Button Don't remove */
/* Tabstrip close button */
.tabs-closebutton {
  -moz-appearance: none;
  padding: 4px 2px;
  margin: 0px;
  border: none;
}

.tabs-closebutton > .toolbarbutton-icon {
  -moz-margin-end: 0px !important;
  -moz-padding-end: 2px !important;
  -moz-padding-start: 2px !important;
}
/* End Tab Close Button Don't remove */


#appmenu_print,
#menu_print,
#appmenu_print_popup,
.appmenu-edit-button,
#appmenu-editmenu-cut,
#appmenu-editmenu-copy,
#appmenu-editmenu-paste,
#menu_cut,
#menu_copy,
#menu_paste,
#context-cut,
#context-copy,
#context-paste,
#appmenu-quit,
#menu_FileQuitItem {
list-style-image: url("chrome://browser/skin/appmenu-icons.png")!important;
}

#appmenu-cut,
#menu_cut,
#context-cut,
#appmenu-editmenu-cut {
  -moz-image-region: rect(0 16px 16px 0);
}

#appmenu-copy,
#menu_copy,
#context-copy,
#appmenu-editmenu-copy {
  -moz-image-region: rect(0 32px 16px 16px);
}

#appmenu-paste,
#menu_paste,
#context-paste,
#appmenu-editmenu-paste {
  -moz-image-region: rect(0 48px 16px 32px);
}

#appmenu_print,
#menu_print,
#appmenu_print_popup {
  -moz-image-region: rect(0 64px 16px 48px);
}
#appmenu-quit,
#menu_FileQuitItem {
  -moz-image-region: rect(0 80px 16px 64px);
}
/* Begin Cyberfox Config */
#appmenu-editmenu-undo,
#context-undo,
#menu_undo,
#appmenu-editmenu-redo,
#menu_redo,
#appmenu_printPreview,
#menu_printPreview,
#appmenu_savePage,
#menu_savePage,
#context-savelink,
#appmenu_find,
#menu_find,
#context-savepage,
#appmenu_sendLink,
#menu_sendLink,
#context-sendLink,
#appmenu-editmenu-selectAll,
#menu_selectAll,
#context-selectall,
#appmenu-editmenu-delete,
#menu_delete,
#context-delete,
#context-navigation-classic #context-back,
#context-navigation-classic #context-forward,
#context-reload{
  list-style-image: url("chrome://browser/skin/appmenu-icons-cf.png")!important;
}

#appmenu_printPreview,
#menu_printPreview {
  -moz-image-region: rect(0 16px 16px 0);
}

#appmenu-editmenu-undo,
#context-undo,
#menu_undo {
  -moz-image-region: rect(0 32px 16px 16px);
}

#appmenu-editmenu-redo,
#menu_redo {
  -moz-image-region: rect(0 48px 16px 32px);
}

#appmenu_find,
#menu_find {
  -moz-image-region: rect(0 64px 16px 48px);
}

#appmenu_savePage,
#menu_savePage,
#context-savelink,
#context-savepage {
  -moz-image-region: rect(0 80px 16px 64px);
}

#appmenu_sendLink,
#menu_sendLink,
#context-sendLink{
  -moz-image-region: rect(0 96px 16px 80px);
}

#appmenu-editmenu-selectAll,
#menu_selectAll,
#context-selectall{
  -moz-image-region: rect(0 112px 16px 96px);
}

#appmenu-editmenu-delete,
#menu_delete,
#context-delete{
  -moz-image-region: rect(0 128px 16px 112px);
}

#context-reload{
  -moz-image-region: rect(0 144px 16px 128px);
}

#context-navigation-classic #context-back{
  -moz-image-region: rect(0 160px 16px 144px);
}

#context-navigation-classic #context-forward{
  -moz-image-region: rect(0 176px 16px 160px);
}

#context-navigation-classic {
-moz-box-orient: vertical;
}

/* End Cyberfox Config */

#appmenu-edit-label {
  -moz-appearance: none;
  background: transparent;
  font-style: italic;
}

#appmenu_bookmarks,
#menu_bookmarkThisPage,
#context-bookmarklink,
#context-bookmarkpage {
  list-style-image: url("chrome://browser/skin/places/bookmark.png")!important;
  -moz-image-region: rect(0px 48px 16px 32px);
}