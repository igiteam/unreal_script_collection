class TurokSeqAct_KnockdownPlayer extends SequenceAction
    hidecategories(Object);

var() bool mbKnockdownImmediately;
var() bool mbKnockdownOnNextAttack;
var() bool mbKnockdownOnProximity;
var() float mKnockdownProximity;

defaultproperties
{
    mbKnockdownImmediately=true
    mKnockdownProximity=400.0000000
    InputLinks[0]=(LinkDesc="Knockdown",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Source Actor",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Knockdown"
    ObjCategory="Turok Gameplay"
}