class MOHAAxisEasySMGController extends MOHAAxisAIController
    config(AI)
    hidecategories(Navigation);

var config BURST_TYPE OpenCombatBurst;

function BURST_TYPE GetCoverFireBurst()
{
    return GetVeryLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetCoverBlownBurst()
{
    return GetVeryLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetOpenCombatBurst()
{
    return OpenCombatBurst;
    //return ReturnValue;    
}

function BURST_TYPE GetMMGBurst()
{
    return GetVeryLongBurst();
    //return ReturnValue;    
}

defaultproperties
{
    OpenCombatBurst=(iNumShots=5,iPreDelayShots=0,fMinDelay=0.0000000,fMaxDelay=0.0000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=200.0000000,BaseConvergeTime=1.0000000,ScaleFromRange=3000.0000000)
    fBlindFirePercentage=0.0000000
    fSuppressionSafe=4.0000000
    fAggressivenessPct=30.0000000
    fCoverBlownWaitTime=10.0000000
    bSupportsSuppressingFire=false
    bThrowsGrenades=false
    fPeekProbability=90.0000000
    UseAlternateCoverProbability=0
    MinPeeks=1
    // Reference: StimulusComponent'Default__MOHAAxisEasySMGController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisEasySMGController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fMinEngageDist=500.0000000
    fMinEngagePenaltyDist=1000.0000000
    fMaxEngagePenaltyDist=1500.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisEasySMGController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisEasySMGController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisEasySMGController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisEasySMGController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}