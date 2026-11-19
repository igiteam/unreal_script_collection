class SeqAct_GetProperty extends SequenceAction
    native
    hidecategories(Object);

var() name PropertyName;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Object",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Int",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[3]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Float",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[4]=(ExpectedType=Class'SeqVar_String',LinkedVariables=none,LinkDesc="String",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[5]=(ExpectedType=Class'SeqVar_Bool',LinkedVariables=none,LinkDesc="Bool",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Get Property"
    ObjCategory="Object Property"
}