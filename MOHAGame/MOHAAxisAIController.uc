class MOHAAxisAIController extends MOHAScriptAIController
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAAxisAIController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisAIController.KynapseEnt0'
    begin object name=KynapseEnt0
        sKynDebugName="AxisNPC"
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAxisAIController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    SquadClass=Class'MOHAAxisSquad'
    // Reference: BurstFireManager'Default__MOHAAxisAIController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisAIController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisAIController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}