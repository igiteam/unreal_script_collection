class MOHAAxisVerySkilledRifleController extends MOHAAxisSkilledRifleController
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

function BURST_TYPE GetMMGBurst()
{
    return GetLongBurst();
    //return ReturnValue;    
}

defaultproperties
{
    fSuppressionThreshhold=7.0000000
    fSuppressionSafe=2.0000000
    fSuppressionDecayRate=5.0000000
    MaxCoverBursts=3.0000000
    fAggressivenessPct=100.0000000
    fCoverBlownWaitTime=7.0000000
    bSupportsSuppressingFire=true
    fPeekProbability=0.0000000
    fMinPeekTime=0.5000000
    fMaxPeekTime=0.8000000
    fAimLagStrengthMMG=25.0000000
    fMaxCoverBlownSuppressedTime=1.0000000
    fTakeDamageBurstDelayPenalty=1.2000000
    fCoverPeekTransitionSpeedMultiplier=1.4000000
    fCoverHideTransitionSpeedMultiplier=1.8000000
    fCoverAimTransitionSpeedMultiplier=2.5000000
    fCoverBlindFireTransitionSpeedMultiplier=2.5000000
    fPeriodicAdvancedMin=10.0000000
    fPeriodicAdvancedMax=15.0000000
    fPeriodicAdvanceMinDistance=700.0000000
    // Reference: StimulusComponent'Default__MOHAAxisVerySkilledRifleController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisVerySkilledRifleController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=1200.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisVerySkilledRifleController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisVerySkilledRifleController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisVerySkilledRifleController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisVerySkilledRifleController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}