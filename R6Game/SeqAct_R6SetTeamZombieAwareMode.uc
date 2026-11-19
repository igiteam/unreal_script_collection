class SeqAct_R6SetTeamZombieAwareMode extends SequenceAction
    native
    hidecategories(Object);

var() array<R6WakeInfo> m_WakeEvents;
var() bool m_bAppendEvents;
var() bool m_bRemoveEvents;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Team",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set TEAM Zombie Aware Mode"
    ObjCategory="R6AI"
}