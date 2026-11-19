class SeqCond_R6CompareTactic extends SequenceCondition
    native
    hidecategories(Object);

var() Actor.ETacticType m_Tactic;

defaultproperties
{
    m_Tactic=1
    OutputLinks[0]=(Links=none,LinkDesc="Equal",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Not Equal",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=3
    ObjName="Compare Tactic"
    ObjCategory="Comparison"
}