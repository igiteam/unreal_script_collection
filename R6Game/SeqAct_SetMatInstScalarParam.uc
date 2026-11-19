class SeqAct_SetMatInstScalarParam extends SequenceAction
    native
    hidecategories(Object);

var() MaterialInstanceConstant MatInst;
var() name ParamName;
var() float ScalarValue;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="ScalarValue",LinkVar="None",PropertyName="ScalarValue",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set ScalarParam"
    ObjCategory="Material Instance"
}