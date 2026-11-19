class UIAction_AddFloat extends UIAction
    native
    hidecategories(Object);

var() float ValueA;
var() float ValueB;
var float Sum;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="A",LinkVar="None",PropertyName="ValueA",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="B",LinkVar="None",PropertyName="ValueB",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Sum",LinkVar="None",PropertyName="Sum",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Add Float"
}