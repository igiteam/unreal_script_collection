class SeqAct_Timer extends SequenceAction
    native
    hidecategories(Object);

var transient float ActivationTime;
var() float Time;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Start",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Time",LinkVar="None",PropertyName="Time",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Time Recorder"
    ObjCategory="Misc"
}