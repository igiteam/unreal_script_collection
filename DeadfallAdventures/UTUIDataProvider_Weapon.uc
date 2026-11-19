class UTUIDataProvider_Weapon extends UTUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config string ClassName;
var config string AmmoClassPath;
var config string Flags;
var const config localized string Description;

defaultproperties
{
    bSearchAllInis=true
}