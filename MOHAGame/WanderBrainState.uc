class WanderBrainState extends AxonControllerBrainState;

var() float WaitDurationA;
var() float WaitDurationB;
var() float MinWanderDist;
var() float MaxWanderDist;
var Vector vDest;
var export editinline AxonPointService PointService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonCoverService CoverService;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(15);
    GotoState('wait');
    //return;    
}

function FinishBrain()
{
    super(AxonBrainState).FinishBrain();
    //return;    
}

function TimerDone()
{
    //return;    
}

function arrived()
{
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationTimer(0.0000000, ActivationEventTripped, 15);
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

state wait extends AxonBaseState
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        RegisterAxonSubstateTimer(WaitDurationA, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('GatherPoints');
        //return;        
    }
    stop;    
}

state GatherPoints extends AxonBaseState
{
    event BeginState(name PreviousStateName)
    {
        local Vector startPos;

        super.BeginState(PreviousStateName);
        startPos = GetBotLocation();
        PointService.SubstateFindPoint(25, 512, startPos, FoundPoints, 'Wander');
        PointService.ClearPointConstraints('Wander');
        PointService.PushPointClaimedConstraint(100.0000000, 'Wander');
        PointService.PushPointDistanceEnvelopeConstraint(MinWanderDist, MaxWanderDist, MinWanderDist * 1.1000000, MaxWanderDist * 0.9000000, GetBotLocation(), 50.0000000,, 'Wander');
        //return;        
    }

    function FoundPoints()
    {
        local int I;

        PointService.OnFindPointCallBack();
        // End:0x3C
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');
            return;
        }
        I = Rand(PointService.GetNumNodesFound());
        vDest = PointService.GetNode(I);
        GotoState('RunToPoint');
        //return;        
    }
    stop;    
}

state RunToPoint extends AxonBaseState
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        CoverService.ClearCover();
        GotoService.SubstateGotoOIR(ArrivedAtPoint, vDest,, 'Aim');
        //return;        
    }

    function ArrivedAtPoint()
    {
        // End:0x19
        if(GotoService.GetMoveFailed() == true)
        {
        }
        GotoState('GatherPoints');
        //return;        
    }
    stop;    
}

defaultproperties
{
    WaitDurationA=0.5000000
    WaitDurationB=0.5000000
    MinWanderDist=2000.0000000
    MaxWanderDist=10000.0000000
    // Reference: AxonPointService'Default__WanderBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__WanderBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: MOHACoverService'Default__WanderBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    EventServices=/* Array type was not detected. */
}