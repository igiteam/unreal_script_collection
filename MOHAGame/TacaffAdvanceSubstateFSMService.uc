class TacaffAdvanceSubstateFSMService extends AxonSubstateFSMService;

var float fDurationMin;
var float fDurationMax;

function Start(float durationMin, float durationMax)
{
    mSubstateMapKey = Name;
    // End:0x25
    if(durationMax < durationMin)
    {
        durationMax = durationMin;
    }
    fDurationMin = durationMin;
    fDurationMax = durationMax;
    GotoState('WaitTacAff');
    //return;    
}

state WaitTacAff extends EventMapState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonNamedScriptEventListener('TacaffAdvanced', WaitToAdvance, mSubstateMapKey);
        //return;        
    }

    function WaitToAdvance()
    {
        GotoState('wait');
        //return;        
    }
    stop;    
}

state wait extends EventMapState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonSubstateTimer(RandRange(fDurationMin, fDurationMax), Execute, mSubstateMapKey, mSubstateMapKey);
        owningBrainState.RegisterAxonNamedScriptEventListener('TacaffAdvanced', Execute, mSubstateMapKey);
        owningBrainState.RegisterAxonNamedScriptEventListener('FlankExecuted', AbortAdvance, mSubstateMapKey);
        owningBrainState.RegisterAxonNamedScriptEventListener('TacaffRetreated', AbortAdvance, mSubstateMapKey);
        //return;        
    }

    function Execute()
    {
        GotoState('WaitTacAff');
        owningBrainState.TriggerAxonNamedScriptEvent('FindCover');
        //return;        
    }

    function AbortAdvance()
    {
        GotoState('wait',, true);
        //return;        
    }
    stop;    
}
