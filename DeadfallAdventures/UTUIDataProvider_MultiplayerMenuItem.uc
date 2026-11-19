class UTUIDataProvider_MultiplayerMenuItem extends UTUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var const config localized string Description;
var config bool bRequiresOnlineAccess;

event bool ShouldBeFiltered()
{
    local PlayerController PC;

    // End:0x0F
    if(super(UDKUIResourceDataProvider).ShouldBeFiltered())
    {
        return true;
    }
    // End:0x8B
    if(bRequiresOnlineAccess)
    {
        // End:0x8A
        foreach Class'Engine.Engine'.static.GetCurrentWorldInfo().LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {            
            return !PC.CanAllPlayersPlayOnline();            
        }        
    }
    return false;
    //return ReturnValue;    
}
