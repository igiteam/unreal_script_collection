class SeqAct_GetVelocity extends SequenceAction
    native
    hidecategories(Object);

var() editconst float Velocity;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Velocity",LinkVar="None",PropertyName="Velocity",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Get Velocity"
    ObjCategory="Actor"
}