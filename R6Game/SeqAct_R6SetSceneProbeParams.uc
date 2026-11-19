class SeqAct_R6SetSceneProbeParams extends SequenceAction
    native
    hidecategories(Object);

var() float m_fFrameRate;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetSceneProbe",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set SceneProbe Params"
    ObjCategory="Actor"
}