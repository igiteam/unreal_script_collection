class MOHAScriptAIController extends MOHAAIController
    config(AI)
    hidecategories(Navigation);

var(Behavior) float fBlownFudgeFactor;
var(Behavior) config float fBlindFirePercentage;
var(Behavior) config float fBlindGrenadePercentage;
var(Behavior) config float fSuppressionThreatMultiplier;
var(Behavior) config float fCoveringFireThreatMultiplier;
var(Behavior) config float fSuppressionThreshhold;
var(Behavior) config float fSuppressionSafe;
var(Behavior) config float fSuppressionDecayRate;
var(Behavior) config float fWaitBetweenBurstsMax;
var(Behavior) config float fWaitBetweenBurstsMin;
var(Behavior) config float MaxCoverBursts;
var(Behavior) config float fMinGrenadeRange;
var(Behavior) config float fMaxGrenadeRange;
var(Behavior) config float fMinGrenadeThrowTimeInSec;
var(Behavior) config float fMinFriendlyThrowTimeInSec;
var(Behavior) config float fMaxGrenadeThrowVarianceInSec;
var(Behavior) config float fSingleShotRechamberInterval;
var(Behavior) config float fAggressivenessPct;
var(Behavior) config float fCoverBlownWaitTime;
var(Behavior) config float fEncroachedDistanceMax;
var(Behavior) config float fEnemyIsCloseDistance;
var(Behavior) config float fMinOpenCombatAimTime;
var(Behavior) config float fOpenCombatHideTime;
var(Behavior) config bool bSupportsSuppressingFire;
var(Behavior) config bool bSupportsCoveringFire;
var(Behavior) config bool bThrowsGrenades;
var bool bProvidingCoveringFire;
var bool bInIdleState;
var bool bPerformingCustomPerformance;
var bool bInPlayerPresence;
var(KynapseDebug) bool bDrawFleeInfo;
var(KynapseDebug) bool bDrawIdleCoverPoint;
var bool bDrawShorthandDebug;
var(Behavior) config float fPeekProbability;
var(Behavior) config float fMinPeekTime;
var(Behavior) config float fMaxPeekTime;
var(Behavior) config int UseAlternateCoverProbability;
var(Behavior) config int MinPeeks;
var(Behavior) config int MaxPeeks;
var(Behavior) config int MaxOpenCombatBursts;
var(Behavior) config float fWaitForReloadAfterHiddenTime;
var(Behavior) config float fWaitInHideBeforeBurstFireTime;
var(Behavior) config float fWaitBetweenLongRangeMeleeTime;
var(Behavior) config float fMeleeAggressivenessPct;
var(Behavior) config float fAimLagStrengthMMG;
var(Behavior) config float fWaitBetweenMMGBurstsMax;
var(Behavior) config float fWaitBetweenMMGBurstsMin;
var(Behavior) config float fMaxCoverBlownSuppressedTime;
var(Behavior) config float fTakeDamageBurstDelayPenalty;
var(Behavior) config float fCoverPeekTransitionSpeedMultiplier;
var(Behavior) config float fCoverHideTransitionSpeedMultiplier;
var(Behavior) config float fCoverAimTransitionSpeedMultiplier;
var(Behavior) config float fCoverBlindFireTransitionSpeedMultiplier;
var(Behavior) config int iPostGrenadeFleeBursts;
var(Behavior) config float fPeriodicAdvancedMin;
var(Behavior) config float fPeriodicAdvancedMax;
var(Behavior) config float fPeriodicAdvanceMinDistance;
var(Behavior) float fMMGHalfAngleFiringArcDeg;
var float fTotalPlayerPresenceTime;
var Actor FleeActor;
var float fIgnoreNextImpactTime;

function OnKynapseDestroy()
{
    local MOHAPawn MP;

    MP = MOHAPawn(Pawn);
    // End:0x6D
    if(MP != none)
    {
        // End:0x6D
        if((MP.GetPawnBody() != MP) && MP.GetPawnBody() != none)
        {
            MP.GetPawnBody().Destroy();
        }
    }
    super(KynapseAIController).OnKynapseDestroy();
    //return;    
}

function bool IsInIdleLocomotion()
{
    return (fGotoDistanceRemaining > float(0)) && bInIdleState;
    //return ReturnValue;    
}

function bool GetEnemyLocation(out Vector vEnemyloc)
{
    // End:0x21
    if(Focus != none)
    {
        vEnemyloc = Focus.Location;
        return true;
    }
    // End:0x43
    if(VSizeSq(FocalPoint) > 0.2500000)
    {
        vEnemyloc = FocalPoint;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool UpdatePlayBulletImpact(Vector StartTrace, Vector impactPos)
{
    local Vector vEnemyloc;
    local float fDistToImpact, fDistToEnemy;

    // End:0x16
    if(!GetEnemyLocation(vEnemyloc))
    {
        return true;
    }
    fDistToEnemy = VSize(vEnemyloc - StartTrace);
    fDistToImpact = VSize(impactPos - StartTrace);
    // End:0x93
    if((fDistToEnemy > 0.0000000) && (fDistToImpact / fDistToEnemy) < 0.3000000)
    {
        fIgnoreNextImpactTime = WorldInfo.TimeSeconds;
        ABSS.TripNamedScriptEvent('HitWall');
        return false;
    }
    return true;
    //return ReturnValue;    
}

function int GetAlertLocalPlayerCost()
{
    return 1;
    //return ReturnValue;    
}

function AlertLocalPlayer()
{
    local PlayerController PC;
    local int Count;

    Count = GetAlertLocalPlayerCost();
    // End:0x3D
    foreach LocalPlayerControllers(PC)
    {
        MOHAPlayerController(PC).RecordAIState(self, Count);        
    }    
    //return;    
}

function bool ShouldFireWeaponAttachment()
{
    return WorldInfo.TimeSeconds != fIgnoreNextImpactTime;
    //return ReturnValue;    
}

function OnPlayerPresence(MOHAPlayerController C, float dt)
{
    bInPlayerPresence = true;
    fTotalPlayerPresenceTime += dt;
    ChoosePlayerPresencePerformance(C);
    SetTimer(dt * 1.5000000, false, 'PlayerProximityTimerExpired');
    //return;    
}

function ChoosePlayerPresencePerformance(MOHAPlayerController C)
{
    local MOHAAIPawn MOHAPawn;
    local CCStimulusType stim;

    // End:0x6A
    if((CurrentAffordanceNode != none) && MOHAAffordanceAIDComponent(CurrentAffordanceNode.AIDComponent) != none)
    {
        stim = MOHAAffordanceAIDComponent(CurrentAffordanceNode.AIDComponent).GetNextSpokenNearby();
        // End:0x6A
        if(stim != none)
        {
            SendCCStimulusByType(stim);
            return;
        }
    }
    // End:0xF7
    if((fTotalPlayerPresenceTime > 5.0000000) && bInIdleState)
    {
        // End:0xB7
        if(MOHAPawn(Pawn) != none)
        {
            MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
        }
        // End:0xF7
        if(MOHAPawn != none)
        {
            SendCCStimulus("PlayerPresenceIdleNonCombat", C.Pawn);
        }
    }
    //return;    
}

function PlayerProximityTimerExpired()
{
    fTotalPlayerPresenceTime = 0.0000000;
    bInPlayerPresence = false;
    //return;    
}

function bool InPlayersPresence()
{
    return bInPlayerPresence;
    //return ReturnValue;    
}

function OnCCPerformanceStarted(CCPerformance2 Performance, float performanceDuration)
{
    local AffordanceNodeVolume anv;

    // End:0x3F
    if(Performance.Outer == MOHAGameInfo(WorldInfo.Game).GlobalCCDirector.GetGlobalPerformanceSet())
    {
        return;
    }
    // End:0x94
    foreach DynamicActors(Class'EAKynapse.AffordanceNodeVolume', anv)
    {
        // End:0x93
        if(MOHAAffordanceAIDComponent(anv.AIDComponent) != none)
        {
            MOHAAffordanceAIDComponent(anv.AIDComponent).OnCCPerformanceStarted(Performance, performanceDuration);
        }        
    }    
    //return;    
}

function float GetMinOpenCombatAimTime()
{
    return fMinOpenCombatAimTime;
    //return ReturnValue;    
}

function NPCPreReload()
{
    // End:0x28
    if(MOHAAIPawn(Pawn) != none)
    {
        MOHAAIPawn(Pawn).NPCPreReload();
    }
    //return;    
}

function OnTakeDamage(int inDamage)
{
    local float burstPenalty;

    burstPenalty = fTakeDamageBurstDelayPenalty * (float(inDamage) / 100.0000000);
    // End:0x32
    if(MountedGun != none)
    {
        burstPenalty *= 0.5000000;
    }
    BurstMan.AddNextFireTimePenalty(burstPenalty);
    // End:0x76
    if(BurstMan.fNextFireTimePenalty > fTakeDamageBurstDelayPenalty)
    {
        BurstMan.fNextFireTimePenalty = fTakeDamageBurstDelayPenalty;
    }
    //return;    
}

function OnStartGTFO()
{
    MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody()).OnStartGTFO();
    //return;    
}

function OnEndGTFO()
{
    MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody()).OnEndGTFO();
    //return;    
}

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    local Vector pos;
    local float XL, YL;
    local string Text;
    local MOHAPawn Inst;
    local Color C;
    local float Alpha;

    super(KynapseAIController).PostRenderFor(PC, Canvas, CameraPosition, CameraDir);
    // End:0x210
    if(!bDrawStateTransitions && bDrawShorthandDebug)
    {
        Alpha = 1.0000000;
        // End:0x85
        if(Pawn != none)
        {
            Alpha = 1.0000000 - (VSize(PC.Pawn.Location - Pawn.Location) / float(2000));
        }
        // End:0x210
        if(Alpha > 0.0000000)
        {
            pos = Canvas.Project(Pawn.Location + (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)));
            Canvas.__NFUN_464__(string(ABSS.BrainStateTop().Class), XL, YL);
            pos.X -= (XL * 0.5000000);
            Canvas.SetPos(pos.X, pos.Y);
            Canvas.SetDrawColor(0, byte(255), 0, byte(float(255) * Alpha));
            Canvas.__NFUN_465__(string(ABSS.BrainStateTop().Class));
            Canvas.__NFUN_465__(string(ABSS.BrainStateTop().GetStateName()));
            // End:0x210
            if(MOHAAIPawn(Pawn) != none)
            {
                Canvas.__NFUN_465__(string(MOHAAIPawn(Pawn).ActiveOIR.OIRParent));
            }
        }
    }
    // End:0x48E
    if(bDrawFleeInfo)
    {
        // End:0x226
        if(FleeActor == none)
        {
            return;
        }
        Text = string(FleeActor.Name);
        Inst = MOHAPawn(FleeActor.Instigator);
        // End:0x262
        if(Inst == none)
        {
            return;
        }
        C.R = byte(255);
        C.G = byte(255);
        C.B = byte(255);
        C.A = byte(255);
        Text = ("Fleeing: '" $ string(FleeActor.Name)) $ "'";
        // End:0x347
        if(Inst.IsTeammate(Pawn))
        {
            C.R = byte(255);
            C.G = 0;
            C.B = 0;
            Text = Text $ " TEAMMATE!";
        }
        pos = Canvas.Project(Pawn.Location + (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.5000000)));
        Canvas.__NFUN_464__(Text, XL, YL);
        pos.X -= (XL * 0.5000000);
        Canvas.SetPos(pos.X, pos.Y);
        Canvas.DrawColor = C;
        Canvas.__NFUN_469__(Text);
        DrawDebugLine(Pawn.Location + (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.5000000)), FleeActor.Location, C.R, C.G, C.B);
    }
    // End:0x4F4
    if(bDrawIdleCoverPoint)
    {
        DrawDebugLine(Pawn.Location, IdleCoverActor.Location, byte(255), byte(255), byte(255));
        DrawDebugBox(IdleCoverActor.Location, vect(5.0000000, 5.0000000, 5.0000000), byte(255), byte(255), byte(255));
    }
    //return;    
}

function bool IsSuppressed()
{
    return SuppressionMeter > fSuppressionThreshhold;
    //return ReturnValue;    
}

defaultproperties
{
    fBlownFudgeFactor=0.2000000
    fBlindFirePercentage=30.0000000
    fSuppressionThreatMultiplier=0.5000000
    fCoveringFireThreatMultiplier=1.0000000
    fSuppressionThreshhold=8.0000000
    fSuppressionSafe=2.0000000
    fSuppressionDecayRate=2.0000000
    MaxCoverBursts=1.0000000
    fMinGrenadeRange=500.0000000
    fMaxGrenadeRange=5000.0000000
    fMinGrenadeThrowTimeInSec=15.0000000
    fMinFriendlyThrowTimeInSec=10.0000000
    fMaxGrenadeThrowVarianceInSec=25.0000000
    fSingleShotRechamberInterval=1.3330000
    fAggressivenessPct=60.0000000
    fCoverBlownWaitTime=4.0000000
    fEncroachedDistanceMax=1500.0000000
    fEnemyIsCloseDistance=800.0000000
    fOpenCombatHideTime=6.0000000
    bSupportsSuppressingFire=true
    bSupportsCoveringFire=true
    bThrowsGrenades=true
    fPeekProbability=40.0000000
    fMinPeekTime=1.1000000
    fMaxPeekTime=1.3300000
    UseAlternateCoverProbability=70
    MaxPeeks=2
    MaxOpenCombatBursts=1
    fWaitForReloadAfterHiddenTime=3.0000000
    fWaitInHideBeforeBurstFireTime=0.5000000
    fWaitBetweenLongRangeMeleeTime=2.0000000
    fMeleeAggressivenessPct=30.0000000
    fAimLagStrengthMMG=15.0000000
    fWaitBetweenMMGBurstsMax=2.0000000
    fWaitBetweenMMGBurstsMin=1.0000000
    fMaxCoverBlownSuppressedTime=2.0000000
    fTakeDamageBurstDelayPenalty=2.0000000
    fCoverPeekTransitionSpeedMultiplier=1.0000000
    fCoverHideTransitionSpeedMultiplier=1.0000000
    fCoverAimTransitionSpeedMultiplier=1.0000000
    fCoverBlindFireTransitionSpeedMultiplier=1.0000000
    iPostGrenadeFleeBursts=2
    fPeriodicAdvanceMinDistance=500.0000000
    fMMGHalfAngleFiringArcDeg=45.0000000
    // Reference: StimulusComponent'Default__MOHAScriptAIController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAScriptAIController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAScriptAIController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAScriptAIController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAScriptAIController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAScriptAIController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}