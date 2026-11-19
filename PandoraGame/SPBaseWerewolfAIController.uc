class SPBaseWerewolfAIController extends SPAIController
    native;

const INVALIDATTACKER_DURATION = 5.0f;

enum EMeleeMoveType
{
    eMovingToTarget,                // 0
    eMovingAwayFromTarget,          // 1
    EMeleeMoveType_MAX              // 2
};

enum EMeleeAction
{
    emaNone,                        // 0
    emaHealArm,                     // 1
    emaSlamPlayer,                  // 2
    emaBipedCloseDistance,          // 3
    emaQuadripedCloseDistance,      // 4
    emaKneeCloseDistance,           // 5
    emaBipedHitAndRun,              // 6
    emaQuadripedHitAndRun,          // 7
    emaOtherHitAndRun,              // 8
    emaBite,                        // 9
    emaSwipe,                       // 10
    emaStandingSuperSwipe,          // 11
    emaJumpingSuperSwipe,           // 12
    emaProtectHead,                 // 13
    emaStaggerBack,                 // 14
    emaHitAndRunMinigame,           // 15
    emaCharge,                      // 16
    emaNPCSwipe,                    // 17
    emaNPCLunge,                    // 18
    emaCATAnimation,                // 19
    EMeleeAction_MAX                // 20
};

enum EMinigameResult
{
    emgrUnknown,                    // 0
    emgrDodged,                     // 1
    emgrCountered,                  // 2
    emgrAbort,                      // 3
    emgrFail,                       // 4
    EMinigameResult_MAX             // 5
};

struct native InvalidatedAttackerInfo
{
    var Controller invalidAttacker;
    var float invalidatedTime;

    structdefaultproperties
    {
        invalidAttacker=none
        invalidatedTime=0.0000000
    }
};

struct native MeleeMoveInfo
{
    var SPAIController.EMoveGoalType movetype;
    var Vector Offset;
    var SPBaseWerewolfAIController.EMeleeMoveType meleeMoveType;

    structdefaultproperties
    {
        movetype=emgtToActor
        Offset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        meleeMoveType=eMovingToTarget
    }
};

struct native ThreatInfo
{
    var float suppressionTime;

    structdefaultproperties
    {
        suppressionTime=0.0000000
    }
};

struct native EatInfo
{
    var float MinEatDist;

    structdefaultproperties
    {
        MinEatDist=0.0000000
    }
};

struct native ThrowItem
{
    var Actor Actor;
    var int nUses;

    structdefaultproperties
    {
        Actor=none
        nUses=0
    }
};

struct ProximZone
{
    var float Radius;
    var float Weight;

    structdefaultproperties
    {
        Radius=0.0000000
        Weight=0.0000000
    }
};

var bool m_bHitTimeOut;
var bool bWallAdjustFailed;
var bool m_bAttackedSinceTimer;
var bool m_moveToThrowSuccessful;
var bool m_bInMeleeMode;
var bool m_returnedFromTakeHit;
var bool m_bIsDoingFullBodyMeleeDodge;
var bool m_bAllowConcentratedArmDamageRecovery;
var bool m_bStartConcentratedHeadDamage;
var bool m_bUseHitAndRun;
var bool m_minigameHandshakeReceived;
var bool m_TMGHandshakeReceived;
var bool bTMGGodMode;
var bool m_minigameTargetAlignmentFinished;
var bool m_bWaitingToBreakOutOfMaul;
var bool m_bFinishedCloseTheGapToMinigameAnim;
var transient bool bForceTackle;
var transient bool bForceHAR;
var transient bool bOnlyAllowThrowingAttacks;
var bool m_bTMGOverride;
var bool bPreventFoodDuringThrowOnly;
var bool bExitForceThrowOnListDepletion;
var bool bOnlyAllowMeleeAttacks;
var bool bCurTargetsAllEvaluated;
/** True if targeting is enabled for this specific WW */
var(Targeting) bool bTargetingEnabled;
var bool m_bPreventCloseTheGap;
var SPBaseWerewolfPawnPersistent m_WerewolfPawn;
var Actor m_SmashObstacle;
var Actor m_ThrowObstacle;
var SPPawn m_SlamObstacle;
var Actor m_ThrowTarget;
var int m_wallFailedMessageCount;
var float m_lastWallFailedTime;
var ThrowObjectInfo m_moveToThrowObjectInfo;
var ThrowObjectInfo m_inProgressThrowObjectInfo;
var SPBaseWerewolfPawnPersistent.eWerewolfActionState m_ThrowActionType;
var SPAIController.EDodgeDirectionType m_currentDodgeStyle;
var SPBaseWerewolfAIController.EMeleeAction m_lastAttackAction;
var SPBaseWerewolfPawnPersistent.eWerewolfActionState m_minigameAction;
var SPBaseWerewolfAIController.EMinigameResult m_minigameResult;
var int m_attackCounter;
var int m_meleeAttackCounter;
var float m_sleepTime;
/** 0.1 */
var(AI) float m_playerSlamChance;
/** 0.1 */
var(AI) float m_playerHitAndRunMinigameChance;
var array<InvalidatedAttackerInfo> m_invalidAttackers;
var Vector m_knockVector;
var float m_lastSuppressionTime;
var MeleeMoveInfo m_meleeMoveInfo;
var float m_lastSuperAttackTime;
var float m_lastMediumWeaponHitTime;
var float m_lastDamageTime;
var float m_currentSlowDownBias;
var float m_armRecoveryStartTime;
var float m_headDamageStartTime;
var int m_headDamageLastHeadHitTime;
var ThreatInfo m_threatInfo;
var Pawn m_hitAndRunMinigameTarget;
var Pawn m_TMGTarget;
var Vector m_minigameMoveToLoc;
var float m_extraHitAndRunChance;
var float m_accumulatedWallDamage;
var Actor m_enemyLastTick;
var Actor m_foodWeAreEating;
var transient float LastForceTackleTime;
var transient Pawn ForcedAttackTarget;
var array<ThrowItem> PrivledgedThrowList;
var int PrivledgedThrowID;
var float LocalTargetDistMultiplierFull;
var float LocalTargetDistMultiplierLinear;
var class<KismetActorFactoryOverrideData> ActorFactoryOverrideClass;
var float m_concentratedTorsoDamageStaggerStartTime;
/** Interval to wait before reevaluating target possibilities */
var(Targeting) float PickDelay;
var float CumlativeTargetDelta;
var int CurProcTarget;
/** Fixed weighting applied to proximity distance from werewolfvar(Targeting) float ProximityDec */
var(Targeting) array<float> ProximityWeight;
/** Override distance at which players outside of are ignored for a given timeframe */
var(Targeting) float fIgnoreDist;
/** Number of seconds to wait after a player is known to have gone out of range before again considering him as a target */
var(Targeting) float fIgnoreTimeout;
/** Number of seconds to wait after a player is known to have gone out of range before again considering him as a target */
var(Targeting) float fIgnoreReturnTimeout;
var float LastTargetEvalTime;
var float LastTargetListRepopulateTime;
var float MinTargetDist;
var float MaxTargetDist;
var Actor LastEnemy;
var SPGameDifficultyTuneWerewolf m_WerewolfGDTuneData;
var const localized string PlayerName;
var SPAnimNodeSequence seqNodeBipedCloseDistance;
var SPAnimNodeSequence seqNodeQuadripedCloseDistance;
var SPAnimNodeSequence seqNodeMiscCloseDistance;
var SPAnimNodeSequence seqNodeBipedHitAndRun;
var SPAnimNodeSequence seqNodeQuadripedHitAndRun;
var SPAnimNodeSequence seqNodeOtherHitAndRun;
var Vector m_animusPulseDirection;

// Export USPBaseWerewolfAIController::execGetThrowVelocity(FFrame&, void* const)
native final function Vector GetThrowVelocity(const out Vector startPos, const out Vector endPos, Rotator launchAngle);

// Export USPBaseWerewolfAIController::execInvalidateAttacker(FFrame&, void* const)
native final function InvalidateAttacker(Controller attacker);

// Export USPBaseWerewolfAIController::execIsInvalidatedAttacker(FFrame&, void* const)
native final function bool IsInvalidatedAttacker(Actor attacker);

// Export USPBaseWerewolfAIController::execUpdateInvalidatedAttackers(FFrame&, void* const)
native final function UpdateInvalidatedAttackers();

// Export USPBaseWerewolfAIController::execBasicUpdateFocus(FFrame&, void* const)
native function bool BasicUpdateFocus();

// Export USPBaseWerewolfAIController::execIsEnemyTargetedBySquad(FFrame&, void* const)
native final function bool IsEnemyTargetedBySquad(Pawn theEnemy);

// Export USPBaseWerewolfAIController::execReactToSuppression(FFrame&, void* const)
native function ReactToSuppression(out SuppressionMemory Suppression, const Vector currentMovePoint, const Vector finalPoint, Actor finalGoal, optional bool bOnlyAllowLeftRightDodge);

// Export USPBaseWerewolfAIController::execIsClearToDodge(FFrame&, void* const)
native final function bool IsClearToDodge(const out Vector dodgeDelta);

// Export USPBaseWerewolfAIController::execIsClearToJumpUp(FFrame&, void* const)
native final function bool IsClearToJumpUp(const out Vector moveDelta, float jumpHeight);

// Export USPBaseWerewolfAIController::execSetForcedThrowTarget(FFrame&, void* const)
native final function SetForcedThrowTarget(Pawn pawn_target, float Time, bool bSetForceEnemy);

// Export USPBaseWerewolfAIController::execDBG_GetPlayerPawn(FFrame&, void* const)
native function PlayerPawn DBG_GetPlayerPawn();

// Export USPBaseWerewolfAIController::execDBG_Break(FFrame&, void* const)
native function DBG_Break();

// Export USPBaseWerewolfAIController::execIsObjectStillValidToThrow(FFrame&, void* const)
native function bool IsObjectStillValidToThrow(Actor pTarget, out ThrowObjectInfo throwInfo);

// Export USPBaseWerewolfAIController::execFindPrivledgedObjectToThrow(FFrame&, void* const)
native final function int FindPrivledgedObjectToThrow(Actor enemyActor, out ThrowObjectInfo throwInfo);

// Export USPBaseWerewolfAIController::execEvalTarget(FFrame&, void* const)
native final function float EvalTarget(out PlayerInfo Entry, bool bReevaluatePathDistance);

// Export USPBaseWerewolfAIController::execGetTarget(FFrame&, void* const)
native final function int GetTarget(SPPawn TargetPawn);

// Export USPBaseWerewolfAIController::execGetBestTarget(FFrame&, void* const)
native final function int GetBestTarget();

// Export USPBaseWerewolfAIController::execGetHealthState(FFrame&, void* const)
native final function SPAIController.HealthState GetHealthState(SPPawn P);

// Export USPBaseWerewolfAIController::execClearExpiredTargetEntries(FFrame&, void* const)
native final function ClearExpiredTargetEntries();

// Export USPBaseWerewolfAIController::execTriggerTargetingEvents(FFrame&, void* const)
native final function TriggerTargetingEvents();

// Export USPBaseWerewolfAIController::execPickDefendAreaDestination(FFrame&, void* const)
native function bool PickDefendAreaDestination(optional bool bSkipCoverChecks);

// Export USPBaseWerewolfAIController::execGetBestEnemy(FFrame&, void* const)
native function Pawn GetBestEnemy(array<EnemyListInfo> enemyList, float MaxDistance, bool bTestOnly, out int outBestEnemyIdx, out float outBestEnemyDist);

// Export USPBaseWerewolfAIController::execRateEnemy(FFrame&, void* const)
native function float RateEnemy(Controller InPlayer);

// Export USPBaseWerewolfAIController::execGetAnimusPulseStaggerDirections(FFrame&, void* const)
native final function GetAnimusPulseStaggerDirections(const out Vector pulseDirection, out Rotator FacingDir, out SPBaseWerewolfPawnPersistent.eWerewolfActionState actionType);

function DBG_Msg(string Str)
{
    //return;    
}

function NotifyEnemy(SPAIController notifier, Controller NewEnemy)
{
    local float NotifyDist;

    // End:0x79
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        NotifyDist = 2500.0000000;
        // End:0x76
        if(VSizeSq(notifier.Pawn.Location - Pawn.Location) < (NotifyDist * NotifyDist))
        {
            super.NotifyEnemy(notifier, NewEnemy);
        }        
    }
    else
    {
        super.NotifyEnemy(notifier, NewEnemy);
    }
    //return;    
}

// Export USPBaseWerewolfAIController::execSearchForTargets(FFrame&, void* const)
native final function SearchForTargets();

final function DecideTarget(float Delta)
{
    // End:0x4B
    if((LastTargetListRepopulateTime + m_WerewolfGDTuneData.TargetListRepopulateTime) <= WorldInfo.TimeSeconds)
    {
        SearchForTargets();
        ClearExpiredTargetEntries();
        LastTargetListRepopulateTime = WorldInfo.TimeSeconds;
    }
    CumlativeTargetDelta += Delta;
    UpdateTargetTable();
    // End:0x8B
    if((CumlativeTargetDelta >= PickDelay) && bCurTargetsAllEvaluated == true)
    {
        AssignEnemy();
        CumlativeTargetDelta = 0.0000000;
    }
    //return;    
}

final function AssignEnemy()
{
    local int targetID;

    targetID = GetBestTarget();
    // End:0x85
    if(targetID > -1)
    {
        SetEnemy(m_playerList[targetID].Target, targetID);
        // End:0x82
        if(LastEnemy != m_playerList[targetID].Target)
        {
            TriggerTargetingEvents();
            LastEnemy = m_playerList[targetID].Target;
        }        
    }
    else
    {
        // End:0xC0
        if(IsAllowedToRoam())
        {
            SetEnemy(none);
            // End:0xB0
            if(IsRoaming())
            {
                return;                
            }
            else
            {
                GotoState('RoamForEnemy');
                return;
            }
        }
        // End:0xF1
        if(m_WerewolfPawn.bPlayFrustration)
        {
            // End:0xF1
            if((GetEnemy()) != none)
            {
                GotoState('Frustrated');
            }
        }
        SetEnemy(none);
    }
    //return;    
}

// Export USPBaseWerewolfAIController::execUpdateTargetTable(FFrame&, void* const)
native final function UpdateTargetTable();

simulated function PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    PlayerReplicationInfo.SetPlayerName(PlayerName);
    CacheAnimNodePointers();
    //return;    
}

simulated function CacheAnimNodePointers()
{
    // End:0x172
    if((Pawn != none) && Pawn.Mesh != none)
    {
        seqNodeBipedCloseDistance = SPAnimNodeSequence(Pawn.Mesh.Animations.FindAnimNode('BipedCloseDistance'));
        seqNodeQuadripedCloseDistance = SPAnimNodeSequence(Pawn.Mesh.Animations.FindAnimNode('QuadripedCloseDistance'));
        seqNodeMiscCloseDistance = SPAnimNodeSequence(Pawn.Mesh.Animations.FindAnimNode('MiscCloseDistance'));
        seqNodeBipedHitAndRun = SPAnimNodeSequence(Pawn.Mesh.Animations.FindAnimNode('BipedHitAndRun'));
        seqNodeQuadripedHitAndRun = SPAnimNodeSequence(Pawn.Mesh.Animations.FindAnimNode('QuadripedHitAndRun'));
        seqNodeOtherHitAndRun = SPAnimNodeSequence(Pawn.Mesh.Animations.FindAnimNode('OtherHitAndRun'));
    }
    //return;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTuneWerewolf();
    //return ReturnValue;    
}

function InitFromTuneData()
{
    m_WerewolfGDTuneData = SPGameDifficultyTuneWerewolf(GetMyGDData());
    fIgnoreDist = m_WerewolfGDTuneData.fIgnoreDist * m_WerewolfGDTuneData.fIgnoreDist;
    fIgnoreTimeout = m_WerewolfGDTuneData.fIgnoreTimeout;
    fIgnoreReturnTimeout = m_WerewolfGDTuneData.fIgnoreReturnTimeout;
    //return;    
}

function SpamError(string S, optional int Count = 5)
{
    local int I;

    I = 0;
    J0x0D:

    // End:0x26 [Loop If]
    if(I < Count)
    {
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

function NotifyFailedTackle()
{
    SpamError("Error - NotifyFailedTackle() called in wrong state in WerewolfAIController");
    //return;    
}

function Notify_Killshot()
{
    SpamError("Error - Notify_Killshot() called in wrong state in WerewolfAIController");
    //return;    
}

function ClearMaulDamageTimer()
{
    SpamError("Error - ClearMaulDamageTimer() called in wrong state in WerewolfAIController");
    //return;    
}

function Notify_HeadBlownOff()
{
    SpamError("Error - Notify_HeadBlownOff() called in wrong state in WerewolfAIController");
    //return;    
}

function Notify_GetUpEnded()
{
    SpamError("Error - Notify_GetUpEnded() called in wrong state in WerewolfAIController");
    //return;    
}

function Notify_KillshotWeaponFX()
{
    SpamError("Error - Notify_KillshotWeaponFX() called in wrong state in WerewolfAIController");
    //return;    
}

function Notify_KillshotWeaponFXFireParticleSystem(ParticleSystem ps, int systemNum)
{
    SpamError("Error - Notify_KillshotWeaponFXFireParticleSystem() called in wrong state in WerewolfAIController");
    //return;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    super.EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    // End:0x33
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    //return;    
}

event SuppressionDetected(out SuppressionMemory Suppression)
{
    local int PlayerIdx;

    m_lastSuppressionTime = WorldInfo.TimeSeconds;
    // End:0xBD
    if((Suppression.Instigator != none) && Suppression.Instigator.Controller != none)
    {
        PlayerIdx = GetPlayerIdx(Suppression.Instigator.Controller);
        // End:0xBD
        if(IsValidPlayerIdx(PlayerIdx))
        {
            // End:0xBD
            if(m_playerList[PlayerIdx].damageSustained <= 0.0000000)
            {
                m_playerList[PlayerIdx].damageSustained = 1.0000000;
            }
        }
    }
    //return;    
}

event ResetPathConstraints()
{
    super.ResetPathConstraints();
    //return;    
}

event WallAdjustFailed()
{
    bWallAdjustFailed = true;
    //return;    
}

function SetSuppressionConstraints()
{
    local float AngerLevel;

    AngerLevel = m_WerewolfPawn.GetAngerLevel();
    // End:0x79
    if(AngerLevel < 0.7500000)
    {
        m_SuppressionConstraints.ShouldTest = true;
        m_SuppressionConstraints.MaxAvoidanceDistance = 900.0000000;
        m_SuppressionConstraints.Strength = ((1.0000000 - AngerLevel) * 1.8000000) + 0.2000000;
    }
    //return;    
}

function SetPathConstraints()
{
    ResetPathConstraints();
    SetSuppressionConstraints();
    //return;    
}

function Tick(float ElapsedTime)
{
    // End:0x60
    if(((!m_bAIDisabled && Pawn != none) && Pawn.Health > 0) && !Pawn.IsPendingKill())
    {
        // End:0x5A
        if(bTargetingEnabled)
        {
            DecideTarget(ElapsedTime);
        }
        CheckForEatingFood();
    }
    super.Tick(ElapsedTime);
    //return;    
}

function ResetVarsOnPossess()
{
    ClearActiveConcentratedDamage();
    //return;    
}

event IdleFinished()
{
    //return;    
}

event ActionFinished()
{
    // End:0x6A
    if(((int(m_WerewolfPawn.GetActionState()) == int(14)) || int(m_WerewolfPawn.GetActionState()) == int(15)) || int(m_WerewolfPawn.GetActionState()) == int(16))
    {
        m_WerewolfPawn.ClearAction();
    }
    //return;    
}

event MeleeAttackFinished()
{
    SetPawnRotationRate(3072, 4096, 80000);
    // End:0x86
    if(m_WerewolfPawn.IsDoingHitAndRunCloseTheGapAnimation())
    {
        m_meleeAttackCounter--;
        m_WerewolfPawn.ClearAction();
        // End:0x74
        if(int(m_WerewolfPawn.m_hitAndRunAnimState) == int(1))
        {
            m_WerewolfPawn.SetHitAndRunState(3);            
        }
        else
        {
            m_WerewolfPawn.SetHitAndRunState(4);
        }
    }
    // End:0x1A5
    if(((((((((int(m_WerewolfPawn.GetActionState()) == int(1)) || int(m_WerewolfPawn.GetActionState()) == int(2)) || int(m_WerewolfPawn.GetActionState()) == int(17)) || int(m_WerewolfPawn.GetActionState()) == int(19)) || int(m_WerewolfPawn.GetActionState()) == int(18)) || int(m_WerewolfPawn.GetActionState()) == int(20)) || int(m_WerewolfPawn.GetActionState()) == int(21)) || int(m_WerewolfPawn.GetActionState()) == int(65)) || int(m_WerewolfPawn.GetActionState()) == int(66))
    {
        m_meleeAttackCounter--;
        m_WerewolfPawn.ClearAction();
    }
    //return;    
}

event HitDeathAnimFinished()
{
    //return;    
}

final function StartAction(SPBaseWerewolfPawnPersistent.eWerewolfActionState Type, optional bool bForceReset, optional float animationSynchTime)
{
    // End:0x59
    if(int(m_WerewolfPawn.GetActionState()) != int(Type))
    {
        m_WerewolfPawn.SetActionStateLast(m_WerewolfPawn.GetActionState());
        m_WerewolfPawn.SetAnimActionState(Type, true);        
    }
    else
    {
        m_WerewolfPawn.SetAnimActionState(Type, bForceReset);
    }
    m_WerewolfPawn.SetAnimationSynchronizationTime(animationSynchTime);
    //return;    
}

final function StartUpperBodyAction(SPBaseWerewolfPawnPersistent.eWerewolfActionState Type, optional bool bForceReset)
{
    m_WerewolfPawn.SetAnimUpperBodyState(Type, true);
    //return;    
}

final function StartMeleeDodge(SPBaseWerewolfPawnPersistent.eWerewolfMeleeDodgeState Type, optional bool bForceReset)
{
    // End:0x38
    if(int(m_WerewolfPawn.GetAnimMeleeDodgeState()) != int(Type))
    {
        m_WerewolfPawn.SetAnimMeleeDodgeState(Type, true);        
    }
    else
    {
        m_WerewolfPawn.SetAnimMeleeDodgeState(Type, bForceReset);
    }
    //return;    
}

final function ClearMeleeDodge(optional bool bRestart)
{
    m_WerewolfPawn.SetAnimMeleeDodgeState(0, bRestart);
    m_bIsDoingFullBodyMeleeDodge = false;
    //return;    
}

function bool ShouldIGotoDefendArea(optional bool bInIdleState)
{
    // End:0x20
    if((Pawn == none) || IsActorInDefendArea(Pawn))
    {
        return false;
    }
    // End:0x2D
    if(!bInIdleState)
    {
        return false;
    }
    // End:0x3D
    if(PickDefendAreaDestination(true))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TransitionToDefendArea()
{
    // End:0x11
    if(m_defendAreaKyVertID == -1)
    {
        return;
    }
    GotoState('GotoDefendAreaDestination');
    //return;    
}

function bool ShouldIPursueEnemy()
{
    return false;
    //return ReturnValue;    
}

function NotifyDying()
{
    ClearActiveConcentratedDamage();
    // End:0x1D
    if(IsInState('TakeHit'))
    {
        PopState();
    }
    // End:0x3F
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

final function bool IsAnyConcentratedReactionActive()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x51 [Loop If]
    if(I < m_WerewolfPawn.m_rtConcentratedDamageInfo.Length)
    {
        // End:0x47
        if(m_WerewolfPawn.m_rtConcentratedDamageInfo[I].bIsActive)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

final function CheckForConcentratedDamage(name damageGroupName, int Damage, Vector Momentum, class<DamageType> DamageType)
{
    local int concentratedIndex;
    local float damagePercent;
    local int gdDataIndex;

    // End:0x1C
    if(int(m_WerewolfPawn.Physics) == int(8))
    {
        return;
    }
    concentratedIndex = GetConcentratedDamage(damageGroupName, DamageType, Momentum, float(Damage), damagePercent, gdDataIndex);
    // End:0x5D
    if(concentratedIndex == -1)
    {
        return;
    }
    // End:0x2AF
    if(m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bAllowConcentratedReaction && !m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bIsActive)
    {
        // End:0x2AC
        if((WorldInfo.TimeSeconds - m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].LastActiveTime) >= m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].timeOutInterval)
        {
            // End:0x17F
            if((WorldInfo.TimeSeconds - m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].lastHitTime) <= m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].maxDamageInterval)
            {
                m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].concentratedDamagePercent += damagePercent;                
            }
            else
            {
                m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].concentratedDamagePercent = damagePercent;
            }
            m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].lastHitTime = WorldInfo.TimeSeconds;
            // End:0x2AC
            if(m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].concentratedDamagePercent >= 1.0000000)
            {
                switch(concentratedIndex)
                {
                    // End:0x20B
                    case 0:
                    // End:0x222
                    case 1:
                        ConcentratedArmDamage(concentratedIndex, gdDataIndex);
                        // End:0x2AC
                        break;
                    // End:0x23A
                    case 2:
                        ConcentratedHeadDamage(concentratedIndex, gdDataIndex);
                        // End:0x2AC
                        break;
                    // End:0x25C
                    case 6:
                        ConcentratedAnimusPulseDamage(concentratedIndex, gdDataIndex, Momentum, DamageType);
                        // End:0x2AC
                        break;
                    // End:0x261
                    case 3:
                    // End:0x283
                    case 4:
                        ConcentratedTorsoDamage(concentratedIndex, gdDataIndex, Momentum, DamageType);
                        // End:0x2AC
                        break;
                    // End:0x2A9
                    case 5:
                        ConcentratedBackDamage(concentratedIndex, gdDataIndex, Momentum, DamageType);
                        // End:0x2AC
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
            }
            else
            {
            }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x2AC! */            
        }
        else
        {
            // End:0x2EC
            if((concentratedIndex == 4) && m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bIsActive)
            {
                ContinueConcentratedTorsoDamage(gdDataIndex);
            }
        }
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x05D! */
}

function bool CheckEarlyOutOptionsForAnimusPulse()
{
    return true;
    //return ReturnValue;    
}

function bool CheckEarlyOutOptionsForHeadDamage()
{
    // End:0x18
    if(m_WerewolfPawn.IsBiped() == false)
    {
        return false;
    }
    // End:0x3D
    if(!m_WerewolfPawn.m_rtConcentratedDamageInfo[2].bAllowConcentratedReaction)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CheckEarlyOutOptionsForTorsoDamage()
{
    // End:0x18
    if(m_WerewolfPawn.IsBiped() == false)
    {
        return false;
    }
    // End:0x62
    if(!m_WerewolfPawn.m_rtConcentratedDamageInfo[3].bAllowConcentratedReaction && !m_WerewolfPawn.m_rtConcentratedDamageInfo[4].bAllowConcentratedReaction)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CheckEarlyOutOptionsForArmDamage()
{
    // End:0x23
    if(IsAnyConcentratedReactionActive() || m_WerewolfPawn.IsBiped() == false)
    {
        return false;
    }
    // End:0x6B
    if(!m_WerewolfPawn.m_rtConcentratedDamageInfo[0].bAllowConcentratedReaction && !m_WerewolfPawn.m_rtConcentratedDamageInfo[1].bAllowConcentratedReaction)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function int GetConcentratedDamage(name damageGroupName, class<DamageType> DamageType, Vector Momentum, float DamageAmount, out float damagePercentOut, out int gdDataIndex)
{
    local int I;

    gdDataIndex = -1;
    // End:0xB2
    if((DamageType == Class'SPDamageTypeAnimusPulse') || DamageType == Class'SPDamageTypeExplosionFireDrakeImmolate')
    {
        // End:0xB2
        if(CheckEarlyOutOptionsForAnimusPulse())
        {
            // End:0x63
            if(m_WerewolfPawn.m_rtConcentratedDamageInfo[6].bIsActive)
            {
                StaggerBackFinished();
            }
            damagePercentOut = 1.0000000;
            m_WerewolfPawn.m_rtConcentratedDamageInfo[6].maxDamageInterval = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.AnimusPulseDamageMaxContinuedDamageInterval);
            return 6;
        }
    }
    // End:0x2CF
    if(CheckEarlyOutOptionsForHeadDamage())
    {
        // End:0x2CF
        if(((((damageGroupName == 'head') || damageGroupName == 'LowerRightArm') || damageGroupName == 'LowerLeftArm') || damageGroupName == 'UpperRightArm') || damageGroupName == 'UpperLeftArm')
        {
            I = 0;
            J0x12D:

            // End:0x2CF [Loop If]
            if(I < m_WerewolfGDTuneData.HeadDamageInfo.Length)
            {
                // End:0x2C5
                if(((damageGroupName == 'head') || m_WerewolfGDTuneData.HeadDamageInfo[I].bForceInduceByUpperArmDamage && (damageGroupName == 'UpperRightArm') || damageGroupName == 'UpperLeftArm') || m_WerewolfGDTuneData.HeadDamageInfo[I].bForceInduceByLowerArmDamage && (damageGroupName == 'LowerRightArm') || damageGroupName == 'LowerLeftArm')
                {
                    // End:0x2C5
                    if(DamageType == m_WerewolfGDTuneData.HeadDamageInfo[I].DamageTypeClass)
                    {
                        damagePercentOut = DamageAmount / m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HeadDamageInfo[I].DamageThreshold);
                        m_WerewolfPawn.m_rtConcentratedDamageInfo[2].maxDamageInterval = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HeadDamageInfo[I].MaxContinuedDamageInterval);
                        gdDataIndex = I;
                        return 2;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x12D;
            }
        }
    }
    // End:0x742
    if(CheckEarlyOutOptionsForTorsoDamage())
    {
        // End:0x742
        if((((((damageGroupName == 'head') || damageGroupName == 'UpperLeftLeg') || damageGroupName == 'UpperRightLeg') || damageGroupName == 'UpperRightArm') || damageGroupName == 'UpperLeftArm') || damageGroupName == 'Torso')
        {
            I = 0;
            J0x35F:

            // End:0x562 [Loop If]
            if(I < m_WerewolfGDTuneData.KnockBackInfo.Length)
            {
                // End:0x558
                if(m_WerewolfGDTuneData.KnockBackInfo[I].EvaluatorCondition != -1)
                {
                    // End:0x558
                    if(DamageType == m_WerewolfGDTuneData.KnockBackInfo[I].DamageTypeClass)
                    {
                        // End:0x40E
                        if((damageGroupName == 'head') && !m_WerewolfGDTuneData.KnockBackInfo[I].bCanBeInducedByHeadDamage)
                        {
                            // [Explicit Break]
                            goto J0x562;                            
                        }
                        else
                        {
                            // End:0x464
                            if(((damageGroupName == 'UpperLeftLeg') || damageGroupName == 'UpperRightLeg') && !m_WerewolfGDTuneData.KnockBackInfo[I].bCanBeInducedByUpperLegDamage)
                            {
                                // [Explicit Break]
                                goto J0x562;                                
                            }
                            else
                            {
                                // End:0x4B7
                                if(((damageGroupName == 'UpperRightArm') || damageGroupName == 'UpperLeftArm') && !m_WerewolfGDTuneData.KnockBackInfo[I].bForceInduceByUpperArmDamage)
                                {
                                    // [Explicit Break]
                                    goto J0x562;
                                }
                            }
                        }
                        damagePercentOut = DamageAmount / m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.KnockBackInfo[I].DamageThreshold);
                        m_WerewolfPawn.m_rtConcentratedDamageInfo[3].maxDamageInterval = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.KnockBackInfo[I].MaxContinuedDamageInterval);
                        gdDataIndex = I;
                        return 3;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x35F;
            }
            J0x562:

            I = 0;
            J0x569:

            // End:0x742 [Loop If]
            if(I < m_WerewolfGDTuneData.StaggerInfo.Length)
            {
                // End:0x738
                if(DamageType == m_WerewolfGDTuneData.StaggerInfo[I].DamageTypeClass)
                {
                    // End:0x5EE
                    if((damageGroupName == 'head') && !m_WerewolfGDTuneData.StaggerInfo[I].bCanBeInducedByHeadDamage)
                    {
                        // [Explicit Break]
                        goto J0x742;                        
                    }
                    else
                    {
                        // End:0x644
                        if(((damageGroupName == 'UpperLeftLeg') || damageGroupName == 'UpperRightLeg') && !m_WerewolfGDTuneData.StaggerInfo[I].bCanBeInducedByUpperLegDamage)
                        {
                            // [Explicit Break]
                            goto J0x742;                            
                        }
                        else
                        {
                            // End:0x697
                            if(((damageGroupName == 'UpperRightArm') || damageGroupName == 'UpperLeftArm') && !m_WerewolfGDTuneData.StaggerInfo[I].bForceInduceByUpperArmDamage)
                            {
                                // [Explicit Break]
                                goto J0x742;
                            }
                        }
                    }
                    damagePercentOut = DamageAmount / m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerInfo[I].DamageThreshold);
                    m_WerewolfPawn.m_rtConcentratedDamageInfo[4].maxDamageInterval = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerInfo[I].MaxContinuedDamageInterval);
                    gdDataIndex = I;
                    return 4;
                }
                I++;
                // [Loop Continue]
                goto J0x569;
            }
        }
    }
    J0x742:

    // End:0x91E
    if(CheckEarlyOutOptionsForArmDamage())
    {
        // End:0x91E
        if((((damageGroupName == 'UpperRightArm') || damageGroupName == 'UpperLeftArm') || damageGroupName == 'LowerRightArm') || damageGroupName == 'LowerLeftArm')
        {
            I = 0;
            J0x7A8:

            // End:0x91E [Loop If]
            if(I < m_WerewolfGDTuneData.ArmBreakInfo.Length)
            {
                // End:0x914
                if(DamageType == m_WerewolfGDTuneData.ArmBreakInfo[I].DamageTypeClass)
                {
                    damagePercentOut = DamageAmount / m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.ArmBreakInfo[I].DamageThreshold);
                    // End:0x8B6
                    if((damageGroupName == 'UpperRightArm') || damageGroupName == 'LowerRightArm')
                    {
                        m_WerewolfPawn.m_rtConcentratedDamageInfo[0].maxDamageInterval = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.ArmBreakInfo[I].MaxContinuedDamageInterval);
                        gdDataIndex = I;
                        return 0;
                        // [Explicit Continue]
                        goto J0x914;
                    }
                    m_WerewolfPawn.m_rtConcentratedDamageInfo[1].maxDamageInterval = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.ArmBreakInfo[I].MaxContinuedDamageInterval);
                    gdDataIndex = I;
                    return 1;
                }
                J0x914:

                I++;
                // [Loop Continue]
                goto J0x7A8;
            }
        }
    }
    return -1;
    //return ReturnValue;    
}

final function ContinueConcentratedTorsoDamage(int gdDataIndex)
{
    local float maxTimeLeft, maxLoopTime, StaggerTimePerShot;

    // End:0x25
    if(!m_WerewolfPawn.m_rtConcentratedDamageInfo[4].bIsActive)
    {
        return;
    }
    // End:0x42
    if(int(m_WerewolfPawn.GetActionState()) != int(27))
    {
        return;
    }
    maxLoopTime = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerInfo[gdDataIndex].MaxStaggerTime);
    maxTimeLeft = (m_concentratedTorsoDamageStaggerStartTime + maxLoopTime) - WorldInfo.TimeSeconds;
    // End:0xB0
    if(maxTimeLeft <= 0.0000000)
    {
        return;
    }
    ClearTimer('StaggerBackFinished');
    StaggerTimePerShot = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerInfo[gdDataIndex].StaggerTimePerShot);
    SetTimer(StaggerTimePerShot, false, 'StaggerBackFinished');
    //return;    
}

function ConcentratedBackDamage(int concentratedIndex, int gdDataIndex, Vector Momentum, class<DamageType> DamageType)
{
    //return;    
}

final function ConcentratedAnimusPulseDamage(int concentratedIndex, int gdDataIndex, Vector Momentum, class<DamageType> DamageType)
{
    local Rotator facingRot;
    local SPBaseWerewolfPawnPersistent.eWerewolfActionState actionType;

    // End:0x0B
    if(m_bAIDisabled)
    {
        return;
    }
    // End:0x2D
    if(int(m_WerewolfPawn.GetAnimMeleeDodgeState()) != int(0))
    {
        ClearMeleeDodge();
    }
    // End:0x50
    if(m_WerewolfPawn.HasConcentratedArmDamage())
    {
        m_WerewolfPawn.HealArmFinished();
    }
    // End:0x65
    if(HasConcentratedTorsoDamage())
    {
        StaggerBackFinished();
    }
    // End:0x74
    if(HasConcentratedHeadDamage())
    {
        CancelConcentratedHeadDamage();
    }
    // End:0x9D
    if(m_WerewolfPawn.CATDefenderPawn != none)
    {
        m_WerewolfPawn.AbortCATAnimation();
    }
    m_WerewolfPawn.m_rtConcentratedDamageInfo[6].bIsActive = true;
    m_WerewolfPawn.concentratedTorsoDamageType = Class'SPDamageTypeShotgun';
    Focus = none;
    m_animusPulseDirection = Momentum;
    // End:0x124
    if(m_bInMeleeMode)
    {
        GetAnimusPulseStaggerDirections(Momentum, facingRot, actionType);
        m_WerewolfPawn.SetRotation(facingRot);
        StartAction(actionType, true);        
    }
    else
    {
        GotoState('NonMeleeAnimusPulseReaction');
    }
    //return;    
}

final function ConcentratedTorsoDamage(int concentratedIndex, int gdDataIndex, Vector Momentum, class<DamageType> DamageType)
{
    local float StaggerTimePerShot;

    // End:0x0B
    if(IsAnyConcentratedReactionActive())
    {
        return;
    }
    // End:0xE2
    if(concentratedIndex != 6)
    {
        // End:0xE2
        if(((((((int(m_WerewolfPawn.GetActionState()) != int(1)) && int(m_WerewolfPawn.GetActionState()) != int(2)) && int(m_WerewolfPawn.GetActionState()) != int(65)) && int(m_WerewolfPawn.GetActionState()) != int(17)) && int(m_WerewolfPawn.GetActionState()) != int(18)) && int(m_WerewolfPawn.GetActionState()) != int(19)) && int(m_WerewolfPawn.GetActionState()) != int(0))
        {
            return;
        }
    }
    // End:0x106
    if((Momentum Dot Vector(Pawn.Rotation)) > 0.0000000)
    {
        return;
    }
    // End:0x123
    if(int(m_WerewolfPawn.GetAnimMeleeDodgeState()) != int(0))
    {
        return;
    }
    m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bIsActive = true;
    m_WerewolfPawn.concentratedTorsoDamageType = DamageType;
    m_concentratedTorsoDamageStaggerStartTime = WorldInfo.TimeSeconds;
    ClearTimer('StaggerBackFinished');
    // End:0x1D9
    if(concentratedIndex == 4)
    {
        StaggerTimePerShot = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerInfo[gdDataIndex].StaggerTimePerShot);
        SetTimer(StaggerTimePerShot, false, 'StaggerBackFinished');
    }
    StartAction(27);
    //return;    
}

function StaggerBackFinished()
{
    local float Min, Max;
    local SPBaseWerewolfPawnPersistent.eWerewolfActionState CurrentAction;

    CurrentAction = m_WerewolfPawn.GetActionState();
    // End:0x71
    if((((int(CurrentAction) == int(27)) || int(CurrentAction) == int(28)) || int(CurrentAction) == int(29)) || int(CurrentAction) == int(30))
    {
        m_WerewolfPawn.ClearAction();
    }
    ClearTimer('StaggerBackFinished');
    m_WerewolfPawn.m_rtConcentratedDamageInfo[3].bIsActive = false;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[3].LastActiveTime = WorldInfo.TimeSeconds;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[3].concentratedDamagePercent = 0.0000000;
    Min = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.KnockBackMinTimeToReset);
    Max = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.KnockBackMaxTimeToReset);
    m_WerewolfPawn.m_rtConcentratedDamageInfo[3].timeOutInterval = RandRange(Min, Max);
    m_WerewolfPawn.m_rtConcentratedDamageInfo[6].bIsActive = false;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[6].LastActiveTime = WorldInfo.TimeSeconds;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[6].concentratedDamagePercent = 0.0000000;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[6].timeOutInterval = 0.0000000;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[4].bIsActive = false;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[4].LastActiveTime = WorldInfo.TimeSeconds;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[4].concentratedDamagePercent = 0.0000000;
    Min = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerMinTimeToReset);
    Max = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.StaggerMaxTimeToReset);
    m_WerewolfPawn.m_rtConcentratedDamageInfo[4].timeOutInterval = RandRange(Min, Max);
    //return;    
}

final function bool HasConcentratedTorsoDamage(optional bool bDontCheckNonMMGun, optional bool bDontCheckMMGun)
{
    return ((!bDontCheckNonMMGun && m_WerewolfPawn.m_rtConcentratedDamageInfo[3].bIsActive) || !bDontCheckNonMMGun && m_WerewolfPawn.m_rtConcentratedDamageInfo[6].bIsActive) || !bDontCheckMMGun && m_WerewolfPawn.m_rtConcentratedDamageInfo[4].bIsActive;
    //return ReturnValue;    
}

final function bool HasConcentratedHeadDamage()
{
    return m_WerewolfPawn.m_rtConcentratedDamageInfo[2].bIsActive;
    //return ReturnValue;    
}

final function ConcentratedHeadDamage(int concentratedIndex, int gdDataIndex)
{
    // End:0x29
    if(HasConcentratedHeadDamage() && m_bStartConcentratedHeadDamage)
    {
        SetTimer(1.5000000, false, 'CancelConcentratedHeadDamage');
        return;
    }
    // End:0x34
    if(IsAnyConcentratedReactionActive())
    {
        return;
    }
    m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bIsActive = true;
    m_bStartConcentratedHeadDamage = true;
    SetTimer(1.5000000, false, 'CancelConcentratedHeadDamage');
    //return;    
}

final function CancelConcentratedHeadDamage()
{
    ConcentratedHeadDamageFinish(false);
    //return;    
}

final function StartConcentratedHeadDamage()
{
    StartUpperBodyAction(24);
    m_bStartConcentratedHeadDamage = false;
    ClearTimer('CancelConcentratedHeadDamage');
    m_headDamageStartTime = WorldInfo.TimeSeconds;
    m_headDamageLastHeadHitTime = 0;
    SetTimer(0.1000000, true, 'UpdateConcentratedHeadDamage');
    //return;    
}

final function UpdateConcentratedHeadDamage()
{
    local float maxTime, LastDamageTime;

    // End:0x32
    if(int(m_WerewolfPawn.GetActionState()) != int(25))
    {
        m_headDamageStartTime = WorldInfo.TimeSeconds;
        return;
    }
    // End:0x79
    if(((GetEnemy()) != none) && SPPawn(GetEnemy()).IsReloading())
    {
        ClearTimer('UpdateConcentratedHeadDamage');
        StartRecoverFromConcentratedHeadDamage();
        return;
    }
    // End:0x96
    if(m_lastDamageTime < m_headDamageStartTime)
    {
        LastDamageTime = m_headDamageStartTime;        
    }
    else
    {
        LastDamageTime = m_lastDamageTime;
    }
    // End:0xD9
    if((WorldInfo.TimeSeconds - LastDamageTime) > 1.0000000)
    {
        ClearTimer('UpdateConcentratedHeadDamage');
        StartRecoverFromConcentratedHeadDamage();
        return;
    }
    // End:0x109
    if((WorldInfo.TimeSeconds - float(m_headDamageLastHeadHitTime)) < 1.0000000)
    {
        maxTime = 3.0000000;        
    }
    else
    {
        maxTime = 1.5000000;
    }
    // End:0x14C
    if((WorldInfo.TimeSeconds - m_headDamageStartTime) > maxTime)
    {
        ClearTimer('UpdateConcentratedHeadDamage');
        StartRecoverFromConcentratedHeadDamage();
        return;
    }
    //return;    
}

final function ConcentratedHeadDamageFinish(bool bSuccessfullyFinished)
{
    local float Min, Max;

    m_bStartConcentratedHeadDamage = false;
    ClearTimer('CancelConcentratedHeadDamage');
    // End:0xF1
    if(bSuccessfullyFinished)
    {
        m_WerewolfPawn.m_rtConcentratedDamageInfo[2].LastActiveTime = WorldInfo.TimeSeconds;
        Min = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HeadDamageMinTimeToReset);
        Max = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.HeadDamageMaxTimeToReset);
        m_WerewolfPawn.m_rtConcentratedDamageInfo[2].timeOutInterval = RandRange(Min, Max);
        m_WerewolfPawn.m_rtConcentratedDamageInfo[2].concentratedDamagePercent = 0.0000000;
    }
    m_WerewolfPawn.m_rtConcentratedDamageInfo[2].bIsActive = false;
    // End:0x141
    if(int(m_WerewolfPawn.GetActionState()) == int(26))
    {
        m_WerewolfPawn.ClearAction();
    }
    //return;    
}

final function UpperBodyActionFinished()
{
    // End:0x27
    if(int(m_WerewolfPawn.GetActionState()) == int(24))
    {
        StartUpperBodyAction(25);        
    }
    else
    {
        // End:0x49
        if(int(m_WerewolfPawn.GetActionState()) == int(26))
        {
            ConcentratedHeadDamageFinish(true);
        }
    }
    //return;    
}

final function StartRecoverFromConcentratedHeadDamage()
{
    // End:0x41
    if((int(m_WerewolfPawn.GetActionState()) == int(24)) || int(m_WerewolfPawn.GetActionState()) == int(25))
    {
        StartUpperBodyAction(26);
    }
    //return;    
}

final function ConcentratedArmDamage(int concentratedIndex, int gdDataIndex)
{
    // End:0x0B
    if(IsAnyConcentratedReactionActive())
    {
        return;
    }
    // End:0x2A
    if(!m_WerewolfPawn.PerformArmBreak(concentratedIndex == 0))
    {
        return;
    }
    m_WerewolfPawn.m_bHasConcentratedArmDamage = true;
    m_bAllowConcentratedArmDamageRecovery = false;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bIsActive = true;
    m_armRecoveryStartTime = WorldInfo.TimeSeconds;
    SetTimer(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.ArmDisabledTime), false, 'StartRecoverFromConcentratedArmDamage');
    //return;    
}

final function StartRecoverFromConcentratedArmDamage()
{
    // End:0x14
    if(m_bInMeleeMode)
    {
        m_bAllowConcentratedArmDamageRecovery = true;        
    }
    else
    {
        // End:0x45
        if(m_WerewolfPawn.IsConcentratedDamageActive(0))
        {
            m_WerewolfPawn.PerformArmHeal(true);
            StartUpperBodyAction(22, true);            
        }
        else
        {
            // End:0x76
            if(m_WerewolfPawn.IsConcentratedDamageActive(1))
            {
                m_WerewolfPawn.PerformArmHeal(false);
                StartUpperBodyAction(23, true);                
            }
            else
            {
                m_WerewolfPawn.HealArmFinished();
            }
        }
    }
    //return;    
}

final function HealArmFinished()
{
    local float Min, Max;

    ClearTimer('StartRecoverFromConcentratedArmDamage');
    m_WerewolfPawn.m_bHasConcentratedArmDamage = false;
    m_bAllowConcentratedArmDamageRecovery = false;
    Min = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.ArmDamageMinTimeToReset);
    Max = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.ArmDamageMaxTimeToReset);
    m_WerewolfPawn.m_rtConcentratedDamageInfo[0].LastActiveTime = WorldInfo.TimeSeconds;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[0].timeOutInterval = RandRange(Min, Max);
    m_WerewolfPawn.m_rtConcentratedDamageInfo[1].LastActiveTime = WorldInfo.TimeSeconds;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[1].timeOutInterval = RandRange(Min, Max);
    m_WerewolfPawn.m_rtConcentratedDamageInfo[0].concentratedDamagePercent = 0.0000000;
    m_WerewolfPawn.m_rtConcentratedDamageInfo[1].concentratedDamagePercent = 0.0000000;
    // End:0x1A5
    if(m_WerewolfPawn.IsConcentratedDamageActive(0))
    {
        m_WerewolfPawn.m_rtConcentratedDamageInfo[0].bIsActive = false;
    }
    // End:0x1D8
    if(m_WerewolfPawn.IsConcentratedDamageActive(1))
    {
        m_WerewolfPawn.m_rtConcentratedDamageInfo[1].bIsActive = false;
    }
    // End:0x225
    if((int(m_WerewolfPawn.GetActionState()) == int(22)) || int(m_WerewolfPawn.GetActionState()) == int(23))
    {
        m_WerewolfPawn.ClearAction();
    }
    //return;    
}

final function AllowConcentratedDamageActive(int concentratedIndex, bool bStatus)
{
    m_WerewolfPawn.m_rtConcentratedDamageInfo[concentratedIndex].bAllowConcentratedReaction = bStatus;
    //return;    
}

final function ClearActiveConcentratedDamage()
{
    local int I;

    // End:0x23
    if(m_WerewolfPawn.HasConcentratedArmDamage())
    {
        m_WerewolfPawn.HealArmFinished();
    }
    // End:0x33
    if(HasConcentratedHeadDamage())
    {
        ConcentratedHeadDamageFinish(false);
    }
    I = 0;
    J0x3A:

    // End:0x81 [Loop If]
    if(I < m_WerewolfPawn.m_rtConcentratedDamageInfo.Length)
    {
        m_WerewolfPawn.m_rtConcentratedDamageInfo[I].bIsActive = false;
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    //return;    
}

function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local name damageGroupName;

    super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x43
    if(ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse') && Damage < 1)
    {
        Damage = 1;
    }
    // End:0x13D
    if(((Pawn != none) && Damage > 0) && Pawn.Health > 0)
    {
        // End:0xB4
        if(ClassIsChildOf(DamageType, Class'SPDamageTypeProjectileLargeAny') || ClassIsChildOf(DamageType, Class'SPDamageTypeShotgun'))
        {
            m_currentSlowDownBias = 0.0000000;
            m_lastMediumWeaponHitTime = WorldInfo.TimeSeconds;
        }
        // End:0xE9
        if((damageGroupName == 'head') && HasConcentratedHeadDamage())
        {
            m_headDamageLastHeadHitTime = int(WorldInfo.TimeSeconds);
        }
        m_lastDamageTime = WorldInfo.TimeSeconds;
        damageGroupName = m_WerewolfPawn.GetHitLocationGroup(m_WerewolfPawn.m_takeDamageBone);
        CheckForConcentratedDamage(damageGroupName, Damage, Momentum, DamageType);
    }
    //return;    
}

final function TryKnockWerewolfOffWall(float Damage)
{
    //return;    
}

function KnockWerewolfOffWall()
{
    local Vector SurfaceNormal;

    SurfaceNormal = Pawn.Floor;
    m_WerewolfPawn.SetWalkMovementType(m_WerewolfPawn.IsBiped());
    Pawn.SetPhysics(2);
    Pawn.Velocity = float(400) * SurfaceNormal;
    RestartMove();
    //return;    
}

function MayFall()
{
    //return;    
}

function bool CanDoThrowObjectAttack()
{
    local bool bFindObjectResult;

    // End:0x2B
    if(!bOnlyAllowThrowingAttacks)
    {
        // End:0x2B
        if(m_WerewolfPawn.HasConcentratedArmDamage() || HasConcentratedHeadDamage())
        {
            return false;
        }
    }
    m_moveToThrowObjectInfo.objectToThrow = none;
    m_moveToThrowObjectInfo.preferredRangeToTarget = 1500.0000000;
    m_moveToThrowObjectInfo.minRangeToTarget = 300.0000000;
    m_moveToThrowObjectInfo.maxRangeToTarget = 3500.0000000;
    m_moveToThrowObjectInfo.preferredRangeToUs = 0.0000000;
    m_moveToThrowObjectInfo.RangeToTargetWeight = 1.0000000;
    m_moveToThrowObjectInfo.minRangeToUs = -1.0000000;
    m_moveToThrowObjectInfo.maxRangeToUs = 2000.0000000;
    m_moveToThrowObjectInfo.rangeToUsWeight = 2.0000000;
    bFindObjectResult = FindObjectToThrow(GetEnemy(), m_moveToThrowObjectInfo);
    // End:0x184
    if(!bFindObjectResult)
    {
        // End:0x184
        if(bOnlyAllowThrowingAttacks)
        {
            // End:0x184
            if(PrivledgedThrowList.Length > 0)
            {
                PrivledgedThrowID = FindPrivledgedObjectToThrow(GetEnemy(), m_moveToThrowObjectInfo);
                // End:0x15E
                if(PrivledgedThrowID != -1)
                {
                    bFindObjectResult = true;                    
                }
                else
                {
                    bFindObjectResult = false;
                    // End:0x177
                    if(bExitForceThrowOnListDepletion)
                    {
                        bOnlyAllowThrowingAttacks = false;
                    }
                    PrivledgedThrowList.Remove(0, PrivledgedThrowList.Length);
                }
            }
        }
    }
    return bFindObjectResult;
    //return ReturnValue;    
}

final function bool AmIFarEnoughToHitAndRun(Actor hitAndRunTarget)
{
    local float distSquared;

    distSquared = VSizeSq(hitAndRunTarget.Location - Pawn.Location);
    // End:0x58
    if(distSquared > (m_WerewolfGDTuneData.MinHitAndRunStartDist * m_WerewolfGDTuneData.MinHitAndRunStartDist))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CouldIHitAndRun(Actor hitAndRunTarget)
{
    local PlayerPawn pPawn;

    pPawn = PlayerPawn(hitAndRunTarget);
    // End:0x1D
    if(pPawn == none)
    {
        return false;
    }
    // End:0x34
    if(pPawn.Health <= 0)
    {
        return false;
    }
    // End:0x5C
    if(float(m_squad.m_members.Length) < m_WerewolfGDTuneData.MinSquadMembersForHitAndRun)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final function bool CanIHitAndRunMinigame(Actor hitAndRunTarget)
{
    return false;
    //return ReturnValue;    
}

function name SelectAttackState()
{
    local int CurLevel, dice;
    local bool ThrowObjectPossible, HitAndRunPossible, bIsEnemyInvalidatedMoveGoal;
    local float rageLevelMeleeChance, rageLevelHitAndRunChance, rageLevelThrowChance;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    CurLevel = m_WerewolfPawn.GetCurrentRageLevelIndex();
    bIsEnemyInvalidatedMoveGoal = IsInvalidatedMoveGoal(pEnemyPawn);
    // End:0x69
    if(bOnlyAllowThrowingAttacks)
    {
        // End:0x5C
        if(!CanDoThrowObjectAttack())
        {
            bOnlyAllowThrowingAttacks = false;            
        }
        else
        {
            return 'ThrowObject';
        }        
    }
    else
    {
        // End:0x7C
        if(bOnlyAllowMeleeAttacks)
        {
            return 'Melee';
        }
    }
    // End:0x98
    if(CurLevel == -1)
    {
        return 'Melee';        
    }
    else
    {
        // End:0xAB
        if(bForceHAR)
        {
            return 'HitAndRun';
        }
        rageLevelMeleeChance = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RageDataParams[CurLevel].Attack.Melee);
        rageLevelHitAndRunChance = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RageDataParams[CurLevel].Attack.HitAndRun);
        rageLevelThrowChance = m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RageDataParams[CurLevel].Attack.ThrowObject);
        dice = Rand(int(((rageLevelMeleeChance + rageLevelHitAndRunChance) + rageLevelThrowChance) + m_extraHitAndRunChance));
        ThrowObjectPossible = (float(dice) < rageLevelThrowChance) || bIsEnemyInvalidatedMoveGoal;
        ThrowObjectPossible = ThrowObjectPossible && CanDoThrowObjectAttack();
        // End:0x25C
        if(!ThrowObjectPossible)
        {
            dice = Rand(int((rageLevelMeleeChance + rageLevelHitAndRunChance) + m_extraHitAndRunChance));
            HitAndRunPossible = float(dice) < (rageLevelHitAndRunChance + m_extraHitAndRunChance);
            HitAndRunPossible = ((HitAndRunPossible && !bIsEnemyInvalidatedMoveGoal) && CouldIHitAndRun(pEnemyPawn)) && AmIFarEnoughToHitAndRun(pEnemyPawn);
        }
        // End:0x272
        if(ThrowObjectPossible)
        {
            return 'ThrowObject';            
        }
        else
        {
            // End:0x288
            if(HitAndRunPossible)
            {
                return 'HitAndRun';                
            }
            else
            {
                return 'Melee';
            }
        }
    }
    //return ReturnValue;    
}

function EvaluateSituation()
{
    // End:0x16
    if(m_bAIDisabled)
    {
        SoftDisableAI();        
    }
    else
    {
        // End:0x2E
        if(m_WerewolfPawn.m_bIsAttachedToTentacle)
        {
            return;            
        }
        else
        {
            // End:0x4B
            if(bOnlyAllowThrowingAttacks)
            {
                GotoState(SelectAttackState());
                return;                
            }
            else
            {
                // End:0x98
                if((CheckForEnemy()) || HasValidEnemy())
                {
                    // End:0x86
                    if(ShouldIBeEatingFood())
                    {
                        GotoState(SelectEatFoodState());                        
                    }
                    else
                    {
                        GotoState(SelectAttackState());
                    }                    
                }
                else
                {
                    // End:0xC7
                    if(IsAllowedToRoam())
                    {
                        // End:0xB7
                        if(IsRoaming())
                        {
                            return;                            
                        }
                        else
                        {
                            GotoState('RoamForEnemy');
                            return;
                        }
                    }
                    // End:0xDE
                    if(ShouldIBeEatingFood())
                    {
                        GotoState(SelectEatFoodState());                        
                    }
                    else
                    {
                        // End:0xFE
                        if(!IsInState('Idle'))
                        {
                            GotoState('Idle');
                        }
                    }
                }
            }
        }
    }
    //return;    
}

final function bool CanIAttack()
{
    // End:0x1C
    if(int(Pawn.Physics) == int(8))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CanIKnock(Actor knockObject, bool bObstacleWasBumped, optional out int bPreventDisableKnockability)
{
    // End:0x32
    if(int(m_WerewolfPawn.GetActionState()) != int(0))
    {
        return CanISmash(knockObject, bObstacleWasBumped);
    }
    // End:0x5B
    if((Pawn != none) && int(Pawn.Physics) == int(8))
    {
        return false;
    }
    // End:0x7B
    if(m_WerewolfPawn.HasConcentratedArmDamage() || HasConcentratedHeadDamage())
    {
        return false;
    }
    // End:0x8D
    if(!AllowedToMoveObject(knockObject))
    {
        return false;
    }
    // End:0xCD
    if(IsFacingBox2D(Pawn, knockObject, 1.0000000) == false)
    {
        Pawn.AddOATSTagToObjectBITFIELD(knockObject, 2, 2.0000000);
        bPreventDisableKnockability = 1;
        return false;
    }
    // End:0x10E
    if(!CheckHistory(knockObject, 4, 0.0000000, 2.0000000, 3))
    {
        Pawn.AddOATSTagToObjectBITFIELD(knockObject, 2, 2.0000000);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CanIThrow(Actor ThrownObject, const out Vector TargetPoint, bool bObstacleWasBumped)
{
    local Pawn theEnemy;
    local float Dist;

    // End:0x31
    if(int(m_WerewolfPawn.GetActionState()) != int(0))
    {
        return CanISmash(ThrownObject, bObstacleWasBumped);
    }
    // End:0x5A
    if((Pawn != none) && int(Pawn.Physics) == int(8))
    {
        return false;
    }
    // End:0x6C
    if(!AllowedToMoveObject(ThrownObject))
    {
        return false;
    }
    Dist = VSize(TargetPoint - ThrownObject.Location);
    // End:0xAD
    if((Dist < float(100)) || Dist > float(4000))
    {
        return false;
    }
    // End:0xCA
    if(IsFacingBox2D(Pawn, ThrownObject, 1.0000000) == false)
    {
        return false;
    }
    theEnemy = GetEnemy();
    // End:0x137
    if(theEnemy != none)
    {
        // End:0x11A
        if(!AttackZoneLineIntersection(Pawn, theEnemy, Pawn.Location, ThrownObject.Location))
        {
            return false;
        }
        // End:0x137
        if((IsFacing(Pawn, theEnemy)) == false)
        {
            return false;
        }
    }
    // End:0x178
    if(!CheckHistory(ThrownObject, 2, 0.0000000, 0.0000000, 3))
    {
        Pawn.AddOATSTagToObjectBITFIELD(ThrownObject, 2, 2.0000000);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CanISmash(Actor SmashTarget, bool bObstacleWasBumped)
{
    local editinline SPActorDestructComponent destruct;

    // End:0x29
    if((Pawn != none) && int(Pawn.Physics) == int(8))
    {
        return false;
    }
    // End:0x3B
    if(Pawn(SmashTarget) != none)
    {
        return false;
    }
    // End:0x5B
    if(m_WerewolfPawn.HasConcentratedArmDamage() || HasConcentratedHeadDamage())
    {
        return false;
    }
    // End:0x77
    if(SmashTarget.IsDestructible() == false)
    {
        return false;        
    }
    else
    {
        destruct = SPActorDestructComponent(SmashTarget.GetActorDestructComponent());
        // End:0xCF
        if((destruct == none) || destruct.CanDoDamageType(m_WerewolfPawn.GetSmashDamageType()) == false)
        {
            return false;
        }
    }
    // End:0x107
    if(int(m_WerewolfPawn.GetActionState()) == int(0))
    {
        // End:0x107
        if(IsFacingBox2D(Pawn, SmashTarget, 1.0000000) == false)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function bool DealWithThrowObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x29
    if(int(m_WerewolfPawn.GetActionState()) != int(0))
    {
        InstantSmashObject(obstacle);        
    }
    else
    {
        m_ThrowObstacle = obstacle;
        m_ThrowTarget = MyEnemy;
        PushState('ThrowObstacle');
    }
    return true;
    //return ReturnValue;    
}

function bool DealWithSmashObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x29
    if(int(m_WerewolfPawn.GetActionState()) != int(0))
    {
        InstantSmashObject(obstacle);        
    }
    else
    {
        m_SmashObstacle = obstacle;
        PushState('SmashObstacle');
    }
    return true;
    //return ReturnValue;    
}

function bool DealWithKnockObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x29
    if(int(m_WerewolfPawn.GetActionState()) != int(0))
    {
        InstantSmashObject(obstacle);        
    }
    else
    {
        m_ThrowObstacle = obstacle;
        PushState('KnockObstacle');
    }
    return true;
    //return ReturnValue;    
}

event SmashEffect()
{
    //return;    
}

final function InstantSmashObject(Actor objectToSmash)
{
    local editinline SPActorDestructComponent destruct;
    local int damageAmt;
    local Vector Impulse;

    Impulse.X = 0.0000000;
    Impulse.Y = -250.0000000;
    Impulse.Z = 0.0000000;
    Impulse = Impulse >> Pawn.Rotation;
    objectToSmash.CollisionComponent.AddImpulse(Impulse,,,, GetSmashMinDamage(), GetSmashMaxDamage(), Pawn);
    destruct = SPActorDestructComponent(objectToSmash.GetActorDestructComponent());
    // End:0xE1
    if(destruct != none)
    {
        damageAmt = destruct.GetHitPoints() + 10;        
    }
    else
    {
        damageAmt = int(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.SmashDamage));
    }
    objectToSmash.TakeDamageAndProcEffects(float(damageAmt), self, objectToSmash.Location, Impulse, m_WerewolfPawn.GetSmashDamageType(),, Pawn);
    //return;    
}

event ThrowEffect()
{
    //return;    
}

event KnockEffect()
{
    //return;    
}

function bool CanISlam(Actor SlamTarget)
{
    local HumanPawn hPawn;
    local PlayerPawn pPawn;

    hPawn = HumanPawn(SlamTarget);
    // End:0x1D
    if(hPawn == none)
    {
        return false;
    }
    // End:0x34
    if(hPawn.Health <= 0)
    {
        return false;
    }
    // End:0x54
    if(m_WerewolfPawn.HasConcentratedArmDamage() || HasConcentratedHeadDamage())
    {
        return false;
    }
    // End:0x71
    if((IsFacing(Pawn, SlamTarget)) == false)
    {
        return false;
    }
    // End:0x99
    if(int(m_WerewolfPawn.GetActorAttackRange(GetEnemy())) != int(1))
    {
        return false;
    }
    pPawn = PlayerPawn(SlamTarget);
    // End:0xC0
    if(pPawn != none)
    {
        return CanISlamPlayer(pPawn);
    }
    return false;
    //return ReturnValue;    
}

final function bool TMGCollisionCheck(PlayerPawn PlayerPawn)
{
    local Vector Check4;
    local Rotator socketCheckRot;
    local bool bCachedValue;

    // End:0x0D
    if(PlayerPawn == none)
    {
        return false;
    }
    // End:0x42
    if(PlayerPawn.Mesh.GetSocketWorldLocationAndRotation('WWCollisionCheck4', Check4, socketCheckRot) == false)
    {
        return false;
    }
    bCachedValue = Pawn.m_bTreatAllOATSObjectsAsObstacles;
    Pawn.m_bTreatAllOATSObjectsAsObstacles = true;
    // End:0xA8
    if(!SPIsLineToPointDirectlyReachable(Pawn.Location, Check4, PlayerPawn))
    {
        Pawn.m_bTreatAllOATSObjectsAsObstacles = bCachedValue;
        return false;
    }
    Pawn.m_bTreatAllOATSObjectsAsObstacles = bCachedValue;
    return true;
    //return ReturnValue;    
}

final function bool CanISlamPlayer(PlayerPawn PlayerPawn)
{
    local PandoraPlayerController pController;

    // End:0x0D
    if(PlayerPawn == none)
    {
        return false;
    }
    pController = PandoraPlayerController(PlayerPawn.Controller);
    // End:0x7F
    if(pController != none)
    {
        // End:0x4B
        if(pController.IsInWerewolfTackleState())
        {
            return false;
        }
        // End:0x67
        if(pController.TimeForTackle() == false)
        {
            return false;
        }
        // End:0x7F
        if(pController.m_bTMGOverride == false)
        {
            return false;
        }
    }
    // End:0xC3
    if(Abs(Pawn.Location.Z - PlayerPawn.Location.Z) > 20.0000000)
    {
        return false;
    }
    // End:0xE0
    if((IsFacing(PlayerPawn, Pawn)) == false)
    {
        return false;
    }
    // End:0xF2
    if(!TMGCollisionCheck(PlayerPawn))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function ResetGodFromTMG()
{
    bTMGGodMode = false;
    //return;    
}

function TMGFailed()
{
    //return;    
}

function TMGHandshake(Controller C)
{
    //return;    
}

simulated function ClearMinigame()
{
    local PandoraPlayerController PC;

    // End:0xEA
    if(m_WerewolfPawn.m_bIsInTMG && m_SlamObstacle != none)
    {
        PC = PandoraPlayerController(m_SlamObstacle.Controller);
        // End:0xEA
        if((PC != none) && PC.IsInWerewolfTackleState())
        {
            m_SlamObstacle.SetCollision(true, true);
            m_SlamObstacle.SetPhysics(1);
            PlayerPawn(m_SlamObstacle).playerHud.UnRegisterTackleMinigame();
            PlayerPawn(m_SlamObstacle).DoToggleTargettable(true);
            PC.tackleMinigameManager.ResumePlayerControl();
            m_WerewolfPawn.m_bIsInTMG = false;
        }
    }
    //return;    
}

event BreakOutOfMaul()
{
    //return;    
}

function GotoMoveToGoalState()
{
    PushState('WerewolfMoveToGoal');
    //return;    
}

function MoveToGoalTimerUpdate()
{
    //return;    
}

final function checkfocus()
{
    local float Dist;
    local Vector deltaToTarget, deltaToPath;
    local float dotProt;
    local Pawn pEnemyPawn;

    return;
    pEnemyPawn = GetEnemy();
    // End:0x48
    if(((pEnemyPawn == none) || CurrentPath == none) || int(Pawn.Physics) != int(1))
    {
        return;
    }
    deltaToTarget = Focus.Location - Location;
    Dist = VSize(deltaToTarget);
    deltaToTarget = Normal(deltaToTarget);
    deltaToPath = Destination - Location;
    deltaToPath = Normal(deltaToPath);
    dotProt = deltaToTarget Dot deltaToPath;
    // End:0xCC
    if(dotProt >= 0.0000000)
    {
        Focus = pEnemyPawn;        
    }
    else
    {
        // End:0xE9
        if(Dist < 500.0000000)
        {
            Focus = pEnemyPawn;            
        }
        else
        {
            Focus = none;
        }
    }
    //return;    
}

final function StopDodgeRun()
{
    m_WerewolfPawn.SetUseDodgeRun(false);
    Pawn.MaxDesiredSpeed = 1.0000000;
    Pawn.DesiredSpeed = 1.0000000;
    //return;    
}

function InitStanceForMovement()
{
    //return;    
}

function KillMeleeMove()
{
    //return;    
}

function InduceMeleeDodge(SPAIController.EDodgeDirectionType dodgeType, bool bIsFullBodyDodge)
{
    //return;    
}

final function bool IsDoingLongMeleeAttack()
{
    return int(m_WerewolfPawn.GetActionState()) == int(1);
    //return ReturnValue;    
}

final function bool IsLongMeleeActionDifferentFromCurrentAction(SPBaseWerewolfAIController.EMeleeAction Action)
{
    return (int(m_WerewolfPawn.GetActionState()) == int(1)) && int(Action) != int(10);
    //return ReturnValue;    
}

final function AttackAnimFinished()
{
    local SPBaseWerewolfAIController.EMeleeAction newAction;

    // End:0x54
    if(IsDoingLongMeleeAttack())
    {
        m_meleeAttackCounter--;
        // End:0x54
        if(ShouldStillMelee())
        {
            newAction = DetermineMeleeAction(true);
            // End:0x54
            if(IsLongMeleeActionDifferentFromCurrentAction(newAction))
            {
                m_WerewolfPawn.ClearAction();
                ActOnMeleeAction(newAction);
            }
        }
    }
    //return;    
}

final function bool IsCurrentMeleeActionClear()
{
    // End:0x2B
    if((int(m_WerewolfPawn.GetActionState()) != int(0)) || m_bIsDoingFullBodyMeleeDodge == true)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final function bool QueryForceTackle()
{
    local bool Result;

    Result = bForceTackle && (WorldInfo.TimeSeconds - LastForceTackleTime) > 10.0000000;
    // End:0x4D
    if(Result)
    {
        LastForceTackleTime = WorldInfo.TimeSeconds;
    }
    return Result;
    //return ReturnValue;    
}

function bool CanSelectMeleeChargeAction()
{
    return false;
    //return ReturnValue;    
}

function StartMeleeCharge()
{
    //return;    
}

function bool IsCharging()
{
    return false;
    //return ReturnValue;    
}

function bool CanBeDefenderInCATAnimation(SPPawn attacker)
{
    switch(m_WerewolfPawn.GetActionState())
    {
        // End:0x18
        case 17:
        // End:0x1D
        case 18:
        // End:0x22
        case 19:
        // End:0x27
        case 41:
        // End:0x2C
        case 42:
        // End:0x31
        case 43:
        // End:0x36
        case 2:
        // End:0x3B
        case 20:
        // End:0x40
        case 21:
        // End:0x45
        case 27:
        // End:0x4A
        case 28:
        // End:0x4F
        case 29:
        // End:0x54
        case 30:
        // End:0x5B
        case 66:
            return false;
        // End:0xFFFF
        default:
            // End:0x7B
            if(int(m_WerewolfPawn.GetAnimMeleeDodgeState()) != int(0))
            {
                return false;
            }
            return super.CanBeDefenderInCATAnimation(attacker);
            break;
    }
    //return ReturnValue;    
}

final function SPBaseWerewolfAIController.EMeleeAction DetermineMeleeAction(bool bIgnoreCurrentAction)
{
    local Vector Delta;
    local int currentRageLevel, biteChance, dice;
    local float dodgeChance, SuperAttackChance, fullBodyDodgeChance, enemyVel;
    local SPBaseWerewolfPawnPersistent.eWerewolfAttackRange rangeType;
    local bool bCanDoFullBodyAction;
    local Vector checkLeft, checkRight, Up, moveDelta;
    local float jumpHeight;
    local bool bIsEnemyAPlayer;
    local Vector tempLoc;
    local float AngerLevel;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    rangeType = m_WerewolfPawn.GetActorAttackRange(pEnemyPawn);
    bCanDoFullBodyAction = AllowedToDoMeleeMoveTo(false) || bIgnoreCurrentAction;
    bIsEnemyAPlayer = pEnemyPawn.IsA('PlayerPawn');
    // End:0x7E
    if(int(Pawn.Physics) == int(8))
    {
        return 0;
    }
    // End:0x8A8
    if(IsCurrentMeleeActionClear() || bIgnoreCurrentAction)
    {
        // End:0xB3
        if(m_WerewolfPawn.HasConcentratedArmDamage() && m_bAllowConcentratedArmDamageRecovery)
        {
            return 1;
        }
        // End:0xBF
        if(m_bStartConcentratedHeadDamage)
        {
            return 13;
        }
        // End:0xCD
        if(HasConcentratedTorsoDamage())
        {
            return 14;
        }
        // End:0x17D
        if(((int(WorldInfo.NetMode) == int(NM_Standalone)) && bIsEnemyAPlayer) && QueryForceTackle() || (RandRange(0.0000000, 1.0000000) < m_playerSlamChance) && CanISlam(pEnemyPawn))
        {
            // End:0x17A
            if((PandoraPlayerController(pEnemyPawn.Controller).CanBeTackled() && SPMinotaurPawnPersistent(Pawn) == none) && SPWeakWerewolfPawnPersistent(Pawn) == none)
            {
                return 2;
            }            
        }
        else
        {
            // End:0x18D
            if(CanSelectMeleeChargeAction())
            {
                return 16;
            }
        }
        // End:0x206
        if((int(rangeType) <= int(2)) && RandRange(0.0000000, 100.0000000) < m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.CATAnimationChancePercentage))
        {
            // End:0x206
            if(m_WerewolfPawn.CATCheckForAttack(SPPawn(pEnemyPawn), m_WerewolfPawn.CATAnimationInfo))
            {
                return 19;
            }
        }
        Delta = pEnemyPawn.Location - Pawn.Location;
        // End:0x368
        if((!m_bPreventCloseTheGap && RandRange(0.0000000, 1.0000000) < 1.0000000) || m_bUseHitAndRun)
        {
            // End:0x368
            if((int(rangeType) > int(1)) && VSizeSq(Delta) < ((m_WerewolfGDTuneData.AttackMediumDistance + 100.0000000) * (m_WerewolfGDTuneData.AttackMediumDistance + 100.0000000)))
            {
                // End:0x368
                if(IsInState('MeleeMoveToGoal') && SPIsLineToActorDirectlyReachable(pEnemyPawn, Pawn.Location, tempLoc))
                {
                    // End:0x368
                    if(IsFacing(Pawn, pEnemyPawn, 0.8660000))
                    {
                        // End:0x327
                        if(m_WerewolfPawn.IsBiped())
                        {
                            // End:0x321
                            if(m_bUseHitAndRun)
                            {
                                return 6;                                
                            }
                            else
                            {
                                return 3;
                            }                            
                        }
                        else
                        {
                            // End:0x356
                            if(RandRange(0.0000000, 1.0000000) < 0.5000000)
                            {
                                // End:0x350
                                if(m_bUseHitAndRun)
                                {
                                    return 7;                                    
                                }
                                else
                                {
                                    return 4;
                                }                                
                            }
                            else
                            {
                                // End:0x365
                                if(m_bUseHitAndRun)
                                {
                                    return 8;                                    
                                }
                                else
                                {
                                    return 5;
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x405
        if(!bIsEnemyAPlayer)
        {
            // End:0x405
            if((int(rangeType) > int(1)) && VSizeSq(Delta) < ((m_WerewolfGDTuneData.AttackMediumDistance - 50.0000000) * (m_WerewolfGDTuneData.AttackMediumDistance - 50.0000000)))
            {
                // End:0x405
                if(IsFacing(Pawn, pEnemyPawn, 0.8660000))
                {
                    // End:0x405
                    if(SPIsLineToActorDirectlyReachable(pEnemyPawn, Pawn.Location, tempLoc))
                    {
                        return 18;
                    }
                }
            }
        }
        AngerLevel = m_WerewolfPawn.GetAngerLevel();
        // End:0x5CD
        if((m_WerewolfPawn.IsBiped() && int(rangeType) == int(1)) && bCanDoFullBodyAction)
        {
            dodgeChance = 0.2000000 + (0.1500000 * (1.0000000 - AngerLevel));
            fullBodyDodgeChance = -0.2500000 + (0.7500000 * (1.0000000 - AngerLevel));
            // End:0x5CD
            if(RandRange(0.0000000, 1.0000000) < dodgeChance)
            {
                Up.X = 0.0000000;
                Up.Y = 0.0000000;
                Up.Z = 1.0000000;
                checkLeft = Vector(Pawn.Rotation) Cross Up;
                checkLeft = Normal(checkLeft) * (200.0000000 + Pawn.CylinderComponent.Bounds.SphereRadius);
                checkRight = -checkLeft;
                // End:0x59C
                if((RandRange(0.0000000, 1.0000000) < 0.5000000) && IsClearToDodge(checkLeft))
                {
                    InduceMeleeDodge(2, RandRange(0.0000000, 1.0000000) < fullBodyDodgeChance);                    
                }
                else
                {
                    // End:0x5CD
                    if(IsClearToDodge(checkRight))
                    {
                        InduceMeleeDodge(1, RandRange(0.0000000, 1.0000000) < fullBodyDodgeChance);
                    }
                }
            }
        }
        // End:0x726
        if(m_WerewolfPawn.IsBiped())
        {
            // End:0x726
            if(int(rangeType) <= int(1))
            {
                // End:0x726
                if((bCanDoFullBodyAction && !m_WerewolfPawn.HasConcentratedArmDamage()) && (WorldInfo.TimeSeconds - m_lastSuperAttackTime) > RandRange(5.0000000, 10.0000000))
                {
                    SuperAttackChance = -0.3500000 + (AngerLevel * 1.0000000);
                    // End:0x67A
                    if(SPPawn(pEnemyPawn).IsReloading())
                    {
                        SuperAttackChance *= 8.0000000;
                    }
                    // End:0x726
                    if(RandRange(0.0000000, 1.0000000) < SuperAttackChance)
                    {
                        // End:0x726
                        if(IsFacing(Pawn, pEnemyPawn, 0.8660000))
                        {
                            m_lastSuperAttackTime = WorldInfo.TimeSeconds;
                            moveDelta = Vector(Pawn.Rotation) * 100.0000000;
                            jumpHeight = 150.0000000;
                            // End:0x723
                            if((RandRange(0.0000000, 1.0000000) < 0.5000000) && IsClearToJumpUp(moveDelta, jumpHeight))
                            {
                                return 12;                                
                            }
                            else
                            {
                                return 11;
                            }
                        }
                    }
                }
            }
        }
        // End:0x8A8
        if(m_WerewolfPawn.IsBiped())
        {
            // End:0x8A8
            if(int(rangeType) <= int(1))
            {
                // End:0x8A8
                if(IsFacing(Pawn, pEnemyPawn, 0.8660000))
                {
                    currentRageLevel = m_WerewolfPawn.GetCurrentRageLevelIndex();
                    // End:0x823
                    if(currentRageLevel != -1)
                    {
                        biteChance = int(m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RageDataParams[currentRageLevel].MeleeAttack.BiteAttack));
                        dice = Rand(int(float(biteChance) + m_WerewolfGDTuneData.GetValue(m_WerewolfGDTuneData.RageDataParams[currentRageLevel].MeleeAttack.SwipeAttack)));
                    }
                    enemyVel = pEnemyPawn.Velocity Dot Normal(Delta);
                    // End:0x896
                    if(((((int(rangeType) <= int(1)) && int(m_lastAttackAction) != int(9)) && dice < biteChance) && enemyVel <= 10.0000000) && bCanDoFullBodyAction)
                    {
                        return 9;                        
                    }
                    else
                    {
                        // End:0x8A5
                        if(bIsEnemyAPlayer)
                        {
                            return 10;                            
                        }
                        else
                        {
                            return 17;
                        }
                    }
                }
            }
        }
    }
    return 0;
    //return ReturnValue;    
}

final function ActOnMeleeAction(SPBaseWerewolfAIController.EMeleeAction Action)
{
    // End:0x17
    if(Pawn.Health <= 0)
    {
        return;
    }
    switch(Action)
    {
        // End:0x27
        case 14:
            // End:0x2C6
            break;
        // End:0xB6
        case 1:
            m_armRecoveryStartTime = WorldInfo.TimeSeconds;
            // End:0x72
            if(m_WerewolfPawn.IsConcentratedDamageActive(0))
            {
                m_WerewolfPawn.PerformArmHeal(true);
                StartUpperBodyAction(22, true);                
            }
            else
            {
                // End:0xA3
                if(m_WerewolfPawn.IsConcentratedDamageActive(1))
                {
                    m_WerewolfPawn.PerformArmHeal(false);
                    StartUpperBodyAction(23, true);                    
                }
                else
                {
                    m_WerewolfPawn.HealArmFinished();
                }
            }
            // End:0x2C6
            break;
        // End:0xC4
        case 13:
            StartConcentratedHeadDamage();
            // End:0x2C6
            break;
        // End:0xEF
        case 2:
            m_SlamObstacle = SPPawn(GetEnemy());
            GotoState('SlamPlayer');
            // End:0x2C6
            break;
        // End:0x10B
        case 3:
            StartAction(17, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x127
        case 4:
            StartAction(18, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x143
        case 5:
            StartAction(19, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x15F
        case 18:
            StartAction(66, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x1A2
        case 6:
            SetPawnRotationRate(3072, 4096, 20000);
            m_WerewolfPawn.SetHitAndRunState(0);
            StartAction(41, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x1E5
        case 7:
            SetPawnRotationRate(3072, 4096, 20000);
            m_WerewolfPawn.SetHitAndRunState(0);
            StartAction(42, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x228
        case 8:
            SetPawnRotationRate(3072, 4096, 20000);
            m_WerewolfPawn.SetHitAndRunState(0);
            StartAction(43, true);
            KillMeleeMove();
            // End:0x2C6
            break;
        // End:0x23A
        case 9:
            StartAction(2, true);
            // End:0x2C6
            break;
        // End:0x24B
        case 10:
            StartUpperBodyAction(1, true);
            // End:0x2C6
            break;
        // End:0x25D
        case 17:
            StartAction(65, true);
            // End:0x2C6
            break;
        // End:0x26F
        case 11:
            StartAction(20, true);
            // End:0x2C6
            break;
        // End:0x281
        case 12:
            StartAction(21, true);
            // End:0x2C6
            break;
        // End:0x293
        case 16:
            StartMeleeCharge();
            // End:0x2C6
            break;
        // End:0x2C3
        case 19:
            StartCATAttack(SPPawn(GetEnemy()), m_WerewolfPawn.CATAnimationInfo);
            // End:0x2C6
            break;
        // End:0xFFFF
        default:
            break;
    }
    m_lastAttackAction = Action;
    //return;    
}

final function ControlPositionDuringExtraction()
{
    // End:0x45
    if(((Pawn == none) || Pawn.Mesh == none) || Pawn.Mesh.Animations == none)
    {
        return;
    }
    // End:0x97
    if(int(m_WerewolfPawn.GetActionState()) == int(17))
    {
        // End:0x94
        if(seqNodeBipedCloseDistance != none)
        {
            ControlPositionDuringExtractionHelper(seqNodeBipedCloseDistance, 25.0000000, 0.0000000, 150.0000000, 2.0000000, 1.0000000, 5.0000000);
        }        
    }
    else
    {
        // End:0xE9
        if(int(m_WerewolfPawn.GetActionState()) == int(18))
        {
            // End:0xE6
            if(seqNodeQuadripedCloseDistance != none)
            {
                ControlPositionDuringExtractionHelper(seqNodeQuadripedCloseDistance, 25.0000000, 0.2500000, 50.0000000, 2.0000000, 1.0000000, 5.0000000);
            }            
        }
        else
        {
            // End:0x13B
            if(int(m_WerewolfPawn.GetActionState()) == int(19))
            {
                // End:0x138
                if(seqNodeMiscCloseDistance != none)
                {
                    ControlPositionDuringExtractionHelper(seqNodeMiscCloseDistance, 25.0000000, 0.0000000, 400.0000000, 1.2500000, 0.7500000, 5.0000000);
                }                
            }
            else
            {
                // End:0x18D
                if(int(m_WerewolfPawn.GetActionState()) == int(41))
                {
                    // End:0x18A
                    if(seqNodeBipedHitAndRun != none)
                    {
                        ControlPositionDuringExtractionHelper(seqNodeBipedHitAndRun, 25.0000000, 0.0000000, 150.0000000, 2.0000000, 1.0000000, 5.0000000);
                    }                    
                }
                else
                {
                    // End:0x1DF
                    if(int(m_WerewolfPawn.GetActionState()) == int(42))
                    {
                        // End:0x1DC
                        if(seqNodeQuadripedHitAndRun != none)
                        {
                            ControlPositionDuringExtractionHelper(seqNodeQuadripedHitAndRun, 25.0000000, 0.0000000, 150.0000000, 2.0000000, 1.0000000, 5.0000000);
                        }                        
                    }
                    else
                    {
                        // End:0x22E
                        if(int(m_WerewolfPawn.GetActionState()) == int(43))
                        {
                            // End:0x22E
                            if(seqNodeOtherHitAndRun != none)
                            {
                                ControlPositionDuringExtractionHelper(seqNodeOtherHitAndRun, 25.0000000, 0.0000000, 300.0000000, 1.2500000, 0.7500000, 5.0000000);
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

final function ControlPositionDuringExtractionHelper(SPAnimNodeSequence SeqNode, float decreasedScaleDistance, float decreasedScaleAmount, float increasedScaleDistance, float increasedScaleAmount, float normalScaleAmount, float minBackTrackVelocityForIncreasedScale)
{
    local Vector Delta;
    local float Dist, enemyVel, slowDownBias;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    Delta = pEnemyPawn.Location - m_WerewolfPawn.Location;
    Dist = VSize(Delta);
    Dist -= m_WerewolfPawn.CylinderComponent.CollisionRadius;
    // End:0x9B
    if(pEnemyPawn.CylinderComponent != none)
    {
        Dist -= pEnemyPawn.CylinderComponent.CollisionRadius;        
    }
    else
    {
        // End:0xDB
        if(pEnemyPawn.CollisionComponent != none)
        {
            Dist -= pEnemyPawn.CollisionComponent.Bounds.SphereRadius;
        }
    }
    slowDownBias = 0.0000000;
    // End:0x111
    if((WorldInfo.TimeSeconds - m_lastMediumWeaponHitTime) < 1.0000000)
    {
        slowDownBias = m_currentSlowDownBias;
    }
    // End:0x146
    if(Dist < decreasedScaleDistance)
    {
        SeqNode.m_accumulatedTranslationScale = decreasedScaleAmount * (1.0000000 - slowDownBias);        
    }
    else
    {
        enemyVel = pEnemyPawn.Velocity Dot (Delta / Dist);
        // End:0x1C3
        if(((Dist > increasedScaleDistance) && enemyVel > minBackTrackVelocityForIncreasedScale) && (WorldInfo.TimeSeconds - m_lastMediumWeaponHitTime) > 1.0000000)
        {
            SeqNode.m_accumulatedTranslationScale = increasedScaleAmount;            
        }
        else
        {
            SeqNode.m_accumulatedTranslationScale = normalScaleAmount * (1.0000000 - slowDownBias);
        }
    }
    //return;    
}

final function MeleeUpdateTimer()
{
    local SPBaseWerewolfAIController.EMeleeAction newAction;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x24
    if(Pawn.Health <= 0)
    {
        return;
    }
    // End:0x3E
    if(m_WerewolfPawn.IsDoingExtractedCloseTheGapAction())
    {
        ControlPositionDuringExtraction();
    }
    // End:0x5F
    if(ShouldStillMelee())
    {
        newAction = DetermineMeleeAction(false);
        ActOnMeleeAction(newAction);
    }
    StanceUpdate();
    //return;    
}

final function bool AllowedToDoMeleeMoveTo(bool bAllowDodges)
{
    local SPBaseWerewolfPawnPersistent.eWerewolfActionState CurrentAction;

    CurrentAction = m_WerewolfPawn.GetActionState();
    switch(CurrentAction)
    {
        // End:0x23
        case 17:
        // End:0x28
        case 18:
        // End:0x2D
        case 19:
        // End:0x32
        case 41:
        // End:0x37
        case 42:
        // End:0x3C
        case 43:
        // End:0x41
        case 2:
        // End:0x46
        case 20:
        // End:0x4B
        case 21:
        // End:0x50
        case 27:
        // End:0x55
        case 28:
        // End:0x5A
        case 29:
        // End:0x5F
        case 30:
        // End:0x64
        case 65:
        // End:0x6B
        case 66:
            return false;
        // End:0xFFFF
        default:
            // End:0x71
            break;
            break;
    }
    // End:0xB9
    if((bAllowDodges == false) && (int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(2)) || int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(1))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final function bool ShouldStillMelee()
{
    // End:0x2D
    if((HasConcentratedHeadDamage() || HasConcentratedTorsoDamage()) || m_WerewolfPawn.HasConcentratedArmDamage())
    {
        return true;
    }
    // End:0x3A
    if(m_meleeAttackCounter <= 0)
    {
        return false;
    }
    // End:0x4E
    if(!HasValidEnemy())
    {
        return false;
    }
    // End:0x64
    if(IsInvalidatedMoveGoal(GetEnemy()))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function MeleeDodgeFinished()
{
    // End:0x3F
    if((int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(2)) || int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(1))
    {
        ClearMeleeDodge();
    }
    //return;    
}

function StanceUpdate()
{
    // End:0x34
    if(m_WerewolfPawn.HasConcentratedArmDamage() || HasConcentratedHeadDamage())
    {
        m_WerewolfPawn.SetStance(1);        
    }
    else
    {
        m_WerewolfPawn.SetStance(0);
    }
    //return;    
}

exec function ThrowIt(SeqAct_GenericFunction inAction)
{
    local array<Object> objVars;

    inAction.GetObjectVars(objVars, "Obj1");
    // End:0x39
    if(objVars.Length > 0)
    {
        m_ThrowObstacle = Actor(objVars[0]);
    }
    objVars.Length = 0;
    inAction.GetObjectVars(objVars, "Obj2");
    // End:0x7A
    if(objVars.Length > 0)
    {
        m_ThrowTarget = Actor(objVars[0]);
    }
    PushState('ThrowObstacle');
    //return;    
}

private final function CheckForEatingFood()
{
    return;
    //return;    
}

private final function name SelectEatFoodState()
{
    // End:0x13
    if(AmIAtFood())
    {
        return 'EatFood';
    }
    return 'GoToFood';
    //return ReturnValue;    
}

private final function bool AmIAtFood()
{
    local float Dist;

    // End:0x0D
    if(m_foodWeAreEating == none)
    {
        return false;
    }
    Dist = VSize(m_WerewolfPawn.Location - m_foodWeAreEating.Location);
    // End:0x48
    if(Dist >= float(300))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

private final function GetFoodToEat()
{
    return;
    //return;    
}

private final function bool ShouldIBeEatingFood()
{
    return false;
    //return ReturnValue;    
}

function SkeletalMeshComponent GetCollideMesh()
{
    local Pawn thePawn;
    local KAsset theKAsset;

    // End:0x0D
    if(m_foodWeAreEating == none)
    {
        return none;
    }
    thePawn = Pawn(m_foodWeAreEating);
    // End:0x38
    if(thePawn != none)
    {
        return thePawn.Mesh;
    }
    theKAsset = KAsset(m_foodWeAreEating);
    // End:0x63
    if(theKAsset != none)
    {
        return theKAsset.SkeletalMeshComponent;
    }
    return none;
    //return ReturnValue;    
}

function EndEating()
{
    m_WerewolfPawn.ClearAction();
    //return;    
}

function MinigameHandshake(Controller C)
{
    //return;    
}

function InAlignment()
{
    //return;    
}

final function SetMinigameAnim(Actor.EMinigameStage stage, Actor.EMinigameState Condition)
{
    m_WerewolfPawn.super(SPBaseWerewolfAIController).SetMinigameAnim(stage, Condition);
    //return;    
}

function AnticipationFinished()
{
    //return;    
}

function ReactionFinished()
{
    //return;    
}

function MinigameDodge(float fTime, int Data)
{
    //return;    
}

function MinigameCounter(float fTime, int Data)
{
    //return;    
}

function MinigameFail(float fTime, int Data)
{
    //return;    
}

final function OnWerewolfMeleeOnly(SeqAct_WerewolfMeleeOnly Action)
{
    bOnlyAllowMeleeAttacks = Action.bEnableMeleeOnly;
    // End:0x2A
    if(bOnlyAllowMeleeAttacks)
    {
        EvaluateSituation();
    }
    //return;    
}

final function EndForcedThrowTarget()
{
    // End:0x1B
    if(ForceEnemy != none)
    {
        SetForcedThrowTarget(none, 0.0000000, true);        
    }
    else
    {
        SetForcedThrowTarget(none, 0.0000000, false);
    }
    //return;    
}

function DummyAnimationCB()
{
    //return;    
}

event SPTurnFinished()
{
    //return;    
}

event SPWalkFinished()
{
    //return;    
}

function HeardSound(SPPawn pwn, Vector vLoc)
{
    local int Idx;
    local float Dist;

    Idx = AddTarget(pwn);
    Dist = VSize(m_WerewolfPawn.Location - vLoc);
    // End:0x5E
    if(Dist > m_WerewolfGDTuneData.SoundClampDist)
    {
        Dist = m_WerewolfGDTuneData.SoundClampDist;
    }
    // End:0x78
    if(Dist < 0.1000000)
    {
        Dist = 0.1000000;
    }
    m_playerList[Idx].soundRating += (Dist / m_WerewolfGDTuneData.SoundClampDist);
    //return;    
}

function SetAttachedTentacle(bool isAttaching)
{
    // End:0x37
    if(isAttaching)
    {
        ClearYourMindFunc(true, false, true);
        m_bAIDisabled = true;
        m_bIsWaitingForSceneFinish = false;
        GotoState('GrabbedByTentacle');        
    }
    else
    {
        m_bAIDisabled = false;
        EvaluateSituation();
    }
    //return;    
}

function bool IsRoaming()
{
    //return ReturnValue;    
}

function bool IsAllowedToRoam()
{
    // End:0x22
    if(m_bAIDisabled || !m_WerewolfGDTuneData.bAllowRoamingWhenNoValidTargets)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SetToGroundMovementType()
{
    m_WerewolfPawn.SetMovementType(2);
    //return;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x1B
        if(m_WerewolfPawn == none)
        {
            m_WerewolfPawn = SPBaseWerewolfPawnPersistent(NewPawn);
        }
        super.Possess(NewPawn, bVehicleTransition);
        SetPawnRotationRate(3072, 4096, 80000);
        SetTimer(1.0000000, true, 'UpdateInvalidatedAttackers');
        InitFromTuneData();
        ResetVarsOnPossess();
        CacheAnimNodePointers();
        AllowConcentratedDamageActive(6, true);
        //return;        
    }
    stop;    
}

state NonMeleeAnimusPulseReaction
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function PausedState()
    {
        //return;        
    }

    function Cleanup()
    {
        // End:0x15
        if(HasConcentratedTorsoDamage())
        {
            global.StaggerBackFinished();
        }
        //return;        
    }

    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        return true;
        //return ReturnValue;        
    }

    function StaggerBackFinished()
    {
        global.StaggerBackFinished();
        EvaluateSituation();
        //return;        
    }

    final function SetStaggerAction()
    {
        local Rotator facingRot;
        local SPBaseWerewolfPawnPersistent.eWerewolfActionState actionType;

        GetAnimusPulseStaggerDirections(m_animusPulseDirection, facingRot, actionType);
        m_WerewolfPawn.SetRotation(facingRot);
        StartAction(actionType, true);
        //return;        
    }
Begin:

    Focus = none;
    SetStaggerAction();
    stop;            
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    event PushedState()
    {
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
Begin:

    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        // End:0x2B
        if(m_SlamObstacle != none)
        {
            m_SlamObstacle.SetNovodexCollisionVolumeCollisionWith(Pawn.Mesh, false);
        }
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Focus = none;
        Target = none;
        PreserveRotation();
        Pawn.SetMovementPhysics();
        SetTimer(RandRange(7.0000000, 10.0000000), false, 'IdleTimer');
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('IdleTimer');
        //return;        
    }

    function PushedState()
    {
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    function PoppedState()
    {
        ClearTimer('IdleTimer');
        //return;        
    }

    function PausedState()
    {
        ClearTimer('IdleTimer');
        //return;        
    }

    final function IdleTimer()
    {
        // End:0x2C
        if(int(m_WerewolfPawn.m_idleState) == int(0))
        {
            m_WerewolfPawn.m_idleState = 1;
        }
        //return;        
    }

    event IdleFinished()
    {
        m_WerewolfPawn.m_idleState = 0;
        SetTimer(RandRange(7.0000000, 10.0000000), false, 'IdleTimer');
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x1C
        if(CheckForEnemy(true))
        {
            EvaluateSituation();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        GotoState(GetStateName(), 'InvestigateNoise', false, true);
        //return;        
    }
Begin:

    Sleep(0.1000000);
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
IdleLoop:


    ClearEnemy();
    // End:0x7E
    if(((CheckForEnemy(true)) || ShouldIBeEatingFood()) || IsAllowedToRoam())
    {
        EvaluateSituation();
    }
    // End:0x96
    if(ShouldIGotoDefendArea(true))
    {
        TransitionToDefendArea();
    }
    m_sleepTime = RandRange(0.3000000, 1.5000000);
    Sleep(m_sleepTime);
    goto 'IdleLoop';
InvestigateNoise:


    Focus = m_recentNoise[m_recentNoise.Length - 1].NoiseMaker;
    goto 'IdleLoop';
    stop;                
}

state SmashObstacle
{
    function BeginState(name PreviousStateName)
    {
        // End:0x45
        if(Pawn != none)
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        Target = none;
        Focus = none;
        FocalPoint = vect(0.0000000, 0.0000000, 0.0000000);
        PreserveRotation();
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x30
        if(int(m_WerewolfPawn.GetActionState()) == int(3))
        {
            m_WerewolfPawn.ClearAction();
        }
        ClearSmash();
        //return;        
    }

    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        // End:0x30
        if(int(m_WerewolfPawn.GetActionState()) == int(3))
        {
            m_WerewolfPawn.ClearAction();
        }
        ClearSmash();
        //return;        
    }

    event ActionFinished()
    {
        // End:0x30
        if(int(m_WerewolfPawn.GetActionState()) == int(3))
        {
            m_WerewolfPawn.ClearAction();
        }
        //return;        
    }

    event SmashEffect()
    {
        InstantSmashObject(m_SmashObstacle);
        //return;        
    }
Begin:

    StartAction(3);
    J0x0A:

    // End:0x30 [Loop If]
    if(int(m_WerewolfPawn.GetActionState()) == int(3))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x0A;
    }
    PopState();
    stop;                    
}

state ThrowObstacle
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x33
        if(int(m_WerewolfPawn.GetActionState()) == int(m_ThrowActionType))
        {
            m_WerewolfPawn.ClearAction();
        }
        ClearThrow();
        //return;        
    }

    function PushedState()
    {
        // End:0x45
        if(Pawn != none)
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        PreserveRotation();
        //return;        
    }

    function PoppedState()
    {
        // End:0x33
        if(int(m_WerewolfPawn.GetActionState()) == int(m_ThrowActionType))
        {
            m_WerewolfPawn.ClearAction();
        }
        ClearThrow();
        //return;        
    }

    function ClearThrow()
    {
        // End:0x3D
        if(m_ThrowObstacle.Base == Pawn)
        {
            m_WerewolfPawn.DettachObjectFromMe(m_ThrowObstacle);
            m_ThrowObstacle.SetPhysics(10);
        }
        m_ThrowObstacle.UnclaimInteractionRights(Pawn);
        m_ThrowObstacle = none;
        m_ThrowTarget = none;
        //return;        
    }

    event bool UpdateFocus()
    {
        return true;
        //return ReturnValue;        
    }

    event ActionFinished()
    {
        // End:0x33
        if(int(m_WerewolfPawn.GetActionState()) == int(m_ThrowActionType))
        {
            m_WerewolfPawn.ClearAction();
        }
        //return;        
    }

    event SmashEffect()
    {
        ThrowEffect();
        //return;        
    }

    event ThrowEffect()
    {
        local Vector Impulse;
        local Rotator launchAngle;
        local Vector startPos, targetPos;
        local editinline StaticMeshComponent StaticMesh;
        local editinline SkeletalMeshComponent SkeletalMeshComp;
        local Box BoundingBox;
        local Vector impulseOffset;
        local int I;
        local array<name> BoneNames;
        local Vector adjustedImpulse;

        startPos = m_ThrowObstacle.Location;
        targetPos = m_ThrowTarget.Location;
        launchAngle = Rotator(Normal(targetPos - startPos));
        // End:0x7E
        if((targetPos.Z + 100.0000000) < startPos.Z)
        {
            launchAngle.Pitch = 0;
        }
        // End:0xB2
        if(VSize(targetPos - startPos) < float(1000))
        {
            launchAngle.Pitch += 1500;            
        }
        else
        {
            launchAngle.Pitch += 2500;
        }
        // End:0xF9
        if(launchAngle.Pitch < 500)
        {
            launchAngle.Pitch = 500;
        }
        // End:0x129
        if(launchAngle.Pitch > 16383)
        {
            launchAngle.Pitch = 16383;
        }
        Impulse = GetThrowVelocity(startPos, targetPos, launchAngle);
        m_ThrowObstacle.SetPhysics(10);
        m_ThrowObstacle.GetComponentsBoundingBox(BoundingBox);
        impulseOffset.X = RandRange(BoundingBox.Min.X, BoundingBox.Max.X);
        impulseOffset.Y = RandRange(BoundingBox.Min.Y, BoundingBox.Max.Y);
        impulseOffset.Z = RandRange(BoundingBox.Min.Z, BoundingBox.Max.Z);
        StaticMesh = m_ThrowObstacle.GetStaticMeshComponent();
        // End:0x2B0
        if(StaticMesh != none)
        {
            StaticMesh.AddImpulse(Impulse, impulseOffset, 'None', true, GetThrowMinDamage(), GetThrowMaxDamage(), Pawn);            
        }
        else
        {
            SkeletalMeshComp = m_ThrowObstacle.GetSkeletalMeshComponent();
            // End:0x44A
            if(SkeletalMeshComp != none)
            {
                m_ThrowObstacle.InitRagdoll();
                SkeletalMeshComp.GetBoneNames(BoneNames);
                I = 0;
                J0x301:

                // End:0x44A [Loop If]
                if(I < BoneNames.Length)
                {
                    // End:0x440
                    if(BoneNames[I] != 'None')
                    {
                        adjustedImpulse = Impulse;
                        // End:0x401
                        if(float(I) > ((float(BoneNames.Length) * m_WerewolfGDTuneData.ThrowSkeletalPercentBonesDontAdjust) + float(1)))
                        {
                            adjustedImpulse.X *= RandRange(m_WerewolfGDTuneData.ThrowSkeletalMeshMinStrengthAdjustment, m_WerewolfGDTuneData.ThrowSkeletalMeshMaxStrengthAdjustment);
                            adjustedImpulse.Y *= RandRange(m_WerewolfGDTuneData.ThrowSkeletalMeshMinStrengthAdjustment, m_WerewolfGDTuneData.ThrowSkeletalMeshMaxStrengthAdjustment);
                            adjustedImpulse.Z *= RandRange(m_WerewolfGDTuneData.ThrowSkeletalMeshMinStrengthAdjustment, m_WerewolfGDTuneData.ThrowSkeletalMeshMaxStrengthAdjustment);
                        }
                        SkeletalMeshComp.AddImpulse(adjustedImpulse, impulseOffset, BoneNames[I], true, GetThrowMinDamage(), GetThrowMaxDamage(), Pawn);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x301;
                }
            }
        }
        // End:0x476
        if(Pawn != none)
        {
            Pawn.TriggerEventClass(Class'SeqEvent_HasThrown', Pawn);
        }
        //return;        
    }

    final function SPBaseWerewolfPawnPersistent.eWerewolfActionState DetermineThrowType()
    {
        local Vector objectCenter, horizontalDir, FacingDir, crossDir;
        local float verticalDelta, horizontalDelta;
        local bool bIsLow;

        objectCenter = m_inProgressThrowObjectInfo.objectToThrow.CollisionComponent.Bounds.Origin;
        verticalDelta = Pawn.Location.Z - (objectCenter.Z + m_inProgressThrowObjectInfo.objectToThrow.CollisionComponent.Bounds.BoxExtent.Z);
        // End:0xD5
        if(verticalDelta > (Pawn.CylinderComponent.CollisionHeight * 0.5000000))
        {
            bIsLow = true;
        }
        FacingDir = Vector(Pawn.Rotation);
        horizontalDir = objectCenter - Pawn.Location;
        horizontalDir.Z = 0.0000000;
        horizontalDir = horizontalDir - ((horizontalDir Dot FacingDir) * FacingDir);
        horizontalDelta = VSize(horizontalDir);
        // End:0x187
        if(horizontalDelta < (Pawn.CylinderComponent.CollisionRadius + 15.0000000))
        {
            // End:0x184
            if(bIsLow)
            {
                return 9;                
            }
            else
            {
                return 4;
            }
        }
        crossDir = FacingDir Cross horizontalDir;
        // End:0x1C5
        if(crossDir.Z >= 0.0000000)
        {
            // End:0x1C2
            if(bIsLow)
            {
                return 7;                
            }
            else
            {
                return 5;
            }
        }
        // End:0x1D4
        if(bIsLow)
        {
            return 8;            
        }
        else
        {
            return 6;
        }
        //return ReturnValue;        
    }
Begin:

    m_inProgressThrowObjectInfo.objectToThrow = m_ThrowObstacle;
    m_inProgressThrowObjectInfo.throwLocation = Pawn.Location;
    m_inProgressThrowObjectInfo.originalObjectLocation = m_ThrowObstacle.Location;
    m_ThrowObstacle.ClaimInteractionRights(Pawn, 2, true);
    // End:0x8B
    if(!AllowedToMoveObject(m_ThrowObstacle))
    {
        PopState();
    }
    m_ThrowActionType = DetermineThrowType();
    StartAction(m_ThrowActionType);
    J0xA4:

    // End:0xED [Loop If]
    if(int(m_WerewolfPawn.GetActionState()) == int(m_ThrowActionType))
    {
        // End:0xE2
        if(!IsObjectStillValidToThrow(m_ThrowTarget, m_inProgressThrowObjectInfo))
        {
            PopState();
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0xA4;
    }
    PopState();
    stop;                
}

state KnockObstacle
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x30
        if(int(m_WerewolfPawn.GetActionState()) == int(13))
        {
            m_WerewolfPawn.ClearAction();
        }
        ClearKnock();
        //return;        
    }

    function PushedState()
    {
        // End:0x45
        if(Pawn != none)
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        Target = none;
        Focus = none;
        FocalPoint = vect(0.0000000, 0.0000000, 0.0000000);
        PreserveRotation();
        //return;        
    }

    event PausedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    function PoppedState()
    {
        // End:0x30
        if(int(m_WerewolfPawn.GetActionState()) == int(13))
        {
            m_WerewolfPawn.ClearAction();
        }
        ClearKnock();
        //return;        
    }

    function ClearKnock()
    {
        m_ThrowObstacle = none;
        //return;        
    }

    event ActionFinished()
    {
        // End:0x30
        if(int(m_WerewolfPawn.GetActionState()) == int(13))
        {
            m_WerewolfPawn.ClearAction();
        }
        //return;        
    }

    event KnockEffect()
    {
        local editinline StaticMeshComponent StaticMesh;
        local Vector impulseOffset;
        local float Speed;

        Speed = 600.0000000;
        m_ThrowObstacle.SetPhysics(10);
        StaticMesh = m_ThrowObstacle.GetStaticMeshComponent();
        // End:0x92
        if(StaticMesh != none)
        {
            impulseOffset = vect(0.0000000, 0.0000000, 0.0000000);
            StaticMesh.AddImpulse(m_knockVector * Speed, impulseOffset, 'None', true, GetKnockAwayMinDamage(), GetKnockAwayMaxDamage(), Pawn);
        }
        //return;        
    }
Begin:

    // End:0x19
    if(IsOnTopOf(m_ThrowObstacle))
    {
        PopState();
    }
    m_WerewolfPawn.m_knockDirection = m_WerewolfPawn.GetBestKnockDirection(m_ThrowObstacle, m_knockVector);
    StartAction(13);
    J0x51:

    // End:0x77 [Loop If]
    if(int(m_WerewolfPawn.GetActionState()) == int(13))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x51;
    }
    PopState();
    stop;        
}

state SlamPlayer
{
    ignores TakeDamageAndProcEffects, NotifyTakeHit, OnAIMoveToActor, EndSlam;

    function bool PassTheBuck(optional SPBaseWerewolfAIController newAttacker)
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        bTMGGodMode = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimers();
        // End:0x27
        if(NextStateName != 'MaulPlayer')
        {
            TMGFailed();
        }
        //return;        
    }

    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        ClearTimers();
        TMGFailed();
        //return;        
    }

    event PausedState()
    {
        TMGFailed();
        //return;        
    }

    event ContinuedState()
    {
        //return;        
    }

    function TMGHandshake(Controller C)
    {
        // End:0x31
        if(C == m_TMGTarget.Controller)
        {
            ClearTimer('AbortTMG');
            m_TMGHandshakeReceived = true;
        }
        //return;        
    }

    function AbortTMG()
    {
        m_WerewolfPawn.ClearAction();
        EvaluateSituation();
        //return;        
    }

    function StartHandshakeProcess()
    {
        local PandoraPlayerController C;

        C = PandoraPlayerController(m_TMGTarget.Controller);
        m_TMGHandshakeReceived = false;
        // End:0x58
        if(C != none)
        {
            C.NotifyBeginTackle(self);
            SetTimer(0.5000000, false, 'AbortTMG');            
        }
        else
        {
            AbortTMG();
        }
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('AbortTMG');
        ClearTimer('PositionActorsSecondCheck');
        ClearTimer('RotationUpdate');
        ClearTimer('ClearRotationUpdateTimer');
        //return;        
    }

    function PositionActorsSecondCheck()
    {
        local PandoraPlayerController pController;
        local Vector socketPos;
        local Rotator SocketRot;
        local Vector socketPosStart;
        local Rotator socketRotStart;
        local Vector wwDirectionToSocket, toWerewolf;
        local float distanceVec;

        pController = PandoraPlayerController(m_SlamObstacle.Controller);
        // End:0x17D
        if(pController != none)
        {
            toWerewolf = Pawn.Location - m_SlamObstacle.Location;
            toWerewolf.Z = 0.0000000;
            toWerewolf = Normal(toWerewolf);
            m_SlamObstacle.Mesh.GetSocketWorldLocationAndRotation('WerewolfTackle', socketPos, SocketRot);
            m_SlamObstacle.Mesh.GetSocketWorldLocationAndRotation('WerewolfTackleStart', socketPosStart, socketRotStart);
            wwDirectionToSocket = socketPos - socketPosStart;
            distanceVec = VSize(wwDirectionToSocket);
            wwDirectionToSocket.Z = 0.0000000;
            wwDirectionToSocket = Normal(wwDirectionToSocket);
            Pawn.SetLocation(((m_SlamObstacle.Location + (toWerewolf * distanceVec)) - m_SlamObstacle.PrePivot) + Pawn.PrePivot);
            SetTimer(0.0100000, true, 'RotationUpdate');
            SetTimer(0.2500000, false, 'ClearRotationUpdateTimer');
        }
        //return;        
    }

    function bool PositionActors()
    {
        local PandoraPlayerController pController;
        local Rotator ViewRotation;
        local Vector socketPos;
        local Rotator SocketRot;
        local Vector socketPosStart;
        local Rotator socketRotStart;
        local Vector wwSocketPos;
        local Rotator wwSocketRot;
        local Vector wwDirectionToSocket, toWerewolf;
        local float distanceVec;
        local Vector distanceCheckVec, previousDirection;
        local float distanceCheckFloat, orientationCheck;

        ClearMove();
        m_SlamObstacle.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        m_SlamObstacle.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        pController = PandoraPlayerController(m_SlamObstacle.Controller);
        // End:0x36E
        if(pController != none)
        {
            toWerewolf = Pawn.Location - m_SlamObstacle.Location;
            toWerewolf.Z = 0.0000000;
            toWerewolf = Normal(toWerewolf);
            previousDirection = toWerewolf;
            ViewRotation = Rotator(toWerewolf);
            ViewRotation.Pitch = 0;
            ViewRotation.Roll = 0;
            pController.SetWerewolfTackleViewRotation(ViewRotation);
            m_SlamObstacle.SetRotation(ViewRotation);
            m_SlamObstacle.Mesh.GetSocketWorldLocationAndRotation('WerewolfTackle', socketPos, SocketRot);
            m_SlamObstacle.Mesh.GetSocketWorldLocationAndRotation('WerewolfTackleStart', socketPosStart, socketRotStart);
            Pawn.Mesh.GetSocketWorldLocationAndRotation('WerewolfTackle', wwSocketPos, wwSocketRot);
            wwDirectionToSocket = socketPos - socketPosStart;
            distanceVec = VSize(wwDirectionToSocket);
            wwDirectionToSocket.Z = 0.0000000;
            wwDirectionToSocket = Normal(wwDirectionToSocket);
            distanceCheckVec = ((m_SlamObstacle.Location + (toWerewolf * distanceVec)) - m_SlamObstacle.PrePivot) + Pawn.PrePivot;
            distanceCheckFloat = VSize(distanceCheckVec);
            // End:0x265
            if((distanceCheckFloat < (distanceVec - 5.0000000)) && distanceCheckFloat > (distanceVec + 5.0000000))
            {
                return false;
            }
            Pawn.SetLocation(((m_SlamObstacle.Location + (toWerewolf * distanceVec)) - m_SlamObstacle.PrePivot) + Pawn.PrePivot);
            toWerewolf = m_SlamObstacle.Location - Pawn.Location;
            toWerewolf.Z = 0.0000000;
            toWerewolf = Normal(toWerewolf);
            ViewRotation = Rotator(toWerewolf);
            ViewRotation.Pitch = 0;
            ViewRotation.Roll = 0;
            Pawn.SetRotation(ViewRotation);
            PreserveRotation();
            orientationCheck = previousDirection Dot toWerewolf;
            // End:0x367
            if(orientationCheck > -0.9600000)
            {
                return false;
            }
            Focus = none;
        }
        return true;
        //return ReturnValue;        
    }

    function EnablePlayer()
    {
        local PandoraPlayerController Player;

        Player = PandoraPlayerController(m_SlamObstacle.Controller);
        // End:0x8E
        if(Player != none)
        {
            Player.EndTackle();
            Player.NoLongerBeingTackled();
            Player.DoUnLookDownSite(true);
            Player.ResetTimer();
            Player.GotoState('ResumePlayerControl');
        }
        //return;        
    }

    function TMGFailed()
    {
        // End:0x3B
        if(m_SlamObstacle != none)
        {
            m_SlamObstacle.SetCollision(true, true);
            m_SlamObstacle.SetPhysics(1);
            EnablePlayer();
            m_SlamObstacle = none;
        }
        // End:0xDE
        if(m_WerewolfPawn != none)
        {
            m_WerewolfPawn.SetCollision(true, true);
            m_WerewolfPawn.SetMovementPhysics();
            m_WerewolfPawn.bCollideWorld = true;
            // End:0xAD
            if(m_WerewolfPawn.Mesh != none)
            {
                m_WerewolfPawn.Mesh.SetDepthPriorityGroup(1);
            }
            // End:0xDE
            if(m_WerewolfPawn.HeadTrackComponent != none)
            {
                m_WerewolfPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
            }
        }
        ClearTimer('ResetGodFromTMG');
        bTMGGodMode = false;
        Focus = GetEnemy();
        // End:0x11B
        if(m_WerewolfPawn != none)
        {
            EvaluateSituation();
        }
        //return;        
    }

    function ClearRotationUpdateTimer()
    {
        ClearTimer('RotationUpdate');
        //return;        
    }

    function RotationUpdate()
    {
        local PandoraPlayerController pController;
        local Vector toPlayer, toWerewolf;
        local Rotator ViewRotation;

        pController = PandoraPlayerController(m_SlamObstacle.Controller);
        // End:0x17A
        if(pController != none)
        {
            toWerewolf = Pawn.Location - m_SlamObstacle.Location;
            toWerewolf.Z = 0.0000000;
            toWerewolf = Normal(toWerewolf);
            ViewRotation = Rotator(toWerewolf);
            ViewRotation.Pitch = 0;
            ViewRotation.Roll = 0;
            pController.SetWerewolfTackleViewRotation(ViewRotation);
            m_SlamObstacle.SetRotation(ViewRotation);
            toPlayer = m_SlamObstacle.Location - Pawn.Location;
            toPlayer.Z = 0.0000000;
            toPlayer = Normal(toPlayer);
            ViewRotation = Rotator(toPlayer);
            ViewRotation.Pitch = 0;
            ViewRotation.Roll = 0;
            Pawn.SetRotation(ViewRotation);
            // End:0x17A
            if(int(Pawn.Physics) == int(2))
            {
                TMGFailed();
            }
        }
        //return;        
    }

    function bool IsEnemyStillAlligned()
    {
        local Vector PlayerCheck1, PlayerCheck2, WWCheckAlligned;
        local Rotator socketCheckRot;
        local float DotCheck, Distance;
        local PlayerPawn PlayerPawn;

        PlayerPawn = PlayerPawn(m_SlamObstacle);
        // End:0x1D
        if(PlayerPawn == none)
        {
            return false;
        }
        // End:0xBC
        if(((PlayerPawn.Mesh.GetSocketWorldLocationAndRotation('PlayerWWFailSafeCheck1', PlayerCheck1, socketCheckRot) == false) || Pawn.Mesh.GetSocketWorldLocationAndRotation('WWFailSafeCheckAlligned', WWCheckAlligned, socketCheckRot) == false) || PlayerPawn.Mesh.GetSocketWorldLocationAndRotation('PlayerWWFailSafeCheck2', PlayerCheck2, socketCheckRot) == false)
        {
            return true;
        }
        Distance = VSize(WWCheckAlligned - PlayerCheck1);
        DotCheck = Normal(WWCheckAlligned - PlayerCheck1) Dot Normal(PlayerCheck1 - PlayerCheck2);
        // End:0x120
        if((DotCheck < m_WerewolfGDTuneData.AllignmentFailSafeDot) || Distance > 40.0000000)
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    event ActionFinished()
    {
        // End:0x45
        if(int(m_WerewolfPawn.GetActionState()) == int(49))
        {
            // End:0x37
            if(!IsEnemyStillAlligned())
            {
                TMGFailed();                
            }
            else
            {
                GotoState('MaulPlayer');
            }
        }
        //return;        
    }

    function bool CanBeDefenderInCATAnimation(SPPawn attacker)
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    SetTimer(5.0000000, false, 'ResetGodFromTMG');
    PandoraPlayerController(m_SlamObstacle.Controller).SetWerewolfTackler(self);
    m_WerewolfPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    m_SlamObstacle.SetCollision(false, false);
    Pawn.bCollideWorld = false;
    Pawn.SetCollision(false, false);
    // End:0xC3
    if((Pawn != none) && Pawn.Mesh != none)
    {
        Pawn.Mesh.SetDepthPriorityGroup(2);
    }
    Pawn.SetPhysics(0);
    m_SlamObstacle.SetPhysics(0);
    m_TMGTarget = GetEnemy();
    StartHandshakeProcess();
    J0xFB:

    // End:0x111 [Loop If]
    if(!m_TMGHandshakeReceived)
    {
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0xFB;
    }
    m_WerewolfPawn.m_DeathThrowDirection = Normal(Pawn.Location - m_SlamObstacle.Location);
    // End:0x18E
    if((((PositionActors()) == false) || m_WerewolfPawn.Health <= 0) || !m_WerewolfPawn.bHasHead)
    {
        TMGFailed();        
    }
    else
    {
        PlayerPawn(m_SlamObstacle).playerHud.RegisterTackleMinigame(self, PandoraPlayerController(m_SlamObstacle.Controller));
        StartAction(49, false, WorldInfo.TimeSeconds + 0.0100000);
        PandoraPlayerController(m_SlamObstacle.Controller).StartMinigameTackleAction(8, WorldInfo.TimeSeconds + 0.0100000);
        SetTimer(0.0100000, false, 'PositionActorsSecondCheck');
    }
    stop;                    
}

state MaulPlayer
{
    ignores TakeDamageAndProcEffects, NotifyTakeHit, OnAIMoveToActor, PushedState;

    function bool PassTheBuck(optional SPBaseWerewolfAIController newAttacker)
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x1D
        if(m_WerewolfPawn.m_bIsInTMG)
        {
            EndMaul();
        }
        //return;        
    }

    function PoppedState()
    {
        // End:0x3E
        if((Pawn != none) && Pawn.Mesh != none)
        {
            Pawn.Mesh.SetDepthPriorityGroup(1);
        }
        //return;        
    }

    event PausedState()
    {
        //return;        
    }

    event ContinuedState()
    {
        //return;        
    }

    function EndMaul()
    {
        local int Counter;

        // End:0x3E
        if((Pawn != none) && Pawn.Mesh != none)
        {
            Pawn.Mesh.SetDepthPriorityGroup(1);
        }
        m_SlamObstacle.SetCollision(true, true);
        Pawn.SetCollision(true, true);
        Pawn.SetMovementPhysics();
        m_SlamObstacle.SetPhysics(1);
        ClearTimer('ResetGodFromTMG');
        bTMGGodMode = false;
        Pawn.bCollideWorld = true;
        m_WerewolfPawn.ClearAction();
        m_WerewolfPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
        PlayerPawn(m_SlamObstacle).playerHud.UnRegisterTackleMinigame();
        PlayerPawn(m_SlamObstacle).DoToggleTargettable(true);
        PandoraPlayerController(m_SlamObstacle.Controller).tackleMinigameManager.ResumePlayerControl();
        m_SlamObstacle = none;
        m_WerewolfPawn.m_bIsInTMG = false;
        Counter = 0;
        J0x166:

        // End:0x1D9 [Loop If]
        if(Counter < m_WerewolfPawn.m_SPEmitterArray.Length)
        {
            // End:0x1CF
            if(m_WerewolfPawn.m_SPEmitterArray[Counter] != none)
            {
                m_WerewolfPawn.m_SPEmitterArray[Counter].Destroy();
                m_WerewolfPawn.m_SPEmitterArray[Counter] = none;
            }
            Counter++;
            // [Loop Continue]
            goto J0x166;
        }
        //return;        
    }

    function Notify_HeadBlownOff()
    {
        m_WerewolfPawn.DestroyHead();
        PandoraPlayerController(m_SlamObstacle.Controller).Pawn.StopFire(0);
        SPWeapon(PandoraPlayerController(m_SlamObstacle.Controller).Pawn.Weapon).HideMuzzleFlashEmitter(true);
        //return;        
    }

    function Notify_KillshotWeaponFX()
    {
        PandoraPlayerController(m_SlamObstacle.Controller).Pawn.StartFire(0);
        SPWeapon(PandoraPlayerController(m_SlamObstacle.Controller).Pawn.Weapon).PlayFireEffects(0);
        //return;        
    }

    function Notify_KillshotWeaponFXFireParticleSystem(ParticleSystem ps, int systemNum)
    {
        local Vector vPos;
        local Rotator rRot;
        local SPEmitterSpawnable E;
        local float PSScale;

        PSScale = 1.0000000;
        switch(systemNum)
        {
            // End:0x47
            case 0:
                m_WerewolfPawn.Mesh.GetSocketWorldLocationAndRotation('ShotA', vPos, rRot);
                // End:0x12B
                break;
            // End:0x7B
            case 1:
                m_WerewolfPawn.Mesh.GetSocketWorldLocationAndRotation('ShotB', vPos, rRot);
                // End:0x12B
                break;
            // End:0xB0
            case 2:
                m_WerewolfPawn.Mesh.GetSocketWorldLocationAndRotation('ShotC', vPos, rRot);
                // End:0x12B
                break;
            // End:0xE5
            case 3:
                m_WerewolfPawn.Mesh.GetSocketWorldLocationAndRotation('head', vPos, rRot);
                // End:0x12B
                break;
            // End:0x125
            case 4:
                m_WerewolfPawn.Mesh.GetSocketWorldLocationAndRotation('Spit_1', vPos, rRot);
                PSScale = 0.6000000;
                // End:0x12B
                break;
            // End:0xFFFF
            default:
                // End:0x12B
                break;
                break;
        }
        E = Spawn(Class'SPEmitterSpawnable',,, vPos, rRot);
        // End:0x2C3
        if((E != none) && ps != none)
        {
            E.SetBase(m_WerewolfPawn, vect(0.0000000, 0.0000000, 1.0000000), m_WerewolfPawn.Mesh, 'JO_head');
            E.SetOwner(m_WerewolfPawn);
            E.SetTemplate(ps, true);
            E.bDestroyOnSystemFinish = true;
            E.ParticleSystemComponent.SetFOV(float(m_WerewolfPawn.GetTMGFOV()));
            E.ParticleSystemComponent.bUseParticleSystemFOV = true;
            E.ParticleSystemComponent.SetDepthPriorityGroup(2);
            E.ParticleSystemComponent.SetScale(PSScale);
            E.ParticleSystemComponent.ActivateSystem();
            E.bKillDuringLevelTransition = true;
            m_WerewolfPawn.m_SPEmitterArray[m_WerewolfPawn.m_SPEmitterArray.Length] = E;
        }
        //return;        
    }

    function bool CanBeDefenderInCATAnimation(SPPawn attacker)
    {
        return false;
        //return ReturnValue;        
    }

    event ActionFinished()
    {
        // End:0x7A
        if((((int(m_WerewolfPawn.GetActionState()) == int(52)) || int(m_WerewolfPawn.GetActionState()) == int(54)) || int(m_WerewolfPawn.GetActionState()) == int(56)) || int(m_WerewolfPawn.GetActionState()) == int(58))
        {
            m_bWaitingToBreakOutOfMaul = false;
        }
        //return;        
    }

    function WaitingToBreakOutOfMaul()
    {
        m_bWaitingToBreakOutOfMaul = false;
        //return;        
    }

    function WaitingToBreakOutOfMaulFailed()
    {
        m_bWaitingToBreakOutOfMaul = false;
        //return;        
    }

    function bool IsInMiniGame()
    {
        // End:0x74
        if((((int(m_WerewolfPawn.GetActionState()) == int(50)) || int(m_WerewolfPawn.GetActionState()) == int(53)) || int(m_WerewolfPawn.GetActionState()) == int(55)) || int(m_WerewolfPawn.GetActionState()) == int(51))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool SlamObstacleIsDead()
    {
        // End:0x2C
        if((m_SlamObstacle.Health <= 0) || m_SlamObstacle.bDeleteMe)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    m_WerewolfPawn.m_bIsInTMG = true;
    PlayerPawn(m_SlamObstacle).DoToggleTargettable(false);
    PandoraPlayerController(m_SlamObstacle.Controller).tackleMinigameManager.StartMinigame(self, PandoraPlayerController(m_SlamObstacle.Controller));
    // End:0xAC
    if((Pawn != none) && Pawn.Mesh != none)
    {
        Pawn.Mesh.SetDepthPriorityGroup(2);
    }
    J0xAC:

    // End:0xD5 [Loop If]
    if((IsInMiniGame()) && !SlamObstacleIsDead())
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0xAC;
    }
    m_bWaitingToBreakOutOfMaul = true;
    // End:0x1C8
    if(PandoraPlayerController(m_SlamObstacle.Controller).tackleMinigameManager.IsState('ButtonMash2Fail'))
    {
        GetEnemy().TakeDamageAndProcEffects(30.0000000, self, m_SlamObstacle.Location, Vector(Pawn.Rotation), m_WerewolfPawn.m_biteDamageType,, Pawn);
        SetTimer(4.7000000, false, 'WaitingToBreakOutOfMaulFailed');
        J0x17D:

        // End:0x191 [Loop If]
        if(m_bWaitingToBreakOutOfMaul)
        {
            Sleep(0.0000000);
            // [Loop Continue]
            goto J0x17D;
        }
        ClearTimer('WaitingToBreakOutOfMaulFailed');
        EndMaul();
        Focus = GetEnemy();
        EvaluateSituation();        
    }
    else
    {
        // End:0x25F
        if(PandoraPlayerController(m_SlamObstacle.Controller).tackleMinigameManager.IsState('ButtonMash1Abort'))
        {
            SetTimer(3.4000000, false, 'WaitingToBreakOutOfMaulFailed');
            J0x214:

            // End:0x228 [Loop If]
            if(m_bWaitingToBreakOutOfMaul)
            {
                Sleep(0.0000000);
                // [Loop Continue]
                goto J0x214;
            }
            ClearTimer('WaitingToBreakOutOfMaulFailed');
            EndMaul();
            Focus = GetEnemy();
            EvaluateSituation();            
        }
        else
        {
            // End:0x347
            if(PandoraPlayerController(m_SlamObstacle.Controller).tackleMinigameManager.IsState('ButtonMash1Fail'))
            {
                GetEnemy().TakeDamageAndProcEffects(10.0000000, self, m_SlamObstacle.Location, Vector(Pawn.Rotation), m_WerewolfPawn.m_biteDamageType,, Pawn);
                SetTimer(3.2000000, false, 'WaitingToBreakOutOfMaulFailed');
                J0x2FF:

                // End:0x313 [Loop If]
                if(m_bWaitingToBreakOutOfMaul)
                {
                    Sleep(0.0000000);
                    // [Loop Continue]
                    goto J0x2FF;
                }
                ClearTimer('WaitingToBreakOutOfMaulFailed');
                EndMaul();
                Focus = GetEnemy();
                EvaluateSituation();
            }
        }
    }
    stop;                    
}

state MoveToGoal
{
    function GotoMoveToGoalState()
    {
        GotoState('WerewolfMoveToGoal', 'Begin', true, true);
        //return;        
    }
    stop;    
}

state WerewolfMoveToGoal extends KyMoveToGoal
{
    event bool AllowedToReactToSuppression(out SuppressionMemory Suppression)
    {
        // End:0x73
        if((((int(m_WerewolfPawn.GetActionState()) == int(14)) || int(m_WerewolfPawn.GetActionState()) == int(15)) || int(m_WerewolfPawn.GetActionState()) == int(16)) || m_WerewolfPawn.GetUseDodgeRun())
        {
            return false;            
        }
        else
        {
            // End:0xA3
            if((WorldInfo.TimeSeconds - m_lastSuppressionTime) < RandRange(2.0000000, 3.0000000))
            {
                return false;                
            }
            else
            {
                // End:0xB0
                if(!IsPathfinderUsingGroundMode())
                {
                    return false;
                }
            }
        }
        return true;
        //return ReturnValue;        
    }

    event Dodge(SPAIController.EDodgeDirectionType dodgeType)
    {
        // End:0xB2
        if(int(dodgeType) == int(3))
        {
            // End:0xAF
            if(m_WerewolfPawn.IsBiped() == false)
            {
                m_lastSuppressionTime = WorldInfo.TimeSeconds;
                m_currentDodgeStyle = dodgeType;
                m_WerewolfPawn.SetUseDodgeRun(true);
                Pawn.MaxDesiredSpeed = 0.5000000;
                Pawn.DesiredSpeed = 0.5000000;
                ClearTimer('StopDodgeRun');
                SetTimer(RandRange(0.5000000, 1.0000000), false, 'StopDodgeRun');
            }            
        }
        else
        {
            m_lastSuppressionTime = WorldInfo.TimeSeconds;
            m_currentDodgeStyle = dodgeType;
            ClearKynapseAgent();
            GotoState(GetStateName(), 'DodgeDelayMove', false, true);
        }
        //return;        
    }

    event ActionFinished()
    {
        // End:0x7A
        if(((int(m_WerewolfPawn.GetActionState()) == int(14)) || int(m_WerewolfPawn.GetActionState()) == int(15)) || int(m_WerewolfPawn.GetActionState()) == int(16))
        {
            m_WerewolfPawn.ClearAction();
            GotoState(GetStateName(), 'MoveLoop', false, true);
        }
        //return;        
    }

    function bool StartDodge()
    {
        // End:0x1D
        if(int(m_currentDodgeStyle) == int(2))
        {
            StartAction(14);            
        }
        else
        {
            // End:0x3A
            if(int(m_currentDodgeStyle) == int(1))
            {
                StartAction(15);                
            }
            else
            {
                // End:0x57
                if(int(m_currentDodgeStyle) == int(4))
                {
                    StartAction(16);                    
                }
                else
                {
                    return false;
                }
            }
        }
        return true;
        //return ReturnValue;        
    }

    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        InitStanceForMovement();
        //return;        
    }

    event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ResetPathConstraints();
        //return;        
    }

    event PushedState()
    {
        super.PushedState();
        SetPathConstraints();
        InitStanceForMovement();
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        ResetPathConstraints();
        //return;        
    }

    event ContinuedState()
    {
        super.ContinuedState();
        SetPathConstraints();
        //return;        
    }

    event PausedState()
    {
        super.PausedState();
        //return;        
    }

    function InitStanceForMovement()
    {
        StanceUpdate();
        //return;        
    }

    function bool IsGoalDirectlyReachable()
    {
        local bool bIsSuppressed;

        // End:0x29
        if((Pawn != none) && int(Pawn.Physics) == int(8))
        {
            return false;
        }
        // End:0x61
        if(super.IsGoalDirectlyReachable())
        {
            // End:0x5F
            if(m_SuppressionConstraints.ShouldTest)
            {
                bIsSuppressed = IsSuppressed();
                return !bIsSuppressed;                
            }
            else
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function FinishedMoveToGoal()
    {
        PopState();
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        checkfocus();
        //return;        
    }
DodgeDelayMove:

    // End:0x85
    if(StartDodge())
    {
        // End:0x6E
        if((Pawn != none) && int(Pawn.Physics) != int(2))
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        m_bDelayingMove = true;
        StopLatentExecution();
        ClearKynapseAgent();        
    }
    else
    {
        goto 'MoveLoop';
    }
    stop;                    
}

state Melee
{
    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        ClearTimer('MeleeUpdateTimer');
        m_bInMeleeMode = false;
        AllowConcentratedDamageActive(0, false);
        AllowConcentratedDamageActive(1, false);
        AllowConcentratedDamageActive(2, false);
        AllowConcentratedDamageActive(3, false);
        AllowConcentratedDamageActive(4, false);
        ClearActiveConcentratedDamage();
        SetPawnRotationRate(3072, 4096, 80000);
        //return;        
    }

    function ContinuedState()
    {
        // End:0x2D
        if(m_returnedFromTakeHit)
        {
            m_returnedFromTakeHit = false;
            m_WerewolfPawn.ClearAction();
            ClearMeleeDodge();
        }
        //return;        
    }

    function StartMeleeUpdateTimer()
    {
        SetTimer(0.2000000, true, 'MeleeUpdateTimer');
        //return;        
    }

    final function bool FindMeleeMoveToPoint()
    {
        local SPBaseWerewolfPawnPersistent.eWerewolfAttackRange rangeType;

        rangeType = m_WerewolfPawn.GetActorAttackRange(GetEnemy());
        // End:0x70
        if((int(rangeType) <= int(2)) && (int(m_WerewolfPawn.GetActionState()) == int(24)) || int(m_WerewolfPawn.GetActionState()) == int(25))
        {
            return false;            
        }
        else
        {
            m_meleeMoveInfo.movetype = 0;
            m_meleeMoveInfo.meleeMoveType = 0;
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    final function DoMeleeMoveToPoint()
    {
        SetMoveGoal(GetEnemy(), 1, m_meleeMoveInfo.Offset, m_meleeMoveInfo.movetype);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('MeleeMoveToGoal');
        //return;        
    }

    function bool IsAtDestination(const out Vector Loc, Actor GoalActor)
    {
        return false;
        //return ReturnValue;        
    }

    function InduceMeleeDodge(SPAIController.EDodgeDirectionType dodgeType, bool bIsFullBodyDodge)
    {
        // End:0x1C
        if(int(Pawn.Physics) != int(1))
        {
            return;
        }
        m_currentDodgeStyle = dodgeType;
        m_bIsDoingFullBodyMeleeDodge = bIsFullBodyDodge;
        // End:0x50
        if(int(m_currentDodgeStyle) == int(2))
        {
            StartMeleeDodge(2);            
        }
        else
        {
            // End:0x69
            if(int(m_currentDodgeStyle) == int(1))
            {
                StartMeleeDodge(1);
            }
        }
        //return;        
    }

    event Dodge(SPAIController.EDodgeDirectionType dodgeType)
    {
        m_lastSuppressionTime = WorldInfo.TimeSeconds;
        InduceMeleeDodge(dodgeType, false);
        //return;        
    }

    event SuppressionDetected(out SuppressionMemory Suppression)
    {
        local int PlayerIdx;
        local Pawn pEnemyPawn;

        // End:0xA8
        if((Suppression.Instigator != none) && Suppression.Instigator.Controller != none)
        {
            PlayerIdx = GetPlayerIdx(Suppression.Instigator.Controller);
            // End:0xA8
            if(IsValidPlayerIdx(PlayerIdx))
            {
                // End:0xA8
                if(m_playerList[PlayerIdx].damageSustained <= 0.0000000)
                {
                    m_playerList[PlayerIdx].damageSustained = 1.0000000;
                }
            }
        }
        // End:0xB9
        if(!AllowedToDoMeleeMoveTo(false))
        {
            return;            
        }
        else
        {
            // End:0xE9
            if((WorldInfo.TimeSeconds - m_lastSuppressionTime) < RandRange(1.0000000, 3.0000000))
            {
                return;                
            }
            else
            {
                // End:0xF6
                if(!IsPathfinderUsingGroundMode())
                {
                    return;
                }
            }
        }
        pEnemyPawn = GetEnemy();
        ReactToSuppression(Suppression, pEnemyPawn.Location, pEnemyPawn.Location, pEnemyPawn, true);
        //return;        
    }

    final function HandleMeleeRestartInMiddleOfLongMeleeAction()
    {
        local SPBaseWerewolfAIController.EMeleeAction newAction;

        newAction = DetermineMeleeAction(true);
        // End:0x3B
        if(IsLongMeleeActionDifferentFromCurrentAction(newAction))
        {
            m_WerewolfPawn.ClearAction();
            ActOnMeleeAction(newAction);
        }
        //return;        
    }

    event bool UpdateFocus()
    {
        // End:0x43
        if(HasConcentratedTorsoDamage(false, true))
        {
            Focus = none;
            FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function StanceUpdate()
    {
        local SPBaseWerewolfPawnPersistent.eWerewolfAttackRange attackRange;

        attackRange = m_WerewolfPawn.GetActorAttackRange(GetEnemy());
        // End:0x47
        if(int(attackRange) <= int(2))
        {
            m_WerewolfPawn.SetStance(1);            
        }
        else
        {
            global.StanceUpdate();
        }
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        // End:0x2E
        if(m_WerewolfPawn.IsDoingExtractedCloseTheGapAction())
        {
            DealWithObstacle(Other, GetEnemy(), true);
        }
        return false;
        //return ReturnValue;        
    }

    final function DetermineIfCloseTheGapIsEligible()
    {
        local bool bIsEnemyAPlayer;
        local int randomNum;

        bIsEnemyAPlayer = GetEnemy().IsA('PlayerPawn');
        // End:0x34
        if(bIsEnemyAPlayer)
        {
            m_bPreventCloseTheGap = false;
            return;
        }
        randomNum = int(RandRange(0.0000000, 100.0000000));
        m_bPreventCloseTheGap = float(randomNum) <= m_WerewolfGDTuneData.PreventCloseTheGapPercentage;
        //return;        
    }
Begin:

    m_bInMeleeMode = true;
    // End:0x21
    if(m_bUseHitAndRun)
    {
        m_meleeAttackCounter = Rand(3) + 1;        
    }
    else
    {
        m_meleeAttackCounter = Rand(int(m_WerewolfPawn.GetAngerLevel() * float(4))) + 1;
    }
    m_returnedFromTakeHit = false;
    ClearActiveConcentratedDamage();
    AllowConcentratedDamageActive(0, true);
    AllowConcentratedDamageActive(1, true);
    AllowConcentratedDamageActive(2, true);
    AllowConcentratedDamageActive(3, true);
    AllowConcentratedDamageActive(4, true);
    ClearMeleeMovePoint();
    ClearMeleeDodge();
    DetermineIfCloseTheGapIsEligible();
    // End:0xB7
    if(!IsDoingLongMeleeAttack())
    {
        m_WerewolfPawn.ClearAction();        
    }
    else
    {
        HandleMeleeRestartInMiddleOfLongMeleeAction();
    }
    StartMeleeUpdateTimer();
    J0xC7:

    // End:0xF4 [Loop If]
    if(ShouldStillMelee())
    {
        // End:0xE9
        if(AllowedToDoMeleeMoveTo(false))
        {
            // End:0xE9
            if(FindMeleeMoveToPoint())
            {
                DoMeleeMoveToPoint();
            }
        }
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0xC7;
    }
    // End:0x174
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x174
        if(int(m_lastMoveStatus) == int(3))
        {
            ExcludeFromGetBestEnemy(GetEnemy().Controller, 1.0000000);
            AssignEnemy();
            // End:0x174
            if((GetEnemy()) == none)
            {
                m_WerewolfPawn.TriggerEventClass(Class'SeqEvent_SPTargetUnreachable', m_WerewolfPawn);
            }
        }
    }
    // End:0x1B3
    if(m_bUseHitAndRun && float(m_squad.m_members.Length) >= m_WerewolfGDTuneData.MinSquadMembersForHitAndRun)
    {
        GotoState('HitAndRunRetreatThenEvaluate');
    }
    Sleep(0.0500000);
    EvaluateSituation();
    stop;            
}

state MeleeMoveToGoal extends WerewolfMoveToGoal
{
    function SetTimers()
    {
        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        local Vector myVelDir;
        local float myVelScale;
        local SPBaseWerewolfPawnPersistent.eWerewolfAttackRange rangeType;
        local float slowDownBias;

        // End:0x28
        if(!AllowedToDoMeleeMoveTo(true) || !ShouldStillMelee())
        {
            AbortMove(false, false, false);
            return;
        }
        rangeType = m_WerewolfPawn.GetActorAttackRange(GetEnemy());
        // End:0x85
        if((int(m_meleeMoveInfo.meleeMoveType) == int(1)) && int(rangeType) > int(1))
        {
            AbortMove(false, false, false);
            return;
        }
        // End:0x1A0
        if((int(m_meleeMoveInfo.meleeMoveType) == int(0)) && int(rangeType) < int(2))
        {
            slowDownBias = 0.0000000;
            // End:0xE8
            if((WorldInfo.TimeSeconds - m_lastMediumWeaponHitTime) < 1.0000000)
            {
                slowDownBias = m_currentSlowDownBias;
            }
            myVelDir = Normal(Pawn.Velocity);
            myVelScale = myVelDir Dot GetEnemy().Velocity;
            // End:0x181
            if((myVelScale < Pawn.GroundSpeed) && myVelScale > 0.0000000)
            {
                Pawn.MaxDesiredSpeed = ((myVelScale / Pawn.GroundSpeed) + 0.1000000) - slowDownBias;                
            }
            else
            {
                Pawn.MaxDesiredSpeed = 1.0000000 - slowDownBias;
            }            
        }
        else
        {
            Pawn.MaxDesiredSpeed = 1.0000000;
        }
        super.MoveToGoalTimerUpdate();
        //return;        
    }

    function KillMeleeMove()
    {
        AbortMove(false, false, false);
        //return;        
    }

    function EndState(name NextStateName)
    {
        Pawn.MaxDesiredSpeed = 1.0000000;
        Pawn.DesiredSpeed = 1.0000000;
        super.EndState(NextStateName);
        //return;        
    }

    function PoppedState()
    {
        // End:0x35
        if(Pawn != none)
        {
            Pawn.MaxDesiredSpeed = 1.0000000;
            Pawn.DesiredSpeed = 1.0000000;
        }
        super.PoppedState();
        //return;        
    }

    function ContinuedState()
    {
        // End:0x33
        if(m_returnedFromTakeHit)
        {
            m_returnedFromTakeHit = false;
            m_WerewolfPawn.ClearAction();
            AbortMove(false, false, false);
        }
        super.ContinuedState();
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local SPPawn OtherPawn;

        OtherPawn = SPPawn(Other);
        // End:0x51
        if((OtherPawn != none) && OtherPawn != (GetEnemy()))
        {
            // End:0x51
            if(IsValidEnemyPawn(OtherPawn, true))
            {
                SetEnemy(OtherPawn);
            }
        }
        return super(KyMoveToGoal).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function bool IsGoalDirectlyReachable()
    {
        // End:0x29
        if((Pawn != none) && int(Pawn.Physics) == int(8))
        {
            return false;
        }
        return super(KyMoveToGoal).IsGoalDirectlyReachable();
        //return ReturnValue;        
    }

    function bool StartDodge()
    {
        // End:0x52
        if(m_WerewolfPawn.IsBiped())
        {
            // End:0x2F
            if(int(m_currentDodgeStyle) == int(2))
            {
                StartMeleeDodge(2);                
            }
            else
            {
                // End:0x4B
                if(int(m_currentDodgeStyle) == int(1))
                {
                    StartMeleeDodge(1);                    
                }
                else
                {
                    return false;
                }
            }
            return true;            
        }
        else
        {
            return super.StartDodge();
        }
        //return ReturnValue;        
    }

    event bool AllowedToReactToSuppression(out SuppressionMemory Suppression)
    {
        // End:0x3A
        if((int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(2)) || int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(1))
        {
            return false;
        }
        return super.AllowedToReactToSuppression(Suppression);
        //return ReturnValue;        
    }

    function MeleeDodgeFinished()
    {
        // End:0x4F
        if((int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(2)) || int(m_WerewolfPawn.GetAnimMeleeDodgeState()) == int(1))
        {
            ClearMeleeDodge();
            GotoState(GetStateName(), 'MoveLoop', false, true);
        }
        //return;        
    }

    function StanceUpdate()
    {
        local SPBaseWerewolfPawnPersistent.eWerewolfAttackRange attackRange;

        attackRange = m_WerewolfPawn.GetActorAttackRange(GetEnemy());
        // End:0x47
        if(int(attackRange) <= int(2))
        {
            m_WerewolfPawn.SetStance(1);            
        }
        else
        {
            global.StanceUpdate();
        }
        //return;        
    }
    stop;    
}

state PursueEnemy
{Begin:

    stop;                
}

state MoveToDefendAreaDestination extends WerewolfMoveToGoal
{
    function SetDefendAreaSquadCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
    {
        // End:0x30
        if(!IsSameDefendAreaCommand(squadCommand, Param))
        {
            super(SPAIController).SetDefendAreaSquadCommand(squadCommand, Param);
            PopState();
        }
        //return;        
    }

    function ClearDefendAreaSquadCommand()
    {
        local bool bWasDefendingArea;

        bWasDefendingArea = IsDefendingArea();
        super(SPAIController).ClearDefendAreaSquadCommand();
        // End:0x23
        if(bWasDefendingArea)
        {
            PopState();
        }
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x2D
        if((HasValidEnemy()) || CheckForEnemy())
        {
            PopState();
            return;
        }
        super.MoveToGoalTimerUpdate();
        //return;        
    }
    stop;    
}

state GotoDefendAreaDestination
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToDefendAreaDestination');
        //return;        
    }
Begin:

    // End:0x19
    if(m_defendAreaKyVertID == -1)
    {
        EvaluateSituation();
    }
    SetMoveGoal(none, 0, m_defendAreaPosition, 2, false);
    // End:0x56
    if((Pawn != none) && IsActorInDefendArea(Pawn))
    {
        SetHasBeenInDefendArea(true);
    }
    Sleep(0.1000000);
    EvaluateSituation();
    stop;                
}

state ThrowObject
{
    function BeginState(name PreviousStateName)
    {
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    function EndState(name NextStateName)
    {
        m_WerewolfPawn.ClearAction();
        UnclaimObject();
        //return;        
    }

    function PushedState()
    {
        m_WerewolfPawn.ClearAction();
        //return;        
    }

    function PoppedState()
    {
        m_WerewolfPawn.ClearAction();
        UnclaimObject();
        //return;        
    }

    event ClaimInterrupted(Actor claimedObject, Actor newClaimant, Object.SPAITagTypes newClaimType)
    {
        // End:0x21
        if(claimedObject == m_moveToThrowObjectInfo.objectToThrow)
        {
            PopState();
        }
        //return;        
    }

    function UnclaimObject()
    {
        // End:0x4C
        if(m_moveToThrowObjectInfo.objectToThrow != none)
        {
            m_moveToThrowObjectInfo.objectToThrow.UnclaimInteractionRights(Pawn);
            m_moveToThrowObjectInfo.objectToThrow = none;
        }
        //return;        
    }
Begin:

    // End:0x31
    if(m_moveToThrowObjectInfo.objectToThrow == none)
    {
        // End:0x27
        if(bOnlyAllowThrowingAttacks)
        {
            Sleep(1.5000000);
        }
        goto 'End';
    }
    m_moveToThrowObjectInfo.objectToThrow.ClaimInteractionRights(Pawn, 2, true);
    PushState('GetInPositionToThrowObject');
    // End:0x12C
    if(m_moveToThrowSuccessful && (GetEnemy()) != none)
    {
        Focus = GetEnemy();
        FocalPoint = GetEnemy().Location;
        FinishRotation();
        PreserveRotation();
        Focus = none;
        DealWithThrowObstacle(m_moveToThrowObjectInfo.objectToThrow, GetEnemy(), false);
        // End:0x11D
        if((PrivledgedThrowID > -1) && PrivledgedThrowID < PrivledgedThrowList.Length)
        {
            PrivledgedThrowList[PrivledgedThrowID].nUses++;
        }
        m_extraHitAndRunChance += 20.0000000;        
    }
    J0x12C:

    Sleep(0.1000000);
    UnclaimObject();
    EvaluateSituation();
    stop;                
}

state GetInPositionToThrowObject
{
    function PushedState()
    {
        SPPawn(Pawn).bNoWallEndAnchor = true;
        m_WerewolfPawn.ReplaceOATSTagOnObjectBITFIELD(m_moveToThrowObjectInfo.objectToThrow, 32, 0.0000000);
        //return;        
    }

    function PoppedState()
    {
        SPPawn(Pawn).bNoWallEndAnchor = false;
        m_WerewolfPawn.CancelOATSTagOverride(m_moveToThrowObjectInfo.objectToThrow);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('MoveToThrowableObject');
        //return;        
    }

    function bool CanPathTo()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

    m_WerewolfPawn.SetStance(0);
    m_moveToThrowSuccessful = false;
    Focus = m_moveToThrowObjectInfo.objectToThrow;
    SetMoveGoal(none, 1, m_moveToThrowObjectInfo.throwLocation, 2, false, false, m_cachedMoveTargetToEnemy);
    // End:0xBB
    if(int(m_lastMoveStatus) != int(4))
    {
        ForceFailHistory(m_moveToThrowObjectInfo.objectToThrow, 2, 10.0000000);
        // End:0xB8
        if(bOnlyAllowThrowingAttacks && PrivledgedThrowID != -1)
        {
            PrivledgedThrowList[PrivledgedThrowID].Actor = none;
        }        
    }
    else
    {
        // End:0x103
        if(((IsObjectStillValidToThrow(GetEnemy(), m_moveToThrowObjectInfo)) && !m_WerewolfPawn.HasConcentratedArmDamage()) && !HasConcentratedHeadDamage())
        {
            m_moveToThrowSuccessful = true;
        }
    }
    PopState();
    stop;        
}

state MoveToThrowableObject extends WerewolfMoveToGoal
{
    function KnockWerewolfOffWall()
    {
        local Vector SurfaceNormal;

        ForceFailHistory(m_moveToThrowObjectInfo.objectToThrow, 2, 10.0000000);
        SurfaceNormal = Pawn.Floor;
        m_WerewolfPawn.SetWalkMovementType(m_WerewolfPawn.IsBiped());
        Pawn.SetPhysics(2);
        Pawn.Velocity = float(400) * SurfaceNormal;
        AbortMove(false, false, false);
        //return;        
    }

    function MoveToGoalObstacleTimerUpdate()
    {
        // End:0x4B
        if((!IsObjectStillValidToThrow(GetEnemy(), m_moveToThrowObjectInfo) || m_WerewolfPawn.HasConcentratedArmDamage()) || HasConcentratedHeadDamage())
        {
            AbortMove();
        }
        //return;        
    }

    event YouAreStuck()
    {
        super(SPAIController).YouAreStuck();
        AbortMove();
        //return;        
    }

    function SetPathConstraints()
    {
        super(SPBaseWerewolfAIController).SetPathConstraints();
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local SPPawn OtherPawn;

        OtherPawn = SPPawn(Other);
        // End:0x5D
        if((OtherPawn != none) && int(Physics) != int(8))
        {
            // End:0x5D
            if(IsValidEnemyPawn(OtherPawn, true))
            {
                SetEnemy(OtherPawn);
                GotoState('Melee');
                return false;
            }
        }
        return super(KyMoveToGoal).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }
    stop;    
}

state EatFood
{
    function UpdateEatingStage()
    {
        return;
        //return;        
    }
Begin:

    StartAction(45);
    Focus = m_foodWeAreEating;
    J0x15:

    // End:0x3E [Loop If]
    if(ShouldIBeEatingFood() && AmIAtFood())
    {
        UpdateEatingStage();
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x15;
    }
    EndEating();
    EvaluateSituation();
    stop;        
}

state GoToFood
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToFood');
        //return;        
    }
    J0x00:
    // End:0x51 [Loop If]
    if(ShouldIBeEatingFood() && !AmIAtFood())
    {
        Focus = m_foodWeAreEating;
        SetMoveGoal(m_foodWeAreEating, 1, vect(0.0000000, 0.0000000, 0.0000000), 0);
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x00;
    }
    EvaluateSituation();
    stop;                    
}

state MoveToFood extends WerewolfMoveToGoal
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    function PushedState()
    {
        super.PushedState();
        //return;        
    }

    function PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function ContinuedState()
    {
        super.ContinuedState();
        //return;        
    }

    function PausedState()
    {
        super.PausedState();
        //return;        
    }

    function SetPathConstraints()
    {
        ResetPathConstraints();
        //return;        
    }
    stop;    
}

state Regenerate
{    stop;    
}

state HitAndRun
{
    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        m_bUseHitAndRun = false;
        //return;        
    }
Begin:

    m_extraHitAndRunChance = 0.0000000;
    // End:0x30
    if(!AmIFarEnoughToHitAndRun(GetEnemy()))
    {
        PushState('HitAndRunRetreat');
    }
    m_bUseHitAndRun = true;
    PushState('Melee');
    EvaluateSituation();
    stop;        
}

state HitAndRunRetreatThenEvaluate
{Begin:

    PushState('HitAndRunRetreat');
    EvaluateSituation();
    stop;        
}

state HitAndRunRetreat
{
    function GotoMoveToGoalState()
    {
        PushState('MoveAwayHitAndRun');
        //return;        
    }

    function RunToOpenSpot()
    {
        local Vector theSpot;
        local RunAwayInfo runInfo;

        runInfo.runAwayFromActor = GetEnemy();
        runInfo.minRunAwayDist = 500.0000000;
        runInfo.maxRunAwayDist = 4000.0000000;
        runInfo.minPreferredRunAwayDist = 1500.0000000;
        runInfo.maxPreferredRunAwayDist = 3000.0000000;
        runInfo.fullLOSWeight = 0.0000000;
        runInfo.partialLOSWeight = 5.0000000;
        runInfo.noLOSWeight = 10.0000000;
        runInfo.distanceWeight = 7.0000000;
        runInfo.minimumRatingValue = 7.5000000;
        runInfo.returnFallBackValue = true;
        // End:0x121
        if(FindRunAwaySpot(runInfo, theSpot))
        {
            SetMoveGoal(none, 2, theSpot, 2, false, false);
        }
        //return;        
    }
Begin:

    m_WerewolfPawn.SetStance(0);
    RunToOpenSpot();
    Sleep(0.0500000);
    PopState();
    stop;                
}

state HitAndRunMinigame
{
    function PushedState()
    {
        StartUp();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        StartUp();
        //return;        
    }

    function StartUp()
    {
        m_WerewolfPawn.m_bAIPreventHitReaction = true;
        m_WerewolfPawn.m_bAIPreventDeath = true;
        m_extraHitAndRunChance = 0.0000000;
        StartCloseTheGapToMinigameAnim();
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        m_WerewolfPawn.m_bAIPreventHitReaction = false;
        m_WerewolfPawn.m_bAIPreventDeath = false;
        ReturnControlToMinigameTarget();
        m_hitAndRunMinigameTarget = none;
        m_playerHitAndRunMinigameChance = default.m_playerHitAndRunMinigameChance;
        // End:0x7E
        if((Pawn != none) && Pawn.Mesh != none)
        {
            Pawn.Mesh.SetDepthPriorityGroup(1);
        }
        //return;        
    }

    function MinigameHandshake(Controller C)
    {
        // End:0x31
        if(C == m_hitAndRunMinigameTarget.Controller)
        {
            ClearTimer('AbortHitAndRun');
            m_minigameHandshakeReceived = true;
        }
        //return;        
    }

    function ReturnControlToMinigameTarget()
    {
        local PandoraPlayerController C;

        C = PandoraPlayerController(m_hitAndRunMinigameTarget.Controller);
        // End:0x39
        if(C != none)
        {
            C.NotifyEndWerewolfHitAndRun();
        }
        //return;        
    }

    function AbortHitAndRun()
    {
        GotoState(GetStateName(), 'End', false, true);
        //return;        
    }

    function StartHandshakeProcess()
    {
        local PandoraPlayerController C;

        C = PandoraPlayerController(m_hitAndRunMinigameTarget.Controller);
        m_minigameHandshakeReceived = false;
        // End:0x58
        if(C != none)
        {
            C.NotifyBeginWerewolfHitAndRun(self);
            SetTimer(0.5000000, false, 'AbortHitAndRun');            
        }
        else
        {
            AbortHitAndRun();
        }
        //return;        
    }

    function CheckIfTargetIsOK()
    {
        // End:0x32
        if((m_hitAndRunMinigameTarget == none) || m_hitAndRunMinigameTarget.Health <= 0)
        {
            GotoState(GetStateName(), 'End', false, true);
        }
        //return;        
    }

    event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
    {
        return false;
        //return ReturnValue;        
    }

    function StartCloseTheGapToMinigameAnim()
    {
        m_bFinishedCloseTheGapToMinigameAnim = false;
        m_WerewolfPawn.SetAnimActionState(m_minigameAction, false);
        m_WerewolfPawn.SetHitAndRunState(2);
        //return;        
    }

    function ActionFinished()
    {
        // End:0x72
        if(((int(m_WerewolfPawn.GetActionState()) == int(41)) || int(m_WerewolfPawn.GetActionState()) == int(42)) || int(m_WerewolfPawn.GetActionState()) == int(43))
        {
            m_bFinishedCloseTheGapToMinigameAnim = true;
            m_WerewolfPawn.ClearAction();
        }
        //return;        
    }
Begin:

    m_hitAndRunMinigameTarget = GetEnemy();
    StartHandshakeProcess();
    J0x1A:

    // End:0x30 [Loop If]
    if(!m_minigameHandshakeReceived)
    {
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0x1A;
    }
    // End:0x6E
    if((Pawn != none) && Pawn.Mesh != none)
    {
        Pawn.Mesh.SetDepthPriorityGroup(2);
    }
    m_minigameResult = 0;
    PushState('HitAndRunSwipePlayerToPosition');
    // End:0xA0
    if(int(m_minigameResult) == int(3))
    {
        goto 'End';
    }
    m_minigameResult = 0;
    PushState('HitAndRunMinigameEntry');
    // End:0xE5
    if(int(m_minigameResult) == int(1))
    {
        PushState('HitAndRunMinigameWaitForDodge');
        goto 'End';        
    }
    else
    {
        // End:0x108
        if(int(m_minigameResult) == int(2))
        {
            PushState('HitAndRunMinigameWaitForCounter');            
        }
        else
        {
            PushState('HitAndRunMinigameWaitForFail');
            goto 'End';
        }
    }
    m_minigameResult = 0;
    CheckIfTargetIsOK();
    PushState('HitAndRunMinigameChain');
    // End:0x167
    if(int(m_minigameResult) == int(2))
    {
        PushState('HitAndRunMinigameWaitForCounter');        
    }
    else
    {
        PushState('HitAndRunMinigameWaitForFail');
        goto 'End';
    }
    m_minigameResult = 0;
    CheckIfTargetIsOK();
    PushState('HitAndRunMinigameFinish');
    // End:0x1C6
    if(int(m_minigameResult) == int(2))
    {
        PushState('HitAndRunMinigameWaitForCounter');        
    }
    else
    {
        PushState('HitAndRunMinigameWaitForFail');
        goto 'End';
    }
    J0x1E0:

    Sleep(0.1000000);
    ReturnControlToMinigameTarget();
    m_WerewolfPawn.ClearAction();
    GotoState('HitAndRunRetreatThenEvaluate');
    stop;            
}

state HitAndRunSwipePlayerToPosition
{
    function ActionFinished()
    {
        // End:0x72
        if(((int(m_WerewolfPawn.GetActionState()) == int(41)) || int(m_WerewolfPawn.GetActionState()) == int(42)) || int(m_WerewolfPawn.GetActionState()) == int(43))
        {
            m_bFinishedCloseTheGapToMinigameAnim = true;
            m_WerewolfPawn.ClearAction();
        }
        //return;        
    }

    function InAlignment()
    {
        m_minigameTargetAlignmentFinished = true;
        //return;        
    }

    function bool IsPositioningFinished()
    {
        // End:0x0D
        if(!m_minigameTargetAlignmentFinished)
        {
            return false;
        }
        // End:0x2A
        if(int(m_WerewolfPawn.GetActionState()) != int(0))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    function Vector GetPositionToSlideTo()
    {
        local Vector deltaDir, moveToLoc;

        deltaDir = Pawn.Location - m_hitAndRunMinigameTarget.Location;
        deltaDir = Normal(deltaDir);
        moveToLoc = m_hitAndRunMinigameTarget.Location + (deltaDir * 350.0000000);
        return moveToLoc;
        //return ReturnValue;        
    }

    event bool UpdateFocus()
    {
        Focus = m_hitAndRunMinigameTarget;
        FocalPoint = m_hitAndRunMinigameTarget.Location;
        return true;
        //return ReturnValue;        
    }

    event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    m_minigameTargetAlignmentFinished = false;
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).StartAlignment();
    m_minigameMoveToLoc = GetPositionToSlideTo();
    MoveTo(m_minigameMoveToLoc);
    Focus = m_hitAndRunMinigameTarget;
    // End:0x7F
    if(!SPPawn(Pawn).ReachedDestinationPointOrActor(m_minigameMoveToLoc, none))
    {
        m_minigameResult = 3;        
    }
    else
    {
        J0x7F:

        // End:0xA6 [Loop If]
        if(!IsPositioningFinished() || !m_bFinishedCloseTheGapToMinigameAnim)
        {
            Sleep(0.0500000);
            // [Loop Continue]
            goto J0x7F;
        }
    }
    PopState();
    stop;            
}

state HitAndRunMinigameEntry
{
    function StartHitAndRunMinigameEntry()
    {
        local SPMiniGameManager MGManager;

        MGManager = Class'SPMiniGameManager'.static.Get();
        MGManager.BeginMiniGameDodge(1.0333000, 0, MinigameCounter, MinigameFail, MinigameDodge);
        //return;        
    }

    function AnticipationFinished()
    {
        PopState();
        //return;        
    }

    function MinigameDodge(float fTime, int Data)
    {
        // End:0x18
        if(int(m_minigameResult) == int(0))
        {
            m_minigameResult = 1;
        }
        //return;        
    }

    function MinigameCounter(float fTime, int Data)
    {
        // End:0x18
        if(int(m_minigameResult) == int(0))
        {
            m_minigameResult = 2;
        }
        //return;        
    }

    function MinigameFail(float fTime, int Data)
    {
        // End:0x18
        if(int(m_minigameResult) == int(0))
        {
            m_minigameResult = 4;
        }
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }
Begin:

    StartHitAndRunMinigameEntry();
    SetMinigameAnim(0, 0);
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).SetMinigameAnim(0, 0);
    stop;                    
}

state HitAndRunMinigameWaitForFail
{
    event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
    {
        return true;
        //return ReturnValue;        
    }

    function ReactionFinished()
    {
        PopState();
        //return;        
    }
Begin:

    SetMinigameAnim(3, 3);
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).SetMinigameAnim(3, 3);
    stop;            
}

state HitAndRunMinigameWaitForDodge
{
    function ReactionFinished()
    {
        PopState();
        //return;        
    }
Begin:

    SetMinigameAnim(3, 1);
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).SetMinigameAnim(3, 1);
    stop;            
}

state HitAndRunMinigameWaitForCounter
{
    function ReactionFinished()
    {
        PopState();
        //return;        
    }
Begin:

    Pawn.TakeDamageAndProcEffects(50.0000000, m_hitAndRunMinigameTarget.Controller, Pawn.Location, Vector(m_hitAndRunMinigameTarget.Rotation), Class'SPDamageTypeMeleeAny');
    SetMinigameAnim(3, 2);
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).SetMinigameAnim(3, 2);
    stop;                
}

state HitAndRunMinigameChain
{
    function StartHitAndRunMinigameChain()
    {
        local SPMiniGameManager MGManager;

        MGManager = Class'SPMiniGameManager'.static.Get();
        MGManager.BeginMiniGame(1.0333000, 0, MinigameCounter, MinigameFail);
        //return;        
    }

    function AnticipationFinished()
    {
        PopState();
        //return;        
    }

    function MinigameCounter(float fTime, int Data)
    {
        // End:0x18
        if(int(m_minigameResult) == int(0))
        {
            m_minigameResult = 2;
        }
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }
Begin:

    StartHitAndRunMinigameChain();
    SetMinigameAnim(1, 0);
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).SetMinigameAnim(1, 0);
    stop;                    
}

state HitAndRunMinigameFinish
{
    function StartHitAndRunMinigameFinish()
    {
        local SPMiniGameManager MGManager;

        MGManager = Class'SPMiniGameManager'.static.Get();
        MGManager.BeginMiniGame(1.0333000, 0, MinigameCounter, MinigameFail);
        //return;        
    }

    function AnticipationFinished()
    {
        PopState();
        //return;        
    }

    function MinigameCounter(float fTime, int Data)
    {
        // End:0x18
        if(int(m_minigameResult) == int(0))
        {
            m_minigameResult = 2;
        }
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }
Begin:

    StartHitAndRunMinigameFinish();
    SetMinigameAnim(2, 0);
    PandoraPlayerController(m_hitAndRunMinigameTarget.Controller).SetMinigameAnim(2, 0);
    stop;                    
}

state MoveAwayHitAndRun extends WerewolfMoveToGoal
{
    function SetPathConstraints()
    {
        super(SPBaseWerewolfAIController).SetPathConstraints();
        //return;        
    }

    event ArrivedAtSubPathPoint(Actor subPathActor)
    {
        super(SPAIController).ArrivedAtSubPathPoint(subPathActor);
        //return;        
    }

    event bool UpdateFocus()
    {
        // End:0x1C
        if(int(Pawn.Physics) == int(1))
        {
            return false;
        }
        return BasicUpdateFocus();
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local SPPawn OtherPawn;

        OtherPawn = SPPawn(Other);
        // End:0x5D
        if((OtherPawn != none) && int(Physics) != int(8))
        {
            // End:0x5D
            if(IsValidEnemyPawn(OtherPawn, true))
            {
                SetEnemy(OtherPawn);
                GotoState('Melee');
                return false;
            }
        }
        return super(KyMoveToGoal).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }
    stop;    
}

state DoForcedThrow
{
    function BeginState(name PreviousStateName)
    {
        CanDoThrowObjectAttack();
        GotoState('ThrowObject');
        //return;        
    }
    stop;    
}

state Suspended
{
    function bool UpdateFocus()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

    Focus = none;
    stop;                    
}

state FinishedMiniGameDeathAnim
{
    event BeginState(name PreviousStateName)
    {
        Pawn.GotoState('Dying');
        //return;        
    }
    stop;    
}

state Frustrated
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    event ActionFinished()
    {
        m_WerewolfPawn.ClearAction();
        EvaluateSituation();
        //return;        
    }
Begin:

    // End:0x1D
    if(m_WerewolfPawn != none)
    {
        m_WerewolfPawn.SetActionState(61);
    }
    stop;            
}

state GrabbedByTentacle
{
    function EndState(name NextStateName)
    {
        // End:0x65
        if(m_WerewolfPawn != none)
        {
            m_WerewolfPawn.SetCollision(true, true);
            m_WerewolfPawn.SetMovementPhysics();
            m_WerewolfPawn.bCollideWorld = true;
            m_WerewolfPawn.SetActionState(0);
            m_WerewolfPawn.m_bIsAttachedToTentacle = false;
        }
        m_bAIDisabled = false;
        EvaluateSituation();
        //return;        
    }
Begin:

    // End:0x1D
    if(m_WerewolfPawn != none)
    {
        m_WerewolfPawn.SetActionState(64);
    }
    stop;            
}

state throwClub
{Begin:

    EvaluateSituation();
    stop;        
}

state RoamForEnemy
{
    function BeginState(name PreviousStateName)
    {
        m_roamPoint.X = 3.4000000 + float(38);
        m_roamPoint.Y = 3.4000000 + float(38);
        m_roamPoint.Z = 3.4000000 + float(38);
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        Cleanup();
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        UnclaimRoamingPoint();
        //return;        
    }

    function bool IsRoaming()
    {
        return true;
        //return ReturnValue;        
    }

    final function RoamToPoint(Vector pointToRoamTo)
    {
        SetMoveGoal(none, 1, pointToRoamTo, 2);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('RoamForEnemyMoveToGoal');
        //return;        
    }
RoamLoop:

    // End:0x3A
    if(FindRoamingPoint(false, m_WerewolfGDTuneData.MinimumDistanceToRoam, true, m_roamPoint))
    {
        RoamToPoint(m_roamPoint);
        UnclaimRoamingPoint();
        goto 'RoamLoop';
    }
    GotoState('Idle');
    stop;                
}

state RoamForEnemyMoveToGoal extends WerewolfMoveToGoal
{
    function SetTimers()
    {
        SetTimer(RandRange(0.7500000, 1.2500000), true, 'RoamForEnemyMoveToGoalUpdateTimer');
        super(KyMoveToGoal).SetTimers();
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('RoamForEnemyMoveToGoalUpdateTimer');
        super(KyMoveToGoal).ClearTimers();
        //return;        
    }

    function bool IsRoaming()
    {
        return true;
        //return ReturnValue;        
    }

    function RoamForEnemyMoveToGoalUpdateTimer()
    {
        // End:0x2E
        if((CheckForEnemy(true)) || HasValidEnemy())
        {
            EvaluateSituation();
        }
        // End:0x4B
        if(!IsDestinationAvailable(m_roamPoint))
        {
            AbortMove();
        }
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local SPPawn OtherPawn;

        OtherPawn = SPPawn(Other);
        // End:0x5F
        if((OtherPawn != none) && OtherPawn.Controller != none)
        {
            // End:0x5F
            if(!IsFriendly(OtherPawn.Controller))
            {
                AbortMove();
                return false;
            }
        }
        return super(KyMoveToGoal).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }
    stop;    
}
