class SeqAct_ForceFeedback extends SequenceAction
    hidecategories(Object);

var() editinline ForceFeedbackWaveform FFWaveform;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Start",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Force Feedback"
    ObjCategory="Misc"
}