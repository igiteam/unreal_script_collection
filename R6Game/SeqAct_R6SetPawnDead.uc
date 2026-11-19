class SeqAct_R6SetPawnDead extends SequenceAction
    hidecategories(Object);

var() bool m_bPreventRagdoll;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Dead"
    ObjCategory="Pawn"
}