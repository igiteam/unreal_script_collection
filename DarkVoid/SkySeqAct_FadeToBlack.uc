class SkySeqAct_FadeToBlack extends SequenceAction
    native;

var() float FadeToBlackTime;
var() float FadeFromBlackTime;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
