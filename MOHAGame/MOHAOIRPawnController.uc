class MOHAOIRPawnController extends MOHAScriptAIController
    config(AI)
    hidecategories(Navigation);

function BURST_TYPE GetMMGBurst()
{
    return GetVeryLongBurst();
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAOIRPawnController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAOIRPawnController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    bDeleteIfSpawnedOutsidePathableSpace=false
    bIgnoreAffordance=true
    // Reference: AxonBrainStateStack'Default__MOHAOIRPawnController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAOIRPawnController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAOIRPawnController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAOIRPawnController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}