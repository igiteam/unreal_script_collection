class SeqAct_R6SetWindModulateSource extends SequenceAction
    hidecategories(Object);

var(Distance) float m_fDistanceMax;
var(Distance) float m_fDistanceMin;

defaultproperties
{
    m_fDistanceMax=100.0000000
    InputLinks[0]=(LinkDesc="Set Source",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Remove Source",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Set",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Removed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Winds",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Source",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0)
    ObjName="Set Wind Modulate Source"
    ObjCategory="Wind"
}