class MOHAAxisLRMPanzerschreckController extends MOHAAxisPanzerschreckController
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAAxisLRMPanzerschreckController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisLRMPanzerschreckController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=9000.0000000
    fMinEngageDist=1000.0000000
    fMinEngagePenaltyDist=1500.0000000
    fMaxEngageDist=10000.0000000
    fMaxEngagePenaltyDist=9000.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisLRMPanzerschreckController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisLRMPanzerschreckController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisLRMPanzerschreckController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisLRMPanzerschreckController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}