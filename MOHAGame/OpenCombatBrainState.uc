class OpenCombatBrainState extends CombatBrainState;

var export editinline CanShootEnemyActivationService ActivationService;
var export editinline AxonPointService PointService;
var export editinline MOHAGotoService GotoService;
var export editinline LODStatusScriptEvent LODStatusEvent;
var int CurrentBursts;
var Vector RunPosition;
var bool bWantsToHide;
var Vector PreHidePosition;
var Pawn PreHideEnemy;
var FixedFireOIRImpl FFImpl;
var int iEnemyTimeout;
var() int iMaxTraversalEdges;
var() int iShootPointsToFind;

function StartBrain()
{
    RunPosition = vect(0.0000000, 0.0000000, 0.0000000);
    PreHidePosition = vect(0.0000000, 0.0000000, 0.0000000);
    FFImpl = MOHAAIPawn(GetBot()).FFImpl;
    super.StartBrain();
    TriggerAxonNamedScriptEvent('PreemptiveFindCover');
    //return;    
}

function RegisterActivationEvents()
{
    ActivationService.CoverService = CoverService;
    ActivationService.EnemyService = EnemyService;
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = iSuppressionLevel;
    ActivationService.Start(ActivationEventTripped, 'OpenCombatActivation');
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function BurstDone()
{
    //return;    
}

function PlayerShotNear()
{
    SetPlayerShotAtThreat();
    GotoState('ResetEnemy');
    //return;    
}

function Hide()
{
    ChildHide();
    //return;    
}

function ChildHide()
{
    GotoState('FindHidePoint');
    //return;    
}

function UnHide()
{
    ChildUnHide();
    //return;    
}

function ChildUnHide()
{
    //return;    
}

function RegisterParentSubstateEvents()
{
    DecaySuppressionEvent.__AboveThreshholdCB__Delegate = Hide;
    DecaySuppressionEvent.__BelowSafeCB__Delegate = UnHide;
    DecaySuppressionEvent.Register(Controller, MOHAPawn(Controller.Focus));
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    EnemyService.AddCoverBlowerThreatAssessment();
    //return;    
}

function InitStartCombat()
{
    RegisterBackGroundEvents();
    GotoState('Aim');
    //return;    
}

function RegisterFindShootPointConstraints()
{
    PointService.ClearPointConstraints(instanceID);
    PointService.PushPointDistanceEnvelopeConstraint(150.0000000, 50000.0000000, 200.0000000, 50000.0000000, GetBotLocation(), 5000.0000000, true, instanceID);
    PointService.PushWithinLeashConstraint(instanceID);
    PointService.PushWithinTacaffPointConstraint(PointService.fTacaffFriendlyPenalty, PointService.fTacaffNeutralPenalty, PointService.fTacaffEnemyPenalty, instanceID);
    PointService.PushWithinTacaffPointConstraint(,,, instanceID);
    PointService.PushPointClaimedConstraint(, instanceID);
    PointService.PushShootPointConstraint(none, false, instanceID);
    //return;    
}

function RegisterFindHidePointConstraints()
{
    PointService.ClearPointConstraints(instanceID);
    PointService.PushWithinTacaffPointConstraint(PointService.fTacaffFriendlyPenalty, PointService.fTacaffNeutralPenalty, PointService.fTacaffEnemyPenalty, instanceID);
    PointService.PushWithinLeashConstraint(instanceID);
    PointService.PushPointClaimedConstraint(, instanceID);
    PointService.PushHidePointConstraint(none, false, instanceID);
    //return;    
}

function StartRealFindCover()
{
    ClearEventMapEntry('RealFindCover');
    TriggerAxonNamedScriptEvent('FindCover');
    //return;    
}

function RegisterBackGroundEvents()
{
    RegisterPlayerShotNear('Background');
    ClearEventMapEntry('parentbackground');
    RegisterAxonSubstateStimulus('TakeFire', 'BulletImpact', FireNear,, 'Background');
    LODStatusEvent.RegisterLODStatusChangeEvent(Controller, WentToSleep, 'Background');
    RegisterAxonSubstateTimer(Controller.fCoverBlownWaitTime / 2.0000000, StartRealFindCover, 'RealFindCover', 'RealFindCover');
    //return;    
}

function WentToSleep()
{
    FinishBrain();
    //return;    
}

function CombatLostEnemy()
{
    // End:0x32
    if((PreHideEnemy == none) || Controller.ShouldThink() == false)
    {
        FinishBrain();
        return;
    }
    RunPosition = PreHidePosition;
    PreHideEnemy = none;
    GotoState('RunToPoint');
    return;
    //return;    
}

function PreValidateRunToPoint()
{
    // End:0x27
    if(RunPosition == vect(0.0000000, 0.0000000, 0.0000000))
    {
        RunPosition = GetBotLocation();
    }
    //return;    
}

function Dummy()
{
    //return;    
}

state ResetEnemy extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetResetEnemy(OnResetEnemyResult);
        //return;        
    }

    function OnResetEnemyResult()
    {
        EnemyService.SubstateHasEnemy(HasEnemy, instanceID);
        //return;        
    }

    function HasEnemy()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state Aim extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x19
        if(bNeedsReload)
        {
            GotoState('Reload');
            return;
        }
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Aim', AimFinished, FFImpl);
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 2500, instanceID);
        EnemyService.SubstateLostEnemy(CombatLostEnemy, instanceID);
        //return;        
    }

    function AimFinished()
    {
        GotoState('AimWait');
        //return;        
    }

    function ShouldReload()
    {
        GotoState('Reload');
        //return;        
    }

    function NoLongerSeeEnemy()
    {
        GotoState('FindShootPoint');
        //return;        
    }

    function ChildHide()
    {
        GotoState('FindHidePoint');
        //return;        
    }

    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindHidePoint');
        //return;        
    }
    stop;    
}

state AimWait extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', AimFinished, FFImpl);
        EnemyService.SubstateLostEnemy(CombatLostEnemy, instanceID);
        EnemyService.CanSeeEnemy(OnGetCanSeeResult);
        //return;        
    }

    function OnGetCanSeeResult()
    {
        local float fCanSeeWait;

        // End:0x27
        if(EnemyService.GetCanSeeEnemyResult() == false)
        {
            fCanSeeWait = 1.0000000;            
        }
        else
        {
            fCanSeeWait = 0.0000000;
        }
        RegisterAxonSubstateTimer(FMax(fCanSeeWait, Controller.GetMinOpenCombatAimTime()), TimerFinished);
        //return;        
    }

    function TimerFinished()
    {
        EnemyService.CanSuppressEnemy(CanShootEnemyRes);
        //return;        
    }

    function CanShootEnemyRes()
    {
        // End:0x29
        if(EnemyService.GetCanSuppressEnemyResult() == false)
        {
            GotoState('Waiting');
            return;
        }
        EnemyService.GetEnemy(GetEnemyRes, iEnemyTimeout);
        //return;        
    }

    function GetEnemyRes()
    {
        // End:0x31
        if(HasLivingEnemy(EnemyService.GetGetEnemyResult()))
        {
            GotoState('Fire');            
        }
        else
        {
            CombatLostEnemy();
        }
        //return;        
    }

    function ShouldReload()
    {
        GotoState('Reload');
        //return;        
    }

    function ChildHide()
    {
        GotoState('FindHidePoint');
        //return;        
    }

    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindHidePoint');
        //return;        
    }
    stop;    
}

state Fire extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('HitWall', ShotWall);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetOpenCombatBurst(), BurstDone, Controller.Focus);
        RegisterCanThrowGrenade();
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 2500, instanceID);
        EnemyService.SubstateLostEnemy(CombatLostEnemy, instanceID);
        ConditionalRegisterReloadEvent();
        //return;        
    }

    function ShotWall()
    {
        // End:0x66
        if(MOHAAIPawn(GetBot()).PlayByPostureOverride == 0)
        {
            MOHAAIPawn(GetBot()).PlayByPostureOverride = 1;
            AnimService.RegisterAnimationEvent('Aim', None, FFImpl);
        }
        //return;        
    }

    function BurstDone()
    {
        CurrentBursts++;
        // End:0x37
        if(CurrentBursts >= Controller.MaxOpenCombatBursts)
        {
            CurrentBursts = 0;
            GotoState('FindHidePoint');            
        }
        else
        {
            GotoState('WaitBetweenBursts');
        }
        //return;        
    }

    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindHidePoint');
        //return;        
    }

    function ShouldReload()
    {
        GotoState('Reload');
        //return;        
    }

    function NoLongerSeeEnemy()
    {
        GotoState('FindShootPoint');
        //return;        
    }

    function ChildHide()
    {
        GotoState('FindHidePoint');
        //return;        
    }
    stop;    
}

state ThrowGrenade extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.SetFallbackCallback(GrenadeDone);
        AnimService.RegisterAnimationEvent('Grenade', GrenadeDone, FFImpl);
        //return;        
    }

    function GrenadeDone()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state Reload extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.NPCPreReload();
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        PostReload();
        CurrentBursts++;
        bNeedsReload = false;
        AnimService.SetFallbackCallback(ReloadFailed);
        AnimService.RegisterAnimationEvent('Reload', ReloadDone, FFImpl);
        Controller.SendCCStimulus("Reload");
        //return;        
    }

    function ReloadFailed()
    {
        RegisterAxonSubstateTimer(1.0000000, ReloadDone);
        //return;        
    }

    function ReloadDone()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state HideReload extends Reload
{
    function ReloadDone()
    {
        GotoState('Hiding');
        //return;        
    }
    stop;    
}

state WaitBetweenBursts extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(0.2500000, TimerDone);
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 2500, instanceID);
        EnemyService.SubstateLostEnemy(CombatLostEnemy, instanceID);
        //return;        
    }

    function TimerDone()
    {
        GotoState('Aim');
        //return;        
    }

    function ShouldReload()
    {
        GotoState('Reload');
        //return;        
    }

    function NoLongerSeeEnemy()
    {
        GotoState('FindShootPoint');
        //return;        
    }

    function ChildHide()
    {
        GotoState('FindHidePoint');
        //return;        
    }

    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('FindHidePoint');
        //return;        
    }
    stop;    
}

state FindShootPoint extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        PointService.SubstateFindPoint(iShootPointsToFind, iMaxTraversalEdges, GetBotLocation(), FoundPoint, instanceID);
        RegisterFindShootPointConstraints();
        //return;        
    }

    function TraversalFailed()
    {
        RunPosition = PreHidePosition;
        GotoState('RunToPoint');
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3B
        if(PointService.GetNumNodesFound() <= 0)
        {
            TraversalFailed();
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

state RunToPoint extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        PreValidateRunToPoint();
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(2);
        GotoService.SubstateGotoOIR(ArrivedAtPoint, RunPosition,, 'Aim',, Controller.fMoveSpeed,, instanceID);
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, instanceID, 'Temp');
        //return;        
    }

    function ArrivedAtPoint()
    {
        // End:0x26
        if(GotoService.GetMoveFailed())
        {
            GotoState('Waiting');
            return;
        }
        // End:0x48
        if(bWantsToHide)
        {
            bWantsToHide = false;
            GotoState('PreHide');            
        }
        else
        {
            GotoState('Aim');
        }
        //return;        
    }

    function CanSeeEnemy()
    {
        // End:0x1C
        if(!bWantsToHide)
        {
            GotoState('Aim');            
        }
        else
        {
            ClearEventMapEntry('Temp');
        }
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ClearEventMapEntry('Temp');
        //return;        
    }
    stop;    
}

state Waiting extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, instanceID);
        RegisterAxonSubstateTimer(5.0000000, TimerDone);
        EnemyService.SubstateLostEnemy(CombatLostEnemy, instanceID);
        //return;        
    }

    function CanSeeEnemy()
    {
        GotoState('Aim');
        //return;        
    }

    function TimerDone()
    {
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

state FindHidePoint extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetEnemy(EnemyRes, iEnemyTimeout);
        //return;        
    }

    function EnemyRes()
    {
        PreHideEnemy = EnemyService.GetGetEnemyResult();
        PointService.SubstateFindPoint(1, iMaxTraversalEdges, GetBotLocation(), FoundPoint, instanceID);
        RegisterFindHidePointConstraints();
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x52
        if(PointService.GetNumNodesFound() <= 0)
        {
            DecaySuppressionEvent.ResetSuppression();
            GotoState('Waiting');
            return;            
        }
        else
        {
            PreHidePosition = GetBotLocation();
            RunPosition = PointService.GetNode(0);
            bWantsToHide = true;
            GotoState('RunToPoint');
        }
        //return;        
    }
    stop;    
}

state PreHide extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(1.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('Hiding');
        //return;        
    }
    stop;    
}

state Hiding extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x19
        if(bNeedsReload)
        {
            GotoState('HideReload');
            return;
        }
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Aim', Dummy, FFImpl);
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, instanceID);
        RegisterAxonSubstateTimer(Controller.fOpenCombatHideTime, TimerDone);
        //return;        
    }

    function CanSeeEnemy()
    {
        GotoState('Aim');
        //return;        
    }

    function TimerDone()
    {
        GotoState('FindShootPoint');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CanShootEnemyActivationService'Default__OpenCombatBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'CanShootEnemyActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: AxonPointService'Default__OpenCombatBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__OpenCombatBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: LODStatusScriptEvent'Default__OpenCombatBrainState.LODStatusEvent0'
    begin object name=LODStatusEvent0 class=Class'LODStatusScriptEvent'
    end object
    LODStatusEvent=LODStatusEvent0
    iEnemyTimeout=25000
    iMaxTraversalEdges=128
    iShootPointsToFind=10
    // Reference: AxonEnemyService'Default__OpenCombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__OpenCombatBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__OpenCombatBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__OpenCombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__OpenCombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__OpenCombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__OpenCombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__OpenCombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0
    end object
    CCAwaitEvent=CCAwaitEvent0
    iSuppressionLevel=5
    instanceID="OpenCombat"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}