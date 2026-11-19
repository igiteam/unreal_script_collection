class SeqAct_SetBool extends SequenceAction
    native
    hidecategories(Object);

var() bool DefaultValue;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Bool',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Bool',LinkedVariables=none,LinkDesc="Value",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    ObjName="Bool"
    ObjCategory="Set Variable"
}