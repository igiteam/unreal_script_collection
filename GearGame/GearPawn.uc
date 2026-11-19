/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn extends GamePawn
	dependson(GearDamageType,GearTypes)
	ClassGroup(GearPawns)
	config(Pawn)
	native(Pawn)
	nativereplication
	placeable			// kludge to make all subclasses placeable
	abstract;

/** GoW global macros */
`include( GearGame\GearStats.uci )
`include(GearPlayerPersistentDataConstants.uci)

var bool bIsOnTurret;

/** Constants which will map a component on the mesh to a byte value for client-side-hit-detection */
const COMPONENT_HIT_Normal = 0;
const COMPONENT_HIT_Shield = 1;
const COMPONENT_HIT_Cleaver = 2;
const COMPONENT_HIT_GasTank = 3;

/** Struct used to replicated root body position when knocked down (not dead) */
struct native ReplicatedRootPosInfo
{
	var vector	Position;
	var byte	bNewData;
};

var	ReplicatedRootPosInfo ReplicationRootBodyPos;

const	MaxCoverGuessDist = 256.f;

var config float MeatflagProtectionPct;

/** Object within GearPawn which handles FX **/
var transient GearPawnFX GearPawnFX;
var class<GearPawnFX> GearPawnFXClass;

/** Additional translation for mesh */
/** Mesh Translation Offset (MTO) is used to modify Mesh.Translation value**/
/** MeshLocSmootherOffset:
 *  This variable is used to compensate mesh's translation
 *  when steps/inclines/bulky geometry causing cylinder to move up/downs rapidly
 *  To make it smooth this interpolates and creates smoother location transition **/
var const transient vector		MTO_MeshLocSmootherOffset;
/** SpecialMoveOffset:
 *  This doesn't have to be used by SpecialMove but it's in-game usable mesh offset
 *  SpecialMoveInterp is interpolation variable to reach target SpecialMoveOffset
 *  SpecialMoveSpeed is interpolate speed to reach target SpecialMoveOffset per second
  */
var transient vector                    MTO_SpecialMoveOffset;
var protected transient vector          MTO_SpecialMoveInterp;
var float                               MTO_SpecialMoveSpeed;

/** Additional yaw for mesh */
var const transient float MeshYawOffset;

/**
 * This is when meshes are authored with the root bone between their legs.
 * If TRUE, then mesh will be offset down by -CollisionHeight - Magic Number so feet touch the floor properly
 */
var const	bool	bTranslateMeshByCollisionHeight;
var const	float	MeshTranslationNudgeOffset;

/** Reference to GearWeapon carried by Pawn. Set in PlayWeaponSwitch() when a new weapon is set. */
var GearWeapon MyGearWeapon;
/** cached cast of Controller to GearAI */
var GearAI MyGearAI;
/** Ref to the sync actor for my coop weapon, if I'm carrying one. */
var transient CoopMGSyncActor CoopWeaponSyncActor;
/** Ref to previous controller before entering a vehicle */
var Controller PreviousController;

/** Cached bIsInCombat flag set by the server via GearPC.IsInCombat() */
var bool bIsInCombat;
/** This pawn should never be considered a valid enemy by AI */
var bool bNeverAValidEnemy;
/** This pawn is never a valid melee target */
var bool bInvalidMeleeTarget;
/** This pawn is never a valid fire target */
var bool bInvalidFireTarget;
/** this pawn can never be special melee attacked (chainsaw, executions, etc) */
var bool bImmuneToSpecialMeleeAttacks;

/** Is rotation locked?	 Currently for scripting only */
var bool bLockRotation;

var ParticleSystem	GoreImpactParticle;
/** Name of base blend anim node */
var Name			FullBodyNodeName;
/** Base blend node */
var AnimNodeSlot	FullBodyNode;

/** A saved reference to the breating node in the anim tree */
var transient GearAnim_AdditiveBlending   BreathingAdditiveControl;

/** Character name of this pawn, ie. Dom,Marcus,Locust Drone */
var localized String CharacterName;

enum ESituationMood
{
	SITMOOD_Default,
	SITMOOD_Tense,
};
var	ESituationMood	SitMood;

enum EHeadTrackPriority
{
	EHTP_Default,
	/** AI Focus Point, low priority. */
	EHTP_AIFocus,
};

struct native HeadTrackStruct
{
	/** Actor to head-track */
	var Actor HeadLookAtActor;
	/** Specific bone on the HeadLookAtActor to track */
	var Name HeadLookAtBoneName;
	/** Current HeadTracking priority */
	var EHeadTrackPriority HeadTrackPriority;
	/** Speed modifier for head turn. To get slower or faster reactions. */
	var float LookAtSpeedScale;
};

/** Replicated HeadTracking information */
var repnotify HeadTrackStruct ReplicatedHeadTrackInfo;

/** HeadTrackTarget that is controlling this pawn's head, if any */
var transient private HeadTrackTarget CurrentHeadTrackTargetActor;
/** Countdown for LookAtTime. Only used when HeadTrackTarget has a LookAtTime defined. */
var transient FLOAT HeadTrackLookAtCountDown;
/** Countdown for delay looking between HeadTrack targets, if HeadTrackTarget has DelayBetweenNextTarget. */
var transient FLOAT HeadTrackDelayCountDown;

/** Limiter on gib effects */
var int EffectCount;

var bool bDelayGibImpactSounds;

/** Defines the current move the player is doing */
enum ESpecialMove
{
	SM_None,
	/** Mantle over cover */
	SM_MidLvlJumpOver,
	/** Swat turns in cover */
	SM_StdLvlSwatTurn,
	/** Run to the edge of cover */
	SM_CoverRun,
	/** Run out of cover until button is released */
	SM_RoadieRun,
	/** Slip out of cover */
	SM_CoverSlip,
	/** Mantle up and down from cover */
	SM_MantleUpLowCover,
	SM_MantleDown,
	/** Evades */
	SM_EvadeFwd,
	SM_EvadeBwd,
	SM_EvadeLt,
	SM_EvadeRt,

	/** Transition to cover */
	SM_Run2MidCov,
	SM_Run2StdCov,

	/** movement 2 idle transitions */
	SM_Run2Idle,
	SM_Walk2Idle,

	/** Push Out of Cover */
	SM_PushOutOfCover,
	GSM_CoverDestroyed,

	// Reaction animations
	SM_FlankedReaction_Left,
	SM_FlankedReaction_Right,
	SM_FlankedReaction_Back,
	SM_FlankedReaction_Front,
	SM_Reaction_InitCombat,
	SM_FullBodyHitReaction,

	/** Stumble Actions */
	SM_StumbleFromMelee,
	SM_StumbleFromMelee2,
	SM_StumbleGoDown,
	SM_StumbleGoDownFromExplosion,
	SM_StumbleGoDownFromCloseRangeShot,
	SM_StumbleGetUp,
	SM_StumbleForwardFromExplosion,
	SM_CoverHead,
	SM_CoverHeadPushed,
	SM_FaceShield,
	SM_CleaverStabbed,
	SM_StumbleBackOutOfCover,
	SM_ChainsawInterrupt,
	SM_StumbleFromMantleKick,
	SM_DBNO,
	SM_Gunked,
	SM_RecoverFromDBNO,
	SM_RoadieRunHitReactionStumble,

	// Other subactions
	SM_Emerge_Type1,
	SM_Emerge_Type2,
	SM_Emerge_Type3,
	SM_Emerge_Pod,
	SM_Emerge_PodJump,

	SM_DeathAnim,
	SM_DeathAnimFire,
	SM_DeathAnimCleaver,
	SM_RecoverFromRagdoll,

	SM_ChainSawHold,
	SM_ChainSawAttack,
	SM_ChainSawVictim,
	SM_ChainsawDuel_Leader,
	SM_ChainsawDuel_Follower,
	SM_ChainsawDuel_Draw,

	SM_BayonetAttack,
	SM_BayonetVictim,
	SM_BayonetDraw_Leader,
	SM_BayonetDraw_Follower,

	SM_ChainSawAttack_Object,
	SM_ChainSawAttack_Object_NoCamera,

	SM_DiggerChestDrill,

	SM_FlailSmashAttack,

	SM_EvadeFromCoverCrouching,
	SM_EvadeFromCoverStanding,

	SM_LeaderShout,

	// Pawn to Pawn Interactions
	SM_CQC_Victim,
	SM_CQCMove_CurbStomp,
	SM_CQCMove_PunchFace,
	SM_CQCMove_Shield,
	SM_CQCMove_B,
	SM_ReviveTeammate,
	SM_GrabWretch,
	SM_GrabWretchFollower,
	SM_Kidnapper,		// Meat Shield, kidnapper
	SM_Hostage,			// Meat Shield, hostage
	SM_Kidnapper_Execution,
	SM_Kidnapper_GrenadeRelease,
	SM_Hostage_GrenadeRelease,
	SM_MantleKick,
	SM_ShareAmmo,
	SM_GiveMoney,
	SM_TradeWeapons,
	SM_TradeWeapons_Leader,
	SM_TradeWeapons_Follower,
	SM_TradeWeaponsSecondaryAI,

	// Interactions
	SM_WeaponPickup,
	SM_DoorPush,
	SM_DoorKick,
	SM_PushButton,
	SM_Engage_Loop,
	SM_Engage_Start,
	SM_Engage_End,
	SM_Engage_Idle,
	SM_Engage_ForceOff,
	SM_LadderClimbUp,
	SM_LadderClimbDown,
	SM_GrapplingHook_Climb,
	SM_GrapplingHook_DynamicClimb,
	SM_Rappel,
	SM_Engage_Matinee,
	SM_ZiplineStart,
	SM_ZiplineIdle,
	SM_ZiplineEnd,

	// Movable cover
	SM_PushCover,

	SM_PushObject,
	SM_UsingCommLink,
	SM_PutOnHelmet,
	SM_ScriptedMove,

	// Special weapon moves
	SM_TargetMortar,
	SM_TargetMinigun,
	SM_TargetHeavySniper,
	SM_UnMountMinigun,
	SM_UnMountMortar,
	SM_UnMountHeavySniper,
	SM_PlantShield,
	SM_DeployShield,
	SM_RaiseShieldOverHead,
	SM_ShieldBash,
	SM_CleaverThrow,
	SM_CleaverSwipe,
	SM_RoadieRunStab,
	SM_AmmoBoxDrop,

	// Wretch special moves
	GSM_PounceAttack,	// Leap attack
	GSM_SwipeAttack,	// Ground attack
	SM_Wretch_Choke,
	GSM_Scream,			// Scream attack
	GSM_LeapToCeiling,
	GSM_DropFromCeiling,
	GSM_Cart_ClimbUp,
	GSM_Cart_SwipeAttack,
	GSM_Elevator_Climb,	// Climbs over the lip of the elevator

	// Berserker special moves
	SM_Berserker_Smash,			// Close range melee attack
	SM_Berserker_Charge,		// Distance melee attack
	SM_Berserker_Collide,		// Successful charge collision (ie w/ player or door that got knocked over)
	SM_Berserker_Stunned,		// Stunned after hitting a wall w/ charge attack
	SM_Berserker_Slide,			// No collision happened before charge has ended
	SM_Berserker_HODHitReaction,// Hammer or Dawn Hit Reaction
	SM_Berserker_Alert,			// Alert search mode
	SM_Berserker_Jump,			// Jump attack for the lambent version
	SM_Berserker_GrabChest,		// Grab chest in pain to close it - lambent version
	SM_Berserker_ShortStun,
	SM_Berserker_ChargeMantle,

	// Brumak
	GSM_Brumak_Roar,
	GSM_Brumak_RtGunHit,
	GSM_Brumak_LtGunHit,
	GSM_Brumak_CannonHit,
	GSM_Brumak_CannonFire,
	GSM_Brumak_MeleeAttack,
	GSM_Brumak_OverlayLftArmSwing,
	GSM_Brumak_OverlayRtArmSwing,
	GSM_Brumak_OverlayBite,
	GSM_Brumak_Scream,
	GSM_Brumak_LtGunPain,
	GSM_Brumak_RtGunPain,
	GSM_Brumak_ExposeDriver,

	// Bloodmount
	SM_BloodMountDriver_CalmMount,
	SM_BloodMount_HitInFace,
	GSM_BloodMount_Melee,

	// Kantus
	GSM_Kantus_KnockDownScream,
	GSM_Kantus_ReviveScream,
	GSM_Kantus_SummoningScream,
	GSM_Kantus_FrustratedScream,
	GSM_KantusArmor_RollAttack,

	// Silverback
	GSM_Silverback_CoverDeploy,
	GSM_Silverback_CoverExit,
	GSM_SilverbackLoaderCratePickup,
	GSM_SilverbackLoaderDropCrate,
	GSM_Silverback_SuperCurbStomp,
	GSM_Silverback_Kick,
	GSM_Silverback_GetIn,
	GSM_Silverback_GetOut,

	// Corpser Larva
	GSM_CorpserLarva_Melee,
	GSM_CorpserLarva_DanceIntro,
	GSM_CorpserLarva_DanceOutro,
	GSM_CorpserLarva_GoUnderground,

	// Lambent Polyp
	GSM_LambentPolyp_Spit,

	// Gunker
	GSM_Gunker_MeleeClose,
	GSM_Gunker_MeleeFar,
	GSM_Gunker_Lob,
	GSM_Gunker_Shoot,

	// Ticker
	GSM_Ticker_LeapToPickup,
	GSM_Ticker_LeapToPlantedGrenade,

	// Drudge
	GSM_Drudge_Scream,
	GSM_Drudge_PreCharge,
	GSM_Drudge_Mutate,
	GSM_Drudge_SnapAttack,
	GSM_Drudge_SpewAttack,
	GSM_Drudge_ExecutionHead,
	GSM_Drudge_ExecutionArms,
	GSM_Drudge_RegenTentacle,
	GSM_Drudge_SpawnPolyps,

	// Savage Drone
	GSM_SavageDrone_EmergeFromUnderground,
	GSM_SavageDrone_ROAR,

	// Dragging Injured People
	GSM_DragInjured_Leader,
	GSM_DragInjured_Follower,

	// 'pede
	SM_Serapede_Attack,
	SM_Serapede_Cringe,

	// Tempest
	SM_Tempest_Land,
	SM_Tempest_Vent,
	SM_Tempest_TakeOff,
	SM_Deprecated_Tempest_VentInAir,// When we clean up, delete this - otherwise, it might hurt tower/rooftop level
	SM_Tempest_BeamInAir,
	SM_Tempest_Hover,
	SM_Tempest_Thrash,
	SM_Tempest_HODHitReaction,
	SM_Tempest_Tower,
	SM_Tempest_Sneak,

	// Mom Corpser
	SM_Corpser_Hurt,
	SM_Corpser_Stab,
	SM_Corpser_Stomp,
	SM_Corpser_Charge,
	SM_CoverHeadPushed_ByCorpser,

	// JumpLink traversal
	GSM_Leap,

	// Ithycus (fish)
	GSM_IthycusAttack,

	// Jumping off of a Reaver
	SM_JumpFromReaver,

	SM_RidingRatTruck,

	// Lambent Human
	GSM_Former_Prowl,
	GSM_Former_Pounce,

	// Siege Beast
	GSM_SiegeBeast_Gunner,
	GSM_SiegeBeast_Loader,

	SM_Adam_Typing,
};

/** Container for all special move properties */
struct native SMStruct
{
	/** Special Move Enum being performed. */
	var ESpecialMove	SpecialMove;
	/** Interaction Pawn */
	var GearPawn		InteractionPawn;
	/** Additional Replicated Flags */
	var INT				Flags;
};

/** Special move currently performed by Pawn. SM_None, when doing none. */
var	ESpecialMove					SpecialMove, PreviousSpecialMove;
/** Special move pending, activated after the current one terminates. */
var SMStruct						PendingSpecialMoveStruct;
/** Are we currently in the process of ending a special move, and should force new moves to delay? */
var transient bool					bEndingSpecialMove;
/** Set when starting PendingSpecialMove to maintain PrevMove reference for transitions. */
var protectedwrite transient bool bIsPendingMove;
/** Time at which last special move was started */
var FLOAT							PreviousSpecialMoveTime;

/** How far away coop interaction special moves can happen */
var config float                    CoopInteractionDistance;

/** Prevent race condition where clients change weapons right after initiating a weapon swap  */
var GearWeapon WeaponForWeaponSwap;

/** How much money to transfer in a money share */
var config float                    MoneyTransferAmount;

/**
 * Special move currently performed by Pawn. SM_None, when doing none. This is necessary
 * because the previous state of SpecialMove is used in DoSpecialMove(), so if the
 * network replication stuff just blows away SpecialMove on the client, then
 * the "from" specialmove information is lost and things no worky.
*/
var	repretry repnotify SMStruct		ReplicatedSpecialMoveStruct;

/** Array matching above enumeration. List of classes to Instance */
var Array<class<GearSpecialMove> >	SpecialMoveClasses;
/** Array of instanced special moves */
var(SpecialMoves) editinline editconst transient Array<GearSpecialMove> SpecialMoves;

/** Pawn ref used for Pawn to Pawn Interactions */
var				GearPawn			InteractionPawn;
/** INT to pack any additional data into special moves, and get it replicated so it's consistent across network. */
var				INT					SpecialMoveFlags;

/** List of Special Moves checked for Pawn to Pawn interactions. */
var	Array<ESpecialMove>				PawnToPawnInteractionList;

/** Useful replication vector that can be used tom communicate a location to the SpecialMove on the client. */
var	vector							SpecialMoveLocation;

/** Special moves that should check to display a HUD indicator (while in cover) */
var array<ESpecialMove>				CoverActionSpecialMoves;

/** Special moves that should check to display a HUD indicator (whether or not in cover) */
var array<ESpecialMove>				ActionSpecialMoves;

/** SpecialMove done when dying. */
var ESpecialMove					SpecialMoveWhenDead;
/** Saved Base when dying */
var Actor							BaseWhenDead;

// CQC moves enum
enum ECQCMove
{
	CQCMove_None,
	CQCMove_MeatBag,
	CQCMove_WeaponKill,
	CQCMove_CharacterKill,
	CQCMove_CurbStomp,
};


/** If Pawn is allowed to do Floor conforming at all. */
var const	bool					bCanDoFloorConform;
/** If Pawn is currently allowed to do floor conforming. Would perform an interpolation if toggled. */
var()	bool						bDoFloorConform;
/** Update Tag for FloorConformUpdate. */
var const transient INT FloorConformUpdateTag;
/** Average Floor Normal. Cached for speed. */
var const transient vector          FloorConformAverageFloorNormal;
/** Full floor conform resulting mesh translation */
var const transient vector			FloorConformTranslation;
/** Keep track of Z translation separately. */
var const transient FLOAT			FloorConformZTranslation;
/** Max Slope Angle allowed */
var const FLOAT						FloorConformMaxSlopeAngle;
/** Track last Pawn rotation, to make any updates if necessary */
var const Rotator					FloorConformLastPawnRotation;

/** Floor normal for full mesh floor conform */
var()				bool			bDoFullMeshFloorConform;
var					TAlphaBlend		MeshFloorConformMovementAlpha, MeshFloorConformToggleAlpha;
var const transient vector			MeshFloorConformNormal, MeshFloorConformBackupNormal;
var const transient float			MeshFloorConformTranslation;
var const transient float			MeshFloorConformSlopeAngle;
var const transient Rotator			MeshFloorConformRotation;

/** Alpha for smooth transitions */
var					TAlphaBlend		IKFloorConformMovementAlpha;
var const transient vector			IKFloorConformNormal, IKFloorConformBackupNormal;
var const transient float			IKFloorConformTranslation;
var const transient float			IKFloorConformSlopeAngle;
var const transient Rotator			IKFloorConformRotation;
var					bool			bDoIKFloorConformTorsoBending;
/** Torso rotation following slope changes */
var const transient Quat			IKFloorConformTorsoQuatWorld, IKFloorConformTorsoQuatLocal;

/** Center Of Mass (COM) translation.
 * Offsets the mesh, in relation to the slope angle with a slight delay,
 * to try to get the character to look balanced. (In world space)
 */
var const transient vector			IKFloorConformCOMTranslation;
/** If Pawn should do Center Of Mass adjustments */
var const			bool			bDoIKFloorConformCOM;
/** Time Accumulator for stable COM spring update */
var const			float			IKFloorConformCOMTimeAccumulator;
/** Target translation for COM adjustment. (In world space). */
var const transient vector			IKFloorConformCOMTarget;
/** Limits enforced for COM translation. X=Radius, Y=Height */
var() const			Vector2D		IKFloorConformCOMLimits;
/** Interpolation speed for COM translation (units per second) */
var() const			Vector			IKFloorConformCOMSpeed;
/** COM translation damping. */
var() const			Vector			IKFloorConformCOMDamping;
/** COM translation velocity. */
var const transient Vector			IKFloorConformCOMVelocity;
/**
 * Weight (0..1) between non COM adjusted offset, and fully balanced.
 * 0 means no COM adjustment, 1 means fully balanced. But then the character can be really outside of the collision cylinder
 */
var() const			FLOAT			IKFloorConformCOMWeight;

var() const			FLOAT			LegAdjustInterpSpeedStopped;
var() const			FLOAT			LegAdjustInterpSpeedMoving;
var	const transient	FLOAT			LegAdjust;

/** Enable foot placement component */
var					bool			bDoFootPlacement;
/** Alpha for controlling foot placement interpolation */
var					TAlphaBlend		FootPlacementAlpha;

/** SkelControl controlling Feet IK bones */
var	transient SkelControlSingleBone	IKFloorConformSkelControl;
/** Bone Controller to rotate joint targets before IK is applied. To prevent odd IK behaviors */
var transient SkelControlSingleBone LegFloorConformSkelControl;
/** IK Controller for feet bones */
var transient GearSkelCtrl_FootPlacement	IKFootLeft, IKFootRight;

/** Both Left/Right Weapon Bone Controller - Used for Trade Weapon: weapo toss **/
var	transient SkelControlSingleBone	LeftWeaponBone;
var transient SkelControlSingleBone RightWeaponBone;
// for now I'm making it global config, since this distance isn't per individual
var globalconfig FLOAT              TradeAnimDistance;

/** If TRUE, translation of mesh is updated to match desired floor translation (0 unless special move desired floor conforming) */
var bool							bDisableMeshTranslationChanges;



/** monitor last time Pawn bumped into something */
var	transient				float		LastBumpTime;

/** Replicated cover information to play transition animations on remote clients. */
var	repnotify				CovPosInfo	AcquiredCoverInfo;

struct native SManipulateCoverInfo
{
	/** Magnitude of force that this pawn is applying to the movable cover in the direction of the cover link */
	var float	AppliedForce;

	/** Magnitude of force that this pawn is applying to the movable cover perpendicular to the direction of the cover link */
	var float	AppliedStrafeForce;

	/** Torque about the Z axis that this pawn is applying to the movable cover */
	var float	AppliedTorque;
};

var SManipulateCoverInfo ManipulateCoverInfo;

/**
* TRUE if this Pawn is holding movable cover
* The pawn will have to release before being able to break away from cover
*/
var transient bool bGrabbingMovableCover;

/** Sound to play when grabbing movable cover */
var(SpecialMoves) SoundCue		GrabCoverSound;
/** Sound to play when releasing grip on movable cover */
var(SpecialMoves) SoundCue		ReleaseCoverSound;
/** Sound to loop while moving cover */
var(SpecialMoves) SoundCue		MovingCoverSound;
/** AudioComponent used for looping MovingCoverSound */
var transient AudioComponent	MovingCoverLoop;

/** whether this pawn can use cover at all */
var bool bCanUseCover;
/**
 * TRUE if this Pawn can play the run2cover slide special move.
 * if FALSE, Pawn will acquire cover without playing this transition.
 */
var(SpecialMoves)			bool		bCanDoRun2Cover;

/**
 * Maximum distance allowed from cover to do run 2 cover special move.
 * Above that distance, move will be denied, and player will evade instead.
 */
var(SpecialMoves)	config	float		Run2CoverMaxDist;

/**
* Maximum distance allowed from cover to do run 2 cover special move when moving perpendicular
*/
var(SpecialMoves)	config	float		Run2CoverPerpendicularMaxDist;



/** Max distance to slide to cover at the end of an evade move */
var(SpecialMoves)	config	float		EndEvadeRun2CoverMaxDist;

/** Max Distance to check for a transition from Roadie Run to cover slide */
var(SpecialMoves)	config	float		RoadieRun2CoverSlideDist;

// COVER DEBUGGING
/** Player search FOV */
var globalconfig	bool	bCoverDebug_PlayerFOV;
/** Cover acquisition FOV */
var globalconfig	bool	bCoverDebug_CoverFOV;
/** Cover acquisition volume */
var globalconfig	bool	bCoverDebug_CoverVolume;
/** Considered cover links for search */
var globalconfig	bool	bCoverDebug_ConsideredLinks;
/** Draw found cover position */
var globalconfig	bool	bCoverDebug_FoundCover;
/** Draw validated cover */
var globalconfig	bool	bCoverDebug_ValidatedCover;

// Weapon debugging
var globalconfig	bool	bWeaponDebug_Accuracy;
var globalconfig	bool	bWeaponDebug_DamageRadius;

/** Whether to draw spheres to indicate headshot area */
var globalconfig	bool	bWeaponDebug_HeadShotLocation;

/** if this is set then the weapon equiping/de equiping / highlighting sounds will not play @see ClientRestart **/
var bool bQuietWeaponEquipping;
/** Set to true if weapons are currently holstered */
var repnotify bool bWeaponHolstered;

/** Represents the type of cover currently being used, for animation */
var ECoverType		CoverType;

/**
 * Represents the current action this pawn is performing at the
 * current cover node.
 */
var ECoverAction	CoverAction, PreviousCoverAction, SavedCoverAction;

/** Time at which cover was entered or left */
var float LastCoverTime;

/** How far away from cover this pawn was the last time he acquired cover (squared) */
var float LastCoverAcquireDistanceSq;

/** Time at which a cover action was taken */
var float LastCoverActionTime;
/** Time at which next cover action can be taken
(< 0 value means left actions ignore, > 0 value means right actions ignore) */
var float NextCoverActionTime;

/**
 * True when animations are mirrored. True if player is looking/moving to the left in cover.
 * Do not set direction, call SetMirroredSide() which will set bWantsToBeMirrored accordingly.
 * Because mirroring requires an animation transition, which introduces a delay.
 * This is not an instant change of direction.
 */
var	const	bool	bIsMirrored;

/**
 * Flag set indicating which side Pawn would like to be.
 * This action can take a little time to complete.
 * bIsMirrored will be updated when mirroring happened.
 */
var			bool	bWantsToBeMirrored;

/**
 * Flag set when Pawn is doing a mirror transition
 */
var	const transient bool	bDoingMirrorTransition;


/** TRUE if should play walk 2 idle transitions. This takes over input when Pawn stops moving */
var	bool	bDoWalk2IdleTransitions;

/** Flag to toggle 360 aiming in cover. */
var bool	bCanDo360AimingInCover;

/** Is player doing 360 aiming? */
var transient bool	bDoing360Aiming, bWasDoing360Aiming;
var transient float	Last360AimingChangeTime;

/** The last time the Pawn was moving */
var transient float LastTimeMoving;

/** Pawn has been injured and is crawling on the ground */
var bool	bIsCrawling;

/** Turn off bNoEncroachCheck when this pawn goes to ragdoll. */
var bool	bEnableEncroachCheckOnRagdoll;

/**
 * When set to TRUE, modify damage in TakeDamage(), otherwise keep the incoming damage value.
 * Used for example by grenade melee to kill the enemy, even if he's behind cover.
 */
var bool	bAllowDamageModification;

/** Whether or not we are in the wait state for the damage sound so we dont' play this over and over **/
var transient bool PlayBurstDamageWarningSoundSemaphore;

/** if set, don't play camera shakes for damage taken */
var bool bIgnoreDamageShakes;

/** Used to track when HOD damage was applied */
var float	LastHODDamageTime;

/** Global modifier that effects all movement modes */
var() float	MovementPct;

/** Array of movement scales to set when in the matching CoverType */
var() array<float> CoverMovementPct;

/**
 * if TRUE, steps smoothing code will be performed.
 * This compensates Z movement of the pawn down/up stairs by offsetting the mesh, and interpolating it
 * smoothly back.
 */
var()	bool	bCanDoStepsSmoothing;

/** XY velocity for a jump */
var() config float JumpSpeedXY;
/** Minimum Z velocity for a jump */
var() config float MinJumpSpeedZ;
/** Maximum horizontal distance this pawn can do a pouncing movement */
var() config float MaxPounceDistXY;
/** Maximum Z velocity for a pounce */
var() config float PounceZ;

/** Default inventory added via AddDefaultInventory() */
var() array< class<Inventory> > DefaultInventory;

/** Configurable health setting */
var() config int DefaultHealth;

/** Configurable ground speed setting */
var() config float DefaultGroundSpeed;

var transient bool bAllowSpeedInterpolation;
var transient float LastMaxSpeedModifier;

var bool bHealthIsRecharging;
var() SoundCue HealthRechargeStartSound;

var SoundCue DeadBodyImpactSound;
var float DeadBodyImpactThreshold;
/** Float value of health to handle deltatime being too small for insane difficulty settings */
var transient float RechargingHealthAmount;

/** Delay before health starts recharging */
var() config float HealthRechargeDelay;

/** Amount of recharge per second */
var() config float HealthRechargePercentPerSecond;

/** Tracks when the Pawn died */
var transient float TimeOfDeath;

/** Whether or not we are scaling to zero **/
var transient protected bool bScalingToZero;

/** Are we currently bleeding out? */
var transient bool bIsBleedingOut;

/** the Pawn who killed me */
var GearPawn KilledByPawn;

/** my location when I died.  used for death cam. */
var Vector	LocationWhenKilled;
var Rotator RotationWhenKilled;

/** True if switched to Gore Skeleton/Physics Asset */
var bool bIsGore;
/** True if Gore has been setup for Gibs. Sets up some optimizations so Gibs don't kill performance. */
var bool bGoreSetupForDeath;
/** If TRUE we broke at least one constraints off the Gore mesh. */
var bool bHasBrokenConstraints;
/** Whether we have GoreExploded or not.  We only want to play GoreExplode effects once **/
var transient bool bHasGoreExploded;
/** whether to do the extra Z axis impulse when killed and ragdolled */
var bool bDoDeathUpKick;
/** Maximum time to keep creature's ragdoll / gibs around after death, even if in view of the player */
var() float CorpseMaxLifeSpan;

/** If TRUE, when recovering from ragdoll, don't allow kicking of corpses any more */
var bool bDisableKicksCorpseAfterRecovery;

/** whether I am currently charging my bow */
var repnotify bool bChargingWeapon;

/** Multiplier for weapon damage, set by difficulty and Guardian Angel assists */
var float PlayerDamageMod;

/** If a gib physics body moves further than this from the Actor location we kill it */
var float	GibKillDistance;

/** Maximum number of Dead RagDoll Pawns allowed. So frame rate doesn't get too bad. */
var config int	MaxAllowedDeadRagDollPawns;

/** List of bone names used for validating head/leg shots. */
var() config array<Name> HeadBoneNames;
var() config array<Name> LegBoneNames;
var() config Name TorsoBoneName;

/** Attached to the neck for HeadShots. To hide the bone scaling ugliness. */
var StaticMeshComponent		HeadShotNeckGoreAttachment;
/** HeadChunks rigidbodies to Spawn when a HeadShot happens */
var array<StaticMesh>		HeadChunks;
/** particle system to play for headshot blood */
var ParticleSystem HeadshotBloodTemplate;

/** if TRUE, Play death animation */
var	bool		bPlayDeathAnimations;
/** if TRUE, this pawn can play head shot deaths. */
var bool		bCanPlayHeadShotDeath;
/** TRUE if this Pawn has played a head shot death */
var bool		bHasPlayedHeadShotDeath;
/** set to force the head shot death even if the damagetype for the deathblow doesn't normally allow it
 * also works to force head shot effects even when not dead yet
 */
var repnotify bool bForceHeadShotGib;
/** List of potential death animations to play */
var	Array<Name>	DeathAnimHighFwd, DeathAnimHighBwd, DeathAnimStdFwd, DeathAnimStdBwd, DeathAnimStdLt, DeathAnimStdRt;
// @See LastDeathAnimHighFwdIndex in GearGRI. Used to not play the same animation twice consecutively.

/** If Pawn can or cannot play physics hit reactions. */
var					bool		bCanPlayPhysicsHitReactions;
/** List of RB bone names which should be UnFixed when playing a Physics Body Impact. */
var(HitReactions) editinline Array<Name> PhysicsBodyImpactBoneList;
/** Internal counter */
var					float		PhysicsImpactBlendTimeToGo;
/** Scale impulses by this amount for Physics Hit Reactions. */
var(HitReactions)	float		PhysicsHitReactionImpulseScale;
/** Time it takes to blend back to animations after being turned into physics. */
var(HitReactions)	float		PhysicsImpactBlendOutTime;
/** Scales the effect of Mass on PhysicsImpacts */
var(HitReactions)	float		PhysicsImpactMassEffectScale;
/** Minimum motor strength when hit */
var(HitReactions)	Vector2D	PhysHRMotorStrength;
var(HitReactions)	Vector2D	PhysHRSpringStrength;
var(HitReactions)	bool		bEnableHitReactionBoneSprings;

// Interface for remapping physical impacts
// Some bones don't react too well to impulses, so we forward them to other bones
// which provide a much better visual result
struct native PhysicsImpactRBRemap
{
	var()	Name	RB_FromName;
	var()	Name	RB_ToName;
};

/** Table to remap RigidBodies for physical impacts */
var(HitReactions) editinline	Array<PhysicsImpactRBRemap> PhysicsImpactRBRemapTable;

/**
* List of RidigBodies where a spring should be attached to animation.
* This helps for e.g. the hand carrying the weapon to not fly away, but remain somewhat close to the animation.
*/
var(HitReactions) editinline	Array<Name>					PhysicsImpactSpringList;

/** Archetype describing the joints and dependencies for gore */
var GearPawnGoreSettings GoreSettings;

/** Struct indicating how much to scale a particular joint limit upon complete ragdoll death. */
struct native DeadRagdollLimitScale
{
	var()	name	RB_ConstraintName;
	var()	float	Swing1Scale;
	var()	float	Swing2Scale;
	var()	float	TwistScale;
};

/** Information on how to scale limits for a ragdoll upon complete death - to prevent weird positions. */
var() array<DeadRagdollLimitScale>	RagdollLimitScaleTable;
/** Time taken to scale limits to their target. */
var() float							TimeToScaleLimits;
/** How much longer to scale limits to target. */
var	float							ScaleLimitTimeToGo;

/** Speed that a gib has to move at to fire effects (ie call PlayGibEffect event). */
var	float GibEffectsSpeedThreshold;

/** Minimum time between calls to PlayGibEffect. */
var	float TimeBetweenGibEffects;

/** Efect used when using a 'simple' death, using just a particle effect. */
var ParticleSystem SimpleDeathEffect;
/** decal to spawn when using the simple death effect */
var DecalData SimpleDeathDecal;
/** Efect used when using a 'simple' death, using just a particle effect. */
var ParticleSystem SimpleDeathEffectNonGore;
/** Scale to use when firing SimpleDeathEffect */
var float SimpleDeathEffectScale;

/** Character sound group archetype */
var() GearSoundGroup	SoundGroup;

/**
 * FOV at which a player is considered safe behind cover.
 * Enemy shots with a direction within that FOV will be ignored
 */
var() vector2d CoverProtectionFOV;

/** Time Pawn is going to keep aiming after firing a weapon, before returning to idle/ready pose */
var	config		float	AimTimeAfterFiring;

/** Is Pawn targeting? Used by animations. */
var				bool	bIsTargeting;
var	repnotify   bool	bIsZoomed;

/** Try to prevent the visual hiccup when zooming changes the muzzle location */
var transient float InitialZoomSmoothingAmountSq;

/** Force pawns into targeting (as if holding Left Trigger) */
var transient	bool	bForceTargeting;
/** Force pawns into aiming stance */
var transient	float	ForcedAimTime;
/** Replicated ForcedAimTime, because WorldInfo.TimeSeconds is not consistent accross server and clients */
var repnotify transient	BYTE	ReplicatedForcedAimTime;

/** Pending Fire is set when a weapon fire is delayed because of animation blends/transitions. */
var transient	bool	bPendingFire, bPendingAltFire, bPendingMeleeAttack;

/** Whether an enemy has spotted us in multiplayer, currently supports 4 teams since that's the max in wingman */
var repnotify transient BYTE SpottedByTeam[4];

/** The player that spotted us */
var repnotify transient GearPRI SpottedBy[4];

/** Time spotted by a player */
var transient float SpottedTime[4];

/** Whether the pawn is unspottable */
var const bool bNotSpottable;

/** How far off a trace can be and still be counted as a spot, the low end of the possible buffer */
var config float SpotBufferMin;

/** How far off a trace can be and still be counted as a spot, the high end of the possible buffer */
var config float SpotBufferMax;

//
// Slot attachments
//

/** neck bone name */
var()	name	NeckBoneName;
/** Name of Pelvis Bone */
var()	name	PelvisBoneName;
/** This is the bone to use for melee damage hit location  */
var()	name	MeleeDamageBoneName;
/** Offset from neck bone to get view location */
var()	Vector	ViewLocationOffset;

/** foot bone names **/
var name LeftFootBoneName;
var name RightFootBoneName;

/** "Knee" bone names **/
var name LeftKneeBoneName;
var name RightKneeBoneName;

/** Hand Bone names **/
var name LeftHandBoneName;
var name RightHandBoneName;

/** Structure used to replicate weapon information to remote clients */
struct native WeaponRepInfo
{
	var		class<GearWeapon>	WeaponClass;
	var		BYTE				BYTE_bHadAPreviousWeapon;
};

/** Current weapon replicated to remote clients. */
var		repnotify	WeaponRepInfo	RemoteWeaponRepInfo;

/** Socket names */
var	const	Name	RightHandSocketName, LeftHandSocketName, HeadSocketName;

var		repnotify	class<Inventory>	AttachClass_Shield;

/** replicated slots */
var		repnotify	class<Inventory>	AttachSlotClass_Holster;
var		repnotify	class<Inventory>	AttachSlotClass_Belt;
var		repnotify	class<Inventory>	AttachSlotClass_LeftShoulder;
var		repnotify	class<Inventory>	AttachSlotClass_RightShoulder;

/** Player attachment slots definition */
enum EAttachSlot
{
	EASlot_Holster,			// Carrying Pistol
	EASlot_Belt,			// Carrying	Items/grenades
	EASlot_LeftShoulder,	// Carrying medium or heavy weight weapons
	EASlot_RightShoulder,	// Carrying medium or heavy weight weapons
	EASlot_None,			// MUST ALWAYS BE DEFINED LAST, means weapon has no slot assigned
};

/** player local attachment slot definition */
struct native SAttachSlot
{
	/** Socket name to attach attachment to */
	var()	name								SocketName;
	/** True to attach to bone named [SocketName], rather than a socket of that name. */
	var()	bool								bAttachToBone;
	/** Class of inventory attachment */
	var()	class<Inventory>					InvClass;

	var()	editinline	StaticMeshComponent		StaticMesh;

	var()	editinline	SkeletalMeshComponent	SkeletalMesh;
};

/** local attachment slots */
var()	Array<SAttachSlot>	AttachSlots;

/** This pawn is capable of ... */
var config bool		bCanRoadieRun;
var config bool		bCanBeForcedToRoadieRun; // if designer tells us to, we can roadie run (e.g. for guys we don't want roadie running normally, but their skeleton supports it)
var const bool      bCanRoadieRunWhileTargeting;
var config bool		bCanBlindFire;

// AI INFO
/** Bone name for determining head direction */
var()	name	SightBoneName;

/** Chance this AI type has to blind fire */
var config float	BlindFirePct;
// FIRE TICKET VARIABLES
/** Number of fire tickets allowed for this pawn -- -1 == Infinite */
/** CALL SetNumberOfFireTickets TO CHANGE */
var config int		NumFireTickets;
/** Claimed fire tickets for this pawn */
var array<Controller> FireTickets;

/** if part of a Horde wave, the index of this enemy in the Horde enemy list */
var EnemySelection HordeEnemyEntry;

/** in Arcade mode, base number of points awarded for dealing 100% damage to this Pawn */
var config int ArcadeBasePointValue;

enum EBodyStance
{
	/** Full Body */
	BS_FullBody,
	/** Standing Upper Body */
	BS_Std_Up,
	/** Standing, idle, lower body */
	BS_Std_Idle_Lower,
	/** Standing cover */
	BS_CovStdIdle,
	BS_CovStdIdle_Up,
	BS_CovStdBlind_Up,
	BS_CovStdLean_Up,
	BS_CovStd_360_Upper,
	/** mid level cover */
	BS_CovMidIdle,
	BS_CovMidIdle_Up,
	BS_CovMidBlindSd_Up,
	BS_CovMidBlindUp_Up,
	BS_CovMidLean_Up,
	BS_CovMid_360_Upper,
	/** Overlays/Additive */
	BS_Additive,
	BS_Kidnapper_Upper,
	BS_Hostage_Upper,
	BS_Shield_Hunkered,
	BS_MortarMounted,
	/** First layer of Layering System, directly on top of Core Set */
	BS_Layer1,
	/** Standing Cover layer, Ready. On top of core animations */
	BS_Layer_StdCov_Ready,
	/** Mid Cover layer, Ready. On top of core animations */
	BS_Layer_MidCov_Ready,
	/** Standing Cover layer, Ready, Idle channel. On top of core animations */
	BS_Layer_StdCov_Ready_Idle,
	/** Mid Cover layer, Ready, Idle channel. On top of core animations */
	BS_Layer_MidCov_Ready_Idle,
	BS_Layer_StdCov_BackToWall,
	BS_Layer_StdCov_BlindSide,
	BS_Layer_StdCov_Lean,
	BS_Layer_MidCov_BackToWall,
	BS_Layer_MidCov_BlindSide,
	BS_Layer_MidCov_BlindUp,
	BS_Layer_MidCov_Lean,
	BS_Layer_Stand_Idle_Idle,
	BS_Layer_Stand_Walk_Idle,
	BS_Layer_Stand_Walk_Aim,
	BS_Layer_Stand_Run_Idle,
};

struct native CustomCameraAnimPropertiesStruct
{
	/**
	* true if the camera system should only do single-ray penetration checks while this
	* anim is playing.	basically disables predictive camera zooming.
	*/
	var bool bSingleRayPenetrationOnly;

	/**
	* true if the camera bone code apply the entirety of the camera bone motion to
	* the camera.  basically disables camera bone motion dampening, useful for special
	* camera moves.
	*/
	var bool bApplyFullMotion;

};

/** Cache nodes for convenience */
var		transient	Array<AnimNodeAimOffset>	AimOffsetNodes;
var()	transient	Array<AnimNodeSlot>		    BodyStanceNodes;
var		transient	AnimNodeSlot				CustomCameraAnimNode;
var		CustomCameraAnimPropertiesStruct		CustomCameraAnimProperties;
var		transient	Array<AnimNodeSequence>		ResumePlayNodes;
var		transient	GearAnim_UpperBodyIKHack	IKHackNode;
var		transient	GearAnim_BlendAnimsByAim	BlendByAimNode;
var		transient	GearAnim_BaseBlendNode		BaseBlendNode;
var		transient	GearAnim_BlendList			BlendByAimToggle;

/** MorphNodeWeight for meatshield */
var		transient	MorphNodeWeight				MeatShieldMorphNodeWeight;
var					FLOAT						MeatShieldMorphTimeToGo;
var					FLOAT						MeatShieldMorphBlendTime;
var					bool						bActivateMeatShieldMorph;
var                 FLOAT                       MeatShieldTargetWeight;
var					Name						MeatShieldMorphTargetName;
/**
 * Fix weapon position when in "downsights" animation, so character appears to be aiming.
 * This can be per character, per weapon, as needed.
 */
var transient	vector WeaponAimIKPositionFix;

/** If TRUE, IK Status should be locked */
var bool		bLockIKStatus;

/** camera bone motion scale */
var float	CameraBoneMotionScale;

/** How much to damp the camera shake while in roadie run */
var config float RoadieRunShakyCamDampeningFactor;

struct native BodyStanceInternal
{
	var() EBodyStance Slot;
	var() Name AnimName;
};

/** A Body stance variable */
struct native BodyStance
{
	var() Array<BodyStanceInternal>	Stance;
};

var bool bUsesBodyStances;

/** Body Stance used by Kismet Action GearPlayerAnim */
var BodyStance						KismetBodyStance;
/** AnimSets set by Kismet */
var repnotify AnimSet KismetAnimSets[2];
/** AnimTree set by Kismet */
var repnotify AnimTree ReplicatedKismetAnimTree;
/** Body Stance used for speech gestures. */
var protected transient BodyStance	SpeechGestureBodyStance;
/** Custom animsets that are set locally and not replicated */
var array<AnimSet> CustomAnimSets;

// Move Cycle Override
/** List of MoveCycleOverride Sequence Actions. Keep track of them. */
var Array<SeqAct_OverrideMoveCycleAnims> MoveCycleOverrideSeqActList;
/** Pointer to currently playing MoveCycleOverride */
var transient SeqAct_OverrideMoveCycleAnims CurrentMoveCycleOverrideSeqAct;
/** Replicated pointer to currently playing MoveCycleOverride */
var repnotify SeqAct_OverrideMoveCycleAnims ReplicatedMoveCycleOverrideSeqAct;
/** Counter for CurrentMoveCycleOverride */
var transient FLOAT CurrentMoveCycleOverrideDelayCounter;

/** bodystance for when pawn is riding junker*/
var BodyStance	BS_Junker_Driving_Idle;
var BodyStance	BS_Junker_Passenger_A_Idle;
var BodyStance	BS_Junker_Passenger_B_Idle;

// Animation state variables

/** TRUE if doing a transition/blend between CoverAction animations. */
var	const	transient	bool			        bDoingCoverActionAnimTransition;
var const   transient   GearAnim_CoverBlend     CoverBlendNode;
var const	transient	INT				        CoverActionAnimUpdateTickTag;
/** Last Cover Action set by animations. */
var const	transient	ECoverAction	LastCoverActionAnim, CoverActionAnim;

/** Accumulator for AimOffset Update */
var transient float AimOffsetUpdateTimeAcc;

/** AimOffset interpolation speed */
var() config float AimOffsetInterpSpeedHuman;
var() config float AimOffsetInterpSpeedHeadTrack;

/** Special weapon reload aimoffset interpolator */
var transient TAlphaBlend AimOffsetWeaponReloadInterpolator;
/** AimOffset interpolator used by special moves */
var transient TAlphaBlend AimOffsetSpecialMoveInterpolator;

/** vars for controlling headtrack aimoffset interp. */
var protected transient rotator LastHeadTrackDeltaRot;
var protected transient rotator LastHeadTrackRunDeltaRot;
var protected transient bool	bDoingHeadTrackAimOffsetInterpolation;
var protected transient bool	bDoingHeadTrackRunOffsetInterpolation;

var transient float HeadTrackTime;
var config	  float HeadTrackDuration;
var transient float HeadTrackRunInterpTime;
var config	  float	HeadTrackRunInterpDuration;

// below variables are used blending between aimoffset and head tracking
// this is to handle in/out or between
var config		float HeadTrackBlendSpeed;
// this is when no aim/aim during transition or no cover to cover
var config		float HeadTrackBlendSpeedModiferWhenSwitch;

// current blend speed
var protected transient float HeadTrackCurrentBlendSpeed;
// current weight to target
var protected transient	float HeadTrackBlendWeightToTarget;
// target weight (0 : only aimoffset and 1 : only head tracking)
var protected transient	float HeadTrackBlendTargetWeight;
var protected transient bool  WasHeadTracking;

/**
 * 2d vector, representing a rotation offset percentage from actor's rotation. Used by Aim anim nodes.
 * Range used (-1,-1) to (+1,+1) (angle equivalent : (-90d,-90d) to (+90d,+90d))
 */
var() vector2d	AimOffsetPct;

/**
 * This is the replicated version of AimOffsetPct that other clients will interpolate to.
 * Using FRotator compression with roll forced to 0
 */
var rotator		ReplicatedAimOffsetPct;
/** This is inpolation variables for replicatedaimoffsetpct due to rotator clamped to byte **/
var transient rotator		CurrentTargetAimOffsetPct;
var transient rotator		CurrentAimOffsetPct;
/** Offset used to offset some animations. For example chainsaw dueling on slopes, to play an animation based on height differences. */
var vector2d	PositionAdjustAimOffsetPct;
/** Interpolator for AimOffsets when moving. Force Yaw to be zero to save on replication. */
var TAlphaBlend MovementAimOffsetInterp;

/**
 * whether or not we are switching weapons.	 this is used as yet another check to see if we can fire our weapon
 *
 * @see GearPC.CanFireWeapon()
 * @see PlayWeaponSwitch()
 * @see TurnOffWeaponSwitchingFlag()
 **/
var bool bSwitchingWeapons, bEquipTransition;

/**
 * FOV used by Pawn to acquire cover.
 * Represents (1.f - dot product) between direction pawn is searching, and direction from Pawn to Cover.
 * 0.f = 0d FOV, 1.f = 180d FOV.
 */
var config float PawnAcquireCoverFOV;
var config float PawnAcquireCoverFOVRoadieRun;

/**
 * FOV relative to Cover to see if Pawn can acquire it.
 * Represents (1.f - dot product) between cover normal direction, and direction from Cover to Pawn..
 * 0.f = 0d FOV, 1.f = 180d FOV
 */
var config float CoverAcquireFOV;
/** Same as above, but when roadie running */
var config float RoadieRunCoverAcquireFOV;

/** Scales Pawn cylinder size, used for cover slot snapping */
var config float CoverSnapScale;

/** Currently acquired cover link */
var CoverLink CurrentLink;

/** Last result from GuessAtCover() */
var CoverInfo CachedCoverGuess;
var float LastCoverGuessTime;

/** Index to current slot being used in CurrentLink */
var int CurrentSlotIdx;
/** Index to the closest slot being used by this pawn */
var int ClosestSlotIdx;
/** Old current slot idx when leave cover - used for swat turns */
var int PreviousSlotIdx;
/** AI is adjusting to this slot */
var CoverInfo TargetSlot;

/** Current left/right slots, for interpolation (see AGearPawn::calcVelocity) */
var int LeftSlotIdx, RightSlotIdx;

/** Current interpolation pct between LeftSlotIdx & RightSlotIdx (see AGearPawn::calcVelocity) */
var float CurrentSlotPct;

/** Represents the direction we are traveling between cover slots */
var ECoverDirection CurrentSlotDirection;
/** Current cover lean direction for the camera, independent of the cover action */
var transient ECoverDirection CoverDirection;

/** Current cover lean direction sent from client when entering cover (used in FindBestCoverSideFor()) */
var transient ECoverDirection ReplicatedCoverDirection;

/** Make sure ReplicatedCoverDirection kept current */
var float FreshCoverDirectionTime;

/** Is player in stationary cover */
var bool bIsInStationaryCover;

/** Pawn is in a lit area - used for Kyrll interaction */
var bool	bInLitArea;
/** Pawn already has a kyrll controller associated with him */
var bool	bKyrllEnabled;

/** override for amount of damage dealt by melee when holding a hostage (<= 0 to use weapon damage) */
var config float KidnapperMeleeDamage;
/** This is the range that Pawns can MeleeAttack in Unarmed. */
var() config float UnarmedMeleeRange;
/** used for replication of melee attacks */
var bool bDoingMeleeAttack;

/** Controller wants to do a melee attack */
var				bool bWantsToMelee;

/** special flag for the alternate melee of the chainsaw, so that remote clients know when to do it
 * @todo: should be an alternate firemode, but too much code assumes MELEE_ATTACK_FIREMODE is the only one
 */
var bool bWantChainsawBash;

/** True if this pawn should be kicked after a chainsaw attack */
var const bool bWantChainsawKick;
/** if > 0.0, Pawn dies at this point of chainsaw anim instead of waiting for the anim notify */
var const float ChainsawOverrideDeathTime;

/** Whether this pawn can do the melee kick */
var const bool bCanMeleeKick;

/** This is what character footstep type this pawn is **/
var ECharacterFootStepType CharacterFootStepType;
var bool bShouldPlayWetFootSteps;

/** Volume modifier attached to friendly and enemy footstep sounds. 1.0 means use the default volume. */
var config float TeamFootStepVolume;
var config float EnemyFootStepVolume;

/** Last time this pawn was shot at. (Includes near misses) */
var transient			FLOAT			LastShotAtTime;
var transient repnotify	BYTE			ShotAtCount;

// For Replication
var transient           BYTE            StopCringeCount;
var transient			FLOAT			LastCringeTime;
var transient repnotify	BYTE			CringeCount;

/**
 * Per DamageType cringe history.
 * This is so we can differentiate rapid fire weapons from rare ones like grenade explosions.
 * And do per weapon filtering.
 */
struct native CringeInfo
{
	var class<DamageType>	DamageType;
	var Array<FLOAT>		History;
	var FLOAT				NextCringeTime;
};
var	transient Array<CringeInfo>	NearHitHistory;
var transient Array<FLOAT>		CringeHistory;

/** Last time this pawn heard a bulletwhip sound */
var transient float LastBulletWhipTime;

/** Last time this pawn took damage **/
var transient float LastTookDamageTime;
var transient float LastPlayedDamageSound;

/** How much damage needs to be dealt before playing the HeavyDamage GUD */
var config int HeavyDamageGUDThreshold;

/** Last time this pawn fired a shot.  Recorded at BEGINNING of shot. */
var transient float LastWeaponStartFireTime;
/** Last time this pawn finished firing a weapon.  Recorded at END of shot. */
var transient float LastWeaponEndFireTime;
/** Last time this pawn blindfired their weapon. */
var transient float LastWeaponBlindFireTime;

/** last time we finished roadie running */
var transient float LastRoadieRunTime;

/** Last time pawn evaded - used by AI */
var transient float LastEvadeTime;
/** Last time pawn evaded into a wall - used for particles*/
var transient float LastEvadeIntoWallTime;

/** Min amount of time between AI evades */
var config float MinTimeBetweenEvades;
/** can't fire for this long after an evade ends */
var config float PostEvadeFireDelay;
/** can't fire for this long after a roadie run ends */
var config float PostRoadieRunFireDelay;

/**
 * This is the Percent of GroundSpeed at which a pawn moves when going backwards.
 * So if you want a 20% reduction you would set this value to 0.80
 **/
var() config float BackwardMovementSpeedPercentage;

/** This is the Percent of GroundSpeed at which a pawn moves when carrying a heavy weapon. */
var() config float HeavyWeaponMovementSpeedPercentage;

/** This is the Percent of GroundSpeed at which a pawn moves when carrying a heavy weapon. */
var() config float HeavyWeaponMovementBoostSpeedPercentage;

/** This is the Percent of GroundSpeed at which a pawn moves when carrying a heavy weapon and firing. */
var() config float HeavyWeaponFiringMovementSpeedPercentage;

/** This is the Percent of GroundSpeed at which a pawn moves when swinging a cleaver */
var() config float CleaverSwingMovementSpeedPercentage;

/** This is the Percent of GroundSpeed at which a pawn moves when carrying a shield. */
var() config float ShieldMovementSpeedPercentage;

/** This is the Percent of GroundSpeed at which a pawn moves when carrying a shield and firing. */
var() config float ShieldFiringMovementSpeedPercentage;

/** Time last cover slipped, used for a temp speed boost for roadie run from slip. */
var transient float RoadieRunBoostTime;

/** Don't allow ServerMove to stop a roadie run if there's a queue roadie run move coming up soon */
var transient float QueuedRoadieRunMoveTimeStamp;

/** Current boost modifier for crawling speed. */
var repnotify transient float CrawlSpeedModifier;

/** The time we last did a melee attack **/
var transient float LastMeleeAttackTime;

/** The effect to play when impacted by a melee hit **/
var ParticleSystem PS_MeleeImpactEffect;

/** The effect to play when impacted by a radial explosive damage hit **/
var ParticleSystem PS_RadialDamageEffect;

/** The effect to play when impacted by a giant blade along the floor plane (used for Gunker, but could be used by knives, swords, etc) **/
var ParticleSystem PS_GiantBladeDamageEffect;
/** The effect to play when impacted by a giant blade from above (used for Gunker, but could be used by knives, swords, etc) **/
var ParticleSystem PS_GiantBladeFromAboveDamageEffect;

/** CoverAction used when mounting heavy weapon (on top of cover, leaning) */
var transient ECoverAction					HeavyMountedCoverAction;
/* CoverType used when mounting heavy weapon */
var transient ECoverType					HeavyMountedCoverType;

/** Cached Array of recoil nodes */
var transient Array<GearSkelCtrl_Recoil>	RecoilNodes;
var transient SkelControlLookAt				HeadTrackSkelControl;
var transient SkelControlLookAt				EyeTrackSkelControl;
/** Bone name of left eye bone. */
var protected const Name					EyeBoneNameLeft;
/** Bone name of right eye bone. */
var protected const Name					EyeBoneNameRight;

/** Test node for troika */
var	transient GearAnim_BlendList		TroikaBlendNode;

/** Cached mirror node for this character */
var transient GearAnim_Mirror_Master	MirrorNode;
/** DBNO Crawl node */
var transient AnimNodeSequence			DBNOCrawlNode;
/** Root AnimTree node */
var	transient AnimTree					AnimTreeRootNode;

// IK Controllers
var() editinline editconst transient SkelControlLimb		IKCtrl_RightHand, IKCtrl_LeftHand, IKBoneCtrl_RightHand, IKBoneCtrl_LeftHand;
var() editinline editconst transient SkelControlSingleBone	IKRotCtrl_RightHand, IKRotCtrl_LeftHand;

/** SkelControls used to lock hostage head in place. */
var transient SkelControlBase HostageHeadLock, HostageHeadLockIK;

/** If TRUE, Pawn can do turn in place animations */
var	bool	bCanDoTurnInPlaceAnim;

/** An aim attractor is a point that the player autoaim code will attempt to target. */
struct native AimAttractor
{
	/** Attraction is scaled from 0 at this radius to 100 at the inner radius. */
	var() float		OuterRadius;

	/** Inside this radius, attraction is 100%. */
	var() float		InnerRadius;

	/** Bone to attach to */
	var() Name		BoneName;
};

/** array of aim attractors attached to this pawn */
var()	Array<AimAttractor>	AimAttractors;
var()	globalconfig	bool bDebugAimAttractors;


//@fixme - move these properties to the special move classes
/** camera shake to play when hitting the wall during a run2cover move */
var() const protected GearCameraShake Run2CoverCameraShake;

/** Distance threshold for minimum camera shake (scale = 0.f) */
var() float Run2CoverMinCameraShakeDistSqThreshold;
/** Distance threshold for maximum camera shake (scale = 1.f) */
var() float Run2CoverMaxCameraShakeDistSqThreshold;

/** Is this pawn in the process of spawning? (ex. crawling out a hole) */
var bool	bSpawning;

/** Any extra camera offset to apply for this pawn.  Used for making minor pawn-specific tweaks without making a whole new pawn-specific set of modes. */
var() const vector ExtraThirdPersonCameraOffset;

/** Which GUDData-based class I should be using for...umm.. GUD data. */
var array<string>				MasterGUDBankClassNames;

/** Index of the GUDBankClass currently being used by this pawn. */
var transient int				LoadedGUDBank;

/** TRUE if this pawn cannot speak GUDS lines temporarily. */
var protected transient bool	bMuteGUDS;

/** Is this pawn in the process of speaking a line? */
var transient bool				bSpeaking;
/** True to turn on speech debug logging. */
var() protected bool			bDebugSpeech;
/** priority of actively speaking line, used to determine if we should interrupt  */
var protected transient ESpeechPriority	CurrentSpeechPriority;

/** Data that describes a spoken line of dialogue. */
struct native SpeakLineParamStruct
{
	var GearPawn					Addressee;
	var	SoundCue					Audio;
	var String						DebugText;
	var bool						bNoHeadTrack;
	var ESpeakLineBroadcastFilter	BroadcastFilter;
	var bool						bSuppressSubtitle;
	var ESpeechPriority				Priority;
	/** how long to wait until playing the sound */
	var float						DelayTime;
	/** how long after line is finished to keep looking at addressee */
	var float						ExtraHeadTrackTime;
};

/** Spoken line description used to broadcast speech to all clients. */
var protected repnotify SpeakLineParamStruct	ReplicatedSpeakLineParams;
/** spoken line description that's next in the queue */
var protected SpeakLineParamStruct QueuedSpeakLineParams;
/** Description of currently playing spoken line. */
var SpeakLineParamStruct						CurrentSpeakLineParams;

/** handle to audio for speech that is currently playing */
var AudioComponent								CurrentlySpeakingLine;

var float										SpeechPitchMultiplier;

/** Pawn Rotation Interpolation between lock/unlock, and cover in/out transitions */
var()	float	PawnRotationInterpolationTime;
/** Counter for the above */
var		float	PawnRotationBlendTimeToGo;
/** Special Interpolation mode for cover transition, Doesn't take shortest path for rotation interp. */
var		bool	bRotInterpCoverTransition;
var		Rotator	LastCoverRotation;

var protected transient repnotify TakeHitInfo LastTakeHitInfo;
/** LastTakeHitInfo will be checked for replication until this time is reached (so new clients don't get random old effects, etc) */
var protected transient float LastTakeHitTimeout;
var FLOAT		NextHitReactionAnimTime;
/** server only flag set when we should go DBNO at the end of the current special move */
var bool bDelayedDBNO;

/** Array of most recent hits this pawn has taken */
var array<HitStruct> RecentHits;

/** Amount of time before a hit is no longer considered recent */
var float RecentHitTime;

/** Is this pawn capable of being knocked DBNO from damage? */
var bool bCanDBNO;
/** Is this pawn capable of being revived from DBNO? */
var bool bCanRecoverFromDBNO;

/** flag valid only when DBNO of cached gametype result of execution from afar check (so clients know) */
var bool bCanBeExecutedFromAfar;

/** If TRUE, vehicle do damage when hitting this GearPawn */
var bool bCanBeRunOver;

/** If TRUE, this GearPawn can set off planted grenades */
var bool bCanTriggerGrenadeTrap;

/** material used to draw our head in taccom */
var MaterialInterface HeadIcon;

/** Texture ref to the large character portrait for this pawn */
var const Texture2D ArcadeCharacterPortrait;

/** Texture ref to the small headshot character portrait for this pawn, used in the wingman EOR scoreboard */
var const Texture2D SmallCharacterHeadshot;

/**
 * handles to the audiocomponents for revive sounds actively playing.
 * gotta store here since we can't have locals in latent state code where this is used
 */
var AudioComponent ReviveBreathSound;
var AudioComponent FlatLiningSound;
var AudioComponent ReviveHeartbeatSound;
var AudioComponent NearDeathBreathSound;

/** Current auto self revive stage - it starts from 0 (nothing) to 3 (revived) **/
enum EReviveAnimType
{
	ERAT_RECOVER,
	ERAT_FAIL,
	ERAT_LOOP,
};

/** Flag telling if Pawn is current traversing a fortification wall (barbed wire) */
var repnotify transient bool bTraversingBarbedWire;

/** Allow Self Reviving **/
var repnotify transient bool bAllowSelfReviving;
/** Is Playing Self Reviving **/
var transient bool bPlayingSelfReviving;
/** Finished Self Reviving **/
var repnotify transient bool bFinishedSelfReviving;
//var transient bool bDoFastReviving;
/** Current Reviving Stage 0->1->2 **/
var transient int CurrentReviveStage;
/** Revive Anim Type **/
var transient EReviveAnimType   ReviveAnimType;

/** Revive anim information **/
struct native ReviveStageAnim
{
	var array<BodyStance>   ReviveAnims;
	var float               LoopTime;
};

/** Stage 0 - 1 - 2 **/
var array<ReviveStageAnim>   ReviveStageAnims;

/** Do we allow inventory drops on death? */
var bool bAllowInventoryDrops;

/** Should this AI allow hit impact decals on its skel mesh**/
var() bool bAllowHitImpactDecalsOnSkelMesh;

/** Should this AI spawn hit effect decals **/
var() bool bSpawnHitEffectDecals;

/** Should this AI spawn blood trail decals **/
var() bool bSpawnBloodTrailDecals;

/** This is to cap the number of "constrain broke" effects we spawn per guy. **/
var() int NumConstraintEffectsSpawnedMax;
var transient int NumConstraintEffectsSpawned;

/** Whether or not this pawn should play the death scream. (i.e. aerial combat or mobs that are far away don't need this on at all)**/
var() bool bDisableDeathScreams;

/** True if I am in "using commlink" mode, false otherwise.	 This is true during the transition animations */
var bool bUsingCommLink;
/** True if I want to be in using commlink mode, but I haven't made it there yet */
var repnotify bool bWantToUseCommLink;
/** True if I have fully entered the using-commlink body stance.  False during transition animations */
var bool bInCommLinkStance;

/** True if I am in conversation mode */
var bool bIsConversing;
/** True is I want to be in conversing state, but I haven't made it there yet */
var repnotify bool bWantToConverse;

/** The reviving blood pool **/
/** TimeSeconds of when the pawn went DBNO */
var				bool					bWasDBNO;
var				float					TimeOfDBNO;
var				byte					DBNOTimeExtensionCnt;
var				Controller				ControllerWhoPutMeDBNO;
var				class<GearDamageType>	DamageTypeThatPutMeDBNO;
var				vector				    MomentumThatPutMeDBNO;
var				float					TimeStampEnteredRevivingState;
var repnotify	byte					bSpawnABloodPool;

/** This is the Particle system that is played on the pawn when they are DBNO **/
var ParticleSystem			DBNO_BloodCrawlSpurtTemplate;

/** particle effect played when we took damage but don't have enough info to use the normal weapon/physical material system */
var ParticleSystem DefaultBloodEffectTemplate;
/** Particle systems for damage-based blood effects */
var ParticleSystem BloodLowHitTemplate;
var ParticleSystem BloodGoreExplosionTemplate;
var ParticleSystem BloodGoreConstraintBrokenTemplate;
/** Emitter for effects when this pawn is hit with a shotgun */
var class<EmitterCameraLensEffectBase> ShotgunCameraLensEffectTemplate;


/** Whether or not to show the fatal death blood effects **/
var bool bShowFatalDeathBlood;

/**
 * If the pawn died by bleeding out.  We need to store this state as we call up into Pawn and then
 * back down into the GearPawn for death events.
 **/
var bool bBledOut;

/** When DBNO, beyond this health threshold the Pawn dies. */
var(MeatShield) config		INT			DBNODeathThreshold;
var(MeatShield) config		INT			HostageDefaultHealth;
var(MeatShield) config		INT			HostageDeathThresholdByHeadshot;
var	repnotify				INT			HostageHealth;
/** time until we get up after being kidnapped (for Pawns that don't die as a result of being taken hostage) */
var config float KidnapRecoveryTime;

/**
 * Half Angle in degrees of protection. From 0d to 90d (90d being full front protection).
 * Note, that damage is interpolated with x^2. So with 90d HalfAngleOfProtection, damage would be:
 * Shot from 0d = 0% damage. Shot from 45d = 25% damage. Shot from 90d = 100% damage.
 */
var(MeatShield) config		float	KidnapperHalfAngleOfProtection;

/**
 * Set to TRUE when hostage has been turned into pseudo rag doll for hostage gibbing.
 * But Pawn hasn't died yet.
 */
var							bool			bInMeatShieldRagDoll;
/** List of bodies to unfix when in Meat Shield rag doll. */
var(MeatShield) editinline	Array<Name>		MeatShieldUnfixedBoneList;

/**
 * Time when hostage was released.
 * With splash damage weapons, sometimes the hostage is killed before the kidnapper.
 * So the kidnapper is not considered protected anymore and can die.
 * Use this variable, to keep the kidnapper protected for this frame.
 */
var							float			HostageReleaseTime;

// if this is on GetPhysicalFireStartLoc will return Location + (FireOffset >> Rotation);
var							bool			bUseSimplePhysicalFireStartLoc;

enum EGearDeathType
{
	GDT_NORMAL,
	GDT_HEADSHOT,
};

/**
 * This tells us which tier the active reload chaining is on.
 *
 **/
var byte ActiveReload_CurrTier;
var repnotify bool bActiveReloadBonusActive;

/** Which one of my bones to focus on when playing pickup special move */
var Name PickupFocusBoneName;
/** Which one of my bones to focus on when playing kickup version of the pickup special move */
var Name PickupFocusBoneNameKickup;

/** which GUD event to throw when I get spotted. */
var() const EGUDEventID NoticedGUDSEvent;
/** How "threatening" I am.  Used by battle status code to prioritize notice events. */
var() const float NoticedGUDSPriority;
/** True to disregard this pawn for noticed events. */
var() const bool bSuppressNoticedGUDSEvents;
/** True to never play generic noticed GUDs */
var() const bool bForceSpecificNoticedGUDSEvent;

/** Reference to the wheel trigger the warpawn is in for turning valves */
var Trigger_Engage EngageTrigger;

/** Reference to the trigger the pawn is in for playering the custom animation */
var repnotify Trigger_ScriptedMove ScriptTrigger;

/** Reference to the trigger the pawn is in for interacting with a door */
var Trigger_DoorInteraction DoorTrigger;
/** Whether this gearpawn is in a door trigger or not */
var repnotify bool bInsideDoorTrigger;

/** Can this pawn pick up weapons from weapon factories */
var bool bCanPickupFactoryWeapons;

/** Reference to a Ladder trigger */
var Trigger_LadderInteraction	LadderTrigger;

/** Roadie Run particle effects **/
var ParticleSystemComponent PSC_RoadieRun;
var ParticleSystem PS_RoadieRun;
var TraceHitInfo LastFootStepTraceInfo;
var PhysicalMaterial LastFootStepPhysMat;

/** Number of times this pawn has been down but not out in MP. */
var int		DownCount;
/** Max number of times this pawn can be down but not out in MP. */
var config int		MaxDownCount;
/** If set to non-zero, overrides the GRI's InitialRevivalTime */
var repnotify transient int OverrideRevivalTime;


/** Damage multiplier for making pawns super troopers (mainly for making AI kill faster) */
var float SuperDamageMultiplier;

/** Time this warpawn revived from death */
var float TimeOfRevival;
/** remembers the team we were on pre-death as our PlayerReplicationInfo will be disconnected */
var byte LastTeamNum;

/** The pawn's light environment */
var() DynamicLightEnvironmentComponent LightEnvironment;

/** last time we played the full body cringe (SM_CoverHead) */
var float LastCoverHeadTime;
/** multiplier to all special-duration cringe effects (cringes using the default duration are not affected) */
var float CringeDurationMult;

/** looping head-covering bodystance */
var private BodyStance BS_HeadCoverLoop;

/** True if pawn is doing head-cover anims */
var transient repnotify bool bCoveringHead;

/** If true, Pawn may not roadie run. */
var transient bool bCannotRoadieRun;

/** Information about the last gudline pawn has played, to avoid rapid line duplication. */
var transient SoundCue		LastGUDLinePlayed;
var transient float			LastGUDLinePlayedTime;
var const float				GUDLineRepeatMin;
/** Min time that must elapse between any 2 GUDS lines. */
var() protected const float	MinTimeBetweenAnyGUDS;


/* Material used to control the pawn colorization based upon distance */
//var MaterialInstanceConstant PawnColorMatInstance;
var transient MaterialInstanceConstant MPRimShader;

/** Number of active OwnerNoSee requests */
var private transient int OwnerNoSeeCount;

/** Inside this cylinder, camera's using this pawn as a target will turn off owner rendering for this pawn */
var(Camera) protected cylinder CameraNoRenderCylinder_High;
var(Camera) protected cylinder CameraNoRenderCylinder_Low;
/** No-render cylinder to use if this pawn is the viewtarget */
var(Camera) protected cylinder CameraNoRenderCylinder_High_ViewTarget;
var(Camera) protected cylinder CameraNoRenderCylinder_Low_ViewTarget;
var(Camera) protected cylinder CameraNoRenderCylinder_FlickerBuffer;

/** Effect to play when the HOD burns someone **/
var()	ParticleSystem				PS_BurnEffect;

/** component for currently playing Burn effect */
var ParticleSystemComponent			BurnEffectPSC;

/** TRUE if this warpawn should block the camera, FALSE otherwise */
var() bool							bBlockCamera;
/** Whether the warpawn is not being rendered because the camera is inside of it */
var bool							bIsHiddenByCamera;
/** If true, instant fire traces hit this pawn and continue through */
var() bool                          bPassThroughDamage;

/** standard head sphere radius for multiplayer */
var float MPHeadRadius;

/** standard head center offset from head bone for multiplayer */
var(head) vector MPHeadOffset;


/**
 * SP FaceFXAnimSet which has all of the efforts for this guy.	We link them up at run time
 * so we can maintain nice encapsulated AnimSets on the content side.  Most characters have this
 * but there are  a few exceptions.	 Those will probably be fixed up soonish.
 **/
var array<FaceFXAnimSet> FAS_Efforts;  // always include the efforts for this guy

/**
 * This is the set of FaceFX Animsets that should be looked at by this pawn for dynamic GUDs package creation at cook time
 */
var array<string> FAS_ChatterNames;


/** SP FaceFXAnimSet which has all of the SP chatter **/
//var FaceFXAnimSet FAS_SinglePlayer;

/** SP FaceFXAnimSet which has all of the SP chatter **/
//var FaceFXAnimSet FAS_MultiPlayer;

/** Number of times the needs revived reminder has triggered. */
var() int NeedsRevivedReminderCount;

/** The amount of time which must pass with this pawn's remains not being seen before we destroy it **/
var float DurationBeforeDestroyingDueToNotBeingSeen;

/** Cylinder to use for view friction when pawn is crouched. */
var() cylinder CrouchedFrictionCylinder;

/** The distance which to trace out from the muzzle socket to see if we are attempting to shoot through wall **/
var float ShootingThroughWallTraceDistance;

/** Vars for doing special cam lookats during death cam mode */
var transient bool bOverrideDeathCamLookat;
var transient GearPawn DeathCamLookatPawn;
var transient Name DeathCamLookatBoneName;

/** Start up actor for Engage Matinee Mode
  * When you entered the mode, it saves the start up actor
  * So that you can be based on - instead of teleport
  */
var Actor EngageMatineeMode_Actor;

struct native PawnPhysicsImpulseInfo
{
	/** Linear velocity to apply to entire rigid body. */
	var vector LinearVelocity;
	/** Angular velocity to apply to entire rigid body. */
	var vector AngularVelocity;

	/** World-space origin of radial impulse. */
	var vector RadialOrigin;
	/** Radius of radial impulse.  If 0.0, no radial impulse will be applied. */
	var float RadialRadius;
	/** Strength of radial impulse. If 0.0, no impulse will be applied. */
	var float RadialStrength;
	//var float RadialFalloff;		// assume RIF_Linear

	/** Point impulse to apply.  if 0,0,0, no point impulse will be applied.  */
	var vector PointImpulse;
	/** Position in world space at which PointImpulse should be applied. */
	var vector PointImpulsePosition;
	/** Bone that receives point impulse. */
	var Name PointImpulseBoneName;
};

var repnotify PawnPhysicsImpulseInfo KnockdownImpulse;
var vector KnockdownStartingPosition;
var bool bCheckKnockdownFall;
/** whether we are able to be knocked down at all */
var config bool bCanBeKnockedDown;

/** Anim to play when knocked down */
var BodyStance BS_KnockDownAnim;
/** Whether to play animtion through physics motors when knocked down */
var	bool	bPlayMotorAnimOnKnockDown;
/** Strength of motors to use for knock-down anim */
var()	float	KnockDownMotorStrength;
/** Damping of motors to use for knock-down anim */
var()	float	KnockDownMotorDamping;
/** How motor strength varies over time after knockdown ('time since knockdown' is input, 'motor scale' is output) */
var()	InterpCurveFloat	KnockDownMotorScale;
/** Time (WorlInfo.TimeSeconds) that we were knocked down */
var		float	KnockDownStartTime;
/** AnimTree to switch to when recovering from rag doll */
var		AnimTree	RecoverFromRagdollAnimTree;

/**
* Range [0..1] to represent the elevation % for the mortar heavy weapon.  Put on the pawn so it replicates,
* since weapons themselves aren't synced.  Seems like there should be a cleaner way to do this,
* but hooray for prototyping.
*/
var transient float MortarElevationPct;
/** List of targets that we have missile lock on.  Used for heavy rocket launcher. */
var transient array<Actor>	MissileLockTargets;



/** Protection range when holding the shield.  Damage is 0% directly in front, and 100% at this angle. */
var protected const config	float	ShieldHalfAngleOfProtection;
/** Protection range when deploying the shield.  Damage is 0% directly in front, and 100% at this angle. */
var protected const config	float	DeployedShieldHalfAngleOfProtection;

/** Currently equipped shield. */
var		GearShield					EquippedShield;

/** Whether targeting should be blocked because we recently were forced to drop a shield */
var     bool                        bPreventTargetingDueToShieldDrop;

/** Currently equipped cleaver. */
var     GearWeap_CleaverBase        EquippedCleaver;

/** Currently equipped gas tank */
var     repnotify bool              bHasGasTank;
var     GearWeap_GasTankBase        EquippedGasTank;
var		SkeletalMeshComponent       EquippedGasTankComponent;
var     int                         EquippedGasTankHealth;

enum PawnOnFireState
{
	POF_None,
	POF_Blazing,        // engulfed in flame, will die shortly
	POF_Burning,        // somewhat on fire, can be put out
	POF_Smoldering,     // smoking, can be put out
	POF_BlazingInk,		// special case for tagged/engulfed with ink
};

var protectedwrite transient PawnOnFireState		OnFireState;
var protected transient repnotify PawnOnFireState	ReplicatedOnFireState;

/** Damagetype to use for fire, if it causes damage.  Set upon ignition. */
var protected transient class<GearDamageType>		OnFireDamageType;

/** True if this pawn is on fire, false otherwise. */
var protected transient bool			bOnFire;

/** Particle system to use for on-fire effects. */
var() protected const ParticleSystem	OnFireBlazingParticleSystem;
/** Particle system to use for on-fire effects. */
var() protected const ParticleSystem	OnFireBurningParticleSystem;
/** Particle system to use for on-fire effects. */
var() protected const ParticleSystem	OnFireSmolderParticleSystem;
/** Particle system to use for on-fire effects. */
var() protected const ParticleSystem	OnFireBlazingInkParticleSystem;
/** ParticleSystemComponent for active on-fire effects. */
var protected array<ParticleSystemComponent> PSC_OnFire;

/** Audio sample to use for the looping burning sound. */
var() protected const SoundCue			OnFireBlazingBurningSound;
/** Audio sample to use for the looping burning sound for local players. */
var() protected const SoundCue			OnFireBlazingBurningSound_Player;
/** Audio sample to use for the looping burning sound. */
var() protected const SoundCue			OnFireBurningSound;
/** Audio sample to use for the looping burning sound. */
var() protected const SoundCue			OnFireSmolderingBurningSound;
/** Audio sample to use for the looping burning sound. */
var() protected const SoundCue			OnFireBlazingInkBurningSound;
/** AudioComponent for active on-fire looping sound. */
var protected AudioComponent			OnFireAudioBurningLoop;

/** Fire damage when blazing. */
var() protected const config float      OnFireBlazingDamagePerSecond;
/** Fire damage when Burning. */
var() protected const config float      OnFireBurningDamagePerSecond;
/** Fire damage when Burning. */
var() protected const config float      OnFireBlazingInkDamagePerSecond;
/** player that caused us to be on fire */
var transient Controller                OnFireDamageInstigator;

/** List of bones to get the on-fire particle effects */
var protected const config array<Name>	OnFireParticleSystemBoneNames;

/** fractional DOT damage (applied when >= 1) */
var protected transient float           DamageOverTimeRemainder;


/** Particle system to use for Imulsion damage effects. */
var() protected const ParticleSystem	ImulsionParticleSystem;
/** ParticleSystemComponent for active imulsdion effects. */
var protected ParticleSystemComponent	PSC_Imulsion;

/** Audio sample to use for the looping imulsion sound. */
var() protected const SoundCue			ImulsionBurningSound;
/** AudioComponent for active imulstion looping sound. */
var protected AudioComponent			ImulsionAudioBurningLoop;

/** Emitter that plays when pawn takes a certain amount of flamethrower damage. */
var transient SpawnedGearEmitter		DamagedByFlamethrowerEmitter;

/** Should we enable debug damage text for tracking? */
var globalconfig bool bDebugDamageText;

/** Location of the last blood trail decal.  Needed to orient the decal correctly**/
var protected transient vector	LocationOfLastBloodTrail;

/** The max amount of decals that I am allowed to have on this pawn.**/
const MAX_DECALS_ATTACHED = 3;
var int NumDecalsAttachedCurr;
var int CurrDecalIdx;
/** This is times of when decals were attached to this pawn.  **/
var float DecalsAttached[MAX_DECALS_ATTACHED];


/** Skin "heating" data. */
var transient float				CurrentSkinHeat;
/** Min heat value we can go down to.  Useful for when you died by flames and want to leave the pawn "burning a bit" **/
var transient float				CurrentSkinHeatMin;
/** Current skin heat, used for determining when to ignite pawns. */
var transient float				CurrentIgnitionSkinHeat;
/** Maximum value for CurrentIgnitionSkinHeat */
var() protected const float     MaxIgnitionSkinHeat;

var() const float				SkinHeatDamagePctToFullyHeat;
var() protected float		    SkinHeatFadeTime;
/** additional damage over time based on skin heat */
var config float                HeatDamagePerSecond;
var transient Controller        HeatDamageInstigator;
var protected transient bool	bSkipCharFade;
var protected transient bool	bSkipHeatFade;
var() protected const float		SkinHeatFadeDelay;

/** Skin "charring" data. */
var protected transient float	CurrentSkinChar;
/** Min heat value we can go down to.  Useful for when you died by flames and want to leave the pawn "charred a bit" **/
var transient float				CurrentSkinCharMin;

var() protected float			SkinCharFadeTime;

/** Similar to God mode, in that you never die, but you still take damage and get the effects and whatnot. */
var() bool						bUnlimitedHealth;


/** True if pawn has unlimited ammo when human controlled */
var transient bool bUnlimitedAmmo;
/** True if pawn has unlimited clips when human controlled */
var transient bool bUnlimitedClips;

/** Currently targeted GDO used for administering damage */
var transient GearDestructibleObject TargetedGDO;
/** Damage of this type is applied to a GDO when bumped */
var() class<GearDamageType>     BumpGDODamageType;

/** class we have been mutated into visually by the Mutate Character Kismet action (@see OnMutate()) */
var repnotify class<GearPawn> MutatedClass;

/** list of bones that should be FIXED for bloodmount death */
var(BloodMountDeath) editinline	Array<Name>		BloodMountFixedBoneList;
/** turned on if we died while mounted on a bloodmount */
var GearPawn_LocustBloodmount BloodMountIDiedOn;

/** movement smoothing parameters */
/** three points of turn smoothing spline (set from movetogoal) */
var transient Actor FinalSplineActor,CurrentSplineActor,PrevSplineActor;
var transient BasedPosition FinalSplinePt; // used when we are not moving to an actor at final (like when we're moving to a set point and we're at the end of our path)
/** the (maximum) turning radius of this pawn when accel smoothing is on */
var() float TurningRadius;
/** the current turning radius we are using (based on TurningRadisu above, and scaled depending on how close to the goal we are) */
var transient float EffectiveTurningRadius;
/** whether or not to allow acceleration smoothing (should we enforce the above turning radius?)*/
var() bool bAllowAccelSmoothing;
/** Acceleration last frame */
var transient vector OldAcceleration;
/** whether to allow spline turn cornering */
var() bool bAllowTurnSmoothing;
/** accel smoothing will be ramped down within this distance */
var() float AccelConvergeFalloffDistance;
/** internal variable used for turn smoothing */
var transient float SmoothTurnStartT;
/** end movement smoothing params **/

/** GUID for checkpoint saved GearPawns so that references to them can be saved even though they will be recreated */
var Guid MyGuid;
/** percent chance that we will try and go DBNO */
var() config float LocustChanceToDBNO;

/** Actor we are forced to be based on unless teleported. This is a hack to keep the Pawn on certain movers (e.g. Derrick)
 * that the physics will occasionally insist we should detach from.
 */
var Actor ClampedBase;

/** Dueling mini game in progress */
var			bool		bInDuelingMiniGame;
/** Number of Button Presses done while chainsaw dueling. */
var			INT			DuelingMiniGameButtonPresses;
/** Duration of Chainsaw dueling mini game. */
var config	FLOAT		ChainsawDuelMiniGameDuration;
/** Angle in Radians between both players to start a chainsaw dueling. Basically telling if they're facing each other or not. */
var config	FLOAT		ChainsawDuelFacingDegreesAngle;
/** number of times AI is considered to have pressed the button during the dueling minigame */
var config	vector2d	AI_ChainsawDuelButtonPresses;

/** Is in Trigger MiniGame */
var			bool		bInTriggerMiniGame;
/** Last Trigger pressed  is right trigger. */
var			bool		bLastTriggerPressedIsRight;

/** Should chainsaw attack instant kill this Pawn? default is TRUE */
var bool	bShouldChainsawAttackInstantKillMe;

// Stopping Power

struct native StoppingPowerStruct
{
	/** Direction of the Hit */
	var()	Vector	Direction;
	/** Stopping power */
	var()	FLOAT	StoppingPower;
	/** Life Time of Stopping Power */
	var()	FLOAT	LifeTime;
};

/** Array of currently applied Stopping Powers */
var			Array<StoppingPowerStruct>	StoppingPowerList;
/** Max Stopping Power that can be applied */
var config	float						MaxStoppingPower;
var config  float                       MaxStoppingPowerDistance;
var const config float					StoppingPowerAngle;
var const config float					StoppingPowerHeavyScale;
/** Accumulated Stopping Power Threshold when roadie running to trigger a stumble */
var config	float						StoppingPowerRoadieRunStumbleThreshold;
/** whether to do stopping power at all for this pawn */
var config	bool						bAllowStoppingPower;

/** Current Marker for Grappling Hook */
var Gear_GrappleHookMarker				CurrentGrapplingMarker;

/** Where to start grappling from */
var vector	                            CurrentGrapplingStartPoint;

/** Grappling hook actor */
var GearInv_GrapplingHookBase       	GrapplingHook;

/** Which grappling hook to spawn */
var class<GearInv_GrapplingHookBase>    GrapplingHookClass;

/** Which rappel rope to spawn */
var class<Gear_RappelRopeBase>          RappelRopeClass;

/** Force animations to use velocity from Base */
var bool								bAnimForceVelocityFromBase;

/** Walkspeed when doing a "forcewalk", e.g. commlink action, camera volume. */
var() protected const config float		ForceWalkingPct;

// kantus revive skin effect mojo
var() config float						KantusSkinEffectFadeDuration;
var transient float						DesiredKantusFadeVal;
var transient float						CurrentKantusFadeVal;
var ParticleSystemComponent				KantusRevivePSC;
var GearPawn_LocustkantusBase			KantusReviver;

/** Hack to store off our controller during death processing, since it gets None'd out midway through. */
var transient Controller				ControllerBeforeDeath;





// cache packet for GetWeaponStartTraceLocation, bUpToDate toggled off at the end of each tick
var struct native WeaponStartTraceLocationCacheStruct
{
	var bool bUpToDate;
	var vector StartLoc;
	var Weapon WeaponCacheIsValidFor;
} WeaponStartTraceLocationCache;

var config array<PerDamageTypeMod> PerDamageTypeModifiers;

var repnotify bool bDisableShadows;

// location of the start of our last mantle
var vector LastMantleLocation;
// worldtime when we mantled last
var float  LastmantleTime;

/** TRUE if Pawn is fully blended into an aiming animation (ready or targeting, i.e. not relaxed or blending from relaxed).  NON-COVER. */
var transient	bool	bTargetingNodeIsInIdleChannel;
var transient	INT		TargetingNodeIsInIdleChannelTickTag;

// whether or not we should allow ourselves to be revived from automatic revivals (like at the end of combat)
var transient	bool	bAllowAutoRevive;

/** If true, do not emit a GUDS event for this pawn's death. */
var protected const bool	bNoDeathGUDSEvent;

/** Whether death one liners are set up for this pawn */
var bool bPlayOneLinerOnDeath;

/** How long to wait to play one liners after death */
var float OnDeathOneLinerDelay;

/** Sounds hooked up by a kismet action to play when we've been killed by a COG squad member */
var SoundCue OnDeathOneLiners[4];

/** replicated copy of material in slot 0 */
var repnotify MaterialInterface ReplicatedMaterial;

// don't allow anchor checks when in these physmodes
var array<EPhysics> ProhibitedFindAnchorPhysicsModes;

/** list of FaceFXAnimSets applied to this Pawn for replication to the clients */
var repnotify FaceFXAnimSet ReplicatedFaceFXAnimSets[3];
/** previously applied ReplicatedFaceFXAnimSets as we need to diff to know what to change locally */
var FaceFXAnimSet PrevReplicatedFaceFXAnimSets[3];

/** vars to deal with moving bases encoraching on based pawns */
var protected transient bool bBaseIsEncroaching;
var protected transient vector BaseEncroachInvNormal;
var protected transient vector BaseEncroachHitLocation;

/** Rotation Debug Variable : To detect big gap of yaw difference **/
/** Last Saved Yaw Value **/
var int LastSavedYaw;
/** WorldInfo.TimeSeconds when saved Last Yaw Value, so that we can get (Current Rotation Rate Per Second) to compare with (Rotation Rate) **/
var float LastSavedYawTime;
/** Multiplier to validate rotation -
 * if (Current Rotation Rate Per Second) > TolerableYawJumpThresholdMultiplier*(Rotation Rate)
 * Then it is invald - too much jump (or pop) of rotation
 **/

var config int TolerableYawJumpThresholdMultiplier;

/** sound played when spawning this Pawn in Horde */
var SoundCue HordeSpawnCry;

/** maximum amount of time we stay in ragdoll on knockdown before forcing the recovery to begin regardless of velocity */
var config float MaxKnockdownTime;
/** if TRUE, pawn will stay in ragdoll until explicitly told to get up. Reset to FALSE when KnockedDown state ends */
var transient bool bStayKnockedDown;

/** whether to enable cheat protection for players equipping a two handed weapon while holding a shield */
var config bool bShouldCheckShieldCheat;

/** Whether or not the actor can recharge health */
var() bool bCanRechargeHealth;

/** whether this pawn can knock over planted shields by meleeing them instead of using the kick special move */
var bool bCanMeleeShields;

/** head scale, for BigHead-type mutators and such */
var repnotify protectedwrite float HeadScale;

/** How to change the voice pitch when in big head mode */
var const float BigHeadVoicePitch;

/** swaps normal roadie run with GSM_RoadieRunComet (for the mutator) */
var repnotify protectedwrite bool bRoadieRunComet;

/** TRUE if currently in the process of taking radial damage.  Tells TakeDamage to do some different stuff. */
var transient protected bool bTakingRadiusDamage;
/** When taking radial damage, this is the epicenter of the damage. */
var transient protected vector RadialDamageOrigin;

/** if TRUE Then gore mask texture is created and hits are rendered to it */
var config bool bAllowGoreHitMask;
/* Texture used for gore mask material */
var transient TextureRenderTarget2D GoreMaskTexture;
/** HitMask Component **/
var SceneCapture2DHitMaskComponent HitMaskComponent;
/** HitMask Multiplier : it's too small for some big monsters **/
var FLOAT   HitMaskMultiplier;

/** Taccom Mesh Stuff*/
/** Mesh used for rendering in taccom */
var transient SkeletalMeshComponent TaccomMesh;

/** Unique position adjustment when a hostage. */
var const vector HostagePositionAdjust;

/** force per unit of velocity applied to dead, ragdolled Pawns we walk over
 * (instead of pushing with infinite mass, we do this and allow some clipping)
 */
var float RagdollPushForce;

/** Whether the player should be jogging instead of walking when in a walking volume */
var bool bIsRoadieJogging;

/** allow this Pawn to be seen through walls in tac-com even for enemies */
var bool bShowInEnemyTaccom;

/** if set, projectiles pass through this Pawn instead of blowing up on it (explosives cause damage on the way through) */
var bool bProjectilesPassThrough;

/** if set, this Pawn is so strong/heavy/etc that it runs right over fortifications - any it touches are instantly destroyed */
var config bool bInstakillsFortifications;
/** if set, fortifications that autotarget (sentry guns, etc) do not target this Pawn */
var bool bIgnoredByFortifications;

/** The gametime when last the player was within a lambent berserker damage actor */
var transient float TimeLastInLambBerserkDamageActor;
/** The camera anim to play when in a lambent berserker damage actor */
var transient CameraAnimInst BerserkerDamageActorCameraAnim;
/** The content for the camera animation players will show if they are standing in a damage actor */
var CameraAnim DamageActorCameraAnim;

/** The tutorial associated with this pawn for siege */
var EGearTutorialType SiegeTutorialType;

/** while loading a checkpoint, GUID of Pawn we need to set up in SM_DragInjured, but delayed to guarantee correct ordering */
var Guid PendingCarriedPawnGuid;

/** last time we did a full body hit reaction (SP/Horde AI only) to avoid doing them too frequently */
var float LastFullBodyHitReactionTime;

/** The percentage (from 0 to 1) of how much of the pawn's extent will be used when determining ledge checks in CheckForLedges() */
var float ExtentPercentageForLedgeChecks;

/** additional generic damage based particle system attached to our Mesh (electricity, fire, etc) */
struct native DamageFX
{
	var ParticleSystemComponent AttachedFX;
	var float                   DetachTime;
};

/** MAX FX that can be attached at the same time **/
const MAX_DAMAGE_FX  = 6;

var protected transient DamageFX AttachedDamageFXs[MAX_DAMAGE_FX];

/** This struct is used to break partially for heavy sniper rifle damage **/
struct native PartialBreakInfo
{
	/** Name of bone to child **/
	var name BoneNameToChild;
	/** Name of bone to break **/
	/** Bone To break vs Bone To Child doesn't have to match
	 *  Bone To break requires content gore to set up accordingly
	 *  where as Bone To Child check can be different **/
	var name BoneNameToBreak;
	/** Hide bone or not **/
	var bool bHideBone;
};

/** This is the customized skin for a weapon this pawn picked up */
var	repnotify CoolSkin PrimaryPickedupWeaponSkin;
/** This is the customized skin for a weapon this pawn picked up */
var	repnotify CoolSkin SecondaryPickedupWeaponSkin;

/** drawn over teammates' heads in competitive gametypes */
var Texture2D TeamBeacon, TeamBeaconTalking;
/** maximum size for team beacon */
var float MaxTeamBeaconSize;
/** maximum distance for full size beacon */
var float MaxFullSizeBeaconDist;
/** when beacon starts scaling, amount of distance to get to the minimum size */
var float MinSizeBeaconDist;

/** whether this Pawn can be healed by e.g. Kantus scream */
var bool bCanBeHealed;
/** if set, when a PC controls this Pawn < 50% health allies are drawn using their glowing taccom mesh instead of their normal mesh (regardless of taccom being on) */
var bool bSeesTaccomMeshForInjuredAllies;

var transient float LastCoverPushOutOffset;

/** Last time we checked for being inside gameplay area */
var transient float LastInPlayAreaCheckTime;
/** Were we out of gameplay area on last check? */
var transient bool bWasOutOfPlayArea;

/** Gravity scale */
var() config float GravityScale;


cpptext
{
	/**
	 * Returns TRUE if AimOffset should be turned off.
	 * That means an AimOffsetPct of (0,0), this will automatically handled interpolation, so it doesn't snap in and out of it.
	 */
	UBOOL ShouldDisableAimOffset();
	UBOOL ShouldApplyNudge(ACoverLink *Link, INT SlotIdx, UBOOL bIgnoreCurrentCoverAction = FALSE);

	/**
	 * Don't let sticky fire trace against our skeletal mesh.
	 * If the encroachment check finds the skeletal mesh component before the cylinder, the cylinder won't be considered and the
	 * encroachment result will be thrown out in AActor::FindTouchingActors() because the skeleton doesn't accept zero extent traces.
	 *
	 * @param Primitive - the collision primitive to test
	 *
	 * @param SourceActor - the actor that wants to trace against us
	 *
	 * @param TraceFlags - the flags of the current trace
	 *
	 * @return TRUE if the trace should proceed
	 */
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive, AActor *SourceActor, DWORD TraceFlags);

	virtual void TickSpecial(FLOAT DeltaSeconds);

	virtual FLOAT GetGravityZ();

	virtual FGuid* GetGuid();

	/** smooths out player movement on steps/slopes, primarily by adding mesh translation to spread out the Z change over time
	 * @param OldLocation - the Pawn's previous Location to compare against for adjustments
	 */
	void PerformStepsSmoothing(const FVector& OldLocation, FLOAT DeltaSeconds);

	/** Update the mesh component to make it match the Floor surface normal better */
	virtual void UpdateFloorConform(FLOAT DeltaSeconds);
	/** Returns floor normal. Defaults for Infantry Pawns, weighting Floor Normal, and four traces below collision cylinder */
	FVector GetFloorConformNormal();
	/** Get Mesh translation and slope angle from floor normal. Returns TRUE if normal is straight up. */
	UBOOL GetFloorConformTranslationAndAngle(FVector &InFloorNormal, FLOAT &OutTranslation, FLOAT &OutSlopeAngle, FVector &OutFloorNormal2D);
	void UpdateNormalInterpolation(FTAlphaBlend& AlphaInterpolator, FVector& CurrentNormal, const FVector& TargetNormal, FVector& BackupNormal, FLOAT DeltaTime, FLOAT InterpolationSpeed);

	virtual FLOAT MaxSpeedModifier();
	FVector CheckForLedges(FVector AccelDir, FVector Delta, FVector GravDir, int &bCheckedFall, int &bMustJump );
	virtual void CalcVelocity(FVector &AccelDir, FLOAT DeltaTime, FLOAT MaxSpeed, FLOAT Friction, INT bFluid, INT bBrake, INT bBuoyant);
	virtual void performPhysics(FLOAT DeltaSeconds);
	virtual void PostProcessPhysics( FLOAT DeltaSeconds, const FVector& OldVelocity );
	// called when physics == PHYS_RigidBody
	virtual void PostProcessRBPhysics(FLOAT DeltaSeconds, const FVector& OldVelocity);

	virtual void SetPostLandedPhysics(AActor *HitActor, FVector HitNormal);
	virtual void physicsRotation(FLOAT DeltaTime, FVector OldVelocity);
	virtual void TickSimulated(FLOAT DeltaSeconds);
	virtual void HandleSerpentineMovement(FVector& out_Direction, FLOAT Distance, const FVector& Dest ) { }
	virtual void stepUp(const FVector& GravDir, const FVector& DesiredDir, const FVector& Delta, FCheckResult &Hit);
	virtual UBOOL ResolveAttachedMoveEncroachment(AActor* EncroachedBase, const FCheckResult& OverlapHit);
	virtual void SyncActorToRBPhysics();

	virtual INT ModifyCostForReachSpec(UReachSpec* Spec, INT Cost);

	/** notification when actor has bumped against the level */
	virtual void NotifyBumpLevel(const FVector &HitLocation, const FVector& HitNormal);

	// Never try to jump over a wall
	virtual UBOOL TryJumpUp(FVector Dir, FVector Destination, DWORD TraceFlags, UBOOL bNoVisibility) { return FALSE; }

	virtual void OnRigidBodyCollision(const FRigidBodyCollisionInfo& MyInfo, const FRigidBodyCollisionInfo& OtherInfo, const FCollisionImpactData& RigidCollisionData);

	// Networking
	INT* GetOptimizedRepList(BYTE* InDefault, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel);

	virtual UBOOL GetMoveDelta(FVector& out_Delta, const FVector& Dest);
	UBOOL moveToward(const FVector &Dest, AActor *GoalActor );

	void UpdateCoverActionAnimTransition(INT InTickTag, UBOOL bInDoingTransition, UGearAnim_CoverBlend* InCoverBlendNode);
	void UpdateTargetingNodeIsInIdleChannel(INT InTickTag, UBOOL bInAimingStance);

	virtual void PreNetReceive();
	virtual void PostNetReceive();
	virtual void PostNetReceiveLocation();
	virtual void PostNetReceiveBase(AActor* NewBase);

	virtual UBOOL IsAliveAndWell() const;

	/**
	 * Determines if a particular special move is being used. Inlined to optimize multiple
	 * calls to this function from within the same function.
	 *
	 * @param AMove the special move type being checked
	 *
	 * @return true if the special move is being performed, false otherwise
	 */
	FORCEINLINE UBOOL IsDoingSpecialMove(BYTE AMove) const
	{
		return SpecialMove == AMove && !bEndingSpecialMove;
	}

private:
	void HeadTrackInterp( const FRotator & AimDeltaRot, const FRotator & HeadTrackDeltaRot, FRotator & OutDeltaRot );
	void UpdateHeadTrackInterp( const FLOAT & DeltaTime );

	/**
	 * Find a local player within a reasonable distance
	 * Verify the speaker is in front of the camera
	 * If not in cover, also verify that the speaker is facing the camera
	 *
	 * @return TRUE if FaceFX should be played this frame
	 */
	UBOOL ShouldPlayFaceFX();
}

replication
{
	// Replicated to ALL but Owning Player
	if ((!bNetOwner || bDemoRecording) && Role == ROLE_Authority)
		CoverType, CoverAction, AcquiredCoverInfo, bWantsToBeMirrored, bIsTargeting, bIsInStationaryCover, ReplicatedAimOffsetPct,
		ReplicatedSpecialMoveStruct, bIsZoomed, CrawlSpeedModifier, CurrentSlotDirection, bGrabbingMovableCover,
		bWantChainsawBash, bFinishedSelfReviving, ScriptTrigger;

	// replicatd to all but owning player unless dead
	if ((!bNetOwner || bDemoRecording) && !bTearOff && Role == ROLE_Authority)
		RemoteWeaponRepInfo, AttachSlotClass_Holster, AttachSlotClass_Belt, AttachSlotClass_LeftShoulder, AttachSlotClass_RightShoulder,
		bShowInEnemyTaccom;

	// Replicated to ALL
	if( Role == Role_Authority )
		AttachClass_Shield, bIsInCombat, bWantsToMelee, bForceTargeting, ReplicatedForcedAimTime, bSpawnABloodPool,
		bChargingWeapon, bWantToConverse, bWantToUseCommLink, ReplicatedSpeakLineParams,
		SpecialMoveLocation, bActiveReloadBonusActive,
		bCannotRoadieRun, bCoveringHead, EngageTrigger, LadderTrigger, DoorTrigger,
		MortarElevationPct, ReplicatedOnFireState, KnockdownImpulse, MutatedClass,
		ShotAtCount, CringeCount, CurrentGrapplingMarker, DesiredKantusFadeVal, KantusReviver,
		KismetAnimSets, ReplicatedKismetAnimTree, ReplicatedMoveCycleOverrideSeqAct, ReplicatedMaterial, DefaultHealth, ClampedBase,
		ReplicatedFaceFXAnimSets, bIsBleedingOut, HeadScale, bForceHeadShotGib, CoopWeaponSyncActor,
		bHasGasTank, bWeaponHolstered, bIsRoadieJogging, SpottedByTeam, SpottedBy, ReplicatedHeadTrackInfo, bTraversingBarbedWire,
		PrimaryPickedupWeaponSkin, SecondaryPickedupWeaponSkin, StopCringeCount;

	if (Physics == PHYS_RigidBody && !bTearOff && Role == ROLE_Authority)
		ReplicationRootBodyPos;

	if (bNetOwner && Role == ROLE_Authority)
		bCanPickupFactoryWeapons, bCanBlindFire, bInsideDoorTrigger, bPreventTargetingDueToShieldDrop;

	if( Role == Role_Authority && SpecialMove == SM_Hostage )
		HostageHealth;

	if( bNetOwner && (Role == ROLE_Authority) && bInDuelingMiniGame )
		DuelingMiniGameButtonPresses;

	// replicated to ALL only if recently hit
	if (Role == ROLE_Authority && WorldInfo.TimeSeconds < LastTakeHitTimeout)
		LastTakeHitInfo;

	// Replicated to ALL once (at spawn time)
	if( Role == ROLE_Authority && bNetInitial )
		DefaultGroundSpeed, bDisableShadows, bRoadieRunComet, bImmuneToSpecialMeleeAttacks, bCanRoadieRun;

	if( bTearOff && Role==ROLE_Authority )
		DurationBeforeDestroyingDueToNotBeingSeen, bEnableEncroachCheckOnRagdoll, KilledByPawn;

	if( bGrabbingMovableCover && Role == ROLE_Authority )
		ManipulateCoverInfo;

	// replicated while DBNO
	if (Role == ROLE_Authority && IsDBNO())
		bCanBeExecutedFromAfar, bAllowSelfReviving, OverrideRevivalTime;
}

exec function DumpFireLinkStats()
{
	DumpCoverLinkStats();
}

native function DumpCoverLinkStats();

// overidden to skip anchor checks when we're in sily phys modes SILLY!
native function NavigationPoint GetBestAnchor( Actor TestActor, Vector TestLocation, bool bStartPoint, bool bOnlyCheckVisible, out float out_Dist );

native function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

/** Read access to native APawn::MaxSpeedModifier() */
native final function float	GetMaxSpeedModifier();

native final function bool	IsInCover();
native final function bool	GuessAtCover( out CoverInfo out_Cover );

/** Retrieves the combat zone this navigation point encompassed by */
native final function CombatZone GetCombatZoneForNav( NavigationPoint Nav );
/** Claim cover for this pawn + bookkeeping */
native final function bool ClaimCover( CoverLink Link, int SlotIdx );
/** Unclaim cover for this pawn + bookkeeping */
native final function bool UnclaimCover( CoverLink Link, int SlotIdx, bool bUnclaimAll );

/**
 * Tries to find cover. Looking from FromLoc, towards direction, for MaxDistance units.
 * @param	FromLoc		Location to start looking from.
 * @param	Direction	to look towards to.
 * @param	FOV			Cover has to be within this FOV from Direction. (Dot, 0.f == 0d, 1.f == 180d)
 * @param	MaxDistance	Maximum distance cover can be at.
 * @param	OutCovPos	Cover information, if found.
 * @param (optional)    stuffed with the pawn that blocked us from using cover (if any)
 * @return	TRUE if valid cover was found.
 */
native final simulated function bool FindCoverFromLocAndDir(Vector FromLoc, Vector Direction, float FOV, float MaxDistance, out CovPosInfo OutCovPosInfo, optional out Pawn out_PawnInTheWay);

/**
  * If we've found potential cover, make sure it's usable.
  * @param	FromLoc					Location of player willing to enter cover
  * @param	Direction				Direction player is looking for cover
  * @param	FOV						Cover has to be within this FOV from Direction. (Dot, 0.f == 0d, 1.f == 180d)
  * @param	OutMaxDistanceSquared	Max Distance squared cover has to be from player. If less, then it is updated with new value.
  * @param	OutCovPosInfo			Cover information to validate.
  * @param (optional)    stuffed with the pawn that blocked us from using cover (if any)
  *
  */
native final simulated function bool ValidatePotentialCover(Vector FromLoc, Vector Direction, out float OutMinDotFOV, out float OutMaxDistanceSquared, out CovPosInfo OutCovPosInfo, optional out Pawn out_PawnInTheWay);

/**
 *	Fills in covposinfo vars given the cover slot
 */
native final simulated function FillCoverPosInfo( CoverLink Link, int LtSlotIdx, int RtSlotIdx, Vector FromLoc, Vector Direction, float MaxDistance, out CovPosInfo out_CovPosInfo );

/** calculates the cover Location, Normal, and Tangent for the given cover position that already has a valid Link, slot indices, and slot pct
 * also accounts for cover PushOutOffset
 */
native final function SetCoverPosVectors(out CovPosInfo CovInfo);

/** Calculate Aim Offset from input
 *  @param Center: Center rotation
 *  @param Target: Desired Target rotation
 *  @param MaxRot: Clamp rotation
 *  @param MaxAimOffset: This is clamp aim offset by aimoffset node
 *  @param InterpolationSpeed: Speed of interpolation
 *  @param DeltaTime: Delta Time passed
 *  @return OutAimOffset: Calculated Aim Offset
 */
native final function CalculateAimOffset(const rotator Center, const rotator Target, const rotator MaxRot,
		const float InterpolationSpeed, const float DeltaTime, out vector2D OutAimOffset );
// TNT uses this but we do not want to have special compile which will create a new fooClasses.h
// each time so we will just always have this function
// //native final function VinceNotifyCoverStatus( bool bIsInCover );

native final function bool CalculateLobTrajectory( out Vector out_SpawnVelocity, float Speed2D, float ZFactor, Vector SpawnLocation, Vector DestinationLocation, float GravityZ );

/**
 *  Switches to the Gore LOD
 *  @return TRUE if successfully switched
 */
native final simulated function bool SwitchToGoreLOD();

/**
 *  Enable Gore Mesh Settings -i.e. LOD/Materials
 *  This does not toggle alternate weights - this only eanbles mesh LOD/Material setups
 *  To support partial switches of weights
 */
native final simulated function bool EnableGoreMesh();
/**
 *   SeqAct/Cmd are checking arriving test separate causing inconsistency. Creating here, so that we can test with consistency
 *   The reason we
 */
native final simulated function bool ReachTestForMatinee(Actor StartActor);

/** Responding to AI_CustomAimOffset
 *  Allows to get custom aimoffset with AI_CustomAimOffset set up
 *  @param AimOffset: 2D vector of AimOffset
 *  @return : TRUE if successfully found. FALSE otherwise
 */
event simulated bool GetCustomAimOffset( out vector2D  AimOffset )
{
	return FALSE;
}

function SpawnDefaultController()
{
	Super.SpawnDefaultController();
	// set the default team based on the class type
	if (IsA('GearPawn_COGGear'))
	{
		WorldInfo.Game.ChangeTeam(Controller,0,FALSE);
	}
	else
	{
		WorldInfo.Game.ChangeTeam(Controller,1,FALSE);
	}
}

simulated function CheckDefaultMeshTranslation()
{
	local vector NewMeshTranslation;

	// If Root bone is between the character's feet. Then Offset mesh properly
	// Down by CollisionHeight plus magic number so feet touch the ground.
	// Because CollisionCylinders slightly hovers above ground.
	if( bTranslateMeshByCollisionHeight && default.Mesh != None )
	{
		// Update value from default component
		NewMeshTranslation = default.Mesh.Translation;
		NewMeshTranslation.Z = -(CylinderComponent.CollisionHeight + MeshTranslationNudgeOffset);
		default.Mesh.SetTranslation(NewMeshTranslation);
		// Reflect change on current mesh.
		UpdateMeshTranslationOffset(MTO_MeshLocSmootherOffset, TRUE);
	}
}

simulated event PostBeginPlay()
{
	local GearPC GPC;
	local int Idx;
	local int i;
	//local MaterialInterface MatInstance;

	Super.PostBeginPlay();

	CheckDefaultMeshTranslation();

	if( GearPawnFX == None )
	{
		Assert(GearPawnFXClass != None);
		GearPawnFX = new(self) GearPawnFXClass;
	}

	// Register with the GUDManager...
	if (MasterGUDBankClassNames.length > 0)
	{
		if (Role == ROLE_Authority)
		{
			GearGame(WorldInfo.Game).UnscriptedDialogueManager.RegisterSpeaker(self);
		}
		else if (Mesh != None && Mesh.SkeletalMesh != None && Mesh.SkeletalMesh.FaceFXAsset != None)
		{
			foreach LocalPlayerControllers(class'GearPC', GPC)
			{
				for (i = 0; i < GPC.ClientGUDSReferences.length; i++)
				{
					if ( GPC.ClientGUDSReferences[i].Bank != None &&
						MasterGUDBankClassNames.Find(GPC.ClientGUDSReferences[i].Bank.SourceGUDBankPath) != INDEX_NONE )
					{
						Mesh.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(GPC.ClientGUDSReferences[i].FaceFXData);
					}
				}
				break;
			}
		}
	}

	// Set proper parameters on AnimSets
	AnimSetListUpdated();

	// Initial setup of fire tickets
	SetNumberOfFireTickets( NumFireTickets );

	// Unfix the 'bFullAnimWeight' bodies
	if( Mesh != None && Mesh.PhysicsAssetInstance != None )
	{
		Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, Mesh);
	}

	// hook up the FaceFXAnimSets here based on SP or MP gametype
	if (Mesh != None && Mesh.SkeletalMesh != None)
	{
		if ( Mesh.SkeletalMesh.FaceFXAsset != None )
		{
			for (Idx=0; Idx<FAS_Efforts.length; ++Idx)
			{
				Mesh.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet( FAS_Efforts[Idx] );
			}
		}

		// Disable the gore material id if set
		if (GoreSettings != None && GoreSettings.GoreMeshMaterialID >= 0)
		{
			Mesh.ShowMaterialSection(GoreSettings.GoreMeshMaterialID, FALSE, GoreSettings.GoreMeshLOD);
		}
	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		// material instance setup.  do the mp rimshaders first, and then we'll derive from those for
		// subsequent materials
		InitMPRimShader();

		if( Mesh != None )
		{
			// must be after rimshader initialization, so that doens't stomp this material.
			InitMICPawnMaterial();

			// when we spawn we want to make our textures are resident right off the bat so they are not all mipped out
			for( Idx = 0; Idx < Mesh.Materials.length; ++Idx )
			{
				Mesh.Materials[Idx].SetForceMipLevelsToBeResident(false, false, 15.0f);
			}

			InitGoreMaskTexture();
		}
	}

	`if(`notdefined(FINAL_RELEASE))
		CheckGoreJoints();
	`endif
}

simulated function Destroyed()
{
	local GearPC GPC;

	// If we're currently doing a special move when we're being destroyed
	if( SpecialMove != SM_None && SpecialMoves[SpecialMove] != None )
	{
		// And end the current special move, as other actors may be relying on that
		EndSpecialMove();
	}

	// Clear references to instanced special move classes.
	SpecialMoves.Length = 0;

	// Clear references to animations nodes
	ClearAnimNodes();

	// Unregister with the GUD manager
	if (MasterGUDBankClassNames.length > 0 && GearGame(WorldInfo.Game) != None)
	{
		GearGame(WorldInfo.Game).UnscriptedDialogueManager.UnregisterSpeaker(self);
	}

	// destroy client-side weapons
	if( GearInventoryManager(InvManager) != None )
	{
		GearInventoryManager(InvManager).DiscardClientSideInventory();
	}

	// destroy slave weapon
	if( MyGearWeapon != None && !MyGearWeapon.bDeleteMe && MyGearWeapon.bSlaveWeapon )
	{
		MyGearWeapon.Destroy();
		MyGearWeapon = None;
	}

	// perform attachment clean up
	CleanupAttachSlots();

	GPC = GearPC(Controller);
	if( GPC != none )
	{
		GearPlayerCamera(GPC.PlayerCamera).SetDesiredColorScale(vect(1.0f,1.0f,1.0f),1.0f);
	}

	// clean up any on-fire emitters
	ExtinguishPawn();

	// notify ai vis man we just got popped
	if( GearGame(WorldInfo.Game) != None )
	{
		GearGame(WorldInfo.Game).AIVisMan.NotifyPawnDestroy(self);
	}

	// Cleanup coop Weapon if we still have one
	if (CoopWeaponSyncActor != None)
	{
		CoopWeaponSyncActor.UnlinkAllAndDestroy();
		CoopWeaponSyncActor = None;
	}

	Super.Destroyed();
}

/** scales this Pawn's default health by the specified multiplier
 * @param Multiplier - amount to multiply default health by
 * @param bResetCurrentHealth - if set, reset current health to default (otherwise, only clamp if old value is no longer valid)
 *				ignored if Pawn is dead/DBNO/hostage/etc
 */
function ScaleDefaultHealth(float Multiplier, bool bResetCurrentHealth)
{
	if (GearGame(WorldInfo.Game).ShouldUseBasePawnDefaults(self))
	{
		DefaultHealth = class'GearPawn'.default.DefaultHealth * Multiplier;
	}
	else
	{
		DefaultHealth = default.DefaultHealth * Multiplier;
	}
	HealthMax = DefaultHealth;
	if (Health > 0)
	{
		if (bResetCurrentHealth)
		{
			Health = DefaultHealth;
		}
		else
		{
			Health = Min(Health, DefaultHealth);
		}
	}
}

/** called when the burn effect is done playing */
simulated function OnBurnEffectFinished(ParticleSystemComponent PSC)
{
	WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurnEffectPSC);
	BurnEffectPSC = None;
}


/** This will stream in all of the textures of the character **/
simulated function CharacterTexturesForceMipsResident()
{
	CharacterTextureForceResident( TRUE );
	SetTimer( 5.0f, FALSE, nameof(CharacterTexturesForceMipsNonResident) );
}

/** This will allow the streaming code to stream in or out all of the textures of the character **/
simulated function CharacterTexturesForceMipsNonResident()
{
	CharacterTextureForceResident( FALSE );
}

/** This does the work of getting all textures and setting them to be resident or not **/
simulated function CharacterTextureForceResident( bool Value )
{
	local int MaterialIdx;

	for( MaterialIdx = 0; MaterialIdx < Mesh.Materials.length; ++MaterialIdx )
	{
		if( Mesh.GetMaterial(MaterialIdx) != None )
		{
			Mesh.GetMaterial(MaterialIdx).SetForceMipLevelsToBeResident(true, Value, -1.0f);
		}
	}
}


simulated function int GetLookAtPriority( GearPC PC, int DefaultPriority )
{
	if ( (PC.Pawn != self) && !bPlayedDeath && WorldInfo.GRI.OnSameTeam(PC.Pawn, self) )
	{
		if ( IsDBNO() )
		{
			return class'GearPointOfInterest'.Default.POIPriority_RevivableComrade;
		}
		else
		{
			if ( IsPlayerOwned() )
			{
				return class'GearPointOfInterest'.Default.POIPriority_ComradeHuman;
			}
			return class'GearPointOfInterest'.Default.POIPriority_Comrade;
		}
	}

	return DefaultPriority;
}

/** makes sure all attachments for a nonlocal client pawn are correct */
simulated final function RefreshRemoteAttachments()
{
	if( WorldInfo.NetMode == NM_Client && !IsLocallyControlled() )
	{
		UpdateRemoteWeapon();
		UpdateRemoteShield(AttachClass_Shield);
		SetSlotAttachment(EASlot_Holster, AttachSlotClass_Holster);
		SetSlotAttachment(EASlot_Belt, AttachSlotClass_Belt);
		SetSlotAttachment(EASlot_LeftShoulder, AttachSlotClass_LeftShoulder);
		SetSlotAttachment(EASlot_RightShoulder, AttachSlotClass_RightShoulder);
	}
}

simulated event PostDemoRewind()
{
	local int i;
	local GearWeapon Weap;

	// force attachments to be reattached
	if (InvManager != None)
	{
		foreach InvManager.InventoryActors(class'GearWeapon', Weap)
		{
			Weap.DetachWeapon();
		}
		if (MyGearWeapon != None)
		{
			AttachWeapon();
		}
		for (i = 0; i < AttachSlots.length; i++)
		{
			AttachSlots[i].InvClass = None;
		}
		RefreshRemoteAttachments();
	}

	if (LightEnvironment != None)
	{
		LightEnvironment.ForceUpdate(true);
	}

	// see if we need to reinit our animations or go into ragdoll
	if (Mesh != None)
	{
		if (Physics != PHYS_RigidBody)
		{
			if (Mesh.PhysicsWeight >= 1.0)
			{
				Mesh.PhysicsWeight = 0.0;
				Mesh.SetHasPhysicsAssetInstance(false);
				Mesh.SetHasPhysicsAssetInstance(true);
				Mesh.SetSkeletalMesh(default.Mesh.SkeletalMesh);
				Mesh.SetAnimTreeTemplate(Mesh.AnimTreeTemplate);
				// restore default materials to get rid of gore stuff
				for (i = 0; i < Mesh.Materials.length; i++)
				{
					if (i >= default.Mesh.Materials.length)
					{
						Mesh.SetMaterial(i, None);
					}
					else
					{
						Mesh.SetMaterial(i, default.Mesh.Materials[i]);
					}
				}
				if (MutatedClass != None)
				{
					MutatedClass.static.MutatePawn(self);
				}
			}
		}
		else if (Physics == PHYS_RigidBody && Mesh.PhysicsWeight < 1.0)
		{
			SetPhysics(PHYS_None);
			InitRagdoll();
		}

		if (Mesh.Animations != None)
		{
			ClearAnimNodes();
			CacheAnimNodes();
		}
	}

	if (SpecialMove != SM_None)
	{
		VerifySMHasBeenInstanced(SpecialMove);
	}
}

simulated function SetHeadScale(float NewScale)
{
	local SkelControlSingleBone HeadControl, WeaponControl;

	HeadScale = NewScale;

	HeadControl = SkelControlSingleBone(Mesh.FindSkelControl('HeadScaler'));
	if (HeadControl != None)
	{
		HeadControl.SetSkelControlStrength(1.0, 0.0);
		HeadControl.BoneScale = HeadScale;
	}

	// HeadScaler defaults to x2, WeaponScaler is x1.5 to have more scaling options.
	// For some creatures/body parts, x2 is too big.
	WeaponControl = SkelControlSingleBone(Mesh.FindSkelControl('WeaponScaler'));
	if (WeaponControl != None)
	{
		WeaponControl.SetSkelControlStrength(1.0, 0.0);
		WeaponControl.BoneScale = (HeadScale <= 1.0) ? HeadScale : FMax(1.0, 0.75 * HeadScale);
	}
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	if (SkelComp == Mesh && HeadScale != default.HeadScale)
	{
		SetHeadScale(HeadScale);
	}
	Super.PostInitAnimTree(SkelComp);
}

/** Modify speech for BigHead Mutator */
simulated function bool SetBigHeadVoice(bool bEnable)
{
	local AudioDevice Audio;
	local SoundClass SoundClassRef;
	local FLOAT NewPitch;
	local bool bChangedSomething;

	NewPitch = bEnable ? BigHeadVoicePitch : 1.f;
	bChangedSomething = FALSE;

	Audio = class'Engine'.static.GetAudioDevice();
	if( Audio != None )
	{
		// Dialog
		SoundClassRef = Audio.FindSoundClass( 'Voice' );
		if( SoundClassRef != None )
		{
			if( SoundClassRef.Properties.Pitch != NewPitch )
			{
				SoundClassRef.Properties.Pitch = NewPitch;
				bChangedSomething = TRUE;
			}
		}

		// Effort sounds.
		SoundClassRef = Audio.FindSoundClass( 'Character' );
		if( SoundClassRef != None )
		{
			if( SoundClassRef.Properties.Pitch != NewPitch )
			{
				SoundClassRef.Properties.Pitch = NewPitch;
				bChangedSomething = TRUE;
			}
		}

		// Music
		SoundClassRef = Audio.FindSoundClass( 'GameMusic' );
		if( SoundClassRef != None )
		{
			if( SoundClassRef.Properties.Pitch != NewPitch )
			{
				SoundClassRef.Properties.Pitch = NewPitch;
				bChangedSomething = TRUE;
			}
		}
	}

	return bChangedSomething;
}

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	local GearPC GPC;
	local bool bFound;
	local int i, j;

	switch( VarName )
	{
		case 'StopCringeCount' : ReplicatedStopCringe(); break;
		case 'bTraversingBarbedWire' : TraversingBarbedWireUpdated(); break;
		case 'ReplicatedHeadTrackInfo' : HeadTrackActorUpdated(); break;
		case 'ShotAtCount' : ShotAtCountIncreased(); break;
		case 'CringeCount' : CringeCountIncreased(); break;
		case 'ReplicatedSpecialMoveStruct' :
			`logsm("Received replicated special move:"@ReplicatedSpecialMoveStruct.SpecialMove);
			if ( (WorldInfo.NetMode != NM_Client) || (ReplicatedSpecialMoveStruct.SpecialMove != SM_None || !bTearOff) )
			{
				// skip this on clients if dead, since we'll handle our own death special moves from here on out
				DoSpecialMoveFromStruct(ReplicatedSpecialMoveStruct, TRUE);
			}
			break;
		case 'CrawlSpeedModifier':
			if (DBNOCrawlNode != None)
			{
				DBNOCrawlNode.Rate = 1.f + CrawlSpeedModifier;
			}
			break;
		case 'CoverAction' :
			CoverActionChanged();
			break;
		case 'LastTakeHitInfo':
			ReplicatedPlayTakeHitEffects();
			break;
		case 'bIsTargeting' :
			// Notification that targeting mode has been changed.
			TargetingModeChanged();
			break;
		case 'InvManager':
			// everyone's InvManager gets replicated into demos so we need to update attachments after receiving it
			if (WorldInfo.IsPlayingDemo() && InvManager != None)
			{
				RefreshRemoteAttachments();
			}
			break;
		// update right hand weapon attachment
		case 'RemoteWeaponRepInfo':
			UpdateRemoteWeapon();
			break;
		case 'AttachClass_Shield':
			UpdateRemoteShield(AttachClass_Shield);
			break;
		// slot attachments
		case 'AttachSlotClass_Holster':
			SetSlotAttachment( EASlot_Holster, AttachSlotClass_Holster );
			break;
		case 'AttachSlotClass_Belt':
			SetSlotAttachment( EASlot_Belt, AttachSlotClass_Belt );
			break;
		case 'AttachSlotClass_LeftShoulder':
			SetSlotAttachment( EASlot_LeftShoulder, AttachSlotClass_LeftShoulder );
			break;
		case 'AttachSlotClass_RightShoulder':
			SetSlotAttachment( EASlot_RightShoulder, AttachSlotClass_RightShoulder );
			break;
		case 'AcquiredCoverInfo' :
			LastCoverAcquireDistanceSq = VSizeSq2D(AcquiredCoverInfo.Location - Location);
			SetCovPosInfo(AcquiredCoverInfo);
			break;
		case 'bChargingWeapon':
			ToggleChargingWeapon();
			break;
		case 'bSpawnABloodPool':
			SpawnBloodPool();
			break;

		case 'ReplicatedSpeakLineParams':
			if (ReplicatedSpeakLineParams.Audio != None)
			{
				QueuedSpeakLineParams = ReplicatedSpeakLineParams;
				if (QueuedSpeakLineParams.DelayTime > 0.f)
				{
					// play later
					SetTimer( QueuedSpeakLineParams.DelayTime, false, nameof(PlayQueuedSpeakLine) );
				}
				else
				{
					// play now!
					PlayQueuedSpeakLine();
				}
			}
			break;

		case 'bCoveringHead':
			if (bCoveringHead)
			{
				PlayHeadCoverAnim_Internal();
			}
			else
			{
				StopPlayingHeadCoverAnim();
			}
			break;
		case 'bWantToConverse':
		case 'bWantToUseCommLink':
			if (VarName == 'bWantToConverse' || bWantToConverse)
			{
				SetConversing(bWantToConverse, bWantToUseCommLink);
				bIsConversing = false; // force reset so bWantToUseCommLink is evaluated again
			}
			break;
		case 'bIsZoomed':
			if (MyGearWeapon != None)
			{
				MyGearWeapon.RemoteZoomLevelChanged(bIsZoomed);
			}
			break;
		case 'ReplicatedForcedAimTime' :
			SetWeaponAlert(float(ReplicatedForcedAimTime));
			break;
		case 'SpottedByTeam':
			UpdateLocalSpottedList();
			break;
		case 'SpottedBy':
			foreach LocalPlayerControllers(class'GearPC', GPC)
			{
				if (SpottedByTeam[GPC.GetTeamNum()] > 0 && GPC.PlayerReplicationInfo == SpottedBy[GPC.GetTeamNum()])
				{
					GPC.ModifyStat('SpottedPlayerMP');
					break;
				}
			}
			break;
		case 'KnockdownImpulse':
			if (!IsZero(KnockdownImpulse.LinearVelocity) || !IsZero(KnockdownImpulse.AngularVelocity))
			{
				ApplyKnockdownImpulse();
			}
			// failsafe in case the recovery special move was lost due to replication timing (i.e. went back to None before replication happened)
			else if ( SpecialMove != SM_RecoverFromRagdoll && ReplicatedSpecialMoveStruct.SpecialMove != SM_RecoverFromRagdoll &&
				Mesh.PhysicsWeight >= 1.0 )
			{
				VerifySMHasBeenInstanced(SM_RecoverFromRagdoll);
				GSM_RecoverFromRagdoll(SpecialMoves[SM_RecoverFromRagdoll]).FinishedBlendToGetUp();
			}
			break;
		case 'ReplicatedOnFireState':
			IgnitePawn(ReplicatedOnFireState);
			break;
		case nameof(MutatedClass):
			if (MutatedClass != None)
			{
				MutatedClass.static.MutatePawn(self);
			}
			break;
		case 'HostageHealth' :
			UpdateHostageHealth();
			break;
		case nameof(bActiveReloadBonusActive):
			if (GearWeapon(Weapon) != None)
			{
				GearWeapon(Weapon).SetActiveReloadEffectsActive(bActiveReloadBonusActive);
			}
			break;
		case nameof(bDisableShadows):
			UpdateShadowSettings(!bDisableShadows);
			break;
		case nameof(ReplicatedKismetAnimTree):
			if( ReplicatedKismetAnimTree != None )
			{
				Mesh.SetAnimTreeTemplate( ReplicatedKismetAnimTree );
			}
			else
			{
				Mesh.SetAnimTreeTemplate( default.Mesh.AnimTreeTemplate );
			}
			break;
		case nameof(KismetAnimSets):
			UpdateAnimSetList();
			break;
		case nameof(ReplicatedMoveCycleOverrideSeqAct):
			if( CurrentMoveCycleOverrideSeqAct != ReplicatedMoveCycleOverrideSeqAct && CurrentMoveCycleOverrideSeqAct != None )
			{
				StopMoveCycleOverride(CurrentMoveCycleOverrideSeqAct);
				CurrentMoveCycleOverrideSeqAct = None;
			}
			if( ReplicatedMoveCycleOverrideSeqAct != None )
			{
				CurrentMoveCycleOverrideSeqAct = ReplicatedMoveCycleOverrideSeqAct;
				StartMoveCycleOverride(ReplicatedMoveCycleOverrideSeqAct);
			}
			break;
		case nameof(ReplicatedMaterial):
			if (ReplicatedMaterial != None)
			{
				Mesh.SetMaterial(0, ReplicatedMaterial);
			}
			else
			{
				Mesh.SetMaterial(0, default.Mesh.GetMaterial(0));
			}
			break;
		case nameof(ReplicatedFaceFXAnimSets):
			for (i = 0; i < ArrayCount(PrevReplicatedFaceFXAnimSets); i++)
			{
				if (PrevReplicatedFaceFXAnimSets[i] != None)
				{
					bFound = false;
					for (j = 0; j < ArrayCount(ReplicatedFaceFXAnimSets); j++)
					{
						if (PrevReplicatedFaceFXAnimSets[i] == ReplicatedFaceFXAnimSets[j])
						{
							bFound = true;
							break;
						}
					}
					if (!bFound)
					{
						Mesh.SkeletalMesh.FaceFXAsset.UnmountFaceFXAnimSet(PrevReplicatedFaceFXAnimSets[i]);
					}
				}
			}
			for (i = 0; i < ArrayCount(ReplicatedFaceFXAnimSets); i++)
			{
				if (ReplicatedFaceFXAnimSets[i] != None)
				{
					Mesh.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(ReplicatedFaceFXAnimSets[i]);
				}
				PrevReplicatedFaceFXAnimSets[i] = ReplicatedFaceFXAnimSets[i];
			}
			break;
		case nameof(HeadScale):
			SetHeadScale(HeadScale);
			break;
		case nameof(bForceHeadShotGib):
			// if torn off, this will be called already as part of the dying process
			if (!bTearOff)
			{
				PlayHeadShotDeath();
			}
			break;
		case nameof(bRoadieRunComet):
			if (bRoadieRunComet)
			{
				ActivateRoadieRunComet();
			}
			break;
		case nameof(bHasGasTank):
			if (!bHasGasTank)
			{
				RemoveGasTank();
			}
			break;
		case nameof(bWeaponHolstered):
			if( bWeaponHolstered )
			{
				HolsterWeapon();
			}
			else
			{
				UnHolsterWeapon();
			}
			break;
		case nameof(ScriptTrigger):
			if (ScriptTrigger != None)
			{
				ConditionalDoScriptedMove();
			}
			break;
		case nameof(bInsideDoorTrigger):
			if (bInsideDoorTrigger && IsDoingSpecialMove(SM_RoadieRun))
			{
				GearPC(Controller).DoDoorOpen();
			}
			break;
		case nameof(PrimaryPickedupWeaponSkin):
		case nameof(SecondaryPickedupWeaponSkin):
			// The skin has changed so update the gun to match
			UpdateWeaponSkin();
			break;
	}

	Super.ReplicatedEvent(VarName);
}

simulated final function ActivateRoadieRunComet()
{
	bRoadieRunComet = true;
	if (SpecialMoveClasses[SM_RoadieRun] == class'GSM_RoadieRun')
	{
		SpecialMoveClasses[SM_RoadieRun] = class'GSM_RoadieRunComet';
		if (SpecialMoves[SM_RoadieRun] != None)
		{
			SpecialMoves[SM_RoadieRun] = None;
		}
	}
}

/** Cause civilians to run away from this spot */
simulated function CauseCrowdPanic();
/** Stop crowd from running away */
simulated function ClearCrowdPanic();

simulated protected function ToggleChargingWeapon()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.ToggleCharging(bChargingWeapon);
	}
}

simulated function NotifyTeamChanged()
{
	Super.NotifyTeamChanged();

	// remember last team for the HUD when we die
	if (PlayerReplicationInfo != None && PlayerReplicationInfo.Team != None)
	{
		LastTeamNum = GetTeamNum();
	}

	// we have everything we need to update attachment visibility
	SetTimer(0.0001, false, nameof(UpdateAttachmentVisibility));

	CreateTaccomMesh();

	CheckForPostRender();
}

/** determines whether we need PostRenderFor() called and if so adds us to the array in the HUD */
simulated function CheckForPostRender()
{
	local GearPC GPC;
	local GearHUD_Base GHUD;

	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		GHUD = GearHUD_Base(GPC.myHUD);
		if (GHUD != None)
		{
			GHUD.ConstructTaccomLocators(self);

			if ( ((class<GearGameSP_Arcade>(WorldInfo.GRI.GameClass) != None && !PlayerReplicationInfo.bBot) || (WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.GRI.IsCoopMultiplayerGame())) &&
				WorldInfo.GRI.OnSameTeam(GPC, self) &&
				GHUD.PostRenderedActors.Find(self) == INDEX_NONE )
			{
				GHUD.PostRenderedActors.AddItem(self);
			}
		}
	}
}

/** Save off commonly used nodes so the tree doesn't need to be iterated over often */
native simulated event CacheAnimNodes();

/** Clear references to anim nodes so AnimTree can be garbage collected. */
simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	AnimTreeRootNode	= None;
	FullBodyNode		= None;
	HeadTrackSkelControl= None;
	EyeTrackSkelControl	= None;
	TroikaBlendNode		= None;
	MirrorNode			= None;
	DBNOCrawlNode		= None;
	IKHackNode			= None;
	BlendByAimNode		= None;
	BlendByAimToggle	= None;
	BaseBlendNode		= None;
	BreathingAdditiveControl = None;

	AimOffsetNodes.Length	= 0;
	BodyStanceNodes.Length	= 0;
	RecoilNodes.Length		= 0;

	bTargetingNodeIsInIdleChannel = default.bTargetingNodeIsInIdleChannel;

	IKCtrl_RightHand	= None;
	IKCtrl_LeftHand		= None;
	IKRotCtrl_RightHand	= None;
	IKRotCtrl_LeftHand	= None;
	IKFloorConformSkelControl = None;
	LegFloorConformSkelControl = None;
	IKFootLeft = None;
	IKFootRight = None;
}

simulated protected function InitMPRimShader();

/** Create Gore hit mask texture **/
/** this is to make it easy to create custom size of texture per different pawn **/
simulated protected function TextureRenderTarget2D CreateGoreMaskTexture()
{
	return class'TextureRenderTarget2D'.static.Create(64, 64, PF_G8, MakeLinearColor(0, 0, 0, 1));
}

/** Init Gore hit mask material **/
simulated protected function InitGoreMaskTexture()
{
	if (bAllowGoreHitMask && HitMaskComponent != None && MIC_PawnMat != None )
	{
		GoreMaskTexture = CreateGoreMaskTexture();

		if ( GoreMaskTexture!=none )
		{
			// Update HitMaskComponent with this texture
			HitMaskComponent.SetCaptureTargetTexture( GoreMaskTexture );
			// update material texture parameter
			RefreshMaterialTextureParameterForGoreMask();
		}
	}
	else
	{
		GoreMaskTexture = None;
	}

}

/** This function gets called when material changes when it turns to gore
 *  Since it will need to update parameters, refresh gore mask texture parameter
 */
event simulated RefreshMaterialTextureParameterForGoreMask(bool DisableFading = FALSE)
{
	local MaterialInstanceConstant MIC;

	// get first parameter
	MIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
	if ( MIC != none &&  GoreMaskTexture!=none )
	{
		// Set new texture as GoreMask parameter
		MIC.SetTextureParameterValue('GoreMask', GoreMaskTexture);

		if ( DisableFading )
		{
			HitMaskComponent.SetFadingStartTimeSinceHit(-1.f);
		}
	}
}

/** This will create the MIC for this pawn's materials **/
simulated protected function InitMICPawnMaterial()
{
	MIC_PawnMat = Mesh.CreateAndSetMaterialInstanceConstant(0);

	// if this pawn has hair (which is in slot 1)
	if( Mesh.GetMaterial(1) != none )
	{
		MIC_PawnHair = Mesh.CreateAndSetMaterialInstanceConstant(1);
	}
}


/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.Notify_AmmoRelease();
	}
}

simulated function Notify_AmmoRelease2()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.Notify_AmmoRelease2();
	}
}

/** Notify called when ammo is thrown by player */
simulated function Notify_AmmoThrow()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.Notify_AmmoThrow();
	}
}

/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.Notify_AmmoGrab();
	}
}

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.Notify_AmmoReload();
	}
}

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload2()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.Notify_AmmoReload2();
	}
}

simulated function Notify_DoorKick()
{
	// effort sound
	SoundGroup.PlayEffort(self, GearEffort_KickEffort);
	SoundGroup.PlayFoleySound(Self, GearFoley_Kick);
}

simulated function Notify_DoorPush()
{
	// effort sound
	SoundGroup.PlayEffort(self, GearEffort_DoorPullEffort);
}

simulated function Notify_GrenadeSwing()
{
	local GearWeap_GrenadeBase NadeWeap;

	NadeWeap = GearWeap_GrenadeBase(MyGearWeapon);
	if (NadeWeap != None)
	{
		NadeWeap.NotifyGrenadeSwing();
	}
};

//Called by an anim sequence at the point of the flail expecting to hit the ground
simulated function Notify_FlailImpact()
{
	local GearWeap_HeavyFlailBase FlailWeap;
	FlailWeap = GearWeap_HeavyFlailBase(MyGearWeapon);
	if (FlailWeap != None)
	{
		FlailWeap.NotifyFlailImpact();
	}
};

/** if this pawn has a helmet on or not **/
simulated function bool HasHelmetOn();


function Restart()
{
	Super.Restart();

	CurrentLink = None;
	CurrentSlotIdx = -1;
	ClosestSlotIdx = -1;
	SetCoverType( CT_None );
	SetCoverAction( CA_Default );
}

simulated function ClientRestart()
{
	local GearPC GPC;

	bQuietWeaponEquipping = TRUE;

	super.ClientRestart();

	CurrentLink = None;
	CurrentSlotIdx = -1;
	ClosestSlotIdx = -1;
	SetCoverType( CT_None );
	SetCoverAction( CA_Default );
	SetTargetingMode(false);

	SetTimer( 3.0f, FALSE, nameof(AllowWeaponEquippingSound) );

	GPC = GearPC(Controller);
	if(GPC != None)
	{
		GPC.ClientPeriodStarted(GEARPERIOD_Life);
	}

	SetLightEnvironmentSettings();
}


/**
 * We spawn the pawn pretty early so it is around along with all of its weapons and then it is
 * teleported to the correct place.	 During that time it will play sounds which is not wanted.
 * Specifically, we are stopping the weapon Equip/DeEquip sounds which play when the weapons are
 * first created and/or given to the pawn.
 **/
simulated function AllowWeaponEquippingSound()
{
	bQuietWeaponEquipping = FALSE;
}

/** @return location used as origin for headshot hit detection */
simulated final function vector GetHeadshotLocation()
{
	if (HeadBoneNames.length > 0)
	{
		return Mesh.GetBoneLocation(HeadBoneNames[0])
			+ MPHeadOffset.X * Mesh.GetBoneAxis(HeadBoneNames[0], AXIS_X)
			+ MPHeadOffset.Y * Mesh.GetBoneAxis(HeadBoneNames[0], AXIS_Y)
			+ MPHeadOffset.Z * Mesh.GetBoneAxis(HeadBoneNames[0], AXIS_Z);
	}
	else
	{
		return vect(0,0,0);
	}
}

/** Returns TRUE of this hit corresponds to a head shot. */
simulated event bool TookHeadShot(name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	local vector HeadLocation;
	local bool bBoneHitHead;

	if (bHasPlayedHeadShotDeath)
	{
		// we obviously can't take a headshot with no head attached to our body
		return false;
	}
	else
	{
		if (HeadBoneNames.length > 0)
		{
			HeadLocation = GetHeadshotLocation();

			// Find distance from head location to bullet vector
			bBoneHitHead = (PointDistToLine(HeadLocation, Normal(Momentum), HitLocation) < MPHeadRadius);

`if(`notdefined(FINAL_RELEASE))
			if (bWeaponDebug_HeadShotLocation)
			{
				FlushPersistentDebugLines();

				DrawDebugLine(HitLocation, HitLocation - Momentum * 100000.f, 0, 255, 0, true);

				if (bBoneHitHead)
				{
					DrawDebugSphere(HeadLocation, MPHeadRadius, 10, 0, 255, 0, true);
				}
				else
				{
					DrawDebugSphere(HeadLocation, MPHeadRadius, 10, 255, 0, 0, true);
				}
			}
`endif
		}

		// in multiplayer game we don't care about helmets
		if (GearGRI(WorldInfo.GRI).IsMultiplayerGame())
		{
			return bBoneHitHead;
		}
		// for SP we want to remove helmets based on head shots
		else if (bBoneHitHead)
		{
			// if we have a helmet then note that so that damage is negated, helmet popped off, etc
			if (HasHelmetOn())
			{
				out_bHasHelmet = 1;
			}
			else
			{
				out_bHasHelmet = 0;
			}

			return true;
		}
		else
		{
			return false;
		}
	}
}

final function bool TookLegShot(Name BoneName)
{
	return LegBoneNames.Find(BoneName) != INDEX_NONE;
}

/** Returns world position that the head bone should look at. This is an adjusted location due to the head bone offset from the eyes. */
simulated native function vector GetHeadLookTargetLocation() const;
/** Returns world position that the eye bones should look at. */
simulated native function vector GetEyeLookTargetLocation() const;

/**
 * Draw debug information for AimAttractors
 */
simulated function DrawDebugAimAttractors()
{
	local int AttractorIdx, NumAttractors;
	local AimAttractor Attr;
	local vector AttrPos;

	if ( (Health > 0) && ( (Controller == None) || !Controller.IsLocalPlayerController() ) )		// @fixme work in multi?
	{
		NumAttractors = AimAttractors.Length;

		// loop over array, draw the spheres
		for (AttractorIdx=0; AttractorIdx<NumAttractors; ++AttractorIdx)
		{
			Attr = AimAttractors[AttractorIdx];
			AttrPos = Mesh.GetBoneLocation(Attr.BoneName);
			DrawDebugSphere(AttrPos, Attr.InnerRadius, 8, 255, 16, 16, FALSE);
			DrawDebugSphere(AttrPos, Attr.OuterRadius, 8, 255, 255, 16, FALSE);
		}
	}
}

/**
 * Draw Pawn's rotation information in front of them to debug
 */
simulated function DrawDebugRotation()
{
	local vector vExtent, StartLoc;

	if ( Mesh!=none )
	{
		// draw cylinder around them
		vExtent = vect(0, 0, 1)*GetCollisionHeight();
		DrawDebugCylinder(Location-vExtent, Location+vExtent, GetCollisionRadius(), 10, 100, 100, 0);
		// Draw Pawn's rotation coordinate in front/top of their cylinder, so it's more visible - red being exactly yaw
		StartLoc = Location+vExtent+vector(Rotation)*GetCollisionRadius();
		DrawDebugCoordinateSystem(StartLoc, Rotation, 50);
		if ( ReachedDesiredRotation()==FALSE )
		{
			// if pawn is rotating, please draw desired rotation with yellow
			DrawDebugLine(StartLoc, StartLoc+Vector(DesiredRotation)*50, 255, 255, 0);
		}
	}
}

/** @return whether this Pawn has illegally equipped a two handed weapon while holding a meatshield or shield pickup */
simulated final function CheckShieldCheat()
{
	if ( bShouldCheckShieldCheat &&
		(IsAKidnapper() || IsCarryingShield()) &&
		GearWeapon(Weapon) != None && !GearWeapon(Weapon).bCanEquipWithShield &&
		!bSwitchingWeapons && InvManager.PendingWeapon == None )
	{
		ServerNotifyShieldCheat();
	}
}

/** client code detected the shield with two handed weapon cheat
 * unfortunate that we must rely on the client to tell us, since then someone can just modify it
 * but weapon switching is client side so we have no choice
 */
reliable server final function ServerNotifyShieldCheat()
{
	if (GearPRI(PlayerReplicationInfo) != None && GearPRI(PlayerReplicationInfo).bIsLeader)
	{
		// killing leader would allow griefing in itself, so try to be more graceful
		if (IsAKidnapper())
		{
			ServerEndSpecialMove();
		}
		else if (IsCarryingShield())
		{
			DropShield();
		}
	}
	else
	{
		Health = 0;
		LastHitBy = None;
		GearPRI(PlayerReplicationInfo).ScoreDeath(GearPRI(PlayerReplicationInfo), class'GDT_ShieldCheatSuicide', GDT_Normal, -100);
		Died(Controller, class'GDT_ShieldCheatSuicide', Location);
	}
}

simulated function Tick(float DeltaTime)
{
	local float PctHealthRemaining;

`if(`notdefined(FINAL_RELEASE))
	local PlayerController PC;
`endif

	// Forward Script Tick event
	if( SpecialMove != SM_None &&  SpecialMoves[SpecialMove] != None )
	{
		SpecialMoves[SpecialMove].Tick(DeltaTime);
	}

	// Update Stopping Power
	UpdateStoppingPower(DeltaTime);

	/*
	// Rotation debugging
	if( AIController(Controller) != None )
	{
		DrawDebugLine(Location, Location + Vector(DesiredRotation) * 200.f,				000, 000, 255);
		DrawDebugLine(Location, Location + Vector(Controller.DesiredRotation) * 200.f,	000, 255, 000);
		DrawDebugLine(Location, Location + Vector(Rotation) * 200.f,					255, 000, 000);
	}
	*/
	`if(`notdefined(FINAL_RELEASE))
	if( bDebugAimAttractors )
	{
		DrawDebugAimAttractors();
	}
	`endif

	// Damage-over-time from skin heat or burning
	if (Role == ROLE_Authority)
	{
		switch (OnFireState)
		{
		case POF_Blazing:
			DamageOverTimeRemainder += OnFireBlazingDamagePerSecond * DeltaTime;
			if (DamageOverTimeRemainder > 1.f)
			{
				TakeDamage(int(DamageOverTimeRemainder), OnFireDamageInstigator, Location, vect(0,0,-1), OnFireDamageType);
				DamageOverTimeRemainder -= int(DamageOverTimeRemainder);
			}
			break;

// 		case POF_Burning:
// 			DamageOverTimeRemainder += OnFireBurningDamagePerSecond * DeltaTime;
// 			if (DamageOverTimeRemainder > 1.f)
// 			{
// 				TakeDamage(int(DamageOverTimeRemainder), OnFireDamageInstigator, Location, vect(0,0,-1), class'GDT_FireDOT');
// 				DamageOverTimeRemainder -= int(DamageOverTimeRemainder);
// 			}
// 			break;

		case POF_BlazingInk:
			DamageOverTimeRemainder += OnFireBlazingInkDamagePerSecond * DeltaTime;
			if (DamageOverTimeRemainder > 1.f)
			{
				TakeDamage(int(DamageOverTimeRemainder), OnFireDamageInstigator, Location, vect(0,0,-1), OnFireDamageType);
				DamageOverTimeRemainder -= int(DamageOverTimeRemainder);
			}
			break;

// 		default:
// 			if (CurrentSkinHeat > 0.f)
// 			{
// 				DamageOverTimeRemainder += HeatDamagePerSecond * DeltaTime * CurrentSkinHeat;
// 				if (DamageOverTimeRemainder > 1.0)
// 				{
// 					TakeDamage(int(DamageOverTimeRemainder), OnFireDamageInstigator, Location, vect(0,0,-1), class'GDT_FireDOT');
// 					DamageOverTimeRemainder -= int(DamageOverTimeRemainder);
// 				}
// 			}
		}
	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		FadeSkinEffects(DeltaTime);

		// check to see if we have moved onto another phys material from the last time we activated the roadierun PSC
		if( ( PSC_RoadieRun != None ) && ( LastFootStepTraceInfo.PhysMaterial != LastFootStepPhysMat ) )
		{
			StartRoadieRunPSC();
		}
	}


	if( IsAliveAndWell() )
	{
		// If locally controlled, handle firing
		if( IsLocallyControlled(Controller) )
		{
			HandleWeaponFiring();
		}

		// Locally controlled human pawns in cover, do this from GearPC::PlayerTakingCover::PlayerMove()
		if( CoverType == CT_None || !IsLocallyControlled() || !IsHumanControlled() )
		{
			UpdateMeshBoneControllers(DeltaTime);
		}

		// if this takes too much time, methinks we can distribute load over multiple frames
		// slight delays in start/stop auto headtracks are tolerable
		UpdateAutomaticHeadTracking();

		// Health is no longer replicated to all so we can't rely on it for remote clients
		if ( WorldInfo.NetMode != NM_DedicatedServer && IsLocallyControlled(Controller) )
		{
			// deal with heavy breathing while very hurt
			PctHealthRemaining = Health/float(DefaultHealth);
			if (NearDeathBreathSound == None && PctHealthRemaining < 0.5f && PctHealthRemaining > 0.0f && GearGRI(WorldInfo.GRI).IsMultiPlayerGame())
			{
				NearDeathBreathSound = SoundGroup.PlayEffortEx(self, GearEffort_NearDeathBreathe, 1.f);
			}
			else if (NearDeathBreathSound != None && PctHealthRemaining > 0.5f)
			{
				NearDeathBreathSound.FadeOut(1.f, 0.f);
				NearDeathBreathSound = None;
			}
		}

		// deal with conversation mode
		if( !bIsConversing && bWantToConverse )
		{
			// Want to use commlink
			if( bWantToUseCommLink )
			{
				if (IsDoingMeleeHoldSpecialMove())
				{
					ForceStopMeleeAttack(TRUE);
				}

				// client may already be doing special move from ReplicatedServerMove
				if (IsDoingSpecialMove(SM_UsingCommLink))
				{
					bIsConversing = TRUE;
				}
				else
				// See if local player can enter in CommLink mode now
				if (CanDoSpecialMove(SM_UsingCommLink))
				{
					if (Role == ROLE_Authority)
					{
						ServerDoSpecialMove(SM_UsingCommLink);
					}
					else
					{
						DoSpecialMove(SM_UsingCommLink);
					}

					bIsConversing = TRUE;
				}
			}
			// If don't want to use CommLink, can converse now
			else
			{
				bIsConversing = TRUE;
			}
		}

		if( Role == Role_Authority  )
		{
			// don't do this if dead!
			if( bHealthIsRecharging && Health < DefaultHealth )
			{
				RechargingHealthAmount = FMin(RechargingHealthAmount + (DeltaTime * (HealthRechargePercentPerSecond * 0.01f) * DefaultHealth), DefaultHealth);
				Health = int(RechargingHealthAmount);
			}
			/*
			if (!WorldInfo.Game.IsA('GearGameSP_Base') && IsHumanControlled())
			{
				// Check to see if player-controlled pawn is out of play area every 1-1.5 seconds. If out for 2 in a row kill them
				if (WorldInfo.TimeSeconds > LastInPlayAreaCheckTime + 1.0f)
				{
					LastInPlayAreaCheckTime = WorldInfo.TimeSeconds + (FRand() / 2); // Add a random jitter so all pawns aren't checked the same frame
					if (!IsInPlayArea() && !InGodMode() && Physics != PHYS_Flying && Physics != PHYS_Swimming)
					{
						if (bWasOutOfPlayArea)
						{
							`log("Killing player because they are outside of the play area:"@ Self @ "(" $ PlayerReplicationInfo.PlayerName $ ")");
							FellOutOfWorld(class'GDT_Environment');
						}
						else
						{
							bWasOutOfPlayArea = true;
						}
					}
					else
					{
						bWasOutOfPlayArea = false;
					}
				}
			}
			*/
		}
	}
	else
	{
		StopFiring();
	}


`if(`notdefined(FINAL_RELEASE))
	if (class'GearGRI'.default.bDebugShowDamage)
	{
		// Doing this with non-local PlayerControllers seems to hose initial replication in our debug configuration
		foreach WorldInfo.LocalPlayerControllers(class'PlayerController',PC)
		{
			PC.AddDebugText(string(Health), self, 1.f, vect(0,0,64.f), vect(0.f,0.f,32.f), class'HUD'.default.WhiteColor, FALSE);
		}
	}
`endif

`if(`notdefined(FINAL_RELEASE))
	if ( class'GearCheatManager'.static.DebugAIOn('rotation') )
	{
		VerifyValidRotation();
	}

`endif
}

simulated native function NativePostRenderFor(PlayerController PC, Canvas Canvas, vector CameraPosition, vector CameraDir);

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, vector CameraPosition, vector CameraDir)
{
	local vector WorldLoc, ScreenLoc;
	local float BeaconScale;
	local GearHUDLocator Locator;
	local GearPC GPC;
	local PlayerReplicationInfo PRI;

	GPC = GearPC(PC);
	if (!GPC.bAssessMode)
	{
		WorldLoc = Location + GetCollisionHeight() * vect(0,0,1.2);
		ScreenLoc = Canvas.Project(WorldLoc);
		// make sure not clipped out
		if (ScreenLoc.X >= 0.0 && ScreenLoc.X < Canvas.ClipX && ScreenLoc.Y >= 0.0 && ScreenLoc.Y < Canvas.ClipY)
		{
			// don't draw if there are any HUD locators referencing us as in that case the beacon is redundant
			foreach GPC.MyGearHUD.HUDLocators(Locator)
			{
				if (Locator.LocatorSubject == self)
				{
					return;
				}
			}
			// make sure really visible and not just a pixel visible here or there
			if (FastTrace(Location, CameraPosition) || FastTrace(WorldLoc, CameraPosition))
			{
				if (DrivenVehicle != None)
				{
					PRI = DrivenVehicle.PlayerReplicationInfo;
				}
				else if (GearPawnRidable_Base(Base) != None)
				{
					PRI = GearPawnRidable_Base(Base).PlayerReplicationInfo;
				}
				else
				{
					PRI = PlayerReplicationInfo;
				}
				Canvas.DrawColor = class'GearHUD_Base'.default.HUDColors[GPC.MyGearHUD.IsCOG(PRI) ? eWARHUDCOLOR_TEAMBLUE : eWARHUDCOLOR_TEAMRED];
				BeaconScale = 1.0 - FClamp((VSize(Location - CameraPosition) - MaxFullSizeBeaconDist) / MinSizeBeaconDist, 0.0, 0.5);
				Canvas.SetPos(ScreenLoc.X - MaxTeamBeaconSize * BeaconScale * 0.5, ScreenLoc.Y - MaxTeamBeaconSize * BeaconScale * 0.5);
				Canvas.DrawTile(TeamBeacon, MaxTeamBeaconSize * BeaconScale, MaxTeamBeaconSize * BeaconScale, 0, 0, TeamBeacon.SizeX, TeamBeacon.SizeY);
				if (GearPRI(PRI).bIsTalking)
				{
					Canvas.SetPos(ScreenLoc.X - TeamBeaconTalking.SizeX * BeaconScale * 0.5, ScreenLoc.Y - MaxTeamBeaconSize * BeaconScale * 0.5 - TeamBeaconTalking.SizeY * BeaconScale);
					Canvas.DrawTile(TeamBeaconTalking, TeamBeaconTalking.SizeX * BeaconScale, TeamBeaconTalking.SizeY * BeaconScale, 0, 0, TeamBeaconTalking.SizeX, TeamBeaconTalking.SizeY);
				}
			}
		}
	}
}

/**
 * Verify if valid rotation
 * only should get called when DebugAI rotation is on
 **/
function VerifyValidRotation()
{
	local int NormalizedYaw, Diff;
	local float RotPerSec;

	if (IsHumanControlled() == FALSE)
	{
		// Make sure yaw range from 0 to 65536
		if (Rotation.Yaw < 0)
		{
			NormalizedYaw = 65536-((-Rotation.Yaw) % 65536);
		}
		else
		{
			NormalizedYaw = Rotation.Yaw % 65536;
		}

		// if we have saved last yaw value
		if ( LastSavedYawTime!=0 )
		{
			// first get the rotation per second rate
			Diff = Abs(LastSavedYaw-NormalizedYaw);
			// diff of 2 yaws couldn't be more than 32768;
			// i.e. diff of yaw 0 to yaw 63000 shouldn't be 65000 but 536
			if (Diff > 32768)
			{
				Diff = 65536-Diff;
			}

			// now get the regular rotation per second
			RotPerSec = Diff/(WorldInfo.TimeSeconds-LastSavedYawTime);

			// if (current rotation rate > rotation rate * TolerableYawJumpThresholdMultiplier)
			// then consider this isn't valid rotation
			if ( RotPerSec>Abs(TolerableYawJumpThresholdMultiplier*RotationRate.Yaw) )
			{
				`AILog_Ext( "ERROR: INVALID ROTATION:"@GetFuncName()@"("@(WorldInfo.TimeSeconds-LastSavedYawTime)@"):LastKnownYaw-"@LastSavedYaw@",CurrentRotation"@Rotation@",Pawn DesiredRotation:"@DesiredRotation@"-"@RotationRate.Yaw, '', MyGearAI );
				`Log( "ERROR: INVALID ROTATION:"@MyGearAI@"@"@GetFuncName()@"("@(WorldInfo.TimeSeconds-LastSavedYawTime)@"):LastKnownYaw-"@LastSavedYaw@",CurrentRotation"@Rotation@",Pawn DesiredRotation:"@DesiredRotation@"-"@RotationRate.Yaw);

				// DebugFreezeGame(self);
			}
		}

		// Update LastSaved Yaw;
		LastSavedYaw = NormalizedYaw;
		LastSavedYawTime = WorldInfo.TimeSeconds;
	}
}

/** Update automatic head tracking. Look at HeadTrackTarget and Focus for potential head tracking */
final native simulated protected function UpdateAutomaticHeadTracking();
/** End tracking current HeadTrackTarget */
final native simulated function StopHeadTrackTarget();

/**
 * Simple function that forces the pawn from cover, sorting
 * out whether it's an AI or player.
 */
simulated function final BreakFromCover()
{
	local GearPC PC;

	if (MyGearAI != None)
	{
		MyGearAI.InvalidateCover();
	}
	else if (CoverType != CT_None)
	{
		PC = GearPC(Controller);
		if( PC != None )
		{
			PC.LeaveCover();
		}
	}
}

function OnForceTargeting(SeqAct_ForceTargeting InAction)
{
	if( InAction.InputLinks[0].bHasImpulse )
	{
		bForceTargeting = TRUE;
	}
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		bForceTargeting = FALSE;
	}
}

/** Return TRUE to prevent targeting */
simulated function bool ShouldPreventTargeting()
{
	if( MyGearWeapon != None && MyGearWeapon.ShouldPreventTargeting() )
	{
		return TRUE;
	}

	return FALSE;
}

/** Return TRUE to force targeting */
simulated function bool ShouldForceTargeting()
{
	if( MyGearWeapon != None && ( bForceTargeting || MyGearWeapon.ShouldForceTargeting() ) )
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Set Pawn TargetingMode flag (affecting animations, camera and other things...)
 * The controller calls this on the server.
 */
final simulated function SetTargetingMode(bool bNewTargetingMode)
{
	if( bIsTargeting != bNewTargetingMode )
	{
		bIsTargeting	= bNewTargetingMode;

		// Force replication now to clients
		bForceNetUpdate = TRUE;

		// Notification that targeting mode has been changed.
		TargetingModeChanged();
	}
}


/**
 * Notification called when targeting mode has been changed.
 * Network: ALL.
 */
final simulated function TargetingModeChanged()
{
	local GearPC PC;

	// If stopped targeting, and if he's not in walking volume, force Pawn into aiming stance for a little while
	if (!bIsTargeting && (WalkVolume(PhysicsVolume) == None || !WalkVolume(PhysicsVolume).bActive))
	{
		SetWeaponAlert(AimTimeAfterFiring);
	}

	// Notify the weapon that targeting mode has been changed.
	if( MyGearWeapon != None )
	{
		MyGearWeapon.TargetingModeChanged(Self);
	}

	// notify the hud about the change
	if( Controller != None )
	{
		PC = GearPC( Controller );
		if( (PC != None) && (PC.myHUD != None) )
		{
			GearHUD_Base(PC.myHUD).TargetingModeChanged(bIsTargeting);
		}
	}

	// See if we should mount/unmount heavy weapons.
	CheckHeavyWeaponMounting();

	// Check if shield should be deployed or not
	CheckShieldDeployment();

	if (bIsTargeting)
	{
		if (IsTimerActive('BodyMove_ChangeTargeting'))
		{
			ClearTimer('BodyMove_ChangeTargeting');
		}
		else
		{
			BodyMove_ChangeTargeting();
		}
	}
	else
	{
		// gets a delay, since the anim is slow to blend
		SetTimer( 0.3f, FALSE, nameof(BodyMove_ChangeTargeting) );
	}
}

final simulated function BodyMove_ChangeTargeting()
{
	SoundGroup.PlayFoleySound(self, GearFoley_Body_Aim);
}

/** AimOffset Pct Interpolation. */
simulated native final function float AimInterpTo(float Current, float Target, float DeltaTime, float InterpSpeed);

/** Origin used for AimOffset calculation. */
simulated event vector GetAimOffsetOrigin()
{
	local name RightHandName;
	local vector VectorLoc, SocketLoc, X, Y, Z;
	local rotator SocketRot;
	local Quat BoneQuat;
	local GearWeap_HeavyBase HeavyWeapon;

	if (Mesh == None)
	{
		return Location;
	}

	// Heavy weapons work as turrets when mounted, so use pivot point as aimoffset origin.
	HeavyWeapon = GearWeap_HeavyBase(Weapon);
	if (HeavyWeapon != None && (HeavyWeapon.IsBeingMounted() || HeavyWeapon.IsMounted()))
	{
		return Mesh.GetBoneLocation('b_MF_IK_Gun');
	}

	// Use weapon location as aimoffset origin, for better alignment.
	if (MyGearWeapon != None)
	{
		RightHandName = MyGearWeapon.GetDefaultHandSocketName(Self);
		if (RightHandName != '')
		{
			// Try as a socket first
			if( Mesh.GetSocketWorldLocationAndRotation(RightHandName, SocketLoc, SocketRot) )
			{
				GetAxes(SocketRot, X, Y, Z);
				return SocketLoc + Z * 12.f;
			}

			// try as a bone reference next;
			if( Mesh.MatchRefBone(RightHandName) != INDEX_NONE )
			{
				BoneQuat = Mesh.GetBoneQuaternion(RightHandName);
				SocketRot = QuatToRotator(BoneQuat);
				GetAxes(SocketRot, X, Y, Z);
				return Mesh.GetBoneLocation(RightHandName) + Z * 12.f;
			}
		}
	}

	if (PelvisBoneName != '' && Mesh.MatchRefBone(PelvisBoneName) != INDEX_NONE)
	{
		VectorLoc = Mesh.GetBoneLocation(PelvisBoneName);
		VectorLoc.Z = GetPawnViewLocation().Z;

		return VectorLoc;
	}

	// Otherwise take default view location
	return Location;
}

/** Native implementation of base AimDir update. */
simulated native function UpdateMeshBoneControllersNative(float DeltaTime);

/**
 * Calculate AimDir 2d vector, used by all Aim AnimNodes.
 * Network: ALL
 */
simulated function UpdateMeshBoneControllers(float DeltaTime)
{
	UpdateMeshBoneControllersNative(DeltaTime);
}

/**
 * Update WeaponAimIKPositionFix vector.
 * used to offset the weapon when the character is in "downsights" animation.
 * weapons have different shapes, and characters different sizes.
 * So we fix here the position of the weapon to prevent any clipping, and ensure character looks like he's properly aiming.
 */
simulated event FixWeaponAimIKPosition(float DeltaTime)
{
	local int		i;
	local vector	TargetWeaponAimIKPositionFix;

	// Interpolate WeaponAimIKPositionFix
	TargetWeaponAimIKPositionFix = GetWeaponAimIKPositionFix();

	// Do Interpolation
	WeaponAimIKPositionFix = VInterpTo(WeaponAimIKPositionFix, TargetWeaponAimIKPositionFix, DeltaTime, 8.f);

	// Do not overwrite IKHackNode if there's no offset, that way we can play with it in the editor.
	if( VSizeSq(WeaponAimIKPositionFix) > 0 )
	{
		// Update IKHackNode
		for(i=0; i<IKHackNode.BoneCopyArray.Length; i++)
		{
			IKHackNode.BoneCopyArray[i].PositionOffset = WeaponAimIKPositionFix;
		}
		// Do mirrored version
		for(i=0; i<IKHackNode.BoneCopyArrayMirrored.Length; i++)
		{
			IKHackNode.BoneCopyArrayMirrored[i].PositionOffset = WeaponAimIKPositionFix;
		}
	}
}

/**
 * @see FixWeaponAimIKPosition for details.
 * Return relative offset from right hand.
 */
simulated function vector GetWeaponAimIKPositionFix()
{
	// Aiming position fix for new HammerBurst mesh.
	if( MyGearWeapon.IsA('GearWeap_LocustAssaultRifle') || MyGearWeapon.IsA('GearWeap_Boomshot') )
	{
		return vect(0, -1, -4);
	}

	return vect(0,0,0);
}

/** Update AimOffset for this Pawn (interpolation and 360 aiming). */
final simulated native function UpdateAimOffset(Vector2d NewAimOffsetPct, FLOAT DeltaTime);

/**
 * Function to test if player would be in 360 aiming given the following parameters.
 * @param	bCurrentlyDoing360Aiming	TRUE if Pawn is currently in 360 aiming. (Affects thresholds).
 * @param	TestAimOffsetPct			Pawn's AimOffsetPct.
 * @param	TestCoverType				Type of Cover Pawn would be in.
 * @param	out_CoverDirection			returns which direction the Pawn would be facing (mirrored or not)
 * @return								TRUE if Pawn would be in 360aiming or FALSE if not.
 */
final simulated native function bool Simulate360Aiming(bool bCurrentlyDoing360Aiming, Vector2D TestAimOffsetPct, ECoverType TestCoverType, out ECoverDirection out_CoverDirection);

/** 360 <-> leaning transitions */
final simulated native function bool IsDoing360ToLeaningTransition();
final simulated native function bool IsDoingLeaningTo360Transition();

/** PopUp to Lean Transition. Straight blend, no animation. */
final simulated native function bool IsDoingPopUpToLeanTransition();

/** Notification called when bDoing360Aiming flag changes */
simulated event On360AimingChangeNotify()
{
	// Last time we changed 360 aiming status
	Last360AimingChangeTime = WorldInfo.TimeSeconds;

	// If doing 360 aiming, then go to default cover action.
	if( bDoing360Aiming )
	{
		SetCoverAction(CA_Default);
	}

	// Update our flag of what our last status was.
	bWasDoing360Aiming = !bDoing360Aiming;

	// Forward notification to weapon
	if( MyGearWeapon != None )
	{
		MyGearWeapon.On360AimingChangeNotify();
	}
}


/**
 * returns base Aim Rotation without any adjustment (no aim error, no autolock, no adhesion.. just clean initial aim rotation!)
 *
 * @return	base Aim rotation.
 */
simulated event Rotator GetBaseAimRotation()
{
	local rotator AimRot, DeltaRot;
	local GearPC PC;
	local vector2d NewAimOffsetPct;
	local Rotator TestDeltaRot;
	local vector	POVLoc;
	local rotator	POVRot;

	// While doing melee, aim in front, not what camera looks at.
	if( bDoingMeleeAttack )
	{
		AimRot = Rotation;
		if (Controller != None)
		{
			AimRot.Pitch = Controller.Rotation.Pitch;
		}
		return AimRot;
	}
	else
	{
		PC = GearPC(Controller);
		if ( (PC != None) && (PC.PlayerCamera != None) && ( (PC.PlayerCamera.CameraStyle == 'Fixed') || PC.bDebugFaceCam ) )
		{
			return PC.Rotation;
		}
	}

	if (Controller != None && !InFreeCam())
	{
		Controller.GetPlayerViewPoint(POVLoc, POVRot);
		AimRot = POVRot;
	}
	else
	{
		AimRot = Super.GetBaseAimRotation();
	}

	if( IsHumanControlled(Controller) && GearWeapon(Weapon) != None )
	{
		AimRot += GearWeapon(Weapon).GetHumanAimRotationAdjustment();
	}

	// clamp blindfiring pitch/yaw
	if( CoverType != CT_None && IsBlindFiring(CoverAction) && MyGearWeapon != None )
	{
		// if we're going to be in 360 aiming, we don't want to clamp, which could
		// prevent the pawn from actually doing the 360 aim
		TestDeltaRot = Normalize(AimRot - Rotation);
		// Convert DeltaRot to AimOffsetPct
		NewAimOffsetPct.X = TestDeltaRot.Yaw / 16384.f;
		NewAimOffsetPct.Y = TestDeltaRot.Pitch / 16384.f;

		if (!Simulate360Aiming(FALSE, NewAimOffsetPct, CoverType, CoverDirection))
		{
			// limit the pitch if blind firing up
			if (CoverAction == CA_BlindUp)
			{
				AimRot.Pitch = Max(MyGearWeapon.MinBlindFireUpAimPitch, Normalize(AimRot).Pitch);
			}
			else
			{
				// otherwise limit the yaw
				DeltaRot = Normalize(AimRot - Rotation);
				//`log("pre yaw:"@AimRot.Yaw@DeltaRot.Yaw);
				if( CoverAction == CA_BlindLeft )
				{
					AimRot.Yaw -= DeltaRot.Yaw - Min(-MyGearWeapon.MinBlindFireSideYaw, DeltaRot.Yaw);
				}
				else if( CoverAction == CA_BlindRight )
				{
					AimRot.Yaw -= DeltaRot.Yaw - Max(MyGearWeapon.MinBlindFireSideYaw, DeltaRot.Yaw);
				}
				//`log("post yaw:"@AimRot.Yaw@DeltaRot.Yaw);
			}
		}
	}
	return AimRot;
}

// Add hit mask
simulated function AddHitMask(vector HitLocation, vector HitStartLocation, float Radius, bool bGore=FALSE)
{
	if (GoreMaskTexture != None)
	{
		// I could block the creating texture, but if I do, if somebody changes option in the middle of game, it won't work.
		if ( !WorldInfo.GRI.ShouldShowGore() )
		{
			return;
		}

// 		FlushPersistentDebugLines();
// 		DrawDebugLine(HitStartLocation, HitLocation, 255, 0, 0, TRUE);
// 		DrawDebugSphere(HitLocation, Radius, 10, 255, 255, 0, TRUE);
// 		DebugFreezeGame();

		// if gore, don't worry about facing, and just draw sphere around it
		if ( bGore )
		{
			HitMaskComponent.SetCaptureParameters(HitLocation, Radius*HitMaskMultiplier, HitStartLocation, FALSE);
		}
		else // for normal gun shot, you would like it to check normal
		{
			HitMaskComponent.SetCaptureParameters(HitLocation, Radius*HitMaskMultiplier, HitStartLocation, TRUE);
		}
	}
}

// Util function to add gore hit mask
simulated function AddCleaverDamageEffect(float Radius)
{
	AddHitMaskBasedOnLastHitInfo(Radius);

	// spawn blood
	// spawn particle on break point
	WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Heavy_Sniper.Effects.P_Heavy_Sniper_Direction_Blood', LastTakeHitInfo.HitLocation , rotator(LastTakeHitInfo.Momentum));
}

// Util function to add gore hit mask
simulated function AddHitMaskBasedOnLastHitInfo(float Radius)
{
	if (LastTakeHitInfo.InstigatedBy!=none)
	{
		AddHitMask(LastTakeHitInfo.HitLocation, LastTakeHitInfo.InstigatedBy.Location, Radius, TRUE);
	}
}

// Util function to add gore hit mask
simulated function AddGoreHitMask(name BoneName, float Radius)
{
	local matrix BoneTransform;
	local vector BoneLoc, EndLoc;

	if (LastTakeHitInfo.InstigatedBy!=none)
	{
		AddHitMask(Mesh.GetBoneLocation(BoneName), LastTakeHitInfo.InstigatedBy.Location, Radius, TRUE);
	}
	else
	{
		// if instigatedby isn't found, just use bone rotation to project start loc
		BoneTransform = Mesh.GetBoneMatrix(Mesh.MatchRefBone(BoneName));
		BoneLoc = MatrixGetOrigin(BoneTransform);
		EndLoc = BoneLoc + vector(MatrixGetRotator(BoneTransform))*100;

		AddHitMask(BoneLoc, EndLoc, Radius, TRUE);
	}
}

simulated function ResetCanBeRunOverFlag()
{
	ClearTimer( nameof(ResetCanBeRunOverFlag) );
	bCanBeRunOver = default.bCanBeRunOver;
}

/**
 * Adjust Pawn Damage
 * - Adjust based on cover (makes cover safe)
 * - Adjust if Pawn is protected by a hostage.
 * - Vehicle damage adjustment
 */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	local bool bIsMultiplayerGame;
	local bool bIsAIControlled;
	local int Index;
	local GearPawnRidable_Base RidableBase;

	bIsMultiplayerGame = WorldInfo.GRI.IsMultiplayerGame();
	bIsAIControlled = AIController(Controller) != None;

	// scale by the current special move
	if( IsDoingASpecialMove() )
	{
		// Special case for Interactions. Only InteractionPawn is allowed to damage me.
		if( SpecialMoves[SpecialMove].bOnlyInteractionPawnCanDamageMe && InstigatedBy != InteractionPawn && InstigatedBy != Self )
		{
			Damage = 0;
			return;
		}

		Damage *= SpecialMoves[SpecialMove].default.DamageScale;
	}

	// If this pawn has a hostage, reduce frontal damage
	// Also if hostage has just been released this frame, consider Kidnapper still protected.
	// For Splash damage weapons, Hostage may just have been killed.
	if( IsAKidnapper() || (HostageReleaseTime == WorldInfo.TimeSeconds) )
	{
		Damage = ReduceKidnapperDamage(GearDamageType, Momentum, InstigatedBy, HitLocation, Damage, HitInfo);
	}
	else if (IsCarryingCleaver())
	{
		Damage = ReduceDamageForCleaverHolder(GearDamageType, HitInfo, Damage);
	}
	else if (IsCarryingShield())
	{
		Damage = ReduceDamageForShieldHolder(Momentum, GearDamageType, HitInfo, Damage);
	}
	else
	{
		RidableBase = GearPawnRidable_Base(Base);
		if (RidableBase != None)
		{
			RidableBase.AdjustDriverDamage(Damage, InstigatedBy != None ? InstigatedBy.Controller : None, HitLocation, Momentum, GearDamageType);
		}
	}

	Damage = ModifyDamageForGasTank(GearDamageType, HitInfo, Damage);

	// if we've eliminated damage don't bother reducing it further
	if (Damage <= 0)
	{
		return;
	}

	if (!bIsMultiplayerGame || WorldInfo.GRI.IsCoopMultiplayerGame())
	{
		// offer chainsaw protection to players in SP/CT games
		if (!bIsAIControlled && (SpecialMove == SM_ChainSawAttack || SpecialMove == SM_BayonetAttack || IsChainsawDueling()))
		{
			Damage = 0;
			return;
		}
		if (bIsAIControlled && GearAI_TDM(Controller) == None)
		{
			Index = PerDamageTypeModifiers.Find('DamageTypeName', GearDamageType.Name);
			if (Index != INDEX_NONE)
			{
				Damage *= PerDamageTypeModifiers[Index].Multiplier;
			}
		}
	}

	// handle cover protection
	if (!GearDamageType.default.bIgnoreCover && IsInCover())
	{
		// for multiplayer we use a less generous approach to cover protection, unless it was from an AI shot
		if (bIsMultiplayerGame && !WorldInfo.GRI.IsCoopMultiplayerGame())
		{
			Damage = MultiplayerCoverDamageAdjust(Momentum,InstigatedBy,HitLocation,Damage);
		}
		else
		{
			// for singleplayer, if they're in cover then eliminate the damage entirely
			if (IsProtectedByCover(Momentum))
			{
				// if it's an AI blind firing then only reduce damage, otherwise nullify the damage
				Damage *= (IsBlindFiring(CoverAction) && !IsPlayerOwned()) ? 0.5f : 0.f;
				Momentum = vect(0,0,0);
			}
		}
	}

	// in SP, reduce damage slightly at the end of our health so players have more "oh no I'm about to die!" time
	if (!bIsMultiplayerGame && !bIsAIControlled && Health < 0.25 * DefaultHealth)
	{
		Damage *= 0.75;
	}

	// Driven Vehicle
	if( DrivenVehicle != None )
	{
		DrivenVehicle.AdjustDriverDamage(Damage, InstigatedBy != None ? InstigatedBy.Controller : None, HitLocation, Momentum, GearDamageType);
	}
}


/** Reduce Kidnapper damage when he's holding a hostage. */
final singular function float ReduceKidnapperDamage(class<GearDamageType> GearDamageType, vector ShotDirection, Pawn InstigatedBy, vector HitLocation, float Damage, const out TraceHitInfo HitInfo)
{
	local bool		bExplosiveDamage;
	local vector	Dir;
	local float		DotAngle, Factor;

	if (WorldInfo.GRI.IsMultiplayerGame())
	{
		// meatshields that are immune to damage don't provide normal damage protection
		if (InteractionPawn != None && !InteractionPawn.CanBeSpecialMeleeAttacked(self))
		{
			return Damage;
		}
		// zero damage if they hit the meatshield or weapon hand
		if (HitInfo.HitComponent.Owner != self || HitInfo.BoneName == GetRightHandSocketName())
		{
			// meat shield takes this damage instead
			InteractionPawn.TakeDamage(Damage, (InstigatedBy != None) ? InstigatedBy.Controller : None, HitLocation, ShotDirection, GearDamageType, HitInfo);
			return 0;
		}
	}

	// Is this explosive damage?
	bExplosiveDamage = ClassIsChildOf(GearDamageType, class'GDT_Explosive');

	// don't protect against headshots
	if( bLastHitWasHeadShot && !bExplosiveDamage )
	{
		return Damage;
	}

	Dir	= -Normal(ShotDirection);
	DotAngle = Dir dot vector(Rotation);

	// If being shot from the front
	if( DotAngle > 0.f )
	{
		Factor = FClamp(Square(1.f - DotAngle) * (90.f / KidnapperHalfAngleOfProtection), 0.f, 1.f);

		// the scalar is for "protection", which is the opposite of the damage scalar, so we jump thru some math hoops here
		Factor = 1.f - ( (1.f - Factor) * GearDamageType.default.MeatshieldProtecionScale );
		Factor = FClamp(Factor, 0.f, 1.f);

		//`log(WorldInfo.TimeSeconds @ Self$"::"$GetStateName()$"::"$GetFuncName() @ "Factor:" @ Factor @ "Orig Damage:" @ Damage @ "Reduced Damage:" @ (Damage*Factor));

		// pass mitigated damage to meatshield
		InteractionPawn.TakeDamage(Damage * (1.0 - Factor), (InstigatedBy != None) ? InstigatedBy.Controller : None, HitLocation, ShotDirection, GearDamageType, HitInfo);

		// Reduce damage
		return Damage * Factor;
	}

	return Damage;
}

/** Players should be able to target again */
function ClearShieldDropTargetingPrevention()
{
	bPreventTargetingDueToShieldDrop = FALSE;
}

/** Reduce Kidnapper damage when he's holding a hostage. */
function float ReduceDamageForShieldHolder(vector ShotDirection, class<GearDamageType> DamType, const out TraceHitInfo HitInfo, float Damage)
{
	local vector	Dir;
	local float		DotAngle, Factor, ProtAngle;

	Dir = -Normal(ShotDirection);
	DotAngle = Dir dot vector(Rotation);
	// If being shot from the front
	if (DotAngle > 0.f)
	{
		ProtAngle = IsDeployingShield() ? DeployedShieldHalfAngleOfProtection : ShieldHalfAngleOfProtection;
		Factor = FClamp(Square(1.f - DotAngle) * (90.f / ProtAngle), 0.f, 1.f);
	}
	else
	{
		Factor = 1.0;
	}

	// for explosive damage types, cut damage.  ballistic damage types are handled by colliding the traces
	// with the shield mesh.
	if (ClassIsChildOf(DamType, class'GDT_Explosive'))
	{
		Damage *= Factor;

		// most explosions cause the player to drop the shield after preventing damage
		if (class<GDT_Explosive>(DamType).default.bCausesShieldDrop)
		{
			DropShield();
			bPreventTargetingDueToShieldDrop = TRUE;
			SetTimer(1.5f, FALSE, nameof(ClearShieldDropTargetingPrevention));
		}
	}
	else if (ClassIsChildOf(DamType, class'GDT_Fire') || ClassIsChildOf(DamType, class'GDT_Melee'))
	{
		// Reduce damage
		Damage *= Factor;
	}
	else
	{
		// did we hit the shield itself?
		if (ComponentIsAnEquippedShield(HitInfo.HitComponent))
		{
			if (ClassIsChildOf(DamType, class'GDT_HeavySniperRifle'))
			{
				// special handling for getting hit in the shield with heavy sniper
				// we want to drop the shield, cringe the hitpawn, and do a fixed amount of damage
				Damage = class'GearWeap_HeavySniperBase'.default.DamageToShieldHolder;
				DropShield(True, True);
				Cringe();
			}
			else
			{
				Damage = 0.f;
			}
		}
		else if (IsDeployingShield())
		{
			// give some damage reduction in front even in the areas not covered by the shield
			Damage *= FMax(Factor, 0.35);
		}
	}

	return Damage;
}

/**
 *  Allow the cleaver to absorb some damage.
 *
 *  @param DamType - the damage class of the current hit
 *
 *  @param HitInfo - misc info about the current hit
 *
 *  @param Damage - the amount of damage caused if not blocked by the cleaver
 *
 *  @return the reduced amount of damage
 */
function float ReduceDamageForCleaverHolder(class<GearDamageType> DamType, const out TraceHitInfo HitInfo, float Damage)
{
	if (ComponentIsAnEquippedCleaver(HitInfo.HitComponent))
	{
		if (ClassIsChildOf(DamType, class'GDT_HeavySniperRifle'))
		{
			// special handling for getting hit in the cleaver with heavy sniper
			// Cringe the hitpawn, and do a fixed amount of damage
			Damage = class'GearWeap_HeavySniperBase'.default.DamageToShieldHolder;
			Cringe();
		}
		else
		{
			Damage = 0.f;
		}
	}

	return Damage;
}


/** Let the gas tank take a chance to absorb damage from the player to itself and potentially spawn effects/blow up
 *  @param DamType - the damage class of the current hit
 *
 *  @param HitInfo - misc info about the current hit
 *
 *  @param Damage - the amount of damage caused if not blocked by the cleaver
 *
 *  @return the reduced amount of damage
 */
simulated function float ModifyDamageForGasTank(class<GearDamageType> DamType, const out TraceHitInfo HitInfo, float Damage)
{
	if (ComponentIsAnEquippedGasTank(HitInfo.HitComponent))
	{
		`log("DAMAGE: "$Damage$", Health:"$EquippedGasTankHealth);
		EquippedGasTankHealth -= Damage;
		if (EquippedGasTankHealth <= 0)
		{
			//EXPLODE!!!
			`log("EXPLODE!");
			EquippedGasTank.Explode();
			RemoveGasTank();
		}
		//Return a little, so the player gets a notification and knows that he is being shot
		return 1.0f;
	}
	else
	{
		return Damage;
	}
}

//Function to remove the gas tank from this pawn's back
simulated function RemoveGasTank()
{
	bHasGasTank = false;
	if (EquippedGasTank != None)
	{
		EquippedGasTank.RemoveFromSlot();
		EquippedGasTank.Destroy();
		EquippedGasTank=none;
	}
	if (EquippedGasTankComponent != none)
	{
		EquippedGasTankComponent.SetHidden(true);
		EquippedGasTankComponent.SetActorCollision(FALSE,FALSE);
		EquippedGasTankComponent.SetBlockRigidBody(FALSE);
		EquippedGasTankComponent.SetTraceBlocking(FALSE,FALSE);
		if (Mesh != none)
		{
			Mesh.DetachComponent(EquippedGasTankComponent);
		}
		EquippedGasTankComponent=none;
	}
}


/**
 * Modify damage based on cover in MP
 */
simulated final function float MultiplayerCoverDamageAdjust( vector ShotDirection, Pawn InstigatedBy, vector HitLocation, float Damage )
{
	local vector2D	AngularDist;
	local vector	AxisX, AxisY, AxisZ, ShotStart;
	local bool		bIsInFront;
	local float dist;

	// Make sure player has valid cover, and is not leaning
	if( SpecialMove == SM_Run2MidCov ||
		SpecialMove == SM_Run2StdCov ||
		CoverType == CT_None ||
		CoverAction == CA_LeanLeft ||
		CoverAction == CA_LeanRight ||
		CoverAction == CA_PopUp )
	{
		return Damage;
	}

	GetAxes(Rotation, AxisX, AxisY, AxisZ);
	ShotDirection = -1.f * Normal(ShotDirection);
	bIsInFront = GetAngularDistance(AngularDist, ShotDirection, AxisX, AxisY, AxisZ );

	// if shot is from front and on same level
	if( bIsInFront ) //&& Abs(InstigatedBy.Location.Z - Location.Z) < GetCollisionHeight() )
	{
		// check shot's angle of attack against cover's orientation
		GetAngularDegreesFromRadians( AngularDist );
		//`log(GetFuncName()@AngularDist.X@CoverProtectionFOV.X@AngularDist.Y@`showvar(ShotDirection));
		// Use 20 instead of the 30 on CoverProtectionFOV.Y for MP
		if ( Abs(AngularDist.X) < CoverProtectionFOV.X && AngularDist.Y < 20 )
		{
			// no damage if side isn't visible
			if ( InstigatedBy != None )
			{
				ShotStart = HitLocation + VSize(InstigatedBy.Location - Location) * ShotDirection;

				if ( !FastTrace(Location + CylinderComponent.CollisionRadius * Normal(ShotDirection cross vect(0,0,1)), ShotStart)
					&& !FastTrace(Location - CylinderComponent.CollisionRadius * Normal(ShotDirection cross vect(0,0,1)), ShotStart) )
				{
					// smoothly interpolate damage if close up, if completely covered
					Dist = VSize(Location - InstigatedBy.Location);
					return Damage * FClamp((320 - Dist)/320,0,1);
				}
			}

			// smoothly interpolate damage if in cover
			return FMax(Abs(AngularDist.X)/CoverProtectionFOV.X, Abs(AngularDist.Y)/25) * Damage;
		}
	}

	return Damage;
}


/**
 * Returns TRUE if player is safe in cover from the shot direction.
 * This function decides if a shot should be ignored because the player is considered safely protected by its current cover.
 * Not used in MP.
 */
final simulated native function bool IsProtectedByCover( vector ShotDirection, optional bool bSkipPlayerCheck, optional bool bSkipCoverActionCheck );


/**
 * Change depth priority group for mesh and attached meshes
 */
simulated function SetDepthPriorityGroup(ESceneDepthPriorityGroup NewDepthPriorityGroup)
{
	local int	Idx;
	local bool	bUseViewOwnerDepthPriorityGroup;

	// If we're a kidnapper or a hostage, ignore DepthPriorityGroup setting
	// As this is creating sorting issues because both actors are not owned by the same viewport.
	// We don't really care because you can't go in cover in this context.
	if( IsAHostage() || IsAKidnapper() )
	{
		NewDepthPriorityGroup = SDPG_World;
	}

	if( Mesh != None )
	{
		bUseViewOwnerDepthPriorityGroup = NewDepthPriorityGroup != SDPG_World;

		Mesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
		if( (Weapon != None) && (Weapon.Mesh != None) )
		{
			Weapon.Mesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
		}

		// any attachments
		for(Idx = 0; Idx < AttachSlots.Length; Idx++)
		{
			if( AttachSlots[Idx].StaticMesh != None )
			{
				AttachSlots[Idx].StaticMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
			}
			if( AttachSlots[Idx].SkeletalMesh != None )
			{
				AttachSlots[Idx].SkeletalMesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup,NewDepthPriorityGroup);
			}
		}

		// Shield
		if( EquippedShield != None && EquippedShield.Mesh != None )
		{
			EquippedShield.Mesh.SetViewOwnerDepthPriorityGroup(bUseViewOwnerDepthPriorityGroup ,NewDepthPriorityGroup);
		}
	}
}

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
	// Don't allow damage to be adjusted
	bAllowDamageModification = FALSE;
	if(Action.Instigator == none)
	{
		Action.Instigator = self;
	}
	Super.OnModifyHealth( Action );
	bAllowDamageModification = TRUE;
}

function CrushedBy(Pawn OtherPawn);

function bool ConfineToClampedBase()
{
	local InterpActor_GearBasePlatform PlatBase;

	// If no longer on our clamped base
	if( ClampedBase != None && Base != ClampedBase )
	{
		PlatBase = InterpActor_GearBasePlatform(Base);

// 		`DLog("Base:" @ Base @ "ClampedBase:" @ ClampedBase @ "Base.Base:" @ Base.Base @ "ClampedBase.Base:" @ ClampedBase.Base @ "PlatBase:" @ PlatBase);

		// If not moving onto another platform OR
		// If not moving onto a platform that is our current platforms base or shares a base (used for torture barges)
		if( PlatBase == None ||
			PlatBase.bAlwaysConfineToClampedBase ||
			( PlatBase.Base != None &&
			  PlatBase.Base != ClampedBase &&
			  PlatBase.Base != ClampedBase.Base ) )
		{
			// Confine the pawn to our original clamped platform
			return TRUE;
		}
	}
	return FALSE;
}

event BaseChange()
{
	local bool	bBasedOnInteractionPawn;

	// See if Pawn is based on his interaction pawn (eg. hostage)
	bBasedOnInteractionPawn = InteractionPawn != None && IsDoingASpecialMove() && (Base == InteractionPawn);

	// if necessary, force the Pawn to stay on its old Base
	if( ClampedBase != None && ClampedBase != Base && (bJustTeleported || Physics == PHYS_RigidBody) )
	{
// 		`DLog("Clear ClampedBase:" @ ClampedBase @ "cleared. New Base:" @ Base @ "SpecialMove" @ SpecialMove @ "Physics:" @ Physics @ "bJustTeleported:" @ bJustTeleported);
		ClampedBase = None;
	}

// 	`DLog("ClampedBase:" @ ClampedBase @ "NewBase:" @ Base @ "bHardAttach:" @ bHardAttach @ "bBasedOnInteractionPawn:" @ bBasedOnInteractionPawn @ "ConfineToClampedBase:" @ ConfineToClampedBase());

	// if necessary, force the Pawn to stay on its old Base
	// Don't override Pawns doing a special move which can be forced to be based on their InteractionPawn
	if( ClampedBase != None && !bHardAttach && !bBasedOnInteractionPawn && ConfineToClampedBase() )
	{
// 		`DLog("Restore ClampedBase:" @ ClampedBase @ "instead of keeping NewBase:" @ Base );

		SetBase(ClampedBase);
		if( Physics == PHYS_Falling && Controller != None )
		{
			bCanJump = true;
			Controller.MayFall(FALSE, vect(0,0,0));
			if (!bCanJump)
			{
				SetPhysics(WalkingPhysics);
			}
		}
	}
	else
	{
// 		`DLog("Calling Super::BaseChange");
		Super.BaseChange();
	}
}

function JumpOffPawn()
{
	local Pawn OtherP;
	OtherP = Pawn(Base);
	// don't actually jump if not really above or inside the other Pawn
	// this fixes some cases where the collidable geometry of the other Pawn changes (e.g. the shield)
	// causing us to think we need to jump off of it
	if (OtherP != None && VSize2D(Location - Base.Location) >= (CylinderComponent.CollisionRadius+OtherP.CylinderComponent.CollisionRadius))
	{
		SetPhysics(PHYS_Falling);
	}
	else
	{
		Velocity += (100 + CylinderComponent.CollisionRadius) * Vector(Rotation);
		if ( VSize2D(Velocity) > FMax(500.0, GroundSpeed) )
		{
			Velocity = FMax(500.0, GroundSpeed) * Normal(Velocity);
		}
		Velocity.Z = 50 + CylinderComponent.CollisionHeight;
		SetPhysics(PHYS_Falling);
	}
}

/** Register a near miss hit */
function RegisterNearHitMiss(ImpactInfo Impact, class<DamageType> InDamageType)
{
	local CringeInfo	OutCringeInfo;
	local FLOAT			ChanceToPlayCringe;

	// Enforce a minimum delay between hits
	if( `TimeSince(LastShotAtTime) < 0.2f )
	{
// 		`DLog("Was last shot at" @ `TimeSince(LastShotAtTime) @ "seconds ago. So Skipping:" @ InDamageType);
		return;
	}

	// Clear NearHitHistory
	ClearCringeHistory(NearHitHistory, 5.f);
	// We keep a history of cringes for 10 seconds
	ClearFLOATArrayHistory(CringeHistory, 10.f);

	// Keep track of shots through LastShotAtTime;
	ShotAtCount++;
	ShotAtCountIncreased();

	// First case is for impacts hapening really close to the player
	//if( Impact.HitActor != None && VSize(Impact.HitLocation - Location) <= 200 )
	if( TRUE )
	{
		// Keep our history up to date.
		AddCringeHistoryTime(NearHitHistory, InDamageType);
		GetCringeInfo(NearHitHistory, InDamageType, OutCringeInfo);

		// If this is the first time this damage type is triggered for this history,
		// or if not cringes have been played recently... go ahead, Trigger it!
		if( OutCringeInfo.History.Length == 1 /*|| CringeHistory.Length == 0*/ )
		{
			TryPlayNearMissCringe();
		}
		// If this damage type has been repeated then see if we should trigger another cringe for it
		else
		{
			// Chance to play this cringe is decreased by the number of recent cringes we've done and the number of times we've been shot at by this damage type.
			ChanceToPlayCringe = 1.f / (1.f + float(CringeHistory.Length) + float(OutCringeInfo.History.Length) / 4.f);
// 			`DLog("ChanceToPlayCringe:" @ ChanceToPlayCringe @ "CringeHistory:" @ CringeHistory.Length @ "CringeInfoHistory" @ OutCringeInfo.History.Length);
			if( ChanceToPlayCringe > 0.2f && (FRand() < ChanceToPlayCringe) )
			{
				TryPlayNearMissCringe();
			}
		}

// 		WorldInfo.AddOnScreenDebugMessage(0, 5.f, MakeColor(160,160,160,255), "CringeHistory:" @ CringeHistory.Length @ "CringeInfoHistory:" @ OutCringeInfo.History.Length );
	}
}



/**
 * Called when ShotAtCount is increased, and sets ShotAtTime to the current time.
 * Doing it this way because time is different between client and servers.
 */
simulated function ShotAtCountIncreased()
{
	LastShotAtTime = WorldInfo.TimeSeconds;
}

simulated function bool TryPlayNearMissCringe()
{
	// Limit the frequency of those guys
	if( `TimeSince(LastCringeTime) > 0.3f )
	{
		if( PlayNearMissCringe() )
		{
			CringeHistory[CringeHistory.Length] = WorldInfo.TimeSeconds;
			LastCringeTime = WorldInfo.TimeSeconds;

			// Replication
			if( Role == ROLE_Authority )
			{
				CringeCount++;
			}

			return TRUE;
		}
	}

	return FALSE;
}

/** Replicated and called when it's time to play a Near Miss Cringe Reaction! */
simulated function CringeCountIncreased()
{
	// Near Miss hapened, try to play a cringe overlay animation.
	TryPlayNearMissCringe();
}

/** By default, play nothing. */
simulated function bool PlayNearMissCringe()
{
	return FALSE;
}

simulated final function AddCringeHistoryTime(out Array<CringeInfo> InHistory, class<DamageType> InDamageType)
{
	local INT			Index;
	local CringeInfo	NewCringeInfo;

	// See if we can find an existing entry
	for(Index=0; Index<InHistory.Length; Index++)
	{
		if( InHistory[Index].DamageType == InDamageType )
		{
			InHistory[Index].History[ InHistory[Index].History.Length ] = WorldInfo.TimeSeconds;
			return;
		}
	}

	// If none found, create a new entry
	NewCringeInfo.DamageType = InDamageType;
	NewCringeInfo.History[0] = WorldInfo.TimeSeconds;
	NewCringeInfo.NextCringeTime = WorldInfo.TimeSeconds;
	InHistory[InHistory.Length] = NewCringeInfo;
}

/**
 * Clear anything that's older than LifeTime seconds.
 */
simulated final function ClearCringeHistory(out Array<CringeInfo> InHistory, FLOAT LifeTime)
{
	local INT	HistoryIdx, TimeIdx;
	local FLOAT	CringeTime;

	for(HistoryIdx=InHistory.Length-1; HistoryIdx>=0; HistoryIdx--)
	{
		for(TimeIdx=InHistory[HistoryIdx].History.Length-1; TimeIdx>=0; TimeIdx--)
		{
			CringeTime = `TimeSince(InHistory[HistoryIdx].History[TimeIdx]);
			if( CringeTime >= LifeTime || CringeTime <= 0 )
			{
				InHistory[HistoryIdx].History.Remove(0, TimeIdx+1);
				break;
			}
		}

		// If history is empty for this damage type, just get rid of this entry...
		if( InHistory[HistoryIdx].History.Length == 0 )
		{
			InHistory.Remove(HistoryIdx, 1);
		}
	}
}

/**
 * Clear anything that's older than LifeTime seconds.
 */
simulated final function ClearFLOATArrayHistory(out Array<FLOAT> History, FLOAT LifeTime)
{
	local INT	TimeIdx;
	local FLOAT	KeyTime;

	for(TimeIdx=History.Length-1; TimeIdx>=0; TimeIdx--)
	{
		KeyTime = `TimeSince(History[TimeIdx]);
		if( KeyTime >= LifeTime || KeyTime <= 0 )
		{
			History.Remove(0, TimeIdx+1);
			break;
		}
	}
}

simulated final function FLOAT GetLastCringeHistoryTime(out const Array<CringeInfo> InHistory, class<DamageType> InDamageType)
{
	local INT Index;

	for(Index=0; Index<InHistory.Length; Index++)
	{
		if( InHistory[Index].DamageType == InDamageType )
		{
			if( InHistory[Index].History.Length > 0 )
			{
				return InHistory[Index].History[ InHistory[Index].History.Length ];
			}
			break;
		}
	}

	return 0.f;
}

simulated final function FLOAT GetNextCringeTime(out const Array<CringeInfo> InHistory, class<DamageType> InDamageType)
{
	local INT	Index;

	for(Index=0; Index<InHistory.Length; Index++)
	{
		if( InHistory[Index].DamageType == InDamageType )
		{
			return InHistory[Index].NextCringeTime;
		}
	}

	return WorldInfo.TimeSeconds;
}

simulated final function bool GetCringeInfo(out const Array<CringeInfo> InHistory, class<DamageType> InDamageType, out CringeInfo OutCringeInfo)
{
	local INT Index;

	for(Index=0; Index<InHistory.Length; Index++)
	{
		if( InHistory[Index].DamageType == InDamageType )
		{
			OutCringeInfo = InHistory[Index];
			return TRUE;
		}
	}

	return FALSE;
}

/**
 *  Overridden to store off radial damage info for certain effects.
 */
simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
 	bTakingRadiusDamage = true;
 	RadialDamageOrigin = HurtOrigin;
	Super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
	bTakingRadiusDamage = false;
}

/** Get a Pawn to enter DBNO state. */
function EnterDBNO(Controller InControllerWhoPutMeDBNO, class<GearDamageType> InDamageTypeThatPutMeDBNO, vector InMomentumThatPutMeDBNO)
{
	`LogSM("");

	// if we don't support DBNO, pretend this didn't happen
	if (!bCanDBNO)
	{
		Health = Max(Health, 1);
		return;
	}

	// Can't send someone to DBNO state if he's already doing the special move or if he's a hostage.
	if (IsDBNO() || IsAHostage())
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Cannot be sent to DBNO state. SpecialMove:" @ SpecialMove);
		ScriptTrace();
		return;
	}

	// Save controller for future use (if we bleed out to death)
	ControllerWhoPutMeDBNO = InControllerWhoPutMeDBNO;
	DamageTypeThatPutMeDBNO	= InDamageTypeThatPutMeDBNO;
	MomentumThatPutMeDBNO = Normal(InMomentumThatPutMeDBNO);

	// If we should wait for current special move to finish before entering DBNO state
	if (IsInState('KnockedDown') || (SpecialMove != SM_None && SpecialMoves[SpecialMove] != none && SpecialMoves[SpecialMove].CanDelayDBNO()))
	{
		// This will call EnterDBNO again after the current special move is done.
		bDelayedDBNO = TRUE;
	}
	// Or enter now
	else
	{
		GotoState('DBNO');
	}
}

// we don't take falling damage
function TakeFallingDamage();

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local int OldHealth, AmountHealed;
	local GearPRI PRI, HealerPRI;

	OldHealth = Health;
	if (bCanBeHealed && Super.HealDamage(Amount, Healer, DamageType))
	{
		AmountHealed = Health - OldHealth;
		if (Healer != None)
		{
			PRI = GearPRI(PlayerReplicationInfo);
			HealerPRI = GearPRI(Healer.PlayerReplicationInfo);
			if (PRI != None && HealerPRI != None)
			{
				PRI.ScoreHeal(HealerPRI, float(AmountHealed) / float(DefaultHealth));
			}
		}

		return true;
	}
	else
	{
		return false;
	}
}

/**
 * Overridden for GoW's specific damage taking needs, whee!
 *
 * @see Actor::TakeDamage
 */
function TakeDamage( int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType,
			optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local Pawn InstigatedByPawn;
	local GearPRI InstigatorPRI, PRI;
	local GearGRI GRI;
	local class<GearDamageType> GearDamageType;
`if(`notdefined(FINAL_RELEASE))
	local PlayerController PC;
`endif
	local float DmgDistance;
	local bool bWasInVehicle;

	// make sure we are the server and we're alive
	if (Role < ROLE_Authority || Health <= 0 || InGodMode() || bTearOff)
	{
		return;
	}

	// prevent pain volumes and such from killing us before we have a chance to initialize health values
	if (Controller == None && CreationTime == WorldInfo.TimeSeconds)
	{
		return;
	}

	GearDamageType = class<GearDamageType>(DamageType);
	// if passed an invalid damagetype then use the default
	if( GearDamageType == None )
	{
		GearDamageType = class'GearDamageType';
	}

	// make sure the we are not invincible from respawning
	// Note: this is not done in AdjustPawnDamage because outside factors (like being in MP or being
	// hit by an explosion) will negate the adjustment and we need to make sure this happens.
	if (GearGame(WorldInfo.Game).IsRespawnInvincible(self) && !GearDamageType.default.bEnvironmentalDamage)
	{
		if ( PlayerController(InstigatedBy) != None )
		{
			PlayerController(InstigatedBy).ClientPlaySound(SoundCue'Interface_Audio.Interface.BurstDamageWarning01Cue');
		}
		return;
	}

	GRI = GearGRI(WorldInfo.GRI);
	PRI = GearPRI(PlayerReplicationInfo);

	if (PRI == None && DrivenVehicle != None)
	{
		PRI = GearPRI(DrivenVehicle.PlayerReplicationInfo);
	}
	else if (PRI == None && Base != None && Base.IsA('GearPawnRidable_Base'))
	{
		PRI = GearPRI(GearPawnRidable_Base(Base).PlayerReplicationInfo);
	}

	// cache the instigator parms
	if (InstigatedBy != None)
	{
		InstigatedByPawn = InstigatedBy.Pawn;
		// use last controlled pawn if not currently controlling one (e.g. died while shot was in flight)
		if (InstigatedByPawn == None && GearPC(InstigatedBy) != None)
		{
			InstigatedByPawn = GearPC(InstigatedBy).LastPawn;
		}
		InstigatorPRI = GearPRI(InstigatedBy.PlayerReplicationInfo);
	}

	// if the hit location is invalid then adjust to base location
	if (IsZero(HitLocation))
	{
		HitLocation = GetBaseTargetLocation();
	}

	// limit the size of the momentum
	if( VSize(Momentum) > 4.f )
	{
		Momentum = Normal(Momentum);
	}

	// verify the hit info is valid
	//@fixme this if statement shouldn't be necessary once the real boomershield asset is in, since it's a skeletal mesh.
	// seems kinda fragile code though, to try and enforce skelmesh hits
//	if ( !ComponentIsAnEquippedShield(HitInfo.HitComponent) )
//	{
		CheckHitInfo(HitInfo, Mesh, Momentum, HitLocation);
//	}

	// remember the last time we were shot at
	ShotAtCountIncreased();

	// reset physics if necessary
	// (do not change when in special move - special move will reset when it's ready)
	if( Physics == PHYS_None && DrivenVehicle == None && !IsDoingASpecialMove() )
	{
		SetMovementPhysics();
	}
	// if we're allowed to modify damage
	if( bAllowDamageModification )
	{
		//@warning: order of operations here is important for e.g. mutators
		if (Damage != 0)
		{
			// first allow the damage type a first-pass modifier
			GearDamageType.static.ModifyDamage(self, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
		}

		// notify the game info of the damage, possibly scaling the values
		// - this handles stuff like god mode, friendly fire, etc

		//@FIXME: this should really be last, so game rules can properly assess scoring
		//	unfortunately too many subclasses overload AdjustPawnDamage() to actually apply damage and it's too late to go rewriting that
		WorldInfo.Game.ReduceDamage(Damage, Self, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser);

		// if the damage wasn't eliminated
		if (Damage != 0)
		{
			// adjust damage based on various stuff (generally just cover)
			AdjustPawnDamage(Damage, InstigatedByPawn, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);
		}
	}

`if(`notdefined(FINAL_RELEASE))
	if (bDebugDamageText || class'GearGRI'.default.bDebugShowDamage)
	{
		foreach WorldInfo.AllControllers(class'PlayerController',PC)
		{
			PC.AddDebugText(string(Damage),self,5.f,vect(0,0,64.f) ,vect(64.f,64.f,256.f) * VRand(),class'HUD'.default.RedColor,TRUE);
		}
	}
`endif

	// if any damage is actually generated
	if( Damage != 0 )
	{
		// stop any health recharge
		ResetHealthRecharge();

		// call Actor's version to handle any SeqEvent_TakeDamage for scripting
		Super(Actor).TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, HitInfo, DamageCauser );

		// Log the hit, but only if the round is in progress
		if (GRI.GameStatus == GS_RoundInProgress && PRI != None)
		{
			PRI.ScoreHit(InstigatorPRI, DefaultHealth, Health, Damage, GearDamageType, DamageCauser);
		}

		bWasInVehicle = (DrivenVehicle != None);
		if (Damage >= Health && !bUnlimitedHealth)
		{
			// will die, kick off of turret.
			// note we cannot do this after Health is decremented, because controller won't repossese pawn proprely (see vehicle.driverleave())
			KickPawnOffTurret();

			// The PRI might've changed in KickPawnOffTurret due to things like the leader not being able to die and being booted from a vehicle
			PRI = GearPRI(PlayerReplicationInfo);
		}

		// apply the damage
		Health -= Damage;

		if (GearGameMP_Base(WorldInfo.Game) == None && PlayerController(Controller) != None && Health < 0.33 * DefaultHealth && !PlayBurstDamageWarningSoundSemaphore)
		{
			PlayerController(Controller).ClientPlaySound(SoundCue'Interface_Audio.Interface.BurstDamageWarning01Cue');
			PlayBurstDamageWarningSoundSemaphore = true;
			SetTimer(4.0, false, nameof(ResetPlayBDWarningSoundSemaphore));
		}

		// play any associated fx/sounds
		DoDamageEffects(Damage, InstigatedByPawn, HitLocation, GearDamageType, Momentum, HitInfo);

		// allow the damage type to add any extra fx/etc
		GearDamageType.static.HandleDamagedPawn(self, InstigatedByPawn, Damage, Momentum);

		// handle unlimited health cheat
		if (Health <= 0 && bUnlimitedHealth)
		{
			Health = 1;
		}

		// keep track of who the last person was that damaged us
		LastHitBy = (InstigatedBy != None && InstigatedBy != Controller) ? InstigatedBy : LastHitBy;

		// if we are now dead,
		if (Health <= 0)
		{
			// if we should DBNO
			if (AllowedToDBNO() && (GearDamageType.static.ShouldDBNO(self, InstigatedByPawn, HitLocation, HitInfo) || ShouldForceDBNO(GearDamageType,InstigatedByPawn,HitLocation)))
			{
				// Send Pawn to DBNO
				EnterDBNO(InstigatedBy, GearDamageType, Momentum);
			}
			// Kill
			else
			{
				TearOffMomentum	= Momentum;

				// The PRI could be invalid if this is a vehicle that boots the driver on death instead of killing them.
				if (PRI != None && !IsA('GearPawn_SilverbackBase'))
				{
					if (InstigatorPRI != None)
					{
						// track the kill for the instigator
						InstigatorPRI.ScoreInstantKill(PRI, GearDamageType, bLastHitWasHeadShot ? GDT_HEADSHOT : GDT_NORMAL);
					}
					else if (ClassIsChildOf(GearDamageType, class'GDT_Environment'))
					{
						// see if it was environment damage and pass it on to the death messages
						PRI.ScoreDeath(None, GearDamageType, GDT_NORMAL, GearDamageType.default.bSuicidePenalty ? -100 : 0);
					}
					else
					{
						PRI.ScoreDeath(None, GearDamageType, bLastHitWasHeadShot ? GDT_HEADSHOT : GDT_NORMAL, 0);
					}
				}

				// no drops on death for Pawns in vehicles
				if (bWasInVehicle)
				{
					bAllowInventoryDrops = false;
				}

				// otherwise die and let PlayDying() sort out gib/ragdoll
				Died(InstigatedBy, damageType, HitLocation);
			}
		}
		else
		{
			// keep track of last time we received damage
			LastTookDamageTime = WorldInfo.TimeSeconds;

			// Handle Stopping Power
			if(bAllowStoppingPower)
			{
				DmgDistance = (InstigatedByPawn != None ? VSize(InstigatedByPawn.Location - Location) : (DamageCauser != None ? VSize(DamageCauser.Location - Location) : 0.f));
				if( GearDamageType.default.StoppingPower > 0.f && DmgDistance < MaxStoppingPowerDistance)
				{
					HandleStoppingPower(GearDamageType, Momentum, DmgDistance);
				}
			}

			// Check for chainsaw interrupt
			if (IsDoingSpecialMove(SM_ChainsawHold) && DamageCauser != None && GSM_ChainsawHold(SpecialMoves[SpecialMove]).bInterruptedByDamage && !WorldInfo.GRI.OnSameTeam(DamageCauser, self))
			{
				ForceStopMeleeAttack(true);
				ServerDoSpecialMove(SM_ChainsawInterrupt, true);
				PlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue');
			}

			if (IsDoingSpecialMove(SM_TradeWeapons) && !WorldInfo.GRI.OnSameTeam(DamageCauser, self))
			{
				ServerEndSpecialMove(SM_TradeWeapons);
			}

			// notify the AI of being hit
			if (MyGearAI != None)
			{
				MyGearAI.GearAINotifyTakeHit(InstigatedBy, HitLocation, Damage, GearDamageType, Momentum, HitInfo);
			}
			if( DrivenVehicle != None &&
				GearAI(DrivenVehicle.Controller) != None )
			{
				GearAI(DrivenVehicle.Controller).GearAINotifyTakeHit(InstigatedBy, HitLocation, Damage, GearDamageType, Momentum, HitInfo);
			}
		}
	}

	if (Health > 0)
	{
		// fire off any gud events associated with damage.  it's ok if damage is 0 here.
		TriggerDamageGUDEvent(Damage, InstigatedByPawn, GearDamageType);
	}

	// make noise for AI purposes
	MakeNoise(1.f,'TakeDamage');

	if (GearDamageType == class'GDT_StickyGoo')
	{
		// Send Pawn to DBNO
		EnterDBNO(InstigatedBy, GearDamageType, Momentum);
	}
}

/** Double check we're allowed to actually DBNO */
function bool AllowedToDBNO()
{
	local GearPC PC;

	if( !bCanDBNO )
	{
		return FALSE;
	}

	// Doing a special move that doesn't allow DBNO
	if (SpecialMove != SM_None && SpecialMoves[SpecialMove].bDisallowDBNO)
	{
		return FALSE;
	}

	PC = GearPC(Controller);
	if (GearGRI(WorldInfo.GRI).bIsCoop && GetTeamNum() == TEAM_COG && PC != None)
	{
		// check if we have any chance of surviving DBNO
		if (!PC.PlayingDevLevel() && !GearGame(WorldInfo.Game).TeamHasAnyChanceOfSurvival(GetTeamNum(),self))
		{
			`log("no chance of survival, no dbno");
			return FALSE;
		}
		// Use difficulty setting in all remaining cases, non-coop non-ai is handled by above check
		`log(`showvar(GearPRI(PlayerReplicationInfo).Difficulty)@`showvar(GearPRI(PlayerReplicationInfo).Difficulty.default.bCanDBNO));
		return GearPRI(PlayerReplicationInfo).Difficulty.default.bCanDBNO;
	}

	return TRUE;
}

/** Whether or not to play death message now **/
simulated function bool ShouldDisplayDeathMessage()
{
	return TRUE;
}
/**
 *  Stopping Power
 */

function HandleStoppingPower(class<GearDamageType> GearDamageType, vector Momentum, float DmgDistance)
{
	// Don't apply stopping power if player has respawn protection
	if (!GearGame(WorldInfo.Game).IsRespawnInvincible(self))
	{
		// Add StoppingPower to the list.
		AddStoppingPower(GearDamageType.default.StoppingPower, Momentum, DmgDistance);

		// Trigger stumbles when roadie running and being shot too much with stopping power.
		if( (IsDoingSpecialMove(SM_RoadieRun) || IsDoingSpecialMove(SM_RoadieRunStab)) && GetResultingStoppingPower() > StoppingPowerRoadieRunStumbleThreshold && CanDoSpecialMove(SM_RoadieRunHitReactionStumble) )
		{
			ServerDoSpecialMove(SM_RoadieRunHitReactionStumble, TRUE);
		}
	}
}

final simulated function AddStoppingPower(float StoppingPower, vector Momentum, float DmgDistance)
{
	local StoppingPowerStruct	NewStoppingPower;

	NewStoppingPower.StoppingPower = StoppingPower * (1.0 - (DmgDistance / MaxStoppingPowerDistance));
	NewStoppingPower.Direction = Normal(Momentum);
	NewStoppingPower.LifeTime = 1.f;
	StoppingPowerList[StoppingPowerList.Length] = NewStoppingPower;

	if( Role == ROLE_Authority && Controller != None && Controller.IsA('GearPC') && !IsLocallyControlled() )
	{
		// Momentum multiplied to avoid compression artifacts, since it's a normalized vector and replication rounds vectors
		ClientAddStoppingPower(StoppingPower, Momentum * 100.0, DmgDistance);
	}
}

final protected simulated reliable client function ClientAddStoppingPower(float StoppingPower, vector Momentum, float DmgDistance)
{
	if (IsLocallyControlled())
	{
		//@note: division must match multiplication in AddStoppingPower(), above
		AddStoppingPower(StoppingPower, Momentum / 100.0, DmgDistance);
	}
}

final simulated function ClearStoppingPower()
{
	StoppingPowerList.Length = 0;
}

final simulated function UpdateStoppingPower(float DeltaTime)
{
	local INT i;

	for (i = 0; i<StoppingPowerList.Length; i++)
	{
		StoppingPowerList[i].LifeTime -= DeltaTime;
		if( StoppingPowerList[i].LifeTime <= 0.f )
		{
			 StoppingPowerList.Remove(i--, 1);
		}
	}
}

/** Returns the Resulting Stopping Power */
native final function float GetResultingStoppingPower();

/** Give the pawn a chance to override whether it should force a DBNO in a death situation or not */
function bool ShouldForceDBNO( class<GearDamageType> GearDmgType, Pawn InstigatedBy, vector HitLocation )
{
	return FALSE;
}

/** determines whether we would normally want to go DBNO, this is a handy way to turn DBNO on/off without breaking stuff that should never DBNO (e.g. explosions, headshots) */
function bool WantsToDBNO(Pawn InInstigator, vector HitLocation,TraceHitInfo HitInfo)
{
	// default doesn't allow AI to DBNO in SP or COOPMP
	if( !IsHumanControlled() )
	{
		// if this is SP or Horde, and we are not COG, then we only sometimes go DBNO
		if ( (!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) &&
			  GetTeamNum() != TEAM_COG
		   )
		{
			if(!TookLegShot(HitInfo.BoneName) && FRand() > LocustChanceToDBNO)
			{
				return FALSE;
			}
		}
	}

	return TRUE;
}

/** Give the pawn a chance to override whether it should Gib or not */
function bool ShouldGib(class<GearDamageType> GearDmgType, Pawn InstigatedBy)
{
	return TRUE;
}

/**
 * Play the proper GUDEvent according to damage dealt
 *
 * @param Damage - how much damage was dealt
 *
 * @param InstigatedByPawn - the Pawn that created the damage
 *
 * @param GearDamageType - the type of damage inflicted
 */
protected function TriggerDamageGUDEvent(int Damage, Pawn InstigatedByPawn, class<GearDamageType> GearDamageType)
{
	if (InstigatedByPawn != self && IsSameTeam(InstigatedByPawn))
	{
		if (InstigatedByPawn.IsHumanControlled() && ClassIsChildOf(GearDamageType, class'GDT_Ballistic'))
		{
			// note that we only throw this event for local players -- hearing the AI comment
			// on this when shopt by another AI is odd.
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_DamageTeammate, InstigatedByPawn, self);
		}
	}
	else if (Damage > HeavyDamageGUDThreshold && DefaultHealth > HeavyDamageGUDThreshold && GearDamageType.default.bPlayDamagedEnemyHeavyGUD)
	{
		if (GetTeamNum() == TEAM_LAMBENT)
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_DamagedEnemyHeavyLambent, InstigatedByPawn, self);
		}
		else
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_DamagedEnemyHeavy, InstigatedByPawn, self);
		}
	}
}


/** Will reset the PlayBDWarningSoundSemaphore so we can play a sound again **/
function ResetPlayBDWarningSoundSemaphore()
{
	PlayBurstDamageWarningSoundSemaphore = FALSE;
}

function Suicide()
{
	local GearPRI PRI;

	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		PRI.ScoreDeath(None, class'GDT_Environment', GDT_NORMAL, 0);
	}
	Super.Suicide();
}

/**
 * Overridden to handle GearPawn specifics.
 * @NOTE - we don't currently support the gameinfo preventing death (through a mutator etc),
 * so if that behavior is needed this code will have to be refactored.
 */
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local class<GearDamageType> GearDamageType;
	local int KillerPlayerSlotIndex;
	local int i;

	// Just ignore clients that try to enter Died()
	if (bTearOff)
	{
		return TRUE;
	}

	if (Role != ROLE_Authority)
	{
`if(`notdefined(FINAL_RELEASE))
		`LogExt("This function shouldn't be called on clients!");
		ScriptTrace();
`endif
		return TRUE;
	}

	`LogSM("");

	// Update Cover Stats if the Pawn is in cover when they died
	if (CoverType != CT_None)
	{
		//@STATS - Record player left cover on death
		`RecordPlayerIntStat(LEFT_COVER,Controller,0);
	}

	GearDamageType = class<GearDamageType>(damageType);
	// ensure a default
	if (GearDamageType == None)
	{
`if(`notdefined(FINAL_RELEASE))
		`LogExt("Invalid gear damage type!"@damageType);
		ScriptTrace();
`endif
		GearDamageType = class'GearDamageType';
	}

	// drop our inventory
	DropExtraWeapons( DamageType );
	if (IsCarryingShield())
	{
		DropShield();
	}
	bHealthIsRecharging = FALSE; // stop health recharging upon death
	bBlocksNavigation	= FALSE; // stop blocking pathing on death

	// broadcast the death event and set the PRI death variables
	if (GearDamageType != class'GDT_Hostage' && GearDamageType != class'GDT_NeckBreak')
	{
		SetDeathReplicationData( (Killer == None) ? None : GearPRI(Killer.PlayerReplicationInfo), GearPRI(PlayerReplicationInfo), GearDamageType );
	}

	if (bPlayOneLinerOnDeath && GearGameSP_Base(WorldInfo.Game) != None)
	{
		KillerPlayerSlotIndex = GearGameSP_Base(WorldInfo.Game).PlayerSlots.Find('Owner', Killer);
		if (KillerPlayerSlotIndex != INDEX_NONE)
		{
			GearPawn(Killer.Pawn).SpeakLine(None, OnDeathOneLiners[KillerPlayerSlotIndex], "", OnDeathOneLinerDelay, Speech_Scripted, SIC_Always);
		}
	}
	// trigger the GUD event
	else if (!bNoDeathGUDSEvent)
	{
		if (bLastHitWasHeadShot)
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_KilledEnemyHeadShot, (Killer==None)?None:Killer.Pawn, self);

			// The head is gone, make sure they're aren't screaming with vocal chords that don't exist
			bDisableDeathScreams = TRUE;
		}
		else
		{
			if (GearDamageType.default.KillGUDEvent == GUDEvent_KilledEnemyGeneric && GetTeamNum() == TEAM_LAMBENT)
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_KilledEnemyGenericLambent, (Killer==None)?None:Killer.Pawn, self);
			}
			else if (GearDamageType.default.KillGUDEvent != GUDEvent_None)
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(GearDamageType.default.KillGUDEvent, (Killer==None)?None:Killer.Pawn, self);
			}
		}
	}

	// Remove attachment to our anchor
	// Allows bookkeeping - ie updates combat zone occupancy
	SetAnchor( None );

	if (Role == ROLE_Authority)
	{
		GearDamageType.static.HandleKilledPawn(self, (Killer==None)?None:Killer.Pawn);
	}

	// These are replicated to other clients
	HitDamageType		= damageType;
	TakeHitLocation		= HitLocation;

	if(GearPawn_LocustBloodmount(Base) != none)
	{
		BloodMountIDiedOn=GearPawn_LocustBloodmount(Base);
	}

	if ( (OnFireState != POF_None) && !IsTimerActive(nameof(ExtinguishPawn)) )
	{
		// set timer for fire to go out
		IgnitePawn(OnFireState,, OnFireDamageType, 8.f);
	}

	if (SpecialMoves.length > SM_RoadieRunStab && SpecialMoves[SM_RoadieRunStab] != None)
	{
		GSM_RoadieRunStab(SpecialMoves[SM_RoadieRunStab]).StopLoopingSounds();
	}

	// Enable spotting for the player that had us spotted
	if (Role == ROLE_Authority)
	{
		for (i = 0; i < 4; i++)
		{
			if (SpottedByTeam[i] > 0)
			{
				SpottedByTeam[i] = 0;

				if (GearPC(SpottedBy[i].Owner) != None)
				{
					GearPC(SpottedBy[i].Owner).AllowSpotting();
				}
			}
		}
	}

	// normal death
	return Super.Died(Killer, damageType, HitLocation);
}

/** Sets the replication values dying and for who killed who */
final function SetDeathReplicationData(GearPRI KillerPRI, GearPRI VictimPRI, class<GearDamageType> DamageDiedFrom)
{
	if (VictimPRI != None && (!VictimPRI.bIsDead || VictimPRI.LastToKillMePRI == None))
	{
		// Mark the last player to kill me, and mark the last player the instigator killed in his PRI
		VictimPRI.LastToKillMePRI = KillerPRI;
		VictimPRI.DamageTypeToKillMe = DamageDiedFrom;
		if ( KillerPRI != None )
		{
			KillerPRI.LastIKilledPRI = VictimPRI;
		}

		// Let my PRI know I'm dead
		VictimPRI.bIsDead = true;
		VictimPRI.ReplicatedEvent('bIsDead');
	}
}

/** Hook for Kismet instigated player death. */
final event ScriptedDeath()
{
	LastTakeHitInfo.Momentum = vect(0,0,-1);
	Died(Controller,class'GDT_ScriptedGib',Location+vect(0,0,32));
}

/** Specific Pawns can decide which weapons they want to drop **/
function DropExtraWeapons( class<DamageType> DamageType );

/** The Drop Extra Worker which will spawn the specific weapon and then drop it! **/
function DropExtraWeapons_Worker( class<DamageType> DamageType, class<GearWeapon> ClassToSpawn )
{
	local vector TossVel;
	local Vector X,Y,Z;
	local GearWeapon WeaponToDrop;

	TossVel = Vector(GetViewRotation());
	TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);

	WeaponToDrop = Spawn( ClassToSpawn );

	GetAxes(Rotation,X,Y,Z);
	WeaponToDrop.DropFrom(Location + 0.8 * CylinderComponent.CollisionRadius * X - 0.5 * CylinderComponent.CollisionRadius * Y, TossVel);
}

/** Stops any current recharge and resets the timer */
final function ResetHealthRecharge()
{
	bHealthIsRecharging = FALSE;
	SetTimer( HealthRechargeDelay,FALSE,nameof(EnableHealthRecharge) );
}

/** Allows health recharging to kick in */
final function EnableHealthRecharge()
{
	if ( !IsInState('Dying') && Health > 0 )
	{
		bHealthIsRecharging = TRUE;
		RechargingHealthAmount = Health;
	}
}

/** Returns a GearPC if available, handles any special cases (like vehicles) */
simulated function GearPC GetPC()
{
	local GearPC PC;
	PC = GearPC(Controller);
	if (PC == None && DrivenVehicle != None)
	{
		PC = GearPC(DrivenVehicle.Controller);
	}
	return PC;
}

/**
 * Called by a timer from the ReplicatedPlayTakeHitEffects() function that checked to see if a meatshield
 *	saved you from death. Since we can't be sure if the player was saved due to health replication we must
 *	do this health check on a timer.
 *	This code is for determining the eGA_PoundOfFlesh achievement but could be useful for other reasons.
 */
simulated function SavedByAMeatshieldCallback()
{
}

/**
 * return FALSE if this pawn should not perform full body hit reactions
 */
final function bool CanPerformFullBodyHitReaction(class<GearDamageType> GDT)
{
	return ( MyGearAI != None && GearAI_TDM(Controller) == None &&
		MyGearAI.MinFullBodyHitReactionInterval > 0.0 &&
		WorldInfo.TimeSeconds - LastFullBodyHitReactionTime > MyGearAI.MinFullBodyHitReactionInterval &&
		GDT != None && FRand() <= GDT.default.FullBodyHitReactionAnimChance);
}

/** Pick Hit Reaction Animation for other pawn to overwrite if you want **/
function INT PickHitReactionAnim(GearPawn Victim, class<GearDamageType> DamageType, TraceHitInfo HitInfo, vector Momentum, vector HitLocation)
{
	return class<GSM_FullBodyHitReaction>(SpecialMoveClasses[SM_FullBodyHitReaction]).static.PickHitReactionAnim(Victim, DamageType, HitInfo, Momentum, HitLocation);
}

/**
 * Creates any damage effects, sounds, anims, etc.
 * Called from TakeDamage(), so only called on ROLE_Authority.
 */
function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	local GearPawn				InstigatedByGP;
	local bool					bSuppressFX;
	local class<GearDamageType>	GearDamageType;
	local INT					AnimIndex;

	// this is replicated to clients, so they know what they were hit by (only used by DBNO currently?)
	HitDamageType = DamageType;

	// kick off the replicated hit info if it was a valid shot
	if( Damage > 0 )
	{
		InstigatedByGP = GearPawn(InstigatedBy);
		GearDamageType = class<GearDamageType>(DamageType);

		// See if we should play a full body hit reaction animation.
		if( !bPlayedDeath && CanDoSpecialMove(SM_FullBodyHitReaction) )
		{
			if( CanPerformFullBodyHitReaction(GearDamageType) )
			{
				AnimIndex = PickHitReactionAnim(Self, GearDamageType, HitInfo, Momentum, HitLocation);
				if( AnimIndex != INDEX_NONE )
				{
					ServerDoSpecialMove(SM_FullBodyHitReaction, FALSE, None, AnimIndex);
					// save last hit reaction time - I didn't see where else saved
					LastFullBodyHitReactionTime = WorldInfo.TimeSeconds;
				}
			}
		}

		// and the FX aren't being suppressed on the weapon or it is (dummy fire)    AND the damage type is not suppressing FS
		bSuppressFX = (InstigatedByGP != None && InstigatedByGP.MyGearWeapon != None && InstigatedByGP.MyGearWeapon.bSuppressImpactFX);
		//Suppress for torque bow, since we don't want the pain sound to overshadow the 'oh shit' gud
		if (GearDamageType != None && GearDamageType.default.WeaponID == WC_TorqueBow)
		{
			bSuppressFX = true;
		}
		if (!bSuppressFX)
		{
			// @see GearPawn_LocustBerserker TakeDamage for a place that short circuits the if (Damage > 0) as it needs to show impact effects
			// from bullets but not actually take damage, etc, etc
			PlayTakeHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
		}
	}
}


/**
 * Play a hit impact effect + impulse.
 * Sets up LastTakeHitInfo for replication.
 */
final function PlayTakeHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, TraceHitInfo HitInfo)
{
	local INT	HitBoneIndex;
	// Set up LastTakeHitInfo to replicate damage for instant hit weapons
	if ( LastTakeHitInfo.HitLocation != HitLocation )
	{
		LastTakeHitInfo.HitLocation	= HitLocation;
	}
	else
	{
		LastTakeHitInfo.HitLocation.Z += 1.0f;
	}

	HitBoneIndex = Mesh.MatchRefBone(HitInfo.BoneName);

	LastTakeHitInfo.Momentum = Momentum;
	LastTakeHitInfo.HitBoneIndex = (HitBoneIndex != INDEX_NONE) ? byte(HitBoneIndex) : 255;	// converting INT to BYTE, with -1 being non valid!
	LastTakeHitInfo.DamageType = DamageType;
	LastTakeHitInfo.PhysicalMaterial = HitInfo.PhysMaterial;
	LastTakeHitInfo.InstigatedBy = InstigatedBy;
	LastTakeHitInfo.Damage = Damage;
	LastTakeHitInfo.RadialDamageOrigin = bTakingRadiusDamage ? RadialDamageOrigin : vect(0,0,0);
	LastTakeHitTimeout = WorldInfo.TimeSeconds+ 0.5f;

	if (LastTakeHitInfo.PhysicalMaterial == None && HitInfo.Material != None)
	{
		LastTakeHitInfo.PhysicalMaterial = HitInfo.Material.PhysMaterial;
	}

	// play clientside effects
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		ReplicatedPlayTakeHitEffects();
	}
}

/** plays clientside hit effects using the data in LastTakeHitInfo */
simulated function ReplicatedPlayTakeHitEffects()
{
	local ImpactInfo Impact;
	local GearWeapon GW;
	local Turret TurretInstigator;
	local class<GearWeapon> WeaponClass;
	local bool bPlayMeleeImpactEffects, bWillShowFatalDeathBlood, bShowGore, bPlayExplosiveRadialDamageEffects;
	local class<GearDamageType> GearDmgType;
	local vector Impulse;
	local float HitMaskRadius, DamageAdjust;

	// call the damage type specific FX handler
	GearDmgType = class<GearDamageType>(LastTakeHitInfo.DamageType);
	if (GearDmgType != None)
	{
		GearDmgType.static.HandleDamageFX(self, LastTakeHitInfo);
	}

	if (GearDmgType == None || !GearDmgType.default.bEnvironmentalDamage)
	{
		if (LastTakeHitInfo.InstigatedBy != None)
		{
			TurretInstigator = Turret(LastTakeHitInfo.InstigatedBy);
			if (TurretInstigator != None)
			{
				GW = GearWeapon(TurretInstigator.MyWeapon);
			}
			else
			{
				GW = GearWeapon(LastTakeHitInfo.InstigatedBy.Weapon);
			}

			if (GW != None)
			{
				WeaponClass = GW.Class;
			}
		}
		if (WeaponClass == None && class<GDT_Ballistic>(GearDmgType) != None)
		{
			// just use base for weapon damage when we don't have an actual GearWeapon available
			WeaponClass = class'GearWeapon';
		}
	}

	// Should we show gore effects?
	bShowGore = WorldInfo.GRI != None && WorldInfo.GRI.ShouldShowGore();

	// mark the last take damage time for client simulation
	LastTookDamageTime = WorldInfo.TimeSeconds;

	// fill impactinfo
	Impact.HitActor				= Self;
	Impact.HitLocation			= LastTakeHitInfo.HitLocation;
	Impact.HitNormal			= IsZero(LastTakeHitInfo.Momentum) ? Normal(Impact.HitLocation - Location) : -1.f * Normal(LastTakeHitInfo.Momentum);
	Impact.RayDir				= -1.0 * Impact.HitNormal;
	Impact.HitInfo.PhysMaterial = LastTakeHitInfo.PhysicalMaterial;
	Impact.HitInfo.BoneName		= (LastTakeHitInfo.HitBoneIndex != 255) ? Mesh.GetBoneName(LastTakeHitInfo.HitBoneIndex) : 'None';
	Impact.HitInfo.HitComponent = Mesh;

	// add hit mask except flame thrower, if no weapon found
	if (WeaponClass != None && !ClassIsChildOf(WeaponClass, class'GearWeap_FlameThrowerBase'))
	{
		//`log(LastTakeHitInfo.Damage);

		// the approx range is 200-1000, mapping 5-15. The min radius is 5, and max radius is 15
		DamageAdjust = (LastTakeHitInfo.Damage-200.f)/80.f;
		HitMaskRadius = 5 + Clamp(DamageAdjust, 0, 10);

 		// damage hit mask
  		if (LastTakeHitInfo.InstigatedBy != None)
  		{
  			AddHitMask(Impact.HitLocation, LastTakeHitInfo.InstigatedBy.Location, HitMaskRadius);
  		}
  		else
  		{
  			// if instigatedby not found, just use normal to approximately simulate
  			AddHitMask(Impact.HitLocation, Impact.HitLocation + Impact.HitNormal * 100.0, HitMaskRadius);
  		}
	}

	// check for non-directional impact fx (@fixme - rename this and make it a property of GearDamageType?)
	if (ClassIsChildOf(LastTakeHitInfo.DamageType, class'GDT_Melee'))
	{
		bPlayMeleeImpactEffects = true;
	}
	else if (ClassIsChildOf(LastTakeHitInfo.DamageType, class'GDT_Explosive'))
	{
		// unless we are playing death and then we do not need to spawn the radial damage effect
		if (!bPlayedDeath)
		{
			bPlayExplosiveRadialDamageEffects = TRUE;
			Impact.HitInfo.BoneName = PelvisBoneName;
		}
	}

	if (WeaponClass != None)
	{
		// Are we going to show fatal death blood?
		bWillShowFatalDeathBlood = (Health <= 0) && bShowFatalDeathBlood;
		// Spawn the impact FX
		WeaponClass.static.SpawnImpactFX(LastTakeHitInfo.InstigatedBy, GW, GearDmgType, Impact, bWillShowFatalDeathBlood, bPlayMeleeImpactEffects, bPlayExplosiveRadialDamageEffects, (GW != None) ? GW.bSuppressImpactFX : false);
		// and disable fatal blood
		if (bWillShowFatalDeathBlood)
		{
			bShowFatalDeathBlood = false;
		}
	}
	// if we have no weapon just assume a default blood effect so we show something
	else if ((Health > 0 || !bShowFatalDeathBlood) && DefaultBloodEffectTemplate != None && bShowGore && !GearDmgType.default.bSuppressImpactFX)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(DefaultBloodEffectTemplate, Impact.HitLocation, rotator(Impact.HitLocation - Location), self);
	}

	// if we are really hurt, but not dead, spawn some small blood drops
	if (Health < (0.40f * DefaultHealth) && Health > 0 && !GearDmgType.default.bSuppressBloodDecals && bSpawnBloodTrailDecals)
	{
		SpawnABloodTrail_PawnIsReallyHurt();
	}

	// Meat Shield Special Case.
	if( IsAHostage() )
	{
		// Make sure Pawn can be special melee attacked. For instance MeatFlag cannot be headshotted, gibbed or killed.
		if( CanBeSpecialMeleeAttacked(GearPawn(LastTakeHitInfo.InstigatedBy)) )
		{
			if ( bShowGore && bCanPlayHeadShotDeath && !bHasPlayedHeadShotDeath &&
				(bForceHeadShotGib || GearDmgType.static.ShouldHeadShotGib(self, LastTakeHitInfo.InstigatedBy)) &&
				HostageHealth < HostageDeathThresholdByHeadshot )
			{
				PlayHeadShotDeath();

				// On server, force Hostage release upon headshot.
				if (InteractionPawn.IsAKidnapper() && WorldInfo.NetMode != NM_Client)
				{
					InteractionPawn.ServerEndSpecialMove(InteractionPawn.SpecialMove);
				}
			}
		}
	}
	// Otherwise gib when dead
	// Check if this is a gibbing damage type ad we're allowed to show gory stuffs!
	// Gore is not compatible with HeadShot deaths
	// Wait at least a second after time of death to gib. This is to keep head shot death from gibbing right away.
	// Do not gore while doing death animation as this won't work well, because skeleton is setup to use motors.
	else if( bPlayedDeath )
	{
		// Handle gibbing
		if( bShowGore && GearDmgType.static.ShouldGib(self,LastTakeHitInfo.InstigatedBy) && ShouldGib(GearDmgType,LastTakeHitInfo.InstigatedBy) &&
			(WorldInfo.TimeSeconds - TimeOfDeath > 1.f) && !IsDoingDeathAnimSpecialMove() )
		{
			// See if we need to switch to a gore skeleton, if we haven't already
			if( !bIsGore )
			{
				SwitchToGore();
			}

			// If we're in Gore Skeleton and we have some breakable joints to gib, then do so!
			if( bIsGore && GoreSettings != None && GoreSettings.GoreBreakableJoints.Length > 0 )
			{
				GoreExplosion(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation, GearDmgType);
			}
		}

		// Add an impulse if in rag doll
		if (Physics == PHYS_RigidBody)
		{
			Impulse = GetImpactPhysicsImpulse(GearDmgType, LastTakeHitInfo.HitLocation, LastTakeHitInfo.Momentum, Impact.HitInfo);
			if (!IsZero(Impulse))
			{
			Mesh.AddImpulse(Impulse, LastTakeHitInfo.HitLocation, Impact.HitInfo.BoneName);
		}
	}
	}
	// Otherwise play standard 'alive' hit reactions
	else
	{
		// Try to play a hit reaction animation. Otherwise fallback to physics hit reactions.
		if( (GearDmgType == None || !GearDmgType.default.bSuppressImpactFX) && !TryPlayHitReactionAnimation(Impact) )
		{
			// Play Physics Body Impact.
			PlayPhysicsBodyImpact(Impact.HitLocation, LastTakeHitInfo.Momentum, LastTakeHitInfo.DamageType, Impact.HitInfo);
		}
	}

	// Handle being in the lambent berserker damage actors
	if (GearDmgType == class'GDT_Berserker_GasTrail' ||
		GearDmgType == class'GDT_Berserker_ImulsionTrail')
	{
		TimeLastInLambBerserkDamageActor = WorldInfo.TimeSeconds;
	}
}

/** Updates the effects a player who is within the damage actor of a lambent berserker */
simulated function UpdateLambentDamageEffects()
{
	local GearPC GPC;

	GPC = GearPC(Controller);
	if (GPC != None &&
		GPC.PlayerCamera != None &&
		TimeLastInLambBerserkDamageActor > 0.0f &&
		TimeLastInLambBerserkDamageActor + 1.0f > WorldInfo.TimeSeconds )
	{
		BerserkerDamageActorCameraAnim = GPC.PlayerCamera.PlayCameraAnim(DamageActorCameraAnim,,,,,true,,1.0f,true);
	}
	else if (BerserkerDamageActorCameraAnim != None)
	{
		BerserkerDamageActorCameraAnim.Stop(false);
		BerserkerDamageActorCameraAnim = None;
		TimeLastInLambBerserkDamageActor = 0.0f;
	}
}

/** Play Hit Reaction animation */
simulated function bool TryPlayHitReactionAnimation(ImpactInfo Impact)
{
`if(`notdefined(FINAL_RELEASE))
	// debugging headshots, don't move
	if (bWeaponDebug_HeadShotLocation)
	{
		return FALSE;
	}
`endif

	/*	`DLog("BoneName:" @ Impact.HitInfo.BoneName);*/
	// Need a bone name to do something...
	if( Impact.HitInfo.BoneName == '' || `TimeSince(NextHitReactionAnimTime) < 0 )
	{
		return FALSE;
	}

	// Disable when doing special moves
	if( IsDoingASpecialMove() || bSwitchingWeapons || bIsConversing || bPlayedDeath )
	{
		return FALSE;
	}

	// Disable for locally controlled pawns targeting
	if( IsHumanControlled() && bIsTargeting )
	{
		return FALSE;
	}

	// Disable when Pawn is firing his weapon.
	if( !IsReloadingWeapon() && (ShotCount > 0) )
	{
		return FALSE;
	}

	return PlayHitReactionAnimation(Impact);
}

/** By default, do not play hit reaction animations */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	return FALSE;
}

/**
 * Plays a Physical Body Impact hit reaction.
 */
final simulated function PlayPhysicsBodyImpact(vector HitLocation, vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo)
{
	local Vector	BodyImpactImpulse;
	local bool		bAlreadyHit;
	local float		ImpactScale, CurrentHitPct;

`if(`notdefined(FINAL_RELEASE))
	// debugging headshots, don't move
	if (bWeaponDebug_HeadShotLocation)
	{
		return;
	}
`endif

	// If you are a human and you are targeting, need a mesh, don't do that in Phys_RigidBody (ragdoll)
	if( !bCanPlayPhysicsHitReactions || Mesh == None || Mesh.bNotUpdatingKinematicDueToDistance || Physics == Phys_RigidBody ||
		bPlayedDeath || IsInState('Dying') || bInMeatShieldRagDoll || (MyGearWeapon != None && MyGearWeapon.WeaponType == WT_Heavy) )
	{
		return;
	}

	// If on a moving base, disable physics hit reactions, as they tend to look bad.
	if( Base != None && Base.Physics == PHYS_Interpolating )
	{
		return;
	}

	// Those root motion modes don't work well with physics hit reactions. Not sure why.
	if( Mesh != None && (Mesh.RootMotionMode == RMM_Relative || Mesh.RootMotionMode == RMM_Translate) )
	{
		return;
	}

	// Prevent physical hit reactions for gameplay reasons
	if( (IsHumanControlled() && bIsTargeting) 
		// Disable when Pawn is firing his weapon.
		|| (!IsReloadingWeapon() && (ShotCount > 0))
		|| IsEvading() || IsDoingSpecialMeleeAttack() || IsChainsawDueling() || IsAKidnapper() )
	{
		return;
	}

	// If this is > 0, we're already being hit
	CurrentHitPct	= PhysicsImpactBlendTimeToGo / PhysicsImpactBlendOutTime;
	bAlreadyHit		= CurrentHitPct > 0.f;

	//  Physics Impulse Given
	BodyImpactImpulse = GetImpactPhysicsImpulse(DamageType, HitLocation, Momentum, HitInfo, TRUE);

	// If hit a bone, then play Physics Body Impact.
	if( HitInfo.BoneName != '' && !IsZero(BodyImpactImpulse) )
	{
		// So if Pawn has been recently hit, randomize impulse to show some impact variations.
		ImpactScale	= bAlreadyHit ? 0.75f * (0.25f + FRand()) : 1.f;

		BodyImpactImpulse = PhysicsHitReactionImpulseScale * ImpactScale * BodyImpactImpulse;

		// When hitting someone not locally controlled by a human player, then increase hit reactions for feedback.
		if( !IsHumanControlled() || !IsLocallyControlled() )
		{
			BodyImpactImpulse *= 2.5f;
		}

// 		`DLog("BodyImpactImpulse:" @ VSize(BodyImpactImpulse) @ "ImpactScale:" @ ImpactScale @ "PhysicsHitReactionImpulseScale:" @ PhysicsHitReactionImpulseScale);
// 		`log("  PlayPhysicsBodyImpact on Bone:" @ HitInfo.BoneName @ "DamageType:" @ DamageType @ "Momentum:" @ Momentum );

		Mesh.AddImpulse(BodyImpactImpulse, HitLocation, HitInfo.BoneName);
		//Mesh.WakeRigidBody();
		StartPhysicsBodyImpact(HitInfo.BoneName, TRUE, class<GearDamageType>(DamageType));
	}
}


/** Get Physical Impulse to apply based on damage type and physics information */
simulated final function vector GetImpactPhysicsImpulse(class<DamageType> DamageType, vector HitLoc, vector Momentum, out TraceHitInfo OutHitInfo, optional bool bIsHitReaction)
{
	local float		TotalMass, ImpulseScale;
	local Vector	BaseImpulse;
// 	local Name		OriginalBoneName;

	// Skip if no damage type or momentum/impulse
	if( DamageType == None || IsZero(Momentum) || (DamageType.default.KDamageImpulse == 0.f && DamageType.default.KDeathUpKick == 0.f) )
	{
`if(`notdefined(FINAL_RELEASE))
		if( IsZero(Momentum) )
		{
			`log(WorldInfo.TimeSeconds @ "Zero Momentum!!!" @ GetFuncName() @ "returning 0." @ "DamageType:" @ DamageType @ "Momentum:" @ Momentum @ "KDamageImpulse:" @ DamageType.default.KDamageImpulse @ "KDeathUpKick:" @ DamageType.default.KDeathUpKick);
			ScriptTrace();
		}
`endif
		return vect(0,0,0);
	}

	BaseImpulse = Momentum * DamageType.default.KDamageImpulse;

	// If we want upward force, then take it into account. We want this when we're dead, but not when taking hit reactions alive.
	if (!bIsHitReaction && bDoDeathUpKick)
	{
		BaseImpulse += /*VSize(Momentum) * */ Vect(0,0,1) * DamageType.default.KDeathUpKick;
	}

	// Try to get a valid bone name to apply the impulse to.
	if( OutHitInfo.BoneName == '' )
	{
		CheckHitInfo(OutHitInfo, Mesh, Normal(Momentum), HitLoc);
	}

	// If not a physics hit reaction (alive), then don't perform further processing
	if( !bIsHitReaction )
	{
		return BaseImpulse;
	}

	// We do need a bone name to go any further, so if we don't have that, abort.
	if( OutHitInfo.BoneName == '' )
	{
//		`log(GetFuncName() @ "No Bone to figure out damage :(");
		return BaseImpulse;
	}

	// See if we need to remap the RigidBody bone -- Only do this for physics hit reactions.
	if( PhysicsImpactRBRemapTable.Length > 0 )
	{
// 		OriginalBoneName	= OutHitInfo.BoneName;
		OutHitInfo.BoneName = GetPhysicsImpactRemappedBone(OutHitInfo.BoneName);
	}

	ImpulseScale = 1.f;

	// If we're hitting a BodySetup on the skeletal mesh, try to scale by mass
	// We do this to balance the fact that being hit in the chest won't cause much impact, while being hit in the hand will send it flying.
	if( Mesh.PhysicsAssetInstance != None )
	{
		TotalMass		= Mesh.PhysicsAssetInstance.GetTotalMassBelowBone(OutHitInfo.BoneName, Mesh.PhysicsAsset, Mesh.SkeletalMesh);
		ImpulseScale	= 1.f + (TotalMass - 1.f) * PhysicsImpactMassEffectScale;
// 		`DLog("TotalMass:" @ TotalMass @ "ImpulseScale:" @ ImpulseScale @ "for bone" @ OutHitInfo.BoneName @ "(OriginalBoneName:" @ OriginalBoneName $ ")");
	}

// 	`log("KDamageImpulse:" @ DamageType.default.KDamageImpulse @ "KDeathUpKick:" @ DamageType.default.KDeathUpKick @ "Momentum:" @ VSize(Momentum) );

	// apply a death impulse to the ragdoll
	// Note: TearOffMomentum gives the direction of the impulse, but also the scale factor.
	//return ImpulseScale * ((Momentum * DamageType.default.KDamageImpulse) + (VSize(Momentum) * (Vect(0,0,1) * DamageType.default.KDeathUpKick)));
	return ImpulseScale * BaseImpulse;
}


/** See if InBoneName exists in PhysicsImpactRBRemapTable, and return which BoneName it should be remapped to */
simulated final function Name GetPhysicsImpactRemappedBone(Name InBoneName)
{
	local int i;

	for( i=0; i<PhysicsImpactRBRemapTable.Length; i++)
	{
		if( PhysicsImpactRBRemapTable[i].RB_FromName == InBoneName )
		{
			return PhysicsImpactRBRemapTable[i].RB_ToName;
		}
	}

	return InBoneName;
}


/** Start a Physics Body Impact */
final simulated function StartPhysicsBodyImpact(Name HitBoneName, bool bUseMotors, class<GearDamageType> GearDamageType)
{
	local bool	bFoundBone;
	local int	i;

	if( Mesh == None || Mesh.PhysicsAsset == None || Mesh.PhysicsAssetInstance == None )
	{
		`log(WorldInfo.TimeSeconds @ "StartPhysicsBodyImpact. Pawn is missing needed assets for Body Impact " $ self );
		return;
	}

	for(i=0; i<PhysicsBodyImpactBoneList.Length; i++)
	{
		if( PhysicsBodyImpactBoneList[i] == HitBoneName )
		{
			bFoundBone = TRUE;
			break;
		}
	}

	// Hit a Bone that is kinematic and not dynamic. So don't do anything
	if( !bFoundBone )
	{
		//`log(WorldInfo.TimeSeconds @ "StartPhysicsBodyImpact. Hit a Bone that is kinematic and not dynamic. So don't do anything HitBoneName:" @ HitBoneName);
		return;
	}

	// Unfix bones that should be affected by physics, fix others (Kinematic)
	Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(FALSE, PhysicsBodyImpactBoneList, Mesh, FALSE, TRUE);

	StartPhysicsBodyImpactPhysicsModify();

	if( bUseMotors )
	{
		// Turn on motors
		Mesh.bUpdateJointsFromAnimation = TRUE;

		// Set motor strength
		Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(PhysHRMotorStrength.X, PhysHRMotorStrength.Y, 0.f, Mesh, TRUE);
		Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(TRUE, TRUE, Mesh, TRUE);
	}
	else
	{
		// Turn off motors
		Mesh.bUpdateJointsFromAnimation = FALSE;
		Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, Mesh, TRUE);
	}

	// Setup Hit Reaction bone springs -- to prevent some bones from being pushed too far
	if( bEnableHitReactionBoneSprings && PhysicsImpactSpringList.Length > 0 && Base != None && !Base.bMovable && !bHasBrokenConstraints )
	{
		Mesh.PhysicsAssetInstance.SetNamedRBBoneSprings(TRUE, PhysicsImpactSpringList, PhysHRSpringStrength.X, PhysHRSpringStrength.Y, Mesh);
	}

	// Add Base linear velocity, so it doesn't look strange when on a moving platform.
	AddBaseLinearVelocityUponWhenGoingRagDoll();

	// Make it start simulating
	Mesh.WakeRigidBody();

	// Enable full physics on body
	Mesh.PhysicsWeight = 1.f;

	// Set Blend Out recovery time.
	PhysicsImpactBlendTimeToGo = PhysicsImpactBlendOutTime * GearDamageType.default.HitReactionTimeScale;
}


simulated function StartPhysicsBodyImpactPhysicsModify()
{
	// Disable collision with alive pawns
	Mesh.SetRBChannel(RBCC_Nothing);
	Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
}


/** notification that we are done blending back from physics to animations */
final simulated event BodyImpactBlendOutNotify()
{
	Mesh.PhysicsWeight			= 0.f;
	PhysicsImpactBlendTimeToGo	= 0.f;

	// Fix all bones back to animation. Return to being fully Kinematic.
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(TRUE);
	Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, Mesh);

	// Restore collision to defaults.
	BodyImpactBlendOutNotifyPhysicsModify();

	// Turn off motors
	Mesh.bUpdateJointsFromAnimation = FALSE;
	Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, Mesh, TRUE);

	// Turn Off Bone Springs
	if( PhysicsImpactSpringList.Length > 0 )
	{
		Mesh.PhysicsAssetInstance.SetNamedRBBoneSprings(FALSE, PhysicsImpactSpringList, 0.f, 0.f, Mesh);
	}
}

simulated function BodyImpactBlendOutNotifyPhysicsModify()
{
	// Restore collision to defaults.
	Mesh.SetRBChannel(default.Mesh.RBChannel);
	Mesh.SetRBCollidesWithChannel(RBCC_Pawn, default.Mesh.RBCollideWithChannels.Pawn);
}


function PlayHit(float Damage, Controller InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, TraceHitInfo HitInfo)
{
`if(`notdefined(FINAL_RELEASE))
	`log(GetFuncName()@"is deprecated for Gear, please fix!");
	ScriptTrace();
`endif
}

// some constraints need to be broken when another bone's constraint is.. check for such bones and break them accordingly
simulated final function BreakDependantBones(Vector Impulse, Vector HitLocation, Name InBoneName, optional bool bVelChange)
{
	local int i,j;

	for(i=0;i< GoreSettings.JointsWithDependantBreaks.length;i++)
	{
		if(GoreSettings.JointsWithDependantBreaks[i].ParentBone == InBoneName)
		{
			for(j=0;j<GoreSettings.JointsWithDependantBreaks[i].DependantBones.length;j++)
			{
				//`log(GetFuncName()@"Breaking "@JointsWithDependantBreaks[i].DependantBones[j]@"because"@InBoneName@"was broken!");
				BreakConstraint(Impulse,HitLocation,GoreSettings.JointsWithDependantBreaks[i].DependantBones[j],bVelChange);
			}
		}
	}
}

simulated final function BreakConstraint(Vector Impulse, Vector HitLocation, Name InBoneName, optional bool bVelChange)
{
	if( Mesh == None )
	{
	`if(`notdefined(FINAL_RELEASE))
		`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Tried to gib with not gore skeleton!!");
		ScriptTrace();
	`endif
		return;
	}

	if (GoreSettings == None)
	{
`if(`notdefined(FINAL_RELEASE))
		`log("Tried to break off gore chunks ("$InBoneName$") from a GearPawn that doesn't support gore");
`endif
		return;
	}

	Mesh.BreakConstraint(Impulse,HitLocation,InBoneName,bVelChange);

	BreakDependantBones(Impulse,HitLocation,InBoneName);

	// Keep track that broke at least one constraint off this gore mesh.
	if( !bHasBrokenConstraints )
	{
		bHasBrokenConstraints = TRUE;

		// only want to call this if we're actually dead (could be hostage, in which case we don't want to call this yet)
		if(bPlayedDeath)
		{
			// This will turn on optimizations for Gibs.
			SetupDeathGibsOptimizations();
		}
	}
}

/**
 * Breaks and gives an impulse to bones that are within a sphere centered around the hit location
 * Optionally, breaks all bones
 *
 * @param Epicenter the explosion's location
 * @param MomentumScale scale to apply for this explosion
 * @param GearDamageType damage type for sphere size and impulse magnitude
 */
simulated function GoreExplosion_Radial(vector Epicenter, float MomentumScale, class<GearDamageType> GearDamageType)
{
	local int Index;
	local float DistToGib;
	local float GibImpulseMagnitude;
	local Vector ConstraintLoc;
	local vector Impulse;
	local vector ZeroVector;
	local vector Dir;

	if (GoreSettings != None)
	{
		DistToGib = GearDamageType.default.DistFromHitLocToGib;
		GibImpulseMagnitude = GearDamageType.default.GibImpulseMagnitude;

		for (Index = 0; Index < GoreSettings.GoreBreakableJoints.Length; Index++)
		{
			if (GearGRI(WorldInfo.GRI).bShowPartialGore && GoreSettings.GoreBreakableJoints[Index].bDontBreakWithPartialGore)
			{
				continue;
			}
			ConstraintLoc = Mesh.GetBoneLocation(GoreSettings.GoreBreakableJoints[Index].ConstraintName);
			// If breaks all, or within radius of epicenter.
			if (DistToGib <= 0 || VSize(ConstraintLoc - Epicenter) <= DistToGib)
			{
				Dir = Normal(ConstraintLoc - Epicenter);
				Impulse = Dir * MomentumScale * GibImpulseMagnitude * GoreSettings.GoreBreakableJoints[Index].ImpulseScale;
				BreakConstraint(Impulse,
					// Use center of mass
					ZeroVector,
					GoreSettings.GoreBreakableJoints[Index].ConstraintName,
					DistToGib <= 0 ? true : GoreSettings.GoreBreakableJoints[Index].bVelImpulse);
			}
		}

		// now apply an impulse to the non-gibbed parts
		if (GoreSettings.GoreRootJoint.ConstraintName != '')
		{
			ConstraintLoc = Mesh.GetBoneLocation(GoreSettings.GoreRootJoint.ConstraintName);
			Dir = Normal(ConstraintLoc - Epicenter);
			Impulse = Dir * MomentumScale * GibImpulseMagnitude * GoreSettings.GoreRootJoint.ImpulseScale;
			Mesh.AddImpulse(Impulse,
				// Use center of mass
				ZeroVector,
				GoreSettings.GoreRootJoint.ConstraintName,
				DistToGib <= 0 ? true : GoreSettings.GoreRootJoint.bVelImpulse);
		}
	}
}

simulated protected function vector GetPenetrationGoreImpulse(vector GoreLoc, vector HitLoc, vector Momentum, class<GearDamageType> DamageType)
{
	local float InheritedMomentumPct, GibRadius;
	local vector Dir, BaseImpulse;
	local float KDeathUpKick;

	Dir = Normal(Momentum);
	BaseImpulse = Dir * DamageType.default.GibImpulseMagnitude;

	GibRadius = DamageType.default.DistFromHitLocToGib;

	if (GibRadius > 0.f)
	{
		InheritedMomentumPct = 1.f - PointDistToLine(GoreLoc, Dir, HitLoc) / GibRadius;
		InheritedMomentumPct = FMax(0.f, InheritedMomentumPct);
		InheritedMomentumPct = InheritedMomentumPct ** 0.5f;        // 0.5 is the falloff exponent

//		if (InheritedMomentumPct > 0.f)
//			DrawDebugLine(GoreLoc, GoreLoc + Dir*100*InheritedMomentumPct, 255, 255, 0, TRUE);

		BaseImpulse *= InheritedMomentumPct;
	}

	// don't do upkick if already moving upwards or this isn't original gore
	if (!bHasGoreExploded && bDoDeathUpKick && !IsZero(BaseImpulse))
	{
		KDeathUpKick = DamageType.default.KDeathUpKick + DamageType.default.KDeathUpKickGib;

		if (BaseImpulse.Z < KDeathUpKick)
		{
			BaseImpulse.Z += KDeathUpKick;

			BaseImpulse.Z = FMin(KDeathUpKick, BaseImpulse.Z);
		}
	}

	return BaseImpulse;
}

simulated function GoreExplosion_Penetration(vector Momentum, vector HitLocation, class<GearDamageType> GearDamageType )
{
	local int Index;
	local vector ConstraintLoc, Impulse;

	if (GoreSettings != None)
	{
		for (Index = 0; Index < GoreSettings.GoreBreakableJoints.Length; Index++)
		{
			if (GearGRI(WorldInfo.GRI).bShowPartialGore && GoreSettings.GoreBreakableJoints[Index].bDontBreakWithPartialGore)
			{
				continue;
			}
			ConstraintLoc = Mesh.GetBoneLocation(GoreSettings.GoreBreakableJoints[Index].ConstraintName);

			// If breaks all, or within cylinder of damage.
			Impulse = GetPenetrationGoreImpulse(ConstraintLoc, HitLocation, Momentum, GearDamageType);
			Impulse *= GoreSettings.GoreBreakableJoints[Index].ImpulseScale;

			if (!IsZero(Impulse))
			{
				BreakConstraint(Impulse, HitLocation, GoreSettings.GoreBreakableJoints[Index].ConstraintName, GoreSettings.GoreBreakableJoints[Index].bVelImpulse);
			}
		}

		// now apply an impulse to the non-gibbed parts
		if (GoreSettings.GoreRootJoint.ConstraintName != '')
		{
			ConstraintLoc = Mesh.GetBoneLocation(GoreSettings.GoreRootJoint.ConstraintName);
			Impulse = GetPenetrationGoreImpulse(HitLocation, HitLocation, Momentum, GearDamageType);
			Impulse *= GoreSettings.GoreRootJoint.ImpulseScale;

			Mesh.AddImpulse(Impulse, ConstraintLoc, GoreSettings.GoreRootJoint.ConstraintName, GoreSettings.GoreRootJoint.bVelImpulse);
		}
	}
}

/**
 * Breaks and gives an impulse to bones that are within a sphere centered around the hit location
 * (think of it as an ice cream cone: sphere for constraint breaking and shooter->bone in terms of impulse)
 *
 * @param OriginatingLocation the instigator's location
 * @param HitLocation where on the pawn was hit
 * @param GearDamageType damage type for sphere size and impulse magnitude
 */
simulated function GoreExplosion_Cone(vector OriginatingLocation,vector HitLocation,class<GearDamageType> GearDamageType)
{
	local int Index;
	local vector ZeroVector;
	local vector ConstraintLoc;
	local vector Impulse;
	local vector HitDir;
	local vector OrigLocToPawnDir;
	local float BreakConstraintRadius;
	local float GibImpulseMagnitude;
	local float HitDotDir;

	if (GoreSettings != None)
	{
		BreakConstraintRadius = GearDamageType.default.DistFromHitLocToGib;
		GibImpulseMagnitude = GearDamageType.default.GibImpulseMagnitude;
		HitDir = Normal(HitLocation - OriginatingLocation);

		// Break any bone within the radius (ice cream portion) of the hit location
		for (Index = 0; Index < GoreSettings.GoreBreakableJoints.Length; Index++)
		{
			if (GearGRI(WorldInfo.GRI).bShowPartialGore && GoreSettings.GoreBreakableJoints[Index].bDontBreakWithPartialGore)
			{
				continue;
			}
			ConstraintLoc = Mesh.GetBoneLocation(GoreSettings.GoreBreakableJoints[Index].ConstraintName);
			if (VSize(ConstraintLoc - HitLocation) <= BreakConstraintRadius)
			{
				Impulse = HitDir * GibImpulseMagnitude * GoreSettings.GoreBreakableJoints[Index].ImpulseScale;
				BreakConstraint(Impulse,ZeroVector,GoreSettings.GoreBreakableJoints[Index].ConstraintName,GoreSettings.GoreBreakableJoints[Index].bVelImpulse);
			}
		}

		// Vector from the gun to the center of the pawn
		OrigLocToPawnDir = Normal(Location - OriginatingLocation);
		// Figure out whether the pawn's location is to the left or right of the hit location
		HitDotDir = OrigLocToPawnDir Dot (HitDir Cross vect(0,0,1));
		// Give the mesh some angular momentum based upon the direction of the hit
		ZeroVector.Z = HitDotDir < 0 ? GearDamageType.default.GibAngularVelocityMagnitude : -GearDamageType.default.GibAngularVelocityMagnitude;
		Mesh.SetRBAngularVelocity(ZeroVector,true);
	}
}

simulated function GoreExplosion_Disc(vector Epicenter, float MomentumScale, class<GearDamageType> GearDamageType)
{
	`Log("JG --- Implement me");
}


/** GetPartialBreakInfo : This is used by heavy sniper damage breaks
 *  This only breaks partially depending on where it hits.
 *  Since it's very specific I didn't make it to gore settings
 *  This returns list of break list
 */
simulated function int GetPartialBreakInfo( out array<PartialBreakInfo> BreakList )
{
	return 0;
}

// Spawn chunks - right now it spawns head chunks. Very fake
simulated final function SpawnChunks(vector ChunkLoc, rotator ChunkRot)
{
	local int				ChunkNb;

	// Spawn several physics Head Chunks
	if( HeadChunks.Length > 0 )
	{
		// Spawn several physics Head Chunks
		for(ChunkNb=0; ChunkNb<5; ChunkNb++)
		{
			// don't spawn the 0 (head) twice
			SpawnAHeadChunk( ChunkLoc, ChunkRot, HeadChunks[ Max( 1, Rand(HeadChunks.Length)) ] );
		}
	}
}
/** BreakPart : This is used by heavy sniper damage breaks
 *  This only breaks partially depending on where it hits.
 *  Since it's very specific I didn't make it to gore settings
 */
simulated function BreakPart()
{
	local name HitBoneName;
	local array<PartialBreakInfo> Breaks;
	local int Index;
	local vector Impulse, ConstraintLoc;

	// don't do any thing if we are outside of 8000 units as we are way way far away and this is just semi wasted work
	if( !EffectIsRelevant(Location, false, 8000, 2000) )
	{
		return;
	}

	// Get list of break info : if your pawn has different list, just overwrite the function
	if ( WorldInfo.GRI.ShouldShowGore() && GetPartialBreakInfo(Breaks) > 0 )
	{
		HitBoneName = Mesh.GetBoneName(LastTakeHitInfo.HitBoneIndex);

		for ( Index = 0; Index < Breaks.Length; ++Index )
		{
			// if child of current bone or current bone
			if ( HitBoneName == Breaks[Index].BoneNameToChild || Mesh.BoneIsChildOf(HitBoneName, Breaks[Index].BoneNameToChild) )
			{
				// spawn first heavy sniper blood splash
				// Or I need to disable bSpawnBloodTrailDecals = FALSE
				// to avoid active decal issue - whatever spawns first and if it's too close, it won't spawn
				SpawnABloodTrail_HeavySniper(ConstraintLoc);

				ConstraintLoc = Mesh.GetBoneLocation(Breaks[Index].BoneNameToBreak);
				// calculate impulse
				Impulse = LastTakeHitInfo.HitLocation-ConstraintLoc;
				//FlushPersistentDebugLines();
				//DrawDebugLine(LastTakeHitInfo.HitLocation, LastTakeHitInfo.HitLocation+Impulse*100, 255, 0, 0, TRUE);

				// enable gore
				EnableGoreMesh();
				// Mark that we're doing a proper gore explosion, which disables any regibbing
				bHasGoreExploded = TRUE;
				// break bone
				BreakConstraint(Impulse, LastTakeHitInfo.HitLocation, Breaks[Index].BoneNameToBreak, TRUE);
				// hide it if set
				if ( Breaks[Index].bHideBone )
				{
					Mesh.HideBoneByName(Breaks[Index].BoneNameToBreak, PBO_Term);
				}

				// spawn chunks on the location
				SpawnChunks(ConstraintLoc, rotator(Impulse));
				// spawn particle on break point
				WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Heavy_Sniper.Effects.P_Heavy_Sniper_Direction_Blood', ConstraintLoc, rotator(Impulse));
				// spawn another particle on hit point
				WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Heavy_Sniper.Effects.COG_Heavy_Sniper_Blood', LastTakeHitInfo.HitLocation, rotator(-LastTakeHitInfo.Momentum));

				return;
			}
		}
	}

	//spawn blood trail first because otherwise it won't show up because of other decals
	SpawnABloodTrail_HeavySniper(LastTakeHitInfo.HitLocation);
	// if nothign happens so far, just gore explode
	// using SwitchToGore didn't work because this was in DeathAnim SM
	// since this is very special case, I'm allowing to go gore while playing animation
	// and it will explode
	// spawn particle on break point - I think this case center would be okay
	WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Heavy_Sniper.Effects.P_Heavy_Sniper_Direction_Blood',Location, Rotation);
	// spawn another particle on hit point
	WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Heavy_Sniper.Effects.COG_Heavy_Sniper_Blood', LastTakeHitInfo.HitLocation, rotator(-LastTakeHitInfo.Momentum));

	if ( WorldInfo.GRI.ShouldShowGore() )
	{
		SwitchToGoreLOD();
		// if nothing happens, just go to GoreExplosion

		// Mark that we're doing a proper gore explosion, which disables any regibbing
		bHasGoreExploded = TRUE;

		GoreExplosion_Penetration(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation, class<GearDamageType>(LastTakeHitInfo.DamageType));
	}
}

/** This will leave some blood when one of our limbs breaks **/
simulated function SpawnABloodTrail_HeavySniper( vector InStartLocation )
{
	if ( EffectIsRelevant(Location, false, 1000) )
	{
		GearPawnFX.SpawnABloodTrail_HeavySniper( InStartLocation );
	}
}
/**
 * This will cause the mob to blow up into little pieces.
 *
 * NOTE: this is called from ReplicatedPlayTakeHitEffects on bodies that have been gored.  This plays the big bloody particle effect and additionally
 * will break off bones based on the hit location.
 *
 */
simulated function GoreExplosion( Vector Momentum, Vector HitLocation, class<GearDamageType> GearDamageType )
{
	local PlayerController PC;

	// don't do any thing if we are outside of 8000 units as we are way way far away and this is just semi wasted work
	if( !EffectIsRelevant(Location, false, 8000, 2000) )
	{
		return;
	}

	// Catch Pawns who have not be set up properly, and throw a warning.
	if( GoreSettings.GoreBreakableJoints.length == 0 )
	{
		return;
	}

	if( !bIsGore )
	{
		return;
	}

	// if you are not playing in extreme content mode you will not get this sound :-(
	PlaySound(GearDamageType.default.GibExplodeSound, TRUE);

	if (GearDamageType.default.GibImpactSoundDelay > 0)
	{
		bDelayGibImpactSounds = TRUE;
		SetTimer(GearDamageType.default.GibImpactSoundDelay, FALSE, nameof(EnableGibImpactSounds));
	}

	if( (BloodGoreExplosionTemplate != None) &&
		 EffectIsRelevant(Location, false, 4000) &&
		!GearDamageType.default.bSuppressPlayExplosiveRadialDamageEffects)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(BloodGoreExplosionTemplate, HitLocation, rot(0,0,0), self);
	}

	// we only want to to play the effects once and if we are spawning blood trail decals
	if( bSpawnBloodTrailDecals && !bHasGoreExploded )
	{
		// delay by a tick to spread out the cost a bit
		SetTimer(WorldInfo.DeltaSeconds + 0.01, false, nameof(SpawnABloodTrail_GibExplode_360));
	}

	// chainsaw uses a special method of breaking the gore
	if( GearDamageType == class'GDT_Chainsaw' )
	{
		ChainsawGore();
		return;
	}

	// look and see if we should spawn a little blood splatter on their camera as someone just got gibbed near them
	if ( !WorldInfo.bDropDetail && bSpawnHitEffectDecals )
	{
		foreach WorldInfo.LocalPlayerControllers( class'PlayerController', PC )
		{
			// splatter some blood on their camera if they are a human and decently close
			if(	(PC.Pawn != none && VSize(PC.Pawn.Location - Location) < 768.0f)
				 // if we are semi looking in the direction of the gibbed pawn
				&& PC.IsAimingAt( self, 0.1f ))
			{
				PC.ClientSpawnCameraLensEffect( class'Emit_CameraBlood_PunchSplatter' );
			}
		}
	}

	// Mark that we're doing a proper gore explosion, which disables any regibbing
	bHasGoreExploded = TRUE;

	// Determine which gore impulse type to use
	switch (GearDamageType.default.GibImpulseType)
	{
		case GIBIMPULSE_Cone:
			GoreExplosion_Cone(LastTakeHitInfo.InstigatedBy.Location,HitLocation,GearDamageType);
			break;
		case GIBIMPULSE_Disc:
			GoreExplosion_Disc(IsZero(LastTakeHitInfo.RadialDamageOrigin) ? HitLocation : LastTakeHitInfo.RadialDamageOrigin, VSize(Momentum), GearDamageType);
			break;
		case GIBIMPULSE_Radial:
			GoreExplosion_Radial(IsZero(LastTakeHitInfo.RadialDamageOrigin) ? HitLocation : LastTakeHitInfo.RadialDamageOrigin, VSize(Momentum), GearDamageType);
			break;
		default:
			// Default to the base gore penetration method
	 		GoreExplosion_Penetration(Momentum, HitLocation, GearDamageType);
			break;
	}


}

/** Returns TRUE if this Pawn can be chainsawed from behind. */
simulated function bool CanBeChainsawedFromBehind()
{
	return TRUE;
}

/** This will break the specific constraints that need to be broken for the chainsaw cut in half effect. **/
simulated function ChainsawGore()
{
	if (GoreSettings.ChainsawSpineBone != '' &&
		GoreSettings.ChainsawArmBone != '')
	{
		BreakConstraint(vect(100,0,0),vect(0,10,0),GoreSettings.ChainsawSpineBone);
		BreakConstraint(vect(0,100,0),vect(0,0,10),GoreSettings.ChainsawArmBone);
	}
}

/** hides the mesh and any attachments */
simulated function HideMesh()
{
	Mesh.SetHidden(true);
}

simulated event TornOff()
{
	// enforce a default momentum
	if (IsZero(TearOffMomentum))
	{
		TearOffMomentum = vect(0,0,1);
	}

	Super.TornOff();

	// destroy client-side weapons
	if ( GearInventoryManager(InvManager) != None )
	{
		GearInventoryManager(InvManager).DiscardClientSideInventory();
	}

	// make sure any onfire effects will expire
	if (OnFireState != POF_None)
	{
		if (!IsTimerActive(nameof(ExtinguishPawn)))
		{
			SetTimer(8.f, false, nameof(ExtinguishPawn));
		}
	}
}

/** Turn off controllers and get pawn ready for being put into physics */
simulated function ReadyPawnForRagdoll()
{
	// Stop any melee attack
	StopMeleeAttack();

	// Abort current special move
	if( IsDoingASpecialMove() )
	{
		EndSpecialMove();
	}

	// Turn off hit reactions
	if( PhysicsImpactBlendTimeToGo > 0.f )
	{
		BodyImpactBlendOutNotify();
	}

	// If in Meat Shield rag doll, then cancel it
	if( bInMeatShieldRagDoll )
	{
		CancelMeatShieldRagDoll();
	}

	// Ensure we are always updating kinematic
	Mesh.MinDistFactorForKinematicUpdate = 0.0;

	// If we had stopped updating kinematic bodies on this character due to distance from camera, force an update of bones now.
	// Also ensure rigid body collision is on.
	if( Mesh.bNotUpdatingKinematicDueToDistance )
	{
		Mesh.ForceSkelUpdate();
		Mesh.UpdateRBBonesFromSpaceBases(TRUE, TRUE);
		Mesh.SetBlockRigidBody(TRUE);
	}

	// Turn off IK Controllers
	if( IKCtrl_RightHand != None )			IKCtrl_RightHand.SetSkelControlActive(FALSE);
	if( IKCtrl_LeftHand != None )			IKCtrl_LeftHand.SetSkelControlActive(FALSE);
	if( IKBoneCtrl_RightHand != None )		IKBoneCtrl_RightHand.SetSkelControlActive(FALSE);
	if( IKBoneCtrl_LeftHand != None )		IKBoneCtrl_LeftHand.SetSkelControlActive(FALSE);
	if( IKRotCtrl_RightHand != None )		IKRotCtrl_RightHand.SetSkelControlActive(FALSE);
	if( IKRotCtrl_LeftHand != None )		IKRotCtrl_LeftHand.SetSkelControlActive(FALSE);

	// Turn off HeadLook controller
	if( HeadTrackSkelControl != None )
	{
		HeadTrackSkelControl.SetSkelControlActive(FALSE);
	}
	// Turn off HeadLook controller
	if( EyeTrackSkelControl != None )
	{
		EyeTrackSkelControl.SetSkelControlActive(FALSE);
	}
}

/**
 * Cancel effects of ragdolling, to get up.
 */
simulated function PostRagDollRecovery()
{
	Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;

	// Turn back on IK Controllers
	if( IKBoneCtrl_RightHand != None )		IKBoneCtrl_RightHand.SetSkelControlActive(TRUE);
	if( IKBoneCtrl_LeftHand != None )		IKBoneCtrl_LeftHand.SetSkelControlActive(TRUE);
}


/**
 * Responsible for playing any death effects, animations, etc.
 *
 * @param	DamageType - type of damage responsible for this pawn's death
 *
 * @param	HitLoc - location of the final shot
 */
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local PlayerController PC;
	local class<GearDamageType> GearDamageType;
	local AudioComponent AudioComp;
	local GearPC GPC;

	// store this for the duration of death processing
	ControllerBeforeDeath = Controller;

	GearDamageType = class<GearDamageType>(DamageType);
	// ensure a default
	if( GearDamageType == None )
	{
`if(`notdefined(FINAL_RELEASE))
		`LogExt("Invalid gear damage type!"@damageType);
		ScriptTrace();
`endif
		GearDamageType = class'GearDamageType';
	}

	// make sure hit mask does not fade it out anymore
	HitMaskComponent.SetFadingStartTimeSinceHit(-1.f);

	GPC = GearPC(Controller);
	//Is this a locally controlled pawn that just died
	if (GPC != None && GPC.IsLocalPlayerController() && GPC.StatManager != None && MyGearWeapon != None)
	{
		GPC.ModifyStat(name(MyGearWeapon.default.WeaponStatName $ "HoldingDeath" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix));
	}

	bCanTeleport		= FALSE;
	bReplicateMovement	= FALSE;
	bTearOff			= TRUE;
	bPlayedDeath		= TRUE;

	KismetDeathDelayTime = default.KismetDeathDelayTime + WorldInfo.TimeSeconds;

	// Time of death may have occurred prior to this call since a player could have been meat shielded
	if (TimeOfDeath == 0.0f)
	{
		TimeOfDeath	= WorldInfo.TimeSeconds;
	}
	LocationWhenKilled	= Location;
	RotationWhenKilled	= Rotation;
	SpecialMoveWhenDead	= SpecialMove;

	// Figure out what we were based on...
	BaseWhenDead = Base;
	if( ClampedBase != None )
	{
		BaseWhenDead = ClampedBase;
	}
	if( BaseWhenDead != None && BaseWhenDead == InteractionPawn )
	{
		BaseWhenDead = InteractionPawn.Base;
	}

// 	`log("=> BaseWhenDead:" @ BaseWhenDead @ "Base:" @ Base @ "ClampedBase:" @ "InteractionPawn:" @ InteractionPawn @ "SpecialMoveWhenDead:" @ SpecialMoveWhenDead);

	// End current Special Move for clean up.
	EndSpecialMove();
	Acceleration = Vect(0,0,0);

	// If we're dead and already have a broken constraint, make sure we turn on the Gibs optimizations.
	if( bHasBrokenConstraints )
	{
		SetupDeathGibsOptimizations();
	}

	PC = PlayerController(Controller);
	if( PC != None )
	{
		// play a death rumble
		PC.ClientPlayForceFeedbackWaveform( GearDamageType.default.KilledFFWaveform );
	}

	// handle stopping any current speech, if any
	if (CurrentlySpeakingLine != None)
	{
		`SpeechLog(self@"died, aborting speech"@CurrentlySpeakingLine.SoundCue);
		CurrentlySpeakingLine.FadeOut(0.2f, 0.f);
		SpeakLineFinished();
	}

	// sanity check that we haven't left around any looping sounds (from weapons or whatever)
	foreach ComponentList(class'AudioComponent', AudioComp)
	{
		//@todo: would be nice to be able to tell which ones are playing looping audio
		AudioComp.FadeOut(2.0, 0.0);
	}

	// play the death scream
	if( !bDisableDeathScreams && GearDamageType.default.DeathScreamEffortID != GearEffort_None )
	{
		SoundGroup.PlayEffort(self, GearDamageType.default.DeathScreamEffortID,, TRUE);
	}

	// Turn off controllers etc.
	ReadyPawnForRagdoll();

	// Skip to dying state
	GotoState('Dying');

	//@note: can't check Role here as it's already ROLE_Authority on client due to bTearOff
	if (WorldInfo.NetMode == NM_Client && CurrentLink != None)
	{
		//`log("simulating cover unclaim from death:"@CurrentLink@CurrentSlotIdx@self);
		CurrentLink.UnClaim(self,CurrentSlotIdx,FALSE);
	}

	// play death and gore only on viewports
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Play death. animation or rag doll or motorized death
		PlayDeath(GearDamageType, HitLoc);
	}
	else
	{
		// dedicated server only hides the mesh, no need to do anything else
		HideMesh();
	}

	// and team beacon
	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		GPC.MyGearHud.PostRenderedActors.RemoveItem(self);
	}

	ControllerBeforeDeath = None;
}

/**
 * Handles eliminating old/nonvisible ragdolls to keep performance in check.
 */
final function ManageRagdolls()
{
	local float				OldestTimeOfDeath;
	local GearPawn			P, OldestDeadPawn;
	local int				NumDeadPawns;
	//@fixme - refactor this to delete farthest/nonvisible ragdolls first, also to ignore inactive (sleeping) ragdolls
	// Check how many Rag Dolled Pawns we have around us.
	// It can get slow if we have too many, so we start killing the oldest one if we get beyond MaxAllowedDeadRagDollPawns.
	foreach WorldInfo.AllPawns(class'GearPawn', P)
	{
		// Disregard us, pending delete and hidden pawns.
		if( P != Self && !P.bDeleteMe && !P.bScalingToZero && !P.bHidden && !P.Mesh.HiddenGame && P.bPlayedDeath && P.Physics == PHYS_RigidBody )
		{
			NumDeadPawns++;

			if( OldestTimeOfDeath == 0.f || P.TimeOfDeath < OldestTimeOfDeath )
			{
				OldestTimeOfDeath	= P.TimeOfDeath;
				OldestDeadPawn		= P;
			}
		}
	}

	// Kill Oldest Gore Pawn.
	if( NumDeadPawns >= MaxAllowedDeadRagDollPawns && OldestDeadPawn != None )
	{
		OldestDeadPawn.bScalingToZero = TRUE;
	}
}

/** Allows GearPawn classes to decide to blow up using a very simple particle effect in some situations */
simulated function bool ShouldUseSimpleEffectDeath(class<GearDamageType> GearDamageType);

simulated function SimpleDeathDecalChoice(const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData)
{
	out_DecalData = SimpleDeathDecal;
}

/** Play death effects: animation, sounds, physics... */
simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	local bool	bShowGore, bPlayedDeathAnim;
	local Actor OldBase;
	local ParticleSystemComponent DeathEffect;

	bPlayedDeathAnim = FALSE;
	bShowGore = WorldInfo.GRI.ShouldShowGore();

	PlayDeathPhysicsModify();

	// if allowed to show the good stuff...
	if( bShowGore )
	{
		// check for a head shot death
		if ( !bHasPlayedHeadShotDeath && bCanPlayHeadShotDeath && !bIsGore &&
			(bForceHeadShotGib || GearDamageType.static.ShouldHeadShotGib(Self, KilledByPawn)) &&
			!GearGRI(WorldInfo.GRI).bShowPartialGore)
		{
			PlayHeadShotDeath();

			// Nudge the bodies away from the explosion
			if (GearDamageType == class'GDT_DiggerGrenade')
			{
				PlayDiggerImpulse(IsZero(LastTakeHitInfo.RadialDamageOrigin) ? HitLoc : LastTakeHitInfo.RadialDamageOrigin, VSize(TearOffMomentum), GearDamageType.default.GibImpulseMagnitude);
			}
		}
		// check to see if we should create the gore skeleton
		else if( GearDamageType.static.ShouldGib(Self, KilledByPawn) && ShouldGib(GearDamageType, KilledByPawn) )
		{
			// See if we want to use super-simple gore
			if( ShouldUseSimpleEffectDeath(GearDamageType) )
			{
				if (WorldInfo.NetMode != NM_DedicatedServer)
				{
					if (bShowGore)
					{
						DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter(SimpleDeathEffect, Location, Rotation);
						PlaySound(SoundCue'Foley_Flesh.Flesh.GibBodyExplodeCue', true); // if you are not playing in extreme content mode you will not get this sound :-(
						if (GearGRI(WorldInfo.GRI) != None)
						{
							GearGRI(WorldInfo.GRI).LeaveADecal(GearPawnFX.BloodDecalTrace_GroundBelowThePawn, SimpleDeathDecalChoice);
						}
					}
					else
					{
						DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter(SimpleDeathEffectNonGore, Location, Rotation);
					}
					DeathEffect.SetScale(SimpleDeathEffectScale);
				}
				// Just straight up destroy pawn
				HideMesh();
				SetCollision(false);
				SetPhysics(PHYS_None);
				LifeSpan = 0.2; // for replication
				return;
			}

			if( !bIsGore )
			{
				SwitchToGore();
			}

			// If we're in Gore Skeleton and we have some breakable joints to gib, then do so!
			if( bIsGore && GoreSettings != None && GoreSettings.GoreBreakableJoints.Length > 0 )
			{
				GoreExplosion(TearOffMomentum, HitLoc, GearDamageType);
			}
		}

		//@fixme - make this based off the physics coming to rest
		SetTimer( 15.0f, FALSE, nameof(NoMoreBloodEffectsOnDeadBodies) );
	}

	// if we die on a bloodmount, stay attached to it and go ragdoll from the waste up
	if( BloodMountIDiedOn != None && FRand() <= BloodMountIDiedOn.DriverStayInSaddleChance )
	{
		BloodMountIDiedOn.PlayMountedDeathFor(Self, GearDamageType, HitLoc, bShowGore);
	}
	else
	{
		// check to see if we can play blended death anims
		// HeadShot is a special case, as we don't actually play a death animation, but use the motor setup.
		//	However the character has to be setup for that, so we need to make sure that we have Pawn.bCanPlayHeadShotDeath == TRUE
		if( Physics != PHYS_RigidBody && SpecialMoveWhenDead != SM_RecoverFromRagdoll && SpecialMoveWhenDead != SM_Hostage &&
			!GearDamageType.default.bForceRagdollDeath && (bPlayDeathAnimations || bHasPlayedHeadShotDeath) && (!bIsGore || bHasPlayedHeadShotDeath) )
		{
			// Stop walking physics, but preserve Base (in case we're on a mover, etc)
			OldBase = Base;
			SetPhysics(PHYS_None);
			SetBase(OldBase);

			if( CanDoSpecialMove(SM_DeathAnimCleaver) )
			{
				DoSpecialMove(SM_DeathAnimCleaver, TRUE,,,TRUE);
				bPlayedDeathAnim = TRUE;
			}
			else if( CanDoSpecialMove(SM_DeathAnimFire) )
			{
				DoSpecialMove(SM_DeathAnimFire, TRUE,,,TRUE);
				bPlayedDeathAnim = TRUE;
			}
			else if( CanDoSpecialMove(SM_DeathAnim) )
			{
				DoSpecialMove(SM_DeathAnim, TRUE,,,TRUE);

				// Play animation
				if( GSM_DeathAnimBase(SpecialMoves[SM_DeathAnim]).PlayDeathAnimation(GearDamageType, HitLoc) )
				{
					bPlayedDeathAnim = TRUE;
				}
			}
		}

		// If we haven't played a custom death, like DeathAnimations, then default to simple rag dolling.
		if( !bPlayedDeathAnim )
		{
			PlayRagDollDeath(GearDamageType, HitLoc, bShowGore);
		}
	}

	// let damagetype do any special stuff
	GearDamageType.static.HandleDeathFX(self);

	// death by fire causes permanent charred skin effect
	if (ClassIsChildOf(HitDamageType, class'GDT_Fire') || ClassIsChildOf(HitDamageType, class'GDT_IncendiaryGrenade'))
	{
		// stop char fading
		CharSkin(1.0);
		CurrentSkinCharMin = 0.95;
		SkinHeatFadeTime = 5.0; // fade out nicely
	}

	// dude is dead, will end up as ragdoll somehow, no need for cylinder to block anymore
	if( CollisionComponent != CylinderComponent )
	{
		CylinderComponent.SetTraceBlocking(FALSE, FALSE);
	}
}

simulated function PlayDeathPhysicsModify();

simulated final native function bool IsDoingDeathAnimSpecialMove() const;

/** Event called from Anim Notify when body rests in animation, to trigger transition to full rag doll. */
simulated function OnDeathAnimBodyRest()
{
	if( SpecialMove == SM_DeathAnim )
	{
		GSM_DeathAnim(SpecialMoves[SpecialMove]).OnDeathAnimBodyRest();
	}
}

/**
 * Sometimes you can get a body that is in a corner and vibrating and moving up and down on itself
 * such that he will sit there for ever constantly spewing blood over and over.	 And it looks a little
 * weird.  So this function will set the GibEffectsSpeedThreshold to a large value.
 **/
simulated function NoMoreBloodEffectsOnDeadBodies()
{
	GibEffectsSpeedThreshold = 100000;
}

/**
 * Add an impulse to the victim of a digger grenade so they move away from the digger explosion
 *
 * @param DiggerOrigin the location of the digger grenade detonation
 * @param Momentum the damage momentum to apply
 * @param GibImpulseMagnitude the impulse from the damage type to apply
 */
simulated function PlayDiggerImpulse(vector DiggerOrigin,float Momentum,float GibImpulseMagnitude)
{
	local vector Dir;
	local vector Impulse;
	local vector BoneLoc;

	if (HeadBoneNames[0] != '')
	{
		BoneLoc = Mesh.GetBoneLocation(HeadBoneNames[0]);
		Dir = Normal(BoneLoc - DiggerOrigin);
		Impulse = Dir * Momentum * GibImpulseMagnitude;
		// Push the mesh in a direction using COM and velocity not force
		Mesh.AddImpulse(Impulse,BoneLoc,HeadBoneNames[0],true);
	}
}

/** Play HeadShot special death */
simulated function PlayHeadShotDeath()
{
	local SkelControlBase Control;

	bHasPlayedHeadShotDeath = true;

	// Scale neck bone down to zero to hide head.
	Control	= Mesh.FindSkelControl('NeckScale');
	if( Control != None )
	{
		Control.SetSkelControlActive(true);
	}

	if( WorldInfo.GRI.ShouldShowGore() && !GearGRI(WorldInfo.GRI).bShowPartialGore)
	{
		if (bTearOff && !bIsGore)
		{
			SwitchToGore();
		}

		// Gore attachment to hide neck bone scaling.
		if (HeadShotNeckGoreAttachment != None)
		{
			Mesh.AttachComponentToSocket(HeadShotNeckGoreAttachment, 'HeadShotGoreMesh');
		}

		// add hit mask to head position
		AddGoreHitMask('b_MF_Head', 20.f);

		if (EffectIsRelevant(Location, false, 4000.0))
		{
			// Force blood emitter to be attached on the neck.
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(HeadshotBloodTemplate, Mesh, 'HeadShotBloodPS', true);

			SpawnHeadChunks();

			if (bSpawnBloodTrailDecals)
			{
				// start up the blood spurting from the neck
				StartBloodTrail('SpawnABloodTrail_HeadShot', 0.2);
				SetTimer(3.5, false, nameof(StopBloodTrail_HeadShot));
			}
		}
	}

	PlaySound( SoundCue'Foley_Flesh.Flesh.GibHeadShotCue' );
}

simulated final function SpawnHeadChunks()
{
	local int				ChunkNb;
	local Vector			HeadLoc, X, Y, Z;
	local Rotator			HeadRot;

	// Spawn several physics Head Chunks
	if( HeadChunks.Length > 0 )
	{
		// HeadRot is pointing up.
		Mesh.GetSocketWorldLocationAndRotation('HeadShotBloodPS', HeadLoc, HeadRot);
		GetAxes(Instigator.Rotation, X, Y, Z);

		// always spawn the head
		SpawnAHeadChunk( HeadLoc, HeadRot, HeadChunks[0] ); // 0 is always the main piece

		// Spawn several physics Head Chunks
		for(ChunkNb=0; ChunkNb<5; ChunkNb++)
		{
			// don't spawn the 0 (head) twice
			SpawnAHeadChunk( HeadLoc, HeadRot, HeadChunks[ Max( 1, Rand(HeadChunks.Length)) ] );
		}
	}
}


/** Does all of the work of spawning a head chunk **/
simulated function SpawnAHeadChunk( vector HeadLoc, rotator HeadRot, StaticMesh TheMesh )
{
	local GearKActorSpawnableEffect HeadChunk;
	local vector RandDir;

	RandDir = ( vect(1,0,0) * ( (FRand() * 2.f) - 1.f) ) + ( vect(0,1,0) * ( (FRand() * 2.f) -1.0f) ) + vect(0,0,1);

	//`log( "RandDir: " $ RandDir );

	HeadChunk = Spawn(class'GearKActorSpawnableEffect',,, HeadLoc + RandDir * 10.f, HeadRot);
	HeadChunk.StaticMeshComponent.SetStaticMesh( TheMesh );
	HeadChunk.StaticMeshComponent.WakeRigidBody();
	HeadChunk.StaticMeshComponent.SetRBCollidesWithChannel( RBCC_Pawn, TRUE ); // make chunks collide with pawns as it is fun to kick them around!

	HeadChunk.ApplyImpulse(RandDir, 2.f + 5.f * FRand(), HeadLoc);

	HeadChunk.LifeSpan = FMin(15.0, CorpseMaxLifeSpan);
	// turn off updating the DLE after a second
	HeadChunk.SetTimer(1.0f, false, nameof(HeadChunk.SetLightEnvironmentToNotBeDynamic));
}

function OnKnockdownPawn(SeqAct_KnockdownPawn Action)
{
	local vector LinearVel, AngularVel;

	// knockdown the pawn
	if (Action.InputLinks[0].bHasImpulse)
	{
		LinearVel = vect(0,0,1) * 384.f * Action.LinearVelocityScale;
		LinearVel.X = int(LinearVel.X);
		LinearVel.Y = int(LinearVel.Y);
		LinearVel.Z = Min(LinearVel.Z,0);	// clamp the z to only push down
		AngularVel = Normal(vector(Rotation) cross vect(0,0,1)) * RandRange(-6.f,-4.f) * Action.AngularVelocityScale;
		bStayKnockedDown = Action.bStayKnockedDown;
		Knockdown(LinearVel, AngularVel);
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		// this will automatically get up, or set a timer until the physics comes to rest
		CheckGetUp();
	}
}

/** Stops all animations from playing and saves a list of the active ones to be restarted on the next call to ResumeAllAnimations(). */
final simulated function PauseAllAnimations()
{
	local AnimNodeSequence SeqNode;
	// make sure we aren't already paused
	if (ResumePlayNodes.Length == 0)
	{
		foreach Mesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
		{
			// if it's currently playing then save it to a list for resuming later
			if( SeqNode.bPlaying )
			{
				ResumePlayNodes.AddItem(SeqNode);
			}
			// stop all nodes from playing
			SeqNode.bPlaying = FALSE;
		}
	}
}

/** Starts playing any animations that were playing at the time PauseAllAnimations() was called. */
final simulated function ResumeAllAnimations()
{
	local AnimNodeSequence SeqNode;
	// Resume nodes playing animation.
	foreach ResumePlayNodes(SeqNode)
	{
		SeqNode.bPlaying = TRUE;
	}
	ResumePlayNodes.Length = 0;
}

/** Stops all animations on character */
simulated function StopAllAnimations()
{
	local AnimNodeSequence	SeqNode;
	local AnimTree RootNode;

	foreach Mesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
	{
		SeqNode.bPlaying = FALSE;
	}

	RootNode = AnimTree(Mesh.Animations);
	if( RootNode != None && !RootNode.bUseSavedPose )
	{
		// Save a pose using the current mesh
		RootNode.SetUseSavedPose(TRUE);
		// Clear references to AnimTree nodes.
		ClearAnimNodes();
		// Now clear the rest of the tree, as we are only going to use the saved pose from now on
		RootNode.Children[0].Anim = None;
		// When dead, no need to animate when not rendered
		Mesh.bUpdateSkelWhenNotRendered = FALSE;
	}
}

simulated function PlayFallDown()
{
	// abort the weapon reload
	if (GearWeapon(Weapon) != None)
	{
		GearWeapon(Weapon).AbortWeaponReload();
	}

	ReadyPawnForRagdoll();

	if( InitRagdoll() )
	{
		// Move into post so that we are hitting physics from last frame, rather than animated from this
		Mesh.SetTickGroup(TG_PostAsyncWork);
		SetTickGroup(TG_PostAsyncWork);

		// Set physics to NOT be updated from Kinematic data
		Mesh.bUpdateKinematicBonesFromAnimation = FALSE;

		PauseAllAnimations();

		if( bPlayMotorAnimOnKnockDown )
		{
			if( Mesh.PhysicsAssetInstance != None )
			{
				// Make sure all motors are on
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(TRUE, TRUE, Mesh, TRUE);
				// Set motor strength
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(KnockDownMotorStrength, KnockDownMotorDamping, 0.f, Mesh, TRUE);
			}
			// Want to update joints with anim data
			Mesh.bUpdateJointsFromAnimation = TRUE;

			// Play anim
			BS_Play(BS_KnockDownAnim, 1.0, 0.2, 0.2, TRUE, TRUE);
		}
		else
		{
			if( Mesh.PhysicsAssetInstance != None )
			{
				// Make sure all motors are off on joints.
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, Mesh, TRUE);
				// Turn on velocity motors, to add some joint friction
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(0.f, 0.f, 0.004f, Mesh, TRUE);
				// Don't set motors on dangly bits.
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularVelocityDrive(TRUE, TRUE, Mesh, TRUE);
			}

			Mesh.bUpdateJointsFromAnimation = FALSE;
		}

		// Record when knockdown happened
		KnockDownStartTime = WorldInfo.TimeSeconds;

		PlayFallDownPhysicsModify();

		// we purposefully do NOT turn collide with RBBC_Pawn on
		// we will innerpentrate other ragdolled pawns as we do not collide with the Pawn channel.  This is acceptable because if we do
		// collide with other ragdolled pawns there is a chance that we will have the physics system forcibly push us apart causing one
		// or both the pawns to fly through the world

		ReduceConstraintLimits();
	}
	else
	{
		`Warn("Failed to init ragdoll for"@self);
	}
}


/** This will modify the physics is the correct way for PlayFallDown **/
simulated function PlayFallDownPhysicsModify()
{
	// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
	//Mesh.SetRBChannel(RBCC_Default);

	Mesh.SetRBChannel(RBCC_Untitled3);
	Mesh.SetRBCollidesWithChannel(RBCC_Untitled3, TRUE);
	Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
	Mesh.SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
}

/** Check to see if we should recover from ragdoll, called on server and owning client. */
function CheckGetUp()
{
	if (Role == ROLE_Authority && IsInState('KnockedDown'))
	{
		// if barely moving,
		if( VSize(Velocity) < 8.f )
		{
			EndKnockedDownState();
		}
		else
		{
			// otherwise check again shortly
			SetTimer( 0.25f, FALSE, nameof(CheckGetUp) );
		}
	}
}


/** Add Base Linear Velocity Upon Death. Takes into account ClampedBase and InteractionPawn */
simulated function AddBaseLinearVelocityUponWhenGoingRagDoll()
{
	local Actor TestBase;
	local Vector VelToSet;

	// Current Base
	TestBase = Base;
	// Forced Base (movers, like Derrick)
	if( ClampedBase != None )
	{
		TestBase = ClampedBase;
	}
	// Base on InteractionPawn (Hostage)
	if( TestBase != None && TestBase == InteractionPawn )
	{
		TestBase = InteractionPawn.Base;
	}
	// Base when dead
	if( BaseWhenDead != None )
	{
		TestBase = BaseWhenDead;
	}


// 	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Base:" @ Base @ "ClampedBase:" @ ClampedBase @ "BaseWhenDead:" @ BaseWhenDead @ "InteractionPawn:" @ InteractionPawn @ "SpecialMove:" @ SpecialMove);
	VelToSet = GetAggregateBaseVelocity( TestBase );

	if( !IsZero( VelToSet ) )
	{
// 		`log("=> Setting Velocity" @ TestBase.Velocity @ "from" @ TestBase);
		Mesh.SetRBLinearVelocity(VelToSet, FALSE);
	}
}

/** Play RagDoll Physics death */
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	local Vector		ApplyImpulse;
	local TraceHitInfo	HitInfo;

	// make room for the new ragdoll
	ManageRagdolls();

	if( InitRagdoll() )
	{
		if( Mesh.PhysicsAssetInstance != None )
		{
			// Make sure all motors are off on joints.
			Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, Mesh, TRUE);

			// Turn on velocity motors, to add some joint friction
			Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(0.f, 0.f, 0.004f, Mesh, TRUE);
			Mesh.PhysicsAssetInstance.SetAllMotorsAngularVelocityDrive(TRUE, TRUE, Mesh, TRUE);

			// Make sure all bodies are unfixed
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

			// Add velocity of base upon death.
			AddBaseLinearVelocityUponWhenGoingRagDoll();
		}

		// Set physics to NOT be updated from Kinematic data
		Mesh.bUpdateJointsFromAnimation = FALSE;
		Mesh.bUpdateKinematicBonesFromAnimation = FALSE;

		if (bIsGore && !(bPlayedDeath && !bHasPlayedHeadShotDeath && GoreSettings != None))
		{
			// We already stopped the animations during gore explosion
			StopAllAnimations();
		}

		// disable unreal collision on ragdolls
		SetCollision(TRUE, FALSE);

		if( bEnableEncroachCheckOnRagdoll )
		{
			bNoEncroachCheck = FALSE;
		}

		// Wake up rigid body
		Mesh.WakeRigidBody();

		// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
		PlayRagDollDeathPhysicsModify();

		// This code only runs if the weapon is both non-goring and the model doesn't play special animations for the damage type
		if (!bIsGore)
		{
			ApplyImpulse = GetImpactPhysicsImpulse(GearDamageType, HitLoc, TearOffMomentum, HitInfo);
			if( !IsZero(ApplyImpulse) )
			{
				Mesh.AddImpulse(ApplyImpulse, HitLoc, HitInfo.BoneName, TRUE);
				Mesh.SetRBLinearVelocity(ApplyImpulse * 2.f, TRUE);
			}

			// Decrease joint limits, to prevent nasty poses once in complete ragdoll.
			ReduceConstraintLimits();
		}
	}
	else
	{
		`warn("PlayDying Ragdoll init failed");
		Destroy();
	}
}

simulated function PlayRagDollDeathPhysicsModify()
{
	// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
	Mesh.SetRBChannel(RBCC_DeadPawn);
	Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
}

/** Utility for scaling joint limits down of specific bones. */
simulated native function ReduceConstraintLimits();

/** This will spawn attachments on pawn classes the override this */
function ShootOffAttachment( EAttachmentType AttachmentType, Vector ApplyImpulse, class<DamageType> DamageType, bool bForced );

/** Any attachments this pawn has will be spawned and dropped **/
function RemoveAndDropAttachments( Vector ApplyImpulse, class<DamageType> DamageType );


State Dying
{
	ignores Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, EnterDBNO;

	simulated event FellOutOfWorld(class<DamageType> dmgType)
	{
		Destroy();
	}

	simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
	{
		return false;
	}

	simulated event BeginState( Name NextStateName )
	{
		// cleanup any DBNO/neardeath audio
		FadeOutAudioComponent(ReviveBreathSound,0.1f);
		FadeOutAudioComponent(FlatLiningSound,0.1f);
		FadeOutAudioComponent(ReviveHeartbeatSound,0.1f);
		FadeOutAudioComponent(NearDeathBreathSound,0.1f);

		Super.BeginState(NextStateName);

		// So here we set how long the corpse should stick around before we start looking ever 2.0 seconds to see if we should destroy it	@see Pawn State Dying
		SetTimer( DurationBeforeDestroyingDueToNotBeingSeen, FALSE );

		// Cancel failsafe lifespan, we want corpses to live until cleaned up
		if (LifeSpan > 20.0f)
		{
			LifeSpan = 0.0f;
		}
	}

	simulated function byte GetTeamNum()
	{
		// we won't have a PRI here so just use the stored value
		return LastTeamNum;
	}

	simulated function Tick(float DeltaTime)
	{
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			FadeSkinEffects(DeltaTime);
		}

		// if we are scaling to zero then do so
		if( ( bScalingToZero )  )
		{
			SetDrawScale( DrawScale - DeltaTime );
			if( DrawScale < 0.4 )
			{
				// start falling through the floor as scaling byitself looks pretty lame
				//SetCollision( FALSE, FALSE, FALSE );
				Mesh.SetRBChannel(RBCC_Nothing);
				Mesh.SetRBCollidesWithChannel(RBCC_Nothing, FALSE);
				Mesh.SetRBCollidesWithChannel(RBCC_Default, FALSE);
				Mesh.SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
				Mesh.SetRBCollidesWithChannel(RBCC_BlockingVolume, FALSE);
				if( DrawScale < 0.02 )
				{
					bScalingToZero = FALSE;
					if( bDeleteMe == FALSE )
					{
						Destroy();
					}
				}
			}
		}
	}


	/**
	 * Start a special move.
	 * @network: local player and server
	 */
	simulated event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove=FALSE, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags=0, optional bool bSkipReplication)
	{
		if( NewMove == SM_None || NewMove == SM_DeathAnim || NewMove == SM_DeathAnimFire || NewMove == SM_DeathAnimCleaver )
		{
			Global.DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags, bSkipReplication);
		}
		else
		{
			`Warn(WorldInfo.TimeSeconds @ Self @ GetStateName() @ GetFuncName() @ "tried to do special move" $ NewMove $ "while Dying...");
		}
	}

	function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local class<GearDamageType>	GearDamageType;

		// make sure we are the server
		// but since we're dead, we have nothing to do on a dedicated server here... all cosmetic!
		if( Role < ROLE_Authority || WorldInfo.NetMode == NM_DedicatedServer )
		{
			return;
		}

		// Don't apply hammer of Dawn damage type every frame, the upward impulse sends bodies flying!
		if( DamageType == class'GDT_HOD' )
		{
			if( `TimeSince(LastHODDamageTime) < 1.f )
			{
				return;
			}
			LastHODDamageTime = WorldInfo.TimeSeconds;
		}

		if( VSize(Momentum) > 4.f )
		{
			Momentum = Normal(Momentum);
		}

		GearDamageType = class<GearDamageType>(DamageType);

		// play any associated fx/sounds
		DoDamageEffects(Damage, InstigatedBy != None ? InstigatedBy.Pawn : None, HitLocation, GearDamageType, Momentum, HitInfo);
	}

	function Unpossessed()
	{
		local PlayerReplicationInfo PRI;

		PRI = PlayerReplicationInfo;
		Global.Unpossessed();
		// preserve the PRI past death since we still refer to it via HUD icons, etc
		PlayerReplicationInfo = PRI;
	}
}


function ShouldCrouch(bool bCrouch)
{
	local ECoverType DesiredCoverType;

	//debug
	`AILog_Ext(GetFuncName() @ bCrouch @ bWantsToCrouch@IsInCover(), 'Cover', MyGearAI);

	Super.ShouldCrouch(bCrouch);

	// Use Crouch to toggle between midlevel and standing cover.
	if (IsInCover())
	{
		// If wants to crouch
		if (bWantsToCrouch)
		{
			// If in standing cover or doing 360 aiming in mid level cover. (Aka pop up)
			if (CoverType == CT_Standing || bDoing360Aiming)
			{
				if (CoverType == CT_Standing)
				{
					// Squat
					SetCoverType(CT_MidLevel);
				}
				else
				{
					SetCoverType(CT_Standing);
				}
			}
		}
		// Otherwise, if wants to stand
		else
		{
			// Find desired cover type at slot
			DesiredCoverType = FindCoverType();

			// If our covertype is different than what the cover suggests, go back to default.
			if (CoverType != DesiredCoverType)
			{
				// Stand
				SetCoverType(DesiredCoverType);
			}
		}
	}
}

/** plays any effects associated with a change in cover type */
simulated final event PlayCoverTypeChanged(ECoverType OldCoverType)
{
	// play sounds if we switched between crouching and standing
	if (OldCoverType == CT_Standing && CoverType == CT_MidLevel)
	{
		SoundGroup.PlayFoleySound(self, GearFoley_ToCrouchFX, false);
		SoundGroup.PlayEffort(self, GearEffort_CrouchEffort, true);
	}
	else if (OldCoverType == CT_MidLevel && CoverType == CT_Standing)
	{
		SoundGroup.PlayFoleySound(self, GearFoley_FromCrouchFX, false);
		SoundGroup.PlayEffort(self, GearEffort_CrouchEffort, true);
	}
}

/**
 * Handles setting the a new cover type for this pawn, for both
 * animation and physics purposes.
 *
 * @param	newCoverType - new cover type now active
 */
final simulated function SetCoverType(ECoverType NewCoverType)
{
	local ECoverType OldCoverType;
	local GearMPPRI MPPRI;
	local gearai_cover GAIC;

	//debug
	`AILog_Ext( GetFuncName()@"Link C/L/R"@CurrentLink@CurrentSlotIdx@LeftSlotIdx@RightSlotIdx@"CT"@CoverType@"to"@NewCoverType, 'Cover', MyGearAI );

	OldCoverType = CoverType;
	MPPRI = GearMPPRI(PlayerReplicationInfo);

	// Do nothing if state isn't changing
	if( NewCoverType != CoverType )
	{
		// if we are the server,
		if (OldCoverType == CT_None)
		{
			if (Role == ROLE_Authority)
			{
				// @STATS - Entered Cover
				`RecordPlayerIntStat(ENTERED_COVER,Controller,0);

				if (MPPRI != None)
				{
					MPPRI.CoverStartedTime = WorldInfo.TimeSeconds;
					MPPRI.bNetDirty = true;
				}
			}
		}

		if( GearPC(Controller) != None )
		{
			GearPC(Controller).CoverLog( "newCoverType:" @ newCoverType, GetFuncName() );
		}

		// Update last cover time
		LastCoverTime = WorldInfo.TimeSeconds;

		// set the enum for animation
		CoverType = NewCoverType;

		if( Role == Role_Authority )
		{
			// Force replication
			bForceNetUpdate = TRUE;

			// Force push out of cover transition for AI characters.
			GAIC = GearAI_Cover(Controller);
			if( NewCoverType == CT_None && GAIC != None && !GAIC.bLeaveCoverFast && !bEndingSpecialMove && CanDoSpecialMove(SM_PushOutOfCover) )
			{
				LocalDoSpecialMove(SM_PushOutOfCover, TRUE);
			}

			// reset bLeaveCoverFast
			if(GAIC != none)
			{
				GAIC.bLeaveCoverFast=false;
			}
		}

		PlayCoverTypeChanged(OldCoverType);
	}

	// Rotation interpolation when leaving cover.
	if( OldCoverType != CT_None && CoverType == CT_None )
	{
		if (Role == ROLE_Authority)
		{
			//@STATS - Left Cover
			`RecordPlayerIntStat(LEFT_COVER,Controller,0);

			if (MPPRI != None && MPPRI.CoverStartedTime > 0)
			{
				MPPRI.TotalTimeInCoverThisRound += `TimeSince(MPPRI.CoverStartedTime);
				MPPRI.TotalTimeInCover += `TimeSince(MPPRI.CoverStartedTime);
				MPPRI.CoverStartedTime = 0;
				MPPRI.bNetDirty = true;
			}
		}

		// If Pawn is not already doing a rotation interp when leaving cover, then do one.
		if( !IsDoingPawnRotationInterpolation() )
		{
			InterpolatePawnRotation(0.f, TRUE);
		}
	}
}


/**
 * Handles setting the new cover action for this pawn
 *
 * @param	NewCoverAction - new cover action type activated
 */

final simulated function SetCoverAction( ECoverAction NewCoverAction )
{
	local GearPC	MyGearPC;

	// Do nothing if state isn't changing
	if( NewCoverAction != CoverAction )
	{
		MyGearPC = GearPC(Controller);
		if( MyGearPC != None )
		{
			MyGearPC.CoverLog( "NewCoverAction:"@NewCoverAction@"Last"@WorldInfo.TimeSeconds-LastCoverActionTime@"Next"@Abs(NextCoverActionTime)-WorldInfo.TimeSeconds, GetFuncName() );
		}

		// That's only for AI...
		if( Role == Role_Authority && !IsHumanControlled() )
		{
			// If leaning or firing left, don't allow non-left actions for a short time
			if( (CoverAction == CA_LeanLeft || CoverAction == CA_BlindLeft) &&
				(NewCoverAction != CA_LeanLeft && NewCoverAction != CA_BlindLeft) )
			{
				NextCoverActionTime = -(WorldInfo.TimeSeconds + 0.35f);
			}
			// Otherwise, if leaning or firing right, don't allow non-right actions for a short time
			else if( (CoverAction == CA_LeanRight || CoverAction == CA_BlindRight) &&
					(NewCoverAction != CA_LeanRight && NewCoverAction != CA_BlindRight) )
			{
				NextCoverActionTime =  (WorldInfo.TimeSeconds + 0.35f);
			}

			// If not moving to default and not enough time has past since last action
			if( NewCoverAction != CA_Default &&
				Abs(NextCoverActionTime) > WorldInfo.TimeSeconds )
			{
				// If old action was left and new action is not left, go to default
				if( NextCoverActionTime < 0.f &&
					NewCoverAction != CA_LeanLeft &&
					NewCoverAction != CA_BlindLeft )
				{
					NewCoverAction = CA_Default;
				}
				// Otherwise, if old action was right and new action is not right, go to default
				else if( NextCoverActionTime > 0.f &&
						NewCoverAction != CA_LeanRight &&
						NewCoverAction != CA_BlindRight )
				{
					NewCoverAction = CA_Default;
				}
			}
		}

		// Heavy weapons don't allow transitioning from leaning to pop-up and vice versa.
		if( !CanDoLeaningTransition() )
		{
			if( IsALeaningAction(NewCoverAction) && IsALeaningAction(CoverAction) )
			{
				return;
			}
		}

		// Set action
		CoverAction = NewCoverAction;
		// Store time
		LastCoverActionTime = WorldInfo.TimeSeconds;

		if( Role == Role_Authority )
		{
			// Force replication
			bForceNetUpdate = TRUE;
		}

		// CoverAction has been updated!
		CoverActionChanged();
	}
}

simulated function CoverActionChanged()
{
	local Actor A;
	local array<SequenceEvent> TouchEvents;
	local int i;

	// Keep track of last cover action set.
	PreviousCoverAction	= SavedCoverAction;
	SavedCoverAction	= CoverAction;

	// If we've just got out of 360 aiming, then don't reset this flag just now.
	// If time has elapsed, then we don't consider just transitioning from that anymore.
	if( bWasDoing360Aiming && `TimeSince(Last360AimingChangeTime) > 0.25f )
	{
		bWasDoing360Aiming = FALSE;
	}
	`LogSM(`location@`showvar(PreviousCoverAction)@`showvar(SavedCoverAction));

	// See if we should mount/unmount heavy weapons.
	CheckHeavyWeaponMounting();

	if (IsPoppingUp())
	{
		SoundGroup.PlayFoleySound(self, GearFoley_Body_Popup);
	}
	else if (IsLeaning())
	{
		SoundGroup.PlayFoleySound(self, GearFoley_Body_Lean);
	}

	// check to see if we need to kick off kismet 'geartouch' events when we change cover action (e.g. we just peaked up, now we want to hit the trigger)
	foreach TouchingActors(class'Actor', A)
	{
		if (A.FindEventsOfClass(class'SeqEvt_GearTouch', TouchEvents))
		{
			for (i = 0; i < TouchEvents.length; i++)
			{
				SeqEvt_GearTouch(TouchEvents[i]).CheckCoverStatusTouchActivate(A,self,true,IsLeaning());
			}
			// clear array for next iteration
			TouchEvents.length = 0;
		}
	}
}

/**
 * Returns TRUE if can do leaning to pop transition and vice versa.
 * Disallowed for Heavy Weapons.
 */
simulated final function bool CanDoLeaningTransition()
{
	if( MyGearWeapon != None && MyGearWeapon.IsA('GearWeap_HeavyBase') )
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * Returns true if blind firing.
 */
simulated final function bool IsBlindFiring(ECoverAction PawnCA)
{
	return (PawnCA == CA_BlindRight || PawnCA == CA_BlindLeft || PawnCA == CA_BlindUp);
}


/**
 * Return true if Cover Action is leaning (left/right/up)
 */
simulated final native function bool IsLeaning();

/** Is Pawn Leaning? Note: PopUp is considered leaning. */
simulated final function bool IsALeaningAction(ECoverAction InCoverAction)
{
	return (InCoverAction == CA_LeanLeft || InCoverAction == CA_LeanRight || InCoverAction == CA_PopUp);
}

simulated final function bool IsPeeking( ECoverAction PawnCA )
{
	return (PawnCA == CA_PeekRight || PawnCA == CA_PeekLeft || PawnCA == CA_PeekUp);
}

/** Return true if this pawn is popping up, false otherwise */
simulated final native function bool IsPoppingUp();

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
	local GearPC PC;

	if (Role == ROLE_Authority)
	{
		if (!WorldInfo.Game.IsA('GearGameSP_Base'))
		{
			Super.FellOutOfWorld(dmgType);
		}
		else
		{
			if (!ClassIsChildOf(dmgType,class'GearDamageType'))
			{
				dmgType = class'GDT_Environment';
			}
			if (IsA('GearPawn_COGGear'))
			{
				`Warn("COG fell out of world, attempting to teleport to a human player"@self);
				// try to teleport near a human player in this evil case
				foreach LocalPlayerControllers(class'GearPC', PC)
				{
					if (PC.FindAvailableTeleportSpot(self))
					{
						// don't die on me!
						return;
					}
					else if (PC.Pawn != None && PC.Pawn != self && GearGameSP_Base(WorldInfo.Game).PlayerSlots.Find('Owner', Controller) != INDEX_NONE)
					{
						// try harder for co-op relevant pawns
						SetLocation(PC.Pawn.Location);
						Velocity = vect(0,0,0);
						return;
					}
				}
			}
			if (PlayerController(Controller) != None)
			{
				if (Anchor != None)
				{
					SetLocation(Anchor.Location);
				}
				else
				{
					SetLocation(class'NavigationPoint'.static.GetNearestNavToActor(self).Location);
				}
			}
			else if (Health > 0)
			{
				Super.FellOutOfWorld(dmgType);
			}
			else
			{
				Super(Actor).FellOutOfWorld(dmgType);
			}
		}
	}
}

/**
 * Called by animation code whenever an action animation has finished.
 */
simulated event CoverActionAnimationFinished()
{
	//@todo - notify ai, so that hard-coded delays can be eliminated
}

function bool InGodMode()
{
	local GearPC PC;
	local GearPawnRidable_Base GPRidable;

	PC = GearPC(Controller);

	if (PC == None && Base != None)
	{
		GPRidable = GearPawnRidable_Base(Base);
		if (GPRidable != none)
		{
			return (GPRidable.Controller != None && GPRidable.Controller.bGodMode);
		}
	}

	return (Super.InGodMode() || (PC != None && (PC.bCameraGodMode || PC.bCinematicMode)));
}

/**
 * Overridden to return the actual player name from this Pawn's
 * PlayerReplicationInfo (PRI) if available.
 */
function String GetDebugName()
{
	// return the actual player name from the PRI if available
	if (PlayerReplicationInfo != None)
	{
		return PlayerReplicationInfo.PlayerName;
	}
	// otherwise return the formatted object name
	return GetItemName(string(self));
}

/**
 * Called from PlayerController UpdateRotation() -> ProcessViewRotation() to (pre)process player ViewRotation
 * adds delta rot (player input), applies any limits and post-processing
 * returns the final ViewRotation set on PlayerController
 *
 * @param	DeltaTime, time since last frame
 * @param	ViewRotation, actual PlayerController view rotation
 * @input	out_DeltaRot, delta rotation to be applied on ViewRotation. Represents player's input.
 * @return	processed ViewRotation to be set on PlayerController.
 */
simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	// Give weapon a chance to modify playercontroller's viewrotation
	if( MyGearWeapon != None )
	{
		MyGearWeapon.ProcessViewRotation( DeltaTime, out_ViewRotation, out_DeltaRot );
	}
	Super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
}

/**
 * Overridden to return camera values specific to GearPawn.
 *
 * @param		RequestedBy
 */
simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
	return 'default';
}

/**
 * Native hook to allow factories to give AI the default loadout if none is specified.
 */
event AI_AddDefaultInventory()
{
	AddDefaultInventory();
}

/**
 * Called after spawning from a factory.
 */
event PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	local GearSpawnerDestination SpawnDest;
	local Vector SpawnDir;
	local float SpeedResult;

	// See if the spawner wants to give the pawn some velocity towards a destination
	// We will first try a destination from the SpawnSet
	if (SpawningFactory.SpawnSets[SpawnSetIdx].SpawnDestinations.length > 0)
	{
		// Randomly grab one from the list
		SpawnDest = SpawningFactory.SpawnSets[SpawnSetIdx].SpawnDestinations[Rand(SpawningFactory.SpawnSets[SpawnSetIdx].SpawnDestinations.length)];
	}

	// If the SpawnSet failed, we'll try the list in the factory
	if (SpawnDest == None &&
		SpawningFactory.SpawnDestinations.length > 0)
	{
		// Randomly grab one from the list
		SpawnDest = SpawningFactory.SpawnDestinations[Rand(SpawningFactory.SpawnDestinations.length)];
	}

	// If we found a destination
	if (SpawnDest != None)
	{
		// Determine the speed to toss the pawn
		SpeedResult = FRand() * (SpawnDest.MaxSpeed - SpawnDest.MinSpeed) + SpawnDest.MinSpeed;
		// Make sure the speed is valid
		if (SpeedResult > 0)
		{
			SetPhysics(PHYS_Falling);
			// Determine the direction to toss the pawn
			SpawnDir = Normal(SpawnDest.Location-Location);
			// Set the pawn to launch
			Velocity = SpawnDir * SpeedResult;
		}
	}
}

/**
 * Overridden to iterate through the DefaultInventory array and
 * give each item to this Pawn.
 *
 * @see			GameInfo.AddDefaultInventory
 */
function AddDefaultInventory()
{
	local class<Inventory> InvClass;
	local Inventory Inv;
	local GearWeapon Weap;

	foreach DefaultInventory(InvClass)
	{
		// Ensure we don't give duplicate items
		Inv = FindInventoryType(InvClass);

		// If item not found
		if( Inv == None )
		{
			// Create it and add to inventory chain, only activate if we don't have a weapon currently selected
			CreateInventory(InvClass,Weapon != None);
		}
		// Otherwise, item already in our inventory chain
		else
		{
			// Add extra ammo to the weapon we already have
			Weap = GearWeapon(Inv);
			if( Weap != None )
			{
				Weap.InitializeAmmo();
			}
		}
	}
}

/** Special add inventory function which forces the player to not equip a weapon */
function AddDefaultInventoryNoEquip()
{
	local class<Inventory> InvClass;
	local Inventory Inv;

	foreach DefaultInventory(InvClass)
	{
		// Ensure we don't give duplicate items
		Inv = FindInventoryType(InvClass);

		// If item not found
		if( Inv == None )
		{
			// Create it and add to inventory chain, only activate if we don't have a weapon currently selected
			CreateInventory(InvClass,true);
		}
	}
}

simulated function OnGiveInventory(SeqAct_GiveInventory InAction)
{
	local int Idx;
	local class<Inventory> InvClass;
	local bool bOldAllowDrops;
	local Inventory NewInv, OldInv;
	local class<GearWeapon> GearWeapClass;

	bOldAllowDrops = bAllowInventoryDrops;
	bAllowInventoryDrops = FALSE;

	if (MyGearAI != None)
	{
		Super.OnGiveInventory(InAction);

		// see if he got a shield, and equip it if so
		for (Idx = 0; Idx < InAction.InventoryList.Length; Idx++)
		{
			if (ClassIsChildOf(InAction.InventoryList[idx], class'GearShield'))
			{
				EquipShield(GearInventoryManager(InvManager).Shield);
				break;
			}
		}
	}
	else
	{
		if (InAction.bClearExisting)
		{
			InvManager.DiscardInventory();
		}
		if (InAction.InventoryList.Length > 0 )
		{
			for (Idx = 0; Idx < InAction.InventoryList.Length; Idx++)
			{
				InvClass = InAction.InventoryList[idx];
				if (InvClass != None)
				{
					// only create if it doesn't already exist
					if (FindInventoryType(InvClass,FALSE) == None)
					{
						// look for an empty slot
						if (GearInventoryManager(InvManager).FindFreeSlotForInventoryClass(InvClass) == EASlot_None)
						{
							`log("no free slot");
							// if occupied try to drop the old weapon
							GearWeapClass = class<GearWeapon>(InvClass);
							if (InAction.bForceReplace || GearWeapClass == None)
							{
								OldInv = GearInventoryManager(InvManager).GetInventoryInSlot(GearInventoryManager(InvManager).GetSlotFromType(GearWeapClass));
								`log("tossing"@`showvar(OldInv));
								TossInventory(OldInv);
							}
							else
							{
								// not allowed to replace or not a gearweapon so can't replace this item
								continue;
							}
						}
						// create the new item
						NewInv = InvManager.CreateInventory(InvClass);
// 						`DLog("created" @ `showvar(NewInv));

						if (ClassIsChildOf(InvClass, class'GearShield'))
						{
							EquipShield(GearShield(NewInv));
						}
						// select the new item
						else if (InAction.bForceReplace && GearWeapon(NewInv) != None)
						{
							if (IsCarryingShield())
							{
								DropShield();
							}
							if (!IsLocallyControlled())
							{
								GearWeapon(NewInv).ClientWeaponSet(false);
							}
							else
							{
								InvManager.SetCurrentWeapon(GearWeapon(NewInv));
							}
						}
					}
				}
				else
				{
					InAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
				}
			}
		}
	}

	bAllowInventoryDrops = bOldAllowDrops;
}

simulated function OnHolsterWeapon(SeqAct_HolsterWeapon InAction)
{
	if( InAction.bPutAway )
	{
		HolsterWeapon();
	}
	else
	{
		UnHolsterWeapon();
	}
}


function OnToggleUnlimitedClips( SeqAct_ToggleUnlimitedClips InAction )
{
	if( InAction.InputLinks[0].bHasImpulse )
	{
		SetUnlimitedClips( TRUE );
	}
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		SetUnlimitedClips( FALSE );
	}
	else if( InAction.InputLinks[2].bHasImpulse )
	{
		SetUnlimitedClips( !bUnlimitedClips );
	}
}

function SetUnlimitedClips( bool bSet )
{
	local GearWeapon Weap;

	bUnlimitedClips = bSet;
	ForEach InvManager.InventoryActors(class'GearWeapon', Weap)
	{
		if( bUnlimitedClips )
		{
			Weap.SetInfiniteSpareAmmo();
		}
		else
		{
			Weap.ClearInfiniteSpareAmmo();
		}
	}
}


/**
 * This will make default inventory for TDM games.
 *
 * @see GearGameDM.RestartPlayer()
 **/
function AddDefaultInventoryTDM()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local UIProviderScriptFieldValue WeaponValue;
	local int ProviderIndex;
	local GearGameWeaponSummary WeaponInfo;
	local class<Inventory> InvClass;
	local string PrimaryWeaponClassPath, SecondaryWeaponClassPath;
	local int InitWeaponId;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if (GameResourceDS != None)
	{
		// Find the provider id for the weapon
		WeaponValue.PropertyTag = 'WeaponId';
		WeaponValue.PropertyType = DATATYPE_Property;

		//Primary weapon
		InitWeaponId = GearPRI(PlayerReplicationInfo).InitialPrimaryWeaponType;
		WeaponValue.StringValue = string(InitWeaponId);
		ProviderIndex = GameResourceDS.FindProviderIndexByFieldValue('Weapons', 'WeaponId', WeaponValue);
		// Found it
		if (ProviderIndex != INDEX_NONE)
		{
			WeaponInfo = GameResourceDS.GetWeaponProvider(ProviderIndex);
			if (WeaponInfo.bIsDefaultPrimaryWeapon)
			{
				PrimaryWeaponClassPath = WeaponInfo.ClassPathName;
			}
		}
		// Didn't find it... hardcode the gold weapons, sigh
		else
		{
			if (InitWeaponId == 17)
			{
				PrimaryWeaponClassPath = "GearGameContentWeapons.GearWeap_AssaultRifle_Golden";
			}
			else if (InitWeaponId == 18)
			{
				PrimaryWeaponClassPath = "GearGameContentWeapons.GearWeap_LocustAssaultRifle_Golden";
			}
		}

		//Secondary weapon
		InitWeaponId = GearPRI(PlayerReplicationInfo).InitialSecondaryWeaponType;
		WeaponValue.StringValue = string(InitWeaponId);
		ProviderIndex = GameResourceDS.FindProviderIndexByFieldValue('Weapons', 'WeaponId', WeaponValue);
		// Found it
		if (ProviderIndex != INDEX_NONE)
		{
			WeaponInfo = GameResourceDS.GetWeaponProvider(ProviderIndex);
			if (WeaponInfo.bIsDefaultSecondaryWeapon)
			{
				SecondaryWeaponClassPath = WeaponInfo.ClassPathName;
			}
		}
		// Didn't find it... hardcode the gold weapons, sigh
		else
		{
			if (InitWeaponId == 17)
			{
				SecondaryWeaponClassPath = "GearGameContentWeapons.GearWeap_AssaultRifle_Golden";
			}
			else if (InitWeaponId == 18)
			{
				SecondaryWeaponClassPath = "GearGameContentWeapons.GearWeap_LocustAssaultRifle_Golden";
			}
		}
	}

	// use the selected value from the PRI
	if (PrimaryWeaponClassPath != "")
	{
		InvClass = class<Inventory>(FindObject(PrimaryWeaponClassPath, class'Class'));
		if ( InvClass != None )
		{
			CreateInventory(InvClass, false);
		}
		else
		{
			CreateInventory(class'GearWeap_AssaultRifle', false);
		}
	}
	else
	{
		CreateInventory(class'GearWeap_AssaultRifle', false);
	}

	// use the selected value from the PRI
	if (SecondaryWeaponClassPath != "")
	{
		InvClass = class<Inventory>(FindObject(SecondaryWeaponClassPath, class'Class'));
		if ( InvClass != None )
		{
			CreateInventory(InvClass, true);
		}
		else
		{
			CreateInventory(class'GearWeap_Shotgun', true);
		}
	}
	else
	{
		CreateInventory(class'GearWeap_Shotgun', true);
	}

	CreateInventory(class'GearWeap_COGPistol', true);
}

/**
 * We override this as we have pawns leaning out of cover and their view location is really where
 * they are peeking out from.  We are using the NeckBone location as that is what we are using in other
 * parts of the code.  We should probably make a more general socket based mechanic for this.
 **/
simulated native event Vector GetPawnViewLocation();

/**
 * Don't calculate sniper muzzle based off mesh data anymore since that system is noisy
 *
 * @param GW - the weapon
 *
 * @param MuzzleLoc - the calculated muzzle location
 */
simulated function CalcScopedWeaponMuzzleLoc(GearWeapon GW, out vector MuzzleLoc)
{
	local vector FPSOffset;

	//local vector FPS;
	//SkeletalMeshComponent(GW.Mesh).GetSocketWorldLocationAndRotation('FirstPersonView', FPS);
	//`log(`showvar((FPS-Location) << Rotation));

	if (!IsInCover())
	{
		FPSOffset = GW.FPSOffset_NoCover;
	}
	else if (CoverAction == CA_LeanLeft)
	{
		if (CoverType == CT_MidLevel)
		{
			FPSOffset = GW.FPSOffset_LeanLeft_MidLevel;
		}
		else
		{
			FPSOffset = GW.FPSOffset_LeanLeft_Standing;
		}
	}
	else if (CoverAction == CA_LeanRight)
	{
		if (CoverType == CT_MidLevel)
		{
			FPSOffset = GW.FPSOffset_LeanRight_MidLevel;
		}
		else
		{
			FPSOffset = GW.FPSOffset_LeanRight_Standing;
		}
	}
	else if (bDoing360Aiming)
	{
		if (CoverType == CT_MidLevel)
		{
			FPSOffset = GW.FPSOffset_360Aim_MidLevel;
		}
		else
		{
			FPSOffset = GW.FPSOffset_360Aim_Standing;
		}
	}
	else
	{
		if (!bIsMirrored)
		{
			FPSOffset = GW.FPSOffset_Popup_NotMirrored;
		}
		else
		{
			FPSOffset = GW.FPSOffset_Popup_Mirrored;
		}
	}

	MuzzleLoc = Location + (FPSOffset >> Rotation);

	//DrawDebugSphere(MuzzleLoc, 10, 10, 255, 0, 0, TRUE);
}

/**
 * @PARAM GW is the gear weapon for which location is being found
 * @PARAM AimDir is the direction pawn is aiming
 * @PARAM bForcePullIn if true always pull final location into collision cylinder
 * @RETURNS muzzle location, pulled into pawn's collision cylinder along -AimDir
 *
 */
final simulated event vector GetPulledInMuzzleLocation(GearWeapon GW, vector AimDir, optional bool bForcePullIn)
{
	local float MuzzleDist;
	local vector MuzzleLoc, PulledInMuzzleLoc, ExtraPullIn, HitLocation, HitNormal;
	local actor HitActor;

	// hack for sniper rifle to put first person camera and shot origin
	// at a nice spot.	here, we're putting at the front of the scope, which
	// minimizes obvious aim error shooting downward and still makes it so that
	// a player must expose himself at least somewhat to snipe
	if ((GW.bIsScopeWeapon && bIsZoomed) || GearWeap_HeavySniperBase(GW) != None)
	{
		if (GearWeap_HeavySniperBase(GW) != None)
		{
			SkeletalMeshComponent(GW.Mesh).GetSocketWorldLocationAndRotation('FirstPersonView', MuzzleLoc);
		}
		else
		{
			CalcScopedWeaponMuzzleLoc(GW, MuzzleLoc);
		}

		MuzzleDist = VSize2D(MuzzleLoc - Location);

		if (bForcePullin || !GW.UseFirstPersonCamera())
		{
			return MuzzleLoc - MuzzleDist * AimDir;
		}
		else
		{
			// make sure this position isn't clipping into a wall
			HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, MuzzleLoc, MuzzleLoc - MuzzleDist * AimDir, false,vect(12,12,12),,TRACEFLAG_Bullet);
			return (HitActor == None) ? MuzzleLoc : HitLocation;
		}
	}

	MuzzleLoc = GetPhysicalFireStartLoc( ((GW != None) ? GW.FireOffset : vect(0,0,8)) );

	// is muzzle outside pawn's collision cylinder?
	MuzzleDist = VSize2D(MuzzleLoc - Location);
	if ( MuzzleDist > CylinderComponent.CollisionRadius )
	{
		// pull MuzzleLoc back toward cylinder
		PulledInMuzzleLoc = MuzzleLoc - MuzzleDist * AimDir;
		MuzzleDist = VSize2D(PulledInMuzzleLoc - Location);
		if ( bForcePullIn ||  MuzzleDist < CylinderComponent.CollisionRadius )
		{
			MuzzleLoc = PulledInMuzzleLoc;
		}
		else
		{
			// only pull in if needed!
			HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, PulledInMuzzleLoc, Location, false,,,TRACEFLAG_Bullet);
			if ( HitActor != None )
			{
				ExtraPullIn = Location - PulledInMuzzleLoc;
				ExtraPullIn.Z = 0;
				ExtraPullIn = (2.0 + MuzzleDist - CylinderComponent.CollisionRadius) * Normal(ExtraPullIn);
			}
			MuzzleLoc = PulledInMuzzleLoc + ExtraPullIn;
		}
	}

	return MuzzleLoc;
}

simulated function SetWeaponStartTraceLocationCache(Weapon ValidWeap, Vector StartLoc)
{
	WeaponStartTraceLocationCache.bUpToDate=true;
	WeaponStartTraceLocationCache.StartLoc = StartLoc;
	WeaponStartTraceLocationCache.WeaponCacheIsValidFor = ValidWeap;
}

//`define GetWeaponStartTraceLocationPerf
`if(`isdefined(GetWeaponStartTraceLocationPerf))
`define	CClock(Time) Clock(`Time)
`define CUnClock(Time) UnClock(`Time)
`else
`define CUnClock(Time)
`define	CClock(Time)
`endif
/**
 * Return world location to start a weapon fire trace from.
 *
 * @return	World location where to start weapon fire traces from
 */
simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	local GearWeapon GW;
	local vector MuzzleLoc, StartLoc, EndTrace, HitLocation, HitNormal, AimDir;
	local Actor HitActor;
	local GearPC GPC;
	local float SmallTraceDist;
	local vector	POVLoc;
	local rotator	POVRot;

	`if(`isdefined(GetWeaponStartTraceLocationPerf))
		local float Overall,SumTotal;
		local float Time[20];
		local int Idx;
	`endif

	`CClock(Overall);
	`CClock(Time[0]);
	if(WeaponStartTraceLocationCache.bUpToDate && WeaponStartTraceLocationCache.WeaponCacheIsValidFor == CurrentWeapon)
	{
		return WeaponStartTraceLocationCache.StartLoc;
	}

	// if not owned by a human player shoot from weapon muzzle
	if( !IsHumanControlled(Controller) )
	{
		StartLoc = super.GetWeaponStartTraceLocation();
		SetWeaponStartTraceLocationCache(CurrentWeapon,StartLoc);
		return StartLoc;
	}

	if (CurrentWeapon != None)
	{
		GW = GearWeapon(CurrentWeapon);
	}
	if (GW == None)
	{
		GW = MyGearWeapon;
	}

	if (GW == None)
	{
		StartLoc = super.GetWeaponStartTraceLocation();
		SetWeaponStartTraceLocationCache(CurrentWeapon,StartLoc);
		return StartLoc;
	}

	GPC = GearPC(Controller);

	if ( GW.UseFirstPersonCamera() )
	{
		MuzzleLoc = GetPulledInMuzzleLocation(GW, vector(GPC.Rotation));

		SetWeaponStartTraceLocationCache(CurrentWeapon,MuzzleLoc);
		return MuzzleLoc;
	}
	`CUnClock(Time[0]);
	`CClock(Time[1]);
	// Replaced the SUPER call with this logic because the base class assumes Controller is controlling this pawn when it might not be
	if (GPC != none)
	{
		GPC.GetPlayerViewPoint( POVLoc, POVRot );
		StartLoc = POVLoc;
	}
	else
	{
		StartLoc = super.GetWeaponStartTraceLocation();
	}
	`CUnClock(Time[1]);
	if( GPC != None )
	{
		`CClock(Time[2]);
		AimDir = vector(GetAdjustedAimFor(GW, StartLoc));
		`CUnClock(Time[2]);
		`CClock(Time[8]);
		StartLoc = GW.AdjustStartTraceLocation(StartLoc, AimDir);		// see if the Weapon wants to tweak it
		`CUnClock(Time[8]);
		`CClock(Time[9]);
		MuzzleLoc = GetPulledInMuzzleLocation(GW, AimDir);
		`CUnClock(Time[9]);


		`CClock(Time[3]);
		// first check to see if there is something intervening camera -> muzzle
		SmallTraceDist = VSize(StartLoc - MuzzleLoc);
		HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, StartLoc + AimDir * SmallTraceDist, StartLoc, true,,,TRACEFLAG_Bullet);
		`CUnClock(Time[3]);
		`CClock(Time[4]);
		if (Pawn(HitActor) != None)
		{
			// adjust the trace forward to avoid this case
			StartLoc = StartLoc + AimDir * SmallTraceDist;
		}
		else
		// if shooting from the hip or blindfiring then always shoot from the muzzle
		if ( !GW.bAlwaysTraceFromPlayerView && ( !bIsTargeting || IsBlindFiring(CoverAction) ) )
		{
			StartLoc = MuzzleLoc;
		}
		else
		if ( !IsInCover() && IsAttemptingToShootThroughWall(GW,StartLoc + (AimDir * ShootingThroughWallTraceDistance)) )
		{
			`CUnClock(Time[4]);
			`CClock(Time[5]);
			// if not in cover, only do corrected trace if can successfully trace from weapon muzzle
			EndTrace = StartLoc + AimDir * GW.GetTraceRange();
			HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartLoc, false,,,TRACEFLAG_Bullet);
			`CUnClock(Time[5]);

			`CClock(Time[6]);
			if ( HitActor != None )
			{
				EndTrace = HitLocation - AimDir * 32;
			}

			HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, MuzzleLoc, false,,,TRACEFLAG_Bullet);

			StartLoc = (HitActor == None) ? StartLoc : MuzzleLoc;
			`CUnClock(Time[6]);
		}
		else
		{
			`CUnClock(Time[4]);
			`CClock(Time[7]);
			// in cover, pull in muzzle location only if it allows you to hit close proximity enemy
			HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, MuzzleLoc + 128*AimDir, MuzzleLoc, true,,,TRACEFLAG_Bullet);
			if (Pawn(HitActor) != None && !IsSameTeam(Pawn(HitActor)))
			{
				StartLoc = MuzzleLoc;
			}
			`CUnClock(Time[7]);
		}
	}
	`CUnClock(Overall);
	`if(`isdefined(GetWeaponStartTraceLocationPerf))
		`log(GetFuncName()@"STATS _--------------------------------------------------_");
		for(Idx=0;Idx<20;Idx++)
		{
			`log(GetFuncName()@" -- STAT ["$Idx$"]"@Time[Idx]@"("@(Time[Idx]/Overall)*100.f@"%)");
			SumTotal += Time[Idx];
		}
		`log(GetFuncName()@"TOTALS --------------- Overall:"@Overall@"Error:"@Abs(Overall-SumTotal));
	`endif
	SetWeaponStartTraceLocationCache(CurrentWeapon,StartLoc);
	return StartLoc;
}


/**
 * This will check to see if the pawn is attempting to shoot through a wall.
 * It takes the Muzzle Location and then pulls back down the weapon length.	 And then traces forward
 * the distance of the pull back plus an amount which will catch "angle" / "wall shooter" players.
 *
 * Using this also stops the shooting something at a distances and having the angle of the
 * shot be different from where you are aiming such that your bullets will impact the wall even
 * tho you have a clear shot at the target with the reticle.
 *
 * There are still issues with too wide walls when you are shooting downwards.	(solution is to
 * reduce the width of that cover.	(c.f. mp_escalation)
 *
 * Overall this will stop most of the egregious "I should be able to shoot like this"
 **/
final simulated function bool IsAttemptingToShootThroughWall( GearWeapon GW, vector EndPoint )
{
	local vector HitLocation, HitNormal;
	local Actor HitActor;
	local float ToWallDistance,PullBackDistance;
	local vector EndTrace, StartTrace;
	local vector Loc, Dir;
	local rotator Rot;

	// grenades don't have a muzzle and use a simulated grenade projectile
	if( GearWeap_GrenadeBase(GW) == none && GW != None )
	{
		PullBackDistance = 100.0f;
		ToWallDistance = PullBackDistance + ShootingThroughWallTraceDistance;

		GW.GetMuzzleLocAndRot(Loc,Rot);
		Dir = Normal(EndPoint - Loc);
		StartTrace = Loc + (Dir * -PullBackDistance); // X is pointing forward always
		EndTrace = StartTrace + (Dir * ToWallDistance);

		// if we hit something close that means bullets coming from our gun would have hit something
		HitActor = GW.GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, false,,,TRACEFLAG_Bullet);

		if( HitActor == None )
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}
	else
	{
		return FALSE;
	}
}

simulated function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	// If controller doesn't exist, get the where the Pawn is aiming at
	if (Controller == None)
	{
		return GetBaseAimRotation();
	}

	// otherwise, give a chance to controller to adjust this Aim Rotation
	return Controller.GetAdjustedAimFor( W, StartFireLoc );
}

/************************************************************************************
 * Interactions
 ***********************************************************************************/

/**
 * Check to see if there is any Pawn around us that we can perform an Interaction with.
 * This function will stop at first valid interaction found.
 * For Human Players, called from ServerUse() function.
 *
 * Returns TRUE if an Interaction has been found.
 * @param	out_SpecialMove		Found special move (interaction)
 * @param	out_InteractionPawn	Found Pawn to perform interaction with.
 * @param bReducedRadius (opt)	If set, reduce check radius ( for HUD checks so we don't show the icon when hovering on the edge,
 * 								minimizing undesired actions due to replication delay )
 */
final simulated function bool CheckPawnToPawnInteractions(out ESpecialMove out_SpecialMove, out GearPawn out_InteractionPawn, optional bool bReducedRadius)
{
	local Actor 		HitA;
	local GearPawn		FoundPawn;
	local ESpecialMove	InteractionSM;
	local vector 		HitL, HitN;
	local bool			bInteractionObstructed;

	// Check for Nearby Pawns
	foreach WorldInfo.AllPawns(class'GearPawn', FoundPawn, Location, bReducedRadius ? 140.0 : 175.0)
	{
		// Make sure FoundPawn is in a state that can be interacted with
		// This is kept relatively simple, so the SpecialMove's CanInteractWith() function implements all the specifics
		if( FoundPawn == Self || FoundPawn.bDeleteMe || FoundPawn.bPlayedDeath )
		{
			continue;
		}

		// Iterate through all possible Pawn to Pawn interactions
		bInteractionObstructed = FALSE;
		foreach PawnToPawnInteractionList(InteractionSM)
		{
			// See if we can perform an interaction with this Pawn
			if( CanDoSpecialMovePawnInteraction(InteractionSM, FoundPawn) )
			{
				// verify no intervening geometry
				//@note - delayed until we have a successful interaction since this will be the most expensive portion
				foreach TraceActors(class'Actor', HitA, HitL, HitN, FoundPawn.Location, Location, vect(16,16,16))
				{
					if (HitA != FoundPawn && HitA.bBlockActors)
					{
						//`log(self@GetFuncName()@"interaction obstructed to"@`showvar(FoundPawn)@"due to"@`showvar(HitA));
						bInteractionObstructed = TRUE;
						break;
					}
				}
				if (!bInteractionObstructed)
				{
					// Found an interaction!
					out_InteractionPawn = FoundPawn;
					out_SpecialMove		= InteractionSM;
					return TRUE;
				}
				else
				{
					// since the interaction is now obstructed skip further checks
					break;
				}
			}
		}
	}

	return FALSE;
}


/**
 * See if a Special Move Pawn To Pawn Interaction can be done.
 */
final simulated function bool CanDoSpecialMovePawnInteraction(ESpecialMove InSpecialMove, GearPawn InInteractionPawn)
{
	// Make sure the weapon (if there is one) isn't marked as no interactions
	if ( MyGearWeapon != None && MyGearWeapon.bNoInteractionWhileEquipped )
	{
		return FALSE;
	}

	// Make sure special move has been instanced.
	VerifySMHasBeenInstanced(InSpecialMove);

	return (SpecialMoves[InSpecialMove].CanInteractWithPawn(InInteractionPawn) && CanDoSpecialMove(InSpecialMove));
}

/**
 * Start a Pawn to Pawn interaction.
 * @param	InSpecialMove		SpecialMove to do (interaction)
 * @param	InInteractionPawn	Pawn to do interaction with.
 */
final reliable server function DoPawnToPawnInteraction(ESpecialMove InSpecialMove, GearPawn InInteractionPawn, optional bool bForceMove)
{
	`logSM(InSpecialMove @ "InteractionPawn:" @ InInteractionPawn);

	// Verify that we can do the Interaction on the server
	if( bForceMove || CanDoSpecialMovePawnInteraction(InSpecialMove, InInteractionPawn) )
	{
		ServerDoSpecialMove(InSpecialMove, bForceMove, InInteractionPawn);
	}
	else
	{
		`logSM(WorldInfo.TimeSeconds @ Self @ InSpecialMove @ "CanDoSpecialMovePawnInteraction failed!");
	}
}

/** RPC so the server can eject the wretch */
reliable server function ServerShakeOffWretch()
{
	if (InteractionPawn != None && !InteractionPawn.bPlayedDeath)
	{
		InteractionPawn.TearOffMomentum = vect(0,0,1);
		InteractionPawn.Died(Controller, class'GDT_Melee', InteractionPawn.Location);
	}
}

/************************************************************************************
 * CQC (Close Quarter Combat)
 ***********************************************************************************/

reliable server function ServerDoCQCMove(ESpecialMove WhichSpecialMove, optional int Variant)
{
	if( WhichSpecialMove == SM_CQCMove_PunchFace )
	{
		if( IsCarryingShield() )
		{
			if( CanDoSpecialMove(SM_CQCMove_Shield) )
			{
				ServerDoSpecialMove(SM_CQCMove_Shield, TRUE, GSM_CQC_Killer_Base(SpecialMoves[SM_CQCMove_Shield]).Follower);
			}
		}
		else
		{
			if( CanDoSpecialMove(SM_CQCMove_PunchFace) )
			{
				// cannot do arm rip without gore
				if ((Variant == 1 || Variant == 2) && GSM_CQC_Killer_Base(SpecialMoves[SM_CQCMove_PunchFace]).Follower.GoreSettings == None)
				{
					Variant = 0;
				}
				ServerDoSpecialMove(SM_CQCMove_PunchFace, TRUE, GSM_CQC_Killer_Base(SpecialMoves[SM_CQCMove_PunchFace]).Follower,Variant);
			}
		}
		return;
	}
	else if (WhichSpecialMove == SM_CQCMove_CurbStomp)
	{
		if( CanDoSpecialMove(SM_CQCMove_CurbStomp) )
		{
			ServerDoSpecialMove(SM_CQCMove_CurbStomp, TRUE, GSM_CQC_Killer_Base(SpecialMoves[SM_CQCMove_CurbStomp]).Follower);
		}
	}
}

/**
 * Are we allowing this Pawn to be based on us?
 * Allow Interaction Pawns to be based, since we do a lot of attachment stuff there.
 * @note: Made simulated so locally owned client hostages don't switch to PHYS_Falling making them lose their base.
 */
simulated function bool CanBeBaseForPawn(Pawn APawn)
{
	return bCanBeBaseForPawns || (InteractionPawn == APawn);
}


/************************************************************************************
 * Special Moves
 ***********************************************************************************/

// Retrieve "CurrentSlotIdx" by picking one closest to current slot pct
final simulated function int GetSlotIdxByPct()
{
	if( CurrentSlotPct < 0.5f )
	{
		return LeftSlotIdx;
	}

	return RightSlotIdx;
}


/** Make sure a special move has been instanced */
simulated final function bool VerifySMHasBeenInstanced(ESpecialMove AMove)
{
	if( AMove != SM_None )
	{
		if( AMove >= SpecialMoves.Length || SpecialMoves[AMove] == None )
		{
			if( AMove < SpecialMoveClasses.Length && SpecialMoveClasses[AMove] != None )
			{
				SpecialMoves[AMove] = new(Outer) SpecialMoveClasses[AMove];

				// Cache a reference to the owner to avoid passing parameters around.
				SpecialMoves[AMove].PawnOwner = Self;
			}
			else
			{
				`log(GetFuncName() @ "Failed with special move:" @ AMove @ "class:" @ SpecialMoveClasses[AMove] @ Self);
				SpecialMoves[AMove] = None;
				return FALSE;
			}
		}
		return TRUE;
	}
	return FALSE;
}


/**
 * Convenience function which takes special move params and returns a SMStruct.
 */
simulated final function SMStruct FillSMStructFromParams(ESpecialMove InSpecialMove, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags=0)
{
	local SMStruct	OutSpecialMoveStruct;

	OutSpecialMoveStruct.SpecialMove = InSpecialMove;
	OutSpecialMoveStruct.InteractionPawn = InInteractionPawn;
	OutSpecialMoveStruct.Flags = InSpecialMoveFlags;

	return OutSpecialMoveStruct;
}

/** Convenience function to spit out a SpecialMoveStruct into a String */
simulated final function String SMStructToString(SMStruct InSMStruct)
{
	return "[SpecialMove:" @ InSMStruct.SpecialMove $ ", InteractionPawn:" @ InSMStruct.InteractionPawn $ ", SpecialMoveFlags:" @ InSMStruct.Flags$"]";
}

simulated final function String SpecialMoveToString(ESpecialMove InSpecialMove, GearPawn InInteractionPawn, INT InSpecialMoveFlags)
{
	return "[SpecialMove:" @ InSpecialMove $ ", InteractionPawn:" @ InInteractionPawn $ ", SpecialMoveFlags:" @ InSpecialMoveFlags $ "]";
}

/**
 * Start a special move.
 * @Note this doesn't handle replication to owning client if called from server.
 * See ServerDoSpecialMove() and LocalDoSpecialMove() for alternatives.
 * @network: local player and server
 */
simulated event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags, optional bool bSkipReplication)
{
	local ESpecialMove	PrevMove, NextMove;
	local SMStruct		NewMoveStruct;

	`LogSM("New special move requested:" @ SpecialMoveToString(NewMove, InInteractionPawn, InSpecialMoveFlags) @ "bForceMove:" @ bForceMove);

	// Make sure NewMove is instanced.
	if( NewMove != SM_None && !VerifySMHasBeenInstanced(NewMove) )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "couldn't instance special move" @ NewMove);
		return;
	}

	// Create struct for new move.
	NewMoveStruct = FillSMStructFromParams(NewMove, InInteractionPawn, InSpecialMoveFlags);

	// If we are starting our pending special move, clear pending move struct
	if( bIsPendingMove )
	{
		`LogSM("- PendingSpecialMove is being started.");
		PendingSpecialMoveStruct = FillSMStructFromParams(SM_None, None, 0);
	}

	// Ignore redundant calls to the same move
	if( NewMove == SpecialMove )
	{
		if( NewMove != SM_None && InSpecialMoveFlags != SpecialMoveFlags )
		{
			`LogSM("- updating special move flags");
			SpecialMoveFlags = InSpecialMoveFlags;
			if (Role == ROLE_Authority && !bSkipReplication)
			{
				ReplicatedSpecialMoveStruct.Flags = SpecialMoveFlags;
				bForceNetUpdate = true;
			}
			SpecialMoves[NewMove].SpecialMoveFlagsUpdated();
		}

		// In JIP situations, InteractionPawn will show up late
		if (InInteractionPawn != InteractionPawn)
		{
			`LogSM("- updating interaction pawn");
			InteractionPawn = InInteractionPawn;
		}

		`LogSM("- ignoring redundant call");
		return;
	}

	if( Role == ROLE_Authority )
	{
		// Store how much time we ran if we are ending roadie run
		if (SpecialMove == SM_RoadieRun)
		{
			// @STATS - Roadie Run End
			`RecordPlayerIntStat(ROADIE_RUN_END, Controller, 0);
		}
	}

	// If we're currently in the process of ending the current move
	if( bEndingSpecialMove )
	{
		// Then force the new request to pending
		`LogSM("- bEndingSpecialMove, setting" @ NewMove @ "as pending specialmove, previous PendingSpecialMove:" @ SMStructToString(PendingSpecialMoveStruct));
		PendingSpecialMoveStruct = NewMoveStruct;
		return;
	}

	// If doing a special move transition, see if we can have an override or a chaining.
	if( !bIsPendingMove && !bForceMove && SpecialMove != SM_None && NewMove != SM_None )
	{
		// See if we can override current special move, otherwise just queue new one until current is finished.
		if( SpecialMoves[SpecialMove].CanOverrideMoveWith(NewMove) || SpecialMoves[NewMove].CanOverrideSpecialMove(SpecialMove) )
		{
			bForceMove = TRUE;
			`LogSM("- Overriding" @ SpecialMove @ "with" @ NewMove @ "(previous pending:" @ SMStructToString(PendingSpecialMoveStruct) $ ")");
		}
		else
		{
			// extra check to see if we can chain since non-owning clients can call DoSpecialMove directly in certain cases
			if( SpecialMoves[SpecialMove].CanChainMove(NewMove) )
			{
				`LogSM("- chaining" @ NewMove @ "after" @ SpecialMove @ "(previous pending:" @ SMStructToString(PendingSpecialMoveStruct) $ ")");
				PendingSpecialMoveStruct = NewMoveStruct;
			}
			else
			{
				`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Cannot override, cannot chain." @ NewMove @ "is lost! SpecialMove:" @ SpecialMove @ "Pending:" @ SMStructToString(PendingSpecialMoveStruct) );
			}
			return;
		}
	}

	// Check that we can do special move and special move has been/can be instanced
	if( NewMove != SM_None && !bForceMove && !CanDoSpecialMove(NewMove) )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "cannot do requested special move" @ NewMove);
		return;
	}

	PrevMove = SpecialMove;

	// Stop previous special move
	if( SpecialMove != SM_None )
	{
		if( !bIsPendingMove )
		{
			`LogSM("- leaving move:" @ SpecialMove);
			bEndingSpecialMove = TRUE;
			// clear the special move so that checks like IsDoingSpecialMove and IsEvading no longer pass
			SpecialMove = SM_None;
			SpecialMoveEnded(PrevMove, NewMove);
			bEndingSpecialMove = FALSE;
			// If we're waiting for a special move to end to enter DBNO, try it now.
			if (Role == ROLE_Authority && bDelayedDBNO)
			{
				EnterDBNO(ControllerWhoPutMeDBNO, DamageTypeThatPutMeDBNO, MomentumThatPutMeDBNO);

				// if we're in DBNO, don't let it get clobbered.
				if (SpecialMove == SM_DBNO || SpecialMove == SM_Gunked)
				{
					return;
				}
			}
		}
		else
		{
			`LogSM("- Skip SpecialMoveEnded for" @ SpecialMove @ "as we're starting PendingSpecialMove" @ NewMoveStruct.SpecialMove);
		}
	}

	// If we're ending a specialmove, and we have a pending one. Start it now.
	if( NewMove == SM_None && PendingSpecialMoveStruct.SpecialMove != SM_None )
	{
		`LogSM("- triggering pending special move:" @ SMStructToString(PendingSpecialMoveStruct));
		// Restore SpecialMove so we can track PrevMove properly when calling DoSpecialMove() again.
		SpecialMove = PrevMove;
		NextMove = PendingSpecialMoveStruct.SpecialMove;

		bIsPendingMove = TRUE;
		SpecialMoves[PendingSpecialMoveStruct.SpecialMove].LastCanDoSpecialMoveTime = WorldInfo.TimeSeconds - 1.0; // make sure we do a fresh check
		DoSpecialMoveFromStruct(PendingSpecialMoveStruct);
		bIsPendingMove = FALSE;

		if( SpecialMove == NextMove )
		{
			`LogSM("- PendingSpecialMove trigger successful for" @ NextMove);
			// success, we can leave
			return;
		}
		else
		{
			`LogSM("- PendingSpecialMove trigger failed for" @ NextMove @ "Proceeding to clear SpecialMove");
		}
	}

	// Set new special move
	`LogSM( SMStructToString(NewMoveStruct) );
	SpecialMove = NewMoveStruct.SpecialMove;
	InteractionPawn = NewMoveStruct.InteractionPawn;
	SpecialMoveFlags = NewMoveStruct.Flags;
//   	ScriptTrace();

	if ( !bSkipReplication &&
		 (((WorldInfo.NetMode != NM_Standalone || WorldInfo.IsRecordingDemo()) && Role == ROLE_Authority) &&
		  (SpecialMove == SM_None || SpecialMoves[SpecialMove].ShouldReplicate())) )
	{

		`LogSM("- Replicating New SM" @ SMStructToString(NewMoveStruct));

		// Force replication now to non-owning clients
		// If previous replicated SM and new one are the SM,
		// we have to make sure something is different so it is correctly replicated.
		if( ReplicatedSpecialMoveStruct.SpecialMove == NewMoveStruct.SpecialMove )
		{
			// If SM_None, we can just bump up the flags, they don't matter in that case.
			if( ReplicatedSpecialMoveStruct.SpecialMove == SM_None )
			{
				ReplicatedSpecialMoveStruct.Flags++;
			}
			else if( ReplicatedSpecialMoveStruct.InteractionPawn == NewMoveStruct.InteractionPawn
				&& ReplicatedSpecialMoveStruct.Flags == NewMoveStruct.Flags )
			{
				// Huston we have have a problem, this special move is not going to be replicated properly!!
				// Report an error, so it can be fixed.
				`Warn("Special Move cannot be replicated properly!!!");
				`Warn(" Old SM:" @ SMStructToString(ReplicatedSpecialMoveStruct) );
				`Warn(" New SM:" @ SMStructToString(ReplicatedSpecialMoveStruct) );
				ScriptTrace();
			}
			else
			{
				// SMs are different, so they can be replicated properly.
				ReplicatedSpecialMoveStruct = NewMoveStruct;
			}
		}
		else
		{
			// SMs are different, so they can be replicated properly.
			ReplicatedSpecialMoveStruct = NewMoveStruct;
		}
		bForceNetUpdate = TRUE;
	}

	// Notification of a special move state change.
	SpecialMoveAssigned(SpecialMove, PrevMove);

	// if it's a valid special move
	if( SpecialMove != SM_None )
	{
		// notify the special move it should start
		SpecialMoveStarted(SpecialMove, PrevMove, bForceMove);

		// if this was a forced move clear any pending moves since this was an interrupt of the current move
		if( bForceMove )
		{
			PendingSpecialMoveStruct = FillSMStructFromParams(SM_None, None, 0);
		}
		// track the event for feedback
		if (WorldInfo.NetMode != NM_Client)
		{
			if (SpecialMove == SM_RoadieRun)
			{
				//@STATS - Record Roadie Run Start
				`RecordPlayerIntStat(ROADIE_RUN_START, Controller, 0);
			}

			//@STATS - Record Generic Special Move
			//`RecordPlayerSpecialMoveEvent(PLAYER_SPECIAL_MOVE,Controller,SpecialMove,PendingSpecialMoveStruct.InteractionPawn != None ? PendingSpecialMoveStruct.InteractionPawn.Controller : None);
		}
	}
}

/**
 * Convenience function that takes a SpecialMoveStruct, and calls DoSpecialMove() from its parameters.
 */
simulated final function DoSpecialMoveFromStruct(SMStruct InSpecialMoveStruct, optional bool bForceMove)
{
	DoSpecialMove(InSpecialMoveStruct.SpecialMove, bForceMove, InSpecialMoveStruct.InteractionPawn, InSpecialMoveStruct.Flags);
}

/**
 * Have a locally controlled Pawn start a special move.
 * PlayerControllers will automatically replicate the move to the server. Will then be replicated to ALL.
 * AI is already executing those on the server, so they're all replicated.
 */
simulated function LocalDoSpecialMove(ESpecialMove NewMove, optional bool bForceMove=FALSE, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags=0 )
{
	if( !IsLocallyControlled() )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "not called on a locally controlled Pawn!" @ NewMove);
		ScriptTrace();
		return;
	}

	if( bForceMove || CanDoSpecialMove(NewMove) )
	{
		if( Controller.IsA('GearPC') )
		{
			GearPC(Controller).DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags);
		}
		else
		{
			DoSpecialMove(NewMove, TRUE, InInteractionPawn, InSpecialMoveFlags);
		}
	}
	else
	{
		`logSM("Couldn't start SpecialMove:" @ NewMove);
	}
}

/** Start a SpecialMove on the Server, and have it locally replicated to owning client. */
simulated function ServerDoSpecialMove(ESpecialMove NewMove, optional bool bForceMove=FALSE, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags=0, optional ESpecialMove SMToChain)
{
	`logSM( SpecialMoveToString(NewMove, InInteractionPawn, InSpecialMoveFlags) );

	if( WorldInfo.NetMode == NM_Client && !bTearOff )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "called on client!!" @ NewMove);
		ScriptTrace();
		return;
	}

	if( bForceMove || CanDoSpecialMove(NewMove) )
	{
		if( GearPC(Controller) != None )
		{
			GearPC(Controller).ServerDictateSpecialMove(NewMove, InInteractionPawn, InSpecialMoveFlags);
		}
		else
		{
			DoSpecialMove(NewMove, TRUE, InInteractionPawn, InSpecialMoveFlags);
		}
		if (SMToChain != SM_None)
		{
			DoSpecialMove(SMToChain,FALSE);
		}
	}
	else
	{
		`logSM("Couldn't start SpecialMove:" @ NewMove);
	}
}

/**
 * Return TRUE if Special Move can be performed
 * @param bForceCheck - Allows you to skip the single frame condition (which will be incorrect on clients since LastCanDoSpecialMoveTime isn't replicated)
 */
simulated final event bool CanDoSpecialMove(ESpecialMove AMove, optional bool bForceCheck)
{
	// Can always end special moves.
	if( AMove == SM_None )
	{
		return TRUE;
	}

	// if it is a valid move and we have a class for the move
	if (Physics != PHYS_RigidBody && AMove != SM_None && SpecialMoveClasses.length > AMove && SpecialMoveClasses[AMove] != None)
	{
		// Make sure special move is instanced
		if( VerifySMHasBeenInstanced(AMove) )
		{
			// and check the instance
			return (CanChainSpecialMove(AMove) && SpecialMoves[AMove].CanDoSpecialMove(bForceCheck));
		}
		`log(GetFuncName() @ "Failed with special move:" @ AMove @ "class:" @ SpecialMoveClasses[AMove] @ Self);
	}
	return FALSE;
}


/** Returns TRUE if player is current performing AMove. */
simulated final native noexport function bool IsDoingSpecialMove(ESpecialMove AMove) const;

/** Returns TRUE if Pawn is doing a special move */
simulated final native function bool IsDoingASpecialMove() const;

simulated final native function bool IsDoingMeleeHoldSpecialMove() const;

/** Returns TRUE if player is current performing a Special Melee Attack Move. */
simulated final native function bool IsDoingSpecialMeleeAttack() const;

/** Returns TRUE if player is current performing a Special Melee Attack Move. */
simulated final native function bool IsSpecialMeleeVictim() const;

// use native versions
simulated event GetActorEyesViewPoint( out vector out_Location, out Rotator out_Rotation )
{
	out_Location = GetPawnViewLocation();
	out_Rotation = GetViewRotation();
}

/** Returns TRUE if the pawn can chain this special move after the current one finishes (or if there currently isn't a special move) */
simulated final function bool CanChainSpecialMove(ESpecialMove NextMove)
{
	return (SpecialMove == SM_None || SpecialMoves[SpecialMove].CanChainMove(NextMove) || SpecialMoves[SpecialMove].CanOverrideMoveWith(NextMove) || SpecialMoves[NextMove].CanOverrideSpecialMove(SpecialMove));
}


/************************************************************************************
 * Trigger Mashing MiniGame
 ***********************************************************************************/

/**
 * Begin Trigger Mashing Mini-game
 */
simulated function TriggerMiniGameStartNotification()
{
	// Reset button presses.
	DuelingMiniGameButtonPresses = 0;

	// Start dueling mini game
	bInTriggerMiniGame = TRUE;
}

/**
 * End Trigger Mashing Mini-game
 */
simulated function TriggerMiniGameEndNotification()
{
	// Stop dueling mini game
	// We can't mash the buttom anymore.
	bInTriggerMiniGame = FALSE;
}

/** Every time a trigger is pressed */
simulated function ReportTriggerPressMiniGame(bool bRightTriggerPressed)
{
	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "bRightTriggerPressed:" @ bRightTriggerPressed @ "bLastTriggerPressedIsRight:" @ bLastTriggerPressedIsRight);

	// If alternating, then report the button press
	if( bLastTriggerPressedIsRight != bRightTriggerPressed )
	{
		ReportDuelingMiniGameButtonPress();
	}
	bLastTriggerPressedIsRight = bRightTriggerPressed;
}

/************************************************************************************
 * Dueling
 ***********************************************************************************/

/** Returns TRUE if Pawn is chainsaw dueling. */
simulated final function bool IsChainsawDueling()
{
	if( bInDuelingMiniGame )
	{
		return TRUE;
	}

	switch( SpecialMove )
	{
		case SM_ChainsawDuel_Leader :
		case SM_ChainsawDuel_Follower :
		case SM_ChainsawDuel_Draw :
				return TRUE;
	}

	return FALSE;
}

/**
 * Notification called from the Engage special move, to let us know that
 * We're done engaging, and we can now actually duel.
 */
simulated function DuelingMiniGameStartNotification()
{
	// Reset button presses.
	DuelingMiniGameButtonPresses = 0;

	// Start dueling mini game
	bInDuelingMiniGame = TRUE;

	if( GearAI(Controller) != None )
	{
		DuelingMiniGameButtonPresses = RandRange(AI_ChainsawDuelButtonPresses.X, AI_ChainsawDuelButtonPresses.Y);
		// difficulty scaling
		DuelingMiniGameButtonPresses *= (0.5 + 0.25 * GearAI(Controller).GetDifficultyLevel());
	}
}

/**
 * Called when leaving Engage special move.
 */
simulated function DuelingMiniGameEndNotification()
{
	// Stop dueling mini game
	// We can't mash the buttom anymore.
	bInDuelingMiniGame = FALSE;
}


reliable server function ReportDuelingMiniGameButtonPress()
{
	// Have server verify that we're still dueling
	if( bInDuelingMiniGame || bInTriggerMiniGame )
	{
		DuelingMiniGameButtonPresses++;

		// Force replication to happen now
		if( WorldInfo.NetMode != NM_Standalone )
		{
			bForceNetUpdate = TRUE;
		}
	}
}

/**
 * Is Pawn doing a 'dodge' move?
 * Those moves prevent pawn from being dragged into a chainsaw dueling for example,
 * we want him to settle down first before being sucked into an execution interaction.
 */
simulated final function bool IsDoingADodgeMove()
{
	return IsEvading() || IsDoingSpecialMove(SM_MidLvlJumpOver) || IsDoingSpecialMove(SM_MantleDown) ||
			IsDoingSpecialMove(SM_MantleUpLowCover) || IsDoingSpecialMove(SM_StdLvlSwatTurn) || IsDoingSpecialMove(SM_CoverSlip);
}

reliable server function ServerQueueRoadieRunMove(float TimeStamp, bool bForce, bool bSkipBoost)
{
	if (Role == ROLE_Authority)
	{
		QueuedRoadieRunMoveTimeStamp = TimeStamp;
		QueueRoadieRunMove(bForce,bSkipBoost);
	}
}

/** called when the client sucessfully queued a roadie run, but the server failed to do so */
reliable client function ClientQueuedRoadieRunFailed()
{
	// note that the client might have stopped and started a whole new roadie run move, which this will also cancel
	// LocalEndSpecialMove() will send a cancel to the server, which will handle that case by cancelling the new move sent to the server
	// while in the normal case the server will simply receive a redundant EndSpecialMove() and discard it
	LocalEndSpecialMove(SM_RoadieRun);
}

/** bForce when we want to force the roadie run move. */
simulated function QueueRoadieRunMove(optional bool bForce, optional bool bSkipBoost)
{
	if (bForce || CanDoSpecialMove(SM_RoadieRun))
	{
		// notify the server as well
		if( Role < ROLE_Authority )
		{
			ServerQueueRoadieRunMove(WorldInfo.TimeSeconds, bForce, bSkipBoost);
		}
		// if not a dedicated server then perform the move locally as well
		if( WorldInfo.NetMode != NM_DedicatedServer )
		{
			DoSpecialMove(SM_RoadieRun, bForce);
		}

		if (!bSkipBoost)
		{
			RoadieRunBoostTime = WorldInfo.TimeSeconds;
		}
		if( bForce )
		{
			Velocity		= Vector(Rotation) * GroundSpeed * GetMaxSpeedModifier();
			Acceleration	= Normal(Velocity) * AccelRate;
		}
	}
	else if (!bForce && !IsLocallyControlled())
	{
		ClientQueuedRoadieRunFailed();
	}
}

reliable server function ServerGrabMovableCover(optional bool bGrab = TRUE)
{
	// Play sounds if necessary
	if( bGrab && !bGrabbingMovableCover && GrabCoverSound != None )
	{
// 		PlaySound(GrabCoverSound);
		PlaySound(ReleaseCoverSound);
	}
	bGrabbingMovableCover = bGrab;
}

function StartMoveCoverLoop()
{
	if (MovingCoverSound != None)
	{
		if( MovingCoverLoop == None )
		{
			MovingCoverLoop = CreateAudioComponent(MovingCoverSound, FALSE, TRUE);
			if (MovingCoverLoop != None)
			{
				MovingCoverLoop.bUseOwnerLocation	= TRUE;
				MovingCoverLoop.bAutoDestroy		= TRUE;
				AttachComponent(MovingCoverLoop);
			}
		}
		if( MovingCoverLoop != None )
		{
			MovingCoverLoop.FadeIn(0.2, 1.f);
		}
	}
}

function StopMoveCoverLoop()
{
	if (MovingCoverLoop != None)
	{
		MovingCoverLoop.FadeOut(0.3f, 0.f);
		MovingCoverLoop = None;
	}
}

unreliable server function ServerSetManipulateCoverInfo(optional float AppliedForce, optional float AppliedTorque, optional float AppliedStrafeForce)
{
	ManipulateCoverInfo.AppliedForce = AppliedForce;
	ManipulateCoverInfo.AppliedTorque = AppliedTorque;
	ManipulateCoverInfo.AppliedStrafeForce = AppliedStrafeForce;
}

/*
** Ending SpecialMoves **

- EndSpecialMove, just ends the special move locally, no replication is done to keep owning client or server in sync.
	This is good when special moves are reliably going to terminate themselves. (for example timer or animation based).
- ServerEndSpecialMove, called on server (ROLE_Authority), and will replicate to owning client if necessary.
	Ensuring synchronization between server/locally owned client.
- LocalEndSpecialMove, called on locally controlled pawn, if it is a client it will be replicated to server.
*/

/**
 * Request to abort/stop current SpecialMove
 * This is not replicated to owning client. See ClientEndSpecialMove() below for this.
 */
final simulated exec function EndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
	`LogSM("SpecialMoveToEnd:" @ SpecialMoveToEnd);

	if( IsDoingASpecialMove() )
	{
		// clear the pending move
		if( SpecialMoveToEnd != SM_None && PendingSpecialMoveStruct.SpecialMove == SpecialMoveToEnd )
		{
			`LogSM("- Clearing PendingSpecialMove:" @ SpecialMoveToEnd);
			PendingSpecialMoveStruct = FillSMStructFromParams(SM_None);
		}

		// if no move specified, or it matches the current move
		if( SpecialMoveToEnd == SM_None || IsDoingSpecialMove(SpecialMoveToEnd) )
		{
			// force it to end
			DoSpecialMove(SM_None, TRUE);
		}
	}
}

/**
 * Abort current special move.
 * Called on ROLE_Authority, and replicated to owning client if needed.
 */
final event ServerEndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
	// make sure we're called on server.
	if( WorldInfo.NetMode == NM_Client )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "not called on server!!!");
		return;
	}

	`LogSM(`showvar(SpecialMoveToEnd)@`showvar(SpecialMove));

	if( SpecialMoveToEnd == SM_None )
	{
		SpecialMoveToEnd = SpecialMove;
	}

	// For replication we require a special move to be specified consistency accross network.
	if( SpecialMoveToEnd != SM_None )
	{
		// Force special move to end locally.
		EndSpecialMove(SpecialMoveToEnd);

		// If we're a player controlled Pawn on the server, replicate this to owning client.
		if( Controller != None && Controller.IsA('GearPC') && !IsLocallyControlled() )
		{
			ReplicatedClientEndSpecialMove(SpecialMoveToEnd);
		}
	}
}

/**
 * Replicated function from Server to Client, called only from ClientEndSpecialMove()
 * Should not be called directly.
 */
final simulated reliable client function ReplicatedClientEndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
	`LogSM("SpecialMoveToEnd:" @ SpecialMoveToEnd);
	EndSpecialMove(SpecialMoveToEnd);
}

/**
 * Abort current special move.
 * Called on locally controlled pawn, and replicated to server if needed.
 */
final simulated event LocalEndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
	// make sure we're called on a locally controlled pawn.
	if( !IsLocallyControlled() )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "called on non locally controlled pawn!!!");
		return;
	}

	`LogSM(`showvar(SpecialMoveToEnd)@`showvar(SpecialMove));

	if( SpecialMoveToEnd == SM_None )
	{
		SpecialMoveToEnd = SpecialMove;
	}

	// For replication we require a special move to be specified consistency accross network.
	if( SpecialMoveToEnd != SM_None )
	{
		// End SpecialMove locally
		EndSpecialMove(SpecialMoveToEnd);

		// Replicate to server if needed
		if( Controller != None && Controller.IsA('GearPC') && WorldInfo.NetMode == NM_Client )
		{
			ReplicatedServerEndSpecialMove(SpecialMoveToEnd);
		}
	}
}

/**
 *  Try Mantle Down
 */
final simulated event bool LocalTryToMantleDown()
{
	// make sure we're called on a locally controlled pawn.
	if( !IsLocallyControlled() )
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "called on non locally controlled pawn!!!");
		return FALSE;
	}

   	if( CanDoSpecialMove(SM_MantleDown) )
	{
		LocalDoSpecialMove(SM_MantleDown, TRUE);
		return TRUE;
	}

	return FALSE;
}
/**
 * Replicated function from Client to Server, called only from LocalEndSpecialMove()
 * Should not be called directly.
 */
final simulated reliable server function ReplicatedServerEndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
	`LogSM("SpecialMoveToEnd:" @ SpecialMoveToEnd);
	EndSpecialMove(SpecialMoveToEnd);
}

/* Notification called when SpecialMove enum changes. */
simulated function SpecialMoveAssigned(ESpecialMove NewMove, ESpecialMove PrevMove)
{
	`LogSM("NewMove:" @ NewMove @ "PrevMove:" @ PrevMove);

	PreviousSpecialMove = PrevMove;
	PreviousSpecialMoveTime = WorldInfo.TimeSeconds;

	// If we just ended SM_CoverRun, update 360 aiming flag for transition
	// This way GearPC.UpdatePlayerPosture() knows about it.
	// Otherwise it can create conflicts and trigger several mirroring transitions in a row.
	if( bCanDo360AimingInCover && PrevMove == SM_CoverRun )
	{
		UpdateAimOffset(AimOffsetPct, 0.f);
	}

	// Update status of left hand IK on special move transitions.
	UpdateBoneLeftHandIK();
}

/** Event called when A new special move has started */
simulated final function SpecialMoveStarted(ESpecialMove NewMove, ESpecialMove PrevMove, bool bForced)
{
	local GearPC	PC;

	`LogSM("NewMove:" @ NewMove @ "PrevMove:" @ PrevMove);

	if( NewMove != SM_None )
	{
		// notify controller that special move started.
		PC = GearPC(Controller);
		if( PC != None )
		{
			PC.SpecialMoveStarted(NewMove);
		}

		// give ai notification
		if (MyGearAI != None)
		{
			MyGearAI.NotifyStartOfSpecialMove(NewMove);
		}

		// forward notification to special move instance
		if( SpecialMoves[NewMove] != None )
		{
			SpecialMoves[NewMove].SpecialMoveStarted(bForced,PrevMove);
		}
`if(`notdefined(FINAL_RELEASE))
		else
		{
			`log("No class for special move:" @ NewMove @ self);
		}
`endif
	}
}


/** Event called when A new special move has stopped */
simulated final function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	`LogSM("PrevMove:" @ PrevMove);

	if( PrevMove != SM_None )
	{
		if( SpecialMoves[PrevMove] != None )
		{
			SpecialMoves[PrevMove].SpecialMoveEnded(PrevMove, NextMove);
		}
`if(`notdefined(FINAL_RELEASE))
		else
		{
			`LogSM("No class for special move:" @ PrevMove);
		}
`endif
		// give ai notification
		if (MyGearAI != None)
		{
			MyGearAI.NotifyEndOfSpecialMove(PrevMove);
		}
	}

	// A special move has ended, update status of shield deployment
	if( NextMove == SM_None && PendingSpecialMoveStruct.SpecialMove == SM_None )
	{
		CheckShieldDeployment();
	}
}

/**
 * Sends a message event to the current special move.
 * returns TRUE if message was correctly processed.
 */
simulated final function bool SpecialMoveMessageEvent(Name EventName, Object Sender)
{
	return(	SpecialMove != SM_None &&
			SpecialMoves[SpecialMove] != None &&
			SpecialMoves[SpecialMove].MessageEvent(EventName, Sender)
			);
}


/** Try to fit actor so it doesn't encroach world, before turning collision back on */
native final simulated function bool FitCollision();

/** Test that Pawn is on a ledge, and can mantle down */
native final simulated function bool CanPerformMantleDown(FLOAT MinMantleHeight, FLOAT MaxMantleHeight, FLOAT ForwardDistanceToTravel, rotator TestRotation);

function PrepareMoveAlong( GearAI_Cover AI, ReachSpec Spec )
{
	if( AI == None )
		return;

	if( Spec.IsA( 'MantleReachSpec' ) )
	{
		// do nothing
	}
	else
	// If not in combat
	if( !AI.IsAlert() )
	{
		//debug
		`AILog_Ext( GetFuncName()@"Reset cover -- not alert"@Spec@CoverType, 'Move', AI );

		AI.ResetCoverType();
	}
	else
	// If can't swat turn or cover slip or adjust along the reach spec
	if( (!bCanSwatTurn  || !Spec.IsA( 'SwatTurnReachSpec' )) &&
		(!bCanCoverSlip || !Spec.IsA( 'CoverSlipReachSpec')) &&
		 !Spec.IsA( 'SlotToSlotReachSpec' ) )
	{
		//debug
		`AILog_Ext( GetFuncName()@"Reset cover -- can't execute special move"@Spec@bCanSwatTurn@bCanCoverSlip@CoverType, 'Move', AI );

		AI.ResetCoverType();
	}
}

/**
 *	Decide which special action to take from Start to End, if any
 */
function bool SpecialMoveTo( NavigationPoint Start, NavigationPoint End, Actor Next )
{
	return true;
// MT->all handled in
// 	local ReachSpec CurrentPath;
// `if(`notdefined(FINAL_RELEASE))
// 	local float Dist;
// `endif
//
// 	if ( Start == None )
// 	{
// 		`AILog_Ext(self@GetFuncName()@"invalid start (no anchor?) FIXME FIXME FIXME", 'Move', MyGearAI);
// 		return FALSE;
// 	}
// 	if( Start == End )
// 	{
// 		//debug
// 		`AILog_Ext(self@GetFuncName()@Start@"not doing special move since it dest == start", 'Move', MyGearAI);
//
// 		return FALSE;
// 	}
//
// 	CurrentPath = Start.GetReachSpecTo( End );
//
// 	if(CurrentPath != Controller.CurrentPath)
// 	{
// 		`AILog_Ext(self @ GetFuncName() @"WARNING! CurrentPath does not agree with Controller.CurrentPath -- Start:"@Start@"End:"@End@"Next:"@Next@ "Controller.CurrentPath:" @ Controller.CurrentPath @ "Local CurrentPath:" @ CurrentPath, ,MyGearAI);
// 		CurrentPath = Controller.CurrentPath;
// 	}
// 	if( CurrentPath != None )
// 	{
// 		if( CurrentPath.IsA( 'SlotToSlotReachSpec' ) )
// 		{
// 		}
// 		else
// 		if( CurrentPath.IsA( 'MantleReachSpec' ) )
// 		{
// 		}
// 		else
// 		if( CurrentPath.IsA( 'SwatTurnReachSpec' ) )
// 		{
// 		}
// 		else
// 		if( CurrentPath.IsA( 'CoverSlipReachSpec' ) )
// 		{
// 		}
// 		else
// 		if( CurrentPath.IsA( 'LadderReachSpec' ) )
// 		{
// 			// EXPLODE!
// 		}
// 		else
// 		if( CurrentPath.IsA( 'LeapReachSpec' ) )
// 		{
//
// 		}
// 		else if( IsInCover() )
// 		{
// 			//debug
// 			`AILog_Ext("Regular path, leave cover:"@CurrentPath@CurrentPath.Start@CurrentPath.GetEnd(), 'None', MyGearAI );
//
// 			LeaveCover();
// 		}
// 	}
// 	else
// 	{
// 		//debug
// `if(`notdefined(FINAL_RELEASE))
// 		`AILog_Ext( self@GetFuncName()@"No CURRENT PATH from"@Start@"to"@End@Controller.CurrentPath@GetBestAnchor(self,Location,TRUE,FALSE,Dist), 'Move', MyGearAI );
// `endif
// 	}
//
// 	return TRUE;
}

// easily overiddable function to change what happens when a pawn mantles
function bool DoMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return class'AICmd_Move_Mantle'.static.MantleEdge( MyGearAI, Dir, MoveStart, MoveDest, Info );
}

/** Overidable function to move pawn to mantle start position */
function bool DoPreMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return false;
}

function bool HasArrivedAtMantleStart(Vector MoveStart)
{
	 return ( VSizeSq2D(MoveStart-Location) < 4.f * CylinderComponent.CollisionRadius * CylinderComponent.CollisionRadius ||
				// Of if our controller supports cover, we just need to be close enough to do a "run 2 cover".
			  (Controller.IsA('GearAI_Cover') && VSizeSq2D(MoveStart-Location) < Run2CoverMaxDist*Run2CoverMaxDist) );
}

event bool SpecialMoveThruEdge( ENavMeshEdgeType EdgeType, INT Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem )
{
	local CoverInfo Info;

	`AILog_Ext(GetFuncName()@`showvar(EdgeType)@`showvar(Dir)@`showvar(MoveStart)@`showvar(MoveDest)@`showvar(RelActor),,MyGearAI);
	//`log( self@GetFuncName()@EdgeType@Dir@MoveStart@MoveDest@RelActor );

	if( EdgeType == NAVEDGE_Mantle )
	{
// 		`log(WorldInfo.TimeSeconds @ self @ GetFuncName() @ VSizeSq2D(MoveStart-Location));

		if( IsAKidnapper() )
		{
			bCanMantle = FALSE;
			bCanClimbUp = FALSE;
		}
		// Using a larger radius, but not working too great.
		// Problem is Pawns who don't have the run to cover behavior they can mantle pretty far away from the wall
		else if( HasArrivedAtMantleStart(MoveStart) )
		{
			LastMantleTime = WorldInfo.TimeSeconds;
			LastMantleLocation = MoveStart;

			Info.Link = CoverLink(RelActor);
			Info.SlotIdx = RelItem;
			DoMantle(MyGearAI,Dir,MoveStart,MoveDest,Info);
			return TRUE;
		}
		else
		{
			Info.Link = CoverLink(RelActor);
			Info.SlotIdx = RelItem;
			Info.Link.GetSlotLocation(Info.SlotIdx);

			LastMantleTime = WorldInfo.TimeSeconds;
			LastMantleLocation = MoveStart;

			return DoPreMantle(MyGearAI,Dir,MoveStart,MoveDest,Info);
// 			`log(WorldInfo.TimeSeconds @ self @ GetFuncName() @ VSize2D(MoveStart-Location));
// 			DrawDebugBox(Location, vect(1,1,0) * CylinderComponent.CollisionRadius + vect(0,0,1) * CylinderComponent.CollisionHeight, 0, 255, 0, TRUE);
// 			DrawDebugLine(Location, MoveStart, 255, 0, 0, TRUE);
		}

	}
	else if( EdgeType == NAVEDGE_Coverslip )
	{
		if( IsAKidnapper() )
		{
			bCanCoverslip = FALSE;
		}
		else
		{
			Info.Link = CoverLink(RelActor);
			Info.SlotIdx = RelItem;
			class'AICmd_Move_CoverSlip'.static.CoverSlipEdge( GearAI_Cover(Controller), Dir, MoveStart, MoveDest, Info );
			return TRUE;
		}
	}
	else if( EdgeType == NAVEDGE_DropDown )
	{
		if( !VerifySMHasBeenInstanced(SM_MantleDown) )
		{
			class'AICmd_Move_NonGSMDropDown'.static.FallOffDropDown(MyGearAI,MoveDest);
			return FALSE;
		}

		class'AICmd_Move_Mantle'.static.MantleEdge(MyGearAI,-1,MoveStart,MoveDest,Info);
		return TRUE;
	}

	return FALSE;
}



simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	local Rotator	BlendDelta, Delta;
	local FLOAT		CoverBlendWeight;
	local INT       DeltaYaw, MaxYawStep;

	// Do not update Pawn's rotation depending on controller's ViewRotation if in FreeCam.
	if( bLockRotation || InFreeCam() )
	{
		NewRotation = Rotation;
	}

	// check the special move alignment
	if( IsDoingASpecialMove() && SpecialMoves[SpecialMove].AlignToActor != None )
	{
		NewRotation = rotator(SpecialMoves[SpecialMove].AlignToActor.Location - Location);
		NewRotation.Pitch = 0;
		NewRotation.Roll = 0;
	}
	else
	{

		// Don't change pawn rotation during a special move
		if( SpecialMove != SM_None && SpecialMoves[SpecialMove].IsPawnRotationLocked() )
		{
			NewRotation = Rotation;
		}
		else if( IsInCover() )
		{
			NewRotation = Normalize(rotator(-GetCoverNormal(TRUE)));
			DeltaYaw = NormalizeRotAxis(NewRotation.Yaw - Rotation.Yaw);
			// Has to match up GameplayCam_Cover.CoverNormalInterpSpeed so controls remain relatively identical.
			// Different interpolation speeds would result in controls not remapped properly and changing.
			MaxYawStep = FCeil(class'GameplayCam_Cover'.default.CoverNormalInterpSpeed * DeltaTime);
			NewRotation.Yaw = Rotation.Yaw + Clamp(DeltaYaw, -MaxYawStep, MaxYawStep);
			LastCoverRotation = NewRotation;
		}
		// for most of SM_MidLvlJumpOver cases, it will go above if "IsInCover", but if not, it is noncover user
		else if ( SpecialMove == SM_MidLvlJumpOver && GSM_NonCoverUserMantleOverCover(SpecialMoves[SM_MidLvlJumpOver]) != none)
		{
			NewRotation = Normalize(rotator(-GSM_NonCoverUserMantleOverCover(SpecialMoves[SM_MidLvlJumpOver]).GetCoverNormal()));
		}
		else if( Physics == PHYS_Ladder )
		{
			NewRotation = OnLadder.Walldir;
		}

		if( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) || (Physics == PHYS_Interpolating) )
		{
			NewRotation.Pitch = 0;
		}
		// don't use pitch if we're using the base platform no movement hack
		else if( Physics == PHYS_None && InterpActor_GearBasePlatform(Base) != None && InterpActor_GearBasePlatform(Base).bDisallowPawnMovement )
		{
			NewRotation.Pitch = 0;
		}
	}

	// Make sure new rotation is normalized.
	NewRotation = Normalize(NewRotation);

	// Special cover exit rotation interpolation. Matches animation blending.
	if( bRotInterpCoverTransition && BaseBlendNode != None )
	{
		CoverBlendWeight	= 1.f - (BaseBlendNode.NodeTotalWeight * BaseBlendNode.Children[1].Weight);
		Delta				= Normalize(NewRotation - LastCoverRotation);
		BlendDelta			= Delta * CoverBlendWeight;
// 		`DLog("CoverBlendWeight:" @ CoverBlendWeight @ "NewRotation:" @ NewRotation @ "Rotation:" @ Rotation @ "Delta:" @ Delta @ "BlendDelta:" @ BlendDelta);
		NewRotation			= Normalize(LastCoverRotation + BlendDelta);

		if( CoverBlendWeight >= 1.f )
		{
			bRotInterpCoverTransition = FALSE;
		}
	}
	// Interpolate pawn rotation smoothly to desired position,
	// to prevent instant snapping when going in and out of cover.
	// And transitioning between special moves locking rotation.
	else if( PawnRotationBlendTimeToGo > 0.f )
	{
		if( PawnRotationBlendTimeToGo > DeltaTime )
		{
			PawnRotationBlendTimeToGo	-= DeltaTime;
			Delta						= Normalize(NewRotation - Normalize(Rotation));
			BlendDelta					= Delta * FClamp((DeltaTime / PawnRotationBlendTimeToGo), 0.f, 1.f);
// 			`DLog("PawnRotationBlendTimeToGo:" @ PawnRotationBlendTimeToGo @ "NewRotation:" @ NewRotation @ "Rotation:" @ Rotation @ "Delta:" @ Delta @ "BlendDelta:" @ BlendDelta);
			NewRotation					= Normalize(Rotation + BlendDelta);
		}
		else
		{
			PawnRotationBlendTimeToGo	= 0.f;
		}
	}

// ROTATION DEUB
/*	if (IsHumanControlled() == FALSE && Health > 0)
	{
		DeltaYaw = FindDeltaAngle(NewRotation.Yaw*UnrRotToRad, Rotation.Yaw*UnrRotToRad)*RadToUnrRot;

		if (Abs(DeltaYaw) > 10000)
		{
			`Log(Name@":"@GetFuncName()@"-Delta:"@DeltaYaw);
			DebugFreezeGame(self);
		}
	}*/

	SetRotation(NewRotation);
}


/** Function to set Pawn rotation interpolation */
simulated final function InterpolatePawnRotation(optional FLOAT RotationInterpTime, optional bool bCoverTransition)
{
	if (IsHumanControlled())
	{
		bRotInterpCoverTransition = bCoverTransition;
		if( !bCoverTransition )
		{
			PawnRotationBlendTimeToGo = (RotationInterpTime > 0.f) ? RotationInterpTime : PawnRotationInterpolationTime;
		}
		// 	`DLog("PawnRotationBlendTimeToGo:" @ PawnRotationBlendTimeToGo @ "bRotInterpCoverTransition:" @ bRotInterpCoverTransition);
		// 	ScriptTrace();
	}
}

simulated final function bool IsDoingPawnRotationInterpolation()
{
	return (PawnRotationBlendTimeToGo > 0.f || bRotInterpCoverTransition);
}

/**
 * @param bSmoothed		if true, returns a normal that has been smoothed over the
 *						length of the cover.
 */
final simulated function vector GetCoverNormal(optional bool bSmoothed)
{
	local Vector X, Y, Z;
	local Rotator InterpRot;

	if (CurrentLink != None)
	{
		// look for a set of bounding slots
		if( CurrentLink.Slots.Length > 1 )
		{
			if (bSmoothed)
			{
				// if we're at an edge and within nudge distance (CollisionRadius * 0.5f) then snap to current slot
				if((CurrentLink.IsLeftEdgeSlot(CurrentSlotIdx,TRUE) || CurrentLink.IsRightEdgeSlot(CurrentSlotIdx,TRUE)) &&
					VSizeSq2D(Location - CurrentLink.GetSlotLocation(CurrentSlotIdx)) <= (25.f * 25.f)
					)
				{
					InterpRot = CurrentLink.GetSlotRotation(CurrentSlotIdx);
				}
				else
				{
					InterpRot = RLerp(CurrentLink.GetSlotRotation(LeftSlotIdx), CurrentLink.GetSlotRotation(RightSlotIdx), CurrentSlotPct, TRUE);
				}
				X = vector(InterpRot);

			}
			else
			{
				// use the axis based on the slot locations
				Z = vect(0,0,1);
				Y = Normal(CurrentLink.GetSlotLocation(RightSlotIdx) - CurrentLink.GetSlotLocation(LeftSlotIdx));
				X = Normal(Y cross Z);
			}
		}
		else
		{
			// otherwise default to our currently assigned slot's rotation
			X = vector(CurrentLink.GetSlotRotation(0));
		}
	}

	return -X;
}


/************************************************************************************
 * Evade
 ***********************************************************************************/


/** Returns TRUE if player is doing an Evade special move. */
final simulated native function bool IsEvading() const;

/** Notification called when the character plays the evade land animation */
simulated function PlayEvadeAnimLandedNotify()
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// play physical material based sounds here
		SoundGroup.PlayFoleySound(self, GearFoley_EvadeImpactFX);
		// Notify AI of sound
		MakeNoise( 0.75f );

		// need to check which way we are rolling
		if( SpecialMove == SM_EvadeRt )
		{
			PlayEvadeParticleEffect( Rotation + Rotator(vect(0,32768,0)) );
		}
		else if( SpecialMove == SM_EvadeLt )
		{
			PlayEvadeParticleEffect( Rotation + Rotator(vect(0,-32768,0)) );
		}
		else if( SpecialMove == SM_EvadeBwd )
		{
			PlayEvadeParticleEffect( Rotation + Rotator(vect(0,32768,0)) + Rotator(vect(0,32768,0)) );
		}
		else
		{
			PlayEvadeParticleEffect( Rotation );
		}
	}
}


/**
 * This will play the evade particle effect by tracing down and then spawning a particle there
 **/
simulated function PlayEvadeParticleEffect( Rotator SpawnRotation )
{
	local float CurrHeight;

	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;

	// don't even try to play nor do any traces if we are not within Relevancy Distance
	if( !EffectIsRelevant(Location, false, 4000) )
	{
		return;
	}

	// kk here we need to do a tracez0r down down into the ground baby!
	// NOTE: this will eventually be moved to c++ land
	CurrHeight = GetCollisionHeight();

	TraceStart = Location;
	TraceDest = TraceStart - ( Vect(0, 0, 1 ) * CurrHeight ) - Vect(0, 0, 16 );

	// trace down and see what we are standing on
	TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, TRUE, TraceExtent, HitInfo, TRACEFLAG_Bullet );
	//DrawDebugLine( TraceStart, TraceDest, 255, 0, 0, TRUE);

	if( TraceActor != none )
	{
		//DrawDebugCoordinateSystem( out_HitLocation, SpawnRotation, 100, TRUE );
		WorldInfo.MyEmitterPool.SpawnEmitter(class'GearPhysicalMaterialProperty'.static.DetermineEvadeParticleEffect(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(HitInfo)), out_HitLocation, SpawnRotation, self);
	}
	// otherwise we hit nothing and are in the air
	else
	{
		//`log( " We are in the air" );
	}

}


simulated event EvadeAnimationFinished()
{
	//debug
	`AILog_Ext( GetFuncName()@IsEvading()@SpecialMove, 'None', MyGearAI );

	if( IsEvading() )
	{
		EndSpecialMove();
	}
}


/************************************************************************************
 * Run2Cover transition
 ***********************************************************************************/


/**
 * Prepare a slide into cover special move.
 * See if can find a good cover spot, and suggest best move.
 * return FALSE, if cannot be done.
 */
simulated final function bool CanPrepareRun2Cover(float CheckDist,
												  out CovPosInfo OutFoundCovInfo,
												  optional vector CheckDir,
												  optional float AcquireCoverFOV,
												  optional vector Start,
												  optional out pawn out_BlockingPawn)
{
	local Vector	Dir;

	// Where to check for cover
	if (IsZero(Start))
	{
		Start		= Location;
	}
	if (!IsZero(CheckDir))
	{
		Dir = CheckDir;
	}
	else
	{
		Dir	= Vector(Rotation);
	}
	CheckDist	= FClamp(CheckDist, 0.f, Run2CoverMaxDist);

	if (AcquireCoverFOV == 0.f)
	{
		AcquireCoverFOV = PawnAcquireCoverFOV;
	}

	//FlushPersistentDebugLines();
	//DrawDebugLine(Start, Start+Dir*CheckDist, 0, 255, 0, TRUE);

	// Try to find cover to run to
	return FindCoverFromLocAndDir(Start, Dir, AcquireCoverFOV, CheckDist, OutFoundCovInfo, out_BlockingPawn);
}

/**
 * Is the pawn currently at the edge of their current cover?  Uses (scaled) collision radius for the distance check.
 *
 * @param bMirrored			if TRUE then checks the left-most edge, otherwise if FALSE checks the right-most edge
 * @param bAllowLeanAsEdge	if TRUE then allow transitions with leans (standing->midlevel) to be treated as an edge
 *
 * @return TRUE if at the edge, FALSE if not
 */
native final function bool IsAtCoverEdge(bool bMirrored, optional bool bAllowLeanAsEdge, optional float Scale = 1.75f, optional out int EdgeSlotIdx, optional int StartSlotIdx = -1, optional bool bIgnoreCurrentCoverAction);

/**
 * Returns the SlotIdx that the pawn is current closest to, -1 if no valid slots.
 *
 * @param bRequireOverlap	if TRUE then requires the pawn to be within overlap distance of the slot
 */
native final function int PickClosestCoverSlot(bool bRequireOverlap = TRUE, optional float RadiusScale = 0.5f, optional bool bIgnoreCurrentCoverAction);


final function bool IsAtLeftEdgeSlot( optional float InLimit, optional bool bMustLean )
{
	if( CoverType == CT_None )
	{
		return FALSE;
	}

	// Lean requirement
	if( bMustLean && !CurrentLink.Slots[0].bLeanLeft )
	{
		return FALSE;
	}

	// Is located on left edge slot
	if( CurrentLink.Slots.Length == 1 ||			// Single Slot
		(CurrentSlotIdx == 0 && IsOnACoverSlot()) )	// Right on edge slot
	{
		return TRUE;
	}

	// Limit test from edge, assuming InLimit is a percentage in this case
	if( InLimit > 0.f && InLimit <= 1.f)
	{
		if( LeftSlotIdx == 0 && CurrentSlotPct <= InLimit )
		{
			return TRUE;
		}
	}
	// otherwise assume it's a distance check
	else
	{
		// if no distance specified, then default to a scaled collision radius
		if (InLimit == 0.f)
		{
			InLimit = CylinderComponent.CollisionRadius * 1.5f;
		}
		//`LogExt(VSize(CurrentLink.GetSlotLocation(LeftSlotIdx) - Location)@"vs"@InLimit);
		return (LeftSlotIdx == 0 && VSize(CurrentLink.GetSlotLocation(LeftSlotIdx) - Location) <= InLimit);
	}

	// check and see if slot immediately to the left of us is disabled.
	// checking against 0.5 because CalcVelocity will let us get 1/2 way to a disabled slot
	// @fixme, 0.5 thing doesn't seem tobe working right now, when itdoes, uncomment below check
	if ( !CurrentLink.Slots[LeftSlotIdx].bEnabled /*&& P.CurrentSlotPct <= 0.5f*/ )
	{
		return TRUE;
	}

	return FALSE;
}


final function bool IsAtRightEdgeSlot(optional float InLimit, optional bool bMustLean)
{
	local int	RightEdgeSlotIndex;

	if( CoverType == CT_None )
	{
		return FALSE;
	}

	RightEdgeSlotIndex = CurrentLink.Slots.Length - 1;

	// Lean requirement
	if( bMustLean && !CurrentLink.Slots[RightSlotIdx].bLeanRight )
	{
		return FALSE;
	}

	// Is located on right edge slot
	if( CurrentLink.Slots.Length == 1 ||								// Single Slot
		(CurrentSlotIdx == RightEdgeSlotIndex && IsOnACoverSlot()) )	// Right on edge slot
	{
		return TRUE;
	}


	// Limit test from edge, assuming InLimit is a percentage in this case
	if( InLimit > 0.f && InLimit <= 1.f)
	{
		if( RightSlotIdx == RightEdgeSlotIndex && CurrentSlotPct >= (1.f - InLimit) )
		{
			return TRUE;
		}
	}
	// otherwise assume it's a distance check
	else
	{
		// if no distance specified, then default to a scaled collision radius
		if (InLimit == 0.f)
		{
			InLimit = CylinderComponent.CollisionRadius * 1.5f;
		}
		//`LogExt(VSize(CurrentLink.GetSlotLocation(RightSlotIdx) - Location)@"vs"@InLimit);
		return (RightSlotIdx == RightEdgeSlotIndex && VSize(CurrentLink.GetSlotLocation(RightSlotIdx) - Location) <= InLimit);
	}

	// check and see if slot immediately to the right of us is disabled.
	// checking against 0.5 because CalcVelocity will let us get 1/2 way to a disabled slot
	// @fixme, 0.5 thing doesn't seem tobe working right now, when itdoes, uncomment below check
	if ( !CurrentLink.Slots[RightSlotIdx].bEnabled /*&& P.CurrentSlotPct >= 0.5f*/ )
	{
		return TRUE;
	}

	return FALSE;
}

/************************************************************************************
 * Move2Idle transition
 ***********************************************************************************/

/** Return TRUE if Pawn is doing one of the move2idle transition special moves */
native final simulated function bool IsDoingMove2IdleTransition();


/**
 * Event called from C++, when Pawn wants to stop moving,
 * to see if move2idle transition can be started.
 */
simulated event ConditionalMove2IdleTransition()
{
	local float			Speed, DeltaToRun, DeltaToWalk, DotY;
	local ESpecialMove	NewMove;
	local GearPC			PC;
	local vector		X, Y, Z;

	`LogSM("");

	// No move2idle transitions in MP or when not in cover.
	if( WorldInfo.NetMode != NM_Standalone || CurrentLink == None )
	{
		return;
	}

	// no transition if about to slide into cover
	if( PendingSpecialMoveStruct.SpecialMove == SM_Run2StdCov || PendingSpecialMoveStruct.SpecialMove == SM_Run2MidCov )
	{
		return;
	}

	// See if Pawn should be forced into walking or running
	Speed		= VSize2D(Velocity);
	DeltaToRun	= Abs(Speed - GroundSpeed);
	DeltaToWalk	= Abs(Speed - GroundSpeed * WalkingPct);

	if( DeltaToRun < DeltaToWalk )
	{
		NewMove = SM_Run2Idle;
	}
	else
	{
		NewMove = SM_Walk2Idle;
	}

	if( IsInCover() )
	{
		// if we're on a slot then don't move since that'll move us off the slot
		if (IsOnACoverSlot())
		{
			return;
		}

		GetAxes(Rotation, X, Y, Z);
		DotY = Velocity dot Y;

		if ( ((DotY < 0.f) && !bIsMirrored) || ((DotY > 0.f) && bIsMirrored) )
		{
			// backing up in cover, don't to move2idle transition.
			// @fixme, someday we'll want a transition, just one suited for walking backward.
			return;
		}
	}

	// For human players, local player plays and replicates the special move.
	// For AI, it's done on server.
	PC = GearPC(Controller);
	if( PC != None )
	{
		if( PC.IsLocalPlayerController() )
		{
			PC.DoSpecialMove(NewMove);
		}
	}
	else
	{
		DoSpecialMove(NewMove);
	}
}


/**
 * Event called from C++ when transition is either finished or aborted.
 */
simulated event Move2IdleTransitionFinished()
{
	`LogSM("");

	if( IsDoingMove2IdleTransition() )
	{
		EndSpecialMove();
	}
}

simulated event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	Super.Bump(Other, OtherComp, HitNormal);

	if (SpecialMove != SM_None)
	{
		SpecialMoves[SpecialMove].NotifyBump(Other, OtherComp, HitNormal);
	}

	// Monitor when Pawn last bumped into something
	LastBumpTime = WorldInfo.TimeSeconds;
}


/************************************************************************************
 * Weapon / Firing
 ***********************************************************************************/


/**
 * Forward FlashLocation updates to weapon.
 */
simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
	local GearWeapon GearWeap;

	GearWeap = GearWeapon(InWeapon);
	if( GearWeap != None )
	{
		GearWeap.FlashLocationUpdated(GetWeaponFiringMode(InWeapon), InFlashLocation, bViaReplication);
	}
}

/**
 * Forward FlashCount updates to weapon.
 */
simulated function FlashCountUpdated(Weapon InWeapon, Byte InFlashCount, bool bViaReplication)
{
	local GearWeapon GearWeap;

	GearWeap = GearWeapon(InWeapon);
	if( GearWeap != None )
	{
		GearWeap.FlashCountUpdated(InFlashCount, GetWeaponFiringMode(InWeapon), bViaReplication);
	}
}

/** @see Pawn::WeaponFired */
simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	local int	        i;
	local bool	        bAltRecoilNode;
	local GearWeapon    InGearWeapon;

	// increment number of consecutive shots.
	ShotCount++;

	// Keep track of when last shot was fired.
	// Tracking WeaponStoppedFiring because weapons like shotgun have a very long Fire Interval.
	// So instead of weapon firing, we track when weapon stopped firing.
	LastWeaponEndFireTime = WorldInfo.TimeSeconds + InWeapon.GetFireInterval(GetWeaponFiringMode(InWeapon));

	// if blind firing then record the time for animations,
	if( CoverType != CT_None && IsBlindFiring(CoverAction) )
	{
		LastWeaponBlindFireTime = WorldInfo.TimeSeconds;
	}

	bAltRecoilNode = IsAKidnapper() || SpecialMove == GSM_DragInjured_Leader;

	// Trigger IK Based weapon recoil.
	InGearWeapon = GearWeapon(InWeapon);
	if( InGearWeapon != None && InGearWeapon.bPlayIKRecoil )
	{
		for(i=0; i<RecoilNodes.Length; i++)
		{
			// Fix for low frame rate issue, do not overwrite shakes...
			if( RecoilNodes[i].Recoil.TimeToGo > RecoilNodes[i].Recoil.TimeDuration*0.5f )
			{
				continue;
			}

			// Kidnappers don't play on global WeaponRecoilNode. Hooked up to the IKGunBone, with controls both hands, and hostage.
			if( bAltRecoilNode && RecoilNodes[i].ControlName == 'WeapRecoilNode' )
			{
				continue;
			}

			// RightHandRecoil node is only used for kidnappers. Only affects right hand for pistols.
			if( !bAltRecoilNode && RecoilNodes[i].ControlName == 'RightHandRecoilNode' )
			{
				continue;
			}

			RecoilNodes[i].bPlayRecoil = !RecoilNodes[i].bPlayRecoil;

			// @fixme laurent, only do this at weapon change? No need to reassign it every time...
			if( RecoilNodes[i].ControlName == 'SpineRecoilNode' )
			{
				RecoilNodes[i].Recoil = InGearWeapon.Recoil_Spine;
			}
			else
			{
				RecoilNodes[i].Recoil = InGearWeapon.Recoil_Hand;
			}
		}
	}
}


/** @see Pawn::WeaponStoppedFiring */
simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	// reset number of consecutive shots fired.
	ShotCount = 0;
}

simulated native event vector GetPhysicalFireStartLoc( vector FireOffset );

/** Attach weapon to character inventory slot */
simulated function AttachWeaponToSlot(GearWeapon W)
{
	local Actor Pickup;
	local class<GearWeapon> PickupClass;

	// don't attach weapon we're picking up as we will switch to it
	if (IsDoingSpecialMove(SM_WeaponPickup) && GSM_Pickup(SpecialMoves[SpecialMove]) != None)
	{
		Pickup = GSM_Pickup(SpecialMoves[SpecialMove]).PickupActor;
		if (GearWeaponPickupFactory(Pickup) != None)
		{
			PickupClass = GearWeaponPickupFactory(Pickup).WeaponPickupClass;
		}
		else if (GearDroppedPickup(Pickup) != None)
		{
			PickupClass = class<GearWeapon>(GearDroppedPickup(Pickup).InventoryClass);
		}
	}

	// current weapon is attached via AttachWeaponToHand()
	// Don't attach grenades on character
	if (W != None && (W != Weapon || W.bTemporaryHolster) && W.CharacterSlot != EASlot_Belt && W.Class != PickupClass)
	{
		`LogInv("Attach" @ W @ "to slot" @ W.CharacterSlot);
		SetSlotAttachment(W.CharacterSlot, W.Class);
	}
}

/** Detach weapon from character inventory slot */
simulated function DetachWeaponFromSlot(GearWeapon W)
{
	`LogInv("Detach" @ W @ "from slot" @ W.CharacterSlot);
	SetSlotAttachment(W.CharacterSlot, None);
	W.StopFireEffects(0);
}

simulated function NotifyLocalPlayerTeamReceived()
{
	if (PlayerReplicationInfo != None)
	{
		// update attachments, tac-com meshes, etc
		NotifyTeamChanged();
	}
}

/** Update visibility of weapon attachments based on whether this pawn's team and
 * local player's team match
 */
simulated event UpdateAttachmentVisibility()
{
	// update attachment visibility based on teams
	SetAttachmentVisibility(EASlot_Belt, AttachSlots[EASlot_Belt].InvClass);
	SetAttachmentVisibility(EASlot_Holster, AttachSlots[EASlot_Holster].InvClass);
	SetAttachmentVisibility(EASlot_LeftShoulder, AttachSlots[EASlot_LeftShoulder].InvClass);
	SetAttachmentVisibility(EASlot_RightShoulder, AttachSlots[EASlot_RightShoulder].InvClass);
}

/**
 * Assign an attachment to an inventory slot.
 * Update attachment meshes and allocate on demand.
 *
 * @param	Slot		Slot to set up.
 * @param	AttachClass	Weapon class to attach to the slot. None to clear attachment.
 */
simulated function SetSlotAttachment(EAttachSlot Slot, class<Inventory> AttachClass)
{
	local GearWeapon Weap;
	local Inventory Inv;

	`LogInv(AttachClass @ "on" @ Slot);
	if( Slot == EASlot_None )
	{
		`LogInv("Slot == EASlot_None - abort");
		return;
	}

	// For remote clients, Slots are not replicated, so we fix them up here
	if( AttachClass != None && WorldInfo.NetMode == NM_Client && !IsLocallyControlled() )
	{
		// See if we can find the weapon in the Pawn's inventory
		// if not, weapon will be created.
		Inv = RemoteClientGetInventoryByClass(AttachClass);
		if (Inv != None)
		{
			// Then set the proper slot on the weapon
			Weap = GearWeapon(Inv);
			if( Weap != None )
			{
				Weap.CharacterSlot = Slot;
			}
		}
		else if (WorldInfo.IsPlayingDemo())
		{
			// nonlocal inventory is replicated for demos, wait for it
			SetTimer( 0.1, false, nameof(RefreshRemoteAttachments) );
		}
		else
		{
			`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Couldn't set proper slot" @ Slot @ "to attachment" @ AttachClass @ "for remote pawn" @ Self);
		}
	}

	if( AttachSlots[Slot].InvClass == AttachClass )
	{
		`LogInv("AttachSlots[Slot].InvClass == AttachClass - abort");
		return;
	}

	// Update local class
	AttachSlots[Slot].InvClass = AttachClass;

	if (Role == ROLE_Authority || bNetOwner)
	{
		// Set individual classes, for replication to remote clients.
		switch (Slot)
		{
			case EASlot_Belt			: AttachSlotClass_Belt			= AttachClass;	break;
			case EASlot_Holster			: AttachSlotClass_Holster		= AttachClass;	break;
			case EASlot_LeftShoulder	: AttachSlotClass_LeftShoulder	= AttachClass;	break;
			case EASlot_RightShoulder	: AttachSlotClass_RightShoulder	= AttachClass;	break;
		}

		if (Role == ROLE_Authority)
		{
			// force replication
			bForceNetUpdate = TRUE;
		}
	}

	SetAttachmentVisibility(Slot, AttachClass);
}

simulated function SetAttachmentVisibility(EAttachSlot Slot, class<Inventory> AttachClass)
{
	local PrimitiveComponent PrimComponent;
	local StaticMeshComponent StaticMeshComponent;
	local SkeletalMeshComponent SkeletalMeshComponent;
	local PlayerController PC;
	local MaterialInstanceConstant MIC_WeaponSkin;
	local LinearColor LC;
	local int TeamNum;
	local class<GearWeapon> WeapClass;
	local MeshComponent InvClassMesh;
	local PlayerReplicationInfo TestPRI;

	// skip if dedicated server, below is only cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	`LogInv(AttachClass @ "on" @ Slot);

	// Get the first local player controller
	foreach LocalPlayerControllers(class'PlayerController', PC) { break; }

	// get weapon class, if AttachClass is for a weapon
	WeapClass = class<GearWeapon>(AttachClass);

	// find the mesh component to use, which depends on what class we're dealing with
	if (WeapClass != None)
	{
		InvClassMesh = WeapClass.default.Mesh;
	}

	TestPRI = PlayerReplicationInfo;
	if (TestPRI == None && GearPawnRidable_Base(Base) != None)
	{
		TestPRI = Pawn(Base).PlayerReplicationInfo;
	}
	if (TestPRI == None && DrivenVehicle != None)
	{
		TestPRI = DrivenVehicle.PlayerReplicationInfo;
	}
	// Hide attachments if the class is none or if this pawn is on the wrong team
	// Also don't show attachments if taken hostage since they clip into the kidnapper
	if ( AttachClass == None
			|| IsAHostage()
			|| ( !PC.bDemoOwner
				&& PC.PlayerReplicationInfo != None
				&& TestPRI != None
				&& PC.PlayerReplicationInfo.Team != TestPRI.Team
				&& (Controller == None || !Controller.IsLocalPlayerController())
				// We ALWAYS show the gastank
				&& !ClassIsChildOf(AttachClass, class'GearWeap_GasTankBase') ) )
	{
		`LogInv("Hiding attachment");

		// turn off attachment
		if( AttachSlots[Slot].StaticMesh != None )
		{
			AttachSlots[Slot].StaticMesh.SetBlockRigidBody(FALSE);
			AttachSlots[Slot].StaticMesh.SetHidden(TRUE);
		}

		if( AttachSlots[Slot].SkeletalMesh != None )
		{
			AttachSlots[Slot].SkeletalMesh.SetHidden(TRUE);
		}
	}
	else if( InvClassMesh != None )
	{
		// update attachment
		// depending on what type of mesh the weapon is, choose the appropriate slot component
		if( InvClassMesh.IsA('SkeletalMeshComponent') )
		{
			if( AttachSlots[Slot].SkeletalMesh == None )
			{
				AttachSlots[Slot].SkeletalMesh = new(Self) class'SkeletalMeshComponent';
			}
			SkeletalMeshComponent	= AttachSlots[Slot].SkeletalMesh;
			PrimComponent			= SkeletalMeshComponent;
			// if it is a gas tank
			if (ClassIsChildOf(AttachClass, class'GearWeap_GasTankBase'))
			{
				EquippedGasTankComponent = SkeletalMeshComponent;

				SkeletalMeshComponent.SetPhysicsAsset(SkeletalMeshComponent(InvClassMesh).PhysicsAsset);

				SkeletalMeshComponent.SetTraceBlocking(TRUE,TRUE);

				SkeletalMeshComponent.SetRBChannel(RBCC_Default);
				SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Default, TRUE);
				SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_BlockingVolume, TRUE);
				SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_EffectPhysics, TRUE);
				SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_GameplayPhysics, TRUE);
				SkeletalMeshComponent.SetRBCollidesWithChannel(RBCC_Pawn, TRUE);

				SkeletalMeshComponent.SetActorCollision(TRUE,FALSE);
				SkeletalMeshComponent.SetBlockRigidBody(TRUE);
			}
		}
		else
		{
			if( AttachSlots[Slot].StaticMesh == None )
			{
				AttachSlots[Slot].StaticMesh = new(Self) class'StaticMeshComponent';
			}
			StaticMeshComponent = AttachSlots[Slot].StaticMesh;
			PrimComponent		= StaticMeshComponent;
			// disable collision that is on by default on staticmeshes
			PrimComponent.SetActorCollision(FALSE, FALSE);
			PrimComponent.SetBlockRigidBody(FALSE);
		}


		// Verify that slot component is attached to Mesh
		if( !Mesh.IsComponentAttached(PrimComponent) )
		{
			if (AttachSlots[Slot].bAttachToBone)
			{
				// attach to bone
				Mesh.AttachComponent(PrimComponent, AttachSlots[Slot].SocketName);
			}
			else
			{
				// attach to socket
				Mesh.AttachComponentToSocket(PrimComponent, AttachSlots[Slot].SocketName);
			}
			PrimComponent.SetShadowParent(Mesh);
			PrimComponent.SetLightEnvironment(LightEnvironment);
			PrimComponent.MotionBlurScale = 0.0;
		}

		// set our staticmesh to be the component
		if( StaticMeshComponent != None )
		{
			StaticMeshComponent.SetStaticMesh( StaticMeshComponent(InvClassMesh).StaticMesh );
		}
		else
		{
			SkeletalMeshComponent.SetSkeletalMesh( SkeletalMeshComponent(InvClassMesh).SkeletalMesh );
		}

		`LogInv( "SetAttachmentVisibility: " $ PrimComponent @ self @ AttachClass );

		if (WeapClass != None)
		{
			//@see GearWeapon.SetMaterialBasedOnTeam

			// Check for the pawn having picked up a weapon and then the player defaults
			MIC_WeaponSkin = UpdateWeaponSkinForMesh(WeapClass,MeshComponent(PrimComponent));

			TeamNum = GetMPWeaponColorBasedOnClass();
			//`log( "MP TeamNum" @ TeamNum );

			if( TeamNum == 0 )
			{
				LC = WeapClass.static.GetWeaponEmisColor_COG( WorldInfo, WeapClass.default.WeaponID );
			}
			else
			{
				LC = WeapClass.static.GetWeaponEmisColor_Locust( WorldInfo, WeapClass.default.WeaponID );
			}

			//`log( AttachClass @ "SetAttachmentVisibility LC " $ LC.A @ LC.R @ LC.G @ LC.B );
			MIC_WeaponSkin.SetVectorParameterValue( 'Weap_EmisColor', LC );
		}

		// show this one
		PrimComponent.SetHidden(FALSE);

		// apply the weapon's transforms to this component
		PrimComponent.SetTranslation( InvClassMesh.Translation );
		PrimComponent.SetRotation( InvClassMesh.Rotation );
		PrimComponent.SetScale3D( InvClassMesh.Scale * InvClassMesh.Scale3D );
	}
}

/**
 * perform any required clean up on attachments
 * ShadowParent crashes when garbage collection is performed, clear references.
 */
simulated function CleanupAttachSlots()
{
	local PrimitiveComponent Primitive;
	local int Idx;

	for( Idx=0; Idx<AttachSlots.Length; Idx++ )
	{
		if( AttachSlots[Idx].SkeletalMesh != None )
		{
			Primitive = AttachSlots[Idx].SkeletalMesh;

		}
		else if( AttachSlots[Idx].StaticMesh != None )
		{
			Primitive = AttachSlots[Idx].StaticMesh;
		}

		if(Primitive != None)
		{
			Primitive.SetShadowParent(None);
			Primitive.SetLightEnvironment(None);
		}
	}
}


final simulated function bool IsSlotLeftShoulder(GearPawn.EAttachSlot Slot)
{
	return(	(!bIsMirrored && Slot == EASlot_LeftShoulder) ||
			(bIsMirrored && Slot == EASlot_RightShoulder) );
}

final simulated function bool IsSlotRightShoulder(GearPawn.EAttachSlot Slot)
{
	return(	(bIsMirrored && Slot == EASlot_LeftShoulder) ||
			(!bIsMirrored && Slot == EASlot_RightShoulder) );
}

/**
 * Player just changed weapon
 * Network: Local Player and Server
 *
 * @param	OldWeapon	Old weapon held by Pawn.
 * @param	NewWeapon	New weapon held by Pawn.
 */
simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	local GearWeapon	OldWeap; //, NewWeap;

	`LogInv("OldWeapon:" @ OldWeapon @ "NewWeapon:" @ NewWeapon);

	//`log(WorldInfo.TimeSeconds @ "OldWeapon:" @ OldWeapon @ "NewWeapon:" @ NewWeapon);

	OldWeap = GearWeapon(OldWeapon);

	// detach old weapon from hand
	if( OldWeap != None )
	{
		OldWeap.DetachWeapon();
	}

	// attach old weapon to inventory slot
	AttachWeaponToSlot(OldWeap);

	// Save a reference to carried GearWeapon, so we don't cast all over the place.
	MyGearWeapon = GearWeapon(Weapon);

	if (OldWeap != None && OldWeap.CustomAnimSets.Length > 0)
	{
		UpdateAnimSetList();
	}
}

simulated function AttachWeapon()
{
	`LogInv("MyGearWeapon:" @ MyGearWeapon);

	if( MyGearWeapon != None )
	{
		// detach from attachment slots, to attach to hand!
		DetachWeaponFromSlot( MyGearWeapon );

		// attach to hand
		AttachWeaponToHand( MyGearWeapon );

		if (MyGearWeapon.CustomAnimSets.Length > 0)
		{
			// Update the animation sets related to the current weapon
			// Adding or removing weapon specific sets.
			UpdateAnimSetList();

			// Force Pawn mesh to be updated.
			if( Mesh != None )
			{
				Mesh.ForceSkelUpdate();
			}
		}

		// Set a timer to reupdate animations next frame. Sometimes during transitions, things get confused.
		SetTimer(0.01f, FALSE, nameof(UpdateAnimations));
	}
	else
	{
		`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Weapon == None for" @ Self @ "LocallyControlled:" @ IsLocallyControlled() @ "Weapon:" @ MyGearWeapon @ "RemoteWeaponRepInfo:" @ RemoteWeaponRepInfo.WeaponClass);
	}
}

/** Hook to start/stop move cycle anims override */
simulated function OnOverrideMoveCycleAnims(SeqAct_OverrideMoveCycleAnims InAction)
{
	// Play
	if( InAction.InputLinks[0].bHasImpulse )
	{
		AddMoveCycleOverrideSeqAct(InAction);
	}
	// Stop
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		RemoveMoveCycleOverrideSeqAct(InAction);
	}
}

native final function AddMoveCycleOverrideSeqAct(SeqAct_OverrideMoveCycleAnims InAction);
native final function RemoveMoveCycleOverrideSeqAct(SeqAct_OverrideMoveCycleAnims InAction);
/**
 * Update MoveCycleOverrides, called from Tick.
 * Triggers Start/Stop events.
 */
native simulated final function UpdateMoveCycleOverride(FLOAT DeltaTime);
/** Determines if a MoveCycleOverride should be playing. */
native simulated final function bool ShouldPlayMoveCycleOverride(SeqAct_OverrideMoveCycleAnims InAction);

/** Event Called when BodyStance should start playing */
event simulated StartMoveCycleOverride(SeqAct_OverrideMoveCycleAnims InAction)
{
	BS_Play(InAction.Animation, 1.f, InAction.BlendInTime, -1.f, TRUE, TRUE, InAction.AnimGroupName);
	if( InAction.bAnimGroupSlave )
	{
		BS_SetForceAlwaysSlaveFlag(InAction.Animation, TRUE);
	}

	ReplicatedMoveCycleOverrideSeqAct = InAction;
	bForceNetUpdate = true;
}

/** Stop Playing Animation */
event simulated StopMoveCycleOverride(SeqAct_OverrideMoveCycleAnims InAction)
{
	// Stop BodyStance
	BS_Stop(InAction.Animation, InAction.BlendOutTime);

	if (ReplicatedMoveCycleOverrideSeqAct == InAction)
	{
		ReplicatedMoveCycleOverrideSeqAct = None;
		bForceNetUpdate = true;
	}
}

/** Kismet Action to add/remove AnimSets. */
simulated function OnAddAnimSet(SeqAct_AddAnimSet InAction)
{
	// if on server, force replication now.
	if( Role == Role_Authority && WorldInfo.NetMode != NM_Standalone )
	{
		bForceNetUpdate = TRUE;
	}

	// Add AnimSets
	if( InAction.InputLinks[0].bHasImpulse )
	{
		if( InAction.AnimTree != None && Mesh.AnimTreeTemplate != InAction.AnimTree )
		{
			ReplicatedKismetAnimTree = InAction.AnimTree;
			Mesh.SetAnimTreeTemplate( InAction.AnimTree );
		}
		AddAnimSetsToKismetArray(InAction.AnimSets);
	}
	// Remove AnimSets
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		if( Mesh.AnimTreeTemplate != default.Mesh.AnimTreeTemplate )
		{
			ReplicatedKismetAnimTree = None;
			Mesh.SetAnimTreeTemplate( default.Mesh.AnimTreeTemplate );
		}
		RemoveAnimSetsFromKismetArray(InAction.AnimSets);
	}
}

simulated function AddAnimSetsToKismetArray(Array<AnimSet> AnimSetsList)
{
	local int ExistingIndex, NewIndex;
	for(NewIndex=0; NewIndex<AnimSetsList.Length; NewIndex++)
	{
		for(ExistingIndex=0; ExistingIndex<ArrayCount(KismetAnimSets); ExistingIndex++)
		{
			if( KismetAnimSets[ExistingIndex] == None )
			{
				KismetAnimSets[ExistingIndex] = AnimSetsList[NewIndex];
				break;
			}
		}
		if( ExistingIndex == ArrayCount(KismetAnimSets) )
		{
			`Warn(Self @ "Ran out of KismetAnimSets entries for" @ AnimSetsList[NewIndex]);
		}
	}

	UpdateAnimSetList();
}

simulated function RemoveAnimSetsFromKismetArray(Array<AnimSet> AnimSetsList)
{
	local int ExistingIndex, NewIndex;
	for(NewIndex=AnimSetsList.Length-1; NewIndex>=0; NewIndex--)
	{
		for(ExistingIndex = ArrayCount(KismetAnimSets) - 1; ExistingIndex >= 0; ExistingIndex--)
		{
			if( KismetAnimSets[ExistingIndex] == AnimSetsList[NewIndex] )
			{
				KismetAnimSets[ExistingIndex] = None;
				break;
			}
		}
	}
	UpdateAnimSetList();
}

/** Adds an array of custom animsets to the CustomAnimSets list which do not get replicated */
simulated function AddLocalCustomAnimSets(Array<AnimSet> AnimSetsList)
{
	local int Idx;

	for (Idx = 0; Idx < AnimSetsList.Length; Idx++)
	{
		if (AnimSetsList[Idx] != None)
		{
			CustomAnimSets.AddItem(AnimSetsList[Idx]);
		}
	}

	UpdateAnimSetList();
}

/** Removes an array of custom animsets from the CustomAnimSets list and does not replicate */
simulated function RemoveLocalCustomAnimSets(Array<AnimSet> AnimSetsList)
{
	local int Idx;

	for (Idx = 0; Idx < AnimSetsList.Length; Idx++)
	{
		if (AnimSetsList[Idx] != None)
		{
			CustomAnimSets.RemoveItem(AnimSetsList[Idx]);
		}
	}

	UpdateAnimSetList();
}

/** Build list of AnimSets for this Pawn */
simulated function BuildScriptAnimSetList()
{
	local int i;

	Super.BuildScriptAnimSetList();

	// Add weapon list
	if (MyGearWeapon != None && MyGearWeapon.CustomAnimSets.Length > 0)
	{
		AddAnimSets(MyGearWeapon.CustomAnimSets);
	}

	// Add Kismet list
	for (i = 0; i < ArrayCount(KismetAnimSets); i++)
	{
		//`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Adding AnimSet:" @ KismetAnimSets[i] @ "to" @ Self);
		if (KismetAnimSets[i] != None)
		{
			Mesh.AnimSets[Mesh.AnimSets.Length] = KismetAnimSets[i];
		}
	}

	// Add the non-replicated custom animsets
	if (CustomAnimSets.length > 0)
	{
		AddAnimSets(CustomAnimSets);
	}
}

simulated exec function UpdateAnimations()
{
	UpdateAnimSetList();
}

/** AnimSets list updated, post process them */
simulated event AnimSetListUpdated()
{
	if( IsDoingASpecialMove() )
	{
		SpecialMoves[SpecialMove].AnimSetsUpdated();
	}
}

simulated event bool RestoreAnimSetsToDefault()
{
	if( MutatedClass != None )
	{
		Mesh.AnimSets = MutatedClass.default.Mesh.AnimSets;
	}
	else
	{
		Mesh.AnimSets = default.Mesh.AnimSets;
	}

	return TRUE;
}


/**
 * Set a new profile on all the AimOffset nodes.
 */
simulated final function SetAimOffsetNodesProfile(Name NewProfileName)
{
	local int i;

	for(i=0; i<AimOffsetNodes.Length; i++)
	{
		AimOffsetNodes[i].SetActiveProfileByName(NewProfileName);
	}
}


/**
 * Spawn a slave weapon for remote clients.
 */
simulated protected function UpdateRemoteWeapon()
{
	local GearWeapon Weap;
	local GearWeapon OldHolsterWeapon;

	`LogInv("Class:" @ RemoteWeaponRepInfo.WeaponClass @ "bHadAPreviousWeapon:" @ RemoteWeaponRepInfo.BYTE_bHadAPreviousWeapon);

	// If we got same weapon, do nothing.
	if( MyGearWeapon != None && !MyGearWeapon.bDeleteMe && RemoteWeaponRepInfo.WeaponClass == MyGearWeapon.class )
	{
		`LogInv("Got same weapon, make sure it's in a good state");

		// Prevent PendingWeapon from getting stuck in the PendingClientWeaponSet state
		InvManager.ClearPendingWeapon();

		// Ensure the current weapon is properly active, abort putting it down if need be
		if (MyGearWeapon.IsInState('Inactive') || MyGearWeapon.IsInState('WeaponPuttingDown'))
		{
			InvManager.SetCurrentWeapon(MyGearWeapon);
		}

		// Clear the delayed put down flag
		MyGearWeapon.bWeaponPutDown = FALSE;

		return;
	}

	// If we didn't have a previous weapon, then get rid of the one we have now.
	if (RemoteWeaponRepInfo.BYTE_bHadAPreviousWeapon == 0 && MyGearWeapon != None && !MyGearWeapon.bDeleteMe)
	{
		MyGearWeapon.ClientWeaponThrown();
	}
	// Handle the case of picking up a pistol while holding a rifle, need to get the old pistol thrown into EASlot_None
	else if (RemoteWeaponRepInfo.WeaponClass.default.WeaponType == WT_Holster)
	{
		OldHolsterWeapon = GearWeapon(GearInventoryManager(InvManager).GetInventoryInSlot(EASlot_Holster));
		if (OldHolsterWeapon != None && OldHolsterWeapon.Class != RemoteWeaponRepInfo.WeaponClass)
		{
			OldHolsterWeapon.ClientWeaponThrown();
		}
	}

	// See if we can find the weapon in the Pawn's inventory
	if( RemoteWeaponRepInfo.WeaponClass != None )
	{
		Weap = GearWeapon(RemoteClientGetInventoryByClass(RemoteWeaponRepInfo.WeaponClass));
		if( Weap != None )
		{
			InvManager.SetCurrentWeapon(Weap);
		}
		else
		{
			if( WorldInfo.IsPlayingDemo() )
			{
				// nonlocal inventory is replicated for demos, wait for it
				SetTimer( 0.1, false, nameof(RefreshRemoteAttachments) );
			}
			else
			{
				`DLog("Couldn't switch to new weapon class!!!" @ RemoteWeaponRepInfo.WeaponClass @ "Weap == None");
			}
		}
	}
	else
	{
		if( MyGearWeapon != None )
		{
			MyGearWeapon.ClientWeaponThrown();
		}
	}
}


/**
* Spawn a slave weapon for remote clients.
*/
simulated protected function UpdateRemoteShield(class<Inventory> InvClass)
{
	local Inventory		Inv;
	local GearShield	ShieldInv;

	`LogInv("InvClass:" @ InvClass);

	if (InvClass != None)
	{
		// See if we can find the weapon in the Pawn's inventory.  Will be created
		// if it doesn't exist.
		Inv = RemoteClientGetInventoryByClass(InvClass);

		ShieldInv = GearShield(Inv);

		if (ShieldInv != None)
		{
			EquipShield(ShieldInv);
		}
		else if (WorldInfo.IsPlayingDemo())
		{
			// nonlocal inventory is replicated for demos, wait for it
			SetTimer( 0.1, false, nameof(RefreshRemoteAttachments) );
		}
	}
	else
	{
		if (EquippedShield != None)
		{
			DropShield();
		}
	}
}


/** This takes care of Spawning an Inventory Manager for remote clients if needed */
simulated final function RemoteClientSetupInvManager()
{
	// Need an inventory manager for remote Pawns...
	// but not for demo playback because it gets replicated in that case
	if (InvManager == None && !WorldInfo.IsPlayingDemo() && !IsLocallyControlled())
	{
		InvManager = Spawn(InventoryManagerClass, Self);
		if( InvManager == None )
		{
			`log("Warning! Couldn't spawn InventoryManager" @ InventoryManagerClass @ "for" @ Self @ GetHumanReadableName());
		}
		else
		{
			InvManager.RemoteRole = ROLE_None;
			InvManager.SetupFor(Self);
		}
	}
}

/**
 * Tries to find an inventory item (e.g. a weapon) in the remote's pawn inventory.
 * it if doesn't exist, it is spawned.
 */
simulated function Inventory RemoteClientGetInventoryByClass(class<Inventory> InvClass)
{
	local Inventory Inv;
	local GearWeapon Weap;

	// Make sure we have an inventory manager
	if( InvManager == None )
	{
		`LogInv("InvManager == None, calling RemoteClientSetupInvManager");
		RemoteClientSetupInvManager();
	}

	// First see if we're already carrying this weapon
	Inv = InvManager.FindInventoryType(InvClass);
	// if not, let's see if we can create it
	if( Inv == None )
	{
		if( !IsLocallyControlled() && !WorldInfo.IsPlayingDemo()  )
		{
			Inv = InvManager.CreateInventory(InvClass, TRUE);
			if (Inv != None)
			{
				// if it's a weapon, set up some extra data
				Weap = GearWeapon(Inv);
				if( Weap != None )
				{
					// Set this weapon as being a Slave.
					Weap.bSlaveWeapon	= TRUE;
					Weap.RemoteRole		= Role_None;
				}
			}
			else
			{
				`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Couldn't Spawn new inventory class!!!" @ InvClass);
			}
		}
		else
		{
			`LogInv("Not allowed to Spawn inventory!! Inv:" @ Inv @ "LocallyControlled:" @ IsLocallyControlled() @ "PlayingDemo:" @ WorldInfo.IsPlayingDemo());
		}
	}

	return Inv;
}


/**
 * Attach specified Weapon to Pawn's hand.
 * Supplied weapon Actor is usually Pawn.Weapon.
 * this function sets up the replication for remote clients,
 * and attaches the weapon components to the right socket.
 */
simulated function AttachWeaponToHand(GearWeapon Weap)
{
	// attach to right hand socket
	`LogInv("attach" @ Weap @ "to" @ Weap.GetDefaultHandSocketName(Self));
	if (Weap != None && !Weap.Mesh.bAttached)
	{
		// Handle player's weapon customization
		UpdateWeaponSkinForMesh(Weap.Class, Weap.Mesh, Weap.MIC_WeaponSkin);

		Weap.AttachWeaponTo(Mesh, Weap.GetDefaultHandSocketName(Self));

		// turn off dynamic casting shadows on AI weapons
		if (Weap.Mesh != None && MyGearAI != None)
		{
			Weap.Mesh.bCastDynamicShadow = false;
		}
	}
}

final simulated function Name GetLeftHandSocketName()
{
	// we have inverted sockets because of animation mirroring
	if( bIsMirrored )
	{
		return RightHandSocketName;
	}
	return LeftHandSocketName;
}


/**
 * Set Pawn mirroring.
 * FALSE = Normal, facing right in cover, cam over right shoulder.
 * TRUE = Mirrored, facing left in cover, cam over left shoulder.
 * This sets the bWantsToBeMirrored flag. This flag will force the animations to find a proper transition ASAP
 * And when that is done, bIsMirrored flag will be updated, and MirroredNotify() will be called.
 */
final simulated event SetMirroredSide(bool bDesiredMirrored)
{
	if( bWantsToBeMirrored != bDesiredMirrored )
	{
		if (Role < ROLE_Authority && (Controller == None || !Controller.IsLocalPlayerController()))
		{
			// non-owning clients just get the flag directly from the server
			return;
		}

		// Tell animations that we'd like to turn...
		bWantsToBeMirrored = bDesiredMirrored;

		if( GearPC(Controller) != None )
		{
			GearPC(Controller).CoverLog("bDesiredMirrored:" @ bDesiredMirrored, GetFuncName());
		}

		if( Role == Role_Authority )
		{
			// Force replication
			bForceNetUpdate = TRUE;
		}
	}
}


/**
 * Notification called from the animation system when player is mirrored.
 * Called when bIsMirrored changes status.
 */
simulated event OnMirroredNotify()
{
	if( Weapon != None && !Weapon.IsA('GearWeap_HeavyBase') )
	{
		AdjustWeaponDueToMirror();
	}
}

/** Weapon mirror notify. Used by heavy weapons. */
simulated function MirrorWeaponAnimNotify()
{
	AdjustWeaponDueToMirror();
}

/** Notification that a mirror transition is finished, and blending out. */
simulated event OnMirrorBlendOutNotify()
{
	//`log(WorldInfo.TimeSeconds @ GetFuncName());

	// Verify that weapon has been properly mirrored and reattached.
	// Re-attach will only be performed if necessary.
	AdjustWeaponDueToMirror();

	// Mirror transition is blending out, prevent IK Controllers from being turned back on,
	// if weapon requested some off.
	InternalUpdateBoneLeftHandIK();
}


/**
 * Update IK Controllers, locked to IK Bones, based on weapon settings.
 * Some weapons, like pistol and grenade, do not want the left hand to be IKed to the IK Bones.
 * @note: You should not call this function directly, call UpdateBoneLeftHandIK() instead.
 */
simulated final private function InternalUpdateBoneLeftHandIK()
{
	local bool	bSet;

	// If IK Status is locked, don't do anything!
	if( bLockIKStatus )
	{
		return;
	}

	// Turn on by default.
	bSet = ShouldLeftHandIKBeOn();

	// If mirrored, disable right hand IK
	if( bIsMirrored )
	{
		if( IKBoneCtrl_RightHand != None )
		{
			IKBoneCtrl_RightHand.SetSkelControlActive(bSet);
		}
	}
	// Otherwise disable left hand IK
	else
	{
		if( IKBoneCtrl_LeftHand != None )
		{
			IKBoneCtrl_LeftHand.SetSkelControlActive(bSet);
		}
	}
}

/**
 * Tests if Left Hand IK should be ON or OFF.
 * Extend this function to add more conditions to it.
 */
simulated function bool ShouldLeftHandIKBeOn()
{
// 	// Disable left hand IK when switching weapons.
// 	if( bSwitchingWeapons && !bEquipTransition )
// 	{
// 		return FALSE;
// 	}
//
// 	// If weapon wants to disable Left Hand IK, then turn it off
// 	if( MyGearWeapon != None && MyGearWeapon.bDisableLeftHandIK )
// 	{
// 		return FALSE;
// 	}
//
// 	// See if Special Move requires to disable left hand IK
// 	if( SpecialMove != SM_None && SpecialMoves[SpecialMove].bDisableLeftHandIK )
// 	{
// 		return FALSE;
// 	}

	// Otherwise left hand IK should be always on.
	return TRUE;
}


/**
 * Conditional version of the above function.
 * Prevents enabling IK during a mirror transition, which would break mirroring.
 */
simulated final function UpdateBoneLeftHandIK()
{
	// Do not turn on IK on IK Bones during a mirror transition
	// When mirror transition is done, InternalUpdateBoneLeftHandIK() will be called.
	if( bDoingMirrorTransition )
	{
		return;
	}

	InternalUpdateBoneLeftHandIK();
}


/**
 * Used to reattach the weapon to the proper sockets.
 *
 * @see OnMirroredNotify
 */
simulated function AdjustWeaponDueToMirror()
{
	//`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Weapon:" @ MyGearWeapon);

	if( MyGearWeapon != None )
	{
		MyGearWeapon.AdjustWeaponDueToMirror(Self);
	}
}

/**
 * Overridden to preserve data from the previous AI controller,
 * if applicable.
 */
function OnAssignController(SeqAct_AssignController inAction)
{
	local GearAI oldController, newController, chkController;
	local TeamInfo team;
	oldController = GearAI(Controller);
	if (oldController != None &&
		ClassIsChildOf(inAction.ControllerClass,class'GearAI'))
	{
		// only update if it's a new class
		if (inAction.ControllerClass != oldController.Class)
		{
			newController = GearAI(Spawn(inAction.ControllerClass));
			if (newController != None)
			{
				// copy over data
				oldController.CopyTo(newController);
				newController.PlayerReplicationInfo = PlayerReplicationInfo;
				// replace any refs
				foreach WorldInfo.AllControllers(class'GearAI', chkController)
				{
					chkController.ReplaceRefs(oldController, newController);
				}
				// possess the pawn
				DetachFromController(true);
				oldController.Destroy();
				newController.Possess(self,false);
				// and update team assignment
				team = PlayerReplicationInfo.Team;
				team.AddToTeam(newController);
			}
		}
	}
	else
	{
		Super.OnAssignController(inAction);
	}
}

function OnToggleWeaponSwappable(SeqAct_ToggleWeaponSwappable Action)
{
	local GearWeapon Weap;
	local int Idx;
	for (Idx = 0; Idx < Action.WeaponTypes.Length; Idx++)
	{
		Weap = GearWeapon(InvManager.FindInventoryType(Action.WeaponTypes[Idx]));
		if (Weap != None)
		{
			Weap.bSwappable = Action.InputLinks[0].bHasImpulse;
		}
	}
}

function OnToggleSuperTroopers(SeqAct_ToggleSuperTroopers Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		// Set the super damage multiplier
		SuperDamageMultiplier = Action.SuperDamageMultiplier;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		// Reset the super damage multiplier
		SuperDamageMultiplier = 1.f;
	}
}

function KickPawnOffTurret()
{
	local Turret Turr;
	local GearPawnRidable_Base RidablePawn;
	local GearVehicleBase GV;

	Turr = Turret(DrivenVehicle);
	if (Turr != None)
	{
		DrivenVehicle.DriverLeave(TRUE);

		// Needs to be done after driver leave because MyGearAI will be reset when possession changes
		if (MyGearAI != none)
		{
			Turr.UnclaimTurret(MyGearAI);
		}
	}

	GV = GearVehicleBase(DrivenVehicle);
	if( GV != None && GV.bKickDriverOnTeleport )
	{
		GV.DriverLeave( TRUE );
	}

	if (Base != none)
	{
		RidablePawn = GearPawnRidable_Base(Base);
		if (RidablePawn != none && RidablePawn.bAllowDriverDamage)
		{
			// Must call the RPC before detaching since RPCs only work for things connected to PlayerControllers
			RidablePawn.ClientForceDriverDetach();
			RidablePawn.DriverLeave(TRUE);
		}
	}
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	local GearPC PC;

	// Clear anchor
	SetAnchor( None );

	// Kick players out of cover
	PC = GearPC( Controller );
	if ( PC != None )
	{
		PC.ClientBreakFromCover();
		PC.ClientResetCameraInterpolation();
	}
	else if (GearAI(Controller) != None)
	{
		GearAI(Controller).InvalidateCover();
	}

	// revive if DBNO
	if (IsDBNO())
	{
		DoRevival(self);
	}

	// kick pawn off of turret
	KickPawnOffTurret();

	// Clear special move
	if( Role == ROLE_Authority )
	{
		// If we are in one of the engage special moves, make sure we end it
		if( IsDoingSpecialMove(SM_Engage_Start) ||
			IsDoingSpecialMove(SM_Engage_Loop) ||
			IsDoingSpecialMove(SM_Engage_Idle) ||
			IsDoingSpecialMove(SM_Engage_End) )
		{
			ServerDoSpecialMove(SM_Engage_End, true);
		}
		else
		{
			ServerDoSpecialMove(SM_None);
		}
	}

	// Do teleport
	super.OnTeleport( Action );
}

/**
 * Looks at the current slot index and sets the appropriate cover type.
 */
final function SetCurrentCoverType(optional bool bClear)
{
	//debug
	`AILog_Ext( GetFuncName()@bClear@"L/R/C"@LeftSlotIdx@RightSlotIdx@CurrentSlotIdx@CoverType, 'Cover', MyGearAI );

	if( !bClear && CurrentLink != None )
	{
		SetCoverType( FindCoverType() );
	}
	else
	{
		SetCoverType(CT_None);
	}
}

final function ECoverType FindCoverType()
{
	if (bWantsToCrouch)
	{
		return CT_MidLevel;
	}
	if( CurrentLink == None || (ClosestSlotIdx < 0 && CurrentSlotIdx < 0) )
	{
		return CT_None;
	}
	return CurrentLink.Slots[ClosestSlotIdx != -1 ? ClosestSlotIdx : CurrentSlotIdx].CoverType;
}

/**
 * Return cover type fo given cover position info.
 */
final simulated function ECoverType GetCoverTypeFor(CovPosInfo Cover)
{
	local ECoverType	LeftType, RightType;

	if( Cover.Link == None )
	{
		return CT_None;
	}

	if( Cover.Link.Slots.Length > 1 )
	{
		if( Cover.LtToRtPct == 0.f || Cover.RtSlotIdx < 0 )
		{
			return Cover.Link.Slots[Cover.LtSlotIdx].CoverType;
		}
		else if( Cover.LtToRtPct == 1.f || Cover.LtSlotIdx < 0 )
		{
			return Cover.Link.Slots[Cover.RtSlotIdx].CoverType;
		}
		else
		{
			// opt for the lower of the two
			LeftType	= Cover.Link.Slots[Cover.LtSlotIdx].CoverType;
			RightType	= Cover.Link.Slots[Cover.RtSlotIdx].CoverType;
			return (LeftType > RightType ? LeftType : RightType);
		}
	}

	return Cover.Link.Slots[0].CoverType;
}


/**
 * Return best facing direction in cover (mirrored or not).
 * Used when acquiring new cover, to find the best starting direction to face.
 */
final simulated function ECoverDirection FindBestCoverSideFor(CovPosInfo CovInfo)
{
	local CoverLink			Link;
	local Vector			CovToPawnDir;
	local bool				bOnRightSlot, bOnLeftSlot, bCanLeanLeft, bCanLeanRight;
	local ECoverType		CovType;
	local ECoverDirection	Out_CovDir360;
	local Rotator			DeltaRot;
	local vector2d			TestAimOffsetPct;
	local vector			CamLoc, LtToRtSlots;
	local rotator			CamRot;
	local float				NudgeDistance;

	// if on server, just use what client told me
	if( !IsLocallyControlled() )
	{
		if( FreshCoverDirectionTime != WorldInfo.TimeSeconds )
		{
			if( Role == ROLE_Authority )
			{
				ScriptTrace();
			}
		}
		else
		{
			return ReplicatedCoverDirection;
		}
	}

	// Find what cover type this is going to be
	CovType	= GetCoverTypeFor(CovInfo);

	// Find out delta angle between pawn's rotation he would face in cover and actual rotation.
	// This simulates the AimOffsetPct the Pawn would have in cover.
	DeltaRot			= Normalize(Rotation - Rotator(-1.f*CovInfo.Normal));
	TestAimOffsetPct.X	= NormalizeRotAxis(DeltaRot.Yaw)	/ 16384.f;
	TestAimOffsetPct.Y	= NormalizeRotAxis(DeltaRot.Pitch)	/ 16384.f;

	// See if Pawn would be entering in 360 aiming in cover
	if( Simulate360Aiming(FALSE, TestAimOffsetPct, CovType, Out_CovDir360) )
	{
		return Out_CovDir360;
	}

	// Test if doing a sideways entry in cover.
	// In that case, camera orientation dictates cover facing direction.
	if( Abs(TestAimOffsetPct.X) > 0.6f )
	{
		if( TestAimOffsetPct.X > 0.f )
		{
			return CD_Right;
		}

		return CD_Left;
	}

	//@experimental - rely on the camera orientation rather than pawn location for the edge cases where to pawn to cover would not line up with what the player is desiring
	if (GearPC(Controller) != None)
	{
		GearPC(Controller).GetPlayerViewPoint(CamLoc,CamRot);
		CovToPawnDir = -vector(CamRot);
	}
	else
	{
		// default to the pawn location if no player is available
		CovToPawnDir = Location - CovInfo.Location;
	}
	CovToPawnDir.Z	= 0.f;
	CovToPawnDir	= Normal(CovToPawnDir);

	Link	= CovInfo.Link;
	// figre out which slot(s) we're standing on
	if (CovInfo.LtSlotIdx != CovInfo.RtSlotIdx)
	{
		NudgeDistance = CylinderComponent.CollisionRadius * 0.5f;
		LtToRtSlots = Link.GetSlotLocation(CovInfo.LtSlotIdx) - Link.GetSlotLocation(CovInfo.RtSlotIdx);

		// Where is cover from the slots?
		bOnLeftSlot			= CovInfo.LtToRtPct <= (NudgeDistance/VSize2D(LtToRtSlots));
		bOnRightSlot		= CovInfo.LtToRtPct >= (1.f - (NudgeDistance/VSize2D(LtToRtSlots)));
	}
	else
	{
		bOnLeftSlot = TRUE;
		bOnRightSlot = TRUE;
	}

	// if coverinfo isn't valid just return current cover direction
	if( CovInfo.LtSlotIdx < 0 || CovInfo.RtSlotIdx < 0  )
	{
		return CoverDirection;
	}

	bCanLeanLeft = (bOnLeftSlot && Link.Slots[CovInfo.LtSlotIdx].bLeanLeft) || (bOnRightSlot && Link.Slots[CovInfo.RtSlotIdx].bLeanLeft);
	bCanLeanRight = (bOnRightSlot && Link.Slots[CovInfo.RtSlotIdx].bLeanRight) || (bOnLeftSlot && Link.Slots[CovInfo.LtSlotIdx].bLeanRight);

	// if we can only lean left, go for left
	if (bCanLeanLeft && !bCanLeanRight)
	{
		ReplicatedCoverDirection = CD_Left;
		return CD_Left;
	}
	else
	// same for lean right
	if (bCanLeanRight && !bCanLeanLeft)
	{
		ReplicatedCoverDirection = CD_Right;
		return CD_Right;
	}
	// otherwise we can't lean, or can lean both ways, so pick based on camera
	else
	{
		// either we're approaching a steep angle or a slight one, so pick the best direction based on the tangent
		// looking at left side
		if( CovToPawnDir dot CovInfo.Tangent > 0.f )
		{
			ReplicatedCoverDirection = CD_Left;
			return CD_Left;
		}
		// looking at right side
		else
		{
			ReplicatedCoverDirection = CD_Right;
			return CD_Right;
		}
	}
}


/**
 * Called by physics once we reach a cover slot location.
 */
simulated event ReachedCoverSlot(int SlotIdx)
{
	local GearPC			PC;
	local GearAI_Cover		AI;
	local int				OldSlotIdx;

	//`log(WorldInfo.TimeSeconds @ GetFuncName());

	OldSlotIdx	   = CurrentSlotIdx;
	CurrentSlotIdx = SlotIdx;
	ClosestSlotIdx = SlotIdx;

	// notify our controller
	PC = GearPC(Controller);
	if( PC != None )
	{
		PC.NotifyReachedCoverSlot( SlotIdx, OldSlotIdx );
	}
	else
	{
		AI = GearAI_Cover(Controller);
		if( AI != None )
		{
			//debug
			`AILog_Ext( self@"ReachedCoverSlot"@SlotIdx, 'Cover', AI );

			AI.NotifyReachedCoverSlot( SlotIdx );
		}
	}

	// apply in replicated struct for non-owning clients
	AcquiredCoverInfo.LtSlotIdx = LeftSlotIdx;
	AcquiredCoverInfo.RtSlotIdx = RightSlotIdx;
	AcquiredCoverInfo.LtToRtPct = CurrentSlotPct;

	// update the current cover type
	SetCurrentCoverType();
}

/** Returns TRUE if Pawn is standing right on a cover slot */
final simulated function bool IsOnACoverSlot()
{
	return (RightSlotIdx == LeftSlotIdx || IsAtCoverEdge(bIsMirrored,TRUE,1.f));
}

/*
function DumpCoverInfo(CovPosInfo CovInfo)
{
	`log(" Link:" @ CovInfo.Link @ "Location:" @ CovInfo.Location @ "Normal:" @ CovInfo.Normal);
	`log(" LtSlotIdx:" @ CovInfo.LtSlotIdx @ "RtSlotIdx:" @ CovInfo.RtSlotIdx @ "LtToRtPct:" @ CovInfo.LtToRtPct);
}

// Dumps out all pawn's cover related information
function DumpPawnCover()
{
	if (CurrentLink!=none)
	{
		`log(" Link:" @ CurrentLink @ "Location:" @ CurrentLink.Location @ "Normal:" @ CurrentLink.Normal @ "CoverType:" @ CoverType);
		`log(" LtSlotIdx:" @ LeftSlotIdx @ "RtSlotIdx:" @ RightSlotIdx @ "CurrentSlotIdx:" @ CurrentSlotIdx @ "ClosestSlotIdx:" @ ClosestSlotIdx @ "CurrentSlotPct:" @ CurrentSlotPct);
	}
	else
	{
		`log("Cover Link isn't set yet");
	}
}
*/

simulated function CovPosInfo CoverInfoToCovPosInfo(CoverInfo CovInfo)
{
	local CovPosInfo	TheInfo;

	TheInfo.Link		= CovInfo.Link;
	TheInfo.LtSlotIdx	= CovInfo.SlotIdx;
	TheInfo.RtSlotIdx	= CovInfo.SlotIdx;
	TheInfo.Location	= CovInfo.Link.GetSlotLocation(CovInfo.SlotIdx);
	TheInfo.LtToRtPct	= 0.f;
	TheInfo.Normal		= vector(CovInfo.Link.GetSlotRotation(CovInfo.SlotIdx)) * -1.f;

	return TheInfo;
}

/** Returns TRUE if Pawn is doing a run2cover special move */
native final simulated function bool IsDoingRun2CoverSpecialMove();

/**
 * Event called when cover has been acquired.
 */
simulated function CoverAcquired(CovPosInfo CovInfo)
{
	local ESpecialMove Move;
	local Actor A;
	local array<SequenceEvent> TouchEvents;
	local int i;

	// Set Cover type
	SetCoverAction(CA_Default);

	CurrentSlotDirection = CD_Default;

	// For now translate all cover info properties to old system.
	// but i'd like to use just that one variable, and have AI use that as well.
	SetCovPosInfo(CovInfo);

	CurrentLink.Claim(self, CurrentSlotIdx);

	LastCoverAcquireDistanceSq = VSizeSq2D(CovInfo.Location - Location);
	AcquiredCoverInfo	= CovInfo;

	// If pawn can play run2cover slide transition, do the special move
	if (bCanDoRun2Cover && (Role == ROLE_Authority || IsLocallyControlled()))
	{
		// Suggest best move depending on cover information
		if (GetCoverTypeFor(CovInfo) == CT_MidLevel)
		{
			Move = SM_Run2MidCov;
		}
		else
		{
			Move = SM_Run2StdCov;
		}

		// perform the special move here for the server and the locally controlled client
		// note that we make no attempt to match up the transition anim
		// as long as root motion isn't involved, it doesn't make any difference
		// because the client side hit detection will allow the client to hit what it sees
		// even if the animation is different on the other side
		if (CanDoSpecialMove(Move))
		{
			DoSpecialMove(Move);
		}
		if (IsLocallyControlled() && GearPC(Controller) != None)
		{
			GearPC(Controller).bSendCoverTransition = true;
		}
	}

	// Play slide in cover animations locally, and replicate to remote clients
	bForceNetUpdate = TRUE;

	if (Role == ROLE_Authority)
	{
		// check to see if we need to kick off kismet 'geartouch' events when we enter cover
		foreach TouchingActors(class'Actor', A)
		{
			if (A.FindEventsOfClass(class'SeqEvt_GearTouch', TouchEvents))
			{
				for (i = 0; i < TouchEvents.length; i++)
				{
					SeqEvt_GearTouch(TouchEvents[i]).CheckCoverStatusTouchActivate(A,self,true,false);
				}
				// clear array for next iteration
				TouchEvents.length = 0;
			}
		}
	}
}

simulated function SetCovPosInfo(CovPosInfo CovInfo)
{
	SetCoverInfo(
		CovInfo.Link,
		(CovInfo.LtToRtPct < 0.5f ? CovInfo.LtSlotIdx : CovInfo.RtSlotIdx),
		CovInfo.LtSlotIdx,
		CovInfo.RtSlotIdx,
		CovInfo.LtToRtPct);
}

simulated function SetCoverInfo(CoverLink Link, int SlotIdx, int LeftIdx, int RightIdx, float SlotPct)
{
	//ScriptTrace();
	//`AILog_Ext(GetFuncname()@Link@SlotIdx@LeftIdx@RightIdx@SlotPct@bReplicate,,MyGearAI);
	// simulate the claims for clients
	if (Role < ROLE_AutonomousProxy)
	{
		if (CurrentLink != None)
		{
			CurrentLink.UnClaim(self,CurrentSlotIdx,FALSE);
		}
	}

	CurrentLink		= Link;
	CurrentSlotIdx	= SlotIdx;
	ClosestSlotIdx  = SlotIdx;
	LeftSlotIdx		= LeftIdx;
	RightSlotIdx	= RightIdx;
	CurrentSlotPct	= SlotPct;
	SetCurrentCoverType();

	// simulate the claims for clients
	if (Role < ROLE_AutonomousProxy)
	{
		if (CurrentLink != None)
		{
			CurrentLink.Claim(self,SlotIdx);
		}
	}
}

/** Transform a SlotInfo (CoverInfo) into a CoverInfo (CovPosInfo) */
native simulated function bool SetCoverInfoFromSlotInfo(out CovPosInfo OutCovInfo, CoverInfo SlotInfo);

/*
 * Pawn has left cover - clean up associated vars
 */
exec function LeaveCover()
{
	local array<SequenceEvent> TouchEvents;
	local Actor A;
	local SeqEvt_GearTouch TouchEvt;
	local int Idx;
	local GearPC PC;

	`LogSM("");

	if (Role == ROLE_Authority)
	{
		// check to see if we need to kick off kismet 'geartouch' events when we leave cover
		foreach TouchingActors(class'Actor', A)
		{
			if (A.FindEventsOfClass(class'SeqEvt_GearTouch', TouchEvents))
			{
				for (Idx = 0; Idx < TouchEvents.Length; Idx++)
				{
					TouchEvt = SeqEvt_GearTouch(TouchEvents[Idx]);
					TouchEvt.CheckCoverStatusTouchActivate(A,self,FALSE,TRUE);
				}
				// clear array for next iteration
				TouchEvents.Length = 0;
			}
		}
		 if(CurrentLink != None)
		 {
			 PC = GearPC(Controller);
			 if (PC != None)
			 {
				 // We need to see if we are in pushable cover and determine if we need to free the AI from helping us
				 PC.FreeAIFromCoverPushHelp();
			 }
		 }
	}

	//debug
	`AILog_Ext( self@"LeaveCover"@CurrentLink@CurrentSlotIdx, 'Cover', MyGearAI );

	// Reset cover transition information
	AcquiredCoverInfo.Link	= None;
	bForceNetUpdate = TRUE;

	PreviousSlotIdx	 = CurrentSlotIdx;
	CurrentSlotPct	 = -1;
	CurrentSlotIdx	 = -1;
	CurrentLink		 = None;
	bGrabbingMovableCover = FALSE;
	SetCoverAction(CA_Default);

	// Force reset any transition cover data
	SetCurrentCoverType( TRUE );

	// Set the player into an alert mode when leaving cover.
	// Don't do that for heavy weapons, as it forces the player to walk.
	if( MyGearWeapon != None && MyGearWeapon.WeaponType != WT_Heavy )
	{
		SetWeaponAlert(5.f);
	}

	StopBloodTrail( 'SpawnABloodTrail_Wall' );
}


function PlaySlidingSound()
{
	local SoundCue SlideOverride;

	SlideOverride = class'GearPhysicalMaterialProperty'.static.DetermineSlidingSound(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( LastFootStepTraceInfo ), CharacterFootStepType);

	if(SlideOverride != none)
	{
		PlaySound(SlideOverride);
		return;
	}

	`log("Failed To Find Slide Sound");

	PlaySound(SoundCue'Foley_Footsteps.FootSteps.Footsteps_Locust_DirtSlide_Cue');
}

simulated function PlayLeapingSound()
{
	local SoundCue LeapingSound;

	LeapingSound = class'GearPhysicalMaterialProperty'.static.DetermineLeapingSound(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( LastFootStepTraceInfo ), CharacterFootStepType);

	if (LeapingSound != none)
	{
		PlaySound(LeapingSound, true);
		//`log( "PlayLeapingSound" @ LeapingSound );
		return;
	}
	`log("Failed To Find Leaping Sound");
}

simulated function PlayLandingSound()
{
	local SoundCue LandingSound;

	if (FRand() > 0.5f)
	{
		SoundGroup.PlayEffort(self, GearEffort_LandLightEffort, true);
	}

	if (Role == ROLE_Authority)
	{
		MakeNoise(0.75f, 'PlayLandingSound');
	}


	LandingSound = class'GearPhysicalMaterialProperty'.static.DetermineLandingSound(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( LastFootStepTraceInfo ), CharacterFootStepType);

	//trace down for land sounds (climb down, evade when feet hit, mantle)
	if (LandingSound != none)
	{
		PlaySound(LandingSound, true);
		//`log( "PlayLandingSound" @ LandingSound );
		return;
	}
	// leap sounds	(climb down, mantle, evade)
	// slide sounds ( sliding)
	`log("Failed To Find Landing Sound");
}


/**
 *	Event from c++ land that tells us to play a footstep
 **/
simulated event PlayFootStepSound( int FootDown )
{
	local float Loudness;
	local GearPC PC;

	if( Role == ROLE_Authority )
	{
		// Noise loudness based on movement speed
		Loudness = (VSize(Velocity) / GroundSpeed);
		MakeNoise( Loudness*Loudness*Loudness, 'NOISETYPE_FootStep' );
	}

	// for each local player we want to see if they are relevant for hearing footsteps and seeing particle effects
	ForEach LocalPlayerControllers( class'GearPC', PC )
	{
		// 300.0f is from the SoundCue DiststanceCrossFade/Attenuation node
		if( (PC.ViewTarget != None) && (VSize(PC.ViewTarget.Location - Location) < 3000.0f) )
		{
			//`log( (VSize(PC.ViewTarget.Location - Location) ));
			ActuallyPlayFootstepSound( PC, FootDown );
			break; // only place this once please :)
		}
	}
}

/**
 * Handles actual playing of sound.  Separated from PlayFootstepSound so we can LOD / distance code
 * determine if we should be playing FootSteps
 *
 * @param LocalPC - Local player controller we're playing the sound on 
 * @param FootDown - which foot is hitting the ground, 0 is left, 1 is right
 */
simulated function ActuallyPlayFootstepSound(GearPC LocalPC, int FootDown)
{
	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local SoundCue FootStepSoundCue;
	local float VolumeMultipler;

	if (WorldInfo.TimeSeconds - LastRenderTime > 3.0)
	{
		TraceStart = Location;
		TraceStart.Z -= CylinderComponent.CollisionHeight * 0.9;
		TraceDest = Location;
		TraceDest.Z -= CylinderComponent.CollisionHeight * 1.1;
	}
	else if (FootDown == 0)
	{
		TraceStart = Mesh.GetBoneLocation(LeftKneeBoneName, 0);
		TraceDest = Mesh.GetBoneLocation(LeftFootBoneName, 0);
	}
	else
	{
		TraceStart = Mesh.GetBoneLocation(RightKneeBoneName, 0);
		TraceDest = Mesh.GetBoneLocation(RightFootBoneName, 0);
	}

	TraceDest = TraceDest + (TraceDest - TraceStart); // push the dest lower than the foot so we hit something

	// trace down and see what we are standing on
	TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, TRACEFLAG_Bullet|TRACEFLAG_PhysicsVolumes);

	if (TraceActor != none)
	{
		// check to see if this is a water volume and use that special WaterPhysMaterials
		if (GearWaterVolume(TraceActor) != None)
		{
			LastFootStepTraceInfo.PhysMaterial = GearWaterVolume(TraceActor).WaterPhysMaterial;
		}

		// play the actual sound now
		FootStepSoundCue = class'GearPhysicalMaterialProperty'.static.DetermineFootStepSound(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), CharacterFootStepType);

		if (!WorldInfo.GRI.OnSameTeam(LocalPC, self))
		{
			VolumeMultipler = EnemyFootStepVolume;
		}
		else
		{
			VolumeMultipler = TeamFootStepVolume;
		}

		if (FootStepSoundCue != None)
		{
			LocalPC.ClientPlayModifiedSound(FootStepSoundCue, self, out_HitLocation, false, VolumeMultipler, 1.0);
		}
		else
		{
			`Log(Self @ GetFuncName() @ "could not find footstep sound for stepping on" @ `showvar(TraceActor));
		}

		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			ActuallyPlayFootParticleEffect(FootDown, LastFootStepTraceInfo, out_HitLocation);
		}

		return;
	}
	// otherwise we hit nothing and are in the air
}


/**
 * This will figure out which material we are standing on and then play the
 * correct footstep effect.
 * It looks up the PhysicalMaterial tree until it finds a valid effect to Spawn.
 * If it does not find one then it defaults the effect coded in to the .uc file
 * for that specific character.
 **/
final simulated function ActuallyPlayFootParticleEffect( int FootDown, TraceHitInfo HitInfo, vector HitLocation )
{
	local PhysicalMaterial ParentPhysMaterial;
	local ParticleSystem PS;
	local ParticleSystem FootStepEffect;
	local vector BoneLocation;

	// if we are in the rain then play water footsteps
	// NOTE: right now terrain does not return material for traces so we need to do this
// 	if( bShouldPlayWetFootSteps )
// 	{
// 		//PlaySound( SoundCue'Foley_Footsteps.FootSteps.Footsteps_Marcus_Water_Cue', FALSE, TRUE );
// 		return;
// 	}

	// if we do not have a PhysicalMaterial
	if( HitInfo.PhysMaterial != none )
	{
		//`log( "we have a physMaterial" );
		FootStepEffect = GetFootStepEffect( HitInfo.PhysMaterial, FootDown );
	}
	else
	{
		// check to see if there is a material
		// if there is no material then we must use the default PS_DefaultImpactEffect
		if( HitInfo.Material != none )
		{
			FootStepEffect = GetFootStepEffect( HitInfo.Material.PhysMaterial, FootDown );
		}
		else
		{
			// "Default footsteps effects" is nothing!
			return;
		}
	}


	// so here we need to look up the "hierarchy" if we have a none in the attribute we want
	// and we probably want to maybe have a code fall back to play some default
	// if the content doens't provide our hungry mouths with data

	// if we have no phys material
	if( HitInfo.PhysMaterial != none )
	{
		ParentPhysMaterial = HitInfo.PhysMaterial.Parent;
	}
	// set the parent phys material here
	else
	{
		// check to see if the material has a phys material
		if( HitInfo.Material.PhysMaterial != none )
		{
			ParentPhysMaterial = HitInfo.Material.PhysMaterial.Parent;
		}
		else
		{
			ParentPhysMaterial = none;
		}
	}


	// this will walk the tree until our parent is null or we have a footstep effect
	// at which point we will break out (which is basically an exception case)
	// but there are no exceptions in .uc land
	while( ( FootStepEffect == none )
		&& ( ParentPhysMaterial != none )
		)
	{
		// look at our parent's data
		FootStepEffect = GetFootStepEffect( ParentPhysMaterial, FootDown );
		ParentPhysMaterial = ParentPhysMaterial.Parent;
	}


	// use the material based effect
	if( FootStepEffect != none )
	{
		//`log( " Playing Effect: " $ FootStepEffect );
		PS = FootStepEffect;
	}
	// do default behavior
	else
	{
		//`log( " Playing Default effect" );
		//PS = None;
		return;
	}

	// these are probably deprecated
// 	if( FootDown == 1 )
// 	{
// 		BoneLocation = Mesh.GetBoneLocation( RightFootBoneName, 0 );
// 	}
// 	else
// 	{
// 		BoneLocation = Mesh.GetBoneLocation( LeftFootBoneName, 0 );
// 	}

	BoneLocation = HitLocation;

	// if we could not find the bone name then the BoneLocation should be vect(0,0,0)
	if (!IsZero(BoneLocation))
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(PS, BoneLocation, Rotation);
	}
}

/**
 * Looks to see if the Sound on the current PhysicalMaterial is valid.
 **/
final function ParticleSystem GetFootStepEffect( PhysicalMaterial PMaterial, int FootDown )
{
	local ParticleSystem Retval;

	Retval = none;

	// our Specific properties exists now we need to call our function to get out
	// the specificProperty
	if( ( none != PMaterial )
		&& ( none != PMaterial.PhysicalMaterialProperty )
		&& ( none != GearPhysicalMaterialProperty(PMaterial.PhysicalMaterialProperty) )
		)
	{
		Retval = GetSpecificFootStepEffect( GearPhysicalMaterialProperty(PMaterial.PhysicalMaterialProperty), FootDown );
	}
	else
	{
		Retval = none;
	}

	return Retval;
}


/**
 * Each object is going to override this and return the data based off the passed in
 * Object.	(e.g.  GetSpecificFootStepSound called on a marcus will look up the
 * marcus footstep sound, called on a locust will look up the locust sound)
 **/
function ParticleSystem GetSpecificFootStepEffect( GearPhysicalMaterialProperty FootStepSounds, int FootDown )
{
	local ParticleSystem Retval;

	// do possible computation or what not.
	if( GroundSpeed > ( GroundSpeed * WalkingPct ) )
	{
		Retval = FootStepSounds.FootstepEffectRun;
	}
	else
	{
		Retval = FootStepSounds.FootstepEffectWalk;
	}

	return Retval;
}

/** this will return the Particle System to be used when we need to invoke an override **/
simulated function ParticleSystem GetImpactOverrideParticleSystem();

/**
 * list important Pawn variables on canvas.	 HUD will call DisplayDebug() on the current ViewTarget when
 * the ShowDebug exec is used
 *
 * @param	HUD		- HUD with canvas to draw on
 * @input	out_YL		- Height of the current font
 * @input	out_YPos	- Y position on Canvas. out_YPos += out_YL, gives position to draw text for next debug line.
 */
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas	Canvas;
	local GearPC 	PC;
	local GearPawn	GP;
	local String	Text;
	local ECoverLocationDescription LocDesc;
	local float XPos,TexScale;
	local int Idx;
	local Texture DiffuseTexture;

	Canvas = HUD.Canvas;

	XPos = 4;
	out_YPos = 0;
	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (GP.GoreMaskTexture != None)
		{
			DiffuseTexture = None;
			if (GP.Mesh != None && GP.Mesh.SkeletalMesh.Materials.Length > 0 && MaterialInstanceConstant(GP.Mesh.SkeletalMesh.Materials[0]) != None)
			{
				for (Idx=0; Idx < MaterialInstanceConstant(GP.Mesh.SkeletalMesh.Materials[0]).TextureParameterValues.Length; Idx++)
				{
					if (MaterialInstanceConstant(GP.Mesh.SkeletalMesh.Materials[0]).TextureParameterValues[Idx].ParameterName == 'Diffuse')
					{
						DiffuseTexture = MaterialInstanceConstant(GP.Mesh.SkeletalMesh.Materials[0]).TextureParameterValues[Idx].ParameterValue;
						break;
					}
				}
			}
			if (DiffuseTexture != None)
			{
				TexScale = 128.0 / DiffuseTexture.GetSurfaceWidth();
				Canvas.SetPos(XPos,0);
				Canvas.SetDrawColor(255, 255, 255);
				Canvas.DrawTexture(DiffuseTexture, TexScale);
			}
			TexScale = 128.0 / GP.GoreMaskTexture.GetSurfaceWidth();
			Canvas.SetPos(XPos,0);
			Canvas.SetDrawColor(255, 0, 0);
			if (DiffuseTexture != None)
			{
				Canvas.DrawTextureBlended(GP.GoreMaskTexture, TexScale, BLEND_Additive);
			}
			else
			{
				Canvas.DrawTextureBlended(GP.GoreMaskTexture, TexScale, BLEND_Opaque);
			}
			Canvas.SetPos(XPos,0);
			Canvas.SetDrawColor(255, 255, 0);
			Canvas.DrawText(GP);
			XPos += GP.GoreMaskTexture.GetSurfaceWidth() * TexScale;
			out_YPos = GP.GoreMaskTexture.GetSurfaceHeight() * TexScale;
		}
	}

	Canvas.SetDrawColor(255, 255, 255);

	super.DisplayDebug(HUD, out_YL, out_YPos);
	Canvas.DrawText(" CoverType:" @ CoverType @ `showvar(CoverAction) @ `showvar(CoverDirection) @ `showvar(CurrentSlotDirection) @ "IsAtCoverEdge:"@IsAtCoverEdge(bIsMirrored,TRUE) @ `showvar(bIsWalking) );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" IsDoingLeaningTo360Transition:" @ IsDoingLeaningTo360Transition() @ `showvar(`TimeSince(Last360AimingChangeTime)) @ `showvar(PreviousCoverAction) );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" bWantsToBeMirrored:" @ bWantsToBeMirrored @ `showvar(bIsMirrored) @ `showvar(bDoingMirrorTransition) );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" SpecialMove:" @ SpecialMove @ `showvar(MTO_MeshLocSmootherOffset));
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" AimOffset:" @ AimOffsetPct.X @ AimOffsetPct.Y @ `showvar(ReplicatedAimOffsetPct) @ `showvar(bDoing360Aiming) @ `showvar(HeadTrackCurrentBlendSpeed) @ `showvar(HeadTrackBlendTargetWeight) @ `showvar(HeadTrackBlendWeightToTarget) );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" bCoverActionAnimTransition:" @ bDoingCoverActionAnimTransition @ `showvar(CoverActionAnim) @ `showvar(LastCoverActionAnim) );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" bPendingFire:" @ bPendingFire @ "CommitToFiring:" @ PawnCommitToFiring(0) @ "CanFireWeapon:" @ CanFireWeapon() @ "ShouldDelayFiring:" @ ShouldDelayFiring() );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Text = " bIsTargeting:" @ bIsTargeting;
	PC = GearPC(Controller);
	if( PC != None )
	{
		Text = Text @ "WantsToTarget:" @ PC.WantsToTarget() @ "CanTarget:" @ PC.CanTarget();
	}
	Canvas.DrawText(Text);
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText(" bDoingMeleeAttack:" @ bDoingMeleeAttack @ "bWantsToMelee:" @ bWantsToMelee @ "bPendingMeleeAttack:" @ bPendingMeleeAttack @ "CanEngageMelee:" @ CanEngageMelee() @ "ShouldDelayMeleeAttack:" @ ShouldDelayMeleeAttack() );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);
	Canvas.DrawText(" LastTookDamage:" @ `TimeSince(LastTookDamageTime) );
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	LocDesc = (CurrentLink != None) ? CurrentLink.GetLocationDescription(CurrentSlotIdx) : CoverDesc_None;
	Canvas.DrawText(" CoverDescription:"@LocDesc);
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	if( Controller != None && AIController(Controller) != None )
	{
		Canvas.DrawText(" Force Rotation:" @ IsDesiredRotationLocked()@ DesiredRotation);
		out_YPos += out_YL;
		Canvas.SetPos(4, out_YPos);

		DrawDebugLine(Location, Location + Vector(DesiredRotation) * 300.f, 0, 0, 255);
	}

	//if (GearPC(Controller) != None)
	//{
	//	Canvas.DrawText(" LocalEnemies:");
	//	out_YPos += out_YL;
	//	Canvas.SetPos(4, out_YPos);

	//	for (Idx=0; Idx<GearPC(Controller).LocalEnemies.Length; ++Idx)
	//	{
	//		Canvas.DrawText("  "@GearPC(Controller).LocalEnemies[Idx].Enemy@GearPC(Controller).LocalEnemies[Idx].bSeen);
	//		out_YPos += out_YL;
	//		Canvas.SetPos(4, out_YPos);
	//	}

	//	Canvas.DrawText(" BattleStatus:");
	//	out_YPos += out_YL;
	//	Canvas.SetPos(4, out_YPos);

	//	for (Idx=0; Idx<GearGame(WorldInfo.Game).BattleMonitor.COGBattleStatus.KnownEnemies.Length; ++Idx)
	//	{
	//		Canvas.DrawText("  "@GearGame(WorldInfo.Game).BattleMonitor.COGBattleStatus.KnownEnemies[Idx]);
	//		out_YPos += out_YL;
	//		Canvas.SetPos(4, out_YPos);
	//	}
	//}
}


/**
 * Event called from native code when Pawn starts crouching.
 * Called on non owned Pawns through bIsCrouched replication.
 * Network: ALL
 *
 * @param	HeightAdjust	height difference in unreal units between default collision height, and actual crouched cylinder height.
 */
simulated event StartCrouch(float HeightAdjust)
{
	super.StartCrouch(HeightAdjust);

	// offset mesh by height adjustment
	if( Mesh != None )
	{
		Mesh.SetTranslation(Mesh.Translation + Vect(0,0,1)*HeightAdjust);
	}
}

/**
 * Event called from native code when Pawn stops crouching.
 * Called on non owned Pawns through bIsCrouched replication.
 * Network: ALL
 *
 * @param	HeightAdjust	height difference in unreal units between default collision height, and actual crouched cylinder height.
 */
simulated event EndCrouch(float HeightAdjust)
{
	super.EndCrouch(HeightAdjust);

	// offset mesh by height adjustment
	if( Mesh != None )
	{
		Mesh.SetTranslation(Mesh.Translation - Vect(0,0,1)*HeightAdjust);
	}
}


simulated function ActiveReloadSuccess( bool bDidSuperSweetReload )
{
	local GearPC		GPC;
	local GearHUD_Base	WH;

	if (Role == ROLE_Authority)
	{
		if( bDidSuperSweetReload )
		{
			//@STATS - Active Reload Super Success
			`RecordWeaponIntStat(ACTIVE_RELOAD_SUPER_SUCCESS,Controller,Weapon.Class,1);
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_SucceededActiveReload, Self);
		}
		else
		{
			//@STATS - Active Reload Success
			`RecordWeaponIntStat(ACTIVE_RELOAD_SUCCESS,Controller,Weapon.Class,1);
		}
	}

	// give GearPC a crack at responding to the event
	GPC = GearPC(Controller);

	if( GPC != None )
	{
		GPC.ActiveReloadSuccess( bDidSuperSweetReload );

		// give GearHUD_Base a crack at responding to the event
		WH = GearHUD_Base(GPC.myHUD);
		if ( WH != None )
		{
			WH.ActiveReloadSuccess( bDidSuperSweetReload );
		}
	}
}


simulated function ActiveReloadFail( bool bFailedActiveReload )
{
	local GearPC		GPC;
	local GearHUD_Base	WH;
	local GearGame	WG;

	if (Role == ROLE_Authority)
	{
		if (bFailedActiveReload)
		{
			//@STATS - Record Active Reload Fail
			`RecordWeaponIntStat(ACTIVE_RELOAD_FAILED,Controller,Weapon.Class,1);
		}
	}

	WG = GearGame(WorldInfo.Game);
	if (WG != None)
	{
		WG.TriggerGUDEvent(GUDEvent_FailedActiveReload, Self);
	}

	// give GearHUD_Base a crack at responding to the event
	GPC = GearPC(Controller);
	if( GPC != None )
	{
		WH = GearHUD_Base(GPC.myHUD);
		if ( WH != None )
		{
			WH.ActiveReloadFail( bFailedActiveReload );
		}
	}
}

/**
* Respond to SpecialMove kismet action
*/
simulated function OnSpecialMove(SeqAct_SpecialMove inAction)
{
	local ESpecialMove SM;
	local GearPawn InInteractionPawn;
	local Controller InteractionPawnController;

	if( inAction.InputLinks[0].bHasImpulse )
	{
		if( inAction.SpecialMove == None ||
			SpecialMoveClasses.Find(inAction.SpecialMove) != INDEX_NONE )
		{
			if( inAction.SpecialMove == None )
			{
				SM = SM_None;
			}
			else
			{
				SM = ESpecialMove(SpecialMoveClasses.Find(inAction.SpecialMove));
			}

			// allow controller to be interaction pawn
			InInteractionPawn = GearPawn(inAction.InteractionPawn);
			if ( InInteractionPawn == none )
			{
				// try controller
				InteractionPawnController = Controller(inAction.InteractionPawn);
				if ( InteractionPawnController!=none )
				{
					InInteractionPawn = GearPawn(InteractionPawnController.Pawn);
				}
			}

			`logSM(Self @ GetFuncName() @ "SpecialMove:" @ inAction.SpecialMove @ "InteractionPawn:" @ InInteractionPawn @ "SpecialMoveFlags:" @ inAction.SpecialMoveFlags);

			if( MyGearAI != None )
			{
				MyGearAI.HandleScriptedSpecialMove(SM, inAction.AlignActor, InInteractionPawn, inAction.SpecialMoveFlags);
			}
			else
			{
				// End Special move
				if( IsDoingASpecialMove() )
				{
					EndSpecialMove();
				}

				if( SM != SM_None )
				{
					ServerDoSpecialMove(SM, false, InInteractionPawn, inAction.SpecialMoveFlags);

					// Something to align to?
					if( inAction.AlignActor != None )
					{
						Controller.SetDestinationPosition( inAction.AlignActor.Location, true );
						Controller.bPreciseDestination	= true;
					}
				}
			}
		}
	}
}

/**
 * Kismet hook to force entering a vehicle
 */
simulated function OnGearEnterVehicle( SeqAct_GearEnterVehicle inAction )
{
	local bool	 bEntered;
	local GearAI AI;

	local Vehicle V;
	local GearVehicle GV;

	AI = MyGearAI;

	V = Vehicle(inAction.TargetVehicle);

	if (V != None)
	{
		GV = GearVehicle(V);
		if (GV != None)
		{
			// SeatIndex == -1 means any seat
			if (inAction.SeatIndex < 0)
			{
				bEntered = GV.TryToDrive(self);
			}
			// respect SeatIndex
			else
			{
				bEntered = GV.TryToDriveSpecificSeat(self, inAction.SeatIndex);
			}
		}
		else
		{
			// handles turrets, etc
			bEntered = V.TryToDrive(self);
		}
		if (!bEntered)
		{
			`Warn("Failed to enter vehicle" @ inAction.TargetVehicle @ " (self.DrivenVehicle:" @ DrivenVehicle $ ")");
		}
	}

	if (GearPawnRidable_Base(inAction.TargetVehicle) != None)
	{
		bEntered = GearPawnRidable_Base(inAction.TargetVehicle).TryToDrive(self);
		if (!bEntered)
		{
			`Warn("Failed to enter vehicle" @ inAction.TargetVehicle);
		}
	}

	// Handle AI entering/exiting a vehicle
	if( AI != None )
	{
		if( bEntered )
		{
			if( GearWeaponPawn(AI.Pawn) != None )
			{
				AI.DefaultCommand = class'AICmd_Base_DriveVehicleWeapon';
				AI.AbortCommand(AI.CommandList);
				AI.BeginCombatCommand(class'AICmd_Base_DriveVehicleWeapon');
			}
			else
			{
				AI.DefaultCommand = class'AICmd_Base_DriveVehicle';
			}
		}
		else
		{
			AI.DefaultCommand = AI.default.DefaultCommand;
		}
	}
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
	Super.OnSetMaterial(Action);

	if (Action.MaterialIndex == 0)
	{
		ReplicatedMaterial = Action.NewMaterial;
		bForceNetUpdate = true;
	}
}

/**
 * Kismet hook to set desired rotation
 *
 * @param inAction - the kismet action
 */
simulated function OnSetDesiredRotation(SeqAct_SetDesiredRotation inAction)
{
	SetDesiredRotation(inAction.DesiredRotation, TRUE, TRUE, inAction.InterpolationTime, TRUE);
}

/**
 * Kismet hook to play custom animations
 */
simulated function OnGearPlayerAnim(SeqAct_GearPlayerAnim inAction)
{
	local GearPC PC;
	local bool bPlay;

	if (Health > 0 && !IsDBNO() && !IsAHostage() && Mesh.RootMotionMode == RMM_Ignore)
	{
		bPlay = InAction.InputLinks[0].bHasImpulse;

		ProcessGearPlayerAnim(InAction, bPlay);

		// if we're the server, replicate it out to non-local players
		if (WorldInfo.NetMode != NM_Client)
		{
			foreach WorldInfo.AllControllers(class'GearPC', PC)
			{
				PC.ClientPlayGearPlayerAnim(self, InAction, bPlay);
			}
		}
	}
}

/** performs the actual work for GearPlayerAnim Kismet action, separated so it can be shared with client side code */
simulated function ProcessGearPlayerAnim(SeqAct_GearPlayerAnim InAction, bool bPlay)
{
	local float AnimDuration;

	if (!InAction.bSkipSpecialMoveEnd)
	{
		SetTargetingMode(false);
		if (GearPC(Controller) != None)
		{
			GearPC(Controller).SetTargetingMode(false);
		}
		// we need to force special moves to end as any animations it may be relying on will be disrupted
		if (Role == ROLE_Authority)
		{
			ServerEndSpecialMove();
		}
		else
		{
			EndSpecialMove();
		}
	}

	// Setup body stance
	if( InAction.BStance.Stance.Length != 0 )
	{
		KismetBodyStance = InAction.BStance;
	}
	else
	{
		KismetBodyStance.Stance.Length = 1;
		KismetBodyStance.Stance[0].AnimName = inAction.AnimName;
		KismetBodyStance.Stance[0].Slot = inAction.bPlayUpperBodyOnly ? BS_Std_Up : BS_FullBody;
	}

	if (bPlay)
	{
		// Play animation
		if( InAction.PlayMode == AnimPM_Rate )
		{
			AnimDuration = BS_Play(KismetBodyStance, inAction.Rate, inAction.BlendInTime, inAction.BlendOutTime, inAction.bLooping, inAction.bOverride);
		}
		else
		{
			BS_PlayByDuration(KismetBodyStance, inAction.Duration, inAction.BlendInTime, inAction.BlendOutTime, inAction.bLooping, inAction.bOverride);
			AnimDuration = inAction.Duration;
		}

		// Support for playing animation at an arbitrary start position.
		if( inAction.StartTime > 0.f )
		{
			BS_SetPosition(KismetBodyStance, inAction.StartTime);
		}

		// If animation uses Root Motion, set it up on character.
		if( InAction.bUseRootMotion )
		{
			BS_SetRootBoneAxisOptions(KismetBodyStance, RBA_Translate, RBA_Translate, RBA_Translate);
			Mesh.RootMotionMode = RMM_Accel;

			// Set timer to turn off body stance when animation starts
			SetTimer( AnimDuration - inAction.BlendOutTime, FALSE, nameof(TurnOffKismetRootMotion) );
		}
	}
	else
	{
		// Stop body stance
		BS_Stop(KismetBodyStance, inAction.BlendOutTime);

		// If animation uses Root Motion, set it up on character.
		if( InAction.bUseRootMotion )
		{
			ClearTimer('TurnOffKismetRootMotion');
			Mesh.RootMotionMode = Mesh.default.RootMotionMode;
			BS_SetRootBoneAxisOptions(KismetBodyStance, RBA_Discard, RBA_Discard, RBA_Discard);
		}
	}
}

/** Turn off root motion set by Kismet action */
simulated function TurnOffKismetRootMotion()
{
	Mesh.RootMotionMode = Mesh.default.RootMotionMode;
	BS_SetRootBoneAxisOptions(KismetBodyStance, RBA_Discard, RBA_Discard, RBA_Discard);
}

/**
 * Duration is how long the animation will play, including transition to the animation (but not from)
 * Pass a Duration <= 0 to play indefinitely.
*/
exec function PlayHeadCoverAnim(float DurationSec, optional bool bDisableRoadieRun)
{
	local GearPawn_SilverbackBase Silverback;

	if (!IsDBNO() && !IsDoingSpecialMove(SM_Kidnapper_Execution))
	{
		//@STATS - Record player cringe
		`RecordPlayerIntStat(CRINGE,Controller,1);

		Silverback = GearPawn_SilverbackBase(Self);

		// when holding a dead meatshield (standard gametypes), lose the meatshield but prevent any negative effects
		// when holding an immortal character (leader in CTL, etc) we still get the full effects
		if (IsAKidnapper() && InteractionPawn.CanBeSpecialMeleeAttacked(self))
		{
			ServerEndSpecialMove(SpecialMove);
		}
		else if (Silverback != None && Silverback.Driver == None)
		{
			Silverback.SetDisabledStatus(TRUE);
		}
		// if carrying a shield, drop it
		else if (IsCarryingShield())
		{
			DropShield();
		}
		else
		{
			// heavy weapons get dropped but that doesn't stop the effect
			if (IsCarryingAHeavyWeapon())
			{
				ThrowActiveWeapon();

				// Flail smashing special move will get stuck if the animation is interrupted, assuming that this can also happen on current/future heavy weapons that do special moves
				ServerEndSpecialMove(SpecialMove);
			}
			if (IsAKidnapper())
			{
				ServerEndSpecialMove(SpecialMove);
			}
			if (IsDoingSpecialMove(SM_ChainsawHold))
			{
				ForceStopMeleeAttack(true);
				ServerDoSpecialMove(SM_ChainsawInterrupt, true);
				PlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue');
			}

			if (!bCoveringHead && (!IsDoingASpecialMove() || (bDisableRoadieRun && IsDoingSpecialMove(SM_RoadieRun))))
			{
				if (Base != None && Base.IsA('GearPawn_SilverbackBase'))
				{
					Silverback = GearPawn_SilverbackBase(Base);
					Silverback.DriverLeave(TRUE);
					Silverback.SetDisabledStatus(TRUE);
				}

				KickPawnOffTurret();

				PlayHeadCoverAnim_Internal();

				bCoveringHead = true;
				bCannotRoadieRun = bDisableRoadieRun;

				if (bCannotRoadieRun && IsDoingSpecialMove(SM_RoadieRun))
				{
					ServerEndSpecialMove(SM_RoadieRun);
				}

				if (DurationSec >= 0.0)
				{
					SetTimer(DurationSec, false, nameof(StopPlayingHeadCoverAnim));
				}
			}
		}
	}
}

/** internal handler for head cover anim code shared between client and server */
simulated private function PlayHeadCoverAnim_Internal()
{
	BS_Play(BS_HeadCoverLoop, 1.0, 0.33f,, true, true);
}

/** Called on a timer to end the headcover anim */
simulated function StopPlayingHeadCoverAnim()
{
	if (bCoveringHead || Role < ROLE_Authority)
	{
		BS_Stop(BS_HeadCoverLoop, 0.67f);
		bCoveringHead = false;
		bCannotRoadieRun = false;
	}
}

/**
 * Turns of/off the "using commlink" mode, where the pawn
 * is walking and talking on his communicator (can have different anim,
 * different abilities, etc).  bUseCommLink is only used when bConv is true.
 */
simulated event SetConversing(bool bConv, optional bool bUseCommLink)
{
	if( bConv && !bIsConversing )
	{
		if( bUseCommLink )
		{
			SetUsingCommLink(TRUE);
		}
	}
	else if( !bConv && bIsConversing )
	{
		if( bUsingCommLink || bWantToUseCommLink )
		{
			SetUsingCommLink(FALSE);
		}

		bIsConversing = FALSE;
	}

	bWantToConverse = bConv;
	if (!bWantToConverse)
	{
		bWantToUseCommLink = FALSE;
	}

	// turn off roadie run
	if ( bConv )
	{
		if (IsDoingSpecialMove(SM_RoadieRun) )
		{
			EndSpecialMove(SM_RoadieRun);
		}
		else if (IsDoingSpecialMove(SM_RoadieRunStab) )
		{
			EndSpecialMove(SM_RoadieRunStab);
		}
	}
}

exec function ToggleCommLink()
{
	SetConversing(!bIsConversing, !bUsingCommLink);
}

/**
 * Pass TRUE to make pawn use the commlink.	 Pass FALSE to turn it off.
 */
simulated function SetUsingCommLink(bool bUsing)
{
	// Want to Stop using CommLink?
	if( !bUsing && bUsingCommLink )
	{
		if( IsDoingSpecialMove(SM_UsingCommLink) )
		{
			if (Role == ROLE_Authority)
			{
				ServerEndSpecialMove();
			}
			else
			{
				EndSpecialMove();
			}
			// Ending the special move will clear bUsingCommLink flag
		}
		else
		{
			bUsingCommLink = FALSE;
		}
	}

	bWantToUseCommLink = bUsing;

	// nuke any meatshields at this point to prevent edge cases of the player losing functionality
	if (bWantToUseCommLink && GearPC(Controller) != None)
	{
		GearPC(Controller).ExecuteMeatshields();
	}
}


/************************************************************************************
 * Weapon Holstering Interface
 * Controls Holstering/UnHolstering of weapon.
 * Note: This is to holster weapon temporarily, this is not the weapon switching code.
 ***********************************************************************************/

/**
 * Tells the Pawn to holster his weapon
 * returns TRUE is the weapon could be holstered
 */
simulated function bool HolsterWeapon()
{
	// If we have a weapon in hand and weapon is not already holstered
	if( MyGearWeapon != None && !MyGearWeapon.bTemporaryHolster && MyGearWeapon.WeaponType != WT_Heavy)
	{
		MyGearWeapon.HolsterWeaponTemporarily(TRUE);
		return TRUE;
	}

	return FALSE;
}


/**
 * Tells Pawn to re-equip his holstered weapon.
 */
simulated function UnHolsterWeapon()
{
	if( MyGearWeapon != None && MyGearWeapon.bTemporaryHolster )
	{
		MyGearWeapon.HolsterWeaponTemporarily(FALSE);
	}
}


/** Returns TRUE is weapon is currently holstered */
simulated final function bool IsWeaponHolstered()
{
	return (MyGearWeapon != None && MyGearWeapon.bTemporaryHolster);
}


/** Stops Holster related animations. */
simulated final function StopHolsterAnims()
{
	if( MyGearWeapon != None )
	{
		MyGearWeapon.StopHolsterAnims();
	}
}


/** gets called at point where weapon should attach/detach */
simulated function SetWeaponTemporarilyHolstered(bool bHolstered)
{
	local GearWeaponPawn WeapPawn;
	local bool bShouldManTurret;

	if( MyGearWeapon != None )
	{
		bWeaponHolstered = bHolstered;
		if( bHolstered )
		{
			// Detah weapon from hand
			MyGearWeapon.DetachWeapon();

			// attach weapon to inventory slot
			AttachWeaponToSlot(MyGearWeapon);

			if( IsDoingMeleeHoldSpecialMove() )
			{
				EndSpecialMove();
			}

			// Notify current Special Move that weapon has been holstered.
			if( SpecialMove != SM_None )
			{
				SpecialMoves[SpecialMove].WeaponTemporarilyHolstered();
			}

			// Holstered weapon, ready to grab troika handles
			if( DrivenVehicle != None )
			{
				bShouldManTurret = DrivenVehicle.IsA('Turret_TroikaBase');

				WeapPawn = GearWeaponPawn(DrivenVehicle);
				if (WeapPawn != None)
				{
					//Check on name since clients won't have the actual weapon
					bShouldManTurret = bShouldManTurret || (WeapPawn.MyVehicle.Seats[WeapPawn.MySeatIndex].GunClass.name == 'GearVWeap_KingRavenTurret');
				}

				if (bShouldManTurret)
				{
					StartManningTurret();
				}
			}
		}
		else
		{
			AttachWeapon();
		}
	}
}





/************************************************************************************
 * Animation
 ***********************************************************************************/

/**
 * Play a body stance animation.
 * This will play an animation on slots defined in the Pawn's AnimTree.
 * See definition of EBodyStance in GearPawn.uc
 *
 * @param	Stance			BodyStance animation to play.
 * @param	Rate			Rate animation should be played at.
 * @param	BlendInTime		Blend in time when animation is played.
 * @param	BlendOutTime	Time before animation ends (in seconds) to blend out.
 *							-1.f means no blend out.
 *							0.f = instant switch, no blend.
 *							otherwise it's starting to blend out at (Anim length - BlendOutTime) seconds.
 * @param	bLooping		Should the anim loop? (and play forever until told to stop by BS_Stop)
 * @param	bOverride		Play same animation over again from begining only if bOverride is set to TRUE.
 * @param	GroupName		Set if all the nodes playing an animation should be part of a group.
 *							In that case they would be synchronized, and only the most relevant animation would trigger notifies.
 *
 * @return	PlayBack length of animation assuming play rate remains constant.
 */
final native simulated function float BS_Play(const out BodyStance	InBodyStance,
				float		Rate,
	optional	float		BlendInTime,
	optional	float		BlendOutTime,
	optional	bool		bLooping,
	optional	bool		bOverride=TRUE,
	optional	Name		GroupName,
	optional    float       StartTime
);


/**
 * Play a body stance animation.
 * This will play an animation on slots defined in the Pawn's AnimTree.
 * See definition of EBodyStance in GearPawn.uc
 *
 * @param	Stance			BodyStance animation to play.
 * @param	Duration		Duration in seconds the animation should play for.
 * @param	BlendInTime		Blend in time when animation is played.
 * @param	BlendOutTime	Time before animation ends (in seconds) to blend out.
 *							-1.f means no blend out.
 *							0.f = instant switch, no blend.
 *							otherwise it's starting to blend out at (Anim length - BlendOutTime) seconds.
 * @param	bLooping		Should the anim loop? (and play forever until told to stop by BS_Stop)
 * @param	bOverride		Play same animation over again from begining only if bOverride is set to TRUE.
 * @param	GroupName		Set if all the nodes playing an animation should be part of a group.
 *							In that case they would be synchronized, and only the most relevant animation would trigger notifies.
 *
 * @return	PlayBack length of animation assuming play rate remains constant.
 */
final native simulated function BS_PlayByDuration(const out BodyStance	InBodyStance,
				float		Duration,
	optional	float		BlendInTime,
	optional	float		BlendOutTime,
	optional	bool		bLooping,
	optional	bool		bOverride=TRUE,
	optional	Name		GroupName);

/**
 * Returns TRUE if given BodyStance is being played currently.
 * Note that calling this from the AnimEnd notification is not reliable as the animation has technically stopped playing.
 */
final native simulated function bool BS_IsPlaying(const out BodyStance InBodyStance);

/** Returns TRUE if animation has any weight in the tree */
final native simulated function bool BS_HasAnyWeight(const out BodyStance InBodyStance);

/**
 * Returns TRUE if given AnimNodeSequence SeqNode belongs to the given BodyStance
 * ie is current triggered in the AnimTree, but not necessarily playing anymore. The animation could be stopped or blending/blended out.
 * This is more reliable when testing if a BodyStance is done playing in an AnimEnd notification.
 */
final native simulated function bool BS_SeqNodeBelongsTo(AnimNodeSequence SeqNode, const out BodyStance InBodyStance);

/**
 * Stop playing a body stance.
 * This will only stop the anim nodes playing the actual stance.
 */
final native simulated function BS_Stop(const out BodyStance InBodyStance, optional float BlendOutTime);

/** Set bPlaying flag on animations. */
final native simulated function BS_SetPlayingFlag(const out BodyStance InBodyStance, bool bNewPlaying);

/**
 * Stop playing all body stances.
 */
final native simulated function BS_StopAll(float BlendOutTime);

/**
 * Overrides a currently playing body stance with a new one.
 * It basically just switches animations.
 */
final native simulated function BS_Override(const out BodyStance InBodyStance);


/**
 * Changes the animation position of a body stance.
 */
final native simulated function BS_SetPosition(const out BodyStance InBodyStance, FLOAT Position);

/** Get position of a body stance */
final native simulated function float BS_GetPosition(const out BodyStance InBodyStance);

/**
 * Returns in seconds the time left until the animation is done playing.
 * This is assuming the play rate is not going to change.
 */
final native simulated function float BS_GetTimeLeft(const out BodyStance InBodyStance);

/** Returns default anim length in seconds */
final native simulated function float BS_GetAnimDefaultLength(const out BodyStance InBodyStance);

/**
 * Returns the Play Rate of a currently playing body stance.
 * if None is found, 1.f will be returned.
 */
final native simulated function float BS_GetPlayRate(const out BodyStance InBodyStance);

/** Set Play rate of the currently playing body stance. */
final native simulated function BS_SetPlayRate(const out BodyStance InBodyStance, float NewRate);

/** Scale Play rate of a Body Stance */
final native simulated function BS_ScalePlayRate(const out BodyStance InBodyStance, FLOAT RateScale);

/**
 * Forces an updated of the child weights.
 * Normally this is done in the tick function, but sometimes it is useful to enforce it.
 * For example when this node has already been ticked, and we want to force a new animation to play during the AnimEnd() event.
 */
final simulated function BS_AccelerateBlend(const out BodyStance InBodyStance, float BlendAmount)
{
	local int i;
	local GearAnim_Slot GearSlot;

	for(i=0; i<InBodyStance.Stance.Length; i++)
	{
		if( InBodyStance.Stance[i].AnimName != '' && InBodyStance.Stance[i].Slot < BodyStanceNodes.Length && BodyStanceNodes[InBodyStance.Stance[i].Slot] != None )
		{
			GearSlot = GearAnim_Slot(BodyStanceNodes[InBodyStance.Stance[i].Slot]);
			if( GearSlot != None )
			{
				GearSlot.AccelerateBlend(BlendAmount);
			}
		}
	}
}

final native simulated function BS_SetbZeroRootTranslation(const out BodyStance InBodyStance, bool InbZeroRootTranslation);

/** Set body stances animation root bone options. */
final native simulated function BS_SetRootBoneAxisOptions(const out BodyStance InBodyStance,
	optional	ERootBoneAxis	AxisX=RBA_Default,
	optional	ERootBoneAxis	AxisY=RBA_Default,
	optional	ERootBoneAxis	AxisZ=RBA_Default
);

/** Control Root Motion Rotation on currently playing Body Stance */
final native simulated function BS_SetRootRotationOption(const out BodyStance InBodyStance, ERootRotationOption RootRotationOption);

/**
 * Mirror a body stance animation.
 * Used by mirror transitions.
 */
final native simulated function BS_SetMirrorOptions(const out BodyStance InBodyStance, bool bTransitionToMirrored, bool bBeginTransition, bool bMirrorAnimation);

/** Request body stance animation to trigger OnAnimEnd event when done playing animation. */
final native simulated function BS_SetAnimEndNotify(const out BodyStance InBodyStance, bool bNewStatus);

/**
 * @see bEarlyAnimEndNotify for more details.
 * By default bEarlyAnimEndNotify is TRUE, meaning AnimEnd notifications will be triggered when the animation starts blending out.
 * Which is not when the animation has actually ended, but in most cases it improves transitions, blends and responsiveness.
 * BS_Play() and BS_PlayByDuration() automatically reset that option to TRUE, so you don't need to reset it when setting it to FALSE.
 */
final native simulated function BS_SetEarlyAnimEndNotify(const out BodyStance InBodyStance, bool bNewEarlyAnimEndNotify);

/**
 * Set bForceAlwaysSlave Flag on related AnimNodeSequence nodes.
 *
 * @param InBodyStance			BodyStance animation definition.
 * @param bNewForceAlwaysFlag	new value for the flag.
 */
final native simulated function BS_SetForceAlwaysSlaveFlag(const out BodyStance InBodyStance, bool bNewForceAlwaysFlags);

/** Event called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// Forward notification to Special Move if doing any.
	if( SpecialMove != SM_None )
	{
		`LogSM("SpecialMove ==" @ SpecialMove @ "calling BS_AnimEndNotify()");
		SpecialMoves[SpecialMove].BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
	}
}


simulated private function CameraBoneAnimEndNotification(AnimNodeSequence SeqNode)
{
	local GearPC GPC;

	GPC = GearPC(Controller);
	if (GPC != None)
	{
		GPC.CameraBoneAnimEndNotification();
	}
}


/** Plays a specific camera-bone animation. */
final simulated function PlayCustomCameraBoneAnim
(
				Name		AnimName,
				float		Rate,
	optional	float		BlendInTime,
	optional	float		BlendOutTime,
	optional	bool		bLooping,
	optional	bool		bOverride,
	optional	bool		bSingleRayPenetrationOnly,
	optional	bool		bApplyFullMotion
)
{
	if( (AnimName != '') && (CustomCameraAnimNode != None) )
	{
		CustomCameraAnimNode.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride);
		CustomCameraAnimProperties.bApplyFullMotion = bApplyFullMotion;
		CustomCameraAnimProperties.bSingleRayPenetrationOnly = bSingleRayPenetrationOnly;
		CustomCameraAnimNode.SetActorAnimEndNotification(TRUE);
	}
}

final simulated function StopCustomCameraBoneAnim(optional float BlendOutTime)
{
	if( CustomCameraAnimNode != None )
	{
		CustomCameraAnimNode.StopCustomAnim(BlendOutTime);
	}
}


/**
 * Returns true if any custom camera anim is playing, false otherwise.
 * SpecificAnimName: if specified, only checks to see if this particular anim is playing.
 */
final simulated event bool IsPlayingCustomCameraAnim(optional Name SpecificAnimName)
{
	local AnimNodeSequence SeqNode;

	if ( (CustomCameraAnimNode != None) && CustomCameraAnimNode.bIsPlayingCustomAnim )
	{
		if (SpecificAnimName != '')
		{
			SeqNode = CustomCameraAnimNode.GetCustomAnimNodeSeq();
			return (SeqNode.AnimSeqName == SpecificAnimName) ? TRUE : FALSE;
		}
		else
		{
			return TRUE;
		}
	}

	return FALSE;
}

/** Animation stopped playing notify */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local int	i;

	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);

	// See if the node that called is part of the BodyStanceNodes...
	for( i=0; i<BodyStanceNodes.Length; i++ )
	{
		if( BodyStanceNodes[i] != None )
		{
			if( SeqNode == BodyStanceNodes[i].GetCustomAnimNodeSeq() )
			{
				BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
				return;
			}
		}
	}

	// if not, see if it's the camera
	if( CustomCameraAnimNode != None && (SeqNode == CustomCameraAnimNode.GetCustomAnimNodeSeq()) )
	{
		CameraBoneAnimEndNotification(SeqNode);
	}
}


/** Returns TRUE is Pawn is reloading his weapon */
simulated native final function bool IsReloadingWeapon() const;

/** Returns TRUE is Pawn is on a zipline */
simulated native final function bool IsOnZipline() const;

/** Can Pawn reload his weapon? */
final simulated function bool CanReloadWeapon()
{
	// Check if special moves can prevent weapon reloads
	if( IsDoingASpecialMove() && SpecialMoves[SpecialMove].bShouldAbortWeaponReload )
	{
		return FALSE;
	}

	if( Physics == PHYS_RigidBody )
	{
		return FALSE;
	}

	return TRUE;
}

/** Determines whether or not the pawn can be cover their head (e.g. SM_CoverHead) **/
final function simulated bool CanCoverHead()
{
	if ( Health > 0 && // we need this here as you can shot and be down but not out and end up doing this then going down
		!IsDBNO() &&
		!IsAHostage() &&
		!IsDoingSpecialMove(SM_MidLvlJumpOver) &&
		!IsDoingSpecialMove(SM_StdLvlSwatTurn) &&
		!IsDoingSpecialMove(SM_MantleUpLowCover) &&
		!IsDoingSpecialMove(SM_MantleDown) &&
		!IsDoingSpecialMove(SM_StumbleGoDown) &&
		!IsDoingSpecialMove(SM_StumbleGetUp) &&
		!IsDoingSpecialMove(SM_StumbleForwardFromExplosion) &&
		!IsDoingSpecialMove(SM_CoverHead) &&
		!IsDoingDeathAnimSpecialMove() &&
		!IsDoingStumbleFromMelee() &&
		!IsDoingSpecialMove(SM_ChainSawAttack) &&
		!IsDoingSpecialMove(SM_ChainSawVictim) &&
		!IsDoingSpecialMove(SM_BayonetAttack) &&
		!IsDoingSpecialMove(SM_BayonetVictim) &&
		!IsDoingSpecialMove(SM_BayonetDraw_Leader) &&
		!IsDoingSpecialMove(SM_BayonetDraw_Follower) &&
		!IsDoingSpecialMove(SM_Engage_Loop) &&
		!IsDoingSpecialMove(SM_Engage_Idle) &&
		!IsDoingSpecialMove(SM_Engage_Start) &&
		!IsDoingSpecialMove(SM_Engage_End)
		)
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Cause this pawn to stumble
 * This is only for AI and stumble away from explosions
 */
function Stumble()
{
	// only AI and if not doing any specialmove, and
	if (MyGearAI!=none && SpecialMove==SM_None &&  CanCoverHead() && CanDoSpecialMove(SM_StumbleForwardFromExplosion))
	{
		KickPawnOffTurret();

		// if carrying a heavy weapon, drop it
		if (IsCarryingAHeavyWeapon())
		{
			ThrowActiveWeapon();
		}
		// if carrying a shield, drop it
		if (IsCarryingShield())
		{
			DropShield();
		}

		ServerDoSpecialMove(SM_StumbleForwardFromExplosion, TRUE);
		//@STATS - Record player cringe
		`RecordPlayerIntStat(CRINGE,Controller,1);
	}
	else
	{
		// otherwise send back to Cringe
		Cringe();
	}
}

/**
 * Cause this pawn to do a cringing action.
 * @param Duration	Length of time from start of animation to start of blend out.
 *					This encompasses blend in and loop.
 */
event Cringe(optional float Duration = -1.f)
{
	local GearPawn_SilverbackBase Silverback;

	if (Role == ROLE_Authority)
	{
		if (IsAKidnapper())
		{
			ServerEndSpecialMove(SpecialMove);
		}
		// if carrying a shield, drop it
		else if (IsCarryingShield())
		{
			DropShield();
		}
		else if (Base != None && Base.IsA('GearPawn_SilverbackBase'))
		{
			Silverback = GearPawn_SilverbackBase(Base);
			Silverback.DriverLeave(true);
			Silverback.SetDisabledStatus(true);
		}
		else if (GearPawnRidable_Base(Base) == None)
		{
			// SP/Horde/Siege AI gets kicked off turrets by cringes
			if (Turret(DrivenVehicle) != None && !DrivenVehicle.IsHumanControlled() && GearAI_TDM(DrivenVehicle.Controller) == None)
			{
				DrivenVehicle.DriverLeave(false);
			}

			// heavy weapons get dropped but that doesn't stop the effect
			if (IsCarryingAHeavyWeapon())
			{
				ThrowActiveWeapon();

				// Flail smashing special move will get stuck if the animation is interrupted, assuming that this can also happen on current/future heavy weapons that do special moves
				ServerEndSpecialMove(SpecialMove);
			}

			if( CanCoverHead() && CanDoSpecialMove(SM_CoverHead) )
			{
				// Replicate duration as in INT, 1/10th second precision.
				ServerDoSpecialMove(SM_CoverHead, true, None, int(Duration * CringeDurationMult * 10));

				LastCoverHeadTime = WorldInfo.TimeSeconds;
			}
		}

		//@STATS - Record player cringe
		`RecordPlayerIntStat(CRINGE,Controller,1);
	}
}

exec function TestDoCringe(float InTime)
{
	Cringe(InTime);
}

event StopCringe()
{
	StopCringeCount++; // For replication.
	ReplicatedStopCringe();
}

simulated final function ReplicatedStopCringe()
{
	if( IsDoingSpecialMove(SM_CoverHead) )
	{
		GSM_CoverHead(SpecialMoves[SM_CoverHead]).StopCoveringHead();
	}
}


/**
 * Returns true if this pawn is in an "aiming pose".  As in, is in a state
 * such that the weapon is up and ready.
 */
final simulated event bool IsInAimingPose()
{
	if( !IsReloadingWeapon() )
	{
		// targeting true
		// certain cover actions true
		// forcedaimtime true
		if ( (WorldInfo.TimeSeconds < ForcedAimTime) ||
				((WorldInfo.TimeSeconds - LastWeaponEndFireTime) < AimTimeAfterFiring) ||
				IsBlindFiring(CoverAction) ||
				IsLeaning() ||
				bIsTargeting
				// recently changed weapons?  make concept of readytime instead of using LastWeaponEndFireTime directly?
				)
		{
			return TRUE;
		}
	}

	return FALSE;
}

unreliable server function ServerSetWeaponAlert(byte Duration)
{
	SetWeaponAlert(float(Duration));
}

final simulated event SetWeaponAlert(float Duration)
{
	local Byte	ByteAimTime;

	ForcedAimTime = WorldInfo.TimeSeconds + Duration;

	if ( (Role == Role_Authority) && (WorldInfo.NetMode != NM_Standalone) )
	{
		// Compress for replication. Doesn't really matter if it's not super accurate.
		ByteAimTime = Byte(Duration);

		// Ensure that ReplicatedForcedAimTime is going to get replicated
		// By making sure we're assigning a different value.
		if( ByteAimTime == ReplicatedForcedAimTime )
		{
			ReplicatedForcedAimTime = ByteAimTime + 1;
		}
		else
		{
			ReplicatedForcedAimTime = ByteAimTime;
		}

		WorldInfo.bForceNetUpdate = TRUE;
	}
}

/**
* Returns socket used for Right Hand (main weapon hand).
* When using animation mirroring, left and right hand sockets are inverted.
*/

simulated native function Name GetRightHandSocketName();

/**
* Returns the weapon hand bone position for this pawn's mesh
* @ param HandLoc is an out parameter returning the weapon hand bone location
* @ param HandRot is an out parameter returning the weapon hand bone rotation
*/
simulated native function GetWeaponHandPosition(out vector HandLoc, out rotator HandRot);

simulated native event rotator GetViewRotation();


/**
 * Return the base location targetting should auto-aim for.
 */
simulated function vector GetBaseTargetLocation()
{
	if( Mesh != None && PelvisBoneName != '' )
	{
		return Mesh.GetBoneLocation(PelvisBoneName);
	}
	return Location;
}

/** Returns melee attack range, taking current state of the pawn into account (weapon, stance, whatever). */
simulated function float GetMeleeAttackRange()
{
	return (MyGearWeapon != None) ? MyGearWeapon.MeleeAttackRange : UnarmedMeleeRange;
}

/** @return how close AI should get to an enemy before attempting melee
 * this doesn't affect the weapon's rules, just the AI behavior
 * so for correct behavior this should return a value equal or less than GetMeleeAttackRange()
 */
final function float GetAIMeleeAttackRange()
{
	return (MyGearWeapon != None) ? MyGearWeapon.GetAIMeleeAttackRange() : UnarmedMeleeRange;
}

/**
 *	Gives pawn a chance to override weapon melee damage
 *	Return TRUE if overridden & out_Damage updated
 *		   FALSE if should use default weapon damage
 */
simulated function bool GetMeleeDamageOverride(out float out_Damage)
{
	if (IsAKidnapper() && KidnapperMeleeDamage > 0.0)
	{
		out_Damage = KidnapperMeleeDamage;
		return true;
	}
	else
	{
		return false;
	}
}

/**
 * Whether the pawn attempting the special move is facing another pawn
 */
native final simulated function bool IsFacingOther(GearPawn OtherPawn, optional float MinDot = 0.5f, optional float HeightTolerancePct = 0.8f) const;

/**
 * Returns TRUE if relevant for gameplay. That is not hidden, pending destruction or dead.
 * DBNO players are considered gameplay relevant.
 */
final simulated function bool IsGameplayRelevant()
{
	return !bHidden && !bDeleteMe && !bPlayedDeath;
}

/**
 * Returns true if given target is a valid melee target for this GearPawn, false otherwise.
 */
simulated function bool TargetIsValidMeleeTarget(GearPawn TestGP, bool bLookForPawnsInStateRevival, optional float RangeMultiplier=1.0)
{
	local vector ToTargetNorm;
	local float DistToTarget;
	local GearGRI GRI;

	// can't target self or fully dead/deleted pawns
	if (TestGP == self || TestGP.bDeleteMe || TestGP.bPlayedDeath || TestGP.bInvalidMeleeTarget)
	{
		return false;
	}

	// can't target anyone in a full vehicle (but can target enemies in turrets or ridables)
	if (GearVehicle(TestGP.DrivenVehicle) != None)
	{
		return false;
	}

	// prevent attacking a teammate's meatshield
	GRI = GearGRI(WorldInfo.GRI);
	if (TestGP.IsAHostage() && !GRI.bAllowFriendlyFire && (MyGearAI == None || !MyGearAI.bBerzerk) && GRI.OnSameTeam(TestGP.InteractionPawn, self))
	{
		return false;
	}

	// can't target dead guys unless specifically looking for DBNO guys
	if (TestGP.Health <= 0 && (!bLookForPawnsInStateRevival || (!TestGP.IsDBNO() && !TestGP.IsAHostage())))
	{
		return false;
	}

	// can't target teammates (unless they're hostages)
	if (!TestGP.IsAHostage() && !GRI.bAllowFriendlyFire && (MyGearAI == None || !MyGearAI.bBerzerk) && GRI.OnSameTeam(TestGP, self))
	{
		return false;
	}

	ToTargetNorm = TestGP.GetMeleeHitTestLocation() - Location;
	DistToTarget = VSize(ToTargetNorm);
	ToTargetNorm /= DistToTarget;

	// can't target outside of melee attack range
	if (DistToTarget > GetMeleeAttackRange() * RangeMultiplier)
	{
		return false;
	}

	// can't target guys protected by cover
	if (TestGP.IsProtectedByCover(ToTargetNorm, TRUE))
	{
		return false;
	}

	// can't target guys protected by shields
	if (TestGP.IsDeployingShield() && TestGP.IsProtectedByShield(ToTargetNorm))
	{
		return false;
	}

	// We can target him!
	return true;
}


/**
 * Returns TRUE if this pawn is in a valid state to engage in a melee attack.
 */
simulated function bool CanEngageMelee()
{
	local GearPC PC;
	local WalkVolume WV;

	if ( Controller == None || Health <= 0 || bIsConversing || bInCommLinkStance || bSwitchingWeapons || bCoveringHead || Physics == PHYS_RigidBody ||
		WorldInfo.TimeSeconds - LastRoadieRunTime < PostRoadieRunFireDelay )
	{
		return false;
	}

	WV = WalkVolume(PhysicsVolume);
	if (WV != None && WV.bActive && WV.bReducesMovementSpeed)
	{
		return false;
	}

	if( MyGearWeapon != None )
	{
		if( (WorldInfo.TimeSeconds - LastMeleeAttackTime) < MyGearWeapon.MeleeAttackCoolDownInSeconds)
		{
			return false;
		}

		if( !MyGearWeapon.CanDoSpecialMeleeAttack() ||
			MyGearWeapon.CurrentFireMode == class'GearWeapon'.const.FIREMODE_FAILEDACTIVERELOAD ||
			MyGearWeapon.CurrentFireMode == class'GearWeapon'.const.FIREMODE_ACTIVERELOADSUCCESS ||
			MyGearWeapon.CurrentFireMode == class'GearWeapon'.const.FIREMODE_ACTIVERELOADSUPERSUCCESS )
		{
			return false;
		}
	}

	// no melee while roadie running or attempting to acquire cover
	PC = GearPC(Controller);
	if (PC != None && ( PC.IsHoldingRoadieRunButton() || PC.bForcedRoadieRun ) && !IsDoingSpecialMove(SM_RoadieRunStab))
	{
		return false;
	}

	if( IsOnZipline() )
	{
		return FALSE;
	}

	if( SpecialMove != SM_None && (!SpecialMoves[SpecialMove].bCanFireWeapon && SpecialMove != SM_RoadieRunStab) ||
		SpecialMove == SM_RidingRatTruck )
	{
		return false;
	}

	// no melee while shield is deployed
	if( IsDeployingShield() )
	{
		return false;
	}

	return true;
}

/** Rules for delaying a melee attack */
simulated function bool ShouldDelayMeleeAttack()
{
	// if holding main fire or coverslipping
	// delay while doing a mirror transition, as animation blending will look awful in that case.
	return IsControllerFireInputPressed(0) || IsDoingSpecialMove(SM_CoverSlip) || IsDoingSpecialMove(SM_RoadieRunStab) || (bIsMirrored != bWantsToBeMirrored);
}

/** This will return whether or not this mob can be special melee attacked **/
simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
{
	local GearGRI_MP GRIMP;
	local GearPRI PawnPRI;

	if (bImmuneToSpecialMeleeAttacks || (Role == ROLE_Authority && GearGame(WorldInfo.Game).IsRespawnInvincible(self)))
	{
		return false;
	}

	GRIMP = GearGRI_MP(WorldInfo.GRI);
	PawnPRI = GearPRI(PlayerReplicationInfo);

	// can't do special melee attacks if we are a leader and leaders can't be killed
	if (PawnPRI != None &&
		PawnPRI.bIsLeader &&
		GRIMP != None &&
		!GRIMP.bLeadersAreKillable )
	{
		// special case because it's fun:
		// allow the losing team's leader to be executed after the round is over
		return ((GRIMP.GameStatus == GS_RoundOver || GRIMP.GameStatus == GS_EndMatch) && !GRIMP.OnSameTeam(self, GRIMP.Winner));
	}

	// Don't try to special melee attack people on a different moving platform
	if (ClampedBase != None && Attacker != None && Attacker.ClampedBase != None && Attacker.ClampedBase != ClampedBase)
	{
		return false;
	}

	// Don't try to special melee attack people on a ridable pawn
	if (Base != None && GearPawnRidable_Base(Base) != None)
	{
		return false;
	}

	// Don't allow special melee attacks vs players in SP if they are already chainsawing
	if ( IsHumanControlled() && GearGameSP_Base(WorldInfo.Game) != None &&
		( IsDoingSpecialMove(SM_ChainSawAttack) ||
		 IsDoingSpecialMove(SM_ChainSawVictim) ||
		 IsDoingSpecialMove(SM_ChainsawDuel_Leader) ||
		 IsDoingSpecialMove(SM_ChainsawDuel_Follower) ||
		 IsDoingSpecialMove(SM_ChainsawDuel_Draw) ||
		 IsDoingSpecialMove(SM_BayonetAttack) ||
		 IsDoingSpecialMove(SM_BayonetVictim) ||
		 IsDoingSpecialMove(SM_BayonetDraw_Leader) ||
		 IsDoingSpecialMove(SM_BayonetDraw_Follower) ||
		 IsDoingSpecialMove(SM_MantleKick) ) )
	{
		return false;
	}

	return !bDeleteMe;
}

/** Returns TRUE if this Pawn can be chainsaw attacked */
simulated function bool CanBeChainsawAttacked()
{
	return !IsDoingSpecialMove(SM_BayonetVictim);
}

/** Returns TRUE if this Pawn can be retro lancer bayonet attacked */
simulated function bool CanBeBayonetAttacked()
{
	return !(SpecialMove == SM_BayonetDraw_Leader || SpecialMove == SM_BayonetDraw_Follower);
}

/** returns TRUE if this pawn should be evaded instead of meleed against */
function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other);

/**
 *	This will attempt a melee attack
 *
 *	MeleeAttacks are determined by the weapon the pawn is holding.	So a pistol maybe
 * gives you a pistol whip melee attack, the AssaultRifle gives you a chainsaw melee attack.
 *
 * To have a melee attack work you need to be:
 *
 *	-in range of your target
 *	-be targeting your target
 *	-not have done a melee attack in the last MeleeAttackCoolDownInSeconds
 *
 * If you are able to do a melee attack you will do RandRange( MeleeAttackDamageMin, MeleeAttackDamageMax )
 * for the specific weapon's melee attack.
 */
simulated function StartMeleeAttack()
{
	local GearInventoryManager Manager;

	//Some heavy weapons can melee now (Heavy Flail)
	if( IsCarryingAHeavyWeapon() && !MyGearWeapon.CanDoSpecialMeleeAttack() )
	{
		// Don't melee while mounting a heavy weapon
		if (IsMountingHeavyWeapon())
		{
			return;
		}

		// EndSpecialMove() might have caused the weapon to be thrown already if e.g. it was out of ammo
		if (IsCarryingAHeavyWeapon())
		{
			Manager = GearInventoryManager(InvManager);
			if( Manager != None && Manager.PreviousEquippedWeapon != None )
			{
				Manager.SetCurrentWeapon(Manager.PreviousEquippedWeapon);
			}
			else
			{
				ThrowActiveWeapon();
			}
		}
	}

	// Set this flag indicating our desire to do a melee attack.
	// Code in Tick() will check to see if we can actually start it.
	bWantsToMelee = TRUE;
}

simulated function StopMeleeAttack(optional bool bForcedByDamage)
{
	bWantsToMelee = FALSE;
	bPendingMeleeAttack = FALSE;

	if (GearWeap_RetroLancer(MyGearWeapon) != None)
	{
		MyGearWeapon.StopFire(class'GearWeapon'.const.MELEE_ATTACK_FIREMODE);
	}
	else if( bForcedByDamage )
	{
		// if melee was stopped because we took damage,
		// remember when it hapened to add a delay
		LastTookDamageTime = WorldInfo.TimeSeconds;
		MyGearWeapon.StopFire(class'GearWeapon'.const.MELEE_ATTACK_FIREMODE);
	}
}

/** Called from server to forcibly stop the Pawn's Melee attack **/
function ForceStopMeleeAttack(optional bool bForcedByDamage)
{
	StopMeleeAttack(bForcedByDamage);
	if( !IsLocallyControlled() )
	{
		ClientStopMeleeAttack(bForcedByDamage);
	}
}

/** Replicated function called from server to client, to Stop Melee Attack */
reliable client function ClientStopMeleeAttack(optional bool bForcedByDamage)
{
	StopMeleeAttack(bForcedByDamage);
}

/** called by the server to force the client to start meleeing */
reliable client function ClientStartMeleeAttack()
{
	StartMeleeAttack();
}

/** Returns TRUE if a Pawn is doing a Stumble because of a Melee hit */
simulated final function bool IsDoingStumbleFromMelee()
{
	return IsDoingSpecialMove(SM_StumbleFromMelee) || IsDoingSpecialMove(SM_StumbleFromMelee2) || IsDoingSpecialMove(SM_ChainsawInterrupt) || IsDoingSpecialMove(SM_StumbleFromMantleKick);
}

/** Play Stumble Hit Reaction from a melee impact */
function DoStumbleFromMeleeSpecialMove(GearPawn GPInstigator)
{
	if( CanDoSpecialMove(SM_StumbleFromMelee2) )
	{
		// only use #2 since that includes some RM to move the players apart (which is what we want for gameplay reasons, if not aesthetically)
		if( GPInstigator != None )
		{
			ServerDoSpecialMove(SM_StumbleFromMelee2, TRUE,, INT((Normal(GPInstigator.Location - Location) dot Vector(Rotation)) < 0));
		}
		else
		{
			ServerDoSpecialMove(SM_StumbleFromMelee2, TRUE);
		}
	}
}

/** Play Stumble Hit Reaction from a mantle kick impact */
function DoStumbleFromMantleKickSpecialMove(GearPawn KickedBy)
{
	if( CanDoSpecialMove(SM_StumbleFromMantleKick) )
	{
		if( MyGearAI != None )
		{
			class'AICmd_React_StumbleFromMantleKick'.static.Stumble(MyGearAI, KickedBy);
		}
		else
		{
			ServerDoSpecialMove(SM_StumbleFromMantleKick,,KickedBy,(CurrentLink!=none && CoverType != CT_None)?0:1);
		}
	}
	else if( IsAKidnapper() )
	{
		ServerEndSpecialMove(SM_Kidnapper);
	}
}


final function bool IsDoingAStumbleGoDown()
{
	return (IsDoingSpecialMove(SM_StumbleGoDown) || IsDoingSpecialMove(SM_StumbleGoDownFromExplosion) || IsDoingSpecialMove(SM_StumbleGoDownFromCloseRangeShot));
}

/** Start the Stumble Back Special Move */
function DoStumbleGoDownSpecialMove()
{
	// make sure Pawn can actually do it. Some enemies don't support the animations.
	if( CanDoSpecialMove(SM_StumbleGoDown) )
	{
		ServerDoSpecialMove(SM_StumbleGoDown, TRUE);
	}
}

/** Get Back up from a knock down special move */
final function GetBackUpFromKnockDown()
{
	// Clear Timer to be safe
	ClearTimer('GetBackUpFromKnockDown');

	if( IsDoingAStumbleGoDown() && CanDoSpecialMove(SM_StumbleGetUp) )
	{
		ServerDoSpecialMove(SM_StumbleGetUp, TRUE);
	}
}


/**
 * Event called when melee attack begins.
 * This means when weapon is enterring melee attacking state on local player and server.
 * When Pawn.FiringMode == MELEE_ATTACK_FIREMODE is replicated on remote clients.
 */
simulated function MeleeAttackStarted(GearWeapon Weap)
{
	local GearPC			GPC;
	local GearPawn		AdhesionTarget;
	local float			TargetHealthPct;

	bDoingMeleeAttack = TRUE;

	// abort any special moves
	if( Role == Role_Authority )
	{
		if( IsDoingASpecialMove()
			&& !IsDoingSpecialMeleeAttack()
			&& !IsDoingSpecialMove(SM_ChainSawHold)
			&& !IsDBNO()
			&& !IsAHostage()
			&& !IsAKidnapper()
			&& !IsDoingSpecialMove(GSM_DragInjured_Leader)
			)
		{
			ServerEndSpecialMove();
		}
	}

	GPC = GearPC(Controller);
	if( GPC != None )
	{
		if( Weap.bDoMeleeAdhesion )
		{
			//`log( "StartMeleeAttack starting Adhesion" );
			// try to find best target around that we can turn towards
			AdhesionTarget = GPC.AttemptMeleeAdhesion();
		}

		// Break from cover
		if( GPC.IsInCoverState() )
		{
			GPC.ClientBreakFromCover();
		}
	}

	// lancer has custom melee, skip the normal efforts, etc
	if( GearWeap_AssaultRifle(Weap) != None )
	{
		return;
	}

	// attack effort sound
	if( AdhesionTarget == None )
	{
		//`log( "StartMeleeAttack 5	 AdhesionTarget == none " );
		SoundGroup.PlayEffort(self, GearEffort_MeleeAttackSmallEffort, true);
	}
	else
	{
		TargetHealthPct = AdhesionTarget.Health / float(AdhesionTarget.DefaultHealth);
		if (TargetHealthPct < 0.3f)
		{
			SoundGroup.PlayEffort(self, GearEffort_MeleeAttackLargeEffort, true);
		}
		else if (TargetHealthPct < 0.6f)
		{
			SoundGroup.PlayEffort(self, GearEffort_MeleeAttackMediumEffort, true);
		}
		else
		{
			SoundGroup.PlayEffort(self, GearEffort_MeleeAttackSmallEffort, true);
		}
	}
}


/**
 * Event called when melee attack ends.
 * This means when weapon leaves melee attacking state on local player and server.
 * When Pawn.FiringMode != MELEE_ATTACK_FIREMODE is replicated on remote clients, and previous firing mode was MELEE_ATTACK_FIREMODE.
 */
simulated function MeleeAttackEnded(GearWeapon Weap)
{
	local GearPC	PC;

	LastMeleeAttackTime = WorldInfo.TimeSeconds;
	bDoingMeleeAttack = FALSE;

	PC = GearPC(Controller);
	if( PC != None )
	{
		PC.StopMeleeAdhesion();
	}
}


/**
 * Function allowing the Pawn to override a weapon melee attack with his own version.
 * @param	out_AnimTime	Play length of the animation played.
 * @return					TRUE to override, FALSE to let weapon play default animations.
 */
simulated function bool OverridePlayMeleeAttackAnim(out float Out_AnimTime)
{
	return FALSE;
}


/**
 * Function allowing the Pawn to override a weapon reload animation with his own version.
 * By default the weapon provides the animation to play.
 * @param   GearWeap        Weapon being reloaded.
 * @param	BS_Animation	BodyStance to play.
 * @return					TRUE to override, FALSE to let weapon play default animations.
 */
simulated function bool OverrideReloadAnimation(GearWeapon GearWeap, out BodyStance BS_Animation)
{
	return FALSE;
}


/** Called after a gored pawn has been around too long. */
simulated private function GoreAroundTooLong()
{
	bScalingToZero = TRUE;
}


/**
 * This will create the gore skeleton which will be constructed to break apart.
 */
simulated final function SwitchToGore()
{
	local GearGRI GRI;

	// Need proper physics asset and mesh
	if (!WorldInfo.GRI.ShouldShowGore())
	{
		return;
	}

	// Don't set gore skeleton during death animation, as current ragdoll is using motors.
	if (IsDoingDeathAnimSpecialMove())
	{
		`log("Can't create gore skeleton while in SM_DeathAnim"@self);
		return;
	}

	// deal with taccom mesh
	RemoveTaccomMesh();
	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != none)
	{
		GRI.RemoveTaccomPlayer(self);
	}

	// Freeze animations upon going ragdoll except when being headshotted. we'll do it once we switch to ragdoll.
	if (bPlayedDeath && !bHasPlayedHeadShotDeath && GoreSettings != None)
	{
		// This will capture a pose and clear the tree
		StopAllAnimations();
	}

	// Do this if we haven't switched to the gore skeleton yet
	if (!bIsGore)
	{
		SetCollisionSize(1.0f, 1.0f);
		CylinderComponent.SetTraceBlocking(false, false);
		// Try to switch to gore LOD
		if (!SwitchToGoreLOD())
		{
			// If this failed, then try to play a death animation instead
			bPlayDeathAnimations = true;
		}
	}

	Mesh.MotionBlurScale = 0.0f;
	// Disable dynamic shadow for performance
	LightEnvironment.bCastShadows = false;
	// Use cheap shadowing from the environment
	LightEnvironment.bUseBooleanEnvironmentShadowing = true;
	// Force the DLE to update since we changed bUseBooleanEnvironmentShadowing, otherwise there will be a delay until it updates
	LightEnvironment.ResetEnvironment();

	if (bEnableEncroachCheckOnRagdoll)
	{
		// If we are checking encroachment (ie looking for physics volumes) and we are gibbed - need to do a bit more checking
		// This is to handle just one gib going into a volume.
		Mesh.bPerBoneVolumeEffects = true;
		bAlwaysEncroachCheck = true;
	}

	if (IsAHostage())
	{
		// Hostage needs to remain animated, so make sure we fix all bodies.
		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
		// Unfix Dangle bones as well
		Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(true, Mesh);
		// Enable full physics on body
		Mesh.PhysicsWeight = 1.f;
		// Set physics to be updated from Kinematic data
		Mesh.bUpdateJointsFromAnimation = true;
		Mesh.bUpdateKinematicBonesFromAnimation = true;
		Mesh.MinDistFactorForKinematicUpdate = 0.f;
		// Make it start simulating
		Mesh.WakeRigidBody();
	}
	else
	{
		// Make sure all bodies are unfixed
		if (Mesh.PhysicsAssetInstance != None)
		{
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);

			// Turn off motors
			Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false, Mesh, true);
		}
	}

	bIsGore = true;
}

/** This will do what ever is needed to reset materials to allow the gore overlay material to show up **/
simulated function SetMainBodyMaterialToNoneToClearItForGoreMaterial()
{
	local int idx;

	for( Idx = 0; Idx < Mesh.Materials.Length; ++Idx )
	{
		//`log( "clearing material to make gore work" @ Mesh.Materials[Idx] );
		Mesh.SetMaterial( Idx, None ); // this is needed as we have to "clear" the material instance on the mesh to make the gore material which is affecting the same verts can be seen.
	}
}


/**
 * Setup Gore Skeleton to be gibbed.
 * This turns on some optimizations so Gibs don't kill performance.
 */
simulated final function SetupDeathGibsOptimizations()
{
	// Do this only once for Gore Skeletons
	// Don't setup those for non dead characters. (ie Hostages)
	if( bGoreSetupForDeath || !bIsGore || !bPlayedDeath )
	{
		return;
	}

	bGoreSetupForDeath = TRUE;

	// When you gore the skeleton, the bounding box can get very large, so the pawn can be considered 'always seen'
	// This forces it to be cleaned up after a certain period.
	SetTimer( FMin(60.f, CorpseMaxLifeSpan), FALSE, nameof(GoreAroundTooLong) );

	// Freeze the light environment state at the state when the pawn was gibbed; this prevents the light environment being computed
	// for the large aggregate bounds of the gibs, which usually doesn't give good results.
	// we need to wait a number of seconds here so we do not capture the explosion light
	// NOTE: this can look bad when the gib is near a bright colored light and then is kicked out away from it into darkness
	SetTimer( 5.0f, FALSE, nameof(SetLightEnvironmentToNotBeDynamic) );

	// Disable dynamic shadow for performance
	LightEnvironment.bCastShadows = FALSE;
	// Use cheap shadowing from the environment
	LightEnvironment.bUseBooleanEnvironmentShadowing = TRUE;
	LightEnvironment.bSynthesizeSHLight = FALSE;
	// Force the DLE to update since we changed bUseBooleanEnvironmentShadowing, otherwise there will be a delay until it updates
	LightEnvironment.ResetEnvironment();
}

/** This will turn "off" the light environment so it will no longer update **/
simulated final function SetLightEnvironmentToNotBeDynamic()
{
	LightEnvironment.bDynamic = FALSE;
}

simulated function UpdatePawnLightEnvironment(LightEnvironmentComponent NewComponent)
{
	if( Mesh != None )
	{
		Mesh.SetLightEnvironment(NewComponent);
	}
	if( EquippedShield != None )
	{
		EquippedShield.Mesh.SetLightEnvironment(NewComponent);
	}
}

simulated event ConstraintBrokenNotify( Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance	)
{
	local SkeletalMeshComponent SMC;

	// make sure we should bother spawning an effect
	if( (NumConstraintEffectsSpawned >= NumConstraintEffectsSpawnedMax) || !EffectIsRelevant(Location, false, 2000) )
	{
		return;
	}

	if( ( ConInstance != None ) &&
		( BloodGoreConstraintBrokenTemplate != None ) &&
		( WorldInfo.GRI.ShouldShowGore() ) )
	{
		NumConstraintEffectsSpawned++;

		// use this to spawn the "breaking of the constraint effect"
		SMC = SkeletalMeshComponent(ConInstance.OwnerComponent);

		// now spawn the persistent spraying of blood effects

		// CHILD
		WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( BloodGoreConstraintBrokenTemplate, SMC, ConSetup.ConstraintBone1,
										false, ConSetup.Pos1 * 50.0, rotator((ConSetup.Pos1 * 50.0) * vect(-1,0,0)) );

		// PARENT
		// don't spawn the constrain breaking effect if we have already gore exploded
		// bHasGoreExploded is set before the various constraint breaking has occurred, so don't play gib fx for gore explosions.
		// bPlayedDeath is set in 100% of cases this code would be called so is not useful
		if( !bHasGoreExploded)
		{
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( BloodGoreConstraintBrokenTemplate, SMC, ConSetup.ConstraintBone2,
											false, ConSetup.Pos2 * 50.0, rotator((ConSetup.Pos2 * 50.0) * vect(1,0,0)) );

			// 50% of the time spawn decal
			if( bSpawnBloodTrailDecals && FRand() > 0.50f )
			{
				// when limbs break we need to spawn some blood on the ground
				SpawnABloodTrail_LimbBreak( ConInstance.GetConstraintLocation() );
			}
		}

		// when breaking gibs, add hit mask
		if (LastTakeHitInfo.InstigatedBy!=none)
		{
			AddHitMask(ConInstance.GetConstraintLocation(), LastTakeHitInfo.InstigatedBy.Location, 30.f, TRUE);
			//`log("Adding hit mask between "@ConSetup.ConstraintBone1@" and "@ConSetup.ConstraintBone2);
		}

		// reset the count so when you go and shoot limbs later you will get correct effects
		SetTimer( 1.0f, FALSE, nameof(ResetNumConstraintEffectsSpawned) );
	}
}

/** This will reset the counter for the constraint effects spawned. **/
simulated function ResetNumConstraintEffectsSpawned()
{
	NumConstraintEffectsSpawned = 0;
}

simulated function ShutDown()
{
	if (Controller != None)
	{
		Controller.PawnDied(self);
		Controller.Destroy();
	}
	Super.ShutDown();
}

/**
 * Play effects for running into the wall during a run to cover.
 */
simulated function DoRun2CoverWallHitEffects()
{
	local GearPC PC;
	local float ShakeScale;

	local vector SpawnLocation, SocketLocation;
	local rotator SpawnRotation;
	local bool bSocketFound;

	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;

	local GearGRI GRI;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	GRI = GearGRI(WorldInfo.GRI);

	// do a screenshake to add weight to the impact
	// scale the shake based on distance we ran to enter cover
	ShakeScale = (LastCoverAcquireDistanceSq - Run2CoverMinCameraShakeDistSqThreshold) / (Run2CoverMaxCameraShakeDistSqThreshold - Run2CoverMinCameraShakeDistSqThreshold);
	ShakeScale = FClamp(ShakeScale, 0.f, 1.f);
	if( IsHumanControlled() && IsLocallyControlled() )
	{
		// play camera shake only for PCs
		PC = GearPC(Controller);
		if( PC != None )
		{
			if( LastCoverAcquireDistanceSq > Run2CoverMinCameraShakeDistSqThreshold )
			{
				PC.ClientPlayCameraShake(Run2CoverCameraShake, ShakeScale);
				PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.EnterCoverHard);
			}
		}
	}

	// only play an impact grunt if we have slide a decent distance
	//`log( "LastCoverAcquireDistanceSq: " $ LastCoverAcquireDistanceSq );
	if (Role == ROLE_Authority && LastCoverAcquireDistanceSq > 36000)
	{
		SoundGroup.PlayEffort(self, GearEffort_CoverSlamEffort, true);
	}

	if( EffectIsRelevant(Location, false, 2000) )
	{
		// play shoulder dust
		if( bIsMirrored )
		{
			// play the "enter cover" particle effect
			bSocketFound = Mesh.GetSocketWorldLocationAndRotation( 'LeftShoulderCoverDust', SocketLocation );
		}
		else
		{
			// play the "enter cover" particle effect
			bSocketFound = Mesh.GetSocketWorldLocationAndRotation( 'RightShoulderCoverDust', SocketLocation );
		}

		if( bSocketFound )
		{
			// move spawnlocation to be on the wall, but at shoulder height (determined by the socket).
			// using just the socket position tends to put the emitter inside the wall due to how the animation is.
			SpawnLocation = Location - (GetCollisionRadius() - 20) * AcquiredCoverInfo.Normal;
			SpawnLocation.Z = SocketLocation.Z;

			SpawnRotation = rotator(AcquiredCoverInfo.Normal);

			TraceStart = SpawnLocation;
			TraceDest = TraceStart - (64 * AcquiredCoverInfo.Normal);

			// trace down and see what we are standing on
			Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, TRACEFLAG_PhysicsVolumes );
			//DrawDebugLine( TraceStart, TraceDest, 255, 0, 0, TRUE);

			if( IsHumanControlled() && IsLocallyControlled() )
			{
				WorldInfo.MyEmitterPool.SpawnEmitter(class'GearPhysicalMaterialProperty'.static.DetermineSlideIntoCoverEffect(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(HitInfo)), SpawnLocation, SpawnRotation);
			}
			else
			{
				WorldInfo.MyEmitterPool.SpawnEmitter(class'GearPhysicalMaterialProperty'.static.DetermineSlideIntoCoverNonPlayerEffect(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(HitInfo)), SpawnLocation, SpawnRotation);
			}
		}

		// blood trail along wall if hurt, health is not replicated so local GearPawns only.
		// for now just do it a decent amount to test it
		if (bSpawnBloodTrailDecals && Health < (0.65 * DefaultHealth) && IsLocallyControlled())
		{
			GRI.LeaveADecal(GearPawnFX.BloodDecalTrace_CoverBehindPawnMiddleOfBody, GearPawnFX.BloodDecalChoice_Wall);
			StartBloodTrail( 'SpawnABloodTrail_Wall' );
		}
	}

	// play sound effects for both PCs and NPCs
	if( Controller != None )
	{
		// check to see if we are going into standing or midlevel cover
		if( CoverType == CT_MidLevel )
		{
			SoundGroup.PlayFoleySound( self, GearFoley_EnterCoverLowFX );
		}
		else if( CoverType == CT_Standing )
		{
			SoundGroup.PlayFoleySound( self, GearFoley_EnterCoverHighFX );
		}

		SoundGroup.PlayFoleySound( self, GearFoley_BodyWallImpactFX );
	}

	// Play fracture effects if relevant
	if (AcquiredCoverInfo.Link != None && AcquiredCoverInfo.Link.bFractureOnTouch)
	{
		// Breaks nearby fractured meshes
		AcquiredCoverInfo.Link.BreakFracturedMeshes(AcquiredCoverInfo.Location, GetCollisionRadius() + GetCollisionHeight(), 100, class'GDT_Melee');
	}
}


/** sound to play when running around  (triggered from script notify on animation)	**/
simulated function PlayBodyMovementSounds_Running()
{
	SoundGroup.PlayFoleySound(self, GearFoley_BodyMovement_RunningFX);
}

/** sound to play when roadie running (triggered from script notify on animation) **/
simulated function PlayBodyMovementSounds_RoadieRun()
{
	SoundGroup.PlayFoleySound(self, GearFoley_BodyMovement_RoadieRunFX);
}

simulated function PlayBodyMovementSounds_GruntSound()
{
	SoundGroup.PlayEffort(self, GearEffort_MantleEffort);
}
simulated function PlayBodyMovementSounds_MartyrRollover()
{
	// this one sounds pretty good
	SoundGroup.PlayFoleySound(self, GearFoley_EnterCoverHighFX);
}

/**
 * Handle notification that this pawn was killed.
 */
function NotifyKilled(Controller Killer)
{
	// Store killer.  Note that Pawn::Died() could potentially modify it's input
	// killer parameter, so we store the killer here to make sure that function
	// has had a chance to do it's thing and pass the information up.
	if( Killer != None )
	{
		KilledByPawn = GearPawn(Killer.Pawn);
		// use last controlled pawn if not currently controlling one (e.g. died while shot was in flight)
		if (KilledByPawn == None && Killer.Pawn == None && GearPC(Killer) != None)
		{
			KilledByPawn = GearPawn(GearPC(Killer).LastPawn);
		}
	}
	else
	{
		KilledByPawn = None;
	}
}

/** Returns true if Pawn can pickup actor A. */
final simulated function bool CanPickUpActor(Actor A)
{
	local GearPickupFactory	PF;
	local GearDroppedPickup	DP;

	PF = GearPickupFactory(A);
	DP = GearDroppedPickup(A);
	return( (PF != None && PF.CanBePickedUpBy(Self)) || (DP != None && DP.CanBePickedUpBy(Self)) );
}

/**
 * Checks for nearby discoverables, returns the first one found.
 */
final simulated function GearDiscoverablesPickupFactoryBase FindNearbyDiscoverables()
{
	local Actor				A;
	local GearDiscoverablesPickupFactoryBase Discoverable;

	// use fast touching list
	ForEach TouchingActors(class'Actor', A)
	{
		Discoverable = GearDiscoverablesPickupFactoryBase(A);
		if (Discoverable != None)
		{
			return Discoverable;
		}
	}

	return None;
}


/**
 * What interaction can we do with this pickup?
 */
final simulated function Name FindInteractionWithPickup(Actor A)
{
	local GearPickupFactory	PF;
	local GearDroppedPickup	DP;

	DP = GearDroppedPickup(A);
	if( DP != None )
	{
		return DP.FindInteractionWith(Self,false);
	}

	PF = GearPickupFactory(A);
	if( PF != None )
	{
		return PF.FindInteractionWith(Self,false);
	}

	return '';
}

/** Only play kick up animation on "shoulder" weapons. Not pistol, not grenades or any other type of pickups. */
final simulated function bool ShouldPlayKickUpAnim(Actor A)
{
	local GearPickupFactory	PF;
	local GearDroppedPickup	DP;
	local GearWeapon			Weap;
	local class<GearWeapon>	WeapClass;

	// Don't play kick up animation when just grabbing ammo from the gun.
	if( FindInteractionWithPickup(A) == 'TakeAmmo' )
	{
		return FALSE;
	}

	DP = GearDroppedPickup(A);
	if( DP != None )
	{
		Weap = GearWeapon(DP.Inventory);
		return Weap != None && Weap.WeaponType == WT_Normal;
	}

	PF = GearPickupFactory(A);
	if( PF != None )
	{
		WeapClass = Class<GearWeapon>(PF.InventoryType);
		return WeapClass != None && WeapClass.default.WeaponType == WT_Normal;
	}

	return FALSE;
}

final simulated function bool IsPickupAHeavyWeapon(Actor A)
{
	local GearPickupFactory	PF;
	local GearDroppedPickup	DP;
	local GearWeapon			Weap;
	local class<GearWeapon>	WeapClass;

	if( FindInteractionWithPickup(A) == 'TakeAmmo' )
	{
		return FALSE;
	}

	DP = GearDroppedPickup(A);
	if( DP != None )
	{
		Weap = GearWeapon(DP.Inventory);
		return Weap != None && Weap.WeaponType == WT_Heavy;
	}

	PF = GearPickupFactory(A);
	if( PF != None )
	{
		WeapClass = Class<GearWeapon>(PF.InventoryType);
		return WeapClass != None && WeapClass.default.WeaponType == WT_Heavy;
	}

	return FALSE;
}

/**
 * Tell Pawn to pick up weapon A
 *
 * @param A - the weapon pickup factory
 */
reliable server function PickupWeapon(Actor A)
{
	if ( A != None && !A.bDeleteMe && CanPickUpActor(A) && CanDoSpecialMove(SM_WeaponPickup) &&
		(Touching.Find(A) != INDEX_NONE || VSize(A.Location - Location) < (GetCollisionRadius() + GetCollisionHeight()) * 2.0) )
	{
		// Claim pickup so noone else can pick it up
		ClaimPickup(A);
		VerifySMHasBeenInstanced(SM_WeaponPickup);
		// Let our special move know about it, so we can pick it up later. (based on animation timing).
		GSM_Pickup(SpecialMoves[SM_WeaponPickup]).PickupActor = A;

		if (ClassIsChildOf(A.Class, class'GearWeaponPickupFactory_LockerBase'))
		{
			ServerDoSpecialMove(SM_WeaponPickup, TRUE, None, class'GSM_Pickup'.static.PackSpecialMoveFlags(ePT_LockerGrab));
		}
		else if (ShouldPlayKickUpAnim(A))
		{
			ServerDoSpecialMove(SM_WeaponPickup, TRUE, None, class'GSM_Pickup'.static.PackSpecialMoveFlags(ePT_KickUp));
		}
		else if( IsPickupAHeavyWeapon(A) )
		{
			ServerDoSpecialMove(SM_WeaponPickup, TRUE, None, class'GSM_Pickup'.static.PackSpecialMoveFlags(ePT_PickupHeavyWeapon));
		}
		else
		{
			ServerDoSpecialMove(SM_WeaponPickup, TRUE, None, class'GSM_Pickup'.static.PackSpecialMoveFlags(ePT_Pickup));
		}
	}
}

/**
 * grab a pickup from the ground.
 * @NetMode: Server only
 */
function GrabPickup(Actor Pickup)
{
	local GearPickupFactory	PF;
	local GearDroppedPickup	DP;

	// make sure that the pickup is still valid
	if (Pickup != None && !Pickup.bDeleteMe)
	{
		DP = GearDroppedPickup(Pickup);
		if( DP != None )
		{
			DP.GiveTo(Self);
			return;
		}

		PF = GearPickupFactory(Pickup);
		if( PF != None )
		{
			PF.GiveTo(Self);
			return;
		}
	}
}

final function ClaimPickup(Actor Pickup)
{
	local GearPickupFactory	PF;
	local GearDroppedPickup	DP;

	DP = GearDroppedPickup(Pickup);
	if( DP != None )
	{
		DP.ClaimPickUp(Self);
		return;
	}

	PF = GearPickupFactory(Pickup);
	if( PF != None )
	{
		PF.ClaimPickUp(Self);
		return;
	}
}

/** if this Pawn is capable of picking up a nonstandard item (e.g. a projectile) place the info for that in Action for HUD displays
 *  @param FoundActor If a special pickup is possible, set this to the actor to be picked up
 *  @param FoundAction If a special action is possible, set this to action possible
 *  @param bHidePurchaseItems If set, don't allow purchaseable items
 *  @param bHideFreeItems If set, don't allow non-purchaseable items
 */
function GetSpecialPickupAction(out Actor FoundActor, out ActionInfo FoundAction, optional bool bHidePurchaseItems, optional bool bHideFreeItems);

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	if (WalkVolume(NewVolume) != None)
	{
		if (WalkVolume(NewVolume).bActive && IsDoingSpecialMove(SM_RoadieRun))
		{
			EndSpecialMove(SM_RoadieRun);
		}
	}
	Super.PhysicsVolumeChange(NewVolume);
}



/** Simple interface for handling pawn dialogue. */
simulated function Speak(SoundCue Cue)
{
	// pass thru to the more robust Gears implementation
	// assuming scripted speech here, since this only gets used from Matinee at the moment.
	SpeakLine(None, Cue, "", 0, Speech_Scripted, SIC_Always);
}

/**
 * Cause this pawn to speak the specified line.
 *
 * @param Addressee Who the line is addressing, used by headtracking.  Ok if it's none.
 * @param Audio The Audio data
 * @param DebugText Poor man's subtitle, useful for debugging.
 * @param DelaySec Time in seconds to delay before actually playing the line.
 * @param Priority Used to determine when to interrupt.
 * @param IntCondition Used to determine when to interrupt.
 * @param bNoHeadTrack True to suppress headtracking for this line
 * @param BroadcastFilter controls who gets to hear this line in network games (see ESpeakLineBroadcastFilter for values)
 * @param bSuppressSubtitle TRUE means this line will have no subtitle, regardless.	 FALSE means normal subtitle rules apply.
 * @param InExtraHeadTrackTime Extra time to keep looking at addressee after line is finished (only valid when bNoHeadTrack==false)
 */
simulated native final function bool SpeakLine(GearPawn Addressee, SoundCue Audio, optional String DebugText, optional float DelaySec, optional ESpeechPriority Priority, optional ESpeechInterruptCondition IntCondition, optional bool bNoHeadTrack, optional int BroadcastFilter, optional bool bSuppressSubtitle, optional float InExtraHeadTrackTime, optional bool bClientSide);

simulated private native final function bool ShouldSuppressSubtitlesForQueuedSpeakLine(bool bVersusMulti);

/** Return true if speech from this pawn should be rejected based on the given filter. */
simulated native private final function bool ShouldFilterOutSpeech(ESpeakLineBroadcastFilter Filter, GearPawn Addressee);

simulated event InterruptLine()
{
	if (CurrentlySpeakingLine != None)
	{
		CurrentlySpeakingLine.FadeOut(0.2f, 0.f);
		SpeakLineFinished();
	}
}

function OnInterruptSpeech(SeqAct_InterruptSpeech Action)
{
	InterruptLine();
}

simulated native private final function PlayQueuedSpeakLine();

simulated native function bool IsValidGUDSSpeaker() const;

/**
 * Control head tracking for this Pawn.
 *
 * @param ActorToTrack Who you want to look at, or None to look at nothing
 * @param LookatBoneName Bone to lookat on target, if it has bones that is
 * @param bOverride if FALSE, will only set new lookat actor if currently None
 * @param HeadTrackPriority - Type of HeadTracking so we can prioritize requests.
 * @Return TRUE if tracking new object, FALSE if request ignored
 */
final native reliable server function bool SetHeadTrackActor(Actor ActorToTrack, optional Name LookatBoneName, optional bool bOverride, optional EHeadTrackPriority HeadTrackPriority, optional float LookAtSpeedScale=1.f);
/** Internal function to start/stop head tracking based on replicated parameters. */
final native simulated function HeadTrackActorUpdated();

final simulated function DisableHeadTrack()
{
	SetHeadTrackActor(None);
}

/** Is Pawn allowed to Head track his Focus Actor */
native simulated function bool ShouldHeadTrackFocusPoint();


/**
 * Called when this pawn's spoken line is finished (naturally or interrupted), to give us
 * an opportunity to clean up.
 */
final simulated event SpeakLineFinished()
{
	local SpeakLineParamStruct EmptyLine;

	bSpeaking = FALSE;

	if(CurrentlySpeakingLine != None)
	{
		GearGRI(WorldInfo.GRI).SpeechManager.NotifyDialogueFinish(self, CurrentlySpeakingLine.SoundCue);

		CurrentlySpeakingLine = None;
	}

	// this function can be called from other ways than SetTimer as well, so
	// cancel the timer to handle those cases
	ClearTimer('SpeakLineFinished');

	// stop looking at addressee
	if( (ReplicatedHeadTrackInfo.HeadLookAtActor != None) && (ReplicatedHeadTrackInfo.HeadLookAtActor == CurrentSpeakLineParams.Addressee) )
	{
		//MessagePlayer("Disabling headtrack in "$CurrentSpeakLineParams.ExtraHeadTrackTime);
		if(CurrentSpeakLineParams.ExtraHeadTrackTime > 0.f)
		{
			SetTimer( CurrentSpeakLineParams.ExtraHeadTrackTime,false,nameof(DisableHeadTrack) );
		}
		else
		{
			DisableHeadTrack();
		}

	}

	// clear text so the line doesn't get replicated to newly joined clients after it's over
	ReplicatedSpeakLineParams = EmptyLine;
}

simulated function DoSpawnABloodPool()
{
	bSpawnABloodPool++;
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		SpawnBloodPool();
	}
}


simulated function SpawnBloodPool()
{
	if( WorldInfo.GRI.ShouldShowGore() && bSpawnBloodTrailDecals )
	{
		GearPawnFX.SpawnABloodTrail_BloodPool();
	}
}


final simulated function AddToLocalDBNOList()
{
	local GearPC GPC;

	ForEach LocalPlayerControllers(class'GearPC', GPC)
	{
		if (GPC.Pawn != None && GPC.Pawn != Self)
		{
			if (GPC.PlayerReplicationInfo != None && GPC.PlayerReplicationInfo.Team.TeamIndex == GetTeamNum())
			{
				GPC.AddDBNOTeammate(Self);
			}
		}
	}
}

/** Called by a timer set when the spot was first triggered */
function RemoveSpotTeam0()
{
	SpottedByTeam[0] = 0;
	SpottedBy[0] = None;

	// Static array replication currently does not support autoset of bNetDirty
	bNetDirty = TRUE;
}

/** Called by a timer set when the spot was first triggered */
function RemoveSpotTeam1()
{
	SpottedByTeam[1] = 0;
	SpottedBy[1] = None;

	// Static array replication currently does not support autoset of bNetDirty
	bNetDirty = TRUE;
}

/** Called by a timer set when the spot was first triggered */
function RemoveSpotTeam2()
{
	SpottedByTeam[2] = 0;
	SpottedBy[2] = None;

	// Static array replication currently does not support autoset of bNetDirty
	bNetDirty = TRUE;
}

/** Called by a timer set when the spot was first triggered */
function RemoveSpotTeam3()
{
	SpottedByTeam[3] = 0;
	SpottedBy[3] = None;

	// Static array replication currently does not support autoset of bNetDirty
	bNetDirty = TRUE;
}

/** Add a hud locator for this pawn to local player controllers */
final simulated function UpdateLocalSpottedList()
{
	local GearPC GPC;

	ForEach LocalPlayerControllers(class'GearPC', GPC)
	{
		if (SpottedByTeam[GPC.GetTeamNum()] > 0)
		{
			GPC.AddedSpottedEnemyLocator(Self);
		}
	}
}

final simulated function EndGameCondition( bool bGib )
{
	local GearGRI GRI;
	local GearPC PC;

	// Cause game over if player's squadmates dies
	GRI = GearGRI(WorldInfo.GRI);
	if( GRI != None )
	{
		if ( AIController(Controller) != None )
		{
			foreach WorldInfo.AllControllers( class'GearPC', PC )
			{
				if (!PC.PlayingDevLevel())
				{
					// one last failsafe so if someone does somehow die in the player's squad, but they weren't supposed to don't fail the game.
					if (class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo).default.bAllowAICOGDeathWhenDBNO)
					{
						PC.GameOverReason = "GearGame.GearGameSP_Base.PlayerDiedText";
						PC.GameOverTarget = GearPRI(PlayerReplicationInfo);
						PC.SetTimer(2.0, false, nameof(PC.ProcessGameOver));
						break;
					}
				}
			}
		}
	}
}


function DoRevival(GearPawn Reviver, optional bool bRevivedByKantus);

/**
 * Kismet interface for toggling the revivability of this pawn.  (Primarily used for tutorial at the moment.)
 */
function OnToggleRevive(SeqAct_ToggleRevive Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		bCanRecoverFromDBNO = TRUE;
	}
	else
	if (Action.InputLinks[1].bHasImpulse)
	{
		bCanRecoverFromDBNO = FALSE;
	}
	else
	{
		bCanRecoverFromDBNO = !bCanRecoverFromDBNO;
	}
}
/**
 * Send this pawn to ragdoll and apply the given forces.  All params are optional, to enable
 * any combination of forces (whole-body, radial, or point)
 *
 * @param RBLinearVelocity			Linear velocity to apply to entire rigid body.
 * @param RBAngularVelocity			Angular velocity to apply to entire rigid body.
 * @param RadialOrigin				World-space origin of radial impulse.
 * @param RadialRadius				Radius of radial impulse.  If 0.0, no radial impulse will be applied.
 * @param RadialStrength			Strength of radial impulse.  If 0.0, no radial impulse will be applied.
 * @param PointImpulse				Point impulse to apply.  if 0,0,0, no point impulse will be applied.
 * @param PointImpulsePosition		Position in world space at which PointImpulse should be applied.
 * @param PointImpulseBoneName		Bone that receives point impulse.
 */
function Knockdown( optional vector RBLinearVelocity, optional vector RBAngularVelocity, optional vector RadialOrigin,
			optional float RadialRadius, optional float RadialStrength, optional vector PointImpulse,
			optional vector PointImpulsePosition, optional name PointImpulseBoneName )
{
	if (Role < ROLE_Authority)
	{
`if(`notdefined(FINAL_RELEASE))
		`warn("Only allowed on server");
		ScriptTrace();
`endif
		return;
	}

	if (IsZero(RBLinearVelocity) && IsZero(RBAngularVelocity))
	{
		`Warn("No linear or angular velocity - one or the other must be set for replication to work");
		ScriptTrace();
		return;
	}

	// only one knockdown allowed at a time and not at all if dead or DBNO
	if (Physics == PHYS_RigidBody || bPlayedDeath || IsDBNO() || IsAHostage())
	{
		return;
	}
	// if holding a meatshield
	else if (IsAKidnapper())
	{
		ServerEndSpecialMove(SpecialMove);
		return;
	}
	// if driving a ridable pawn like a silverback
	else if (Base != None && Base.IsA('GearPawnRidable_Base'))
	{
		KickPawnOffTurret();
		return;
	}
	// if carrying a heavy weapon, drop it
	else if (IsCarryingAHeavyWeapon())
	{
		ThrowActiveWeapon();
	}
	// if carrying a shield, drop it
	else if (IsCarryingShield())
	{
		DropShield();
	}

	if( bCanBeKnockedDown )
	{
		StopFiring();

		//@STATS - Record player knockdown
		`RecordPlayerIntStat(KNOCKDOWN,Controller,1);

		// set the knockdown information for use in ApplyKnockdownImpulse()
		KnockdownImpulse.LinearVelocity = RBLinearVelocity;
		KnockdownImpulse.AngularVelocity = RBAngularVelocity;
		KnockdownImpulse.PointImpulse = PointImpulse;
		KnockdownImpulse.PointImpulseBoneName = PointImpulseBoneName;
		KnockdownImpulse.PointImpulsePosition = PointImpulsePosition;
		KnockdownImpulse.RadialOrigin = RadialOrigin;
		KnockdownImpulse.RadialRadius = RadialRadius;
		KnockdownImpulse.RadialStrength = RadialStrength;

		// transition to the KnockedDown state
		GotoState('KnockedDown');
	}
}

simulated function float GetKnockDownFailSafeTimeout()
{
	return 6.f;
}
/** Applies the contents of KnockdownImpulse.  Clients shouldn't call this function directly, only from repnotify. */
simulated protected function ApplyKnockdownImpulse()
{
	//`Log("KNOCKDOWN");
//	`log("!!!"@`showvar(KnockdownImpulse.LinearVelocity)@`showvar(Location)@`showvar(Mesh.GetPosition()));
	// Record when knockdown happened
	KnockDownStartTime = WorldInfo.TimeSeconds;
	KnockdownStartingPosition = Location;
	// bail out of cover
	if (IsInCover())
	{
		BreakFromCover();
	}
	if (Physics != PHYS_RigidBody || Mesh != CollisionComponent)
	{
		// first send them to ragdoll
		PlayFallDown();
	}
	if (Physics == PHYS_RigidBody)
	{
		// and apply the forces additively

		// whole-body velocities
		//@note: we set instead of adding for angular velocity as it's generally zero for newly created ragdolls
		//	and if it weren't, the client wouldn't be able to reliably derive the same value so it would just cause mismatches
		Mesh.SetRBAngularVelocity(KnockdownImpulse.AngularVelocity, false);
		if (!IsZero(KnockdownImpulse.LinearVelocity))
		{
			Mesh.SetRBLinearVelocity(KnockdownImpulse.LinearVelocity, true);
		}

		// radial impulses
		if ( (KnockdownImpulse.RadialRadius > 0.f) && (KnockdownImpulse.RadialStrength > 0.f) )
		{
			Mesh.AddRadialImpulse(KnockdownImpulse.RadialOrigin, KnockdownImpulse.RadialRadius, KnockdownImpulse.RadialStrength, RIF_Linear);
		}

		// point impulses
		if (!IsZero(KnockdownImpulse.PointImpulse))
		{
			Mesh.AddImpulse(KnockdownImpulse.PointImpulse, KnockdownImpulse.PointImpulsePosition, KnockdownImpulse.PointImpulseBoneName);
		}

		if (Role == ROLE_Authority && !bStayKnockedDown)
		{
			SetTimer(GetKnockDownFailSafeTimeout(),FALSE,nameof(KnockdownFailsafe));
			bCheckKnockdownFall = FALSE;
			SetTimer(0.5f,FALSE,nameof(EnableKnockdownFallChecking));
		}
	}
	else
	{
		`warn(self@"failed to transition to RigidBody for"@GetFuncName());
	}
}

event KnockdownFailsafe()
{
	// don't kill off dudes if they are in unlimited health as we use that for testing and you can get into places where multiple maulers will keep you knocked down for quite a while
	if( !bUnlimitedHealth )
	{
		`warn( "KnockdownFailsafe is triggering!!!" @ self @ Controller );
		// award points appropriately
		if (LastHitBy != None && LastHitBy != Controller && GearPRI(LastHitBy.PlayerReplicationInfo) != None)
		{
			// track the kill for the instigator
			GearPRI(LastHitBy.PlayerReplicationInfo).ScoreInstantKill(GearPRI(PlayerReplicationInfo), class'GDT_Environment', GDT_NORMAL);
		}
		else
		{
			// see if it was environment damage and pass it on to the death messages
			GearPRI(PlayerReplicationInfo).ScoreDeath(None, class'GDT_Environment', GDT_NORMAL, -100);
		}

		Died(LastHitBy, class'GDT_Environment', Location);
	}
}

final function EnableKnockdownFallChecking()
{
	bCheckKnockdownFall = TRUE;
}

/** Util to update motor strength of motors after being knocked down */
native function TickKnockDownMotorStrength(float DeltaSeconds);

/**
 * Knocked down state used on the server for non-lethal ragdoll scenarios.
 * Server only.
 */
state KnockedDown
{
	function BeginState(Name PrevStatName)
	{
		if (MyGearAI != None)
		{
			MyGearAI.NotifyKnockDownStart();
		}
	}

	simulated function Tick(float DeltaTime)
	{
		// if using motorised-anim during knockdown, update motor strengths
		if( bPlayMotorAnimOnKnockDown )
		{
			TickKnockDownMotorStrength(DeltaTime);
		}

		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			FadeSkinEffects(DeltaTime);
		}
	}

Begin:
	// apply the impulse
	ApplyKnockdownImpulse();
	// Set a max timer so Pawn doesn't stay in this state forever.
	if( !bStayKnockedDown )
	{
		SetTimer((MaxKnockdownTime > 0.0) ? MaxKnockdownTime : 1.5, false, nameof(EndKnockedDownState));
	}
	do
	{
		// delay
		Sleep(0.35f);

		// we can be doing a transition, and in that case the weapon will show up a bit later.
		if( Role == ROLE_Authority && IsCarryingAHeavyWeapon() )
		{
			ThrowActiveWeapon();
		}
		// until we're snapped out of physics, stopped moving, or the physics has gone to sleep
	} until ((Physics != PHYS_RigidBody || VSize(Velocity) < 8.f || !Mesh.RigidBodyIsAwake()) && !bStayKnockedDown);

	EndKnockedDownState();
}

simulated function float GetKnockdownZThreshold()
{
	return 256.f;
}

function EndKnockedDownState()
{
	ClearTimer(nameof(EndKnockedDownState));
	ClearTimer(nameof(CheckGetUp));
	ClearTimer(nameof(KnockdownFailsafe));
	ClearTimer(nameof(EnableKnockdownFallChecking));

	// leave in knockdown state if we're being chainsawed
	if (SpecialMove == SM_ChainsawVictim || SpecialMove == SM_BayonetVictim)
	{
		// set timer just in case we somehow get out of the move without being killed
		SetTimer(1.0, false, nameof(EndKnockedDownState));
	}
	else
	{
		bStayKnockedDown = false;

		// if we've fallen a significant distance then assume we're dead
		if (Abs(KnockdownStartingPosition.Z - Location.Z) > GetKnockdownZThreshold())
		{
			KnockdownFailsafe();
		}

		KnockdownImpulse.LinearVelocity = vect(0,0,0);
		KnockdownImpulse.AngularVelocity = vect(0,0,0);

		// if we're still alive at this point
		if ((Health > 0 || IsInState('KnockedDown')) && Physics == PHYS_RigidBody)
		{
			if( SpecialMoveClasses[SM_RecoverFromRagdoll] != None )
			{
				ServerDoSpecialMove(SM_RecoverFromRagdoll, TRUE);
				GotoState('');
			}
			else
			{
				`log(GetFuncName() @ "Failed to find special move class for: SM_RecoverFromRagdoll" @ self);
			}
		}
	}
}

function NotifyWaitingForRevive()
{
	local GearAI AI;
	foreach WorldInfo.AllControllers(class'GearAI', AI)
	{
		if( AI != Controller )
		{
			AI.NotifyWaitingForRevive(None, Controller, Self);
		}
	}
}

function AlterCrawlSpeed(float Delta)
{
	local bool bIncreaseDBNO;

	//`log(`location@Delta@`showvar(CrawlSpeedModifier)@`showvar(TimeOfDBNO));
	// if this is a speed increase then delay the DBNO bleedout
	bIncreaseDBNO = (Delta > 0.f);

	CrawlSpeedModifier = FClamp(CrawlSpeedModifier + Delta,0.f,0.7f);
	if (DBNOCrawlNode != None)
	{
		DBNOCrawlNode.Rate = (1.f + CrawlSpeedModifier);
	}
	if (Role < ROLE_Authority)
	{
		ServerSetCrawlSpeed(CrawlSpeedModifier, bIncreaseDBNO);
	}
	else if (bIncreaseDBNO && DBNOTimeExtensionCnt < 7 && FRand() > DBNOTimeExtensionCnt / 7.f)
	{
		TimeOfDBNO += GearGame(WorldInfo.Game).AutoReviveOnBleedOut(self) ? -1.0 : 1.0;

		DBNOTimeExtensionCnt = DBNOTimeExtensionCnt + 1;
	}
}

reliable server function ServerSetCrawlSpeed(float NewSpeed, bool bIncreaseDBNO)
{
	//`log(`location@NewSpeed@`showVar(CrawlSpeedModifier)@`showvar(TimeOfDBNO));
	// if this is a speed increase then delay the DBNO bleedout
	if (bIncreaseDBNO && DBNOTimeExtensionCnt < 7 && FRand() > DBNOTimeExtensionCnt / 7.f)
	{
		TimeOfDBNO += GearGame(WorldInfo.Game).AutoReviveOnBleedOut(self) ? -1.0 : 1.0;

		DBNOTimeExtensionCnt = DBNOTimeExtensionCnt + 1;
	}
	CrawlSpeedModifier = NewSpeed;
	ReplicatedEvent('CrawlSpeedModifier');
}

// called at the end of fights and such whenever everyone is being auto-revived
function ReviveFromAutoRevive(GearPawn GP)
{
	if(bAllowAutoRevive)
	{
		DoRevival(GP);
	}
}

/** Kismet action to send someone into DBNO state */
function OnForceDBNO( SeqAct_ForceDBNO Action )
{
	EnterDBNO(None, class'GearDamageType', vector(Rotation));
	bAllowAutoRevive = Action.bAllowAutoRevive;
	if (MyGearAI != None)
	{
		MyGearAI.bAllowDBNOCrawl = Action.bAllowAICrawl;
	}
}

/** Returns TRUE if Pawn is DBNO.
 * @param bIgnoreBeingExecuted (opt) - if true, return false when currently being executed; default is to consider us still DBNO during those
 * @param bIgnoreBeingGunked (opt) - if true, return false when currently being gunked; default is to consider us still DBNO during those
 */
simulated final native function bool IsDBNO(optional bool bIgnoreBeingExecuted, optional bool bIgnoreBeingGunked) const;

final function bool ShouldTakeDamageWhenDBNO()
{
	// if we're COG AI, don't take damage while DBNO unless difficulty settings are high enough
	if (GetTeamNum() == 0 && !WorldInfo.GRI.IsMultiplayerGame() && bCanRechargeHealth)
	{
		if (GearAI(Controller) != None)
		{
			return false;
		}
		else if (GearPC(Controller) != None)
		{
			return GearPRI(PlayerReplicationInfo).Difficulty.default.bHumanCOGCanBeExecuted;
		}
		else
		{
			return true;
		}
	}
	else
	{
		return true;
	}

}
/**  DBNO Recovery code - these code is called by DBNO and RecoveryFromDBNO GSM **/

/** Recovery animation rate changes depending on how fast you're pressing button **/
simulated function float GetRecoveryAnimationRate()
{
	local float MinSpeedModifier, MaxSpeedModifier, InvRangeSpeedModifier;

	MinSpeedModifier = 0.5;
	MaxSpeedModifier = 1.5;
	InvRangeSpeedModifier = 1.42f; // Inverse of 0.7 (max crawl speed)

	return MinSpeedModifier + FClamp((CrawlSpeedModifier)*InvRangeSpeedModifier, 0.0f, MaxSpeedModifier-MinSpeedModifier);
}

/** Play Recovery Animation **/
simulated function TickDBNORecovery()
{
	local float AnimTime;
	local BodyStance AnimToPlay;

	if ( bAllowSelfReviving==FALSE )
	{
		return;
	}

	/** If already playing adjust playrate **/
	if ( bPlayingSelfReviving )
	{
		if ( ReviveStageAnims.Length > CurrentReviveStage )
		{
			if ( ReviveAnimType != ERAT_FAIL )
			{
				AnimToPlay = ReviveStageAnims[CurrentReviveStage].ReviveAnims[ReviveAnimType];
				// modify speed
				BS_SetPlayRate(AnimToPlay, GetRecoveryAnimationRate());
			}
		}
	}
	else
	{
		// First time playing

		// A little hacky -  we set that when the stumble animation is done playing.
		// We don't want to start playing the animation until we're done with that transition.
		if( Mesh.RootMotionMode != RMM_Velocity )
		{
			return;
		}

		AnimToPlay = ReviveStageAnims[0].ReviveAnims[ERAT_RECOVER];
		AnimTime = BS_Play( AnimToPlay, GetRecoveryAnimationRate(), 0.25f, 0.25f );
		if ( AnimTime > 0.f )
		{
			// Turn off Root motion on animation node
			BS_SetRootBoneAxisOptions(AnimToPlay, RBA_Discard, RBA_Discard, RBA_Discard );
			// Turn on Root motion on mesh.
			//Mesh.RootMotionMode = RMM_Accel;
			Mesh.RootMotionMode = default.Mesh.RootMotionMode;

			BS_SetAnimEndNotify(AnimToPlay, TRUE);

			// set all variables
			bPlayingSelfReviving = TRUE;
			ReviveAnimType = ERAT_RECOVER;
			CurrentReviveStage = 0;
		}
	}
}

/** Clear playing recording **/
simulated function ClearRecovery()
{
	local BodyStance AnimToStop;

	ClearTimer(nameof(ClearRecovery));

	if ( bPlayingSelfReviving )
	{
		AnimToStop = ReviveStageAnims[CurrentReviveStage].ReviveAnims[ReviveAnimType];
		BS_Stop(AnimToStop, 0.25f);
		BS_SetAnimEndNotify(AnimToStop, FALSE);
		BS_SetRootBoneAxisOptions(AnimToStop, RBA_Discard, RBA_Discard, RBA_Discard);
		Mesh.RootMotionMode = default.Mesh.RootMotionMode;

		if (SpecialMove == SM_DBNO)
		{
			Mesh.RootMotionMode = RMM_Velocity;
		}

		// Auto reviving variable
		bPlayingSelfReviving = FALSE;
		CurrentReviveStage = 0;
		ReviveAnimType = ERAT_RECOVER;
		bFinishedSelfReviving = FALSE;

		// Clear movement
		ZeroMovementVariables();
		AlterCrawlSpeed(-CrawlSpeedModifier);
	}
}

/** Play recovery fail animation **/
simulated function PlayRecoveryFailing()
{
	local float AnimTime;
	local BodyStance AnimToPlay;

	// already playing fail
	if ( bPlayingSelfReviving && ReviveAnimType != ERAT_FAIL )
	{
		if ( ReviveStageAnims.Length > CurrentReviveStage )
		{
			AnimToPlay = ReviveStageAnims[CurrentReviveStage].ReviveAnims[ERAT_FAIL];
			// no blending out and disable early notifier
			// so that it can finish fail animation and not affecting
			// velocity from root motion is affecting movement node
			// of DBNO crawling
			AnimTime = BS_Play( AnimToPlay, 1.f, 0.25f, 0.f );
			if ( AnimTime > 0.f )
			{
				// Turn off Root motion on animation node
				BS_SetRootBoneAxisOptions(AnimToPlay, RBA_Translate, RBA_Translate );
				BS_SetAnimEndNotify(AnimToPlay, FALSE);
				// Turn on Root motion on mesh.
				Mesh.RootMotionMode = RMM_Accel;

				ReviveAnimType = ERAT_FAIL;
				SetTimer(AnimTime, FALSE, nameof(ClearRecovery));
			}
		}
	}
}

/** Move onto next Stage **/
simulated function MoveOntoNextStage()
{
	local float AnimTime;
	local int NextReviveStage;
	local BodyStance AnimToPlay;

	NextReviveStage = CurrentReviveStage + 1;

	if ( bPlayingSelfReviving && ReviveAnimType == ERAT_LOOP )
	{
		AnimToPlay = ReviveStageAnims[NextReviveStage].ReviveAnims[ERAT_RECOVER];
		AnimTime = BS_Play(AnimToPlay, GetRecoveryAnimationRate(), 0.25f, 0.67f);
		if ( AnimTime > 0.f )
		{
			BS_SetAnimEndNotify(AnimToPlay, TRUE);
			ReviveAnimType = ERAT_RECOVER;
		//	`log("Stage changes from "@CurrentReviveStage@" to "@NextReviveStage);
			CurrentReviveStage = NextReviveStage;
		}
	}
}


function DoFatalDeath(Controller InKillerController, class<GearDamageType> InDamageType, Vector InHitLocation, Vector InMomentum);

/**
 * DBNO state, only called on server.
 */
state DBNO
{
	// ignored while DBNO
	function ServerKnockdown( optional vector RBLinearVelocity, optional vector RBAngularVelocity,
					optional vector RadialOrigin, optional float RadialRadius,
					optional float RadialStrength, optional vector PointImpulse,
					optional vector PointImpulsePosition, optional name PointImpulseBoneName );
	simulated protected function ApplyKnockdownImpulse();
	function DoStumbleFromMeleeSpecialMove(GearPawn GPInstigator);
	function DoStumbleFromMantleKickSpecialMove(GearPawn KickedBy);

	event BeginState(Name PrevStateName)
	{
		local array<SequenceEvent> EngageEvents;
		local SeqEvt_Engage EngageEvent;
		local bool bIsGunkedDBNO;
		local array<SequenceEvent> ScriptedEvents;
		local SeqEvt_ScriptedMove ScriptedEvent;
		local GearGame GG;

		GG = GearGame(WorldInfo.Game);
		if (DamageTypeThatPutMeDBNO == class'GDT_StickyGoo')
		{
			bIsGunkedDBNO = true;
		}

		`LogSM("");

		if (IsInCover())
		{
			if (MyGearAI != None)
			{
				MyGearAI.InvalidateCover(false, true);
			}
			else if (GearPC(Controller) != None)
			{
				GearPC(Controller).LeaveCover();
			}
			else
			{
				CurrentLink.UnClaim(self, CurrentSlotIdx, false);
				LeaveCover();
			}
		}

		// cancel engage trigger if necessary
		if (EngageTrigger != None && (SpecialMove == SM_Engage_Start || SpecialMove == SM_Engage_Loop || SpecialMove == SM_Engage_Idle))
		{
			EngageTrigger.EngagedPawn = None;

			// fire proper kismet event
			if (EngageTrigger.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents))
			{
				EngageEvent = SeqEvt_Engage(EngageEvents[0]);
				if (EngageEvent != None && EngageEvent.bEnabled)
				{
					// don't check fov since the camera could be anywhere
					EngageEvent.bCheckInteractFOV = false;
					// fire the event
					EngageTrigger.TriggerEventClass(class'SeqEvt_Engage', self, eENGAGEOUT_Stopped);
				}
			}
		}

		// cancel scripted move trigger if necessary
		if (ScriptTrigger != None && SpecialMove == SM_ScriptedMove)
		{
			// fire proper kismet event
			if (ScriptTrigger.FindEventsOfClass(class'SeqEvt_ScriptedMove', ScriptedEvents))
			{
				ScriptedEvent = SeqEvt_ScriptedMove(ScriptedEvents[0]);
				if (ScriptedEvent != None && ScriptedEvent.bEnabled)
				{
					// don't check fov since the camera could be anywhere
					ScriptedEvent.bCheckInteractFOV = false;
					// fire the event
					ScriptTrigger.TriggerEventClass(class'SeqEvt_ScriptedMove', self, eSCRIPTOUT_Finished);
				}
			}
		}

		// server side only stuff
		bDelayedDBNO = FALSE;

		// do this before health reaches zero
		KickPawnOffTurret();

		if (!bIsGunkedDBNO)
		{
			// Set health to zero so we can count down to death amount
			Health = 0;
		}
		// keeps track of how many times this pawn has gone DBNO
		DownCount++;
		// keep track of DBNO time to give a second of invulnerability
		TimeStampEnteredRevivingState = WorldInfo.TimeSeconds;

		// track the DBNO for the victim
		GG.ScoreDBNO(self, Controller, ControllerWhoPutMeDBNO);
		GearPRI(PlayerReplicationInfo).ScoreKnockdown((ControllerWhoPutMeDBNO != None) ? GearPRI(ControllerWhoPutMeDBNO.PlayerReplicationInfo) : None, DamageTypeThatPutMeDBNO);

		GearPRI(PlayerReplicationInfo).PlayerStatus = WPS_Down;

		// notify the damage type handler for any DBNO fx
		if( HitDamageType != None )
		{
			class<GearDamageType>(HitDamageType).static.HandleDBNOPawn(self);
		}

		// notify the AI that we need reviving
		SetTimer( 0.5f, FALSE, nameof(NotifyWaitingForRevive) );

		// "so-and-so went down!" guds
		// note that in multi, we don't do this if you're the only one left, since there's nobody to revive you
		if ( (GearGameMP_Base(WorldInfo.Game) == None) || (GearGameMP_Base(WorldInfo.Game).GetNumPlayersAlive(GetTeamNum()) > 1) )
		{
			if (GearPRI(PlayerReplicationInfo).bIsLeader)
			{
				GG.TriggerGUDEvent(GUDEvent_WentDBNO_Leader, self, None);
			}
			else
			{
				GG.TriggerGUDEvent(GUDEvent_WentDBNO, self, None);
			}

			// no reminders during splits, since you might not be able to get there
			if( !GG.bInCoopSplit || !GG.bGapSquadSplit )
			{
				NeedsRevivedReminder();
				NeedsRevivedReminderCount = 0;
			}
		}

		// if carrying a heavy weapon, drop it
		if( IsCarryingAHeavyWeapon() )
		{
			ThrowActiveWeapon();
			// and select another weapon
			GearInventoryManager(InvManager).SetWeaponFromSlot(EASlot_LeftShoulder);
		}

		// if carrying a shield, drop it
		if( IsCarryingShield() )
		{
			DropShield();
		}

		StopFiring();

		// don't let AIs think they can mantle when they're DBNO
		bCanMantle  = FALSE;
		bCanClimbUp = FALSE;
		// don't let AIs think they can climb ladders when they're dbno
		bCanClimbLadders = FALSE;

		// Send Pawn into DBNO special move.
		if (bIsGunkedDBNO)
		{
			ServerDoSpecialMove(SM_Gunked, TRUE);
		}
		else
		{
			ServerDoSpecialMove(SM_DBNO, TRUE,, DetermineDBNOType());
		}

		// notify the gametype
		GG.NotifyDBNO(ControllerWhoPutMeDBNO, Controller, Self);

		// cache flag for clientside checks
		bCanBeExecutedFromAfar = GG.CanBeShotFromAfarAndKilledWhileDownButNotOut(self, None, None);

		// bAllowSelfReviving
		if ( Role==ROLE_Authority )
		{
			bAllowSelfReviving = GG.AutoReviveOnBleedOut(self);
		}
	}

	event EndState(Name NextStateName)
	{
		local GearAI OtherAI;

		`LogSM("");

		bIsBleedingOut = FALSE;

		if( Role == ROLE_Authority )
		{
			ClearTimer('NeedsRevivedReminder');
		}

		// smolder a little longer and go out
		if( bBledOut && (OnFireState == POF_Smoldering) )
		{
			IgnitePawn(POF_Smoldering,,, 8.f);
		}

		ClearTimer( 'NotifyWaitingForRevive' );

		foreach WorldInfo.AllControllers(class'GearAI', OtherAI)
		{
			if( OtherAI != MyGearAI )
			{
				OtherAI.NotifyLeftDBNO(self);
			}
		}

		// restore mantle setting since we turned it off when entering dbno
		bCanMantle	= default.bCanMantle;
		bCanClimbUp	= default.bCanClimbUp;

		// restore ladder setting since we turned it off when entering dbno
		bCanClimbLadders = default.bCanClimbLadders;
	}

	// decide determine type - this will set to specialmove flag
	function int DetermineDBNOType()
	{
		// if moving and forward
		if ( VSizeSq(Velocity) >  100.f && (Velocity Dot vector(Rotation)) > 0.f && (MomentumThatPutMeDBNO Dot vector(Rotation)) > 0 )
		{
			// it came from roadie run
			return EDTRoadieRun;
		}

		// if not human (because camera is very confusing) and if shot from front and if not in cover and if damage type is explosive
		if ( IsHumanControlled() == FALSE &&  (MomentumThatPutMeDBNO Dot vector(Rotation)) < 0 &&
			( CoverType == CT_None ) &&
			( ClassIsChildOf( DamageTypeThatPutMeDBNO, class'GDT_Explosive' ) || ClassIsChildOf( DamageTypeThatPutMeDBNO, class'GDT_SniperRifle' ) ))
		{
			// it hit from front
			return EDTSpin;
		}

		return EDTDefault;
	}
	/**
	 * If you are in state reviving and you take damage then you are FATALLY KILLED!
	 */
	function TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local class<GearDamageType> GearDamageType;

		//`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ DamageType);


		// only count "fatal" damage if they have been dead for a second
		// we do this as there are some order issues with shotgun bullets and other bullets
		// also we want there to be a clear separation between taking someone out.	and fatally killing them
		// exception: self damage always works (so that martyr is always a martyr)
		if (Role < ROLE_Authority || (WorldInfo.TimeSeconds - TimeStampEnteredRevivingState < 1.0 && InstigatedBy != Controller))
		{
			return;
		}

		`LogSM("");

		GearDamageType = class<GearDamageType>(DamageType);

		// if passed an invalid damagetype then use the default
		if( GearDamageType == None )
		{
			GearDamageType = class'GearDamageType';
		}

		// if we're COG AI, don't take damage while DBNO unless difficulty settings are high enough
		if ( !ShouldTakeDamageWhenDBNO() )
		{
			return;
		}

		// Special case for Interactions. Only InteractionPawn is allowed to damage me.
		if (IsDoingASpecialMove() && SpecialMoves[SpecialMove].bOnlyInteractionPawnCanDamageMe && InstigatedBy.Pawn != InteractionPawn && InstigatedBy.Pawn != self)
		{
			return;
		}

		// if the hit location is invalid then adjust to base location
		if( IsZero(HitLocation) )
		{
			HitLocation = GetBaseTargetLocation();
		}

		// ensure a valid momentum
		if( VSize(Momentum) > 4.f )
		{
			Momentum = Normal(Momentum);
		}

		// first allow the damage type a first-pass modifier
		GearDamageType.static.ModifyDamage(self, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

		// if the damage wasn't eliminated
		if( Damage > 0 )
		{
			// notify the game info of the damage, possibly scaling the values
			WorldInfo.Game.ReduceDamage(Damage, Self, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
		}

		if( Damage > 0 )
		{
			if (InstigatedBy == None)
			{
				InstigatedBy = ControllerWhoPutMeDBNO;
			}

			// Update health
			Health				-= Damage;
			LastTookDamageTime	 = WorldInfo.TimeSeconds;

			// play any associated fx/sounds
			DoDamageEffects(Damage, InstigatedBy.Pawn, HitLocation, DamageType, Momentum, HitInfo);

			// Don't kill right away if we're a hostage
			if( Health <= DBNODeathThreshold )
			{
				DoFatalDeath(InstigatedBy, GearDamageType, HitLocation, Momentum);
			}
		}
	}

	function DoFatalDeath(Controller InKillerController, class<GearDamageType> InDamageType, Vector InHitLocation, Vector InMomentum)
	{
		local GearPRI KillerPRI;

		`LogSM("");

		TearOffMomentum = InMomentum;
		//Health			= -1;

		// grab the last person we know of who hurt us
		if( InKillerController != None )
		{
			KillerPRI = GearPRI(InKillerController.PlayerReplicationInfo);
			if( KillerPRI != None )
			{
				KillerPRI.ScoreExecution(GearPRI(PlayerReplicationInfo), InDamageType, GDT_NORMAL);
			}
		}
		else if (ClassIsChildOf(InDamageType, class'GDT_Environment'))
		{
			GearPRI(PlayerReplicationInfo).ScoreDeath(None, InDamageType, GDT_Normal, InDamageType.default.bSuicidePenalty ? -100 : 0);
		}
		else
		{
			GearPRI(PlayerReplicationInfo).ScoreDeath(None, InDamageType, GDT_Normal);
		}
		// perform the appropriate death
		Died(InKillerController, InDamageType, InHitLocation);
	}

	function DoRevival(GearPawn Reviver, optional bool bRevivedByKantus)
	{
		local GearMPPRI MPPRI;
		local GearPC GPC;

		`LogSM("");

		if( !bCanRecoverFromDBNO )
		{
			`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "bCanRecoverFromDBNO is FALSE!! Aborted. Reviver:" @ Reviver);
			ScriptTrace();
			return;
		}

		GPC = GearPC(Controller);

		// reset to default
		bAllowAutoRevive = default.bAllowAutoRevive;

		// give the revive credit if not an auto revive
		if( Reviver != self )
		{
			GearGame(WorldInfo.Game).ScoreRevive(Reviver, self);
		}
		else
		{
			// otherwise just reset the damage lists
			GearPRI(PlayerReplicationInfo).PlayerDamageList.Length = 0;

			if (GPC != None)
			{
				MPPRI = GearMPPRI(PlayerReplicationInfo);
				if (MPPRI != None)
				{
					MPPRI.NumSelfRevivesThisRound++;
					if (MPPRI.NumSelfRevivesThisRound == 2)
					{
						// @AWARD - Survivor
						GPC.NotifyEarnedAward('Survivor');
					}
				}
			}
		}

		GearPRI(PlayerReplicationInfo).PlayerStatus = WPS_Alive;

		// Clear this variable since we only want this information if the player died from the DBNO
		GearPRI(PlayerReplicationInfo).LastToDBNOMePRI = None;

		// return with reduced health
		if(bRevivedByKantus)
		{
			// if we've been revived by the kantus, go to 15% health, until after the revive is done
			Health = DefaultHealth * 0.15f;
		}
		else
		{
			if (HealthRechargeDelay > 0.f)
			{
				Health = DefaultHealth * 0.8f;
			}
			else
			{
				Health = DefaultHealth;
			}
		}

		// notify kismet of Revival
		TriggerEventClass( class'SeqEvt_EnteredRevivalState', Reviver, 1 );

		if( GPC != None )
		{
			GPC.GoToPlayerWalking();
			if( (Role == ROLE_Authority) && !GPC.IsLocalPlayerController() )
			{
				GPC.bRequestClientVerifyState = TRUE;
			}

			// Have the HUD draw who revived them
			if( WorldInfo.GRI.IsMultiplayerGame() )
			{
				GPC.ClientStartDrawingRevival( Reviver );
			}
		}
		else
		{
			if( MyGearAI != None )
			{
				MyGearAI.PawnWasRevived();
			}
		}

		if(bRevivedByKantus)
		{
			KantusReviver = GearPawn_LocustKantusBase(Reviver);
		}

		// Start recovery special move
		ServerDoSpecialMove(SM_RecoverFromDBNO, TRUE, None, class'GSM_RecoverFromDBNO'.static.PackSpecialMoveFlags(bRevivedByKantus));

		// transition back to the default state
		GotoState('');

		// start the recharge process
		if (!bRevivedByKantus && HealthRechargeDelay > 0.f)
		{
			EnableHealthRecharge();
		}
	}


	function bool ShouldBleedOut()
	{
		local bool bIsGunkedDBNO;

		if (DamageTypeThatPutMeDBNO == class'GDT_StickyGoo')
		{
			bIsGunkedDBNO = true;
		}

		// if a hostage or cheating
		if (bIsGunkedDBNO || IsAHostage() || GearGame(WorldInfo.Game).bDBNOForeverCheat)
		{
			// no bleed out
			return FALSE;
		}
		// if AI controlled (and not MP)
		if (!IsHumanControlled() && GetTeamNum() == 0 && !WorldInfo.GRI.IsMultiplayerGame() && GearAI_TDM(Controller) == None)
		{
			// bleed out based on difficulty
			// in Arcade never let squadmates die since humans will respawn
			return (!bCanRechargeHealth || (GearPRI(PlayerReplicationInfo).Difficulty.default.bAllowAICOGDeathWhenDBNO && GearGameSP_Arcade(WorldInfo.Game) == None));
		}
		// otherwise bleed out
		return TRUE;
	}

Begin:

	// handle stopping any current speech, if any
	if (CurrentlySpeakingLine != None && CurrentSpeakLineParams.Priority == Speech_Scripted)
	{
		`SpeechLog(self@"DBNO'd, aborting speech"@CurrentlySpeakingLine.SoundCue);
		CurrentlySpeakingLine.FadeOut(0.2f, 0.f);
		SpeakLineFinished();
	}

	// if we're the server and not a hostage
	if (Role == ROLE_Authority)
	{
		if (ShouldBleedOut())
		{
			bIsBleedingOut = TRUE;
			// start the bleed out cycle
			while( TRUE )
			{
				if (IsAHostage() || IsSpecialMeleeVictim())
				{
					break;
				}

				// check that we didn't become unable to bleed out (e.g. due to Campaign game becoming co-op)
				if (!WorldInfo.GRI.IsMultiplayerGame() && !ShouldBleedOut())
				{
					Goto('Begin');
				}

				if ( (TimeOfDBNO > 0) && ((WorldInfo.TimeSeconds - TimeOfDBNO) > GetRevivalTime()) )
				{
					// if we should auto revive
					if( GearGame(WorldInfo.Game).AutoReviveOnBleedOut(self) )
					{
						// then do so
						DoRevival(self);
					}
					else
					{
						// otherwise go ahead and die
						bBledOut = TRUE;
						DoFatalDeath(ControllerWhoPutMeDBNO, class'GDT_BledOut', Location, vect(0,0,1));
					}
				}
				Sleep(0.5f);
			}
		}
		else if (!WorldInfo.GRI.IsMultiplayerGame())
		{
			// we need to check if we become able to bleed out in SP since that state may change
			// if a player leaves the game
			while (!IsAHostage())
			{
				if (ShouldBleedOut())
				{
					Goto('Begin');
				}
				Sleep(1.0);
			}
		}
	}
}


/** Called on a timer while this pawn is in the "down but not out" state */
final function NeedsRevivedReminder(optional bool bManuallyCalled)
{
	local GearPawn GP;

	if (IsBeingExecuted())
	{
		return;
	}

	// Only play needs revive GUDs if someone else on the team is alive
	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (GP != Self && GP.IsAliveAndWell() && WorldInfo.GRI.OnSameTeam(GP, self))
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_NeedsRevived, self, None);
			break;
		}
	}

	if (++NeedsRevivedReminderCount < 5 && !bManuallyCalled)
	{
		SetTimer( RandRange(5.f,10.f),FALSE,nameof(NeedsRevivedReminder) );
	}
}

/** check to see if I'm near a team mate*/
final function bool IsNearATeammate(optional float DistThresh=384.0f)
{
	local GearPawn GP;

	foreach WorldInfo.AllPawns(class'GearPawn', GP, Location, DistThresh)
	{
		if (GP != None && GP.IsAliveAndWell() && WorldInfo.GRI.OnSameTeam(GP, self))
		{
			return TRUE;
		}
	}

	return false;
}

/** Helper function to fade out an audio component if it is valid */
simulated final function FadeOutAudioComponent(AudioComponent AC, float Duration, optional float Volume)
{
	if (AC != None)
	{
		AC.FadeOut(Duration,Volume);
	}
}

/************************************************************************************
 * Meat Shield
 ***********************************************************************************/


/** Returns TRUE if this Pawn is a hostage. */
simulated final native function bool IsAHostage() const;

/** Returns TRUE if this Pawn is a kidnapper. */
simulated final native function bool IsAKidnapper() const;

/** Implemented in Kidnapped state */
function FreeHostage(GearPawn Kidnapper);

/** see if we should play the kidnap recovery anim */
function CheckKidnapRecovery()
{
	if (KidnapRecoveryTime > 0.0)
	{
		// Abort current special move.
		if( IsDoingASpecialMove() )
		{
			ServerEndSpecialMove(SpecialMove);
		}

		DoStumbleGoDownSpecialMove();
		SetTimer(KidnapRecoveryTime, FALSE, nameof(GetBackUpFromKnockDown));
	}
}

simulated function bool CanBeAHostage()
{
	// don't allow the player to be picked up again when he was very recently dropped and recovering
	// prevents an exploit where a player spams drop and grab commands
	return (!IsTimerActive(nameof(GetBackUpFromKnockDown)) || GetTimerCount(nameof(GetBackUpFromKnockDown)) > 1.0);
}

/** called by the client for living hostages (e.g. leaders) when they want to fight back (taunts, shakes on kidnapper, etc) */
reliable server function ServerDoHostageResistance();

/**
 * Kidnapped state, only called on server.
 * State used for Hostages set from GSM_Hostage.
 */
state Kidnapped
{
	function ServerKnockdown( optional vector RBLinearVelocity, optional vector RBAngularVelocity,
					optional vector RadialOrigin, optional float RadialRadius,
					optional float RadialStrength, optional vector PointImpulse,
					optional vector PointImpulsePosition, optional name PointImpulseBoneName );
	simulated protected function ApplyKnockdownImpulse() {}
	function DoStumbleFromMeleeSpecialMove(GearPawn GPInstigator) {}
	function DoStumbleFromMantleKickSpecialMove(GearPawn KickedBy) {}

	event BeginState(Name PrevStateName)
	{
		`LogSM("");

		// Giving hostage a second of immortality
		TimeStampEnteredRevivingState = WorldInfo.TimeSeconds;

		// Clear this variable since we only want this information if the player died from the DBNO
		GearPRI(PlayerReplicationInfo).LastToDBNOMePRI = None;
	}

	event EndState(name NextStateName)
	{
		// sanity check in case the special move breaks in some way
		if (NextStateName != 'DBNO' && NextStateName != 'Dying')
		{
			Health = Max(Health, 1);
		}
	}

	/**
	 * If you are in state reviving and you take damage then you are FATALLY KILLED!
	 */
	function TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local class<GearDamageType> GearDamageType;
		local bool bIsMeatFlag;

		//`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ DamageType);

		if (Role < ROLE_Authority)
		{
			return;
		}

		`LogSM("");

		GearDamageType = class<GearDamageType>(DamageType);

		// if passed an invalid damagetype then use the default
		if( GearDamageType == None )
		{
			GearDamageType = class'GearDamageType';
		}

		// if the hit location is invalid then adjust to base location
		if( IsZero(HitLocation) )
		{
			HitLocation = GetBaseTargetLocation();
		}

		// ensure a valid momentum
		if( VSize(Momentum) > 4.f )
		{
			Momentum = Normal(Momentum);
		}

		// first allow the damage type a first-pass modifier
		GearDamageType.static.ModifyDamage(self, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

		// if the damage wasn't eliminated
		if( Damage > 0 )
		{
			// notify the game info of the damage, possibly scaling the values
			WorldInfo.Game.ReduceDamage(Damage, Self, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
		}

		if( Damage > 0 )
		{
			HostageHealth		-= Damage;
			LastTookDamageTime	 = WorldInfo.TimeSeconds;

			// if we won't die from being kidnapped then pass a portion of the damage to the kidnapper to prevent "god mode"
			if (!CanBeSpecialMeleeAttacked(InteractionPawn))
			{
				bIsMeatFlag = TRUE;
				// if it's explosive then don't pass through since this will already cause a break
				if (ClassIsChildOf(DamageType,class'GDT_Explosive'))
				{
					return;
				}

				// Block passing on damage while being bag tagged
				if (!IsDoingSpecialMove(SM_Hostage_GrenadeRelease))
				{
					InteractionPawn.TakeDamage(Damage * (1.f - MeatflagProtectionPct),InstigatedBy,HitLocation,Momentum,DamageType);
				}
			}

			// Update Hostage health effects
			UpdateHostageHealth();

			// play any associated fx/sounds
			DoDamageEffects(Damage, InstigatedBy.Pawn, HitLocation, DamageType, Momentum, HitInfo);

			// Explosive damage will always kill the hostage
			// Conventional weapons cannot kill MeatFlag (check for CanBeSpecialMeleeAttacked)
			if (!bIsMeatFlag && (ClassIsChildOf(DamageType, class'GDT_Explosive') || HostageHealth <= 0))
			{
				TearOffMomentum = Momentum;
				Health			= -1;

				if (ClassIsChildOf(DamageType, class'GDT_Explosive'))
				{
					if (ClassIsChildOf(DamageType, class'GDT_Mortar'))
					{
						// if it's a mortar then delay longer since it's far likely we'll die soon
						InteractionPawn.SetTimer(0.5f,FALSE,nameof(SavedByAMeatshieldCallback));
					}
					else
					{
						InteractionPawn.SetTimer(0.1f,FALSE,nameof(SavedByAMeatshieldCallback));
					}
				}

				// perform the appropriate death
				Died(InstigatedBy, GearDamageType, HitLocation);

				// If somehow we're still hostage after dying.... Force a release.
				if (IsAHostage() && InteractionPawn.IsAKidnapper())
				{
					InteractionPawn.ServerEndSpecialMove();
				}
			}
		}
	}

	reliable server function ServerDoHostageResistance()
	{
		local GearPC PC;
		local GSM_Hostage HostageMove;

		HostageMove = GSM_Hostage(SpecialMoves[SpecialMove]);
		// check cooldown and make sure kidnapper intro has been fully completed
		if ( HostageMove != None && Controller != None && WorldInfo.TimeSeconds - HostageMove.LastResistTime > HostageMove.ResistShakeCooldown &&
			!InteractionPawn.SpecialMoves[InteractionPawn.SpecialMove].bMovementDisabled )
		{
			// maybe taunt
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_KidnapResist, self);

			PC = GearPC(InteractionPawn.Controller);
			if (PC != None)
			{
				PC.ClientPlayCameraShake(HostageMove.ResistShake);
				PC.ClientPlayForceFeedbackWaveform(HostageMove.ResistFF);
			}
			else
			{
				//@FIXME: set some flag on bot to screw up accuracy
			}

			InteractionPawn.ServerDoSpecialMove(InteractionPawn.SpecialMove, true, self, InteractionPawn.SpecialMoveFlags + 1);

			//@FIXME: temporarily do shake on hostage as well so they know what the button press did
			//	remove when get an anim
			PC = GearPC(Controller);
			if (PC != None)
			{
				PC.ClientPlayCameraShake(HostageMove.ResistShake);
				PC.ClientPlayForceFeedbackWaveform(HostageMove.ResistFF);
			}

			HostageMove.LastResistTime = WorldInfo.TimeSeconds;

			InteractionPawn.TakeDamage(HostageMove.ResistDamage, Controller, Location, -vector(Rotation), class'GDT_Hostage');
		}
	}

	/** Free Hostage. Let him walk away. */
	function FreeHostage(GearPawn Kidnapper)
	{
		local GearPC	GPC;

		`LogSM("");

		if (!SetLocation(Location + vect(0,0,1)))
		{
			`Log("Recovering hostage stuck in a wall, teleporting to nearest nav point");
			SetLocation(class'NavigationPoint'.static.GetNearestNavToActor(self).Location);
		}

		GearPRI(PlayerReplicationInfo).PlayerStatus = WPS_Alive;

		// return with reduced health, but instantly recharging
		Health = DefaultHealth * 0.5f;
		EnableHealthRecharge();

		// notify kismet of Revival
		// @fixme laurent - probably need another event there
		TriggerEventClass(class'SeqEvt_EnteredRevivalState', Self, 1);

		GPC = GearPC(Controller);
		if( GPC != None )
		{
			GPC.GoToPlayerWalking();
			if( (Role == ROLE_Authority) && !GPC.IsLocalPlayerController() )
			{
				GPC.bRequestClientVerifyState = TRUE;
			}

			// Have the HUD draw who revived them
			if( WorldInfo.GRI.IsMultiplayerGame() )
			{
				GPC.ClientStartDrawingRevival(Self);
			}
		}
		// tell AI that it was released/revived
		else if (MyGearAI != None)
		{
			MyGearAI.PawnWasRevived();
		}

		// if pawn is on fire or smoldering, put him out
		ExtinguishPawn();

		// Start recovery special move
		ServerDoSpecialMove(SM_RecoverFromDBNO, TRUE);

		// transition back to the default state
		GotoState('');

		CheckKidnapRecovery();
	}

	function Unpossessed()
	{
		local PlayerReplicationInfo PRI;

		PRI = PlayerReplicationInfo;
		Global.Unpossessed();
		// preserve the PRI past death since we still refer to it via HUD icons, etc
		PlayerReplicationInfo = PRI;
	}
}

/**
 * Reflect Hostage's health through gradual gibbing.
 */
simulated function UpdateHostageHealth()
{
	local int BucketNum;
	local int HealthLost;
	local int Index;
	local int HostageBoneCount;
	local vector HitLoc;
	local vector Momentum;
	local RB_ConstraintInstance	ConstraintInst;

	if (GoreSettings == None ||
		GoreSettings.HostageBones.Length == 0 ||
		!IsAHostage() ||
		// This is the check for the meatflag, he cannot be gibbed!
		!CanBeSpecialMeleeAttacked(InteractionPawn) ||
		// We don't break constraints on meatbags with partial gore enabled
		GearGRI(WorldInfo.GRI).bShowPartialGore)
	{
		return;
	}

	HostageBoneCount = GoreSettings.HostageBones.Length;
	HealthLost = Max(HostageDefaultHealth - HostageHealth, 0);
	// 10% so we get all of the bones broken off
	BucketNum = INT((FLOAT(HealthLost) / (HostageDefaultHealth-(HostageDefaultHealth*0.10f))) * FLOAT(GoreSettings.HostageBones.Length));

	// Search through the list breaking off the bones up to the bucket amount
	for (Index = 0; Index < BucketNum && Index < HostageBoneCount; Index++)
	{
		ConstraintInst = Mesh.PhysicsAssetInstance.FindConstraintInstance(GoreSettings.HostageBones[Index], Mesh.PhysicsAsset);
		if (ConstraintInst != None &&
			!ConstraintInst.bTerminated)
		{
			if (!bIsGore)
			{
				// first time just create the gore skeleton
				SwitchToGore();
				return;
			}

			HitLoc = Mesh.GetBoneLocation(GoreSettings.HostageBones[Index]);
			Momentum = Normal(HitLoc - Location) * 10.f;
			BreakConstraint(Momentum, HitLoc, GoreSettings.HostageBones[Index]);
		}
	}
}

/** Restores mesh to original state. */
final simulated function CancelMeatShieldRagDoll()
{
	bInMeatShieldRagDoll	= FALSE;
	Mesh.PhysicsWeight		= 0.f;

	// Fix all bones back to animation. Return to being fully Kinematic.
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(TRUE);
	Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, Mesh);
}

/** Conditionally plays the scripted move special move */
simulated function ConditionalDoScriptedMove()
{
	if (ScriptTrigger != None &&
		!IsDoingSpecialMove(SM_ScriptedMove))
	{
		DoSpecialMove(SM_ScriptedMove, true);
		if (Role < ROLE_Authority)
		{
			ServerDoScriptedMove(ScriptTrigger);
		}
	}
}

/**  Tell the server to do the scripted move */
reliable server function ServerDoScriptedMove(Trigger_ScriptedMove ScriptTrig)
{
	ScriptTrigger = ScriptTrig;
	if (ScriptTrigger != None &&
		!IsDoingSpecialMove(SM_ScriptedMove))
	{
		DoSpecialMove(SM_ScriptedMove, true);
	}
}

/** Validate collision from Pawn to Door Trigger */
simulated function bool ValidateDoorTriggerCollision(Trigger_DoorInteraction DoorTrig)
{
	return (!DoorTrig.bDoTraceToPlayer || FastTrace( DoorTrig.Location, Location ));
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local GearAI AI;
	local GearPC PC;
	local AIAvoidanceCylinderComponent AvoidCyl;
	local Trigger_DoorInteraction	DoorTrig;
	local Trigger_Engage Engage;
	local Trigger_ScriptedMove ScriptTrig;
	local Trigger_LadderInteraction	LT;
	local GearDroppedPickup_Shield Shield;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	// look for a door trigger to interact with
	if (SpecialMoveClasses[SM_DoorKick] != None)
	{
		DoorTrig = Trigger_DoorInteraction(Other);
		if (DoorTrig != None && ValidateDoorTriggerCollision(DoorTrig) )
		{
			DoorTrigger = DoorTrig;
			PC = GearPC(Controller);
			if (PC != None)
			{
				PC.OnEnterDoorTrigger(DoorTrig);
			}
			else
			{
				AI = GearAI(Controller);
				if( DoorTrigger.bAutoTriggerAI && AI != None )
				{
					if( DoorTrigger.TriggerEventClass(class'SeqEvt_DoorOpen',self,,TRUE))
					{
						if(IsDoingSpecialMove(SM_RoadieRun) || IsDoingSpecialMove(SM_RoadieRunStab))
						{
							EndSpecialMove();
						}
						ServerDoSpecialMove(SM_DoorKick);
					}
				}
			}

			return;
		}
	}

	if (Role == ROLE_Authority)
	{
		Engage = Trigger_Engage(Other);
		if ( Engage != None )
		{
			if (EngageTrigger == None || !IsDoingASpecialMove() || GSM_Engage(SpecialMoves[SpecialMove]) == None)
			{
				EngageTrigger = Engage;
			}
			return;
		}
	}

	if (IsLocallyControlled())
	{
		ScriptTrig = Trigger_ScriptedMove(Other);
		if (ScriptTrig != None &&
			ScriptTrig.TriggerIsUsable(self))
		{
			if (ScriptTrigger == None ||
				!IsDoingSpecialMove(SM_ScriptedMove) ||
				GSM_ScriptedMove(SpecialMoves[SpecialMove]) == None)
			{
				ScriptTrigger = ScriptTrig;
				ConditionalDoScriptedMove();
				return;
			}
		}
	}

	LT = Trigger_LadderInteraction(Other);
	if( LT != None )
	{
		LadderTrigger = LT;
		return;
	}

	// check for roadie running into a deployed shield
	if (Role == ROLE_Authority && IsDoingSpecialMove(SM_RoadieRun))
	{
		Shield = GearDroppedPickup_Shield(Other);
		if (Shield != None &&
			Shield.CanKickOver(self, false))
		{
			Shield.SetTimer( 0.85f,FALSE,nameof(Shield.KickOver) );
			ServerDoSpecialMove(SM_DoorKick, TRUE);
			return;
		}
	}

	if (MyGearAI != None)
	{
		AvoidCyl = AIAvoidanceCylinderComponent(OtherComp);
		if (AvoidCyl != None)
		{
			//`log(GetFuncName()@Other@OtherComp@AvoidCyl.TeamThatShouldFleeMe);
			AvoidCyl.AIEnteredAvoidanceCylinder(MyGearAI);
		}
	}
}

event UnTouch(Actor Other)
{
	local GearPC						PC;
	local Trigger_DoorInteraction	DoorTrig;
	local Trigger_LadderInteraction	LT;
	local Trigger_ScriptedMove ScriptTrig;

	Super.UnTouch(Other);

	if (Role == ROLE_Authority)
	{
		ScriptTrig = Trigger_ScriptedMove(Other);
		if ( ScriptTrig != None && ScriptTrigger == ScriptTrig )
		{
			if (!IsDoingSpecialMove(SM_ScriptedMove))
			{
				ScriptTrigger = None;
			}
			return;
		}
	}

	if (SpecialMoveClasses[SM_DoorKick] != None)
	{
		DoorTrig = Trigger_DoorInteraction(Other);
		if (DoorTrig != None)
		{
			PC = GearPC(Controller);
			if (PC != None)
			{
				PC.OnExitDoorTrigger();
			}
			DoorTrigger = None;
			return;
		}
	}

	LT = Trigger_LadderInteraction(Other);
	if( LT != None && LT == LadderTrigger )
	{
		LadderTrigger = None;
	}
}

event BumpLevel(Vector HitLocation, Vector HitNormal)
{
	local rotator SpawnRotation;
	local Vector HitOffset;

	HitOffset = (Location)+(HitNormal*10);
	if(WorldInfo.TimeSeconds > LastEvadeIntoWallTime + 3.0 && IsEvading())
	{
		if ( EffectIsRelevant(Location, false, 2000) )
		{
			SpawnRotation = rotator(HitNormal);
			WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'Effects_Gameplay.Player_Movement.P_Player_Cover_Hit', HitOffset, SpawnRotation);
		}

		LastEvadeIntoWallTime = WorldInfo.TimeSeconds;
	}
}
/**
 * Overridden to avoid the extra trace in Actor.
 */
simulated function bool CalcCamera(float DeltaTime, out vector out_CamLoc, out rotator out_camRot, out float out_FOV)
{
	return FALSE;
}


/************************************************************************************
 * Firing Code
 ***********************************************************************************/


function bool StopFiring()
{
	bPendingFire = FALSE;
	bPendingAltFire = FALSE;
	bPendingMeleeAttack = FALSE;

	if( Weapon != None )
	{
		Weapon.StopFire(Weapon.CurrentFireMode);
	}

	return TRUE;
}

simulated function HandleWeaponFiring()
{
	local bool bIsControllerFireInputPressed, bIsWeaponPendingFire, bShouldDelayFiring;
	local byte MeleeFiringMode, AltFiringMode;

	// Normal weapon firing (FiringMode 0)
	bIsControllerFireInputPressed = IsControllerFireInputPressed(0);
	bIsWeaponPendingFire = IsWeaponPendingFire(0);
	bShouldDelayFiring = ShouldDelayFiring();

	// If weapon firing was delayed (bPendingFire=TRUE) and
	// the weapon can't fire or the player has let go of the trigger
	if (bPendingFire && !CanFireWeapon())
	{
		bPendingFire = false;
	}

	//debug
	`AILog_Ext( GetFuncName()@`showvar(bIsControllerFireInputPressed)@`showvar(Controller.bFire)@`showvar(bIsWeaponPendingFire)@`showvar(bShouldDelayFiring)@`showvar(PawnCommitToFiring(0))@`showvar(CanFireWeapon()), 'WeaponFiring', MyGearAI );

	// If weapon is not about to fire and the pawn is trying to fire
	if (!bIsWeaponPendingFire && PawnCommitToFiring(0))
	{
		// If need to delay firing because of animation transitions...
		if (bShouldDelayFiring)
		{
			if (!bPendingFire)
			{
				// firing was delayed, but set alert time anyway, so we stay alert if the shot was aborted
				// checking bPendingFire so we only do this on the first frame of the delay
				SetWeaponAlert(AimTimeAfterFiring);

				// tell server too, if we're the client, so everyone else gets the aiming anim started
				if (WorldInfo.NetMode == NM_Client)
				{
					ServerSetWeaponAlert(byte(AimTimeAfterFiring));
				}
			}

			// Delay because of animation transitions.
			// Example scenario: player ducks behind cover, and taps fire once.
			// The animations need to blend to the blind fire pose before the weapon can fire,
			// But if the player released fire before the animations blended, the weapon won't fire.
			// To fix this problem we set a bPendingFire flag when shots are delayed because of animations.
			bPendingFire = true;
		}
		else
		{
			//debug
			`AILog_Ext("StartFire 0", 'WeaponFiring', MyGearAI);

			// Start firing and cancel pending flag
			NotifyActuallyFiring();
			StartFire(0);
			bPendingFire = false;
		}
	}
	// Otherwise, if weapon is about to fire and is prevented from firing
	else if (bIsWeaponPendingFire && (!bIsControllerFireInputPressed || !CanFireWeapon() || bShouldDelayFiring))
	{
		//debug
		`AILog_Ext("StopFire 0", 'WeaponFiring', MyGearAI);

		// Stop firing
		StopFire(0);
	}

	// Notify Special Move when fire button is pressed. Even if the pawn can't fire his weapon.
	if (bIsControllerFireInputPressed && SpecialMove != SM_None && SpecialMoves[SpecialMove].bForwardFirePressedNotification)
	{
		SpecialMoves[SpecialMove].FirePressedNotification();
	}

	// BEGIN ALT FIRE
	if (MyGearWeapon != None && MyGearWeapon.bAltFireWeapon)
	{
		AltFiringMode = class'GearWeapon'.const.ALTFIRE_FIREMODE;
		bIsWeaponPendingFire = IsWeaponPendingFire(AltFiringMode);

		if (bPendingAltFire && !CanFireWeapon())
		{
			bPendingAltFire = false;
		}

		if (!bIsWeaponPendingFire && PawnCommitToFiring(AltFiringMode))
		{
			// If no need to delay firing because of animation transitions, fire now
			if( bShouldDelayFiring )
			{
				// Delay because of animation transitions.
				bPendingAltFire = true;
			}
			else
			{
				StartFire(AltFiringMode);
				bPendingAltFire = false;
			}
		}
		else if (bIsWeaponPendingFire && (!IsControllerFireInputPressed(AltFiringMode) || !CanFireWeapon() || bShouldDelayFiring))
		{
			StopFire(AltFiringMode);
		}
	}
	/// END ALT FIRE

	// Melee Attacks (FiringMode MELEE_ATTACK_FIREMODE)
	// Mimics normal firing code.
	MeleeFiringMode = class'GearWeapon'.const.MELEE_ATTACK_FIREMODE;

	bIsWeaponPendingFire = IsWeaponPendingFire(MeleeFiringMode);
	bIsControllerFireInputPressed = IsControllerFireInputPressed(MeleeFiringMode);

	// If bPendingMeleeAttack and can't trigger a melee attack, then cancel bPendingMeleeAttack.
	if (bPendingMeleeAttack && !CanEngageMelee())
	{
		bPendingMeleeAttack = false;
	}

	if (!bIsWeaponPendingFire && (bPendingMeleeAttack || (bIsControllerFireInputPressed && CanEngageMelee())))
	{
		if (!ShouldDelayMeleeAttack())
		{
			bPendingMeleeAttack = false;

			// break them out of cover if necessary
			if( IsInCover() )
			{
				BreakFromCover();
			}

			//`log("starting melee");
			// Make sure weapon is not firing
			StartFire(MeleeFiringMode);
		}
		else
		{
			bPendingMeleeAttack = true;
		}
	}
	else if (bIsWeaponPendingFire && (!IsControllerFireInputPressed(MeleeFiringMode) || Health <= 0 || Controller == None))
	{
		// Only abort if not in the middle of a chainsaw attack
		if( !IsDoingASpecialMove() ||
				(!IsDoingSpecialMove(SM_ChainSawAttack) &&
				 !IsDoingSpecialMove(SM_ChainSawVictim) &&
				 !IsDoingSpecialMove(SM_ChainsawDuel_Leader) &&
				 !IsDoingSpecialMove(SM_ChainsawDuel_Follower) &&
				 !IsDoingSpecialMove(SM_ChainsawDuel_Draw) &&
				 !IsDoingSpecialMove(SM_BayonetAttack) &&
				 !IsDoingSpecialMove(SM_BayonetVictim) && 
				 !IsDoingSpecialMove(SM_BayonetDraw_Leader) &&
				 !IsDoingSpecialMove(SM_BayonetDraw_Follower)) )
		{
			StopFire(MeleeFiringMode);
		}
	}
}

simulated function NotifyActuallyFiring();

/**
 * Returns TRUE if our Pawn's weapon's trigger is being pressed.
 */
simulated function bool IsWeaponPendingFire(Byte InFiringMode)
{
	return (InvManager != None && InvManager.IsPendingFire(Weapon, InFiringMode));
}

/**
 * Is Controller Input requesting to fire for FiringMode InFiringMode?
 */
simulated function bool IsControllerFireInputPressed(Byte InFiringMode)
{
	if ( Controller == None )
	{
		return false;
	}

	switch( InFiringMode )
	{
		case class'GearWeapon'.const.DEFAULT_FIREMODE :
			return (Controller.bFire == 1);
		case class'GearWeapon'.const.MELEE_ATTACK_FIREMODE :
			return (bWantsToMelee);
		case class'GearWeapon'.const.ALTFIRE_FIREMODE :
			return (Controller.bAltFire == 1);
	}

	return FALSE;
}

/**
* Player willing to fire? Or Player is already firing?
* Weapon may still not fire because of ShouldDelayFiring()
* But player would still be in a firing posture (CoverAction/Animations)
*/
final simulated function bool PawnCommitToFiring( Byte InFiringMode )
{
	if( IsWeaponPendingFire(InFiringMode) )
	{
		return TRUE;
	}

	if (GearWeap_GrenadeBase(Weapon) != None && Weapon.IsTimerActive('StartThrow'))
	{
		return TRUE;
	}

	if( IsControllerFireInputPressed(InFiringMode) ||
		(bPendingFire	 && InFiringMode == class'GearWeapon'.const.DEFAULT_FIREMODE ) ||
		(bPendingAltFire && InFiringMode == class'GearWeapon'.const.ALTFIRE_FIREMODE ) )
	{
		return CanFireWeapon();
	}
	return FALSE;
}

/**
 * Returns true if Pawn can fire his weapon.
 * Used by Weapon to figure when it can be fired, and by HUD to draw crosshair indicator.
 */
native simulated function bool CanFireWeapon(optional bool bTestingForTargeting);

/**
 * If TRUE, firing should be delayed.
 * This is used to keep the player animations in a firing stance, but prevents the gun from actually be fired.
 * This prevents firing during anim blend transitions.
 * @param bReticleTesting TRUE if testing to render reticle on HUD.
 */
simulated function bool ShouldDelayFiring(optional bool bReticleTesting=FALSE)
{
	local GearPC PCOwner;
	local GearGameplayCamera Cam;

	// If the weapon doesn't want to delay firing because of animations, then ignore this function.
	if( MyGearWeapon != None && MyGearWeapon.bNoAnimDelayFiring )
	{
		return FALSE;
	}

	// If in cover and CA_Default can't fire unless in 360 aiming.
	// Outside of 360 aiming, an action is required (blind firing or leaning).
	if( CoverType != CT_None && CoverAction == CA_Default && !bDoing360Aiming && IsHumanControlled() )
	{
		// we do allow firing if completely out of ammo though, so we can get the no-ammo feedback
		if (MyGearWeapon == None || MyGearWeapon.HasAnyAmmo())
		{
			return TRUE;
		}
	}

	// Check for animation transitions.
	// However don't disable reticle when doing animation transitions.
	if( !bReticleTesting && DoingAnimationTransition() )
	{
		return TRUE;
	}

	// When not in cover, delay if not in aiming stance.
	if( (CoverType == CT_None) && bTargetingNodeIsInIdleChannel && MyGearWeapon != None && (MyGearWeapon.bAllowAimingStance || MyGearWeapon.bAllowDownsightsStance) )
	{
		return TRUE;
	}

	// When leaving cover and interpolating rotation back, wait for Pawn to face aiming reticule before being able to fire again.
	if( SpecialMove == SM_None && CoverType == CT_None && IsDoingPawnRotationInterpolation() && Abs(AimOffsetPct.X) > 0.5f )
	{
		return TRUE;
	}

	// If doing a camera turn, we can't aim, so disallow firing.
	PCOwner = GearPC(Controller);
	if( PCOwner != None )
	{
		Cam = GearPlayerCamera(PCOwner.PlayerCamera).GameplayCam;
		if( Cam != None && Cam.bDoingACameraTurn )
		{
			return TRUE;
		}
	}

	return FALSE;
}


/** Returns TRUE is Pawn is doing an Animation Transition. */
simulated function final bool DoingAnimationTransition()
{
	local bool bAllowFiring;

	// doing 360 aiming cover anim transitions do not occur, so don't wait for them
	// we also don't care about mirror transitions in this case
	if( bDoing360Aiming )
	{
		return FALSE;
	}
	// Check for mirror transitions -- don't delay if in CA_PopUp.
	// Allowed to fire while doing a cover slip special move.
	else if( bDoingMirrorTransition && CoverAction != CA_PopUp && SpecialMove != SM_CoverSlip )
	{
		return TRUE;
	}
	// Delay during animation transitions, or if we're expecting one to happen...
	else if ((bDoingCoverActionAnimTransition || (CoverType != CT_None && CoverAction != CoverActionAnim)))
	{
		// Some transitions allow firing
		bAllowFiring = (IsCoverActionLeaning(CoverActionAnim) && IsCoverActionPopUp(LastCoverActionAnim))
			|| (IsCoverActionPopUp(CoverActionAnim) && IsCoverActionLeaning(LastCoverActionAnim)
			|| (bWasDoing360Aiming && (IsCoverActionLeaning(CoverActionAnim) ||  IsCoverActionPopUp(CoverActionAnim)))
			|| (bDoing360Aiming && (IsCoverActionLeaning(LastCoverActionAnim) || IsCoverActionPopUp(LastCoverActionAnim)))
			);

		return !bAllowFiring;
	}
	else
	{
		return FALSE;
	}
}

simulated final function bool IsCoverActionLeaning(ECoverAction InAction)
{
	return (InAction == CA_LeanLeft || InAction == CA_LeanRight);
}

simulated final function bool IsCoverActionPopUp(ECoverAction InAction)
{
	return (InAction == CA_PopUp);
}

/** Updates the number of available fire tickets */
final function SetNumberOfFireTickets( int inNum )
{
	NumFireTickets = inNum;
	FireTickets.Length = Max(0,NumFireTickets);
}

/** Ask for a fire ticket for the target */
final function bool ClaimFireTicket( Controller inClaimer, optional bool bClaimAll, optional bool bTest )
{
	local int Idx, Num;
	local bool bResult;

	if(NumFireTickets < 0)
	{
		return TRUE;
	}

	// If not claiming all
	if( !bClaimAll )
	{
		// Check to see if we already have a ticket
		Idx = FireTickets.Find( inClaimer );
		if( Idx >= 0 )
		{
			return TRUE;
		}
	}

	Num = FireTickets.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		if( bClaimAll ||
			FireTickets[Idx] == None || FireTickets[Idx].bDeleteMe || FireTickets[Idx].IsInState('Dead') )
		{
			if( !bTest )
			{
				FireTickets[Idx] = inClaimer;
			}

			bResult = TRUE;

			if( !bClaimAll )
			{
				break;
			}
		}
	}

	return bResult;
}

/** Release all of ticket claims for given controller */
final function bool ReleaseFireTicket( Controller inReleaser )
{
	local int Idx, Num;
	local bool bResult;

	Num = FireTickets.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		if( FireTickets[Idx] == inReleaser )
		{
			FireTickets[Idx] = None;
			bResult = TRUE;
		}
	}

	return bResult;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);

	if (PlayerController(C) == None && GearAI_TDM(C) == None)
	{
		//`log(self@C@GetFuncName()@CharacterName);
		// if singleplayer or an AI in multiplayer use the character name
		// don't clear the name if getting into a silverback
		if(PlayerReplicationInfo != none && (!bVehicleTransition || CharacterName != ""))
		{
			PlayerReplicationInfo.SetPlayerName(CharacterName);
		}
	}

	SetLightEnvironmentSettings();

	NotifyTeamChanged();

	MyGearAI = GearAI(Controller);

	// Turn off air control for AI because it can mess up landing after quick ehole spawns, etc.
	if( !IsHumanControlled() )
	{
		AirControl = 0.f;
	}

	// notify weapon
	if (MyGearWeapon != None)
	{
		MyGearWeapon.NotifyPossessed();
	}
}


/** Helper function to set the DLE settings on the pawn (can be used to look at gametypes or other types of config settings) **/
simulated function SetLightEnvironmentSettings()
{
	// If we are playing horde then we want to turn off the SH light for all AI enemies
	if( ClassIsChildOf( WorldInfo.GetGameClass(), class'GearGameHorde_Base') == TRUE )
	{
		LightEnvironment.bSynthesizeSHLight = IsLocallyControlled();
	}
}


function UnPossessed()
{
	Super.Unpossessed();
	// reset our DPG
	SetDepthPriorityGroup(SDPG_World);
	// notify weapon
	if ( MyGearWeapon != None )
	{
		MyGearWeapon.NotifyUnpossessed();
	}
	// clear ai ref
	MyGearAI = None;
}

function DetachFromController(optional bool bDestroyController)
{
	Super.DetachFromController(bDestroyController);

	MyGearAI = None;
}


function bool BeginAttackRun( GearPawn NewVictim );


/**
* Returns FALSE if Actor can play. For pawn, if he's speaking, no it can't play
* Implement in sub-class.
*/
simulated function bool CanActorPlayFaceFXAnim()
{
	// if pawn is speaking, then no actor can't play facefx
	return (!bSpeaking);
}

/**
 * Called via delegate when FacialAudioComp is finished.
 */
simulated function FaceFXAudioFinished(AudioComponent AC)
{
	if ( (AC == FacialAudioComp) && (CurrentlySpeakingLine == FacialAudioComp) )
	{
		CurrentlySpeakingLine = None;
	}
}

/** modifies GroundSpeed by the passed in percentage - accessor needed so we can account for the root motion of some Pawn classes
 * @note: not replicated
 */
function SetGroundSpeedModifier(float NewModifier)
{
	GroundSpeed = DefaultGroundSpeed * NewModifier;
}

/** Updates State when traversing BarbedWire.
 *  Called on Server
 */
final function SetBarbedWireTraversal(bool bTraversing)
{
	if( bTraversingBarbedWire != bTraversing )
	{
		bTraversingBarbedWire = bTraversing;
		bForceNetUpdate = TRUE;
		TraversingBarbedWireUpdated();
	}
}

/** Notification when bTraversingBarbedWire flag is updated.
 *  Called on all net modes */
simulated function TraversingBarbedWireUpdated();

/** Kismet action to forcefully drop a heavy weapon if this pawn has one */
function OnForceDropHeavyWeapon( SeqAct_ForceDropHeavyWeapon Action )
{
	if( GearWeap_HeavyBase(MyGearWeapon) != none )
	{
		ThrowActiveWeapon( Action.bDestroyWeapon );
	}
}

/**
 * Overridden to prevent weapon drops if flagged (for AI, etc).
 */
function ThrowActiveWeapon( optional bool bDestroyWeap )
{
	if (Health <= 0 || (MyGearWeapon != None && MyGearWeapon.bCanThrowActiveWeapon))
	{
		// Cancel any weapon specific special moves
		if( IsMountingHeavyWeapon() )
		{
			ServerEndSpecialMove();
		}

		if( bDestroyWeap )
		{
			Weapon.Destroy();
		}
		else
		{
			Super.ThrowActiveWeapon();
		}
	}

	// If we end up without a weapon, make sure we switch to one.
	if( Weapon == None && InvManager.PendingWeapon == None && Health > 0 )
	{
		GearInventoryManager(InvManager).AutoSwitchWeapon();
	}
}

function TossInventory(Inventory Inv, optional vector ForceVelocity)
{
	local rotator ViewRot;
	local vector TossVel;
	local GearInventoryManager GIM;

	GIM = GearInventoryManager(InvManager);
	if ( IsZero(ForceVelocity) && (GIM != None) )
	{
		// for gears, we'll standardize the toss velocities unless overridden
		// rather than letting Pawn do it for us
		ViewRot = GetViewRotation();
		ViewRot.Pitch = GIM.InventoryTossPitch;
		TossVel = (vector(ViewRot) * GIM.InventoryTossSpeed) + Velocity;
	}
	else
	{
		TossVel = ForceVelocity;
	}

	Super.TossInventory(Inv, TossVel);
}

function ThrowWeaponOnDeath()
{
	// throwing stuff on death is delayed for CSHD purposes
	// however, we need to make our current weapon owned by the Controller so that the relevant RPCs will be accepted
	if (MyGearWeapon != None)
	{
		MyGearWeapon.SetOwner(Controller);
	}
}

/** called to toss weapon and discard inventory after a short delay so CSHD has a chance to trigger a final shot
 * if the client hit the button in time
 */
function DelayedDeathDiscardInventory()
{
	if( InvManager != None )
	{
		ThrowActiveWeapon();
		GearGame(WorldInfo.Game).DelayedDiscardInventory(self);
		InvManager.Destroy();
		InvManager = None;
	}
}

/**
 * Trade weapons with a teammate
 *
 * @param GP - The teammate that we're trading weapons with
 */
reliable server function ServerTradeWeapon(GearPawn GP)
{
	local GearWeapon OldLocalWeapon, OldRemoteWeapon;
	local GearWeapon NewLocalWeapon, NewRemoteWeapon;
	local int AmmoAdded;
	local GearWeapon WeaponToAddAmmo;
	local CoolSkin OldLocalWeaponSkin, OldRemoteWeaponSkin;
	local bool bHasOldLocalWeaponSkin, bHasOldRemoteWeaponSkin;

	// Only the server should call this function.
	if (Role != ROLE_Authority)
		return;

	// Cache off the old weapons in case their original references get trashed
	OldLocalWeapon = MyGearWeapon;
	OldRemoteWeapon = GP.WeaponForWeaponSwap;

	WeaponToAddAmmo = GearWeapon(InvManager.FindInventoryType(OldRemoteWeapon.Class));

	// just stealing ammo from remote weapons and destroying it
	if (WeaponToAddAmmo != None)
	{
		AmmoAdded = WeaponToAddAmmo.AddAmmo(OldRemoteWeapon.SpareAmmoCount + OldRemoteWeapon.WeaponMagSize - OldRemoteWeapon.AmmoUsedCount);

		WeaponToAddAmmo.AddAmmoMessage(Max(AmmoAdded, 0));

		//`log("Server is removing weapons from "@GP);
		GP.InvManager.RemoveFromInventory(OldRemoteWeapon);
		OldRemoteWeapon.Destroy();
	}
	else
	{
		// Preserve weapon skins
		if (GetWeaponSkinParametersForClass(OldLocalWeapon.Class, OldLocalWeaponSkin) && OldLocalWeaponSkin.WeaponSkinIndex != 255)
		{
			bHasOldLocalWeaponSkin = TRUE;
		}
		if (GetWeaponSkinParametersForClass(OldRemoteWeapon.Class, OldRemoteWeaponSkin) && OldRemoteWeaponSkin.WeaponSkinIndex != 255)
		{
			bHasOldRemoteWeaponSkin = TRUE;
		}

		ClearWeaponSkinParametersForClass(OldLocalWeapon.Class);
		GP.ClearWeaponSkinParametersForClass(OldRemoteWeapon.Class);

		if (bHasOldRemoteWeaponSkin)
		{
			SetWeaponSkinFromPickup(OldRemoteWeaponSkin);
		}
		if (bHasOldLocalWeaponSkin)
		{
			GP.SetWeaponSkinFromPickup(OldLocalWeaponSkin);
		}

		// Alert the inventory managers to dump the old weapons
		//`log("Server is removing weapons from "@self);
		InvManager.RemoveFromInventory(OldLocalWeapon);
		//`log("Adding new weapon to "@self);

		if (OldRemoteWeapon != None)
		{
			// Create a new copy of the weapon that's properly married to the local inventory manager
			NewLocalWeapon = GearWeapon(InvManager.CreateInventory(OldRemoteWeapon.Class));
			AmmoAdded = NewLocalWeapon.CopyAmmoAmountFromWeapon(OldRemoteWeapon);
			OldRemoteWeapon.Destroy();
			InvManager.SetCurrentWeapon(NewLocalWeapon);
			NewLocalWeapon.AddAmmoMessage(Max(AmmoAdded, 0));
			//GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpNewWeapon, Self, None);
			//`log("New weapon is added to "@self);
		}

		//`log("Server is removing weapons from "@GP);
		GP.InvManager.RemoveFromInventory(OldRemoteWeapon);

		if (OldLocalWeapon != None)
		{
			//`log("Adding new weapon to "@GP);
			// Create a new copy of the weapon that's properly married to the remote inventory manager
			NewRemoteWeapon = GearWeapon(GP.InvManager.CreateInventory(OldLocalWeapon.Class));
			AmmoAdded = NewRemoteWeapon.CopyAmmoAmountFromWeapon(OldLocalWeapon);
			OldLocalWeapon.Destroy();
			GP.InvManager.SetCurrentWeapon(NewRemoteWeapon);
			NewRemoteWeapon.AddAmmoMessage(Max(AmmoAdded, 0));
			//GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpNewWeapon, GP, None);
			//`log("New weapon is added to "@GP);
		}
	}

	`RecordPlayerPlayerEvent(TRADEWEAPONS, Controller, GP.Controller);
}

/** 	Weapon Trade anim notifier - This is duration notifier tha comes in
 	This forward event to GSM_TradeWeapons_Leader GSM **/

// Follower Weapon starts moving
simulated function FollowerWeaponStart()
{
	if ( IsDoingSpecialMove(SM_TradeWeapons_Leader) )
	{
		GSM_TradeWeapons_Leader(SpecialMoves[SM_TradeWeapons_Leader]).FollowerWeaponStart();
	}
}

// Follower Weapon moving on air
simulated function FollowerWeaponLoop(FLOAT CurrentTime, FLOAT TotalDuration)
{
	if ( IsDoingSpecialMove(SM_TradeWeapons_Leader) )
	{
		GSM_TradeWeapons_Leader(SpecialMoves[SM_TradeWeapons_Leader]).FollowerWeaponLoop(CurrentTime, TotalDuration);
	}
}

// Follower Weapon finishes moving
simulated function FollowerWeaponEnd()
{
	if ( IsDoingSpecialMove(SM_TradeWeapons_Leader) )
	{
		GSM_TradeWeapons_Leader(SpecialMoves[SM_TradeWeapons_Leader]).FollowerWeaponEnd();
	}
}

// Leader weapon starts moving
simulated function LeaderWeaponStart()
{
	if ( IsDoingSpecialMove(SM_TradeWeapons_Leader) )
	{
		GSM_TradeWeapons_Leader(SpecialMoves[SM_TradeWeapons_Leader]).LeaderWeaponStart();
	}
}

// Leader Weapon moving on air
simulated function LeaderWeaponLoop(FLOAT CurrentTime, FLOAT TotalDuration)
{
	if ( IsDoingSpecialMove(SM_TradeWeapons_Leader) )
	{
		GSM_TradeWeapons_Leader(SpecialMoves[SM_TradeWeapons_Leader]).LeaderWeaponLoop(CurrentTime, TotalDuration);
	}
}

// Leader Weapon finishes moving
simulated function LeaderWeaponEnd()
{
	if ( IsDoingSpecialMove(SM_TradeWeapons_Leader) )
	{
		GSM_TradeWeapons_Leader(SpecialMoves[SM_TradeWeapons_Leader]).LeaderWeaponEnd();
	}
}

/**
 * Give half of our current weapon's ammo to a teammate.
 *
 * @param GP - The teammate that we're giving ammo to.
 */
function ShareAmmo(GearPawn GP)
{
	local Controller ControllerToTest;
	local GearWeapon RemoteWeap;
	local SoundCue AmmoPickupSound;
	local int AmmoCountDelta;
	local bool bSharedAmmo;

	// Only the server should call this function.
	if (Role != ROLE_Authority)
		return;

	ControllerToTest = GP.Controller;
	if (ControllerToTest == None && GP.DrivenVehicle != None)
	{
		ControllerToTest = GP.DrivenVehicle.Controller;
	}

	if (!GP.IsHumanControlled(ControllerToTest))
		return;

	// Heavy weapons are not allowed to share ammo.
	if (MyGearWeapon.WeaponType != WT_Heavy)
	{
		foreach GP.InvManager.InventoryActors(class'GearWeapon', RemoteWeap)
		{
			if (MyGearWeapon.Class == RemoteWeap.Class)
			{
				AmmoCountDelta = MyGearWeapon.WeaponMagSize;

				if (MyGearWeapon.SpareAmmoCount >= AmmoCountDelta && RemoteWeap.SpareAmmoCount + AmmoCountDelta <= RemoteWeap.WeaponMaxSpareAmmo)
				{
					// We're giving out ammo, but not all our ammo.
					if (GearInventoryManager(GP.InvManager).AddAmmoFromWeaponClass(MyGearWeapon.Class, AmmoCountDelta, TRUE))
					{
						GearInventoryManager(InvManager).RemoveAmmoFromWeaponClass(MyGearWeapon.Class, AmmoCountDelta, TRUE);
						bSharedAmmo = TRUE;
						if (AmmoPickupSound == None)
						{
							AmmoPickupSound = MyGearWeapon.Class.default.AmmoTypeClass.default.AmmoPickupSound;
						}

						`RecordPlayerPlayerEvent(GIVEAMMO, Controller, ControllerToTest);
					}
				}
			}
		}
	}

	if (bSharedAmmo)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GiveAmmo, Self);
	}
	else
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GiveAmmoRefused, GP);
	}

	if (AmmoPickupSound != None)
	{
		PlaySound(AmmoPickupSound);
	}
}

/**
 * Verify the player is in a good state and has a person to recieve money
 *
 * @return TRUE if we can share money
 */
simulated function bool CanGiveMoney()
{
	local GearPawn GP;
	local PlayerReplicationInfo PRI;

	if (IsInCover() || IsDBNO() || IsFiring())
	{
		return FALSE;
	}

	if (!ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base') || PlayerReplicationInfo.Score < MoneyTransferAmount)
	{
		return FALSE;
	}

	if (GearPC(Controller) != None)
	{
		GP = GearPC(Controller).TargetedPawn;
	}

	if (GP != None && VSize(GP.Location - Location) < CoopInteractionDistance)
	{
		PRI = GearPRI(GP.PlayerReplicationInfo);

		if (PRI == None && GP.DrivenVehicle != None)
		{
			PRI = GearPRI(GP.DrivenVehicle.PlayerReplicationInfo);
		}

		if (!GP.bCanBeBaseForPawns && PRI != none && !PRI.bBot && IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath)
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Share money over to GP
 *
 * @param GP - the player to give money to
 */
reliable server function ServerGiveMoney(GearPawn GP)
{
	local PlayerReplicationInfo PRI;

	if (GP != None && PlayerReplicationInfo.Score >= MoneyTransferAmount)
	{
		PRI = GearPRI(GP.PlayerReplicationInfo);
		if (PRI == None && GP.DrivenVehicle != None)
		{
			PRI = GearPRI(GP.DrivenVehicle.PlayerReplicationInfo);
		}

		if (PRI != None)
		{
			PlayerReplicationInfo.Score -= MoneyTransferAmount;
			PRI.Score += MoneyTransferAmount;

			PlayerReplicationInfo.bForceNetUpdate = true;
			PRI.bForceNetUpdate = true;

			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GiveMoney, self);

			if ( GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications &&
				(IsLocallyControlled() || GP.IsLocallyControlled()) )
			{
				GearGRI_Horde(WorldInfo.GRI).UpdateFortificationGhostImages();
			}

			`RecordPlayerPlayerEvent(GIVEMONEY, Controller, GP.Controller);
		}
	}
}

//@HACK: workaround for client seeing server not attached to the Reaver correctly
simulated final function ReaverAttachmentHack()
{
	if ( Vehicle_RideReaver_Base(DrivenVehicle) != None ||
		(GearWeaponPawn(DrivenVehicle) != None && Vehicle_RideReaver_Base(DrivenVehicle.GetVehicleBase()) != None) )
	{
		DrivenVehicle.AttachDriver(self);
	}
}

/**
 * StartDriving() and StopDriving() also called on clients
 * on transitions of DrivenVehicle variable.
 * Network: ALL
 */
simulated event StartDriving(Vehicle V)
{
	local bool bShouldManTurret;
	local GearWeaponPawn WeapPawn;
	local GearAI AI;

	if (bWantsToMelee)
	{
		StopMeleeAttack();
	}

	Super.StartDriving(V);

	AI = GearAI(Controller);
	if( AI != None )
	{
		AI.NotifyStartDriving(V);
	}

	ClearTimer(nameof(TryHolsterAgain));
	bShouldManTurret = V.IsA('Turret_Troikabase');
	WeapPawn = GearWeaponPawn(V);
	if (WeapPawn != None)
	{
		//Check on name since clients won't have the actual weapon
		bShouldManTurret = bShouldManTurret || (WeapPawn.MyVehicle.Seats[WeapPawn.MySeatIndex].GunClass.name == 'GearVWeap_KingRavenTurret');
	}

	if (bShouldManTurret)
	{
		bIsOnTurret = TRUE;
		// Holster Weapon first if we have one
		if( MyGearWeapon != None )
		{
			MyGearWeapon.HolsterWeaponTemporarily(TRUE);
		}
		else
		{
			StartManningTurret();
		}
	}

	//@HACK: workaround for client seeing server not attached to the Reaver correctly
	if ( WorldInfo.NetMode == NM_Client && V.bAttachDriver &&
		( Vehicle_RideReaver_Base(DrivenVehicle) != None ||
			(GearWeaponPawn(DrivenVehicle) != None && Vehicle_RideReaver_Base(DrivenVehicle.GetVehicleBase()) != None) ) )
	{
		SetTimer(1.0, false, nameof(ReaverAttachmentHack));
	}
}

/** event called when Pawn is ready to man turret */
final simulated function StartManningTurret()
{
	bIsOnTurret = TRUE;

	// Start troika manning animations
	TroikaBlendNode.SetActiveChild(0, 0.2f);

	// Disable turn in place node
	bCanDoTurnInPlaceAnim = FALSE;

	// Hook up IK, to hands are attached to handles on troika
	if (Base != None && Base.IsA('Pawn'))
	{
		IKCtrl_RightHand.EffectorLocationSpace = BCS_BaseMeshSpace;
		IKCtrl_LeftHand.EffectorLocationSpace = BCS_BaseMeshSpace;
	}
	else
	{
		IKCtrl_RightHand.EffectorLocationSpace = BCS_WorldSpace;
		IKCtrl_LeftHand.EffectorLocationSpace = BCS_WorldSpace;
	}

	IKCtrl_RightHand.SetSkelControlActive(TRUE);
	IKCtrl_LeftHand.SetSkelControlActive(TRUE);

	IKRotCtrl_RightHand.SetSkelControlActive(TRUE);
	IKRotCtrl_LeftHand.SetSkelControlActive(TRUE);
	IKRotCtrl_RightHand.bApplyRotation = TRUE;
	IKRotCtrl_LeftHand.bApplyRotation = TRUE;
	IKRotCtrl_RightHand.BoneRotationSpace = BCS_WorldSpace;
	IKRotCtrl_LeftHand.BoneRotationSpace = BCS_WorldSpace;

	// There's some situations like multiturret reload where these skel controls need to be disabled immediately
	if (GearTurret(DrivenVehicle) != None)
	{
		GearTurret(DrivenVehicle).TurretManned(Self);
	}
}

final simulated function StopManningTurret()
{
	// Enable turn in place node
	bCanDoTurnInPlaceAnim = default.bCanDoTurnInPlaceAnim;

	// Stop troika manning animations
	if (TroikaBlendNode != None)
	{
		TroikaBlendNode.SetActiveChild(1, 0.2f);
	}

	// Disable hand IKs
	if (IKCtrl_RightHand != None)
	{
		IKCtrl_RightHand.SetSkelControlActive(FALSE);
	}
	if (IKCtrl_LeftHand != None)
	{
		IKCtrl_LeftHand.SetSkelControlActive(FALSE);
	}
	if (IKRotCtrl_RightHand != None)
	{
		IKRotCtrl_RightHand.SetSkelControlActive(FALSE);
	}
	if (IKRotCtrl_LeftHand != None)
	{
		IKRotCtrl_LeftHand.SetSkelControlActive(FALSE);
	}

	bIsOnTurret = FALSE;
}

reliable client function ForceClientStopDriving(Vehicle V)
{
	StopDriving(V);
}

/**
 * StartDriving() and StopDriving() also called on clients
 * on transitions of DrivenVehicle variable.
 * Network: ALL
 */
simulated event StopDriving(Vehicle V)
{
	local GearAI AI;

	Super.StopDriving(V);

	AI = GearAI(Controller);
	if (AI != None)
	{
		AI.NotifyStopDriving(V);
	}

	if (Mesh != None)
	{
		if (Mesh.AnimTreeTemplate != default.Mesh.AnimTreeTemplate)
		{
			Mesh.SetAnimTreeTemplate(default.Mesh.AnimTreeTemplate);
		}
		Mesh.SetTranslation(default.Mesh.Translation);

		KismetAnimSets[0] = None;
		KismetAnimSets[1] = None;
		UpdateAnimSetList();
	}

	if (bIsOnTurret)
	{
		StopManningTurret();

		// Unholster weapon
		if (MyGearWeapon != None)
		{
		   MyGearWeapon.HolsterWeaponTemporarily(FALSE);
		}
		else
		{
	    //@FIXEME - We aren't unpossessed from vehicle yet?
			SetTimer(0.1, false, nameof(TryHolsterAgain));
		}


		if ( V != None && (Role == ROLE_Authority) && (InterpActor_GearBasePlatform(V.Base) != None) )
		{
			// the super put us into falling with no base, but we don't want that on moving platforms or we can shoot backwards
			SetBase(V.Base);
			SetPhysics(WalkingPhysics);
		}

		// make sure collision got restored
		SetCollisionSize(default.CylinderComponent.CollisionRadius, default.CylinderComponent.CollisionHeight);
	}
	else if (GearWeaponPawn(V) != None)
	{
		// Unholster weapon
		if (MyGearWeapon != None)
		{
			MyGearWeapon.HolsterWeaponTemporarily(FALSE);
		}
		else
		{
			//@FIXEME - We aren't unpossessed from vehicle yet?
			SetTimer(0.1, false, nameof(TryHolsterAgain));
		}
	}
	else if (Role < ROLE_Authority && RemoteWeaponRepInfo.WeaponClass != None)
	{
		RefreshRemoteAttachments();
	}
	else if (MyGearWeapon != None)
	{
		AttachWeapon();
	}
}

/** Pawn types that ride a Reaver can implement this function */
simulated function ReaverDismount();

//@FIXME - JM - not sure if/why I need this yet
simulated function TryHolsterAgain()
{
	MyGearWeapon.HolsterWeaponTemporarily(FALSE);
}


/**
 * Used to draw info over pawns in MP.
 * Things we care about:
 *
 * -if in "cover" or not (for the viewing pawn)
 * -HP numbers
 * -ActiveReload active
 *
 **/
simulated function DrawDebug_MP( GearHUD_Base HUD, Pawn P )
{
	local Texture2D InCoverIcon;
	local float		PercentDamageReduction;

	if( IsProtectedByCover( Location - P.Location ) == TRUE )
	{
		InCoverIcon = Texture2D'AI-Icons.AICON-H';	// cool sunglasses for being cool in cover
	}
	else
	{
		InCoverIcon = Texture2D'EditorResources.S_NavP'; // standy guy as you are running around like a maniac
	}

	PercentDamageReduction = MultiplayerCoverDamageAdjust( (Location - P.Location), P, Location, 100 );

	DrawIconOverhead( HUD, InCoverIcon, PercentDamageReduction );
}


simulated function DrawIconOverhead( GearHUD_Base HUD, Texture2D Icon, float PercentDamageReduction )
{
	local GearPC		PC;
	local Canvas	Canvas;
	local Vector	CameraLoc, ScreenLoc;
	local Rotator	CameraRot;
	local String	Str;
	local float		X, Y, HealthPct;

	if (Icon == None)
	{
		return;
	}

	PC = GearPC(HUD.PlayerOwner);
	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255);

	// project location onto the hud
	PC.GetPlayerViewPoint( CameraLoc, CameraRot );
	ScreenLoc = Canvas.Project( Location + vect(0,0,1) * GetCollisionHeight() * 1.5f );
	Canvas.SetPos( ScreenLoc.X - Icon.SizeX/2, ScreenLoc.Y - Icon.SizeY/2 );
	Canvas.DrawTexture( Icon, 1.f );

	Canvas.SetDrawColor(255,255,255);

	X = ScreenLoc.X + Icon.SizeX/2 + 5;
	Y = ScreenLoc.Y - Icon.SizeY/2;
	Canvas.SetPos( X, Y );

	Str = "H:" $ Health $ " AR: " $ bActiveReloadBonusActive $ " %DamGiven: " $ PercentDamageReduction;
	Canvas.DrawText( Str, TRUE );

	Canvas.SetDrawColor(255,255,255);

	Canvas.SetDrawColor(0,255,0);
	HealthPct = (Health/float(DefaultHealth));
	Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * HealthPct,4,0,0,2,2);
	Canvas.SetDrawColor(255,0,0);
	//Canvas.SetPos(Canvas.CurX + HealthPct * 64.f,Canvas.CurY);
	Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * (1.f - HealthPct),4,0,0,2,2);

	Canvas.SetDrawColor(255,255,255);
}


/**
 * Determines whether or not the pawn can be curbstomped.
 * This is also used for execution validity
 */
function simulated bool CanBeCurbStomped()
{
	return FALSE;
}

/**
 * We do not want to be encroached.
 * @todo:  make this check for GearPawns but let vehicles encroach us?
 **/
event EncroachedBy( actor Other )
{
}

event bool EncroachingOn(Actor Other)
{
	if ( !bScriptInitialized )
	{
		`log( "EncroachedOn self: " $ self $ " other: " $ Other $" at "$Other.Location );
		return false;
	}
	return Super.EncroachingOn(Other);
}


function SetMovementPhysics()
{
	// No movement physics if on a vehicle
	if ( DrivenVehicle != None || Pawn(Base) != None ||
		(InterpActor_GearBasePlatform(Base) != None && InterpActor_GearBasePlatform(Base).bDisallowPawnMovement) )
	{
		SetPhysics( PHYS_None );
	}
	else
	{
		super.SetMovementPhysics();
	}
}

/** This will start the RoadieRun Particle Effect **/
final simulated function StartRoadieRunPSC()
{
	local ParticleSystem RoadieRunSystem;

	if ( !EffectIsRelevant(Location, false, 2000) )
	{
		return;
	}

	RoadieRunSystem = class'GearPhysicalMaterialProperty'.static.DetermineRoadieRunParticleEffect(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( LastFootStepTraceInfo ));
	if( RoadieRunSystem != none )
	{
		if (PSC_RoadieRun != None)
		{
			PSC_RoadieRun.DeActivateSystem();
			PSC_RoadieRun.SetTemplate(RoadieRunSystem);
		}
		else
		{
			PSC_RoadieRun = new(self) class'ParticleSystemComponent';
			PSC_RoadieRun.SetTemplate(RoadieRunSystem);
			PSC_RoadieRun.bAutoActivate = FALSE;
			Mesh.AttachComponent( PSC_RoadieRun, RightFootBoneName, vect(0,0,0),,);
		}

		PSC_RoadieRun.SetHidden( FALSE );
		PSC_RoadieRun.ActivateSystem();
	}

	ClearTimer( 'HideRoadieRunPSC' );

	LastFootStepPhysMat = LastFootStepTraceInfo.PhysMaterial;
	//`log( PSC_RoadieRun @ LastFootStepPhysMat @ LastFootStepTraceInfo.PhysMaterial );
}

final simulated function HideRoadieRunPSC()
{
	Mesh.DetachComponent(PSC_RoadieRun);
	PSC_RoadieRun = None;
}

simulated function PlayBoltEject()
{
	local GearWeap_SniperRifle snipe;
	snipe = GearWeap_SniperRifle(Weapon);
	if(snipe != none)
		snipe.PlayBoltEject();
}

simulated function PistolEjectClip()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.ejectclip();
}

simulated function PistolCockOpen()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.cockopen();
}
simulated function PistolCockClose()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.cockclose();
}
simulated function PistolClipImpact()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.clipimpact();
}
simulated function PistolInsertClip()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.insertclip();
}

simulated function PistolJammed()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.jammed();
}

simulated function PistolHandSlam()
{
	local GearWeap_PistolBase pistol;
	pistol = GearWeap_PistolBase(Weapon);
	if(pistol != none)
		pistol.handslam();
}



/**
 * Notification that root motion mode changed.
 * Called only from SkelMeshComponents that have bRootMotionModeChangeNotify set.
 * This is useful for synchronizing movements.
 * For intance, when using RMM_Translate, and the event is called, we know that root motion will kick in on next frame.
 * It is possible to kill in-game physics, and then use root motion seemlessly.
 */
simulated event RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
	// Forward to current special move
	if( SpecialMove != SM_None && SpecialMoves[SpecialMove] != None )
	{
		SpecialMoves[SpecialMove].RootMotionModeChanged(SkelComp);
	}
}

/**
 * Notification called after root motion has been extracted, and before it's been used.
 * This notification can be used to alter extracted root motion before it is forwarded to physics.
 * It is only called when bRootMotionExtractedNotify is TRUE on the SkeletalMeshComponent.
 * @note: It is fairly slow in Script, so enable only when really needed.
 */
simulated event RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	// Forward to current special move
	if( SpecialMove != SM_None && SpecialMoves[SpecialMove] != None )
	{
		SpecialMoves[SpecialMove].RootMotionExtracted(SkelComp, ExtractedRootMotionDelta);
	}
}

/**
 * Returns camera "no render" cylinder.
 * @param bViewTarget TRUE to return the cylinder for use when this pawn is the camera target, false to return the non-viewtarget dimensions
 */
final simulated native function GetCameraNoRenderCylinder(out float Radius, out float Height, bool bViewTarget, bool bHiddenLocally);

simulated function EnableGibImpactSounds()
{
	bDelayGibImpactSounds = FALSE;
}

//@ todo this needs to be moved to be based off the skel mesh maybe?
simulated event PlayGibEffect(vector HitLoc, vector HitNorm, float SquaredForce)
{
	// make it so we don't spawn more than 2 decals per time period (aka when you kick a body)
	// around all of its pieces are moving along the ground and spamming out blood
	if( (++EffectCount > 2) || !EffectIsRelevant(Location, false, 2000))
	{
		return;
	}

	if (!bDelayGibImpactSounds)
	{
		if(SquaredForce < 17500.0f)
			PlaySound(SoundCue'Foley_Flesh.Flesh.GibBodyChunkSmallCue',false,false,false,HitLoc);
		else if(SquaredForce < 20000.0f)
			PlaySound(SoundCue'Foley_Flesh.Flesh.GibBodyChunkMediumCue',false,false,false,HitLoc);
		else if(SquaredForce < 40000.0f)
			PlaySound(SoundCue'Foley_Flesh.Flesh.PhysicsFleshThumpCue',false,false,false,HitLoc);
		else if(SquaredForce < 70000.0f)
			PlaySound(SoundCue'Foley_Flesh.Flesh.GibBodyChunkLargeCue',false,false,false,HitLoc);
		else if(SquaredForce < 130000.0f)
			PlaySound(SoundCue'Foley_Flesh.Flesh.GibBodyChunkHugeCue',false,false,false,HitLoc);
		else // when kicking bodies around play this
			PlaySound(SoundCue'Foley_Flesh.Flesh.GibBodyChunkMediumCue',false,false,false,HitLoc);
	}

	if( WorldInfo.GRI.ShouldShowGore() && bSpawnBloodTrailDecals )
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(GoreImpactParticle, HitLoc, rotator(HitNorm));

		//`log( "blood " $ HitLoc @ SquaredForce @ EffectCount );
		GearPawnFX.SpawnABloodTrail_GibImpact( HitLoc );
	}

	if(!IsTimerActive('ResetEffects'))
	{
		SetTimer( 0.25, FALSE, nameof(ResetEffects) );
	}
}

final simulated function ResetEffects()
{
	EffectCount = 0;
}

simulated event bool InFreeCam()
{
	local PlayerController	PC;

	PC = PlayerController(Controller);
	return (PC != None && PC.PlayerCamera != None && (PC.PlayerCamera.CameraStyle == 'FreeCam' || PC.PlayerCamera.CameraStyle == 'FaceCam') );
}

event Landed(vector HitNormal, Actor FloorActor)
{
	local GearSpawner_EmergenceHoleBase EHole;
	EHole = GearSpawner_EmergenceHoleBase(FloorActor);
	if (EHole != None &&
		Location.Z < EHole.Location.Z)
	{
		TakeDamage(99999,None,Location,vect(0,0,0),class'GDT_ScriptedRagdoll',,EHole);
	}
	Super.Landed(HitNormal,FloorActor);
}


/**
 * This will set the DurationBeforeDestroyingDueToNotBeingSeen to the value the Kismet action wants it.
 * This is useful for keeping certain bodies around longer than others fo
 **/
simulated function OnModifyDurationBeforeDestroyingDueToNotBeingSeen( SeqAct_ModifyDurationBeforeDestroyingDueToNotBeingSeen Action )
{
	DurationBeforeDestroyingDueToNotBeingSeen = Action.NewDurationBeforeDestroyingDueToNotBeingSeen;
}


simulated function GetAimFrictionExtent(out float Width, out float Height, out vector Center)
{
	if (!bCanBeFrictionedTo)
	{
		Width = 0.f;
		Height = 0.f;
	}
	else if ( bIsCrouched || ((CoverType == CT_MidLevel) && (CoverAction != CA_PopUp)) )
	{
		// smaller cylinder for crouched pawns
		Height = CrouchedFrictionCylinder.Height;
		Width = CrouchedFrictionCylinder.Radius;
	}
	else
	{
		super.GetAimFrictionExtent(Width, Height, Center);
	}

	Center = GetBaseTargetLocation();
}


simulated function GetAimAdhesionExtent(out float Width, out float Height, out vector Center)
{
	if (!bCanBeAdheredTo)
	{
		Width = 0.f;
		Height = 0.f;
	}
	else if ( bIsCrouched || ((CoverType == CT_MidLevel) && (CoverAction != CA_PopUp)) )
	{
		// smaller cylinder for crouched pawns
		Height = CrouchedFrictionCylinder.Height;
		Width = CrouchedFrictionCylinder.Radius;
	}
	else
	{
		super.GetAimAdhesionExtent(Width, Height, Center);
	}

	// reduce the size a bit to allow adhesion to move the crosshair onto the character
	Height *= 0.65f;
	Width *= 0.65f;

	Center = GetBaseTargetLocation();
}


final simulated event vector GetDeathCamLookatPos()
{
	local vector Lookat;

	if ( bOverrideDeathCamLookat && (DeathCamLookatPawn != None) )
	{
		if (DeathCamLookatBoneName != '')
		{
			Lookat = DeathCamLookatPawn.Mesh.GetBoneLocation(DeathCamLookatBoneName);
		}
		else
		{
			Lookat = DeathCamLookatPawn.Location;
		}
	}
	else if (bIsGore)
	{
		// look where you used to be, and mourn your lack of l33tness
		Lookat = LocationWhenKilled;
	}
	else if ( (KilledByPawn != None) && (KilledByPawn != self) )
	{
		// track your killer
		Lookat = KilledByPawn.GetPawnViewLocation();
		if (IsZero(Lookat))
		{
			Lookat = KilledByPawn.Location;
		}
	}
	else
	{
		// track head of your corpse
		Lookat = Mesh.GetBoneLocation(NeckBoneName);
		if (IsZero(Lookat))
		{
			Lookat = Location;
		}
	}

	return Lookat;
}

/** This is set when we want the mob to not use AdjustPawnDamage or ReduceDamage functions @see GearProj_Grenade.DoExplosion **/
//@fixme - renamed bDontModifyDamage, but need to rename function and fixup refs to avoid the confusion!
simulated function SetDontModifyDamage( bool NewValue )
{
	bAllowDamageModification = !NewValue;
}

/** Sets this pawn on fire. */
simulated exec function IgnitePawn(PawnOnFireState NewState, optional Controller FireInstigator, optional class<GearDamageType> DamageType, optional float Duration)
{
	local SoundCue FireSound;
	local ParticleSystemComponent OnFirePSC;
	local bool bStereo;

	if (InGodMode() || GearGame(WorldInfo.Game).IsRespawnInvincible(self))
	{
		// no ignition in god mode
		NewState = POF_None;
	}

`if(`notdefined(FINAL_RELEASE))
	// make sure unlimitedhealth pawns have a reasonable duration
	if ( (NewState == POF_Blazing || NewState == POF_BlazingInk) && bUnlimitedHealth )
	{
		Duration = 6.f;
	};
`endif

	if (OnFireState != NewState)
	{
		// extinguish old state
		if (OnFireState != POF_None)
		{
			ExtinguishPawn();
			ClearTimer(nameof(ExtinguishPawn));
		}

		if (NewState != POF_None)
		{
			OnFireDamageInstigator = FireInstigator;

			// pick effects
			switch (NewState)
			{
			case POF_Blazing:

			`if(`notdefined(FINAL_RELEASE))
				if (OnFireParticleSystemBoneNames.length == 0)
				{
					`warn(GetFuncName()@": Missing OnFireParticleSystemBoneNames, this pawn's class needs set up for burning."@self);
				}
			`endif

				OnFirePSC = new(Outer) class'ParticleSystemComponent';
				if (OnFirePSC != None)
				{
					OnFirePSC.SetTemplate(OnFireBlazingParticleSystem);
					OnFirePSC.SetActorParameter('BoneSocketActor', Self);
					AttachComponent(OnFirePSC);
					PSC_OnFire[PSC_OnFire.length] = OnFirePSC;
				}

				// local players get stereo audio sample
				if (IsLocallyControlled())
				{
					bStereo = true;
					FireSound = OnFireBlazingBurningSound_Player;
				}
				else
				{
					FireSound = OnFireBlazingBurningSound;
				}
				break;

			case POF_Burning:

			`if(`notdefined(FINAL_RELEASE))
				if (OnFireParticleSystemBoneNames.length == 0)
				{
					`warn(GetFuncName()@": Missing OnFireParticleSystemBoneNames, this pawn's class needs set up for burning."@self);
				}
			`endif

				OnFirePSC = new(Outer) class'ParticleSystemComponent';
				if (OnFirePSC != None)
				{
					OnFirePSC.SetTemplate(OnFireBurningParticleSystem);
					OnFirePSC.SetActorParameter('BoneSocketActor', Self);
					AttachComponent(OnFirePSC);
					PSC_OnFire[PSC_OnFire.length] = OnFirePSC;
				}
				FireSound = OnFireBurningSound;
				break;

			case POF_Smoldering:
				// smoky particle effect on the chest
				OnFirePSC = new(Outer) class'ParticleSystemComponent';
				if (OnFirePSC != None)
				{
					OnFirePSC.SetTemplate(OnFireSmolderParticleSystem);
					Mesh.AttachComponent(OnFirePSC, TorsoBoneName);
					PSC_OnFire[PSC_OnFire.length] = OnFirePSC;
				}
				FireSound = OnFireSmolderingBurningSound;
				break;

			case POF_BlazingInk:
				
				OnFirePSC = new(Outer) class'ParticleSystemComponent';
				if (OnFirePSC != None)
				{
					OnFirePSC.SetTemplate(OnFireBlazingInkParticleSystem);
					OnFirePSC.SetActorParameter('BoneSocketActor', Self);
					AttachComponent(OnFirePSC);
					PSC_OnFire[PSC_OnFire.length] = OnFirePSC;
				}

				// @todo arm bones too
				FireSound = OnFireBlazingInkBurningSound;
				break;

			default:
				`log("Unhandled OnFire state in"@GetFuncName());
			}

			// start audio loop
			OnFireAudioBurningLoop = CreateAudioComponent(FireSound, false, true);
			if (OnFireAudioBurningLoop != None)
			{
				OnFireAudioBurningLoop.bAutoDestroy = true;
				Mesh.AttachComponent(OnFireAudioBurningLoop, TorsoBoneName);
				OnFireAudioBurningLoop.bAllowSpatialization = !bStereo;
				OnFireAudioBurningLoop.FadeIn(0.6f, 1.f);
			}
		}

		OnFireState = NewState;
		OnFireDamageType = DamageType == None ? class'GDT_Fire' : DamageType;
		if (Role == ROLE_Authority)
		{
			ReplicatedOnFireState = OnFireState;
		}
	}

	if (Duration != 0.f)
	{
		SetTimer( Duration, false, nameof(ExtinguishPawn) );
	}
}

/** Called when pawn fire effect is done, so we can clean up. */
simulated function OnPawnFireEffectFinished(ParticleSystemComponent PSC)
{
	Mesh.DetachComponent(PSC);
}

/** Puts out the fire on this pawn. */
simulated exec function ExtinguishPawn()
{
	local ParticleSystemComponent PSC;
	if (OnFireState != POF_None)
	{
		// stop particle effect(s)
		foreach PSC_OnFire(PSC)
		{
			PSC.DeactivateSystem();
			PSC.OnSystemFinished = OnPawnFireEffectFinished;
		}
		PSC_OnFire.length = 0;

		// stop audio
		if (OnFireAudioBurningLoop != None)
		{
			OnFireAudioBurningLoop.FadeOut(1.f, 0.0f);
			OnFireAudioBurningLoop = None;
		}

		CurrentSkinHeatMin = 0.0f; // allow the pawn to fade his burny look to nothing
		SkinHeatFadeTime = default.SkinHeatFadeTime; // fade out nicely
		OnFireState = POF_None;
		OnFireDamageType = None;
		if (Role == ROLE_Authority)
		{
			ReplicatedOnFireState = OnFireState;
		}
	}
}

/** Sets this pawn to start imulsion effects */
simulated function StartImulsion( float Duration )
{
	if ( PSC_Imulsion == None )
	{
		// start particle effect
		PSC_Imulsion = new(Outer) class'ParticleSystemComponent';
		if ( PSC_Imulsion != None )
		{
			PSC_Imulsion.SetTemplate(ImulsionParticleSystem);
			PSC_Imulsion.SetAbsolute(, true);
			PSC_Imulsion.SetRotation(rot(0,0,0));
			Mesh.AttachComponent(PSC_Imulsion, TorsoBoneName);
		}

		// start audio loop
		ImulsionAudioBurningLoop = CreateAudioComponent(ImulsionBurningSound, false, true);
		if (ImulsionAudioBurningLoop != None)
		{
			ImulsionAudioBurningLoop.bAutoDestroy = true;
			Mesh.AttachComponent(ImulsionAudioBurningLoop, TorsoBoneName);
			ImulsionAudioBurningLoop.FadeIn(0.6f, 1.f);
		}
	}

	SetTimer( Duration, false, nameof(StopImulsion) );
}

/** Called when pawn imulsion effect is done, so we can clean up. */
simulated function OnPawnImulsionEffectFinished(ParticleSystemComponent PSC)
{
	Mesh.DetachComponent(PSC);
}

/** Stops the effects for taking imulsion damage */
simulated function StopImulsion()
{
	// stop particle effect
	if ( PSC_Imulsion != None )
	{
		PSC_Imulsion.DeactivateSystem();
		PSC_Imulsion.OnSystemFinished = OnPawnImulsionEffectFinished;
		PSC_Imulsion = None;
	}

	// stop audio
	if ( ImulsionAudioBurningLoop != None )
	{
		ImulsionAudioBurningLoop.FadeOut(1.f, 0.0f);
		ImulsionAudioBurningLoop = None;
	}
}

/************************************************************************************
 * Boomer Shield
 ***********************************************************************************/

/**
 * Return attachment info for Shield.
 *
 * @param OutBoneName - the bone that the shield should attach to
 *
 * @param OutRelativeRotation - the relative rotation the shield should be attached at
 *
 * @param OutRelativeLocation - the relative location the shield should be attached at
 *
 * @param OutScale - the scale the shield should be while attached
 */
simulated function GetShieldAttachBone(out Name OutBoneName, out Rotator OutRelativeRotation, out Vector OutRelativeLocation, out float OutScale)
{
	local SkeletalMeshSocket	ShieldSocket;

	ShieldSocket = Mesh.GetSocketByName('Shield');
	if( ShieldSocket != None )
	{
		OutBoneName = ShieldSocket.BoneName;
		OutRelativeRotation = ShieldSocket.RelativeRotation;
		OutRelativeLocation = ShieldSocket.RelativeLocation;
	}
	else
	{
		// Defaults for Marcus Skeleton
		OutBoneName = 'b_MF_ForeTwist2_L';
		OutRelativeRotation.Roll = -16384;
	}

	// Make shield smaller for non boomer guys.
	OutScale = 0.75f;
}

/** Equips the shield that is currently in the inventory. */
simulated function EquipShield(GearShield ShieldInv)
{
	local GearInventoryManager	GIM;
	local MeshComponent			ShieldMesh;
	local Name					AttachName;
	local Rotator				AttachRotation;
	local Vector				AttachLocation;
	local float                 ShieldScale;
	local GearPC				MyGearPC;

	if( ShieldInv != None )
	{
		ShieldMesh = ShieldInv.Mesh;

		// attach shield mesh to pawn's mesh
		GetShieldAttachBone(AttachName, AttachRotation, AttachLocation, ShieldScale);

		ShieldMesh.SetScale(ShieldScale);

		Mesh.AttachComponent(ShieldMesh, AttachName, AttachLocation, AttachRotation);
		ShieldMesh.SetShadowParent(Mesh);
		ShieldMesh.SetLightEnvironment(LightEnvironment);
		ShieldMesh.SetActorCollision(true, false);
		ShieldMesh.SetBlockRigidBody(true);

		// switch to a one-handed weapon, if necessary (e.g. pistol)
		if (MyGearWeapon == None || !MyGearWeapon.bCanEquipWithShield || InvManager.PendingWeapon != None)
		{
			GIM = GearInventoryManager(InvManager);
			GIM.SwitchToOneHandedWeapon();
		}

		EquippedShield = ShieldInv;

		// replicate to clients
		if (Role == ROLE_Authority)
		{
			AttachClass_Shield = ShieldInv.Class;
			bForceNetUpdate = TRUE;
		}

		// Call the delegates in the PC for equipping the shield
		MyGearPC = GearPC(Controller);
		if ( MyGearPC != None )
		{
			MyGearPC.TriggerGearEventDelegates( eGED_Shield );
		}

		ShieldInv.SetMaterialBasedOnTeam( ShieldMesh, GetMPWeaponColorBasedOnClass() );

	}
}

simulated reliable server function ServerDropShield()
{
	DropShield();
}


simulated function DropShield(optional bool bSkipToss, optional bool bDestroyShield)
{
	local MeshComponent ShieldMesh;

	// cancel the SM if it's current
	if ((Role == ROLE_Authority || IsLocallyControlled()) && (IsDoingSpecialMove(SM_DeployShield) || IsDoingSpecialMove(SM_PlantShield)))
	{
		EndSpecialMove();
	}

	if (EquippedShield != None)
	{
		// don't throw shield if not allowed to drop items
		if (!bAllowInventoryDrops)
		{
			bSkipToss = true;
		}

		if (bDestroyShield)
		{
			EquippedShield.PlayDestructionFX();
		}
		// detach shield mesh from pawn's mesh
		ShieldMesh = EquippedShield.Mesh;
		if (Mesh.IsComponentAttached(ShieldMesh))
		{
			Mesh.DetachComponent(ShieldMesh);
		}
		ShieldMesh.SetShadowParent(None);
		ShieldMesh.SetLightEnvironment(None);
		ShieldMesh.SetActorCollision(FALSE, FALSE);
		ShieldMesh.SetBlockRigidBody(FALSE);

		// throw it from the inventory if allowed
		if (!bSkipToss)
		{
			PlaySound(EquippedShield.ShieldDropSound, true);

			if (Role == ROLE_Authority)
			{
				TossInventory(EquippedShield);
			}
		}
		else if (Role == ROLE_Authority)
		{
			InvManager.RemoveFromInventory(EquippedShield);
			EquippedShield.Destroy();
		}

		// replicate to clients
		if (Role == ROLE_Authority)
		{
			AttachClass_Shield = None;
			bForceNetUpdate = true;
		}

		// and clear it off the pawn.
		EquippedShield = None;

		// force reset targeting mode so that we go back to the normal targeting anim
		SetTargetingMode(false);
		if (GearPC(Controller) != None)
		{
			GearPC(Controller).SetTargetingMode(false);
		}
	}
}

simulated final event bool IsCarryingShield()
{
	return (EquippedShield != None);
}

/** Return true if the cleaver is being carried */
simulated final function bool IsCarryingCleaver()
{
	return (EquippedCleaver != None);
}

simulated final event bool IsDeployingShield()
{
	return ( IsCarryingShield() && IsDoingSpecialMove(SM_DeployShield) );
}

/** Returns true if this pawn is protected by a shield for attacks from the given direction. */
final simulated function bool IsProtectedByShield(vector ShotDirectionNorm, optional bool bIgnoreMeatshields, optional vector ShotOrigin)
{
	local float DotAngle, ProtAngleDeg;
	DotAngle = (-ShotDirectionNorm) dot vector(Rotation);
	// if passed an origin then project back along the normal to catch origins near the player's feet
	if (!IsZero(ShotOrigin))
	{
		ShotDirectionNorm = Normal((Location + vector(Rotation) * 64.f) - ShotOrigin);
	}
	DotAngle = (-ShotDirectionNorm) dot vector(Rotation);
	if (IsCarryingShield())
	{
		ProtAngleDeg = IsDeployingShield() ? DeployedShieldHalfAngleOfProtection : ShieldHalfAngleOfProtection;
		return (DotAngle > Cos(ProtAngleDeg * DegToRad));
	}
	else if (!bIgnoreMeatShields && IsAKidnapper())
	{
		ProtAngleDeg = ShieldHalfAngleOfProtection;
		return (DotAngle > Cos(ProtAngleDeg * DegToRad));
	}
	return FALSE;
}


/**
 *  Impact Effects are handled in TakeDamage->DoDamageEffects. But only if there damage done.
 *  If there is no damage done, but you still want an impact effect to be played, return TRUE here.
 */
simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	return HitEquipment(Impact.HitInfo.HitComponent);
}

simulated function bool HitEquipment(PrimitiveComponent HitComponent)
{
	return  (HitComponent != Mesh) && (HitComponent != None)
				&& ( ComponentIsAnEquippedShield(HitComponent)
		  			|| ComponentIsAnEquippedCleaver(HitComponent)
		  			|| ComponentIsAnEquippedGasTank(HitComponent) );
}

/** Return true if the given component is a shield I have equipped, false otherwise. */
simulated final function bool ComponentIsAnEquippedShield(PrimitiveComponent Component)
{
	return ( (EquippedShield != None) && (EquippedShield.Mesh == Component) );
}

/** Return true if the given component is a cleaver I have equipped, false otherwise. */
simulated final function bool ComponentIsAnEquippedCleaver(PrimitiveComponent Component)
{
	return ( (EquippedCleaver != None) && (EquippedCleaver.Mesh == Component) );
}

/** Return true if the given component is a gas tank I have on me, false otherwise. */
simulated final function bool ComponentIsAnEquippedGasTank(PrimitiveComponent Component)
{
	return ( (EquippedGasTankComponent != None) && (EquippedGasTankComponent == Component) );
}

/** A pawn specific way of handling what component was hit on the pawn */
simulated function byte GetPawnSpecificComponentHitType(PrimitiveComponent Component)
{
	if (Component != None)
	{
		if (EquippedShield != None && EquippedShield.Mesh == Component)
		{
			return COMPONENT_HIT_Shield;
		}
		else if (EquippedCleaver != None && EquippedCleaver.Mesh == Component)
		{
			return COMPONENT_HIT_Cleaver;
		}
		else if (EquippedGasTankComponent == Component)
		{
			return COMPONENT_HIT_GasTank;
		}
	}

	return COMPONENT_HIT_NORMAL;
}

/** Handle pawn specific way of handling the component that was hit on the pawn */
function HandleServerSideComponentRemap(out ImpactInfo Impact, byte HitType)
{
	switch (HitType)
	{
		case COMPONENT_HIT_Shield:
			if (EquippedShield != None)
			{
				Impact.HitInfo.HitComponent = EquippedShield.Mesh;
			}
			return;
		case COMPONENT_HIT_Cleaver:
			if (EquippedCleaver != None)
			{
				Impact.HitInfo.HitComponent = EquippedCleaver.Mesh;
			}
			return;
		case COMPONENT_HIT_GasTank:
			Impact.HitInfo.HitComponent = EquippedGasTankComponent;
			return;
	}
}

/** Returns true if shield will be raised, false otherwise. */
function bool TryToRaiseShieldOverHead()
{
	if (CanDoSpecialMove(SM_RaiseShieldOverHead))
	{
		ServerDoSpecialMove(SM_RaiseShieldOverHead);
		return TRUE;
	}

	return FALSE;
}

/************************************************************************************
 * Grappling Hook
 ***********************************************************************************/

/**
 * Function to let us know that a Pawn can use the grappling hook or not.
 * Mainly if he has animations to make this work.
 */
simulated function bool CanUseGrapplingHook()
{
	return FALSE;
}

function OnAIGrapple(SeqAct_AIGrapple Action)
{
	// Kismet Sequence to use grappling hook. Pawn has to be able to support it to initiate it.
	if( Action.InputLinks[0].bHasImpulse )
	{
		// new grappling hook code
		if( Gear_GrappleHookMarker(Action.GrappleTargets[0]) != None )
		{
			GrappleTo( Gear_GrappleHookMarker(Action.GrappleTargets[0]) );
		}
		else
		{
			`Warn("Grapple To must be set!");
		}
	}
}

function GrappleTo(Gear_GrappleHookMarker InGrappleHookMarker)
{
	if( !CanUseGrapplingHook() )
	{
		`Warn(Self @ "tried to grapple to" @ InGrappleHookMarker @ "but doesn't support Grappling!!");
		return;
	}

	CurrentGrapplingMarker = InGrappleHookMarker;
	ServerDoSpecialMove(SM_GrapplingHook_Climb, TRUE);

}

/** Get grappling hook ground marker location */
simulated function vector GetGrapplingHookGroundMarker()
{
	local Vector	TraceStart, TraceEnd, HitLocation, HitNormal, X, Y, Z, MarkerOffset;

	GetAxes(CurrentGrapplingMarker.Rotation, X, Y, Z);
	MarkerOffset = CurrentGrapplingMarker.MarkerOffset;

	// Test, no scaling, just use Marker default height
	if( TRUE )
	{
		return CurrentGrapplingMarker.Location + X * MarkerOffset.X + Y * MarkerOffset.Y + Z * MarkerOffset.Z;
	}
	// Otherwise trace to ground and perform scaling of animations
	else
	{
		// Scale offset by a little bit to trace further than default height.
		MarkerOffset = 1.5f * MarkerOffset;
		TraceStart = CurrentGrapplingMarker.Location;
		TraceEnd = TraceStart + X * MarkerOffset.X + Y * MarkerOffset.Y + Z * MarkerOffset.Z;

		if( Trace(HitLocation, HitNormal, TraceEnd, TraceStart, FALSE) != None )
		{
			return HitLocation;
		}
	}

	// If we couldn't hit anything, then return max range...
	return TraceEnd;
}

/**
 * Create a new grappling hook actor
 *
 * @param MarkerLocation - the spawn location
 *
 * @param MarkerRotation - the spawn rotation
 */
simulated function CreateGrapplingHook(Vector MarkerLocation, Rotator MarkerRotation)
{
	// Destroy previous one if it exists.
	DestroyGrapplingHook();

	if (CanUseGrapplingHook() && GrapplingHookClass != None)
	{
		GrapplingHook = Spawn(GrapplingHookClass, Self,, MarkerLocation, MarkerRotation);
		GrapplingHook.SetHardAttach(TRUE);
		GrapplingHook.SetBase(Base);
	}
}

/** Destroy the grappling hook actor */
simulated function DestroyGrapplingHook()
{
	if( GrapplingHook != None )
	{
		// detect the "fall" damage type and simulate it on clients
		if (Role < ROLE_Authority && HitDamageType == class'GDT_FallOffGrappleRope')
		{
			GrapplingHook.KnockOff(None);
		}
		// if it's ragdolled, let it die on it's own
		if (GrapplingHook.Physics != PHYS_RigidBody)
		{
			GrapplingHook.Destroy();
		}
		GrapplingHook = None;
	}
}

/**
 * Get the animation slot of the grappling hook actor
 *
 * @return the requested GearAnim_Slot
 */
simulated function GearAnim_Slot GetGrapplingHookAnimSlot()
{
	if (GrapplingHook == None)
	{
		return None;
	}

	return GearAnim_Slot(GrapplingHook.GrapplingHookMesh.FindAnimNode('MainSlot'));
}

/** Force all local player controllers to spectate this pawn. */
function ViewMe()
{
	local GearPC	OutGPC;

	foreach WorldInfo.LocalPlayerControllers(class'GearPC', OutGPC)
	{
		OutGPC.SetViewTarget(Self);
	}
}

function CancelViewMe()
{
	local GearPC	OutGPC;

	foreach WorldInfo.LocalPlayerControllers(class'GearPC', OutGPC)
	{
		if( OutGPC.ViewTarget == Self )
		{
			OutGPC.SetViewTarget(OutGPC.Pawn);
		}
	}
}

/**
 *  Set new MeshTranslationOffset (world offset)
 *  @return TRUE if offset was applied, FALSE if prevented/disabled.
 **/
native simulated function bool UpdateMeshTranslationOffset(vector NewOffset, optional bool bForce);

final simulated function CheckShieldDeployment()
{
	local bool		bShouldDeployShield;

	// Only driven by locally controlled player
	if( !IsLocallyControlled() )
	{
		return;
	}

	// if sliding to cover don't do anything
	if( IsDoingSpecialMove(SM_Run2MidCov) || IsDoingSpecialMove(SM_Run2StdCov) )
	{
		return;
	}

	bShouldDeployShield = ShouldDeployShield();

// 	`DLog("bShouldDeployShield" @ bShouldDeployShield);
	if( bShouldDeployShield && SpecialMove != SM_DeployShield )
	{
		if( CanDoSpecialMove(SM_DeployShield) )
		{
			LocalDoSpecialMove(SM_DeployShield, TRUE);
		}
// 		else
// 		{
// 			`DLog("failed to start special move SM_DeployShield. Current SpecialMove:" @ SpecialMove);
// 		}
	}
	else if( !bShouldDeployShield && IsDoingSpecialMove(SM_DeployShield) )
	{
		LocalEndSpecialMove(SM_DeployShield);
	}
}


/**
 * Check if shield should be deployed or not.
 */
simulated function bool ShouldDeployShield()
{
	if( !IsCarryingShield() )
	{
		return FALSE;
	}

	// Otherwise targeting mode indicates that shield should be deployed
	return bIsTargeting;
}

/************************************************************************************
 * Heavy Weapons
 ***********************************************************************************/

final simulated event bool IsCarryingAHeavyWeapon()
{
	return (MyGearWeapon != None && MyGearWeapon.WeaponType == WT_Heavy);
}

/**
 * See if heavy weapons should be mounted or unmounted.
 * @param	bCheckingFromSpecialMove	if check is done within a special move transition, and therefore special move checks should be bypassed.
 */
final simulated function CheckHeavyWeaponMounting(optional bool bCheckingFromSpecialMove)
{
	local GearWeap_HeavyMiniGunBase     MiniGunWeapon;
	local GearWeap_HeavyMortarBase	    MortarWeapon;
	local GearWeap_HeavySniperBase      SniperWeapon;
	local bool bShouldMountHeavyWeap;
	local INT	PackedCoverState;
	local GearPC PC;

	// Pawn has to be locally controlled to instigate heavy weapon mounting/unmounting.
	if( !IsLocallyControlled() )
	{
		return;
	}

	// if sliding to cover don't do anything
	if (IsDoingSpecialMove(SM_Run2MidCov) || IsDoingSpecialMove(SM_Run2StdCov))
	{
		return;
	}

	//`log("CheckHeavyWeaponMounting. bCheckingFromSpecialMove:" @ bCheckingFromSpecialMove);
	PC = GearPC(Controller);

	// ** MiniGun
	bShouldMountHeavyWeap = ShouldMountMiniGun();
	MiniGunWeapon = GearWeap_HeavyMiniGunBase(Weapon);
	if( MiniGunWeapon != None )
	{
		// attempt to run to cover
		if (bShouldMountHeavyWeap && !IsInCover() && PC != None && PC.TryToRunToCover(FALSE,0.5f,DCLICK_None,TRUE))
		{
			return;
		}
		//`log("Checking for MiniGun. bShouldMountMiniGun" @ bShouldMountMiniGun @ "MyGearPawn.SpecialMove:" @ MyGearPawn.SpecialMove);

		// Check if MiniGun should be mounted
		if( bCheckingFromSpecialMove || (SpecialMove != SM_TargetMinigun && SpecialMove != SM_UnMountMinigun) )
		{
			//`log("CanDoSpecialMove SM_TargetMinigun" @ CanDoSpecialMove(SM_TargetMinigun));
			if( bShouldMountHeavyWeap && CanDoSpecialMove(SM_TargetMinigun) )
			{
				// Pack cover state, as it's used to pick the correct animation. Replicated here, to make sure it's consistent.
				// As variables and functions are replicated in different orders.
				PackedCoverState = (CoverAction << 2) + CoverType;
				LocalDoSpecialMove(SM_TargetMinigun, false, None, PackedCoverState);
			}
		}
	}
	// Check if MiniGun should be unmounted. Also done is Pawn isn't carrying heavy weapon anymore.
	if( SpecialMove == SM_TargetMinigun )
	{
		//`log("CanDoSpecialMove SM_UnMountMinigun" @ CanDoSpecialMove(SM_UnMountMinigun));
		if( !bShouldMountHeavyWeap )
		{
			if( CanDoSpecialMove(SM_UnMountMinigun) )
			{
				LocalDoSpecialMove(SM_UnMountMinigun, false);
			}
			else
			{
				// try again later in case we become able to do the special move
				SetTimer(0.1, false, nameof(CheckHeavyWeaponMounting));
			}
		}
	}

	// ** Mortar
	bShouldMountHeavyWeap = ShouldMountMortar();
	MortarWeapon = GearWeap_HeavyMortarBase(Weapon);
	if( MortarWeapon != None )
	{
		// Check if Mortar should be mounted
		if( bCheckingFromSpecialMove || (SpecialMove != SM_TargetMortar && SpecialMove != SM_UnMountMortar) )
		{
			//`log("CanDoSpecialMove SM_TargetMortar" @ CanDoSpecialMove(SM_TargetMortar));
			if( bShouldMountHeavyWeap && CanDoSpecialMove(SM_TargetMortar) )
			{
				PackedCoverState = (CoverAction << 2) + CoverType;
				LocalDoSpecialMove(SM_TargetMortar, false, None, PackedCoverState);
			}
		}
	}
	// Check if Mortar should be unmounted. Also done is Pawn isn't carrying heavy weapon anymore.
	if( SpecialMove == SM_TargetMortar )
	{
		//`log("CanDoSpecialMove SM_UnMountMinigun" @ CanDoSpecialMove(SM_UnMountMinigun));
		if( !bShouldMountHeavyWeap )
		{
			if( CanDoSpecialMove(SM_UnMountMortar) )
			{
				LocalDoSpecialMove(SM_UnMountMortar, false);
			}
			else
			{
				SetTimer(0.1, false, nameof(CheckHeavyWeaponMounting));
			}
		}
	}

	// ** Heavy sniper
	bShouldMountHeavyWeap = ShouldMountHeavySniper();
	SniperWeapon = GearWeap_HeavySniperBase(Weapon);
	if( SniperWeapon != None )
	{
		// attempt to run to cover
		if (bShouldMountHeavyWeap && !IsInCover() && PC != None && PC.TryToRunToCover(FALSE,0.5f,DCLICK_None,TRUE))
		{
			return;
		}
		// Check if HeavySniper should be mounted
		if( bCheckingFromSpecialMove || (SpecialMove != SM_TargetHeavySniper && SpecialMove != SM_UnMountHeavySniper) )
		{
			//`log("CanDoSpecialMove SM_TargetHeavySniper" @ CanDoSpecialMove(SM_TargetHeavySniper));
			if( bShouldMountHeavyWeap && CanDoSpecialMove(SM_TargetHeavySniper) )
			{
				PackedCoverState = (CoverAction << 2) + CoverType;
				LocalDoSpecialMove(SM_TargetHeavySniper, false, None, PackedCoverState);
			}
		}
	}
	// Check if HeavySniper should be unmounted. Also done is Pawn isn't carrying heavy weapon anymore.
	if( SpecialMove == SM_TargetHeavySniper )
	{
		//`log("CanDoSpecialMove SM_UnMountMinigun" @ CanDoSpecialMove(SM_UnMountMinigun));
		if( !bShouldMountHeavyWeap )
		{
			if( CanDoSpecialMove(SM_UnMountHeavySniper) )
			{
				LocalDoSpecialMove(SM_UnMountHeavySniper, false);
			}
			else
			{
				// try again later in case we become able to do the special move
				SetTimer(0.1, false, nameof(CheckHeavyWeaponMounting));
			}
		}
	}
}

/**
 * Check if minigun should be mounted or not.
 */
final simulated function bool ShouldMountMiniGun()
{
	if( Weapon == None || !Weapon.IsA('GearWeap_HeavyMiniGun') || Weapon.IsInState('PuttingDownHeavyWeapon') )
	{
		return FALSE;
	}

	return Weapon.HasAnyAmmo() && bIsTargeting;
}

/**
 * Check if mortar should be mounted or not.
 */
final simulated function bool ShouldMountMortar()
{
	if( Weapon == None || !Weapon.IsA('GearWeap_HeavyMortar') || Weapon.IsInState('PuttingDownHeavyWeapon') )
	{
		return FALSE;
	}

	// don't allow mounting when reloading mortar
	if (IsReloadingWeapon() && !IsDoingSpecialMove(SM_TargetMortar))
	{
		return FALSE;
	}

	return Weapon.HasAnyAmmo() && bIsTargeting;
}

/**
 * Check if heavy sniper should be mounted or not.
 */
final simulated function bool ShouldMountHeavySniper()
{
	local vector ScopeLoc;

	if( Weapon == None || !Weapon.IsA('GearWeap_HeavySniperBase') || Weapon.IsInState('PuttingDownHeavyWeapon') )
	{
		return FALSE;
	}

	// don't allow mounting when reloading heavy sniper
	if (IsReloadingWeapon() && !IsDoingSpecialMove(SM_TargetHeavySniper))
	{
		return FALSE;
	}

	// try to make sure the scope isn't inside geometry
	// PLK - not 100% because you can get still get in cycles where you stand and sit
	// hard to predict when the kneeling anim if going to put you into a bad spot without a ton of false positives
	if (IsInCover() || !IsDoingSpecialMove(SM_TargetHeavySniper))
	{
		SkeletalMeshComponent(MyGearWeapon.Mesh).GetSocketWorldLocationAndRotation('MountCheckCover', ScopeLoc);
	}
	else
	{
		SkeletalMeshComponent(MyGearWeapon.Mesh).GetSocketWorldLocationAndRotation('MountCheck', ScopeLoc);
	}

	if (!FastTrace(Location, ScopeLoc, vect(1,1,1)))
	{
		//DrawDebugLine(Location, ScopeLoc, 255, 0, 0, TRUE);

		return FALSE;
	}

	return Weapon.HasAnyAmmo() && bIsTargeting;
}

simulated function Notify_WeaponMountedImpact()
{
	local GearWeap_HeavyBase HWeap;
	HWeap = GearWeap_HeavyBase(Weapon);
	if (HWeap != None)
	{
		HWeap.Notify_MountedImpact();
	}
}

/** Returns true if this pawn is mounted, or in the process of mounting or unmounting a heavy weapon. */
simulated native function bool IsMountingHeavyWeapon() const;

/**
 * This will start a trail timer.
 * @TODO: make a nice way to determine the time period to drop.  Or change this to me some like distance based updating.
 **/
simulated function StartBloodTrail( name TrailFuncName, optional float SpawnRate )
{
	if( SpawnRate == 0.0f )
	{
		SpawnRate = 0.5f;
	}

	SetTimer( SpawnRate, TRUE, TrailFuncName );
}


/** This will stop the head shot spurting blood trail @see PlayHeadShotDeath **/
simulated final function StopBloodTrail_HeadShot()
{
	ClearTimer( nameof(SpawnABloodTrail_HeadShot) );
}

/**
 * This will stop a trail timer.
 * @TODO: make a nice way to determine the time period to drop.  Or change this to me some like distance based updating.
 **/
simulated final function StopBloodTrail( name TrailFuncName )
{
	ClearTimer( TrailFuncName );
	LocationOfLastBloodTrail = vect(0,0,0);
}


/** This will leave a trail of blood when you are DBNO **/
simulated function SpawnABloodTrail_DBNO()
{
	GearPawnFX.SpawnABloodTrail_DBNO();
}

/** This will leave a trail of blood when you are MeatBagging **/
simulated function SpawnABloodTrail_MeatBag()
{
	GearPawnFX.SpawnABloodTrail_MeatBag();
}

/** This will leave a trail of blood when you are in cover **/
simulated function SpawnABloodTrail_Wall()
{
	if (IsLocallyControlled())
	{
		if (Health < DefaultHealth)
		{
			GearPawnFX.SpawnABloodTrail_Wall();
		}
		else
		{
			StopBloodTrail(nameof(SpawnABloodTrail_Wall));
		}
	}
}

simulated function SpawnABloodTrail_GibExplode_Ground()
{
	GearPawnFX.SpawnABloodTrail_GibExplode_Ground();
}

/** This will unleash a blast of gore on the walls, ceiling, and floor around the character**/
simulated function SpawnABloodTrail_GibExplode_360()
{
	GearPawnFX.SpawnABloodTrail_GibExplode_360();
}

/** This will leave a trail of blood on the ground when you chainsaw someone **/
simulated function SpawnABloodTrail_ChainsawSpray_Ground()
{
	GearPawnFX.SpawnABloodTrail_ChainsawSpray_Ground();
}

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated function SpawnABloodTrail_ChainsawSpray_Wall()
{
	GearPawnFX.SpawnABloodTrail_ChainsawSpray_Wall();
}

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated function SpawnABloodTrail_GibImpact( vector HitLoc )
{
	if( EffectIsRelevant(Location, false, 4000) )
	{
		GearPawnFX.SpawnABloodTrail_GibImpact( HitLoc );
	}
}

/** This will leave a trail of blood from your headshot stump **/
simulated function SpawnABloodTrail_HeadShot()
{
	GearPawnFX.SpawnABloodTrail_HeadShot();
}

/** This will leave a small splat of blood **/
simulated function SpawnABloodTrail_HitByABullet()
{
	if ( EffectIsRelevant(Location, false, 1000) )
	{
		GearPawnFX.SpawnABloodTrail_HitByABullet();
	}
}

/** This will leave some blood as we are really hurt **/
simulated function SpawnABloodTrail_PawnIsReallyHurt()
{
	if ( EffectIsRelevant(Location, false, 2000) )
	{
		GearPawnFX.SpawnABloodTrail_PawnIsReallyHurt();
	}

}

/** This will leave some blood when one of our limbs breaks **/
simulated function SpawnABloodTrail_LimbBreak( vector InStartLocation )
{
	if ( EffectIsRelevant(Location, false, 1000) )
	{
		GearPawnFX.SpawnABloodTrail_LimbBreak( InStartLocation );
	}
}

/**
 * This is our function which will "remove" decals from our pawn.
 * We don't actually remove anything as the decal will do that itself.  But we need to keep track
 * of how many we have attached.
 * @todo: refactor this.  (works for bennu demo tho!)
 **/
simulated final function RemoveDecalsFromSelf()
{
	local int Idx;

	for( Idx = 0; Idx < MAX_DECALS_ATTACHED; ++Idx )
	{
		if( (Worldinfo.TimeSeconds - DecalsAttached[Idx]) > 15.0f )
		{
			NumDecalsAttachedCurr--;
		}
	}

	if( NumDecalsAttachedCurr != 0 )
	{
		SetTimer( 2.0f, FALSE, nameof(RemoveDecalsFromSelf) );
	}
}

/** Heats up the skin by the given amount.  Skin heat constantly diminishes in Tick(). */
simulated function HeatSkin(float HeatIncrement)
{
	// if fading, enforce CurrentSkinHeatMin
	if (HeatIncrement < 0 && CurrentSkinHeat > CurrentSkinHeatMin)
	{
		CurrentSkinHeat += HeatIncrement;
		CurrentSkinHeat = FClamp(CurrentSkinHeat, CurrentSkinHeatMin, 1.f);
	}
	else
	{
		CurrentSkinHeat += HeatIncrement;
		CurrentSkinHeat = FClamp(CurrentSkinHeat, 0.f, 1.f);
	}

	CurrentIgnitionSkinHeat += HeatIncrement;
	CurrentIgnitionSkinHeat = FClamp(CurrentIgnitionSkinHeat, 0.f, MaxIgnitionSkinHeat);

	MIC_PawnMat.SetScalarParameterValue('Heat', CurrentSkinHeat);

	if( MIC_PawnHair != none )
	{
		MIC_PawnHair.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}

	if (HeatIncrement > 0.f)
	{
		bSkipHeatFade = TRUE;
		SetTimer(SkinHeatFadeDelay, FALSE, nameof(SkinHeatFadeDelayExpired));
	}
}

/** Char skin to the given absolute char amount [0..1].  Charring does not diminish over time. */
simulated function CharSkin(float CharIncrement)
{
	CurrentSkinChar += CharIncrement;
	CurrentSkinChar = FClamp(CurrentSkinChar, 0.f, 1.f);

	if (WorldInfo.GRI.ShouldShowGore())
	{	
		MIC_PawnMat.SetScalarParameterValue('Burn', CurrentSkinChar);

		if( MIC_PawnHair != none )
		{
			MIC_PawnHair.SetScalarParameterValue('Burn', CurrentSkinChar);
		}
	}

	if (CharIncrement > 0.f)
	{
		bSkipCharFade = TRUE;
	}
}

final simulated function SkinHeatFadeDelayExpired()
{
	bSkipHeatFade = FALSE;
}

final simulated function FadeSkinEffects(float DeltaTime)
{
	local float KantusFadeDelta;
	// fade skin heat.
	if ( (CurrentIgnitionSkinHeat > 0 || CurrentSkinHeat > 0) && !bSkipHeatFade && (SkinHeatFadeTime > 0.f) )
	{
		HeatSkin(-DeltaTime / SkinHeatFadeTime);
	}
//	bSkipHeatFade = FALSE;

	// fade charring
	if ( (CurrentSkinChar > CurrentSkinCharMin) && !bSkipCharFade && (SkinCharFadeTime > 0.f) )
	{
		CharSkin(-DeltaTime / SkinCharFadeTime);
	}
	bSkipCharFade = FALSE;


	// kantus revive skin effect
	if( DesiredKantusFadeVal != CurrentKantusFadeVal )
	{
		KantusFadeDelta = DesiredKantusFadeVal - CurrentKantusFadeVal;
		KantusFadeDelta = KantusFadeDelta / abs(KantusFadeDelta);
		CurrentKantusFadeVal = fclamp(CurrentKantusFadeVal + KantusFadeDelta * DeltaTime/KantusSkinEffectFadeDuration,0.f,1.f);
		MIC_PawnMat.SetScalarParameterValue('ResValue',CurrentKantusFadeVal);

		if(DesiredKantusFadeVal>=1.0f && KantusRevivePSC == none && KantusReviver != none)
		{
			KantusReviver.DoKantusReviveEffects(self);
		}
		if(DesiredKantusFadeVal <= 0.f && KantusRevivePSC != none)
		{
			KantusRevivePSC.DeactivateSystem();
			DetachComponent(KantusRevivePSC);
			KantusRevivePSC=none;
		}
	}
}

final function ClearKantusHealGlow()
{
	DesiredKantusFadeVal = 0.0;
}

/** Notification forwarded from RB_BodyInstance, when a spring is over extended and disabled. */
simulated event OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
	Super.OnRigidBodySpringOverextension(BodyInstance);

	// Forward notification to special move.
	if( SpecialMove != SM_None )
	{
		SpecialMoves[SpecialMove].OnRigidBodySpringOverextension(BodyInstance);
	}
}

static function MutatePawn(GearPawn Victim)
{
	local int Idx;

	Victim.MutatedClass = default.Class;

	// Detach weapon from right hand
	Victim.MyGearWeapon.DetachWeapon();

	if( Victim.Mesh.SkeletalMesh != default.Mesh.SkeletalMesh )
	{
		Victim.Mesh.SetSkeletalMesh(default.Mesh.SkeletalMesh);
	}
	if( Victim.Mesh.PhysicsAsset != default.Mesh.PhysicsAsset )
	{
		Victim.Mesh.SetPhysicsAsset(default.Mesh.PhysicsAsset);
	}
	// Replace AnimTree only if it is different, because it will reset the animation state.
	if( Victim.Mesh.AnimTreeTemplate != default.Mesh.AnimTreeTemplate )
	{
		if( Victim.IsDoingASpecialMove() )
		{
			`warn("mutating" @ Victim.class @ "to" @ default.class @ "while doing special move:" @ Victim.SpecialMove @ "that could be bad! Aborting special move!");
			Victim.EndSpecialMove();
		}

		Victim.Mesh.SetAnimTreeTemplate(default.Mesh.AnimTreeTemplate);
	}

	for (Idx = 0; Idx < default.Mesh.GetNumElements(); Idx++)
	{
		Victim.Mesh.SetMaterial(Idx,default.Mesh.GetMaterial(Idx));
	}

	// Reattach weapon to right hand.
	Victim.AttachWeapon();
}

function OnMutate(SeqAct_Mutate Action)
{
	if (Action.PawnClass != None)
	{
		Action.PawnClass.static.MutatePawn(self);
	}
}

/** @return whether this Pawn is currently taking damage due to a pain volume it is touching */
function bool IsInPainVolume()
{
	local PhysicsVolume V;
	local Emit_StickyFire Fire;

	foreach TouchingActors(class'PhysicsVolume', V)
	{
		if (V.bPainCausing && V.DamagePerSec > 0.0)
		{
			return true;
		}
	}
	foreach TouchingActors(class'Emit_StickyFire', Fire)
	{
		return true;
	}

	return false;
}

function SplashBayonetCameraBlood()
{
	if (InteractionPawn != None && PlayerController(Controller) != None)
	{
		InteractionPawn.GearPawnFX.SpawnBayonetCameraBlood(PlayerController(Controller));
	}
}

/** Splash some blood on the screen! - used by anim notifies **/
function SplashChainsawBloodOnScreen()
{
	if (InteractionPawn != None && PlayerController(Controller) != None)
	{
		InteractionPawn.GearPawnFX.SpawnChainsawCameraBlood(PlayerController(Controller));
	}
}

/** Splash some blood on the screen! - used by anim notifies **/
function SplashBloodOnScreen_ExecutionBoltok()
{
	if (GearPC(Controller) != None)
	{
		GearPC(Controller).ClientSpawnCameraLensEffect( class'Emit_CameraBlood_PunchSplatter' );
	}
}

/** Splash some blood on the screen! - used by anim notifies **/
function SplashBloodOnScreen_PunchFace()
{
	if (GearPC(Controller) != None)
	{
		GearPC(Controller).ClientSpawnCameraLensEffect( class'Emit_CameraBlood_PunchSplatter' );
	}
}

/** Splash some blood on the screen! - used by anim notifies **/
function SplashBloodOnScreen_SmashFace()
{
	if (GearPC(Controller) != None)
	{
		GearPC(Controller).ClientSpawnCameraLensEffect( class'Emit_CameraBlood_PunchSplatter' );
	}
}

/** Splash some blood on the screen! - used by anim notifies **/
function SplashBloodOnScreen_TorqueBow()
{
	if (GearPC(Controller) != None)
	{
		GearPC(Controller).ClientSpawnCameraLensEffect( class'Emit_CameraBlood_PunchSplatter' );
	}
}

// Is this pawn getting executed
simulated function bool IsBeingExecuted()
{
	return (IsDoingSpecialMove(SM_CQC_Victim) || IsDoingSpecialMove(SM_ChainsawVictim) || IsDoingSpecialMove(SM_BayonetVictim) || IsDoingSpecialMove(SM_DiggerChestDrill));
}

// Is this pawn executing someone
simulated function bool IsDoingExecution()
{
	return (IsDoingSpecialMove(SM_CQCMove_CurbStomp) ||
			IsDoingSpecialMove(SM_CQCMove_PunchFace) ||
			IsDoingSpecialMove(SM_CQCMove_Shield) ||
			IsDoingSpecialMove(SM_CQCMove_B)||
			IsDoingSpecialMove(SM_ChainSawAttack) ||
			IsDoingSpecialMove(SM_BayonetAttack));
}

function ExecutionParticleSpawner( const ParticleSystem PS )
{
	local bool bFoundSpawnLoc;
	local vector Loc;
	local rotator Rot;
	//local array<name> BoneNames;

	if( !EffectIsRelevant(Location, false, 1000) )
	{
		return;
	}

	if (WorldInfo.GRI.ShouldShowGore())
	{
		if (Mesh.GetSocketWorldLocationAndRotation( HeadSocketName, Loc, Rot ))
		{
			bFoundSpawnLoc = TRUE;
		}
		// for now we assume there is always going to be a head socket
		// 	else
		// 	{
		// 		Mesh.GetBoneNames( BoneNames );
		// 		if( BoneNames.Find('b_MF_Spine_01') != INDEX_NONE )
		// 		Loc = Mesh.GetBoneLocation( 'b_MF_Spine_01' );
		// 		bFoundSpawnLoc = TRUE;
		// 	}

		// if we have a spawn loc
		if (bFoundSpawnLoc)
		{
			WorldInfo.MyEmitterPool.SpawnEmitter(PS, Loc, Rot);
		}
	}
}

/** used by anim notifies */
function SpawnExecutionEffect_Boltok()
{
	ExecutionParticleSpawner( ParticleSystem'Effects_Gameplay.Blood.P_Blood_Head_Boltok_Execution' );
}

/** used by anim notifies */
function SpawnExecutionEffect_LongShot()
{
	local GearGRI GRI;
	local rotator Rot;

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None && GRI.ShouldShowGore() )
	{
		if ( EffectIsRelevant(Location, false, 1000) )
		{
			WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'Effects_Gameplay.Blood.P_Blood_Body_Longshot_Execution', Mesh.GetBoneLocation(PelvisBoneName), Rot);
		}

		GRI.LeaveADecal(GearPawnFX.BloodDecalTrace_GroundBelowThePawn, GearPawnFX.BloodDecalChoice_GibExplode_Ground);
	}

}

/** used by anim notifies */
function SpawnExecutionEffect_TorqueBow()
{
	//Execution head explosion and blood spray (duplicate of the headshot blood fountain):
	ExecutionParticleSpawner( ParticleSystem'Effects_Gameplay.Blood.P_Blood_Head_Torquebow_Execution' );
	//Also needs: Blood decals on ground like the headshot spray from the neck
}

/** used by anim notifies */
function SpawnExecutionEffect_PunchRightToLeft()
{
	local GearGRI GRI;

	ExecutionParticleSpawner( ParticleSystem'Effects_Gameplay.Blood.P_Blood_Head_FacePunch_Bloodspray' );

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.LeaveADecal(GearPawnFX.BloodDecalTrace_FromNeckForFacePunch, GearPawnFX.BloodDecalChoice_PunchFace);
	}
}

/** used by anim notifies */
function SpawnExecutionEffect_PunchLeftToRight()
{
	local GearGRI GRI;

	ExecutionParticleSpawner( ParticleSystem'Effects_Gameplay.Blood.P_Blood_Head_FacePunch_Bloodspray' );

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.LeaveADecal(GearPawnFX.BloodDecalTrace_FromNeckForFacePunch, GearPawnFX.BloodDecalChoice_PunchFace);
	}
}


//Small directional blood sprays to spawn from the face after each punch, ideally we could spawn then in the direction the punch is going (think slomo rocky blood from mouth)

/**
 * Called by AnimNotify_PlayParticleEffect
 * Looks for a socket name first then bone name
 *
 * @param AnimNotifyData The AnimNotify_PlayParticleEffect which will have all of the various params on it
 */
event bool PlayParticleEffect( const AnimNotify_PlayParticleEffect AnimNotifyData )
{
	local vector Loc;
	local rotator Rot;
	local bool bPlayNonExtreme;
	local ParticleSystem PSC;

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		`Log("(GearPawn): PlayParticleEffect on dedicated server!");
		return true;
	}

	// should I play non extreme content?
	bPlayNonExtreme = ( AnimNotifyData.bIsExtremeContent == TRUE ) && ( WorldInfo.GRI.ShouldShowGore() == FALSE ) ;


	// if this is extreme content and we can't show extreme content then return
	if ( bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate==None )
	{
		return false;
	}

	if ( !EffectIsRelevant(Location, false, 4000) )
	{
		// Return true so that the skelmesh component doesn't play it!
		return true;
	}

	if ( bPlayNonExtreme )
	{
		PSC = AnimNotifyData.PSNonExtremeContentTemplate;
	}
	else
	{
		PSC = AnimNotifyData.PSTemplate;
	}

	// now go ahead and spawn the particle system based on whether we need to attach it or not
	if (AnimNotifyData.bAttach)
	{
		if (AnimNotifyData.SocketName != '')
		{
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PSC, Mesh, AnimNotifyData.SocketName, true);
		}
		else if (AnimNotifyData.BoneName != '')
		{
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PSC, Mesh, AnimNotifyData.BoneName, false);
		}
		else
		{
			return false;
		}
	}
	else
	{
		// find the location
		if( AnimNotifyData.SocketName != '' )
		{
			Mesh.GetSocketWorldLocationAndRotation( AnimNotifyData.SocketName, Loc, Rot );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			Loc = Mesh.GetBoneLocation( AnimNotifyData.BoneName );
			Rot = QuatToRotator(Mesh.GetBoneQuaternion(AnimNotifyData.BoneName));
		}
		else
		{
			Loc = Location;
			Rot = rot(0,0,1);
		}

		WorldInfo.MyEmitterPool.SpawnEmitter(PSC, Loc, Rot);
	}

	return true;
}

/** Hook called from HUD actor. Gives access to HUD and Canvas */
simulated function DrawHUD(HUD H)
{
	Super.DrawHUD(H);
	// Hook for HUD access from SpecialMoves.
	if( SpecialMove != SM_None )
	{
		SpecialMoves[SpecialMove].DrawHUD(H);
	}
}

function OnSetPawnSpeed(SeqAct_SetPawnSpeed InAction)
{
	GroundSpeed = InAction.NewSpeed;
}

function OnSetTimeDilation(SeqAct_SetTimeDilation InAction)
{
	CustomTimeDilation = InAction.TargetTimeDilation;
}

simulated function bool ShouldTorqueBowArrowGoThroughMe(GearProjectile Proj, TraceHitInfo HitInfo, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	return (WorldInfo.GRI == None || !WorldInfo.GRI.OnSameTeam(Proj.Instigator, self) && TookHeadShot(HitInfo.BoneName, HitLocation, Momentum));
}

exec function PlayGUDSAction(EGUDActionID ActionID, optional GearPawn Addressee, optional GearPawn ReferringTo, optional ESpeakLineBroadcastFilter MPBroadcastFilter)
{
	GearGame(WorldInfo.Game).UnscriptedDialogueManager.PlayGUDSAction(ActionID, self, Addressee, ReferringTo, MPBroadcastFilter);
}

simulated function OnPawnMuteGUDS(SeqAct_PawnMuteGUDS Action)
{
	// 0 is mute, 1 is unmute
	bMuteGUDS = Action.InputLinks[0].bHasImpulse;
}

/**
  * Turn on/off GUDS : Used for in-game cinematic
  */
simulated function SetPawnMuteGUDS(bool bMute)
{
	bMuteGUDS = bMute;
}

/**
 * Handles switching the player in/out of matinee mode.
 * This isn't same as Cinematic Mode.
 * Cinematic mode does hide hud or destroy all extra weapons for preparation
 * This one makes player to go matinee mode - disabling inputs
 * This doesn't just for matinee mode, but any special animation mode that you'd like to have this controller on
 * Forward the request to each controller
 */
function OnToggleMatineeMode(SeqAct_ToggleMatineeMode Action)
{
	local int ActorIdx;
	local Actor LatentActor, StartActor;

	if (Action.bActionEnabled)
	{
		// Clear
		StartActor = self;
		for (ActorIdx=0; ActorIdx<Action.LatentActors.Length; ++ActorIdx)
		{
			LatentActor = Action.LatentActors[ActorIdx];
			if (LatentActor != none &&
				(LatentActor == self || LatentActor == Controller) )
			{

				// check bound
				if ( Action.StartActors.Length > ActorIdx )
				{
					StartActor = Action.StartActors[ActorIdx];
				}

				break;
			}
		}
	}
	else
	{
		StartActor = none;
	}

	//`log("Toggling Matinee Mode for "@self);
	ClientToggleMatineeMode(Action.bActionEnabled, StartActor);
}

reliable client function ClientToggleMatineeMode(bool bEnableMatineeMode, Actor StartActor)
{
	//`log("Toggling Matinee Mode in Client "@StartActor);

	EngageMatineeMode_Actor = StartActor;

	if (MyGearAI != none)
	{
		MyGearAI.TurnOnBehavior(!bEnableMatineeMode);
	}
	else if (Controller != none)
	{
		GearPC(Controller).TurnOnBehavior(!bEnableMatineeMode);
	}
}

event MAT_BeginAIGroup(vector StartLoc, rotator StartRot)
{
	local BasedPosition BP;

	Vect2BP( BP, StartLoc, Base );
	ClientSetPawnLocationAndRotation( BP, StartRot);

	// FIXME: think about this - should we do this or not?
	// I'd rather like to separate it out with toggle matinee mode

//  	if (MyGearAI != none)
//  	{
//  		MyGearAI.TurnOnBehavior(Action);
//  	}
//  	else if (Controller != none)
//  	{
//  		GearPC(Controller).TurnOnBehavior(Action);
//  	}
}

simulated exec event PlaySpeechGesture(Name GestureAnim)
{
	if( BS_IsPlaying(SpeechGestureBodyStance) )
	{
		BS_Stop(SpeechGestureBodyStance, 0.67f);
	}

	if( !IsDoingASpecialMove() && !IsCarryingAHeavyWeapon() && !IsDeployingShield() && !bIsConversing )
	{
		SpeechGestureBodyStance.Stance.Length = 2; // Arrays of Struct need to be pre-sized. :(
		SpeechGestureBodyStance.Stance[0].Slot = BS_Std_Up;
		SpeechGestureBodyStance.Stance[0].AnimName = GestureAnim;

		SpeechGestureBodyStance.Stance[1].Slot = BS_Std_Idle_Lower;
		SpeechGestureBodyStance.Stance[1].AnimName = GestureAnim;

		BS_Play(SpeechGestureBodyStance, 0.85f, 0.67f, 0.67f);
	}
}

/** Kismet hook for kicking a pawn out of a vehicle */
simulated function OnGearExitVehicle( SeqAct_GearExitVehicle inAction )
{
	local Pawn VehiclePawn;
	local GearTurret GT;
	local GearVehicle GV;
	local GearPawnRidable_Base GPR;

	if( InAction.TargetVehicle != None )
	{
		VehiclePawn = Pawn(InAction.TargetVehicle);
	}
	else if( Controller != None )
	{
		VehiclePawn = Controller.Pawn;
	}
	else if( PreviousController != None )
	{
		VehiclePawn = PreviousController.Pawn;
	}

	GT = GearTurret(VehiclePawn);
	if( GT != None && GT.Driver == self )
	{
		GT.OnGearExitVehicle(InAction);
	}
	else
	{
		GV = GearVehicle(VehiclePawn);
		if( GV != None )
		{
			// Kick them out first so they get the controller back
			if( VehiclePawn == self )
			{
				GV.KickPawn(GearPawn(GV.Driver));
			}
			else
			{
				GV.KickPawn(self);
			}

			// reset default command
			if( MyGearAI != None )
			{
				MyGearAI.DefaultCommand = MyGearAI.Default.DefaultCommand;
			}
		}

		GPR = GearPawnRidable_Base(VehiclePawn);
		if( GPR != None )
		{
			if( VehiclePawn == self )
			{
				GPR.KickPawn(GPR.Driver);
			}
			else
			{
				GPR.KickPawn(self);
			}

			// reset default command
			if( MyGearAI != None )
			{
				MyGearAI.DefaultCommand = MyGearAI.Default.DefaultCommand;
			}
		}
	}
}


/**
 * Handler for scripted use of Silverbacks
 */
function OnAIUseSilverback(SeqAct_AIUseSilverback Action)
{
	local GearAI_Cover AI;
	local GearPC PC;

	if( Action.InputLinks[0].bHasImpulse )
	{
		AI = GearAI_Cover(MyGearAI);
		if( AI != None )
		{
			AI.OnAIUseSilverback(Action);
		}
	}
	else if( Action.InputLinks[1].bHasImpulse )
	{
		if( Action.Silverback != None )
		{
			AI = GearAI_Cover(Action.Silverback.MyGearAI);
			PC = GearPC(Action.Silverback.Controller);
		}
		else if( Controller != None )
		{
			AI = GearAI_Cover(Controller);
			PC = GearPC(Controller);
		}
		else
		{
			AI = GearAI_Cover(PreviousController);
			PC = GearPC(PreviousController);
		}

		if( AI != None )
		{
			AI.StopUsingSilverback(AI.CurrentSilverback);
		}
		if( PC != None )
		{
			GearPawnRidable_Base(PC.Pawn).DriverLeave(false);
		}
	}
}

/** Stub for subclasses */
function TelegraphAttack();

/** Stub for subclasses */
function TelegraphCharge();

/** Stub for subclasses */
simulated function FlameTankAboutToBlow()
{
	// say "ahhh!"
	if (!bPlayedDeath)
	{
		SoundGroup.PlayEffort(self, GearEffort_OnFireDeath,, TRUE);
	}
}

/** Play the abort comm link effort. Returns true if effort was played successfully */
simulated event bool PlayAbortCommLink()
{
	return SoundGroup.PlayEffort(Self, GearEffort_AbortCommLink);
}

function PathConstraint CreatepathConstraint(class<PathConstraint> ConstraintClass )
{
	return GearGame(WorldInfo.Game).GetPathConstraintFromCache(ConstraintClass,self);
}

function PathGoalEvaluator CreatePathGoalEvaluator(class<PathGoalEvaluator> GoalEvalClass )
{
	return GearGame(WorldInfo.Game).GetPathGoalEvaluatorFromCache(GoalEvalClass,self);
}

/** Stub for subclasses */
simulated function OpenShield( bool bModGroundSpeed, optional float ModGroundSpeed, optional bool bDoSpecialMove );
/** Stub for subclasses */
simulated function CloseShield();

/**
 * Will return the TeamNum of the weapon owner based on class.  So for the MP Classes they will have correct class based colors
 * Additionally, the TeamNum is getting set WAY after the weapons have been attached so TeamNum() doesn't really work at getting
 * the correct colors set.
 **/
simulated function byte GetMPWeaponColorBasedOnClass();

simulated function OnSetPawnBaseHealth(SeqAct_SetPawnBaseHealth Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		DefaultHealth = Action.NewHealth;
		Health = Action.NewHealth;
	}
}

/**
 * Make sure we're hitting a member of the opposing team
 *
 * @param PC - the player controller using the crosshair
 *
 * @param HitLocation - where the crosshair trace hit
 *
 * @param HitBone - the bone that the crosshair trace hit
 *
 * @param HitComponent - the component that was hit
 *
 * @return TRUE if the crosshair should turn red
 */
simulated function bool ShouldTurnCursorRedFor(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	return (GetTeamNum() != 254 && !WorldInfo.GRI.OnSameTeam(PC, self));
}

/**
 * Should we turn the 'crosshair plus' used to show important hit areas, such as weak spots.
 *
 * @param PC - the player controller using the crosshair
 * @param HitLocation - where the crosshair trace hit
 * @param HitBone - the bone that the crosshair trace hit
 * @param HitComponent - the component that was hit
 * @return TRUE if the crosshair should turn 'crosshair plus'
 */
simulated function bool ShouldDisplayCrosshairPlus(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	return FALSE;
}

function int GetMaxDownCount()
{
	/* Override handled at difficulty level now
	if(!WorldInfo.GRI.IsMultiPlayerGame())
	{
		return -1; // inf downs in SP
	}*/
	return MaxDownCount;
}

simulated function int GetRevivalTime()
{
	if (OverrideRevivalTime != 0)
	{
		return OverrideRevivalTime;
	}
	return GearGRI(WorldInfo.GRI).InitialRevivalTime;
}

function float GetAIAccuracyModWhenTargetingMe(GearAI GuyTargetingMe)
{
	return 0.f;
}

event bool IsFiringHOD()
{
	return ((Weapon != None) && Weapon.IsA('GearWeap_HOD') && Weapon.IsFiring());
}


/** This is a debug function to verify that none OF the pawns have incorrect bones in their break lists **/
simulated function CheckGoreJoints()
{
`if(`notdefined(FINAL_RELEASE))
	local int HostageIdx;
	local name HostageBoneName;
	local int BreakableIdx;
	local bool bFound;

	if (GoreSettings != None)
	{
		for (HostageIdx = 0; HostageIdx < GoreSettings.HostageBones.Length; ++HostageIdx)
		{
			HostageBoneName = GoreSettings.HostageBones[HostageIdx];

			// look for the HostageName
			for (BreakableIdx = 0; BreakableIdx < GoreSettings.GoreBreakableJoints.length; ++BreakableIdx)
			{
				if (HostageBoneName == GoreSettings.GoreBreakableJoints[BreakableIdx].ConstraintName)
				{
					bFound = TRUE;
					break;
				}
			}

			if (!bFound)
			{
				`warn("Found Bone ("$HostageBoneName$") in HostageBreak list that was not in GoreSettings.GoreBreakableJoints list!!!!");
			}

			// reset for next round
			bFound = FALSE;
		}
	}
`endif
}

/** Toggle MeatShieldMorph */
simulated function SetActiveMeatShieldMorph(bool bInActivate)
{
	bActivateMeatShieldMorph = bInActivate;
	MeatShieldMorphTimeToGo = MeatShieldMorphBlendTime;
}

/**
 * Returns location to use when testing if this pawn was hit by a melee attack.  Useful to override, e.g., for
 * small creatures close to the ground.
 */
simulated function vector GetMeleeHitTestLocation()
{
	return Location;
}

/** Notification called when one of our meshes gets his AnimTree updated */
simulated event AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
	`LogInv(SkelMesh.AnimTreeTemplate);
	if( MyGearWeapon != None && SkelMesh == MyGearWeapon.Mesh )
	{
		MyGearWeapon.UpdateAnimNodeReferences();
	}

	Super.AnimTreeUpdated(SkelMesh);
}


reliable server function ServerAddMissleLockTarget(Actor TargetActor)
{
	AddMissleLockTarget(TargetActor);
}

simulated function AddMissleLockTarget(Actor TargetActor)
{
	if (Role < ROLE_Authority)
	{
		ServerAddMissleLockTarget(TargetActor);
	}

	MissileLockTargets[MissileLockTargets.length] = TargetActor;

}

reliable server function ServerClearMissileLockTargets()
{
	ClearMissileLockTargets();
}

simulated function ClearMissileLockTargets()
{
	if (Role < ROLE_Authority)
	{
		// tell server
		ServerClearMissileLockTargets();
	}

	MissileLockTargets.length = 0;
}

function GoBerzerk(float Duration)
{
	if (MyGearAI != None)
	{
		MyGearAI.SetBerzerk(true);
		SetTimer(Duration, FALSE, nameof(ExpireBerzerk));
	}
}
function ExpireBerzerk()
{
	if (MyGearAI != None)
	{
		MyGearAI.SetBerzerk(false);
	}
};

/** Kismet hook to allow for the stripping of armor attachments, placeholder to eat warnings. Used in GearPawn_Infantry */
function OnRemoveArmorAttachments(SeqAct_RemoveArmorAttachments Action);

/** Notification called when Chainsaw Attack towards this Pawn has ended */
function ChainsawAttackedEndedNotification(GearPawn InstigatedBy);

/** Notification called when Bayonet Attack towards this Pawn has ended */
function BayonetAttackedEndedNotification(GearPawn InstigatedBy);

function float GetMinDistToAnyHumanSquadMate()
{
	local GearPC PC;
	local GearSquad Squad;
	local float BestDist;
	local float CurDist;

	if(Controller != none && IsHumanControlled())
	{
		Squad = GearPC(Controller).Squad;
	}
	else if(MyGearAI != none)
	{
		Squad = MyGearAI.Squad;
	}

	BestDist=1000000;

	if(Squad != none)
	{
		foreach Squad.AllMembers(class'GearPC',PC)
		{
			if(PC.Pawn != none)
			{
				CurDist = VSize(Location-PC.Pawn.Location);
				if(CurDist < BestDist)
				{
					BestDist = CurDist;
				}
			}
		}
	}

	return BestDist;
}

/**
 * Clones the mesh, changes the materials for it, and changes the DPG
 */
simulated function CreateTaccomMesh()
{
	local int MaterialIndex;
	local GearGRI GRI;
	local MaterialInstanceConstant MIC;

	GRI = GearGRI(WorldInfo.GRI);

	if (GRI != None && GRI.GameClass != None && class<GearGame>(GRI.GameClass).default.bShouldDisplayAlliesViaTaccom && Mesh != None)
	{
		if (GRI.AddTaccomPlayer(self))
		{
			//If this isn't a dupe...
			if (TaccomMesh == none)
			{
				// Clone the mesh and set the material and DPG
				TaccomMesh = new(Self) Mesh.Class;
				if (TaccomMesh != None)
				{
					TaccomMesh.SetSkeletalMesh(Mesh.SkeletalMesh);
					for (MaterialIndex = 0; MaterialIndex < TaccomMesh.GetNumElements(); MaterialIndex++)
					{
						MIC = new(TaccomMesh) class'MaterialInstanceConstant';
						//@note: use runtime mesh material to handle e.g. MP material overrides
						MIC.SetParent(Mesh.GetMaterial(MaterialIndex));
						MIC.SetScalarParameterValue('Taccom', 1.0);
						TaccomMesh.SetMaterial(MaterialIndex, MIC);
					}
					TaccomMesh.SetParentAnimComponent(Mesh);
					TaccomMesh.SetDepthPriorityGroup(SDPG_Foreground);
					TaccomMesh.CastShadow = false;
					AttachComponent(TaccomMesh);
				}
			}
		}
		else
		{
			RemoveTaccomMesh();
		}
	}
}

simulated function RemoveTaccomMesh()
{
	if (TaccomMesh != none)
	{
		TaccomMesh.SetHidden(true);
		DetachComponent(TaccomMesh);
		TaccomMesh = none;
	}
}

/** disables bShowInEnemyTaccom, usually used with timers */
final function RemoveFromEnemyTaccom()
{
	bShowInEnemyTaccom = false;
}

/** restores GroundSpeed to its default value */
final function ResetGroundSpeed()
{
	GroundSpeed = DefaultGroundSpeed;
}

/** A sane alternative to ClientSetLocation(), which ends up setting the Controller's rotation as well. */
reliable client function ClientSetPawnLocationAndRotation( BasedPosition Loc, rotator Rot)
{
	Rot.Roll = 0;
	SetRotation(Rot);
	SetLocation(BP2Vect(Loc));
	if( Loc.Base != None )
	{
		SetBase( Loc.Base );
	}
}

//`define debugfindmantledistance(expr) `expr
`define debugfindmantledistance(expr)
/**
 * Finds mantle distance.
 * Uses Mantle Target as a suggestion, but performs a trace to find how thick cover is.
 * mantle targets are from slots to slots, and player may not be on a slot.
 * Also "slots to slots" may not be aligned with each other (along cover normal/pawn rotation)
 * so this information cannot be used as is.
 * Here a trace is performed to find how thick this cover is, and then uses that to scale root motion
 * on jumping animation to make sure player can jump over without getting stuck inside cover.
 */
simulated function bool FindMantleDistance(out Vector out_MantleStartLoc, out Vector out_MantleEndLoc, out float out_MantleDistance, optional Actor ActorToIgnoreAtTheEnd)
{
	local Vector	StartTrace, EndTrace, HitLocation, HitNormal, BackupExtent;
	local float		ExtentRadius, CollisionRadius;//, CoverThickness;
	local Actor		HitActor, BlockingActor;
	local Pawn      HitPawn;

	//// DEBUG
  	`debugfindmantledistance(FlushPersistentDebugLines());
  	`debugfindmantledistance(DrawDebugSphere(out_MantleStartLoc, 8, 8, 0, 255, 0, TRUE));
  	`debugfindmantledistance(DrawDebugSphere(out_MantleEndLoc, 8, 8, 255, 0, 0, TRUE));

	// Trace from current estimate of mantle end location, back to start.
	// We're trying to find the cover surface.
	StartTrace	= out_MantleEndLoc;
	EndTrace	= out_MantleStartLoc;

	// backup trace with extent using the pawn cylinder for less than perfect content
	BackupExtent = GetCollisionExtent() * 0.5f;

	// check to see if there are any pawns at the start location
	foreach TraceActors(class'Pawn', HitPawn, HitLocation, HitNormal, EndTrace - vect(0,0,32), EndTrace,,,TRACEFLAG_Blocking)
	{
		if (HitPawn.bBlockActors && !HitPawn.bTearOff && HitActor != ActorToIgnoreAtTheEnd)
		{
			`debugfindmantledistance(`log("aborting mantle 2 for:"@HitPawn));
			return FALSE;
		}
	}

	foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace,BackupExtent,,TRACEFLAG_Blocking)
	{
		if (HitActor.bBlockActors && !HitActor.bTearOff && HitActor != ActorToIgnoreAtTheEnd)
		{
			BlockingActor = HitActor;
		}
	}
	if( BlockingActor != None )
	{
		`debugfindmantledistance(`log(">>>>>>>>>>>>>>>>>>>>>>OUTER TRACE>>>>>>>>>>>>>>>>>>>>>>>"@HitActor@HitLocation));
		`debugfindmantledistance(DrawDebugLine(StartTrace, HitLocation, 255, 0, 0, TRUE));

		if( BlockingActor != None )
		{
			`debugfindmantledistance(DrawDebugLine(StartTrace, HitLocation, 0, 255, 0, TRUE));

			// Collision radius of Pawn
			CollisionRadius	= GetCollisionRadius();
			// Take collision box diagonal. This takes into account the worst case possible,
			// because player collision is an AABB and not an actual cylinder.
			ExtentRadius	= CollisionRadius * Sqrt(2.f) + 1.f;

			// New Mantle end location: backup by max collision extent of Pawn to make sure he can fit there.
			out_MantleEndLoc = HitLocation + Normal(StartTrace - EndTrace) * ExtentRadius;
			`debugfindmantledistance(DrawDebugCoordinateSystem(out_MantleEndLoc,rot(0,0,0),100.f,TRUE));

			// New Mantle distance
			`debugfindmantledistance(DrawDebugLine(out_MantleEndLoc,out_MantleStartLoc,255,0,0,TRUE));
			out_MantleDistance	= VSize2D(out_MantleEndLoc - out_MantleStartLoc);
		}
	}

	return TRUE;
}

/** Accessor for whether the pawn can strafe or not (used so we can have situationly strafing */
function bool CanStrafe()
{
	return bCanStrafe;
}

/**
 * Handler for the kismet action that sets up the one liners
 *
 * @param SetOnDeathOneLinersAction - kismet action that triggered this function
 */
function OnSetOnDeathOneLiners(SeqAct_SetOnDeathOneLiners SetOnDeathOneLinersAction)
{
	bPlayOneLinerOnDeath = TRUE;

	OnDeathOneLinerDelay = SetOnDeathOneLinersAction.DelaySec;

	OnDeathOneLiners[0] = SetOnDeathOneLinersAction.OneLiners[0];
	OnDeathOneLiners[1] = SetOnDeathOneLinersAction.OneLiners[1];
	OnDeathOneLiners[2] = SetOnDeathOneLinersAction.OneLiners[2];
	OnDeathOneLiners[3] = SetOnDeathOneLinersAction.OneLiners[3];
}

/**
 * Kismet handler for zipline, the authority and the autonomous pawn needs to run the attach and detach code
 *
 * @param ZiplineAction - the kismet action
 */
function OnManageZipline(SeqAct_ManageZipline ZiplineAction)
{
	if (ZiplineAction.bDetach)
	{
		ZiplineDetach();

		if (!IsLocallyControlled())
		{
			ClientZiplineDetach();
		}
	}
	else
	{
		ZiplineAttach(ZiplineAction.ZiplineBase);

		if (!IsLocallyControlled())
		{
			ClientZiplineAttach(ZiplineAction.ZiplineBase);
		}
	}
}

/**
 * Set the stage for being matinee controlled down the zipline
 *
 * @param ZiplineBase - the base actor we'll be using while on the zipline
 */
function ZiplineAttach(Actor ZiplineBase)
{
	local GearAI AI;

	AI = GearAI(Controller);
	if( AI != None )
	{
		if( AI.CommandList != None )
		{
			AI.AbortCommand( AI.CommandList );
		}
	}

	SetPhysics(PHYS_Interpolating);
	SetHardAttach(TRUE);
	SetBase(ZiplineBase);
	LocalDoSpecialMove(SM_ZiplineIdle, TRUE);
}

/**
 * Tell the client to set the stage for being matinee controlled down the zipline
 *
 * @param ZiplineBase - the base actor we'll be using while on the zipline
 */
reliable client function ClientZiplineAttach(Actor ZiplineBase)
{
	ZiplineAttach(ZiplineBase);
}

/** Detach from the zipline and fall */
function ZiplineDetach()
{
	LocalDoSpecialMove(SM_ZiplineEnd, TRUE);
	SetBase(None);
	SetHardAttach(FALSE);
	SetPhysics(PHYS_Falling);
}

/** Tell the client to detach from the zipline */
reliable client function ClientZiplineDetach()
{
	ZiplineDetach();
}

/** called on a timer to start SM_DragInjured with the character represented by PendingCarriedPawnGuid */
function ApplyPendingCarriedPawn()
{
	local GearPawn P;

	foreach WorldInfo.AllPawns(class'GearPawn', P)
	{
		if (P.MyGuid == PendingCarriedPawnGuid || (P.MyGearAI != None && P.MyGearAI.MyGuid == PendingCarriedPawnGuid))
		{
			ServerDoSpecialMove(GSM_DragInjured_Leader, true, P);
			break;
		}
	}
}

simulated function bool OverrideHolsterAnimation(GearWeapon WP)
{
	return FALSE;
}

simulated function bool OverrideEquipAnimation(GearWeapon WP, float BlendInTime)
{
	return FALSE;
}

/** Allow gearpawns to hook into the input */
simulated function PreProcessInput(GearPlayerInput Input)
{
	local GearPC PC;
	local bool bLookingAtPOI;

	PC = GearPC(Controller);
	bLookingAtPOI = PC != None && PC.CurrLookedAtPOI != None;

	// If we are doing the roadiejog (when in walking volumes) force roadierun-like controls
	if( !bLookingAtPOI && bIsRoadieJogging )
	{
		// force running forwards
		Input.aBaseY	= 1.f;
		// strafe becomes turning
		Input.aTurn		= Input.aStrafe * 0.33f;
		Input.aStrafe	= 0.f;
	}
}

/** Called just before the pawn receives inventory */
simulated function EquipingWeaponNotify(GearWeapon EquipWeapon)
{
	if (GearInventoryManager(InvManager).Shield != None && !EquipWeapon.bCanEquipWithShield && (Role == ROLE_Authority || IsLocallyControlled()))
	{
		`LogInv("Dropping shield!");
		// can't hold shield with non-1-handed weapon, so drop it
		ServerDropShield();
	}
}

/** Allow pawns to tweak their acceleration while flying */
function AdjustFlyingAcceleration();

/** attaches a generic particle effect to our Mesh for long lasting damage effects, e.g. electricity or fire
 * changed to allow multiple to be attached at the same time up to 6; not replicated
 */
simulated final function AttachDamageFX(ParticleSystem Template, name AttachPoint, float Duration, optional vector RelLocation,optional rotator RelRotation,optional vector RelScale)
{
	local DamageFX DFX;
	local INT Iter, AvailableIndex;
	local FLOAT MinTime;

	AvailableIndex = INDEX_NONE;

	// pick the one not attached if any
	for (Iter=0; Iter<MAX_DAMAGE_FX; ++Iter)
	{
		DFX = AttachedDamageFXs[Iter];

		// if still none, use this
		if (DFX.AttachedFX==none)
		{
			DFX.AttachedFX = new(self) class'ParticleSystemComponent';
			AvailableIndex = Iter;
			break;
		}
		// if not used any more
		else if (!DFX.AttachedFX.bAttached)
		{
			AvailableIndex = Iter;
			break;
		}
	}

	// if everything is attached, detach the shortest one that's going to be detached
	if ( AvailableIndex == INDEX_NONE )
	{
		MinTime = WorldInfo.TimeSeconds + 10000.f;

		for (Iter=0; Iter<MAX_DAMAGE_FX; ++Iter)
		{
			DFX = AttachedDamageFXs[Iter];
			if ( MinTime > DFX.DetachTime )
			{
				MinTime = DFX.DetachTime;
				AvailableIndex = Iter;
			}
		}

		DFX = AttachedDamageFXs[AvailableIndex];
		// find the one that's shortest
		Mesh.DetachComponent(DFX.AttachedFX);
	}

	DFX.AttachedFX.SetTemplate(Template);
	DFX.DetachTime = WorldInfo.TimeSeconds + Duration;
	// copy back to original array
	AttachedDamageFXs[AvailableIndex] = DFX;
	if (Mesh.GetSocketByName(AttachPoint) != None)
	{
		Mesh.AttachComponentToSocket(DFX.AttachedFX, AttachPoint);
	}
	else
	{
		Mesh.AttachComponent(DFX.AttachedFX, AttachPoint, RelLocation, RelRotation, RelScale);
	}

	// if timer isn't active, activate it
	if (IsTimerActive(nameof(StopAttachedDamageFX)) == FALSE)
	{
		// timer tends to come earlier than desired, so add buffer to it.
		SetTimer(Duration, false, nameof(StopAttachedDamageFX));
	}

	// if we have next timer to be later than this new duration,
	// this can cause issue
	// TODO: if this becomes issue to you, we just need to recalc next timer here
}

/** turns off the currently active damage effect */
simulated final function StopAttachedDamageFX()
{
	local INT Iter;
	local FLOAT CurTime, NextTime;
	local DamageFX DFX;

	CurTime = WorldInfo.TimeSeconds;
	NextTime = CurTime + 1000.f;
	for (Iter=0; Iter<MAX_DAMAGE_FX; ++Iter)
	{
		DFX = AttachedDamageFXs[Iter];

		// if attached, check it's time to detach
		if (DFX.AttachedFX!=none && DFX.AttachedFX.bAttached)
		{
			if (DFX.DetachTime <= CurTime)
			{
				Mesh.DetachComponent(DFX.AttachedFX);
				DFX.AttachedFX.SetTemplate(None);
			}
			// otherwise find if we should set new timer
			else if ( DFX.DetachTime - NextTime < 0)
			{
				NextTime = DFX.DetachTime;
			}
		}
	}

	// if we have next timer, set new timer
	if (NextTime < CurTime + 1000.f)
	{
		SetTimer(NextTime-CurTime, false, nameof(StopAttachedDamageFX));
	}
}

/** plays some attack audio */
function PlayAttackYell()
{
	if (WorldInfo.Game != None)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Scream, self, None, 0.0);
	}
}

/**
 * Sets the weapon skin from a weapon they picked up
 *
 * @param WeaponSkin the skin to be copied
 *
 * @return the skin to use or none if none is set
 */
simulated function SetWeaponSkinFromPickup(const out CoolSkin WeaponSkin)
{
	local GearPRI PRI;
	local CoolSkin ConfiguredSkin;

	// Check if the user already has this weapon skin as a default
	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		PRI.GetWeaponSkinParametersForClass(WeaponSkin.WeapClass,ConfiguredSkin);
	}
	// If they don't match, overwrite one of our dropped slots
	// One of these should always be available because dropping clears one
	if (ConfiguredSkin != WeaponSkin)
	{
		// Check the primary weapon
		if (PrimaryPickedupWeaponSkin.WeapClass == WeaponSkin.WeapClass ||
			PrimaryPickedupWeaponSkin.WeapClass == None)
		{
			PrimaryPickedupWeaponSkin = WeaponSkin;
		}
		// And now the secondary
		else if (SecondaryPickedupWeaponSkin.WeapClass == WeaponSkin.WeapClass ||
				 SecondaryPickedupWeaponSkin.WeapClass == None)
		{
			SecondaryPickedupWeaponSkin = WeaponSkin;
		}
	}
}

/**
 * Returns the weapon skin for the specified class based upon customized weapon they picked up
 *
 * @param WeapClass the weapon class that wants to be customized
 *
 * @return the skin to use or none if none is set
 */
simulated function MaterialInterface GetWeaponSkinFromPickup(class<GearWeapon> WeapClass)
{
	// Check the primary weapon
	if (PrimaryPickedupWeaponSkin.WeapClass == WeapClass)
	{
		if (PrimaryPickedupWeaponSkin.WeaponSkinIndex < WeapClass.default.WeaponSkins.Length)
		{
			return WeapClass.default.WeaponSkins[PrimaryPickedupWeaponSkin.WeaponSkinIndex];
		}

		return WeapClass.default.Mesh.GetMaterial(0);
	}
	// And now the secondary
	if (SecondaryPickedupWeaponSkin.WeapClass == WeapClass)
	{
		if (SecondaryPickedupWeaponSkin.WeaponSkinIndex < WeapClass.default.WeaponSkins.Length)
		{
			return WeapClass.default.WeaponSkins[SecondaryPickedupWeaponSkin.WeaponSkinIndex];
		}

		return WeapClass.default.Mesh.GetMaterial(0);
	}
	return None;
}

/**
 * Returns the weapon skin for the specified class based upon customized weapon they picked up
 *
 * @param WeapClass the weapon class that wants to be customized
 *
 * @return the skin to use or none if none is set
 */
simulated function MaterialInterface GetWeaponSkinForClass(class<GearWeapon> WeapClass)
{
	local MaterialInterface SkinMat;
	local GearPRI PRI;

	// Check for the pawn having picked up a weapon
	SkinMat = GetWeaponSkinFromPickup(WeapClass);
	if (SkinMat == None)
	{
		// If the user has selected a weapon skin to use, choose that one
		PRI = GearPRI(PlayerReplicationInfo);
		if (PRI == None)
		{
			if (DrivenVehicle != None)
			{
				PRI = GearPRI(DrivenVehicle.PlayerReplicationInfo);
			}
			else if (GearPawn_SilverbackBase(Base) != None)
			{
				PRI = GearPRI(GearPawn_SilverbackBase(Base).PlayerReplicationInfo);
			}
		}

		if (PRI != None)
		{
			SkinMat = PRI.GetWeaponSkinForClass(WeapClass);
		}
	}
	// This is the default weapon skin
	if (SkinMat == None)
	{
		SkinMat = WeapClass.default.Mesh.GetMaterial(0);
	}
	return SkinMat;
}

/**
 * Returns the full weapon skin parameters for the specified class based upon a user's customization
 *
 * @param WeapClass the weapon class that wants to be customized
 * @param SkinParams the skin data that will be filled in
 *
 * @return true if there was a skin assigned for that weapon, false otherwise
 */
simulated function bool GetWeaponSkinParametersForClass(class<GearWeapon> WeapClass,out CoolSkin SkinParams)
{
	local GearPRI PRI;

	// Check the primary weapon
	if (PrimaryPickedupWeaponSkin.WeapClass == WeapClass)
	{
		SkinParams = PrimaryPickedupWeaponSkin;
		return true;
	}
	// And now the secondary
	else if (SecondaryPickedupWeaponSkin.WeapClass == WeapClass)
	{
		SkinParams = SecondaryPickedupWeaponSkin;
		return true;
	}
	// If the user has selected a weapon skin to use, choose that one
	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		return PRI.GetWeaponSkinParametersForClass(WeapClass,SkinParams);
	}
	return false;
}

/**
 * Returns the full weapon skin parameters to their default state
 *
 * @param WeapClass the weapon class that is being dropped
 */
simulated function ClearWeaponSkinParametersForClass(class<GearWeapon> WeapClass)
{
	local CoolSkin NoSkin;

	// Check the primary weapon
	if (PrimaryPickedupWeaponSkin.WeapClass == WeapClass)
	{
		PrimaryPickedupWeaponSkin = NoSkin;
	}
	// And now the secondary
	else if (SecondaryPickedupWeaponSkin.WeapClass == WeapClass)
	{
		SecondaryPickedupWeaponSkin = NoSkin;
	}
}

/**
 * Updates the gun skin when a repnotify happens
 */
simulated function UpdateWeaponSkin()
{
	if ( MyGearWeapon != None &&
		(MyGearWeapon.Class == PrimaryPickedupWeaponSkin.WeapClass || MyGearWeapon.Class == SecondaryPickedupWeaponSkin.WeapClass) )
	{
		UpdateWeaponSkinForMesh(MyGearWeapon.Class, MyGearWeapon.Mesh, MyGearWeapon.MIC_WeaponSkin);
	}
}


/**
 * Updates the specified mesh with the skin for that weapon class
 *
 * @param WeapClass the weapon being updated
 * @param MeshComp the mesh component being updated
 */
simulated function MaterialInstanceConstant UpdateWeaponSkinForMesh(class<GearWeapon> WeapClass, MeshComponent MeshComp, optional out MaterialInstanceConstant MIC_WeaponSkin)
{
	local MaterialInterface SkinMat;
	local CoolSkin WeaponSkin;

	// Create a new MIC based off of the new data
	MIC_WeaponSkin = new(outer) class'MaterialInstanceConstant';
	SkinMat = GetWeaponSkinForClass(WeapClass);
	MIC_WeaponSkin.SetParent(SkinMat);
	// Get any extra items we need
	if (GetWeaponSkinParametersForClass(WeapClass,WeaponSkin))
	{
		// Apply all parameters
		if (WeaponSkin.bRequiresParameters)
		{
			// Set all of the scalar parameters
			MIC_WeaponSkin.SetScalarParameterValue('Emmis_amount',WeaponSkin.Emmis_amount);
			MIC_WeaponSkin.SetScalarParameterValue('PatternTile',WeaponSkin.PatternTile);
			MIC_WeaponSkin.SetScalarParameterValue('ReflectionSmoothness',WeaponSkin.ReflectionSmoothness);
			MIC_WeaponSkin.SetScalarParameterValue('SpecPower',WeaponSkin.SpecPower);
			// Set all of the vector parameters
			MIC_WeaponSkin.SetVectorParameterValue('BaseDiffuseColor',WeaponSkin.BaseDiffuseColor);
			MIC_WeaponSkin.SetVectorParameterValue('MetalColorCracks',WeaponSkin.MetalColorCracks);
			MIC_WeaponSkin.SetVectorParameterValue('MetalColorSurface',WeaponSkin.MetalColorSurface);
			MIC_WeaponSkin.SetVectorParameterValue('SpecularColor',WeaponSkin.SpecularColor);
			MIC_WeaponSkin.SetVectorParameterValue('TopReflectionColor',WeaponSkin.TopReflectionColor);
			MIC_WeaponSkin.SetVectorParameterValue('PatternColor01',WeaponSkin.PatternColor01);
			MIC_WeaponSkin.SetVectorParameterValue('PatternColor02',WeaponSkin.PatternColor02);
		}
	}
	// Set the skin last
	MeshComp.SetMaterial(0,MIC_WeaponSkin);

	return MIC_WeaponSkin;
}

/** get the difficulty/intelligence level to use for this AI */
final function EDifficultyLevel GetDifficultyLevel()
{
	return GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel;
}

/** Return true if this pawn is considered to be in the valid play area */
function bool IsInPlayArea()
{
	if( class'NavigationHandle'.static.GetPylonFromPos( Location ) == None )
	{
		return FALSE;
	}
	return TRUE;
}

/** Need to get LastTakeHitInfo **/
simulated function TakeHitInfo GetLastTakeHitInfo()
{
	return LastTakeHitInfo;
}

defaultproperties
{
	MeatShieldMorphBlendTime=0.4f
	MeatShieldTargetWeight=1.f
	EffectCount=0
	bAlwaysRelevant=TRUE  // we want to make our pawns always relevant as our levels are small enough and it solves the issues of being shot by a non relevant pawn where you still take damage but don't get a damage locator

	HeadSocketName="Head"
	RightHandSocketName="RightHand"
	LeftHandSocketName="LeftHand"

	PelvisBoneName="b_MF_Pelvis"
	PickupFocusBoneName="b_MF_Weapon_L_End"
	PickupFocusBoneNameKickup="b_MF_Weapon_R_End"

	FullBodyNodeName="Custom_FullBody"

	CharacterFootStepType=CFST_Generic

	AttachSlots(EASlot_Holster)=(SocketName="Holster")
	AttachSlots(EASlot_Belt)=(SocketName="Belt1")
	AttachSlots(EASlot_LeftShoulder)=(SocketName="LeftBackMount")
	AttachSlots(EASlot_RightShoulder)=(SocketName="RightBackMount")

	ControllerClass=class'GearAI'
	InventoryManagerClass=class'GearInventoryManager'
	SoundGroup=GearSoundGroup'GearSoundGroupArchetypes.GSG_Empty'
	MeleeRange=+20.0
	bMuffledHearing=TRUE

	bBlockActors=TRUE
	bBlocksNavigation=TRUE

	ViewPitchMin=-12000
	ViewPitchMax=10000

	Buoyancy=+000.99000000
	UnderWaterTime=+00020.000000
	BaseEyeHeight=+00060.000000
	EyeHeight=+00060.000000
	CrouchHeight=+64.0
	CrouchRadius=+34.0
	GroundSpeed=+00300.000000
	AirSpeed=+00600.000000
	WaterSpeed=+00300.000000
	AccelRate=+02048.000000
	JumpZ=+00540.000000
	bCanStrafe=TRUE
	bCanSwim=TRUE
	RotationRate=(Pitch=45000,Yaw=45000,Roll=45000)
	AirControl=+0.35
	bCanCrouch=FALSE

	bJumpCapable=FALSE
	bCanJump=FALSE
	bStopAtLedges=TRUE
	bAvoidLedges=TRUE
	bCanDoStepsSmoothing=TRUE
	bCanClimbLadders=TRUE
	bCanPickupInventory=TRUE
	bCanPickupFactoryWeapons=TRUE
	SightRadius=+12000.0

	DurationBeforeDestroyingDueToNotBeingSeen=8.0

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		BlockZeroExtent=FALSE
	End Object

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		LightShadowMode=LightShadow_Modulate
		bSynthesizeSHLight=TRUE
		bUseBooleanEnvironmentShadowing=FALSE
		ModShadowFadeoutTime=0.75f
		bIsCharacterLightEnvironment=TRUE
		bAllowDynamicShadowsOnTranslucency=TRUE
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=SkeletalMeshComponent Name=GearPawnMesh
		BlockZeroExtent=TRUE
		//BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=false,BlockingVolume=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		LightEnvironment=MyLightEnvironment
		MinDistFactorForKinematicUpdate=0.2
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
		bCullModulatedShadowOnBackfaces=FALSE
		bAllowAmbientOcclusion=FALSE
		MotionBlurScale=0.0
		bUpdateSkelWhenNotRendered=TRUE
		bIgnoreControllersWhenNotRendered=FALSE
		bTickAnimNodesWhenNotRendered=TRUE
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=TRUE
	End Object
	Mesh=GearPawnMesh
	Components.Add(GearPawnMesh)

	bTranslateMeshByCollisionHeight=TRUE
	MeshTranslationNudgeOffset=3.f

	WalkingPct=+0.5
	MovementPct=1.0
	CoverMovementPct=(0.f,1.0f,1.0f)
	CoverProtectionFOV=(X=60,Y=30)

	MaxStepHeight=40.f

	// used primarily for AI in gears (to determine how high of a ledge AI can walk off of safely during pathfinding)
	LedgeCheckThreshold=60.0f

	LastCoverTime=-999.f
	LastCoverActionTime=-999.f
	NextCoverActionTime=0.f // KEEP default as ZERO!

	// Animation
	bUsesBodyStances=TRUE
	bCanDo360AimingInCover=TRUE
	bCanDoRun2Cover=TRUE
	bCanPlayHeadShotDeath=FALSE
	bPlayDeathAnimations=FALSE
	bTargetingNodeIsInIdleChannel=FALSE
	MovementAimOffsetInterp=(BlendTime=0.33f)

//	bRevive=true
	bNoEncroachCheck=TRUE

	PathSearchType=PST_Constraint

	SpecialMoveClasses(SM_DeathAnim)=class'GSM_DeathAnim'
	SpecialMoveClasses(SM_Engage_Matinee)=class'GSM_EngageMatinee'

	LastShotAtTime=-9999.f
	LastMeleeAttackTime=-9999.f
	LastWeaponStartFireTime=-9999.f
	LastWeaponEndFireTime=-9999.f
	ForcedAimTime=-9999.f

	Begin Object Class=GearCameraShake Name=Run2CoverCameraShake0
		OscillationDuration=0.6f
		RotOscillation={(Pitch=(Amplitude=50.f,Frequency=60.f),
						Yaw=(Amplitude=50.f,Frequency=0.f),
						Roll=(Amplitude=120.f,Frequency=205.f))}
		LocOscillation={(X=(Amplitude=4.f,Frequency=30.f),
						Y=(Amplitude=2.f,Frequency=20.f),
						Z=(Amplitude=2.f,Frequency=20.f))}
		FOVOscillation=(Amplitude=2.f,Frequency=5.f)
	End Object
	Run2CoverCameraShake=Run2CoverCameraShake0
	Run2CoverMaxCameraShakeDistSqThreshold=16000
	Run2CoverMinCameraShakeDistSqThreshold=1000

	CoverActionSpecialMoves=(SM_MantleUpLowCover,SM_CoverSlip,SM_MantleKick,SM_MidLvlJumpOver,SM_StdLvlSwatTurn,SM_EvadeFromCoverCrouching,SM_EvadeFromCoverStanding,SM_PushObject,SM_PushCover)
	ActionSpecialMoves=(SM_ReviveTeammate,SM_LadderClimbDown,SM_LadderClimbUp,SM_TradeWeapons_Leader,SM_CQCMove_CurbStomp)

	// Physics Hit Reaction
	PhysicsImpactBlendOutTime=0.45f
	PhysicsHitReactionImpulseScale=1.f
	PhysicsImpactMassEffectScale=0.9f
	PhysHRMotorStrength=(X=5000,Y=0)
	PhysHRSpringStrength=(X=5,Y=5)
	bEnableHitReactionBoneSprings=TRUE
	bCanPlayPhysicsHitReactions=TRUE

	PawnRotationInterpolationTime=0.15f
	bCanDoTurnInPlaceAnim=TRUE

	LoadedGUDBank=-1

	Begin Object Class=AudioComponent Name=FaceAudioComponent
	End Object
	FacialAudioComp=FaceAudioComponent
	Components.Add(FaceAudioComponent)

	// Hit Gore mask component
	Begin Object Class=SceneCapture2DHitMaskComponent Name=HitMaskComp
	End Object
	HitMaskComponent=HitMaskComp
	Components.Add(HitMaskComp)
	HitMaskMultiplier = 1.f

	NoticedGUDSPriority=1
	NoticedGUDSEvent=GUDEvent_NoticedEnemyGeneric

	BS_Junker_Driving_Idle=(Stance=((Slot=BS_FullBody,AnimName="Driver_Idle")))
	BS_Junker_Passenger_A_Idle=(Stance=((Slot=BS_FullBody,AnimName="Passenger_A_Idle")))
	BS_Junker_Passenger_B_Idle=(Stance=((Slot=BS_FullBody,AnimName="Passenger_B_Idle")))

	BS_HeadCoverLoop={(Stance=((Slot=BS_Std_Up,AnimName="AR_Injured_Headcover1_Idle"),
		(Slot=BS_CovStdIdle_Up,AnimName="AR_Injured_Headcover1_Idle"),
		(Slot=BS_CovMidIdle_Up,AnimName="AR_Injured_Headcover1_Idle"))
	)}

	HeadChunks(00)=StaticMesh'COG_Gore.Head_Chunk11' // this is the head
	HeadChunks(01)=StaticMesh'COG_Gore.Head_Chunk2'
	HeadChunks(02)=StaticMesh'COG_Gore.Head_Chunk3'
	HeadChunks(03)=StaticMesh'COG_Gore.Head_Chunk4'
	HeadChunks(04)=StaticMesh'COG_Gore.Head_Chunk5'
	HeadChunks(05)=StaticMesh'COG_Gore.Head_Chunk6'
	HeadChunks(06)=StaticMesh'COG_Gore.Head_Chunk7'
	HeadChunks(07)=StaticMesh'COG_Gore.Head_Chunk8'
	HeadChunks(08)=StaticMesh'COG_Gore.Head_Chunk9'
	HeadChunks(09)=StaticMesh'COG_Gore.Head_Chunk10'
	HeadChunks(10)=StaticMesh'COG_Gore.Head_Chunk1'
	HeadChunks(11)=StaticMesh'COG_Gore.Head_Chunk12'
	HeadChunks(12)=StaticMesh'COG_Gore.Head_Chunk13'
	HeadChunks(13)=StaticMesh'COG_Gore.Head_Chunk14'
	HeadChunks(14)=StaticMesh'COG_Gore.Head_Chunk15'

	GibKillDistance=2048.0f

	SuperDamageMultiplier=1.f

	PS_RoadieRun=ParticleSystem'War_Level_Effects2.Smoke.P_Player_RoadieRun_Dust'
	PS_BurnEffect=ParticleSystem'COG_HOD.Effects.P_HOD_Burn'

	LastTeamNum=255
	GUDLineRepeatMin=30.0f
	MinTimeBetweenAnyGUDS=4.f

	CameraNoRenderCylinder_High_ViewTarget=(Radius=50,Height=86)
	CameraNoRenderCylinder_Low_ViewTarget=(Radius=50,Height=36)
	CameraNoRenderCylinder_High=(Radius=40,Height=88)
	CameraNoRenderCylinder_Low=(Radius=40,Height=44)
	CameraNoRenderCylinder_FlickerBuffer=(Radius=4,Height=4)
	bBlockCamera=TRUE

	CrouchedFrictionCylinder=(Radius=64.f,Height=40.f)

	bKillDuringLevelTransition=TRUE
	HealthRechargeStartSound=SoundCue'Interface_Audio.Interface.BurstDamageStop01Cue'

	MPHeadOffset=(X=3,Y=-2,Z=0)
	MPHeadRadius=12

	DBNO_BloodCrawlSpurtTemplate=ParticleSystem'Effects_Gameplay.Blood.P_Blood_DBNO_Crawl'
	GoreImpactParticle=ParticleSystem'Effects_Gameplay.Blood.P_Blood_groundimpact_bodypart'
	bShowFatalDeathBlood=TRUE

	GibEffectsSpeedThreshold=125.0
	TimeBetweenGibEffects=0.25
	DeadBodyImpactThreshold = 10.0;

	LastCringeTime=-999999
	LastCoverGuessTime=-99999

	bReplicateRigidBodyLocation=TRUE

	OnFireBlazingParticleSystem=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_Body_Burn_Death'
	OnFireBlazingBurningSound=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_FireBodyLoop_Cue'
	OnFireBlazingBurningSound_Player=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_FireBodyLoopStereo_Cue';
	OnFireBurningParticleSystem=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_Body_Burn_1'
	OnFireBurningSound=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_FireLegsLoop_Cue'
	OnFireSmolderParticleSystem=ParticleSystem'FX_Flamethrower.Particles.P_FX_Flamethrower_BodyBurn_01'
	OnFireSmolderingBurningSound=SoundCue'Foley_Flesh.Flesh.Flesh_SmolderingFireCue'
	OnFireBlazingInkParticleSystem=ParticleSystem'Weap_Ink_Grenade.FX.P_Weap_Ink_Grenade_Player_Trail'
	OnFireBlazingInkBurningSound=SoundCue'Ambient_Loops.Fires.fire_small08Cue'                  // @fixme need real


// Taking out for now as it's annoying, might put it back later if we need it
// 	GrabCoverSound=SoundCue'Foley_bodymoves.BodyMoves.SquadArmImpactBody_Cue'
	ReleaseCoverSound=SoundCue'Human_Marcus_Efforts.Efforts.MarcusLandLightCue'
// Taking out for now as it's annoying, might put it back later if we need it
// 	MovingCoverSound=SoundCue'Human_Marcus_Efforts.Efforts.MarcusBreathRodieCue'

//ImulsionParticleSystem=ParticleSystem'FX_Flamethrower.Particles.P_FX_Flamethrower_BodyBurn_01'
	ImulsionParticleSystem=ParticleSystem'LOC_Drudge.Effects.head.P_Player_Burn_Smoke_Ash'
	ImulsionBurningSound=SoundCue'Ambient_Loops.Water_G2.water_waterfalllarge01Cue'

	SimpleDeathEffect=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Crowd_Gib_Medium'
	SimpleDeathEffectNonGore=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Crowd_Gib_Medium_NoGore'
	SimpleDeathEffectScale=1.0

	bAllowDamageModification=true
	bCanRecoverFromDBNO=true
	bModifyReachSpecCost=true
	bRespondToExplosions=true
	bCanBeRunOver=true
	bCanTriggerGrenadeTrap=true

	bAllowInventoryDrops=true
	bAllowHitImpactDecalsOnSkelMesh=false
	bSpawnHitEffectDecals=true
	bSpawnBloodTrailDecals=true
	NumConstraintEffectsSpawnedMax=4

	bDisableDeathScreams=false

	MaxFallSpeed=+10000.0
	AIMaxFallSpeedFactor=1.0

	SkinHeatFadeTime=0.4f
	SkinHeatFadeDelay=0.3f
	SkinHeatDamagePctToFullyHeat=0.3f
	CurrentSkinHeatMin=0.0f
	SkinCharFadeTime=1.f
	MaxIgnitionSkinHeat=1.0

	SightBoneName="LookingDirection"

	GearPawnFXClass=class'GearPawnFX'

	bAllowTurnSmoothing=TRUE
	TurningRadius=32.f
	AccelConvergeFalloffDistance=400.f
	bAllowAccelSmoothing=TRUE
	RagdollPushForce=0.5

	bAllowAutoRevive=true

	bNeedsBaseTickedFirst=TRUE	// Needed for floor conform, so base is updated before our animation.
	bCanDoFloorConform=FALSE
	bDoFloorConform=TRUE
	bDoFullMeshFloorConform=FALSE
	FloorConformAverageFloorNormal=(X=0,Y=0,Z=1.f)
	FloorConformMaxSlopeAngle=40.f
	MeshFloorConformToggleAlpha=(BlendTime=0.42f,BlendType=ABT_Cubic)
	MeshFloorConformMovementAlpha=(BlendType=ABT_Linear)
	IKFloorConformMovementAlpha=(BlendType=ABT_Linear)
	bDoIKFloorConformCOM=TRUE
	IKFloorConformCOMLimits=(X=25,Y=25)
	IKFloorConformCOMSpeed=(X=50,Y=50,Z=50)
	IKFloorConformCOMDamping=(X=10,Y=10,Z=10)
	IKFloorConformCOMWeight=0.5f
	bDoFootPlacement=FALSE
	FootPlacementAlpha=(BlendTime=0.42f,BlendType=ABT_Cubic)
	LegAdjustInterpSpeedMoving=36.f
	LegAdjustInterpSpeedStopped=128.f
	bDoIKFloorConformTorsoBending=FALSE
	IKFloorConformTorsoQuatWorld=(X=0,Y=0,Z=0,W=1)
	IKFloorConformTorsoQuatLocal=(X=0,Y=0,Z=0,W=1)

	SpeechPitchMultiplier=1.f

	ShootingThroughWallTraceDistance=1000.f

	HordeEnemyEntry=(Index=INDEX_NONE)

	ProhibitedFindAnchorPhysicsModes=(PHYS_Flying,PHYS_Interpolating)

	CorpseMaxLifeSpan=20.f

	// This is disabled because it causes players to shoot up when dbno/ragdoll killed
	bDoDeathUpKick=false

	bShouldChainsawAttackInstantKillMe=true
	bCanRechargeHealth=false
	bReplicateHealthToAll=false
	bCanBeHealed=true

	HeadScale=1.0

	DefaultBloodEffectTemplate=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Full_LOD_Med_Hit'
	BloodLowHitTemplate=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Full_LOD_Low_Hit'
	BloodGoreExplosionTemplate=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Full_LOD_Death'
	BloodGoreConstraintBrokenTemplate=ParticleSystem'Effects_Gameplay.Blood.P_Blood_flying_bodypart'
	ShotgunCameraLensEffectTemplate=class'Emit_CameraBlood_ShotGun'
	HeadshotBloodTemplate=ParticleSystem'Effects_Gameplay.Blood.P_Blood_HeadShot'

	PS_GiantBladeDamageEffect=ParticleSystem'Locust_Lambent_Boomer.Effects.P_Stab_Blood'
	PS_GiantBladeFromAboveDamageEffect=ParticleSystem'Locust_Lambent_Boomer.Effects.P_Stab_Down_Blood'

	VehicleCheckRadius=100.0
	PlayerDamageMod=1.0

	RecentHitTime=5.0f

	ExtentPercentageForLedgeChecks=0.5f

	BumpGDODamageType=class'GDT_BumpGDO'

	ReviveStageAnims(0)=( ReviveAnims[ERAT_RECOVER]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_Start"))), ReviveAnims[ERAT_FAIL]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_Fail_Early"))), ReviveAnims[ERAT_LOOP]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_Loop_1"))), LoopTime=4.0f )
	ReviveStageAnims(1)=( ReviveAnims[ERAT_RECOVER]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_Mid"))), ReviveAnims[ERAT_FAIL]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_Fail"))), ReviveAnims[ERAT_LOOP]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_Loop_2"))), LoopTime=0.1f )
	ReviveStageAnims(2)=( ReviveAnims[ERAT_RECOVER]=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Recover_End"))) )

	MTO_SpecialMoveSpeed = 3

	TeamBeacon=Texture2D'Warfare_HUD.HUD.T_PlayerIndicator'
	TeamBeaconTalking=Texture2D'Warfare_HUD.T_PlayerIndicator_Voice'
	MaxFullSizeBeaconDist=512.0
	MinSizeBeaconDist=2048.0
	MaxTeamBeaconSize=12.0

	BigHeadVoicePitch=1.25
	CringeDurationMult=1.0
}
