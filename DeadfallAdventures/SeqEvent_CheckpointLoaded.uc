class SeqEvent_CheckpointLoaded extends SequenceEvent
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var() name FindCheckPointName;
var transient bool bStatusIsOk;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    ObjName="Checkpoint Loaded"
}