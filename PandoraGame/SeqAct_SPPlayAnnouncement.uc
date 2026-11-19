class SeqAct_SPPlayAnnouncement extends SequenceAction;

/** Message Class to Broadcast */
var() class<LocalMessage> MessageClass;
var() int Switch;

event Activated()
{
    local WorldInfo WI;
    local Pawn TargetPawn;
    local PlayerController targetController;

    TargetPawn = Pawn(Targets[0]);
    WI = GetWorldInfo();
    // End:0x97
    if(TargetPawn != none)
    {
        targetController = PlayerController(TargetPawn.Controller);
        // End:0x94
        if((targetController != none) && targetController.PlayerReplicationInfo != none)
        {
            WI.BroadcastLocalizedMessage(MessageClass, Switch, targetController.PlayerReplicationInfo);
        }        
    }
    else
    {
        WI.BroadcastLocalizedMessage(MessageClass, Switch);
    }
    //return;    
}
