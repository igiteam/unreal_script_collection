class MOHAAxisBaneController extends MOHAAxisAIController
    config(AI)
    hidecategories(Navigation);

var() config BURST_TYPE StationaryBurst;
var() config BURST_TYPE MovingBurst;
var() float fEnemyCloseDist;

function BURST_TYPE GetMMGBurst()
{
    return StationaryBurst;
    //return ReturnValue;    
}

function BURST_TYPE GetWildBurst()
{
    return MovingBurst;
    //return ReturnValue;    
}

function LocalOnBurstDone()
{
    // End:0x23
    if(Pawn != none)
    {
        MOHAAIPawn(Pawn).ResetAimLag();
    }
    //return;    
}

defaultproperties
{
    StationaryBurst=(iNumShots=25,iPreDelayShots=0,fMinDelay=0.0500000,fMaxDelay=0.2000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=250.0000000,BaseConvergeTime=1.2500000,ScaleFromRange=2000.0000000)
    MovingBurst=(iNumShots=50,iPreDelayShots=0,fMinDelay=0.1000000,fMaxDelay=0.2000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=250.0000000,BaseConvergeTime=1.5800000,ScaleFromRange=2000.0000000)
    fMinOpenCombatAimTime=0.1000000
    MaxOpenCombatBursts=3
    fAimLagStrengthMMG=35.0000000
    fTakeDamageBurstDelayPenalty=0.0000000
    bUsesCover=false
    // Reference: StimulusComponent'Default__MOHAAxisBaneController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisBaneController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=2000.0000000
    fMinEngageDist=100.0000000
    fMinEngagePenaltyDist=500.0000000
    fMaxEngagePenaltyDist=3000.0000000
    fMoveSpeed=190.0000000
    fSprintSpeed=225.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisBaneController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisBaneController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisBaneController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisBaneController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}