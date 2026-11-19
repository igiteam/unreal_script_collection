class SeqEvent_SequenceActivated extends SequenceEvent
    native
    hidecategories(Object,Register);

var() string InputLabel;
var() bool ActivateDisabledEvents;

defaultproperties
{
    InputLabel="Default Input"
    MaxTriggerCount=0
    bPlayerOnly=false
    bAlwaysActivated=true
    ObjName="Sequence Activated"
}