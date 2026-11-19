class UIAction_SetMapFloor extends UIAction_SetValue
    hidecategories(Object);

var() int Floor;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Floor",LinkVar="None",PropertyName="Floor",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Map Floor"
}