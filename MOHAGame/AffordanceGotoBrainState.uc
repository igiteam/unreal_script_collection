class AffordanceGotoBrainState extends AxonSquadOrderBrainState
    abstract;

var export editinline AxonCoverService CoverService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;
var KynapseSquadNode SquadDest;
var export editinline AxonAffordanceService AffordanceService;
var export editinline AxonPointService PointService;
var Vector RunPosition;
var bool bRunPositionSet;
var bool bRunning;
var int iSuppressionLevel;
var name instanceID;

function StartBrain()
{
    bRunPositionSet = false;
    Controller.bAimAtFocus = false;
    Controller.bInIdleState = true;
    CustomStart();
    super(AxonBrainState).StartBrain();
    // End:0x61
    if(Controller.IsMountedInCover())
    {
        GotoState('PreHide');        
    }
    else
    {
        GotoState('ParentState');
    }
    bRunning = false;
    //return;    
}

function ResetBrain()
{
    super(AxonBrainState).ResetBrain();
    //return;    
}

function StandardFinish()
{
    Controller.bInIdleState = false;
    Controller.bAimAtFocus = true;
    super(AxonBrainState).StandardFinish();
    //return;    
}

function CustomStart()
{
    SetSuppressionLevel(iSuppressionLevel);
    //return;    
}

function RegisterActivationEvents()
{
    AffordanceService.RegisterAxonActivationCheckWithinAffordance(ActivationEventTripped, iSuppressionLevel, instanceID);
    //return;    
}

function ActivationEventTripped()
{
    SquadDest = AffordanceService.GetSquadNodeFromCallback();
    // End:0x2E
    if(SquadDest != none)
    {
        ActivateBrain();
    }
    //return;    
}

function BrainEnded()
{
    FinishBrain();
    //return;    
}

function NewAffordanceDest()
{
    // End:0x1B
    if(!bRunning)
    {
        GotoState('LookForPoint',, true);
        return;
    }
    SquadDest = AffordanceService.GetSquadNodeFromCallback();
    // End:0x50
    if(SquadDest != none)
    {
        GotoState('RunLookForPoint',, true);        
    }
    else
    {
        BrainEnded();
    }
    //return;    
}

function RegisterParentSubstateEvents()
{
    AffordanceService.SubstateOnNewAffordanceDest(NewAffordanceDest, instanceID);
    //return;    
}

function RegisterCustomSubstateTransition()
{
    //return;    
}

function Dummy()
{
    //return;    
}

state PreHide extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.SetActivityStartCallback(HideComplete);
        AnimService.RegisterAnimationEvent('Hide', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier * 1.5000000, 'Crouch_Center');
        //return;        
    }

    function HideComplete()
    {
        GotoState('ParentState');
        //return;        
    }
    stop;    
}

state ParentState extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterParentSubstateEvents();
        PushEventStack();
        GotoState('LookForPoint');
        //return;        
    }
    stop;    
}

state LookForPoint extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        PointService.SubstateFindPoint(1, 100, SquadDest.GetSafeTraversalStartPos(), FoundPoint, instanceID);
        RegisterCustomSubstateTransition();
        PointService.ClearPointConstraints(instanceID);
        PointService.PushPointClaimedConstraint(, instanceID);
        PointService.PushPointWithinAffordanceConstraint(,, false, instanceID);
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3F
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');
            return;            
        }
        else
        {
            bRunPositionSet = true;
            RunPosition = PointService.GetNode(0);
            GotoState('RunToPoint');
        }
        //return;        
    }

    function TimerDone()
    {
        BrainEnded();
        //return;        
    }
    stop;    
}

state RunLookForPoint extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClearCover();
        // End:0x5B
        if(bRunPositionSet)
        {
            GotoService.SubstateGotoOIR(Dummy, RunPosition,, 'Aim',, Controller.fMoveSpeed);
        }
        PointService.SubstateFindPoint(1, 100, SquadDest.GetSafeTraversalStartPos(), FoundPoint, instanceID);
        RegisterCustomSubstateTransition();
        ChildRegisterPointConstraints();
        //return;        
    }

    function ChildRegisterPointConstraints()
    {
        PointService.ClearPointConstraints(instanceID);
        PointService.PushWithinLeashConstraint(instanceID);
        PointService.PushPointClaimedConstraint(, instanceID);
        PointService.PushPointWithinAffordanceConstraint(,, false, instanceID);
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3F
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');
            return;            
        }
        else
        {
            bRunPositionSet = true;
            RunPosition = PointService.GetNode(0);
            GotoState('RunToPoint');
        }
        //return;        
    }
    stop;    
}

state wait extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(5.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        BrainEnded();
        //return;        
    }
    stop;    
}

state RunToPoint extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        bRunning = true;
        CoverService.ClearCover();
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(2);
        GotoService.SubstateGotoOIR(ArrivedAtPoint, RunPosition,, 'Aim',, Controller.fMoveSpeed);
        RegisterCustomSubstateTransition();
        //return;        
    }

    function ArrivedAtPoint()
    {
        bRunning = false;
        // End:0x2E
        if(GotoService.GetMoveFailed())
        {
            GotoState('wait');
            return;
        }
        BrainEnded();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHACoverService'Default__AffordanceGotoBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__AffordanceGotoBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonAnimService'Default__AffordanceGotoBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__AffordanceGotoBrainState.AffordanceService0'
    begin object name=AffordanceService0 class=Class'EAKynapse.AxonAffordanceService'
    end object
    AffordanceService=AffordanceService0
    // Reference: AxonPointService'Default__AffordanceGotoBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    instanceID="AffordanceGoto"
    EventServices=/* Array type was not detected. */
}