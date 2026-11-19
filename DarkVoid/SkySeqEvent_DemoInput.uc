class SkySeqEvent_DemoInput extends SequenceEvent;

var() int ControllerId;
var() name ButtonName;
var() Object.EInputEvent InputEvent;
var() bool bTrapInput;

function bool CheckInput(PlayerController Player, int CheckControllerID, name CheckButtonName, Object.EInputEvent CheckInputEvent)
{
    // End:0x73
    if(((((CheckButtonName == ButtonName) && int(CheckInputEvent) == int(InputEvent)) && (ControllerId == -1) || CheckControllerID == ControllerId) && CheckActivate(Player, Player)) && bEnabled)
    {
        return bTrapInput;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}
