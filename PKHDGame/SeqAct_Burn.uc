class SeqAct_Burn extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float InTotalTime;
var() float InDamageInterval;
var() float InDamageAmount;

defaultproperties
{
    InTotalTime=999.0000000
    InDamageInterval=1.0000000
    InDamageAmount=5.0000000
    InputLinks[0]=(LinkDesc="Burn",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Extinguish",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Burn"
}