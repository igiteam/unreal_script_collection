class MOHAAlliedEliteRifleController extends MOHAAlliedEliteAIController
    config(AI)
    hidecategories(Navigation);

function int GetAlertLocalPlayerCost()
{
    return 3;
    //return ReturnValue;    
}

defaultproperties
{
    fBlindFirePercentage=0.0000000
    fSuppressionThreatMultiplier=0.2500000
    MaxCoverBursts=3.0000000
    // Reference: StimulusComponent'Default__MOHAAlliedEliteRifleController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAlliedEliteRifleController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fMinEngageDist=800.0000000
    fMinEngagePenaltyDist=1200.0000000
    fMaxEngagePenaltyDist=3000.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAlliedEliteRifleController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAlliedEliteRifleController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAlliedEliteRifleController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAlliedEliteRifleController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}