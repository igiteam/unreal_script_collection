class IdleBrainState extends AxonControllerBrainState;

var export editinline AxonCoverService CoverService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonAnimService AnimService;
var export editinline AxonAffordanceService AffordanceService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonPointService PointService;
var Vector TraversalStart;
var Vector RunPosition;
var Vector OrigPosition;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    GotoState('WaitIdle');
    //return;    
}

function RegisterActivationEvents()
{
    GeneralInit();
    //return;    
}

function GeneralInit()
{
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    Controller.SetNextFixedFireOIRData(Controller.Pawn.Location, 'Aim', true);
    //return;    
}

state WaitIdle extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(3.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        // End:0x23
        if(Controller.bUsesCover)
        {
            GotoState('ClearCover');            
        }
        else
        {
            GotoState('GetTraversalStart');
        }
        //return;        
    }
    stop;    
}

state ClearCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClearCover(0);
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
        if(!AffordanceService.GetTacAffTraversalStartResult(TraversalStart))
        {
            TraversalStart = GetBot().Location;
        }
        GotoState('LookForPoint');
        //return;        
    }
    stop;    
}

state LookForPoint extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        OrigPosition = GetBotLocation();
        PointService.SubstateFindPoint(1, 256, TraversalStart, FoundPoint, Name);
        PointService.PushBasicAggressorFindCoverPointConstraints(Controller, true, Name);
        PointService.PushPointClaimedConstraint(, Name);
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3F
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('SitAround');
            return;            
        }
        else
        {
            RunPosition = PointService.GetNode(0);
            GotoState('RunToPoint');
        }
        //return;        
    }
    stop;    
}

state RunToPoint extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(2);
        GotoService.SubstateGotoOIR(ArrivedAtPoint, RunPosition,, 'Aim',, Controller.fMoveSpeed);
        //return;        
    }

    function ArrivedAtPoint()
    {
        // End:0x26
        if(GotoService.GetMoveFailed())
        {
            GotoState('WaitAndTryAgain');
            return;
        }
        GotoState('SitAround');
        //return;        
    }
    stop;    
}

state SitAround extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        RegisterAxonNamedScriptEventListener('TacaffAdvanced', GoAgain);
        //return;        
    }

    function GoAgain()
    {
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

state WaitAndTryAgain extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(3.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('GetTraversalStart');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHACoverService'Default__IdleBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonEnemyService'Default__IdleBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: AxonAnimService'Default__IdleBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__IdleBrainState.AffordanceService0'
    begin object name=AffordanceService0 class=Class'EAKynapse.AxonAffordanceService'
    end object
    AffordanceService=AffordanceService0
    // Reference: MOHAGotoService'Default__IdleBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonPointService'Default__IdleBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    EventServices=/* Array type was not detected. */
}