class SeqAct_Toggle extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Bool',LinkedVariables=none,LinkDesc="Bool",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    EventLinks[0]=(ExpectedType=Class'SequenceEvent',LinkedEvents=none,LinkDesc="Event",DrawX=0,bHidden=false)
    ObjName="Toggle"
    ObjCategory="Toggle"
}