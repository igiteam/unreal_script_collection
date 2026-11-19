class SeqAct_R6AIRegroupTeam extends SequenceAction
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Regroup",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Hold",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Player',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Regroup Rainbow Team"
    ObjCategory="R6AI"
}