class SeqAct_SOLFinish extends SequenceAction
    native
    hidecategories(Object);

var() bool m_bTellRainbowsToRegroup;

defaultproperties
{
    m_bTellRainbowsToRegroup=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="SOL Interactive Actor",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Finish SOL"
    ObjCategory="SOL"
}