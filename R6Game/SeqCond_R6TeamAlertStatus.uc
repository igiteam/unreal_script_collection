class SeqCond_R6TeamAlertStatus extends SequenceCondition
    native
    hidecategories(Object);

var() float m_fThresholdUnaware;
var() float m_fThresholdAware;
var() float m_fThresholdCombating;

defaultproperties
{
    m_fThresholdUnaware=0.5000000
    m_fThresholdAware=0.5000000
    m_fThresholdCombating=0.5000000
    OutputLinks[0]=(Links=none,LinkDesc="Unaware",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aware",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Combating",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Nothing",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Team",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Team Alert Status"
}