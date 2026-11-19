class SeqEvent_LevelLoaded extends SequenceEvent
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
    ObjName="Level Loaded And Visible"
    ObjCategory="Misc"
}