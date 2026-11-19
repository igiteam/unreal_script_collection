class MOHAAxisSkilledSMGControllerNoGrenade extends MOHAAxisSkilledSMGController
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    bThrowsGrenades=false
    // Reference: StimulusComponent'Default__MOHAAxisSkilledSMGControllerNoGrenade.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisSkilledSMGControllerNoGrenade.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAxisSkilledSMGControllerNoGrenade.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisSkilledSMGControllerNoGrenade.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisSkilledSMGControllerNoGrenade.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisSkilledSMGControllerNoGrenade.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}