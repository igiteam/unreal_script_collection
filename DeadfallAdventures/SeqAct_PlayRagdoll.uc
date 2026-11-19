class SeqAct_PlayRagdoll extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() RB_LineImpulseActor ImpulseVector;
var() float AngularVariation;
var() float ForceVariation;
var() bool bRecoverFromRagdoll;

defaultproperties
{
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Recover",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Play Ragdoll on Pawn"
}