class CoverCombatBrainState extends CombatBrainState;

var float WaitCrouchedTimeMin;
var float WaitCrouchedTimeMax;
var int BrainMaxPeeks;
var int NumPeeks;
var() float WaitInc;
var() float WaitDecaySpeed;
var() float WaitTimeMax;
var() float CoverStaleTimeMax;
var() float CoverStaleTimeMin;
var() float fAtCoverDist;
var int CurrentBursts;
var KynapseCoverNode newCoverNode;
var bool bShouldHideSuppressed;
var bool bPlayerRequestedCoveringFire;
var export editinline InCoverHasEnemyActivationService ActivationService;
var export editinline PeriodicAdvanceSubstateFSMService PeriodicAdvanceService;
var export editinline TacaffAdvanceSubstateFSMService TacaffAdvanceService;
var export editinline EnemyWithinRadiusAxonScriptEvent EnemyWithinRadiusEvent;

function RegisterActivationEvents()
{
    ActivationService.EnemyService = EnemyService;
    ActivationService.CoverService = CoverService;
    ActivationService.Controller = Controller;
    ActivationService.SuppressionLevel = iSuppressionLevel;
    ActivationService.Start(ActivationEventTripped, 'CombatBrainStateHasEnemy');
    //return;    
}

function ResetPeeks()
{
    BrainMaxPeeks = Controller.MinPeeks + Rand((Controller.MaxPeeks - Controller.MinPeeks) + 1);
    BrainMaxPeeks = Clamp(BrainMaxPeeks, Controller.MinPeeks, Controller.MaxPeeks);
    //return;    
}

function bool ShouldPeek()
{
    // End:0x26
    if(EnemyWithinRadiusEvent.IsEnemyWithinRadius(Controller.fEnemyIsCloseDistance))
    {
        return false;
    }
    // End:0x3E
    if(NumPeeks >= BrainMaxPeeks)
    {
        NumPeeks = 0;
        return false;
    }
    return (FRand() * 100.0000000) < Controller.fPeekProbability;
    //return ReturnValue;    
}

function Dummy()
{
    //return;    
}

function EnemyOutsideFiringArc()
{
    GotoState('FindBetterCover');
    //return;    
}

function RegisterParentSubstateEvents()
{
    CoverService.SubstateOnEnemyOutsideCoverFiringArc(1100, EnemyOutsideFiringArc,, 'CheckFiringArc');
    CoverService.SubstateOnCoverUnmounted(FinishBrain, 'finebethatway');
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    EnemyService.AddPlayerShotAtMeThreatAssessment();
    EnemyService.AddCoverFiringArcAssessment();
    //return;    
}

function CustomStart()
{
    // End:0x67
    if(((Controller.bIgnoreAffordance == false) && Controller.CurrentAffordanceNode != none) && Controller.bInAssignedAffordance == false)
    {
        PeriodicAdvanceService.Start(4.0000000, 9.0000000, Controller);        
    }
    else
    {
        // End:0xB3
        if(Controller.fPeriodicAdvancedMax > 0.0000000)
        {
            PeriodicAdvanceService.Start(Controller.fPeriodicAdvancedMin, Controller.fPeriodicAdvancedMax, Controller);
        }
    }
    TacaffAdvanceService.Start(1.0000000, 2.0000000);
    //return;    
}

function NoLongerSeeEnemy()
{
    GotoState('TryFireAtLKP');
    //return;    
}

function CoveringFire()
{
    local StimulusSenderSubscription send;
    local int Dummy;

    bPlayerRequestedCoveringFire = false;
    // End:0x5A
    if(GetCallbackParamSender('Sender', send))
    {
        // End:0x5A
        if(send.Owner.GetStimuliSenderParamInt('RequestSuppressingFire', 'Player', Dummy))
        {
            bPlayerRequestedCoveringFire = true;
        }
    }
    //return;    
}

function ProvideCoveringFire(delegate<AxonDelegate> callback)
{
    local name requestCoverFireStimulusTemplate;

    // End:0x16
    if(!Controller.bSupportsCoveringFire)
    {
        return;
    }
    // End:0x3C
    if(Controller.TeamIndex == 0)
    {
        requestCoverFireStimulusTemplate = 'AlliedRequestSuppressingFire';        
    }
    else
    {
        requestCoverFireStimulusTemplate = 'AxisRequestSuppressingFire';
    }
    RegisterAxonSubstateStimulus(requestCoverFireStimulusTemplate, requestCoverFireStimulusTemplate, callback);
    //return;    
}

function BurstDone()
{
    //return;    
}

function InitStartCombat()
{
    ResetPeeks();
    // End:0x28
    if(ShouldPeek())
    {
        GotoState('Peek');        
    }
    else
    {
        GotoState('SpotEnemy');
    }
    //return;    
}

function FinishBrain()
{
    super.FinishBrain();
    //return;    
}

function SuspendBrain(AxonBrainState usurperState)
{
    super(AxonBrainState).SuspendBrain(usurperState);
    //return;    
}

function PlayerShotNear()
{
    SetPlayerShotAtThreat();
    GotoState('ResetEnemy');
    //return;    
}

function OnEnemyExposed()
{
    ClearEventMapEntry('EnemyExposed');
    // End:0x2F
    if(Controller.bSupportsSuppressingFire)
    {
        GotoState('StartSuppressingFire');
    }
    //return;    
}

function ResetCheckExposed()
{
    ClearEventMapEntry('EnemyExposed');
    // End:0x27
    if(Controller.IsSuppressed())
    {
        return;
    }
    // End:0x7A
    if(Controller.bSupportsSuppressingFire && float(Rand(100)) <= Controller.fAggressivenessPct)
    {
        EnemyService.SubstateEnemyExposed(OnEnemyExposed,, 'EnemyExposed');
    }
    //return;    
}

state CheckForEnemy extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
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
        // End:0x1E
        if(ShouldPeek())
        {
            GotoState('Peek');            
        }
        else
        {
            GotoState('SpotEnemy');
        }
        //return;        
    }
    stop;    
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
        GotoState('SpotEnemyWait');
        //return;        
    }
    stop;    
}

state Hide extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        PushHideParams();
        AnimService.SetFallbackCallback(wait);
        // End:0x88
        if(Controller.IsSuppressed())
        {
            AnimService.RegisterAnimationEvent('Supression', WaitForSafe, Controller.GetCurrentCoverNode(), true,, Controller.fCoverHideTransitionSpeedMultiplier);            
        }
        else
        {
            AnimService.RegisterAnimationEvent('Hide', WaitForSafe, Controller.GetCurrentCoverNode(), true,, Controller.fCoverHideTransitionSpeedMultiplier);
        }
        DecaySuppressionEvent.Register(Controller);
        CCRequestEvent.Register(Controller, PerformanceReady);
        RegisterCanThrowGrenade();
        ResetCheckExposed();
        ResetPeeks();
        EnemyWithinRadiusEvent.RegisterCheckWithinRadius(Controller, Controller.fEnemyIsCloseDistance, EnemyIsClose);
        // End:0x191
        if(Controller.SuppressionMeter < Controller.fSuppressionThreshhold)
        {
            ProvideCoveringFire(CoveringFire);
        }
        //return;        
    }

    function wait()
    {
        RegisterAxonSubstateTimer(1.0000000, WaitForSafe);
        //return;        
    }

    function WaitForSafe()
    {
        // End:0x28
        if(Rand(100) < Controller.UseAlternateCoverProbability)
        {
            GotoState('TryAlternateCover');            
        }
        else
        {
            GotoState('HideSuppressed');
        }
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('CCPerformHide');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        GotoState('TryCoveringFire');
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ClearEventMapEntry('Hide');
        //return;        
    }

    function EnemyIsClose()
    {
        GotoState('HideSuppressed');
        //return;        
    }
    stop;    
}

state TryAlternateCover extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.GetAlternateCover(OnGetAlternateCover);
        //return;        
    }

    function OnGetAlternateCover()
    {
        newCoverNode = none;
        // End:0x33
        if(CoverService.GetGetAlternateCoverResult(newCoverNode))
        {
            GotoState('TryClaimAlternateCover');            
        }
        else
        {
            GotoState('HideSuppressed');
        }
        //return;        
    }
    stop;    
}

state FindBetterCover extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.GetAlternateCover(OnGetAlternateCover, true);
        //return;        
    }

    function OnGetAlternateCover()
    {
        newCoverNode = none;
        // End:0x2F
        if(CoverService.GetGetAlternateCoverResult(newCoverNode))
        {
            GotoNextState();            
        }
        else
        {
            ClearEventMapEntry('CheckFiringArc');
            GotoState('HideSuppressed');
        }
        //return;        
    }

    function GotoNextState()
    {
        GotoState('TryClaimAlternateCover');
        //return;        
    }
    stop;    
}

state FindBetterCoverThenShoot extends FindBetterCover
{
    function GotoNextState()
    {
        GotoState('TryClaimAlternateCoverThenShoot');
        //return;        
    }
    stop;    
}

state TryClaimAlternateCover extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClaimCover(newCoverNode.GetId(), ClaimResult);
        //return;        
    }

    function ClaimResult()
    {
        // End:0x37
        if(CoverService.GetClaimResult())
        {
            Controller.SetNewAlternateCoverNode(newCoverNode, 'Hide');
        }
        GotoNextState();
        //return;        
    }

    function GotoNextState()
    {
        GotoState('HideSuppressed');
        //return;        
    }
    stop;    
}

state TryClaimAlternateCoverThenShoot extends TryClaimAlternateCover
{
    function GotoNextState()
    {
        GotoState('StartFire');
        //return;        
    }
    stop;    
}

state HideSuppressed extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        local MOHAPawn suppressingPawn;
        local bool bCheckSuppressorDeath;

        bCheckSuppressorDeath = false;
        suppressingPawn = none;
        // End:0x84
        if(Controller.IsSuppressed())
        {
            bCheckSuppressorDeath = true;
            suppressingPawn = LastSuppressingPawn;
            AnimService.RegisterAnimationEvent('Supression', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);            
        }
        else
        {
            AnimService.RegisterAnimationEvent('Hide', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
        }
        DecaySuppressionEvent.__BelowSafeCB__Delegate = UnHide;
        DecaySuppressionEvent.Register(Controller, suppressingPawn, bCheckSuppressorDeath);
        RegisterAxonSubstateTimer(Controller.fWaitForReloadAfterHiddenTime, TimerDone, 'HideSuppressed', 'HideSuppressed');
        CCRequestEvent.Register(Controller, PerformanceReady);
        // End:0x1CE
        if(float(Rand(100)) <= Controller.fBlindGrenadePercentage)
        {
            EnemyService.SubstateCanThrowGrenade(Controller, TryBlindGrenade, 5.0000000, 10.0000000, 0.0000000, instanceID, 'HideSuppressed');
            EnemyService.RegisterDefaultGrenadeConstraints(instanceID);
        }
        // End:0x20A
        if(float(Rand(100)) <= Controller.fBlindFirePercentage)
        {
            RegisterAxonSubstateTimer(Controller.fWaitInHideBeforeBurstFireTime, TryBlindFire);
        }
        //return;        
    }

    function UnHide()
    {
        GotoState('CheckForEnemy');
        //return;        
    }

    function TimerDone()
    {
        GotoState('HideSuppressedListenForReload');
        //return;        
    }

    function TryBlindFire()
    {
        GotoState('BlindFire');
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('CCPerformHide');
        //return;        
    }

    function TryBlindGrenade()
    {
        // End:0x20
        if(Controller.bThrowsGrenades)
        {
            GotoState('BlindGrenade');
        }
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ClearEventMapEntry('HideSuppressed');
        //return;        
    }
    stop;    
}

state CCPerformHide extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Hide', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
        CCAwaitEvent.Register(Controller, PerformanceDone);
        //return;        
    }

    function PerformanceDone()
    {
        GotoState('HideSuppressed');
        //return;        
    }
    stop;    
}

state HideSuppressedListenForReload extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        DecaySuppressionEvent.__BelowSafeCB__Delegate = UnHide;
        DecaySuppressionEvent.Register(Controller, LastSuppressingPawn);
        //return;        
    }

    function UnHide()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

state BlindFire extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Blind', Dummy, Controller.GetCurrentCoverNode(),,, Controller.fCoverBlindFireTransitionSpeedMultiplier);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetWildBurst(), BurstDone, Controller.Focus);
        //return;        
    }

    function BurstDone()
    {
        GotoState('Hide');
        //return;        
    }
    stop;    
}

state BlindGrenade extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('BlindGrenade', AnimDone, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
        //return;        
    }

    function AnimDone()
    {
        GotoState('Hide');
        //return;        
    }
    stop;    
}

state Peek extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        NumPeeks++;
        AnimService.SetActivityStartCallback(PeekExposed);
        AnimService.RegisterAnimationEvent('Peek', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverPeekTransitionSpeedMultiplier);
        DecaySuppressionEvent.__AboveThreshholdCB__Delegate = ShouldHideSuppressed;
        DecaySuppressionEvent.Register(Controller);
        CCRequestEvent.Register(Controller, PerformanceReady, 1);
        ProvideCoveringFire(CoveringFire);
        EnemyWithinRadiusEvent.RegisterCheckWithinRadius(Controller, Controller.fEnemyIsCloseDistance, EnemyIsClose);
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 5000);
        //return;        
    }

    function PeekExposed()
    {
        RegisterAxonSubstateTimer(RandRange(Controller.fMinPeekTime, Controller.fMaxPeekTime), ShouldHide);
        //return;        
    }

    function ShouldHide()
    {
        GotoState('Hide');
        //return;        
    }

    function ShouldHideSuppressed()
    {
        Controller.SendCCStimulus("Suppressed");
        GotoState('Hide');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        GotoState('TryCoveringFire');
        //return;        
    }

    function EnemyIsClose()
    {
        GotoState('SpotEnemyWait');
        //return;        
    }

    function PerformanceReady()
    {
        GotoState('CCPerformHide');
        //return;        
    }
    stop;    
}

state SpotEnemyWait extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(1.0000000, CheckForCanShoot);
        EnemyService.SubstateOnCanSeeEnemy(CheckForCanShoot, 'CoverCombatBrainState');
        RegisterPlayerShotNear();
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 5000);
        ProvideCoveringFire(CoveringFire);
        //return;        
    }

    function CheckForCanShoot()
    {
        EnemyService.CanShootEnemy(OnCanShootEnemyResult, true);
        //return;        
    }

    function OnCanShootEnemyResult()
    {
        local bool bCanShoot;

        bCanShoot = EnemyService.GetCanShootEnemyResult();
        // End:0x33
        if(bCanShoot)
        {
            GotoState('StartFire');
            return;
        }
        GotoState('Hide');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        GotoState('TryCoveringFire');
        //return;        
    }
    stop;    
}

state SpotEnemy extends SpotEnemyWait
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.SetFallbackCallback(ShouldHide);
        AnimService.RegisterAnimationEvent('Peek', AimAnimDone, Controller.GetCurrentCoverNode(),,, Controller.fCoverPeekTransitionSpeedMultiplier);
        // End:0xA7
        if((FRand() * 100.0000000) < Controller.fAggressivenessPct)
        {
            EnemyService.SubstateOnCanSeeEnemy(CheckForCanShoot, 'CoverCombatBrainState');
        }
        DecaySuppressionEvent.__AboveThreshholdCB__Delegate = ShouldHide;
        DecaySuppressionEvent.Register(Controller);
        RegisterPlayerShotNear();
        EnemyService.SubstateNoLongerSeeEnemy(NoLongerSeeEnemy, 5000);
        ProvideCoveringFire(CoveringFire);
        //return;        
    }

    function AimAnimDone()
    {
        GotoState('SpotEnemyWait');
        //return;        
    }

    function ShouldHide()
    {
        Controller.SendCCStimulus("Suppressed");
        GotoState('Hide');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        GotoState('TryCoveringFire');
        //return;        
    }
    stop;    
}

state FireBase extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        DecaySuppressionEvent.__AboveThreshholdCB__Delegate = ShouldHide;
        DecaySuppressionEvent.Register(Controller);
        RegisterPlayerShotNear();
        //return;        
    }

    function ShouldHide()
    {
        Controller.SendCCStimulus("Suppressed");
        GotoState('Hide');
        //return;        
    }

    function EnemyOutsideFiringArc()
    {
        GotoState('FindBetterCoverThenShoot');
        //return;        
    }
    stop;    
}

state TryFireAtLKP extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.CanSuppressEnemy(OnCanSuppressEnemyResult, true);
        //return;        
    }

    function OnCanSuppressEnemyResult()
    {
        local bool bCanSuppress;

        bCanSuppress = EnemyService.GetCanSuppressEnemyResult();
        // End:0x34
        if(bCanSuppress)
        {
            GotoState('StartFire');            
        }
        else
        {
            GotoState('Hide');
        }
        //return;        
    }
    stop;    
}

state StartFire extends FireBase
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x19
        if(bNeedsReload)
        {
            GotoState('Reload');
            return;
        }
        AnimService.RegisterAnimationEvent('Aim', AimAnimDone, Controller.GetCurrentCoverNode(),,, Controller.fCoverAimTransitionSpeedMultiplier);
        ProvideCoveringFire(CoveringFire);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function AimAnimDone()
    {
        GotoState('Fire');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        GotoState('TryCoveringFire');
        //return;        
    }
    stop;    
}

state Fire extends FireBase
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverAimTransitionSpeedMultiplier);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetCoverFireBurst(), BurstDone, Controller.Focus);
        ConditionalRegisterReloadEvent();
        ProvideCoveringFire(CoveringFire);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function BurstDone()
    {
        CurrentBursts++;
        // End:0x6E
        if(float(CurrentBursts) >= Controller.MaxCoverBursts)
        {
            CurrentBursts = 0;
            // End:0x5D
            if(EnemyWithinRadiusEvent.IsEnemyWithinRadius(Controller.fEnemyIsCloseDistance))
            {
                GotoState('StartFire');                
            }
            else
            {
                GotoState('Hide');
            }            
        }
        else
        {
            GotoState('WaitBetweenBursts');
        }
        //return;        
    }

    function ShouldReload()
    {
        GotoState('Reload');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        GotoState('TryCoveringFire');
        //return;        
    }
    stop;    
}

state StartSuppressingFire extends StartFire
{
    function AimAnimDone()
    {
        GotoState('SuppressingFire');
        //return;        
    }
    stop;    
}

state SuppressingFire extends FireBase
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Aim', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverAimTransitionSpeedMultiplier);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetSuppressingBurst(), BurstDone, Controller.Focus);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function BurstDone()
    {
        // End:0x83
        if(bShouldHideSuppressed)
        {
            Controller.SendCCStimulus("Suppressed");
            AnimService.RegisterAnimationEvent('Hide', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
            GotoState('HideSuppressed');            
        }
        else
        {
            GotoState('Hide');
        }
        //return;        
    }

    function ShouldHide()
    {
        bShouldHideSuppressed = true;
        //return;        
    }

    function ShouldReload()
    {
        super(CombatBrainState).ShouldReload();
        BurstDone();
        //return;        
    }
    stop;    
}

state TryCoveringFire extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.CanSuppressEnemy(OnCanSuppressEnemyResult, true);
        //return;        
    }

    function OnCanSuppressEnemyResult()
    {
        local bool bCanSuppress;

        bCanSuppress = EnemyService.GetCanSuppressEnemyResult();
        // End:0x34
        if(bCanSuppress)
        {
            GotoState('StartCoveringFire');            
        }
        else
        {
            GotoState('Hide');
        }
        //return;        
    }
    stop;    
}

state StartCoveringFire extends StartFire
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.bProvidingCoveringFire = true;
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function AimAnimDone()
    {
        GotoState('DoCoveringFire');
        //return;        
    }

    function ChildEndState(name NextState)
    {
        Controller.bProvidingCoveringFire = false;
        //return;        
    }
    stop;    
}

state DoCoveringFire extends FireBase
{
    function ChildBeginState(name PreviousStateName)
    {
        Controller.bProvidingCoveringFire = true;
        Controller.fSuppressionThreatMultiplier = Controller.default.fCoveringFireThreatMultiplier;
        // End:0x76
        if(bPlayerRequestedCoveringFire)
        {
            MOHAAIPawn(Controller.Pawn).NPCtoNPCDamageMult = 1.0000000;
            Controller.AccuracyMan.fNpcToNpcAccuracyScale = 0.0000000;
        }
        AnimService.RegisterAnimationEvent('Aim', None, Controller.GetCurrentCoverNode(),,, Controller.fCoverAimTransitionSpeedMultiplier);
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetSuppressingBurst(), BurstDone, Controller.Focus);
        ProvideCoveringFire(CoveringFire);
        super.ChildBeginState(PreviousStateName);
        //return;        
    }

    function ShouldReload()
    {
        super(CombatBrainState).ShouldReload();
        BurstDone();
        //return;        
    }

    function BurstDone()
    {
        GotoState('Hide');
        //return;        
    }

    function CoveringFire()
    {
        global.CoveringFire();
        // End:0x52
        if(bPlayerRequestedCoveringFire)
        {
            MOHAAIPawn(Controller.Pawn).NPCtoNPCDamageMult = 1.0000000;
            Controller.AccuracyMan.fNpcToNpcAccuracyScale = 0.0000000;
        }
        //return;        
    }

    function ChildEndState(name NextState)
    {
        MOHAAIPawn(Controller.Pawn).NPCtoNPCDamageMult = MOHAAIPawn(Controller.Pawn).default.NPCtoNPCDamageMult;
        Controller.AccuracyMan.fNpcToNpcAccuracyScale = Controller.AccuracyMan.Class.default.fNpcToNpcAccuracyScale;
        Controller.fSuppressionThreatMultiplier = Controller.default.fSuppressionThreatMultiplier;
        Controller.bProvidingCoveringFire = false;
        //return;        
    }
    stop;    
}

state ThrowGrenade extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Grenade', GrenadeDone, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
        //return;        
    }

    function GrenadeDone()
    {
        GotoState('Hide');
        //return;        
    }
    stop;    
}

state Reload extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        ClearEventMapEntry('EnemyExposed');
        Controller.NPCPreReload();
        PostReload();
        AnimService.SetFallbackCallback(ReloadFailed);
        AnimService.RegisterAnimationEvent('Reload', ReloadDone, Controller.GetCurrentCoverNode(), true,, Controller.fCoverHideTransitionSpeedMultiplier);
        Controller.SendCCStimulus("Reload");
        // End:0xF5
        if(MOHAPawn(Controller.Pawn) != none)
        {
            MOHAPawn(Controller.Pawn).AxonObserver.NotifyObservers('Reload');
        }
        //return;        
    }

    function ReloadFailed()
    {
        RegisterAxonSubstateTimer(1.0000000, ReloadDone);
        //return;        
    }

    function ReloadDone()
    {
        GotoState('CheckForEnemy');
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ResetCheckExposed();
        //return;        
    }
    stop;    
}

state WaitBetweenBursts extends StartCombat
{
    function ChildBeginState(name PreviousStateName)
    {
        local float WaitTime;

        WaitTime = RandRange(Controller.fWaitBetweenBurstsMin, Controller.fWaitBetweenBurstsMax);
        RegisterAxonSubstateTimer(WaitTime, TimerDone, 'WaitBetweenBursts', 'WaitBetweenBursts');
        //return;        
    }

    function TimerDone()
    {
        GotoState('StartFire');
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ClearEventMapEntry('WaitBetweenBursts');
        //return;        
    }

    function EnemyOutsideFiringArc()
    {
        GotoState('FindBetterCoverThenShoot');
        //return;        
    }
    stop;    
}

defaultproperties
{
    WaitCrouchedTimeMin=1.0000000
    WaitCrouchedTimeMax=1.5000000
    WaitInc=0.5000000
    WaitDecaySpeed=0.5000000
    WaitTimeMax=5.0000000
    CoverStaleTimeMax=16.0000000
    CoverStaleTimeMin=12.0000000
    fAtCoverDist=100.0000000
    // Reference: InCoverHasEnemyActivationService'Default__CoverCombatBrainState.ActivationService0'
    begin object name=ActivationService0 class=Class'InCoverHasEnemyActivationService'
        // Reference: KynapseCoverNode'Default__CoverCombatBrainState.ActivationService0.CoverNode0'
        begin object name=CoverNode0
        end object
        CoverNode=CoverNode0
    end object
    ActivationService=ActivationService0
    // Reference: PeriodicAdvanceSubstateFSMService'Default__CoverCombatBrainState.PeriodicAdvanceService0'
    begin object name=PeriodicAdvanceService0 class=Class'PeriodicAdvanceSubstateFSMService'
    end object
    PeriodicAdvanceService=PeriodicAdvanceService0
    // Reference: TacaffAdvanceSubstateFSMService'Default__CoverCombatBrainState.TacaffAdvanceService0'
    begin object name=TacaffAdvanceService0 class=Class'TacaffAdvanceSubstateFSMService'
    end object
    TacaffAdvanceService=TacaffAdvanceService0
    // Reference: EnemyWithinRadiusAxonScriptEvent'Default__CoverCombatBrainState.EnemyWithinRadiusEvent0'
    begin object name=EnemyWithinRadiusEvent0 class=Class'EnemyWithinRadiusAxonScriptEvent'
    end object
    EnemyWithinRadiusEvent=EnemyWithinRadiusEvent0
    // Reference: AxonEnemyService'Default__CoverCombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__CoverCombatBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__CoverCombatBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__CoverCombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__CoverCombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__CoverCombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__CoverCombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__CoverCombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0
    end object
    CCAwaitEvent=CCAwaitEvent0
    iSuppressionLevel=6
    instanceID="CoverCombat"
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}