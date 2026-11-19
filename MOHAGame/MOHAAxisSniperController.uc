class MOHAAxisSniperController extends MOHAAxisAIController
    config(AI)
    hidecategories(Navigation);

var() config BURST_TYPE OpenCombatBurst;
var() config BURST_TYPE CloseOpenCombatBurst;
var() config float fEnemyCloseDist;

function BURST_TYPE GetOpenCombatBurst()
{
    // End:0x16
    if(IsEnemyClose())
    {
        return CloseOpenCombatBurst;        
    }
    else
    {
        return OpenCombatBurst;
    }
    //return ReturnValue;    
}

function float GetMinOpenCombatAimTime()
{
    local MOHAAIPawn NPCPawn;

    NPCPawn = MOHAAIPawn(Pawn);
    // End:0x52
    if((NPCPawn != none) && NPCPawn.CurrentWeaponAttachment != none)
    {
        SmallArmsAttachment(NPCPawn.CurrentWeaponAttachment).StartScopeGlint();
    }
    // End:0x65
    if(IsEnemyClose())
    {
        return 0.5000000;
    }
    return super(MOHAScriptAIController).GetMinOpenCombatAimTime();
    //return ReturnValue;    
}

function bool IsEnemyClose()
{
    local Vector vEnemyPos;

    // End:0x27
    if((Focus == none) && VSizeSq(FocalPoint) < 0.0500000)
    {
        return false;        
    }
    else
    {
        // End:0x49
        if(Focus != none)
        {
            vEnemyPos = Focus.Location;            
        }
        else
        {
            vEnemyPos = FocalPoint;
        }
    }
    // End:0x82
    if(VSizeSq(vEnemyPos - Pawn.Location) > (fEnemyCloseDist * fEnemyCloseDist))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
    local MOHAAIPawn NPCPawn;

    super(MOHAAIController).NotifyWeaponFinishedFiring(W, FireMode);
    NPCPawn = MOHAAIPawn(Pawn);
    // End:0x62
    if((NPCPawn != none) && NPCPawn.CurrentWeaponAttachment != none)
    {
        SmallArmsAttachment(NPCPawn.CurrentWeaponAttachment).StopScopeGlint();
    }
    //return;    
}

function bool IsSniperController()
{
    return true;
    //return ReturnValue;    
}

function int GetAlertLocalPlayerCost()
{
    return 5;
    //return ReturnValue;    
}

defaultproperties
{
    OpenCombatBurst=(iNumShots=1,iPreDelayShots=0,fMinDelay=0.7500000,fMaxDelay=1.0000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=0.0000000,BaseConvergeTime=0.4000000,ScaleFromRange=10000.0000000)
    CloseOpenCombatBurst=(iNumShots=3,iPreDelayShots=0,fMinDelay=0.1000000,fMaxDelay=0.5000000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=175.0000000,BaseConvergeTime=1.5000000,ScaleFromRange=2000.0000000)
    fEnemyCloseDist=1000.0000000
    fAggressivenessPct=30.0000000
    fMinOpenCombatAimTime=1.0000000
    fOpenCombatHideTime=3.0000000
    bThrowsGrenades=false
    fTakeDamageBurstDelayPenalty=1.2000000
    bUsesCover=false
    // Reference: StimulusComponent'Default__MOHAAxisSniperController.Stimulus0'
    begin object name=Stimulus0
    end object
    Stimulus=Stimulus0
    // Reference: KynapseEntityComponent'Default__MOHAAxisSniperController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    fHearingRadius=10000.0000000
    fMinEngageDist=1000.0000000
    fMinEngagePenaltyDist=1500.0000000
    fMaxEngageDist=6500.0000000
    fMaxEngagePenaltyDist=4500.0000000
    // Reference: AxonBrainStateStack'Default__MOHAAxisSniperController.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    // Reference: BurstFireManager'Default__MOHAAxisSniperController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAxisSniperController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    // Reference: SpriteComponent'Default__MOHAAxisSniperController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
}