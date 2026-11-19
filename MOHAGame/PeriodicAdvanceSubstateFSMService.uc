class PeriodicAdvanceSubstateFSMService extends AxonSubstateFSMService
    implements(CoverConstraintProviderInterface);

var float fDurationMin;
var float fDurationMax;
var MOHAScriptAIController Controller;

function Start(float durationMin, float durationMax, MOHAScriptAIController C)
{
    mSubstateMapKey = Name;
    // End:0x25
    if(durationMax < durationMin)
    {
        durationMax = durationMin;
    }
    fDurationMin = durationMin;
    fDurationMax = durationMax;
    Controller = C;
    GotoState('wait');
    //return;    
}

function PushFindCoverConstraints(AxonCoverService covServ, AxonPointService pointServ, name Id)
{
    covServ.PushBasicAggressorFindCoverConstraints(Controller,, Id);
    covServ.PushOutsidePointCoverConstraint(Controller.Pawn.Location, Controller.fPeriodicAdvanceMinDistance, Id);
    pointServ.PushBasicAggressorFindCoverPointConstraints(Controller, true, Id);
    //return;    
}

function ResetClock()
{
    //return;    
}

state wait extends EventMapState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonSubstateTimer(RandRange(fDurationMin, fDurationMax), TimerDone, mSubstateMapKey, mSubstateMapKey);
        owningBrainState.RegisterAxonNamedScriptEventListener('FlankExecuted', ResetClock, mSubstateMapKey);
        owningBrainState.RegisterAxonNamedScriptEventListener('TacaffRetreated', ResetClock, mSubstateMapKey);
        owningBrainState.RegisterAxonNamedScriptEventListener('TacaffAdvanced', ResetClock, mSubstateMapKey);
        //return;        
    }

    function TimerDone()
    {
        GotoState('Engage');
        //return;        
    }

    function ResetClock()
    {
        GotoState('wait',, true);
        //return;        
    }
    stop;    
}

state Engage extends EventMapState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.OwningBSS.PushNamedScriptEventParamName('FindCover', 'CustomConstraintPusher', Name);
        owningBrainState.TriggerAxonNamedScriptEvent('FindCover');
        //return;        
    }
    stop;    
}
