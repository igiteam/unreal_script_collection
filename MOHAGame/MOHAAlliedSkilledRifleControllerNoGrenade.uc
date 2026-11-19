class MOHAAlliedSkilledRifleControllerNoGrenade extends MOHAAlliedSkilledRifleController
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    bThrowsGrenades=false
    // Reference: StimulusComponent'Default__MOHAAlliedSkilledRifleControllerNoGrenade.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAlliedSkilledRifleControllerNoGrenade.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAlliedSkilledRifleControllerNoGrenade.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAlliedSkilledRifleControllerNoGrenade.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAlliedSkilledRifleControllerNoGrenade.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAlliedSkilledRifleControllerNoGrenade.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}