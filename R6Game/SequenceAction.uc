class SequenceAction extends SequenceOp
    abstract
    native
    hidecategories(Object);

var name HandlerName;
var bool bCallHandler;
var() array<Object> Targets;

defaultproperties
{
    bCallHandler=true
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Unknown Action"
    ObjColor=(R=255,G=0,B=255,A=255)
}