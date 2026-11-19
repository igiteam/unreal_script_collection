class IdleCoverBrainState extends AxonControllerBrainState;

var int nNumCoverNodes;
var int iMaxEdges;
var Vector CoverTraversalStart;
var KynapseCoverNode newCoverNode;
var name instanceID;
var export editinline AxonCoverService CoverService;
var export editinline AxonPointService PointService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonAnimService AnimService;
var export editinline AxonAffordanceService AffordanceService;
var export editinline CCRequestPerformanceAxonScriptEvent CCRequestEvent;
var export editinline CCAwaitPerformanceAxonScriptEvent CCAwaitEvent;
var export editinline NoCoverNoEnemyActivationService ActivationService;

function RegisterActivationEvents()
{
    ActivationService.CoverService = CoverService;
    ActivationService.EnemyService = EnemyService;
    ActivationService.SuppressionLevel = 1;
    ActivationService.Start(ActivationEventTripped, instanceID);
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    Controller.bInIdleState = true;
    Controller.bAimAtFocus = false;
    SetSuppressionLevel(1);
    GotoState('WaitATic');
    //return;    
}

function RegisterCoverBlown()
{
    CoverService.SubstateCoverBlown(CoverBlown,, instanceID);
    CoverService.ClearCoverConstraints("CoverBlown", instanceID);
    CoverService.PushNearPlayerCoverConstraint("CoverBlown",, instanceID);
    CoverService.PushIdleCoverPointConstraint("CoverBlown",,, true, false,, instanceID);
    //return;    
}

function StandardFinish()
{
    Controller.bAimAtFocus = true;
    Controller.bInIdleState = false;
    super(AxonBrainState).StandardFinish();
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function RestartSearch()
{
    GotoState('GetTraversalStart');
    //return;    
}

function CoverBlown()
{
    RestartSearch();
    //return;    
}

state WaitATic extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local FixedFireOIRImpl FFImpl;

        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        FFImpl = MOHAAIPawn(GetBot()).FFImpl;
        AnimService.RegisterAnimationEvent('Aim', None, FFImpl);
        RegisterAxonSubstateTimer(0.1000000, TimerDone);
        RegisterCoverBlown();
        //return;        
    }

    function TimerDone()
    {
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

state WaitPostTraversalFailure extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local FixedFireOIRImpl FFImpl;

        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        FFImpl = MOHAAIPawn(GetBot()).FFImpl;
        AnimService.RegisterAnimationEvent('Aim', None, FFImpl);
        RegisterAxonSubstateTimer(10.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

state GetTraversalStart extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AffordanceService.GetTacticalAffordanceTraversalStart(OnGetTraversalStart);
        //return;        
    }

    function OnGetTraversalStart()
    {
        // End:0x36
        if(!AffordanceService.GetTacAffTraversalStartResult(CoverTraversalStart))
        {
            CoverTraversalStart = GetBot().Location;
        }
        GotoState('LookForCover');
        //return;        
    }
    stop;    
}

state LookForCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.SubstateFindCover(nNumCoverNodes, iMaxEdges, CoverTraversalStart, FoundCover, instanceID);
        CoverService.PushBasicAggressorFindCoverConstraints(Controller,, instanceID);
        CoverService.PushIdleCoverPointConstraint(, 1500.0000000, 500.0000000, true, false,, instanceID);
        PointService.PushBasicAggressorFindCoverPointConstraints(Controller, true, instanceID);
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', RestartSearch);
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x4F
        if(CoverService.GetNumNodesFound() <= 0)
        {
            Controller.IdleCoverActor = none;
            GotoState('WaitPostTraversalFailure');
            return;            
        }
        else
        {
            newCoverNode = CoverService.GetCoverNode(0);
            GotoState('TryClaimCover');
        }
        //return;        
    }
    stop;    
}

state TryClaimCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClaimCover(newCoverNode.GetId(), ClaimResult);
        RegisterCoverBlown();
        //return;        
    }

    function ClaimResult()
    {
        // End:0x29
        if(!CoverService.GetClaimResult())
        {
            GotoState('WaitATic');            
        }
        else
        {
            GotoState('RunToCover');
        }
        //return;        
    }
    stop;    
}

state RunToCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(GetBot()).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, Controller.fMoveSpeed);
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', RestartSearch);
        RegisterCoverBlown();
        //return;        
    }

    function ArrivedAtCover()
    {
        // End:0x3E
        if(GotoService.GetMoveFailed())
        {
            CoverService.ClearCover(1000);
            GotoState('WaitATic');
            return;
        }
        GotoState('FirstHide');
        //return;        
    }
    stop;    
}

state FirstHide extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Hide', FinishAnim, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
        CCRequestEvent.Register(Controller, PerformanceReady);
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', RestartSearch);
        RegisterCoverBlown();
        //return;        
    }

    function FinishAnim()
    {
        GotoState('WaitAFew');
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('Perform');
        //return;        
    }
    stop;    
}

state Perform extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CCAwaitEvent.Register(Controller, PerformanceDone);
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', RestartSearch);
        //return;        
    }

    function PerformanceDone()
    {
        GotoState('LookAround');
        //return;        
    }
    stop;    
}

state WaitAFew extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.SubstateOnCoverUnmounted(CoverUnmounted);
        CCRequestEvent.Register(Controller, PerformanceReady);
        RegisterAxonSubstateTimer(RandRange(Controller.fMinPeekTime, Controller.fMaxPeekTime) * 2.0000000, TimerDone);
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', RestartSearch);
        RegisterCoverBlown();
        //return;        
    }

    function TimerDone()
    {
        GotoState('LookAround');
        //return;        
    }

    function CoverUnmounted()
    {
        GotoState('GetTraversalStart');
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('Perform');
        //return;        
    }
    stop;    
}

state LookAround extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.SubstateOnCoverUnmounted(CoverUnmounted);
        AnimService.SetActivityStartCallback(PeekExposed);
        AnimService.RegisterAnimationEvent('Peek', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverAimTransitionSpeedMultiplier);
        CCRequestEvent.Register(Controller, PerformanceReady);
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', RestartSearch);
        RegisterCoverBlown();
        //return;        
    }

    function PeekExposed()
    {
        RegisterAxonSubstateTimer(RandRange(Controller.fMinPeekTime, Controller.fMaxPeekTime) * 3.0000000, ShouldHide);
        //return;        
    }

    function ShouldHide()
    {
        GotoState('FirstHide');
        //return;        
    }

    function CoverUnmounted()
    {
        GotoState('GetTraversalStart');
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('Perform');
        //return;        
    }
    stop;    
}

defaultproperties
{
    nNumCoverNodes=10
    iMaxEdges=150
    instanceID="IdleCover"
    // Reference: MOHACoverService'Default__IdleCoverBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonPointService'Default__IdleCoverBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__IdleCoverBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonEnemyService'Default__IdleCoverBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: AxonAnimService'Default__IdleCoverBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__IdleCoverBrainState.AffordanceService0'
    begin object name=AffordanceService0 class=Class'EAKynapse.AxonAffordanceService'
    end object
    AffordanceService=AffordanceService0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__IdleCoverBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0 class=Class'CCRequestPerformanceAxonScriptEvent'
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__IdleCoverBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0 class=Class'CCAwaitPerformanceAxonScriptEvent'
    end object
    CCAwaitEvent=CCAwaitEvent0
    // Reference: NoCoverNoEnemyActivationService'Default__IdleCoverBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'NoCoverNoEnemyActivationService'
    end object
    ActivationService=ActivationService0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}