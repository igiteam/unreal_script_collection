class SeqAct_SetFloat extends SequenceAction
    native
    hidecategories(Object);

var float Target;
var() float Value;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Float"
    ObjCategory="Set Variable"
}