class SeqEvent_R6AIHearGunfire extends SequenceEvent
    native
    hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    ReTriggerDelay=0.2000000
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Ally",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Enemy",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.R6SeqVar_Pawn',LinkedVariables=none,LinkDesc="Noise Maker",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Heard Gunfire"
    ObjCategory="R6AI"
}