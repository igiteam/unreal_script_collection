class SeqEvent_LevelReset extends SequenceEvent
    native
    hidecategories(Object,Register);

var() bool m_bSingleMapOnly;
var() bool m_bMultiLevelOnly;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    bAlwaysActivated=true
    VariableLinks=none
    ObjName="Level Reset"
    ObjCategory="Misc"
}