class SeqAct_R6SetScriptedWalkAnim extends SequenceAction
    native
    hidecategories(Object);

var() float m_fWalkSpeed;
var() name AnimForward;
var() name AnimStrafeLeft;
var() name AnimStrafeRight;
var() transient array<AnimSet> AnimSets;
var() editconst transient array<name> AvailableAnims;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Reset",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Walk Animation"
    ObjCategory="Pawn"
}