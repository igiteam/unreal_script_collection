class SeqEvent_Switch extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    PopulateLinkedVariableValues();
    //return;    
}

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Switched On",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Released",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    ObjName="Switch"
}