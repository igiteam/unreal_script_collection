class OutOfCoverPerformanceBrainState extends AxonControllerBrainState;

var FixedFireOIRImpl FFImpl;
var export editinline AxonAnimService AnimService;
var export editinline OutOfCoverPerformanceActivationService ActivationService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var export editinline LODStatusScriptEvent LODStatusEvent;
var Pawn Shooter;
var bool bActivatedOnce;

function RegisterActivationEvents()
{
    // End:0x0B
    if(bActivatedOnce)
    {
        return;
    }
    ActivationService.Controller = Controller;
    ActivationService.EnemyService = EnemyService;
    ActivationService.CoverService = CoverService;
    ActivationService.SuppressionLevel = 8;
    ActivationService.Start(ActivationEventTripped, Name);
    //return;    
}

function ActivationEventTripped()
{
    Shooter = ActivationService.Shooter;
    FFImpl = MOHAAIPawn(GetBot()).FFImpl;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(8);
    LODStatusEvent.RegisterLODStatusChangeEvent(Controller, WentToSleep, 'Background');
    GotoState('wait');
    //return;    
}

function WentToSleep()
{
    FinishBrain();
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    FFImpl.ResetPointTarget();
    super(AxonBrainState).StandardFinish();
    //return;    
}

state wait extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(0.5000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state Aim extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Aim', AimFinished, FFImpl);
        //return;        
    }

    function AimFinished()
    {
        // End:0x32
        if((Shooter != none) && Shooter.Health > 0)
        {
            GotoState('Point');            
        }
        else
        {
            FinishBrain();
        }
        //return;        
    }
    stop;    
}

state Point extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        FFImpl.SetPointTarget(Shooter.Location);
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('SPoint', AnimDone, FFImpl);
        //return;        
    }

    function AnimDone()
    {
        GotoState('HoldPoint');
        //return;        
    }
    stop;    
}

state HoldPoint extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(1.5000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('PointRight');
        //return;        
    }
    stop;    
}

state PointAround extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        SetPointTarget();
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Point', AnimDone, FFImpl);
        //return;        
    }
    stop;    
}

state PointRight extends PointAround
{
    function SetPointTarget()
    {
        FFImpl.SetPointTarget(GetBot().Location + (Vector(GetBot().Rotation + rot(0, 16384, 0)) * float(512)));
        //return;        
    }

    function AnimDone()
    {
        GotoState('PointLeft');
        //return;        
    }
    stop;    
}

state PointLeft extends PointAround
{
    function SetPointTarget()
    {
        FFImpl.SetPointTarget(GetBot().Location + (Vector(GetBot().Rotation - rot(0, 16384, 0)) * float(512)));
        //return;        
    }

    function AnimDone()
    {
        GotoState('PointFinal');
        //return;        
    }
    stop;    
}

state PointFinal extends Point
{
    function AnimDone()
    {
        GotoState('HoldPointFinal');
        //return;        
    }
    stop;    
}

state HoldPointFinal extends HoldPoint
{
    function TimerDone()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__OutOfCoverPerformanceBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: OutOfCoverPerformanceActivationService'Default__OutOfCoverPerformanceBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'OutOfCoverPerformanceActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: AxonEnemyService'Default__OutOfCoverPerformanceBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: MOHACoverService'Default__OutOfCoverPerformanceBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: LODStatusScriptEvent'Default__OutOfCoverPerformanceBrainState.LODStatusEvent0'
    begin object name=LODStatusEvent0 class=Class'LODStatusScriptEvent'
    end object
    LODStatusEvent=LODStatusEvent0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}