class PlayerStartWanderBrainState extends AxonControllerBrainState;

var() float WaitDurationA;
var() float WaitDurationB;
var export editinline MOHAGotoService GotoService;
var array<Actor> ClaimedPoints;
var Actor curpoint;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
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

function Actor FindFurthestNavPoint()
{
    local NavigationPoint np, Best;
    local float bestDist, curDist;
    local bool bIsClaimed;

    bestDist = 0.0000000;
    Best = none;
    // End:0x97
    foreach Controller.AllActors(Class'Engine.NavigationPoint', np)
    {
        curDist = VSize(np.Location - (GetBotLocation()));
        bIsClaimed = ClaimedPoints.Find(np) >= 0;
        // End:0x96
        if((curDist > bestDist) && !bIsClaimed)
        {
            Best = np;
            bestDist = curDist;
        }        
    }    
    return Best;
    //return ReturnValue;    
}

state wait extends AxonBaseState
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        RegisterAxonSubstateTimer(WaitDurationA, TimerDone);
        ClaimedPoints.Length = 0;
        //return;        
    }

    function TimerDone()
    {
        GotoState('FindPoint');
        //return;        
    }
    stop;    
}

state FindPoint extends AxonBaseState
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        curpoint = FindFurthestNavPoint();
        GotoState('GotoPoint');
        //return;        
    }
    stop;    
}

state GotoPoint extends AxonBaseState
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x26
        if(curpoint == none)
        {
            GotoState('wait');
            return;
        }
        GotoService.SubstateGotoOIR(arrived, curpoint.Location,, 'Aim');
        //return;        
    }

    function arrived()
    {
        // End:0x6B
        if(GotoService.GetMoveFailed() == true)
        {
            Controller.DrawDebugCoordinateSystem(curpoint.Location, rot(0, 0, 0), 100.0000000, false);
            ClaimedPoints[ClaimedPoints.Length] = curpoint;
            GotoState('FindPoint');
            return;
        }
        GotoState('wait');
        //return;        
    }
    stop;    
}

defaultproperties
{
    WaitDurationA=0.1000000
    WaitDurationB=0.5000000
    // Reference: MOHAGotoService'Default__PlayerStartWanderBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    EventServices=/* Array type was not detected. */
}