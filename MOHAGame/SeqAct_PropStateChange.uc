class SeqAct_PropStateChange extends SequenceAction
    hidecategories(Object);

var() int SpecialState;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Prev",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Next",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[2]=(LinkDesc="Special",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Prop",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Change Prop State"
    ObjCategory="Actor"
}