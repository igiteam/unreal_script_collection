class UIEvent_OnEnterCheatSuccess extends UIEvent
    native
    hidecategories(Object);

var string CheatCommand;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Activator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Cheat Command",LinkVar="None",PropertyName="CheatCommand",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Enter Cheat Success"
}