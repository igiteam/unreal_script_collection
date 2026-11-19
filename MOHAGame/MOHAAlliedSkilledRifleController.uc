class MOHAAlliedSkilledRifleController extends MOHAAlliedAIController
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
    // Reference: StimulusComponent'Default__MOHAAlliedSkilledRifleController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAlliedSkilledRifleController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fMinEngageDist=800.0000000
    fMinEngagePenaltyDist=1200.0000000
    fMaxEngagePenaltyDist=3000.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAlliedSkilledRifleController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAlliedSkilledRifleController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAlliedSkilledRifleController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAlliedSkilledRifleController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}