class RetreatAffordanceGotoBrainState extends AffordanceGotoBrainState;

function CustomStart()
{
    SetSuppressionLevel(13);
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationTimer(0.0000000, ActivationEventTripped, 13, 'RetreatTimer');
    //return;    
}

function ActivationEventTripped()
{
    // End:0x15
    if(SquadDest != none)
    {
        ActivateBrain();
    }
    //return;    
}

function DestroyTransplantBrain()
{
    super(AxonBrainState).DestroyTransplantBrain();
    SquadBrainState.OwningBSS.TripNamedScriptEvent('RunnersArrived');
    //return;    
}

function BrainEnded()
{
    DestroyTransplantBrain();
    //return;    
}

function RegisterParentSubstateEvents()
{
    RegisterAxonNamedScriptEventListener('FinishRetreat', DestroyTransplantBrain);
    RegisterAxonNamedScriptEventListener('PrePawnDied', DestroyTransplantBrain);
    //return;    
}

defaultproperties
{
    // Reference: MOHACoverService'Default__RetreatAffordanceGotoBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__RetreatAffordanceGotoBrainState.GotoFNCService0'
    begin object name=GotoFNCService0
    end object
    GotoService=GotoFNCService0
    // Reference: AxonAnimService'Default__RetreatAffordanceGotoBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__RetreatAffordanceGotoBrainState.AffordanceService0'
    begin object name=AffordanceService0
    end object
    AffordanceService=AffordanceService0
    // Reference: AxonPointService'Default__RetreatAffordanceGotoBrainState.PointService0'
    begin object name=PointService0
    end object
    PointService=PointService0
    iSuppressionLevel=13
    instanceID="RetreatAffordanceGoto"
    EventServices=/* Array type was not detected. */
}