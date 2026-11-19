class TurokSeqEvent_MPAIWaveDead extends SequenceEvent
    hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Interim Wave",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Last Wave",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="MP AI Wave Dead"
    ObjCategory="Turok Multiplayer"
}