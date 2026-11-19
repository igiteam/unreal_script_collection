class FindCoverActivationService extends AxonFSMService
    implements(CoverConstraintProviderInterface);

var int nNumCoverNodes;
var int iMaxEdges;
var int SuppressionLevel;
var export editinline AxonAffordanceService AffordanceService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonAnimService AnimService;
var export editinline AxonCoverService CoverService;
var export editinline AxonPointService PointService;
var MOHAScriptAIController Controller;
var KynapseCoverNode newCoverNode;
var Vector CoverTraversalStart;
var CoverConstraintProviderInterface ConstraintProvider;
var bool bWaitAfterWeFindCover;
var bool bWantToFindCoverAfterSuspended;
var float fSuspendCoverSearchTime;
var float fFindCoverByTime;

function StartFSMService()
{
    ResetFindCoverByTime();
    GotoState('WaitForSignal');
    //return;    
}

function bool FoundCoverInTime()
{
    // End:0x11
    if(fFindCoverByTime < 0.0000000)
    {
        return true;
    }
    return Controller.WorldInfo.TimeSeconds < fFindCoverByTime;
    //return ReturnValue;    
}

function ResetFindCoverByTime()
{
    fFindCoverByTime = -1.0000000;
    //return;    
}

function CustomReset()
{
    newCoverNode = none;
    //return;    
}

function PushFindCoverConstraints(AxonCoverService covServ, AxonPointService pointServ, name Id)
{
    covServ.PushBasicAggressorFindCoverConstraints(Controller,, Id);
    pointServ.PushBasicAggressorFindCoverPointConstraints(Controller, true, Id);
    //return;    
}

function SetupCoverConstraintPusher()
{
    local name PusherName;
    local Object Pusher;

    ConstraintProvider = self;
    // End:0x80
    if(owningBrainState.GetCallbackParamName('CustomConstraintPusher', PusherName))
    {
        Pusher = owningBrainState.OwningBSS.GetObjectFromName(PusherName);
        // End:0x80
        if((Pusher != none) && NotEqual_InterfaceInterface(CoverConstraintProviderInterface(Pusher), CoverConstraintProviderInterface(none)))
        {
            ConstraintProvider = CoverConstraintProviderInterface(Pusher);
        }
    }
    //return;    
}

function PushCoverBlownConstraints()
{
    CoverService.PushBasicAggressorCoverBlownConstraints(Controller, mInstanceID);
    //return;    
}

function PreFindCover()
{
    SetupCoverConstraintPusher();
    //return;    
}

function FindCover()
{
    ResetFindCoverByTime();
    bWaitAfterWeFindCover = false;
    SetupCoverConstraintPusher();
    //return;    
}

function TacaffRetreat()
{
    FindCover();
    //return;    
}

function FindCoverByTime()
{
    local float fFindTime;

    fFindTime = 0.0000000;
    // End:0x6A
    if(owningBrainState.GetCallbackParamFloat('FindTime', fFindTime) && fFindTime > 0.0000000)
    {
        fFindCoverByTime = Controller.WorldInfo.TimeSeconds + fFindTime;
        FindCoverByTimeInternal();
    }
    //return;    
}

function FindCoverByTimeInternal()
{
    bWaitAfterWeFindCover = false;
    SetupCoverConstraintPusher();
    //return;    
}

function OnSuspendCoverSearch()
{
    // End:0x3F
    if(owningBrainState.GetCallbackParamFloat('SuspendTime', fSuspendCoverSearchTime) && fSuspendCoverSearchTime > 0.0000000)
    {
        GotoState('SuspendCoverSearch',, true);
    }
    //return;    
}

state BaseSignalState extends ClearActivationState
{
    function BeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('PreemptiveFindCover', PreFindCover, SuppressionLevel);
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('FindCover', FindCover, SuppressionLevel);
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('FindCoverByTime', FindCoverByTime, SuppressionLevel);
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('TacaffRetreated', TacaffRetreat, SuppressionLevel);
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('FlankExecuted', TacaffRetreat, SuppressionLevel);
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('SuspendCoverSearch', OnSuspendCoverSearch, SuppressionLevel);
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state SuspendCoverSearch extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        bWaitAfterWeFindCover = true;
        bWantToFindCoverAfterSuspended = false;
        owningBrainState.RegisterAxonActivationTimer(fSuspendCoverSearchTime, TimerDone, SuppressionLevel, mInstanceID);
        //return;        
    }

    function FindCover()
    {
        ResetFindCoverByTime();
        bWantToFindCoverAfterSuspended = true;
        bWaitAfterWeFindCover = false;
        SetupCoverConstraintPusher();
        //return;        
    }

    function FindCoverByTimeInternal()
    {
        bWantToFindCoverAfterSuspended = true;
        bWaitAfterWeFindCover = false;
        SetupCoverConstraintPusher();
        //return;        
    }

    function PreFindCover()
    {
        bWantToFindCoverAfterSuspended = true;
        bWaitAfterWeFindCover = true;
        SetupCoverConstraintPusher();
        //return;        
    }

    function TacaffRetreat()
    {
        bWantToFindCoverAfterSuspended = true;
        bWaitAfterWeFindCover = false;
        SetupCoverConstraintPusher();
        GotoState('GetTraversalStart');
        //return;        
    }

    function TimerDone()
    {
        // End:0x1A
        if(bWantToFindCoverAfterSuspended)
        {
            GotoState('GetTraversalStart');            
        }
        else
        {
            GotoState('WaitForSignal');
        }
        //return;        
    }
    stop;    
}

state WaitForSignal extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        bWaitAfterWeFindCover = true;
        //return;        
    }

    function PreFindCover()
    {
        bWaitAfterWeFindCover = true;
        SetupCoverConstraintPusher();
        GotoState('GetTraversalStart');
        //return;        
    }

    function FindCover()
    {
        ResetFindCoverByTime();
        bWaitAfterWeFindCover = false;
        SetupCoverConstraintPusher();
        GotoState('GetTraversalStart');
        //return;        
    }

    function FindCoverByTimeInternal()
    {
        bWaitAfterWeFindCover = false;
        SetupCoverConstraintPusher();
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

state GetTraversalStart extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        AffordanceService.GetTacticalAffordanceTraversalStartActivation(OnGetTraversalStart, SuppressionLevel);
        //return;        
    }

    function OnGetTraversalStart()
    {
        // End:0x3A
        if(!AffordanceService.GetTacAffTraversalStartResult(CoverTraversalStart))
        {
            CoverTraversalStart = Controller.Pawn.Location;
        }
        GotoState('LookForCover');
        //return;        
    }
    stop;    
}

state LookForCover extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        CoverService.RegisterAxonActivationFindCover(nNumCoverNodes, iMaxEdges, CoverTraversalStart, FoundCover, SuppressionLevel, mInstanceID);
        ConstraintProvider.PushFindCoverConstraints(CoverService, PointService, mInstanceID);
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('WaitForSignal');
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x3F
        if(CoverService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');
            return;            
        }
        else
        {
            newCoverNode = CoverService.GetCoverNode(0);
            GotoState('TryClaimCover');
        }
        //return;        
    }

    function TacaffRetreat()
    {
        bWaitAfterWeFindCover = false;
        SetupCoverConstraintPusher();
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

state wait extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationTimer(2.0000000, TimerDone, SuppressionLevel, mInstanceID);
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('WaitForSignal');
        //return;        
    }

    function TimerDone()
    {
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

state TryClaimCover extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClaimCoverActivationEvent(newCoverNode.GetId(), ClaimResult, SuppressionLevel);
        //return;        
    }

    function ClaimResult()
    {
        // End:0x29
        if(!CoverService.GetClaimResult())
        {
            GotoState('wait');            
        }
        else
        {
            GotoState('WaitAfterFoundNode');
        }
        //return;        
    }
    stop;    
}

state WaitAfterFoundNode extends BaseSignalState
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x22
        if(!bWaitAfterWeFindCover && FoundCoverInTime())
        {
            Finish();
            return;
        }
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        CoverService.RegisterAxonActivationCoverBlown(OnCoverBlown, SuppressionLevel,, mInstanceID);
        CoverService.PushBasicAggressorCoverBlownConstraints(Controller, mInstanceID);
        //return;        
    }

    function OnLostEnemy()
    {
        GotoState('WaitForSignal');
        //return;        
    }

    function FindCover()
    {
        Finish();
        //return;        
    }

    function FindCoverByTimeInternal()
    {
        Finish();
        //return;        
    }

    function OnCoverBlown()
    {
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

defaultproperties
{
    nNumCoverNodes=10
    iMaxEdges=150
    fFindCoverByTime=-1.0000000
}