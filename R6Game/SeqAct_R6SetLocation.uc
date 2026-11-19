class SeqAct_R6SetLocation extends SequenceAction
    native
    hidecategories(Object);

var() bool m_FastMove;
var() bool m_bSetRotation;
var() bool m_bCheckValidNavMeshLocation;

defaultproperties
{
    m_FastMove=true
    m_bCheckValidNavMeshLocation=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Location",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Warp To Actor",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjClassVersion=2
    ObjName="Set Actor Location"
    ObjCategory="Actor"
}