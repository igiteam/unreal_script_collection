class MOHAAICoverTestController extends MOHAAlliedAIController
    config(AI)
    hidecategories(Navigation);

function bool ShouldTakeScreenshotsForDebug()
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAAICoverTestController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAICoverTestController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    bIgnoreAffordance=true
    // Reference: AxonBrainStateStack'Default__MOHAAICoverTestController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAICoverTestController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAICoverTestController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAICoverTestController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}