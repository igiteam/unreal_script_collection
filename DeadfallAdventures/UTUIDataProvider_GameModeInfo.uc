class UTUIDataProvider_GameModeInfo extends UTUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config string GameMode;
var config string DefaultMap;
var config string GameSettingsClass;
var config string GameSearchClass;
var config string OptionSet;
var const config localized string Description;
var config string PreviewImageMarkup;
var config string Prefixes;
var config string IconImage;
var config float IconU;
var config float IconV;
var config float IconUL;
var config float IconVL;

defaultproperties
{
    bSearchAllInis=true
}