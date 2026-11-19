class SeqAct_AttachToEvent extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Attachee",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    EventLinks[0]=(ExpectedType=Class'SequenceEvent',LinkedEvents=none,LinkDesc="Event",DrawX=0,bHidden=false)
    ObjName="Attach To Event"
    ObjCategory="Event"
}