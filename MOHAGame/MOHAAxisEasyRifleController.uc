class MOHAAxisEasyRifleController extends MOHAAxisAIController
    config(AI)
    hidecategories(Navigation);

var config BURST_TYPE OpenCombatBurst;

function BURST_TYPE GetCoverFireBurst()
{
    return GetShortBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetCoverBlownBurst()
{
    return GetShortBurst();
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

function int GetAlertLocalPlayerCost()
{
    return 5;
    //return ReturnValue;    
}

defaultproperties
{
    OpenCombatBurst=(iNumShots=1,iPreDelayShots=0,fMinDelay=0.0000000,fMaxDelay=0.0000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=200.0000000,BaseConvergeTime=2.0000000,ScaleFromRange=2000.0000000)
    fBlindFirePercentage=0.0000000
    fSuppressionSafe=4.0000000
    fCoverBlownWaitTime=9.0000000
    fEnemyIsCloseDistance=1200.0000000
    bSupportsSuppressingFire=false
    bThrowsGrenades=false
    fPeekProbability=90.0000000
    UseAlternateCoverProbability=0
    MinPeeks=1
    fMeleeAggressivenessPct=40.0000000
    // Reference: StimulusComponent'Default__MOHAAxisEasyRifleController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisEasyRifleController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fMinEngageDist=500.0000000
    fMinEngagePenaltyDist=3000.0000000
    fMaxEngageDist=5500.0000000
    fMaxEngagePenaltyDist=3500.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisEasyRifleController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisEasyRifleController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisEasyRifleController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisEasyRifleController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}