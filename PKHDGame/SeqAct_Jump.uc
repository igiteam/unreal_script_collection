class SeqAct_Jump extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() RB_LineImpulseActor ImpulseVector;
var() float JumpDeltaMultiplier;
var() array<EvilJumpSequenceInformation> JumpSequenceInfos;
var bool bInheritVelocityFromMotionDelta;

defaultproperties
{
    JumpDeltaMultiplier=1.0000000
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="RB_LineImpulseActor",LinkVar="None",PropertyName="ImpulseVector",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Jump"
}