class Actor extends Object
    abstract
    native
    nativereplication
    hidecategories(lighting);

const MINFLOORZ = 0.7;
const RBSTATE_LINVELSCALE = 10.0;
const RBSTATE_ANGVELSCALE = 1000.0;
const ALERTLEVELS = 4;

enum EPhysics
{
    PHYS_None,                      // 0
    PHYS_Walking,                   // 1
    PHYS_Falling,                   // 2
    PHYS_Swimming,                  // 3
    PHYS_Flying,                    // 4
    PHYS_Rotating,                  // 5
    PHYS_Projectile,                // 6
    PHYS_Interpolating,             // 7
    PHYS_Spider,                    // 8
    PHYS_Ladder,                    // 9
    PHYS_RigidBody,                 // 10
    PHYS_Unused,                    // 11
    PHYS_Door,                      // 12
    PHYS_OnRope,                    // 13
    PHYS_Grenade,                   // 14
    PHYS_RootMotion,                // 15
    PHYS_MAX                        // 16
};

enum ECoverStatus
{
    COVERSTATUS_INVALID,            // 0
    COVERSTATUS_POTENTIAL,          // 1
    COVERSTATUS_VALID,              // 2
    COVERSTATUS_MAX                 // 3
};

enum ENetRole
{
    ROLE_None,                      // 0
    ROLE_SimulatedProxy,            // 1
    ROLE_AutonomousProxy,           // 2
    ROLE_Authority,                 // 3
    ROLE_MAX                        // 4
};

enum EExplosionCollisionOverride
{
    EExplosionCollisionOverride_None,// 0
    EExplosionCollisionOverride_ForceBlock,// 1
    EExplosionCollisionOverride_ForceGoThrough,// 2
    EExplosionCollisionOverride_MAX // 3
};

enum ETravelType
{
    TRAVEL_Absolute,                // 0
    TRAVEL_Partial,                 // 1
    TRAVEL_Relative,                // 2
    TRAVEL_MAX                      // 3
};

enum EDoubleClickDir
{
    DCLICK_None,                    // 0
    DCLICK_Left,                    // 1
    DCLICK_Right,                   // 2
    DCLICK_Forward,                 // 3
    DCLICK_Back,                    // 4
    DCLICK_Active,                  // 5
    DCLICK_Done,                    // 6
    DCLICK_MAX                      // 7
};

enum ER6MoveFlags
{
    MOVE_NotSpecified,              // 0
    MOVE_StandWalk,                 // 1
    MOVE_StandWalkFast,             // 2
    MOVE_StandJog,                  // 3
    MOVE_StandRun,                  // 4
    MOVE_CrouchWalk,                // 5
    MOVE_CrouchJog,                 // 6
    MOVE_Rappeling,                 // 7
    MOVE_RappelingInverted,         // 8
    MOVE_TakeCoverStandWalk,        // 9
    MOVE_TakeCoverStandWalkBackwards,// 10
    MOVE_TakeCoverCrouchWalk,       // 11
    MOVE_TakeCoverCrouchBlindFire,  // 12
    MOVE_Ladder,                    // 13
    MOVE_LadderSlide,               // 14
    MOVE_LazyWalk,                  // 15
    MOVE_MAX                        // 16
};

enum AIEventType
{
    AI_NONE,                        // 0
    AI_SEE_ENEMY_INVISIBLE,         // 1
    AI_SEE_ENEMY_BARELY,            // 2
    AI_SEE_ENEMY_PARTIALLY,         // 3
    AI_SEE_ENEMY_MOSTLY,            // 4
    AI_SEE_ENEMY_ALERT,             // 5
    AI_SEE_ENEMY_SURPRISED,         // 6
    AI_SEE_ENEMY_GOING_OUT_OF_SIGHT,// 7
    AI_SEE_ENEMY_IN_DARK,           // 8
    AI_SEE_ENEMY_BEHIND_SMOKE,      // 9
    AI_SEE_ENEMY_LOST,              // 10
    AI_SEE_ENEMY_INCOVER,           // 11
    AI_SEE_GRENADE,                 // 12
    AI_SEE_CORPSE,                  // 13
    AI_SEE_WOUNDED,                 // 14
    AI_SEE_LIGHT_TURN_OFF,          // 15
    AI_SEE_LIGHT_TURN_ON,           // 16
    AI_HEAR_QUIET_FOOTSTEP,         // 17
    AI_HEAR_HEAVY_FOOTSTEP,         // 18
    AI_HEAR_DOOR,                   // 19
    AI_HEAR_OBJECT,                 // 20
    AI_HEAR_VOICE,                  // 21
    AI_HEAR_SHATTER,                // 22
    AI_HEAR_SCREAM,                 // 23
    AI_HEAR_EXPLOSION_FRAG,         // 24
    AI_HEAR_EXPLOSION_FLASHBANG,    // 25
    AI_HEAR_EXPLOSION_SMOKE,        // 26
    AI_HEAR_EXPLOSION_EMP,          // 27
    AI_HEAR_EXPLOSION_TEAR_GAS,     // 28
    AI_HEAR_EXPLOSION_MOLOTOV,      // 29
    AI_HEAR_EXPLOSION_DETERRENT,    // 30
    AI_HEAR_EXPLOSION_INCENDIARY,   // 31
    AI_HEAR_EXPLOSION_BREACHING_CHARGE,// 32
    AI_HEAR_EXPLOSION_CLAYMORE,     // 33
    AI_HEAR_EXPLOSION_C4,           // 34
    AI_HEAR_EXPLOSION_TRIP_WIRE,    // 35
    AI_HEAR_GUNFIRE,                // 36
    AI_HEAR_RICOCHET,               // 37
    AI_HEAR_GRENADE_BOUNCE,         // 38
    AI_SHOT_JUST_MISSED,            // 39
    AI_ALARM,                       // 40
    AI_TAKE_DAMAGE,                 // 41
    AI_DESTINATION_OCCUPIED,        // 42
    AI_NEED_RELOAD,                 // 43
    AI_SHOT_BLOCKED,                // 44
    AI_PATH_BLOCKED,                // 45
    AI_BLOCKS_ANOTHER,              // 46
    AI_BLOCKS_LANDING,              // 47
    AI_HIT_ENEMY,                   // 48
    AI_REQUEST_FAILED,              // 49
    AI_COVER_LOCKED,                // 50
    AI_COVER_FOUND,                 // 51
    AI_COVER_NOT_FOUND,             // 52
    AI_COVER_ALREADY_COVERED,       // 53
    AI_CORNER_FOUND,                // 54
    AI_CORNER_NOTFOUND,             // 55
    AI_AMBUSH_FOUND,                // 56
    AI_AMBUSH_NOT_FOUND,            // 57
    AI_ADVANCE_FOUND,               // 58
    AI_ADVANCE_NOT_FOUND,           // 59
    AI_INCAPACITATED,               // 60
    AI_DEAD,                        // 61
    AI_CHANGED_DEAD,                // 62
    AI_ENEMY_DEAD,                  // 63
    AI_SEE_CIVIL_GO_PANICKED,       // 64
    AI_SEE_CIVIL_GO_CURIOUS,        // 65
    AI_SEE_CIVIL_GO_HEROIC,         // 66
    AI_KISMET_START,                // 67
    AI_KISMET_END,                  // 68
    AI_SEARCH_LIST_COMPLETE,        // 69
    AI_SEARCH_NOLIST_COMPLETE,      // 70
    AI_GOAL_COMPLETE,               // 71
    AI_GOAL_FAILURE,                // 72
    AI_PATH_NOTFOUND,               // 73
    AI_PATH_OUTOFAREA,              // 74
    AI_TEAM_THROWN_GRENADE,         // 75
    AI_INTERN_EVENTS,               // 76
    AI_TAKE_DAMAGE_OTHER_ENEMY,     // 77
    AI_UNCONSCIOUS,                 // 78
    AI_GRABBED,                     // 79
    AI_RELEASED,                    // 80
    AI_GET_DOWN,                    // 81
    AI_TEAM_LEADER_INCAPACITATED,   // 82
    AI_TACTIC_LEADER_INCAPACITATED, // 83
    AI_TEAM_LEADER_DEAD,            // 84
    AI_TACTIC_LEADER_DEAD,          // 85
    AI_COVER_BLOWUP,                // 86
    AI_SEE_ENEMY_PERIPHERAL,        // 87
    AI_REQUEST_ABORTED,             // 88
    AI_REQUEST_ENDED,               // 89
    AI_ENEMY_OUTOFFOV,              // 90
    AI_SECONDHAND_THREATENING_EVENT,// 91
    AI_SEE_THREATOBJECT_VISIBLE,    // 92
    AI_SEE_THREATOBJECT_INVISIBLE,  // 93
    AI_CONVERSATION_BROKEN,         // 94
    AI_PATH_BLOCKED_BY_FOLLOWER,    // 95
    AI_DOOR_ENCROACHING,            // 96
    AI_MAX                          // 97
};

enum ETacticType
{
    TACTIC_None,                    // 0
    TACTIC_ScriptZombie,            // 1
    TACTIC_FragAndClear,            // 2
    TACTIC_BangAndClear,            // 3
    TACTIC_Flank,                   // 4
    TACTIC_BasicTeam,               // 5
    TACTIC_Search,                  // 6
    TACTIC_Advance,                 // 7
    TACTIC_Combat,                  // 8
    TACTIC_Formation,               // 9
    TACTIC_TeamHold,                // 10
    TACTIC_TeamMoveTo,              // 11
    TACTIC_TeamTakeCover,           // 12
    TACTIC_HostageFollow,           // 13
    TACTIC_Zombie,                  // 14
    TACTIC_GuardLocation,           // 15
    TACTIC_DoorEntry,               // 16
    TACTIC_ChokeEntry,              // 17
    TACTIC_WindowEntry,             // 18
    TACTIC_ClearRoom,               // 19
    TACTIC_CoordCombat,             // 20
    TACTIC_IgnoreRainbow,           // 21
    TACTIC_Helicopter,              // 22
    TACTIC_SpecWeapon,              // 23
    TACTIC_Turret,                  // 24
    TACTIC_Snipe,                   // 25
    TACTIC_DoorAssault,             // 26
    TACTIC_WindowAssault,           // 27
    TACTIC_Civilian,                // 28
    TACTIC_InteractWith,            // 29
    TACTIC_ActionSpot,              // 30
    TACTIC_HostageWait,             // 31
    TACTIC_HostageExit,             // 32
    TACTIC_LeadHostage,             // 33
    TACTIC_GuardHostage,            // 34
    TACTIC_Unused,                  // 35
    TACTIC_Assault,                 // 36
    TACTIC_StandShoot,              // 37
    TACTIC_Patrol,                  // 38
    TACTIC_Ambush,                  // 39
    TACTIC_Investigate,             // 40
    TACTIC_TeamMoveToSOL,           // 41
    TACTIC_MAX                      // 42
};

enum EObjectiveType
{
    OBJECTIVE_None,                 // 0
    OBJECTIVE_Patrol,               // 1
    OBJECTIVE_Guard,                // 2
    OBJECTIVE_Zombie,               // 3
    OBJECTIVE_GuardLocation,        // 4
    OBJECTIVE_Formation,            // 5
    OBJECTIVE_Helicopter,           // 6
    OBJECTIVE_Asleep,               // 7
    OBJECTIVE_FollowingPatrol,      // 8
    OBJECTIVE_Waiting,              // 9
    OBJECTIVE_GuardHostage,         // 10
    OBJECTIVE_LeadHostage,          // 11
    OBJECTIVE_Unused,               // 12
    OBJECTIVE_Ambush,               // 13
    OBJECTIVE_Turret,               // 14
    OBJECTIVE_Snipe,                // 15
    OBJECTIVE_MAX                   // 16
};

enum EAnimationStep
{
    AS_PickAnimation,               // 0
    AS_WaitAnimation,               // 1
    AS_AnimationEnded,              // 2
    AS_MAX                          // 3
};

enum GoalType
{
    GOAL_None,                      // 0
    GOAL_Wait,                      // 1
    GOAL_Patrol,                    // 2
    GOAL_MoveTo,                    // 3
    GOAL_MoveToSpec,                // 4
    GOAL_MoveFromIdle,              // 5
    GOAL_Shoot,                     // 6
    GOAL_ThrowGrenade,              // 7
    GOAL_SetBreachingCharge,        // 8
    GOAL_DetonateBreachingCharge,   // 9
    GOAL_ScopeDoor,                 // 10
    GOAL_Interact,                  // 11
    GOAL_InteractWithObject,        // 12
    GOAL_InteractWithGeo,           // 13
    GOAL_UseDoor,                   // 14
    GOAL_Unused,                    // 15
    GOAL_UseGeoLedge,               // 16
    GOAL_UseHelicopter,             // 17
    GOAL_UseLadder,                 // 18
    GOAL_UseRope,                   // 19
    GOAL_UseTurret,                 // 20
    GOAL_UseWindow,                 // 21
    GOAL_Kismet,                    // 22
    GOAL_Peek,                      // 23
    GOAL_Search,                    // 24
    GOAL_ReloadWeapon,              // 25
    GOAL_SwitchWeapon,              // 26
    GOAL_CIVILWANDER,               // 27
    GOAL_CIVILROAMING,              // 28
    GOAL_CIVILPANICKED,             // 29
    GOAL_CIVILFROZEN,               // 30
    GOAL_CIVILHEROIC,               // 31
    GOAL_CIVILCURIOUS,              // 32
    GOAL_Scan,                      // 33
    GOAL_MakeCover,                 // 34
    GOAL_EnterCover,                // 35
    GOAL_ExitCover,                 // 36
    GOAL_Communicate,               // 37
    GOAL_Animation,                 // 38
    GOAL_AnimateWindow,             // 39
    GOAL_AnimateDoor,               // 40
    GOAL_Idle,                      // 41
    GOAL_StopObstructing,           // 42
    GOAL_VisionMode,                // 43
    GOAL_Snipe,                     // 44
    GOAL_InteractWithActor,         // 45
    GOAL_ToggleWeaponSuppressor,    // 46
    GOAL_MAX                        // 47
};

enum GoalStatus
{
    GS_Pending,                     // 0
    GS_Executing,                   // 1
    GS_Complete,                    // 2
    GS_Failure,                     // 3
    GS_MAX                          // 4
};

enum EValidToActorReturn
{
    EVAR_True,                      // 0
    EVAR_False,                     // 1
    EVAR_Pending,                   // 2
    EVAR_MAX                        // 3
};

enum EAttractorType
{
    ATTRACTOR_NONE,                 // 0
    ATTRACTOR_Standard,             // 1
    ATTRACTOR_Enhanced,             // 2
    ATTRACTOR_MAX                   // 3
};

struct TimerData
{
    var bool bLoop;
    var name FuncName;
    var float Rate;
    var float Count;

    structdefaultproperties
    {
        bLoop=false
        FuncName="None"
        Rate=0.0000000
        Count=0.0000000
    }
};

struct SAutoAimInfluence
{
    var string m_szName;
    var Vector m_vPosition;
    var float m_fWeight;

    structdefaultproperties
    {
        m_szName=""
        m_vPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fWeight=0.0000000
    }
};

struct SLimbHPInfo
{
    var() int m_iHealth;
    var() float m_fMultiplier;

    structdefaultproperties
    {
        m_iHealth=0
        m_fMultiplier=0.0000000
    }
};

struct SLocationBasedHitPoints
{
    var() SLimbHPInfo m_Head;
    var() SLimbHPInfo m_Chest;
    var() SLimbHPInfo m_LeftArm;
    var() SLimbHPInfo m_RightArm;
    var() SLimbHPInfo m_LeftLeg;
    var() SLimbHPInfo m_RightLeg;

    structdefaultproperties
    {
        m_Head=(m_iHealth=0,m_fMultiplier=0.0000000)
        m_Chest=(m_iHealth=0,m_fMultiplier=0.0000000)
        m_LeftArm=(m_iHealth=0,m_fMultiplier=0.0000000)
        m_RightArm=(m_iHealth=0,m_fMultiplier=0.0000000)
        m_LeftLeg=(m_iHealth=0,m_fMultiplier=0.0000000)
        m_RightLeg=(m_iHealth=0,m_fMultiplier=0.0000000)
    }
};

struct ConvexShape
{
    var array<Vector> m_aWorldPos;
    var Vector m_vCenter;
    var float m_fRadius;
    var float m_fMaxHeight;

    structdefaultproperties
    {
        m_aWorldPos=none
        m_vCenter=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fRadius=0.0000000
        m_fMaxHeight=0.0000000
    }
};

struct PointRegion
{
    var() editconst ZoneInfo Zone;
    var() editconst Level m_pLevel;
    var() editconst int iLeaf;
    var() editconst byte ZoneNumber;
    var transient bool m_bFromZoningVolume;

    structdefaultproperties
    {
        Zone=none
        m_pLevel=none
        iLeaf=0
        ZoneNumber=0
        m_bFromZoningVolume=false
    }
};

struct TraceHitInfo
{
    var Material Material;
    var PhysicalMaterial PhysMaterial;
    var int Item;
    var name BoneName;
    var export editinline PrimitiveComponent HitComponent;
    var MaterialInstance MaterialInst;

    structdefaultproperties
    {
        Material=none
        PhysMaterial=none
        Item=0
        BoneName="None"
        HitComponent=none
        MaterialInst=none
    }
};

struct ImpactInfo
{
    var Actor HitActor;
    var Vector HitSourceLocation;
    var Vector HitLocation;
    var Vector HitNormal;
    var Vector RayDir;
    var TraceHitInfo HitInfo;
    var bool bLastImpact;
    var bool m_bDamaged;

    structdefaultproperties
    {
        HitActor=none
        HitSourceLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RayDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitInfo=(Material=none,PhysMaterial=none,Item=0,BoneName="None",HitComponent=none,MaterialInst=none)
        bLastImpact=false
        m_bDamaged=false
    }
};

struct RigidBodyState
{
    var Vector Position;
    var Quat Quaternion;
    var Vector LinVel;
    var Vector AngVel;
    var int bNewData;

    structdefaultproperties
    {
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Quaternion=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        LinVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        AngVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bNewData=0
    }
};

struct EAIEvent
{
    var Actor.AIEventType m_eEventType;
    var Actor.GoalType m_eGoalType;
    var name m_nGoalID;
    var Vector m_vEventLocation;
    var Actor m_pEventTarget;
    var Class m_damageType;

    structdefaultproperties
    {
        m_eEventType=0
        m_eGoalType=0
        m_nGoalID="None"
        m_vEventLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pEventTarget=none
        m_damageType=none
    }
};

struct sPIPInfo
{
    var Vector vLocation;
    var Rotator rRotation;
    var float fAspectRatio;
    var float fFov;
    var R6EngineEnums.EVisionMode EVisionMode;
    var bool bDistortionEnable;
    var float fDistortionStrength;
    var float fDistortionScale;

    structdefaultproperties
    {
        vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        rRotation=(Pitch=0,Yaw=0,Roll=0)
        fAspectRatio=0.0000000
        fFov=0.0000000
        EVisionMode=0
        bDistortionEnable=false
        fDistortionStrength=1.5000000
        fDistortionScale=1.6000000
    }
};

var native const Guid m_Guid;
var bool m_bTransfertDamageToBase;
var(MPModes) bool m_bUnloadForDeathMatch;
var(MPModes) bool m_bUnloadForTeamDeathMatch;
var(MPModes) bool m_bUnloadForAttackDefend;
var(MPModes) bool m_bUnloadForConquest;
var(MPModes) bool m_bUnloadForAssassination;
var(MPModes) bool m_bUnloadForRetrieval;
var(MPModes) bool m_bUnloadForStory;
var(MPModes) bool m_bUnloadForTerroristHunt;
var(MPModes) bool m_bUnloadForSoloStory;
var(MPModes) bool m_bUnloadForSoloTerroristHunt;
var const bool bStatic;
var(Advanced) bool bHidden;
var const bool bNoDelete;
var const bool bDeleteMe;
var bool bOnlyOwnerSee;
var bool bStasis;
var bool bWorldGeometry;
var bool bIgnoreVehicles;
var bool bOrientOnSlope;
var const bool bOnlyAffectPawns;
var const bool bIgnoreEncroachers;
var bool m_bSpawned;
var bool m_bShutdown;
var bool m_bSavedHidden;
var bool m_bSavedCollideActors;
var bool m_bSavedBlockActors;
var(lighting) bool m_bForceCastStaticShadow;
var(lighting) const bool m_bSkipNormalLights;
var bool m_bIsDynamicObstacle;
var(Advanced) bool m_bIsDynamicCover;
var const bool bNetTemporary;
var bool bOnlyRelevantToOwner;
var bool bAlwaysRelevant;
var bool bReplicateInstigator;
var bool bReplicateMovement;
var bool bSkipActorPropertyReplication;
var bool bUpdateSimulatedPosition;
var bool bTearOff;
var bool bOnlyDirtyReplication;
var const bool bNetInitialRotation;
var const bool bClientAuthoritative;
var bool bReplicatePredictedVelocity;
var bool bReplicateRigidBodyLocation;
var bool bBadStateCode;
var bool bDebug;
var bool m_bScriptNoCollisionSet;
var bool m_bScriptOldCollideActors;
var bool m_bScriptOldBlockActors;
var bool m_bLifeSpanDontDeleteWhileRender;
var(R6SoundPropagation) /*0x04000000-0x00000000*/ bool m_bDynamicOccluder;
var bool m_bTeminateRBPhysicsWhenStable;
var bool m_bYawIsLocked;
var(Attachment) bool bHardAttach;
var(Display) const bool UseCharacterLights;
var const bool UsePawnLights;
var bool m_bInteractDisabled;
var bool bHurtEntry;
var bool bGameRelevant;
var bool bTravel;
var const bool bMovable;
var bool bDestroyInPainVolume;
var bool bCanBeDamaged;
var bool bShouldBaseAtStartup;
var bool bPendingDelete;
var bool bCanTeleport;
var const bool bAlwaysTick;
var(Collision) bool m_bCanSeeThrough;
var(Collision) bool m_bCanSeeThroughButNotOrderThrough;
var(Collision) bool m_bCanFireThrough;
var(Collision) bool bCollideWhenPlacing;
var(Collision) const bool bCollideActors;
var(Collision) bool bCollideWorld;
var(Collision) bool bBlockActors;
var bool bProjTarget;
var bool bBlocksTeleport;
var(Collision) const bool bCollideSB;
var(Advanced) bool m_bTickOnlyWhenVisible;
var(Display) bool m_bUseSingleZoneVisibility;
var(Display) bool m_bUseSingleZoneStreaming;
var(Display) bool m_bForceStreaming;
var(Collision) bool bNoEncroachCheck;
var bool bIgnoreOutOfWorld;
var bool bBounce;
var const bool bJustTeleported;
var const bool bNetInitial;
var const bool bNetOwner;
var(Advanced) bool bHiddenEd;
var(Advanced) bool bHiddenEdGroup;
var(Advanced) bool bEdShouldSnap;
var(Collision) bool bPathColliding;
var bool bScriptInitialized;
var(Advanced) bool bLockLocation;
var bool bNoSelect;
var bool m_bPlayerUseAsCam;
var bool m_bDeleteOnReset;
var bool m_bSnakeCamRelevant;
var bool m_bIsNPCPawn;
var const bool m_bIsDoor;
var(NavMeshGeneration) const bool m_bIgnoreForNavMesh;
var(NavMeshGeneration) const bool m_bDoNotClimbOnMe;
var(NavMeshGeneration) const bool m_bDirectInsertInNavMesh;
var(Heat) float m_fHeat;
var const export editinline array<export editinline ActorComponent> Components;
var private const export editinline transient array<export editinline ActorComponent> AllComponents;
var(Movement) const Actor.EPhysics Physics;
var Actor.ENetRole RemoteRole;
var Actor.ENetRole Role;
var R6EngineEnums.ESoundSurfaceType m_eSoundSurfaceType;
var const R6EngineEnums.EAnimNotify m_eLatentAnimNotify;
var(Collision) Actor.EExplosionCollisionOverride m_eExplosionCollisionOverride;
var const Object.ETickingGroup TickGroup;
var array<R6EngineEnums.EExplosionEffectType> m_supportedExplosionEffects;
var const Actor Owner;
var(Attachment) const Actor Base;
var const array<TimerData> Timers;
var const transient bool bTicked;
var transient bool m_ConvexShapeCollisionCachedOnFire;
var const transient bool bNetDirty;
var transient bool m_bAlwaysUpdate;
var transient bool bEdSnap;
var const transient bool bTempEditor;
var transient bool bPathTemp;
var transient bool m_bSerializeForCheckpoint;
var transient array<ConvexShape> m_ConvexShapeCollisionChached;
var transient Vector m_ConvexShapeCollisionChachedLocation;
var transient Rotator m_ConvexShapeCollisionChachedRotation;
var transient array<ConvexShape> m_ConvexShapeCoverChached;
var transient Vector m_ConvexShapeCoverChachedLocation;
var transient Rotator m_ConvexShapeCoverChachedRotation;
var const transient int NetTag;
var float NetUpdateTime;
var float NetUpdateFrequency;
var float NetPriority;
var repnotify Pawn Instigator;
var const transient WorldInfo WorldInfo;
var float LifeSpan;
var const float CreationTime;
var int m_iDynOccId;
var(R6Sound) /*0x04000000-0x00000000*/ export editinline R6SoundComponent m_R6Sound;
var(Region) const editconst transient PointRegion Region;
var transient float LastRenderTime;
var transient int m_iLastRenderTick;
var(Object) name Tag;
var name InitialState;
var(Object) name Group;
var const transient array<Actor> Touching;
var const Actor Deleted;
var const float LatentFloat;
var const AnimNodeSequence LatentSeqNode;
var const Actor m_AnimActor;
var const transient PhysicsVolume PhysicsVolume;
var(Movement) const Vector Location;
var(Movement) const Rotator Rotation;
var Vector Velocity;
var Vector Acceleration;
var int m_iLockedYaw;
var int m_iUpdatedYaw;
var(Attachment) export editinline SkeletalMeshComponent BaseSkelComponent;
var(Attachment) name BaseBoneName;
var const array<Actor> Attached;
var const Vector RelativeLocation;
var const Rotator RelativeRotation;
var(Display) interp const float DrawScale;
var(Display) interp const Vector DrawScale3D;
var(Display) const Vector PrePivot;
var(Collision) export editinline PrimitiveComponent CollisionComponent;
var(Collision) float m_fBulletGoThrough;
var native int OverlapTag;
var float Mass;
var float Buoyancy;
var(Movement) Rotator RotationRate;
var(Movement) Rotator DesiredRotation;
var Actor PendingTouch;
var(Advanced) EdLayer Layer;
var class<LocalMessage> MessageClass;
var const array< class<SequenceEvent> > SupportedEvents;
var const array<SequenceEvent> GeneratedEvents;
var array<SeqAct_Latent> LatentActions;
var(CubemapSample) R6CubemapSample m_FirstNearest;
var(CubemapSample) R6CubemapSample m_SecondNearest;
var float m_fRatio;
var TextureCube m_Cubemap0;
var TextureCube m_Cubemap1;
var int m_iNearestTriangleIndex;
var int m_iNearestZoneIndex;

replication
{
    // Pos:0x000
    if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && ((int(RemoteRole) == int(ROLE_AutonomousProxy)) && bNetInitial) || ((int(RemoteRole) == int(ROLE_SimulatedProxy)) && bNetInitial || bUpdateSimulatedPosition) && ((Base == none) || Base.bWorldGeometry) || int(Physics) == int(13))
        Location, Rotation;

    // Pos:0x096
    if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && int(RemoteRole) == int(ROLE_SimulatedProxy))
        Base;

    // Pos:0x0C6
    if(((((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && int(RemoteRole) == int(ROLE_SimulatedProxy)) && Base != none) && !Base.bWorldGeometry)
        RelativeLocation, RelativeRotation;

    // Pos:0x119
    if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && (int(RemoteRole) == int(ROLE_SimulatedProxy)) && bNetInitial || bUpdateSimulatedPosition)
        Physics, Velocity;

    // Pos:0x15F
    if((((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && int(RemoteRole) == int(ROLE_SimulatedProxy)) && int(Physics) == int(5))
        DesiredRotation, RotationRate;

    // Pos:0x1A1
    if((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority))
        bHardAttach, bHidden;

    // Pos:0x1C6
    if(((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty)
        bOnlyOwnerSee;

    // Pos:0x1F6
    if((((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty) && bCollideActors || bCollideWorld)
        bBlockActors, bProjTarget;

    // Pos:0x23C
    if((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority))
        RemoteRole, Role, 
        bNetOwner, bTearOff;

    // Pos:0x261
    if((((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty) && bReplicateInstigator)
        Instigator;

    // Pos:0x29C
    if(((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty)
        DrawScale, PrePivot, 
        bCollideActors, bCollideWorld;

    // Pos:0x2CC
    if(((bNetOwner && !bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty)
        Owner;

    // Pos:0x307
    if(int(Role) == int(ROLE_Authority))
        m_bDeleteOnReset, m_bInteractDisabled, 
        m_bIsNPCPawn;
}

event EndEvent()
{
    return;
}

event Trigger(Actor other, Pawn EventInstigator, optional name EventID)
{
    return;
}

event TriggerEvent(name EventName, Actor other, Pawn EventInstigator, optional name EventID)
{
    local Actor A;

    // End:0x23
    if((EventName == 'None') || EventName == 'None')
    {
        return;
    }
    // End:0x6B
    foreach DynamicActors(Class'Actor', A)
    {
        // End:0x6A
        if(EventName == A.Tag)
        {
            A.Trigger(other, EventInstigator, EventID);
        }        
    }    
    return;
}

simulated function bool IsPlayerPawn()
{
    return false;
    return;
}

// Export UActor::execGetCameraConfig(FFrame&, void* const)
native static final function R6CameraConfig GetCameraConfig();

// Export UActor::execGetControlsConfig(FFrame&, void* const)
native static final function R6ControlsConfig GetControlsConfig();

// Export UActor::execGetTakeCoverConfig(FFrame&, void* const)
native static final function R6TakeCoverConfig GetTakeCoverConfig();

// Export UActor::execGetMiscConfig(FFrame&, void* const)
native static final function R6MiscConfig GetMiscConfig();

// Export UActor::execGetHealthConfig(FFrame&, void* const)
native static final function R6HealthConfig GetHealthConfig();

// Export UActor::execGetVisualConfig(FFrame&, void* const)
native static final function R6VisualConfig GetVisualConfig();

// Export UActor::execGetWeaponsConfig(FFrame&, void* const)
native static final function R6WeaponsConfig GetWeaponsConfig();

// Export UActor::execGetAccuracyConfig(FFrame&, void* const)
native static final function R6AccuracyConfig GetAccuracyConfig();

// Export UActor::execGetDamageConfig(FFrame&, void* const)
native static final function R6DamageConfig GetDamageConfig();

// Export UActor::execGetPlayerOptions(FFrame&, void* const)
native static final function R6PlayerOptions GetPlayerOptions();

// Export UActor::execGetImpactConfig(FFrame&, void* const)
native static final function R6ImpactConfig GetImpactConfig();

// Export UActor::execGetRapellingConfig(FFrame&, void* const)
native static final function R6RapellingConfig GetRapellingConfig();

// Export UActor::execGetHandSignalsConfig(FFrame&, void* const)
native static final function R6HandSignalsConfig GetHandSignalsConfig();

// Export UActor::execGetRainbowConfig(FFrame&, void* const)
native static final function R6RainbowConfig GetRainbowConfig();

// Export UActor::execGetAIConfig(FFrame&, void* const)
native static final function R6AIConfig GetAIConfig();

// Export UActor::execGetDifficultyConfig(FFrame&, void* const)
native static final function R6DifficultyConfig GetDifficultyConfig();

// Export UActor::execGetInteractLocationsConfig(FFrame&, void* const)
native static final function R6InteractLocationsConfig GetInteractLocationsConfig();

// Export UActor::execGetGadgetsConfig(FFrame&, void* const)
native static final function R6GadgetsConfig GetGadgetsConfig();

// Export UActor::execGetInteractLengthsConfig(FFrame&, void* const)
native static final function R6InteractLengthsConfig GetInteractLengthsConfig();

// Export UActor::execGetFPPWalkthroughConfig(FFrame&, void* const)
native static final function R6FPPWalkthroughConfig GetFPPWalkthroughConfig();

// Export UActor::execGetRadarConfig(FFrame&, void* const)
native static final function R6RadarConfig GetRadarConfig();

// Export UActor::execGetGlobalPostProcessConfigCollection(FFrame&, void* const)
native static final function R6PostProcessConfigCollection GetGlobalPostProcessConfigCollection();

// Export UActor::execGetLocalPostProcessConfigCollection(FFrame&, void* const)
native static final function R6PostProcessConfigCollection GetLocalPostProcessConfigCollection(int iLevelIndex);

// Export UActor::execGetGameManager(FFrame&, void* const)
native static final function R6AbstractGameManager GetGameManager();

// Export UActor::execAllowBloodStains(FFrame&, void* const)
native function bool AllowBloodStains();

// Export UActor::execUnloadInventorySounds(FFrame&, void* const)
native function UnloadInventorySounds(Object pInventory);

// Export UActor::execShouldTakeDamage(FFrame&, void* const)
native function bool ShouldTakeDamage(PrimitiveComponent pHitComponent, Actor pDamageSource);

// Export UActor::execOnCauseDamage(FFrame&, void* const)
native function OnCauseDamage(SeqAct_CauseDamage Action);

// Export UActor::execIsConvexShapeCacheValid(FFrame&, void* const)
native static final function bool IsConvexShapeCacheValid(bool bCollision);

// Export UActor::execInvalidateConvexShapeCache(FFrame&, void* const)
native static final function InvalidateConvexShapeCache();

// Export UActor::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command, optional bool bWriteToLog);

// Export UActor::execSleep(FFrame&, void* const)
native(256) final latent function Sleep(float Seconds);

// Export UActor::execFinishAnim(FFrame&, void* const)
native(261) final latent function FinishAnim(AnimNodeSequence SeqNode);

// Export UActor::execWaitForAnimNotify(FFrame&, void* const)
native final latent function WaitForAnimNotify(R6EngineEnums.EAnimNotify eNotify, Actor AnimActor);

// Export UActor::execGetClimbHeight(FFrame&, void* const)
native simulated function float GetClimbHeight();

// Export UActor::execEnableBlockingVolume(FFrame&, void* const)
native simulated function EnableBlockingVolume(bool bVal, Pawn pPawn);

// Export UActor::execHasSpaceToClimb(FFrame&, void* const)
native simulated function bool HasSpaceToClimb(Pawn pPawn);

// Export UActor::execSetGAnimTreeSkelComponent(FFrame&, void* const)
native final function SetGAnimTreeSkelComponent(SkeletalMeshComponent Mesh);

// Export UActor::execGetGAnimTreeSkelComponent(FFrame&, void* const)
native final function SkeletalMeshComponent GetGAnimTreeSkelComponent();

// Export UActor::execGetCenter(FFrame&, void* const)
native function Vector GetCenter();

// Export UActor::execSetCollision(FFrame&, void* const)
native(262) final function SetCollision(optional bool NewColActors, optional bool NewBlockActors);

// Export UActor::execSetCollisionSize(FFrame&, void* const)
native(283) final function SetCollisionSize(float NewRadius, float NewHeight);

// Export UActor::execSetDrawScale(FFrame&, void* const)
native final function SetDrawScale(float NewScale);

// Export UActor::execSetDrawScale3D(FFrame&, void* const)
native final function SetDrawScale3D(Vector NewScale3D);

// Export UActor::execSetPrePivot(FFrame&, void* const)
native final function SetPrePivot(Vector NewPrePivot);

// Export UActor::execOnlyAffectPawns(FFrame&, void* const)
native final function OnlyAffectPawns(bool bNewAffectPawns);

// Export UActor::execMove(FFrame&, void* const)
native(266) final function bool Move(Vector Delta);

// Export UActor::execSetLocation(FFrame&, void* const)
native(267) final function bool SetLocation(Vector NewLocation, optional bool bNoCollision);

// Export UActor::execSetRotation(FFrame&, void* const)
native(299) final function bool SetRotation(Rotator NewRotation, optional bool bNoCollision);

// Export UActor::execSetYaw(FFrame&, void* const)
native final function SetYaw(int iYaw);

// Export UActor::execSetRelativeRotation(FFrame&, void* const)
native final function bool SetRelativeRotation(Rotator NewRotation);

// Export UActor::execSetRelativeLocation(FFrame&, void* const)
native final function bool SetRelativeLocation(Vector NewLocation);

// Export UActor::execMoveSmooth(FFrame&, void* const)
native(3969) final function bool MoveSmooth(Vector Delta);

// Export UActor::execAutonomousPhysics(FFrame&, void* const)
native(3971) final function AutonomousPhysics(float DeltaSeconds);

// Export UActor::execSetBase(FFrame&, void* const)
native(298) final function SetBase(Actor NewBase, optional Vector NewFloor, optional SkeletalMeshComponent SkelComp, optional name BoneName);

// Export UActor::execSetOwner(FFrame&, void* const)
native(272) final function SetOwner(Actor NewOwner);

// Export UActor::execIsBasedOn(FFrame&, void* const)
native final function bool IsBasedOn(Actor TestActor);

// Export UActor::execIsOwnedBy(FFrame&, void* const)
native final function bool IsOwnedBy(Actor TestActor);

simulated event ReplicatedEvent(name VarName)
{
    return;
}

// Export UActor::execDrawDebugLine(FFrame&, void* const)
native final function DrawDebugLine(Vector LineStart, Vector LineEnd, byte R, byte G, byte B);

// Export UActor::execDrawDebugBox(FFrame&, void* const)
native final function DrawDebugBox(Vector Center, Vector Extent, byte R, byte G, byte B);

// Export UActor::execDrawPersistentDebugLine(FFrame&, void* const)
native final function DrawPersistentDebugLine(Vector LineStart, Vector LineEnd, byte R, byte G, byte B);

// Export UActor::execFlushPersistentDebugLines(FFrame&, void* const)
native final function FlushPersistentDebugLines();

// Export UActor::execChartData(FFrame&, void* const)
native final function ChartData(string DataName, float DataValue);

// Export UActor::execDrawCoordinateSystem(FFrame&, void* const)
native final function DrawCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines);

// Export UActor::execSetPhysics(FFrame&, void* const)
native(3970) final function SetPhysics(Actor.EPhysics newPhysics);

// Export UActor::execClock(FFrame&, void* const)
native final function Clock(out float Time);

// Export UActor::execUnClock(FFrame&, void* const)
native final function UnClock(out float Time);

// Export UActor::execAttachComponent(FFrame&, void* const)
native final function AttachComponent(ActorComponent NewComponent);

// Export UActor::execDetachComponent(FFrame&, void* const)
native final function DetachComponent(ActorComponent ExComponent);

// Export UActor::execSetTickGroup(FFrame&, void* const)
native final function SetTickGroup(Object.ETickingGroup NewTickGroup);

// Export UActor::execRemoveComponent(FFrame&, void* const)
native final function RemoveComponent(ActorComponent componentToRemove);

// Export UActor::execGetInteractDistance(FFrame&, void* const)
native function float GetInteractDistance(Pawn pPawn);

// Export UActor::execGetAffectingLightsParameter(FFrame&, void* const)
native final function GetAffectingLightsParameter(out float Parameter, optional bool bSkipPawnLights);

// Export UActor::execOnR6AttachPropActor(FFrame&, void* const)
native function OnR6AttachPropActor(SeqAct_R6AttachPropActor theAction);

// Export UActor::execOnR6DetachPropActor(FFrame&, void* const)
native function OnR6DetachPropActor(SeqAct_R6AttachPropActor theAction);

// Export UActor::execStopMatineesOnActor(FFrame&, void* const)
native final function StopMatineesOnActor(SeqAct_Interp InterpAction);

// Export UActor::execHasMatineePlaying(FFrame&, void* const)
native final function bool HasMatineePlaying();

// Export UActor::execGetMesh(FFrame&, void* const)
native function MeshComponent GetMesh();

event Destroyed()
{
    return;
}

event GainedChild(Actor other)
{
    return;
}

event LostChild(Actor other)
{
    return;
}

event Tick(float DeltaTime)
{
    return;
}

// Export UActor::execHitWall(FFrame&, void* const)
native function HitWall(Vector vHitNormal, Actor pWall, Vector vLocation);

// Export UActor::execTouch(FFrame&, void* const)
native function Touch(Actor other, PrimitiveComponent Component, Vector vHitLocation, Vector vHitNormal);

// Export UActor::execUnTouch(FFrame&, void* const)
native function UnTouch(Actor other);

event Timer()
{
    return;
}

event Falling()
{
    return;
}

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    return;
}

event ZoneChange(ZoneInfo NewZone)
{
    return;
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    return;
}

event PostTouch(Actor other)
{
    return;
}

event Bump(Actor other, PrimitiveComponent Component, Vector HitNormal)
{
    return;
}

event BaseChange()
{
    return;
}

event Attach(Actor other)
{
    return;
}

event Detach(Actor other)
{
    return;
}

event Actor SpecialHandling(Pawn other)
{
    return;
}

event bool EncroachingOn(Actor other)
{
    return;
}

event EncroachedBy(Actor other)
{
    return;
}

event RanInto(Actor other)
{
    return;
}

// Export UActor::execClampRotation(FFrame&, void* const)
native final simulated function bool ClampRotation(out Rotator out_Rot, Rotator rBase, Rotator rUpperLimits, Rotator rLowerLimits);

simulated event bool OverRotated(out Rotator out_Desired, out Rotator out_Actual)
{
    return;
}

event bool UsedBy(Pawn User)
{
    local int idx, activatedCnt;
    local SeqEvent_Used usedEvent;

    idx = 0;
    J0x07:

    // End:0x6D [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        usedEvent = SeqEvent_Used(GeneratedEvents[idx]);
        // End:0x63
        if((usedEvent != none) && usedEvent.bEnabled)
        {
            ActivateEvent(usedEvent, User);
            activatedCnt++;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return activatedCnt > 0;
    return;
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    SetPhysics(0);
    bHidden = true;
    SetCollision(false, false);
    Destroy();
    return;
}

// Export UActor::execTrace(FFrame&, void* const)
native(277) final function Actor Trace(out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent, optional out TraceHitInfo HitInfo, optional bool bTracePhysicsVolumes);

// Export UActor::execTraceComponent(FFrame&, void* const)
native final function bool TraceComponent(out Vector HitLocation, out Vector HitNormal, PrimitiveComponent InComponent, Vector TraceEnd, optional Vector TraceStart, optional Vector Extent, optional out TraceHitInfo HitInfo);

// Export UActor::execFastTrace(FFrame&, void* const)
native(548) final function bool FastTrace(Vector TraceEnd, optional Vector TraceStart);

// Export UActor::execContainsPoint(FFrame&, void* const)
native final function bool ContainsPoint(Vector Spot);

// Export UActor::execTouchingActor(FFrame&, void* const)
native final function bool TouchingActor(Actor A);

// Export UActor::execGetComponentsBoundingBox(FFrame&, void* const)
native final function GetComponentsBoundingBox(out Box ActorBox);

// Export UActor::execGetBoundingCylinder(FFrame&, void* const)
native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

// Export UActor::execSpawn(FFrame&, void* const)
native(278) final function Actor Spawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail);

// Export UActor::execDestroy(FFrame&, void* const)
native(279) final function bool Destroy();

event TornOff()
{
    return;
}

// Export UActor::execSetTimer(FFrame&, void* const)
native(280) final function SetTimer(float inRate, optional bool inbLoop, optional name inTimerFunc);

// Export UActor::execClearTimer(FFrame&, void* const)
native final function ClearTimer(optional name inTimerFunc);

// Export UActor::execIsTimerActive(FFrame&, void* const)
native final function bool IsTimerActive(optional name inTimerFunc);

// Export UActor::execGetTimerCount(FFrame&, void* const)
native final function float GetTimerCount(optional name inTimerFunc);

// Export UActor::execGetTimerRate(FFrame&, void* const)
native final function float GetTimerRate(optional name TimerFuncName);

// Export UActor::execCreateAudioComponent(FFrame&, void* const)
native final function AudioComponent CreateAudioComponent(SoundCue InSoundCue, optional bool bPlay, optional bool bStopWhenOwnerDestroyed, optional R6EngineEnums.ESoundSlot ESoundSlot);

// Export UActor::execPlaySound(FFrame&, void* const)
native final function AudioComponent PlaySound(SoundCue InSoundCue, R6EngineEnums.ESoundSlot ESoundSlot, optional bool bUseOwnerLocation, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation);

// Export UActor::execStopSound(FFrame&, void* const)
native final function StopSound(SoundCue InSoundCue, optional float fFadeDuration);

// Export UActor::execFindAudioComponents(FFrame&, void* const)
native final function FindAudioComponents(out array<editinline AudioComponent> vAudioComponents);

// Export UActor::execMakeNoise(FFrame&, void* const)
native(512) final function MakeNoise(float Radius, optional Actor.AIEventType nType, optional Vector NoiseLoc, optional Actor NoiseMaker);

// Export UActor::execPlayerCanSeeMe(FFrame&, void* const)
native(532) final function bool PlayerCanSeeMe();

// Export UActor::execSuggestTossVelocity(FFrame&, void* const)
native final function bool SuggestTossVelocity(out Vector TossVelocity, Vector Destination, Vector Start, float TossSpeed, optional float BaseTossZ, optional float DesiredZPct, optional Vector CollisionSize);

event bool PreTeleport(Teleporter InTeleporter)
{
    return;
}

event PostTeleport(Teleporter OutTeleporter)
{
    return;
}

// Export UActor::execGetURLMap(FFrame&, void* const)
native(547) final function string GetURLMap();

// Export UActor::execGetCoverStatus(FFrame&, void* const)
native function Actor.ECoverStatus GetCoverStatus();

// Export UActor::execAllActors(FFrame&, void* const)
native(304) final iterator function AllActors(class<Actor> BaseClass, out Actor Actor);

// Export UActor::execDynamicActors(FFrame&, void* const)
native(313) final iterator function DynamicActors(class<Actor> BaseClass, out Actor Actor);

// Export UActor::execChildActors(FFrame&, void* const)
native(305) final iterator function ChildActors(class<Actor> BaseClass, out Actor Actor);

// Export UActor::execBasedActors(FFrame&, void* const)
native(306) final iterator function BasedActors(class<Actor> BaseClass, out Actor Actor);

// Export UActor::execTouchingActors(FFrame&, void* const)
native(307) final iterator function TouchingActors(class<Actor> BaseClass, out Actor Actor);

// Export UActor::execTraceActors(FFrame&, void* const)
native(309) final iterator function TraceActors(class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, Vector End, optional Vector Start, optional Vector Extent);

// Export UActor::execVisibleActors(FFrame&, void* const)
native(311) final iterator function VisibleActors(class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc);

// Export UActor::execVisibleCollidingActors(FFrame&, void* const)
native(312) final iterator function VisibleCollidingActors(class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden);

// Export UActor::execCollidingActors(FFrame&, void* const)
native(321) final iterator function CollidingActors(class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc);

// Export UActor::execOverlappingActors(FFrame&, void* const)
native final iterator function OverlappingActors(class<Actor> BaseClass, out Actor out_Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden);

// Export UActor::execComponentList(FFrame&, void* const)
native final iterator function ComponentList(Class BaseClass, out ActorComponent out_Component);

// Export UActor::execAllOwnedComponents(FFrame&, void* const)
native final iterator function AllOwnedComponents(class<Component> BaseClass, out ActorComponent OutComponent);

// Export UActor::execLocalPlayerControllers(FFrame&, void* const)
native final iterator function LocalPlayerControllers(out PlayerController PC);

final function bool FindActorsOfClass(class<Actor> ActorClass, out array<Actor> out_Actors)
{
    local Actor TestActor;

    out_Actors.Length = 0;
    // End:0x2B
    foreach AllActors(ActorClass, TestActor)
    {
        out_Actors[out_Actors.Length] = TestActor;        
    }    
    return out_Actors.Length > 0;
    return;
}

// Export UActor::execSubtract_ColorColor(FFrame&, void* const)
native(549) static final operator(20) Color -(Color A, Color B);

// Export UActor::execMultiply_FloatColor(FFrame&, void* const)
native(550) static final operator(16) Color *(float A, Color B);

// Export UActor::execAdd_ColorColor(FFrame&, void* const)
native(551) static final operator(20) Color +(Color A, Color B);

// Export UActor::execMultiply_ColorFloat(FFrame&, void* const)
native(552) static final operator(16) Color *(Color A, float B);

event RecoverFromBadStateCode()
{
    return;
}

simulated event GotoStateSafe(name NewState, optional name NewLabel)
{
    GotoState(NewState, NewLabel);
    return;
}

event PreBeginPlay()
{
    // End:0x6A
    if(((!bGameRelevant && !bStatic) && int(WorldInfo.NetMode) != int(NM_Client)) && !WorldInfo.Game.CheckRelevance(self))
    {
        // End:0x67
        if(bNoDelete)
        {
            ShutDown();            
        }
        else
        {
            Destroy();
        }
    }
    return;
}

event BroadcastLocalizedMessage(class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    WorldInfo.Game.BroadcastLocalized(self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    return;
}

event PreResetCleanup()
{
    return;
}

event SaveOriginalData()
{
    return;
}

event ResetOriginalData()
{
    return;
}

simulated event SetDeleteOnReset(bool bVal)
{
    m_bDeleteOnReset = bVal;
    return;
}

reliable client simulated event ClientSetDeleteOnReset(bool bVal)
{
    SetDeleteOnReset(bVal);
    return;
}

event PostBeginPlay()
{
    return;
}

event PreLoadGame()
{
    return;
}

event PostLoadGame()
{
    return;
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x24
    if(InitialState != 'None')
    {
        GotoState(InitialState);        
    }
    else
    {
        GotoState('Auto');
    }
    return;
}

simulated event ConstraintBrokenNotify(name ConstraintName, Actor ConstraintOwner, Vector ConstrainLocation)
{
    return;
}

simulated function bool HurtRadius(float fDistMaxDam, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController)
{
    local Actor Victim;
    local bool bCausedDamage;

    ((Instigator != none) ? Instigator.Controller : none);
    // End:0x2C
    if(bHurtEntry)
    {
        return false;
    }
    bHurtEntry = true;
    bCausedDamage = false;
    // End:0xE4
    foreach VisibleCollidingActors(Class'Actor', Victim, DamageRadius, HurtOrigin)
    {
        // End:0xE3
        if(((Victim != self) && Victim != IgnoredActor) && int(Victim.Role) == int(ROLE_Authority))
        {
            Victim.TakeRadiusDamage(InstigatedByController, fDistMaxDam, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, false);
            bCausedDamage = bCausedDamage || Victim.bProjTarget;
        }        
    }    
    bHurtEntry = false;
    return bCausedDamage;
    return;
}

simulated event bool IsAutoAimable(Pawn aimingPawn)
{
    return false;
    return;
}

event GetAutoAimInfluences(out array<SAutoAimInfluence> autoAimInfluences)
{
    local SAutoAimInfluence actorInfluence;

    actorInfluence.m_szName = string(Name);
    actorInfluence.m_vPosition = Location;
    actorInfluence.m_fWeight = 1.0000000;
    autoAimInfluences[autoAimInfluences.Length] = actorInfluence;
    return;
}

event KilledBy(Pawn EventInstigator)
{
    return;
}

// Export UActor::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int iDamage, int iMaxDamage, Controller pEventInstigator, Vector vHitSourceLocation, Vector vHitLocation, Vector vMomentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

// Export UActor::execTakeRadiusDamage(FFrame&, void* const)
native function TakeRadiusDamage(Controller pInstigatedBy, float fDistMaxDam, float fBaseDamage, float fDamageRadius, class<DamageType> pDamageType, float fMomentum, Vector vHurtOrigin, bool bFullDamage);

simulated event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
    return;
}

// Export UActor::execCheckHitInfo(FFrame&, void* const)
native final simulated function CheckHitInfo(out TraceHitInfo HitInfo, PrimitiveComponent FallBackComponent, Vector vDir, out Vector vOut_HitLocation);

// Export UActor::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

function DebugFreezeGame()
{
    local PlayerController PC;

    ScriptTrace();
    // End:0x3B
    foreach LocalPlayerControllers(PC)
    {        
        PC.ConsoleCommand("PlayersOnly");        
        return;        
    }    
    return;
}

function bool CheckForErrors()
{
    return;
}

function bool CheckForDeprecated()
{
    return;
}

event BecomeViewTarget(PlayerController PC)
{
    return;
}

event EndViewTarget(PlayerController PC)
{
    return;
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector HitNormal;
    local float Radius, Height;

    GetBoundingCylinder(Radius, Height);
    // End:0x6C
    if(Trace(out_CamLoc, HitNormal, Location - ((Vector(out_CamRot) * Radius) * float(20)), Location, false) == none)
    {
        out_CamLoc = Location - ((Vector(out_CamRot) * Radius) * float(20));        
    }
    else
    {
        out_CamLoc = Location + (Height * Vector(Rotation));
    }
    return false;
    return;
}

simulated function string GetItemName(string FullName)
{
    local int pos;

    pos = InStr(FullName, ".");
    J0x10:

    // End:0x50 [Loop If]
    if(pos != -1)
    {
        FullName = Right(FullName, (Len(FullName) - pos) - 1);
        pos = InStr(FullName, ".");
        // [Loop Continue]
        goto J0x10;
    }
    return FullName;
    return;
}

simulated event string GetHumanReadableName()
{
    return GetItemName(string(Class));
    return;
}

static function ReplaceText(out string Text, string Replace, string With)
{
    local int I;
    local string Input;

    Input = Text;
    Text = "";
    I = InStr(Input, Replace);
    J0x25:

    // End:0x85 [Loop If]
    if(I != -1)
    {
        Text = (Text $ Left(Input, I)) $ With;
        Input = Mid(Input, I + Len(Replace));
        I = InStr(Input, Replace);
        // [Loop Continue]
        goto J0x25;
    }
    Text = Text $ Input;
    return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return "";
    return;
}

function MatchStarting()
{
    return;
}

function SetGRI(GameReplicationInfo GRI)
{
    return;
}

function string GetDebugName()
{
    return GetItemName(string(self));
    return;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Actor A;
    local float MyRadius, MyHeight;
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.SetDrawColor(byte(255), 0, 0);
    T = GetDebugName();
    // End:0x86
    if(bDeleteMe)
    {
        T = T $ " DELETED (bDeleteMe == true)";
    }
    // End:0xC9
    if(T != "")
    {
        Canvas.__NFUN_465__(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    // End:0x2B7
    if(HUD.ShouldDisplayDebug("net"))
    {
        // End:0x2B7
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            T = "ROLE ";
            switch(Role)
            {
                // End:0x145
                case ROLE_None:
                    T = T $ "None";
                    // End:0x1B3
                    break;
                // End:0x16A
                case 1:
                    T = T $ "SimulatedProxy";
                    // End:0x1B3
                    break;
                // End:0x190
                case 2:
                    T = T $ "AutonomousProxy";
                    // End:0x1B3
                    break;
                // End:0x1B0
                case 3:
                    T = T $ "Authority";
                    // End:0x1B3
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            T = T $ " REMOTE ROLE ";
            switch(RemoteRole)
            {
                // End:0x1F1
                case ROLE_None:
                    T = T $ "None";
                    // End:0x25F
                    break;
                // End:0x216
                case 1:
                    T = T $ "SimulatedProxy";
                    // End:0x25F
                    break;
                // End:0x23C
                case 2:
                    T = T $ "AutonomousProxy";
                    // End:0x25F
                    break;
                // End:0x25C
                case 3:
                    T = T $ "Authority";
                    // End:0x25F
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x280
            if(bTearOff)
            {
                T = T $ " Tear Off";
            }
            Canvas.__NFUN_465__(T, false);
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    // End:0x4D6
    if(HUD.ShouldDisplayDebug("physics"))
    {
        T = (((((("Physics" @ (GetPhysicsName())) @ "in physicsvolume") @ (GetItemName(string(PhysicsVolume)))) @ "on base") @ (GetItemName(string(Base)))) @ "gravity") @ string(GetGravityZ());
        // End:0x366
        if(bBounce)
        {
            T = T $ " - will bounce";
        }
        Canvas.__NFUN_465__(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__((("Location: " $ string(Location)) $ " Rotation ") $ string(Rotation), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__((((("Velocity: " $ string(Velocity)) $ " Speed ") $ string(VSize(Velocity))) $ " Speed2D ") $ string(VSize(Velocity - (Velocity.Z * vect(0.0000000, 0.0000000, 1.0000000)))), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__("Acceleration: " $ string(Acceleration), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x6F7
    if(HUD.ShouldDisplayDebug("collision"))
    {
        Canvas.DrawColor.B = 0;
        GetBoundingCylinder(MyRadius, MyHeight);
        Canvas.__NFUN_465__((("Collision Radius " $ string(MyRadius)) $ " Height ") $ string(MyHeight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__((((("Collides with Actors " $ string(bCollideActors)) $ ", world ") $ string(bCollideWorld)) $ ", proj. target ") $ string(bProjTarget));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__("Blocks Actors " $ string(bBlockActors));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        T = "Touching ";
        // End:0x692
        foreach TouchingActors(Class'Actor', A)
        {
            T = (T $ (GetItemName(string(A)))) $ " ";            
        }        
        // End:0x6C0
        if(T == "Touching ")
        {
            T = "Touching nothing";
        }
        Canvas.__NFUN_465__(T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    Canvas.DrawColor.B = byte(255);
    Canvas.__NFUN_465__(" STATE: " $ string(GetStateName()), false);
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.__NFUN_465__(((" Instigator:" @ (GetItemName(string(Instigator)))) @ "Owner:") @ (GetItemName(string(Owner))));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    return;
}

simulated function string GetPhysicsName()
{
    switch(Physics)
    {
        // End:0x16
        case 0:
            return "None";
            // End:0x11D
            break;
        // End:0x28
        case 1:
            return "Walking";
            // End:0x11D
            break;
        // End:0x3A
        case 2:
            return "Falling";
            // End:0x11D
            break;
        // End:0x4D
        case 3:
            return "Swimming";
            // End:0x11D
            break;
        // End:0x5E
        case 4:
            return "Flying";
            // End:0x11D
            break;
        // End:0x71
        case 5:
            return "Rotating";
            // End:0x11D
            break;
        // End:0x86
        case 6:
            return "Projectile";
            // End:0x11D
            break;
        // End:0x9E
        case 7:
            return "Interpolating";
            // End:0x11D
            break;
        // End:0xAF
        case 8:
            return "Spider";
            // End:0x11D
            break;
        // End:0xC0
        case 9:
            return "Ladder";
            // End:0x11D
            break;
        // End:0xD4
        case 10:
            return "RigidBody";
            // End:0x11D
            break;
        // End:0xE5
        case 11:
            return "Unused";
            // End:0x11D
            break;
        // End:0xF4
        case 12:
            return "Door";
            // End:0x11D
            break;
        // End:0x105
        case 13:
            return "OnRope";
            // End:0x11D
            break;
        // End:0x11A
        case 15:
            return "RootMotion";
            // End:0x11D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function PlaySoundAt(SoundCue ASound, Vector SourceLocation, R6EngineEnums.ESoundSlot ESoundSlot)
{
    local editinline AudioComponent AC;

    // End:0x0D
    if(ASound == none)
    {
        return;
    }
    AC = WorldInfo.CreateAudioComponent(ASound, false, true, ESoundSlot);
    AC.bUseOwnerLocation = false;
    AC.Location = SourceLocation;
    AC.bAutoDestroy = true;
    AC.Play();
    return;
}

function bool IsInVolume(Volume aVolume)
{
    local Volume V;

    // End:0x23
    foreach TouchingActors(Class'Volume', V)
    {
        // End:0x22
        if(V == aVolume)
        {            
            return true;
        }        
    }    
    return false;
    return;
}

function bool IsInPain()
{
    local PhysicsVolume V;

    // End:0x3E
    foreach TouchingActors(Class'PhysicsVolume', V)
    {
        // End:0x3D
        if(V.bPainCausing && V.DamagePerSec > float(0))
        {            
            return true;
        }        
    }    
    return false;
    return;
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
    return;
}

simulated function bool CanSplash()
{
    return false;
    return;
}

simulated function bool CheckMaxEffectDistance(PlayerController P, Vector SpawnLocation, optional float CullDistance)
{
    local float Dist;

    // End:0x17
    if(P.ViewTarget == none)
    {
        return true;
    }
    Dist = VSize(SpawnLocation - P.ViewTarget.Location);
    // End:0x6D
    if((CullDistance > float(0)) && CullDistance < (Dist * P.m_fFOVBias))
    {
        return false;
    }
    return !P.BeyondFogDistance(P.ViewTarget.Location, SpawnLocation);
    return;
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    local PlayerController P;
    local bool bResult;

    // End:0x21
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return bForceDedicated;
    }
    // End:0x45
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        bResult = true;        
    }
    else
    {
        // End:0x69
        if((Instigator != none) && Instigator.IsHumanControlled())
        {
            return true;            
        }
        else
        {
            // End:0x9D
            if(SpawnLocation == Location)
            {
                bResult = (WorldInfo.TimeSeconds - LastRenderTime) < float(2);                
            }
            else
            {
                // End:0xD9
                if((Instigator != none) && (WorldInfo.TimeSeconds - Instigator.LastRenderTime) < float(3))
                {
                    bResult = true;
                }
            }
        }
    }
    // End:0x1C9
    if(bResult)
    {
        bResult = false;
        // End:0x1C8
        foreach LocalPlayerControllers(P)
        {
            // End:0x1C7
            if(P.ViewTarget != none)
            {
                // End:0x137
                if((P.Pawn == Instigator) && Instigator != none)
                {                    
                    return true;
                    // End:0x1C7
                    continue;
                }
                // End:0x1A7
                if((Vector(P.Rotation) Dot (SpawnLocation - P.ViewTarget.Location)) < 0.0000000)
                {
                    bResult = VSize(P.ViewTarget.Location - SpawnLocation) < float(1600);
                    // End:0x1C8
                    break;
                    // End:0x1C7
                    continue;
                }
                bResult = CheckMaxEffectDistance(P, SpawnLocation, CullDistance);
                // End:0x1C8
                break;
            }            
        }        
    }
    return bResult;
    return;
}

final simulated function float TimeSince(float Time)
{
    return WorldInfo.TimeSeconds - Time;
    return;
}

final simulated function float WorldTime()
{
    return WorldInfo.TimeSeconds;
    return;
}

event TriggerEventClass(class<SequenceEvent> InEventClass, Actor InInstigator)
{
    ActivateEventClass(InEventClass, InInstigator, GeneratedEvents);
    return;
}

// Export UActor::execActivateEvent(FFrame&, void* const)
native final function bool ActivateEvent(SequenceEvent inEvent, Actor InInstigator);

// Export UActor::execActivateEventClass(FFrame&, void* const)
native final function bool ActivateEventClass(class<SequenceEvent> inClass, Actor InInstigator, array<SequenceEvent> EventList);

final function bool FindEventsOfClass(class<SequenceEvent> eventClass, out array<SequenceEvent> out_EventList)
{
    local int idx;
    local bool bFoundEvent;

    idx = 0;
    J0x07:

    // End:0xC5 [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        // End:0xBB
        if((ClassIsChildOf(GeneratedEvents[idx].Class, eventClass) && GeneratedEvents[idx].bEnabled) && (GeneratedEvents[idx].MaxTriggerCount == 0) || GeneratedEvents[idx].MaxTriggerCount > GeneratedEvents[idx].TriggerCount)
        {
            out_EventList[out_EventList.Length] = GeneratedEvents[idx];
            bFoundEvent = true;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return bFoundEvent;
    return;
}

event ClearLatentAction(class<SeqAct_Latent> actionClass, optional bool bAborted, optional SeqAct_Latent exceptionAction)
{
    local int idx;

    idx = 0;
    J0x09:

    // End:0xA9 [Loop If]
    if(idx < LatentActions.Length)
    {
        // End:0x3B
        if(LatentActions[idx] == none)
        {
            LatentActions.Remove(idx--, 1);
            // [Explicit Continue]
            goto J0x9F;
        }
        // End:0x9F
        if(ClassIsChildOf(LatentActions[idx].Class, actionClass) && LatentActions[idx] != exceptionAction)
        {
            // End:0x91
            if(bAborted)
            {
                LatentActions[idx].AbortFor(self);
            }
            LatentActions.Remove(idx--, 1);
        }
        J0x9F:

        idx++;
        // [Loop Continue]
        goto J0x09;
    }
    return;
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
    // End:0x2E
    if(bNoDelete || int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ShutDown();        
    }
    else
    {
        // End:0x3C
        if(!bDeleteMe)
        {
            Destroy();
        }
    }
    return;
}

simulated function ShutDown()
{
    SetPhysics(0);
    SetCollision(false, false);
    // End:0x25
    if(CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(false);
    }
    bHidden = true;
    bStasis = true;
    bTearOff = true;
    return;
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local int idx;
    local Actor destActor;
    local Controller C;

    Action.GetObjectVars(objVars, "Destination");
    idx = 0;
    J0x28:

    // End:0xAA [Loop If]
    if((idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[idx]);
        C = Controller(destActor);
        // End:0xA0
        if((C != none) && C.Pawn != none)
        {
            destActor = C.Pawn;
        }
        idx++;
        // [Loop Continue]
        goto J0x28;
    }
    // End:0xFC
    if((destActor != none) && SetLocation(destActor.Location))
    {
        PlayTeleportEffect(false, true);
        // End:0xF9
        if(Action.bUpdateRotation)
        {
            SetRotation(destActor.Rotation);
        }        
    }
    else
    {
        WarnInternal("Unable to teleport to" @ string(destActor));
    }
    return;
}

simulated function OnSetBlockRigidBody(SeqAct_SetBlockRigidBody Action)
{
    // End:0x60
    if(CollisionComponent != none)
    {
        // End:0x37
        if(Action.InputLinks[0].bHasImpulse)
        {
            CollisionComponent.SetBlockRigidBody(true);            
        }
        else
        {
            // End:0x60
            if(Action.InputLinks[1].bHasImpulse)
            {
                CollisionComponent.SetBlockRigidBody(false);
            }
        }
    }
    return;
}

simulated function OnSetRigidBodyIgnoreVehicles(SeqAct_SetRigidBodyIgnoreVehicles Action)
{
    // End:0x60
    if(CollisionComponent != none)
    {
        // End:0x37
        if(Action.InputLinks[0].bHasImpulse)
        {
            CollisionComponent.SetRigidBodyIgnoreVehicles(true);            
        }
        else
        {
            // End:0x60
            if(Action.InputLinks[1].bHasImpulse)
            {
                CollisionComponent.SetRigidBodyIgnoreVehicles(false);
            }
        }
    }
    return;
}

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    SetPhysics(Action.newPhysics);
    return;
}

function OnChangeCollision(SeqAct_ChangeCollision Action)
{
    SetCollision(Action.bCollideActors, Action.bBlockActors);
    return;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        bHidden = true;        
    }
    else
    {
        // End:0x48
        if(Action.InputLinks[1].bHasImpulse)
        {
            bHidden = false;            
        }
        else
        {
            bHidden = !bHidden;
        }
    }
    // End:0x82
    if(int(RemoteRole) == int(ROLE_None))
    {
        RemoteRole = ROLE_SimulatedProxy;
        bAlwaysRelevant = true;
        NetUpdateFrequency = 0.1000000;
    }
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    return;
}

function OnAttachToActor(SeqAct_AttachToActor Action)
{
    local int idx;
    local Actor Attachment;
    local Controller C;
    local array<Object> objVars;

    Action.GetObjectVars(objVars, "Attachment");
    idx = 0;
    J0x27:

    // End:0x13D [Loop If]
    if((idx < objVars.Length) && Attachment == none)
    {
        Attachment = Actor(objVars[idx]);
        C = Controller(Attachment);
        // End:0x9F
        if((C != none) && C.Pawn != none)
        {
            Attachment = C.Pawn;
        }
        // End:0x133
        if(Attachment != none)
        {
            // End:0xCF
            if(Action.bDetach)
            {
                Attachment.SetBase(none);
                // [Explicit Continue]
                goto J0x133;
            }
            C = Controller(self);
            // End:0x122
            if((C != none) && C.Pawn != none)
            {
                C.Pawn.DoKismetAttachment(Attachment, Action);
                // [Explicit Continue]
                goto J0x133;
            }
            DoKismetAttachment(Attachment, Action);
        }
        J0x133:

        idx++;
        // [Loop Continue]
        goto J0x27;
    }
    return;
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors, bOldBlockActors;

    // End:0xEB
    if(Action.bUseRelativeOffset || Action.bUseRelativeRotation)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(false, false);
        // End:0x95
        if(Action.bUseRelativeRotation)
        {
            Attachment.SetRotation(Rotation + Action.RelativeRotation);
        }
        // End:0xD3
        if(Action.bUseRelativeOffset)
        {
            Attachment.SetLocation(Location + (Vector(Rotation) * Action.RelativeOffset));
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors);
    }
    Attachment.SetBase(self);
    return;
}

event BeginAnimControl(array<AnimSet> InAnimSets)
{
    return;
}

event SetAnimPosition(out R6ScriptedAnimInfo AnimInfo, bool bFireNotifies)
{
    return;
}

event NotifyAnimPaused(bool bPaused, name AnimToPause)
{
    return;
}

event FinishAnimControl(bool bFacialAnim, name LastAnimPlayed)
{
    return;
}

function bool IsStationary()
{
    return true;
    return;
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = Location;
    out_Rotation = Rotation;
    return;
}

// Export UActor::execIsPlayerOwned(FFrame&, void* const)
native final function bool IsPlayerOwned();

function PawnBaseDied()
{
    return;
}

simulated event byte GetTeamNum()
{
    return byte(255);
    return;
}

simulated function byte GetRadarIcon()
{
    return byte(255);
    return;
}

simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return "";
    return;
}

simulated function NotifyLocalPlayerTeamReceived()
{
    return;
}

simulated function Vector GetTargetLocation()
{
    return Location;
    return;
}

event SpawnedByKismet()
{
    return;
}

function PickedUpBy(Pawn P)
{
    return;
}

simulated function logd(coerce string S, optional name LogTag)
{
    return;
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction)
{
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    // End:0x38
    if(InterpAction.m_bStopMatineesPlayingOnActor)
    {
        StopMatineesOnActor(InterpAction);
    }
    return;
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    return;
}

event InterpGroupAttached(SeqAct_Interp InterpAction, name GroupName)
{
    return;
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
    return;
}

simulated function DecalComponent AddDecal(MaterialInstance DecalMaterial, Vector DecalLocation, Rotator DecalRotation, float Width, float Height, float Thickness, bool bNoClip, PrimitiveComponent HitComponent, DecalLifetimeData LifetimeData)
{
    local editinline DecalComponent Decal;

    // End:0x148
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        Decal = new (Outer) Class'DecalComponent';        
        AttachComponent(Decal);
        Decal.Location = DecalLocation;
        Decal.Orientation = DecalRotation;
        Decal.Width = Width;
        Decal.Height = Height;
        Decal.Thickness = Thickness;
        Decal.FarPlane = Decal.Thickness * 0.5000000;
        Decal.NearPlane = -Decal.FarPlane;
        Decal.bNoClip = bNoClip;
        Decal.HitComponent = HitComponent;
        Decal.LifetimeData = LifetimeData;
        Decal.SetDecalMaterial(DecalMaterial);
        Decal.Finalize();
        return Decal;
    }
    return;
}

simulated event GetPIPInfo(out sPIPInfo pipInfo)
{
    pipInfo.vLocation = Location;
    pipInfo.rRotation = Rotation;
    pipInfo.fFov = 59.8400000;
    pipInfo.EVisionMode = 0;
    pipInfo.bDistortionEnable = false;
    return;
}

// Export UActor::execGetDamageMultiplierFor(FFrame&, void* const)
native function float GetDamageMultiplierFor(name BoneName);

function OnR6DisableCollision(SeqAct_R6DisableCollision Action)
{
    // End:0x3C
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x39
        if(m_bScriptNoCollisionSet)
        {
            SetCollision(m_bScriptOldCollideActors, m_bScriptOldBlockActors);
            m_bScriptNoCollisionSet = false;
        }        
    }
    else
    {
        // End:0x87
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x87
            if(!m_bScriptNoCollisionSet)
            {
                m_bScriptOldCollideActors = bCollideActors;
                m_bScriptOldBlockActors = bBlockActors;
                m_bScriptNoCollisionSet = true;
                SetCollision(false, false);
            }
        }
    }
    return;
}

// Export UActor::execGetInteractLocation(FFrame&, void* const)
native function Vector GetInteractLocation(Pawn pPawn, optional bool bUseLoc, optional Vector vPos);

// Export UActor::execGetInteractRotation(FFrame&, void* const)
native function Rotator GetInteractRotation(Pawn pPawn);

// Export UActor::execIsInteractRotationGood(FFrame&, void* const)
native function bool IsInteractRotationGood(Pawn pPawn);

// Export UActor::execCanInteract(FFrame&, void* const)
native function bool CanInteract(Pawn pInteractor, optional bool bUseLoc, optional Vector vPos);

// Export UActor::execNeedsMoveToInteract(FFrame&, void* const)
native function bool NeedsMoveToInteract(Pawn pPawn);

// Export UActor::execCenterControllerWhenUsing(FFrame&, void* const)
native function bool CenterControllerWhenUsing();

// Export UActor::execMoveToFP(FFrame&, void* const)
native function bool MoveToFP(Pawn pPawn);

// Export UActor::execPreInteract(FFrame&, void* const)
native function PreInteract(Pawn pPawn);

// Export UActor::execInteract(FFrame&, void* const)
native function Interact(Pawn pInteractor);

// Export UActor::execSpecialInteraction(FFrame&, void* const)
native function bool SpecialInteraction(Pawn pPawn, Vector vHitLocation);

simulated function bool BlocksView()
{
    return;
}

simulated function bool DisableCameraMoveWhileUsing()
{
    return BlocksView();
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    eDesc = 0;
    return false;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    eDesc = 0;
    return false;
    return;
}

function OnR6DisableInteraction(SeqAct_R6DisableInteraction Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bInteractDisabled = false;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bInteractDisabled = true;
        }
    }
    return;
}

event InteractFailure(Pawn pInteractor)
{
    local int idx;
    local SeqEvent_R6InteractFailure usedEvent;

    idx = 0;
    J0x07:

    // End:0x66 [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        usedEvent = SeqEvent_R6InteractFailure(GeneratedEvents[idx]);
        // End:0x5C
        if((usedEvent != none) && usedEvent.bEnabled)
        {
            ActivateEvent(usedEvent, pInteractor);
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function TriggerInteractSuccessEvent(Pawn pInteractor)
{
    local int idx;
    local SeqEvent_R6InteractSuccess usedEvent;

    idx = 0;
    J0x07:

    // End:0x66 [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        usedEvent = SeqEvent_R6InteractSuccess(GeneratedEvents[idx]);
        // End:0x5C
        if((usedEvent != none) && usedEvent.bEnabled)
        {
            ActivateEvent(usedEvent, pInteractor);
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

event InteractSuccesful(Pawn pInteractor)
{
    TriggerInteractSuccessEvent(pInteractor);
    return;
}

simulated function float GetViewFOV()
{
    return 0.0000000;
    return;
}

// Export UActor::execShutdownActor(FFrame&, void* const)
native function bool ShutdownActor();

defaultproperties
{
    bReplicateMovement=true
    bMovable=true
    bJustTeleported=true
    m_bDeleteOnReset=true
    m_bDoNotClimbOnMe=true
    // Reference: SpriteComponent'Default__Actor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Sprite" class=Class'SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Role=3
    m_eSoundSurfaceType=9
    NetUpdateFrequency=30.0000000
    NetPriority=1.0000000
    DrawScale=1.0000000
    DrawScale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    Mass=100.0000000
    MessageClass=Class'LocalMessage'
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    m_iNearestTriangleIndex=-1
    m_iNearestZoneIndex=-1
}