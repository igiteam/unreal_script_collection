class SPPawn extends GamePawn
    native
    nativereplication
    config(Game);

enum EHitDeathState
{
    EHDS_NORMAL,                    // 0
    EHDS_HIT,                       // 1
    EHDS_FIREDEATH,                 // 2
    EHDS_DEATH,                     // 3
    EHDS_MAX                        // 4
};

enum SPEMovementType
{
    emtWerewolfStandRun,            // 0
    emtWerewolfCrounchRun,          // 1
    emtDefault,                     // 2
    emtWerewolfWallWalk,            // 3
    emtGriffonRun,                  // 4
    emtAttached,                    // 5
    emtWerewolfStandWalk,           // 6
    emtWerewolfCrouchWalk,          // 7
    emtFireDrakeQuadruped,          // 8
    emtFireDrakeRoll,               // 9
    emtFireDrakeWallWalk,           // 10
    emtGriffonFlight,               // 11
    emtWerewolfWallWalkNEW,         // 12
    emtBloodTickWallWalk,           // 13
    emtGriffonAnimBased,            // 14
    emtGriffonStalk,                // 15
    emtGriffonCharge,               // 16
    emtMinotaurCharge,              // 17
    emtSprint,                      // 18
    emtSprintBurst,                 // 19
    emtWalk,                        // 20
    SPEMovementType_MAX             // 21
};

enum EHSDamageValidationType
{
    edvtSwipe,                      // 0
    edvtBite,                       // 1
    edvtSuper,                      // 2
    edvtCloseGap,                   // 3
    edvtHitAndRun,                  // 4
    edvtMiniGame,                   // 5
    edvtGriffonHorn,                // 6
    edvtGriffonAirSwipe,            // 7
    edvtGriffonAttackPoint,         // 8
    edvtRam,                        // 9
    edvtNariClaw,                   // 10
    edvtNariSuper,                  // 11
    edvtScream,                     // 12
    edvtKrakenTentacleSmash,        // 13
    edvtFireDrakeImmolate,          // 14
    edvtFireDrakeFlameThrower,      // 15
    edvtNone,                       // 16
    EHSDamageValidationType_MAX     // 17
};

enum EHSDamageDirectionType
{
    eddtNone,                       // 0
    eddtUp,                         // 1
    eddtDown,                       // 2
    eddtZDontUse1,                  // 3
    eddtLeft,                       // 4
    eddtUpLeft,                     // 5
    eddtDownLeft,                   // 6
    eddtZDontUse2,                  // 7
    eddtRight,                      // 8
    eddtUpRight,                    // 9
    eddtDownRight,                  // 10
    EHSDamageDirectionType_MAX      // 11
};

enum eKnockDirection
{
    eKnockLeft,                     // 0
    eKnockRight,                    // 1
    eKnockForward,                  // 2
    eKnockDirection_MAX             // 3
};

enum SPECodeMovementType
{
    ecmtAnimationExtraction,        // 0
    ecmtCATAdjustment,              // 1
    ecmtRegisteredDestination,      // 2
    ecmtCATInterpolation,           // 3
    ecmtUnknown,                    // 4
    SPECodeMovementType_MAX         // 5
};

enum EEnemyRange
{
    EEnemyRangeNear,                // 0
    EEnemyRangeMedium,              // 1
    EEnemyRangeFar,                 // 2
    EEnemyRange_MAX                 // 3
};

enum ENetEdgeType
{
    ENetEdgeType_Invalid,           // 0
    ENetEdgeType_Single,            // 1
    ENetEdgeType_Start,             // 2
    ENetEdgeType_Intermediate,      // 3
    ENetEdgeType_Finish,            // 4
    ENetEdgeType_Exact,             // 5
    ENetEdgeType_MAX                // 6
};

enum SPFG_Mode
{
    SPFG_PathFollow,                // 0
    SPFG_HoldPosition,              // 1
    SPFG_MAX                        // 2
};

struct native PathEdge
{
    var private int VertexData;
    var SPPawn.ENetEdgeType Type;
    var private byte AnimCompletionPercentage;
    var byte AnimConnectionIndex;
    var private Rotator StartRotation;

    structdefaultproperties
    {
        VertexData=0
        Type=ENetEdgeType_Invalid
        AnimCompletionPercentage=0
        AnimConnectionIndex=0
        StartRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native MovementTypeStruct
{
    var float AccelRate;
    var float GroundSpeed;
    var SPPawn.SPEMovementType movementType;
    var int animTreeIndex;
    var Actor.EPhysics physicsToUse;
    var float BlendTime;

    structdefaultproperties
    {
        AccelRate=2048.0000000
        GroundSpeed=0.0000000
        movementType=emtWerewolfStandRun
        animTreeIndex=0
        physicsToUse=PHYS_None
        BlendTime=0.0000000
    }
};

struct native HitLocationGrouping
{
    var name GroupName;
    var const array<name> BoneNames;

    structdefaultproperties
    {
        GroupName="None"
        BoneNames=none
    }
};

struct native PawnAttackDamageZone
{
    var name SocketName;
    var float CylinderRadius;
    var float cylinderHalfHeight;
    var bool bUseDOT;
    var float Dot;
    var float Damage;
    var float maxDuration;
    var float ElapsedTime;
    var class<DamageType> DamageType;
    var name callBackEvent;
    var bool bActive;
    var bool bForceUpdate;

    structdefaultproperties
    {
        SocketName="None"
        CylinderRadius=0.0000000
        cylinderHalfHeight=0.0000000
        bUseDOT=false
        Dot=0.0000000
        Damage=0.0000000
        maxDuration=0.0000000
        ElapsedTime=0.0000000
        DamageType=none
        callBackEvent="None"
        bActive=false
        bForceUpdate=false
    }
};

struct native DamageZoneCallbackParams
{
    var Actor HitActor;

    structdefaultproperties
    {
        HitActor=none
    }
};

struct native transient TakeDamageParamInfo
{
    var init float Damage;
    var init Controller instigatedBy;
    var init Vector HitLocation;
    var init Vector Momentum;
    var init class<DamageType> DamageType;
    var init TraceHitInfo HitInfo;
    var init Actor DamageCauser;

    structdefaultproperties
    {
        Damage=0.0000000
        instigatedBy=none
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
        HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none)
        DamageCauser=none
    }
};

struct native WallAnimChannelData
{
    var bool bReset;
    var name MCBName;

    structdefaultproperties
    {
        bReset=false
        MCBName="None"
    }
};

struct native TransitionInfo
{
    var SPAWallTransition transition;
    var name transitionAnimName;
    var Vector moveToLocation;
    var Rotator moveToRotation;

    structdefaultproperties
    {
        transition=none
        transitionAnimName="None"
        moveToLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        moveToRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native WallTransitionData
{
    var bool bTransitionRequired;
    var array<TransitionInfo> TransitionList;
    var int currentTransition;

    structdefaultproperties
    {
        bTransitionRequired=false
        TransitionList=none
        currentTransition=0
    }
};

struct native WallMovementData
{
    var SPWallAnimationReachSpec ReachSpec;
    var ReachSpec nextSpec;
    var int connectionIndex;
    var bool bIsSingleAnim;
    var SPAWallAnimation wallAnimData;
    var Vector moveToLocation;
    var Rotator moveToRotation;
    var WallTransitionData TransitionData;
    var bool bExecutingTransition;
    var bool bDoingMove;

    structdefaultproperties
    {
        ReachSpec=none
        nextSpec=none
        connectionIndex=0
        bIsSingleAnim=false
        wallAnimData=none
        moveToLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        moveToRotation=(Pitch=0,Yaw=0,Roll=0)
        TransitionData=(bTransitionRequired=false,TransitionList=none,currentTransition=0)
        bExecutingTransition=false
        bDoingMove=false
    }
};

struct native WallMovmementSearchData
{
    var int connectionIndex;
    var SPAWallAnimation wallAnimData;
    var WallTransitionData TransitionData;
    var float requiredAngleChange;

    structdefaultproperties
    {
        connectionIndex=0
        wallAnimData=none
        TransitionData=(bTransitionRequired=false,TransitionList=none,currentTransition=0)
        requiredAngleChange=0.0000000
    }
};

struct native SPFG_TargetAttribute
{
    var bool m_bValid;

    structdefaultproperties
    {
        m_bValid=false
    }
};

struct native SPFG_MaxSpeedAttribute extends SPFG_TargetAttribute
{
    var float m_speed;
};

struct native SPFG_PathSegmentAttribute extends SPFG_TargetAttribute
{
    var Vector m_pathSegment[2];
};

struct native SPFG_LookAheadAttribute extends SPFG_TargetAttribute
{
    var Vector m_lookAheadPoint;
    var Vector m_lookAheadDirection;
};

struct native SPFG_DistBasedTargetAttribute extends SPFG_TargetAttribute
{
    var float m_remainingDistance;
};

struct native SPFG_SpeedAttriute extends SPFG_DistBasedTargetAttribute
{
    var float m_desiredSpeed;
};

struct native SPFG_OrientationAttriute extends SPFG_DistBasedTargetAttribute
{
    var Quat m_desiredOrientation;
};

struct native SPFG_Target
{
    var SPPawn.SPFG_Mode m_mode;
    var SPFG_SpeedAttriute m_speedAttrib;
    var SPFG_MaxSpeedAttribute m_maxSpeedAttrib;
    var SPFG_OrientationAttriute m_orientationAttrib;
    var SPFG_PathSegmentAttribute m_pathAttrib;
    var SPFG_LookAheadAttribute m_lookAheadAttrib;
    var float m_maxDeviation;
    var float m_deviationAlpha;

    structdefaultproperties
    {
        m_mode=SPFG_PathFollow
        m_speedAttrib=(m_desiredSpeed=0.0000000,m_remainingDistance=0.0000000,m_bValid=false)
        m_maxSpeedAttrib=(m_speed=0.0000000,m_bValid=false)
        m_orientationAttrib=(m_desiredOrientation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000),m_remainingDistance=0.0000000,m_bValid=false)
        m_pathAttrib=(m_pathSegment=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_pathSegment[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_bValid=false)
        m_lookAheadAttrib=(m_lookAheadPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_lookAheadDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_bValid=false)
        m_maxDeviation=0.0000000
        m_deviationAlpha=0.0000000
    }
};

struct native SPFG_CurrentStatus
{
    var Vector m_pathOffsetDirection;
    var float m_minDistFromPath;
    var Vector m_onPathPos;
    var Vector m_onPathDirection;
    var float m_pathDistToGoal;
    var float m_pathTimeToGoal;

    structdefaultproperties
    {
        m_pathOffsetDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_minDistFromPath=0.0000000
        m_onPathPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_onPathDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pathDistToGoal=0.0000000
        m_pathTimeToGoal=0.0000000
    }
};

struct native SPFlightGuidance
{
    var bool m_isCurrent;
    var SPFG_Target m_target;
    var SPFG_CurrentStatus m_status;

    structdefaultproperties
    {
        m_isCurrent=false
        m_target=(m_mode=SPFG_PathFollow,m_speedAttrib=(m_desiredSpeed=0.0000000,m_remainingDistance=0.0000000,m_bValid=false),m_maxSpeedAttrib=(m_speed=0.0000000,m_bValid=false),m_orientationAttrib=(m_desiredOrientation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000),m_remainingDistance=0.0000000,m_bValid=false),m_pathAttrib=(m_pathSegment=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_pathSegment[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_bValid=false),m_lookAheadAttrib=(m_lookAheadPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_lookAheadDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_bValid=false),m_maxDeviation=0.0000000,m_deviationAlpha=0.0000000)
        m_status=(m_pathOffsetDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_minDistFromPath=0.0000000,m_onPathPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_onPathDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_pathDistToGoal=0.0000000,m_pathTimeToGoal=0.0000000)
    }
};

struct native AIPhysicsDamageGroup
{
    /** *** END OF FLIGHT GUIDANCE (SPFG) STRUCTS */
    var() float MinDamage;
    /** *** END OF FLIGHT GUIDANCE (SPFG) STRUCTS */
    var() float MaxDamage;

    structdefaultproperties
    {
        MinDamage=0.0000000
        MaxDamage=0.0000000
    }
};

struct native CATAnimInfo
{
    var name attackAnimationName;
    var Vector attackerMoveOffset;
    var float attackerYawOffset;
    var name defenseAnimationName;
    var Vector defenderMoveOffset;
    var float defenderYawOffset;
    var SPACATAnimation AnimInfo;
    var SPCATDefenseProperty DefenseProperty;
    var bool bUseExactPositioning;

    structdefaultproperties
    {
        attackAnimationName="None"
        attackerMoveOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        attackerYawOffset=0.0000000
        defenseAnimationName="None"
        defenderMoveOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        defenderYawOffset=0.0000000
        AnimInfo=none
        DefenseProperty=none
        bUseExactPositioning=false
    }
};

struct native SPAimingMissParams
{
    var float Min;
    var float Max;
    var float Height;

    structdefaultproperties
    {
        Min=32.0000000
        Max=100.0000000
        Height=64.0000000
    }
};

struct native SPAimingParams
{
    var float Distance;
    var float percentageOnTargetShots;
    var SPAimingMissParams miss;

    structdefaultproperties
    {
        Distance=1000.0000000
        percentageOnTargetShots=50.0000000
        miss=(Min=32.0000000,Max=100.0000000,Height=64.0000000)
    }
};

struct native SPClosestNeighborhoodVertexCache
{
    var float CacheTime;
    var Vector Location;
    var bool bUsedWallCheck;
    var int VertexID;

    structdefaultproperties
    {
        CacheTime=0.0000000
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bUsedWallCheck=false
        VertexID=0
    }
};

struct native PawnPassThroughEntry
{
    var class<Pawn> PassThroughType;
    var float Duration;

    structdefaultproperties
    {
        PassThroughType=none
        Duration=0.0000000
    }
};

var repnotify bool m_bWeaponFiring;
/** Specifies whether AI should be disabled at start Targetting */
var(AI) bool bDisableAIOnStart;
var(AI) bool bTargettable;
/** Specifies whether AI should be set not to take damage on start */
var(AI) bool bDisableTakeDamageOnStart;
var bool destructCollisionLog;
var bool m_bEnablePhysicsPushing;
var transient bool m_bLogEnabled;
var bool m_bResetTurnAnim;
var bool m_bCanSpider;
var bool bHasNovodexBoundingVolume;
var bool bNoWallEndAnchor;
var bool bInAir;
var bool bDodging;
/** vareDoubleClickDir CurrentDir; ** DEBUG ** */
var(Debug) bool bLogUnassignedMaterials;
var bool bImmobile;
var bool bRegisterLocation;
var bool bRegisterOrientation;
var bool bRegistrationUsingPointToFace;
var bool bUsingAnimationRegistration;
var bool bRegistrationAdjustPlaybackRate;
var bool bRegistrationUseCollision;
var transient bool SPTurnIsTurning;
var transient bool SPTurnIsWalking;
var transient bool SPTurnDontApplyPhysics;
var transient bool SPPhysicsFlag;
var bool m_bIsCurrentPoseRotationallyInvariant;
var bool m_bArrivedAtWallDestination;
var bool m_kynapseRelay_bArrivedAtWallDestination;
var bool m_kynapseRelay_bAllowNextWallMove;
var bool m_kynapseRelay_bFinishedAnimBasedMove;
var(AI) transient bool m_isDebugTurnOn;
var bool bPreventPhysRotation;
var bool m_bResetDeathFromSiphon;
var bool m_bThrowDeath;
var bool m_bFireAxeSuperAttack;
var transient bool bAnimTrackInitialized;
var bool m_bCompletedRandomPath;
var bool m_bUseRandomPaths;
var bool m_bCurveTargetPath;
var bool m_bHasTakenFlameDamage;
var bool m_bIsAttachedToTentacle;
var bool m_bAllowAIToPassThroughInRagdoll;
var bool m_bDiedWhileSpidering;
var bool m_AllowFadeOnDeath;
var bool m_bFadeMaterialsInitialized;
var bool m_bStartDissolve;
var bool bCATAnimationInProgress;
var bool bCATAnimationDisabled;
var transient bool m_bDoingClientExactMove;
var transient bool m_bIgnoreServerMoves;
var transient bool m_bClientSingleEdge;
var transient bool m_bWaitingForPhysWalking;
var transient bool m_bNextEdgeIsAnimBased;
/** Turns on/off the new extracted translation for physwalking: Uses velocity instead of translation if true. */
var(NewTranslation) transient bool m_bExtractVelocityFromAnimationInPhysWalking;
var bool m_bDestroyDestructibleBase;
var bool m_bCanTakeFallingDamage;
var bool m_bAllowPawnPassThrough;
var bool bEnableAnimusHitReaction;
var bool bHitByAnimusPulse;
var bool bAPRRampUp;
/** Holds the class type of the current weapon attachment.  Replicated to all clients. */
var(WeaponReplication) private repnotify class<SPWeaponAttachment> CurrentWeaponAttachmentClass;
/** This holds the local copy of the current attachment.  This "attachment" actor will exist on all versions of the client. */
var(WeaponReplication) SPWeaponAttachment CurrentWeaponAttachment;
var export editinline SPHeadTrackComponent HeadTrackComponent;
var float FootstepTraceDistance;
var PandoraSPGameInfo.ESPSinglePlayerTeam TeamAssignment;
var PandoraGameInfo.ESPMultiplayerTeam MultiplayerTeamAssignment;
var SPPawn.EHitDeathState m_hitDeathState;
var SPPawn.SPECodeMovementType m_codeMovementType;
var Object.EPhysAnimState m_PhysAnimState;
var SPEquippedWeaponNode.SPWeaponType m_deathWeapon;
var SPPawn.EEnemyRange m_deathEnemyRange;
var SPKynapseLevelData.AITypes m_eAIType;
var transient Actor.EPhysics PrevPhysics;
var int m_currentMovementTypeIndex;
var array<MovementTypeStruct> m_movementTypeInfo;
/** Default inventory added via AddDefaultInventory() // Special Anim sets... */
var() /*0x80000000-0x00000000*/ array< class<Inventory> > DefaultInventory;
/** Array for Special specific animsets //var editinline export array<HitLocationGrouping>m_hitLocationGroupings; */
var() array<AnimSet> SpecialAnimSets;
var export editinline array<export editinline HitLocationGrouping> m_hitLocationGroupings;
var RigidBodyDamagerInfo m_rigidBodyDamagerInfo;
var float m_physicsPushingUpdateInterval;
var float m_physicsPushingLastUpdateAccrue;
var float m_physicsPushingHorizontalAdjustment;
var float m_physicsPushingVerticalAdjustment;
var Vector m_physicsPushingCenterOffset;
var() float m_minPhysicsPushingStrength;
var() float m_maxPhysicsPushingStrength;
/** scale applied to pushing strength (bigger things should have bigger force) */
var() float m_physicsPushingStrengthScale;
var array<PawnAttackDamageZone> m_damageZones;
var int m_DOTDuration;
var int m_DOTDamage;
var Controller m_DOTInstigator;
var class<PandoraDamageType> m_DOTDamageType;
/** Defend Area */
var(AI) float AttackDistWhileDefendingArea;
var float m_animTurnAmount;
var(DestructComponent) const editconst export editinline SPActorDestructComponent DestructComponent;
var transient TakeDamageParamInfo DeathParams;
var export editinline SPNavigationComponent NavigationComponent;
var const RB_BodyInstance m_boundingVolumeBodyInstance;
var array<ImpactDamageRecord> m_impactDamageArray;
var Actor m_OATSBase;
var float DodgeSpeed;
var float DodgeSpeedZ;
var float ActorOriginHeight;
var array<SPPawn> m_hostiles;
var private const export editinline array<export editinline SPExtendedCollisionComponent> ExtendedCollision;
var Vector RegistrationLocation;
var Quat RegistrationOrientation;
var Vector RegistrationPointToFace;
var float RegistrationStartTime;
var float RegistrationEndTime;
var SPAnimNodeSequence RegistrationAnimNode;
var float LastRegistrationTime;
var float RegistrationShrunkenDistanceRateBias;
var float RegistrationExpandedDistanceRateBias;
var float PawnCorpseLifetime;
var transient int SPTurnNodeIndex;
var transient SPTurnNode SPTurnNodeDoingTurn;
/** Amount of base weight a werewolf equates to this type of enemy */
var(TargetingValue) float WerewolfBaseWeight;
/** If non-zero this weight overrides all other weighting during evaluation used for path building to determine what % of the normal collision height should be used for wall walking */
var(TargetingValue) float WerewolfOverrideWeight;
var float WallCollisionHeightScale;
var float WallCollisionRadiusFullScale;
var float WallCollisionRadiusHalfScale;
var float WallCollisionRadiusSmallScale;
var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var WallMovementData m_wallMovementData;
var SPAnimNodeSequence m_wallRegistrationNode;
var name m_currentWallPose;
var int FavorWallPercentage;
var int m_wallPathMaxTurnAngleToIgnore;
var float m_wallRotationRateDegrees;
var int m_kynapseRelay_vertexID;
/** In degrees per second */
var() transient float m_debugTurnTurnRate;
var() transient float m_debugTurnMoveSpeed;
var transient Rotator m_rotationRate;
var name m_sDefaultBoneName;
var float m_DeathThrowImpulse;
var Vector m_DeathThrowDirection;
var class<SPLifeForceHolder> m_lifeForceHolderClass;
var float m_AnimationSynchronizationTime;
var SPRenderTargetProxy CurRTProxy;
var TextureRenderTarget2D RTTargetSrc;
var export editinline SkeletalMeshComponent CurSkelMeshComponent;
var MaterialInterface mtlTestMtlInstance;
var Material mtlTestMtl;
var Texture2D m_ImpactMask;
var export editinline AudioComponent FacialAudioComp;
var SPPhysicalMaterial DefPhysMaterial;
var Vector PreExtractedAnimationLocation;
var Rotator PreExtractedAnimationRotation;
var Vector m_VCurvedPathLocation;
var float m_localVelocityAngle;
var float m_hitDirectionAngle;
var class<DamageType> m_deathDamageType;
var float m_deathDistFromImpact;
var float m_lastDistFromImpact;
var Vector m_amortizedVelocity;
var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;
var SPTuneDataPawn m_PawnTuneData;
var SPGameDifficultyTune m_GDData;
var name m_OldStateName;
var array<MaterialInstanceConstant> m_FadeMIC;
var float m_fFadePercent;
/** A string that can be designer defined and superimposed over the object during run-time CAT System (Choreographed Attack Tech) */
var() string DebugTag;
var SPCATBaseStateInfo CATStateInfo;
var CATAnimInfo CATAnimationInfo;
var Vector CATAccumulatedExtractedTranslation;
var Vector CATDefendingOffset;
var float CATDefendingYawOffset;
var Vector CATAttackingLocation;
var Rotator CATAttackingOrientation;
var SPPawn CATAttackerPawn;
var SPPawn CATDefenderPawn;
var float CATInterpolationTimeLeft;
var float DeathAnimationPhysicsStartTime;
var float DeathAnimationPhysicsStartRampingTime;
var float DeathAnimationPhysicsFinishRampingTime;
var float DeathAnimationPhysicsHoldPercentage;
var name m_deathEnemyType;
var(AI) SPAimingParams AimMinRange;
var(AI) SPAimingParams AimMaxRange;
var transient Vector LastProjectileFireLocation;
var transient Rotator LastProjectileFireRot;
var transient array<PathEdge> m_pathEdges;
var repnotify transient PathEdge m_lastEdgeSent;
var transient Vector m_ClientPreciseDestination;
var transient Vector m_ExtractedVelocity;
var array<MaterialInstanceConstant> MtlInstances;
var SPClosestNeighborhoodVertexCache m_ClosestNeighborhoodVertexCache[8];
var SkeletalMesh m_DismemberedSkeletalMesh;
var array<name> m_boneNamesToTestAgainstExplosions;
var Vector m_nextEdgeEndLoc;
var int HitsPerSec;
var int ShotsPerSec;
var float ClientExactModeTimeout;
var transient Vector m_fallStartLocation;
var transient array<PawnPassThroughEntry> m_pawnPassThroughList;
var SPRandomPedProfile DefaultPedProfile;
var class<SPRTPDamageMaskPersistent> SPRTPDamageMaskClass;
var array<MaterialInterface> AnimusReactionMat;
var array<MaterialInstanceConstant> AnimusReactionMatInst;
var array<MaterialInterface> OriginalMat;
var array<MaterialInstanceConstant> OriginalMatInst;
var float AnimusPulseReactionDuration;
var float APRRampdownDuration;
var float APRBrightness;
var float APRPulseTime;
var array<Controller> ControllersThatThinkIAmAnEnemy;
var class<DamageType> LastDamageRecievedType;
var FootStepParticleInfo DefaultFootstepParticles;
var init transient array<init TakeDamageParamInfo> m_collectedDamage;
var transient int PrevMovementTypeIndex;
var transient Rotator NewRotation;
var transient Vector NewLocation;

replication
{
    // Pos:0x000
    if(bNetDirty
        CurrentWeaponAttachmentClass;

    // Pos:0x006
    if(bNetInitial
        m_bWeaponFiring;

    // Pos:0x00C
    if(!bNetOwner && bReplicateMovement
        m_currentMovementTypeIndex;

    // Pos:0x01F
    if(bNetInitial && !bReplicateMovement
        m_lastEdgeSent;
}

event int GetMaxSimultaneousEnemies()
{
    return 1000;
    //return ReturnValue;    
}

// Export USPPawn::execUpdateControllersThatThinkIAmAnEnemy(FFrame&, void* const)
native final function UpdateControllersThatThinkIAmAnEnemy();

// Export USPPawn::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

// Export USPPawn::execSetAIAnimControl(FFrame&, void* const)
native function SetAIAnimControl(bool B);

// Export USPPawn::execGetAIAnimControl(FFrame&, void* const)
native function bool GetAIAnimControl();

// Export USPPawn::execAddSpecialAnimationSets(FFrame&, void* const)
native function bool AddSpecialAnimationSets();

// Export USPPawn::execAddAnimationSets(FFrame&, void* const)
native final function bool AddAnimationSets(array<AnimSet> animSetsToAdd, optional bool bPreventPropagationOfAnimSetToMeshSavedList);

// Export USPPawn::execRemoveAnimationSets(FFrame&, void* const)
native final function bool RemoveAnimationSets(array<AnimSet> animSetsToRemove, optional bool bPreventPropagationOfAnimSetToMeshSavedList);

// Export USPPawn::execTeleportOrient(FFrame&, void* const)
native function bool TeleportOrient(Vector pos, Vector Rot);

// Export USPPawn::execIndividualSceneAnimFinished(FFrame&, void* const)
native function IndividualSceneAnimFinished(SeqAct_Latent Action, bool bAnimFinished);

// Export USPPawn::execReachedDestinationPointOrActor(FFrame&, void* const)
native function bool ReachedDestinationPointOrActor(Vector Loc, Actor GoalActor);

// Export USPPawn::execAttachObjectToMe(FFrame&, void* const)
native final function AttachObjectToMe(Actor Target, name SocketName, bool useCurrentLocation, bool useCurrentRotation);

// Export USPPawn::execDettachObjectFromMe(FFrame&, void* const)
native final function DettachObjectFromMe(Actor Target);

// Export USPPawn::execInitHitLocationGroupings(FFrame&, void* const)
native final function InitHitLocationGroupings();

// Export USPPawn::execFindHitLocationGroupingByBoneName(FFrame&, void* const)
native final function bool FindHitLocationGroupingByBoneName(name BoneName, out int groupNumber);

// Export USPPawn::execSPAILog(FFrame&, void* const)
native final function SPAILog(name logCategory, string LogText);

// Export USPPawn::execUpdatePushingPhysics(FFrame&, void* const)
native final function UpdatePushingPhysics();

// Export USPPawn::execUpdateDamageZones(FFrame&, void* const)
native final function UpdateDamageZones(float DeltaTime);

// Export USPPawn::execIsDamageZoneActive(FFrame&, void* const)
native final function bool IsDamageZoneActive(int zone);

// Export USPPawn::execNotifyFactoryOfDeath(FFrame&, void* const)
native final function NotifyFactoryOfDeath();

// Export USPPawn::execIsLogEnabled(FFrame&, void* const)
native function bool IsLogEnabled();

// Export USPPawn::execEnableNovadexCallbackOnPhysicsAsset(FFrame&, void* const)
native final function EnableNovadexCallbackOnPhysicsAsset(bool bEnable);

// Export USPPawn::execEnableNovodexBoundingVolume(FFrame&, void* const)
native final function EnableNovodexBoundingVolume(bool bEnable);

// Export USPPawn::execUpdateNovodexBoundingVolume(FFrame&, void* const)
native final function UpdateNovodexBoundingVolume(float DeltaTime);

// Export USPPawn::execSetNovodexCollisionVolumeCollisionWith(FFrame&, void* const)
native final function SetNovodexCollisionVolumeCollisionWith(SkeletalMeshComponent meshToIgnore, bool noCollide);

// Export USPPawn::execLookAtConsoleEnabled(FFrame&, void* const)
native final function bool LookAtConsoleEnabled();

// Export USPPawn::execShowingLookAt(FFrame&, void* const)
native final function bool ShowingLookAt();

// Export USPPawn::execGetAdjustedHeadLookAtPos(FFrame&, void* const)
native final function Vector GetAdjustedHeadLookAtPos(const out Vector lookAtPos);

// Export USPPawn::execGenericSocketNameToBoneName(FFrame&, void* const)
native static function name GenericSocketNameToBoneName(SkeletalMeshComponent SkelMesh, name SName);

// Export USPPawn::execRegisterDestination(FFrame&, void* const)
native final function bool RegisterDestination(SPAnimNodeSequence theNode, const out Vector finalLocation, float StartTime, float endTime, bool bUseCollision, bool bAdjustPlaybackRate, float shrunkenDistanceRateBias, float expandedDistanceRateBias);

// Export USPPawn::execRegisterOrientation(FFrame&, void* const)
native final function bool RegisterOrientation(SPAnimNodeSequence theNode, const out Rotator finalRotation, float StartTime, float endTime, bool bUseCollision, bool bAdjustPlaybackRate);

// Export USPPawn::execRegisterOrientationToPoint(FFrame&, void* const)
native final function bool RegisterOrientationToPoint(SPAnimNodeSequence theNode, const out Vector pointToFace, float StartTime, float endTime, bool bAdjustPlaybackRate, bool bUseCollision);

// Export USPPawn::execRegisterDestinationAndOrientation(FFrame&, void* const)
native final function bool RegisterDestinationAndOrientation(SPAnimNodeSequence theNode, const Vector finalLocation, const Rotator finalRotation, float StartTime, float endTime, bool bUseCollision, bool bAdjustPlaybackRate, float shrunkenDistanceRateBias, float expandedDistanceRateBias);

// Export USPPawn::execCancelDestinationRegistration(FFrame&, void* const)
native final function bool CancelDestinationRegistration();

// Export USPPawn::execSPTurnFinished(FFrame&, void* const)
native final function SPTurnFinished();

// Export USPPawn::execSPRunningTurnStarting(FFrame&, void* const)
native final function SPRunningTurnStarting();

// Export USPPawn::execSPRunningTurnFinished(FFrame&, void* const)
native final function SPRunningTurnFinished();

// Export USPPawn::execSPDisablePhysicsDuringTurn(FFrame&, void* const)
native final function SPDisablePhysicsDuringTurn();

// Export USPPawn::execSPEnablePhysicsDuringTurn(FFrame&, void* const)
native final function SPEnablePhysicsDuringTurn();

// Export USPPawn::execSPWalkFinished(FFrame&, void* const)
native function SPWalkFinished();

// Export USPPawn::execCanChangeSpeed(FFrame&, void* const)
native function bool CanChangeSpeed();

// Export USPPawn::execSPManuallyCheckForScriptedTurnRadius(FFrame&, void* const)
native final function bool SPManuallyCheckForScriptedTurnRadius();

// Export USPPawn::execBreakpoint(FFrame&, void* const)
native function Breakpoint();

// Export USPPawn::execSPRegisterOrientation(FFrame&, void* const)
native function SPRegisterOrientation(SPAnimNodeSequence theNode, const out Rotator finalRotation, float StartTime, float endTime, bool bAdjustPlaybackRate, const out Vector pointToFace);

// Export USPPawn::execGetDefaultBoneName(FFrame&, void* const)
native function name GetDefaultBoneName();

// Export USPPawn::execForceComponentsToUpdate(FFrame&, void* const)
native final function ForceComponentsToUpdate(optional bool bCollUpdate = false, optional bool bTranformOnly = true);

// Export USPPawn::execGetClosestVertexWithNeighborhoodData(FFrame&, void* const)
native final function int GetClosestVertexWithNeighborhoodData(Actor targetActor, const out Vector TargetLocation, bool bWallCheck);

// Export USPPawn::execClearClosestVertexWithNeighborhoodDataCache(FFrame&, void* const)
native final function ClearClosestVertexWithNeighborhoodDataCache();

// Export USPPawn::execInitPhysicsAssetInstance(FFrame&, void* const)
native final function InitPhysicsAssetInstance(bool bOn);

// Export USPPawn::execTriLookup(FFrame&, void* const)
native final function MaterialInterface TriLookup(const Vector vStart, const Vector vEnd, out float U, out float V, out float UVSizeRatio);

// Export USPPawn::execAddDamageMaskImpact(FFrame&, void* const)
native function AddDamageMaskImpact(SPRenderTargetProxy proxy, float U, float V, float UVSizeRatio);

// Export USPPawn::execCalculateDistanceToGround(FFrame&, void* const)
native final function float CalculateDistanceToGround(optional float maxDist, optional Vector offsetFromLocation, optional int bOffsetIsLocal);

// Export USPPawn::execCalcTrajInitVelGivenAngle(FFrame&, void* const)
native final function bool CalcTrajInitVelGivenAngle(const out Vector launchPos, const out Vector targetPos, float gravity, float Angle, out Vector initVel, out float T);

// Export USPPawn::execCalcTrajInitVelGivenSpeed(FFrame&, void* const)
native final function int CalcTrajInitVelGivenSpeed(const out Vector launchPos, const out Vector targetPos, float gravity, float Speed, out Vector initVel1, out float T1, out Vector initVel2, out float T2);

// Export USPPawn::execCalcTrajInitVelGivenSpeedMoving(FFrame&, void* const)
native final function int CalcTrajInitVelGivenSpeedMoving(const out Vector launchPos, const out Vector targetPos, const out Vector targetVel, float gravity, float Speed, int iterations, out Vector initVel, out float T);

// Export USPPawn::execCalcVelocityToHitMovingTarget(FFrame&, void* const)
native final function bool CalcVelocityToHitMovingTarget(const out Vector launchPos, const out Vector targetPos, const out Vector targetVel, float gravity, int adjustedRotatorPitch, out Vector initVel, out float T);

// Export USPPawn::execAddSuppressionToPawns(FFrame&, void* const)
native final function AddSuppressionToPawns(const out Vector oldPos, const out Vector NewPos);

// Export USPPawn::execGetWallMovementData(FFrame&, void* const)
native final function bool GetWallMovementData(SPWallAnimationReachSpec theSpec, out WallMovementData movementData);

// Export USPPawn::execArrivedAtWallPathEnd(FFrame&, void* const)
native final function ArrivedAtWallPathEnd(bool bSnapLocationToPathEnd, bool bSnapOrientationToPathEnd);

// Export USPPawn::execCacheWallMovementInformation(FFrame&, void* const)
native final function CacheWallMovementInformation(SPWallAnimationReachSpec ReachSpec);

// Export USPPawn::execForceWallWalking(FFrame&, void* const)
native final function ForceWallWalking(SeqAct_ForceWallWalking Action);

// Export USPPawn::execComputeLocalVelocityAngle(FFrame&, void* const)
native final function float ComputeLocalVelocityAngle();

// Export USPPawn::execComputeLocalHitDirectionAngle(FFrame&, void* const)
native final function float ComputeLocalHitDirectionAngle(const out Vector bulletDirection, const out Vector HitLocation, Pawn attacker);

// Export USPPawn::execCATCheckForAttack(FFrame&, void* const)
native final function bool CATCheckForAttack(SPPawn defender, out CATAnimInfo AnimInfo);

// Export USPPawn::execCATCheckForSpecificAttack(FFrame&, void* const)
native final function bool CATCheckForSpecificAttack(SPPawn defender, name specificAnimName, bool bForceAttack, out CATAnimInfo AnimInfo);

// Export USPPawn::execGetWeaponAttachmentClass(FFrame&, void* const)
native final function class<SPWeaponAttachment> GetWeaponAttachmentClass();

// Export USPPawn::execGetBestKnockDirection(FFrame&, void* const)
native function SPPawn.eKnockDirection GetBestKnockDirection(Actor knockObject, out Vector knockVector);

// Export USPPawn::execPlayRemoteSound(FFrame&, void* const)
native final function PlayRemoteSound(SoundCue InSoundCue, optional Vector SoundLocation, optional bool bNoRepToOwner, optional bool bNoRepToRelevant, optional bool bStopWhenOwnerDestroyed);

// Export USPPawn::execGetCurrentWeaponStateGrenadeActionName(FFrame&, void* const)
native function name GetCurrentWeaponStateGrenadeActionName();

// Export USPPawn::execIsInRangeOfExplodingActor(FFrame&, void* const)
native function bool IsInRangeOfExplodingActor(Actor explodingActor, const out Vector Loc, float Radius);

// Export USPPawn::execHitTarget(FFrame&, void* const)
native final function HitTarget(Actor theTarget);

// Export USPPawn::execTraceForImpactInfo(FFrame&, void* const)
native function bool TraceForImpactInfo(const Vector traceEnd, const Vector traceStart, const out Vector Extent, out ImpactInfo theImpactInfo);

// Export USPPawn::execEnablePawnPassThrough(FFrame&, void* const)
native final function EnablePawnPassThrough(SPPawn bumpedPawn, float Duration, optional bool bMirror = true);

// Export USPPawn::execGetSocketInformation(FFrame&, void* const)
native static function bool GetSocketInformation(Actor NewParent, name SocketName, out SkeletalMeshComponent SkelMesh, out name BoneName, out Vector NewLoc, out Rotator NewRot);

// Export USPPawn::execHandleDebugOptimizations(FFrame&, void* const)
native function HandleDebugOptimizations();

// Export USPPawn::execSetSimulateGravity(FFrame&, void* const)
native function SetSimulateGravity(bool turnOn);

// Export USPPawn::execSetupAnimusPulseEffect(FFrame&, void* const)
native function SetupAnimusPulseEffect();

// Export USPPawn::execHitByAnimusPulse(FFrame&, void* const)
native final function HitByAnimusPulse();

// Export USPPawn::execUpdateAnimusPulseEffect(FFrame&, void* const)
native final function UpdateAnimusPulseEffect(float DeltaTime);

// Export USPPawn::execIsReloading(FFrame&, void* const)
native final function bool IsReloading();

event class<DamageType> GetSmashDamageType()
{
    return Class'SPDamageTypeMeleeAny';
    //return ReturnValue;    
}

function class<SPLifeForceHolder> GetLifeForceHolderClass()
{
    return m_lifeForceHolderClass;
    //return ReturnValue;    
}

event bool CanBeDefenderInCATAnimation(SPPawn attacker)
{
    // End:0x2F
    if(SPAIController(Controller) != none)
    {
        return SPAIController(Controller).CanBeDefenderInCATAnimation(attacker);
    }
    return false;
    //return ReturnValue;    
}

event PlayLocalSound(SoundCue Sound)
{
    // End:0x1A
    if((Sound == none) || !IsLocallyControlled())
    {
        return;
    }
    PlaySound(Sound, true, true,, Location, true);
    //return;    
}

event bool ShouldClearVelocityWhenClearingKynapse()
{
    return true;
    //return ReturnValue;    
}

event HitByDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    // End:0x41
    if(((ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse') && bEnableAnimusHitReaction) && !IsPendingKill()) && GetStateName() != 'Dying')
    {
        HitByAnimusPulse();
    }
    //return;    
}

function IsInsideDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    //return;    
}

function int SpecialCost(ReachSpec Path)
{
    //return ReturnValue;    
}

function PawnDeathDestructiblePropertyCheck()
{
    //return;    
}

event DamageZoneCallbackProto(DamageZoneCallbackParams Params)
{
    //return;    
}

event PrepareForLeapLand()
{
    //return;    
}

function FinishedMove(bool bMoveAborted)
{
    //return;    
}

function PostMoveTowardNotify()
{
    //return;    
}

function BeginningMoveToTarget()
{
    //return;    
}

function EndingMoveToTarget()
{
    //return;    
}

event AttackAnimFinished()
{
    //return;    
}

event MinigameInfo(SPAnimNotify_MinigameInfo Info)
{
    //return;    
}

event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
{
    return false;
    //return ReturnValue;    
}

event StopWallMovementAnimation()
{
    //return;    
}

// Export USPPawn::execCleanUpPhysSpider(FFrame&, void* const)
native final function CleanUpPhysSpider(bool bResetKynapseWallMovement);

simulated event NotifyThrowGrenade()
{
    //return;    
}

simulated event NotifyTakeOutGrenade()
{
    //return;    
}

// Export USPPawn::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc, optional bool bVisionCheck);

// Export USPPawn::execGetShotTargetOnBody(FFrame&, void* const)
native simulated function Vector GetShotTargetOnBody(optional Actor RequestedBy);

// Export USPPawn::execCanUsePhysAnimState_AnimIntoRagdoll(FFrame&, void* const)
native final function bool CanUsePhysAnimState_AnimIntoRagdoll();

// Export USPPawn::execPhysAnimSetAllBonesAIControl(FFrame&, void* const)
native final function PhysAnimSetAllBonesAIControl(bool bAIControlled, bool bAllowCurrentBlending);

// Export USPPawn::execPhysAnimSetNamedBonesAIControl(FFrame&, void* const)
native final function PhysAnimSetNamedBonesAIControl(array<name> BoneNames, bool bAIControlled, bool bAllowCurrentBlending);

// Export USPPawn::execAttemptPhysAnimState_Fixed(FFrame&, void* const)
native final function bool AttemptPhysAnimState_Fixed(optional bool bForceState);

// Export USPPawn::execAttemptPhysAnimState_Poking(FFrame&, void* const)
native final function bool AttemptPhysAnimState_Poking(Pawn instigatingPawn, optional bool bForceState);

// Export USPPawn::execAttemptPhysAnimState_AnimIntoRagdoll(FFrame&, void* const)
native final function bool AttemptPhysAnimState_AnimIntoRagdoll(optional bool bForceState);

// Export USPPawn::execAttemptPhysAnimState_Ragdoll(FFrame&, void* const)
native final function bool AttemptPhysAnimState_Ragdoll(optional bool bForceState);

// Export USPPawn::execAttemptPhysAnimState_RagdollIntoAnim(FFrame&, void* const)
native final function bool AttemptPhysAnimState_RagdollIntoAnim(optional bool bForceState);

// Export USPPawn::execDismemberJoint(FFrame&, void* const)
native final function DismemberJoint(name JointName, float physicsStartTime);

// Export USPPawn::execSetAnimIntoRagdollBlendControl(FFrame&, void* const)
native final function SetAnimIntoRagdollBlendControl(float startRampingTime, float finishRampingTime, optional float holdPercentage = 0.0000000);

// Export USPPawn::execDamageCollectorAddDamage(FFrame&, void* const)
native final simulated function DamageCollectorAddDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USPPawn::execDamageCollectorApplyDamage(FFrame&, void* const)
native final simulated function DamageCollectorApplyDamage();

// Export USPPawn::execDamageCollectorClear(FFrame&, void* const)
native final simulated function DamageCollectorClear();

// Export USPPawn::execGetBulletImpactScale(FFrame&, void* const)
native final function float GetBulletImpactScale();

// Export USPPawn::execAddWeaponAnimations(FFrame&, void* const)
native final function AddWeaponAnimations(class<SPWeapon> WeaponClass);

// Export USPPawn::execRemoveWeaponAnimations(FFrame&, void* const)
native final function RemoveWeaponAnimations(class<SPWeapon> WeaponClass);

event bool CanPawnUsePhysAnimStatePoking()
{
    // End:0x24
    if((int(Physics) != int(1)) && int(Physics) != int(0))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event bool CanPawnUsePhysAnimStateAnimIntoRagdoll()
{
    // End:0x1D
    if((int(Physics) == int(8)) || m_bDiedWhileSpidering)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event bool CanPawnUsePhysAnimStateRagdoll()
{
    return true;
    //return ReturnValue;    
}

simulated event bool CanPawnUsePhysAnimStateRagdollIntoAnim()
{
    return true;
    //return ReturnValue;    
}

simulated event GetNamedFixedBodiesForPoking(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.FixedBoneNamesForPoking;
    //return;    
}

simulated event GetPokingNamedAngularBoneSprings(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.AngularBoneSpringNamesForPoking;
    //return;    
}

simulated event GetPokingNamedLinearBoneSprings(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.LinearBoneSpringNamesForPoking;
    //return;    
}

simulated event GetAnimIntoRagdollNamedAngularBoneSprings(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.AngularBoneSpringNamesForAnimIntoRagdoll;
    //return;    
}

simulated event GetAnimIntoRagdollNamedLinearBoneSprings(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.LinearBoneSpringNamesForAnimIntoRagdoll;
    //return;    
}

simulated event GetRagdollIntoAnimNamedAngularBoneSprings(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.AngularBoneSpringNamesForRagdollIntoAnim;
    //return;    
}

simulated event GetRagdollIntoAnimNamedLinearBoneSprings(out array<name> OutArray)
{
    OutArray = Mesh.PhysicsAsset.LinearBoneSpringNamesForRagdollIntoAnim;
    //return;    
}

simulated event SPTwoStageBlendTarget GetPokingMotorSpringScaleBlendValues()
{
    return Mesh.PhysicsAsset.JointMotorSpringScaleForPoking;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetPokingGetMotorDampingScaleBlendValues()
{
    return Mesh.PhysicsAsset.JointMotorDampingScaleForPoking;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetPokingAngularSpringBlendValues()
{
    return Mesh.PhysicsAsset.AngularBoneSpringBlendValuesForPoking;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetPokingLinearSpringBlendValues()
{
    return Mesh.PhysicsAsset.LinearBoneSpringBlendValuesForPoking;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetPokingPhysicsWeightValues()
{
    return Mesh.PhysicsAsset.PhysicsBlendValuesForPoking;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetAnimIntoRagdollMotorSpringScaleBlendValues()
{
    return Mesh.PhysicsAsset.JointMotorSpringScaleForAnimIntoRagdoll;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetAnimIntoRagdollGetMotorDampingScaleBlendValues()
{
    return Mesh.PhysicsAsset.JointMotorDampingScaleForAnimIntoRagdoll;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetAnimIntoRagdollAngularSpringBlendValues()
{
    return Mesh.PhysicsAsset.AngularBoneSpringBlendValuesForAnimIntoRagdoll;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetAnimIntoRagdollLinearSpringBlendValues()
{
    return Mesh.PhysicsAsset.LinearBoneSpringBlendValuesForAnimIntoRagdoll;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetAnimIntoRagdollPhysicsWeightValues()
{
    return Mesh.PhysicsAsset.PhysicsBlendValuesForAnimIntoRagdoll;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetRagdollIntoAnimMotorSpringScaleBlendValues()
{
    return Mesh.PhysicsAsset.JointMotorSpringScaleForRagdollIntoAnim;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetRagdollIntoAnimGetMotorDampingScaleBlendValues()
{
    return Mesh.PhysicsAsset.JointMotorDampingScaleForRagdollIntoAnim;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetRagdollIntoAnimAngularSpringBlendValues()
{
    return Mesh.PhysicsAsset.AngularBoneSpringBlendValuesForRagdollIntoAnim;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetRagdollIntoAnimLinearSpringBlendValues()
{
    return Mesh.PhysicsAsset.LinearBoneSpringBlendValuesForRagdollIntoAnim;
    //return ReturnValue;    
}

simulated event SPTwoStageBlendTarget GetRagdollIntoAnimPhysicsWeightValues()
{
    return Mesh.PhysicsAsset.PhysicsBlendValuesForRagdollIntoAnim;
    //return ReturnValue;    
}

simulated event float GetPhysicsWeightAtWhichToIgnorePoking()
{
    return Mesh.PhysicsAsset.PhysicsWeightAtWhichToIgnorePoking;
    //return ReturnValue;    
}

simulated event StartTransitionAnimationForRagdollIntoAnim()
{
    //return;    
}

simulated event StartAnimationForAnimIntoRagdoll()
{
    //return;    
}

simulated event StartGetUpAnimationForRagdollIntoAnim()
{
    //return;    
}

simulated event PrepareForNonAnimationBasedMovement()
{
    //return;    
}

simulated event bool ShouldCheckGroundAccidents()
{
    return true;
    //return ReturnValue;    
}

function HitDeathFinishedAnimCB()
{
    //return;    
}

function bool CanClassStepAside()
{
    return false;
    //return ReturnValue;    
}

function TakeFallingDamage()
{
    local float EffectiveSpeed;

    // End:0x0D
    if(!m_bCanTakeFallingDamage)
    {
        return;
    }
    // End:0xF1
    if(Velocity.Z < (-0.5000000 * MaxFallSpeed))
    {
        // End:0xEE
        if(int(Role) == int(ROLE_Authority))
        {
            MakeNoise(1.0000000);
            // End:0xEE
            if(Velocity.Z < (float(-1) * MaxFallSpeed))
            {
                EffectiveSpeed = Velocity.Z;
                // End:0x98
                if(TouchingWaterVolume())
                {
                    EffectiveSpeed += float(100);
                }
                // End:0xEE
                if(EffectiveSpeed < (float(-1) * MaxFallSpeed))
                {
                    TakeDamageAndProcEffects((-100.0000000 * (EffectiveSpeed + MaxFallSpeed)) / MaxFallSpeed, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
                }
            }
        }        
    }
    else
    {
        // End:0x11E
        if(Velocity.Z < (-1.4000000 * JumpZ))
        {
            MakeNoise(0.5000000);            
        }
        else
        {
            // End:0x148
            if(Velocity.Z < (-0.8000000 * JumpZ))
            {
                MakeNoise(0.2000000);
            }
        }
    }
    //return;    
}

simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser)
{
    local float ColRadius, ColHeight, DamageScale, Dist;
    local Vector Dir;

    GetBoundingCylinder(ColRadius, ColHeight);
    Dir = Location - HurtOrigin;
    Dist = VSize(Dir);
    Dir = Normal(Dir);
    m_lastDistFromImpact = Dist;
    // End:0x62
    if(bFullDamage)
    {
        DamageScale = 1.0000000;        
    }
    else
    {
        Dist = FClamp(Dist - ColRadius, 0.0000000, DamageRadius);
        DamageScale = 1.0000000 - (Dist / DamageRadius);
    }
    // End:0x102
    if(DamageScale > 0.0000000)
    {
        TakeDamageAndProcEffects(DamageScale * BaseDamage, instigatedBy, Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), (DamageScale * Momentum) * Dir, DamageType,, DamageCauser);
    }
    //return;    
}

simulated event TakeDamageAndProcEffects(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    LastDamageRecievedType = DamageType;
    super(Actor).TakeDamageAndProcEffects(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function DBG_MsgP(string Str)
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

function DetachFromController(optional bool bDestroyController)
{
    local Controller OldController;

    // End:0x9D
    if((Controller != none) && Controller.Pawn == self)
    {
        OldController = Controller;
        Controller.PawnDied(self);
        // End:0x62
        if(Controller != none)
        {
            Controller.UnPossess();
        }
        // End:0x96
        if((SPAIController(OldController) != none) && !OldController.bDeleteMe)
        {
            OldController.Destroy();
        }
        Controller = none;
    }
    //return;    
}

simulated event bool UseFirstPersonAnims()
{
    // End:0x25
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return IsFirstPerson();
    }
    // End:0x50
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return int(Role) == int(ROLE_AutonomousProxy);        
    }
    else
    {
        return IsLocallyControlled();
    }
    //return ReturnValue;    
}

event bool ShouldPushActor(Actor A)
{
    // End:0x32
    if((A.bStatic == true) || A.IsA('SpeedTreeActor'))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function name GetDefaultBone()
{
    return 'JO_Spine_A';
    //return ReturnValue;    
}

simulated function SPPawn.EHSDamageDirectionType GetDamageDirection()
{
    return 0;
    //return ReturnValue;    
}

function SetThrowDeath(float Impulse, Vector Direction)
{
    m_bThrowDeath = true;
    m_DeathThrowImpulse = Impulse;
    m_DeathThrowDirection = Direction;
    //return;    
}

function SetStateForAttachedTentacle(bool isAttaching)
{
    //return;    
}

function SetAttachedToTentacle(bool isAttaching)
{
    m_bIsAttachedToTentacle = isAttaching;
    SetStateForAttachedTentacle(m_bIsAttachedToTentacle);
    //return;    
}

function bool GetAttachedToTentacle()
{
    return m_bIsAttachedToTentacle;
    //return ReturnValue;    
}

function SetWeaponAttachmentClass(class<SPWeaponAttachment> AttachmentClass)
{
    CurrentWeaponAttachmentClass = AttachmentClass;
    //return;    
}

simulated function WeaponAttachmentChanged()
{
    // End:0x12
    if(int(Role) > int(ROLE_SimulatedProxy))
    {
        return;
    }
    // End:0x63
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass)
    {
        CurrentWeaponAttachment.DetachFrom(SPSkeletalMeshComponent(Mesh));
        CurrentWeaponAttachment.Destroy();
    }
    // End:0xF9
    if(CurrentWeaponAttachmentClass != none)
    {
        // End:0xAD
        if((CurrentWeaponAttachment == none) || CurrentWeaponAttachmentClass != CurrentWeaponAttachment.Class)
        {
            CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass, self);
        }
        // End:0xF6
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.Instigator = self;
            CurrentWeaponAttachment.AttachTo(self);
            AddWeaponAnimations(CurrentWeaponAttachment.WeaponClass);            
        }        
    }
    else
    {
        CurrentWeaponAttachment = none;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x22
    if(VarName == 'CurrentWeaponAttachmentClass')
    {
        WeaponAttachmentChanged();
        return;        
    }
    else
    {
        // End:0x40
        if(VarName == 'm_lastEdgeSent')
        {
            BecameRelevantWhileAnimBased();
            return;            
        }
        else
        {
            // End:0x68
            if(VarName == 'm_bWeaponFiring')
            {
                // End:0x68
                if(m_bWeaponFiring)
                {
                    WeaponFired(true);
                }
            }
        }
    }
    super(Pawn).ReplicatedEvent(VarName);
    //return;    
}

function bool GetBestFireSocket(const Vector NewLocation, out name fireSocketName)
{
    fireSocketName = 'None';
    return false;
    //return ReturnValue;    
}

function EnableMotors(bool InEnabled)
{
    local RB_ConstraintInstance ConInst;
    local int I;

    I = 0;
    J0x07:

    // End:0x8B [Loop If]
    if(I < Mesh.PhysicsAssetInstance.Constraints.Length)
    {
        ConInst = Mesh.PhysicsAssetInstance.Constraints[I];
        // End:0x81
        if(!ConInst.bAIControlled)
        {
            ConInst.SetAngularPositionDrive(InEnabled, InEnabled);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetAnimationSynchronizationTime(float TimeSeconds)
{
    m_AnimationSynchronizationTime = TimeSeconds;
    //return;    
}

function SetNovodexBoundingVolume(bool bEnable)
{
    bHasNovodexBoundingVolume = bEnable;
    EnableNovodexBoundingVolume(bEnable);
    // End:0x2E
    if(bEnable)
    {
        SetNovodexCollisionVolumeCollisionWith(Mesh, true);
    }
    //return;    
}

final function Vector DeltaBetweenCollision(Actor T)
{
    local Vector ourCenter, theirCenter, Delta;

    // End:0x2A
    if(Controller(T) != none)
    {
        T = Controller(T).Pawn;
    }
    // End:0x3B
    if(T == none)
    {
        return Delta;
    }
    // End:0x95
    if(CollisionComponent != none)
    {
        ourCenter = CollisionComponent.Bounds.Origin;
        ourCenter.Z -= CollisionComponent.Bounds.SphereRadius;        
    }
    else
    {
        ourCenter = Location;
    }
    // End:0x118
    if(T.CollisionComponent != none)
    {
        theirCenter = T.CollisionComponent.Bounds.Origin;
        theirCenter.Z -= T.CollisionComponent.Bounds.SphereRadius;        
    }
    else
    {
        theirCenter = T.Location;
    }
    Delta = ourCenter - theirCenter;
    return Delta;
    //return ReturnValue;    
}

event float DistanceBetweenCollisionSQ(Actor T)
{
    return VSizeSq(DeltaBetweenCollision(T));
    //return ReturnValue;    
}

event float DistanceBetweenCollision(Actor T)
{
    return Sqrt(DistanceBetweenCollisionSQ(T));
    //return ReturnValue;    
}

simulated function float GetApproximateDistanceBetweenCylinderEdges(Pawn P)
{
    local float retval;
    local Vector Delta;

    // End:0x6E
    if(P != none)
    {
        Delta = P.Location - Location;
        retval = VSize(Delta);
        retval -= P.GetClassSpecificCollisionRadius(self);
        retval -= (GetClassSpecificCollisionRadius(P));
        return retval;
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetApproximateDistanceToCylinderEdge(Vector Loc, Pawn P)
{
    local float retval;
    local Vector Delta;

    // End:0x57
    if(P != none)
    {
        Delta = P.Location - Loc;
        retval = VSize(Delta);
        retval -= P.GetClassSpecificCollisionRadius(self);
        return retval;
    }
    return 0.0000000;
    //return ReturnValue;    
}

function AddHostile(Controller instigatedBy)
{
    local SPPawn hostilePawn;
    local int Count;

    // End:0x1E
    if((instigatedBy == none) || instigatedBy == Controller)
    {
        return;
    }
    hostilePawn = SPPawn(instigatedBy.Pawn);
    // End:0x45
    if(hostilePawn == none)
    {
        return;
    }
    Count = 0;
    J0x4C:

    // End:0x7D [Loop If]
    if(Count < m_hostiles.Length)
    {
        // End:0x73
        if(m_hostiles[Count] == hostilePawn)
        {
            return;
        }
        Count++;
        // [Loop Continue]
        goto J0x4C;
    }
    m_hostiles[m_hostiles.Length] = hostilePawn;
    //return;    
}

function bool IsHostile(SPPawn pawnToTest)
{
    local int Count;

    Count = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(Count < m_hostiles.Length)
    {
        // End:0x2E
        if(m_hostiles[Count] == pawnToTest)
        {
            return true;
        }
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int actualDamage;
    local PlayerController PC;
    local Controller Killer;
    local Pawn InstigatorPawn;
    local Vector N;

    AddHostile(EventInstigator);
    // End:0x27
    if(DamageType == none)
    {
        DamageType = Class'Engine.DamageType';
    }
    // End:0x39
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x46
    if(Health <= 0)
    {
        return;
    }
    DamageAmount = float(FloatingPointAdjustDamage(DamageAmount));
    // End:0xB3
    if((int(Physics) == int(1)) && DamageType.default.bExtraMomentumZ)
    {
        Momentum.Z = FMax(Momentum.Z, 0.4000000 * VSize(Momentum));
    }
    // End:0xCE
    if(EventInstigator == Controller)
    {
        Momentum *= 0.6000000;
    }
    Momentum = Momentum / Mass;
    // End:0x118
    if(DrivenVehicle != none)
    {
        DrivenVehicle.AdjustDriverDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType);
    }
    actualDamage = int(DamageAmount);
    WorldInfo.Game.ReduceDamage(actualDamage, self, EventInstigator, HitLocation, Momentum, DamageType);
    AdjustDamage(actualDamage, Momentum, EventInstigator, HitLocation, DamageType, HitInfo);
    Health -= actualDamage;
    // End:0x1B3
    if(HitLocation == vect(0.0000000, 0.0000000, 0.0000000))
    {
        HitLocation = Location;
    }
    PlayHit(float(actualDamage), EventInstigator, HitLocation, DamageType, Momentum, HitInfo);
    // End:0x397
    if(Health <= 0)
    {
        PC = PlayerController(Controller);
        // End:0x222
        if(PC != none)
        {
            PC.ClientPlayForceFeedbackWaveform(DamageType.default.KilledFFWaveform);
        }
        // End:0x26E
        if((DamageType.default.bCausedByWorld && (EventInstigator == none) || EventInstigator == Controller) && LastHitBy != none)
        {
            Killer = LastHitBy;            
        }
        else
        {
            // End:0x284
            if(EventInstigator != none)
            {
                Killer = EventInstigator;
            }
        }
        TearOffMomentum = Momentum;
        Died(Killer, DamageType, HitLocation);
        DeathParams.Damage = DamageAmount;
        DeathParams.instigatedBy = EventInstigator;
        DeathParams.HitLocation = HitLocation;
        DeathParams.Momentum = Momentum;
        DeathParams.DamageType = DamageType;
        DeathParams.HitInfo = HitInfo;
        DeathParams.DamageCauser = DamageCauser;
        // End:0x365
        if(EventInstigator != none)
        {
            InstigatorPawn = EventInstigator.Pawn;            
        }
        else
        {
            InstigatorPawn = none;
        }
        N = Normal(Momentum);
        m_hitDirectionAngle = ComputeLocalHitDirectionAngle(N, HitLocation, InstigatorPawn);        
    }
    else
    {
        // End:0x3CF
        if(Controller != none)
        {
            Controller.NotifyTakeHit(EventInstigator, HitLocation, actualDamage, DamageType, Momentum);
        }
        // End:0x429
        if((EventInstigator != none) && EventInstigator != Controller)
        {
            // End:0x41E
            if(int(WorldInfo.NetMode) != int(NM_Standalone))
            {
                // End:0x41B
                if(actualDamage > 0)
                {
                    LastHitBy = EventInstigator;
                }                
            }
            else
            {
                LastHitBy = EventInstigator;
            }
        }
    }
    MakeNoise(1.0000000);
    super(Actor).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    local SPAnimSceneTemplateNode SeqNode;

    // End:0x0D
    if(Mesh == none)
    {
        return;
    }
    Mesh.SaveAnimSets();
    AddAnimationSets(InAnimSets, true);
    SeqNode = SPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
    // End:0x65
    if(SeqNode == none)
    {        
    }
    else
    {
        SeqNode.m_bPlayNewScene = false;
        SeqNode.m_currentScene.sceneAnimName = 'None';
    }
    bAnimTrackInitialized = true;
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    local SPAnimSceneTemplateNode SeqNode;
    local SPAnimNodeSequence AnimNode;

    // End:0x16C
    if((Mesh != none) && HasAnimTrack())
    {
        SeqNode = SPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
        // End:0x55
        if(SeqNode == none)
        {
            return;
        }
        // End:0x6A
        if(HasMovementTrack())
        {
            SetPhysics(7);            
        }
        else
        {
            SetPhysics(0);
        }
        // End:0xF8
        if(SeqNode.m_currentScene.sceneAnimName != InAnimSeqName)
        {
            // End:0xB7
            if(Controller != none)
            {
                SPAIController(Controller).WaitForSceneFinish();
            }
            SetAIAnimControl(false);
            SeqNode.PlayNewScene(InAnimSeqName, 1, none, 0.0000000);
            SeqNode.PlayQueuedScene();
        }
        AnimNode = SPAnimNodeSequence(SeqNode.GetActiveChild());
        // End:0x125
        if(AnimNode == none)
        {            
        }
        else
        {
            AnimNode.bPlaying = false;
            AnimNode.m_bForceNoPlaying = true;
            AnimNode.SetPosition(InPosition, bFireNotifies);
        }        
    }
    else
    {
        super(Actor).SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
    }
    //return;    
}

simulated event FinishAnimControl()
{
    local SPAnimSceneTemplateNode SeqNode;
    local SPAnimNodeSequence AnimNode;
    local int I;

    // End:0x0D
    if(Mesh == none)
    {
        return;
    }
    // End:0x1B
    if(bAnimTrackInitialized == false)
    {
        return;
    }
    bAnimTrackInitialized = false;
    Mesh.RestoreSavedAnimSets();
    SetPhysics(0);
    SeqNode = SPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
    // End:0x74
    if(SeqNode == none)
    {        
    }
    else
    {
        I = 0;
        J0x7B:

        // End:0xEA [Loop If]
        if(I < SeqNode.Children.Length)
        {
            AnimNode = SPAnimNodeSequence(SeqNode.Children[I].Anim);
            // End:0xCE
            if(AnimNode == none)
            {
                // [Explicit Continue]
                goto J0xE0;
            }
            AnimNode.m_bForceNoPlaying = false;
            J0xE0:

            I++;
            // [Loop Continue]
            goto J0x7B;
        }
    }
    //return;    
}

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName)
{
    // End:0x2E
    if(Mesh != none)
    {
        return Mesh.PlayFaceFXAnim(AnimSet, SeqName, GroupName);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated event StopActorFaceFXAnim()
{
    // End:0x1B
    if(Mesh != none)
    {
        Mesh.StopFaceFXAnim();
    }
    //return;    
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return FacialAudioComp;
    //return ReturnValue;    
}

simulated event FaceFXAsset GetActorFaceFXAsset()
{
    // End:0x3F
    if((Mesh != none) && Mesh.SkeletalMesh != none)
    {
        return Mesh.SkeletalMesh.FaceFXAsset;        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    return (Mesh != none) && Mesh.IsPlayingFaceFXAnim();
    //return ReturnValue;    
}

function ApplyDOT(Controller instigata, int Duration, int Damage, class<PandoraDamageType> DamageType)
{
    // End:0x16
    if(DamageType == none)
    {
        DamageType = Class'PandoraDamageType';
    }
    // End:0x34
    if(m_DOTDuration == 0)
    {
        SetTimer(1.0000000, true, 'DOTTimer');
    }
    m_DOTInstigator = instigata;
    m_DOTDamage = Damage / Duration;
    m_DOTDuration = Duration;
    m_DOTDamageType = DamageType;
    //return;    
}

function DOTTimer()
{
    TakeDamageAndProcEffects(float(m_DOTDamage), m_DOTInstigator, vect(0.0000000, 0.0000000, 0.0000000), Vector(Rotation), m_DOTDamageType,, ((m_DOTInstigator != none) ? m_DOTInstigator.Pawn : none));
    m_DOTDuration -= 1;
    // End:0x77
    if(m_DOTDuration <= 0)
    {
        m_DOTDuration = 0;
        ClearTimer('DOTTimer');
    }
    //return;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local bool IsReallyDead;
    local PandoraPlayerController thePlayer;

    m_deathDamageType = DamageType;
    m_deathDistFromImpact = m_lastDistFromImpact;
    m_localVelocityAngle = ComputeLocalVelocityAngle();
    // End:0x41
    if(!m_bDiedWhileSpidering)
    {
        m_bDiedWhileSpidering = int(Physics) == int(8);
    }
    IsReallyDead = super(Pawn).Died(Killer, DamageType, HitLocation);
    // End:0xC9
    if(IsReallyDead)
    {
        NotifyFactoryOfDeath();
        // End:0xC6
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            thePlayer = PandoraPlayerController(Killer);
            // End:0xC6
            if((thePlayer != none) && DamageType == Class'SPDamageTypeImpactFireAxeSwing')
            {
                thePlayer.SinglePlayerFireAxeKillAchievement();
            }
        }        
    }
    else
    {
        TriggerEventClass(Class'SeqEvent_UnConscious', self);
    }
    return IsReallyDead;
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    return 0;
    //return ReturnValue;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return none;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return none;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super(Pawn).PreBeginPlay();
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    m_PawnTuneData = GetMyTuneData();
    m_GDData = GetMyGDData();
    // End:0x9F
    if(m_GDData != none)
    {
        Health = int(m_GDData.GetValue(m_GDData.HitPoints));
        // End:0x9C
        if(Health == 0)
        {
            Health = m_PawnTuneData.HitPoints;
        }        
    }
    HealthMax = Health;
    //return;    
}

simulated function PostBeginPlay()
{
    super(Pawn).PostBeginPlay();
    // End:0x43
    if(!bDeleteMe)
    {
        AddSpecialAnimationSets();
        SetMovementType(2);
        InitHitLocationGroupings();
        SetNovodexBoundingVolume(bHasNovodexBoundingVolume);
        ClearClosestVertexWithNeighborhoodDataCache();
    }
    HeadTrackComponent.Init();
    // End:0x73
    if(bHidden == true)
    {
        SetHiddenFlag(bHidden);
    }
    InitPhysicsAssetInstance(true);
    HandleDebugOptimizations();
    // End:0xB3
    if(bEnableAnimusHitReaction && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        SetupAnimusPulseEffect();
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    ServerTick_SPPawn(DeltaTime);
    HeadTrackComponent.DoTick(DeltaTime);
    // End:0x49
    if(!bDeleteMe && m_bStartDissolve)
    {
        DoFadeTick(DeltaTime);
    }
    DamageCollectorApplyDamage();
    super(Actor).Tick(DeltaTime);
    //return;    
}

final function ServerTick_SPPawn(float DeltaTime)
{
    // End:0x35
    if(m_bEnablePhysicsPushing)
    {
        m_physicsPushingLastUpdateAccrue += DeltaTime;
        // End:0x35
        if(m_physicsPushingLastUpdateAccrue >= m_physicsPushingUpdateInterval)
        {
            UpdatePushingPhysics();
            m_physicsPushingLastUpdateAccrue = 0.0000000;
        }
    }
    UpdateDamageZones(DeltaTime);
    UpdateControllersThatThinkIAmAnEnemy();
    //return;    
}

simulated function bool LookAtActorDefault(Actor actorToLookAt, out Vector whereToLook)
{
    return HeadTrackComponent.LookAtActorDefault(actorToLookAt, whereToLook);
    //return ReturnValue;    
}

simulated event bool DoAILookAt(out Vector whereToLook)
{
    // End:0x4B
    if((Controller != none) && Controller.GetEnemy() != none)
    {
        return LookAtActorDefault(Controller.GetEnemy(), whereToLook);
    }
    return false;
    //return ReturnValue;    
}

event FlightStartTakeoff(int vertexUID)
{
    //return;    
}

event FlightStartLanding(int vertexUID, Vector landingPos)
{
    //return;    
}

event UsePhysWalking()
{
    //return;    
}

event UsePhysFlying()
{
    //return;    
}

simulated function bool IsPhysFlying()
{
    // End:0x15
    if(int(Physics) == int(4))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function PrepareForNavPoint(NavigationPoint goal)
{
    // End:0x7F
    if(Controller != none)
    {
        // End:0x7F
        if((Controller.CurrentPath != none) && Controller.NextRoutePath != none)
        {
            // End:0x7F
            if((SPWallAnimationReachSpec(Controller.CurrentPath) == none) && SPWallAnimationReachSpec(Controller.NextRoutePath) != none)
            {
                Controller.bPreciseDestination = true;
            }
        }
    }
    SetMovementPhysics();
    //return;    
}

event NewFloor()
{
    //return;    
}

event PrepareForBase(Actor NewBase)
{
    //return;    
}

simulated function bool IsWallMoveTowardsInProgress()
{
    return m_wallMovementData.bDoingMove;
    //return ReturnValue;    
}

function OnForceWallWalking(SeqAct_ForceWallWalking Action)
{
    ForceWallWalking(Action);
    //return;    
}

simulated event SetDefaultWallPose()
{
    m_currentWallPose = 'ground';
    //return;    
}

simulated event UpdateWallPose(name newPoseName)
{
    // End:0x13
    if(newPoseName == 'None')
    {
    }
    m_currentWallPose = newPoseName;
    //return;    
}

simulated event SwitchFromWallWalkingToWalking()
{
    // End:0x1F
    if((int(Role) <= int(ROLE_SimulatedProxy)) && !m_bIgnoreServerMoves)
    {
        return;
    }
    // End:0x3A
    if(int(Role) <= int(ROLE_SimulatedProxy))
    {
        SetSimulateGravity(true);
    }
    SetToGroundMovementType();
    SetPhysics(ROLE_SimulatedProxy);
    //return;    
}

function SetToGroundMovementType()
{
    //return;    
}

simulated event PrepareForWallAnimationReachSpec(SPWallAnimationReachSpec ReachSpec, int kyEndVertexID)
{
    // End:0xF2
    if(m_bCanSpider)
    {
        // End:0xE8
        if(!IsWallMoveTowardsInProgress())
        {
            CacheWallMovementInformation(ReachSpec);
            m_kynapseRelay_vertexID = kyEndVertexID;
            // End:0x4D
            if(int(Physics) != int(8))
            {
                SetDefaultWallPose();
                SetPhysics(8);
            }
            m_wallMovementData.TransitionData.currentTransition = 0;
            m_wallMovementData.bDoingMove = true;
            m_bArrivedAtWallDestination = false;
            // End:0xDB
            if(GetWallMovementData(ReachSpec, m_wallMovementData))
            {
                // End:0xC9
                if(m_wallMovementData.TransitionData.bTransitionRequired)
                {
                    StartWallTransition(ReachSpec);                    
                }
                else
                {
                    StartWallMovement(ReachSpec);
                }                
            }
            else
            {
                Breakpoint();
            }            
        }
        else
        {
            Breakpoint();
        }
    }
    //return;    
}

simulated function StartWallMovementAnimations()
{
    //return;    
}

simulated function StartWallMovement(SPWallAnimationReachSpec ReachSpec)
{
    m_wallRegistrationNode = none;
    UpdateWallPose(m_wallMovementData.wallAnimData.StartPose);
    m_bIsCurrentPoseRotationallyInvariant = m_wallMovementData.wallAnimData.bIsStartPoseRotationallyInvariant;
    StartWallMovementAnimations();
    // End:0x119
    if((int(m_wallMovementData.wallAnimData.LocomotionType) == int(2)) || int(m_wallMovementData.wallAnimData.LocomotionType) == int(1))
    {
        // End:0x119
        if(m_wallRegistrationNode != none)
        {
            RegisterDestinationAndOrientation(m_wallRegistrationNode, m_wallMovementData.moveToLocation, m_wallMovementData.moveToRotation, m_wallMovementData.wallAnimData.BlendStartTime, m_wallMovementData.wallAnimData.BlendEndTime, false, true, 1.0000000, 1.0000000);
        }
    }
    //return;    
}

simulated function bool StartWallTransitionAnimations()
{
    //return ReturnValue;    
}

simulated function StartWallTransition(SPWallAnimationReachSpec ReachSpec)
{
    local int cur;

    m_wallRegistrationNode = none;
    // End:0xBC
    if(StartWallTransitionAnimations())
    {
        // End:0xB9
        if(m_wallRegistrationNode != none)
        {
            cur = m_wallMovementData.TransitionData.currentTransition;
            RegisterDestinationAndOrientation(m_wallRegistrationNode, m_wallMovementData.TransitionData.TransitionList[cur].moveToLocation, m_wallMovementData.TransitionData.TransitionList[cur].moveToRotation, 0.0000000, -1.0000000, false, false, 1.0000000, 1.0000000);
        }        
    }
    else
    {
        StartWallMovement(ReachSpec);
    }
    //return;    
}

simulated function WallTransitionFinished()
{
    m_wallMovementData.TransitionData.currentTransition = m_wallMovementData.TransitionData.currentTransition + 1;
    CancelDestinationRegistration();
    StartWallTransition(m_wallMovementData.ReachSpec);
    //return;    
}

function SetAnimTurnAmountInDegrees(float turnAmount)
{
    m_animTurnAmount = turnAmount;
    m_bResetTurnAnim = true;
    //return;    
}

function BlendedTurnAnimCB(out BlendedTurnAnimCBParams Params)
{
    Params.turnAmount = m_animTurnAmount;
    Params.bResetAnims = m_bResetTurnAnim;
    m_bResetTurnAnim = false;
    //return;    
}

simulated function name CameraMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x36
    if((IsFirstPerson()) || int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return 'FirstPerson';        
    }
    else
    {
        return 'ThirdPerson';
    }
    //return ReturnValue;    
}

simulated event SetMovementType(SPPawn.SPEMovementType Type)
{
    local int I;
    local bool bFound;

    // End:0x1F
    if((int(Role) <= int(ROLE_SimulatedProxy)) && !m_bIgnoreServerMoves)
    {
        return;
    }
    bFound = false;
    I = 0;
    J0x2E:

    // End:0xF7 [Loop If]
    if(I < m_movementTypeInfo.Length)
    {
        // End:0xED
        if(int(m_movementTypeInfo[I].movementType) == int(Type))
        {
            m_currentMovementTypeIndex = I;
            AccelRate = m_movementTypeInfo[I].AccelRate;
            GroundSpeed = m_movementTypeInfo[I].GroundSpeed;
            // End:0xE2
            if(int(m_movementTypeInfo[I].physicsToUse) == int(4))
            {
                AirSpeed = m_movementTypeInfo[I].GroundSpeed;
            }
            bFound = true;
            // [Explicit Break]
            goto J0xF7;
        }
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    J0xF7:

    // End:0x102
    if(!bFound)
    {
    }
    //return;    
}

simulated event SPPawn.SPEMovementType GetMovementType()
{
    // End:0x16
    if(m_currentMovementTypeIndex > (m_movementTypeInfo.Length - 1))
    {
        return 2;
    }
    // End:0x24
    if(m_currentMovementTypeIndex < 0)
    {
        return 2;
    }
    return m_movementTypeInfo[m_currentMovementTypeIndex].movementType;
    //return ReturnValue;    
}

simulated function SetMovementPhysics()
{
    local PandoraPlayerController spPlaya;

    // End:0x1F
    if((int(Role) < int(ROLE_Authority)) && !m_bIgnoreServerMoves)
    {
        return;
    }
    // End:0x34
    if(HasAnimTrack())
    {
        SetPhysics(0);        
    }
    else
    {
        // End:0x4F
        if(PhysicsVolume.bWaterVolume)
        {
            SetPhysics(3);            
        }
        else
        {
            // End:0x78
            if(int(m_movementTypeInfo[m_currentMovementTypeIndex].physicsToUse) == int(4))
            {
                SetPhysics(4);                
            }
            else
            {
                // End:0xA1
                if(int(m_movementTypeInfo[m_currentMovementTypeIndex].physicsToUse) == int(8))
                {
                    SetPhysics(8);                    
                }
                else
                {
                    // End:0xCA
                    if(int(m_movementTypeInfo[m_currentMovementTypeIndex].physicsToUse) == int(10))
                    {
                        SetPhysics(10);                        
                    }
                    else
                    {
                        // End:0x105
                        if((int(m_movementTypeInfo[m_currentMovementTypeIndex].physicsToUse) == int(1)) && int(Physics) == int(8))
                        {
                            SetPhysics(1);                            
                        }
                        else
                        {
                            // End:0x1A1
                            if(int(Physics) != int(2))
                            {
                                // End:0x128
                                if(Base == none)
                                {
                                    SetPhysics(2);                                    
                                }
                                else
                                {
                                    // End:0x146
                                    if(Base.bWorldGeometry == true)
                                    {
                                        SetPhysics(1);                                        
                                    }
                                    else
                                    {
                                        // End:0x161
                                        if(Controller != none)
                                        {
                                            spPlaya = PandoraPlayerController(Controller);
                                        }
                                        // End:0x18B
                                        if((spPlaya != none) && spPlaya.LockPosition > 0)
                                        {
                                            SetPhysics(0);                                            
                                        }
                                        else
                                        {
                                            // End:0x19C
                                            if(bHardAttach)
                                            {
                                                SetPhysics(0);                                                
                                            }
                                            else
                                            {
                                                SetPhysics(1);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function JumpOffPawn()
{
    Velocity += ((float(100) + CylinderComponent.CollisionRadius) * VRand());
    Velocity.Z = 200.0000000 + CylinderComponent.CollisionHeight;
    // End:0x5F
    if(int(Physics) != int(4))
    {
        SetPhysics(2);        
    }
    //return;    
}

event EncroachedBy(Actor Other)
{
    //return;    
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
    local Vector X, Y, Z, traceStart, traceEnd, Dir,
	    Cross, HitLocation, HitNormal;

    local Actor HitActor;
    local Rotator TurnRot;

    // End:0x3A
    if((bIsCrouched || bWantsToCrouch) || (int(Physics) != int(1)) && int(Physics) != int(2))
    {
        return false;
    }
    TurnRot.Yaw = Rotation.Yaw;
    GetAxes(TurnRot, X, Y, Z);
    // End:0x209
    if(int(Physics) == int(2))
    {
        // End:0xA1
        if(int(DoubleClickMove) == int(3))
        {
            traceEnd = -X;            
        }
        else
        {
            // End:0xBF
            if(int(DoubleClickMove) == int(4))
            {
                traceEnd = X;                
            }
            else
            {
                // End:0xDD
                if(int(DoubleClickMove) == int(1))
                {
                    traceEnd = Y;                    
                }
                else
                {
                    // End:0xFA
                    if(int(DoubleClickMove) == int(2))
                    {
                        traceEnd = -Y;
                    }
                }
            }
        }
        traceStart = (Location - ((CylinderComponent.CollisionHeight - float(16)) * vect(0.0000000, 0.0000000, 1.0000000))) + (traceEnd * (CylinderComponent.CollisionRadius - float(16)));
        traceEnd = traceStart + (traceEnd * 40.0000000);
        HitActor = Trace(HitLocation, HitNormal, traceEnd, traceStart, false, vect(16.0000000, 16.0000000, 16.0000000));
        // End:0x1B9
        if((HitActor == none) || HitNormal.Z < -0.1000000)
        {
            return false;
        }
        // End:0x209
        if(!HitActor.bWorldGeometry)
        {
            // End:0x1E5
            if(!HitActor.bBlockActors)
            {
                return false;
            }
            // End:0x209
            if((Pawn(HitActor) != none) && Vehicle(HitActor) == none)
            {
                return false;
            }
        }
    }
    // End:0x232
    if(int(DoubleClickMove) == int(3))
    {
        Dir = X;
        Cross = Y;        
    }
    else
    {
        // End:0x264
        if(int(DoubleClickMove) == int(4))
        {
            Dir = float(-1) * X;
            Cross = Y;            
        }
        else
        {
            // End:0x296
            if(int(DoubleClickMove) == int(1))
            {
                Dir = float(-1) * Y;
                Cross = X;                
            }
            else
            {
                // End:0x2BC
                if(int(DoubleClickMove) == int(2))
                {
                    Dir = Y;
                    Cross = X;
                }
            }
        }
    }
    // End:0x2DF
    if(AIController(Controller) != none)
    {
        Cross = vect(0.0000000, 0.0000000, 0.0000000);
    }
    return PerformDodge(DoubleClickMove, Dir, Cross);
    //return ReturnValue;    
}

function Vector BotDodge(Vector Dir)
{
    local Vector Vel;

    Vel = DodgeSpeed * Dir;
    Vel.Z = DodgeSpeedZ;
    return Vel;
    //return ReturnValue;    
}

function bool PerformDodge(Actor.EDoubleClickDir DoubleClickMove, Vector Dir, Vector Cross)
{
    // End:0x1A
    if(int(Physics) == int(2))
    {
        TakeFallingDamage();
    }
    bDodging = true;
    Velocity = (DodgeSpeed * Dir) + ((Velocity Dot Cross) * Cross);
    GroundSpeed = VSize(Velocity);
    MakeNoise(1.0000000);
    return true;
    //return ReturnValue;    
}

simulated function SPPhysicalMaterial GetStandingMaterial(optional out Vector GroundPos)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local SPPhysicalMaterial SPPhysMat;
    local Vector UpDirection;

    SPPhysMat = none;
    UpDirection = vect(0.0000000, 0.0000000, 1.0000000) >> Rotation;
    UpDirection *= FootstepTraceDistance;
    HitActor = Trace(HitLocation, HitNormal, Location - UpDirection, Location, true,, HitInfo);
    // End:0x164
    if(HitActor != none)
    {
        // End:0x133
        if(HitInfo.Material != none)
        {
            SPPhysMat = SPPhysicalMaterial(HitInfo.PhysMaterial);
            // End:0xC8
            if(SPPhysMat == none)
            {
                SPPhysMat = SPPhysicalMaterial(HitInfo.Material.PhysMaterial);
            }
            // End:0x130
            if(bLogUnassignedMaterials)
            {
                // End:0x130
                if(SPPhysMat == none)
                {
                    ClientMessage("Physical Material Unassigned for material:");
                    ClientMessage(string(HitInfo.Material));
                }
            }            
        }
        else
        {
            // End:0x164
            if(HitInfo.PhysMaterial != none)
            {
                SPPhysMat = SPPhysicalMaterial(HitInfo.PhysMaterial);
            }
        }
    }
    GroundPos = HitLocation;
    return SPPhysMat;
    //return ReturnValue;    
}

simulated event StartFootStepEffects(FeetDown FeetDown, AnimNotify_Footstep.eFeetDownImpactStrength FeetDownImpactStrength, optional SPPhysicalMaterial DefaultPhysMat)
{
    local SPPhysicalMaterial SPPhysMat;
    local array<SPPhysicalMaterialParicleSystemParams> PsParams;
    local Vector SocketLocation;
    local Rotator SocketRotation;
    local Vector GroundPos, GroundPlaneNormal;
    local float DistFromGroundPlane;

    // End:0x31C
    if(!bInAir && Mesh != none)
    {
        SPPhysMat = GetStandingMaterial(GroundPos);
        // End:0x44
        if(SPPhysMat == none)
        {
            SPPhysMat = DefaultPhysMat;
        }
        // End:0x51
        if(SPPhysMat == none)
        {
            return;
        }
        GroundPlaneNormal = Normal(Location - GroundPos);
        // End:0x10B
        if(FeetDown.FootDown_Left)
        {
            // End:0x10B
            if(Mesh.GetSocketWorldLocationAndRotation('FootLeft', SocketLocation, SocketRotation))
            {
                DistFromGroundPlane = (SocketLocation - GroundPos) Dot GroundPlaneNormal;
                SocketLocation = SocketLocation + (-GroundPlaneNormal * DistFromGroundPlane);
                PsParams.Insert(0, 1);
                PsParams[0].Location = SocketLocation;
                PsParams[0].Strength = FeetDownImpactStrength;
            }
        }
        // End:0x1B1
        if(FeetDown.FootDown_Right)
        {
            // End:0x1B1
            if(Mesh.GetSocketWorldLocationAndRotation('FootRight', SocketLocation, SocketRotation))
            {
                DistFromGroundPlane = (SocketLocation - GroundPos) Dot GroundPlaneNormal;
                SocketLocation = SocketLocation + (-GroundPlaneNormal * DistFromGroundPlane);
                PsParams.Insert(0, 1);
                PsParams[0].Location = SocketLocation;
                PsParams[0].Strength = FeetDownImpactStrength;
            }
        }
        // End:0x257
        if(FeetDown.FootDown_Left_Front)
        {
            // End:0x257
            if(Mesh.GetSocketWorldLocationAndRotation('FootLeftFront', SocketLocation, SocketRotation))
            {
                DistFromGroundPlane = (SocketLocation - GroundPos) Dot GroundPlaneNormal;
                SocketLocation = SocketLocation + (-GroundPlaneNormal * DistFromGroundPlane);
                PsParams.Insert(0, 1);
                PsParams[0].Location = SocketLocation;
                PsParams[0].Strength = FeetDownImpactStrength;
            }
        }
        // End:0x2FD
        if(FeetDown.FootDown_Right_Front)
        {
            // End:0x2FD
            if(Mesh.GetSocketWorldLocationAndRotation('FootRightFront', SocketLocation, SocketRotation))
            {
                DistFromGroundPlane = (SocketLocation - GroundPos) Dot GroundPlaneNormal;
                SocketLocation = SocketLocation + (-GroundPlaneNormal * DistFromGroundPlane);
                PsParams.Insert(0, 1);
                PsParams[0].Location = SocketLocation;
                PsParams[0].Strength = FeetDownImpactStrength;
            }
        }
        SPPhysMat.StartFootStepParticleSystems(self, PsParams, DefaultFootstepParticles);
    }
    //return;    
}

simulated event PlayFootStepSound(int FootDown, optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;
    local bool bPlayedSound;

    // End:0x90
    if(!bInAir)
    {
        SPPhysMat = GetStandingMaterial(GroundPos);
        // End:0x40
        if(VSizeSq(GroundPos) ~= 0.0000000)
        {
            return;
        }
        // End:0x6C
        if(SPPhysMat != none)
        {
            bPlayedSound = SPPhysMat.PlayFootStepSound(self, maxDist);
        }
        // End:0x87
        if(!bPlayedSound)
        {
            PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Walk_Cue');
        }
        MakeNoise(1.0000000);
    }
    //return;    
}

simulated event PlayFootScuffSound(int FootDown, optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayFootScuffSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Scuff_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayFootRunSound(int FootDown, optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayFootRunSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Run_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayJumpInitSound(optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayJumpInitSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Scuff_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayJumpLandSound(optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayJumpLandSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Land_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event ClientLanded(Vector HitNormal, Actor FloorActor)
{
    // End:0x27
    if(int(Role) == int(ROLE_SimulatedProxy))
    {
        PlayJumpLandSound(0.0000000);
        bInAir = false;
    }
    //return;    
}

simulated event PlayBodyFallSound(int FootDown, optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayBodyFallSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Bodyfalls.Bodyfall_Medium_Stone_ACue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayBodyFallSoftSound(int FootDown, optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayBodyFallSoftSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Bodyfalls.Bodyfall_Medium_Stone_BCue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayCrouchDownSound(optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayCrouchDownSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Scuff_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayCrouchStepSound(int FootDown, optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayCrouchStepSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_CrouchWalk_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated event PlayCrouchUpSound(optional float maxDist = 0.0000000)
{
    local SPPhysicalMaterial SPPhysMat;
    local Vector GroundPos;

    SPPhysMat = GetStandingMaterial(GroundPos);
    // End:0x35
    if(VSizeSq(GroundPos) ~= 0.0000000)
    {
        return;
    }
    // End:0x72
    if((SPPhysMat == none) || SPPhysMat.PlayCrouchUpSound(self, maxDist) == false)
    {
        PlaySound(SoundCue'S_Fol_Footsteps.Test.Footsteps_Test_Scuff_Cue');
    }
    MakeNoise(1.0000000);
    //return;    
}

simulated function WeaponFired(bool bViaReplication, optional Vector HitLocation)
{
    super(Pawn).WeaponFired(bViaReplication, HitLocation);
    // End:0x31
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.StartFiring();
    }
    //return;    
}

simulated function WeaponStoppedFiring(bool bViaReplication)
{
    super(Pawn).WeaponStoppedFiring(bViaReplication);
    // End:0x2B
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.StopFiring();
    }
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0x35
    if((SPWeapon(Weapon) != none) && SPWeapon(Weapon).NotReadyToFire(FireModeNum))
    {
        return;
    }
    super(Pawn).StartFire(FireModeNum);
    //return;    
}

function bool StopFiring()
{
    // End:0x28
    if((Weapon != none) && !Weapon.IsFiring())
    {
        return true;
    }
    return super(Pawn).StopFiring();
    //return ReturnValue;    
}

simulated event bool IsFiringWeaponStateCallback(out int bResetAnim)
{
    return IsFiring();
    //return ReturnValue;    
}

simulated event bool IsFiring()
{
    // End:0x15
    if(CurrentWeaponAttachment == none)
    {
        return super(Pawn).IsFiring();        
    }
    else
    {
        return CurrentWeaponAttachment.IsFiring();
    }
    //return ReturnValue;    
}

function AddDefaultInventory()
{
    local int I;
    local Inventory Inv;

    I = 0;
    J0x07:

    // End:0x65 [Loop If]
    if(I < DefaultInventory.Length)
    {
        // End:0x5B
        if(FindInventoryType(DefaultInventory[I]) == none)
        {
            Inv = CreateInventory(DefaultInventory[I]);
            // End:0x5B
            if(Weapon(Inv) != none)
            {
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function WeaponJustFired()
{
    // End:0x29
    if(SPAIController(Controller) != none)
    {
        SPAIController(Controller).WeaponJustFired();
    }
    //return;    
}

simulated function ReloadStart()
{
    // End:0x29
    if(SPAIController(Controller) != none)
    {
        SPAIController(Controller).ReloadStart();
    }
    //return;    
}

simulated event ReloadFinished()
{
    // End:0x5B
    if(IsReloading())
    {
        // End:0x32
        if(SPWeapon(Weapon) != none)
        {
            SPWeapon(Weapon).ReloadFinished();
        }
        // End:0x5B
        if(SPAIController(Controller) != none)
        {
            SPAIController(Controller).ReloadFinished();
        }
    }
    //return;    
}

function TellReloadFinished(SPWeapon spWeap)
{
    //return;    
}

simulated event Vector GetPhysicalFireStartLoc(optional Vector FireOffset)
{
    local Vector SocketLoc, X, Y, Z;
    local Rotator SocketRot;

    // End:0x25
    if(Weapon != none)
    {
        return Weapon.GetPhysicalFireStartLoc();        
    }
    else
    {
        // End:0x57
        if(CurrentWeaponAttachment != none)
        {
            // End:0x57
            if(CurrentWeaponAttachment.GetMuzzleLoc(SocketLoc, SocketRot))
            {
                return SocketLoc;
            }
        }
    }
    GetWeaponHandPosition(SocketLoc, SocketRot);
    GetAxes(SocketRot, X, Y, Z);
    return ((SocketLoc + (FireOffset.X * X)) + (FireOffset.Y * Y)) + (FireOffset.Z * Z);
    //return ReturnValue;    
}

simulated function GetWeaponHandPosition(out Vector HandLoc, out Rotator HandRot)
{
    // End:0x28
    if(!Mesh.GetSocketWorldLocationAndRotation('JO_Gun', HandLoc, HandRot))
    {
    }
    //return;    
}

simulated event Vector MyGetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    return GetWeaponStartTraceLocation(CurrentWeapon);
    //return ReturnValue;    
}

simulated event name GetAimNodeProfileName()
{
    return 'Default';
    //return ReturnValue;    
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local SPWeapon Weap;
    local Vector StartLoc;

    // End:0x1C
    if(CurrentWeapon != none)
    {
        Weap = SPWeapon(CurrentWeapon);
    }
    // End:0x37
    if(Weap == none)
    {
        Weap = SPWeapon(Weapon);
    }
    // End:0x64
    if(IsHumanControlled() || Weap == none)
    {
        StartLoc = super(Pawn).GetWeaponStartTraceLocation(CurrentWeapon);
        return StartLoc;
    }
    // End:0x75
    if(Weap == none)
    {
        return Location;
    }
    return Weap.GetMuzzleLoc();
    //return ReturnValue;    
}

simulated function Vector GetPulledInMuzzleLocation(SPWeapon Weap, Vector AimDir)
{
    local float MuzzleDist;
    local Vector MuzzleLoc, PulledInMuzzleLoc, ExtraPullIn, HitLocation, HitNormal;

    local Actor HitActor;
    local Vector Offset;

    // End:0x23
    if(Weap != none)
    {
        Offset = Weap.FireOffset;        
    }
    else
    {
        Offset = vect(0.0000000, 0.0000000, 8.0000000);
    }
    MuzzleLoc = GetPhysicalFireStartLoc(Offset);
    MuzzleDist = VSize2D(MuzzleLoc - Location);
    // End:0x180
    if(MuzzleDist > CylinderComponent.CollisionRadius)
    {
        PulledInMuzzleLoc = MuzzleLoc - (MuzzleDist * AimDir);
        MuzzleDist = VSize2D(PulledInMuzzleLoc - Location);
        // End:0x172
        if(MuzzleDist > CylinderComponent.CollisionRadius)
        {
            HitActor = Weap.GetTraceOwner().Trace(HitLocation, HitNormal, PulledInMuzzleLoc, Location, false,,, 1);
            // End:0x16F
            if(HitActor != none)
            {
                ExtraPullIn = Location - PulledInMuzzleLoc;
                ExtraPullIn.Z = 0.0000000;
                ExtraPullIn = ((2.0000000 + MuzzleDist) - CylinderComponent.CollisionRadius) * Normal(ExtraPullIn);
                PulledInMuzzleLoc += ExtraPullIn;                
            }            
        }
        MuzzleLoc = PulledInMuzzleLoc;        
    }
    return MuzzleLoc;
    //return ReturnValue;    
}

simulated function OnCauseDestruction(SeqAct_CauseDestruction Action)
{
    // End:0x19
    if(Action.NotifyBarphOfDeath)
    {
        NotifyFactoryOfDeath();
    }
    super(Actor).OnCauseDestruction(Action);
    //return;    
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
    // End:0x19
    if(Action.NotifyBarphOfDeath)
    {
        NotifyFactoryOfDeath();
    }
    SetNovodexBoundingVolume(false);
    super(Actor).OnDestroy(Action);
    //return;    
}

simulated event Destroyed()
{
    // End:0x52
    if((WorldInfo.m_RTProxyManager != none) && CurRTProxy != none)
    {
        WorldInfo.m_RTProxyManager.RemoveTarget(CurRTProxy);
        CurRTProxy.Destroy();
    }
    // End:0x88
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.DetachFrom(SPSkeletalMeshComponent(Mesh));
        CurrentWeaponAttachment.Destroy();
    }
    DamageCollectorClear();
    super(Pawn).Destroyed();
    //return;    
}

function OnSpeedScale(SeqAct_SpeedScale Action)
{
    MaxDesiredSpeed = Action.Scale;
    DesiredSpeed = Action.Scale;
    //return;    
}

simulated function OnTeleportOrient(SeqAct_TeleportOrient Action)
{
    local Vector pos;

    pos = Action.Position;
    // End:0x3D
    if(Action.UseMayaCoords == true)
    {
        pos = pos + PrePivot;
    }
    // End:0x6D
    if(TeleportOrient(pos, Action.EulerRotation))
    {
        PlayTeleportEffect(false, true);        
    }
    //return;    
}

simulated function DoTeleport(Actor destActor, bool PrePivotAdjust, bool bUpdateRotation)
{
    super(Pawn).DoTeleport(destActor, PrePivotAdjust, bUpdateRotation);
    m_fallStartLocation = Location;
    //return;    
}

simulated function DoTeleportOrient(Vector PosIn, Vector EulerRotIn, bool bUseMayaCoords)
{
    local Vector pos;

    pos = PosIn;
    // End:0x29
    if(bUseMayaCoords == true)
    {
        pos = pos + PrePivot;
    }
    // End:0x4F
    if(TeleportOrient(pos, EulerRotIn))
    {
        PlayTeleportEffect(false, true);        
    }
    //return;    
}

function OnSetMovementType(SeqAct_SetMovementType Action)
{
    SetMovementType(Action.m_type);
    //return;    
}

simulated function OnToggleTargettable(SeqAct_ToggleTargettable Action)
{
    // End:0x2E
    if(Action.InputLinks[0].bHasImpulse)
    {
        DoToggleTargettable(true);        
    }
    else
    {
        // End:0x5C
        if(Action.InputLinks[1].bHasImpulse)
        {
            DoToggleTargettable(false);            
        }
        else
        {
            DoToggleTargettable(!bTargettable);
        }
    }
    //return;    
}

simulated function DoToggleTargettable(bool bMakeTargettable)
{
    // End:0x0B
    if(!bMakeTargettable)
    {
    }
    bTargettable = bMakeTargettable;
    //return;    
}

function OnPlaySceneAnimation(SeqAct_PlaySceneAnimation Action)
{
    local bool bSetActorCollision, bNewCollideActors, bNewBlockActors;
    local SPAnimSceneTemplateNode sceneNode;
    local SPAIController spController;
    local float animBlendTime;
    local array<Object> objVars;
    local int Idx;
    local Actor destActor;
    local Controller C;

    bSetActorCollision = false;
    bNewCollideActors = bCollideActors;
    bNewBlockActors = bBlockActors;
    // End:0x9D
    if(SPAIController(Controller) != none)
    {
        // End:0x69
        if(int(Action.m_bEnableAI) == int(1))
        {
            SPAIController(Controller).DoToggleAI(true);            
        }
        else
        {
            // End:0x9D
            if(int(Action.m_bEnableAI) == int(0))
            {
                SPAIController(Controller).DoToggleAI(false);
            }
        }
    }
    sceneNode = SPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
    // End:0xEA
    if(sceneNode == none)
    {
        Action.bAborted = true;
        return;
    }
    spController = SPAIController(Controller);
    // End:0x119
    if(spController != none)
    {
        spController.WaitForSceneFinish();
    }
    // End:0x134
    if(GetAIAnimControl())
    {
        animBlendTime = 0.2500000;        
    }
    else
    {
        animBlendTime = 0.0000000;
    }
    SetAIAnimControl(false);
    // End:0x191
    if(int(Action.m_bCollideWorld) != int(2))
    {
        // End:0x189
        if(int(Action.m_bCollideWorld) == int(1))
        {
            bCollideWorld = true;            
        }
        else
        {
            bCollideWorld = false;
        }
    }
    // End:0x1E0
    if(int(Action.m_bCollideActors) != int(2))
    {
        bSetActorCollision = true;
        // End:0x1D8
        if(int(Action.m_bCollideActors) == int(1))
        {
            bNewCollideActors = true;            
        }
        else
        {
            bNewCollideActors = false;
        }
    }
    // End:0x22F
    if(int(Action.m_bBlockActors) != int(2))
    {
        bSetActorCollision = true;
        // End:0x227
        if(int(Action.m_bBlockActors) == int(1))
        {
            bNewBlockActors = true;            
        }
        else
        {
            bNewBlockActors = false;
        }
    }
    // End:0x286
    if(int(Action.m_bCollideProj) != int(2))
    {
        // End:0x27E
        if(int(Action.m_bCollideProj) == int(1))
        {
            bSetActorCollision = true;
            bCollideProj = true;
            bNewCollideActors = true;            
        }
        else
        {
            bCollideProj = false;
        }
    }
    // End:0x2A2
    if(bSetActorCollision == true)
    {
        SetCollision(bNewCollideActors, bNewBlockActors);
    }
    // End:0x2E9
    if(int(Action.m_bPathColliding) != int(2))
    {
        // End:0x2E1
        if(int(Action.m_bPathColliding) == int(1))
        {
            bPathColliding = true;            
        }
        else
        {
            bPathColliding = false;
        }
    }
    // End:0x311
    if(int(Action.m_bTargettable) == int(1))
    {
        DoToggleTargettable(true);        
    }
    else
    {
        // End:0x336
        if(int(Action.m_bTargettable) == int(0))
        {
            DoToggleTargettable(false);
        }
    }
    // End:0x464
    if(Action.TeleportInfo.m_bTeleport)
    {
        // End:0x372
        if(Action.TeleportAndOrientInfo.m_bTeleportAndOrient)
        {
        }
        Action.GetObjectVars(objVars, "Destination");
        Idx = 0;
        J0x39B:

        // End:0x41F [Loop If]
        if((Idx < objVars.Length) && destActor == none)
        {
            destActor = Actor(objVars[Idx]);
            C = Controller(destActor);
            // End:0x415
            if((C != none) && C.Pawn != none)
            {
                destActor = C.Pawn;
            }
            Idx++;
            // [Loop Continue]
            goto J0x39B;
        }
        DoTeleport(destActor, Action.TeleportInfo.m_bPrePivotAdjust, Action.TeleportInfo.m_bUpdateRotation);
    }
    // End:0x4FD
    if(Action.TeleportAndOrientInfo.m_bTeleportAndOrient && !Action.TeleportInfo.m_bTeleport)
    {
        DoTeleportOrient(Action.TeleportAndOrientInfo.m_position, Action.TeleportAndOrientInfo.m_EulerRotation, Action.TeleportAndOrientInfo.m_bUseMayaCoords);
    }
    // End:0x538
    if(Action.PhysicsInfo.m_bSetPhysics)
    {
        SetPhysics(Action.PhysicsInfo.m_bOverridePhysics);
    }
    sceneNode.PlayNewScene(Action.m_animSeqName, Action.m_playCount, Action, animBlendTime);
    //return;    
}

function FinishSceneAnimation()
{
    local SPAnimSceneTemplateNode sceneNode;

    sceneNode = SPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
    // End:0x53
    if(sceneNode != none)
    {
        IndividualSceneAnimFinished(sceneNode.m_seqAct, false);
    }
    SetAIAnimControl(true);
    //return;    
}

event SceneAnimationFinished()
{
    //return;    
}

function OnEndSceneAnimation(SeqAct_EndSceneAnimation Action)
{
    local bool bSetActorCollision, bNewCollideActors, bNewBlockActors, bFindSpot;
    local SPAIController spController;

    FinishSceneAnimation();
    spController = SPAIController(Controller);
    // End:0x39
    if(spController != none)
    {
        spController.SceneFinished();
    }
    bSetActorCollision = false;
    bNewCollideActors = bCollideActors;
    bNewBlockActors = bBlockActors;
    // End:0xAA
    if(int(Action.m_bCollideWorld) != int(2))
    {
        // End:0xA2
        if(int(Action.m_bCollideWorld) == int(1))
        {
            bCollideWorld = true;
            bFindSpot = true;            
        }
        else
        {
            bCollideWorld = false;
        }
    }
    // End:0xF9
    if(int(Action.m_bCollideActors) != int(2))
    {
        bSetActorCollision = true;
        // End:0xF1
        if(int(Action.m_bCollideActors) == int(1))
        {
            bNewCollideActors = true;            
        }
        else
        {
            bNewCollideActors = false;
        }
    }
    // End:0x150
    if(int(Action.m_bBlockActors) != int(2))
    {
        bSetActorCollision = true;
        // End:0x148
        if(int(Action.m_bBlockActors) == int(1))
        {
            bNewBlockActors = true;
            bFindSpot = true;            
        }
        else
        {
            bNewBlockActors = false;
        }
    }
    // End:0x197
    if(int(Action.m_bCollideProj) != int(2))
    {
        // End:0x18F
        if(int(Action.m_bCollideProj) == int(1))
        {
            bCollideProj = true;            
        }
        else
        {
            bCollideProj = false;
        }
    }
    // End:0x1B3
    if(bSetActorCollision == true)
    {
        SetCollision(bNewCollideActors, bNewBlockActors);
    }
    // End:0x1FA
    if(int(Action.m_bPathColliding) != int(2))
    {
        // End:0x1F2
        if(int(Action.m_bPathColliding) == int(1))
        {
            bPathColliding = true;            
        }
        else
        {
            bPathColliding = false;
        }
    }
    // End:0x235
    if(Action.PhysicsInfo.m_bSetPhysics)
    {
        SetPhysics(Action.PhysicsInfo.m_bOverridePhysics);
    }
    // End:0x25D
    if(int(Action.m_bTargettable) == int(1))
    {
        DoToggleTargettable(true);        
    }
    else
    {
        // End:0x282
        if(int(Action.m_bTargettable) == int(0))
        {
            DoToggleTargettable(false);
        }
    }
    // End:0x294
    if(bFindSpot)
    {
        SetLocation(Location);
    }
    // End:0x30F
    if(SPAIController(Controller) != none)
    {
        // End:0x2DB
        if(int(Action.m_bEnableAI) == int(1))
        {
            SPAIController(Controller).DoToggleAI(true);            
        }
        else
        {
            // End:0x30F
            if(int(Action.m_bEnableAI) == int(0))
            {
                SPAIController(Controller).DoToggleAI(false);
            }
        }
    }
    //return;    
}

simulated function OnSpSetRagdoll(SeqAct_SpSetRagdollBase Action)
{
    local SPAIController SPAIController;

    SPAIController = SPAIController(Controller);
    // End:0x65
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x4F
        if(SPAIController != none)
        {
            SPAIController.EnterKismetRagdoll();
        }
        SetPhysics(0);
        EnableNovodexBoundingVolume(false);
        AttemptPhysAnimState_Ragdoll(true);        
    }
    else
    {
        // End:0xC8
        if(Action.InputLinks[1].bHasImpulse)
        {
            AttemptPhysAnimState_Fixed(true);
            SetMovementType(2);
            SetMovementPhysics();
            EnableNovodexBoundingVolume(true);
            // End:0xC8
            if(SPAIController != none)
            {
                SPAIController.ExitKismetRagdoll();
            }
        }
    }
    //return;    
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    local PlayerController PC;

    // End:0x48
    if(Mesh != none)
    {
        Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName);
    }
    // End:0xC2
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xC1
        if(NetConnection(PC.Player) != none)
        {
            PC.ClientPlayActorFaceFXAnim(self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName);
        }        
    }    
    //return;    
}

simulated function OnSpPlayFaceFXAnimNotify(SeqAct_SpPlayFaceFXAnimNotify inAction)
{
    local PlayerController PC;

    ClearLatentAction(Class'SeqAct_SpPlayFaceFXAnimNotify', true, inAction);
    // End:0x59
    if(Mesh != none)
    {
        Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName);
    }
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xD2
        if(NetConnection(PC.Player) != none)
        {
            PC.ClientPlayActorFaceFXAnim(self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName);
        }        
    }    
    //return;    
}

event ParseKismetActorFactoryOverrideParameters(KismetActorFactoryOverrideData overrideData)
{
    local SPPawnKismetActorFactoryOverrideData PawnOverrideData;

    PawnOverrideData = SPPawnKismetActorFactoryOverrideData(overrideData);
    // End:0xA2
    if(PawnOverrideData != none)
    {
        // End:0x5F
        if(PawnOverrideData.bOverrideHealth)
        {
            // End:0x5F
            if(PawnOverrideData.Health > float(0))
            {
                Health = int(PawnOverrideData.Health);                
            }
        }
        FavorWallPercentage = PawnOverrideData.FavorWallPercentage;
        // End:0x8E
        if(FavorWallPercentage < -100)
        {
            FavorWallPercentage = -100;
        }
        // End:0xA2
        if(FavorWallPercentage > 100)
        {
            FavorWallPercentage = 100;
        }
    }
    //return;    
}

simulated function OnSpAddRemoveAnimSets(SeqAct_SpAddRemoveAnimSets Action)
{
    // End:0x2C
    if(Action.bRemoveAnimSets)
    {
        RemoveAnimationSets(Action.AnimSetsToAddOrRemove);        
    }
    else
    {
        AddAnimationSets(Action.AnimSetsToAddOrRemove);
    }
    //return;    
}

simulated function ProcDynDamage(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector vDir, vWeaponSocketPos;
    local float U, V, UVAreaRatio;
    local int Count;
    local Pawn PawnDamageCauser;

    // End:0x19
    if(!WorldInfo.m_bUseDynamicDamage)
    {
        return;
    }
    // End:0x40
    if(Momentum != vect(0.0000000, 0.0000000, 0.0000000))
    {
        vDir = Normal(Momentum);        
    }
    else
    {
        // End:0x77
        if(DamageInstigator != none)
        {
            DamageInstigator.Mesh.GetSocketWorldLocationAndRotation('AimSocket', vWeaponSocketPos);            
        }
        else
        {
            // End:0xC6
            if(DamageCauser != none)
            {
                PawnDamageCauser = Pawn(DamageCauser);
                // End:0xC6
                if(PawnDamageCauser != none)
                {
                    PawnDamageCauser.Mesh.GetSocketWorldLocationAndRotation('AimSocket', vWeaponSocketPos);
                }
            }
        }
        vDir = Normal(HitLocation - vWeaponSocketPos);
    }
    mtlTestMtlInstance = TriLookup(HitLocation, HitLocation + (vDir * 999999.0000000), U, V, UVAreaRatio);
    // End:0x16F
    if((DamageType == Class'SPDamageTypeExplosionRocketLauncher') || DamageType == Class'SPDamageTypeExplosionGrenade')
    {
        Count = 0;
        J0x134:

        // End:0x16C [Loop If]
        if(Count < 13)
        {
            AddDamageMaskImpact(CurRTProxy, FRand() * float(1), FRand() * float(1), UVAreaRatio);
            Count++;
            // [Loop Continue]
            goto J0x134;
        }        
    }
    else
    {
        AddDamageMaskImpact(CurRTProxy, U, V, UVAreaRatio);
    }
    //return;    
}

simulated function InitDynDamageSystem(optional float ImpactSize)
{
    CurRTProxy = Spawn(SPRTPDamageMaskClass, self);
    CurRTProxy.Target = RTTargetSrc;
    SPRTPDamageMaskPersistent(CurRTProxy).ImageMask = m_ImpactMask;
    // End:0x70
    if(ImpactSize != float(0))
    {
        SPRTPDamageMaskPersistent(CurRTProxy).InitialImpactSize = ImpactSize;
    }
    CurSkelMeshComponent.AddRTProxy(CurRTProxy);
    CurRTProxy.SkelMeshComponent = CurSkelMeshComponent;
    InitRT();
    //return;    
}

simulated function SetRegenRate(float Val)
{
    // End:0x25
    if(CurRTProxy != none)
    {
        SPRTPDamageMaskPersistent(CurRTProxy).recoverTime = Val;
    }
    //return;    
}

simulated function MeltSkin()
{
    local SPRTPDamageMaskPersistent DmgMask;

    DmgMask = SPRTPDamageMaskPersistent(CurRTProxy);
    // End:0x2F
    if(DmgMask != none)
    {
        DmgMask.MeltSkin();
    }
    //return;    
}

simulated function InitRT()
{
    CurRTProxy.SetupRT();
    // End:0x4C
    if(WorldInfo.m_RTProxyManager == none)
    {
        WorldInfo.m_RTProxyManager = Spawn(Class'Engine.SPRTProxyManager');
    }
    WorldInfo.m_RTProxyManager.AddUniqueTarget(CurRTProxy);
    WorldInfo.m_RTProxyManager.AddTarget(CurRTProxy);
    //return;    
}

final event SetDamageZone(int ZoneIndex, bool bStatus)
{
    // End:0x79
    if((ZoneIndex >= 0) && ZoneIndex < m_damageZones.Length)
    {
        m_damageZones[ZoneIndex].bActive = bStatus;
        // End:0x5D
        if(bStatus)
        {
            m_damageZones[ZoneIndex].bForceUpdate = true;
        }
        m_damageZones[ZoneIndex].ElapsedTime = 0.0000000;
    }
    //return;    
}

function Vector GetPawnGroundPosition()
{
    local Vector HitLocation, HitNormal, traceStart, traceEnd, vFail;

    traceStart = Location + (vect(0.0000000, 0.0000000, 1.0000000) * ActorOriginHeight);
    traceEnd = Location - (vect(0.0000000, 0.0000000, 1.0000000) * float(1000));
    // End:0x6C
    if(Trace(HitLocation, HitNormal, traceEnd, traceStart, false) != none)
    {
        return HitLocation;
    }
    vFail.X = 0.0000000;
    vFail.Y = 0.0000000;
    vFail.Z = 0.0000000;
    return vFail;
    //return ReturnValue;    
}

event name GetHipBoneName()
{
    return 'JO_Hip';
    //return ReturnValue;    
}

event name GetHeadBoneName()
{
    return 'JO_head';
    //return ReturnValue;    
}

function bool CanThrowWeaponOnDeath()
{
    local PandoraGameInfo PGI;
    local SPWeapon SPWeapon;

    PGI = PandoraGameInfo(WorldInfo.Game);
    SPWeapon = SPWeapon(Weapon);
    // End:0x6B
    if((PGI != none) && SPWeapon != none)
    {
        return PGI.TryCreateSlotForTossedWeapon(SPWeapon.WeapID, Location);
    }
    return true;
    //return ReturnValue;    
}

function TossInventory(Inventory Inv, optional Vector ForceVelocity, optional class<DamageType> DamageType)
{
    local class<SPWeapon> BaseSPWeaponType;
    local Weapon Weap;
    local SPWeapon origWeapon;
    local Vector randVelOffset;
    local Rotator NewRotation;
    local int AmmoCount, AmmoInMag;

    Weap = Weapon(Inv);
    origWeapon = SPWeapon(Weap);
    // End:0x112
    if(origWeapon != none)
    {
        BaseSPWeaponType = origWeapon.GetBaseNonNPCClass();
        // End:0x112
        if(BaseSPWeaponType != none)
        {
            origWeapon.Disable('Touch');
            origWeapon.DetachWeapon();
            AmmoCount = origWeapon.AmmoCount;
            AmmoInMag = origWeapon.ammoInMagazine;
            InvManager.RemoveFromInventory(origWeapon);
            Weapon = Spawn(BaseSPWeaponType,,, origWeapon.Location, origWeapon.Rotation);
            origWeapon.Destroy();
            origWeapon = none;
            Weap = Weapon;
        }
    }
    randVelOffset.X = RandRange(-200.0000000, 200.0000000);
    randVelOffset.Y = RandRange(-200.0000000, 200.0000000);
    randVelOffset.Z = 0.0000000;
    ForceVelocity += randVelOffset;
    NewRotation = Weapon.Rotation;
    NewRotation.Yaw = Rand(65536);
    NewRotation.Roll = 32265;
    Weap.SetRotation(NewRotation);
    // End:0x203
    if(origWeapon == none)
    {
        Weap.CurrentDroppedWeaponAmmoCount = AmmoCount;
        Weap.CurrentDroppedWeaponAmmoCountInMagazine = AmmoInMag;        
    }
    else
    {
        Weap.CurrentDroppedWeaponAmmoCount = origWeapon.AmmoCount;
        Weap.CurrentDroppedWeaponAmmoCountInMagazine = origWeapon.ammoInMagazine;
    }
    super(Pawn).TossInventory(Weap, ForceVelocity, DamageType);
    //return;    
}

// Export USPPawn::execGetActorRange(FFrame&, void* const)
native final function SPPawn.EEnemyRange GetActorRange(Actor TheActor, float maxNearRange, float maxMediumRange, optional bool bCheckHeightDifference, optional float maxHeightDifference);

simulated function SPPawn.EEnemyRange GetEnemyRange(float maxNearRange, float maxMediumRange, optional bool bCheckHeightDifference, optional float maxHeightDifference)
{
    local SPPlayerReplicationInfo repInfo;

    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x20
    if(repInfo == none)
    {
        return 0;
    }
    return GetActorRange(repInfo.EnemyPawn, maxNearRange, maxMediumRange, bCheckHeightDifference, maxHeightDifference);
    //return ReturnValue;    
}

simulated function float GetMaxNearRange()
{
    return 400.0000000;
    //return ReturnValue;    
}

simulated function float GetMaxMediumRange()
{
    return 1500.0000000;
    //return ReturnValue;    
}

simulated function float GetMaxHeightDifferenceForAnimTreeRangeCheck()
{
    return 150.0000000;
    //return ReturnValue;    
}

simulated function name EnemyRangeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local SPPawn.EEnemyRange Range;

    // End:0x17
    if(bPlayedDeath)
    {
        Range = m_deathEnemyRange;        
    }
    else
    {
        Range = GetEnemyRange(GetMaxNearRange(), GetMaxMediumRange());
    }
    switch(Range)
    {
        // End:0x57
        case 0:
            return 'Melee';
            // End:0x8B
            break;
        // End:0x69
        case 1:
            return 'Medium';
            // End:0x8B
            break;
        // End:0x7B
        case 2:
            return 'Long';
            // End:0x8B
            break;
        // End:0xFFFF
        default:
            return 'Long';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x08B
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x08B    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x08B
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x08B
}

simulated function name EnemyRangeWithHeightCheckMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local SPPawn.EEnemyRange Range;

    // End:0x17
    if(bPlayedDeath)
    {
        Range = m_deathEnemyRange;        
    }
    else
    {
        Range = GetEnemyRange(GetMaxNearRange(), GetMaxMediumRange(), true, GetMaxHeightDifferenceForAnimTreeRangeCheck());
    }
    switch(Range)
    {
        // End:0x60
        case 0:
            return 'Melee';
            // End:0x94
            break;
        // End:0x72
        case 1:
            return 'Medium';
            // End:0x94
            break;
        // End:0x84
        case 2:
            return 'Long';
            // End:0x94
            break;
        // End:0xFFFF
        default:
            return 'Long';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x094
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x094    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x094
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x094
}

simulated function name GetPawnTypeName(Pawn thePawn)
{
    // End:0x15
    if(thePawn == none)
    {
        return 'None';
    }
    // End:0x152
    if(thePawn != none)
    {
        // End:0x45
        if(thePawn.IsA('SoldierPawn'))
        {
            return 'soldier';            
        }
        else
        {
            // End:0x6A
            if(thePawn.IsA('PlayerPawn'))
            {
                return 'Player';                
            }
            else
            {
                // End:0xB4
                if(thePawn.IsA('SPBaseWerewolfPawnPersistent'))
                {
                    // End:0xA7
                    if(thePawn.IsA('SPMinotaurPawnPersistent'))
                    {
                        return 'Minotaur';                        
                    }
                    else
                    {
                        return 'Werewolf';
                    }                    
                }
                else
                {
                    // End:0xD9
                    if(thePawn.IsA('SPNariPawnPersistent'))
                    {
                        return 'Nari';                        
                    }
                    else
                    {
                        // End:0xFE
                        if(thePawn.IsA('SPGriffonPawnPersistent'))
                        {
                            return 'Griffon';                            
                        }
                        else
                        {
                            // End:0x123
                            if(thePawn.IsA('SPFireDrakePawnPersistent'))
                            {
                                return 'FireDrake';                                
                            }
                            else
                            {
                                // End:0x148
                                if(thePawn.IsA('SPBloodTickPawnPersistent'))
                                {
                                    return 'BloodTick';                                    
                                }
                                else
                                {
                                    return 'Civilian';
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return 'None';
    //return ReturnValue;    
}

simulated function name GetEnemyTypeName()
{
    local SPPlayerReplicationInfo repInfo;

    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x25
    if(repInfo == none)
    {
        return 'None';
    }
    return GetPawnTypeName(repInfo.EnemyPawn);
    //return ReturnValue;    
}

simulated function name EnemyTypeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x0F
    if(bPlayedDeath)
    {
        return m_deathEnemyType;
    }
    return GetEnemyTypeName();
    //return ReturnValue;    
}

simulated function name DeathInitMCB(SPAnimGenericFunctionMonitorNode Node)
{
    //return ReturnValue;    
}

simulated function name DeathShutdownMCB(SPAnimGenericFunctionMonitorNode Node)
{
    //return ReturnValue;    
}

function HeardSound(SPPawn Pawn, Vector vLoc)
{
    // End:0x3B
    if(Controller.IsA('SPAIController'))
    {
        SPAIController(Controller).HeardSound(Pawn, vLoc);
    }
    //return;    
}

simulated function BeginSignetDraw()
{
    PerformBodyCleanup();
    //return;    
}

simulated function AbortSignetDraw()
{
    //return;    
}

function HandleBodyCleanup()
{
    local PandoraGameInfo GameInfo;
    local float SecsToKeepDeadTaxed;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0xA9
    if(GameInfo != none)
    {
        GameInfo.nDeadBodies++;
        // End:0xA9
        if(GameInfo.nDeadBodies >= m_GameplayGDTuneData.MaxNumDeadBodies)
        {
            SecsToKeepDeadTaxed = m_GameplayGDTuneData.GetSecsToKeepDeadTaxedByDamageType(LastDamageRecievedType);
            // End:0x94
            if(SecsToKeepDeadTaxed == 0.0000000)
            {
                PerformBodyCleanup();                
            }
            else
            {
                SetTimer(SecsToKeepDeadTaxed, false, 'PerformBodyCleanup');
            }
            return;
        }
    }
    SetTimer(m_GameplayGDTuneData.GetSecsToKeepDeadNormByDamageType(LastDamageRecievedType), false, 'PerformBodyCleanup');
    SetTimer(2.0000000, true, 'CheckBodyCleanupCondition');
    //return;    
}

simulated function PerformBodyCleanup()
{
    ClearTimer('PerformBodyCleanup');
    // End:0x28
    if(Controller != none)
    {
        Controller.Destroy();
    }
    // End:0x46
    if(m_AllowFadeOnDeath)
    {
        InitFadeMaterials();
        m_bStartDissolve = true;        
    }
    else
    {
        Destroy();
    }
    //return;    
}

function CheckBodyCleanupCondition()
{
    local PandoraGameInfo GameInfo;
    local float SecsToKeepDeadTaxed;

    SecsToKeepDeadTaxed = m_GameplayGDTuneData.GetSecsToKeepDeadTaxedByDamageType(LastDamageRecievedType);
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0xA6
    if(GameInfo != none)
    {
        // End:0xA6
        if(GameInfo.nDeadBodies >= m_GameplayGDTuneData.MaxNumDeadBodies)
        {
            ClearTimer('PerformBodyCleanup');
            // End:0x93
            if(SecsToKeepDeadTaxed == 0.0000000)
            {
                PerformBodyCleanup();                
            }
            else
            {
                SetTimer(SecsToKeepDeadTaxed, false, 'PerformBodyCleanup');
            }
        }
    }
    //return;    
}

simulated function InitFadeMaterials()
{
    local int I, nMaterials;

    // End:0xE4
    if(m_AllowFadeOnDeath && !m_bFadeMaterialsInitialized)
    {
        m_bFadeMaterialsInitialized = true;
        nMaterials = Mesh.SkeletalMesh.Materials.Length;
        m_FadeMIC.Remove(0, m_FadeMIC.Length);
        m_FadeMIC.Insert(0, nMaterials);
        I = 0;
        J0x5E:

        // End:0xE4 [Loop If]
        if(I < nMaterials)
        {
            m_FadeMIC[I] = new (none) Class'Engine.MaterialInstanceConstant';
            m_FadeMIC[I].SetParent(Mesh.GetMaterial(I));
            Mesh.SetMaterial(I, m_FadeMIC[I]);
            I++;
            // [Loop Continue]
            goto J0x5E;
        }
    }
    //return;    
}

simulated function bool DoFadeTick(float DeltaTime)
{
    local int I;
    local PandoraGameInfo GameInfo;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0xE0
    if(m_AllowFadeOnDeath)
    {
        m_fFadePercent -= (DeltaTime / float(2));
        // End:0x86
        if(m_fFadePercent < float(0))
        {
            m_fFadePercent = 0.0000000;
            // End:0x65
            if(Controller != none)
            {
                Controller.Destroy();
            }
            // End:0x81
            if(GameInfo != none)
            {
                GameInfo.nDeadBodies--;
            }
            Destroy();
            return false;
        }
        I = 0;
        J0x8D:

        // End:0xE0 [Loop If]
        if(I < m_FadeMIC.Length)
        {
            // End:0xD6
            if(m_FadeMIC[I] != none)
            {
                m_FadeMIC[I].SetScalarParameterValue('dissolve', m_fFadePercent);
            }
            I++;
            // [Loop Continue]
            goto J0x8D;
        }
    }
    return true;
    //return ReturnValue;    
}

function bool GetScatterDamage(out AIPhysicsDamageGroup DamageGroup)
{
    local SPTuneDataAI AITuneData;

    AITuneData = SPTuneDataAI(GetMyTuneData());
    // End:0xA3
    if(m_GDData != none)
    {
        DamageGroup.MinDamage = m_GDData.GetValue(m_GDData.ScatterDamageParams.MinDamage);
        DamageGroup.MaxDamage = m_GDData.GetValue(m_GDData.ScatterDamageParams.MaxDamage);
        return true;        
    }
    else
    {
        // End:0xC8
        if(AITuneData != none)
        {
            DamageGroup = AITuneData.ScatterDamageParams;
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

function bool GetThrowDamage(out AIPhysicsDamageGroup DamageGroup)
{
    local SPTuneDataAI AITuneData;

    AITuneData = SPTuneDataAI(GetMyTuneData());
    // End:0xA3
    if(m_GDData != none)
    {
        DamageGroup.MinDamage = m_GDData.GetValue(m_GDData.ThrowDamageParams.MinDamage);
        DamageGroup.MaxDamage = m_GDData.GetValue(m_GDData.ThrowDamageParams.MaxDamage);
        return true;        
    }
    else
    {
        // End:0xC8
        if(AITuneData != none)
        {
            DamageGroup = AITuneData.ThrowDamageParams;
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

function bool GetSmashDamage(out AIPhysicsDamageGroup DamageGroup)
{
    local SPTuneDataAI AITuneData;

    AITuneData = SPTuneDataAI(GetMyTuneData());
    // End:0xA3
    if(m_GDData != none)
    {
        DamageGroup.MinDamage = m_GDData.GetValue(m_GDData.SmashDamageParams.MinDamage);
        DamageGroup.MaxDamage = m_GDData.GetValue(m_GDData.SmashDamageParams.MaxDamage);
        return true;        
    }
    else
    {
        // End:0xC8
        if(AITuneData != none)
        {
            DamageGroup = AITuneData.SmashDamageParams;
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

function bool GetKnockawayDamage(out AIPhysicsDamageGroup DamageGroup)
{
    local SPTuneDataAI AITuneData;

    AITuneData = SPTuneDataAI(GetMyTuneData());
    // End:0xA3
    if(m_GDData != none)
    {
        DamageGroup.MinDamage = m_GDData.GetValue(m_GDData.KnockawayDamageParams.MinDamage);
        DamageGroup.MaxDamage = m_GDData.GetValue(m_GDData.KnockawayDamageParams.MaxDamage);
        return true;        
    }
    else
    {
        // End:0xC8
        if(AITuneData != none)
        {
            DamageGroup = AITuneData.KnockawayDamageParams;
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event NotifyAnimIntoRagdollBlendControl(float startRampingTime, float endRampingTime, float holdPercentage)
{
    DeathAnimationPhysicsStartTime = WorldInfo.TimeSeconds;
    DeathAnimationPhysicsStartRampingTime = startRampingTime;
    DeathAnimationPhysicsFinishRampingTime = endRampingTime;
    DeathAnimationPhysicsHoldPercentage = holdPercentage;
    // End:0x5B
    if(startRampingTime > 0.0000000)
    {
        SetTimer(startRampingTime, false, 'DeathAnimationStartAnimIntoRagdoll');        
    }
    else
    {
        DeathAnimationStartAnimIntoRagdoll();
    }
    //return;    
}

simulated function DeathAnimationStartAnimIntoRagdoll()
{
    // End:0x54
    if((int(m_PhysAnimState) == int(0)) || int(m_PhysAnimState) == int(1))
    {
        AttemptPhysAnimState_AnimIntoRagdoll(true);
        // End:0x54
        if(DeathAnimationPhysicsFinishRampingTime > 0.0000000)
        {
            SetAnimIntoRagdollBlendControl(0.0000000, DeathAnimationPhysicsFinishRampingTime - DeathAnimationPhysicsStartRampingTime, DeathAnimationPhysicsHoldPercentage);
        }
    }
    DeathAnimationPhysicsStartRampingTime = 0.0000000;
    DeathAnimationPhysicsFinishRampingTime = 0.0000000;
    DeathAnimationPhysicsHoldPercentage = 0.0000000;
    //return;    
}

function StartCATAnimation(name AnimName, bool bIsAttacker)
{
    local SPAnimSceneTemplateNode sceneNode;

    sceneNode = SPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
    // End:0x3B
    if(sceneNode == none)
    {
        return;
    }
    SetAIAnimControl(false);
    // End:0x89
    if(bIsAttacker)
    {
        sceneNode.PlayNewScene(AnimName, 1, none, 0.2500000, WorldInfo.TimeSeconds + 0.0010000);        
    }
    else
    {
        sceneNode.PlayNewScene(AnimName, 1, none, 0.2500000, WorldInfo.TimeSeconds + 0.0010000, 0);
    }
    Mesh.m_rootExtractionMode.Mode = 2;
    bCATAnimationInProgress = true;
    //return;    
}

function PerformCATAttack(SPPawn defender, CATAnimInfo inAnimationInfo)
{
    CATAttackerPawn = none;
    CATDefenderPawn = defender;
    CATAnimationInfo.attackerMoveOffset = inAnimationInfo.attackerMoveOffset;
    CATAnimationInfo.attackerYawOffset = inAnimationInfo.attackerYawOffset;
    CATAnimationInfo.attackAnimationName = inAnimationInfo.attackAnimationName;
    CATAnimationInfo.bUseExactPositioning = inAnimationInfo.bUseExactPositioning;
    CATAnimationInfo.AnimInfo = inAnimationInfo.AnimInfo;
    CATAnimationInfo.DefenseProperty = inAnimationInfo.DefenseProperty;
    CATInterpolationTimeLeft = 0.2500000;
    StartCATAnimation(CATAnimationInfo.attackAnimationName, true);
    GotoState('CATAttacker');
    //return;    
}

function PrepareForCATDefenseAnimationToStart()
{
    SetPhysics(0);
    //return;    
}

function PerformCATDefense(SPPawn attacker, CATAnimInfo inAnimationInfo)
{
    CATAttackerPawn = attacker;
    CATDefenderPawn = none;
    CATAnimationInfo.defenderMoveOffset = inAnimationInfo.defenderMoveOffset;
    CATAnimationInfo.defenderYawOffset = inAnimationInfo.defenderYawOffset;
    CATAnimationInfo.defenseAnimationName = inAnimationInfo.defenseAnimationName;
    CATAnimationInfo.bUseExactPositioning = inAnimationInfo.bUseExactPositioning;
    CATAnimationInfo.AnimInfo = inAnimationInfo.AnimInfo;
    CATAnimationInfo.DefenseProperty = inAnimationInfo.DefenseProperty;
    CATInterpolationTimeLeft = 0.2500000;
    PrepareForCATDefenseAnimationToStart();
    StartCATAnimation(CATAnimationInfo.defenseAnimationName, false);
    GotoState('CATDefender');
    //return;    
}

event AbortCATAnimation()
{
    //return;    
}

function CATAttackFinished()
{
    //return;    
}

function CATDefenseFinished()
{
    //return;    
}

function CATSignalControllerWeAreDone(bool bSucceeded)
{
    local SPAIController AIController;

    AIController = SPAIController(Controller);
    // End:0x35
    if(AIController != none)
    {
        AIController.FinishCATAttack(bSucceeded);
    }
    //return;    
}

function OnSpToggleCATAnimationAbility(SeqAct_SpToggleCATAnimationAbility Action)
{
    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bCATAnimationDisabled = false;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bCATAnimationDisabled = true;            
        }
        else
        {
            // End:0x86
            if(Action.InputLinks[2].bHasImpulse)
            {
                bCATAnimationDisabled = !bCATAnimationDisabled;
            }
        }
    }
    //return;    
}

function OnSpDebugCATAnimation(SeqAct_SpDebugCATAnimation Seq)
{
    local array<Object> objVars;
    local SPAIController defenderController, MyController;
    local SPPawn defenderPawn;

    Seq.GetObjectVars(objVars, "DefenderPawn");
    // End:0x31
    if(objVars.Length < 0)
    {
        return;
    }
    defenderPawn = SPPawn(objVars[0]);
    // End:0x87
    if(defenderPawn == none)
    {
        defenderController = SPAIController(objVars[0]);
        defenderPawn = SPPawn(defenderController.Pawn);
        // End:0x87
        if(defenderPawn == none)
        {
            return;
        }
    }
    MyController = SPAIController(Controller);
    // End:0xA4
    if(MyController == none)
    {
        return;
    }
    // End:0xC3
    if(Seq.AttackAnimation == 'None')
    {
        return;
    }
    // End:0x104
    if(CATCheckForSpecificAttack(defenderPawn, Seq.AttackAnimation, true, CATAnimationInfo))
    {
        MyController.StartCATAttack(defenderPawn, CATAnimationInfo);
    }
    //return;    
}

function CancelRegisteredDest()
{
    //return;    
}

event SceneAnimationStarted(SPAnimNodeSequence pSequence)
{
    //return;    
}

reliable client simulated event MulticastAnimBasedSingleEdge(int VertexData, Rotator StartRotation)
{
    //return;    
}

reliable client simulated event MulticastAnimBasedStart(int VertexData, Rotator StartRotation)
{
    //return;    
}

reliable client simulated event MulticastAnimBasedFinish(int VertexData)
{
    //return;    
}

reliable client simulated event MulticastAnimBasedEdge(int VertexData)
{
    //return;    
}

reliable client simulated event MulticastExactEdge(int VertexData)
{
    //return;    
}

reliable client simulated event MulticastCancelExactMode()
{
    //return;    
}

// Export USPPawn::execNewPathEdge(FFrame&, void* const)
native final function NewPathEdge(int VertexData, SPPawn.ENetEdgeType eType, Rotator StartRotation);

// Export USPPawn::execCancelClientExactMode(FFrame&, void* const)
native final function CancelClientExactMode();

// Export USPPawn::execBecameRelevantWhileAnimBased(FFrame&, void* const)
native final function BecameRelevantWhileAnimBased();

unreliable client k2call simulated event MulticastWeaponFired()
{
    WeaponFired(true);
    //return;    
}

reliable client k2call simulated event MulticastWeaponStartedFiring()
{
    WeaponFired(true);
    //return;    
}

reliable client k2call simulated event MulticastWeaponStoppedFiring()
{
    WeaponStoppedFiring(true);
    //return;    
}

simulated function FlashCountUpdated(bool bViaReplication)
{
    local SPWeapon PawnWeapon;

    // End:0x0B
    if(bViaReplication)
    {
        return;
    }
    super(Pawn).FlashCountUpdated(false);
    PawnWeapon = SPWeapon(Weapon);
    // End:0xAB
    if((int(Role) == int(ROLE_Authority)) && PawnWeapon != none)
    {
        // End:0x84
        if(int(FlashCount) > int(0))
        {
            // End:0x6F
            if(PawnWeapon.bSemiAuto)
            {
                MulticastWeaponFired();                
            }
            else
            {
                MulticastWeaponStartedFiring();
                m_bWeaponFiring = true;
            }            
        }
        else
        {
            // End:0xAB
            if(!PawnWeapon.bSemiAuto)
            {
                MulticastWeaponStoppedFiring();
                m_bWeaponFiring = false;
            }
        }
    }
    //return;    
}

simulated function InitMPColor()
{
    local int NumElems, I;

    NumElems = Mesh.GetNumElements();
    MtlInstances.Length = 0;
    MtlInstances.Insert(0, NumElems);
    I = 0;
    J0x35:

    // End:0xBB [Loop If]
    if(I < NumElems)
    {
        MtlInstances[I] = new (none) Class'Engine.MaterialInstanceConstant';
        MtlInstances[I].SetParent(Mesh.GetMaterial(I));
        Mesh.SetMaterial(I, MtlInstances[I]);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    //return;    
}

state Dying
{
    event PoppedState()
    {
        ClearTimer('CheckIfWeShouldDie');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('CheckIfWeShouldDie');
        //return;        
    }

    simulated function OnSpSetRagdoll(SeqAct_SpSetRagdollBase Action)
    {
        //return;        
    }

    function PawnDeathDestructiblePropertyCheck()
    {
        local editinline ActorDestructComponent C;

        C = GetActorDestructComponent();
        // End:0x9B
        if(C != none)
        {
            C.CauseDestruction(DeathParams.Damage, DeathParams.instigatedBy, DeathParams.HitLocation, DeathParams.Momentum, DeathParams.DamageType, DeathParams.HitInfo, DeathParams.DamageCauser);
        }
        //return;        
    }

    event Timer()
    {
        // End:0x55
        if(m_DeathTimeout == 0.0000000)
        {
            // End:0x2C
            if(PawnCorpseLifetime > 0.0000000)
            {
                m_DeathTimeout = PawnCorpseLifetime;                
            }
            else
            {
                m_DeathTimeout = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.CorpseLifetime);
            }
        }
        SetTimer(m_DeathTimeout, false, 'CheckIfWeShouldDie');
        //return;        
    }

    function CheckIfWeShouldDie()
    {
        local bool cannotDelete;
        local Pawn pPawn;
        local int NumCorpses;

        cannotDelete = false;
        // End:0x1C
        if(m_bResetDeathFromSiphon)
        {
            cannotDelete = true;            
        }
        else
        {
            // End:0x52
            if(!m_DeathTimeoutLookAtOverride && (m_GameplayGDTuneData.CanDeleteOnscreenCorpses == false) && PlayerCanSeeMe())
            {
                cannotDelete = true;                
            }
            else
            {
                pPawn = WorldInfo.PawnList;
                J0x67:

                // End:0xAB [Loop If]
                if(pPawn != none)
                {
                    // End:0x93
                    if(pPawn.IsInState('Dying'))
                    {
                        NumCorpses++;
                    }
                    pPawn = pPawn.NextPawn;
                    // [Loop Continue]
                    goto J0x67;
                }
                // End:0xDD
                if((m_DeathTimeout > 0.0000000) && NumCorpses < m_GameplayGDTuneData.MaxCorpses)
                {
                    cannotDelete = true;
                }
            }
        }
        m_DeathTimeout -= 1.0000000;
        // End:0x165
        if(cannotDelete)
        {
            // End:0x14F
            if(m_DeathTimeout <= 0.0000000)
            {
                // End:0x139
                if(m_PastDeathTimeoutCheckTime == 0.0000000)
                {
                    m_PastDeathTimeoutCheckTime = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.PastLifetimeCheckTime);
                }
                SetTimer(m_PastDeathTimeoutCheckTime, false, 'CheckIfWeShouldDie');                
            }
            else
            {
                SetTimer(1.0000000, false, 'CheckIfWeShouldDie');
            }            
        }
        else
        {
            Destroy();
        }
        //return;        
    }
    stop;    
}

state Ragdoll
{    stop;    
}

state CATAttacker
{
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

    function Cleanup()
    {
        SetAIAnimControl(true);
        CATSignalControllerWeAreDone(bCATAnimationInProgress == false);
        // End:0x4E
        if(bCATAnimationInProgress)
        {
            bCATAnimationInProgress = false;
            // End:0x4E
            if(CATDefenderPawn != none)
            {
                CATDefenderPawn.AbortCATAnimation();
            }
        }
        bPreventPhysRotation = false;
        CATAttackerPawn = none;
        CATDefenderPawn = none;
        CATAnimationInfo.AnimInfo = none;
        CATAnimationInfo.DefenseProperty = none;
        Mesh.m_rootExtractionMode.Mode = 0;
        CATAttackFinished();
        //return;        
    }

    function AbortCATAnimation()
    {
        // End:0x17
        if(bCATAnimationInProgress)
        {
            GotoState('None');
        }
        //return;        
    }

    function SceneAnimationFinished()
    {
        // End:0x1F
        if(bCATAnimationInProgress)
        {
            bCATAnimationInProgress = false;
            GotoState('None');
        }
        //return;        
    }

    event bool CanPawnUsePhysAnimStatePoking()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    bPreventPhysRotation = true;
    stop;                
}

state CATDefender
{
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

    function Cleanup()
    {
        local SPPawn attacker;

        CATSignalControllerWeAreDone(bCATAnimationInProgress == false);
        // End:0x4A
        if(bCATAnimationInProgress)
        {
            bCATAnimationInProgress = false;
            // End:0x43
            if(CATAttackerPawn != none)
            {
                CATAttackerPawn.AbortCATAnimation();
            }
            AttemptPhysAnimState_Ragdoll(true);
        }
        bPreventPhysRotation = false;
        attacker = CATAttackerPawn;
        CATAttackerPawn = none;
        CATDefenderPawn = none;
        CATAnimationInfo.AnimInfo = none;
        CATAnimationInfo.DefenseProperty = none;
        DeathAnimationPhysicsFinishRampingTime = 0.0000000;
        DeathAnimationPhysicsStartRampingTime = 0.0000000;
        Mesh.m_rootExtractionMode.Mode = 0;
        CATDefenseFinished();
        Died(((attacker != none) ? attacker.Controller : none), Class'PandoraDamageType', Location);
        //return;        
    }

    function AbortCATAnimation()
    {
        // End:0x17
        if(bCATAnimationInProgress)
        {
            GotoState('None');
        }
        //return;        
    }

    function SceneAnimationFinished()
    {
        // End:0x1F
        if(bCATAnimationInProgress)
        {
            bCATAnimationInProgress = false;
            GotoState('None');
        }
        //return;        
    }

    event bool CanPawnUsePhysAnimStatePoking()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    bTargettable = false;
    bPreventPhysRotation = true;
    J0x10:

    // End:0x2B [Loop If]
    if(int(m_PhysAnimState) != int(3))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x10;
    }
    SceneAnimationFinished();
    stop;            
}
