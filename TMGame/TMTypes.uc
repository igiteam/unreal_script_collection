/**
 * This will hold all of our enums and types and such that we need to
 * use in multiple files where the enum can't be mapped to a specific file.
 * Also to make these type available to the native land without forcing objects to be native.
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMTypes extends Object
	native;


// list of all the game buttons for the sake of input handling
//@note - if you re-order this list at all you'll need to update GearPlayerInput.ButtonMappings and GearPlayerInput.UpdateJoystickInputs()
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

enum EImpactTypeBallistic
{
	ITB_None,
	ITB_Boltock, // Pistol Locust
	ITB_BrumakSideGun,
	ITB_BrumakSideGunOther,
	ITB_Gnasher, // Shotgun
	ITB_Hammerburst,
	ITB_KingRavenTurret,
	ITB_Lancer,  // COG Assault Rifle
	ITB_LocustBurstPistol,
	ITB_Longshot, // Sniper
	ITB_Minigun, // Heavy Weapon
	ITB_Scorcher, // Flamethrower
	ITB_Snub,  // Pistol COG
	ITB_TorqueBow,
	ITB_Troika,
	ITB_TyroTurrent,
	ITB_WretchMeleeSlash,
	ITB_WretchMelee,
	ITB_BrumakSideGunPlayer,
	// !!!! add NEW entries below here !!!!
};


enum EImpactTypeExplosion
{
	ITE_None,
	ITE_BoomerFlail,
	ITE_Boomshot,
	ITE_BrumakMainGun,
	ITE_BrumakRocket,
	ITE_CentaurCannon,
	ITE_GrenadeFrag,
	ITE_GrenadeGas,
	ITE_GrenadeInk,
	ITE_GrenadeSmoke,
	ITE_HOD,
	ITE_Mortar,  // Heavy Weapon
	ITE_ReaverRocket,
	ITE_RocketLauncherTurret,
	ITE_TorqueBowArrow,
	ITE_BrumakMainGunPlayer,
	// !!!! add NEW entries below here !!!!
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

/** replicated information on a hit we've taken */
// struct native TakeHitInfo
// {
// 	/** the amount of damage */
// 	var int Damage;
// 	/** the location of the hit */
// 	var vector HitLocation;
// 	/** how much momentum was imparted */
// 	var vector Momentum;
// 	/** the damage type we were hit with */
// 	var class<DamageType> DamageType;
// 	/** the bone that was hit on our Mesh (if any) */
// 	var name HitBone;
//
// 	/** the weapon that shot us */
// 	var Pawn				InstigatedBy;
// 	/** the bone that was hit on our Mesh (if any) */
// 	var byte				HitBoneIndex;
// 	/** the physical material that was hit on our Mesh (if any) */
// 	var PhysicalMaterial	PhysicalMaterial;
// };

/** replicated information on a hit we've taken */
struct native TMTakeHitInfo
{
	/** the amount of damage */
	var int Damage;
	/** the location of the hit */
	var vector HitLocation;
	/** how much momentum was imparted */
	var vector Momentum;
	/** the damage type we were hit with */
	var class<DamageType> DamageType;
	/** the bone that was hit on our Mesh (if any) */
	var name HitBone;
};

/**
 * Enumeration of the various WeaponClass used mainly for indexing the FXInfo array in GearPhysicalMaterialProperty at the moment
 * we are going to use this for random explosions also so it is not just weapons
 *
 * NOTE:  If any new types are added they must be added at the end as the the GearPhysicalMaterialProperty indexes into an array with these enums
 */
enum EWeaponClass
{
	WC_Boltock, // Pistol Locust
	WC_Boomshot,
	WC_BoomerFlail,
	WC_BrumakMainGun,
	WC_BrumakSideGun,
	WC_BrumakSideGunOther,
	WC_FragGrenade,
	WC_GasGrenade,
	WC_Gnasher, // Shotgun
	WC_HOD,
	WC_Hammerburst,
	WC_InkGrenade,
	WC_KingRavenTurret,
	WC_Lancer,  // COG Assault Rifle
	WC_Longshot, // Sniper
	WC_Minigun, // Heavy Weapon
	WC_Mortar,  // Heavy Weapon
	WC_Scorcher, // Flamethrower
	WC_SmokeGrenade,
	WC_Snub,  // Pistol COG
	WC_TorqueBow,
	WC_Troika,
	WC_TyroTurrent,
	WC_WretchMeleeSlash,
	WC_FragGrenadeExplosion,		// explosions
	WC_TorqueBowArrowExplosion,
	WC_MortarExplosion,
	WC_BoomshotExplosion,
	WC_BrumakRocketExplosion,
	WC_LocustBurstPistol,
	WC_CentaurCannon,
	WC_ReaverRocket,
	WC_RocketLauncherTurret,
	WC_Shield,
	// !!!! add NEW entries below here !!!!
	WC_MyLancer,
};

enum EGearAutoInitTutorialTypes
{
	eGAIT_None,
	eGAIT_SP,
	eGAIT_MP,
	eGAIT_Train1,
	eGAIT_Train2,
	eGAIT_Train3,
	eGAIT_Train4,
	eGAIT_Train5,
};

// Don't reorder these as that will confuse Live
enum EDifficultyLevel
{
	DL_Casual,
	DL_Normal,
	DL_Hardcore,
	DL_Insane
};

enum EActionType
{
	/** Default value of the action system */
	AT_None,
	/** Kismet induced button icon **/
	AT_KismetButton,
	/** Reviving and need to stay alive **/
	AT_StayingAlive,
	/** Reviving and want to blow self up **/
	AT_SuicideBomb,
	/** Knocked down by explosion / close range shot **/
	AT_KnockedDown,
	/** Downed Teammate tooltip */
	AT_DownedTeammate,
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
	/** Special moves */
	AT_SpecialMove,
	/** Doors, buttons, etc */
	AT_Trigger,
	/** Pickups */
	AT_Pickup,
	/** Movable Objects */
	AT_MovableObject,
	/** vehicle controls */
	AT_VehicleControl
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
		FontIndex=0//FONT_Chrom24
		IconAnimationSpeed=0.0f
	}
};

/** stores checkpoint information for held weapons */
struct InventoryRecord
{
	var string InventoryClassPath;
	var int SpareAmmoCount;
	var int AmmoUsedCount;
	var byte CharacterSlot;
	var bool bIsActiveWeapon;
};

/** Per-damagetype damage modifiers. Campaign/Horde only. */
struct native PerDamageTypeMod
{
	var config name DamageTypeName;
	var config float Multiplier;
};

/** These are the Tracer Types we utilize.  Named after what they look like. **/
enum EWeaponTracerType
{
	WTT_LongSkinny,
	WTT_ShortBullet,
	WTT_MinigunFastFiring,
	WTT_Hammerburst,
	WTT_Boltok,
	WTT_Brumak,
	WTT_Reaver,
	WTT_BrumakPlayer,
};

/** Enumeration of the various weapons used mainly for indexing the FXInfo array in GearPhysicalMaterialProperty at the moment */
enum ECharacterFootStepType
{
	CFST_Generic,
	CFST_COG_Dom,
	CFST_COG_Marcus,
	CFST_Locust_Drone,
	CFST_Locust_Ticker,
	CFST_Locust_Wretch,
	CFST_Locust_RideableBrumak,
	// !!!! add NEW entries below here !!!!
	CFST_PLA,
	CFST_Enemy
};

enum ECrossfadeType
{
	CFT_BeginningOfMeasure,
	CFT_EndOfMeasure
};


struct native MusicSegment
{
	/** Tempo in Beats per Minute. This allows for the specific segement to have a different BPM **/
	var() float TempoOverride;

	/** crossfading always begins at the beginning of the measure **/
	var ECrossfadeType CrossfadeRule;

	/**
	* How many measures it takes to crossfade to this MusicSegment
	* (e.g. No matter which MusicSegement we are currently in when we crossfade to this one we will
	* fade over this many measures.
	**/
	var() int CrossfadeToMeNumMeasuresDuration;

	var() SoundCue TheCue;

	structdefaultproperties
	{
		CrossfadeRule=CFT_BeginningOfMeasure;
		CrossfadeToMeNumMeasuresDuration=1
	}

};

struct native StingersForAMap
{
	var() SoundCue Died;
	var() SoundCue DoubleKill;
	var() SoundCue EnemyGrabFlag;
	var() SoundCue FirstKillingSpree;
	var() SoundCue FlagReturned;
	var() SoundCue GrabFlag;
	var() SoundCue Kill;
	var() SoundCue LongKillingSpree;
	var() SoundCue MajorKill;
	var() SoundCue MonsterKill;
	var() SoundCue MultiKill;
	var() SoundCue ReturnFlag;
	var() SoundCue ScoreLosing;
	var() SoundCue ScoreTie;
	var() SoundCue ScoreWinning;

};


struct native MusicForAMap
{
	/** Default Tempo in Beats per Minute. **/
	var() float Tempo;

	var() MusicSegment Action;
	var() MusicSegment Ambient;
	var() MusicSegment Intro;
	var() MusicSegment Suspense;
	var() MusicSegment Tension;
	var() MusicSegment Victory;
};

/** Live achievement defines (check TM3.spa.h for order)*/
enum ETMGameAchievements
{
	// Achievement IDs start from 1 so skip Zero
	ETMA_InvalidAchievement,
	ETMA_CAMPAIGN_CompleteAllTraining,
	ETMA_CAMPAIGN_DeployLeviathan,
	ETMA_CAMPAIGN_DefeatLauren,
	ETMA_CAMPAIGN_SignTreaty,
	ETMA_CAMPAIGN_DefeatSelig,
	ETMA_CAMPAIGN_LiandriMainframe,
	ETMA_CAMPAIGN_HijackDarkwalker,
	ETMA_CAMPAIGN_ControlTarydium,
	ETMA_CAMPAIGN_StealNecrisTech,
	ETMA_CAMPAIGN_ReachOmicron,
	ETMA_CAMPAIGN_DefeatLoque,
	ETMA_CAMPAIGN_SignTreatyExpert,
	ETMA_CAMPAIGN_LiandriMainframeExpert,
	ETMA_CAMPAIGN_ReachOmicronExpert,
	ETMA_CAMPAIGN_DefeatLoqueExpert,
	ETMA_CAMPAIGN_DefeatLaurenGodlike,
	ETMA_CAMPAIGN_DefeatSeligGodlike,
	ETMA_CAMPAIGN_DefeatMatrixGodlike,
	ETMA_CAMPAIGN_DefeatLoqueGodlike,
	ETMA_COOP_Complete1,
	ETMA_COOP_Complete10,
	ETMA_COOP_CompleteCampaign,
	ETMA_IA_EveryGameMode,
	ETMA_IA_Untouchable,
	ETMA_EXPLORE_AllPowerups,
	ETMA_EXPLORE_EveryMutator,
	ETMA_EXPLORE_EveryWeaponKill,
	ETMA_WEAPON_BrainSurgeon,
	ETMA_WEAPON_ShockTherapy,
	ETMA_WEAPON_GooGod,
	ETMA_WEAPON_Pistolero,
	ETMA_WEAPON_Hammerhead,
	ETMA_WEAPON_StrongestLink,
	ETMA_WEAPON_BombSquad,
	ETMA_WEAPON_BigGameHunter,
	ETMA_VEHICLE_Hoverboard,
	ETMA_VEHICLE_Armadillo,
	ETMA_VEHICLE_Gunner,
	ETMA_VEHICLE_Ace,
	ETMA_VEHICLE_Deathwish,
	ETMA_HUMILIATION_SerialKiller,
	ETMA_HUMILIATION_SirSlaysALot,
	ETMA_HUMILIATION_PathOfDestruction,
	ETMA_HUMILIATION_Deity,
	ETMA_VERSUS_GetItOn,
	ETMA_VERSUS_SameTeam,
	ETMA_VERSUS_Nemecide,
	ETMA_VERSUS_AroundTheWorld,
	ETMA_VERSUS_Dedication,
	ETMA_VERSUS_MeetInterestingPeople,
	ETMA_VERSUS_GetALife,
	ETMA_VERSUS_KillGetALifers,
	ETMA_RANKED_RememberYourFirst,
	ETMA_RANKED_DontHateThePlayer,
	ETMA_RANKED_MixItUp,
	ETMA_RANKED_HatTrick,
	ETMA_RANKED_BloodSweatTears,
	ETMA_RANKED_TenFootPole
};
