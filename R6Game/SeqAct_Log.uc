class SeqAct_Log extends SequenceAction
    native
    hidecategories(Object);

var() bool bOutputToScreen;
var() bool bIncludeObjComment;

defaultproperties
{
    bOutputToScreen=true
    bIncludeObjComment=true
    VariableLinks[0]=(ExpectedType=Class'SeqVar_String',LinkedVariables=none,LinkDesc="String",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Float",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Bool',LinkedVariables=none,LinkDesc="Bool",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    VariableLinks[3]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Object",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    VariableLinks[4]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Int",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    ObjName="Log"
    ObjCategory="Misc"
}