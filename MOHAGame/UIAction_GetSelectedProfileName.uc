class UIAction_GetSelectedProfileName extends UIAction
    native
    hidecategories(Object);

var string OutProfileName;
var() int InProfileNo;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

event Report()
{
    SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = OutProfileName;
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Profile Name",LinkVar="None",PropertyName="DeviceName",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="GetSelectedProfileName"
    ObjCategory="RealMem"
}