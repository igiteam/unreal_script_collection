class SeqCond_IsCompassOn extends SequenceCondition
    hidecategories(Object);

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

function Activated()
{
    local MOHAPlayerController localPlayerController;

    // End:0x37
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', localPlayerController)
    {
        // End:0x36
        if(NetConnection(localPlayerController.Player) == none)
        {
            // End:0x37
            break;
        }        
    }    
    // End:0x9B
    if(((localPlayerController != none) && MOHAHUD(localPlayerController.myHUD) != none) && MOHAHUD(localPlayerController.myHUD).IsCompassEnabled())
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="On",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Off",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Compass Status"
    ObjCategory="UI"
}