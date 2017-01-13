(function (global) {
    /* 
        Global blacklist shared between options.js and overlay.js
        blacklist.js must be loaded first before overlay.js and options.js
    */
    var ctrblacklist = [
        "extensions.classicthemerestorer.pref_actindx",
        "extensions.classicthemerestorer.pref_actindx2",
        "extensions.classicthemerestorer.pw_actidx_c",
        "extensions.classicthemerestorer.pw_actidx_t",
        "extensions.classicthemerestorer.pw_actidx_tc",
        "extensions.classicthemerestorer.pw_actidx_g",
        "extensions.classicthemerestorer.pw_actidx_tb",
        "extensions.classicthemerestorer.pw_actidx_lb",
        "extensions.classicthemerestorer.pw_actidx_sb",
        "extensions.classicthemerestorer.ctrreset",
        "extensions.classicthemerestorer.compatibility.treestyle",
        "extensions.classicthemerestorer.compatibility.treestyle.disable",
        "extensions.classicthemerestorer.compatibility.tabmix",
        "extensions.classicthemerestorer.ctrpref.firstrun",
        "extensions.classicthemerestorer.features.firstrun",
        "extensions.classicthemerestorer.features.lastcheck",
        "extensions.classicthemerestorer.features.updatecheck",
        "extensions.classicthemerestorer.ctrpref.lastmod",
        "extensions.classicthemerestorer.ctrpref.lastmodapply",
        "extensions.classicthemerestorer.ctrpref.updatekey",
        "extensions.classicthemerestorer.version",
        "extensions.classicthemerestorer.ctrpref.lastmod.backup",
        "extensions.classicthemerestorer.ctrpref.importjson",
        "extensions.classicthemerestorer.ctrpref.active",
        "extensions.classicthemerestorer.compatibility.personalmenu",
        "extensions.classicthemerestorer.firstrun",
        "extensions.classicthemerestorer.syncprefs"
    ];
    // Make ctrblacklist a global variable
    global.ctrblacklist = ctrblacklist;
} (this));