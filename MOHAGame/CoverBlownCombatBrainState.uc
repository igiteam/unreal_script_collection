class CoverBlownCombatBrainState extends CombatBrainState;

var export editinline CanShootEnemyCoverBlownActivationService ActivationService;
var export editinline AxonPointService PointService;
var export editinline MOHAGotoService GotoService;
var export editinline EnemyWithWeaponTypeScriptEvent EnemyWithSniperWeaponEvent;
var int CurrentBursts;
var FixedFireOIRImpl FFImpl;
var float fStandUpRadius;
var Vector vFriendlyCoverPosition;

function StartBrain()
{
    SetupFixedFireOIR();
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
    ActivationService.Start(ActivationEventTripped, instanceID);
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function ResetSuppressionMeter()
{
    //return;    
}

function FinishBrain()
{
    super.FinishBrain();
    TriggerAxonNamedScriptEvent('FindCover');
    //return;    
}

function SetupFixedFireOIR()
{
    FFImpl = MOHAAIPawn(GetBot()).FFImpl;
    //return;    
}

function BurstDone()
{
    //return;    
}

function BlownTimerDone()
{
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    CeaseProvidingCoveringFire();
    Controller.bProvidingCoveringFire = false;
    super(AxonBrainState).StandardFinish();
    //return;    
}

function PlayerShotNear()
{
    SetPlayerShotAtThreat();
    GotoState('ResetEnemy');
    //return;    
}

function RegisterParentSubstateEvents()
{
    RegisterAxonSubstateTimer(Controller.fCoverBlownWaitTime, BlownTimerDone, instanceID);
    EnemyWithSniperWeaponEvent.Register(Controller, FinishBrain, 'Background');
    ListenForCoveringFire();
    SendProvidingCoveringFire();
    CheckOtherProvidingCoveringFire(FinishBrain);
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    EnemyService.AddCoverBlowerThreatAssessment();
    //return;    
}

function InitStartCombat()
{
    // End:0x27
    if(Controller.IsMountedInCover())
    {
        GotoState('PreHide');        
    }
    else
    {
        StartCoverBlownCombat();
    }
    //return;    
}

function StartCoverBlownCombat()
{
    ClearEventMapEntry('NoLongerSeeBackground');
    EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, int(Controller.fCoverBlownWaitTime * float(250)),, 'NoLongerSeeBackground');
    GotoState('Aim');
    //return;    
}

function NoLongerSeeEnemy()
{
    FinishBrain();
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

function SendProvidingCoveringFire()
{
    local name coverFireStimulus;

    coverFireStimulus = GetCoveringFireStimulus();
    Controller.Stimulus.AttachSender(coverFireStimulus, coverFireStimulus, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
    //return;    
}

function CeaseProvidingCoveringFire()
{
    local name coverFireStimulus;

    coverFireStimulus = GetCoveringFireStimulus();
    Controller.Stimulus.DetachSender(coverFireStimulus);
    //return;    
}

function ListenForCoveringFire()
{
    local name requestCoverFireStimulusTemplate;

    // End:0x26
    if(Controller.TeamIndex == 0)
    {
        requestCoverFireStimulusTemplate = 'AlliedRequestSuppressingFire';        
    }
    else
    {
        requestCoverFireStimulusTemplate = 'AxisRequestSuppressingFire';
    }
    RegisterAxonSubstateStimulus(requestCoverFireStimulusTemplate, requestCoverFireStimulusTemplate, FriendlyRequestedCoveringFire,, 'RequestSuppressingFire');
    //return;    
}

function FriendlyRequestedCoveringFire()
{
    local StimulusSenderSubscription send;

    // End:0xB0
    if(GetCallbackParamSender('Sender', send))
    {
        // End:0xB0
        if(VSize(send.Owner.GetSpatialActor().Location - GetBot().Location) < float(1500))
        {
            // End:0xB0
            if(send.Owner.GetStimuliSenderParamVector('RequestSuppressingFire', 'Destination', vFriendlyCoverPosition))
            {
                ClearEventMapEntry('RequestSuppressingFire');
                GotoState('GestureToCover');
            }
        }
    }
    //return;    
}

function OnEnemyExposed()
{
    GotoState('SuppressingFire');
    //return;    
}

function Dummy()
{
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

state ResetEnemy extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetResetEnemy(OnResetEnemyResult);
        //return;        
    }

    function OnResetEnemyResult()
    {
        EnemyService.SubstateLostEnemy(NoEnemy, instanceID);
        EnemyService.SubstateHasEnemy(HasEnemy, instanceID);
        //return;        
    }

    function NoEnemy()
    {
        FinishBrain();
        //return;        
    }

    function HasEnemy()
    {
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state PreHide extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        DecaySuppressionEvent.Register(Controller);
        AnimService.SetActivityStartCallback(HideComplete);
        // End:0xA0
        if(Controller.IsSuppressed())
        {
            AnimService.RegisterAnimationEvent('Supression', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier * 1.5000000);            
        }
        else
        {
            AnimService.RegisterAnimationEvent('Hide', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier * 1.5000000);
        }
        //return;        
    }

    function HideComplete()
    {
        GotoState('HideSuppressed');
        //return;        
    }
    stop;    
}

state HideSuppressed extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        DecaySuppressionEvent.__BelowSafeCB__Delegate = UnHide;
        DecaySuppressionEvent.Register(Controller, MOHAPawn(Controller.Focus));
        RegisterAxonSubstateTimer(Controller.fMaxCoverBlownSuppressedTime, UnHide);
        //return;        
    }

    function UnHide()
    {
        StartCoverBlownCombat();
        //return;        
    }
    stop;    
}

state Aim extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Aim', AimFinished, FFImpl);
        RegisterPlayerShotNear();
        //return;        
    }

    function AimFinished()
    {
        // End:0x47
        if(Controller.bSupportsSuppressingFire)
        {
            ClearEventMapEntry('EnemyExposed');
            EnemyService.SubstateEnemyExposed(OnEnemyExposed,, 'EnemyExposed');
        }
        GotoState('Fire');
        //return;        
    }
    stop;    
}

state Fire extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('HitWall', ShotWall);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetCoverBlownBurst(), BurstDone, Controller.Focus);
        AmmoCountEvent.RegisterAmmoCountSubstate(Controller, Reload, Controller.GetWeaponAmmoCount(), MOHAPawn(Controller.Pawn));
        RegisterCanThrowGrenade();
        RegisterPlayerShotNear();
        //return;        
    }

    function Reload()
    {
        GotoState('Reload');
        //return;        
    }

    function BurstDone()
    {
        CurrentBursts++;
        GotoState('WaitBetweenBursts');
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

state SuppressingFire extends Fire
{
    function ChildBeginState(name PreviousStateName)
    {
        ClearEventMapEntry('EnemyExposed');
        RegisterAxonNamedScriptEventListener('HitWall', ShotWall);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetSuppressingBurst(), BurstDone, Controller.Focus);
        AmmoCountEvent.RegisterAmmoCountSubstate(Controller, Reload, Controller.GetWeaponAmmoCount(), MOHAPawn(Controller.Pawn));
        RegisterPlayerShotNear();
        //return;        
    }

    function BurstDone()
    {
        CurrentBursts++;
        GotoState('WaitBetweenBursts');
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        // End:0x38
        if(Controller.bSupportsSuppressingFire)
        {
            EnemyService.SubstateEnemyExposed(OnEnemyExposed,, 'EnemyExposed');
        }
        //return;        
    }
    stop;    
}

state Reload extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.NPCPreReload();
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
        AnimService.RegisterAnimationEvent('Aim', ReloadDone, FFImpl);
        GotoState('Aim');
        //return;        
    }
    stop;    
}

state WaitBetweenBursts extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(0.2500000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('Fire');
        //return;        
    }
    stop;    
}

state GestureToCover extends StartCombat
{
    event ChildBeginState(name PreviousStateName)
    {
        Controller.bProvidingCoveringFire = true;
        FFImpl.SetPointTarget(vFriendlyCoverPosition);
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Point', AnimDone, FFImpl);
        //return;        
    }

    function AnimDone()
    {
        GotoState('Aim');
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        FFImpl.ResetPointTarget();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CanShootEnemyCoverBlownActivationService'Default__CoverBlownCombatBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'CanShootEnemyCoverBlownActivationService'
    end object
    ActivationService=ActivationService0
    // Reference: AxonPointService'Default__CoverBlownCombatBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__CoverBlownCombatBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: EnemyWithWeaponTypeScriptEvent'Default__CoverBlownCombatBrainState.EnemyWithSniperWeaponEvent0'
    begin object name=EnemyWithSniperWeaponEvent0 class=Class'EnemyWithWeaponTypeScriptEvent'
        WeaponType=Class'MOHASniperRifle'
    end object
    EnemyWithSniperWeaponEvent=EnemyWithSniperWeaponEvent0
    fStandUpRadius=750.0000000
    // Reference: AxonEnemyService'Default__CoverBlownCombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__CoverBlownCombatBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__CoverBlownCombatBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__CoverBlownCombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__CoverBlownCombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__CoverBlownCombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__CoverBlownCombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__CoverBlownCombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0
    end object
    CCAwaitEvent=CCAwaitEvent0
    iSuppressionLevel=6
    instanceID="CoverBlownCombat"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}