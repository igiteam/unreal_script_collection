class SeqAct_R6SetPIPSpecialActor extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Input",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Output",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0)
    ObjName="Set PIP Viewer"
    ObjCategory="PIP"
}