class SeqAct_MPObjectiveSetState extends SequenceAction
    native
    hidecategories(Object);

var() MPObjective.EObjectiveState NewState;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="MPObjective",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="MP Objective Set State"
    ObjCategory="MPGame"
}