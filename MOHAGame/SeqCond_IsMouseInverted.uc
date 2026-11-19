class SeqCond_IsMouseInverted extends SequenceCondition
    hidecategories(Object);

var MOHAPlayerController Player;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

function Activated()
{
    local MOHAPlayerController localPlayerController;

    // End:0x42
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', localPlayerController)
    {
        // End:0x41
        if(NetConnection(localPlayerController.Player) == none)
        {
            Player = localPlayerController;
            // End:0x42
            break;
        }        
    }    
    // End:0x78
    if(Player.PlayerInput.bInvertMouse == true)
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
    OutputLinks[0]=(Links=none,LinkDesc="Inverted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="NotInverted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="ControllerInvertStatus"
    ObjCategory="RealMem"
}