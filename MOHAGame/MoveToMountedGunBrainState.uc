class MoveToMountedGunBrainState extends AxonControllerBrainState;

var() float fStandGroundWhileEnemyHiddenTimeMS;
var MOHAMountedGun MountedGun;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;
var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var export editinline FindMountedGunActivationService ActivationService;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;
var export editinline EnemyWithinFiringArcAxonScriptEvent EnemyWithinFiringArcEvent;
var export editinline OnMMGUnMountedAxonScriptEvent OnMMGEvent;
var name instanceID;
var name BackgroundKeyName;

function RegisterActivationEvents()
{
    ActivationService.Controller = Controller;
    ActivationService.EnemyService = EnemyService;
    ActivationService.OnMMGEvent = OnMMGEvent;
    ActivationService.CoverService = CoverService;
    ActivationService.SuppressionLevel = 9;
    ActivationService.StimulusTemplate = 'MG42';
    ActivationService.Start(ActivationEventTripped, 'MoveToMountedGunActiviation');
    //return;    
}

function ActivationEventTripped()
{
    MountedGun = ActivationService.MountedGun;
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(9);
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    // End:0x5E
    if(Controller.IsMountedInCover())
    {
        GotoState('PreHide');        
    }
    else
    {
        GotoState('StartMoveToMountedGun');
    }
    //return;    
}

function FinishBrain()
{
    MountedGun.ClearClaim();
    super(AxonBrainState).FinishBrain();
    //return;    
}

function FinishCorrectly()
{
    FinishBrain();
    //return;    
}

function SuspendBrain(AxonBrainState usurperState)
{
    MountedGun.ClearClaim();
    super(AxonBrainState).SuspendBrain(usurperState);
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function PlayerOverrideClaim()
{
    FinishBrain();
    //return;    
}

function Coma()
{
    ActivationService.Abort();
    //return;    
}

function ArrivedAtMountedGun()
{
    //return;    
}

function TimedOut()
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

function MountedGunInvalid()
{
    //return;    
}

function NoLongerHasEnemy()
{
    FinishBrain();
    //return;    
}

function SetPlayerShotAtThreat()
{
    Controller.SetPlayerShotAtMeThreatTime(Class'EALAWeapon'.static.GetPlayerShotAtThreatFromBrainState(self));
    //return;    
}

function DiedEnRoute()
{
    MountedGun.ApplyDeathPenalty();
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
        GotoState('StartMoveToMountedGun');
        //return;        
    }
    stop;    
}

state StartMoveToMountedGun extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.SubstateLostEnemy(NoLongerHasEnemy,, BackgroundKeyName);
        CoverService.SubstateCoverBlown(MountedGunInvalid,,, BackgroundKeyName);
        CoverService.PushFlankingAggressorCoverBlownContraints(Controller, Controller.fMMGHalfAngleFiringArcDeg, false);
        CoverService.PushShootAtLeastOneCoverConstraint("CoverBlown");
        RegisterAxonNamedScriptEventListener('PlayerOverrideClaim', PlayerOverrideClaim, BackgroundKeyName);
        GotoState('CheckForEnemy');
        //return;        
    }

    function MountedGunInvalid()
    {
        FinishBrain();
        //return;        
    }
    stop;    
}

state CheckForEnemy extends StartMoveToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetEnemy(EnemyResult);
        //return;        
    }

    function EnemyResult()
    {
        GotoState('MonitorEncroachment');
        //return;        
    }
    stop;    
}

state ResetEnemy extends StartMoveToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetResetEnemy(OnResetEnemyResult);
        //return;        
    }

    function OnResetEnemyResult()
    {
        GotoState('MonitorEncroachment');
        //return;        
    }
    stop;    
}

state BaseMoveToMountedGun extends StartMoveToMountedGun
{
    function ArrivedAtMountedGun()
    {
        // End:0x4E
        if((GotoService.GetMoveFailed() || MountedGun == none) || !MountedGun.IsClaimedBy(Controller))
        {
            FinishBrain();
            return;
        }
        GotoState('Mount');
        //return;        
    }
    stop;    
}

state Mount extends StartMoveToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('PrePawnDied', DiedEnRoute);
        AnimService.RegisterAnimationEvent('Aim', AnimDone, MountedGun);
        //return;        
    }

    function AnimDone()
    {
        FinishCorrectly();
        //return;        
    }
    stop;    
}

state RunToMountedGun extends BaseMoveToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('PrePawnDied', DiedEnRoute);
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtMountedGun,, MountedGun, 'Aim',, Controller.fMoveSpeed,, instanceID);
        //return;        
    }
    stop;    
}

state SprintToMountedGun extends BaseMoveToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(3);
        GotoService.SubstateGotoOIR(ArrivedAtMountedGun,, MountedGun, 'Aim',, Controller.fSprintSpeed,, instanceID);
        //return;        
    }
    stop;    
}

state MonitorEncroachment extends RunToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyWithinFiringArcEvent.RegisterCheckEncroachment(Controller, MountedGun.MountedGunCoverNode, EncroachedUpon);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function EncroachedUpon()
    {
        GotoState('MoveAndShoot');
        //return;        
    }
    stop;    
}

state MoveAndShoot extends RunToMountedGun
{
    function ChildBeginState(name PreviousStateName)
    {
        local Pawn EnemyPawn;

        RegisterAxonNamedScriptEventListener('PrePawnDied', DiedEnRoute);
        EnemyWithinFiringArcEvent.RegisterCheckOutsideFiringArc(Controller, BurstDone);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetWildBurst(), BurstDone, Controller.Focus);
        EnemyService.SubstateNoLongerSeeEnemy(CantShootEnemy, int(fStandGroundWhileEnemyHiddenTimeMS), instanceID);
        EnemyPawn = Pawn(Controller.Focus);
        // End:0x141
        if((((Controller.TeamIndex == 1) && EnemyPawn != none) && EnemyPawn.Controller != none) && !EnemyPawn.Controller.bIsPlayer)
        {
            RegisterAxonSubstateStimulus('PlayerShoot', 'PlayerShoot', PlayerShotNear);
        }
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetRandDesiredPosture();
        GotoService.SubstateGotoOIR(ArrivedAtMountedGun,, MountedGun, 'Aim',, Controller.fMoveSpeed,, instanceID);
        //return;        
    }

    function BurstDone()
    {
        GotoState('MonitorEncroachment');
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
        GotoState('RunToMountedGun');
        //return;        
    }
    stop;    
}

defaultproperties
{
    fStandGroundWhileEnemyHiddenTimeMS=1000.0000000
    // Reference: MOHAGotoService'Default__MoveToMountedGunBrainState.GotoService0'
    begin object name=GotoService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoService0
    // Reference: AxonAnimService'Default__MoveToMountedGunBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: AxonEnemyService'Default__MoveToMountedGunBrainState.EnemyService0'
    begin object name=EnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=EnemyService0
    // Reference: AxonCoverService'Default__MoveToMountedGunBrainState.CoverService0'
    begin object name=CoverService0 class=Class'AxonCoverService'
    end object
    CoverService=CoverService0
    // Reference: FindMountedGunActivationService'Default__MoveToMountedGunBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'FindMountedGunActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: BurstFireAxonScriptEvent'Default__MoveToMountedGunBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: EnemyWithinFiringArcAxonScriptEvent'Default__MoveToMountedGunBrainState.EnemyWithinFiringArcEvent0'
    begin object name=EnemyWithinFiringArcEvent0 class=Class'EnemyWithinFiringArcAxonScriptEvent'
    end object
    EnemyWithinFiringArcEvent=EnemyWithinFiringArcEvent0
    // Reference: OnMMGUnMountedAxonScriptEvent'Default__MoveToMountedGunBrainState.OnMMGEvent0'
    begin object name=OnMMGEvent0 class=Class'OnMMGUnMountedAxonScriptEvent'
    end object
    OnMMGEvent=OnMMGEvent0
    instanceID="MoveToMountedGun"
    BackgroundKeyName="Background"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}