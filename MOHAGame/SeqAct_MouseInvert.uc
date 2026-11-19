class SeqAct_MouseInvert extends SequenceAction
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
    Player.PlayerInput.InvertMouse();
    //return;    
}

defaultproperties
{
    ObjName="MouseInvert"
    ObjCategory="Misc"
}