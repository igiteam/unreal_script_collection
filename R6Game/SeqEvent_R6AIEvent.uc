class SeqEvent_R6AIEvent extends SequenceEvent
    native
    hidecategories(Object);

var() array<R6WakeInfo> m_Events;
var() bool m_ZombieOnly;
var() bool m_DisabledForZombie;

event GetFullObjComment(out string FullObjComment, R6GameEnums.EWakeEvents eWokenEvent)
{
    FullObjComment = (ObjComment $ " by event ") $ string(eWokenEvent);
    return;
}

defaultproperties
{
    bPlayerOnly=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Event Source",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="AI Event"
    ObjCategory="R6AI"
}