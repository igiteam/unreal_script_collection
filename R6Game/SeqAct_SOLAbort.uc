class SeqAct_SOLAbort extends SequenceAction
    native
    hidecategories(Object);

var() bool m_bTellRainbowsToRegroup;

defaultproperties
{
    m_bTellRainbowsToRegroup=true
    InputLinks[0]=(LinkDesc="Abort",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="SOL Interactive Actor",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Abort SOL"
    ObjCategory="SOL"
}