class MOHAAxisSkilledSMGController extends MOHAAxisEasySMGController
    config(AI)
    hidecategories(Navigation);

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
    return GetVeryLongBurst();
    //return ReturnValue;    
}

defaultproperties
{
    fBlindFirePercentage=50.0000000
    fBlindGrenadePercentage=30.0000000
    fSuppressionSafe=3.0000000
    fSuppressionDecayRate=3.0000000
    fWaitBetweenBurstsMax=0.2000000
    fWaitBetweenBurstsMin=0.3000000
    MaxCoverBursts=2.0000000
    fMaxGrenadeThrowVarianceInSec=15.0000000
    fAggressivenessPct=65.0000000
    fCoverBlownWaitTime=9.0000000
    bThrowsGrenades=true
    fPeekProbability=30.0000000
    fMinPeekTime=0.8000000
    fMaxPeekTime=1.0000000
    MinPeeks=0
    MaxPeeks=1
    fMeleeAggressivenessPct=50.0000000
    fMaxCoverBlownSuppressedTime=1.5000000
    fTakeDamageBurstDelayPenalty=1.5000000
    fCoverHideTransitionSpeedMultiplier=1.1000000
    fCoverAimTransitionSpeedMultiplier=1.2500000
    fCoverBlindFireTransitionSpeedMultiplier=1.2500000
    // Reference: StimulusComponent'Default__MOHAAxisSkilledSMGController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisSkilledSMGController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=750.0000000
    fMinEngageDist=100.0000000
    fMinEngagePenaltyDist=500.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisSkilledSMGController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisSkilledSMGController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisSkilledSMGController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisSkilledSMGController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}