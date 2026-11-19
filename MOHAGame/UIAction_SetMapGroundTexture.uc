class UIAction_SetMapGroundTexture extends UIAction_SetValue
    hidecategories(Object);

var() Texture NewTexture;
var() float X;
var() float Y;
var() float Width;
var() float Height;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=none,LinkedVariables=none,LinkDesc="Texture",LinkVar="None",PropertyName="NewTexture",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="X",LinkVar="None",PropertyName="X",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[5]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Y",LinkVar="None",PropertyName="Y",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[6]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Width",LinkVar="None",PropertyName="Width",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[7]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Height",LinkVar="None",PropertyName="Height",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Map Ground Texture"
}