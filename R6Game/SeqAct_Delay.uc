class SeqAct_Delay extends SeqAct_Latent
    native
    hidecategories(Object);

var const bool bDelayActive;
var const float DefaultDuration;
var() float Duration;
var const float LastUpdateTime;
var const float RemainingTime;

defaultproperties
{
    DefaultDuration=1.0000000
    Duration=1.0000000
    InputLinks[0]=(LinkDesc="Start",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Pause",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Duration",LinkVar="None",PropertyName="Duration",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Delay"
    ObjCategory="Misc"
}