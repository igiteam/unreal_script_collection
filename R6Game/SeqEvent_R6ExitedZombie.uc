class SeqEvent_R6ExitedZombie extends SequenceEvent
    native
    hidecategories(Object);

var R6GameEnums.EWakeEvents m_eWokenEvent;

event GetFullObjComment(out string FullObjComment)
{
    FullObjComment = (ObjComment $ " by event ") $ string(m_eWokenEvent);
    return;
}

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    ObjName="Exited Script Zombie"
    ObjCategory="R6AI"
}