class UTUIDataProvider_SettingsMenuItem extends UTUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var const localized string Description;
var config bool bFrontEndOnly;

event bool ShouldBeFiltered()
{
    return super(UDKUIResourceDataProvider).ShouldBeFiltered() || bFrontEndOnly && !Class'Engine.WorldInfo'.static.IsMenuLevel();
    //return ReturnValue;    
}
