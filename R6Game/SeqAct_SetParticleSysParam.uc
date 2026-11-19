class SeqAct_SetParticleSysParam extends SequenceAction
    hidecategories(Object);

var() export editinline array<export editinline ParticleSysParam> InstanceParameters;
var() bool bOverrideScalar;
var() float ScalarValue;

defaultproperties
{
    bOverrideScalar=true
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Scalar Value",LinkVar="None",PropertyName="ScalarValue",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Particle Param"
    ObjCategory="Particles"
}