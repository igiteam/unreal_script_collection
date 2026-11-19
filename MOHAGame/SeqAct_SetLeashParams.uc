class SeqAct_SetLeashParams extends SeqAct_Latent
    native
    hidecategories(Object);

var() KynapseVolume LeashVolume;
var() float fLeashRadius;
var() Actor LeashRadiusPosition;

defaultproperties
{
    fLeashRadius=-255.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Leash Kynapse Volume",LinkVar="None",PropertyName="LeashVolume",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Radius",LinkVar="None",PropertyName="fLeashRadius",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Leash Home",LinkVar="None",PropertyName="LeashRadiusPosition",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set AI Leash Params (Latent)"
    ObjCategory="Kynapse AI"
}