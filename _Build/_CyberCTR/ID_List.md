List of menu and context menu IDs to hide with custom filter

##[Quick Navigation]

- [File Menu](#file-menu)
- [Edit Menu](#edit-menu)
- [View Menu](#view-menu)
- [History Menu](#history-menu)
- [Bookmarks Menu](#bookmarks-menu)
- [Tools Menu](#tools-menu)
- [Help Menu](#help-menu)
- [Main Interface](#main-interface)
- [General Interface](#general-interface)
- [Tool-Bar Buttons](#tool-bar-buttons)
- [Customization](#customization)
- [Tab Context Menu](#tab-context-menu)
- [Back Forward Menu](#back-forward-menu)
- [Toolbar Context Menu](#toolbar-context-menu)
- [Content Area Context Menu](#content-area-context-menu)
- [Panel UI](#panel-ui)
- [CyberCTR - CTR](#cyberctr)

For items marked with `*Tree` means the whole menu and sub-menus. 

*Note:* Not every item is in this list and some items are cyberfox specific.

*Note:* Some IDs or Classes may radically change the user interface or break it use with caution.

*Note:* Warning some ID's are case sensitive...

More items will be added as time permits.


####[File Menu]
| Item | ID |
------------- | -------------
Complete File Menu Item | #file-menu
File Menu Pop-up | #menu_FilePopup
New Tab | #menu_newNavigatorTab
New Window | #menu_newNavigator
New Private Window | #menu_newPrivateWindow
Open File | #menu_openFile
Save Page As | #menu_savePage
Send Link | #menu_sendLink
Print Setup | #menu_printSetup
Print Preview | #menu_printPreview
Print | #menu_print
Work Offline | #goOfflineMenuitem
Restart Browser | #app_restartBrowser
Exit | #menu_FileQuitItem
[Top](#quick-navigation)


####[Edit Menu]
| Item | ID |
------------- | -------------
Complete Edit Menu Item | #edit-menu
Edit Menu Pop-up | #menu_EditPopup
Undo | #menu_undo
Redo | #menu_redo
Cut | #menu_cut
Copy | #menu_copy
Paste | #menu_paste
Delete | #menu_delete
Select All | #menu_selectAll
Find | #menu_find
Text Direction Swap | #textfieldDirection-swap
[Top](#quick-navigation)


####[View Menu]
| Item | ID |
------------- | -------------
Complete View Menu Item | #view-menu
View Menu Pop-up | #menu_ViewPopup
Tool-bars `*Tree` | #viewToolbarsMenu
About:Config | #AboutConfigMenuItem
Customize Tool-bars | #menu_customizeToolbars
Sidebar `*Tree` | #viewSidebarMenu
Bookmarks | #menu_bookmarksSidebar
History | #menu_historySidebar
Zoom `*Tree` | #viewFullZoomMenu
Zoom In | #menu_zoomEnlarge
Zoom Out | #menu_zoomReduce
Reset | #menu_zoomReset
Zoom Text Only | #toggle_zoom
Page Style `*Tree` | #pageStyleMenu
No Style | #menu_pageStyleNoStyle
Basic Page Style | #menu_pageStylePersistentOnly
Charset Menu (Full `*Tree`) | #charsetMenu
Fullscreen | #fullScreenItem
Show All Tabs | #menu_showAllTabs
[Top](#quick-navigation)


####[History Menu]
| Item | ID |
------------- | -------------
Complete History Menu Item | #history-menu
History Menu Pop-up | #menu_ViewPopup
Show All History | #menu_showAllHistory
Clear Recent History | #sanitizeItem
Sync tabs | #sync-tabs-menuitem
Restore Previous Session | #historyRestoreLastSession
Recently Closed tabs `*Tree` | #historyUndoMenu
Tab Undo Pop-up | #historyUndoPopup
Recently Closed Windows `*Tree` | #historyUndoWindowMenu
Window Undo Pop-up | #historyUndoWindowPopup
[Top](#quick-navigation)


####[bookmarks Menu]
| Item | ID |
------------- | -------------
Complete bookmarks Menu Item | #bookmarksMenu
bookmarks Menu Pop-up | #bookmarksMenuPopup
Show All Bookmarks | #bookmarksShowAll
Bookmark This Page | #menu_bookmarkThisPage
Subscribe To This Page | #subscribeToPageMenuitem
Subscribe Menu Pop-up | #subscribeToPageMenupopup
Bookmarks Tool-bar `*Tree` | #bookmarksToolbarFolderPopup
Recent Bookmarks | #menu_unsortedBookmarks
[Top](#quick-navigation)


####[Tools Menu]
| Item | ID |
------------- | -------------
Complete Tools Menu Item | #tools-menu
Tools Menu Pop-up | #menu_ToolsPopup
Downloads | #menu_openDownloads
Addons | #menu_openAddons
Setup Sync | #sync-setup
Web Developer `*Tree` | #webDeveloperMenu
Web Developer Menu Pop-up | #menuWebDeveloperPopup
Toggle Tools | #menu_devToolbox
Inspector | #menu_browserToolbox
Web Console | __Unknown__
Debugger | __Unknown__
Style Editor | __Unknown__
Performance | __Unknown__
Network | __Unknown__
Developer Tool-bar | __Unknown__
WebIDE | #menu_webide
Browser Console | #menu_browserConsole
Responsive Design View | #menu_responsiveUI
Eydropper | #menu_eyedropper
Scratchpad | #menu_scratchpad
Page Source | #menu_pageSource
Get More Tools | #getMoreDevtools
Page Info | #menu_pageInfo
Clear Ram Cache | #minimizeMemoryUsage
Options | #menu_preferences
[Top](#quick-navigation)


####[Help Menu]
| Item | ID |
------------- | -------------
Complete Help Menu Item | #helpMenu
Help Menu Pop-up | #menu_HelpPopup
Cyberfox Help | #menu_openHelp
Keyboard Shortcuts | #menu_keyboardShortcuts
Troubleshooting Information | #troubleShooting
Submist Feedback | #feedbackPage
Restart With Addons Disabled | #helpSafeMode
Aboyt Cyberfox | #aboutName
[Top](#quick-navigation)


####[Main Interface]
| Item | ID |
------------- | -------------
Tabs Tool-bar | #TabsToolbar
Tab Browser Tabs | #tabbrowser-tabs
Bookmarks Tool-bar | #PersonalToolbar
Sidebar Box | #sidebar-box
Developer Toolbar | #developer-toolbar
[Top](#quick-navigation)


####[General Interface]
| Item | ID |
------------- | -------------
Navigation Tool-bar | #nav-bar
Back Button | #back-button
Forward Button | #forward-button
Url Tool-bar | #urlbar
Identity Box | #identity-box
Page Favicon (Includes HTTPS Icon) | #page-proxy-favicon
Seach-bar Tool-bar | #search-container
[Top](#quick-navigation)


####[Tool-Bar Buttons]
| Item | ID |
------------- | -------------
Bookmark Tool-bar Button | #bookmarks-menu-button
Bookmark Tool-bar Button Menu `*Tree` | #bookmarks-menu-button
View Bookmarks Sidebar | #BMB_viewBookmarksSidebar
Show All Bookmarks | #BMB_bookmarksShowAllTop
Subscribe To This page | #BMB_subscribeToPageMenuitem
Bookmarks Toolbar `*Tree` | #BMB_bookmarksToolbar
Bookmarks Toolbar Pop-up | #BMB_bookmarksToolbarPopup
Bookmarks Toolbar View Bookmarks Sidebar | #BMB_viewBookmarksToolbar
Unsorted Bookmarks | #BMB_unsortedBookmarks
Show All Boomarks | #BMB_bookmarksShowAll
Downloads Button | #downloads-button
Home Button | #home-buttonvbcmd
Print Button | #print-button
New Window Button | #new-window-button
Fullscreen Button | #fullscreen-button
Sync Button | #sync-button
Tabview Button | #tabview-button
Restart Browser Button | #toolbar_restartBrowser
Clone Current Tab Button | #tbar-clonenewtab
Clone In New Window Button | #tbar-clonenewwindow
Downloads Simple | #downloads-button-additional
Copy Tab Url Button | #tbar-copycurrenttaburl
Copy All Tab Urls Button | #tbar-copyalltaburl
Browser Console Button | #tbar_browserconsole
[Top](#quick-navigation)


####[Customization]
| Item | ID |
------------- | -------------
Titlebar Visibility Button | #customization-titlebar-visibility-button
Toolbar Visibility Button `*Tree` | #customization-toolbar-visibility-button
Light Weight Themes Button `*Tree` | #customization-lwtheme-button
Devedition Theme Button | #customization-devedition-theme-button
Reset Button | #customization-reset-button
[Top](#quick-navigation)


####[Tab Context Menu]
| Item | ID |
------------- | -------------
Tab Context Menu `*Tree` | #tabContextMenu
Pin Tab | #context_pinTab
Unpin Tab | #context_unpinTab
Move To Group `*Tree` | #context_tabViewMenu
Move To New Window | #context_openTabInWindow
Copy Tab Url | #context_CopyCurrentTabUrl
Copy All Tab Urls | #context_CopyAllTabUrls
Clone Current Tab | #context_CloneCurrentTab
Clone In Window | #context_CloneCurrentTabNewWindow
Reload All Tabs | #context_reloadAllTabs
Bookmark All Tabs | #context_bookmarkAllTabs
Close Tabs To The Right | #context_closeTabsToTheEnd
Close Other Tabs | #context_closeOtherTabs
Undo Closed Tab | #context_undoCloseTab
Close Tab | #context_closeTab
[Top](#quick-navigation)


####[Back Forward Menu]
| Item | ID |
------------- | -------------
Back Forward Menu | #backForwardMenu
[Top](#quick-navigation)


####[Toolbar Context Menu]
| Item | ID |
------------- | -------------
Toolbar Context Menu `*Tree` | #toolbar-context-menu
Move To Menu | __.customize-context-moveToPanel__
Remove From Tool-Bar | __.customize-context-removeFromToolbar__
Reload All Tabs | #toolbar-context-reloadAllTabs
Bookmark All Tabs | #toolbar-context-bookmarkAllTabs
Undo Closed Tab | #toolbar-context-undoCloseTab
Customize | __.viewCustomizeToolbar__
About:Config | #menu-aboutconfig
[Top](#quick-navigation)


####[Content Area Context Menu]
| Item | ID |
------------- | -------------
Content Area Context Menu `*Tree` | #contentAreaContextMenu
Context Navigation `*Tree` | #context-navigation
Back | #context-back
Forward | #context-forward
Reload | #context-reload
Stop | #context-stop
Bookmark This Page | #context-bookmarkpage
Spellcheck No Suggestions | #spell-no-suggestions
Spellcheck Add To Dictionary | #spell-add-to-dictionary
Spellcheck Undo Add To Dictionary | #spell-undo-add-to-dictionary
Open Link | #context-openlinkincurrent
Open Lin In New Tab | #context-openlinkintab
Open Link In New Window | #context-openlink
Open Link In New Private Window | #context-openlinkprivate
Bookmark This Link | #context-bookmarklink
Share Link | #context-sharelink
Save Link As | #context-savelink
Copy Email Address | #context-copyemail
Copy Link | #context-copylink
Play | #context-media-play
Pause | #context-media-pause
Mute | #context-media-mute
Unmute | #context-media-unmute
Playback Rate `*Tree` | #context-media-playbackrate
Show Controls | #context-media-showcontrols
Hide Controls | #context-media-hidecontrols
Show Stats | #context-video-showstats
Hide Stats | #context-video-hidestats
Media Fullscreen | #context-video-fullscreen
Media Exit Fullscreen| #context-leave-dom-fullscreen
Reload Image | #context-reloadimage
View Image | #context-viewimage
View  Video | #context-viewvideo
Copy Image | #context-copyimage-contents
Copy Image Location | #context-copyimage
Copy Video Location | #context-copyvideourl
Copy Audio Location | #context-copyaudiourl
Save Image As | #context-saveimage
Share Image | #context-shareimage
Email Image | #context-sendimage
Set As Desktop Background | #context-setDesktopBackground
View Image Information | #context-viewimageinfo
Save Video As | #context-sharevideo
Save Audio As | #context-saveaudio
Save Video Image | #context-video-saveimage
Email Video | #context-sendvideo
Email Audio | #context-sendaudio
Click To Activate | #context-ctp-play
Hide Click To Activate | #context-ctp-hide
Context Navigation Classic `*Tree` | #context-navigation-classic
Share Page | #context-sharepage
Save Page As | #context-savepage
Email Link | #context-sendLink
Undo | #context-undo
Cut | #context-cut
Copy | #context-copy
Paste | #context-paste
Delete | #context-delete
Select All | #context-selectall
Add A Keyword For This In Search | #context-keywordfield
Search <Engine> For | #context-searchselect
Share Selection | #context-shareselect
View Page Source | #context-viewsource
View Page Information | #context-viewinfo
Check Spelling | #spell-check-enabled
Add To Dictionary | #spell-add-dictionaries-main
Select Dictionary `*Tree` | #spell-dictionaries
Inspect Element | #context-inspect
Toggle Javascript | #context-javascript
[Top](#quick-navigation)


####[Panel UI]
| Item | ID |
------------- | -------------
Sync | #PanelUI-fxa-status
Customize | #PanelUI-customize
Help Menu `*Tree` | #PanelUI-help
Quit | #PanelUI-quit
[Top](#quick-navigation)


####[CyberCTR]
| Item | ID |
------------- | -------------
AppMenu Button `*Tree` | #appmenu-popup
AppMenu Primary Pane `*Tree` | #appmenuPrimaryPane
New Tab | #appmenu_newTab 
New Tab Pop-up `*Tree` | #ctraddon_menu_newTabmenupopup
New Tab | #appmenu_newTab_popup
New Window | #appmenu_newNavigator
Open File | #appmenu_openFile
New Private Window | #appmenu_newPrivateWindow
Minimize Memory Usage | #appmenu_minimizeMemoryUsage
Edit Box `*Tree` | #ctraddon_appmenubox_edit
Edit Label | #appmenu-edit-label
Cut | #appmenu-cut
Copy | #appmenu-copy
Paste | #appmenu-paste
Edit Menu `*Tree` | #appmenu-editmenu
Edit Menu Pop-up `*Tree` | #appmenu-editmenu-menupopup
Edit Menu Cut | #appmenu-editmenu-cut
Edit Menu Copy | #appmenu-editmenu-copy
Edit Menu Paste | #appmenu-editmenu-paste
Edit Menu Undo | #appmenu-editmenu-undo
Edit Menu Redo | #appmenu-editmenu-redo
Edit Menu Select All | #appmenu-editmenu-selectAll
Edit Menu Delete | #appmenu-editmenu-delete
Find In This Page | #appmenu_find
Save Page As | #appmenu_savePage
Email Link | #appmenu_sendLink
Print `*Tree` | #appmenu_print
Print Pop-up `*Tree` | #ctraddon_menu_newPrintmenupopup
Print Pop-up Print | #appmenu_print_popup
Print Pop-up Print Preview | #appmenu_printPreview
Print Pop-up Print Setup | #appmenu_printSetup
Web Developer `*Tree` | #appmenu_webDeveloper
Web Developer Pop-up `*Tree` | #appmenu_webDeveloper_popup
Toggle Tools | #appmenu_devToolbox
Inspector | __Unknown__
Web Console | #appmenu_errorConsole
Debugger | __Unknown__
Style Editor | __Unknown__
Performance | __Unknown__
Network | __Unknown__
Developer Tool-Bar | #appmenu_devToolbar
WebIDE | #appmenu_webide
Browser Console | #appmenu_browserConsole
Responsive Design View | #appmenu_responsiveUI
Eydropper | #appmenu_eyedropper
Scratchpad | #appmenu_scratchpad
Page Source | #appmenu_pageSource
Get More Tools | #appmenu_getMoreDevtools
Work Offline | #appmenu_offlineMode
Fullscreen | #appmenu_fullScreen
Sync | #sync-setup-appmenu
Restart Browser | #appmenu_restartBrowser
Quit | #appmenu-quit
[Top](#quick-navigation)
