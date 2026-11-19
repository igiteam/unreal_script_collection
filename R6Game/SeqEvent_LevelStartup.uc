class SeqEvent_LevelStartup extends SequenceEvent
    native
    hidecategories(Object,Register);

var() bool m_bSingleMapOnly;
var() bool m_bMultiLevelOnly;
var() bool m_bActivateWhenLoadingCheckpoint;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    bAlwaysActivated=true
    VariableLinks=none
    ObjName="Level Startup"
    ObjCategory="Misc"
}