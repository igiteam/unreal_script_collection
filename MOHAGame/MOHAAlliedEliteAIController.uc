class MOHAAlliedEliteAIController extends MOHAAlliedAIController
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
    fSuppressionDecayRate=4.0000000
    fWaitBetweenBurstsMax=0.1000000
    fWaitBetweenBurstsMin=0.1500000
    MaxCoverBursts=4.0000000
    fAggressivenessPct=100.0000000
    fEncroachedDistanceMax=1200.0000000
    fPeekProbability=0.0000000
    UseAlternateCoverProbability=100
    MaxPeeks=0
    fMeleeAggressivenessPct=60.0000000
    fAimLagStrengthMMG=25.0000000
    fMaxCoverBlownSuppressedTime=0.5000000
    fCoverPeekTransitionSpeedMultiplier=1.4000000
    fCoverHideTransitionSpeedMultiplier=1.6000000
    fCoverAimTransitionSpeedMultiplier=2.0000000
    fCoverBlindFireTransitionSpeedMultiplier=2.0000000
    fPeriodicAdvancedMin=12.0000000
    fPeriodicAdvancedMax=20.0000000
    // Reference: StimulusComponent'Default__MOHAAlliedEliteAIController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAlliedEliteAIController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAlliedEliteAIController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAlliedEliteAIController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAlliedEliteAIController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAlliedEliteAIController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}