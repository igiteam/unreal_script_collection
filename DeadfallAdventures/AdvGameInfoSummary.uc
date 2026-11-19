class AdvGameInfoSummary extends UIGameInfoSummary
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config array<config string> AdditionalOptions;
var config AdvTypes.EMultiGameMode MPGameMode;
var config string SettingsName;
var config string IconPathName;
var const localized string SellTitle;
var const localized string SellText;
var const localized string HintText;
