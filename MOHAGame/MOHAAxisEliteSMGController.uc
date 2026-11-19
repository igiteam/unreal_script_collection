class MOHAAxisEliteSMGController extends MOHAAxisVerySkilledSMGController
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
    fSuppressionThreshhold=6.0000000
    fSuppressionDecayRate=5.0000000
    fWaitBetweenBurstsMin=0.1500000
    MaxCoverBursts=5.0000000
    fMinGrenadeThrowTimeInSec=15.0000000
    fAggressivenessPct=100.0000000
    fCoverBlownWaitTime=7.0000000
    UseAlternateCoverProbability=100
    fMaxCoverBlownSuppressedTime=0.5000000
    fTakeDamageBurstDelayPenalty=0.6000000
    fCoverPeekTransitionSpeedMultiplier=1.4000000
    fCoverHideTransitionSpeedMultiplier=1.8000000
    fCoverAimTransitionSpeedMultiplier=2.5000000
    fCoverBlindFireTransitionSpeedMultiplier=2.5000000
    fPeriodicAdvancedMin=10.0000000
    fPeriodicAdvancedMax=15.0000000
    fPeriodicAdvanceMinDistance=700.0000000
    // Reference: StimulusComponent'Default__MOHAAxisEliteSMGController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisEliteSMGController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAxisEliteSMGController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisEliteSMGController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisEliteSMGController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisEliteSMGController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}