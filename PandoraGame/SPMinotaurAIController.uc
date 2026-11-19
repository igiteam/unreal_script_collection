class SPMinotaurAIController extends SPBaseWerewolfAIController
    native;

struct native SPMinotaurBullCharge
{
    var float m_damage;
    var float m_pushBackSpeed;
    var class<DamageType> m_damageType;
    var float m_supressionProbability;
    var SPAIController.EMoveGoalType m_moveType;
    var Vector m_moveOffset;
    var bool m_directlyReachable;
    var bool m_bumpedSomething;
    var bool m_bumpedImmovable;
    var SPBullChargeVolume m_chargeVolume;
    var SPBullChargeVolumeProperties m_chargeVolumeProperties;
    var Vector m_targetPos;
    var Vector m_lastEnemyPos;
    var Actor m_targetActor;
    var Vector m_targetPlaneNormal;
    var Pawn m_bumpedPawn;
    var float m_chargeSpeed;
    var float m_commitTime;
    var float m_minCommitTime;
    var float m_maxCommitTime;
    var float m_distToTravelBeforeStopping;
    var float m_distToTravelAfterMiss;
    var float m_minDist;
    var float m_maxDist;
    var float m_lastTime;
    var float m_nextTime;
    var float m_minTimeBetweenCharges;
    var bool m_commited;
    var name m_chargeMoveState;

    structdefaultproperties
    {
        m_damage=20.0000000
        m_pushBackSpeed=1200.0000000
        m_damageType=Class'SPDamageTypeMinotaurHit'
        m_supressionProbability=0.1000000
        m_moveType=emgtToActor
        m_moveOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_directlyReachable=false
        m_bumpedSomething=false
        m_bumpedImmovable=false
        m_chargeVolume=none
        m_chargeVolumeProperties=(m_damage=20.0000000,m_damageType=Class'SPDamageTypeMinotaurHit',m_zoneVelocity=1200.0000000,m_targetVelocity=1000.0000000,m_chargeOffset=50.0000000,m_radius=250.0000000,m_height=300.0000000,m_showDebug=false,m_screenScratch=(materialName=none,scratchSound=none,SocketName="None",xOffset=0,yOffset=0,Duration=0.0000000,FadeTime=0.0000000,DamageType=edvtSwipe,facingDamageDir=eddtNone,ScreenShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None"),HitDOFEffectName="None",HitMaterialEffectName="None",HitEffectFadeTime=0.0000000,HitEffectMaterialInstance=none,HitMaterialEffect=none,HitDOFEffect=none,bValid=false))
        m_targetPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_lastEnemyPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_targetActor=none
        m_targetPlaneNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bumpedPawn=none
        m_chargeSpeed=0.0000000
        m_commitTime=0.7500000
        m_minCommitTime=0.0000000
        m_maxCommitTime=0.0000000
        m_distToTravelBeforeStopping=100.0000000
        m_distToTravelAfterMiss=100.0000000
        m_minDist=1000.0000000
        m_maxDist=10000.0000000
        m_lastTime=0.0000000
        m_nextTime=0.0000000
        m_minTimeBetweenCharges=2.0000000
        m_commited=false
        m_chargeMoveState="None"
    }
};

var SPMinotaurBullCharge m_charge;
var float m_destructibleDetectedTime;
var float m_destructibleNextDetectTime;
var bool m_shouldStopToSmash;
var float m_concentratedBackDamageStaggerStartTime;
var SPGameDifficultyTuneMinotaur m_MinotaurGDTuneData;

// Export USPMinotaurAIController::execCanDirectlyChargeEnemy(FFrame&, void* const)
native final function bool CanDirectlyChargeEnemy();

final function SetupPoseChangeForDestructibleSmash(Actor obstacle)
{
    local Vector objectCenter;
    local float verticalDelta;

    objectCenter = obstacle.CollisionComponent.Bounds.Origin;
    verticalDelta = Pawn.Location.Z - (objectCenter.Z + obstacle.CollisionComponent.Bounds.BoxExtent.Z);
    // End:0xB9
    if(verticalDelta > (Pawn.CylinderComponent.CollisionHeight * 0.5000000))
    {
        return;
    }
    m_destructibleDetectedTime = AITime + float(1);
    //return;    
}

final function bool HeadDownToBustThroughDestructible()
{
    // End:0x14
    if(m_destructibleDetectedTime > AITime)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool UseWalk()
{
    return false;
    //return ReturnValue;    
}

final function bool UseWalkDuringMelee()
{
    local SPBaseWerewolfPawnPersistent.eWerewolfAttackRange attackRange;

    // End:0x14
    if(!HasValidEnemy(,,, true))
    {
        return false;
    }
    attackRange = m_WerewolfPawn.GetActorAttackRange(GetEnemy());
    // End:0x4A
    if(int(attackRange) <= int(1))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.MinotaurGD;
    //return ReturnValue;    
}

function InitFromTuneData()
{
    local SPMinotaurPawnPersistent myPawn;
    local float distToTravelBeforeStopping, distToTravelAfterMiss;

    super.InitFromTuneData();
    m_MinotaurGDTuneData = SPGameDifficultyTuneMinotaur(GetMyGDData());
    distToTravelBeforeStopping = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurChargeDistanceToMoveAfterMiss) * 0.5000000;
    distToTravelAfterMiss = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurChargeDistanceToMoveAfterMiss) * 0.5000000;
    m_charge.m_minDist = m_MinotaurGDTuneData.minotaurChargeMinDist;
    m_charge.m_maxDist = m_MinotaurGDTuneData.minotaurChargeMaxDist;
    m_charge.m_minCommitTime = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurChargeMinDodgeTime);
    m_charge.m_maxCommitTime = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurChargeMaxDodgeTime);
    m_charge.m_damage = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurChargeDamageDone);
    m_charge.m_pushBackSpeed = m_MinotaurGDTuneData.minotaurChargePlayerPushBackSpeed;
    m_charge.m_distToTravelBeforeStopping = distToTravelBeforeStopping;
    m_charge.m_distToTravelAfterMiss = distToTravelAfterMiss;
    myPawn = SPMinotaurPawnPersistent(Pawn);
    myPawn.FrontDamageMultiplier = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurFrontDamageMultiplier);
    myPawn.BackDamageMultiplier = m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.minotaurBackDamageMultiplier);
    myPawn.NoBipedalRageIndex = int(m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.goQuadrapedRageIndex));
    myPawn.chargeImpactEffect = m_MinotaurGDTuneData.minotaurChargeHitEffect;
    // End:0x292
    if(m_charge.m_minDist > m_charge.m_maxDist)
    {
    }
    // End:0x2B7
    if(m_charge.m_minCommitTime > m_charge.m_maxCommitTime)
    {
    }
    //return;    
}

final function bool HasClub()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    return myPawn.HasClub();
    //return ReturnValue;    
}

final function bool ThrowClubFinished()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    return myPawn.ThrowClubFinished();
    //return ReturnValue;    
}

private final function bool ShouldIBeEatingFood()
{
    return false;
    //return ReturnValue;    
}

final function int GetCurrentRageLevelIndex()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    return myPawn.super(SPMinotaurAIController).GetCurrentRageLevelIndex();
    //return ReturnValue;    
}

function StanceUpdate()
{
    local int rageIndex;

    rageIndex = GetCurrentRageLevelIndex();
    // End:0x40
    if(m_WerewolfPawn.HasConcentratedArmDamage() || HasConcentratedHeadDamage())
    {
        m_WerewolfPawn.SetStance(1);        
    }
    else
    {
        // End:0xA0
        if(((float(rageIndex) >= m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.goQuadrapedRageIndex)) && HasClub() == false) && !bOnlyAllowMeleeAttacks)
        {
            m_WerewolfPawn.SetStance(0);            
        }
        else
        {
            m_WerewolfPawn.SetStance(1);
        }
    }
    //return;    
}

function bool CheckEarlyOutOptionsForAnimusPulse()
{
    return !IsCharging();
    //return ReturnValue;    
}

function int GetConcentratedDamage(name damageGroupName, class<DamageType> DamageType, Vector Momentum, float DamageAmount, out float damagePercentOut, out int gdDataIndex)
{
    local int Index;

    Index = super.GetConcentratedDamage(damageGroupName, DamageType, Momentum, DamageAmount, damagePercentOut, gdDataIndex);
    return Index;
    //return ReturnValue;    
}

function ConcentratedBackDamage(int concentratedIndex, int gdDataIndex, Vector Momentum, class<DamageType> DamageType)
{
    // End:0x3F
    if((IsAnyConcentratedReactionActive() || int(Pawn.Physics) == int(8)) || m_WerewolfPawn.IsBiped() == false)
    {
        return;
    }
    // End:0xD0
    if(((((int(m_WerewolfPawn.GetActionState()) != int(1)) && int(m_WerewolfPawn.GetActionState()) != int(2)) && int(m_WerewolfPawn.GetActionState()) != int(65)) && int(m_WerewolfPawn.GetActionState()) != int(17)) && int(m_WerewolfPawn.GetActionState()) != int(0))
    {
        return;
    }
    // End:0xF4
    if((Momentum Dot Vector(Pawn.Rotation)) < 0.0000000)
    {
        return;
    }
    // End:0x111
    if(int(m_WerewolfPawn.GetAnimMeleeDodgeState()) != int(0))
    {
        return;
    }
    m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bIsActive = true;
    m_WerewolfPawn.concentratedTorsoDamageType = DamageType;
    m_concentratedBackDamageStaggerStartTime = WorldInfo.TimeSeconds;
    ClearTimer('StaggerForwardFinished');
    StartAction(28);
    //return;    
}

final function StaggerForwardFinished()
{
    // End:0x30
    if(int(m_WerewolfPawn.GetActionState()) == int(27))
    {
        m_WerewolfPawn.ClearAction();
    }
    ClearTimer('StaggerForwardFinished');
    m_WerewolfPawn.m_rtConcentratedDamageInfo[5].bIsActive = false;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[5].LastActiveTime = WorldInfo.TimeSeconds;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[5].timeOutInterval = 5.0000000;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[5].concentratedDamagePercent = 0.0000000;
    //return;    
}

function bool HasConcentratedBackDamage(optional bool bDontCheckNonMMGun, optional bool bDontCheckMMGun)
{
    return !bDontCheckNonMMGun && m_WerewolfPawn.m_rtConcentratedDamageInfo[5].bIsActive;
    //return ReturnValue;    
}

final function float GetChargeSpeed()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    return myPawn.GetChargeSpeed();
    //return ReturnValue;    
}

final function Vector DirectMoveVelocity()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    return myPawn.DirectMoveVelocity();
    //return ReturnValue;    
}

final function ChargeInit()
{
    m_charge.m_directlyReachable = false;
    m_charge.m_bumpedSomething = false;
    m_charge.m_bumpedImmovable = false;
    m_charge.m_targetActor = none;
    m_charge.m_commited = false;
    m_charge.m_chargeSpeed = GetChargeSpeed();
    //return;    
}

function HandleVolumeTouch(Actor Other, Vector HitNormal)
{
    //return;    
}

function bool CouldIHitAndRun(Actor hitAndRunTarget)
{
    return false;
    //return ReturnValue;    
}

function name SelectAttackState()
{
    local int CurLevel;
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    CurLevel = m_WerewolfPawn.GetCurrentRageLevelIndex();
    // End:0xCB
    if((m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.dropClubAtRageIndex) <= float(CurLevel)) || m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.goQuadrapedRageIndex) <= float(CurLevel))
    {
        // End:0xC1
        if(myPawn.HasClub() && !bOnlyAllowMeleeAttacks)
        {
            CancelAction();
            return 'throwClub';            
        }
        else
        {
            return super.SelectAttackState();
        }        
    }
    else
    {
        return super.SelectAttackState();
    }
    //return ReturnValue;    
}

event bool IsSuppressionValid(SPPawn Originator, const out Vector Origin, const out Vector End)
{
    return false;
    //return ReturnValue;    
}

function CancelAction()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    myPawn.CancelAction();
    m_WerewolfPawn.ClearAction();
    //return;    
}

function HitByAnimusPulse()
{
    //return;    
}

final function DisableChargeForTime(float Time)
{
    m_charge.m_nextTime = WorldInfo.TimeSeconds + Time;
    //return;    
}

final function CancelDisableChargeForTime()
{
    m_charge.m_nextTime = 0.0000000;
    //return;    
}

final function bool ChargedRecently()
{
    local bool ChargedRecently;

    ChargedRecently = WorldInfo.TimeSeconds < m_charge.m_nextTime;
    return ChargedRecently;
    //return ReturnValue;    
}

final function bool DoIFeelLikeCharging()
{
    local int dice, CurLevel;

    // End:0x0B
    if(bOnlyAllowMeleeAttacks)
    {
        return false;
    }
    CurLevel = m_WerewolfPawn.GetCurrentRageLevelIndex();
    dice = Rand(int((m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.RageDataParams[CurLevel].MeleeAttack.BiteAttack) + m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.RageDataParams[CurLevel].MeleeAttack.SwipeAttack)) + m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.RageDataParams[CurLevel].MeleeAttack.BullCharge)));
    // End:0x13C
    if(float(dice) < m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.RageDataParams[CurLevel].MeleeAttack.BullCharge))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

final function bool IsEnemyInChargeAttackRange()
{
    local float distSQ;

    // End:0x14
    if(!HasValidEnemy(,,, true))
    {
        return false;
    }
    distSQ = VSizeSq(GetEnemy().Location - Pawn.Location);
    // End:0x73
    if(distSQ < (m_charge.m_minDist * m_charge.m_minDist))
    {
        return false;
    }
    // End:0xA1
    if(distSQ > (m_charge.m_maxDist * m_charge.m_maxDist))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final function bool CanIChargeEnemy()
{
    // End:0x0B
    if(bOnlyAllowMeleeAttacks)
    {
        return false;
    }
    // End:0x1F
    if(!HasValidEnemy(,,, true))
    {
        return false;
    }
    // End:0x2A
    if(HasClub())
    {
        return false;
    }
    // End:0x37
    if(!IsEnemyInChargeAttackRange())
    {
        return false;
    }
    // End:0x44
    if(!KyIsEnemyReachable())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CanSelectMeleeChargeAction()
{
    // End:0x0B
    if(bOnlyAllowMeleeAttacks)
    {
        return false;
    }
    // End:0x22
    if(Pawn.Health <= 0)
    {
        return false;
    }
    // End:0x2D
    if(ChargedRecently())
    {
        return false;
    }
    // End:0x3A
    if(!DoIFeelLikeCharging())
    {
        return false;
    }
    // End:0x47
    if(!CanIChargeEnemy())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function StartMeleeCharge()
{
    GotoState('Charge');
    //return;    
}

function bool SmashAnObstacle(Actor obstacle, float impulseApplied)
{
    local editinline SPActorDestructComponent destruct;
    local int damageAmt;
    local SPMinotaurPawnPersistent myPawn;
    local Vector Impulse;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    Impulse.X = impulseApplied;
    Impulse.Y = 0.0000000;
    Impulse.Z = 0.0000000;
    Impulse = Impulse >> Pawn.Rotation;
    obstacle.CollisionComponent.AddImpulse(Impulse,,,, GetSmashMinDamage(), GetSmashMaxDamage(), Pawn);
    destruct = SPActorDestructComponent(obstacle.GetActorDestructComponent());
    // End:0xF1
    if(destruct != none)
    {
        damageAmt = destruct.GetHitPoints() + 10;        
    }
    else
    {
        damageAmt = int(m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.SmashDamage));
    }
    obstacle.TakeDamageAndProcEffects(float(damageAmt), self, obstacle.Location, Impulse, myPawn.GetSmashDamageType(),, Pawn);
    return true;
    //return ReturnValue;    
}

final function PlayChargeImpactEffect()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    myPawn.PlayChargeImpactEffect(Pawn.Location);
    //return;    
}

function bool DealWithSmashObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x23
    if(m_shouldStopToSmash)
    {
        return super.DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);        
    }
    else
    {
        PlayChargeImpactEffect();
        SetupPoseChangeForDestructibleSmash(obstacle);
        SmashAnObstacle(obstacle, 250.0000000);
    }
    return true;
    //return ReturnValue;    
}

final function EndDirectMove()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    myPawn.EndDirectMove();
    //return;    
}

final function StartDirectMove()
{
    local SPMinotaurPawnPersistent myPawn;

    myPawn = SPMinotaurPawnPersistent(Pawn);
    myPawn.StartDirectMove();
    //return;    
}

function ChaseTimeOut()
{
    //return;    
}

function NotifyDying()
{
    m_charge.m_chargeVolume.Destroy();
    super.NotifyDying();
    //return;    
}

state MinotaurMoveToGoal extends WerewolfMoveToGoal
{    stop;    
}

state Charge
{
    function BeginState(name PreviousStateName)
    {
        OnStateEnter();
        //return;        
    }

    function EndState(name NextStateName)
    {
        OnStateExit();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        //return;        
    }

    function OnStateEnter()
    {
        m_charge.m_commitTime = RandRange(m_charge.m_minCommitTime, m_charge.m_maxCommitTime);
        //return;        
    }

    function OnStateExit()
    {
        CancelAction();
        ClearTimer('ChargeUpdateTimer');
        DisableChargeForTime(RandRange(5.0000000, 8.0000000));
        SetPawnRotationRate(3072, 4096, 80000);
        //return;        
    }

    function bool UpdateFocus()
    {
        FocalPoint = GetEnemy().Location;
        return true;
        //return ReturnValue;        
    }

    function ContinuedState()
    {
        //return;        
    }

    function SetSuppressionConstraints()
    {
        super(SPBaseWerewolfAIController).SetSuppressionConstraints();
        // End:0x41
        if(RandRange(0.0000000, 1.0000000) <= m_charge.m_supressionProbability)
        {
            m_SuppressionConstraints.ShouldTest = true;            
        }
        else
        {
            m_SuppressionConstraints.ShouldTest = false;
        }
        //return;        
    }

    function CheckForAbort()
    {
        // End:0x15
        if(!CanIChargeEnemy())
        {
            AbortCharge();
        }
        //return;        
    }

    function DoChargeMoveToPoint()
    {
        SetMoveGoal(m_charge.m_targetActor, 1, m_charge.m_moveOffset, m_charge.m_moveType, false, m_charge.m_directlyReachable);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState(m_charge.m_chargeMoveState);
        //return;        
    }

    function GetReadyToCharge()
    {
        local SPMinotaurPawnPersistent myPawn;

        m_WerewolfPawn.ClearAction();
        ChargeInit();
        StopDodgeRun();
        m_WerewolfPawn.SetStance(0);
        StartAction(62);
        myPawn = SPMinotaurPawnPersistent(Pawn);
        myPawn.PrepareCharge();
        //return;        
    }

    function AbortCharge()
    {
        EvaluateSituation();
        //return;        
    }

    final function bool IsReadyToCharge()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        return myPawn.IsDoneThreatning();
        //return ReturnValue;        
    }

    final function StartAttackRun()
    {
        DisableChargeForTime(RandRange(5.0000000, 8.0000000));
        m_charge.m_chargeMoveState = 'ChargeChaseEnemy';
        m_charge.m_targetActor = GetEnemy();
        m_charge.m_moveOffset.X = 0.0000000;
        m_charge.m_moveOffset.Y = 0.0000000;
        m_charge.m_moveOffset.Z = 0.0000000;
        m_charge.m_moveType = 0;
        m_charge.m_directlyReachable = false;
        DoChargeMoveToPoint();
        //return;        
    }

    function CommitToCharge()
    {
        local Vector Direction;
        local Pawn pEnemyPawn;

        // End:0x139
        if(m_charge.m_commited)
        {
            pEnemyPawn = GetEnemy();
            Direction = Normal(pEnemyPawn.Location - Pawn.Location);
            m_charge.m_chargeMoveState = 'ChargeCommited';
            m_charge.m_lastEnemyPos = pEnemyPawn.Location;
            m_charge.m_targetPos = pEnemyPawn.Location + (Direction * float(100));
            m_charge.m_moveOffset = m_charge.m_targetPos;
            m_charge.m_moveType = 2;
            m_charge.m_directlyReachable = true;
            m_charge.m_targetActor = none;
            FocalPoint = m_charge.m_moveOffset;
            PushState(m_charge.m_chargeMoveState);
        }
        //return;        
    }
Begin:

    CheckForAbort();
    GetReadyToCharge();
    J0x14:

    // End:0x34 [Loop If]
    if(!IsReadyToCharge())
    {
        CheckForAbort();
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0x14;
    }
    StartAttackRun();
    CommitToCharge();
    Sleep(0.0500000);
    EvaluateSituation();
    stop;        
}

state ChargeMoveToGoal extends WerewolfMoveToGoal
{
    function SetTimers()
    {
        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        //return;        
    }

    function PushedState()
    {
        OnStateEnter();
        super.PushedState();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        super.PoppedState();
        //return;        
    }

    function OnStateEnter()
    {
        SetTimers();
        SetPawnRotationRate(3072, 4096, 32768);
        AddBuffetVolume();
        //return;        
    }

    function OnStateExit()
    {
        SetPawnRotationRate(3072, 4096, 80000);
        RemoveBuffetVolume();
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    function InitStanceForMovment()
    {
        m_WerewolfPawn.SetStance(0);
        //return;        
    }

    function AddBuffetVolume()
    {
        local SPMinotaurPawnPersistent minoPawn;

        minoPawn = SPMinotaurPawnPersistent(Pawn);
        m_charge.m_chargeVolumeProperties.m_damage = m_charge.m_damage;
        m_charge.m_chargeVolumeProperties.m_damageType = Class'SPDamageTypeMinotaurHit';
        m_charge.m_chargeVolumeProperties.m_zoneVelocity = 200.0000000;
        m_charge.m_chargeVolumeProperties.m_targetVelocity = m_charge.m_pushBackSpeed;
        m_charge.m_chargeVolumeProperties.m_height = 85.0000000;
        m_charge.m_chargeVolumeProperties.m_radius = 75.0000000;
        m_charge.m_chargeVolumeProperties.m_chargeOffset = 200.0000000;
        m_charge.m_chargeVolumeProperties.m_showDebug = false;
        // End:0x164
        if(minoPawn != none)
        {
            m_charge.m_chargeVolumeProperties.m_screenScratch = minoPawn.m_screenScratch;            
        }
        else
        {
            m_charge.m_chargeVolumeProperties.m_screenScratch.bValid = false;
        }
        // End:0x1E0
        if(m_charge.m_chargeVolume == none)
        {
            m_charge.m_chargeVolume = Class'SPBullChargeVolume'.static.CreateVolume(m_charge.m_chargeVolumeProperties, Pawn);            
        }
        else
        {
            m_charge.m_chargeVolume.Setup(m_charge.m_chargeVolumeProperties, Pawn);
        }
        m_charge.m_chargeVolume.Enabled(true);
        m_charge.m_chargeVolume.__TouchActorCallback__Delegate = HandleVolumeTouch;
        //return;        
    }

    function RemoveBuffetVolume()
    {
        m_charge.m_chargeVolume.Enabled(false);
        //return;        
    }

    function FinishedMoveToGoal()
    {
        PopState();
        //return;        
    }

    function ChaseTimeOut()
    {
        AbortMove(false);
        //return;        
    }

    function bool IsCharging()
    {
        return true;
        //return ReturnValue;        
    }

    function bool DealWithKnockObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        Scatter(obstacle);
        return false;
        //return ReturnValue;        
    }

    function bool DealWithObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        // End:0x3F
        if(int(GetObstacleAction(obstacle, MyEnemy, bObstacleWasBumped)) != int(0))
        {
            SmashAnObstacle(obstacle, GetChargeSpeed());
            return false;            
        }
        else
        {
            // End:0x63
            if(KActor(obstacle) != none)
            {
                Scatter(obstacle);
                return false;                
            }
            else
            {
                // End:0x87
                if(SPDPhysSkel(obstacle) != none)
                {
                    Scatter(obstacle);
                    return false;                    
                }
                else
                {
                    // End:0x9C
                    if(SPBulletPersistent(obstacle) != none)
                    {
                        return false;                        
                    }
                    else
                    {
                        // End:0xAE
                        if(DroppedPickup(obstacle) != none)
                        {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
        //return ReturnValue;        
    }

    function bool DealWithThrowObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        Scatter(obstacle);
        return false;
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local bool bDealWithObstacle;
        local Vector Heading;
        local float D;

        Heading = Vector(Pawn.Rotation);
        HitNormal = -HitNormal;
        bDealWithObstacle = DealWithObstacle(Other, GetEnemy(), true);
        // End:0xA7
        if(bDealWithObstacle)
        {
            D = Heading Dot HitNormal;
            // End:0xA7
            if(Abs(D) > 0.7071068)
            {
                m_charge.m_bumpedSomething = true;
                // End:0xA7
                if(SPPawn(Other) == none)
                {
                    m_charge.m_bumpedImmovable = true;
                }
            }
        }
        return false;
        //return ReturnValue;        
    }

    event bool EncroachingOn(Actor Other)
    {
        m_charge.m_bumpedSomething = true;
        m_charge.m_bumpedImmovable = true;
        return super(Actor).EncroachingOn(Other);
        //return ReturnValue;        
    }

    event bool NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
    {
        local Vector Heading;
        local float D;

        Heading = Vector(Pawn.Rotation);
        HitNormal = -HitNormal;
        D = Heading Dot HitNormal;
        // End:0x6D
        if(Abs(D) > 0.7071068)
        {
            m_charge.m_bumpedSomething = true;
            m_charge.m_bumpedImmovable = true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool DealWithObstacleObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        // End:0x30
        if(CheckHistory(obstacle, 4, 0.0000000, 1.2000000, 6))
        {
            obstacle.Destroy();
            return false;
        }
        m_charge.m_bumpedSomething = true;
        m_charge.m_bumpedImmovable = true;
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state ChargeChaseEnemy extends ChargeMoveToGoal
{
    function SetTimers()
    {
        local float chaseTime;

        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        chaseTime = VSize(GetEnemy().Location - Pawn.Location) / GetChargeSpeed();
        // End:0x61
        if(chaseTime < float(2))
        {
            chaseTime = 2.0000000;
        }
        chaseTime *= 1.2000000;
        SetTimer(chaseTime, false, 'ChaseTimeOut');
        //return;        
    }

    function OnStateEnter()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        myPawn.StartChargeRun();
        super.OnStateEnter();
        //return;        
    }

    function bool UpdateFocus()
    {
        FocalPoint = GetEnemy().Location;
        return true;
        //return ReturnValue;        
    }

    function HandleVolumeTouch(Actor Other, Vector HitNormal)
    {
        // End:0x46
        if(((GetEnemy()) == none) || Other == (GetEnemy()))
        {
            m_charge.m_bumpedSomething = true;
            AbortMove(false);
        }
        //return;        
    }

    final function bool CanCommit()
    {
        local float commitDistance;
        local Vector relativePos, relativeDir, myFacing;
        local float Dist;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        // End:0x1D
        if(pEnemyPawn == none)
        {
            return false;
        }
        relativePos = pEnemyPawn.Location - Pawn.Location;
        Dist = VSize(relativePos);
        Dist = Dist - pEnemyPawn.GetClassSpecificCollisionRadius(Pawn);
        commitDistance = m_charge.m_commitTime * m_charge.m_chargeSpeed;
        // End:0xB0
        if(Dist > commitDistance)
        {
            return false;
        }
        relativeDir = Normal(relativePos);
        myFacing = Vector(Pawn.Rotation);
        // End:0xEC
        if((myFacing Dot relativeDir) < 0.7071200)
        {
            return false;
        }
        // End:0xF9
        if(!CanDirectlyChargeEnemy())
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    function FinishedMoveToGoal()
    {
        PopState();
        //return;        
    }

    function CommitToCharge()
    {
        m_charge.m_commited = true;
        StartDirectMove();
        AbortMove(false);
        //return;        
    }

    function HitByAnimusPulse()
    {
        GotoState('dazed');
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        m_charge.m_commited = false;
        // End:0x26
        if(CanCommit())
        {
            CommitToCharge();
        }
        // End:0x4D
        if(m_charge.m_bumpedImmovable)
        {
            PlayChargeImpactEffect();
            AbortMove(false);
        }
        //return;        
    }
    stop;    
}

state ChargeCommited extends ChargeMoveToGoal
{
    function BeginState(name PreviousStateName)
    {
        OnStateEnter();
        //return;        
    }

    function EndState(name NextStateName)
    {
        OnStateExit();
        //return;        
    }

    function PushedState()
    {
        OnStateEnter();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        //return;        
    }

    function SetTimers()
    {
        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        //return;        
    }

    function OnStateEnter()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        SetStopCondition();
        AddBuffetVolume();
        Focus = none;
        FocalPoint = (m_charge.m_targetPlaneNormal * float(10000)) + m_charge.m_targetPos;
        myPawn.StartCommitedChargeRun();
        myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
        super.OnStateEnter();
        //return;        
    }

    function OnStateExit()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        RemoveBuffetVolume();
        Focus = GetEnemy();
        myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
        EndDirectMove();
        super.OnStateExit();
        //return;        
    }

    function bool UpdateFocus()
    {
        FocalPoint = (m_charge.m_targetPlaneNormal * float(10000)) + m_charge.m_targetPos;
        return true;
        //return ReturnValue;        
    }

    final function SetStopCondition()
    {
        local Vector Direction;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        Direction = Normal(pEnemyPawn.Location - Pawn.Location);
        m_charge.m_targetPos = pEnemyPawn.Location + (Direction * m_charge.m_distToTravelAfterMiss);
        m_charge.m_lastEnemyPos = pEnemyPawn.Location;
        m_charge.m_targetPlaneNormal = Direction;
        m_charge.m_bumpedSomething = false;
        m_charge.m_bumpedImmovable = false;
        //return;        
    }

    final function bool ShouldStop()
    {
        local float Dist;

        // End:0x16
        if(m_charge.m_bumpedSomething)
        {
            return true;
        }
        // End:0x2C
        if(m_charge.m_bumpedImmovable)
        {
            return true;
        }
        Dist = VSizeSq(m_charge.m_targetPos - Pawn.Location);
        // End:0x6D
        if(Dist < float(30 * 30))
        {
            return true;
        }
        // End:0xAA
        if(((Pawn.Location - m_charge.m_targetPos) Dot m_charge.m_targetPlaneNormal) >= float(0))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function HandleVolumeTouch(Actor Other, Vector HitNormal)
    {
        // End:0x73
        if(((GetEnemy()) == none) || Other == (GetEnemy()))
        {
            m_charge.m_bumpedSomething = true;
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        }
        //return;        
    }

    final function DirectlyMovePawn(Vector Dest)
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        myPawn.ChargeDirectlyMove(Dest);
        //return;        
    }

    final function DirectlyStopPawn()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        myPawn.StartChargeBrake();
        myPawn.ChargeDirectlyStop(m_charge.m_distToTravelBeforeStopping);
        //return;        
    }
Begin:

    DirectlyMovePawn(m_charge.m_targetPos);
    J0x16:

    // End:0x51 [Loop If]
    if(!ShouldStop())
    {
        // End:0x46
        if(m_charge.m_targetPos == vect(0.0000000, 0.0000000, 0.0000000))
        {
            // [Explicit Break]
            goto J0x51;
        }
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x16;
    }
    J0x51:

    StartDirectMove();
    Sleep(0.1000000);
    // End:0xBA
    if(m_charge.m_bumpedSomething || m_charge.m_bumpedImmovable)
    {
        EndDirectMove();
        PlayChargeImpactEffect();
        // End:0xB7
        if(m_charge.m_bumpedImmovable)
        {
            GotoState('dazed');
        }        
    }
    else
    {
        DirectlyStopPawn();
        J0xC0:

        // End:0x146 [Loop If]
        if(VSize(DirectMoveVelocity()) > float(50))
        {
            // End:0x13B
            if(m_charge.m_bumpedSomething || m_charge.m_bumpedImmovable)
            {
                // End:0x138
                if(m_charge.m_bumpedImmovable && VSize(Velocity) > (0.3333000 * GetChargeSpeed()))
                {
                    GotoState('dazed');
                }
                // [Explicit Break]
                goto J0x146;
            }
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0xC0;
        }
    }
    J0x146:

    PopState();
    stop;            
}

state dazed
{
    function BeginState(name PreviousStateName)
    {
        OnStateEnter();
        //return;        
    }

    function EndState(name NextStateName)
    {
        OnStateExit();
        //return;        
    }

    function OnStateEnter()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        EndDirectMove();
        Focus = none;
        FocalPoint = (m_charge.m_targetPlaneNormal * float(10000)) + m_charge.m_targetPos;
        myPawn.StartDazed();
        myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
        //return;        
    }

    function PushedState()
    {
        OnStateExit();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        //return;        
    }

    function OnStateExit()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
        CancelAction();
        Focus = GetEnemy();
        //return;        
    }

    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        return true;
        //return ReturnValue;        
    }

    final function bool IsDazed()
    {
        local SPMinotaurPawnPersistent myPawn;

        myPawn = SPMinotaurPawnPersistent(Pawn);
        return myPawn.IsDazed();
        //return ReturnValue;        
    }
    J0x00:
    // End:0x14 [Loop If]
    if(IsDazed())
    {
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0x00;
    }
    DisableChargeForTime(RandRange(5.0000000, 8.0000000));
    CancelAction();
    EvaluateSituation();
    stop;        
}

state throwClub
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function StartThrowClub()
    {
        local SPMinotaurPawnPersistent myPawn;
        local Vector clubTarget;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        myPawn = SPMinotaurPawnPersistent(Pawn);
        // End:0x7A
        if(pEnemyPawn != none)
        {
            clubTarget.X = 0.0000000;
            clubTarget.Y = 0.0000000;
            clubTarget.Z = pEnemyPawn.EyeHeight;            
        }
        else
        {
            clubTarget = myPawn.Location + (Vector(Rotation) * float(100));
        }
        myPawn.StartThrowClub(pEnemyPawn, clubTarget);
        //return;        
    }

    function bool UpdateFocus()
    {
        // End:0x2F
        if((GetEnemy()) != none)
        {
            FocalPoint = GetEnemy().Location;
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
Begin:

    StartThrowClub();
    J0x0A:

    // End:0x20 [Loop If]
    if(!ThrowClubFinished())
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x0A;
    }
    CancelAction();
    EvaluateSituation();
    stop;                
}

state MinotaurMeleeMoveToGoal extends MeleeMoveToGoal
{
    function SetTimers()
    {
        SetTimer(0.1000000, true, 'StanceUpdate');
        super.SetTimers();
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('StanceUpdate');
        super(KyMoveToGoal).ClearTimers();
        //return;        
    }

    function bool UseWalk()
    {
        return UseWalkDuringMelee();
        //return ReturnValue;        
    }
    stop;    
}

state Melee
{
    function bool UseWalk()
    {
        return UseWalkDuringMelee();
        //return ReturnValue;        
    }

    function GotoMoveToGoalState()
    {
        PushState('MinotaurMeleeMoveToGoal');
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local bool bDealWithObstacle;

        bDealWithObstacle = DealWithObstacle(Other, GetEnemy(), true);
        // End:0x2C
        if(bDealWithObstacle)
        {
            return false;
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}
