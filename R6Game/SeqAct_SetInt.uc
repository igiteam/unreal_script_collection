class SeqAct_SetInt extends SequenceAction
    native
    hidecategories(Object);

var int Target;
var() int Value;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Int"
    ObjCategory="Set Variable"
}