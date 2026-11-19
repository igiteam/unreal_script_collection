class SeqAct_R6SetLocationRelative extends SequenceAction
    native
    hidecategories(Object);

var() Rotator m_Rotation;
var() bool m_IgnoreRotation;
var() bool m_FastMove;
var() bool m_bCheckValidNavMeshLocation;

defaultproperties
{
    m_FastMove=true
    m_bCheckValidNavMeshLocation=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Root",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Displacement",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Set Relative Actor Location"
    ObjCategory="Actor"
}