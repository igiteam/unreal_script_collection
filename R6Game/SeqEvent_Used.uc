class SeqEvent_Used extends SequenceEvent
    native
    hidecategories(Object);

var() bool bAimToInteract;
var() float InteractDistance;
var() string InteractText;
var() Texture2D InteractIcon;

defaultproperties
{
    bAimToInteract=true
    InteractDistance=128.0000000
    InteractText="Use"
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Distance",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Used"
    ObjCategory="Trigger"
}