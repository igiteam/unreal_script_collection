class NavAct_WaitingForPlayer extends AdvNavPointAction
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float CallIntervals;
var() float PlayerDistance;
var() bool bCallPlayer;
var() bool bIgnoreDistance;

function bool IsNavActionActive()
{
    return false;
    //return ReturnValue;    
}

function StartNavAction()
{
    local AdvAICmd_WaitForPlayer WaitCommand;

    super(EvilNavPointAction).StartNavAction();
    WaitCommand = AdvAICmd_WaitForPlayer(AICommand);
    // End:0x48
    if(CallIntervals == 0.0000000)
    {
        CallIntervals = 10.0000000;
    }
    // End:0x6A
    if(PlayerDistance == 0.0000000)
    {
        PlayerDistance = 400.0000000;
    }
    WaitCommand.CallIntervals = CallIntervals;
    WaitCommand.PlayerDistance = PlayerDistance;
    WaitCommand.bCallPlayer = bCallPlayer;
    WaitCommand.bIgnoreDistance = bIgnoreDistance;
    WaitCommand.SetFinishCondition();
    //return;    
}

defaultproperties
{
    CallIntervals=10.0000000
    PlayerDistance=400.0000000
    DefaultAICommand=Class'AdvAICmd_WaitForPlayer'
}