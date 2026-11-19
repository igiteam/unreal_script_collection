class SPGriffonPawnPersistent extends SPFlightPawn
    native
    config(Game);

enum EGriffonAttackPointTransitionMode
{
    egaptNone,                      // 0
    egaptSideStepLeft,              // 1
    egaptSideStepRight,             // 2
    egaptTableTransition,           // 3
    EGriffonAttackPointTransitionMode_MAX// 4
};

enum EHitReactionState
{
    ersNone,                        // 0
    ersPlayLight,                   // 1
    ersPlayHeavy,                   // 2
    ersPlayLightExplosion,          // 3
    ersPlayExplosion,               // 4
    ersPlayAnimusPulse,             // 5
    ersPlayBackup,                  // 6
    ersDead,                        // 7
    EHitReactionState_MAX           // 8
};

enum EGriffonUberState
{
    egatNone,                       // 0
    egatAnnounce,                   // 1
    egatChallenge,                  // 2
    egatDazed,                      // 3
    egatMissedCharge,               // 4
    egatTurn,                       // 5
    egatTaunt,                      // 6
    egatKnockAway,                  // 7
    egatScreamAttack,               // 8
    egatCG,                         // 9
    egatCGR,                        // 10
    egatCGF,                        // 11
    egatCGFR,                       // 12
    egatScreamAttackReared,         // 13
    egatBackup,                     // 14
    egatGroundAttack,               // 15
    EGriffonUberState_MAX           // 16
};

enum EGriffonIdleType
{
    egitNone,                       // 0
    egitPreAttackIdle,              // 1
    EGriffonIdleType_MAX            // 2
};

enum EGriffonRot
{
    eRoll,                          // 0
    ePitch,                         // 1
    eYaw,                           // 2
    EGriffonRot_MAX                 // 3
};

enum EGriffonLoc
{
    eForward,                       // 0
    eRight,                         // 1
    eUp,                            // 2
    EGriffonLoc_MAX                 // 3
};

enum EGriffonHitDamage
{
    NoDamage,                       // 0
    SmallArms,                      // 1
    HeavyWeapons,                   // 2
    Explosives,                     // 3
    EGriffonHitDamage_MAX           // 4
};

enum EGriffonTurn
{
    Unchecked,                      // 0
    NoTurn,                         // 1
    Right45,                        // 2
    Left45,                         // 3
    Right90,                        // 4
    Left90,                         // 5
    Right180,                       // 6
    Left180,                        // 7
    EGriffonTurn_MAX                // 8
};

var SPGriffonAIController MyController;
var() bool xxxx_Test;
var bool bUseOldPhysics;
var bool m_bDying;
var bool m_allowBodyHitReaction;
var bool m_resetIdleAnim;
var bool m_bCanPlayHitReaction;
var bool m_bTurnCycleFinished;
var bool m_bShouldResetTurnAnims;
var transient bool m_isDoingHornAttack;
var transient bool m_isDoingPounceAttack;
var bool m_bCanPlaySwipeSound;
var bool m_resetAttackAnim;
/** in the air attack approach animation state */
var() bool m_bDoingAirAttackApproach;
/** in the air attack approach animation state */
var() bool m_bDoingAirAttackAnticipation;
var bool m_bPlayingAttackPointAnimation;
var bool m_bResetAttackPointAnimation;
var bool m_bInTurnTowardsFocus;
var bool m_bWaitingForAttackPointOrientation;
var bool m_bInAttackPointState;
var bool m_bAtAttackPoint;
var bool m_bIsThisTransitionAttackPointDestructibleDestroyed;
var bool m_bWaitingForHitReact;
var() float xxxx_Prop;
var() float xxxx_Diff;
var() Vector xxxx_Direction;
var export editinline SPGriffonDebugRenderComponent m_RenderComponent;
var array<float> deltaHPRsmooth;
var float FlapRateModifier;
var float RollAmount;
/** ---- health, hitpoints, and vital statistics ------ */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPGriffonPawnPersistent.EHitReactionState m_hitReactionAnimState;
var SPGriffonPawnPersistent.EGriffonUberState m_currentUberState;
var SPGriffonPawnPersistent.EGriffonIdleType m_currentIdleType;
var SPGriffonPawnPersistent.EGriffonHitDamage m_eHitDamageType;
var SPFlightPawn.EFlightPathingType m_pathingType;
var SPGriffonPawnPersistent.EGriffonTurn m_turnType;
var SPPawn.eKnockDirection m_knockDirection;
var SPGriffonAttackPoint.EGriffonAttackPointPoseType m_eTransitionToAttackPointPose;
var SPGriffonAttackPoint.EGriffonAttackPointPoseType m_eTransitionFromAttackPointPose;
var SPGriffonPawnPersistent.EGriffonAttackPointTransitionMode m_eAttackPointTransitionMode;
var SPPawn.EHSDamageDirectionType m_lastDamageDirectionType;
var name m_lastDamagedBone;
var name m_currentHeadHitName;
var float m_rotationRateScale;
var float KismetSpeedScale;
var export editinline CylinderComponent m_collisionCylinder;
var float m_RecordedDmg;
var float m_RecordedExplosiveDmg;
var transient name m_neckAttackNameCurrent;
var transient name m_neckAttackNameNext;
var transient name m_frontAttackDir;
var SoundCue m_ramImpactSound;
var SoundCue m_swipeSound;
var name m_LastAirAttackAnimName;
/** 0 for none, otherwise one of several different animations */
var() int m_iCurrentAirAttack;
var SoundCue m_startAirAttackRoar;
var name m_AttackPointDeathAnimationName;
var name m_LastAttackPointAnimName;
var name m_LastAttackPointTransitionAnimName;
var name m_AttackPointAnimationName;
var int m_activeWallAnimChannel;
var WallAnimChannelData m_wallAnimChannelData[2];
var() float MaxAnimationReachSpecLength;
var SPTuneDataGriffon m_GriffonTuneData;
var SPGameDifficultyTuneGriffon m_GriffonGDTuneData;
var ParticleSystem SonicParticleTemplate;
var SPGriffonAttackPoint m_CurrentAttackPoint;
var int m_CurrentAttackPointVolumeIndex;
var StaticMesh m_SonicCone;
var SPDStaticMesh m_SonicActor;
var transient Vector sonicDrawVector;

// Export USPGriffonPawnPersistent::execMyTestFN(FFrame&, void* const)
native function MyTestFN(int Val);

// Export USPGriffonPawnPersistent::execBoxExtent(FFrame&, void* const)
native function Box BoxExtent();

// Export USPGriffonPawnPersistent::execFrontAttackFinished(FFrame&, void* const)
native function FrontAttackFinished();

// Export USPGriffonPawnPersistent::execFrontAttackStarting(FFrame&, void* const)
native function name FrontAttackStarting(SPAnimGenericFunctionMonitorNode Node);

// Export USPGriffonPawnPersistent::execSonicRangedAttack(FFrame&, void* const)
native function bool SonicRangedAttack(float Range, Vector Extent);

function OnSpSetAirGroundMode(SeqAct_SpSetAirGroundMode Action)
{
    MyController = SPGriffonAIController(Controller);
    // End:0x34
    if(MyController != none)
    {
        MyController.OnSpSetAirGroundMode(Action);
    }
    //return;    
}

function class<DamageType> GetSmashDamageType()
{
    return Class'SPDamageTypeGriffon';
    //return ReturnValue;    
}

function SetAnimBasedMovementType()
{
    SetMovementType(14);
    //return;    
}

function OnSpeedScale(SeqAct_SpeedScale Action)
{
    KismetSpeedScale = Action.Scale;
    MaxDesiredSpeed = KismetSpeedScale;
    DesiredSpeed = KismetSpeedScale;
    AccelRate = Class'SPGriffonPawnPersistent'.default.AccelRate * KismetSpeedScale;
    m_rotationRateScale = KismetSpeedScale;
    //return;    
}

simulated function name TurnBasedAttackCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x10
    if(m_resetAttackAnim)
    {
        bResetChildOut = 1;
    }
    switch(SPTurnNodeIndex)
    {
        // End:0xFFFF
        default:
            return 'Ahead';
            break;
    }
    //return ReturnValue;    
}

event HornAttackFinished()
{
    m_isDoingHornAttack = false;
    MyController.HornAttackFinished();
    //return;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

function int SpecialCost(ReachSpec Path)
{
    // End:0x1E
    if(Path.IsA('SPWallReachSpec'))
    {
        return 1000000000;
    }
    return 0;
    //return ReturnValue;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Griffon;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.GriffonGD;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super(SPPawn).PreBeginPlay();
    m_GriffonTuneData = SPTuneDataGriffon(GetMyTuneData());
    m_GriffonGDTuneData = SPGameDifficultyTuneGriffon(GetMyGDData());
    //return;    
}

simulated function PostBeginPlay()
{
    super(SPPawn).PostBeginPlay();
    m_AirGroundMode = 1;
    MyController = SPGriffonAIController(Controller);
    SetMovementType(2);
    SetMovementPhysics();
    MeleeRange = m_GriffonGDTuneData.HornAttackDistMax;
    // End:0xB7
    if(NavigationComponent != none)
    {
        NavigationComponent.m_bUseAerialPathSmoothing = true;
        NavigationComponent.m_bAutoAvoidObstacles = false;
        NavigationComponent.m_seekPointNudgeDistance = 1000.0000000;
        NavigationComponent.m_maxDistanceFromPath = 200.0000000;
        NavigationComponent.m_avoidObstacleMaxLookAheadDistance = 225.0000000;
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    ServerTick_SPGriffonPawnPersistent(DeltaTime);
    super(SPPawn).Tick(DeltaTime);
    //return;    
}

simulated function ScaleSonicMesh()
{
    sonicDrawVector.X += 0.0750000;
    m_SonicActor.SetDrawScale3D(sonicDrawVector);
    //return;    
}

final function ServerTick_SPGriffonPawnPersistent(float DeltaTime)
{
    // End:0x28
    if((MyController == none) && Controller != none)
    {
        MyController = SPGriffonAIController(Controller);
    }
    UpdateDamageZones(DeltaTime);
    m_RecordedDmg -= m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.DamageDecayRate);
    m_RecordedExplosiveDmg -= m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.ExplosiveDamageDecayRate);
    // End:0xB2
    if(m_RecordedDmg < float(0))
    {
        m_RecordedDmg = 0.0000000;
        // End:0xB2
        if(!m_bCanPlayHitReaction)
        {
            m_bCanPlayHitReaction = true;
        }
    }
    // End:0xCA
    if(m_RecordedExplosiveDmg < float(0))
    {
        m_RecordedExplosiveDmg = 0.0000000;
    }
    // End:0xDF
    if(m_SonicActor != none)
    {
        ScaleSonicMesh();
    }
    //return;    
}

event bool ArrivedAtMoveTarget()
{
    return true;
    //return ReturnValue;    
}

function SetDamageType(class<DamageType> DamageType)
{
    switch(DamageType)
    {
        // End:0x3D
        case Class'SPDamageTypeHK_UMP':
            // End:0x3A
            if((int(m_eHitDamageType) != int(3)) && int(m_eHitDamageType) != int(2))
            {
                m_eHitDamageType = 1;
            }
            // End:0xA6
            break;
        // End:0x45
        case Class'SPDamageTypeMinigun':
        // End:0x4D
        case Class'SPDamageTypeDesertEagle':
        // End:0x55
        case Class'SPDamageTypeAssaultRifle':
        // End:0x78
        case Class'SPDamageTypeShotgun':
            // End:0x75
            if(int(m_eHitDamageType) != int(3))
            {
                m_eHitDamageType = 2;
            }
            // End:0xA6
            break;
        // End:0x80
        case Class'SPDamageTypeExplosionGrenade':
        // End:0x88
        case Class'SPDamageTypeExplosionRocketLauncher':
        // End:0x9B
        case Class'SPDamageTypeAnimusPulse':
            m_eHitDamageType = 3;
            // End:0xA6
            break;
        // End:0xFFFF
        default:
            m_eHitDamageType = 1;
            break;
    }
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local float HeavyResetTime, LightResetTime, ExplosionResetTime, LightExplosionResetTime;

    LightResetTime = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.TimeOutTimer);
    HeavyResetTime = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.HeavyTimeOutTimer);
    LightExplosionResetTime = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.LightExplosionTimeOutTimer);
    ExplosionResetTime = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.ExplosionTimeOutTimer);
    super(SPPawn).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x14C
    if(!IsInState('CATAttcker'))
    {
        // End:0x11B
        if(PlayerController(EventInstigator) != none)
        {
            m_RecordedDmg += DamageAmount;
            // End:0x118
            if(DamageType == Class'SPDamageTypeExplosionAny')
            {
                m_RecordedExplosiveDmg += DamageAmount;
            }            
        }
        else
        {
            m_RecordedDmg += (DamageAmount * m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.DamageNPCModifier));
        }
    }
    // End:0x355
    if(int(Physics) != int(4))
    {
        SetDamageType(DamageType);
        // End:0x334
        if(int(m_hitReactionAnimState) == int(0))
        {
            // End:0x1D5
            if(DamageType == Class'SPDamageTypeAnimusPulse')
            {
                m_resetAttackAnim = true;
                // End:0x1CB
                if(MyController.IsBackupValid(Location - (Vector(Rotation) * float(1500))))
                {
                    m_hitReactionAnimState = 6;                    
                }
                else
                {
                    m_hitReactionAnimState = 5;
                }
                return;
            }
            // End:0x228
            if(m_bCanPlayHitReaction && m_RecordedDmg > m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.DamageThreshold))
            {
                SetTimer(LightResetTime, false, 'ResetHitReaction');
                m_hitReactionAnimState = 1;
            }
            // End:0x27B
            if(m_bCanPlayHitReaction && m_RecordedExplosiveDmg > m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.LightExplosiveDamageThreshold))
            {
                SetTimer(LightExplosionResetTime, false, 'ResetHitReaction');
                m_hitReactionAnimState = 3;
            }
            // End:0x2CB
            if(m_RecordedDmg > m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.HeavyDamageThreshold))
            {
                SetTimer(HeavyResetTime, false, 'ResetHitReaction');
                m_hitReactionAnimState = 2;
                m_bCanPlayHitReaction = true;
            }
            // End:0x31B
            if(m_RecordedExplosiveDmg > m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.ExplosiveDamageThreshold))
            {
                SetTimer(ExplosionResetTime, false, 'ResetHitReaction');
                m_hitReactionAnimState = 4;
                m_bCanPlayHitReaction = true;
            }
            m_lastDamagedBone = HitInfo.BoneName;            
        }
        else
        {
            // End:0x355
            if(Health <= 0)
            {
                m_lastDamagedBone = HitInfo.BoneName;
            }
        }
    }
    //return;    
}

function bool GetBestFireSocket(const Vector NewLocation, out name fireSocketName)
{
    local Vector vPos[4];
    local Rotator rRot;
    local float smDist, Dist;
    local int smSocket, I;

    smDist = 999999.0000000;
    smSocket = 0;
    Mesh.GetSocketWorldLocationAndRotation('Fire1', vPos[0], rRot);
    Mesh.GetSocketWorldLocationAndRotation('Fire2', vPos[1], rRot);
    Mesh.GetSocketWorldLocationAndRotation('Fire3', vPos[2], rRot);
    Mesh.GetSocketWorldLocationAndRotation('Fire4', vPos[3], rRot);
    I = 0;
    J0xAF:

    // End:0x108 [Loop If]
    if(I < 4)
    {
        Dist = VSizeSq(vPos[I] - NewLocation);
        // End:0xFE
        if(Dist < smDist)
        {
            smDist = Dist;
            smSocket = I;
        }
        I++;
        // [Loop Continue]
        goto J0xAF;
    }
    switch(smSocket)
    {
        // End:0x126
        case 0:
            fireSocketName = 'Fire1';
            // End:0x16D
            break;
        // End:0x13C
        case 1:
            fireSocketName = 'Fire2';
            // End:0x16D
            break;
        // End:0x153
        case 2:
            fireSocketName = 'Fire3';
            // End:0x16D
            break;
        // End:0x16A
        case 3:
            fireSocketName = 'Fire4';
            // End:0x16D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return true;
    //return ReturnValue;    
}

event UsePhysWalking()
{
    HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
    MyController.SetPursueStyle();
    bCanFly = false;
    SetMovementPhysics();
    m_isLanding = false;
    m_isTakingoff = false;
    //return;    
}

event UsePhysFlying()
{
    HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    SetMovementType(11);
    bCanFly = true;
    SetMovementPhysics();
    m_isLanding = false;
    m_isTakingoff = false;
    //return;    
}

function OnIncrementGriffonThrust(SeqAct_IncrementGriffonThrust Action)
{
    FPhys.deltaThrust += Action.Amount;
    // End:0x51
    if(FPhys.deltaThrust > 1.0000000)
    {
        FPhys.deltaThrust = 1.0000000;
    }
    // End:0x81
    if(FPhys.deltaThrust < 0.0000000)
    {
        FPhys.deltaThrust = 0.0000000;
    }
    //return;    
}

simulated function int GetFreeWallAnimationChannel()
{
    // End:0x10
    if(m_activeWallAnimChannel == 0)
    {
        return 1;        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

simulated function SetSingleWallAnimation(name NodeName, name AnimName)
{
    // End:0xC1
    if((Mesh != none) && Mesh.Animations != none)
    {
        m_wallRegistrationNode = SPAnimNodeSequence(Mesh.Animations.FindAnimNode(NodeName));
        // End:0xC1
        if(m_wallRegistrationNode != none)
        {
            m_wallRegistrationNode.SetAnim(AnimName, false);
            m_wallRegistrationNode.SetPosition(0.0000000, false);
            m_wallRegistrationNode.bLooping = false;
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'SingleAnim';            
        }
    }
    //return;    
}

simulated function WallAnimationChannel1SingleAnimFinished()
{
    // End:0x5A
    if((m_activeWallAnimChannel == 0) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

simulated function WallAnimationChannel2SingleAnimFinished()
{
    // End:0x5A
    if((m_activeWallAnimChannel == 1) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

simulated function SetFourWayWallAnimation(name NodeName, name forwardName, name backwardName, name leftName, name rightName)
{
    local SPAnimBlendDirectionalNode fourWayNode;
    local AnimNodeSequence Seq;

    // End:0x1C3
    if((Mesh != none) && Mesh.Animations != none)
    {
        fourWayNode = SPAnimBlendDirectionalNode(Mesh.Animations.FindAnimNode(NodeName));
        // End:0x1A3
        if(fourWayNode != none)
        {
            Seq = AnimNodeSequence(fourWayNode.Children[0].Anim);
            // End:0xA3
            if(Seq != none)
            {
                Seq.SetAnim(forwardName, false);
            }
            // End:0x1A0
            if(fourWayNode.Children.Length >= 4)
            {
                Seq = AnimNodeSequence(fourWayNode.Children[1].Anim);
                // End:0x106
                if(Seq != none)
                {
                    Seq.SetAnim(backwardName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[2].Anim);
                // End:0x153
                if(Seq != none)
                {
                    Seq.SetAnim(leftName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[3].Anim);
                // End:0x1A0
                if(Seq != none)
                {
                    Seq.SetAnim(rightName, false);
                }
            }            
        }
        m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'FourWayAnim';
    }
    //return;    
}

simulated function bool StartWallTransitionAnimations()
{
    local name transName;

    SetAnimBasedMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    m_wallMovementData.bExecutingTransition = true;
    // End:0x130
    if(m_wallMovementData.TransitionData.currentTransition < m_wallMovementData.TransitionData.TransitionList.Length)
    {
        transName = m_wallMovementData.TransitionData.TransitionList[m_wallMovementData.TransitionData.currentTransition].transitionAnimName;
        m_activeWallAnimChannel = GetFreeWallAnimationChannel();
        m_wallAnimChannelData[m_activeWallAnimChannel].bReset = true;
        // End:0xF0
        if(transName == 'None')
        {
            return false;
        }
        // End:0x116
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallAnimation('WallAnimationChannel1Single', transName);            
        }
        else
        {
            SetSingleWallAnimation('WallAnimationChannel2Single', transName);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function StartWallMovementAnimations()
{
    local SPAWallAnimation wallData;

    SetAnimBasedMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    wallData = m_wallMovementData.wallAnimData;
    m_wallMovementData.bExecutingTransition = false;
    m_activeWallAnimChannel = GetFreeWallAnimationChannel();
    m_wallAnimChannelData[m_activeWallAnimChannel].bReset = true;
    // End:0x8A
    if(wallData.MainAnimationName == 'None')
    {
    }
    // End:0x120
    if(m_activeWallAnimChannel == 0)
    {
        // End:0xCE
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation('WallAnimationChannel1Single', wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation('WallAnimationChannel1FourWay', wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }        
    }
    else
    {
        // End:0x159
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation('WallAnimationChannel2Single', wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation('WallAnimationChannel2FourWay', wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }
    }
    //return;    
}

function SetSingleWallIdleAnimation(name NodeName, name AnimName)
{
    local SPAnimNodeSequence Seq;

    // End:0x94
    if((Mesh != none) && Mesh.Animations != none)
    {
        Seq = SPAnimNodeSequence(Mesh.Animations.FindAnimNode(NodeName));
        // End:0x94
        if(Seq != none)
        {
            Seq.SetAnim(AnimName, false);
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'IdleAnim';            
        }
    }
    //return;    
}

event StopWallMovementAnimation()
{
    // End:0x96
    if(!m_wallMovementData.bIsSingleAnim && m_wallMovementData.wallAnimData != none)
    {
        // End:0x69
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallIdleAnimation('WallAnimationChannel1Idle', m_wallMovementData.wallAnimData.IdleAnimation);            
        }
        else
        {
            SetSingleWallIdleAnimation('WallAnimationChannel2Idle', m_wallMovementData.wallAnimData.IdleAnimation);
        }
    }
    //return;    
}

simulated function name WallAnimationChannelSelectMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x33
    if(m_wallAnimChannelData[m_activeWallAnimChannel].bReset)
    {
        m_wallAnimChannelData[m_activeWallAnimChannel].bReset = false;
    }
    // End:0x50
    if(m_activeWallAnimChannel == 0)
    {
        retval = 'Channel1';        
    }
    else
    {
        retval = 'Channel2';
    }
    return retval;
    //return ReturnValue;    
}

simulated function name WallAnimationChannel1MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[0].MCBName;
    //return ReturnValue;    
}

simulated function name WallAnimationChannel2MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[1].MCBName;
    //return ReturnValue;    
}

simulated function name AerialWingHitOrDeathAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    // End:0x37
    if(int(m_hitReactionAnimState) != int(0))
    {
        // End:0x37
        if(m_bDying)
        {
            retval = 'Death';
        }
    }
    return retval;
    //return ReturnValue;    
}

simulated function name AerialBodyHitOrDeathAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    // End:0x49
    if(int(m_hitReactionAnimState) != int(0))
    {
        // End:0x3A
        if(m_bDying)
        {
            retval = 'Death';            
        }
        else
        {
            retval = 'Hit';
        }
    }
    return retval;
    //return ReturnValue;    
}

simulated function name AerialHeadHitOrDeathAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    // End:0x49
    if(int(m_hitReactionAnimState) != int(0))
    {
        // End:0x3A
        if(m_bDying)
        {
            retval = 'Death';            
        }
        else
        {
            retval = 'Hit';
        }
    }
    return retval;
    //return ReturnValue;    
}

function HitReactionFinished()
{
    // End:0x7C
    if((int(m_hitReactionAnimState) > int(0)) && !m_bDying)
    {
        m_bCanPlayHitReaction = false;
        ClearTimer('AllowHitReactionRestart');
        m_hitReactionAnimState = 0;
        m_allowBodyHitReaction = false;
        m_eHitDamageType = 0;
        m_RecordedDmg = 0.0000000;
        m_RecordedExplosiveDmg = 0.0000000;
        SetPhysics(1);
        MyController.HitReactionFinished();
    }
    //return;    
}

function LightHitReactionFinished()
{
    // End:0x66
    if((int(m_hitReactionAnimState) > int(0)) && !m_bDying)
    {
        m_bCanPlayHitReaction = false;
        ClearTimer('AllowHitReactionRestart');
        m_hitReactionAnimState = 0;
        m_allowBodyHitReaction = false;
        m_eHitDamageType = 0;
        SetPhysics(1);
        MyController.HitReactionFinished();
    }
    //return;    
}

function DeathReactionFinished()
{
    m_hitReactionAnimState = 7;
    // End:0x27
    if(MyController != none)
    {
        MyController.DeathReactionFinished();
    }
    //return;    
}

function AllowHitReactionRestart()
{
    //return;    
}

function ResetHitReaction()
{
    m_bCanPlayHitReaction = true;
    //return;    
}

simulated function name HitReactionTypePollAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x1B
    if(m_resetAttackAnim == true)
    {
        bResetChildOut = 1;
        m_resetAttackAnim = false;
    }
    retval = 'Light';
    switch(m_hitReactionAnimState)
    {
        // End:0x49
        case 2:
            retval = 'Heavy';
            // End:0xAB
            break;
        // End:0x60
        case 4:
            retval = 'Explosion';
            // End:0xAB
            break;
        // End:0x77
        case 3:
            retval = 'LightExplosion';
            // End:0xAB
            break;
        // End:0x8E
        case 5:
            retval = 'Animus';
            // End:0xAB
            break;
        // End:0xA5
        case 6:
            retval = 'Backup';
            // End:0xAB
            break;
        // End:0xFFFF
        default:
            // End:0xAB
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function name HeadControlHitMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    // End:0x25
    if(int(m_hitReactionAnimState) == int(0))
    {
        return retval;
    }
    // End:0x60
    if(m_bDying)
    {
        switch(m_currentUberState)
        {
            // End:0x3B
            case 10:
            // End:0x40
            case 12:
            // End:0x48
            case 13:
                // End:0x5D
                break;
            // End:0xFFFF
            default:
                retval = 'NormalDeath';
                // End:0x5D
                break;
                break;
        }        
    }
    else
    {
        switch(m_currentUberState)
        {
            // End:0x6D
            case 10:
            // End:0x72
            case 12:
            // End:0x7A
            case 13:
                // End:0x8F
                break;
            // End:0xFFFF
            default:
                retval = 'NormalHit';
                // End:0x8F
                break;
                break;
        }
    }
    return retval;
    //return ReturnValue;    
}

simulated function name AttackPointDeathCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_AttackPointDeathAnimationName;
    //return ReturnValue;    
}

simulated function name BodyControlHitMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    // End:0x7F
    if(!m_bDying)
    {
        // End:0x30
        if(int(m_hitReactionAnimState) == int(0))
        {
            return retval;
        }
        switch(m_currentUberState)
        {
            // End:0x3D
            case 10:
            // End:0x42
            case 12:
            // End:0x4A
            case 13:
                // End:0x7C
                break;
            // End:0xFFFF
            default:
                // End:0x79
                if(int(m_hitReactionAnimState) > int(0))
                {
                    m_currentUberState = 0;
                    retval = 'NormalHit';
                    SetPhysics(0);
                }
                // End:0x7C
                break;
                break;
        }        
    }
    else
    {
        // End:0xD4
        if(m_bDying)
        {
            // End:0xA5
            if(m_AttackPointDeathAnimationName != 'None')
            {
                return 'AttackPointDeath';
            }
            switch(m_currentUberState)
            {
                // End:0xB2
                case 10:
                // End:0xB7
                case 12:
                // End:0xBF
                case 13:
                    // End:0xD4
                    break;
                // End:0xFFFF
                default:
                    retval = 'NormalDeath';
                    // End:0xD4
                    break;
                    break;
            }
        }
    }
    return retval;
    //return ReturnValue;    
}

simulated function float HeadBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    childWeights[1] = 1.0000000;
    return 1.0000000;
    //return ReturnValue;    
}

simulated function float WingBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    childWeights[1] = 1.0000000;
    return 1.0000000;
    //return ReturnValue;    
}

event KnockEffect()
{
    MyController.KnockEffect();
    //return;    
}

function DestroySonicCone()
{
    // End:0x3A
    if(m_SonicActor != none)
    {
        m_SonicActor.StaticMeshComponent.SetHidden(true);
        m_SonicActor.Destroy();
        m_SonicActor = none;
    }
    //return;    
}

function SetIdleType(SPGriffonPawnPersistent.EGriffonIdleType Type)
{
    m_currentIdleType = Type;
    //return;    
}

function ActivateRightFrontClawDamage()
{
    //return;    
}

function ActivateLeftFrontClawDamage()
{
    //return;    
}

function ActivatePounceDamage()
{
    //return;    
}

function ActivateBeakDamage()
{
    //return;    
}

function SetUberState(SPGriffonPawnPersistent.EGriffonUberState Type, optional bool bPreventDamage)
{
    local int I;

    m_currentUberState = Type;
    switch(m_currentUberState)
    {
        // End:0x50
        case 0:
            // End:0x4D
            if(!bPreventDamage)
            {
                I = 0;
                J0x2B:

                // End:0x4D [Loop If]
                if(I < 8)
                {
                    SetDamageZone(I, false);
                    I++;
                    // [Loop Continue]
                    goto J0x2B;
                }
            }
            // End:0x66
            break;
        // End:0x58
        case 5:
            // End:0x66
            break;
        // End:0xFFFF
        default:
            m_resetAttackAnim = true;
            // End:0x66
            break;
            break;
    }
    //return;    
}

simulated function name TurnTypeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0xF7
    if(((int(m_currentUberState) == int(0)) && !m_isDoingHornAttack) && !m_isDoingPounceAttack)
    {
        // End:0x56
        if((int(m_turnType) == int(0)) || int(m_turnType) == int(1))
        {
            SetTurnType();
        }
        // End:0x79
        if(m_bShouldResetTurnAnims == true)
        {
            bResetChildOut = 1;
            m_bTurnCycleFinished = false;
            m_bShouldResetTurnAnims = false;
        }
        switch(m_turnType)
        {
            // End:0x90
            case 1:
                return 'Default';
            // End:0x9F
            case 2:
                return 'Right45';
            // End:0xAE
            case 3:
                return 'Left45';
            // End:0xBD
            case 4:
                return 'Right90';
            // End:0xCC
            case 5:
                return 'Left90';
            // End:0xDB
            case 6:
                return 'Right180';
            // End:0xEA
            case 7:
                return 'Left180';
            // End:0xFFFF
            default:
                return 'Default';
                break;
        }
    }
    m_turnType = 0;
    return 'Default';
    //return ReturnValue;    
}

function TurnFinished()
{
    m_turnType = 0;
    //return;    
}

function bool AllowedToTurn()
{
    // End:0x29
    if((Controller == none) || Controller.GetEnemy() == none)
    {
        return false;
    }
    // End:0x55
    if(((CATAttackerPawn != none) || CATDefenderPawn != none) || int(Physics) == int(8))
    {
        return false;
    }
    // End:0x94
    if(((m_isDoingHornAttack || m_isDoingPounceAttack) || !m_bTurnCycleFinished) || MyController.IsInState('KyPursueToPosition'))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SetTurnType()
{
    local float Angle, dotter;
    local Vector rightside, Front;
    local bool Right;
    local Vector projectedPos;

    Front = Vector(Rotation);
    // End:0x26
    if(!AllowedToTurn())
    {
        m_turnType = 1;
        return;
    }
    rightside = Front;
    rightside.X = Front.Y;
    rightside.Y = -Front.X;
    projectedPos = Controller.GetEnemy().Location + (Controller.GetEnemy().Velocity * 1.5000000);
    Angle = Front Dot Normal(projectedPos - Location);
    dotter = rightside Dot Normal(projectedPos - Location);
    Right = ((dotter < float(0)) ? true : false);
    // End:0x12A
    if(Angle > 0.9500000)
    {
        m_turnType = 1;
        return;        
    }
    else
    {
        // End:0x151
        if(Angle > 0.5000000)
        {
            m_turnType = ((Right) ? 2 : 3);            
        }
        else
        {
            // End:0x178
            if(Angle > -0.7070000)
            {
                m_turnType = ((Right) ? 4 : 5);                
            }
            else
            {
                m_turnType = ((Right) ? 6 : 7);
            }
        }
    }
    m_bTurnCycleFinished = false;
    m_bShouldResetTurnAnims = true;
    //return;    
}

event StartAirAttackApproach()
{
    m_bDoingAirAttackApproach = true;
    m_bDoingAirAttackAnticipation = false;
    //return;    
}

event StartAirAttackAnticipation()
{
    m_bDoingAirAttackApproach = false;
    m_bDoingAirAttackAnticipation = true;
    //return;    
}

event StartAirAttack(int iAnimation)
{
    // End:0x22
    if((iAnimation < 0) || iAnimation > 2)
    {
        m_iCurrentAirAttack = 0;
        return;
    }
    m_iCurrentAirAttack = iAnimation + 1;
    m_bDoingAirAttackApproach = false;
    m_bDoingAirAttackAnticipation = false;
    //return;    
}

function PlayRoar()
{
    PlaySound(m_startAirAttackRoar);
    //return;    
}

event AbortAirAttack()
{
    m_bDoingAirAttackApproach = false;
    //return;    
}

simulated function name IsDoingAirAttack(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x2E
    if((m_bDoingAirAttackApproach || m_bDoingAirAttackAnticipation) || m_iCurrentAirAttack != 0)
    {
        return 'Attacking';        
    }
    else
    {
        return 'Not Attacking';
    }
    //return ReturnValue;    
}

simulated function name AirAttackCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x21
    if(m_bDoingAirAttackApproach)
    {
        m_LastAirAttackAnimName = 'Approach';
        return m_LastAirAttackAnimName;        
    }
    else
    {
        // End:0x42
        if(m_bDoingAirAttackAnticipation)
        {
            m_LastAirAttackAnimName = 'Anticipation';
            return m_LastAirAttackAnimName;            
        }
        else
        {
            switch(m_iCurrentAirAttack)
            {
                // End:0x63
                case 1:
                    m_LastAirAttackAnimName = 'Forward';
                    return m_LastAirAttackAnimName;
                // End:0x7D
                case 2:
                    m_LastAirAttackAnimName = 'Left';
                    return m_LastAirAttackAnimName;
                // End:0x97
                case 3:
                    m_LastAirAttackAnimName = 'Right';
                    return m_LastAirAttackAnimName;
                // End:0xFFFF
                default:
                    break;
                }
        }
    }
    return m_LastAirAttackAnimName;
    //return ReturnValue;    
}

function AirAttackFinished()
{
    m_bDoingAirAttackApproach = false;
    m_bDoingAirAttackAnticipation = false;
    m_iCurrentAirAttack = 0;
    //return;    
}

simulated function MoveAndHitBlend(SPAnimGenericFunctionBlendNode Node)
{
    MoveAndHitBlendNative(Node);
    //return;    
}

// Export USPGriffonPawnPersistent::execMoveAndHitBlendNative(FFrame&, void* const)
native function MoveAndHitBlendNative(SPAnimGenericFunctionBlendNode Node);

simulated function name UberStateMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_resetAttackAnim)
    {
        bResetChildOut = 1;
        m_resetAttackAnim = false;
    }
    switch(m_currentUberState)
    {
        // End:0x2F
        case 1:
            return 'Announce';
        // End:0x3E
        case 2:
            return 'Challenge';
        // End:0x4D
        case 3:
            return 'dazed';
        // End:0x5C
        case 4:
            return 'MissedCharge';
        // End:0x80
        case 5:
            Node.m_overrideBlendTime = 0.2000000;
            return 'Turn';
        // End:0x8F
        case 6:
            return 'Taunt';
        // End:0x9E
        case 7:
            return 'KnockAway';
        // End:0xAD
        case 8:
            return 'ScreamAttack';
        // End:0xBC
        case 9:
            return 'CloseTheGap';
        // End:0xCB
        case 10:
            return 'CloseTheGapReared';
        // End:0xDA
        case 11:
            return 'CloseTheGapFar';
        // End:0xE9
        case 12:
            return 'CloseTheGapFarReared';
        // End:0xF8
        case 13:
            return 'ScreamAttackReared';
        // End:0x107
        case 14:
            return 'Backup';
        // End:0xFFFF
        default:
            return 'Default';
            break;
    }
    //return ReturnValue;    
}

simulated function name AerialHeadStateMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_currentUberState)
    {
        // End:0xFFFF
        default:
            return 'Default';
            break;
    }
    //return ReturnValue;    
}

simulated function name AerialWingStateMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_currentUberState)
    {
        // End:0xFFFF
        default:
            return 'Default';
            break;
    }
    //return ReturnValue;    
}

simulated function name IdleTypeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_resetIdleAnim)
    {
        bResetChildOut = 1;
        m_resetIdleAnim = false;
    }
    switch(m_currentIdleType)
    {
        // End:0x2F
        case 1:
            return 'PreAttackIdle';
        // End:0xFFFF
        default:
            return 'Default';
            break;
    }
    //return ReturnValue;    
}

function CGFinished()
{
    m_isDoingPounceAttack = false;
    m_isDoingHornAttack = false;
    // End:0x3C
    if(int(m_currentUberState) == int(9))
    {
        m_currentUberState = 0;
        MyController.HornAttackFinished();
    }
    //return;    
}

function CGRFinished()
{
    m_isDoingHornAttack = false;
    m_isDoingPounceAttack = false;
    // End:0x3C
    if(int(m_currentUberState) == int(10))
    {
        m_currentUberState = 0;
        MyController.HornAttackFinished();
    }
    //return;    
}

function CGFFinished()
{
    m_isDoingPounceAttack = false;
    m_isDoingHornAttack = false;
    // End:0x3C
    if(int(m_currentUberState) == int(11))
    {
        m_currentUberState = 0;
        MyController.HornAttackFinished();
    }
    //return;    
}

function CGFRFinished()
{
    m_isDoingPounceAttack = false;
    m_isDoingHornAttack = false;
    // End:0x3C
    if(int(m_currentUberState) == int(12))
    {
        m_currentUberState = 0;
        MyController.HornAttackFinished();
    }
    //return;    
}

function KnockAwayFinished()
{
    // End:0x2C
    if(int(m_currentUberState) == int(7))
    {
        m_currentUberState = 0;
        MyController.KnockAwayFinished();
    }
    //return;    
}

function AnnounceFinished()
{
    // End:0x2F
    if(int(m_currentUberState) == int(1))
    {
        m_currentUberState = 0;
        MyController.AnnounceFinished();        
    }
    //return;    
}

function ChallengeFinished()
{
    // End:0x2C
    if(int(m_currentUberState) == int(2))
    {
        m_currentUberState = 0;
        MyController.ChallengeFinished();
    }
    //return;    
}

function ScreamAttackFinished()
{
    // End:0x41
    if((int(m_currentUberState) == int(8)) || int(m_currentUberState) == int(13))
    {
        m_currentUberState = 0;
        MyController.ScreamAttackFinished();        
    }
    //return;    
}

function DazedFinished()
{
    // End:0x2C
    if(int(m_currentUberState) == int(3))
    {
        m_currentUberState = 0;
        MyController.DazedFinished();
    }
    //return;    
}

function MissedChargeFinished()
{
    // End:0x2C
    if(int(m_currentUberState) == int(4))
    {
        m_currentUberState = 0;
        MyController.MissedChargeFinished();
    }
    //return;    
}

function TauntFinished()
{
    // End:0x2C
    if(int(m_currentUberState) == int(6))
    {
        m_currentUberState = 0;
        MyController.TauntFinished();
    }
    //return;    
}

function BackupFinished()
{
    m_currentUberState = 0;
    MyController.BackupFinished();
    //return;    
}

function AttackPointTransitionFinished()
{
    MyController.AttackPointTransitionFinished();
    //return;    
}

function AttackPointHeadHitReactFinished()
{
    MyController.AttackPointHeadHitReactFinished();
    //return;    
}

function PrepareForNavPoint(NavigationPoint goal)
{
    // End:0x2C
    if(goal.IsA('VolumePathNode'))
    {
        bCanFly = true;
        SetMovementType(2);
    }
    SetMovementPhysics();
    super(SPPawn).PrepareForNavPoint(goal);
    //return;    
}

simulated function name PhysicsStateMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x28
    if((int(m_currentUberState) == int(7)) || m_bInTurnTowardsFocus)
    {
        return 'Default';        
    }
    else
    {
        // End:0x52
        if((int(m_eAttackPointTransitionMode) != int(0)) && !m_bWaitingForAttackPointOrientation)
        {
            return 'AttackPoint';            
        }
        else
        {
            // End:0x80
            if((m_bInAttackPointState && m_bAtAttackPoint) && !m_bWaitingForAttackPointOrientation)
            {
                return 'AttackPoint';                
            }
            else
            {
                // End:0x9D
                if(int(Physics) == int(8))
                {
                    return 'AnimBased';                    
                }
                else
                {
                    // End:0xBA
                    if(int(Physics) == int(4))
                    {
                        return 'Flying';                        
                    }
                    else
                    {
                        // End:0xD7
                        if(int(Physics) == int(2))
                        {
                            return 'Falling';                            
                        }
                        else
                        {
                            // End:0xF4
                            if(int(Physics) == int(7))
                            {
                                return 'Flying';                                
                            }
                            else
                            {
                                return 'Default';
                            }
                        }
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

simulated function name AttackPointMasterMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x1D
    if(int(m_eAttackPointTransitionMode) != int(0))
    {
        return 'AttackPointTransition';        
    }
    else
    {
        // End:0x6E
        if(((m_bInAttackPointState && m_bAtAttackPoint) && !m_bWaitingForAttackPointOrientation) && !m_bWaitingForHitReact)
        {
            // End:0x61
            if(m_bPlayingAttackPointAnimation)
            {
                return 'AttackPointAttack';                
            }
            else
            {
                return 'AttackPointIdle';
            }            
        }
        else
        {
            // End:0x84
            if(m_bWaitingForHitReact)
            {
                return 'AttackPointHitReaction';                
            }
            else
            {
                return 'AttackPointIdle';
            }
        }
    }
    //return ReturnValue;    
}

simulated function name AttackPointIdleMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local bool bAttackPointBlocked;

    bAttackPointBlocked = true;
    // End:0x22
    if(int(m_currentUberState) == int(8))
    {
        return 'ScreamAttack';
    }
    // End:0xBE
    if(m_CurrentAttackPoint != none)
    {
        // End:0x51
        if(m_CurrentAttackPoint.IsDestructibleDestroyed(m_CurrentAttackPointVolumeIndex))
        {
            bAttackPointBlocked = false;
        }
        bResetChildOut = 0;
        // End:0x92
        if(!bAttackPointBlocked)
        {
            m_LastAttackPointAnimName = m_CurrentAttackPoint.m_VolumeProperties[m_CurrentAttackPointVolumeIndex].m_AnimNameUnblockedIdle;
            return m_LastAttackPointAnimName;            
        }
        else
        {
            m_LastAttackPointAnimName = m_CurrentAttackPoint.m_VolumeProperties[m_CurrentAttackPointVolumeIndex].m_AnimNameBlockedIdle;
            return m_LastAttackPointAnimName;
        }
    }
    return m_LastAttackPointAnimName;
    //return ReturnValue;    
}

simulated function name AttackPointAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local bool bAttackPointBlocked;

    bAttackPointBlocked = true;
    // End:0xC0
    if(m_CurrentAttackPoint != none)
    {
        // End:0x37
        if(m_CurrentAttackPoint.IsDestructibleDestroyed(m_CurrentAttackPointVolumeIndex))
        {
            bAttackPointBlocked = false;
        }
        bResetChildOut = 0;
        // End:0x59
        if(m_bResetAttackPointAnimation)
        {
            bResetChildOut = 1;
            m_bResetAttackPointAnimation = false;            
        }
        else
        {
            bResetChildOut = 0;
        }
        // End:0x94
        if(!bAttackPointBlocked)
        {
            m_LastAttackPointAnimName = m_CurrentAttackPoint.m_VolumeProperties[m_CurrentAttackPointVolumeIndex].m_AnimNameAttack;            
        }
        else
        {
            m_LastAttackPointAnimName = m_CurrentAttackPoint.m_VolumeProperties[m_CurrentAttackPointVolumeIndex].m_AnimNameBlockedAttack;
        }
        return m_LastAttackPointAnimName;
    }
    return m_LastAttackPointAnimName;
    //return ReturnValue;    
}

// Export USPGriffonPawnPersistent::execAttackPointTableTransitionMCBNative(FFrame&, void* const)
native function name AttackPointTableTransitionMCBNative(SPAnimGenericFunctionMonitorNode Node);

simulated function name AttackPointTableTransitionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return AttackPointTableTransitionMCBNative(Node);
    //return ReturnValue;    
}

simulated function name AttackPointTransitionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_eAttackPointTransitionMode)
    {
        // End:0x22
        case 1:
            m_LastAttackPointTransitionAnimName = 'SideStepLeft';
            return m_LastAttackPointTransitionAnimName;
        // End:0x3C
        case 2:
            m_LastAttackPointTransitionAnimName = 'SideStepRight';
            return m_LastAttackPointTransitionAnimName;
        // End:0x50
        case 3:
            m_LastAttackPointTransitionAnimName = 'TableTransition';
        // End:0xFFFF
        default:
            return m_LastAttackPointTransitionAnimName;
            break;
    }
    //return ReturnValue;    
}

function AttackPointAnimationFinished()
{
    m_bPlayingAttackPointAnimation = false;
    m_bResetAttackPointAnimation = true;
    //return;    
}

event bool ShouldPushActor(Actor A)
{
    local bool bShouldPush;

    bShouldPush = super(SPPawn).ShouldPushActor(A);
    // End:0x52
    if(((bShouldPush == true) && Controller != none) && MyController != none)
    {
        return MyController.ShouldPushActor(A);
    }
    return false;
    //return ReturnValue;    
}

event ApplySonicDamage(Actor Victim)
{
    local float dmg;

    dmg = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.ScreamDamage);
    // End:0x54
    if((dmg < 1.0000000) && dmg > 0.0000000)
    {
        dmg = 1.0000000;
    }
    Victim.TakeDamageAndProcEffects(dmg, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'SPDamageTypeImpactGriffonScream');
    //return;    
}

event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
{
    // End:0x2F
    if(MyController != none)
    {
        return MyController.DoAttack(DamageType, SocketName, facingDamageDir);
    }
    return false;
    //return ReturnValue;    
}

function CATAttackFinished()
{
    m_RecordedDmg = 0.0000000;
    //return;    
}

simulated event StartFootStepEffects(FeetDown FeetDown, AnimNotify_Footstep.eFeetDownImpactStrength FeetDownImpactStrength, optional SPPhysicalMaterial DefaultPhysMat)
{
    local PlayerController PC;

    switch(FeetDownImpactStrength)
    {
        // End:0x78
        case 0:
            // End:0x74
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PandoraPlayerController(PC).PlayLocalizedShake(m_GriffonGDTuneData.LowFootstepEffects.ShakeParams, Location, m_GriffonGDTuneData.LowFootstepEffects.ShakeRadius);                
            }            
            // End:0x159
            break;
        // End:0xE7
        case 1:
            // End:0xE3
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PandoraPlayerController(PC).PlayLocalizedShake(m_GriffonGDTuneData.MediumFootstepEffects.ShakeParams, Location, m_GriffonGDTuneData.MediumFootstepEffects.ShakeRadius);                
            }            
            // End:0x159
            break;
        // End:0x156
        case 2:
            // End:0x152
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PandoraPlayerController(PC).PlayLocalizedShake(m_GriffonGDTuneData.HighFootstepEffects.ShakeParams, Location, m_GriffonGDTuneData.HighFootstepEffects.ShakeRadius);                
            }            
            // End:0x159
            break;
        // End:0xFFFF
        default:
            break;
    }
    super(SPPawn).StartFootStepEffects(FeetDown, FeetDownImpactStrength, DefaultPhysMat);
    //return;    
}

function CreateImpulse(float Impulse, float Radius, float ZOffset)
{
    local SPDImpulseActor impulseActor;
    local Vector pos;

    pos = Location;
    pos.Z -= ZOffset;
    impulseActor = Spawn(Class'SPDImpulseActor',,, pos);
    impulseActor.ImpulseComponent.ImpulseFalloff = 1;
    impulseActor.ImpulseComponent.ImpulseStrength = Impulse;
    impulseActor.ImpulseComponent.ImpulseRadius = Radius;
    impulseActor.delay = 0.0000000;
    impulseActor.Damage = 0;
    impulseActor.DamageRadius = 0.0000000;
    //return;    
}

function NewYawRotRateChild(SPAnimBlendByYawRotRate Node, name childName, int ChildIndex, float turnAmountInDegrees)
{
    // End:0x58
    if(m_isDoingHornAttack)
    {
        // End:0x4A
        if((m_neckAttackNameCurrent == 'None') || m_neckAttackNameCurrent == childName)
        {
            m_neckAttackNameCurrent = childName;
            m_neckAttackNameNext = 'None';            
        }
        else
        {
            m_neckAttackNameNext = childName;
        }        
    }
    else
    {
        m_neckAttackNameCurrent = childName;
        m_neckAttackNameNext = 'None';
    }
    //return;    
}

simulated function name ChooseMoveHitLocationCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local int Index;
    local name retval;

    retval = 'body';
    // End:0x1F
    if(m_resetAttackAnim)
    {
        bResetChildOut = 1;
    }
    // End:0x4E
    if(FindHitLocationGroupingByBoneName(m_lastDamagedBone, Index))
    {
        retval = m_hitLocationGroupings[Index].GroupName;
    }
    return retval;
    //return ReturnValue;    
}

simulated function name ChooseAttackHeightMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x10
    if(m_resetAttackAnim)
    {
        bResetChildOut = 1;
    }
    // End:0x49
    if((Controller != none) && Controller.GetEnemy().bIsCrouched)
    {
        return 'Short';
    }
    return 'Standard';
    //return ReturnValue;    
}

simulated function name ChooseAttackCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x10
    if(m_resetAttackAnim)
    {
        bResetChildOut = 1;
    }
    // End:0x2D
    if(m_neckAttackNameCurrent == 'None')
    {
        return 'Ahead';
    }
    return m_neckAttackNameCurrent;
    //return ReturnValue;    
}

simulated function name ChooseAttackSideMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local Vector deltaPos;
    local Rotator DeltaRot;
    local int yawAmount;
    local float yawAmountDegrees;
    local SPPlayerReplicationInfo repInfo;

    // End:0x19
    if(m_frontAttackDir != 'None')
    {
        return m_frontAttackDir;
    }
    // End:0x3D
    if((m_isDoingHornAttack == false) && m_isDoingPounceAttack == false)
    {
        return 'NotAttacking';
    }
    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x62
    if(repInfo == none)
    {
        return 'None';
    }
    // End:0x8C
    if(repInfo.EnemyPawn == none)
    {
        m_frontAttackDir = 'NotAttacking';
        return m_frontAttackDir;
    }
    deltaPos = repInfo.EnemyPawn.Location - Location;
    DeltaRot = Rotator(deltaPos);
    yawAmount = (DeltaRot.Yaw & 65535) - (Rotation.Yaw & 65535);
    yawAmount = NormalizeAngle(yawAmount);
    yawAmountDegrees = (float(yawAmount) * 360.0000000) / float(65536);
    // End:0x150
    if(yawAmountDegrees < -m_GriffonGDTuneData.HornAttackSlackSideAttackAngle)
    {
        m_frontAttackDir = 'AttackLeft';        
    }
    else
    {
        // End:0x17B
        if(yawAmountDegrees > m_GriffonGDTuneData.HornAttackSlackSideAttackAngle)
        {
            m_frontAttackDir = 'AttackRight';            
        }
        else
        {
            m_frontAttackDir = 'AttackCenter';
        }
    }
    return m_frontAttackDir;
    //return ReturnValue;    
}

simulated function SPPawn.EHSDamageDirectionType GetDamageDirection()
{
    return m_lastDamageDirectionType;
    //return ReturnValue;    
}

simulated function name KnockAwayMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x1D
    if(int(m_knockDirection) == int(1))
    {
        return 'Right';        
    }
    else
    {
        // End:0x37
        if(int(m_knockDirection) == int(0))
        {
            return 'Left';
        }
    }
    return 'Forward';
    //return ReturnValue;    
}

simulated function float MeleeAttackBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    childWeights[1] = 1.0000000;
    return 1.0000000;
    //return ReturnValue;    
}

simulated function name IsAttacking(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x1E
    if(m_isDoingHornAttack || m_isDoingPounceAttack)
    {
        return 'Attacking';
    }
    return 'NotAttacking';
    //return ReturnValue;    
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }

    simulated function SetMovementPhysics()
    {
        // End:0x16
        if(int(Physics) != int(10))
        {
            super(SPPawn).SetMovementPhysics();
        }
        //return;        
    }

    function StartDying()
    {
        // End:0x33
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 2.0000000;            
        }
        else
        {
            SetTimer(5.0000000, false);
        }
        SetCollision(true, false);
        // End:0x66
        if(MyController != none)
        {
            MyController.NotifyDying();            
        }
        else
        {
            // End:0x9F
            if(MyController != none)
            {
                // End:0x92
                if(MyController.bIsPlayer)
                {
                    DetachFromController();                    
                }
                else
                {
                    MyController.Destroy();
                }
            }
        }
        //return;        
    }

    function EndDying()
    {
        local int I;

        // End:0x4D
        if(MyController != none)
        {
            MyController.NotifyDied();
            // End:0x40
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x54:

        // End:0x99 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x8F
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x54;
        }
        //return;        
    }
Begin:

    HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    PawnDeathDestructiblePropertyCheck();
    StartDying();
    SetPhysics(2);
    SetUberState(0);
    m_bDying = true;
    DestroySonicCone();
    J0x4A:

    // End:0x65 [Loop If]
    if(int(m_hitReactionAnimState) != int(7))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x4A;
    }
    Mesh.bUpdateAnimTree = false;
    SetNovodexBoundingVolume(false);
    m_bEnablePhysicsPushing = false;
    EndDying();
    HandleBodyCleanup();
    stop;        
}
