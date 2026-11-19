class RetreatRunnerBrainState extends AxonSquadOrderBrainState;

var KynapseCoverNode newCoverNode;
var Vector RunToPoint;
var export editinline AxonCoverService CoverService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(13);
    GotoState('ParentState');
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationTimer(0.0000000, ActivationEventTripped, 13, 'RetreatTimer');
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function DestroyTransplantBrain()
{
    super(AxonBrainState).DestroyTransplantBrain();
    SquadBrainState.OwningBSS.TripNamedScriptEvent('RunnersArrived');
    //return;    
}

state ParentState extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('FinishRetreat', DestroyTransplantBrain);
        RegisterAxonNamedScriptEventListener('PrePawnDied', DestroyTransplantBrain);
        PushEventStack();
        GotoState('LookForCover');
        //return;        
    }
    stop;    
}

state LookForCover extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(5.0000000, TimedOut);
        CoverService.SubstateFindCover(30, 250, GetBotLocation(), FoundCover);
        CoverService.ClearCoverConstraints();
        CoverService.SetPushHideCovConstraintParams(Controller.fMaxHideAngle);
        CoverService.PushHideCoverConstraint();
        CoverService.PushWithinAffordanceCoverConstraint();
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x39
        if(CoverService.GetNumNodesFound() <= 0)
        {
            DestroyTransplantBrain();            
        }
        else
        {
            newCoverNode = CoverService.GetCoverNode(0);
            GotoState('TryClaimCover');
        }
        //return;        
    }

    function TimedOut()
    {
        DestroyTransplantBrain();
        //return;        
    }
    stop;    
}

state TryClaimCover extends ParentState
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
            GotoState('LookForCover');            
        }
        else
        {
            GotoState('RunToCover');
        }
        //return;        
    }
    stop;    
}

state RunToCover extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, Controller.fMoveSpeed);
        //return;        
    }

    function ArrivedAtCover()
    {
        DestroyTransplantBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHACoverService'Default__RetreatRunnerBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__RetreatRunnerBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonAnimService'Default__RetreatRunnerBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    EventServices=/* Array type was not detected. */
}