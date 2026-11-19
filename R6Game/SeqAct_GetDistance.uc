class SeqAct_GetDistance extends SequenceAction
    native
    hidecategories(Object);

var() editconst float Distance;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="A",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="B",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Distance",LinkVar="None",PropertyName="Distance",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Get Distance"
    ObjCategory="Actor"
}