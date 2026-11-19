class UICond_IsServerSameVersion extends SequenceCondition
    hidecategories(Object);

var() bool ShowPopupWhenInconsistent;
var const localized string IncompatibleVersion;

event Activated()
{
    local Plasma P;
    local PlasmaServerListDataStore DataStore;
    local PlasmaServerListGame gameServer;
    local MOHAPlayerController PlayerController;
    local MOHAUIInteraction UI;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    DataStore = P.serverListDataStore;
    // End:0x7B
    if((DataStore.SelectedServer < 0) || DataStore.SelectedServer >= DataStore.Servers.Length)
    {
        OutputLinks[0].bHasImpulse = true;
        return;
    }
    gameServer = DataStore.Servers[DataStore.SelectedServer];
    // End:0xC8
    if(gameServer.sameVersion)
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        // End:0x164
        if(ShowPopupWhenInconsistent)
        {
            // End:0x108
            foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', PlayerController)
            {
                // End:0x107
                if(NetConnection(PlayerController.Player) == none)
                {
                    // End:0x108
                    break;
                }                
            }            
            // End:0x164
            if(PlayerController != none)
            {
                UI = MOHAUIInteraction(PlayerController.GetUIController());
                // End:0x164
                if(UI != none)
                {
                    UI.OpenAlert(UI.JoinFailed, IncompatibleVersion, 2);
                }
            }
        }
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    IncompatibleVersion="The selected game is running a different version and cannot be joined."
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Is Server Same Version?"
    ObjCategory="Plasma"
}