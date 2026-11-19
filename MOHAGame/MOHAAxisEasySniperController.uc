class MOHAAxisEasySniperController extends MOHAAxisSniperController
    config(AI)
    hidecategories(Navigation);

defaultproperties
{
    OpenCombatBurst=(iNumShots=3,fMinDelay=0.8500000,fMaxDelay=1.5000000,PauseProbability=(Points=/* Array type was not detected. */),StartingSpreadOffset=175.0000000,ScaleFromRange=2000.0000000)
    fOpenCombatHideTime=6.0000000
    fTakeDamageBurstDelayPenalty=1.8000000
    // Reference: StimulusComponent'Default__MOHAAxisEasySniperController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisEasySniperController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAxisEasySniperController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisEasySniperController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisEasySniperController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisEasySniperController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}