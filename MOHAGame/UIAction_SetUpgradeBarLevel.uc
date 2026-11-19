class UIAction_SetUpgradeBarLevel extends UIAction
    native
    hidecategories(Object);

var() string SceneTag;
var() float FloatValue;
var() float SizeMultiplier;
var() string WidgetName;

defaultproperties
{
    FloatValue=-1.0000000
    SizeMultiplier=3.2500000
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Scene Tag",LinkVar="None",PropertyName="SceneTag",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Float Value",LinkVar="None",PropertyName="FloatValue",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[5]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Multiplier",LinkVar="None",PropertyName="SizeMultiplier",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[6]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Widget Name",LinkVar="None",PropertyName="WidgetName",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Set Upgrade Bar Level"
}