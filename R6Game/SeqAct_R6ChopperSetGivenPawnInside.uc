class SeqAct_R6ChopperSetGivenPawnInside extends SequenceAction
    native
    hidecategories(Object);

var() R6GameEnums.EHelicopterSittingPos m_eSeattingPos;

defaultproperties
{
    m_eSeattingPos=2
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.R6SeqVar_Pawn',LinkedVariables=none,LinkDesc="Pawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Helicopter",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Pawn Inside"
    ObjCategory="Helicopter"
}