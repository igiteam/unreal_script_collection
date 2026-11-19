class HuntBrainState extends AxonControllerBrainState;

var Actor Enemy;
var export editinline AxonEnemyService EnemyService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonCoverService CoverService;
var export editinline AxonPointService PointService;
var export editinline HuntEnemyActivationService ActivationService;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;
var Vector LKP;
var Vector HuntPos;
var name instanceID;

function RegisterActivationEvents()
{
    ActivationService.EnemyService = EnemyService;
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = 3;
    ActivationService.Start(ActivationEventTripped, 'HuntActivation');
    //return;    
}

function ActivationEventTripped()
{
    LKP = ActivationService.LastKnownPosition;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(3);
    GotoState('StartHunt');
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function FoundEnemy()
{
    CoverService.ClearCover();
    //return;    
}

state StartHunt extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateOnCanSeeEnemy(FoundEnemy);
        PushEventStack();
        GotoState('WaitATic');
        //return;        
    }
    stop;    
}

state WaitATic extends StartHunt
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.FocalPoint = LKP;
        RegisterAxonSubstateTimer(1.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('FireAtLKP');
        //return;        
    }
    stop;    
}

state FireAtLKP extends StartHunt
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.FocalPoint = LKP;
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetLongBurst(), BurstDone);
        //return;        
    }

    function BurstDone()
    {
        EnemyService.GetHuntPos(GotHuntPos);
        //return;        
    }

    function GotHuntPos()
    {
        HuntPos = EnemyService.GetGetHuntPosResult();
        GotoState('FindHuntGotoPosition');
        //return;        
    }
    stop;    
}

state FindHuntGotoPosition extends StartHunt
{
    function ChildBeginState(name PreviousStateName)
    {
        PointService.SubstateFindPoint(1, 175, HuntPos, FoundPoint, instanceID);
        PointService.ClearPointConstraints(instanceID);
        PointService.PushPointClaimedConstraint(, instanceID);
        PointService.PushWithinLeashConstraint(instanceID);
        Controller.FocalPoint = LKP;
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetLongBurst(), BurstDone);
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3F
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('bs');
            return;            
        }
        else
        {
            HuntPos = PointService.GetNode(0);
            GotoState('GotoHuntPos');
        }
        //return;        
    }
    stop;    
}

state bs extends StartHunt
{    stop;    
}

state GotoHuntPos extends StartHunt
{
    function ChildBeginState(name PreviousStateName)
    {
        GotoService.SubstateGotoOIR(MoveDone, HuntPos,, 'Aim',, 500.0000000);
        //return;        
    }

    function MoveDone()
    {
        // End:0x26
        if(GotoService.GetMoveFailed())
        {
            GotoState('bs');
            return;
        }
        FinishBrain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonEnemyService'Default__HuntBrainState.HuntEnemyService0'
    begin object name=HuntEnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=HuntEnemyService0
    // Reference: MOHAGotoService'Default__HuntBrainState.HuntService0'
    begin object name=HuntService0 class=Class'MOHAGotoService'
    end object
    GotoService=HuntService0
    // Reference: MOHACoverService'Default__HuntBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonPointService'Default__HuntBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: HuntEnemyActivationService'Default__HuntBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'HuntEnemyActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: BurstFireAxonScriptEvent'Default__HuntBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    instanceID="Hunt"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}