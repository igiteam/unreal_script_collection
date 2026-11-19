class SeqAct_R6ChopperGetCam extends SequenceAction
    native
    hidecategories(Object);

var R6Helicopter Helicopter;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Helicopter",LinkVar="None",PropertyName="Helicopter",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Get Helicopter Camera"
    ObjCategory="Helicopter"
}