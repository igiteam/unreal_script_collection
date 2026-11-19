class UIAction_LocalMessage extends UIAction
    native
    hidecategories(Object);

enum EKismetWarnLevel
{
    KismetWarnLevel_None,           // 0
    KismetWarnLevel_Warning,        // 1
    KismetWarnLevel_Error,          // 2
    KismetWarnLevel_MAX             // 3
};

var() string MessageString;
var() float FadeTime;
var() UIAction_LocalMessage.EKismetWarnLevel KismetWarnLevel;

defaultproperties
{
    FadeTime=10.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="String",LinkVar="None",PropertyName="MessageString",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_LocalPlayerController',LinkedVariables=none,LinkDesc="Local PlayerController",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Local Message"
    ObjCategory="Misc"
}