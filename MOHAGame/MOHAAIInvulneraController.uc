class MOHAAIInvulneraController extends MOHAAIController
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAAIInvulneraController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAIInvulneraController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAIInvulneraController.ABSS1'
    begin object name=ABSS1 class=Class'EAKynapse.AxonBrainStateStack'
    end object
    ABSS=ABSS1
    // Reference: BurstFireManager'Default__MOHAAIInvulneraController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAIInvulneraController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAIInvulneraController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}