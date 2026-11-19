class MoveToCoverBrainState extends AxonControllerBrainState;

var() float fEnemyTimeout;
var int iNumBursts;
var() int iMaxBursts;
var() float fMinTimeBetweenStandGround;
var KynapseCoverNode newCoverNode;
var export editinline AxonCoverService CoverService;
var export editinline AxonPointService PointService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonAnimService AnimService;
var export editinline AxonAffordanceService AffordanceService;
var export editinline FindCoverActivationService ActivationService;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;
var export editinline EnemyWithinFiringArcAxonScriptEvent EnemyWithinFiringArcEvent;
var export editinline DecaySuppressionAxonScriptEvent DecaySuppressionEvent;
var export editinline CCRequestPerformanceAxonScriptEvent CCRequestEvent;
var export editinline CCAwaitPerformanceAxonScriptEvent CCAwaitEvent;
var export editinline OnWithinGotoDistanceAxonScriptEvent WithinGotoDistance;
var bool bWithinMinimumGotoDistance;
var bool bShouldSuspendCoverSearch;
var bool bDoneAiming;
var bool bGotoRegistered;
var float BlownFudgeFactor;
var float fLastGotoDistance;
var float fRunToStandGroundDist;
var Vector vLookAheadPos;
var name instanceID;
var name BackgroundName;

function RegisterActivationEvents()
{
    ActivationService.AnimService = AnimService;
    ActivationService.CoverService = CoverService;
    ActivationService.PointService = PointService;
    ActivationService.EnemyService = EnemyService;
    ActivationService.AffordanceService = AffordanceService;
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = 7;
    ActivationService.Start(ActivationEventTripped, instanceID);
    // End:0xE8
    if(bShouldSuspendCoverSearch)
    {
        OwningBSS.PushNamedScriptEventParamFloat('SuspendCoverSearch', 'SuspendTime', 6.0000000);
        TriggerAxonNamedScriptEvent('SuspendCoverSearch');
    }
    //return;    
}

function ActivationEventTripped()
{
    newCoverNode = ActivationService.newCoverNode;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    bWithinMinimumGotoDistance = false;
    bShouldSuspendCoverSearch = false;
    SetSuppressionLevel(7);
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddCoverBlowerThreatAssessment();
    EnemyService.AddWithinFiringArcThreatAssessment(90.0000000, 250.0000000);
    EnemyWithinFiringArcEvent.fEncroachedDistanceMax = Controller.fEncroachedDistanceMax;
    // End:0xBD
    if(Controller.IsMountedInCover())
    {
        GotoState('PreHide');        
    }
    else
    {
        BeginMoveToCover();
    }
    //return;    
}

function BeginMoveToCover()
{
    // End:0x57
    if(Controller.InPlayersPresence())
    {
        Controller.SendCCStimulus("PlayerPresenceLeavingCover");
        GotoState('StartNearPlayer');        
    }
    else
    {
        RequestCoveringFire();
        GotoState('StartMoveToCover');
    }
    //return;    
}

function FinishBrain()
{
    bGotoRegistered = false;
    super(AxonBrainState).FinishBrain();
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function FinishAndClearCover()
{
    CoverService.ClearCover(0);
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    super(AxonBrainState).StandardFinish();
    Controller.bAimAtFocus = true;
    bGotoRegistered = false;
    //return;    
}

function ArrivedAtCover()
{
    //return;    
}

function TimedOut()
{
    //return;    
}

function CoverInvalid()
{
    //return;    
}

function BurstDone()
{
    //return;    
}

function CantShootEnemy()
{
    //return;    
}

function OnCanShootEnemyResult()
{
    //return;    
}

function EncroachedUpon()
{
    //return;    
}

function CanThrowGrenade()
{
    // End:0x38
    if(Controller.bThrowsGrenades)
    {
        EnemyService.NotifyJustThrewGrenade(instanceID);
        GotoState('ThrowGrenade');
    }
    //return;    
}

function EvasiveManeuver(name stateName)
{
    ClearEventStack();
    GotoState(stateName);
    //return;    
}

function bool EnemyIsPlayer()
{
    local Pawn EnemyPawn;

    EnemyPawn = Pawn(Controller.Focus);
    return (((Controller.TeamIndex == 1) && EnemyPawn != none) && EnemyPawn.Controller != none) && EnemyPawn.Controller.bIsPlayer;
    //return ReturnValue;    
}

function Vector GetTraversalStartPos()
{
    return GetBotLocation();
    //return ReturnValue;    
}

function OnWithinGotoDistance()
{
    ClearEventMapEntry('MonitorGotoDistance');
    // End:0x5C
    if(!bWithinMinimumGotoDistance)
    {
        bWithinMinimumGotoDistance = true;
        CoverService.PushBasicAggressorCoverBlownConstraints(Controller);
        CoverService.PushNearPlayerCoverConstraint("CoverBlown");
    }
    //return;    
}

function RequestCoveringFire()
{
    local name requestCoverFireStimulusTemplate;

    Controller.SendCCStimulus("RequestCoveringFire");
    // End:0x4F
    if(Controller.TeamIndex == 0)
    {
        requestCoverFireStimulusTemplate = 'AlliedRequestSuppressingFire';        
    }
    else
    {
        requestCoverFireStimulusTemplate = 'AxisRequestSuppressingFire';
    }
    Controller.Stimulus.AttachSender('RequestSuppressingFire', requestCoverFireStimulusTemplate, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),,, true);
    // End:0x112
    if(VSize(newCoverNode.GetPosition() - GetBot().Location) > float(500))
    {
        Controller.Stimulus.PushStimuliSenderParamVector('RequestSuppressingFire', 'Destination', newCoverNode.GetPosition());
    }
    //return;    
}

function SetPlayerShotAtThreat()
{
    Controller.SetPlayerShotAtMeThreatTime(Class'EALAWeapon'.static.GetPlayerShotAtThreatFromBrainState(self));
    //return;    
}

function name GetCoveringFireStimulus()
{
    // End:0x1E
    if(Controller.TeamIndex == 0)
    {
        return 'AlliedCoverBlownCoveringFire';
    }
    return 'AxisCoverBlownCoveringFire';
    //return ReturnValue;    
}

function CheckOtherProvidingCoveringFire(delegate<AxonDelegate> callback)
{
    local name coverFireStimulus;

    coverFireStimulus = GetCoveringFireStimulus();
    RegisterAxonSubstateStimulus(coverFireStimulus, coverFireStimulus, callback);
    //return;    
}

function TryGotoStandGround()
{
    // End:0x17
    if(MOHAAIPawn(GetBot()) == none)
    {
        return;
    }
    // End:0x97
    if(MOHAAIPawn(GetBot()).IsMovementInterruptable() && !Controller.IsPointLocked(GetBot().Location, 100.0000000))
    {
        fLastGotoDistance = Controller.fGotoDistanceRemaining;
        // End:0x97
        if(!TryLocomoteToStandGround())
        {
            GotoState('StandGround');
        }
    }
    //return;    
}

function bool TryLocomoteToStandGround()
{
    // End:0x47
    if((Controller.CurrentEnemy != none) && VSize(Controller.CurrentEnemy.Location - (GetBotLocation())) < fRunToStandGroundDist)
    {
        return false;
    }
    // End:0x6E
    if(FindRunaheadPoint(fRunToStandGroundDist, vLookAheadPos))
    {
        GotoState('RunToStandGround');
        return true;
    }
    return false;
    //return ReturnValue;    
}

function StopMoving()
{
    bGotoRegistered = false;
    ClearEventMapEntry('Goto');
    ClearEventMapEntry('MonitorGotoDistance');
    //return;    
}

function LostEnemy()
{
    //return;    
}

function RegisterBackGroundEvents()
{
    EnemyService.SubstateLostEnemy(LostEnemy,, BackgroundName);
    CoverService.SubstateCoverBlown(CoverInvalid,,, BackgroundName);
    CoverService.ClearCoverConstraints("CoverBlown");
    CoverService.PushNearPlayerCoverConstraint("CoverBlown");
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
        BeginMoveToCover();
        //return;        
    }
    stop;    
}

state StartNearPlayer extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(0.5000000, TimerDone);
        CCRequestEvent.Register(Controller, PerformanceReady);
        //return;        
    }

    function TimerDone()
    {
        GotoState('StartMoveToCover');
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('CCPerform');
        //return;        
    }
    stop;    
}

state CCPerform extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CCAwaitEvent.Register(Controller, PerformanceDone);
        //return;        
    }

    function PerformanceDone()
    {
        GotoState('StartMoveToCover');
        //return;        
    }
    stop;    
}

state StartMoveToCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local float distToCover;

        RegisterBackGroundEvents();
        bGotoRegistered = false;
        distToCover = VSize(GetBot().Location - newCoverNode.GetPosition());
        // End:0xAE
        if(!Controller.IsPointLocked(GetBot().Location, 100.0000000) && EnemyWithinFiringArcEvent.QuickCheckEncroachment(Controller, newCoverNode, distToCover))
        {
            fLastGotoDistance = distToCover;
            GotoState('StandGround');            
        }
        else
        {
            GotoState('RunToCover');
        }
        //return;        
    }

    function CoverInvalid()
    {
        // End:0x70
        if(bWithinMinimumGotoDistance && MOHAAIPawn(GetBot()) != none)
        {
            // End:0x51
            if(MOHAAIPawn(GetBot()).IsMovementInterruptable())
            {
                GotoState('RunToFixedFire');                
            }
            else
            {
                ClearEventMapEntry(BackgroundName);
                RegisterBackGroundEvents();
                bWithinMinimumGotoDistance = false;
            }
            return;
        }
        FinishAndClearCover();
        //return;        
    }

    function LostEnemy()
    {
        FinishAndClearCover();
        //return;        
    }
    stop;    
}

state RunToFixedFire extends StartMoveToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        ClearEventMapEntry(BackgroundName);
        StopMoving();
        GotoService.SubstateGotoOIR(ArriveAtFixedFire, newCoverNode.GetPosition(),, 'Aim',, Controller.fMoveSpeed);
        //return;        
    }

    function ArriveAtFixedFire()
    {
        FinishAndClearCover();
        TriggerAxonNamedScriptEvent('ForceCoverBlownCombat');
        //return;        
    }
    stop;    
}

state RunToCover extends StartMoveToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, instanceID);
        RunToCover();
        //return;        
    }

    function RunToCover()
    {
        // End:0x0B
        if(bGotoRegistered)
        {
            return;
        }
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, Controller.fMoveSpeed,,,, 'Goto');
        bGotoRegistered = true;
        Controller.bAimAtFocus = false;
        WithinGotoDistance.Register(Controller, 1000.0000000, OnWithinGotoDistance, 'MonitorGotoDistance');
        //return;        
    }

    function CanSeeEnemy()
    {
        GotoState('MonitorEncroachment');
        //return;        
    }

    function ArrivedAtCover()
    {
        // End:0x3A
        if(GotoService.GetMoveFailed())
        {
            CoverService.ClearCover(3000);
            FinishBrain();
            return;
        }
        // End:0x56
        if(newCoverNode != none)
        {
            GotoState('Hide');            
        }
        else
        {
            FinishBrain();
        }
        //return;        
    }

    function FireNear()
    {
        GotoState('SprintToCover');
        //return;        
    }
    stop;    
}

state SprintToCover extends RunToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        StopMoving();
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(3);
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, Controller.fSprintSpeed);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state Hide extends StartMoveToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        StopMoving();
        AnimService.RegisterAnimationEvent('Hide', Finish, Controller.GetCurrentCoverNode());
        CoverService.SubstateOnCoverMounted(OnCoverMounted, instanceID);
        //return;        
    }

    function OnCoverMounted()
    {
        FinishBrain();
        //return;        
    }

    function Finish()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

state MonitorEncroachment extends RunToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyWithinFiringArcEvent.RegisterCheckEncroachment(Controller, newCoverNode, EncroachedUpon);
        CheckOtherProvidingCoveringFire(KeepGoingTowardCover);
        RunToCover();
        //return;        
    }

    function KeepGoingTowardCover()
    {
        GotoState('RunToCoverPostStandGround');
        //return;        
    }

    function EncroachedUpon()
    {
        TryGotoStandGround();
        //return;        
    }
    stop;    
}

state RunToStandGround extends StartMoveToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        StopMoving();
        GotoService.SubstateGotoOIR(ArriveAtFixedFire, vLookAheadPos,, 'Aim',, Controller.fMoveSpeed);
        //return;        
    }

    function ArriveAtFixedFire()
    {
        GotoState('StandGround');
        //return;        
    }
    stop;    
}

state StandGround extends StartMoveToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        StopMoving();
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, int(fEnemyTimeout));
        // End:0x83
        if(Controller.bThrowsGrenades)
        {
            EnemyService.SubstateCanThrowGrenade(Controller, CanThrowGrenade,,,, instanceID);
            EnemyService.RegisterDefaultGrenadeConstraints(instanceID);
        }
        RegisterAxonNamedScriptEventListener('HitWall', ShotWall);
        CheckOtherProvidingCoveringFire(KeepGoingTowardCover);
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        PushEventStack();
        AnimService.RegisterAnimationEvent('Aim', AimAnimDone, MOHAAIPawn(GetBot()).FFImpl);
        Controller.bAimAtFocus = true;
        //return;        
    }

    function ShotWall()
    {
        // End:0x79
        if(MOHAAIPawn(GetBot()).PlayByPostureOverride == 0)
        {
            MOHAAIPawn(GetBot()).PlayByPostureOverride = 1;
            AnimService.RegisterAnimationEvent('Aim', None, MOHAAIPawn(GetBot()).FFImpl);
        }
        //return;        
    }

    function AimAnimDone()
    {
        PopEventStack();
        AnimService.RegisterAnimationEvent('Aim', None, MOHAAIPawn(GetBot()).FFImpl);
        BurstDone();
        //return;        
    }

    function BurstDone()
    {
        PopEventStack();
        PushEventStack();
        // End:0x28
        if(iNumBursts >= iMaxBursts)
        {
            KeepGoingTowardCover();            
        }
        else
        {
            BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetCoverFireBurst(), BurstDone, Controller.Focus);
            iNumBursts++;
        }
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        PopEventStack();
        iNumBursts = 0;
        //return;        
    }

    function NoLongerSeeEnemy()
    {
        GotoState('RunToCover');
        //return;        
    }

    function KeepGoingTowardCover()
    {
        GotoState('RunToCoverPostStandGround');
        //return;        
    }
    stop;    
}

state ThrowGrenade extends StartMoveToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        StopMoving();
        AnimService.SetFallbackCallback(GrenadeDone);
        AnimService.RegisterAnimationEvent('Grenade', GrenadeDone, MOHAAIPawn(GetBot()).FFImpl);
        //return;        
    }

    function GrenadeDone()
    {
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Aim', Dummy, MOHAAIPawn(GetBot()).FFImpl);
        GotoState('RunToCoverPostStandGround');
        //return;        
    }
    stop;    
}

state RunToCoverPostStandGround extends RunToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateEnemyChanged(OKToStandGroundOnceMore);
        RegisterAxonSubstateTimer(fMinTimeBetweenStandGround, OKToStandGroundOnceMore);
        EnemyService.SubstateOnCanSeeEnemy(CanSeeEnemy, instanceID, 'PSGBackground');
        RunToCover();
        //return;        
    }

    function FireAtHim()
    {
        GotoState('MoveAndShoot');
        //return;        
    }

    function NoLongerSeeEnemy()
    {
        GotoState('RunToCover');
        //return;        
    }

    function OKToStandGroundOnceMore()
    {
        GotoState('MonitorEncroachment');
        //return;        
    }

    function CanSeeEnemy()
    {
        ClearEventMapEntry('PSGBackground');
        EnemyWithinFiringArcEvent.RegisterCheckEncroachment(Controller, newCoverNode, FireAtHim);
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ClearEventMapEntry('PSGBackground');
        super(AxonBaseBookshelfState).ChildEndState(NextStateName);
        //return;        
    }
    stop;    
}

state ResetEnemy extends StartMoveToCover
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
        GotoState('MonitorEncroachment');
        //return;        
    }
    stop;    
}

state MoveAndShoot extends RunToCover
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyWithinFiringArcEvent.RegisterCheckOutsideFiringArc(Controller, BurstDone);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetWildBurst(), BurstDone, Controller.Focus);
        EnemyService.SubstateNoLongerSeeEnemy(CantShootEnemy, int(fEnemyTimeout));
        // End:0xC0
        if(!EnemyIsPlayer())
        {
            RegisterAxonSubstateStimulus('PlayerShoot', 'PlayerShoot', PlayerShotNear);
        }
        RunToCover();
        MOHAPawn(Controller.Pawn).DesiredPosture = 0;
        Controller.bAimAtFocus = true;
        //return;        
    }

    function BurstDone()
    {
        GotoState('RunToCoverPostStandGround');
        //return;        
    }

    function PlayerShotNear()
    {
        SetPlayerShotAtThreat();
        GotoState('ResetEnemy');
        //return;        
    }

    function CantShootEnemy()
    {
        GotoState('RunToCoverPostStandGround');
        //return;        
    }
    stop;    
}

defaultproperties
{
    fEnemyTimeout=2000.0000000
    iMaxBursts=1
    fMinTimeBetweenStandGround=10.0000000
    // Reference: MOHACoverService'Default__MoveToCoverBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonPointService'Default__MoveToCoverBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__MoveToCoverBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonEnemyService'Default__MoveToCoverBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: AxonAnimService'Default__MoveToCoverBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__MoveToCoverBrainState.AffordanceService0'
    begin object name=AffordanceService0 class=Class'EAKynapse.AxonAffordanceService'
    end object
    AffordanceService=AffordanceService0
    // Reference: FindCoverActivationService'Default__MoveToCoverBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'FindCoverActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: BurstFireAxonScriptEvent'Default__MoveToCoverBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: EnemyWithinFiringArcAxonScriptEvent'Default__MoveToCoverBrainState.EnemyWithinFiringArcEvent0'
    begin object name=EnemyWithinFiringArcEvent0 class=Class'EnemyWithinFiringArcAxonScriptEvent'
        fFiringAngleDotMin=-0.5000000
        fEncroachedDistanceScalarLateral=0.7500000
        fEncroachedDistanceScalarFrontal=1.5000000
        fEncroachedDistanceScalarRear=0.3000000
        fEncroachedDistanceMax=1000.0000000
    end object
    EnemyWithinFiringArcEvent=EnemyWithinFiringArcEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__MoveToCoverBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0 class=Class'DecaySuppressionAxonScriptEvent'
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__MoveToCoverBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0 class=Class'CCRequestPerformanceAxonScriptEvent'
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__MoveToCoverBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0 class=Class'CCAwaitPerformanceAxonScriptEvent'
    end object
    CCAwaitEvent=CCAwaitEvent0
    // Reference: OnWithinGotoDistanceAxonScriptEvent'Default__MoveToCoverBrainState.WithinGotoDistance0'
    begin object name=WithinGotoDistance0 class=Class'OnWithinGotoDistanceAxonScriptEvent'
    end object
    WithinGotoDistance=WithinGotoDistance0
    BlownFudgeFactor=0.2000000
    fRunToStandGroundDist=500.0000000
    instanceID="MoveToCover"
    BackgroundName="MoveToCoverBackground"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}