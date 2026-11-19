/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
* This will hold all of our enums and types and such that we need to
* use in multiple files where the enum can'y be mapped to a specific file.
*/
class GearTypes extends GameTypes
	native
	abstract
	config(Game);

/** one selection from an array in a Horde enemy list */
struct native EnemySelection
{
	var GearHordeEnemyList List;
	var int Index;
};

enum EGearSquadFormationType
{
	GSF_None,
	GSF_Column,
	GSF_Line,
};

struct native FormationPosition
{
	/** Name of position */
	var() Name	PosName;
	/** Position is relative to position index (-1 == Leader) */
	/** Note: must be an index less than this current position */
	var() int RelIdx;
	/** Ideal yaw offset to "foward" (as defined by leader) */
	var() int YawOffset;
	/** Ideal distance from leader position */
	var() float Distance;

	/** Ideal position in world space */
	var transient Vector	IdealPosition;

	/** Current point assigned to this position */
	var() transient Vector  ActualPosition;

	/** Current navigation point (not used if using nav mesh) assigned to this position */
	var() transient NavigationPoint Nav;

	/** Current AI controller assigned to this position */
	var() transient GearAI		AI;



	var() Color DebugColor;

	structdefaultproperties
	{
		RelIdx=-1
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

struct native ExplosionCameraData
{
	/** Shake to play when source is in front of the camera, or when directional variants are unspecified. */
	var() editinline CameraShake CamShake;

	/** Radius within which to play full-powered camera shake (will be scaled within radius) */
	var() float		                CamShakeInnerRadius;
	/** Between inner and outer radii, scale shake from full to zero */
	var() float		                CamShakeOuterRadius;
	/** Exponent for intensity falloff between inner and outer radii. */
	var() float		                CamShakeFalloff;

	/** TRUE to attempt to automatically do force feedback to match the camera shake */
	var() bool                      bAutoControllerVibration;
	/** TRUE to rotate CamShake to play radially relative to the explosion.  Left/Right/Rear will be ignored. */
	var() bool						bOrientCameraShakeTowardsEpicenter;
	/** Disables post process for the camera effect */
	var() bool bNoPostProcess;
	var() bool bNoMovement;
	/** Play only when explosion is on screen */
	var() bool bOnlyWhenVisible;
};

/** Tells the game code which direction to trace for a given decal */
enum EDecalTraceDir
{
	DECALTRACE_PosX,
	DECALTRACE_NegX,
	DECALTRACE_PosY,
	DECALTRACE_NegY,
	DECALTRACE_PosZ,
	DECALTRACE_NegZ
};

struct native DecalData
{
	/** Used internally for validate the struct contains useful data */
	var bool bIsValid;

	/** Material and any other properties that are needed for impact decals */
	var() MaterialInterface DecalMaterial;

	/** Determines whether or not to use the fast decal attach path which WILL clip when hitting multiple BSP pieces.  Large decals should NOT use this as they will look really bad **/
	var() bool ClipDecalsUsingFastPath;

	/** Width of the decal **/
	var() float Width;
	/** Height of the decal **/
	var() float Height;
	/** Thickness of the decal (used to calculate the nearplane/farplane values) **/
	var() float Thickness;

	/** Whether decal should randomly alter rotation */
	var() bool bRandomizeRotation;

	/** Range of Percentages that the decal should be randomly scaled **/
	var() vector2d RandomScalingRange;

	/**
	 * This is the range in units that that effect should be offset from the trace start.  (e.g. if we are tracing straight down this will
	 * cause the trace to start off center)
	 * This value should be the number of units for the radius of possible offset.
	 **/
	var() float RandomRadiusOffset;


	/** How long the decal should last before completely being gone (i.e. if we have a 10 second fade this needs to include that amount, -1 = infinite) **/
	var() float LifeSpan;

	/** Start/End blend range specified as an angle in degrees. Controls where to start blending out the decal on a surface */
	var() vector2d BlendRange;

	/** Just like LifeSpan but used when performance is slow (-1 = infinite) **/
	var() float LifeSpan_ForSlowPerf;

	structdefaultproperties
	{
		ClipDecalsUsingFastPath=TRUE

		Width=6.0f
		Height=6.0f
		Thickness=10.0f

		bRandomizeRotation=TRUE

		RandomScalingRange=(X=1.0f,Y=1.2f)

		LifeSpan=-1.0f

		BlendRange=(X=70,Y=89.5)
		LifeSpan_ForSlowPerf=15.0f
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
		, LifeSpan(-1.0f)
		, BlendRange(70.f,89.5f)
		, LifeSpan_ForSlowPerf(15.0f)
		{}
	}
};

/** Specifies a random range of values to pass to a material parameter */
struct native GearDecalParam
{
	/** The name of the parameter we are updating */
	var() name ParamName;
	/** The min value for the random value */
	var() float Min;
	/** The max value for the random value */
	var() float Max;
};

/** Ties a decal material to a direction of tracing */
struct native ExplosionDecal
{
	/** The direction to trace, relative to the explosion source (for example, relative to the direction a projectile was travelling) */
	var() EDecalTraceDir Dir;
	/** if set, trace direction is in world space */
	var() bool bWorldSpaceDir;
	/** How far to trace in the specified direction */
	var() float TraceDistance;
	/** The material to use for the decal */
	var() DecalData Decal;
	/** List of parameters to set to random values between a min/max range */
	var() array<GearDecalParam> Params;

	structdefaultproperties
	{
		TraceDistance=64.0
	}
};

/** Associates a camera lens effect with a min/max range so that we can choose the best effect based upon proximity */
struct native GearCameraLensEffect
{
	/** The lens effect to use if within the specified range */
	var() const class<EmitterCameraLensEffectBase> Effect;
	/** The min range before choosing this effect */
	var() const float MinRange;
	/** The max range after which the effect is skipped */
	var() const float MaxRange;
};

/** These are the Tracer Types we utilize.  Named after what they look like. **/
enum EWeaponTracerType
{
	WTT_LongSkinny,
	WTT_LongSkinnyAR,
	WTT_ShortBullet,
	WTT_MinigunFastFiring,
	WTT_Hammerburst,
	WTT_HammerburstAR,
	WTT_Boltok,
	WTT_Boltok_AR,
	WTT_Brumak,
	WTT_Reaver,
	WTT_BrumakPlayer,
	WTT_HammerburstLambent,
	WTT_Coop_Minigun,
	WTT_Gnasher,
	WTT_Gnasher_AR,
	WTT_Gorgon,
	WTT_Gorgon_AR,
	WTT_Lancer,
	WTT_Lancer_AR,
	WTT_Longshot,
	WTT_Mulcher,
	WTT_Oneshot,
	WTT_RetroLancer,
	WTT_RetroLancer_AR,
	WTT_SawedOff,
	WTT_SawedOff_AR,
	WTT_SnubPistol,
	WTT_SnubPistol_AR,
	WTT_Hammerburst_Reaver,
	WTT_MultiTurret_Hammerburst,
	WTT_MultiTurret_Lancer,
	WTT_MultiTurret_RetroLancer,
	WTT_Tempest,
	WTT_LancerOnyxGuard,
	WTT_TorqueMaxSpeed,
};


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

/** enumeration of the various WeaponClass used mainly for UI indexing */
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
	WC_ReaverRocket,
	WC_RocketLauncherTurret,
	WC_Shield,
	WC_IncendiaryGrenade,
	WC_HeavySniperRifle,
	WC_HeavyFlail,
	WC_SawedOffShotgun,
	WC_RetroLancer,
	WC_Box,
	WC_GasTank,
	WC_BlimpBallTurret,
	WC_LambentHammerburst,
	WC_Ripper,
	WC_Melee,
	WC_CoopMinigun,
	WC_Cleaver,
	WC_DiggerLauncher,
	WC_SecurityBotGun,
	WC_SilverbackMinigun,
	WC_SilverbackRocket,
	WC_MinigunTurret,
	WC_MultiLancer,
	WC_MultiRetro,
	WC_MultiHammerburst,
	WC_MultiBoomshot,
	WC_MultiGnasher,
	WC_DLC_Cobra,
	WC_MultiBoomshot_GasBarge,
	// !!!! add NEW entries below here !!!!
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
	ITB_HeavySniperRifle,
	ITB_RetroLancer,
	ITB_CleaverMelee,
	ITB_LambentHammerburst,
	ITB_SilverbackGatlingGun,
	ITB_BrumakSmash,
	ITB_Vulcan,
	ITB_SawedOff,
	ITB_Tempest,
	// !!!! add NEW entries below here !!!!
};


enum EImpactTypeExplosion
{
	ITE_None,
	ITE_BoomerFlail,
	ITE_Boomshot,
	ITE_BrumakMainGun,
	ITE_BrumakRocket,
	ITE_GrenadeFrag,
	ITE_GrenadeGas,
	ITE_GrenadeInk,
	ITE_GrenadeIncendiary,
	ITE_GrenadeSmoke,
	ITE_HOD,
	ITE_Mortar,  // Heavy Weapon
	ITE_ReaverRocket,
	ITE_RocketLauncherTurret,
	ITE_TorqueBowArrow,
	ITE_BrumakMainGunPlayer,
	ITE_GunkerGunk,
	ITE_GunkerShot,
	ITE_DrudgeSpit,
	ITE_TempestGoo,
	ITE_BlimpBall,
	ITE_CorpserLarvaMelee,
	// !!!! add NEW entries below here !!!!
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
	CFST_Locust_Kantus,
	CFST_Locust_ArmoredKantus,
	CFST_Locust_BloodMount,
	CFST_Locust_Berserker,
	CFST_Locust_Reaver,
	CFST_Locust_Serapede,
	// !!!! add NEW entries below here !!!!
};

enum EGearDecalType
{
	GDTT_Blood_GenericSplat,
	GDTT_Chainsaw_Ground,
	GDTT_Chainsaw_Wall,
	GDTT_DBNO_BodyHittingFloor,
	GDTT_DBNO_Smear,
	GDTT_ExitWoundSplatter,
	GDTT_GibExplode_Ceiling,
	GDTT_GibExplode_Ground,
	GDTT_GibExplode_Wall,
	GDTT_GibImpact,
	GDTT_GibTrail,
	GDTT_LimbBreak,
	GDTT_MeatBag_BloodSplatter,
	GDTT_MeatBag_FirstGrabbing,
	GDTT_MeatBag_HeelScuff,
	GDTT_NeckSpurt,
	GDTT_Wall_SlammingIntoCover,
	GDTT_Wall_Smear,
	GDTT_Wall_Smear_Mirrored,
	GDTT_GibExplode_Ground_SmallSplat,
	GDTT_BloodPool,
	GDTT_PawnIsReallyHurtSmallSplat,
	GDTT_HitByBulletSmallSplat,
	GDTT_ExecutionLong_PunchFace,
	GDTT_ExecutionLong_Sniper,
	GDTT_ExecutionLong_TorqueBow,
	GDTT_ExecutionLong_PistolWhip,
	GDTT_FlameThrower_StartFlameBlast,
	GDTT_FlameThrower_FlameIsBurning,
	GDDT_ReaverGibExplode,
	GDDT_IncendiaryGrenade_InitialBlastRound,
	GDDT_IncendiaryGrenade_InitialBlastWedge,
	GDDT_StickyFire,
	GDDT_StickyInk,
	GDDT_StickyInkLarge,
	GDDT_BerserkerImulsionTrail,
	GDDT_BerserkerJumpSplat,
	GDTT_DrudgeHeadWormTrail,
	GDTT_HeavySniperBlast,
	GDTT_SerapedeTailBlownOffSplat
	// !!!! add NEW entries below here !!!!
};


/** HUD control icon types
 * goes from highest priority to lowest priorty
 */
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
	/** Looking at something */
	AT_ForceLook,
	/** Available force looks, etc */
	AT_Scripted,
	/** Looking at a player */
	AT_Player,
	/** When performing an action that puts us in a different state, like ValveTurning */
	AT_StateAction,
	/** vehicle controls */
	AT_VehicleControl,
	/** Special moves */
	AT_SpecialMove,
	/** Doors, buttons, etc */
	AT_Trigger,
	/** Pickups */
	AT_Pickup,
	/** fortifications */
	AT_Fortification,
	/** Vehicles, turrets, etc */
	AT_Vehicle,
	/** Downed Teammate tooltip */
	AT_DownedTeammate,
	/** Movable Objects */
	AT_MovableObject,
	/** weapon actions */
	AT_WeaponActions,
	/** fortication melee */
	AT_FortificationMelee,
};

enum EFontType
{
	/** WarfareFonts.Fonts.WarfareFonts_Euro20 */
	FONT_Euro20,
	/** WarfareFonts.WarfareFonts_GameOVer2 */
	FONT_GameOver2,
	/** Warfare_HUD.WarfareHUD_font */
	FONT_HUD_GearHUD_font,
	/** Warfare_HUD.Xbox360_18pt */
	FONT_Xbox360_18pt,
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

	/** Whether to draw in the center of the screen */
	var bool bCenterY;

	/** Whether to draw just below the crosshair */
	var bool bDrawBelowCrosshair;

	/** speed the icons will switch for animating */
	var float IconAnimationSpeed;

	// structdefaultproperties used to have:
	//		TooltipFont=Font'Warfare_HUD.HUD.UIfont-chromosome-heavy-big'
	// Now, we replace with WarfareFonts.Fonts.WarfareFonts_Chrom24
	structdefaultproperties
	{
		AutoDeActivateTimer=1.f
		FontIndex=FONT_Euro20
		IconAnimationSpeed=0.0f
	}
};

/** Types of button displays supported by the SeqAct_ToggleButtonMash kismet action */
enum eGearKismetIconType
{
	eGEARBUTTON_A,
	eGEARBUTTON_A_MASH,
	eGEARBUTTON_B,
	eGEARBUTTON_B_MASH,
	eGEARBUTTON_X,
	eGEARBUTTON_Y,
	eGEARBUTTON_ChainsawMash,
};

// Don't reorder these as that will confuse Live
enum EDifficultyLevel
{
	DL_Casual,
	DL_Normal,
	DL_Hardcore,
	DL_Insane,
};

/** Enum of all of the multiplayer game modes (syncs with CONTEXT_VERSUSMODES in GearOnlineConstants.uci)*/
enum EGearMPTypes
{
	eGEARMP_Warzone,
	eGEARMP_Execution,
	eGEARMP_Horde,
	eGEARMP_Wingman,
	eGEARMP_KOTH,
	eGEARMP_CTL,
	eGEARMP_Newbie,
	eGEARMP_Siege,
};

/** Enum of the versus game settings that are used to configure the game */
enum EGearsVersusGameSetting
{
	eGEARVERSUSSETTING_WingmanScore,
	eGEARVERSUSSETTING_KOTHRoundScore,
	eGEARVERSUSSETTING_NoobRoundScore,
	eGEARVERSUSSETTING_EnemyDiff,
	eGEARVERSUSSETTING_HordeWave,
	eGEARVERSUSSETTING_RoundsToWin,
	eGEARVERSUSSETTING_RoundTime,
	eGEARVERSUSSETTING_NumBots,
	eGEARVERSUSSETTING_BotDiff,
	eGEARVERSUSSETTING_Bleedout,
	eGEARVERSUSSETTING_FriendlyFire,
	eGEARVERSUSSETTING_MapSelection,
	eGEARVERSUSSETTING_WeaponSwap,
	eGEARVERSUSSETTING_SiegeEnemyDiff,
	eGEARVERSUSSETTING_SiegeWave,
	// If this enum is altered:
	// 1) Make sure to handle the array in default properties of UIScene_FrontEnd.uc
	// 2) Increase the array size of the array in GearPartyGRI.uc
};

/** The different modes the campaign lobby can have */
enum EGearCampaignLobbyMode
{
	eGCLOBBYMODE_Error,
	eGCLOBBYMODE_Host,
	eGCLOBBYMODE_Join,
	eGCLOBBYMODE_Split,
	eGCLOBBYMODE_SoloPath,
};

/** Enum of all of the races in Gears */
enum EGearRaceTypes
{
	eGEARRACE_COG,
	eGEARRACE_Locust,
};

/** Structure to help pass the tutorial variable around */
struct native TutorialParams
{
	var int SPTut1;
	var int SPTut2;
	var int SPTut3;
	var int SPTut4;
	var int MPTut1;
	var int MPTut2;
	var int MPTut3;
	var int MPTut4;
	var int TrainTut1;
	var int TrainTut2;
	var int TrainTut3;
	var int TrainTut4;
	var int SiegeTut1;
	var int SiegeTut2;
	var int SiegeTut3;
	var int SiegeTut4;
};

/** Enum of the different auto-initialized tutorial modes supported */
Enum EGearAutoInitTutorialTypes
{
	eGAIT_None,
	eGAIT_SP,
	eGAIT_MP,
	eGAIT_Train1,
	eGAIT_Train2,
	eGAIT_Train3,
	eGAIT_Train4,
	eGAIT_Train5,
	eGAIT_Siege,
};

/** Enum of all of the tutorials in the game */
enum EGearTutorialType
{
	GEARTUT_Objectives,
	GEARTUT_Cover,
	GEARTUT_Fire,
	GEARTUT_Target,
	GEARTUT_ChangeWeapon,
	GEARTUT_Reload,
	GEARTUT_ActiveReload,
	GEARTUT_ActiveReloadBegin,
	GEARTUT_PointOfInterest,
	GEARTUT_Mantle1,
	GEARTUT_Mantle2,
	GEARTUT_Evade,
	GEARTUT_CoverSlip,
	GEARTUT_SwatTurn,
	GEARTUT_Use1,
	GEARTUT_Use2,
	GEARTUT_Grenades1,
	GEARTUT_Grenades2,
	GEARTUT_PlayerDamage,
	GEARTUT_Revive,
	GEARTUT_ChainsawMelee,
	GEARTUT_Ladder,
	GEARTUT_RoadieRun,
	GEARTUT_BlindFire,
	GEARTUT_AimFromCover,
	GEARTUT_Movement,
	GEARTUT_Executions,
	GEARTUT_MeatShield,
	GEARTUT_Crawling,
	GEARTUT_WeapMortar,
	GEARTUT_WeapLongshot,
	GEARTUT_Shield,
	GEARTUT_WeapHOD,
	GEARTUT_WeapBow,
	GEARTUT_Reaver,
	GEARTUT_Reaver2,
	GEARTUT_Brumak,
	GEARTUT_WeapSmokeGrenade,
	GEARTUT_WeapShotgun,
	GEARTUT_WeapPistol,
	GEARTUT_WeapMinigun,
	GEARTUT_WeapInkGrenade,
	GEARTUT_WeapHammerburst,
	GEARTUT_WeapFragGrenade,
	GEARTUT_WeapFlameThrower,
	GEARTUT_WeapBurstPistol,
	GEARTUT_WeapBoomshot,
	GEARTUT_WeapBoltok,
	GEARTUT_WeapAssaultRifle,
	GEARTUT_ReloadSimple,
	GEARTUT_ReloadSimpleEnd,
	GEARTUT_UnlimitedAmmo,
	GEARTUT_Sneak,
	GEARTUT_ObjectivesReminder,
	GEARTUT_WeapTurret,
	GEARTUT_Leader,
	GEARTUT_MeatBag,
	GEARTUT_ReviveAlly,
	GEARTUT_WeapCleaver,
	GEARTUT_WeapDigger,
	GEARTUT_WeapCoopMach,
	GEARTUT_WeapCoopMachAmmo,
	GEARTUT_WeapFlail,
	GEARTUT_WeapRocket,
	GEARTUT_WeapHeavySniper,
	GEARTUT_WeapIncendGrenade,
	GEARTUT_WeapRetroLancer,
	GEARTUT_WeapSawedOff,
	GEARTUT_CoopInteract,
	GEARTUT_DrudgeStalk,
	GEARTUT_SIEGE_Ticker,
	GEARTUT_SIEGE_Wretch,
	GEARTUT_SIEGE_Butcher,
	GEARTUT_SIEGE_Boomer,
	GEARTUT_SIEGE_Kantus,
	GEARTUT_SIEGE_Grenadier,
	GEARTUT_SIEGE_SavageBoomer,
	GEARTUT_SIEGE_Serapede,
	GEARTUT_SIEGE_ArmoredKantus,
	GEARTUT_SIEGE_GatlingBoomer,
	GEARTUT_SIEGE_FlailBoomer,
	GEARTUT_SIEGE_Berserker,
	GEARTUT_SIEGE_NakedTicker,
	GEARTUT_SIEGE_Drone,
	GEARTUT_SIEGE_MiniCorpser,
	GEARTUT_SIEGE_Bloodmount,
	GEARTUT_SIEGE_Reaver,
	GEARTUT_WeapMultiTurret,
	GEARTUT_SubTurret,
	GEARTUT_FortDestruction,
	GEARTUT_Silverback,
	GEARTUT_SilverbackDeployed,
	GEARTUT_SilverbackLoader,
	GEARTUT_Spotting,
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

/** Enum of all the discoverables in gears */
enum EGearDiscoverableType
{
	InvalidDiscoverable,
	Nightmare_CogTag,
	Ravens_Doms20,
	Ravens_DomsHealth,
	Ravens_BairdsList,
	Ravens_SilverbackManual,
	Ravens_CogTag,
	Hanover_Journal,
	Hanover_Diary,
	Hanover_GroceryList,
	Hanover_CogTag,
	Stadium_Program,
	Stadium_ThrashballRules,
	Stadium_ChampionshipRing,
	Stadium_CogTag,
	Bridge_Bayonet,
	Bridge_TollboothTokens,
	Bridge_SightseeingBook,
	Bridge_CogTag,
	Wreckage_GardeningBook,
	Wreckage_CaptLog,
	Wreckage_CogTag,
	Badlands_LocustHammer,
	Badlands_QueenSymbol,
	Badlands_CogTag,
	Blimp_Manifest,
	Blimp_CogTag,
	Fort_AnvilGatePlaque,
	Fort_Painting,
	Fort_Journal,
	Fort_SamsDadsMedals,
	Fort_CogTag,
	Mercy_PanickedNote,
	Mercy_Message,
	Mercy_AirRaidSign,
	Mercy_CogTag,
	Char_OldMagazine,
	Char_Journal,
	Char_FuelOrder,
	Char_CogTag,
	Shipyard_Bulletin,
	Shipyard_MaintenanceManual,
	Shipyard_Tabloid,
	Shipyard_CogTag,
	Coast_Pamphlet,
	Coast_AssaultPlans,
	Coast_Schematics,
	Coast_CogTag,
	Azura_Announcement,
	Azura_Diary,
	Azura_MoneyStack,
	Azura_CogTag,
	Tower_Brochure,
	Tower_FenixResearch,
	Tower_CogTag
};

/** All of the achievements in the game */
enum EGearAchievement
{
	eGA_Invalid,
	eGA_MARCUSITSYOURFATHER,		  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_SWIMMININGLOWIEGRAVY,		  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_WESTRUCKGOLD,				  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_WELCOMETOCOUGARTOWN,		  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_BIGASSHEADSHOT,				  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_SUPPOSEDTOKNOWWHERETHATIS,    // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_FLOODTHEMOUTTHEIRTUNNELS,	  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_THANKSFORFLYINGGASBAGAIRWAYS, // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_THEBITCHISBACK,				  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_GOODDRIVERDISCOUNT,			  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_BROTHERSTOTHEEND,			  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_WELCOMETOGRIFFINTOWER,		  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_BAIRDSFAVORITEKINDOFTOY,	  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_THATLOOKSLIKETHEFRONTDOOR,	  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_LOOKATTHATINSTANTSUMMER,	  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_OKFAITHYEAHGOTIT,			  // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_WEVEFINALLYGOTATOMORROW,      // Campaign progression  Handled by: SeqAct_GearAchievementUnlock kismet action 
	eGA_READYFORMORE,				  // CompleteChapterByDifficulty() in GearProfileSettings
	eGA_AINTMYFIRSTRODEO,			  // CompleteChapterByDifficulty() in GearProfileSettings
	eGA_ONCEMOREUNTOTHEBREACH,		  // CompleteChapterByDifficulty() in GearProfileSettings
	eGA_COLLECTOR,					  // UpdateDiscoverableProgression() in GearProfileSettings
	eGA_PACKRAT,					  // UpdateDiscoverableProgression() in GearProfileSettings
	eGA_HOARDER,					  // UpdateDiscoverableProgression() in GearProfileSettings
	eGA_REMEMBEREDTHEFALLEN,		  // UpdateDiscoverableProgression() in GearProfileSettings
	eGA_MYFELLOWGEARS,				  // UpdateCoopChapterCompleteProgression() in GearProfileSettings
	eGA_ADIFFERENTKINDOFFOURSOME,	  // UpdateCoopChapterCompleteProgression() in GearProfileSettings
	eGA_REPLACEME1,                  
	eGA_ITSCALLEDPROGRESS,			  // ClientWriteLeaderboardStats() in GearPC_SP
	eGA_LEVEL5,						  // CheckLevelAchievements()
	eGA_LEVEL10,                      // CheckLevelAchievements()
	eGA_LEVEL15,                      // CheckLevelAchievements()
	eGA_LEVEL25,                      // CheckLevelAchievements()
	eGA_CALLINGYOURSHOTS,			  // UpdateAchievementProgression() in GearProfileSettings
	eGA_FIRSTAMONGEQUALS,			  // UpdateAchievementProgression() in GearProfileSettings
	eGA_DONTYOUDIEONME,				  // ModifyMultiplier() in GearGRI_SP_Arcade
	eGA_AWARDWINNINGTACTICS,		  // AwardEarned() in GearAwardManager
	eGA_SERIOUSLY3,                  
	eGA_BACKTOBASIC,				  // HandleTeamWin() in GearGameMP_Base
	eGA_WELCOMETOVERSUS,			  // UpdateKillingProgression() in GearProfileSettings
	eGA_WELCOMETOKINGOFTHEHILL,		  // ClientStatGameEnded() in GearPC_MP
	eGA_WELCOMETOTEAMDEATHMATCH,	  // ClientStatGameEnded() in GearPC_MP
	eGA_WELCOMETOCAPTURETHELEADER,	  // ClientStatGameEnded() in GearPC_MP
	eGA_WELCOMETOEXECUTION,			  // ClientStatGameEnded() in GearPC_MP
	eGA_WELCOMETOWINGMAN,			  // ClientStatGameEnded() in GearPC_MP
	eGA_WELCOMETOWARZONE,			  // ClientStatGameEnded() in GearPC_MP
	eGA_WELCOMETOHORDEMODE,			  // UpdateHordeWaveProgression() in GearProfileSettings
	eGA_WELCOMETOBEASTMODE,			  // UpdateSiegeWaveProgression() in GearProfileSettings
	eGA_WELCOMETOARCADEMODE,		  // UpdateArcadeProgression() in GearProfileSettings
	eGA_REPLACEME2,                  
	eGA_RUSTLUNG,					  // CheckViralAchievement() in GearPC in menu for EpicDevs or AddDeathMessage() in GearPC when spreading
	eGA_DLC1,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC2,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC3,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC4,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC5,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC6,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC7,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC8,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC9,						// Handled by: SeqAct_GearAchievementUnlock kismet action
	eGA_DLC10,						// Handled by: SeqAct_GearAchievementUnlock kismet action
};

/** Enum of all the maps the game will ship with (needed for achievement tracking) */
enum EGearMapsShipped
{
	eGEARMAP_None,
	eGEARMAP_MP1,
	eGEARMAP_MP2,
	eGEARMAP_MP3,
	eGEARMAP_MP4,
	eGEARMAP_MP5,
	eGEARMAP_MP6,
	eGEARMAP_MP7,
	eGEARMAP_MP8,
	eGEARMAP_MP9,
	eGEARMAP_MP10,
	eGEARMAP_MP11,
	eGEARMAP_MP12,
	eGEARMAP_MP13,
	eGEARMAP_MP14,
	eGEARMAP_MP15,
	eGEARMAP_MP16,
	eGEARMAP_MP17,
	eGEARMAP_MP18,
	eGEARMAP_MP19,
	eGEARMAP_MP20,
	eGEARMAP_MP21,
	eGEARMAP_MP22
};

/**
 * Enum of all the weapons in the game (at least the ones we shipped with)
 * NOTE: the Disabled value is required for UI so we can disable weapons in the pickup factories
 *			and should remain at the bottom of the list
 */
enum EGearWeaponType
{
	eGEARWEAP_FragGrenade,
	eGEARWEAP_InkGrenade,
	eGEARWEAP_IncendiaryGrenade,
	eGEARWEAP_SmokeGrenade,
	eGEARWEAP_Boomshot,
	eGEARWEAP_Flame,
	eGEARWEAP_Sniper,
	eGEARWEAP_Bow,
	eGEARWEAP_Mulcher,
	eGEARWEAP_Mortar,
	eGEARWEAP_HOD,
	eGEARWEAP_Gorgon,
	eGEARWEAP_Boltok,
	eGEARWEAP_Pistol,
	eGEARWEAP_Lancer,
	eGEARWEAP_Hammerburst,
	eGEARWEAP_Shotgun,
	eGEARWEAP_Shield,
	eGEARWEAP_SawedOffShotgun,
	eGEARWEAP_RetroLancer,
	eGEARWEAP_Box,
	eGEARWEAP_GasTank,
	eGEARWEAP_Disabled,
	eGEARWEAP_GoldLancer, // Must be after because you can't swap it in MP
	eGEARWEAP_GoldHammer, // Must be after because you can't swap it in MP
	eGEARWEAP_DLC_Cobra,
};

/** Enum of all the execution types in the game (needed for achievement tracking) */
enum EGearExecutionType
{
	eGET_Curbstomp,
	eGET_MeatShield,
	eGET_ShieldBash,
	eGET_QuickGeneric,
	eGET_QuickBow,
	eGET_QuickShotgun,
	eGET_QuickSniper,
	eGET_LongGeneric,
	eGET_LongBoltok,
	eGET_LongBow,
	eGET_LongSniper,
	eGET_LongBurstPistol,
	eGET_LongDigger,
	eGET_LongElephant,
	eGET_LongFlameThrower,
	eGET_LongMortar,
	eGET_LongRetroLancer,
	eGET_LongSawedOff,
	eGET_LongPunchFace,
	eGET_LongLancer,
};

/** Enum of all the training scenarios we have in Training Grounds */
enum EGearTrainingType
{
	eGEARTRAIN_Basic,
	eGEARTRAIN_Execution,
	eGEARTRAIN_Respawn,
	eGEARTRAIN_Objective,
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

/** Enum of the inputs for this action */
enum EManageTutorialInputs
{
	eMTINPUT_AddTutorial,
	eMTINPUT_RemoveTutorial,
	eMTINPUT_StartTutorial,
	eMTINPUT_StopTutorial,
	eMTINPUT_CompleteTutorial,
	eMTINPUT_SystemOn,
	eMTINPUT_SystemOff,
	eMTINPUT_AutosOn,
	eMTINPUT_AutosOff,
	eMTINPUT_AttemptFailure,
};

/** Enum of all of the possible experience buckets 
    (keep in sync with GearStats.uci) */
enum EExperienceBuckets
{
	eEXP_Kills,
	eEXP_Revives,
	eEXP_Objectives,
	eEXP_Executions,
	eEXP_Awards,
	eEXP_WinBonus,
	eEXP_ParticipationBonus,
	/** For quitting one or more ranked match(es) before completion */
	eEXP_QuitPenalty
};

/** struct to store the date and time the checkpoint was created */
struct native CheckpointTime
{
	var int SecondsSinceMidnight;
	var int Day;
	var int Month;
	var int Year;
};

/**
 * This stores a 64-bit DateTime value for use by screenshots.
 * qword cannot be used due to it's variables being declared as const.
 */
struct native DateTime
{
	var int A, B;
};

/**
 * This is the info that is stored for each player in the game when a screenshot is taken.
 * If the contents of this struct changes, the two SerializeInfo() functions in GearScreenshotIO.cpp must be updated.
 */
struct native ScreenshotPlayerInfo
{
	/** The nickname for bots only. */
	var string Nick;
	/** The player's XUID.  For bot's this is set to zero. */
	var UniqueNetId Xuid;
	/** If true, the player is visible within the screenshot. */
	var bool IsVisible;
	/**
	 * If IsVisible is true, then this contains the coordinates for the player's screen-space bounding box surrounding.
	 * Only the X and Y coordinates will be valid.
	 */
	var box ScreenSpaceBoundingBox;
	/** The location of the player in world-space. */
	var vector Location;
};

/**
 * This is the info that is stored for each screenshot when it is taken.
 * If the contents of this struct changes, the two SerializeInfo() functions in GearScreenshotIO.cpp must be updated.
 */
struct native ScreenshotInfo
{
	/** The time at which the screenshot was taken, based on GWorld->GetTimeSeconds(). */
	var float WorldTime;
	/** An optional description of the screenshot. */
	var string Description;
	/** The screenshot's calculated rating. */
	var int Rating;
	/** The friendly name of the gametype being played when the screenshot was taken. */
	var string GameTypeFriendly;
	/** The EGearMPTypes value for the gametype. */
	var int GameTypeId;
	/** The eScreenshotMatchType value for this shot. */
	var int MatchType;
	/** The name of the map being played when the screenshot was taken. */
	var string MapName;
	/** The friendly name of the map being played when the screenshot was taken. */
	var string MapNameFriendly;
	/** The "real world" time at which the screenshot was taken. */
	var DateTime Realtime;
	/** The stats ID for this match. */
	var guid MatchID;
	/** The camera's location when the shot was taken. */
	var vector CamLoc;
	/** The camera's rotation when the shot was taken. */
	var rotator CamRot;
	/** Screenshot width. */
	var int Width;
	/** Screenshot height. */
	var int Height;
	/** Info for all the players (including bots) in the screenshot. */
	var array<ScreenshotPlayerInfo> Players;
};

/** Profile to weapon lookup table */
struct native ProfileToWeaponLookupTableData
{
	var class<Inventory> WeapClass;
	var EGearWeaponType WeapSwapType;
	var int ProfileId;
};

/** Weapon class to weapon class mapping */
struct native WeaponClassToWeaponClassMapping
{
	/** The source weapon class */
	var name WeapClass;
	/** The weapon class to swap to */
	var string SwapWeapClass;
};

/** Level specific weapon swapping */
struct native LevelSpecificWeaponSwapping
{
	/** The name of the level that needs weapon swaps */
	var name MapName;
	/** The set of weapon swaps */
	var array<WeaponClassToWeaponClassMapping> MapWeaponSwaps;
};

/** Enumeration of all the encouragements you hear at the end of a round in MP games */
enum EEncouragementType
{
	ET_WonMatch,
	ET_LostMatch,
	ET_WonMatchByShutout,
	ET_LostMatchByShutout,
	ET_MatchOrRoundDraw,
	ET_WonRound,
	ET_LostRound,
};

/** Structure to store the MP encouragements at the end of an MP round */
struct native TeamEncouragementData
{
	var array<SoundCue> COGSounds;
	var array<SoundCue> LocustSounds;
};

/** Mapping of GearDamageType class to EGearWeaponType */
var const array<class<GearDamageType> > DamageToWeaponMap;

/** Mapping of GearDamageType class to EGearExecutionType */
var const array<class<GearDamageType> > DamageToExecutionMap;

/** Mapping of EWeaponClass to the actual weapon's class */
var const array<class<Inventory> > WeaponClasses;

/**
 * This is a list of Physical Materials that are in the vast majority of maps.
 * By referencing them here we will not have to duplicate them into all of the maps and will save diskpace
 **/
var const array<PhysicalMaterial> AlwaysReferencedPhysMaterials;

/** Per-damagetype damage modifiers. Campaign/Horde only. */
struct native PerDamageTypeMod
{
	var config name DamageTypeName;
	var config float Multiplier;
};

/** base "p" level for each chapter point */
var const config array<name> ChapterLevelNames;

/** Enum of all possible comparisons */
enum EComparisonType
{
	GEARCOMPARE_Invalid,
	GEARCOMPARE_Equal,
	GEARCOMPARE_NotEqual,
	GEARCOMPARE_LessThan,
	GEARCOMPARE_LessThanEqual,
	GEARCOMPARE_GreaterThan,
	GEARCOMPARE_GreaterThanEqual,
};

/** Enum of all possible recording periods */
enum ERecordingPeriodType
{
	GEARPERIOD_Persistent,
	GEARPERIOD_Game,
	GEARPERIOD_Round,
	GEARPERIOD_Life,
};

/** Enum of ways in which a GearStat can be modified */
enum EStatModificationType
{
	GEARSTATMODTYPE_Delta,
	GEARSTATMODTYPE_Set,
	GEARSTATMODTYPE_Maximum,
};

/** Enum of ways in which an award can be earned multiple times */
enum EAwardRepeatType
{
	//Can only earn the award once
	GEARAWARDREPEAT_None,
	//Can only earn once per game
	GEARAWARDREPEAT_OncePerGame,
	//Can only earn once per round
	GEARAWARDREPEAT_OncePerRound,
	//Can earn the award as many times as the checks are true AND the stat is modified (otherwise you would earn the award an infinite amount of times the first time you earn it
	GEARAWARDREPEAT_Unlimited,
	//Can earn the award multiple times, each successive time multiples the stats necessary by the number of awards earned IN THAT STAT'S PERIOD!
	GEARAWARDREPEAT_Multiple,
	//Can earn the award multiple times, each successive time doubles the stats necessary by the number of awards earned IN THAT STAT'S PERIOD!
	GEARAWARDREPEAT_Double,
};

/** Different types of awards */
enum EAwardType
{
	GEARAWARDTYPE_Ribbon,
	GEARAWARDTYPE_Medal,
	GEARAWARDTYPE_Achievement,
	GEARAWARDTYPE_WeaponSkin,
	GEARAWARDTYPE_Character,
	GEARAWARDTYPE_Fortification,
	GEARAWARDTYPE_Mutator,
	GEARAWARDTYPE_Execution,
	GEARAWARDTYPE_AvatarItem,
	GEARAWARDTYPE_Epic,
};

/** The amount of progress messages to show, if any */
enum EAwardProgressType
{
	GEARAWARDPROGRESS_None,
	GEARAWARDPROGRESS_Always,
	GEARAWARDPROGRESS_Percentage,
	GEARAWARDPROGRESS_Constant,
};

/** How progress should be represented */
enum EProgressRepresentation
{
	GEARAWARDPROGREP_Integer,
	GEARAWARDPROGREP_TenthOfSecond,
};

/** All possible attachment types
 *	NOTE: The amount of types MUST equal the const NumAttachments in GearPawn_Infantry, at least until we can set the size of static arrays using enum values
 */
enum EAttachmentType
{
	eATTACHTYPE_Helmet,
	eATTACHTYPE_Face,
	eATTACHTYPE_ShoulderLeft,
	eATTACHTYPE_ShoulderRight,
	eATTACHTYPE_HandRight,
};

/** Possible spots for shoulder pieces*/
enum EShoulder
{
	eSHOULDER_Left,
	eSHOULDER_Right,
};

/** List of events a player can do to a fortification */
enum EGearFortificationEventType
{
	GFET_Purchased,
	GFET_Sold,
	GFET_Repaired,
	GFET_Upgraded,
	GFET_Damaged,
	GFET_Destroyed
};

//THIS IS DEPRECATED!!!!
enum EChapterPoint
{
	CHAP_One_Nightmare,
	CHAP_One_RavensNest_1,
	CHAP_One_RavensNest_2,
	CHAP_Two_Hanover_1,
	CHAP_Two_Hanover_2,
	CHAP_Two_Hanover_3,
	CHAP_Two_Bridge,
	CHAP_Two_Wreckage,
	CHAP_Three_Badlands_1,
	CHAP_Three_Badlands_2,
	CHAP_Three_Badlands_3,
	CHAP_Three_Badlands_4,
	CHAP_Three_Blimp_1,
	CHAP_Three_Blimp_2,
	CHAP_Three_Fort_1,
	CHAP_Three_Fort_2,
	CHAP_Four_Convoy,
	CHAP_Four_Mercy_1,
	CHAP_Four_Mercy_2,
	CHAP_Four_Char_1,
	CHAP_Four_Char_2,
	CHAP_Four_Char_3,
	CHAP_Four_Shipyard_1,
	CHAP_Four_Shipyard_2,
	CHAP_Five_Maelstrom,
	CHAP_Five_Coast_1,
	CHAP_Five_Coast_2,
	CHAP_Five_Azura_1,
	CHAP_Five_Azura_2,
	CHAP_Five_Tower_1,
	CHAP_Five_Tower_2,
	CHAP_Gameover, // This chapter does not exist and is here so that code knows if CHAP_Five_Tower_2 was beaten
	CHAP_DLC_1,	// From here down is reserved for potential DLC
	CHAP_DLC_2,
	CHAP_DLC_3,
	CHAP_DLC_4,
	CHAP_DLC_5,
	CHAP_DLC_6,
	CHAP_DLC_7,
	CHAP_DLC_8,
	CHAP_DLC_9,
	CHAP_DLC_10,
	CHAP_DLC_11,
	CHAP_DLC_12,
	CHAP_DLC_13,
	CHAP_DLC_14,
	CHAP_DLC_15,
	CHAP_DLC_16,
	CHAP_DLC_17,
	CHAP_DLC_18,
};

/** Enum of all front end sections/screens
 *  MAKE SURE AllOptions in DefaultUI.GearGame.UIWidget_MainMenu is in th same order as this enum!
 */
enum EMainMenuOption
{
	//DONT CHANGE THESE!!
	MAINMENUOP_None,
	MAINMENUOP_MainMenu,
	MAINMENUOP_ClientMenu,

	MAINMENUOP_Campaign,
	MAINMENUOP_SaveSlots,
	MAINMENUOP_SPGametype,
	MAINMENUOP_SPDifficulty,
	MAINMENUOP_SPActSelect,
	MAINMENUOP_Arcade_MutatorSelection,
	MAINMENUOP_Horde_MutatorSelection,

	MAINMENUOP_VS_Playlists,
	MAINMENUOP_VS_Playlist1,
	MAINMENUOP_VS_Playlist2,
	MAINMENUOP_VS_Playlist3,
	MAINMENUOP_VS_Playlist4,
	MAINMENUOP_VS_Playlist5,
	MAINMENUOP_VS_Playlist6,
	MAINMENUOP_VS_Playlist7,
	MAINMENUOP_VS_Playlist8,

	MAINMENUOP_VS_Training,
	MAINMENUOP_Horde,
	MAINMENUOP_Siege,

	/*
	 * The order of the custom game options screens MUST match the order of EGearMPTypes
	 */
	MAINMENUOP_VS_CustomWarzone,
	MAINMENUOP_VS_CustomExecution,
	MAINMENUOP_Horde_Options,
	MAINMENUOP_VS_CustomWingman,
	MAINMENUOP_VS_CustomKOTH,
	MAINMENUOP_VS_CustomCTL,
	MAINMENUOP_VS_CustomNewbie,
	MAINMENUOP_Siege_Options,

	MAINMENUOP_WarJournal,
	MAINMENUOP_Calendar,
	MAINMENUOP_Matchmaking,
	MAINMENUOP_DLC,

	/*
	 * NOTE: MAINMENUOP_SPChapterSelect is NOT a real screen that ever occurs.
	 * Please read the comment at the bottom to determine what the real chapter select screen enum values will be
	 * MAINMENUOP_SPChapterSelect is only used in GetSelectionFromScreen in order to make it easier to determine
	 * what chapter was selected without having to know the act.
	 */

	MAINMENUOP_SPChapterSelect,
	/* Note about chapter select screens
	 * As there exists a different chapter select screen for each act, and the number of acts can change dynamically
	 * each chapter select screen is constructed dynamically.
	 * As a result, the EMainMenuOption value for specific act's chapter select screen is as follows:
	 * MAINMENUOP_MAX + ActNum
	 */
};

/**
 * Enum to describe what type of screen this is
 */
enum EMainMenuScreenType
{
	MMSCREENTYPE_NormalList,
	MMSCREENTYPE_SingleStacker,
	MMSCREENTYPE_Difficulty,
	MMSCREENTYPE_SaveSlot,
	MMSCREENTYPE_Mutators,
};

/** Types of versus parties there can be */
enum EGearVersusMatchType
{
	/** non-network match */
	eGVMT_Local,
	/** Ranked public live match */
	eGVMT_Official,
	/** Private invite only match */
	eGVMT_Custom,
	/** LAN only match */
	eGVMT_SystemLink,
	/** Public social match (player match) */
	eGVMT_Player
};

/** Enum used in conjunction with the Last Game Type variable in the profile to save off what game type the player played last */
enum EGearLastGameType
{
	eGLGT_Campaign,
	eGLGT_VS_Social,
	eGLGT_VS_Ranked,
	eGLGT_VS_Custom,
	eGLGT_Horde_Social,
	eGLGT_Horde_Custom,
	eGLGT_Siege_Social,
	eGLGT_Siege_Custom,
};

//Simple structure used to keep track of the most recent hits done to a pawn
struct native HitStruct
{
	var int Damage;
	var float Time;
};

/** Describes how a joint breaks for a gore mesh */
struct native GoreBreakableJoint
{
	var() name      ConstraintName;
	/** For per-bone tweaking. */
	var() float     ImpulseScale;
	/** if TRUE, the impulse applied to this bone will be a mass-independent velocity impulse */
	var() bool      bVelImpulse;
	/** if TRUE, do not break this joint if GearGame.bShowPartialGore is set for this locale */
	var() bool      bDontBreakWithPartialGore;

	structdefaultproperties
	{
		ImpulseScale=1.f
		bVelImpulse=true
	}
};

/** list of bones that when broken need to break other bones */
struct native DependantBreakInfo
{
	/** Name of the bone to break dependents of */
	var name ParentBone;
	/** List of bones that need to get broken when parent bone does */
	var array<Name> DependantBones;
};

/** Used to notify party members of something noteworthy (achievement, award, level progression) */
enum EPartyNotificationType
{
	// The player unlocked an achievement
	PNT_Achievement,
	// The player just earned a major award
	PNT_Award,
	// The player just leveled up
	PNT_LevelChange
};

/** This struct holds the parameters needed to replicate a customized skin */
struct native CoolSkin
{
	/** The index into the WeaponSkins array or 255 for the default weapon */
	var byte WeaponSkinIndex;
	/** The weapon class to apply this CoolSkin to */
	var class<GearWeapon> WeapClass;
	/** True if the skin needs the parameters set, false if they should be left alone */
	var bool bRequiresParameters;
	/** Vector parameters affecting the look of the skin */
	var LinearColor BaseDiffuseColor;
	var LinearColor MetalColorCracks;
	var LinearColor MetalColorSurface;
	var LinearColor ReflectionColor;
	var LinearColor SpecularColor;
	var LinearColor TopReflectionColor;
	var LinearColor PatternColor01;
	var LinearColor PatternColor02;
	/** Scalar parameters that affect the look of the skin */
	var float Emmis_amount;
	var float PatternTile;
	var float ReflectionSmoothness;
	var float SpecPower;

	structdefaultproperties
	{
		// Set to the default skin
		WeaponSkinIndex=255
		Emmis_amount=1.0
	}
};

/** Sets WeaponType to the EGearWeaponType it corresponds to in the DamageToWeaponMap via a GearDamageType */
static final function bool GetWeaponType( class<GearDamageType> DmgType, out EGearWeaponType WeaponType )
{
	local int Idx;

	if (DmgType != None)
	{
		// Find the index of the damage type in the map
		for ( Idx = 0; Idx < class'GearTypes'.default.DamageToWeaponMap.length; Idx++ )
		{
			if ( class'GearTypes'.default.DamageToWeaponMap[Idx] == DmgType )
			{
				WeaponType = EGearWeaponType(Idx);
				return true;
			}
		}
	}
	return false;
}

/** Sets ExecutionType to the EGearExecutionType it corresponds to in the DamageToExecutionMap via a GearDamageType */
static final function bool GetExecutionType( class<GearDamageType> DmgType, out EGearExecutionType ExecutionType )
{
	local int Idx;

	if ( ClassIsChildOf(DmgType, class'GDT_Execution_Base') )
	{
		// Find the index of the damage type in the map
		for ( Idx = 0; Idx < class'GearTypes'.default.DamageToExecutionMap.length; Idx++ )
		{
			if ( class'GearTypes'.default.DamageToExecutionMap[Idx] == DmgType )
			{
				ExecutionType = EGearExecutionType(Idx);
				return true;
			}
		}
	}

	return false;
}

defaultproperties
{
	AlwaysReferencedPhysMaterials.Add( PhysicalMaterial'GearPhysMats.Stone' )
	AlwaysReferencedPhysMaterials.Add( PhysicalMaterial'GearPhysMats.Wood' )

	DamageToWeaponMap(eGEARWEAP_FragGrenade)=class'GDT_FragGrenade'
	DamageToWeaponMap(eGEARWEAP_InkGrenade)=class'GDT_InkGrenade'
	DamageToWeaponMap(eGEARWEAP_IncendiaryGrenade)=class'GDT_IncendiaryGrenade'
	DamageToWeaponMap(eGEARWEAP_SmokeGrenade)=class'GDT_SmokeGrenade'
	DamageToWeaponMap(eGEARWEAP_Boomshot)=class'GDT_Boomshot'
	DamageToWeaponMap(eGEARWEAP_Flame)=class'GDT_FlamethrowerSpray'
	DamageToWeaponMap(eGEARWEAP_Sniper)=class'GDT_SniperRifle'
	DamageToWeaponMap(eGEARWEAP_Bow)=class'GDT_TorqueBow_Explosion'
	DamageToWeaponMap(eGEARWEAP_Mulcher)=class'GDT_Mulcher'
	DamageToWeaponMap(eGEARWEAP_Mortar)=class'GDT_Mortar'
	DamageToWeaponMap(eGEARWEAP_HOD)=class'GDT_HOD'
	DamageToWeaponMap(eGEARWEAP_Gorgon)=class'GDT_LocustBurstPistol'
	DamageToWeaponMap(eGEARWEAP_Boltok)=class'GDT_LocustPistol'
	DamageToWeaponMap(eGEARWEAP_Pistol)=class'GDT_COGPistol'
	DamageToWeaponMap(eGEARWEAP_Lancer)=class'GDT_AssaultRifle'
	DamageToWeaponMap(eGEARWEAP_Hammerburst)=class'GDT_LocustAssaultRifle'
	DamageToWeaponMap(eGEARWEAP_Shotgun)=class'GDT_Shotgun'
	DamageToWeaponMap(eGEARWEAP_GoldHammer)=class'GDT_LocustAssaultRifle'
	DamageToWeaponMap(eGEARWEAP_GoldLancer)=class'GDT_AssaultRifle'
	DamageToWeaponMap(eGEARWEAP_RetroLancer)=class'GDT_RetroLancer'

	DamageToExecutionMap(eGET_Curbstomp)=class'GDT_CurbStomp'
	DamageToExecutionMap(eGET_MeatShield)=class'GDT_NeckBreak'
	DamageToExecutionMap(eGET_ShieldBash)=class'GDT_ShieldExecute'
	DamageToExecutionMap(eGET_QuickGeneric)=class'GDT_QuickExecution'
	DamageToExecutionMap(eGET_QuickBow)=class'GDT_QuickExecution_Bow'
	DamageToExecutionMap(eGET_QuickShotgun)=class'GDT_QuickExecution_Shotgun'
	DamageToExecutionMap(eGET_QuickSniper)=class'GDT_QuickExecution_Sniper'
	DamageToExecutionMap(eGET_LongGeneric)=class'GDT_Execution_Default'
	DamageToExecutionMap(eGET_LongBoltok)=class'GDT_LongExecution_Boltok'
	DamageToExecutionMap(eGET_LongBow)=class'GDT_LongExecution_Bow'
	DamageToExecutionMap(eGET_LongSniper)=class'GDT_LongExecution_Sniper'
	DamageToExecutionMap(eGET_LongBurstPistol)=class'GDT_LongExecution_BurstPistol'
	DamageToExecutionMap(eGET_LongDigger)=class'GDT_LongExecution_Digger'
	DamageToExecutionMap(eGET_LongElephant)=class'GDT_LongExecution_Elephant'
	DamageToExecutionMap(eGET_LongFlameThrower)=class'GDT_LongExecution_FlameThrower'
	DamageToExecutionMap(eGET_LongMortar)=class'GDT_LongExecution_Mortar'
	DamageToExecutionMap(eGET_LongRetroLancer)=class'GDT_LongExecution_RetroLancer'
	DamageToExecutionMap(eGET_LongSawedOff)=class'GDT_LongExecution_SawedOff'
	DamageToExecutionMap(eGET_LongPunchFace)=class'GDT_Execution_PunchFace'
	DamageToExecutionMap(eGET_LongLancer)=class'GDT_LongExecution_Lancer'

	WeaponClasses(WC_MAX)=None
	WeaponClasses(WC_Boltock)=class'GearWeap_LocustPistol'
	WeaponClasses(WC_Boomshot)=class'GearWeap_BoomshotBase'
	WeaponClasses(WC_BoomerFlail)=class'GearWeap_HeavyFlailBase'
	WeaponClasses(WC_BrumakMainGun)=class'GearWeap_BrumakWeaponBase'
	WeaponClasses(WC_BrumakSideGun)=class'GearWeap_BrumakWeaponBase'
	WeaponClasses(WC_BrumakSideGunOther)=class'GearWeap_BrumakWeaponBase'
	WeaponClasses(WC_FragGrenade)=class'GearWeap_FragGrenade'
	WeaponClasses(WC_GasGrenade)=None
	WeaponClasses(WC_Gnasher)=class'GearWeap_Shotgun' // Shotgun
	WeaponClasses(WC_HOD)=class'GearWeap_HODBase'
	WeaponClasses(WC_Hammerburst)=class'GearWeap_LocustAssaultRifle'
	WeaponClasses(WC_InkGrenade)=class'GearWeap_InkGrenadeBase'
	WeaponClasses(WC_KingRavenTurret)=class'GearWeap_KingRavenTurretBase'
	WeaponClasses(WC_Lancer)=class'GearWeap_AssaultRifle'  // COG Assault Rifle
	WeaponClasses(WC_Longshot)=class'GearWeap_SniperRifle' // Sniper
	WeaponClasses(WC_Minigun)=class'GearWeap_HeavyMiniGunBase' // Heavy Weapon
	WeaponClasses(WC_Mortar)=class'GearWeap_HeavyMortarBase'  // Heavy Weapon
	WeaponClasses(WC_Scorcher)=class'GearWeap_FlameThrowerBase' // Flamethrower
	WeaponClasses(WC_SmokeGrenade)=class'GearWeap_SmokeGrenade'
	WeaponClasses(WC_Snub)=class'GearWeap_COGPistol'  // Pistol COG
	WeaponClasses(WC_TorqueBow)=class'GearWeap_BowBase'
	WeaponClasses(WC_Troika)=class'GearWeap_TroikaBase'
	WeaponClasses(WC_TyroTurrent)=None
	WeaponClasses(WC_MinigunTurret)=class'GearWeap_MinigunTurretBase'
	WeaponClasses(WC_WretchMeleeSlash)=class'GearWeap_WretchMelee'
	WeaponClasses(WC_FragGrenadeExplosion)=class'GearWeap_FragGrenade'		// explosions
	WeaponClasses(WC_TorqueBowArrowExplosion)=class'GearWeap_BowBase'
	WeaponClasses(WC_MortarExplosion)=class'GearWeap_HeavyMortarBase'
	WeaponClasses(WC_BoomshotExplosion)=class'GearWeap_BoomshotBase'
	WeaponClasses(WC_BrumakRocketExplosion)=class'GearWeap_BrumakWeaponBase'
	WeaponClasses(WC_LocustBurstPistol)=class'GearWeap_LocustBurstPistolBase'
	WeaponClasses(WC_ReaverRocket)=None
	WeaponClasses(WC_RocketLauncherTurret)=None
	WeaponClasses(WC_Shield)=class'GearShield'
	WeaponClasses(WC_IncendiaryGrenade)=class'GearWeap_IncendiaryGrenadeBase'
	WeaponClasses(WC_HeavySniperRifle)=class'GearWeap_HeavySniperBase'
	WeaponClasses(WC_HeavyFlail)=class'GearWeap_HeavyFlailBase'
	WeaponClasses(WC_SawedOffShotgun)=class'GearWeap_Shotgun_SawedOff'
	WeaponClasses(WC_RetroLancer)=class'GearWeap_RetroLancer'
	WeaponClasses(WC_Box)=None
	WeaponClasses(WC_GasTank)=None
	WeaponClasses(WC_BlimpBallTurret)=None
	WeaponClasses(WC_LambentHammerburst)=class'GearWeap_LocustAssaultRifle'
	WeaponClasses(WC_Melee)=class'GearWeap_Melee'
	WeaponClasses(WC_CoopMinigun)=class'GearWeap_HeavyCoopMGBase'
	WeaponClasses(WC_Cleaver)=class'GearWeap_CleaverBase'
	WeaponClasses(WC_DiggerLauncher)=class'GearWeap_DiggerLauncher'
	WeaponClasses(WC_SecurityBotGun)=class'GearWeap_SecurityBotGun'
	WeaponClasses(WC_SilverbackMinigun)=class'GearWeap_Silverback_MinigunBase'
	WeaponClasses(WC_SilverbackRocket)=class'GearWeap_Silverback_RocketLauncherBase'
	WeaponClasses(WC_MultiLancer)=class'GearWeap_AssaultRifle_MultiTurret'
	WeaponClasses(WC_MultiRetro)=class'GearWeap_RetroLancer_MultiTurret'
	WeaponClasses(WC_MultiHammerburst)=class'GearWeap_LocustAssaultRifle_MultiTurret'
	WeaponClasses(WC_MultiBoomshot)=class'GearWeap_Boomshot_MultiTurret'
	WeaponClasses(WC_MultiGnasher)=class'GearWeap_Shotgun_MultiTurret'
}
