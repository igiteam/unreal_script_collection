class MOHAAxisPanzerschreckController extends MOHAAxisAIController
    config(AI)
    hidecategories(Navigation);

var() config BURST_TYPE OpenCombatBurst;

function BURST_TYPE GetOpenCombatBurst()
{
    return OpenCombatBurst;
    //return ReturnValue;    
}

function BURST_TYPE GetCoverFireBurst()
{
    return OpenCombatBurst;
    //return ReturnValue;    
}

defaultproperties
{
    OpenCombatBurst=(iNumShots=1,iPreDelayShots=0,fMinDelay=0.0000000,fMaxDelay=0.0000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=75.0000000,BaseConvergeTime=2.0000000,ScaleFromRange=2000.0000000)
    fAggressivenessPct=30.0000000
    fMinOpenCombatAimTime=0.7500000
    bThrowsGrenades=false
    MaxOpenCombatBursts=3
    fTakeDamageBurstDelayPenalty=0.0000000
    iPostGrenadeFleeBursts=1
    bUsesCover=false
    // Reference: StimulusComponent'Default__MOHAAxisPanzerschreckController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisPanzerschreckController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=1000.0000000
    fMinEngageDist=500.0000000
    fMinEngagePenaltyDist=1000.0000000
    fMaxEngagePenaltyDist=3500.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisPanzerschreckController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisPanzerschreckController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisPanzerschreckController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisPanzerschreckController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}