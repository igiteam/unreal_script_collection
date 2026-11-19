class SeqEvent_R6AIInteract extends SequenceEvent
    native
    hidecategories(Object);

var() float InteractDistance;
var() string InteractText;
var() Texture2D InteractIcon;

defaultproperties
{
    InteractDistance=96.0000000
    InteractText="Use"
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="RestrictedInstigator",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.R6SeqVar_Pawn',LinkedVariables=none,LinkDesc="CurrentInteractor",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Interacted"
    ObjCategory="R6AI"
}