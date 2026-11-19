class UTSeqEvent_FlagEvent extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object);

function Trigger(name EventType, Controller EventInstigator)
{
    local array<int> ActivateIndices;
    local int I;
    local SeqVar_Object ObjVar;

    I = 0;
    J0x0B:

    // End:0x85 [Loop If]
    if(I < OutputLinks.Length)
    {
        // End:0x77
        if(EventType == name(OutputLinks[I].LinkDesc))
        {
            ActivateIndices[ActivateIndices.Length] = I;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0xFB
    if(ActivateIndices.Length == 0)
    {
        ScriptLog(((("Not activating" @ string(self)) @ "for event") @ string(EventType)) @ "because there are no matching outputs");        
    }
    else
    {
        // End:0x17A
        if(CheckActivate(Originator, EventInstigator, false, ActivateIndices))
        {
            // End:0x179
            foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
            {
                ObjVar.SetObjectValue(EventInstigator);                
            }            
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Taken",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Dropped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Returned",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[3]=(Links=none,LinkDesc="Captured",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    ObjName="Flag Event"
}