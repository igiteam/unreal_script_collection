class TurokSeqAct_ConstrainPlayer extends SequenceAction
    hidecategories(Object);

var() bool mbAllowMovement;
var() float mLookAtTime;
var() @NULL mLookAtConstraints;
var() array mLookAtSplinePoints;

defaultproperties
{
    mLookAtSplinePoints=/* Array type was not detected. */
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Position",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Look At",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Constrain Player"
    ObjCategory="Turok Cinema"
}