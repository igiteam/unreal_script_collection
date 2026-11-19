class SPBaseWerewolfPawnPersistent extends SPPawn
    native
    nativereplication
    config(Game);

enum eMtlID
{
    eHair,                          // 0
    eHead,                          // 1
    eBody,                          // 2
    eHair2,                         // 3
    eMtlID_MAX                      // 4
};

enum eRecoverMode
{
    eRecoverMode_REGEN,             // 0
    eRecoverMode_MAX                // 1
};

enum eWerewolfActionState
{
    eActionNone,                    // 0
    eActionSwipe,                   // 1
    eActionBite,                    // 2
    eActionSmash,                   // 3
    eActionDefaultThrow,            // 4
    eActionRightSideThrow,          // 5
    eActionLeftSideThrow,           // 6
    eActionRightLowThrow,           // 7
    eActionLeftLowThrow,            // 8
    eActionLowThrow,                // 9
    eActionTacklePlayerTackle,      // 10
    eActionTacklePlayerAttack,      // 11
    eActionTacklePlayerGetUp,       // 12
    eActionKnockAway,               // 13
    eActionDodgeLeft,               // 14
    eActionDodgeRight,              // 15
    eActionDodgeBack,               // 16
    eActionBipedCloseDistance,      // 17
    eActionQuadripedCloseDistance,  // 18
    eActionKneeCloseDistance,       // 19
    eActionStandingSuperSwipe,      // 20
    eActionJumpingSuperSwipe,       // 21
    eActionHealRightArm,            // 22
    eActionHealLeftArm,             // 23
    eActionStartProtectHead,        // 24
    eActionCycleProtectHead,        // 25
    eActionEndProtectHead,          // 26
    eActionStaggerBack,             // 27
    eActionStaggerForward,          // 28
    eActionStaggerLeft,             // 29
    eActionStaggerRight,            // 30
    eActionMotorFront,              // 31
    eActionMotorBack,               // 32
    eActionGetupFront,              // 33
    eActionGetupBack,               // 34
    eActionHitAndRunAlignSwipeFront,// 35
    eActionHitAndRunAlignSwipeLeft, // 36
    eActionHitAndRunAlignSwipeRight,// 37
    eActionHARMinigameStart,        // 38
    eActionHARMinigameChain,        // 39
    eActionHARMinigameFinish,       // 40
    eActionBipedHitAndRun,          // 41
    eActionQuadripedHitAndRun,      // 42
    eActionOtherHitAndRun,          // 43
    eActionSuspend,                 // 44
    eActionEating,                  // 45
    eActionTacklePlayerKillshot,    // 46
    eActionTacklePlayerKillshotSuccess,// 47
    eActionTacklePlayerTackleFailed,// 48
    eActionTMGPlayerTakeDown,       // 49
    eActionTMGPlayerStage1Attack,   // 50
    eActionTMGPlayerStage2Choice,   // 51
    eActionTMGPlayerStage1PassKickedOff,// 52
    eActionTMGPlayerTransitionToStage2,// 53
    eActionTMGPlayerStage1Fail,     // 54
    eActionTMGPlayerStage2Attack,   // 55
    eActionTMGPlayerStage2Fail,     // 56
    eActionTMGPlayerGetUp,          // 57
    eActionTMGPlayerKillshot,       // 58
    eActionTMGPlayerKillshotSuccess,// 59
    eActionWallTest,                // 60
    eActionFrustration,             // 61
    eActionCharge,                  // 62
    eActionClubThrow,               // 63
    eActionSwipeTentacle,           // 64
    eActionNPCSwipe,                // 65
    eActionNPCLunge,                // 66
    eWerewolfActionState_MAX        // 67
};

enum EWerewolfHitAndRunAnimState
{
    eHARStateBegin,                 // 0
    eHARStateToQuad,                // 1
    eHARStateToBiped,               // 2
    eHARStateQuadDone,              // 3
    eHARStateBipedDone,             // 4
    EWerewolfHitAndRunAnimState_MAX // 5
};

enum EMoveStyle
{
    eWalk,                          // 0
    eJog,                           // 1
    eRun,                           // 2
    EMoveStyle_MAX                  // 3
};

enum EPATAState
{
    PATA_FixedAll,                  // 0
    PATA_FixedLower,                // 1
    PATA_MotorRagdoll,              // 2
    PATA_Floppy,                    // 3
    PATA_Recover,                   // 4
    PATA_None,                      // 5
    PATA_MAX                        // 6
};

enum EWerewolfDeathPosture
{
    ewdpDefault,                    // 0
    ewdpBiped,                      // 1
    ewdpQuadrupedStatic,            // 2
    ewdpQuadrupedMoving,            // 3
    EWerewolfDeathPosture_MAX       // 4
};

enum eWerewolfMeleeDodgeState
{
    eMeleeDodgeNone,                // 0
    eMeleeDodgeRight,               // 1
    eMeleeDodgeLeft,                // 2
    eWerewolfMeleeDodgeState_MAX    // 3
};

enum eWerewolfIdleState
{
    eIdleNormal,                    // 0
    eIdleSpecial,                   // 1
    eIdleTaunt,                     // 2
    eIdleHowl,                      // 3
    eWerewolfIdleState_MAX          // 4
};

enum eWerewolfStance
{
    eStanceQuadruped,               // 0
    eStanceBiped,                   // 1
    eWerewolfStance_MAX             // 2
};

enum eWerewolfAttackRange
{
    eRangeTooClose,                 // 0
    eRangeNear,                     // 1
    eRangeMedium,                   // 2
    eRangeFar,                      // 3
    eRangeNone,                     // 4
    eWerewolfAttackRange_MAX        // 5
};

enum eWerewolfEatingStage
{
    ewesEating,                     // 0
    ewesLookUp,                     // 1
    ewesLookAt,                     // 2
    ewesRestart,                    // 3
    eWerewolfEatingStage_MAX        // 4
};

enum eBoneFixingTraversal
{
    eSingleBone,                    // 0
    eRecursive,                     // 1
    eBoneFixingTraversal_MAX        // 2
};

enum eDodgeNetworkInfo
{
    eNetworkMeleeDodgeNone,         // 0
    eNetworkMeleeDodgeRight,        // 1
    eNetworkMeleeDodgeLeft,         // 2
    eNetworkMeleeDodgeRun,          // 3
    eDodgeNetworkInfo_MAX           // 4
};

enum ENetUnconciousState
{
    ENUS_UNCONSCIOUS,               // 0
    ENUS_MOTORGETUP,                // 1
    ENUS_CONSCIOUS,                 // 2
    ENUS_MAX                        // 3
};

enum UnfixActions
{
    UnfixActionAllChildren,         // 0
    UnfixActionAllChildrenButLeaves,// 1
    UnfixActionAllChildrenButSpecifiedBones,// 2
    UnfixActionSpecifiedBones,      // 3
    UnfixActions_MAX                // 4
};

struct native RuntimeConcentratedDamageInfo
{
    var bool bIsActive;
    var bool bAllowConcentratedReaction;
    var float lastHitTime;
    var float maxDamageInterval;
    var float concentratedDamagePercent;
    var float LastActiveTime;
    var float timeOutInterval;

    structdefaultproperties
    {
        bIsActive=false
        bAllowConcentratedReaction=false
        lastHitTime=0.0000000
        maxDamageInterval=0.0000000
        concentratedDamagePercent=0.0000000
        LastActiveTime=0.0000000
        timeOutInterval=0.0000000
    }
};

var private bool rightArmInjured;
var private bool leftArmInjured;
var bool m_bGetUpFromBack;
var bool m_bAIPreventDeath;
var bool m_bAIPreventHitReaction;
var bool bHasHead;
var bool m_bHasConcentratedArmDamage;
var bool m_bResurrectsIfHeadNotDestroyed;
var bool bProcessDynDamage;
var bool stanceForcedFromKismet;
var bool m_bResetAction;
var bool m_bResetUpperBody;
var bool m_bResetMeleeDodge;
var private bool m_bUseDodgeRun;
var bool m_resetDeathAnim;
var bool m_bRestartHitState;
var bool m_bPreRagDollTargettable;
var bool m_bIsPokeable;
var bool m_bUnconscious;
var bool m_bResetMinigameAction;
var bool m_bResetHitAndRunState;
var bool m_bIsInTMG;
var bool bPlayFrustration;
var bool m_bIsBiped;
var Vector MoveDir;
var int m_HeadHitPoints;
var int m_InitHeadHitPoints;
var int m_LastHeadHitPoints;
var float TickTime;
var int TickMode;
var SkeletalMesh smWWHeadless;
var Material mWWHeadlessMtl[3];
var SPEmitterSpawnable WWHeadParticleEmitter;
var ParticleSystem WWHeadParticleTemplate;
var ParticleSystem WWHeadParticleTemplateBloodHit;
var ParticleSystem WWHeadParticleTemplateDeathEnergy;
var ParticleSystem WWHeadParticleTemplateBloodSpout;
var ParticleSystem WWHeadParticleTemplateBloodDrip;
var array<SPEmitterSpawnable> m_SPEmitterArray;
var SoundCue HeadShotSound;
var SoundCue ArmBreakSound;
var SPTargetVolume HeadTargetVolume;
var class<KismetActorFactoryOverrideData> ActorFactoryOverrideClass;
var int m_activeWallAnimChannel;
var WallAnimChannelData m_wallAnimChannelData[2];
var class<DamageType> concentratedTorsoDamageType;
var int Cnt;
var Pawn LastInstigatedBy;
var array<SPBaseWerewolfPawnPersistent> Packmates;
var SPBaseWerewolfAIController PreRagdollController;
var SPPawn.EHSDamageDirectionType m_lastDamageDirectionType;
/** Variable Declaration */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var private SPBaseWerewolfPawnPersistent.eWerewolfActionState m_actionState;
var private SPBaseWerewolfPawnPersistent.eWerewolfActionState m_actionStateLast;
var private SPBaseWerewolfPawnPersistent.eWerewolfActionState m_actionStateLastNotNone;
var private SPBaseWerewolfPawnPersistent.eWerewolfMeleeDodgeState m_meleeDodgeState;
var private repnotify SPBaseWerewolfPawnPersistent.eDodgeNetworkInfo m_dodgeNetworkData;
var SPBaseWerewolfPawnPersistent.eWerewolfIdleState m_idleState;
var repnotify SPBaseWerewolfPawnPersistent.ENetUnconciousState m_NetUnconsciousState;
var Actor.EMinigameState m_minigameState;
var SPBaseWerewolfPawnPersistent.EWerewolfHitAndRunAnimState m_hitAndRunAnimState;
var SPBaseWerewolfPawnPersistent.eWerewolfEatingStage m_eatingStage;
var SPBaseWerewolfPawnPersistent.EWerewolfDeathPosture m_deathPosture;
var SPPawn.eKnockDirection m_knockDirection;
var class<DamageType> m_biteDamageType;
var class<DamageType> m_swipeDamageType;
var float m_noAccidentChecksBeforeThisTime;
var EmitterSpawnable ArmBreakEmitter;
var ParticleSystem ArmBreakParticleTemplate;
var array<DamageTypeConditionMatch> m_torsoDamageEvaluatorEntries;
var private repnotify int m_actionStateCount;
var name m_takeDamageBone;
var name m_animDamagedBone;
var class<DamageType> m_damageType;
var Vector m_damageMomentum;
var Vector m_hitLocation;
var export editinline SpriteComponent m_EmotionSpriteComponent;
var Texture2D m_DamageStateSprite[4];
var Texture2D m_DamageStateSpriteUnknown;
/** Name of the active forward movement stylevar   float m_FwdMoveSpeedPercent; Percentage of total speed for the active forward movement style */
var() name m_FwdMoveStyle;
var MaterialInstanceConstant headMaterialInst;
var MaterialInstanceConstant bodyMaterialInst;
var float currAlivePercent;
var float minAlivePercent;
var float dieTime;
var SkeletalMesh m_werewolfSkelMeshSwap;
var int m_iNumMaterials;
var float m_blendValueForMash1Animations;
var float m_blendValueForMash2Animations;
var transient array<RuntimeConcentratedDamageInfo> m_rtConcentratedDamageInfo;
var SPGameDifficultyTuneWerewolf m_WerewolfGDTuneData;
var SPAnimNodeSequence seqWallAnimationChannel1Idle;
var SPAnimNodeSequence seqWallAnimationChannel2Idle;
var SPAnimNodeSequence seqWallAnimationChannel1Single;
var SPAnimNodeSequence seqWallAnimationChannel2Single;
var SPAnimBlendDirectionalNode seqWallAnimationChannel1FourWay;
var SPAnimBlendDirectionalNode seqWallAnimationChannel2FourWay;

replication
{
    // Pos:0x000
    if(true
        m_bIsBiped;

    // Pos:0x001
    if(bReplicateMovement
        m_actionState;

    // Pos:0x007
    if(bNetDirty
        concentratedTorsoDamageType, leftArmInjured, 
        m_NetUnconsciousState, m_actionStateCount, 
        m_dodgeNetworkData, m_hitAndRunAnimState, 
        rightArmInjured;
}

// Export USPBaseWerewolfPawnPersistent::execWerewolfTestFn(FFrame&, void* const)
native function WerewolfTestFn();

// Export USPBaseWerewolfPawnPersistent::execUpdateRBBonesFromSpaceBases(FFrame&, void* const)
native function UpdateRBBonesFromSpaceBases();

// Export USPBaseWerewolfPawnPersistent::execGetCurrentRageLevelIndex(FFrame&, void* const)
native final function int GetCurrentRageLevelIndex();

// Export USPBaseWerewolfPawnPersistent::execIsHostileToPack(FFrame&, void* const)
native final function bool IsHostileToPack(Pawn P);

// Export USPBaseWerewolfPawnPersistent::execBreakpoint(FFrame&, void* const)
native function Breakpoint();

// Export USPBaseWerewolfPawnPersistent::execSPRegisterOrientation(FFrame&, void* const)
native function SPRegisterOrientation(SPAnimNodeSequence theNode, const out Rotator finalRotation, float StartTime, float endTime, bool bAdjustPlaybackRate, const out Vector pointToFace);

// Export USPBaseWerewolfPawnPersistent::execSPWalkFinished(FFrame&, void* const)
native function SPWalkFinished();

// Export USPBaseWerewolfPawnPersistent::execCanChangeSpeed(FFrame&, void* const)
native function bool CanChangeSpeed();

// Export USPBaseWerewolfPawnPersistent::execSetSpeedFromMoveStyle(FFrame&, void* const)
native final function SetSpeedFromMoveStyle();

// Export USPBaseWerewolfPawnPersistent::execGetMoveStyleFromVelocity(FFrame&, void* const)
native final function name GetMoveStyleFromVelocity();

// Export USPBaseWerewolfPawnPersistent::execSetMoveStyle(FFrame&, void* const)
native final function SetMoveStyle(name MoveStyleName);

// Export USPBaseWerewolfPawnPersistent::execPhysAnimBreakArm(FFrame&, void* const)
native final function bool PhysAnimBreakArm(array<name> affectedBoneNames, array<name> MotorNames, array<name> linearBoneSpringNames, array<name> angularBoneSpringNames);

// Export USPBaseWerewolfPawnPersistent::execPhysAnimHealArm(FFrame&, void* const)
native final function bool PhysAnimHealArm(array<name> affectedBoneNames);

simulated function DBG_MsgWP(string Str)
{
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

function DBG_WPMsg(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

final simulated function SPBaseWerewolfPawnPersistent.eWerewolfActionState GetRagdollIntoAnimTransitionAction(bool bOnBack)
{
    // End:0x0F
    if(bOnBack)
    {
        return 32;        
    }
    else
    {
        return 31;
    }
    //return ReturnValue;    
}

final simulated function SPBaseWerewolfPawnPersistent.eWerewolfActionState GetRagdollIntoAnimGetUpAction(bool bOnBack)
{
    // End:0x0F
    if(bOnBack)
    {
        return 34;        
    }
    else
    {
        return 33;
    }
    //return ReturnValue;    
}

simulated function InitFromTuneData()
{
    local int I, Count;

    m_HeadHitPoints = int((m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HitPoints) * m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HeadHealthPercent)) / 100.0000000);
    m_InitHeadHitPoints = m_HeadHitPoints;
    Count = 0;
    I = 0;
    J0x70:

    // End:0x143 [Loop If]
    if(I < m_WerewolfGDTuneData.StaggerInfo.Length)
    {
        // End:0x139
        if(m_WerewolfGDTuneData.StaggerInfo[I].EvaluatorCondition != -1)
        {
            m_torsoDamageEvaluatorEntries.Length = m_torsoDamageEvaluatorEntries.Length + 1;
            m_torsoDamageEvaluatorEntries[Count].DamageTypeClass = m_WerewolfGDTuneData.StaggerInfo[I].DamageTypeClass;
            m_torsoDamageEvaluatorEntries[Count].Condition = m_WerewolfGDTuneData.StaggerInfo[I].EvaluatorCondition;
            Count++;
        }
        I++;
        // [Loop Continue]
        goto J0x70;
    }
    I = 0;
    J0x14A:

    // End:0x21D [Loop If]
    if(I < m_WerewolfGDTuneData.KnockBackInfo.Length)
    {
        // End:0x213
        if(m_WerewolfGDTuneData.KnockBackInfo[I].EvaluatorCondition != -1)
        {
            m_torsoDamageEvaluatorEntries.Length = m_torsoDamageEvaluatorEntries.Length + 1;
            m_torsoDamageEvaluatorEntries[Count].DamageTypeClass = m_WerewolfGDTuneData.KnockBackInfo[I].DamageTypeClass;
            m_torsoDamageEvaluatorEntries[Count].Condition = m_WerewolfGDTuneData.KnockBackInfo[I].EvaluatorCondition;
            Count++;
        }
        I++;
        // [Loop Continue]
        goto J0x14A;
    }
    m_torsoDamageEvaluatorEntries.Length = m_torsoDamageEvaluatorEntries.Length + 1;
    m_torsoDamageEvaluatorEntries[Count].DamageTypeClass = none;
    m_torsoDamageEvaluatorEntries[Count].Condition = -1;
    //return;    
}

simulated event SPGameDifficultyTuneWerewolf GetWerewolfDifficultyData()
{
    // End:0x20
    if(m_WerewolfGDTuneData == none)
    {
        m_WerewolfGDTuneData = SPGameDifficultyTuneWerewolf(GetMyGDData());
    }
    return m_WerewolfGDTuneData;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTuneWerewolf();
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    GetWerewolfDifficultyData();
    InitFromTuneData();
    //return;    
}

simulated function InitDamage()
{
    InitDynDamageSystem();
    //return;    
}

simulated function PostBeginPlay()
{
    SetupResurrectionEffect();
    InitFadeMaterials();
    // End:0x23
    if(bProcessDynDamage)
    {
        InitDamage();
    }
    SetRegenRate(999999.0000000);
    // End:0x58
    if(int(Role) <= int(ROLE_SimulatedProxy))
    {
        RotationRate.Yaw = 80000;
    }
    super.PostBeginPlay();
    CacheAnimNodePointers();
    //return;    
}

simulated function CacheAnimNodePointers()
{
    seqWallAnimationChannel1Idle = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('WallAnimationChannel1Idle'));
    // End:0x39
    if(seqWallAnimationChannel1Idle == none)
    {
    }
    seqWallAnimationChannel2Idle = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('WallAnimationChannel2Idle'));
    // End:0x72
    if(seqWallAnimationChannel1Idle == none)
    {
    }
    seqWallAnimationChannel1Single = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('WallAnimationChannel1Single'));
    // End:0xAB
    if(seqWallAnimationChannel1Idle == none)
    {
    }
    seqWallAnimationChannel2Single = SPAnimNodeSequence(Mesh.Animations.FindAnimNode('WallAnimationChannel2Single'));
    // End:0xE4
    if(seqWallAnimationChannel1Idle == none)
    {
    }
    seqWallAnimationChannel1FourWay = SPAnimBlendDirectionalNode(Mesh.Animations.FindAnimNode('WallAnimationChannel1FourWay'));
    // End:0x11D
    if(seqWallAnimationChannel1Idle == none)
    {
    }
    seqWallAnimationChannel2FourWay = SPAnimBlendDirectionalNode(Mesh.Animations.FindAnimNode('WallAnimationChannel2FourWay'));
    // End:0x156
    if(seqWallAnimationChannel1Idle == none)
    {
    }
    //return;    
}

event ParseKismetActorFactoryOverrideParameters(KismetActorFactoryOverrideData overrideData)
{
    local WerewolfKismetActorFactoryOverrideData wwOverrideData;

    super.ParseKismetActorFactoryOverrideParameters(overrideData);
    wwOverrideData = WerewolfKismetActorFactoryOverrideData(overrideData);
    // End:0xB3
    if(wwOverrideData != none)
    {
        // End:0x87
        if(wwOverrideData.bOverrideHeadHealthPercent)
        {
            // End:0x87
            if(wwOverrideData.HeadHealthPercent > 0.0000000)
            {
                m_HeadHitPoints = int(float(Health) * (wwOverrideData.HeadHealthPercent * 0.0100000));
                m_InitHeadHitPoints = m_HeadHitPoints;                
            }
        }
        // End:0xB3
        if(wwOverrideData.bOverrideHealth)
        {
            // End:0xB3
            if(Health > 0)
            {
                HealthMax = Health;                
            }
        }
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    ServerTick_SPBaseWerewolfPawnPersistent(DeltaTime);
    super.Tick(DeltaTime);
    //return;    
}

final k2override function ServerTick_SPBaseWerewolfPawnPersistent(float DeltaTime)
{
    local Vector HeadLoc;
    local Rotator HeadRot;

    // End:0x53
    if(HeadTargetVolume != none)
    {
        Mesh.GetSocketWorldLocationAndRotation('head', HeadLoc, HeadRot);
        HeadTargetVolume.SetLocation(HeadLoc);
        HeadTargetVolume.SetRotation(HeadRot);
    }
    // End:0x6F
    if(GetStateName() == 'Dying')
    {
        UpdateResurrectionEffects(DeltaTime);
    }
    SetEmotionIcon(GetAngerLevel());
    SetBrokenArmData();
    //return;    
}

final function SetBrokenArmData()
{
    // End:0x28
    if(IsConcentratedDamageActive(1) && int(GetActionState()) != int(23))
    {
        leftArmInjured = true;        
    }
    else
    {
        leftArmInjured = false;
    }
    // End:0x58
    if(IsConcentratedDamageActive(0) && int(GetActionState()) != int(22))
    {
        rightArmInjured = true;        
    }
    else
    {
        rightArmInjured = false;
    }
    //return;    
}

final function UpdateResurrectionEffects(float DeltaTime)
{
    local float deathAmountPerSecond, deathAmountThisTick;

    deathAmountPerSecond = (1.0000000 - minAlivePercent) / dieTime;
    deathAmountThisTick = deathAmountPerSecond * DeltaTime;
    currAlivePercent -= deathAmountThisTick;
    // End:0x51
    if(currAlivePercent < minAlivePercent)
    {
        currAlivePercent = minAlivePercent;
    }
    headMaterialInst.SetScalarParameterValue('HeadTextureSwitch', currAlivePercent);
    bodyMaterialInst.SetScalarParameterValue('BodyTextureSwitch', currAlivePercent);
    //return;    
}

final function int FindHeadMaterial()
{
    local int I;
    local float OutVal;

    // End:0x8E
    if(CurSkelMeshComponent != none)
    {
        I = 0;
        J0x12:

        // End:0x8E [Loop If]
        if(I < CurSkelMeshComponent.Materials.Length)
        {
            // End:0x84
            if((CurSkelMeshComponent.Materials[I] != none) && CurSkelMeshComponent.Materials[I].GetScalarParameterValue('HeadTextureSwitch', OutVal))
            {
                return I;
            }
            I++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    return -1;
    //return ReturnValue;    
}

final function int FindBodyMaterial()
{
    local int I;
    local float OutVal;

    // End:0x8E
    if(CurSkelMeshComponent != none)
    {
        I = 0;
        J0x12:

        // End:0x8E [Loop If]
        if(I < CurSkelMeshComponent.Materials.Length)
        {
            // End:0x84
            if((CurSkelMeshComponent.Materials[I] != none) && CurSkelMeshComponent.Materials[I].GetScalarParameterValue('BodyTextureSwitch', OutVal))
            {
                return I;
            }
            I++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    return -1;
    //return ReturnValue;    
}

final function SetupResurrectionEffect()
{
    local int MtlIDHead, MtlIDBody;

    MtlIDHead = FindHeadMaterial();
    MtlIDBody = FindBodyMaterial();
    // End:0x8D
    if(headMaterialInst == none)
    {
        headMaterialInst = new (none) Class'Engine.MaterialInstanceConstant';
        // End:0x8D
        if(MtlIDHead != -1)
        {
            headMaterialInst.SetParent(Mesh.GetMaterial(MtlIDHead));
            Mesh.SetMaterial(MtlIDHead, headMaterialInst);
        }
    }
    // End:0x102
    if(bodyMaterialInst == none)
    {
        bodyMaterialInst = new (none) Class'Engine.MaterialInstanceConstant';
        // End:0x102
        if(MtlIDBody != -1)
        {
            bodyMaterialInst.SetParent(Mesh.GetMaterial(MtlIDBody));
            Mesh.SetMaterial(MtlIDBody, bodyMaterialInst);
        }
    }
    //return;    
}

final function SetEmotionIcon(float AngerLevel)
{
    local int SpriteIdx;

    // End:0x2D
    if(m_EmotionSpriteComponent != none)
    {
        m_EmotionSpriteComponent.SetHidden(!WorldInfo.SPShowEmotion);
    }
    // End:0x6C
    if((AngerLevel > float(1)) || AngerLevel < float(0))
    {
        // End:0x69
        if(m_EmotionSpriteComponent != none)
        {
            m_EmotionSpriteComponent.Sprite = m_DamageStateSpriteUnknown;
        }        
    }
    else
    {
        SpriteIdx = int((AngerLevel * float(3)) + 0.5000000);
        // End:0xC7
        if(m_EmotionSpriteComponent != none)
        {
            m_EmotionSpriteComponent.Sprite = m_DamageStateSprite[SpriteIdx];
            m_EmotionSpriteComponent.Sprite = m_DamageStateSprite[SpriteIdx];
        }
    }
    //return;    
}

final simulated event float GetAngerLevel()
{
    return 1.0000000 - (float(Health) / float(HealthMax));
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

final simulated function bool ShouldHeadBeDestroyed(float DamageAmount, Controller EventInstigator, class<DamageType> DamageType, name hitBoneName)
{
    local bool bIsExplosiveDamage, bIsFireDamage;
    local name hitLocationGroupName;
    local bool bDamagedByPlayer, bStraightToDeath, bPulseDamage, bFireAxeDamage;

    // End:0x0B
    if(m_bAIPreventDeath)
    {
        return false;
    }
    // End:0x1A
    if(InGodMode())
    {
        return false;
    }
    bIsExplosiveDamage = ClassIsChildOf(DamageType, Class'SPDamageTypeExplosionAny');
    bDamagedByPlayer = ((EventInstigator != none) && EventInstigator.Pawn != none) && EventInstigator.Pawn.IsA('PlayerPawn');
    bStraightToDeath = (((int(Physics) == int(8)) || !GetAIAnimControl()) || !bDamagedByPlayer) || bIsExplosiveDamage;
    // End:0xE6
    if(bDamagedByPlayer)
    {
        // End:0xE6
        if(PlayerPawn(EventInstigator.Pawn).GetFireAxeSuperHit())
        {
            return true;
        }
    }
    // End:0x104
    if(WorldInfo.m_bOneHitKillWerewolf)
    {
        // End:0x104
        if(bDamagedByPlayer)
        {
            return true;
        }
    }
    bIsFireDamage = ClassIsChildOf(DamageType, Class'SPDamageTypeImpactFlame');
    bPulseDamage = ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse') || ClassIsChildOf(DamageType, Class'SPDamageTypeExplosionFireDrakeImmolate');
    hitLocationGroupName = GetHitLocationGroup(hitBoneName);
    bFireAxeDamage = DamageType == Class'SPDamageTypeImpactFireAxeSwing';
    // End:0x255
    if(((hitLocationGroupName == 'head') && !bStraightToDeath) && !bPulseDamage)
    {
        // End:0x239
        if(m_bUnconscious)
        {
            // End:0x236
            if((EventInstigator.Pawn != none) && (m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.GroundHeadDist) <= 0.0000000) || VSize(Location - EventInstigator.Pawn.Location) < m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.GroundHeadDist))
            {
                m_HeadHitPoints -= int(DamageAmount);
            }            
        }
        else
        {
            // End:0x252
            if(!bFireAxeDamage)
            {
                m_HeadHitPoints -= int(DamageAmount);
            }
        }        
    }
    else
    {
        // End:0x281
        if(bStraightToDeath)
        {
            // End:0x27E
            if(m_bUnconscious || WillDamageMakeUsUnconscious(DamageAmount))
            {
                m_HeadHitPoints = 0;
            }            
        }
        else
        {
            // End:0x2B0
            if(bIsFireDamage)
            {
                m_HeadHitPoints -= int(DamageAmount);
                // End:0x2AD
                if(WillDamageMakeUsUnconscious(DamageAmount))
                {
                    m_HeadHitPoints = 0;
                }                
            }
            else
            {
                // End:0x2C9
                if(bPulseDamage)
                {
                    // End:0x2C9
                    if(m_bUnconscious)
                    {
                        m_HeadHitPoints = 0;
                    }
                }
            }
        }
    }
    return m_HeadHitPoints <= 0;
    //return ReturnValue;    
}

final function DetachHeadBone()
{
    Mesh.SkeletalMesh = m_werewolfSkelMeshSwap;
    //return;    
}

final function bool PerformArmBreak(bool bRightArm)
{
    local Vector pos;
    local Rotator Rot;
    local name SocketName;

    // End:0x1DF
    if(!m_bUnconscious && (int(m_PhysAnimState) == int(0)) || int(m_PhysAnimState) == int(1))
    {
        // End:0x93
        if(bRightArm)
        {
            SocketName = 'ArmBreakR';
            // End:0x90
            if(!PhysAnimBreakArm(m_WerewolfGDTuneData.RightArmBreakBoneNames, m_WerewolfGDTuneData.RightArmBreakMotorNames, m_WerewolfGDTuneData.RightArmBreakLinearBoneSprings, m_WerewolfGDTuneData.RightArmBreakAngularBoneSprings))
            {
                return false;
            }            
        }
        else
        {
            SocketName = 'ArmBreakL';
            // End:0xEB
            if(!PhysAnimBreakArm(m_WerewolfGDTuneData.LeftArmBreakBoneNames, m_WerewolfGDTuneData.LeftArmBreakMotorNames, m_WerewolfGDTuneData.LeftArmBreakLinearBoneSprings, m_WerewolfGDTuneData.LeftArmBreakAngularBoneSprings))
            {
                return false;
            }
        }
        // End:0x1CD
        if(ArmBreakParticleTemplate != none)
        {
            // End:0x1CD
            if(Mesh.GetSocketWorldLocationAndRotation(SocketName, pos, Rot))
            {
                ArmBreakEmitter = Spawn(Class'Engine.EmitterSpawnable',,, pos, Rot);
                ArmBreakEmitter.SetTemplate(ArmBreakParticleTemplate, true);
                ArmBreakEmitter.bDestroyOnSystemFinish = true;
                ArmBreakEmitter.SetBase(self, vect(1.0000000, 0.0000000, 0.0000000), Mesh, SocketName, true);
                ArmBreakEmitter.SetOwner(self);
                ArmBreakEmitter.ParticleSystemComponent.ActivateSystem();
                ArmBreakEmitter.bKillDuringLevelTransition = true;
            }
        }
        PlaySound(ArmBreakSound);
        return true;
    }
    return false;
    //return ReturnValue;    
}

final function PerformArmHeal(bool bRightArm)
{
    PhysAnimSetAllBonesAIControl(false, true);
    // End:0x6D
    if(!m_bUnconscious && (int(m_PhysAnimState) == int(0)) || int(m_PhysAnimState) == int(1))
    {
        // End:0x58
        if(bRightArm)
        {
            PhysAnimHealArm(m_WerewolfGDTuneData.RightArmBreakBoneNames);            
        }
        else
        {
            PhysAnimHealArm(m_WerewolfGDTuneData.LeftArmBreakBoneNames);
        }
    }
    //return;    
}

simulated function AttemptHitReaction(Pawn instigatingPawn)
{
    // End:0x0B
    if(m_bAIPreventHitReaction)
    {
        return;
    }
    // End:0x18
    if(!m_bIsPokeable)
    {
        return;
    }
    // End:0x60
    if(((ClassIsChildOf(m_damageType, Class'SPDamageTypeImpactFlame') || ClassIsChildOf(m_damageType, Class'SPDamageTypeRigidBody')) || ClassIsChildOf(m_damageType, Class'SPDamageTypeAnimusPulse')) || ClassIsChildOf(m_damageType, Class'SPDamageTypeExplosionFireDrakeImmolate'))
    {
        return;
    }
    AttemptPhysAnimState_Poking(instigatingPawn, false);
    //return;    
}

final function CreateHeadTargetVolume()
{
    local Vector HeadLoc;
    local Rotator HeadRot;

    // End:0x75
    if((HeadTargetVolume == none) && Mesh != none)
    {
        Mesh.GetSocketWorldLocationAndRotation('head', HeadLoc, HeadRot);
        HeadTargetVolume = Spawn(Class'SPTargetVolume', self,, HeadLoc, HeadRot);
        HeadTargetVolume.__OnTookDamage__Delegate = ProcHeadDamage;
    }
    //return;    
}

final function CleanUpHeadTargetVolume()
{
    // End:0x1F
    if(HeadTargetVolume != none)
    {
        HeadTargetVolume.Destroy();
        HeadTargetVolume = none;
    }
    //return;    
}

// Export USPBaseWerewolfPawnPersistent::execGetShotTargetOnBody(FFrame&, void* const)
native simulated function Vector GetShotTargetOnBody(optional Actor RequestedBy);

final simulated function DetermineDeathPosture()
{
    local Vector N;

    m_deathPosture = 0;
    // End:0x1C
    if(IsBiped())
    {
        m_deathPosture = 1;        
    }
    else
    {
        // End:0x3C
        if(VSizeSq(m_amortizedVelocity) > 10.0000000)
        {
            m_deathPosture = 3;            
        }
        else
        {
            m_deathPosture = 2;
        }
    }
    m_localVelocityAngle = ComputeLocalVelocityAngle();
    N = Normal(m_damageMomentum);
    m_hitDirectionAngle = ComputeLocalHitDirectionAngle(N, m_hitLocation, LastInstigatedBy);
    m_deathDamageType = m_damageType;
    m_deathDistFromImpact = m_lastDistFromImpact;
    //return;    
}

final simulated function GoUnconscious()
{
    // End:0x1D
    if(m_bUnconscious && int(Role) >= int(ROLE_Authority))
    {
        return;
    }
    DetermineDeathPosture();
    GotoState('Unconscious');
    //return;    
}

simulated function bool CanPawnUsePhysAnimStateAnimIntoRagdoll()
{
    // End:0x13
    if(int(GetActionState()) == int(21))
    {
        return false;
    }
    return super.CanPawnUsePhysAnimStateAnimIntoRagdoll();
    //return ReturnValue;    
}

simulated function StartTransitionAnimationForRagdollIntoAnim()
{
    //return;    
}

simulated function StartGetUpAnimationForRagdollIntoAnim()
{
    //return;    
}

simulated function RagdollInToAnimFinished()
{
    //return;    
}

simulated function StartRagdollToAnim()
{
    //return;    
}

function ProcHeadDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
    //return;    
}

final simulated function bool WillDamageMakeUsUnconscious(float DamageAmount)
{
    return float(Health) <= (DamageAmount + float(1));
    //return ReturnValue;    
}

simulated function RecordDamageInformation(Pawn DamageInstigator, class<DamageType> DamageType, Vector HitLocation, Vector Momentum, name BoneName)
{
    m_takeDamageBone = BoneName;
    m_damageType = DamageType;
    m_damageMomentum = Momentum;
    m_hitLocation = HitLocation;
    LastInstigatedBy = DamageInstigator;
    //return;    
}

simulated event ProcEffects(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SPPawn instigatingPawn;

    RecordDamageInformation(DamageInstigator, DamageType, HitLocation, Momentum, HitInfo.BoneName);
    // End:0x82
    if((DamageInstigator != none) && DamageInstigator.IsA('PlayerPawn'))
    {
        ProcDynDamage(DamageAmount, DamageInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    // End:0xA1
    if(!m_bDiedWhileSpidering)
    {
        m_bDiedWhileSpidering = int(Physics) == int(8);
    }
    // End:0xBC
    if(DamageInstigator != none)
    {
        instigatingPawn = SPPawn(DamageInstigator);
    }
    AttemptHitReaction(instigatingPawn);
    super(Actor).ProcEffects(DamageAmount, DamageInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SPBaseWerewolfAIController wwController;
    local Pawn InstigatorPawn;

    wwController = SPBaseWerewolfAIController(Controller);
    // End:0x34
    if((wwController != none) && wwController.bTMGGodMode)
    {
        return;
    }
    // End:0x7E
    if(EventInstigator != none)
    {
        // End:0x66
        if(wwController != none)
        {
            wwController.ApplyDamageToTargetTable(EventInstigator, DamageAmount);
        }
        InstigatorPawn = EventInstigator.Pawn;        
    }
    // End:0xB0
    if(m_bAIPreventDeath && (float(Health) - DamageAmount) <= float(1))
    {
        DamageAmount = float(Health - 2);
    }
    RecordDamageInformation(InstigatorPawn, DamageType, HitLocation, Momentum, HitInfo.BoneName);
    // End:0x189
    if(m_bResurrectsIfHeadNotDestroyed)
    {
        // End:0x13D
        if(ShouldHeadBeDestroyed(DamageAmount, EventInstigator, DamageType, HitInfo.BoneName))
        {
            Died(EventInstigator, DamageType, HitLocation);
            Health = int(DamageAmount - float(1));            
        }
        else
        {
            // End:0x189
            if(WillDamageMakeUsUnconscious(DamageAmount))
            {
                // End:0x189
                if(int(WorldInfo.NetMode) == int(NM_Standalone))
                {
                    Health = int(DamageAmount + float(2));
                    // End:0x189
                    if(!m_bUnconscious)
                    {
                        GoUnconscious();
                    }
                }
            }
        }
    }
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function PrepareForNavPoint(NavigationPoint goal)
{
    // End:0x2E
    if((m_wallMovementData.ReachSpec != none) && m_wallMovementData.bDoingMove)
    {
        return;
    }
    SetWalkMovementType(IsBiped());
    super.PrepareForNavPoint(goal);
    //return;    
}

final simulated function int GetFreeWallAnimationChannel()
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

final simulated function SetSingleWallAnimation(SPAnimNodeSequence Seq, name AnimName)
{
    // End:0x9F
    if((Mesh != none) && Mesh.Animations != none)
    {
        m_wallRegistrationNode = Seq;
        // End:0x9F
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

final simulated function WallAnimationChannel1SingleAnimFinished()
{
    // End:0x65
    if((m_activeWallAnimChannel == 0) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            // End:0x5D
            if(!m_bArrivedAtWallDestination)
            {
            }
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

final simulated function WallAnimationChannel2SingleAnimFinished()
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

final simulated function SetFourWayWallAnimation(SPAnimBlendDirectionalNode fourWayNode, name forwardName, name backwardName, name leftName, name rightName)
{
    local AnimNodeSequence Seq;

    // End:0x196
    if((Mesh != none) && Mesh.Animations != none)
    {
        // End:0x176
        if(fourWayNode != none)
        {
            Seq = AnimNodeSequence(fourWayNode.Children[0].Anim);
            // End:0x79
            if(Seq != none)
            {
                Seq.SetAnim(forwardName, false);
            }
            // End:0x176
            if(fourWayNode.Children.Length >= 4)
            {
                Seq = AnimNodeSequence(fourWayNode.Children[1].Anim);
                // End:0xDC
                if(Seq != none)
                {
                    Seq.SetAnim(backwardName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[2].Anim);
                // End:0x129
                if(Seq != none)
                {
                    Seq.SetAnim(leftName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[3].Anim);
                // End:0x176
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

    SetActionState(0);
    SetSpiderMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    m_wallMovementData.bExecutingTransition = true;
    // End:0x120
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
        // End:0x10E
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallAnimation(seqWallAnimationChannel1Single, transName);            
        }
        else
        {
            SetSingleWallAnimation(seqWallAnimationChannel2Single, transName);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function StartWallMovementAnimations()
{
    local SPAWallAnimation wallData;

    SetActionState(0);
    SetSpiderMovementType();
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
    // End:0x110
    if(m_activeWallAnimChannel == 0)
    {
        // End:0xC6
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation(seqWallAnimationChannel1Single, wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation(seqWallAnimationChannel1FourWay, wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }        
    }
    else
    {
        // End:0x141
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation(seqWallAnimationChannel2Single, wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation(seqWallAnimationChannel2FourWay, wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }
    }
    //return;    
}

final simulated function SetSingleWallIdleAnimation(SPAnimNodeSequence Seq, name AnimName)
{
    // End:0x67
    if((Mesh != none) && Mesh.Animations != none)
    {
        // End:0x67
        if(Seq != none)
        {
            Seq.SetAnim(AnimName, false);
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'IdleAnim';
        }
    }
    //return;    
}

simulated event StopWallMovementAnimation()
{
    // End:0x86
    if(!m_wallMovementData.bIsSingleAnim && m_wallMovementData.wallAnimData != none)
    {
        // End:0x61
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallIdleAnimation(seqWallAnimationChannel1Idle, m_wallMovementData.wallAnimData.IdleAnimation);            
        }
        else
        {
            SetSingleWallIdleAnimation(seqWallAnimationChannel2Idle, m_wallMovementData.wallAnimData.IdleAnimation);
        }
    }
    //return;    
}

final simulated function name WallAnimationChannelSelectMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
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

final simulated function name WallAnimationChannel1MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[0].MCBName;
    //return ReturnValue;    
}

final simulated function name WallAnimationChannel2MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[1].MCBName;
    //return ReturnValue;    
}

event PrepareForBase(Actor NewBase)
{
    // End:0x44
    if(((NewBase != none) && !NewBase.bWorldGeometry) && int(Physics) == int(8))
    {
        SetWalkMovementType(IsBiped());
    }
    //return;    
}

event Notify_Killshot()
{
    SPBaseWerewolfAIController(Controller).Notify_Killshot();
    //return;    
}

event Notify_HeadBlownOff()
{
    SPBaseWerewolfAIController(Controller).Notify_HeadBlownOff();
    //return;    
}

event Notify_GetUpEnded()
{
    SPBaseWerewolfAIController(Controller).Notify_GetUpEnded();
    //return;    
}

event Notify_KillshotWeaponFX()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFX();
    //return;    
}

event Notify_KillshotWeaponFXBloodHitShotA()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFXFireParticleSystem(WWHeadParticleTemplateBloodHit, 0);
    //return;    
}

event Notify_KillshotWeaponFXBloodHitShotB()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFXFireParticleSystem(WWHeadParticleTemplateBloodHit, 1);
    //return;    
}

event Notify_KillshotWeaponFXBloodHitShotC()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFXFireParticleSystem(WWHeadParticleTemplateBloodHit, 2);
    //return;    
}

event Notify_KillshotWeaponFXDeathEnergy()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFXFireParticleSystem(WWHeadParticleTemplateDeathEnergy, 3);
    //return;    
}

event Notify_KillshotWeaponFXBloodSpout()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFXFireParticleSystem(WWHeadParticleTemplateBloodSpout, 3);
    //return;    
}

event Notify_KillshotWeaponFXBloodDrip()
{
    SPBaseWerewolfAIController(Controller).Notify_KillshotWeaponFXFireParticleSystem(WWHeadParticleTemplateBloodDrip, 4);
    //return;    
}

function int SpecialCost(ReachSpec Path)
{
    local SPWallReachSpec wallReach;

    wallReach = SPWallReachSpec(Path);
    // End:0x3F
    if(wallReach != none)
    {
        return int(-float(Path.Distance * FavorWallPercentage) * 100.0000000);
    }
    return 0;
    //return ReturnValue;    
}

final simulated event HealArmFinished()
{
    local SPBaseWerewolfAIController MyController;

    PhysAnimSetAllBonesAIControl(false, true);
    // End:0x2C
    if(!m_bUnconscious && int(m_PhysAnimState) == int(0))
    {
        AttemptPhysAnimState_Fixed(true);
    }
    // End:0x62
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x62
        if(MyController != none)
        {
            MyController.super(SPBaseWerewolfPawnPersistent).HealArmFinished();
        }
    }
    //return;    
}

simulated event AttackAnimFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x36
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x36
        if(MyController != none)
        {
            MyController.super(SPBaseWerewolfAIController).AttackAnimFinished();
        }
    }
    //return;    
}

simulated function ClearAction(optional bool bRestart)
{
    SetAnimActionState(0, bRestart);
    //return;    
}

simulated function int GetTMGFOV()
{
    return 85;
    //return ReturnValue;    
}

simulated function ActionFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.ActionFinished();
        }
    }
    //return;    
}

final simulated function MeleeAttackFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.MeleeAttackFinished();
        }
    }
    //return;    
}

final simulated function MeleeDodgeFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.MeleeDodgeFinished();
        }
    }
    //return;    
}

final simulated function UpperBodyActionFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x36
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x36
        if(MyController != none)
        {
            MyController.super(SPBaseWerewolfPawnPersistent).UpperBodyActionFinished();
        }
    }
    //return;    
}

final simulated function StaggerBackFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.StaggerBackFinished();
        }
    }
    //return;    
}

final simulated function AnticipationFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.AnticipationFinished();
        }
    }
    //return;    
}

final simulated function ReactionFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.ReactionFinished();
        }
    }
    //return;    
}

event bool ArrivedAtMoveTarget()
{
    return true;
    //return ReturnValue;    
}

final simulated function name DeathPostureMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_resetDeathAnim)
    {
        bResetChildOut = 1;
        m_resetDeathAnim = false;
    }
    switch(m_deathPosture)
    {
        // End:0x32
        case 1:
            return 'biped';
            // End:0x5E
            break;
        // End:0x44
        case 3:
            return 'QuadrupedMoving';
            // End:0x5E
            break;
        // End:0x49
        case 2:
        // End:0x5B
        case 0:
            return 'QuadrupedStatic';
            // End:0x5E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return 'Quadruped';
    //return ReturnValue;    
}

final simulated function name IdleTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_idleState)
    {
        // End:0x1A
        case 1:
            return 'Sniff';
            // End:0x1D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return 'Default';
    //return ReturnValue;    
}

final simulated function IdleFinished()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.IdleFinished();
        }
    }
    //return;    
}

final simulated function bool ShouldIgnoreGroundAccidentForState(SPBaseWerewolfPawnPersistent.eWerewolfActionState astate)
{
    switch(astate)
    {
        // End:0x0D
        case 13:
        // End:0x12
        case 14:
        // End:0x17
        case 15:
        // End:0x1C
        case 16:
        // End:0x21
        case 3:
        // End:0x26
        case 4:
        // End:0x2B
        case 5:
        // End:0x30
        case 6:
        // End:0x35
        case 9:
        // End:0x3A
        case 7:
        // End:0x41
        case 8:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

final simulated function PreChangeActionState()
{
    // End:0x29
    if(ShouldIgnoreGroundAccidentForState(m_actionState))
    {
        m_noAccidentChecksBeforeThisTime = WorldInfo.TimeSeconds + float(2);
    }
    //return;    
}

simulated event bool ShouldCheckGroundAccidents()
{
    // End:0x11
    if(ShouldIgnoreGroundAccidentForState(GetActionState()))
    {
        return false;
    }
    // End:0x2C
    if(m_noAccidentChecksBeforeThisTime > WorldInfo.TimeSeconds)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event SmashEffect()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.SmashEffect();
        }
    }
    //return;    
}

event ThrowEffect()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.ThrowEffect();
        }
    }
    //return;    
}

event KnockEffect()
{
    local SPBaseWerewolfAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.KnockEffect();
        }
    }
    //return;    
}

simulated function float DamageAmount(SPPawn.EHSDamageValidationType DamageType)
{
    local float damageToDo;

    switch(DamageType)
    {
        // End:0x39
        case 0:
            damageToDo = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.SwipeDamage);
            // End:0x144
            break;
        // End:0x6A
        case 1:
            damageToDo = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.BiteDamage);
            // End:0x144
            break;
        // End:0x9B
        case 2:
            damageToDo = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.SuperDamage);
            // End:0x144
            break;
        // End:0xCC
        case 3:
            damageToDo = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.CloseGapDamage);
            // End:0x144
            break;
        // End:0xFD
        case 4:
            damageToDo = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HitAndRunDamage);
            // End:0x144
            break;
        // End:0x12E
        case 5:
            damageToDo = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.MiniGameDamage);
            // End:0x144
            break;
        // End:0x133
        case 16:
        // End:0xFFFF
        default:
            damageToDo = 5.0000000;
            // End:0x144
            break;
            break;
    }
    return damageToDo;
    //return ReturnValue;    
}

simulated function SPPawn.EHSDamageDirectionType GetDamageDirection()
{
    return m_lastDamageDirectionType;
    //return ReturnValue;    
}

final simulated function SPBaseWerewolfPawnPersistent.eWerewolfAttackRange GetActorAttackRange(Actor chkActor, optional bool bNoHeightCheck)
{
    local float distSQ;

    // End:0x0F
    if(chkActor == none)
    {
        return 4;
    }
    // End:0x68
    if(!bNoHeightCheck && Abs(chkActor.Location.Z - Location.Z) > (CylinderComponent.CollisionHeight + 60.0000000))
    {
        return 3;
    }
    distSQ = VSizeSq(chkActor.Location - Location);
    // End:0xBA
    if(distSQ <= (m_WerewolfGDTuneData.AttackTooCloseDistance * m_WerewolfGDTuneData.AttackTooCloseDistance))
    {
        return 0;        
    }
    else
    {
        // End:0xEA
        if(distSQ <= (m_WerewolfGDTuneData.AttackNearDistance * m_WerewolfGDTuneData.AttackNearDistance))
        {
            return 1;            
        }
        else
        {
            // End:0x117
            if(distSQ <= (m_WerewolfGDTuneData.AttackMediumDistance * m_WerewolfGDTuneData.AttackMediumDistance))
            {
                return 2;
            }
        }
    }
    return 3;
    //return ReturnValue;    
}

final simulated function bool HasConcentratedArmDamage()
{
    return m_bHasConcentratedArmDamage;
    //return ReturnValue;    
}

final simulated function bool IsSocketDamageEnabled(name SocketName)
{
    // End:0x39
    if(SocketName == 'RightHand')
    {
        // End:0x36
        if(HasConcentratedArmDamage() && m_rtConcentratedDamageInfo[0].bIsActive)
        {
            return false;
        }        
    }
    else
    {
        // End:0x6F
        if(SocketName == 'LeftHand')
        {
            // End:0x6F
            if(HasConcentratedArmDamage() && m_rtConcentratedDamageInfo[1].bIsActive)
            {
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

final simulated function bool IsDoingExtractedCloseTheGapAction(optional bool bExcludeHitAndRunCloseGaps)
{
    return ((((int(m_actionState) == int(17)) || int(m_actionState) == int(18)) || int(m_actionState) == int(19)) || int(m_actionState) == int(66)) || !bExcludeHitAndRunCloseGaps && IsDoingHitAndRunCloseTheGapAnimation();
    //return ReturnValue;    
}

final simulated function float GetMaxDistanceBetweenCylinderEdgesToApplyDamage(Pawn P)
{
    // End:0x23
    if(PlayerPawn(P) != none)
    {
        return m_WerewolfGDTuneData.MaxDistanceBetweenCylinderEdgesForHitConnectionWithPlayer;        
    }
    else
    {
        return m_WerewolfGDTuneData.MaxDistanceBetweenCylinderEdgesForHitConnectionWithOther;
    }
    //return ReturnValue;    
}

final simulated function bool CheckAttack(SPPawn.EHSDamageValidationType damageValidationType, out float BaseDamage, name SocketName)
{
    local float hFudgeDistance, vFudgeDistance;
    local SPPlayerReplicationInfo repInfo;

    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x22
    if(!IsSocketDamageEnabled(SocketName))
    {
        return false;
    }
    // End:0x46
    if((repInfo == none) || repInfo.EnemyPawn == none)
    {
        return false;
    }
    hFudgeDistance = GetMaxDistanceBetweenCylinderEdgesToApplyDamage(repInfo.EnemyPawn);
    // End:0xA2
    if(IsDoingExtractedCloseTheGapAction(false))
    {
        vFudgeDistance = 80.0000000;
        // End:0x9F
        if(ShouldSocketDamageActor(SocketName, repInfo.EnemyPawn, hFudgeDistance, vFudgeDistance))
        {
            return true;
        }        
    }
    else
    {
        // End:0xC7
        if((GetApproximateDistanceBetweenCylinderEdges(repInfo.EnemyPawn)) <= hFudgeDistance)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

final simulated function bool ShouldSocketDamageActor(name SocketName, Actor targetActor, float horizontalFudgeDistance, float verticalFudgeDistance)
{
    local Rotator SocketRot;
    local Vector Delta;
    local float targetCollisionRadius, targetCollisionHeight;
    local Vector TargetLocation, baseLocation;
    local float deltaDist, deltaHeight;
    local Pawn TargetPawn;

    // End:0xD0
    if(targetActor.CollisionComponent != none)
    {
        TargetPawn = Pawn(targetActor);
        // End:0x4F
        if(TargetPawn != none)
        {
            targetCollisionRadius = TargetPawn.GetClassSpecificCollisionRadius(self);            
        }
        else
        {
            targetCollisionRadius = targetActor.CollisionComponent.Bounds.SphereRadius;
        }
        TargetLocation = targetActor.CollisionComponent.Bounds.Origin;
        targetCollisionHeight = targetActor.CollisionComponent.Bounds.SphereRadius;        
    }
    else
    {
        TargetLocation = targetActor.Location;
        targetCollisionRadius = 50.0000000;
        targetCollisionHeight = 100.0000000;
    }
    // End:0x180
    if(!Mesh.GetSocketWorldLocationAndRotation(SocketName, baseLocation, SocketRot))
    {
        baseLocation = Location;
        horizontalFudgeDistance += targetActor.CollisionComponent.Bounds.SphereRadius;
        verticalFudgeDistance += targetActor.CollisionComponent.Bounds.SphereRadius;
    }
    Delta = TargetLocation - baseLocation;
    deltaHeight = Delta.Z;
    Delta.Z = 0.0000000;
    deltaDist = VSize(Delta);
    // End:0x1E3
    if(deltaHeight > (targetCollisionHeight + verticalFudgeDistance))
    {
        return false;
    }
    // End:0x1FB
    if(deltaDist > (targetCollisionRadius + horizontalFudgeDistance))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
{
    local bool retval;
    local float damageToDo;
    local SPPlayerReplicationInfo repInfo;
    local SPBaseWerewolfAIController MyController;

    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x34
    if((repInfo == none) || repInfo.EnemyPawn == none)
    {
        return false;
    }
    m_lastDamageDirectionType = facingDamageDir;
    damageToDo = DamageAmount(DamageType);
    // End:0x98
    if(PlayerPawn(repInfo.EnemyPawn) == none)
    {
        damageToDo *= m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.NonPlayerDamageMultiplier);
    }
    // End:0x14B
    if(int(DamageType) == int(1))
    {
        // End:0xCA
        if(SocketName == 'None')
        {
            SocketName = 'Teeth';
        }
        retval = CheckAttack(DamageType, damageToDo, SocketName);
        // End:0x148
        if(retval)
        {
            repInfo.EnemyPawn.TakeDamageAndProcEffects(damageToDo, Controller, repInfo.EnemyPawn.Location, Vector(Rotation), m_biteDamageType,, self);
            m_lastDamageDirectionType = 0;
            return true;
        }        
    }
    else
    {
        retval = CheckAttack(DamageType, damageToDo, SocketName);
        // End:0x1C2
        if(retval == true)
        {
            repInfo.EnemyPawn.TakeDamageAndProcEffects(damageToDo, Controller, repInfo.EnemyPawn.Location, Vector(Rotation), m_swipeDamageType,, self);
        }
        // End:0x2DF
        if(IsDoingHitAndRunCloseTheGapAnimation(true))
        {
            MyController = SPBaseWerewolfAIController(Controller);
            // End:0x2DF
            if(MyController != none)
            {
                // End:0x27F
                if((retval && MyController.CanIHitAndRunMinigame(repInfo.EnemyPawn)) && (RandRange(0.0000000, 1.0000000) < MyController.m_playerHitAndRunMinigameChance) || WorldInfo.SPAllowHARMinigameTest)
                {
                    MyController.m_minigameAction = m_actionState;
                    MyController.GotoState('HitAndRunMinigame');                    
                }
                else
                {
                    MyController.m_playerHitAndRunMinigameChance += MyController.Class.default.m_playerHitAndRunMinigameChance;
                    // End:0x2D7
                    if(MyController.m_playerHitAndRunMinigameChance > 0.5000000)
                    {
                        MyController.m_playerHitAndRunMinigameChance = 0.5000000;
                    }
                    SetHitAndRunState(1);
                }
            }
        }
        m_lastDamageDirectionType = 0;
        return retval;
    }
    m_lastDamageDirectionType = 0;
    return false;
    //return ReturnValue;    
}

final simulated function bool IsDoingHitAndRunCloseTheGapAnimation(optional bool bCheckForBeginning)
{
    // End:0x1E
    if(bCheckForBeginning && int(m_hitAndRunAnimState) != int(0))
    {
        return false;
    }
    return ((int(m_actionState) == int(41)) || int(m_actionState) == int(42)) || int(m_actionState) == int(43);
    //return ReturnValue;    
}

function OnBeginDeath()
{
    //return;    
}

final simulated function name HitDeathStateAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_hitDeathState)
    {
        // End:0x2F
        case 3:
            Node.m_overrideBlendTime = 0.2500000;
            return 'Death';
            // End:0x54
            break;
        // End:0xFFFF
        default:
            Node.m_overrideBlendTime = 0.0000000;
            return 'Normal';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
}

final simulated function name GetHitLocationGroup(name damagedBone)
{
    local int Index;

    // End:0x2A
    if(FindHitLocationGroupingByBoneName(damagedBone, Index))
    {
        return m_hitLocationGroupings[Index].GroupName;
    }
    return 'Default';
    //return ReturnValue;    
}

final simulated function name HitDeathLocationAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return GetHitLocationGroup(m_animDamagedBone);
    //return ReturnValue;    
}

final simulated function SetAnimHitDeathState(SPPawn.EHitDeathState hitDeathState, optional bool bRestart)
{
    m_bRestartHitState = bRestart;
    m_resetDeathAnim = bRestart;
    // End:0x45
    if((int(hitDeathState) == int(3)) && int(m_hitDeathState) != int(3))
    {
        m_resetDeathAnim = true;
    }
    m_hitDeathState = hitDeathState;
    m_animDamagedBone = m_takeDamageBone;
    //return;    
}

final function SetHitAndRunState(SPBaseWerewolfPawnPersistent.EWerewolfHitAndRunAnimState harState)
{
    m_bResetHitAndRunState = true;
    m_hitAndRunAnimState = harState;
    //return;    
}

final simulated function SetActionState(SPBaseWerewolfPawnPersistent.eWerewolfActionState actionState)
{
    // End:0x53
    if(int(actionState) != int(0))
    {
        // End:0x2D
        if(int(actionState) == int(m_actionStateLastNotNone))
        {
            m_actionStateCount++;            
        }
        else
        {
            m_actionStateCount = 0;
        }
        PreChangeActionState();
        m_actionState = actionState;
        m_actionStateLastNotNone = m_actionState;        
    }
    else
    {
        m_actionState = actionState;
    }
    //return;    
}

final simulated event SPBaseWerewolfPawnPersistent.eWerewolfActionState GetActionState()
{
    return m_actionState;
    //return ReturnValue;    
}

final simulated function SetActionStateLast(SPBaseWerewolfPawnPersistent.eWerewolfActionState actionState)
{
    m_actionStateLast = actionState;
    //return;    
}

final simulated function SPBaseWerewolfPawnPersistent.eWerewolfActionState GetActionStateLast()
{
    return m_actionStateLast;
    //return ReturnValue;    
}

final function SetAnimActionState(SPBaseWerewolfPawnPersistent.eWerewolfActionState actionState, optional bool bRestart)
{
    m_bResetAction = bRestart;
    SetActionState(actionState);
    //return;    
}

final function SetAnimUpperBodyState(SPBaseWerewolfPawnPersistent.eWerewolfActionState actionState, optional bool bRestart)
{
    m_bResetUpperBody = bRestart;
    SetActionState(actionState);
    //return;    
}

final simulated function name SpecialDeathMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return 'Default';
    //return ReturnValue;    
}

simulated function name ChargeRunAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return 'Default';
    //return ReturnValue;    
}

simulated function name ActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x4D
    if(m_AnimationSynchronizationTime > WorldInfo.TimeSeconds)
    {
        return Node.ActiveChildName;
    }
    // End:0x75
    if(m_bResetAction)
    {
        // End:0x66
        if(int(Role) == int(ROLE_SimulatedProxy))
        {
        }
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    // End:0x9D
    if((int(m_hitDeathState) == int(3)) || int(m_hitDeathState) == int(1))
    {
        return retval;
    }
    switch(GetActionState())
    {
        // End:0xBD
        case 1:
            retval = 'Swipe';
            // End:0x6D2
            break;
        // End:0xD4
        case 2:
            retval = 'Bite';
            // End:0x6D2
            break;
        // End:0xEB
        case 65:
            retval = 'NPCSwipe';
            // End:0x6D2
            break;
        // End:0x102
        case 66:
            retval = 'NPCLunge';
            // End:0x6D2
            break;
        // End:0x119
        case 3:
            retval = 'Smash';
            // End:0x6D2
            break;
        // End:0x130
        case 4:
            retval = 'DefaultThrow';
            // End:0x6D2
            break;
        // End:0x147
        case 5:
            retval = 'RightSideThrow';
            // End:0x6D2
            break;
        // End:0x15E
        case 6:
            retval = 'LeftSideThrow';
            // End:0x6D2
            break;
        // End:0x175
        case 9:
            retval = 'LowThrow';
            // End:0x6D2
            break;
        // End:0x18C
        case 7:
            retval = 'RightLowThrow';
            // End:0x6D2
            break;
        // End:0x1A3
        case 8:
            retval = 'LeftLowThrow';
            // End:0x6D2
            break;
        // End:0x1BA
        case 0:
            retval = 'NoAction';
            // End:0x6D2
            break;
        // End:0x1E6
        case 10:
            Node.m_overrideBlendTime = 0.0000000;
            retval = 'TacklePlayerTackle';
            // End:0x6D2
            break;
        // End:0x1FD
        case 11:
            retval = 'TacklePlayerAttack';
            // End:0x6D2
            break;
        // End:0x214
        case 12:
            retval = 'TacklePlayerGetUp';
            // End:0x6D2
            break;
        // End:0x22B
        case 13:
            retval = 'KnockAway';
            // End:0x6D2
            break;
        // End:0x242
        case 14:
            retval = 'DodgeLeft';
            // End:0x6D2
            break;
        // End:0x259
        case 15:
            retval = 'DodgeRight';
            // End:0x6D2
            break;
        // End:0x270
        case 16:
            retval = 'DodgeBack';
            // End:0x6D2
            break;
        // End:0x287
        case 17:
            retval = 'BipedCloseDistance';
            // End:0x6D2
            break;
        // End:0x29E
        case 18:
            retval = 'QuadripedCloseDistance';
            // End:0x6D2
            break;
        // End:0x2B5
        case 19:
            retval = 'KneeCloseDistance';
            // End:0x6D2
            break;
        // End:0x2CC
        case 41:
            retval = 'BipedHitAndRun';
            // End:0x6D2
            break;
        // End:0x2E3
        case 42:
            retval = 'QuadripedHitAndRun';
            // End:0x6D2
            break;
        // End:0x2FA
        case 43:
            retval = 'OtherHitAndRun';
            // End:0x6D2
            break;
        // End:0x311
        case 20:
            retval = 'StandingSuperSwipe';
            // End:0x6D2
            break;
        // End:0x328
        case 21:
            retval = 'JumpingSuperSwipe';
            // End:0x6D2
            break;
        // End:0x33F
        case 23:
            retval = 'HealArm';
            // End:0x6D2
            break;
        // End:0x356
        case 22:
            retval = 'HealArm';
            // End:0x6D2
            break;
        // End:0x36D
        case 24:
            retval = 'ProtectHead';
            // End:0x6D2
            break;
        // End:0x384
        case 25:
            retval = 'ProtectHead';
            // End:0x6D2
            break;
        // End:0x39B
        case 26:
            retval = 'ProtectHead';
            // End:0x6D2
            break;
        // End:0x3B2
        case 27:
            retval = 'StaggerBack';
            // End:0x6D2
            break;
        // End:0x3C9
        case 28:
            retval = 'StaggerForward';
            // End:0x6D2
            break;
        // End:0x3E0
        case 29:
            retval = 'StaggerLeft';
            // End:0x6D2
            break;
        // End:0x3F7
        case 30:
            retval = 'StaggerRight';
            // End:0x6D2
            break;
        // End:0x423
        case 31:
            Node.m_overrideBlendTime = 0.0000000;
            retval = 'RegenMotorFront';
            // End:0x6D2
            break;
        // End:0x44F
        case 32:
            Node.m_overrideBlendTime = 0.0000000;
            retval = 'RegenMotorBack';
            // End:0x6D2
            break;
        // End:0x47B
        case 33:
            Node.m_overrideBlendTime = 0.0000000;
            retval = 'RegenGetupFront';
            // End:0x6D2
            break;
        // End:0x4A7
        case 34:
            Node.m_overrideBlendTime = 0.0000000;
            retval = 'RegenGetupBack';
            // End:0x6D2
            break;
        // End:0x4BE
        case 38:
            retval = 'HARMinigameStart';
            // End:0x6D2
            break;
        // End:0x4D5
        case 39:
            retval = 'HARMinigameChain';
            // End:0x6D2
            break;
        // End:0x4EC
        case 40:
            retval = 'HARMinigameFinish';
            // End:0x6D2
            break;
        // End:0x503
        case 44:
            retval = 'Suspend';
            // End:0x6D2
            break;
        // End:0x51A
        case 45:
            retval = 'Eating';
            // End:0x6D2
            break;
        // End:0x531
        case 46:
            retval = 'TacklePlayerKillshot';
            // End:0x6D2
            break;
        // End:0x548
        case 47:
            retval = 'TacklePlayerKillshotSuccess';
            // End:0x6D2
            break;
        // End:0x55F
        case 48:
            retval = 'TacklePlayerTackleFailed';
            // End:0x6D2
            break;
        // End:0x576
        case 49:
            retval = 'TMGPlayerTakeDown';
            // End:0x6D2
            break;
        // End:0x58D
        case 50:
            retval = 'TMGPlayerStage1Attack';
            // End:0x6D2
            break;
        // End:0x5A4
        case 51:
            retval = 'TMGPlayerStage2Choice';
            // End:0x6D2
            break;
        // End:0x5BB
        case 52:
            retval = 'TMGPlayerStage1KickedOff';
            // End:0x6D2
            break;
        // End:0x5D2
        case 53:
            retval = 'TMGPlayerTransitionToStage2';
            // End:0x6D2
            break;
        // End:0x5E9
        case 54:
            retval = 'TMGPlayerStage1Fail';
            // End:0x6D2
            break;
        // End:0x600
        case 55:
            retval = 'TMGPlayerStage2Attack';
            // End:0x6D2
            break;
        // End:0x617
        case 56:
            retval = 'TMGPlayerStage2Fail';
            // End:0x6D2
            break;
        // End:0x62E
        case 57:
            retval = 'TMGPlayerGetUp';
            // End:0x6D2
            break;
        // End:0x645
        case 58:
            retval = 'TMGPlayerKillshot';
            // End:0x6D2
            break;
        // End:0x65C
        case 59:
            retval = 'TMGPlayerKillshotSuccess';
            // End:0x6D2
            break;
        // End:0x673
        case 60:
            retval = 'WallTest';
            // End:0x6D2
            break;
        // End:0x68A
        case 61:
            retval = 'Frustrated';
            // End:0x6D2
            break;
        // End:0x6A1
        case 62:
            retval = 'Charge';
            // End:0x6D2
            break;
        // End:0x6B8
        case 63:
            retval = 'throwClub';
            // End:0x6D2
            break;
        // End:0x6CF
        case 64:
            retval = 'SwipingTentacle';
            // End:0x6D2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

final function SetMinigameAnim(Actor.EMinigameStage stage, Actor.EMinigameState Condition)
{
    switch(stage)
    {
        // End:0x19
        case 0:
            SetAnimActionState(38, true);
            // End:0x46
            break;
        // End:0x2A
        case 1:
            SetAnimActionState(39, true);
            // End:0x46
            break;
        // End:0x3B
        case 2:
            SetAnimActionState(40, true);
            // End:0x46
            break;
        // End:0x43
        case 3:
            // End:0x46
            break;
        // End:0xFFFF
        default:
            break;
    }
    m_minigameState = Condition;
    m_bResetMinigameAction = true;
    //return;    
}

final simulated function name HARMinigameMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x18
    if(m_bResetMinigameAction)
    {
        bResetChildOut = 1;
        m_bResetMinigameAction = false;
    }
    switch(m_minigameState)
    {
        // End:0x37
        case 0:
            retval = 'Start';
            // End:0x7F
            break;
        // End:0x4E
        case 1:
            retval = 'Dodge';
            // End:0x7F
            break;
        // End:0x65
        case 2:
            retval = 'Counter';
            // End:0x7F
            break;
        // End:0x7C
        case 3:
            retval = 'Fail';
            // End:0x7F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

final simulated function name HitAndRunMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x18
    if(m_bResetHitAndRunState)
    {
        bResetChildOut = 1;
        m_bResetHitAndRunState = false;
    }
    switch(m_hitAndRunAnimState)
    {
        // End:0x37
        case 0:
            retval = 'Start';
            // End:0x96
            break;
        // End:0x4E
        case 1:
            retval = 'ToQuad';
            // End:0x96
            break;
        // End:0x65
        case 2:
            retval = 'ToBiped';
            // End:0x96
            break;
        // End:0x7C
        case 3:
            retval = 'QuadDone';
            // End:0x96
            break;
        // End:0x93
        case 4:
            retval = 'BipedDone';
            // End:0x96
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

final simulated function name UpperBodyMeleeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Swipe';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetUpperBody)
    {
        bResetChildOut = 1;
        m_bResetUpperBody = false;
    }
    switch(GetActionState())
    {
        // End:0x5C
        case 22:
            retval = 'HealRightArm';
            // End:0xBB
            break;
        // End:0x73
        case 23:
            retval = 'HealLeftArm';
            // End:0xBB
            break;
        // End:0x8A
        case 24:
            retval = 'StartProtectHead';
            // End:0xBB
            break;
        // End:0xA1
        case 25:
            retval = 'CycleProtectHead';
            // End:0xBB
            break;
        // End:0xB8
        case 26:
            retval = 'EndProtectHead';
            // End:0xBB
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

final simulated function name MeleeDodgeTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetMeleeDodge)
    {
        bResetChildOut = 1;
        m_bResetMeleeDodge = false;
    }
    // End:0x64
    if((int(m_hitDeathState) == int(3)) || int(m_hitDeathState) == int(1))
    {
        return retval;
    }
    switch(GetAnimMeleeDodgeState())
    {
        // End:0x84
        case 1:
            retval = 'MeleeDodgeRight';
            // End:0x9E
            break;
        // End:0x9B
        case 2:
            retval = 'MeleeDodgeLeft';
            // End:0x9E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

event NewFloor()
{
    //return;    
}

final simulated function name GriffonMaulHijackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return 'Default';
    //return ReturnValue;    
}

final simulated function name EatingStageMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_eatingStage)
    {
        // End:0x17
        case 0:
            return 'Eating';
        // End:0x26
        case 1:
            return 'LookUp';
        // End:0x35
        case 2:
            return 'LookAt';
        // End:0x44
        case 3:
            return 'Restart';
        // End:0xFFFF
        default:
            return 'Eating';
            break;
    }
    //return ReturnValue;    
}

simulated function RegenMotorFinished()
{
    //return;    
}

simulated function LookUpFinished()
{
    m_eatingStage = 2;
    //return;    
}

simulated function RestartFinished()
{
    m_eatingStage = 0;
    //return;    
}

simulated event bool DoAILookAt(out Vector whereToLook)
{
    local SPBaseWerewolfAIController MyController;
    local SPPlayerReplicationInfo repInfo;

    // End:0x93
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        MyController = none;
        // End:0x3C
        if(Controller != none)
        {
            MyController = SPBaseWerewolfAIController(Controller);
        }
        // End:0x93
        if((MyController != none) && MyController.m_moveToThrowObjectInfo.objectToThrow != none)
        {
            return LookAtActorDefault(MyController.m_moveToThrowObjectInfo.objectToThrow, whereToLook);
        }
    }
    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0xB0
    if(repInfo == none)
    {
        return false;
    }
    // End:0xC7
    if(repInfo.EnemyPawn == none)
    {
        return false;
    }
    // End:0x109
    if(int(GetActionState()) == int(45))
    {
        // End:0x107
        if(int(m_eatingStage) == int(2))
        {
            return LookAtActorDefault(repInfo.EnemyPawn, whereToLook);
        }
        return false;
    }
    return LookAtActorDefault(repInfo.EnemyPawn, whereToLook);
    //return ReturnValue;    
}

final simulated function NotifyHeadBlownOffFinished()
{
    Mesh.bUpdateAnimTree = false;
    SetThrowDeath(200.0000000, m_DeathThrowDirection);
    GotoState('Dying');
    //return;    
}

simulated function DestroyHead()
{
    local Vector vPos;
    local Rotator rRot;
    local PandoraGameInfo PGI;

    // End:0x0D
    if(!bHasHead)
    {
        return;
    }
    PlaySound(HeadShotSound);
    // End:0x70
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        PGI = PandoraGameInfo(WorldInfo.Game);
        // End:0x70
        if(PGI != none)
        {
            PGI.ShowWereWolfTutorial();
        }
    }
    bHasHead = false;
    Mesh.SetSkeletalMesh(smWWHeadless, true, true);
    Mesh.GetSocketWorldLocationAndRotation('head', vPos, rRot);
    WWHeadParticleEmitter = Spawn(Class'SPEmitterSpawnable',,, vPos, rRot);
    // End:0x201
    if(WWHeadParticleEmitter != none)
    {
        WWHeadParticleEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_head');
        WWHeadParticleEmitter.SetOwner(self);
        WWHeadParticleEmitter.SetTemplate(WWHeadParticleTemplate, true);
        WWHeadParticleEmitter.bDestroyOnSystemFinish = true;
        // End:0x1D4
        if(SPBaseWerewolfAIController(Controller) != none)
        {
            // End:0x1D4
            if(SPBaseWerewolfAIController(Controller).GetStateName() == 'MaulPlayer')
            {
                WWHeadParticleEmitter.ParticleSystemComponent.SetFOV(85.0000000);
                WWHeadParticleEmitter.ParticleSystemComponent.bUseParticleSystemFOV = true;
                WWHeadParticleEmitter.ParticleSystemComponent.SetDepthPriorityGroup(2);
            }
        }
        WWHeadParticleEmitter.ParticleSystemComponent.ActivateSystem();
        WWHeadParticleEmitter.bKillDuringLevelTransition = true;
    }
    SetTimer(60.0000000, false, 'RemoveHeadParticles');
    HandleBodyCleanup();
    //return;    
}

function Kill()
{
    //return;    
}

final simulated function RemoveHeadParticles()
{
    // End:0x39
    if(WWHeadParticleEmitter != none)
    {
        WWHeadParticleEmitter.ParticleSystemComponent.DeactivateSystem();
        WWHeadParticleEmitter.Destroy();
        WWHeadParticleEmitter = none;
    }
    //return;    
}

simulated event Destroyed()
{
    RemoveHeadParticles();
    CleanUpHeadTargetVolume();
    super.Destroyed();
    //return;    
}

simulated function name ChargeActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    bResetChildOut = 1;
    return 'NoAction';
    //return ReturnValue;    
}

simulated function name ChargeCommitActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    bResetChildOut = 1;
    return 'NoAction';
    //return ReturnValue;    
}

final simulated function float BiteAttackBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    // End:0x31
    if(IsBiped() && int(Physics) != int(8))
    {
        childWeights[1] = 1.0000000;
        return 1.0000000;        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

final simulated function float MeleeAttackBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    // End:0x31
    if(IsBiped() && int(Physics) != int(8))
    {
        childWeights[1] = 1.0000000;
        return 1.0000000;        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

final simulated function name StanceTransitionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x16
    if(IsBiped())
    {
        return 'biped';        
    }
    else
    {
        return 'Quadruped';
    }
    //return ReturnValue;    
}

final function OnSpSetStance(SeqAct_SPSetStance Action)
{
    stanceForcedFromKismet = true;
    SetStance(Action.m_stance, true);
    //return;    
}

final function SetStance(SPBaseWerewolfPawnPersistent.eWerewolfStance newStance, optional bool Force = false)
{
    // End:0x21
    if((Force == false) && stanceForcedFromKismet == true)
    {
        return;
    }
    // End:0x3A
    if(int(Physics) == int(8))
    {
        SetSpiderMovementType();        
    }
    else
    {
        SetWalkMovementType(int(newStance) == int(1));
    }
    //return;    
}

final simulated function bool IsBiped()
{
    return m_bIsBiped;
    //return ReturnValue;    
}

final simulated function SetSpiderMovementType()
{
    SetMovementType(12);
    //return;    
}

simulated function SetWalkMovementType(bool biped)
{
    // End:0x20
    if(biped)
    {
        m_bIsBiped = true;
        SetMovementType(0);        
    }
    else
    {
        m_bIsBiped = false;
        SetMovementType(1);
    }
    //return;    
}

final simulated function name KnockDirectionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Direction;

    Direction = 'Forward';
    switch(m_knockDirection)
    {
        // End:0x2E
        case 0:
            Direction = 'Left';
            // End:0x5F
            break;
        // End:0x45
        case 1:
            Direction = 'Right';
            // End:0x5F
            break;
        // End:0x5C
        case 2:
            Direction = 'Forward';
            // End:0x5F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return Direction;
    //return ReturnValue;    
}

final simulated function SetDodgeNetworkData()
{
    // End:0x1B
    if(int(m_meleeDodgeState) == int(1))
    {
        m_dodgeNetworkData = 1;        
    }
    else
    {
        // End:0x36
        if(int(m_meleeDodgeState) == int(2))
        {
            m_dodgeNetworkData = 2;            
        }
        else
        {
            // End:0x4A
            if(m_bUseDodgeRun)
            {
                m_dodgeNetworkData = 3;                
            }
            else
            {
                m_dodgeNetworkData = 0;
            }
        }
    }
    //return;    
}

final function SetAnimMeleeDodgeState(SPBaseWerewolfPawnPersistent.eWerewolfMeleeDodgeState dodgeState, optional bool bRestart)
{
    m_bResetMeleeDodge = bRestart;
    m_meleeDodgeState = dodgeState;
    SetDodgeNetworkData();
    //return;    
}

final simulated function SPBaseWerewolfPawnPersistent.eWerewolfMeleeDodgeState GetAnimMeleeDodgeState()
{
    return m_meleeDodgeState;
    //return ReturnValue;    
}

final simulated function SetUseDodgeRun(bool newUseDodgeRun)
{
    m_bUseDodgeRun = newUseDodgeRun;
    SetDodgeNetworkData();
    //return;    
}

simulated function bool GetUseDodgeRun()
{
    return m_bUseDodgeRun;
    //return ReturnValue;    
}

final simulated function name DodgeRunMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x17
    if(GetUseDodgeRun())
    {
        return 'Dodge';
    }
    return 'Default';
    //return ReturnValue;    
}

final simulated function name DetermineFwdMoveStyleMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_FwdMoveStyle;
    //return ReturnValue;    
}

final simulated function BlendWerewolfMinigameTackleAnimationsStage1(SPAnimGenericFunctionBlendNode Node)
{
    Node.TargetWeight[0] = m_blendValueForMash1Animations;
    Node.TargetWeight[1] = 1.0000000 - m_blendValueForMash1Animations;
    //return;    
}

final simulated function BlendWerewolfMinigameTackleAnimationsStage2(SPAnimGenericFunctionBlendNode Node)
{
    Node.TargetWeight[0] = m_blendValueForMash2Animations;
    Node.TargetWeight[1] = 1.0000000 - m_blendValueForMash2Animations;
    //return;    
}

final simulated function float InjuredRightArmPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    // End:0x1C
    if(rightArmInjured)
    {
        childWeights[1] = 1.0000000;
        return 1.0000000;
    }
    childWeights[1] = 0.0000000;
    return 0.0000000;
    //return ReturnValue;    
}

final simulated function float InjuredLeftArmPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    // End:0x1C
    if(leftArmInjured)
    {
        childWeights[1] = 1.0000000;
        return 1.0000000;
    }
    childWeights[1] = 0.0000000;
    return 0.0000000;
    //return ReturnValue;    
}

final simulated function float LegTurningMCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    return 0.0000000;
    //return ReturnValue;    
}

final simulated function bool IsConcentratedDamageActive(int concentratedIndex)
{
    return m_rtConcentratedDamageInfo[concentratedIndex].bIsActive;
    //return ReturnValue;    
}

function ThreatAnimDone()
{
    //return;    
}

function SetStateForAttachedTentacle(bool isAttaching)
{
    // End:0x2F
    if(SPBaseWerewolfAIController(Controller) != none)
    {
        SPBaseWerewolfAIController(Controller).SetAttachedTentacle(isAttaching);
    }
    //return;    
}

reliable client simulated event MulticastAnimBasedSingleEdge(int VertexData, Rotator StartRotation)
{
    NewPathEdge(VertexData, 1, StartRotation);
    //return;    
}

reliable client simulated event MulticastAnimBasedStart(int VertexData, Rotator StartRotation)
{
    NewPathEdge(VertexData, 2, StartRotation);
    //return;    
}

reliable client simulated event MulticastAnimBasedEdge(int VertexData)
{
    NewPathEdge(VertexData, 3, rot(0, 0, 0));
    //return;    
}

reliable client simulated event MulticastAnimBasedFinish(int VertexData)
{
    NewPathEdge(VertexData, 4, rot(0, 0, 0));
    //return;    
}

reliable client simulated event MulticastExactEdge(int VertexData)
{
    NewPathEdge(VertexData, 5, rot(0, 0, 0));
    //return;    
}

reliable client simulated event MulticastCancelExactMode()
{
    CancelClientExactMode();
    //return;    
}

simulated event PrepareForNonAnimationBasedMovement()
{
    SetWalkMovementType(IsBiped());
    SetMovementPhysics();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x5B
    if(VarName == 'm_NetUnconsciousState')
    {
        switch(m_NetUnconsciousState)
        {
            // End:0x31
            case 0:
                GoUnconscious();
                m_bUnconscious = true;
                // End:0x56
                break;
            // End:0x43
            case 1:
                StartRagdollToAnim();
                // End:0x56
                break;
            // End:0x53
            case 2:
                m_bUnconscious = false;
                // End:0x56
                break;
            // End:0xFFFF
            default:
                break;
        }
        return;        
    }
    else
    {
        // End:0xDE
        if(VarName == 'm_dodgeNetworkData')
        {
            switch(m_dodgeNetworkData)
            {
                // End:0x8E
                case 0:
                    m_meleeDodgeState = 0;
                    m_bUseDodgeRun = false;
                    // End:0xD9
                    break;
                // End:0xA6
                case 1:
                    m_meleeDodgeState = 1;
                    m_bUseDodgeRun = false;
                    // End:0xD9
                    break;
                // End:0xBE
                case 2:
                    m_meleeDodgeState = 2;
                    m_bUseDodgeRun = false;
                    // End:0xD9
                    break;
                // End:0xD6
                case 3:
                    m_meleeDodgeState = 0;
                    m_bUseDodgeRun = true;
                    // End:0xD9
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            return;            
        }
        else
        {
            // End:0x106
            if(VarName == 'm_actionStateCount')
            {
                // End:0x104
                if(m_actionStateCount > 0)
                {
                    m_bResetAction = true;
                }
                return;
            }
        }
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    // End:0x39
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x36
        if(!ClassIsChildOf(m_deathDamageType, Class'SPDamageTypeImpactFlame'))
        {
            DestroyHead();
        }        
    }
    else
    {
        bHasHead = false;
        HandleBodyCleanup();
    }
    super(Pawn).PlayDying(DamageType, HitLoc);
    //return;    
}

function SetToGroundMovementType()
{
    SetMovementType(2);
    //return;    
}

simulated state Unconscious
{
    simulated function EndState(name NextStateName)
    {
        // End:0x1E
        if(m_bUnconscious && NextStateName != 'Dying')
        {
        }
        CleanUpUnconscious(NextStateName == 'Dying');
        //return;        
    }

    simulated event PoppedState()
    {
        // End:0x09
        if(m_bUnconscious)
        {
        }
        CleanUpUnconscious(false);
        //return;        
    }

    simulated function CleanUpUnconscious(bool bDying)
    {
        EndHealing();
        m_bUnconscious = false;
        // End:0x32
        if(int(Role) >= int(ROLE_Authority))
        {
            m_NetUnconsciousState = 2;
            bReplicateMovement = true;
        }
        CleanUpHeadTargetVolume();
        // End:0x4A
        if(PreRagdollController != none)
        {
            PreRagdollController = none;
        }
        // End:0x90
        if(!bDying)
        {
            EnableNovodexBoundingVolume(true);
            bImmobile = false;
            SetWalkMovementType(IsBiped());
            SetMovementPhysics();
            SetAnimHitDeathState(0);
            SetAnimActionState(0);
        }
        //return;        
    }

    function bool CanBeDefenderInCATAnimation(SPPawn attacker)
    {
        return false;
        //return ReturnValue;        
    }

    function ProcHeadDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
    {
        local TraceHitInfo HitInfo;

        // End:0x8F
        if(bHasHead)
        {
            CheckHitInfo(HitInfo, Mesh, Momentum, HitLocation);
            // End:0x62
            if(GetHitLocationGroup(HitInfo.BoneName) != 'head')
            {
                HitInfo.BoneName = 'jo_neckA';
            }
            TakeDamageAndProcEffects(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        }
        //return;        
    }

    simulated function PreparePawnForUnconsciousness()
    {
        CreateHeadTargetVolume();
        m_bPreRagDollTargettable = bTargettable;
        bTargettable = false;
        StartHealing();
        PreRagdollController = SPBaseWerewolfAIController(Controller);
        Controller.PushState('Suspended');
        bImmobile = true;
        //return;        
    }

    simulated function StartAnimationForAnimIntoRagdoll()
    {
        SetAnimHitDeathState(3, true);
        PreparePawnForUnconsciousness();
        //return;        
    }

    function BeginHealingTimers()
    {
        // End:0x59
        if(!WorldInfo.m_bStayDown)
        {
            SetTimer(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.DisabledTime), false, 'StartRagdollToAnim');
            SetTimer(1.0000000, true, 'HealthRecoverPerSec');
        }
        //return;        
    }

    simulated function StartHealing()
    {
        BeginHealingTimers();
        SetRegenRate(0.0500000);
        //return;        
    }

    simulated function EndHealing()
    {
        SetRegenRate(999999.0000000);
        ClearTimer('HealthRecoverPerSec');
        ClearTimer('StartRagdollToAnim');
        //return;        
    }

    simulated function SetMovementPhysics()
    {
        // End:0x11
        if(!m_bUnconscious)
        {
            super(SPPawn).SetMovementPhysics();
        }
        //return;        
    }

    final function HealthRecoverPerSec()
    {
        // End:0x87
        if(!WorldInfo.m_bStayDown)
        {
            // End:0x5B
            if((float(Health) + m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RecoveryRate)) > float(HealthMax))
            {
                Health = HealthMax;                
            }
            else
            {
                Health += int(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RecoveryRate));
            }
        }
        //return;        
    }

    simulated function StartRagdollToAnim()
    {
        // End:0x10
        if(int(m_PhysAnimState) != int(3))
        {
        }
        // End:0x1D
        if(!bHasHead)
        {
            return;
        }
        // End:0x2A
        if(!m_bUnconscious)
        {
            return;
        }
        // End:0x42
        if(int(Role) >= int(ROLE_Authority))
        {
            m_NetUnconsciousState = 1;
        }
        m_bDiedWhileSpidering = false;
        TriggerEventClass(Class'SeqEvent_Reviving', self);
        // End:0x71
        if(AttemptPhysAnimState_RagdollIntoAnim(false))
        {
            PreRagdollController = none;            
        }
        else
        {
            AttemptPhysAnimState_Fixed(true);
            RagdollInToAnimFinished();
        }
        //return;        
    }

    simulated function StartTransitionAnimationForRagdollIntoAnim()
    {
        m_bGetUpFromBack = Mesh.GetBoneAxis('JO_Hip', 2).Z > 0.0000000;
        SetAnimHitDeathState(0);
        SetActionState(GetRagdollIntoAnimTransitionAction(m_bGetUpFromBack));
        //return;        
    }

    simulated function StartGetUpAnimationForRagdollIntoAnim()
    {
        SetActionState(GetRagdollIntoAnimGetUpAction(m_bGetUpFromBack));
        //return;        
    }

    simulated function RagdollInToAnimFinished()
    {
        local SPBaseWerewolfAIController wwAI;

        // End:0x104
        if((int(m_PhysAnimState) == int(4)) || int(m_PhysAnimState) == int(0))
        {
            m_bIsPokeable = true;
            bTargettable = m_bPreRagDollTargettable;
            bImmobile = false;
            m_HeadHitPoints = m_InitHeadHitPoints;
            TriggerEventClass(Class'SeqEvent_AIRegenerated', self);
            wwAI = SPBaseWerewolfAIController(Controller);
            // End:0xEB
            if(wwAI != none)
            {
                // End:0xD7
                if((wwAI.m_bAIDisabled && wwAI.IsInState('AIDisabled', true)) && wwAI.IsInState('Suspended', false))
                {
                    wwAI.PopState();                    
                }
                else
                {
                    wwAI.EvaluateSituation();
                }
            }
            CleanUpUnconscious(false);
            GotoState('None');
        }
        //return;        
    }
Begin:

    m_bUnconscious = true;
    // End:0x31
    if(SPBaseWerewolfAIController(Controller) != none)
    {
        SPBaseWerewolfAIController(Controller).ClearMinigame();
    }
    // End:0x51
    if(int(Role) >= int(ROLE_Authority))
    {
        m_NetUnconsciousState = 0;
        bReplicateMovement = false;
    }
    // End:0xB4
    if(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.GroundHeadHealth) > 0.0000000)
    {
        m_LastHeadHitPoints = m_HeadHitPoints;
        m_HeadHitPoints = int(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.GroundHeadHealth));
    }
    TriggerEventClass(Class'SeqEvent_UnConscious', self);
    // End:0xE6
    if(!CanUsePhysAnimState_AnimIntoRagdoll())
    {
        AttemptPhysAnimState_Ragdoll(true);
        PreparePawnForUnconsciousness();        
    }
    else
    {
        StartAnimationForAnimIntoRagdoll();
    }
    stop;                
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        m_HeadHitPoints = 0;
        // End:0x53
        if(Controller != none)
        {
            // End:0x3B
            if(SPBaseWerewolfAIController(Controller) != none)
            {
                SPBaseWerewolfAIController(Controller).ClearMinigame();
            }
            Controller.GotoState('ControllerDying');
        }
        SetActionState(0);
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

    function StartDying()
    {
        local SPBaseWerewolfAIController MyController;

        // End:0x33
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 2.0000000;            
        }
        else
        {
            // End:0x6B
            if(m_DeathTimeout == 0.0000000)
            {
                m_DeathTimeout = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.CorpseLifetime);
            }
            SetTimer(1.0000000, false, 'CheckIfWeShouldDie');
        }
        SetCollision(true, false);
        MyController = SPBaseWerewolfAIController(Controller);
        // End:0xB6
        if(MyController != none)
        {
            MyController.NotifyDying();            
        }
        else
        {
            // End:0xEF
            if(Controller != none)
            {
                // End:0xE2
                if(Controller.bIsPlayer)
                {
                    DetachFromController();                    
                }
                else
                {
                    Controller.Destroy();
                }
            }
        }
        //return;        
    }

    function EndDying()
    {
        local int I;
        local SPBaseWerewolfAIController MyController;

        MyController = SPBaseWerewolfAIController(Controller);
        // End:0x5D
        if(MyController != none)
        {
            MyController.NotifyDied();
            // End:0x50
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
        J0x64:

        // End:0xA9 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x9F
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
        I = 0;
        J0xB0:

        // End:0xFB [Loop If]
        if(I < m_SPEmitterArray.Length)
        {
            // End:0xF1
            if(m_SPEmitterArray[I] != none)
            {
                m_SPEmitterArray[I].Destroy();
                m_SPEmitterArray[I] = none;
            }
            I++;
            // [Loop Continue]
            goto J0xB0;
        }
        CleanUpHeadTargetVolume();
        //return;        
    }

    simulated function StartAnimationForAnimIntoRagdoll()
    {
        SetAnimHitDeathState(3, true);
        bImmobile = true;
        //return;        
    }
Begin:

    SetRegenRate(999999.0000000);
    PawnDeathDestructiblePropertyCheck();
    StartDying();
    Sleep(0.1000000);
    OnBeginDeath();
    // End:0x6A
    if(m_bThrowDeath)
    {
        AttemptPhysAnimState_Ragdoll(true);
        CollisionComponent.AddImpulse(m_DeathThrowDirection * m_DeathThrowImpulse,,, true);        
    }
    else
    {
        // End:0x8F
        if(!CanUsePhysAnimState_AnimIntoRagdoll())
        {
            // End:0x8C
            if(int(m_PhysAnimState) != int(2))
            {
                AttemptPhysAnimState_Ragdoll(true);
            }            
        }
        else
        {
            StartAnimationForAnimIntoRagdoll();
        }
        J0x99:

        // End:0xB4 [Loop If]
        if(int(m_PhysAnimState) != int(3))
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x99;
        }
    }
    // End:0xD8
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        DestroyHead();
    }
    Mesh.bUpdateAnimTree = false;
    SetNovodexBoundingVolume(false);
    m_bEnablePhysicsPushing = false;
    EndDying();
    // End:0x125
    if(Controller == none)
    {
        TriggerEventClass(Class'Engine.SeqEvent_Death', self);
    }
    stop;            
}
