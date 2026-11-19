class MOHAAlliedAIController extends MOHAScriptAIController
    config(AI)
    hidecategories(Navigation);

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super(MOHAAIController).Possess(inPawn, bVehicleTransition);
    Stimulus.AttachSender('AlliedPresenceSender', 'AlliedPresence', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, 3);
    Stimulus.AttachListener('AlliedPresenceListener', 'AlliedPresence', OnAlliedPresence, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, 3);
    //return;    
}

function OnAlliedPresence(out StimulusListenerSubscription Listener, out StimulusSenderSubscription Sender)
{
    //return;    
}

function BURST_TYPE GetCoverFireBurst()
{
    return GetLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetCoverBlownBurst()
{
    return GetLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetOpenCombatBurst()
{
    return GetLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetMMGBurst()
{
    return GetLongBurst();
    //return ReturnValue;    
}

defaultproperties
{
    fBlindFirePercentage=50.0000000
    fSuppressionThreatMultiplier=0.1000000
    fSuppressionSafe=3.0000000
    fSuppressionDecayRate=3.0000000
    fWaitBetweenBurstsMax=0.2000000
    fWaitBetweenBurstsMin=0.3000000
    MaxCoverBursts=2.0000000
    fMinGrenadeThrowTimeInSec=35.0000000
    fMinFriendlyThrowTimeInSec=6.0000000
    fMaxGrenadeThrowVarianceInSec=35.0000000
    fAggressivenessPct=65.0000000
    fCoverBlownWaitTime=12.0000000
    fOpenCombatHideTime=2.0000000
    bSupportsSuppressingFire=false
    fPeekProbability=30.0000000
    fMinPeekTime=0.8000000
    fMaxPeekTime=1.0000000
    MaxPeeks=1
    fMeleeAggressivenessPct=50.0000000
    fMaxCoverBlownSuppressedTime=1.0000000
    fTakeDamageBurstDelayPenalty=0.5000000
    fCoverHideTransitionSpeedMultiplier=1.1000000
    fCoverAimTransitionSpeedMultiplier=1.2500000
    fCoverBlindFireTransitionSpeedMultiplier=1.2500000
    fPeriodicAdvancedMin=15.0000000
    fPeriodicAdvancedMax=25.0000000
    // Reference: StimulusComponent'Default__MOHAAlliedAIController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAlliedAIController.KynapseEnt0'
    begin object name=KynapseEnt0
        sKynDebugName="AlliedNPC"
    end object
    KynEntityComponent=KynapseEnt0
    TeamIndex=0
    fHearingRadius=1200.0000000
    fMinEngageDist=500.0000000
    fMinEngagePenaltyDist=800.0000000
    fTacaffPresenceMult=3.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAlliedAIController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    SquadClass=Class'MOHAAlliedSquad'
    // Reference: BurstFireManager'Default__MOHAAlliedAIController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAlliedAIController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAlliedAIController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}