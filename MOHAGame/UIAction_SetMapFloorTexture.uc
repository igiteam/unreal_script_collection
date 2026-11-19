class UIAction_SetMapFloorTexture extends UIAction_SetValue
    hidecategories(Object);

var() Texture NewTexture;
var() int Floor;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=none,LinkedVariables=none,LinkDesc="Texture",LinkVar="None",PropertyName="NewTexture",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Floor(0-4)",LinkVar="None",PropertyName="Floor",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Map Floor Texture"
}