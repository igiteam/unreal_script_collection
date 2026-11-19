class SeqAct_ActivateRemoteEvent extends SequenceAction
    native
    hidecategories(Object);

var() name EventName;

defaultproperties
{
    EventName="DefaultEvent"
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Activate Remote Event"
    ObjCategory="Event"
}