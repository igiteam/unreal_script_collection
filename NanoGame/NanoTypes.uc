/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
* This will hold all of our enums and types and such that we need to
* use in multiple files where the enum can't be mapped to a specific file.
*/
class NanoTypes extends GameTypes
	native
	abstract
	config(Game);

struct native AccelCurve
{
	var float 				Time;
	var float				Accumulation;
	var rotator				RotationOffset;
	var float				GroundScale;
	var float				AirScale;
	var float				MaxAccel;
	var float				MaxSpeed;
	var InterpCurveVector	AccelCurve;
};

enum EComboJoyDirection
{
	CJD_None,
	CJD_Right,
	CJD_Left,
	CJD_Up,
	CJD_Down,
	CJD_Any,
};

enum ECondMeleePhysics
{
	CMP_Any,
	CMP_Ground,
	CMP_Air,
};

struct native TargetSortInfo
{
	var Actor Target;
	var float Rating;
};

enum ETargetQueryType
{
	TQT_None,
	TQT_MeleeAttack,
	TQT_GunAttack,
};


/**
 * The types of root motion curves we have to play with
 **/
enum ERootMotionCurveType
{
	RMCT_None,
	RMCT_FastThenSlow,
	RMCT_MoreSteadyMovementBack,
	RMCT_SlowThenFast,
	RMCT_FastToSlowToFastToSlow
};


// check out NanoMeleeWeaponSheet MeleeHitReactionItem  for where all of these vars originally come from
// this is filled out from: NanoMeleeWeaponSheet.PushReactionToHitReactionInfo
struct native HitReactionInfo
{
	var() Name  AnimName;
	var() float PlayRate;
	var() float Position;
	var() bool	bAI_MeleeDisengage;
	var() float EndPositionOffset;
	var() float BlendInTime;
	var() float BlendOutTime;

	// looped anim
	var Name            AnimNameStart;
	var Name            AnimNameLoop;
	/** How long we should loop for **/
	var float           AnimLoopTime;
	var Name            AnimNameEnd;


	/** Whether or not the foe is stunned after they have played the Hit Animation **/
	var bool            bPostHitReactionStunned;
	var float           PostHitReactionStunTime;
	var Name            PostHitReactionStunAnimName;

	var ERootMotionCurveType OverrideRootMotionCurveType;
	var() ERootMotionMode   RootMotionMode;
	var() ERootBoneAxis	    RootBoneOption[3];
	var() float             RootMotionScale;

	var() Vector HitLocation;
	var() Vector HitNormal;
	var() Vector HitDirection;

	var() EPhysics	    PhysicsOnStart;
	var() Vector        VelocityOnStart;

	var() Pawn      Attacker;
	var() byte      AttackPriority;

	structdefaultproperties
	{
		RootMotionScale=1.f
	}
};

// RB Channels
//	RBCC_Untitled1 = DUSTED OBJECTS
//  RBCC_Untitled2 = DUST VOLUMES
//	RBCC_Untitled3 = BUSTABLE ACTOR

/** Set of possible camera transitions */
enum ENanoCameraTransition
{
	ENCT_None,
	ENCT_FirstPerson,		// Transition to first person
	ENCT_ForceFirstPerson,	// Immediate transition to first person
	ENCT_ThirdPerson,		// Transition to third person
	ENCT_ForceThirdPerson,	// Immediate transition to third person
	ENCT_Done,				// Completed the transition, should reset
};

enum ENanoCameraTransitionState
{
	ENCTS_None,			// Normal
	ENCTS_Transition,	// Actively transitioning using transition bone
	ENCTS_Interp,		// Lerping toward the destination camera bone
};

/** The set of NanoStates that the Pawn can be in **/
enum ENanoState
{
	ENS_Normal, // just running around the worldstate
	ENS_Dust,	// when you are dusting (or the other become gaseous powers)  (NOTE: you are not really a gas but more a cloud / incorporeal)
	ENS_Dense,  // when you are busting (or the other become dense powers)
	ENS_MAX, 
};

/** Enumerated types of nano skills.  Used primarily for replication.  Every new nano skill base class should have a unique entry here */
enum ENanoSkills
{
	NS_Absorb,
	NS_Agility,
	NS_Bamf,
	NS_Dash,
	NS_Dense,
	NS_Ghost,
	NS_Jump,
	NS_Melee,
	NS_Ping,
	NS_Tornado,
	NS_VehicleOverride,
	NS_Grapple,
	NS_Health,
	NS_Hacking,
	NS_DenseBash,
	NS_NanoBuckets,
};

/** Which slot a plan belongs to */
enum ENanoPlanSlot
{
	EPS_Gun,
	EPS_Melee,
	EPS_Utility,
	EPS_WeaponModifications
};

/** Indicates different types of interaction */
enum ENanoInteractType
{
	ENIT_Default,
	ENIT_AbsorbBegin,
	ENIT_AbsorbEnd,
	ENIT_TouchInteract
};

/** What kind of dashing the player is in */
enum EDashPip
{
	EDP_Walking,
	EDP_Dash1,
	EDP_Dash2,
	//EDP_Dash3,
	EDP_DroppingHammer,
	EDP_DroppingHammer2,
	EDP_Never,
	EDP_MAX
};

enum EDirection
{
	DIR_Left,
	DIR_Right,
	DIR_Up,
	DIR_Down,
	DIR_None // this should be the zeroth
};

enum ESafeZoneViolation
{
	SZV_None,
	SZV_Left,
	SZV_Right,
	SZV_Up,
	SZV_Down,
	SZV_Rear,
	SZV_Front,
};

enum EMantleType
{
	MANTLE_None,
	MANTLE_Ledge,
	MANTLE_Waist,
	MANTLE_WaistRoll,
	MANTLE_WallRun,
	MANTLE_Jump,
	MANTLE_EndingMantle,
	MANTLE_BigStep,
	MANTLE_FlipJump,
	MANTLE_ChestHigh,
	MANTLE_Hurdle,
	MANTLE_StepDown,
	MANTLE_AntennaRun,
	MANTLE_WallStick,
};

enum EPawnInteractionType
{
	PAWNINTER_None,
	PAWNINTER_Grab,
	PAWNINTER_GrabAndBeat,
	PAWNINTER_Pin,
	PAWNINTER_Evade,
	PAWNINTER_Tackle,
};

enum EPerchType
{
	PT_Point,
	PT_HorzPole,
};

/** Enum to describe color of a traffic light */
enum ETrafficLightState
{
	ETLS_Red,
	ETLS_Green
};


/* Contains information for this plan's UI icon */
struct native NanoIconData
{
	/** the path name to the texture or material for the weapon icon */
	var		Texture2D			IconTex;

	/** optional texture coordinates for use when referring to a texture atlas. */
	var		TextureCoordinates	Coords;
};

enum EActionType
{
	/** Default value of the action system */
	AT_None,
	/** Kismet induced button icon **/
	AT_KismetButton,
	/** Looking at something */
	AT_ForceLook,
	/** Available force looks, etc */
	AT_Scripted,
	/** Looking at a player */
	AT_Player,
	/** When performing an action that puts us in a different state, like ValveTurning */
	AT_StateAction,
	/** Vehicles, turrets, etc */
	AT_Vehicle,
	/** Doors, buttons, etc */
	AT_Trigger,
	/** Pickups */
	AT_Pickup,
	/** Movable Objects */
	AT_MovableObject
};

/**
 *	Structure to hold arrays since we can't have arrays of arrays
 */
struct native ActionIconData
{
	var array<CanvasIcon> ActionIcons;
};

/**
 * Information for drawing an action.
 */
struct native ActionInfo
{
	/** Type of action for reference/prioritization */
	var transient EActionType ActionType;
	/** Identifier for this action */
	var Name ActionName;
	/** List of icons drawn left->right, centered based on total width */
	var array<ActionIconData> ActionIconDatas;
	/** Spacing to add between icons */
	var float IconSpacing;

	/** Is it currently active? */
	var transient bool bActive;
	/** Current blend percent */
	var transient float BlendPct;
	/** Cached draw info */
	var transient bool bCached;
	var transient float SizeX, SizeY;

	/** Text (tooltip) drawn at center based on total width like the icons */
	var string TooltipText;
	/** Index into the engine's AdditionalFonts array for the font to use. */
	var int FontIndex;

	/** Duration before this action automatically turns off */
	var float AutoDeActivateTimer;
	/** Time at which this action was activated */
	var transient float ActivateTime;

	/** Whether to mirror the icons or not */
	var bool bMirror;

	/** speed the icons will switch for animating */
	var float IconAnimationSpeed;

	// structdefaultproperties used to have:
	//		TooltipFont=Font'Warfare_HUD.HUD.UIfont-chromosome-heavy-big'
	// Now, we replace with WarfareFonts.Fonts.WarfareFonts_Chrom24
	structdefaultproperties
	{
		AutoDeActivateTimer=1.f
		IconAnimationSpeed=0.0f
	}
};

struct native DecalData
{
	/** Used internally for validate the struct contains useful data */
	var bool bIsValid;

	/** Material and any other properties that are needed for impact decals */
	var() MaterialInterface DecalMaterial;

	/** Determines whether or not to use the fast decal attach path which WILL clip when hitting multiple BSP pieces.  Large decals should NOT use this as they will look really bad **/
	var() bool ClipDecalsUsingFastPath;

// 	/** Width of the decal**/
// 	var() RawDistributionFloat Width;
// 	/** Height of the decal**/
// 	var() RawDistributionFloat Height;
// 	/** Thickness of the decal**/
// 	var() RawDistributionFloat Thickness;

	/** Width of the decal **/
	var() float Width;
	/** Height of the decal **/
	var() float Height;
	/** Thickness of the decal (used to calculate the nearplane/farplane values) **/
	var() float Thickness;

	/** Whether decal should randomly alter rotation */
	var() bool bRandomizeRotation;

	/** Range of Percentages that the decal should be randomly scaled **/

	/** Range of Percentages that the decal should be randomly scaled **/
	var() vector2d RandomScalingRange;

	/**
	 * This is the range in units that that effect should be offset from the trace start.  (e.g. if we are tracing straight down this will
	 * cause the trace to start off center)
	 * This value should be the number of units for the radius of possible offset.
	 **/
	var() float RandomRadiusOffset;


	/** How long the decal should last before completely being gone (i.e. if we have a 10 second fade this needs to include that amount) **/
	var() float LifeSpan;

	/** Start/End blend range specified as an angle in degrees. Controls where to start blending out the decal on a surface */
	var() vector2d BlendRange;

	/** To allow a decal spawn, no other decals of this type can be within this distance.**/
	var() float CanSpawnDistance;

	// we don't want to add the object overhead for using these :-(  And we don't want to add the rand() cost for every time when not all will use it.  And we don't want to add an if check each time also.   so we will ponder what to do
	// 		Begin Object Class=DistributionFloatConstant Name=DistributionWidth
	// 			Constant=6.0;
	// 		End Object
	// 		Width=(Distribution=DistributionWidth)
	//
	// 		Begin Object Class=DistributionFloatConstant Name=DistributionHeight
	// 		    Constant=6.0;
	// 		End Object
	// 		Height=(Distribution=DistributionHeight)
	//
	// 		Begin Object Class=DistributionFloatConstant Name=DistributionThickness
	// 			Constant=10.0;
	// 		End Object
	// 		Thickness=(Distribution=DistributionThickness)

	structdefaultproperties
	{
		ClipDecalsUsingFastPath=TRUE

		Width=6.0f
		Height=6.0f
		Thickness=10.0f

		bRandomizeRotation=TRUE

		RandomScalingRange=(X=1.0f,Y=1.2f)

		LifeSpan=15.0f

		BlendRange=(X=70,Y=89.5)

		CanSpawnDistance=10.0f
	}

	structcpptext
	{
		/** Constructors */
		FDecalData() 
		{}
		FDecalData(EEventParm)
		{
			appMemzero(this, sizeof(FDecalData));
		}
		FDecalData(ENativeConstructor)
		: ClipDecalsUsingFastPath(TRUE)
		, Width(6.0f)
		, Height(6.0f)
		, Thickness(10.0f)
		, bRandomizeRotation(TRUE)
		, RandomScalingRange(1.0f,1.2f)
		, LifeSpan(15.0f)
		, BlendRange(70.f,89.5f)
		, CanSpawnDistance(10.0f)
		{}
	}
};


/** These are the Tracer Types we utilize.  Named after what they look like. **/
enum EWeaponTracerType
{
	WTT_LongSkinny,
	WTT_ShortBullet,
};


// list of all the game buttons for the sake of input handling
//@note - if you re-order this list at all you'll need to update NanoPlayerInput.ButtonMappings and NanoPlayerInput.UpdateJoystickInputs()
enum EGameButtons
{
	GB_A,
	GB_X,
	GB_Y,
	GB_B,
	GB_Start,
	GB_Back,
	GB_LeftTrigger,
	GB_LeftBumper,
	GB_RightTrigger,
	GB_RightBumper,
	GB_DPad_Up,
	GB_DPad_Left,
	GB_DPad_Down,
	GB_DPad_Right,
	GB_LeftStick_Push,
	GB_RightStick_Push,
	GB_LeftStick_Up,
	GB_LeftStick_Down,
	GB_LeftStick_Left,
	GB_LeftStick_Right,
	GB_RightStick_Up,
	GB_RightStick_Down,
	GB_RightStick_Left,
	GB_RightStick_Right,
	GB_Max,
};

struct native InputBufferItem
{
	/** Button this item is buffering */
	var() EGameButtons  Button;
	/** World time the button was pressed */
	var() float         Time;
};

/**
 * Enumeration of the various WeaponClass used mainly for indexing the FXInfo array in NanoPhysicalMaterialProperty at the moment
 * we are going to use this for random explosions also so it is not just weapons
 *
 * NOTE:  If any new types are added they must be added at the end as the the NanoPhysicalMaterialProperty indexes into an array with these enums
 */
enum EWeaponClass
{
	WC_MP5, // Pistol Locust
	WC_MP7,
	WC_GrenadeNano,
	WC_NanoSword,

	// !!!! add NEW entries below here !!!!
};



enum EImpactTypeBallistic
{
	ITB_None,
	ITB_MP7,
	ITB_NanoSword,
	// !!!! add NEW entries below here !!!!
};


enum EImpactTypeExplosion
{
	ITE_None,
	ITE_NanoGrenade,
	ITE_GrenadeSmoke,
	// !!!! add NEW entries below here !!!!
};




/** Enumeration of the various weapons used mainly for indexing the FXInfo array in NanoPhysicalMaterialProperty at the moment */
enum ECharacterFootStepType
{
	NFST_Generic,
	NFST_Lyrik,
	NFST_Owen,
	NFST_MetaCorp_Generic,

	// !!!! add NEW entries below here !!!!
};

enum ENanoDecalType
{
	NDTT_None,
	NDTT_Blood_GenericSplat,
	NDTT_ExitWoundSplatter,
	NDTT_GibExplode_Ceiling,
	NDTT_GibExplode_Ground,
	NDTT_GibExplode_Ground_SmallSplat,
	NDTT_GibExplode_Wall,
	NDTT_GibImpact,
	NDTT_GibTrail,
	NDTT_HitByBulletSmallSplat,
	NDTT_LimbBreak,
	NDTT_NeckSpurt,
	NDTT_PawnIsReallyHurtSmallSplat,
	// specialized for nano
	NDTT_SwordSlice,
	NDTT_SwordSliceBloodDrops,
	NDTT_SwordSliceBloodSprayBackSplash,
	NDTT_SwordSliceBloodSprayLanding,
	NDTT_BloodPool
	// !!!! add NEW entries below here !!!!
};

/** Types of button displays supported by the SeqAct_ToggleButtonMash kismet action */
enum eNanoKismetIconType
{
	eNANOBUTTON_A,
	eNANOBUTTON_A_MASH,
	eNANOBUTTON_B,
	eNANOBUTTON_B_MASH,
	eNANOBUTTON_X,
	eNANOBUTTON_Y,
	eNANOBUTTON_ChainsawMash,
};

// Don't reorder these as that will confuse Live
enum EDifficultyLevel
{
	DL_Casual,
	DL_Normal,
	DL_Hardcore,
	DL_Insane,
};

/** Enum of all of the multiplayer game modes */
enum ENanoMPTypes
{
	eNANOMP_Race,
	eNANOMP_CTF,
	eNANOMP_TDM,
};

/** Enum of all of the races in Nanos */
enum ENanoRaceTypes
{
	eNANORACE_Protagonist,
	eNANORACE_MetaCorp,
};

/** Enum of icons to be shown above NPC heads */
enum EHeadIconType
{
	EHIT_Nothing,
	EHIT_Exclamation,
	EHIT_Question
};

/** Enum of all of the tutorials in the game */
enum ENanoTutorialType
{
	NANOTUT_Objectives,
};

enum ENanoAct
{
	NANOACT_I,
	NANOACT_II,
	NANOACT_III,
	NANOACT_IV,
	NANOACT_V,
	NANOACT_DLC1,	// Potential DLC Act
	NANOACT_DLC2,	// Potential DLC Act
	NANOACT_DLC3,	// Potential DLC Act
};

enum EChapterPoint
{
	CHAP_Tutorial_Welcome,
};

/**
 * The kinds of progress that a player can make towards various goals (these are rewarded with toasts).
 */
enum EProgressType
{
	ePROG_Achievement,
	ePROG_Collectible, //A.K.A Discoverable
	ePROG_Unlockable
};

/** Enum of all the discoverable in gears */
enum ENanoDiscoverableType
{
	eDISC_None,
};

/** List of unlockables in Nanos2 */
enum ENanoUnlockable
{
	eUNLOCK_InsaneDifficulty,
	eUNLOCK_Character_None, // Used for datastores to determine if a character is/is not unlockable
};

/** All of the achievements in the game */
enum ENanoAchievement
{
	eGA_Invalid,
};

/** Enum of all the maps the game will ship with (needed for achievement tracking) */
enum ENanoMapsShipped
{
	eNANOMAP_None,
	eNANOMAP_MP1,
	eNANOMAP_MP2,
	eNANOMAP_MP3,
	eNANOMAP_MP4,
	eNANOMAP_MP5,
	eNANOMAP_MP6,
	eNANOMAP_MP7,
	eNANOMAP_MP8,
	eNANOMAP_MP9,
	eNANOMAP_MP10,
};


/**
* prioritization of different types of speech.
* used to determine what interrupts what.	lowest to highest.
*/
enum ESpeechPriority
{
	Speech_None,
	Speech_Effort,
	Speech_GUDS,
	Speech_Scripted,
	Speech_Immediate,
};

enum ESpeechInterruptCondition
{
	/** interrupt if request is higher pri than current (this is the default, keep it at zero) */
	SIC_IfHigher,
	/** never interrupt */
	SIC_Never,
	/** interrupt if request is same or higher priority than current */
	SIC_IfSameOrHigher,
	/** always interrupt */
	SIC_Always
};

enum ESpeakLineBroadcastFilter
{
	/** No filtering, everyone can hear the speech. */
	SLBFilter_None,
	/** Only the speaking players can hear. */
	SLBFilter_SpeakerOnly,
	/** Only the speaking player and his teammates can hear. */
	SLBFilter_SpeakerTeamOnly,
	/** Only the speaking player and the addressee can hear. */
	SLBFilter_SpeakerAndAddresseeOnly,
};


/** struct to store the date and time the checkpoint was created */
struct native CheckpointTime
{
	var int SecondsSinceMidnight;
	var int Day;
	var int Month;
	var int Year;
};


/** Enum of the memory slots used in the campaign */
enum EGearCampaignMemorySlot
{
	eGEARCAMPMEMORYSLOT_0,
	eGEARCAMPMEMORYSLOT_1,
	eGEARCAMPMEMORYSLOT_2,
};

struct native SafeZoneCheckLocInfo
{
	var Vector	WorldSpaceLoc;
	var Vector4	ScreenSpaceLoc;
	var float	ScreenSpaceW;
	var float	WorldSpaceDepth;
};

/** Struct containing violation information for a single world space check location */
struct native SafeZoneViolationInfo
{
	/** World space position of the point violating the safe zone */
	var Vector	WorldSpaceCheckLoc;
	/** Screen space position of the point violating the safe zone */
	var Vector4 ScreenSpaceCheckLoc;
	/** W value of the screen space location before normalizing -- used to get back to proper worldspace position */
	var float	ScreenLocW;
	/** Min/Max screen space corners of safe zone */
	var Vector4 SafeZoneScreenMin, SafeZoneScreenMax;
	/** Min/Max screen space corners of adjusted safe zone - where it tries to interp to when main bounds fail */
	var Vector4 SafeZoneScreenAdjustMin, SafeZoneScreenAdjustMax;
	/** Screen space violation values -- U == (+)right/(-)left, V == (+)up/(-)down */
	var float	U, V;
	/** World space violation behind the camera (value is negative) */
	var float	W;

	var bool	bForceFullCorrection;

	structcpptext
	{
		FSafeZoneViolationInfo()
		{
			U = 0.f;
			V = 0.f;
			W = 0.f;
		}
		UBOOL IsZero() { return (U==0.f && V==0.f && W==0.f); }

		FORCEINLINE FLOAT & operator[]( INT ComponentIndex )
		{
			return (&U)[ ComponentIndex ];
		}
		FORCEINLINE FLOAT operator[]( INT ComponentIndex ) const
		{
			return (&U)[ ComponentIndex ];
		}
	}
};

struct native SafeZoneItem
{
	var() Name						ZoneName;
	var() class<SafeZoneInfo>		ZoneClass;

	/** Instance of the zone class */
	var() editinline SafeZoneInfo	Zone;
};

/**
* Struct for holding any data needed by the UI when representing or manipulating multiple checkpoints at once.  Eliminates the need
* to mount and unmount the savegame device to check each checkpoint individually.
*/
struct native transient CheckpointEnumerationResult
{
	var		byte				bCheckpointFileExists[EGearCampaignMemorySlot];
	var		byte				bCheckpointFileContainsData[EGearCampaignMemorySlot];
	var		byte				bCheckpointFileCorrupted[EGearCampaignMemorySlot];
	var		CheckpointTime		CheckpointTimestamp[EGearCampaignMemorySlot];
	var		EDifficultyLevel	CheckpointDifficulty[EGearCampaignMemorySlot];
	var		EChapterPoint		CheckpointChapter[EGearCampaignMemorySlot];

	structcpptext
	{
		FCheckpointEnumerationResult()
		{
			appMemzero(this, sizeof(FCheckpointEnumerationResult));
		}
		FCheckpointEnumerationResult(EEventParm)
		{
			appMemzero(this, sizeof(FCheckpointEnumerationResult));
		}
	}
};


/** Defines the current move the player is doing */
enum ESpecialMove
{
	SM_None,
};

// Each one of these has 100 points in it
enum EChaosTier
{
	ECT_Tier0,
	ECT_Tier1,
	ECT_Tier2,
	ECT_Tier3,
	ECT_Tier4,
	ECT_Tier5,
	ECT_MAX
};

/** Entry in chaos history */
struct native ChaosChangeHistoryInfo
{
	var name  ChaosZoneName;
	var string	ChaosChangeCause;
	var int		ChaosChange;
	var float	ChaosChangeTime;
};

/** Used to indicate button pressed during sword attack combos */
enum EComboButton
{
	COMBOBUTTON_HIGH,
	COMBOBUTTON_LOW
};

/** Useful set of colors for chaos tiers */
var Color   ChaosTierColor[5];

/**
 * This is a list of Physical Materials that are in the vast majority of maps.
 * By referencing them here we will not have to duplicate them into all of the maps and will save diskpace
 **/
var const array<PhysicalMaterial> AlwaysReferencedPhysMaterials;


enum EConfrontationType
{
	ECFT_None,
	ECFT_Melee_Attacking,
	ECFT_Melee_Engaged,
	ECFT_Melee_Standby,
	ECFT_Melee_Spectator,
	ECFT_Ranged,  // this will be extended to have "viewer, shooter, call outs ("you on the roof stop!")
	ECFT_RangedCloser, 
	ECFT_RooftopSentinel,
};

/** These are the types of impacts we have.  Used for different sounds and different impact effects. **/
enum EMeleeImpactType
{
	EMIT_Sword, // this needs to be the Default as most of our hits are going to be sword, and some sword blood on things is a good starting point
	EMIT_Baton,
	EMIT_ElbowLeft,
	EMIT_ElbowRight,
	EMIT_FootLeft,
	EMIT_FootRight,
	EMIT_Staff,
	EMIT_Knife
};

struct native SkillInfoItem
{
	var() class<NanoSkill>               SkillClass;
	var() int                            SkillLevel;
	var() transient editinline NanoSkill Skill;
};

/** Single struct to handle all info for aim offset profiles */
struct native NanoAimOffsetProfile
{
	var()   Name    ProfileName;

	/** Number of degrees from center to transition to from forward to rear */
	var()   float   TransDegrees_FrontToRear_Right, TransDegrees_FrontToRear_Left;
	/** Number of degrees from center to transition to from rear to forward */
	var()   float   TransDegrees_RearToFront_Right, TransDegrees_RearToFront_Left;
};


/** Location for adding new things to give to the player as rewards **/
struct native RewardDatum
{
	/** This is the amount of currency gained from absorbing this orb **/
	var(Reward) int CurrencyGained;

	/** This is the amount of nano power buckets gained from absorbing this orb **/
	var(Reward) int NanoPowerBucketsGained;

	/** This is the amount of nano power forge core buckets gained from absorbing this orb **/
	var(Reward) int NanoPowerForgeCoreBucketsGained;

	/** This is the amount of rebel mind share gained from absorbing this orb **/
	var(Reward) int RebelMindShareGained;

	/** This is the amount of XP gained from absorbing this orb **/
	var(Reward) int XPGained;

	/** This is the DataPlan for this mission. **/
	var(Reward) class<NanoPlan> DataPlan;

	/** If the **/
	var(Reward) bool bShouldUnlockPlan;

};


struct native MeleeListDatum
{
	var int NumMeleeEngage;
	var int NumMeleeStandby;
	var int NumMeleeSpectator;
	var int NumRangedShooter;
	var int NumShootingAtOnce;
	var int NumShootingAtOnceWhenEscaping;
	var int NumMeleeFireTickets;
};


enum ETimeOfDay
{
	ETOD_Sunrise,
	ETOD_Morning,
	ETOD_Noon,
	ETOD_Afternoon,
	ETOD_Sunset,
	ETOD_Night,
	ETOD_Midnight,
	ETOD_MiddleOfNight
};


/** Used to pass information for drawing a NanoHUDElement_Minimap */
struct native MinimapDrawInfo
{
	/** Upper left location (normalized to screen width) */
	var()   vector2d    Minimap_UL;

	/** Size of the minimap */
	var()   vector2d    MinimapSize;

	/** unreal units per canvas width */
	var()   float       MinimapToWorldScale;

	/** If we should draw border on minimap */
	var()   bool        bDrawBorder;

	/** Location in world space to center map on */
	var()   vector      MinimapLocation;

	/** Rotation of map (in degrees) */
	var()   float       MinimapRotation;

	/** If TRUE, show things that are above/below player as alternating arrow */
	var()   bool        bEnableAboveBelowIcons;

};


/** 
 * This is our "it is painful to add new functions to interfaces due to no default implementation" 
 * struct work around.  Also, for all our various "firing" logic we have a myriad of data that we want to pass around
 * and probably have some helper utility functions / calculations based on a bunch of different values.
 **/
struct native FiringTargetableDatum
{
	var bool bIsDashing;
	/** When this pawned started dashing **/
	var float LastDashStartTime;
	/** If the FireTarget is stunned or not.  We usually don't want to attack tesla shock stunned foes. **/
	var bool bIsTeslaShockStunned;
};



/** Utility to fire a NanoStateChanged event on the supplied actor. */
static function FireNanoStateChangeEvent(Actor ChangedActor, Actor Instigator, ENanoState NewState)
{
	local SequenceEvent Evt;
	local SeqEvt_NanoStateChanged StateEvt;
	local array<int> ActivateIndices;

	// Set which output to fire
	if(NewState == ENS_Normal)
	{
		ActivateIndices[0] = 0;
	}
	else if(NewState == ENS_Dust)
	{
		ActivateIndices[0] = 1;
	}
	else if(NewState == ENS_Dense)
	{
		ActivateIndices[0] = 2;
	}

	// Look for 'nano state changed' event on actor that changed.
	foreach ChangedActor.GeneratedEvents(Evt)
	{
		StateEvt = SeqEvt_NanoStateChanged(Evt);
		if (StateEvt != None)
		{
			StateEvt.CheckActivate(ChangedActor, Instigator, FALSE, ActivateIndices);
		}
	}
}

/** This will set the material to the default state (i.e. neither dusted nor densed **/
static simulated function SetMaterialInstanceToDefault( out MaterialInstanceConstant MIC )
{
	MIC.SetScalarParameterValue( 'Dense', 1.0 );
	MIC.SetScalarParameterValue( 'Dust', 1.0 );
}


/** This will set the material to look like it has been dusted **/
static simulated function SetMaterialInstanceToDusted( out MaterialInstanceConstant MIC )
{
	MIC.SetScalarParameterValue( 'Dense', 1.0 );
	MIC.SetScalarParameterValue( 'Dust', 0.0 );
}


/** This will set the material to look like it has been densed **/
static simulated function SetMaterialInstanceToDensed( out MaterialInstanceConstant MIC )
{
	MIC.SetScalarParameterValue( 'Dense', 0.0 );
	MIC.SetScalarParameterValue( 'Dust', 1.0 );
}

/** Util to return a color for a given chaos level. */
static simulated function color GetColorForChaosTier(EChaosTier Tier)
{
	local color TempColor;

	if(Tier < 0 || Tier > 4)
	{
		TempColor.R = 255;
		TempColor.G = 255;
		TempColor.B = 255;
		return TempColor;
	}
	else
	{
		return default.ChaosTierColor[Tier];
	}
}

static simulated function FillHitReactionInfo
( 
	out HitReactionInfo out_HRI, 
	Name AnimName, 
	float PlayRate, 
	optional float  Position = 0.f, 
	optional float  BlendInTime = 0.f, 
	optional float  BlendOutTime = 0.1f, 
	optional float  EndPositionOffset = 0.f, 
	optional Vector HitLoc, 
	optional Vector HitDir,
	optional Byte   AttackPriority
)
{
	out_HRI.AnimName = AnimName;
	out_HRI.PlayRate = PlayRate;
	out_HRI.Position = Position;
	out_HRI.BlendInTime = BlendInTime;
	out_HRI.BlendOutTime = BlendOutTime;
	out_HRI.EndPositionOffset = EndPositionOffset;
	out_HRI.bAI_MeleeDisengage = TRUE;
	out_HRI.AttackPriority = AttackPriority;

	out_HRI.HitLocation = HitLoc;
	out_HRI.HitDirection = HitDir;
}


// Given rotation R1 and R2 in the same space, return R1 in R2's space
static native function rotator RInverseTransform( const out rotator R1, const out rotator R2 );

/** This will return the user name of the currently playing user. **/
static native function String GetLocalPlayerUserName();

/** Get a timestamp string for the current time */
static native function string GetTimestampForCurrentTime();

/** Get how many seconds from TimestampA until TimestampB */
static native function int GetSecondsBetweenTimestamps(string TimestampA, string TimestampB);


defaultproperties
{
	AlwaysReferencedPhysMaterials.Add( PhysicalMaterial'NanoPhysMats.Stone' )
	AlwaysReferencedPhysMaterials.Add( PhysicalMaterial'NanoPhysMats.Wood' )
	
	ChaosTierColor[0]=(R=128,G=255,B=128) // green
	ChaosTierColor[1]=(R=128,G=128,B=255) // blue
	ChaosTierColor[2]=(R=255,G=255,B=0) // yellow
	ChaosTierColor[3]=(R=255,G=128,B=0) // orange
	ChaosTierColor[4]=(R=255,G=51,B=51) // red 
}
