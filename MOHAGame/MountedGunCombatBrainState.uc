class MountedGunCombatBrainState extends CombatBrainState;

var export editinline EnemyWithinFiringArcAxonScriptEvent EnemyWithinFiringArcEvent;
var export editinline HasEnemyAndMountedGunActivationService ActivationService;
var export editinline OnMMGMountedAxonScriptEvent OnMMGEvent;
var export editinline MOHAMountedGun MountedGun;
var int MaxBursts;
var int CurrentBursts;
var() int fFireWhileEnemyHiddenTimeMS;
var() float fWaitAfterCantShootEnemiesSec;

function RegisterActivationEvents()
{
    ActivationService.OnMMGEvent = OnMMGEvent;
    ActivationService.EnemyService = EnemyService;
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = iSuppressionLevel;
    ActivationService.Start(ActivationEventTripped, 'MountedGunCombatActivation');
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function RegisterParentSubstateEvents()
{
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    EnemyService.AddWithinFiringArcThreatAssessment(Controller.fMMGHalfAngleFiringArcDeg);
    EnemyService.AddCoverBlowerThreatAssessment();
    CoverService.SubstateCoverBlown(MountedGunInvalid,, 'flankedcoverblown');
    CoverService.PushFlankingAggressorCoverBlownContraints(Controller, Controller.fMMGHalfAngleFiringArcDeg,, 'flankedcoverblown');
    RegisterNoEnemiesCoverBlown();
    //return;    
}

function RegisterNoEnemiesCoverBlown()
{
    ClearEventMapEntry('noenemiesbg');
    CoverService.SubstateCoverBlown(NoEnemiesToShoot,, 'noenemiescoverblown', 'noenemiesbg');
    CoverService.PushShootAtLeastOneCoverConstraint("CoverBlown", 'noenemiescoverblown');
    //return;    
}

function InitializeMountedGun()
{
    MountedGun = MOHAMountedGun(Controller.Pawn);
    //return;    
}

function StartBrain()
{
    EnemyWithinFiringArcEvent.fFiringAngleDotMin = Cos(0.0174533 * Controller.fMMGHalfAngleFiringArcDeg);
    InitializeMountedGun();
    Controller.fMaxEngageDist = MountedGun.fMaxEngagementDistance;
    Controller.fMaxEngagePenaltyDist = MountedGun.fMaxEngagementDistance;
    Controller.AccuracyMan.fNpcToNpcAccuracyScale = 2.0000000;
    Controller.fSuppressionThreatMultiplier = Controller.default.fCoveringFireThreatMultiplier;
    MountedGun.TryPlayMMGAID();
    super.StartBrain();
    //return;    
}

function StandardFinish()
{
    Controller.fMaxEngageDist = Controller.Class.default.fMaxEngageDist;
    Controller.fMaxEngagePenaltyDist = Controller.Class.default.fMaxEngagePenaltyDist;
    Controller.AccuracyMan.fNpcToNpcAccuracyScale = Controller.AccuracyMan.Class.default.fNpcToNpcAccuracyScale;
    Controller.fSuppressionThreatMultiplier = Controller.default.fSuppressionThreatMultiplier;
    super(AxonBrainState).StandardFinish();
    //return;    
}

function InitStartCombat()
{
    GotoState('Aim');
    //return;    
}

function DummyAnimCallback()
{
    //return;    
}

function CombatLostEnemy()
{
    FinishBrain();
    //return;    
}

function MountedGunInvalid()
{
    MountedGun.fGunnerDeathRemountTime = 15.0000000;
    FinishBrain();
    //return;    
}

function NoEnemiesToShoot()
{
    GotoState('WaitForEnemiesToComeBack');
    //return;    
}

function PlayerShotNear()
{
    SetPlayerShotAtThreat();
    GotoState('ResetEnemy');
    //return;    
}

function ReturnToNormalAttack()
{
    ClearEventMapEntry('BlindAttack');
    RegisterNoEnemiesCoverBlown();
    GotoState('Aim');
    //return;    
}

function WaitOver()
{
    MountedGunInvalid();
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
        GotoState('WaitForEnemyInSights');
        //return;        
    }
    stop;    
}

state Aim extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', AimAnimDone, MountedGun);
        //return;        
    }

    function AimAnimDone()
    {
        GotoState('Fire');
        //return;        
    }
    stop;    
}

state Fire extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyWithinFiringArcEvent.RegisterCheckOutsideFiringArc(Controller, OutsideArc);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetMMGBurst(), BurstDone, Controller.Focus);
        RegisterPlayerShotNear();
        //return;        
    }

    function BurstDone()
    {
        GotoState('WaitBetweenBursts');
        //return;        
    }

    function OutsideArc()
    {
        GotoState('WaitForEnemyInSights');
        //return;        
    }
    stop;    
}

state WaitForEnemyInSights extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyWithinFiringArcEvent.RegisterCheckInsideFiringArc(Controller, InsideArc);
        RegisterPlayerShotNear();
        //return;        
    }

    function InsideArc()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state WaitBetweenBursts extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', None, MountedGun);
        RegisterAxonSubstateTimer(RandRange(Controller.fWaitBetweenMMGBurstsMin, Controller.fWaitBetweenMMGBurstsMax), TimerDone);
        RegisterPlayerShotNear();
        //return;        
    }

    function TimerDone()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state WaitForEnemiesToComeBack extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        ClearEventMapEntry('noenemiesbg');
        RegisterAxonSubstateTimer(fWaitAfterCantShootEnemiesSec, WaitOver,, 'BlindAttack');
        RegisterAxonSubstateTimer(1.0000000, InitialWaitOver);
        RegisterPlayerShotNear();
        //return;        
    }

    function InitialWaitOver()
    {
        GotoState('AimBlind');
        //return;        
    }
    stop;    
}

state AimBlind extends Aim
{
    function AimAnimDone()
    {
        GotoState('FireBlind');
        //return;        
    }
    stop;    
}

state FireBlind extends Fire
{
    function BurstDone()
    {
        GotoState('WaitBetweenBurstsBlind');
        //return;        
    }

    function OutsideArc()
    {
        GotoState('WaitForEnemyInSightsBlind');
        //return;        
    }
    stop;    
}

state WaitBetweenBurstsBlind extends WaitBetweenBursts
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateOnCanSeeEnemy(ReturnToNormalAttack);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function TimerDone()
    {
        GotoState('AimBlind');
        //return;        
    }
    stop;    
}

state WaitForEnemyInSightsBlind extends WaitForEnemyInSights
{
    function InsideArc()
    {
        GotoState('AimBlind');
        //return;        
    }
    stop;    
}

state Reload extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Reload', ReloadAnimDone, MountedGun);
        //return;        
    }

    function ReloadAnimDone()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: EnemyWithinFiringArcAxonScriptEvent'Default__MountedGunCombatBrainState.EnemyWithinFiringArcEvent0'
    begin object name=EnemyWithinFiringArcEvent0 class=Class'EnemyWithinFiringArcAxonScriptEvent'
    end object
    EnemyWithinFiringArcEvent=EnemyWithinFiringArcEvent0
    // Reference: HasEnemyAndMountedGunActivationService'Default__MountedGunCombatBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'HasEnemyAndMountedGunActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: OnMMGMountedAxonScriptEvent'Default__MountedGunCombatBrainState.OnMMGEvent0'
    begin object name=OnMMGEvent0 class=Class'OnMMGMountedAxonScriptEvent'
    end object
    OnMMGEvent=OnMMGEvent0
    MaxBursts=7
    fFireWhileEnemyHiddenTimeMS=3000
    fWaitAfterCantShootEnemiesSec=6.0000000
    // Reference: AxonEnemyService'Default__MountedGunCombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__MountedGunCombatBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__MountedGunCombatBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__MountedGunCombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__MountedGunCombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__MountedGunCombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__MountedGunCombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__MountedGunCombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0
    end object
    CCAwaitEvent=CCAwaitEvent0
    iSuppressionLevel=11
    instanceID="MMGCombat"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}