class IdleLeashGotoBrainState extends IdleAffordanceGotoBrainState;

var export editinline AxonLeashService LeashService;

function RegisterActivationEvents()
{
    LeashService.RegisterAxonActivationCheckWithinLeash(ActivationEventTripped, iSuppressionLevel, instanceID);
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function BrainEnded()
{
    FinishBrain();
    //return;    
}

function ArrivedAtLeash()
{
    CoverTraversalStart = Controller.Pawn.Location;
    SetSuppressionLevel(4);
    GotoState('RunLookForCover');
    //return;    
}

function RegisterParentSubstateEvents()
{
    //return;    
}

function RegisterCustomeSubstateTransition()
{
    LeashService.SubstateArrivedAtLeash(ArrivedAtLeash, instanceID);
    //return;    
}

function PushCustomCoverConstraints()
{
    CoverService.PushWithinLeashCoverConstraint(, instanceID);
    //return;    
}

function Vector GetLeashTraversalStartPos()
{
    local MOHAAIPawn P;

    P = MOHAAIPawn(Controller.Pawn);
    // End:0x7A
    if(P != none)
    {
        // End:0x55
        if(P.LeashVolume != none)
        {
            return P.LeashVolume.GetCentroid();
        }
        // End:0x7A
        if(P.fLeashRadius > float(0))
        {
            return P.vLeashHome;
        }
    }
    return GetBotLocation();
    //return ReturnValue;    
}

state LookForPoint
{
    function ChildBeginState(name PreviousStateName)
    {
        PointService.SubstateFindPoint(1, 100, GetLeashTraversalStartPos(), FoundPoint, instanceID);
        RegisterCustomSubstateTransition();
        PointService.ClearPointConstraints(instanceID);
        PointService.PushPointClaimedConstraint(, instanceID);
        PointService.PushWithinLeashConstraint(instanceID);
        //return;        
    }
    stop;    
}

state wait
{
    function TimerDone()
    {
        GotoState('LookForPoint');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonLeashService'Default__IdleLeashGotoBrainState.LeashService0'
    begin object name=LeashService0 class=Class'EAKynapse.AxonLeashService'
    end object
    LeashService=LeashService0
    // Reference: MOHACoverService'Default__IdleLeashGotoBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__IdleLeashGotoBrainState.GotoFNCService0'
    begin object name=GotoFNCService0
    end object
    GotoService=GotoFNCService0
    // Reference: AxonAnimService'Default__IdleLeashGotoBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__IdleLeashGotoBrainState.AffordanceService0'
    begin object name=AffordanceService0
    end object
    AffordanceService=AffordanceService0
    // Reference: AxonPointService'Default__IdleLeashGotoBrainState.PointService0'
    begin object name=PointService0
    end object
    PointService=PointService0
    iSuppressionLevel=13
    instanceID="LeashGoto"
    EventServices=/* Array type was not detected. */
}