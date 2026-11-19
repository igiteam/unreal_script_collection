class CCHideBrainState extends AxonControllerBrainState;

var int nNumCoverNodes;
var int iMaxEdges;
var Vector CoverTraversalStart;
var KynapseCoverNode newCoverNode;
var name instanceID;
var export editinline AxonCoverService CoverService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonAnimService AnimService;
var export editinline AxonAffordanceService AffordanceService;
var export editinline CCRequestPerformanceAxonScriptEvent CCRequestEvent;
var export editinline CCAwaitPerformanceAxonScriptEvent CCAwaitEvent;

function RegisterActivationEvents()
{
    CoverService.RegisterActivationOnCoverUnmounted(ActivationEventTripped, 18, 'CCHideBrainActivation');
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
    SetSuppressionLevel(18);
    GotoState('WaitATic');
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

state WaitATic extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', None, Controller.GetCurrentCoverNode());
        RegisterAxonSubstateTimer(0.1000000, TimerDone);
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

state LookForCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.SubstateFindCover(nNumCoverNodes, iMaxEdges, CoverTraversalStart, FoundCover, instanceID);
        CoverService.PushBasicAggressorFindCoverConstraints(Controller,, instanceID);
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x3F
        if(CoverService.GetNumNodesFound() <= 0)
        {
            GotoState('WaitATic');
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
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, Controller.fMoveSpeed);
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
        AnimService.RegisterAnimationEvent('Hide', FinishAnim, Controller.GetCurrentCoverNode());
        //return;        
    }

    function FinishAnim()
    {
        GotoState('AwaitBlockingPerformance');
        //return;        
    }
    stop;    
}

state AwaitBlockingPerformance extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CCRequestEvent.Register(Controller, PerformanceReady);
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
        RegisterAxonSubstateStimulus('BulletImpact', 'BulletImpact', PerformanceDone);
        //return;        
    }

    function PerformanceDone()
    {
        GotoState('AwaitBlockingPerformance');
        //return;        
    }
    stop;    
}

defaultproperties
{
    nNumCoverNodes=10
    iMaxEdges=150
    instanceID="CCHideBrain"
    // Reference: MOHACoverService'Default__CCHideBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__CCHideBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonEnemyService'Default__CCHideBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: AxonAnimService'Default__CCHideBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__CCHideBrainState.AffordanceService0'
    begin object name=AffordanceService0 class=Class'EAKynapse.AxonAffordanceService'
    end object
    AffordanceService=AffordanceService0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__CCHideBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0 class=Class'CCRequestPerformanceAxonScriptEvent'
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__CCHideBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0 class=Class'CCAwaitPerformanceAxonScriptEvent'
    end object
    CCAwaitEvent=CCAwaitEvent0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}