class SeqAct_AttachToActor extends SequenceAction
    hidecategories(Object);

var() bool bDetach;
var() bool bUseRelativeOffset;
var() bool bUseRelativeRotation;
var() name BoneName;
var() Vector RelativeOffset;
var() Rotator RelativeRotation;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Attachment",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Attach to Actor"
    ObjCategory="Actor"
}