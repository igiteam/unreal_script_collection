/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class TPActorFactoryAI extends ActorFactoryAI
	config(Editor)
	hidecategories(NotUsedByBARPH)
	dependson(TPSpawnPoint)
	native;

//***********************************************************************
// INCLUDES
//***********************************************************************

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************


enum ESpPointSelection
{
	/** Try each spawn point in a linear method */
	PointSelection_Normal,
	/** Pick the first available randomly selected point */
	PointSelection_Random,
	/** PS_Normal, but in reverse */
	PointSelection_Reverse,
};

struct native Close_Quaters_Combat_Data
{
	var () float m_RangeToStartCQB_State;
	var () float m_SpeedToChargeScale;
	var () float m_AdditionalMeleeRangeOfAttack;
	var () bool	 m_bAbleToMeleeAttacks;
	var () int m_AdditionalMeleeAttackDamage;
	var () float m_AdditionalMeleeHitForce;
	var () float m_MeleeWaitToFailTime;
	var () float m_DelayBetweenStartOfMeleeStateAndTheAttackStart;
	var () float m_OverridePercentOfMagToBlowThroughBeforeCharge;
	var () float m_HowOfftenInSecsToCheck_LOS_ForBlow;
	var () bool	m_bNotAllowedToEverNoMatterWhatDoMeleeAttack;
};


struct native EngagementTacData
{
	var () bool	m_bAllowTacticalSteping;
};


struct native Danger_Awareness
{
	var () float	m_GrenadeOutRangeOfInterest;
	var () float	m_DangerAwarenessThreshold;
	var () bool		m_bReactToGrenades;
	var () bool		m_bReactToGrenadesByRunningAway;
	var () float	m_ChanceOfReactingToGrenadesByRunningAway;
	var () bool		m_bReactToGrenadesByJumpingOverCover;
	var () float	m_ChanceOfReactingToGrenadesByJumpingOverCover;
	var () bool		m_bReactToGrenadesByCowering;
	var () float	m_ChanceOfReactingToGrenadesByCowering;
	var () bool		m_bReactToGrenadesByThrowingBack;
	var () float	m_ChanceOfReactingToGrenadesByThrowingBack;
	var () float	m_TimeReactingToInitialGrenadeOut;
	var () float	m_TimeReactingToGrenadesByCowering;
	var () float	m_RangeOfReactingToGrenadesByThrowingBack;
	var	() float	m_HotGrenTossBackThrowForceFactor;
	var	() float	m_HotGrenTossBackThrowZForce;
	var () float	m_ChanceToPerformInitialReactingToGrenadeOut;
	var () float	m_ChanceToTurnTowardsGrenDuringInitialReactingToGrenadeOut;
	var () float	m_SpeedToRunAwayScale;
};

struct native Audio_Sensory
{
	var ()	float m_SmallArmsBulletImpactRangeOfInterest;
	var ()	float m_SmallArmsFiringRangeOfInterest;
	var ()	float m_GrenadeExplodingRangeOfInterest;
	var ()	float m_NormalExplodingRangeOfInterest;
	var ()	float m_NormalExplodingDefaultRangeOfInterest;
	var ()	float m_WalkingFootFallsRangeOfInterest;
	var ()	float m_RunningFootFallsRangeOfInterest;
	var ()	float m_CrouchingFootFallsRangeOfInterest;
	var ()	float m_FeetScuffiingRangeOfInterest;
	var ()	float m_HumanJumpingRangeOfInterest;
	var ()	float m_HumanLandingFromJumpRangeOfInterest;
	var ()	float m_NormalHumanBodyFallRangeOfInterest;
	var ()	float m_SoftHumanBodyFallRangeOfInterest;
	var ()	float m_HumanCrouchingRangeOfInterest;
	var ()	float m_HumanTakingDamageRangeOfInterest;
	var ()	float m_ChangedWeaponRangeOfInterest;

	var ()	bool m_bDisplayAudioSensingRangesAny;
	var ()	bool m_bDisplayAudioSensingRangesAll;
	var ()	bool m_bDisplaySmallArmsBulletImpactRangeOfInterest;
	var ()	bool m_bDisplaySmallArmsFiringRangeOfInterest;
	var ()	bool m_bDisplayGrenadeExplodingRangeOfInterest;
	var ()	bool m_bDisplayNormalExplodingRangeOfInterest;
	var ()	bool m_bDisplayNormalExplodingDefaultRangeOfInterest;
	var ()	bool m_bDisplayWalkingFootFallsRangeOfInterest;
	var ()	bool m_bDisplayRunningFootFallsRangeOfInterest;
	var ()	bool m_bDisplayCrouchingFootFallsRangeOfInterest;
	var ()	bool m_bDisplayFeetScuffiingRangeOfInterest;
	var ()	bool m_bDisplayHumanJumpingRangeOfInterest;
	var ()	bool m_bDisplayHumanLandingFromJumpRangeOfInterest;
	var ()	bool m_bDisplayNormalHumanBodyFallRangeOfInterest;
	var ()	bool m_bDisplaySoftHumanBodyFallRangeOfInterest;
	var ()	bool m_bDisplayHumanCrouchingRangeOfInterest;
	var ()	bool m_bDisplayHumanTakingDamageRangeOfInterest;
	var ()	bool m_bDisplayChangedWeaponRangeOfInterest;

	var	() color m_DisplaySmallArmsBulletImpactRangeOfInterestColor;
	var ()	color m_DisplaySmallArmsFiringRangeOfInterestColor;
	var ()	color m_DisplayGrenadeExplodingRangeOfInterestColor;
	var ()	color m_DisplayNormalExplodingRangeOfInterestColor;
	var ()	color m_DisplayNormalExplodingDefaultRangeOfInterestColor;
	var ()	color m_DisplayWalkingFootFallsRangeOfInterestColor;
	var ()	color m_DisplayRunningFootFallsRangeOfInterestColor;
	var ()	color m_DisplayCrouchingFootFallsRangeOfInterestColor;
	var ()	color m_DisplayFeetScuffiingRangeOfInterestColor;
	var ()	color m_DisplayHumanJumpingRangeOfInterestColor;
	var ()	color m_DisplayHumanLandingFromJumpRangeOfInterestColor;
	var ()	color m_DisplayNormalHumanBodyFallRangeOfInterestColor;
	var ()	color m_DisplaySoftHumanBodyFallRangeOfInterestColor;
	var ()	color m_DisplayHumanCrouchingRangeOfInterestColor;
	var ()	color m_DisplayHumanTakingDamageRangeOfInterestColor;
	var ()	color m_DisplayChangedWeaponRangeOfInterestColor;

	var () SoundCue m_IHeardSomethingSoundCue;
	var () bool	m_bLogAudioAI_CueData;
	
};

struct native CoverBehaviorDataInput
{
	var() bool	m_bAllowUseOfCover;							// the ability to use cover period for any reason

	// intermediate cover is cover sought while engaging in a random fire fight
	// the the time to use that cover is how offten the AI Pawn should reassess it's use of cover
	// either seeking new cover or giving up cover and either conitune on it mission or going after the player.
	var() float	m_TimeToUseIntermediateCoverInSeconds;

	// how far away to look for potentail cover durring a random fire fight.
	// a value of less then zero is not to look at all. why would you want this to be negitive which is the default value
	// and still be allow to use cover would be for explict cover tasks
	var() float	m_DistanceToLookForIntermediateCover;
	
	var() float m_MinDistanceToPlayerInCover;
	
	var () bool m_bDisplayDistanceToLookForIntermediateCover;
	var	() color m_DisplayDistanceToLookForIntermediateCoverColor;

	var () float m_MaxDistanceAwayFromCoverForSnappingIn;

	var () float m_ChanceToStepOutFromCoverToEngage;
	var () float m_MinDistanceToCoverForSprinting;
	var () float m_MinDistanceToCoverForRunning;
	var () float m_SpeedFactorForCrouchWalkToCover;
	var () float m_JumpDownHorizontalOutDuration;
	var () float m_JumpDownMinVirticalDist;
};


struct native WanderDataInput
{
	var() bool			m_bAllowIdleWander;
	var() float			m_DefaultIdleWanderTime;
	var() float			m_ChanceToWander;
	var() float			m_TimeToWanderWhileWaitingForMTE_Target;
};

struct native GrenadeUseBehaviorData
{
	var ()  bool		m_bCanUseGrenades;
	var ()  bool		m_bCalcUpperArcForAuto;

	var ()  bool		m_bAlwaysThrowAgainstPlayerCamper;
	var ()  bool		m_bThrowGrenadeEvenIfNoGoodArc;

	var ()  float		m_ChanceToUseGrenadeByOwnWill;
	var ()  float		m_HowOfftenInSecsToCheckChanceToUseGrenade;
	var ()  float		m_TimeToWaitAfterThrownGrenadeToTryAgain;

	var ()  int			m_MaxNumberOfGrenadesToThrow;

	var() float			m_TossSpeed;
	var() float			m_BaseTossZ;
	var() float			m_DesiredZPct;
};


struct native Kynapse
{
	var()	float FaceEnemyDist;
	var()	float BeginFacingEnemyDist;
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var () float				MaxFactoryStartDelay;
var () float				MinFactoryStartDelay;

var () float				HeroDamagePlus;

// Maximum pawns allowed in the level
var () int					MaxSpawnedCount;
// Minimum time in seconds between
var () float				AdditionalRandomTimeBetweenSpawns;
var () float				TimeBetweenSpawns;
// Maximum pawns that may be spawned at the same time
var () int					MaxSpawnedAtOnce;

//var () SPDestructibleProperties	DestructibleProperties;

var () ESpPointSelection	PointSelection;

var () bool bUpdateSkelWhenNotRendered;			// Whether or not to update the skeletal mesh when no viewed.

var() array<AnimSet> SpecialAnimSets;		/** Array for Special specific animsets */
var() ESpPointGroup RestrictSpawnPointsTo;

// Internal use.
var int		SpawnedCount;
var float	RemainingDelay;
var int		LastSpawnIdx;
var bool	bDeathCanResetCounter;

//We need a better way to expose AI/Pawn variables to the factory.
var() Name							StartStateName;
var() bool bDisableAIOnStart;				// Specifies whether AI should be disabled at start
var() bool bLOSHearing;				// Specifies whether AI does LOS to sound source
var() float SightRadius;
var() float PeripheralVision;
var() bool bTargettable;
var() export editinline TPSquadSelector SquadType; /** Type of squad to select name from */

var(MeshProperties)	bool						CastShadow;
var(MeshProperties)	const bool					bForceDirectLightMap;
var(MeshProperties)	bool						bCastDynamicShadow;
var(MeshProperties)	const bool					bAcceptsLights;
var(MeshProperties)	const bool					bAcceptsDynamicLights;
var(MeshProperties)	const bool					bUsePrecomputedShadows;
var(MeshProperties)	const LightingChannelContainer	LightingChannels;

var() CoverBehaviorDataInput	m_CoverBehaviorDataInput;

var() WanderDataInput m_WanderDataInput;
var () float WaitTimeBetweenTestsForValidWanderTarget;

// Danger Awareness


var ()	Danger_Awareness m_Danger_Awareness;
var ()	Close_Quaters_Combat_Data  m_Close_Quaters_Combat_Data;
var ()	GrenadeUseBehaviorData  m_GrenadeUseBehaviorData;
var ()	EngagementTacData  m_Engagement_Tac_Data;


// AUDIO Sensory

var ()	Audio_Sensory m_Audio_Sensory;

var()	Kynapse m_Kynapse;

var (AI_AudioEvents)	float	m_WALKING_FOOT_FALLS_Loudness;
var (AI_AudioEvents)	float	m_RUNNING_FOOT_FALLS_Loudness;
var (AI_AudioEvents)	float	m_CROUCHING_FOOT_FALLS_Loudness;
var (AI_AudioEvents)	float	m_FEET_SCUFFIING_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_JUMPING_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_LANDING_FROM_JUMP_Loudness;
var (AI_AudioEvents)	float	m_NORMAL_HUMAN_BODY_FALL_Loudness;
var (AI_AudioEvents)	float	m_SOFT_HUMAN_BODY_FALL_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_CROUCHING_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_TAKING_DAMAGE_Loudness;

var	()					Float	WeaponAccuracy;
var ()					Bool	bAllowInventoryDrops; // Should this AI drop inventory on death?
var ()					Bool	bTurretGunner; // Should the AI search for available turrets?
var ()					float	MaxDistanceAwayToLookForTurret;

var() color AIDebugColor;

var() eFFXCharType	FFXCharType;

//***********************************************************************
// CPP TEXT
//***********************************************************************


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


