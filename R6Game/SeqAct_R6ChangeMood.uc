class SeqAct_R6ChangeMood extends SequenceAction
    native
    hidecategories(Object);

var() R6CivilPawn.ECivilMood m_eMood;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Change mood"
    ObjCategory="R6AI"
}