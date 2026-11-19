class SeqAct_R6ToggleDoorParams extends SeqAct_Toggle
    hidecategories(Object);

var() bool bToggleCanBeUsed;
var() bool bToggleBreakable;
var() bool bToggleBreachable;
var() bool bToggleLocked;
var() bool bToggleDisableForGameMode;

defaultproperties
{
    bToggleCanBeUsed=true
    bToggleBreakable=true
    bToggleBreachable=true
    bToggleLocked=true
    bToggleDisableForGameMode=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    EventLinks=none
    ObjClassVersion=2
    ObjName="Modify Door Parameters"
    ObjCategory="Door"
}