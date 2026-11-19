class SeqAct_FinishSequence extends SequenceAction
    native
    hidecategories(Object);

var() string OutputLabel;
var() bool DeactivateEvents;
var() bool StopAllMatinees;

defaultproperties
{
    OutputLabel="Default Output"
    OutputLinks=none
    VariableLinks=none
    ObjName="Finish Sequence"
    ObjCategory="Misc"
}