class SeqAct_SetIgnoreAffordance extends SequenceAction
    hidecategories(Object);

var() bool bIgnoreAffordance;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="Ignore Affordance",LinkVar="None",PropertyName="bIgnoreAffordance",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Ignore Affordance"
    ObjCategory="Kynapse AI"
}