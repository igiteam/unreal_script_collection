class UICond_IsServerPunkbusterEnabled extends SequenceCondition
    hidecategories(Object);

var() bool ShowPopupWhenInconsistent;
var const localized string MustEnablePunkbuster;

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
    // End:0xE2
    if(!gameServer.punkbuster || P.PBisPbClEnabled())
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        // End:0x17E
        if(ShowPopupWhenInconsistent)
        {
            // End:0x122
            foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', PlayerController)
            {
                // End:0x121
                if(NetConnection(PlayerController.Player) == none)
                {
                    // End:0x122
                    break;
                }                
            }            
            // End:0x17E
            if(PlayerController != none)
            {
                UI = MOHAUIInteraction(PlayerController.GetUIController());
                // End:0x17E
                if(UI != none)
                {
                    UI.OpenAlert(UI.JoinFailed, MustEnablePunkbuster, 2);
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
    MustEnablePunkbuster="The selected server requires you to enable Punkbuster before you may join."
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Is Server Punkbuster Compatible?"
    ObjCategory="Plasma"
}