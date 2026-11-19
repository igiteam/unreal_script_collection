class MOHAAxisVerySkilledSMGController extends MOHAAxisSkilledSMGController
    config(AI)
    hidecategories(Navigation);

function BURST_TYPE GetCoverFireBurst()
{
    return GetShortBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetCoverBlownBurst()
{
    return GetShortBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetOpenCombatBurst()
{
    return GetShortBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetMMGBurst()
{
    return GetLongBurst();
    //return ReturnValue;    
}

defaultproperties
{
    fBlindFirePercentage=75.0000000
    fBlindGrenadePercentage=75.0000000
    fSuppressionThreshhold=7.0000000
    fSuppressionDecayRate=4.0000000
    fWaitBetweenBurstsMax=0.1000000
    fWaitBetweenBurstsMin=0.2000000
    MaxCoverBursts=4.0000000
    fMinGrenadeThrowTimeInSec=25.0000000
    fAggressivenessPct=80.0000000
    fCoverBlownWaitTime=8.0000000
    fEncroachedDistanceMax=1200.0000000
    bSupportsSuppressingFire=true
    fPeekProbability=0.0000000
    UseAlternateCoverProbability=75
    MaxPeeks=0
    fMeleeAggressivenessPct=60.0000000
    fAimLagStrengthMMG=25.0000000
    fMaxCoverBlownSuppressedTime=1.0000000
    fTakeDamageBurstDelayPenalty=1.2000000
    fCoverPeekTransitionSpeedMultiplier=1.2500000
    fCoverHideTransitionSpeedMultiplier=1.3000000
    fCoverAimTransitionSpeedMultiplier=1.6600000
    fCoverBlindFireTransitionSpeedMultiplier=1.6600000
    fPeriodicAdvancedMin=15.0000000
    fPeriodicAdvancedMax=25.0000000
    // Reference: StimulusComponent'Default__MOHAAxisVerySkilledSMGController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisVerySkilledSMGController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=1200.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisVerySkilledSMGController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisVerySkilledSMGController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisVerySkilledSMGController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisVerySkilledSMGController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}