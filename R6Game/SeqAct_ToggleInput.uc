class SeqAct_ToggleInput extends SeqAct_Toggle
    hidecategories(Object);

var() bool bToggleMovement;
var() bool bToggleTurning;

defaultproperties
{
    bToggleMovement=true
    bToggleTurning=true
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Toggle Input"
}