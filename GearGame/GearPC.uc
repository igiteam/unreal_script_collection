/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPC extends GamePlayerController
	config(Pawn)
	dependson(GearTypes,GearPawn,GearDiscoverablesPickupFactoryBase,GearPointOfInterest,GearGRI,GearPersistentPartyBeaconHost,GearPlayerMatchBeaconClient,UIScene_MessageBox)
	native(PC)
	nativereplication;

`include(GearPlayerPersistentDataConstants.uci)

cpptext
{
	virtual void PreBeginPlay();

	virtual FGuid* GetGuid() { return &MyGuid; }

	virtual FLOAT GetMaxDropHeight();
	virtual UBOOL WantsLedgeCheck();

	FLOAT ScoreFrictionTarget(AActor const* Actor, FLOAT MaxDistance, FRotator const& CamRot);

	virtual UBOOL HearSound(USoundCue* InSoundCue, AActor* SoundPlayer, const FVector& SoundLocation, UBOOL bStopWhenOwnerDestroyed);

	virtual UBOOL Tick(FLOAT DeltaSeconds, ELevelTick TickType);

	// Networking
	INT* GetOptimizedRepList( BYTE* InDefault, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );

	virtual void physWalking(FLOAT deltaTime, INT Iterations);

	virtual void	ShowSelf(){/*SILENCE!*/} // this is handled by the ai visibility manager
	void UpdateCanDoSpecialMoveCacheList(TArrayNoInit<FSMCacheDatum>& CacheList, TArrayNoInit<BYTE>& PawnIndexList, INT& LastUpdatedIndex);
	/**
	 * will grab the cached value from the list, and also return FALSE if the cached value is too old
	 * Or if mirror state matters, (when CheckMirrorState == TRUE) and if that changes, it will return FALSE
	 */
	UBOOL GetCachedCanDoSpecialMove(TArrayNoInit<FSMCacheDatum>& CacheList, INT Idx, const UBOOL CheckMirrorState);
	virtual void PostNetReceive();

	/** IMPLEMENT Interface_NavigationHandle */
	virtual UBOOL	CanCoverSlip(ACoverLink* Link, INT SlotIdx);

	/**
	 * Builds a list of components that are hidden based upon gameplay
	 *
	 * @param ViewLocation the view point to hide/unhide from
	 * @param HiddenComponents the list to add to/remove from
	 */
	virtual void UpdateHiddenComponents(const FVector& ViewLocation,TSet<UPrimitiveComponent*>& HiddenComponents);
}

/** List of stored variables used to persist data through certain map transitions */
struct native StoredKismetVariable
{
	var Name VariableName;
	var string StringValue;
	var float FloatValue;
	var Object ObjectValue;
	var int IntValue;
	var bool BoolValue;
};
var transient array<StoredKismetVariable> StoredKismetVariables;

//Maximum number of objective locators allowed per objective
const MAX_OBJLOCATORS = 10;

/** Struct containing all data pertaining to an Objective */
struct native ObjectiveInfo
{
	/** Name of objective for scripting purposes */
	var() Name ObjectiveName;
	/** Path name to localized objective description to draw on the HUD */
	var() string ObjectiveDesc;
	/** extra data substituted in to localized description; separate replacement strings with |
	 * substituted text is ~0, ~1, ~2, etc
	 * e.g. "Param1|Param2" would result in "~0" becoming "Param1" and "~1" becoming "Param2" in the final string
	 */
	var() string ObjectiveDescVars;
	/** Should we list this objective in taccom? */
	var() bool bShowInList;
	/** Is this objective completed? */
	var() bool bCompleted;
	/** Is this objective failed? */
	var() bool bFailed;
	/** Time at which this objective was received/updated/completed */
	var() float UpdatedTime;
	/** Whether to update the player's screen */
	var bool bNotifyPlayer;
	/** Whether or not any locators were sent. Necessary for the client to determine if the locators were stripped due to the map not being loaded yet */
	var bool bLocatorWasSent;
	/** Whether or not to always draw this objective */
	var bool bAlwaysDraw;

	/** The objective locators this objective references */
	var GearObjectiveLocator Locators[MAX_OBJLOCATORS];
};

struct native CheckpointMusicRecord extends MusicTrackDataStructures.MusicTrackStruct
{
	var string TheSoundCuePath;
};

struct CheckpointRecord
{
	var Guid SavedGuid; // our GUID at save time
	var Name CheckpointName; // used to link to checkpoint loaded kismet events by name

	var float PawnHealthPct;
	var string PawnClassName;
	var string RidableClassName; // when driving a GearPawnRidable_Base, the Pawn being driven
	var string MutatedClassName;
	var string PawnPathName; // used when Pawn at save time was a level placed actor
	var vector Location;
	var rotator Rotation;
	var string BasePathName;
	var bool bWeaponHolstered;
	var byte TeamIndex;
	var string SquadFormationName;
	var string SlotPathName; // path name of slot we were taking cover on (if we were taking cover)
	var int	SlotIdx;
	var array<InventoryRecord> InventoryRecords;
	var array<ObjectiveInfo> Objectives;
	var string CratePathName; // path name to carried crate (if any)
	var CheckpointMusicRecord Music;
	var string MountedFaceFX[3];
	var array<StoredKismetVariable> StoredKismetVariables;
	var string KismetAnimSets[2];
	var string KismetAnimTree;
	var float GUDSFrequencyMultiplier;
	var int Score; // player score (for Arcade mode)
	var int PlayerSlotIndex; // index in GearGameSP_Base's PlayerSlots array, for managing playerpawn classes
	var Guid CarriedPawnGuid; // GUID of pawn carried via SM_DragInjured
	var string AttachmentClassNames[4];
};

/** Cached version of MyGearPawn */
var GearPawn MyGearPawn;

/** Squad this player belongs to */
var GearSquad Squad;

/** Struct to define values for different post processing presets. */
struct native PostProcessInfo
{
	var ETVType Preset;
	var float Shadows;
	var float MidTones;
	var float HighLights;
	var float Desaturation;
};

/** Enum of canvas icons supported */
enum GearIconTextureType
{
	eGEARICON_A,
	eGEARICON_A_PRESSED,
	eGEARICON_B,
	eGEARICON_B_PRESSED,
	eGEARICON_X,
	eGEARICON_X_PRESSED,
	eGEARICON_Y,
	eGEARICON_Y_PRESSED,
	eGEARICON_RS,
	eGEARICON_RS_PRESSED,
	eGEARICON_LS,
	eGEARICON_LS_PRESSED,
	eGEARICON_LT,
	eGEARICON_RT,
	eGEARICON_Chainsaw,
	eGEARICON_Chainsaw_PRESSED,
};
/** List of textures mapped by GearIconTextureType */
var array<CanvasIcon> GearIcons;

/** Cover the server wants the client to enter as soon as it replicates (used primarily for spawned cover where the channel may not exist yet for an RPC) */
var repnotify CoverInfo ServerDictatedCover;

/** Array of possible preset values for post process. */
var transient array<PostProcessInfo>	PostProcessPresets;

/** Indicates if this GearPC currently has a vehicle PP overlay */
var	bool	bHasVehicleOverlay;

/** a bit kludgey here.  system need some architectural love */
var bool	bCameraLookAtIsFromKismet;

/** Show feedback effects in god mode */
var()	config bool		bShowFeedbackFXInGodMode;

/** Debugging AI vars */
var config bool bDebugAI;
var(Debug) GearAI   DebugAIController;
var array<name> DebugAICategories;
var config bool bInvisible;

/** DeadZone used as a threshold for player controls */
var(Cover) config float	DeadZoneThreshold;

var() config bool   bShowSpecialMoveTips;

/** Flag indicating that player is currently targeting. */
var			bool	bIsTargeting;

/** If we were targeting last frame */
var         bool	bTargetingLastFrame;

/** If we can use the coop interaction menu */
var         bool	bCanUseCoopInteractionMenu;
/** Last Time Targeting was active */
var transient float LastTargetingTime;

/** The pawn we're targeting currently */
var         GearPawn TargetedPawn;
var         Actor    TargetedActor;

/** Disable double click for movement */
var config	bool	bDisableDoubleClickMovement;
/** Allow mouse wheel scroll to zoom when targeting */
var config	bool	bMouseWheelZoom;

/**
 * whether 360 evading is allowed.  controlled by the profile
 */
var bool bAllow360Evade;

//
// Cover
//

/** Allow player to enter cover from any direction, or restrict it to the forward region? */
var(Cover) config		bool	bRun2CoverAnyDirection;

/** Threshold to break from cover when pulling back on the stick. */
var(Cover)	config		float	BreakFromCoverHoldTime;
/** Internal property used to track current amount of time stick has been held to break from cover. */
var transient float BreakFromCoverHoldTimer;

/** Bool when desiring to break from cover, to delay until full input/movement has been processed */
var			transient	bool	bBreakFromCover;
/** If TRUE, press A to break from cover. */
var			config		bool	bPressAToBreakFromCover;
/** when set, send cover transition info in next ServerMove() (because we just entered cover or server asked for retransmission) */
var bool bSendCoverTransition;

/** Camera relative controls: Left/Right. */
var	float	RemappedJoyRight;
/** Camera relative controls: Up/Down */
var float	RemappedJoyUp;
/** Rotation used to remap controls */
var Rotator	ControlsRemapRotation;

/** Minimum delay between 2 cover moves */
var(Cover)	config	float	EvadeRetriggerDelay;

/** debug cover flag */
var(Cover)	config	bool	bDebugCover;

/** Animation debugging. */
var bool bDebugAnimation, bDebugMorphs;
var float DebugTextMaxLen;

/** Amount of time the player is delayed when moving between slots with a lean */
var()	config		float	CoverTransitionTime;
var		transient	float	CoverTransitionCountHold;
var		transient	float	CoverTransitionCountDown;

/** Toggle for assess mode */
var bool bAssessMode;

/** Kismet events for entering and leaving cover */
var const array<SeqEvt_EnteredCover> EnteredCoverEvents;
var const array<SeqEvt_LeftCover> LeftCoverEvents;

/** Last friction target */
var transient Actor LastFrictionTarget;
/** Last friction target acquire time */
var transient float LastFrictionTargetTime;

/** in range [0..1], how hard is the forward accel control depressed. */
var transient float VehicleGasPressedAmount;
/** in range [0..1], how hard is the reverse accel control depressed. */
var transient float VehicleReversePressedAmount;

/** Amount of time before starting a roadie run */
var() config float RoadieRunTimer;

/** Amount of time before starting a long execution */
var() config float ExecuteHeldTimer;

/**
 *  If true, forced to roadie run.
 *  If the player enters cover, mantles and coverslips will be done automatically.
 *  Intended for use in Cole's Thrashball charge in Gears 3 Stadium
 */
var transient bool bForcedRoadieRun;

/** Direction double click was captured last */
var EDoubleClickDir CurrentDoubleClickDir;

/** Last time mouse wheel was used to cycle weapons */
var() transient float LastCycleWeaponTime;

/** Take Damage Scale for Near Death */
struct native ScaleDamageInfo
{
	/** If health is less than this, scale */
	var() float		HealthLimitPct;
	/** Scale damage by this amount */
	var() float		Scale;
};
var() config array<ScaleDamageInfo>	ScaleDamageList;

/**
 * Defines the cone from the player that determines whether or not it is ok
 * to do melee-attack adhesion.  This is the cosine of the half-angle of the cone.
 */
var() float MinMeleeAdhesionDotValue;

/** Target we are forcibly adhering to. */
var GearPawn	ForcedAdhesionTarget;
var GearPawn	MeleeAdhesionTarget;

/** Number of orders given to AI which the AI refused to do */
var Byte	RefusedOrderCount;

/** Is god mode currently enabled by a camera look at? */
var bool bCameraGodMode;

/** Are we currently looking at a point of interest? */
var bool bLookingAtPointOfInterest;

/** Played when we get a new POI **/
var SoundCue PointOfInterestAdded;
/** Last Time we played a POI Sound */
var float LastPoITime;
/** How long between POI Sounds*/
var() float PoIRepeatTime;

/**
 * Time which we stop players from Pushing out of cover when pressing 'A'
 * This is used to stop people mashing the 'A' button and getting into cover and then
 * immediately leaving cover as they hit 'A' again
 **/
var config float TimeBeforeAButtonPressLeavesCover;

/** all other things being equal, would we prefer to lean out of mid level cover or pop up over it? */
var transient bool bPreferLeanOverPopup;

/**
 * The current GearPawn being targetedusing the tooltip targeting feature
 */
var GearPawn CurrentTooltipTargetGearPawn;

//
// Input
//

/** Stack of player inputs being used by the controller */
var array<PlayerInput> PlayerInputStack;
/** Reference to the main GearPlayerInput object so that update calls (like camera reorienting) can still happen */
var GearPlayerInput MainPlayerInput;

/** Whether to use the alternate controller scheme or not - set via SetAlternateControls() */
var const bool bUseAlternateControls;

/** Whether to use different execution controls */
var config bool bChangeExecutionControls;

/** List of Kismet input events */
var const array<SeqEvt_Input> InputEvents;

/** Whether the input is enabled or disabled */
var int InputIsDisabledCount;

/** The state of the inputs from cinematic mode */
var bool bCinemaDisableInputButtons;

/** Is this player in combat?  Set by IsInCombat(), and should never be referenced directly. */
var private float LastCheckIsInCombatTime;

/** List of enabled POIs */
var	private array<GearPointOfInterest>	EnabledPointsOfInterest;
/** List that matches EnabledPointsOfInterest which determines if the POI in the same index has been looked at yet */
var private array<bool>					POILookedAtList;
var GearPointOfInterest					CurrLookedAtPOI;

/** Interp speed range for looking at points of interest.  bonus points for long var name. */
var() vector2d PointOfInterestLookatInterpSpeedRange;

/**********************************
 * SPECTATING
 **********************************/

/** Current camera point viewing */
var GearSpectatorPoint CurrSpectatorPoint;
/** The default spectating type for this PC */
var const name DefaultSpectateType;

var transient SeqAct_SpectatorCameraPath BattleCamPath;
var bool bUseBattleCamAutoFraming;

/** Holy alliteration batman!  Celebratory Screenshake to play when you get a supersuccess active reload */
var() const protected GearCameraShake ARSuperSuccessScreenShake;

struct native LocalEnemy
{
	/** reference to the enemy warpawn */
	var Pawn Enemy;
	/** holds results of last LOS check */
	var bool bVisible;
	/** true if enemy has ever been visible */
	var bool bSeen;
	/** true if there is LOS...  this does NOT exclude enemies behind you like bVisible does */
	var bool bHasLOS;
};

/** cache to store LOS status of enemies */
var array<LocalEnemy> LocalEnemies;

/** List used to turn crosshair red for given actors */
var Actor UnfriendlyActorList[16];

/** Idx in LocalEnemies array of next enemy to check for LOS (we only check one per frame */
var transient int NextLocalEnemyToCheckLOS;

/** The max distance an enemy can be before their excluded from the death camera looking at them */
var const float DeathCameraEnemyMaxDistance;
/** Biggest threat to the player when in reviving state */
var GearPawn BiggestThreatWP;

/** action info associated with valve turning. */
var const ActionInfo ActionValveTurn;

/** Action icon for mashing button to stay alive during revive state */
var const ActionInfo ActionStayingAlive;

/** Action icon for mashing button to stay alive during revive state in games that have auto revive rules - first stage*/
var const ActionInfo ActionStayingAliveAutoRevive;

/** Action icon for mashing button to stay alive during revive state in games that have auto revive rules - second stage*/
var const ActionInfo ActionStayingAliveAutoReviving;

/** Action icon for mashing button to stay alive during revive state in games that have auto revive rules - third stage*/
var const ActionInfo ActionStayingAliveAutoRevived;

/** Action icon for suiciding with a grenade */
var const ActionInfo ActionSuicideBomb;

/** Action icon for displaying action icons through kismet */
var ActionInfo ActionKismetButton;

/** Action icon so we know to hit a fortification */
var ActionInfo ActionHitFortification;

/** The profile data associated with this player */
var GearProfileSettings ProfileSettings;

/** The player's persistent data for reading/writing */
var GearPlayerPersistentData PersistentData;

/** whether active cover type was received by servermove currently being processed */
var bool bServerMoveCoverActive;
/** whether current ServerMove() is a RoadieServerMove() (if not, make sure player not in roadie run) */
var bool bServerMoveRoadieRunActive;

/** Last pawn I possessed */
var Pawn LastPawn;

/** Offset from the top of the viewport to set the UIScene's position for fitting splitscreen properly */
var float SceneYOffsetForSplitscreen;

/** indicates whether this player is a dedicated server spectator (so disable rendering and don't allow it to participate at all) */
var bool bDedicatedServerSpectator;

/** request call to ClientVerifyState().  Done asynchronously to make sure only one sent per tick */
var bool bRequestClientVerifyState;

/** request call to ServerVerifyState().  Done asynchronously to make sure only one sent per tick */
var bool bRequestServerVerifyState;

/** Enum of the different post process effects */
enum GearPostProcessFXType
{
	eGPP_None,
	eGPP_Pause,
	eGPP_BleedOut,
	eGPP_Gameover,
	eGPP_Menu,
	eGPP_Taccom,
};
var GearPostProcessFXType CurrentPPType;

/**
 * Post process settings for gameover and pause UI scenes.
 */
var PostProcessSettings GameoverPPSettings;
var PostProcessSettings PausePPSettings;
var PostProcessSettings MenuPPSettings;

/** Structure defining necessary data to play a camera-bone animation. */
struct native CameraBoneAnimation
{
	var Name		AnimName;
	var vector		CollisionTestVector;
};


/** current index into profile maplist that we are playing (local server player only) */
var int MapListIndex;

/**
 * Structure to contain the configurable data needed to modify a player's health if they
 * receive too much burst damage in a small amount of time.
 */
struct native BurstDamageModConfig
{
	/** The percentage of the total health of the player that if damaged this amount will make us save him and give him one last try */
	var const float	HealthPercentForLifeSave;
	/** The percentage of the total health of the player we will subtract per second from CurrentBurstDamageTaken */
	var const float	HealthPercentWipedPerSecond;
	/** The amount of time we will give the player invincibility if we save their life */
	var const float	InvincibilityLengthInSecs;
	/** The number of units at which the enemy can still hit you when invincible */
	var const float	InvincibilityRangeInUnits;
};
var config BurstDamageModConfig BurstDamageModConfigData;

const Player_BulletWhipDistance = 800;
const Player_NearMissDistance	= 200;

/** Current sound mode in use */
var transient protected name KismetSpecifiedSoundMode;

/** Whether the kismet sound mode should override all other soundmodes or be considered after dialog */
var transient protected bool bKismetSpecifiedSoundModeTopPriority;

/** The current hud cast to a GearHUD_Base */
var GearHud_Base MyGearHud;

/** Current Kismet interaction event player would activate if he presses Use now. Determined on server, replicated to client */
var SeqEvt_Interaction InteractEvent;

/** List of currently Down But Not Out teammates.  Pawns are added when they enter the reviving state, and removed when list is checked and they fail a condition */
var array<GearPawn> DBNOTeammates;

/** true if level has vehicles, so player should be checking for available HUD actions related to vehicles */
var bool bCheckVehicles;

/** set when camera is being controlled by Matinee, so we don't force the server's ViewTarget on the client */
var bool bInMatinee;

var bool bWasKicked;

/** Used to track how many pawns were killed with a given explosive round */
var int NumExplosiveKills;
/** Used to see how fast the number of kills occurred. If 3 within .5 seconds, then increment ClusterLuck */
var float ExplosiveKillTimeStamp;

/** True if this PC has contributed his info to the initialization of the COG Tags */
var transient bool bHasInitedCogTags;

/** Extra rotation to apply this tick in UpdateOrient */
var transient rotator ExtraRot;

/**
 * Cache of the last crosshair hit location in case we need to re-align viewrotation during a camera switch,
 * e.g. sniper zoom. Only valid while targeting.
 */
var transient vector LastCrosshairHitLocation;

var transient Actor	SearchGoalActor;

/** Controller sensitivity multipliers for rotation */
var() config float	RotationSensitivityLow;
var() config float	RotationSensitivityMedium;
var() config float	RotationSensitivityHigh;
/** Controller sensitivity multipliers for rotation when targetting */
var() config float	TargettingRotationSensitivityLow;
var() config float	TargettingRotationSensitivityMedium;
var() config float	TargettingRotationSensitivityHigh;
/** Controller sensitivity multipliers for rotation when zooming */
var() config float	ZoomRotationSensitivityLow;
var() config float	ZoomRotationSensitivityMedium;
var() config float	ZoomRotationSensitivityHigh;

/** For driving mode, rotation of view relative to vehicle. */
var	rotator RelativeToVehicleViewRot;
/** Last output rotation when using 'relative to vehicle' mode - for interpolation. */
var rotator LastVehicleSpaceViewRotation;

/** Channel the player is associated with regardless of their state */
var int VoiceChannel;


/** Sounds and components for the gameover screen */
var AudioComponent GameoverLoop;
var SoundCue OpenGameoverCue;
var SoundCue LoadCheckpointCue;

/** Rotation.Yaw when we entered TargetingMortar mode. */
var transient float TargetHeavyWeaponBaseRotationYaw;

/** Is this player currently waiting to respawn? */
var bool bWaitingToRespawn;

/** The distance of the trace to determine if a player is friendly or not */
var() config float DistanceForEnemyTrace;

/** Pickup preference modifiers, for tweaking the rules for sorting pickups */
var() config float PickUpAmmoPreference;
var() config float PickUpNewWeaponPreference;
var() config float PickUpSwapWeaponPreference;

/** The data store that holds data needed to translate bound input events to strings for UI */
var GearUIDataStore_StringAliasBindingsMap BoundEventsStringDataStore;
/** The data store that holds data needed to translate unbound input events to strings for UI */
var GearUIDataStore_StringAliasMap StringDataStore;

/** The object that manages the objectives for the player. */
var GearObjectiveManager ObjectiveMgr;

/** The object that manages the tutorials for the player. */
var GearTutorialManager TutorialMgr;
/**
 * Whether the tutorial system has been on (used when we need to turn it off for special UI events like timers)
 * NOTE: should only be set at the time that the TutorialMgr is created and from the OnManageTutorials kismet call
 */
var bool bTutorialSystemWasOn;

/** Enum of events that will trigger a list of delegates when an event occurs */
enum EGearEventDelegateType
{
	eGED_CoverAcquired,
	eGED_CoverLeave,
	eGED_Mantle,
	eGED_Evade,
	eGED_CoverSlip,
	eGED_SwatTurn,
	eGED_GrenadeToss,
	eGED_KickDoor,
	eGED_Pickup,
	eGED_Revive,
	eGED_Chainsaw,
	eGED_BayonetKill,
	eGED_ClimbDownLadder,
	eGED_RoadieRun,
	eGED_Reload,
	eGED_Executions,
	eGED_MeatShield,
	eGED_Crawling,
	eGED_Shield,
	eGED_Turret,
	eGED_ActiveReloadSuccess,
	eGED_ActiveReloadFailed,
	eGED_ReloadFinished,
	eGED_MeatBagGrabbed,
	eGED_Melee,
	eGED_MultiTurret,
	eGED_KilledStalkPod,
	eGED_Silverback,
	eGED_SilverbackDeployed,
	eGED_SilverbackLoader,
	eGED_NumTypes	// used to set the length of GearEventDelegates
};

/** Struct to hold anything related to an event that will trigger delegates when an event occurs */
struct native GearEventData
{
	/** Array of delegates that will be triggered when the event occurs */
	var array<delegate<OnGearEvent> > GearEventDelegates;
};

/** Array of GearEventData indexed by EGearEventDelegateType that will trigger delegates when an event occurs */
var array<GearEventData> GearEventList;

/** Array of delegates to be fired when a weapon is equipped */
var array<delegate<OnGearWeaponEquip> > GearWeaponEquipDelegates;

/** Whether we've used the Loaded exec and have access to all of the weapons (this is so we can switch between mousewheeling functionality for debug) */
var bool bWeaponsLoaded;

/** Text to draw when get revived by a teammate */
var localized string RevivedString;

/** The discoverable that is currently being looked at */
var EGearDiscoverableType DiscoverType;

/** Time of last conversation abort from this player */
var protected transient float ConversationAbortTime;

/** Time between horn sounds on vehicle */
var float LastHornPlayedTime;

/** Rain emitter that's currently attached to us. */
var protected Emit_Rain WeatherEmitter;

/** Only allow players to spot one enemy at a time by default, this is when the last spot took place */
var transient float LastSpotTime;

/** Keep track of spotted enemy so we can clear it if necessary */
var transient GearPawn SpottedEnemy;

/************************************************************************
	HELPER VARIABLES FOR TRACKING ACHIEVEMENTS
 ************************************************************************/
/** Minigun achievement variables */
var bool bIsMountedWithMinigun;

/************************************************************************
	PROFILE AND ONLINE VARIABLES
 ************************************************************************/

/** Whether we need to update the profile settings or not */
var bool bProfileSettingsUpdated;

/** If this is true, then our connection with the server has timed out */
var bool bHasLostContactWithServer;

/** The XUID of the host for reporting them as dropped */
var UniqueNetId HostId;

// Invite handling

/** Client beacon for requesting reservation on a party host we want to join. Invite handling */
var GearPersistentPartyBeaconClient ClientPersistentPartyBeacon;
/** Client beacon for joining a game session (JIP) which might be active on the party host we are joining. Invite handling */
var PartyBeaconClient PendingJIPClientReservationBeacon;
/** Current pending game session info for a JIP session we want to join. Invite handling */
var OnlineGameSearch PendingJIPGameSearch;
/** Id of the party host player that has sent us an invite */
var UniqueNetId InvitePartyHostOwnerId;

/** Temp var for delegate use when returning to party */
var transient UniqueNetId ReturnToPartyRequestingId;
/** Temp var for identifying game settings type when returning to party */
var transient bool bWasLocalSystemOrPrivate;

/** Different types of invite errors */
enum EInviteAcceptanceError
{
	// Generic error of invite failure
	eInviteError_DefaultError,
	// Remote party does not have enough space to allow all players to join
	eInviteError_NotEnoughSpaceInPartyInvite,
	// Not all players can play online
	eInviteError_NotAllPlayersCanJoinInvite,
	// Party is not full but game is
	eInviteError_NotEnoughSpaceInGameToJoin,
	// The party session is currently in an active game but the game session rejected the JIP request
	eInviteError_GameJIPFailed,
	// Game session has DLC that we do not
	eInviteError_GameJIPFailedMissingDLC
};

/** GUID for checkpoint saving so that references to us can be saved even though we may be recreated */
var Guid MyGuid;

// the last index we updated in our cached lists
var int LastCoverActionSpecialMoveUpdateIdx,LastGlobalActionSpecialMoveUpdateIdx;
// the actual cando cache, (one of which is updated each frame)
struct native SMCacheDatum
{
	// the last cached value
	var bool bCachedValue;
	// cached when mirrored or not - in cover, this should change
	var bool bIsMirrored;
	// the world time this datum was updated (is considered invalid, and returns false if too old)
	var float LastUpdateTime;
	// the last time this SM's status was requested
	var float LastRequestedTime;
};
var array<SMCacheDatum> CachedCanDoCoverActionSpecialMoves;
var array<SMCacheDatum> CachedCanDoGlobalActionSpecialMoves;

var transient bool bDebugFaceCam;
var protected transient bool bDebugGUDBrowser;
var protected transient bool bDebugEffortBrowser;

/** indicates this is a fake player created to load checkpoint data that was saved when playing co-op,
 * but is being loaded in single player
 * it is destroyed immediately after parsing the checkpoint data
 */
var transient const bool bCheckpointDummy;

/** client holder for GUDS sound references, since GUDSManager does not exist on the client
 * should not be used on the server
 */
struct native GUDSReferenceHolder
{
	/** name of GUD bank package */
	var name PackageName;
	/** GUDBank object */
	var GUDBank Bank;
	/** FaceFX animset */
	var FaceFXAnimSet FaceFXData;
};
var array<GUDSReferenceHolder> ClientGUDSReferences;

var transient float LastCheckpointSaveTime;
/** Filled in when SaveCheckpoint is called and applied/read from the record. Used to get CP name from kismet and match to approriate ksimet events */
var transient Name LastCheckpointSaveName;


/** Used to temporarily disable targeting DOF */
var transient bool							bDisableCameraTargetingDOF;

/** number of events (anything you want) that have occurred so we can do mem profiler dumps **/
var transient int Automation_NumMemoryEvents;

/** Ignore close connection errors when explicitly traveling */
var bool bIsReturningFromMatch;

/** Prevents double-initialization of main menu when we know a return is pending */
var bool bIsReturningToMainMenu;

/** set when client is loading checkpoint until we receive the confirmation notify */
var transient bool bClientLoadingCheckpoint;

/** Whether we are waiting for a read of the profile to complete before we save a profile again */
var transient bool bHasSigninChanged;

/** Whether we are waiting for a read of the persistent data to complete before we save the persistent data again */
var transient bool bHasPersistentData;

/** information about the upgrade level we've attained for each fortification type */
struct native FortificationUpgradeLevel
{
	/** base class of fortification that this entry effects (all subclasses of this class are also affected) */
	var class<GearFortification> FortClass;
	/** the upgrade level this player has (can build up to this level, or -1 if player can't build it at all) */
	var int UpgradeLevel;
	/** percentage of base repair cost this player pays to repair this fortification type, reduced based on earned awards */
	var float RepairPct;
};
var protected array<FortificationUpgradeLevel> FortificationUpgrades;

/** mapping of fortification name to awards that grant increases in the upgrade level above */
struct native FortUpgradeList
{
	var name FortName;
	/** awards that improve the player's ability to build or upgrade this type */
	var array<name> UpgradeAwards;
	/** awards that improve the player's ability to repair this type */
	var array<name> RepairAwards;
};
var const config array<FortUpgradeList> FortUpgradeAwardMap;
/** range of values for the player's repair ability for a fortification type (X = at min level, Y = at max level) */
var config vector2d RepairPctRange;

/** fortification player has selected to modify (teardown/repair/etc) */
var GearFortification ModifyFortification;

/** search radius for fortifications to modify (teardown/repair/etc) */
var config float FortificationModifyRadius;

/** Stat Manager */
var transient GearStatManager StatManager;

/** Award Manager */
var transient GearAwardManager AwardManager;

/** Lenght of time we show you your friend's awards that they've earned */
var config float CoopAwardDisplayTime;

/** Whether to disallow weapon switching */
var bool bPreventWeaponSwitching;
/** Allows player so shoot while in cover even though movement is disabled */
var bool bAllowDisabledMovementFiring;

/** The accumulator for the Guardian Angel system */
var transient int GuardianAngelScore;
/** The amount of GA points earned for getting killed */
var config const int GuardianAngelKilledBonus;
/** The amount of GA points earned for getting downed */
var config const int GuardianAngelDownedBonus;

/** fully qualified localized property indicated the reason why the player(s) failed in SP - used for delayed game over display */
var string GameOverReason;
/** optional target player for GameOverReason (e.g. player that died) */
var GearPRI GameOverTarget;

/** Used to keep track of the time a bleed out effect initially started */
var float BleedOutTimeStarted;

/** Death Cam parameters **/
var transient GearPawn  KilledByPawn;
var transient vector    KilledLocation;

/** Called when the stats write and end/destroy session calls are complete */
var delegate<OnWriteStatsAndEndSessionCompleteDelegate> WriteStatsAndEndSessionDelegate;

/** Player was notified that his party host disconnected and should disable invites */
var transient bool bPartyHostLost;

/** Cached current FrictionAdhesionTarget */
var Actor CachedFrictionAdhesionTarget;

/** POV used for cached FrictionAdhesionTarget */
var TPOV CachedFrictionAdhesionPOV;

/** Time at which last cached FrictionAdhesionTarget was calculated (in case camera isn't moving */
var float LastFrictionAdhesionTargetTime;

/** Strings used in displaying XP progress */
var localized string ExperienceEarnedTitle;
var localized string MatchPenaltyTitle;
var localized string DemotedTitle;
var localized string DemotedText;
var localized string PromotedTitle;
var localized string PromotedText;

/** string displayed when the player gets bonus XP for an execution */
var localized string ExecutionBonusMessage;

/** If death message is delayed, it will be stored as array here and will be reset whenever **/
struct native DeathMessage
{
	var GearPawn Victim;
	var PlayerReplicationInfo Killer;
	var PlayerReplicationInfo Other;
	var class<DamageType> DamageType;
	var EGearDeathType DeathType;
	var bool bIsKnockdown;
	var int PointsAwarded;
	var bool bIgnoreForHUD;
	var bool bSkipBlood;
	var bool bSentToHud;
};

/** Death messages that need to be delayed **/
var array<DeathMessage> DelayedDeathMessages;

replication
{
	// Things the server should send to the client.
	if( bNetOwner && Role==ROLE_Authority )
		InteractEvent, ServerDictatedCover, bWaitingToRespawn, UnfriendlyActorList;
}

simulated event ReplicatedEvent(Name VarName)
{
	local CovPosInfo CovInfo;

	if (VarName == nameof(ServerDictatedCover))
	{
		if( ServerDictatedCover.Link != None )
		{
			if (MyGearPawn != None)
			{
				MyGearPawn.SetCoverInfoFromSlotInfo(CovInfo, ServerDictatedCover);
			}
			else
			{
				CovInfo.Link = ServerDictatedCover.Link;
				CovInfo.LtSlotIdx = ServerDictatedCover.SlotIdx;
				CovInfo.RtSlotIdx = ServerDictatedCover.SlotIdx;
				CovInfo.LtToRtPct = 0.f;
				CovInfo.Location = ServerDictatedCover.Link.GetSlotLocation(ServerDictatedCover.SlotIdx);
				CovInfo.Normal = vector(ServerDictatedCover.Link.GetSlotRotation(ServerDictatedCover.SlotIdx)) * -1;
			}
			AcquireCover(CovInfo);
		}
	}
	else if (VarName == nameof(PlayerReplicationInfo))
	{
		// Have clients send their DLC values to the server
		UpdateLocalPlayersDLCValues();
		// Have clients update their profile settings so that the local settings are applied
		bProfileSettingsUpdated = true;
		// Still need to call the super class
		Super.ReplicatedEvent(VarName);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

event InitInputSystem()
{
	local bool bPushInputObject;
	local LocalPlayer LP;
	local GearGameSP_Base SPGame;

	if ( PlayerInput == None )
	{
		bPushInputObject = true;
	}

	Super.InitInputSystem();

	LP = LocalPlayer(Player);

	if (bDedicatedServerSpectator)
	{
		LP.ViewportClient.bDisableWorldRendering = true;
	}

	// Push the newly created playerinput onto the player input stack if there wasn't one already.
	if ( bPushInputObject )
	{
		MainPlayerInput = GearPlayerInput(PlayerInput);
		MainPlayerInput.OnInputObjectCreate();
		PushPlayerInput( PlayerInput );
	}

	if (WorldInfo.NetMode == NM_Client)
	{
		ServerSetAlternateControls(bUseAlternateControls);
	}

	// reset the post processing when we get a new PC
	LP.RemoveAllPostProcessingChains();
	LP.InsertPostProcessingChain(LP.Outer.GetWorldPostProcessChain(), INDEX_NONE, true);

	// clear the loading screen if it's up
	SPGame = GearGameSP_Base(WorldInfo.Game);
	if (WorldInfo.NetMode == NM_Client || SPGame == None || !SPGame.bStartupLoadCheckpoint)
	{
		ClientShowLoadingMovie(false, GetURLMap() ~= `CAMPAIGN_ENTRY_LEVEL);
	}
}

/** Pushes a player input object to the stack and sets the current player input to be that new object. */
final function PushPlayerInput( PlayerInput NewPlayerInput )
{
	local GearPlayerInput_Base PrevInputObject;
	local int InteractionIdx;

	if ( NewPlayerInput != None )
	{
		if ( PlayerInputStack.length > 0 )
		{
			PrevInputObject = GearPlayerInput_Base(PlayerInputStack[PlayerInputStack.length-1]);
		}

		// Add the new input
		PlayerInputStack.AddItem( NewPlayerInput );

		// Set the current input object to the new one
		InteractionIdx = Interactions.Find(PlayerInput);
		PlayerInput = NewPlayerInput;
		if ( InteractionIdx == INDEX_NONE )
		{
			Interactions[Interactions.Length] = PlayerInput;
		}
		else
		{
			Interactions[InteractionIdx] = PlayerInput;
		}

		// Call the function that allows the new input object to perform any needed tasks when getting pushed to the top of the stack.
		GearPlayerInput_Base(PlayerInput).PushedOnTopOfInputStack( PrevInputObject, true );

		// If there was already an input object on the stack call the function that lets it handle
		// it's being pushed back from the front of the stack.
		if ( PrevInputObject != None )
		{
			PrevInputObject.PushedBackOnInputStack();
		}
	}

	UpdateControllerConfig();
}

/** Pops a player input object from the stack and sets the current player input to be the next input object in the stack. */
final function PopPlayerInput( optional PlayerInput PlayerInputToPop )
{
	local GearPlayerInput_Base PrevInputObject;
	local int IndexToRemove, InteractionIdx;
	local bool bRemovedCurrentInputHandler;

	if (  PlayerInputStack.length > 0 )
	{
		// Find the index to remove
		IndexToRemove = (PlayerInputToPop != None) ? PlayerInputStack.Find(PlayerInputToPop) : PlayerInputStack.length-1;

		// Could not find the input to remove so bail
		if ( IndexToRemove == INDEX_NONE )
		{
			return;
		}

		// Set the input object to be removed
		PrevInputObject = GearPlayerInput_Base(PlayerInputStack[IndexToRemove]);

		// Determine if the input object to be removed is the currently active input handler
		bRemovedCurrentInputHandler = (PlayerInput == PrevInputObject) ? true : false;

		// Remove it
		PlayerInputStack.RemoveItem( PrevInputObject );
	}

	// If the input handler that got removed was active, to some cleanup
	if ( bRemovedCurrentInputHandler )
	{
		if ( PlayerInputStack.length > 0 )
		{
			// Set the input object to be the last in the list
			InteractionIdx = Interactions.Find(PlayerInput);
			PlayerInput = PlayerInputStack[PlayerInputStack.length-1];
			if ( InteractionIdx == INDEX_NONE )
			{
				Interactions[Interactions.Length] = PlayerInput;
			}
			else
			{
				Interactions[InteractionIdx] = PlayerInput;
			}

			// Call the function that will allow the old input object to perform any needed tasks now that it's becoming the front of the list.
			GearPlayerInput_Base(PlayerInput).PoppedToTopOfInputStack( PrevInputObject, true );
		}

		// Let the input object that is being popped off of the stack to perform any needed tasks if it was active
		if ( PrevInputObject != None )
		{
			PrevInputObject.PoppedOffOfInputStack();
		}
	}

	UpdateControllerConfig();
}


/**
 * Called when the local player is about to travel to a new map or IP address.  Provides subclass with an opportunity
 * to perform cleanup or other tasks prior to the travel.
 *
 * Overloaded so we can save the profile before traveling
 */
event PreClientTravel( string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel )
{
	local LocalPlayer LP;
	local GearEngine Engine;

	// Only save if we are NOT in the menu level
	if (!class'WorldInfo'.static.IsMenuLevel())
	{
		ClientSaveAllPlayerData();
	}

	// Kick off a CIV check before loading
	LP = LocalPlayer(Player);
	if (LP != None)
	{
		Engine = GearEngine(class'Engine'.static.GetEngine());
		if (Engine != None)
		{
			Engine.CheckCIV();
		}
	}

	Super.PreClientTravel(PendingURL, TravelType, bIsSeamlessTravel);

	if (!bIsSeamlessTravel )
	{
		ClientShowLoadingMovie(true);
	}
}

/** Client function so that the server can tell this player to save it's profile */
reliable client function ClientSaveAllPlayerData()
{
	SaveProfile();
	SavePersistentData();
}

/**
 * Replicate owner of the party session the PRI player belongs to.
 * Once the PartyOwnerUniqueId is replicated for each PRI they will
 * register the remote players on their party sessions.
 *
 * @param PartyOwnerUniqueId owner of party session for the PRI player
 */
reliable server function ServerSetPartyOwner(UniqueNetId PartyOwnerUniqueId)
{
	local int Idx;
	local GearPRI GPRI, PartyOwnerPRI, CurrPRI;

	GPRI = GearPRI(PlayerReplicationInfo);
	if (GPRI != None)
	{
		GPRI.PartyOwnerUniqueId = PartyOwnerUniqueId;
		GPRI.RegisterPlayerWithParty();

		// @STATS - Party makeup (default to self unless we find who we came with)
		PartyOwnerPRI = GPRI;
		for ( Idx = 0; Idx < WorldInfo.GRI.PRIArray.length; Idx++ )
		{
			CurrPRI = GearPRI(WorldInfo.GRI.PRIArray[Idx]);
			if (CurrPRI.UniqueId == PartyOwnerUniqueId)
			{
				PartyOwnerPRI = CurrPRI;
				break;
			}
		}

		`RecordPlayerPlayerEvent(PARTYOWNER, self, Controller(PartyOwnerPRI.Owner));
	}
}

/**
 * Called on all players whenever they login in order to set their
 * party owner on the server.  Once the correct party owner is replicated
 * for each client then this allows each client to remotely register the
 * correct players with their party session.
 */
reliable client function ClientRegisterWithParty()
{
	local UniqueNetId PartyOwnerUniqueId;
	local OnlineGameSettings PartySettings;

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
		if (PartySettings != None)
		{
			PartyOwnerUniqueId = PartySettings.OwningPlayerId;
		}

		// Zero id used if no party settings
		ServerSetPartyOwner(PartyOwnerUniqueId);
	}
}

simulated event PostBeginPlay()
{
	local GearPC PC;
	local Vehicle V;
	local GearPawnRidable_Base GRPR;

	Super.PostBeginPlay();

	// clear lingering blur from seamless travel case
	SetTimer(2.f,FALSE,nameof(ClearBlurPP));

	PreCacheAnimations();

	if (MainPlayerInput != None)
	{
		MainPlayerInput.LastInputTime = WorldInfo.TimeSeconds;
	}

	// store the points of interest for clients
	StorePointsOfInterest();

	// init the post processing settings
	InitPausePostProcessSettings();
	InitGameoverPostProcessSettings();

	// set the default sound mode
	SetSoundMode( 'Default' );

	bHasInitedCogTags = FALSE;

	// Create the Objective Manager if it hasn't been created yet.
	if ( ObjectiveMgr == None )
	{
		ObjectiveMgr = new(self) class'GearObjectiveManager';
	}

	// Ensure the profile settings are initially set
	bProfileSettingsUpdated = TRUE;

	// so if we are auto hording then start the killing in N seconds
	if (GearGame(WorldInfo.Game) != None && GearGame(WorldInfo.Game).bDoAutomatedHordeTesting)
	{
		foreach WorldInfo.AllControllers(class'GearPC', PC)
		{
			PC.SetTimer(10.0, false, nameof(PC.Automation_KillMobs));
		}
	}

	// see if we need to check for vehicle interactions
	foreach WorldInfo.AllPawns(class'Vehicle', V)
	{
		bCheckVehicles = true;
		break;
	}

	foreach WorldInfo.AllPawns(class'GearPawnRidable_Base', GRPR)
	{
		bCheckVehicles = true;
		break;
	}

	// default to no host migration
	WorldInfo.ToggleHostMigration(false);
}

/** Clear the contents of the command to bind key cache */
simulated function ClearStringAliasBindingMapCache()
{
	BoundEventsStringDataStore.ClearBoundKeyCache();
}

/** Initialized the tutorial system if it hasn't been inited yet */
reliable client final function ClientInitializeTutorialSystem( EGearAutoInitTutorialTypes TutorialListType, optional bool bAddNonOptionControlledTutorials )
{
	if ( TutorialMgr == None )
	{
		TutorialMgr = new(self) class'GearTutorialManager';
		bTutorialSystemWasOn = true;
		TutorialMgr.StartSystem( bTutorialSystemWasOn, true, TutorialListType );
		// Hack to start the auto tutorials that are not save in the profile
		if (bAddNonOptionControlledTutorials)
		{
			TutorialMgr.AddAutoInitiatedTutorials(false);
		}
	}
}

/** Start the tutorial system */
final function RestartTutorialSystem( optional bool bTurnSystemOn = true, optional bool bWipeTutorials = true )
{
	if ( TutorialMgr != None )
	{
		TutorialMgr.StartSystem( bTurnSystemOn, bWipeTutorials );
		TutorialMgr.AddAutoInitiatedTutorials();
	}
}

/** Stop the tutorial system */
final function StopTutorialSystem( optional bool bWipeTutorials = true )
{
	if ( TutorialMgr != None )
	{
		TutorialMgr.StopSystem( bWipeTutorials );
	}
}

/** Sets a timer that will stop the weapon from firing */
final function StopFiringWeaponAfterTime( float Time )
{
	SetTimer( Time, false, nameof(StopFiringWeapon) );
}

/** Stop the weapon from firing */
final function StopFiringWeapon()
{
	bFire = 0;
	StopFire(0);
	SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
}

/** Stop the weapon from alt firing */
final function StopAltFiringWeapon()
{
	bAltFire = 0;
	StopFire(class'GearWeapon'.const.ALTFIRE_FIREMODE);
	SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
}

/**
* Creates and initializes the "PlayerOwner" and "PlayerSettings" data stores.  This function assumes that the PlayerReplicationInfo
* for this player has not yet been created, and that the PlayerOwner data store's PlayerDataProvider will be set when the PRI is registered.
*
* Overloaded so we can initialize game specific player data stores.
*/
simulated protected function RegisterCustomPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;
	local class<GearUIDataStore_StringAliasBindingsMap> StringAliasBindingsMapDataStoreClass;
	local class<GearUIDataStore_StringAliasMap> StringAliasMapDataStoreClass;

	local StringAliasTag StringAliasTagHandler;
	local ControllerTag ControllerTagHandler;

	// Unregister old profile, clean profile callbacks etc.
	if ( ProfileSettings != None )
	{
		UnregisterPlayerDataStores();
	}

	// only create player data store for local players
	LP = LocalPlayer(Player);

	Super.RegisterCustomPlayerDataStores();
	if ( LP != None )
	{
		// Register a handler for tags of the form <StringAliasBinding: />
		StringAliasTagHandler = new( LP.GetTranslationContext() ) class'StringAliasTag';
		StringAliasTagHandler.Init(LP);
		LP.GetTranslationContext().RegisterTranslatorTag( StringAliasTagHandler );

		// Register an alias handler for <StringAliasBinding: /> so we can remove StringAliasBinding.
		ControllerTagHandler = new( LP.GetTranslationContext() ) class'ControllerTag';
		ControllerTagHandler.Init(LP);
		LP.GetTranslationContext().RegisterTranslatorTag( ControllerTagHandler );

		// Get the warfare specific online data
		ProfileSettings = GearProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
		if (OnlineSub == None)
		{
			// Running -nolive so create profile for you
			ProfileSettings.SetToDefaults();
		}
		PersistentData = GearPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);

		// Replicate the character / weapon settings to the server
		SetPlayerPreferences(ProfileSettings.GetPreferredClassIndex(0), ProfileSettings.GetPreferredClassIndex(1), ProfileSettings.GetPreferredMedalIndex());

		// get a reference to the main data store client
		DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
		if ( DataStoreManager != None )
		{
			// find the "PlayerOwner" data store registered for this player; there shouldn't be one...
			BoundEventsStringDataStore = GearUIDataStore_StringAliasBindingsMap(DataStoreManager.FindDataStore('StringAliasBindings',LP));
			if ( BoundEventsStringDataStore == None )
			{
				// find the appropriate class to use for the PlayerSettings data store
				StringAliasBindingsMapDataStoreClass = class<GearUIDataStore_StringAliasBindingsMap>(DataStoreManager.FindDataStoreClass(class'GearUIDataStore_StringAliasBindingsMap'));
				if ( StringAliasBindingsMapDataStoreClass != None )
				{
					// create the PlayerOwner data store
					BoundEventsStringDataStore = DataStoreManager.CreateDataStore(StringAliasBindingsMapDataStoreClass);
					if ( BoundEventsStringDataStore != None )
					{
						// and register it
						if ( !DataStoreManager.RegisterDataStore(BoundEventsStringDataStore, LP) )
						{
							`log("Failed to register 'StringAliasBindings' data store for player:"@ Self);
						}
					}
					else
					{
						`log("Failed to create 'StringAliasBindings' data store for player:"@ Self @ "using class" @ StringAliasBindingsMapDataStoreClass,,'DevDataStore');
					}
				}
			}
			else
			{
				`log("'StringAliasBindings' data store already registered for player:"@ Self,,'DevDataStore');
			}

			// find the "PlayerOwner" data store registered for this player; there shouldn't be one...
			StringDataStore = GearUIDataStore_StringAliasMap(DataStoreManager.FindDataStore('StringAliasMap',LP));
			if ( StringDataStore == None )
			{
				// find the appropriate class to use for the PlayerSettings data store
				StringAliasMapDataStoreClass = class<GearUIDataStore_StringAliasMap>(DataStoreManager.FindDataStoreClass(class'GearUIDataStore_StringAliasMap'));
				if ( StringAliasMapDataStoreClass != None )
				{
					// create the PlayerOwner data store
					StringDataStore = DataStoreManager.CreateDataStore(StringAliasMapDataStoreClass);
					if ( StringDataStore != None )
					{
						// and register it
						if ( !DataStoreManager.RegisterDataStore(StringDataStore, LP) )
						{
							`log("Failed to register 'StringAlias' data store for player:"@ Self);
						}
					}
					else
					{
						`log("Failed to create 'StringAlias' data store for player:"@ Self @"using class" @ StringAliasMapDataStoreClass,,'DevDataStore');
					}
				}
			}
			else
			{
				`log("'StringAlias' data store already registered for player:"@ Self,,'DevDataStore');
			}
		}
	}
}

/**
* Unregisters the "PlayerOwner" data store for this player.  Called when this PlayerController is destroyed.
*
* Overloaded so we can unregister game specific player data stores.
*/
simulated function UnregisterPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;

	// only execute for local players
	LP = LocalPlayer(Player);
	if ( LP != None )
	{
		// Clear profile ref
		ProfileSettings = None;
		PersistentData = None;

		// unregister it from the data store client and clear our reference
		// get a reference to the main data store client
		DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
		if ( DataStoreManager != None )
		{
			// unregister the bound events string data store
			if ( BoundEventsStringDataStore != None )
			{
				if ( !DataStoreManager.UnregisterDataStore(BoundEventsStringDataStore) )
				{
					`log("Failed to unregister 'StringAliasBindings' data store for player:"@Self);
				}

				// clear the reference
				BoundEventsStringDataStore = None;
			}
			else
			{
				`log("'StringAliasBindings' data store not registered for player:" @ Self,,'DevDataStore');
			}

			// unregister the string data store
			if ( StringDataStore != None )
			{
				if ( !DataStoreManager.UnregisterDataStore(StringDataStore) )
				{
					`log("Failed to unregister 'StringAlias' data store for player:"@ Self);
				}

				// clear the reference
				StringDataStore = None;
			}
			else
			{
				`log("'StringAlias' data store not registered for player:" @ Self,,'DevDataStore');
			}
		}
		else
		{
			`log("Data store client not found!",,'DevDataStore');
		}

	}

	Super.UnregisterPlayerDataStores();
}

/** Overridden from PlayerController to set the default camera mode. */
function SpawnPlayerCamera()
{
	super.SpawnPlayerCamera();

	// default camera mode
	SetCameraMode('default');
}

/**
 * Force load anims (matinee and specified animsets) from lazy arrays to
 * get rid of load hitches.
 */
native final function PreCacheAnimations();

event ConditionalPause(bool bDesiredPauseState)
{
	// client can't pause
	if (WorldInfo.NetMode != NM_Client)
	{
		Super.ConditionalPause(bDesiredPauseState);
	}
}

/** Find and store all the points of interest in the level */
simulated function StorePointsOfInterest()
{
	local GearPointOfInterest POI;

	foreach DynamicActors(class'GearPointOfInterest',POI)
	{
		if ( POI.bEnabled )
		{
			AddPointOfInterest( POI );
		}
	}
}

/** Whether the player has line of sight to the POI or not */
simulated function bool HasLineOfSightToPOI( GearPointOfInterest POI )
{
	local Actor HitActor;
	local vector ActualLookatLoc, HitLoc, HitNormal, StartTrace, StartTraceAdj;

	// See if we should trace for line of sight
	if ( POI.bForceLookCheckLineOfSight )
	{
		ActualLookatLoc = POI.GetActualLookatLocation();
		StartTrace = Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight();

		if (MyGearPawn != None)
		{
			// adjust starttrace right a little, to account for camera offset
			StartTraceAdj = vect(0,64,0);
			if (MyGearPawn.bIsMirrored)
			{
				StartTraceAdj.Y = -StartTraceAdj.Y;
			}
			StartTrace += StartTraceAdj >> rotator(ActualLookatLoc-StartTrace);
		}

		HitActor = Trace( HitLoc, HitNormal, ActualLookatLoc, StartTrace );

		if ( (HitActor != None) && (HitActor != POI.AttachedToActor) )
		{
			return false;
		}
	}

	return true;
}

/**
 * Returns the actor the camera is currently focused on (via a LookAt or whatever), or None if none.
 */
simulated protected function Actor GetCameraFocusActor()
{
	return GearPlayerCamera(PlayerCamera).GameplayCam.GetFocusActor();
}

/** Force the player to look at a POI */
simulated function ProcessPOI( optional GearPointOfInterest POI, optional bool bUserInstigated )
{
	local GearPointOfInterest BestPOI, CurrPOI;

	// First see which POI is best to look at
	BestPOI = FindBestPOIToLookAt( POI );
	// If a POI was passed in and it's not the best one or there is no best one, do nothing
	if ( (BestPOI == None) || ((POI != None) && (POI != BestPOI)) )
	{
		return;
	}

	// Do a line of sight check if we need to, returning if failed
	if ( (BestPOI.ForceLookType != ePOIFORCELOOK_None) && BestPOI.bForceLookCheckLineOfSight )
	{
		if ( !HasLineOfSightToPOI(BestPOI) )
		{
			return;
		}
	}

	// See if we need to stop an old look at or return because we're about to look at the same one
	if ( bLookingAtPointOfInterest )
	{
		CurrPOI = GearPointOfInterest(GetCameraFocusActor());
		if (CurrPOI != None)
		{
			// Same POI so return
			if ( CurrPOI == BestPOI )
			{
				return;
			}

			// Different POI, so stop it
			if ( CurrPOI != None )
			{
				StopForceLookAtPointOfInterest( bUserInstigated );
			}
		}
	}

	// Look at the POI
	ForceLookAtPointOfInterest( bUserInstigated, BestPOI );
}

/**
 * Add a point of interest this client can look at, optionally forced.
 */
simulated function AddPointOfInterest( GearPointOfInterest POI )
{
	local int Idx, CurrPriority;

	if (POI != None)
	{
		// Set locally in case of networked games
		POI.bEnabled = TRUE;

		// Add to list
		if (EnabledPointsOfInterest.Find(POI) == INDEX_NONE)
		{
			EnabledPointsOfInterest[EnabledPointsOfInterest.length] = POI;
			POILookedAtList[POILookedAtList.length] = false;
		}

		// If this poi wants us to disable the other scripted pois, then do so
		if ( POI.bDisableOtherPOIs )
		{
			ClearFocusPoint( false );
			for ( Idx = 0; Idx < EnabledPointsOfInterest.length; Idx++ )
			{
				if ( (EnabledPointsOfInterest[Idx] != POI) && EnabledPointsOfInterest[Idx].bEnabled )
				{
					CurrPriority = EnabledPointsOfInterest[Idx].GetLookAtPriority( self );
					if ( CurrPriority >= class'GearPointOfInterest'.Default.POIPriority_ScriptedEvent )
					{
						EnabledPointsOfInterest[Idx].bEnabled = false;
					}
				}
			}
		}

		// If we are doing an automatic force-look, or the player is already looking at a POI, try and process it
		if ( (POI.ForceLookType == ePOIFORCELOOK_Automatic) || (bLookingAtPointOfInterest && IsHoldingPOIButton()) )
		{
			ProcessPOI( POI, (bLookingAtPointOfInterest && IsHoldingPOIButton()) );
		}
	}
}

/**
* Removes a point of interest from the potential list.
*/
simulated function RemovePointOfInterest( GearPointOfInterest POI, optional EPOIForceLookType ForceLookType )
{
	local int Idx;

	if ( POI != None )
	{
		Idx = EnabledPointsOfInterest.Find( POI );
		if ( Idx >= 0 )
		{
			EnabledPointsOfInterest.Remove( Idx, 1 );
			POILookedAtList.Remove( Idx, 1 );
			if (GetCameraFocusActor() == POI)
			{
				StopForceLookAtPointOfInterest();
			}
		}
	}
}

/**
 * Tell HUD to display ammo message
 */
reliable client function ClientAddAmmoMessage(class<GearDamageType> DamageClass, int AmountAdded, optional bool bWasAmmoShare)
{
	if ( (myHUD != None) && myHUD.bShowHUD && (DamageClass != None) )
	{
		MyGearHud.LastWeaponInfoTime = WorldInfo.TimeSeconds;
		MyGearHud.AddAmmoMessage(PlayerReplicationInfo, DamageClass, AmountAdded, bWasAmmoShare);
	}

	if (class<GearWeapon>(class'GearTypes'.default.WeaponClasses[DamageClass.default.WeaponID]) != None)
	{
		ModifyStat(name(class<GearWeapon>(class'GearTypes'.default.WeaponClasses[DamageClass.default.WeaponID]).default.WeaponStatName $ "Pickups" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix));
	}
}

function SetLastWeaponInfoTime(float NewTime)
{
	if ( (MyGearHud != None) && myHUD.bShowHUD )
	{
		MyGearHud.LastWeaponInfoTime = NewTime;
	}
}

simulated function OnPlayWaveForm( SeqAct_PlayWaveForm inAction )
{
	ClientPlayForceFeedbackWaveform( inAction.WaveForm );
}

/**
 * @return	TRUE if starting a force feedback waveform is allowed;  child classes should override this method to e.g. temporarily disable
 * 			force feedback
 */
simulated function bool IsForceFeedbackAllowed()
{
	return Super.IsForceFeedbackAllowed() && MyGearHud != None && MyGearHud.UI_PauseSceneInstance == None;
}



/**
 * Handles switching the player in/out of animation mode.
 * This isn't same as Cinematic Mode.
 * Cinematic mode does hide hud or destroy all extra weapons for preparation
 * This one makes player to go animation mode - disabling inputs
 */
function OnToggleMatineeMode(SeqAct_ToggleMatineeMode Action)
{
	if (MyGearPawn==none)
	{
		`log( GetFuncName()@": MyGearPawn == none." );
		return;
	}

	MyGearPawn.OnToggleMatineeMode(Action);
}


simulated function TurnOnBehavior(bool bBehaviorOn)
{
	if (bBehaviorOn)
	{
		MyGearPawn.EndSpecialMove( SM_Engage_Matinee );
		ClientGotoState( 'PlayerWalking' );
		GotoState( 'PlayerWalking' );
		// enable input
		EnableInput(TRUE, TRUE, FALSE);
	}
	else
	{
		MyGearPawn.DoSpecialMove( SM_Engage_Matinee, true );
		// disable input
		DisableInput(TRUE, TRUE, FALSE);
	}

}

reliable client function ClientCameraLookAtFinished(SeqAct_CameraLookAt Action)
{
	CameraLookAtFinished(Action);
}

/**
 * The function that gets called when the cameralookat is done.
 * This cleans up the CameraLookAt mode for kismet.
 */
simulated event CameraLookAtFinished(SeqAct_CameraLookAt Action)
{
	local GearPlayerCamera	Cam;

	Focus = None;

	if( Action.bAffectCamera )
	{
		Cam = GearPlayerCamera(PlayerCamera);
		ClearCameraFocus(Action, Cam);
	}

	if( Action.bAffectHead && MyGearPawn != None)
	{
		MyGearPawn.SetHeadTrackActor(None);
		if (MyGearPawn.HeadTrackDelayCountDown < 2.0f)
		{
			MyGearPawn.HeadTrackDelayCountDown = 2.0f;
		}
	}

	if (LocalPlayer(Player) == None)
	{
		ClientCameraLookAtFinished(Action);
	}
}

/** Undo the CameraLookAt */
simulated function ClearCameraFocus(SeqAct_CameraLookAt Action, GearPlayerCamera Cam)
{
	ClearFocusPoint(TRUE, Action.bLeaveCameraRotation );
	// clear camera god mode
	if ( bCameraGodMode )
	{
		bCameraGodMode = FALSE;
	}

	// clear the tooltip
	if ( MyGearHud != None )
	{
		MyGearHud.ClearActionInfoByType(AT_ForceLook);
	}

	// Turn input back on.
	if ( Action.bDisableInput )
	{
		EnableInput(true,true,true);
	}
}

function OnCameraLookAt(SeqAct_CameraLookAt Action)
{
	local array<Object> ObjVars;
	local int Idx;
	local Actor FocusActor;
	local Controller C;

	// Find the first supplied actor
	Action.GetObjectVars(ObjVars, "Focus");
	for( Idx = 0; Idx < ObjVars.Length && FocusActor == None; Idx++ )
	{
		FocusActor = Actor(ObjVars[Idx]);

		// If its a player variable, look at pawn not controller
		C = Controller(FocusActor);
		if( C != None && C.Pawn != None )
		{
			FocusActor = C.Pawn;
		}
	}

	ProcessCameraLookAt(Action, FocusActor);
	if (LocalPlayer(Player) == None)
	{
		ClientProcessCameraLookAt(Action, FocusActor);
	}
}

simulated function ProcessCameraLookAt(SeqAct_CameraLookAt Action, Actor FocusActor)
{
	local GearPlayerCamera		Cam;
	local ActionInfo			HUDAction;
	local SkeletalMeshComponent ComponentIt;
	local vector				FocusLocation, HitLoc, HitNormal, StartTrace, StartTraceAdj;
	local actor					HitActor;

	if (Action.bCheckLineOfSight)
	{
		FocusLocation = FocusActor.Location;
		if( Action.FocusBoneName != 'None' && Action.FocusBoneName != '' )
		{
			// find a skeletal mesh component on the focus actor
			foreach FocusActor.ComponentList(class'SkeletalMeshComponent', ComponentIt)
			{
				FocusLocation = ComponentIt.GetBoneLocation(Action.FocusBoneName);
				break;
			}
		}

		StartTrace = Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight();

		if (MyGearPawn != None)
		{
			// adjust starttrace right a little, to account for camera offset
			StartTraceAdj = vect(0,64,0);
			if (MyGearPawn.bIsMirrored)
			{
				StartTraceAdj.Y = -StartTraceAdj.Y;
			}
			StartTrace += StartTraceAdj >> rotator(FocusLocation-StartTrace);
		}

		HitActor = Trace(HitLoc, HitNormal, FocusLocation, StartTrace);

		if ( (HitActor != None) && (HitActor != FocusActor) )
		{
			// activate failed output
			Action.OutputLinks[3].bHasImpulse = TRUE;

			// and BAIL!
			return;
		}
	}


	Focus = FocusActor;

	// If we have a focus, update camera focuspoint. These params are used by the camera to look at focus point.
	if( Action.bAffectCamera )
	{
		Cam = GearPlayerCamera(PlayerCamera);

		if( FocusActor != None )
		{
			SetFocusPoint(
				TRUE,
				FocusActor,
				Action.InterpSpeedRange,
				Action.InFocusFOV,
				Action.CameraFOV,
				Action.bAlwaysFocus,
				!Action.bTurnInPlace,
				Action.bIgnoreTrace,
				Action.FocusBoneName );

			if ( (MyGearHud != None) && (Len(Action.TextDisplay) > 0) )
			{
				HUDAction.ToolTipText = Action.TextDisplay;
				MyGearHud.SetActionInfo(AT_ForceLook, HUDAction);
			}

			if ( Action.bToggleGodMode )
			{
				// if not already in god mode
				if (!bGodMode)
				{
					bCameraGodMode = TRUE;
				}
			}

			// Turn input off if disabled and the action has a duration
			if (Action.bDisableInput) // && Action.bUsedTimer) comment due to legacy kimset in gears
			{
				DisableInput(true,true,true);
			}
		}
		else
		{
			ClearCameraFocus(Action, Cam);
		}
	}

	if( Action.bAffectHead )
	{
		// Force Head Tracking
		MyGearPawn.SetHeadTrackActor(FocusActor, Action.FocusBoneName, TRUE);
	}

	// activate succeeded output
	Action.OutputLinks[2].bHasImpulse = TRUE;
}

/** calls ProcessCameraLookAt on the client
 * @warning: assumes the various properties of Action aren't changed at runtime, since those changes won't happen on the client
 */
reliable client function ClientProcessCameraLookAt(SeqAct_CameraLookAt Action, Actor FocusActor)
{
	ProcessCameraLookAt(Action, FocusActor);
}

reliable client function ClientSetForcedCameraFOV(float inFOV)
{
	local GearPlayerCamera Cam;

	Cam = GearPlayerCamera(PlayerCamera);
	Cam.bUseForcedCamFOV = TRUE;
	Cam.ForcedCamFOV = inFOV;
}

reliable client function ClientClearForcedCameraFOV()
{
	local GearPlayerCamera Cam;

	Cam = GearPlayerCamera(PlayerCamera);
	Cam.bUseForcedCamFOV = FALSE;
}

function OnCameraSetFOV(SeqAct_CameraSetFOV Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		ClientSetForcedCameraFOV(Action.DesiredFOV);
	}
	else
	{
		ClientClearForcedCameraFOV();
	}
}


function OnSpawnCameraLensEffect(SeqAct_SpawnCameraLensEffect Action)
{
	ClientSpawnCameraLensEffect( Action.LensEffectToSpawn );
}

/** Make the AI go back to normal mood since we are shutting taccom off */
function ResetTaccomAIMoods()
{
	local GearAI AI;
	local GearPRI AIPRI;

	foreach WorldInfo.AllControllers(class'GearAI',AI)
	{
		AIPRI = GearPRI(AI.PlayerReplicationInfo);
		// if they're in the same squad
		if ( AIPRI != None )
		{
			AI.SetCombatMood(AICM_Normal);
		}
	}
}

/**
* Forward SeqAct_AIMove to GearAI, if we have one
*/
function OnAIMove(SeqAct_AIMove Action);

/**
 * Server/SP only function for changing whether the player is in cinematic mode.  Updates values of various state variables, then replicates the call to the client
 * to sync the current cinematic mode.
 *
 * @param	bInCinematicMode	specify TRUE if the player is entering cinematic mode; FALSE if the player is leaving cinematic mode.
 * @param	bHidePlayer			specify TRUE to hide the player's pawn (only relevant if bInCinematicMode is TRUE)
 * @param	bAffectsHUD			specify TRUE if we should show/hide the HUD to match the value of bCinematicMode
 * @param	bAffectsMovement	specify TRUE to disable movement in cinematic mode, enable it when leaving
 * @param	bAffectsTurning		specify TRUE to disable turning in cinematic mode or enable it when leaving
 * @param	bAffectsButtons		specify TRUE to disable button input in cinematic mode or enable it when leaving.
 */
function SetCinematicMode( bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons )
{
	local bool bAdjustButtonInput;
	local GearAI AI;

	if (Role < ROLE_Authority)
	{
		`Warn("Not supported on client");
		return;
	}

	// Calling super will apply the value of bInCinematicMode to bCinematicMode
	Super.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);

	// Make player invisible to AI during cinematics
	bInvisible = bCinematicMode;
	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		AI.StopFiring();
	}

	bAdjustButtonInput = bAffectsButtons && (bCinematicMode != bCinemaDisableInputButtons);

	if( Pawn != None )
	{
		Pawn.SetCinematicMode( bCinematicMode );
	}

	if (bCinematicMode)
	{
		ClientStopForceFeedbackWaveform();
		ClientBreakFromCover();
		ExecuteMeatshields();
		ReviveTeammates();
		ServerReviveSelf();
		StopPostProcessOverride(CurrentPPType);
		// reset taccom FX as well
		if (MyGearHud != None)
		{
			MyGearHud.ResetTaccomOpacity();
			MyGearHud.CloseDiscoverableScene();
		}
	}

	if ( bAdjustButtonInput )
	{
		if ( bCinematicMode )
		{
			DisableInput(TRUE, FALSE, FALSE);
			if (LocalPlayer(Player) == None)
			{
				ClientDisableButtons();
			}
		}
		else
		{
			EnableInput(TRUE, FALSE, FALSE);
			if (LocalPlayer(Player) == None)
			{
				ClientEnableButtons();
			}
		}
		bCinemaDisableInputButtons = bCinematicMode;
	}

	// disable guds during cinematics
	if (GearGame(WorldInfo.Game).UnscriptedDialogueManager != None)
	{
		GearGame(WorldInfo.Game).UnscriptedDialogueManager.SetDisabled(bCinematicMode);
	}
}

/** called by the server to synchronize cinematic transitions with the client */
reliable client function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
	local int LODIdx;
	local GearPawn_COGGear COGPawn;
	local SkeletalMeshActor SkelMeshActor;

	Super.ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);

	if (myGearHUD != None)
	{
		myGearHUD.ActiveAction.bActive = FALSE;  // when we are in cinematic mode we need to clear any active ActionIcons

		// if the cinematic mode toggles the HUD off, we have to clean up the HUD
		if (myGearHUD.bShowHUD)
		{
			myGearHUD.ClearHUDAfterShowToggle();
		}

		if (bCinematicMode)
		{
			// reset taccom FX as well
			MyGearHud.ResetTaccomOpacity();
			MyGearHud.CloseDiscoverableScene();
		}
	}

	// Deactivate the active tutorial if there is one
	if (bCinematicMode && TutorialMgr != none)
	{
		TutorialMgr.RebootSystem();
	}

	// let the UI know that cinematic mode has [potentially] changed, so it should update cached viewport sizes for any open scenes
	UpdateUIViewportSizes();

	// toggle the cinematic weights
	if (IsPrimaryPlayer())
	{
		foreach WorldInfo.DynamicActors(class'SkeletalMeshActor', SkelMeshActor)
		{
			for (LODIdx=0; LODIdx<SkelMeshActor.SkeletalMeshComponent.LODInfo.length;LODIdx++)
			{
				if (SkelMeshActor.SkeletalMeshComponent.LODInfo[LODIdx].InstanceWeightUsage == IWU_FullSwap)
				{
					SkelMeshActor.SkeletalMeshComponent.ToggleInstanceVertexWeights(bInCinematicMode,LODIdx);
				}
			}
		}

		foreach WorldInfo.AllPawns(class'GearPawn_COGGear', COGPawn)
		{
			for (LODIdx=0; LODIdx<COGPawn.Mesh.LODInfo.length;LODIdx++)
			{
				if (COGPawn.Mesh.LODInfo[LODIdx].InstanceWeightUsage == IWU_FullSwap)
				{
					COGPawn.Mesh.ToggleInstanceVertexWeights(bInCinematicMode,LODIdx);
				}
			}
		}
	}
}

simulated function UpdateUIViewportSizes()
{
	local GameUISceneClient SceneClient;
	local bool bWasForcingFullscreen;
	local LocalPlayer SecondPlayer;

	SceneClient = class'UIRoot'.static.GetSceneClient();

	// only relevant if we're playing split-screen - otherwise all scenes are always fullscreen
	if ( SceneClient != None && IsSplitscreenPlayer() )
	{
		SecondPlayer = class'UIInteraction'.static.GetLocalPlayer(1);

		bWasForcingFullscreen = SecondPlayer.Size.Y == 0;
		if ( SceneClient.Outer.Outer.ShouldForceFullscreenViewport() != bWasForcingFullscreen )
		{
			SceneClient.bUpdateSceneViewportSizes = true;
		}
	}

	RefreshAllSafeZoneViewports();
}

/** called by the server to synchronize cinematic transitions with the client */
reliable client function ClientDisableButtons()
{
	DisableInput(true, false, false);
}
reliable client function ClientEnableButtons()
{
	EnableInput(true, false, false);
}

/** Returns TRUE if you are in a coop-enabled mode. */
final function bool IsCoop()
{
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);
	return (GRI != None && (GRI.bIsCoop || GRI.IsCoopMultiplayerGame()));
}

/** returns TRUE if we are in a coop-enabled mode and more than 1 player is active */
simulated final event bool IsActuallyPlayingCoop()
{
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		return GRI.IsActuallyPlayingCoop();
	}

	return false;
}

/** Whether there is a teammate to spectator or not */
final function bool CanSpectateTeammate()
{
	local int Idx;
	local GearPRI CurrPRI;

	if (PlayerReplicationInfo.bOnlySpectator)
	{
		return TRUE;
	}
	if ( WorldInfo.GRI != None )
	{
		for ( Idx = 0; Idx < WorldInfo.GRI.PRIArray.length; Idx++ )
		{
			CurrPRI = GearPRI(WorldInfo.GRI.PRIArray[Idx]);
			if ( PlayerReplicationInfo != CurrPRI &&
				 !CurrPRI.bIsDead )
			{
				return TRUE;
			}
		}
	}
	return FALSE;
}

unreliable server function ServerViewNearestPlayer()
{
	local vector CamLoc;
	local rotator CamRot;
	local float BestValue, Value;
	local GearPawn GP, BestGP;
	BestValue = 999999.f;
	GetPlayerViewPoint(CamLoc,CamRot);
	foreach WorldInfo.AllPawns(class'GearPawn',GP)
	{
		if (GP != None && GP.PlayerReplicationInfo != None && GP.Health > 0 && WorldInfo.Game.CanSpectate(self,GP.PlayerReplicationInfo))
		{
			Value = VSize(CamLoc - GP.Location) * (1.f - (Normal(GP.Location - CamLoc) dot vector(CamRot)));
			if (Value < BestValue && Value > 0)
			{
				BestValue = Value;
				BestGP = GP;
			}
		}
	}
	if (BestGP != None)
	{
		SetViewTarget(BestGP.PlayerReplicationInfo);
	}
	else
	{
		ServerViewNextPlayer();
	}
}

unreliable server function ServerViewNextPlayer()
{
	if (IsSpectating() && GearGRI(WorldInfo.GRI).GameStatus != GS_RoundOver)
	{
		Super.ServerViewNextPlayer();
	}
}

unreliable server function ServerViewPrevPlayer()
{
	if (IsSpectating())
	{
		Super.ServerViewPrevPlayer();
	}
}

function OnAIForceSwitchWeapon(SeqAct_AIForceSwitchWeapon Action)
{
	local Weapon FoundWeapon;
	FoundWeapon = Weapon(Pawn.InvManager.FindInventoryType(Action.ForcedWeaponType));
	if (FoundWeapon != None)
	{
		Pawn.InvManager.SetCurrentWeapon(FoundWeapon);
	}
}

function OnForceRoadieRun(SeqAct_ForceRoadieRun InAction)
{
	if( InAction.InputLinks[0].bHasImpulse )
	{
		bForcedRoadieRun = TRUE;
		MyGearPawn.ServerDoSpecialMove(SM_RoadieRun, true);
	}
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		bForcedRoadieRun = FALSE;
	}
}

auto state PlayerWaiting
{
	simulated function BeginState(Name PreviousStateName)
	{
		super.BeginState( PreviousStateName );

		if ( GetPRI() != None )
		{
			GetPRI().PlayerStatus = WPS_Spectating;
		}
		bIsUsingStreamingVolumes = FALSE;
	}

	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);

		bIsUsingStreamingVolumes = true;
	}

	function PlayerMove(float DeltaTime)
	{
		// don't allow player movement during startup spectating
		if (GetStateName() != 'PlayerWaiting')
		{
			Super.PlayerMove(DeltaTime);
		}
	}
}

//Out of spectator, but not yet assigned a pawn
state WaitingForPawn
{
	//Overriden to ensure that the spectator camera rotation and location do not override the pawn's if you receive it before the state has transitioned
	function PlayerMove(float DeltaTime);
}

/*
 * Called at game over to do book keeping
 */
function ProcessGameOver()
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.GuardianAngelWasKilled();
		PC.ClientGameOver(GameOverReason, GameOverTarget);
	}
}

/** called by the server to display the game over screen */
reliable client event ClientGameOver(string Reason, GearPRI Target)
{
	GearHUD_Base(MyHUD).ShowGameOverScreen(Reason, Target);
}

state Dead
{
	ignores SeePlayer, HearNoise, KilledBy;

	function EnableAssessMode();

	function bool WantsSpectatorUI()
	{
		return (!bFrozen && WorldInfo.GRI != None && (WorldInfo.GRI.IsMultiplayerGame() || ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSP_Arcade')));
	}

	function BeginState(Name PreviousStateName)
	{
		local GearGRI GRI;

		Super.BeginState(PreviousStateName);

		LastPawn = Pawn(ViewTarget);
		GetPRI().PlayerStatus = WPS_Dead;

		// Turn off targeting when you die
		bIsTargeting = FALSE;
		SetTargetingMode( FALSE );

		DisableAssessMode();

		StopMeleeAdhesion();
		StopForcedAdhesion();

		if (IsLocalPlayerController())
		{
			// Don't enable the bleedout override if the round is over, which ensures that it doesn't interfere with other menu post processing override blends
			GRI = GearGRI(WorldInfo.GRI);
			if (!IsDoingSpecialMove(SM_Hostage) && ((GRI == None) || (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)))
			{
				StartPostProcessOverride(eGPP_BleedOut);
			}
			// forcefully clear any vibration
			SetTimer(1.f,FALSE,nameof(ClientStopForceFeedbackWaveform));
		}

		// if we are not in a MP game this is a fail condition outright
		if( !WorldInfo.GRI.IsMultiplayerGame() )
		{
			if ( Role == ROLE_Authority && !WorldInfo.IsPlayInEditor() && !PlayingDevLevel() &&
				GearGameSP_Base(WorldInfo.Game).ShouldDeathCauseFailure(self) )
			{
				GameOverReason = "GearGame.GearGameSP_Base.PlayerDiedText";
				GameOverTarget = GearPRI(PlayerReplicationInfo);
				SetTimer(5.f, false, nameof(ProcessGameOver));
			}
		}
		else
		{
			// every time we die on the client go ahead and collect garbage
			if( Role < Role_Authority )
			{
				WorldInfo.ForceGarbageCollection();
			}
		}

		// Deactivate the active tutorial if there is one
		if (TutorialMgr != none)
		{
			TutorialMgr.RebootSystem();
		}

		if (Role == Role_Authority && WorldInfo.GRI.IsMultiplayerGame())
		{
			// call this on a separate timer since we can transition out of the dead state early if the user chooses to spectate immediately
			SetTimer(3.f, false, nameof(WaitForRespawn));
		}

		// Saves Parameter before wait for death cam
		if (GearPawn(LastPawn) != None)
		{
			KilledByPawn = GearPawn(LastPawn).KilledByPawn;
			KilledLocation = LastPawn.Location;
		}
		else
		{
			KilledByPawn = None;
			KilledLocation = vect(0,0,0);
		}
	}

	function EndState(Name NextStateName)
	{
		local GearPRI GPRI;

		Super.EndState(NextStateName);

		GPRI = GetPRI();
		if (GPRI != None && GPRI.PlayerStatus != WPS_Respawning)
		{
			GPRI.PlayerStatus = WPS_Dead;
		}
		// if we're being destroyed and not somehow resurrected, force the game over to happen immediately
		// None is passed when ending state due to destruction
		if (NextStateName == 'None' && LocalPlayer(Player) == None && IsTimerActive(nameof(ProcessGameOver)))
		{
			ProcessGameOver();
		}
		ClearTimer(nameof(ProcessGameOver));

		BiggestThreatWP = None;
		ClearFocusPoint(FALSE);		// clear both kismet and nonkismet lookats
		ClearFocusPoint(TRUE);

		if( MyGearHUD != None )
		{
			if (WorldInfo.GRI != None && !WorldInfo.GRI.IsMultiplayerGame())
			{
				MyGearHUD.ClearActionInfoByType(AT_StayingAlive);
				MyGearHUD.ClearActionInfoByType(AT_SuicideBomb);
			}
			MyGearHUD.ResetTaccomOpacity();
		}
		ResetPlayerMovementInput();

		if (IsLocalPlayerController())
		{
			StopPostProcessOverride(eGPP_BleedOut,0.0);
		}
	}

	exec function StartFire( optional Byte FireModeNum )
	{
		if (!bFrozen)
		{
			TransitionFromDeadState();
		}
	}

	event Timer()
	{
		// don't turn off bFrozen and allow spectator control if we're going to end the game in failure
		if (!IsTimerActive(nameof(ProcessGameOver)))
		{
			Super.Timer();
		}
	}

	function PlayerMove(float DeltaTime)
	{
		ViewShake(DeltaTime);
	}

	function bool UseDeathCam()
	{
		local GearGame GG;
		local GearPawn GP;

		GG = GearGame(WorldInfo.Game);
		GP = GearPawn(LastPawn);

		return (GP!=none && GG.bEnableDeathCam && KilledByPawn!=none &&
			VSize(KilledByPawn.Location - LastPawn.Location) > GG.MinDeathCamActiveDistance &&
			!(GP.IsAKidnapper() || GP.IsAHostage()));
	}

Begin:
	// notify the HUD so it can cleanup
	if( myHUD != None )
	{
		myHUD.PlayerOwnerDied();
	}
	if (LastPawn != None && Pawn(ViewTarget) == None)
	{
		// if we died as a meatshield then view the player who grabbed us
		if (GearPawn(LastPawn) != None && GearPawn(LastPawn).IsAHostage() && GearPawn(LastPawn).InteractionPawn != None)
		{
			SetViewTarget(GearPawn(LastPawn).InteractionPawn);
		}
		else
		{
			// otherwise focus our body
			SetViewTarget(LastPawn);
		}

		// if we died from a GDT
		if (class<GearDamageType>(LastPawn.HitDamageType) != None)
		{
			// call the static handler for any special cases
			class<GearDamageType>(LastPawn.HitDamageType).static.HandleDeadPlayer(self);
		}
	}
	if (Role == Role_Authority && WorldInfo.GRI.IsMultiplayerGame())
	{
		// if hostaged, don't do it
		if (UseDeathCam())
		{
			// wait until death cam finishes
			Sleep(2.0f);

			if (KilledByPawn!=none)
			{
				SetViewTarget(KilledByPawn);
			}

			Sleep(3.0f);

			// go back to original pawn
			SetViewTarget(LastPawn);
		}
		else
		{
			// don't leave this view while our body is still being held by the enemy
			while (GearPawn(ViewTarget) != None && (GearPawn(ViewTarget).IsAKidnapper() || GearPawn(ViewTarget).IsAHostage()))
			{
				Sleep(0.1);
			}

			Sleep(5.0f);
		}

		if (MyGearHUD != None)
		{
			MyGearHUD.SpectatorCameraFadeOut(false, 0.3);
		}
		Sleep(0.3);
		TransitionFromDeadState();
	}
}

 /**
 * CustomSpectating
 * Default spectating state that attempts to use the level placed cameras to spectate.
 */
state CustomSpectating extends Spectating
{
	reliable client function ClientRestart(Pawn NewPawn)
	{
		Global.ClientRestart(NewPawn);
	}

	function PickInitialViewTarget()
	{
		local GearPlayerCamera GearCam;

		// Revert zoom
		GearCam = GearPlayerCamera(PlayerCamera);
		if (GearCam != None)
		{
			GearCam.SpectatorCam.ControlInfo_Zoom = 0;
		}

		ViewFirstSpectatorPoint();
	}

	function PickNextViewTarget()
	{
		local GearPlayerCamera GearCam;

		// Revert zoom
		GearCam = GearPlayerCamera(PlayerCamera);
		if (GearCam != None)
		{
			GearCam.SpectatorCam.ControlInfo_Zoom = 0;
		}

		ViewNextSpectatorPoint();
	}

	function PickPrevViewTarget()
	{
		local GearPlayerCamera GearCam;

		// Revert zoom
		GearCam = GearPlayerCamera(PlayerCamera);
		if (GearCam != None)
		{
			GearCam.SpectatorCam.ControlInfo_Zoom = 0;
		}

		ViewPrevSpectatorPoint();
		MyGearHud.SpectatorCameraFadeIn();
	}

	function bool IsSpectating()
	{
		return true;
	}

	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		CacheBattleCamPath();

		PickInitialViewTarget();
	}

	function EndState(Name NextStateName)
	{
		if (NextStateName != 'GhostSpectating' && NextStateName != 'PlayerSpectating')
		{
			Super.EndState(NextStateName);
		}

		// leave the map up while seamless travel is still finishing
		if (GearGRI(WorldInfo.GRI) != None && GearGRI(WorldInfo.GRI).GameStatus != GS_Loading)
		{
			SetOverheadMapActive(false);
		}
	}

	function UpdateRotation(float DeltaTime)
	{
		local rotator DeltaRot, ViewRotation;
		local float MaxDeltaRot;
		local GearSpectatorPoint SpectatorPt;

		SpectatorPt = GearSpectatorPoint(GetViewTarget());
		if (SpectatorPt != None)
		{
			// Calculate Delta to be applied on ViewRotation
			DeltaRot.Yaw	= PlayerInput.aTurn;
			DeltaRot.Pitch	= PlayerInput.aLookUp;

			MaxDeltaRot = SpectatorPt.MaxRotationRate * DeltaTime;
			DeltaRot.Yaw = FClamp(DeltaRot.Yaw, -MaxDeltaRot, MaxDeltaRot);
			DeltaRot.Pitch = FClamp(DeltaRot.Pitch, -MaxDeltaRot, MaxDeltaRot);

			ViewRotation = Rotation;
			ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
			SetRotation( ViewRotation );
		}
		else
		{
			super.UpdateRotation(DeltaTime);
		}
	}

	function PlayerTick( float DeltaTime )
	{
		local GearPlayerCamera GearCam;

		Global.PlayerTick(DeltaTime);

		if (BattleCamPath != None )
		{
			BattleCamPath.UpdateCameraPosition(DeltaTime);

			// pass along control info
			GearCam = GearPlayerCamera(PlayerCamera);
			if (GearCam != None)
			{
				GearCam.SpectatorCam.ControlInfo_LookRight = PlayerInput.bInvertTurn ? -PlayerInput.RawJoyLookRight : PlayerInput.RawJoyLookRight;
				GearCam.SpectatorCam.ControlInfo_LookUp = PlayerInput.bInvertMouse ? -PlayerInput.RawJoyLookUp : PlayerInput.RawJoyLookUp;
				GearCam.SpectatorCam.ControlInfo_Zoom = FClamp(PlayerInput.RawJoyUp * DeltaTime + GearCam.SpectatorCam.ControlInfo_Zoom, -1.0f, 1.0f);
			}
		}
	}
}

/**
 * PlayerSpectating
 * Allows the player to view other players to spectate.
 */
state PlayerSpectating extends CustomSpectating
{
	function PickInitialViewTarget()
	{
		// don't override a valid already set ViewTarget
		if (GearPawn(ViewTarget) == None || ViewTarget.bTearOff || ViewTarget.IsInState('Dying') || GearPawn(ViewTarget).IsAHostage())
		{
			ServerViewBestPlayer();
			// if there is no available target then go to battle cam
			if (ViewTarget == None || ViewTarget == self)
			{
				TransitionToSpectate('CustomSpectating');
			}
		}
	}

	function PickNextViewTarget()
	{
		ServerViewNextPlayer();
	}

	function PickPrevViewTarget()
	{
		ServerViewPrevPlayer();
	}

	function PlayerTick( float DeltaTime )
	{
		if ( ViewTarget == None || ViewTarget.bDeleteMe || ViewTarget == self ||
			(GearPawn(ViewTarget) != None && ViewTarget.IsInState('Dying') && WorldInfo.TimeSeconds - GearPawn(ViewTarget).TimeOfDeath > 6.0f) )
		{
			PickInitialViewTarget();
		}
		Super.PlayerTick(DeltaTime);
	}
}

/** sends the player to the correct state from dead */
function TransitionFromDeadState();

/** called to send PC to the respawning state, if the gametype allows it */
final function WaitForRespawn()
{
	if (IsDead() || IsSpectating())
	{
		if (PlayerReplicationInfo.Team != None &&
			GearGame(WorldInfo.Game).ShouldRespawnPC(PlayerReplicationInfo.Team.TeamIndex, self))
		{
			GearGame(WorldInfo.Game).StartRespawning(self);
			bWaitingToRespawn = true;
		}
		else
		{
			// ask the game again later
			SetTimer(1.0, false, nameof(WaitForRespawn));
		}
	}
}

function Restart(bool bVehicleTransition)
{
	if (bWaitingToRespawn)
	{
		bWaitingToRespawn = false;
		ClearTimer(nameof(WaitForRespawn));
	}
	Super.Restart(bVehicleTransition);

	if (MyGearPawn != None)
	{
		// Update the PRI's PawnClass
		if( !ClassIsChildOf(MyGearPawn.Class, class'GearPawnRidable_Base') )
		{
			GearPRI(PlayerReplicationInfo).SetPawnClass(MyGearPawn.class);
		}
	}
}

/** called to play an animation on leaders so it's more obvious who they are */
final function DoLeaderShout()
{
	// wait until weapon is equipped
	if ((AcknowledgedPawn == Pawn || IsLocalPlayerController()) && Pawn.Weapon!=none  && Pawn.Weapon.IsInState('Active') )
	{
		ServerDictateSpecialMove(SM_LeaderShout);
	}
	else
	{
		// we need to wait for the client to acknowledge possession of the Pawn to ensure replication works correctly
		SetTimer(0.1, false, nameof(DoLeaderShout));
	}
}

final function GearPRI GetViewTargetPRI()
{
	local Actor VT;

	VT = GetViewTarget();
	if ( Controller( VT ) != none )
	{
		return GearPRI(Controller( VT ).PlayerReplicationInfo);
	}
	else if ( Pawn( VT ) != none )
	{
		return GearPRI(Pawn(VT).PlayerReplicationInfo);
	}
	else
	{
		return none;
	}
}

/**
 * Returns whether or not the SpectateType passed in is valid for this PC
 *
 * @param SpectateType	Name of the spectating type to check
 *
 * @return	Whether or not SpectateType is valid
 */
function bool IsValidSpectatingType(Name SpectateType)
{
	return (SpectateType == 'Spectating' || SpectateType == 'PlayerSpectating');
}

/**
 * Should be to instigate a transition to spectating, automatically handles notifying server or notifying the owning client as necessary.
 */
exec function TransitionToSpectate(optional Name SpectateType)
{
	local GearGRI_MP GRIMP;

	GRIMP = GearGRI_MP(WorldInfo.GRI);
	if (bWaitingToRespawn &&
		GRIMP != None &&
		GRIMP.RespawnTime <= 1)
	{
		`log("delaying spectate change due to impending respawn");
		return;
	}
	// default to a valid spectating state
	if (!IsValidSpectatingType(SpectateType))
	{
		SpectateType = DefaultSpectateType;
	}
	if (GetStateName() != SpectateType)
	{
		if (IsLocalPlayerController())
		{
			if (Role != ROLE_Authority)
			{
				// notify the server
				ServerSpectate(SpectateType);
			}
			// simulate
			ClientTransitionToSpectate(SpectateType);
		}
		else
		{
			ServerSpectate(SpectateType);
			// tell the owning client to spectate as well
			ClientTransitionToSpectate(SpectateType);
		}
	}
}

/**
 * Called when the server instigates a transition to spectating (i.e. after death).  Call TransitionToSpectate() if instigating from a local client.
 */
reliable client function ClientTransitionToSpectate(Name SpectateType)
{
	if (GetStateName() != SpectateType)
	{
		// do a simple fade between transitions (if not already viewing a battle cam)
		if (MyGearHUD != None && GetStateName() != 'PlayerWaiting' && CameraActor(ViewTarget) == None)
		{
			MyGearHUD.SpectatorCameraFadeIn();
		}
		GotoState(SpectateType);
	}
}

/**
 * Called when a client instigates a transition to spectating via TransitionToSpectate().
 */
reliable server function ServerSpectate(Name SpectateType)
{
	if (IsDead() || IsSpectating())
	{
		GotoState(SpectateType);
	}
	else
	{
		`log(GetFuncName() @ Self @ `showvar(GetStateName()) @ `showvar(GetViewTarget()));
		// out of sync - remind the client which state is current
		ClientGotoState(GetStateName());
		ClientSetViewTarget(GetViewTarget());
	}
}

/** Stubs to be overridden by individual spectating states to handle viewtarget selection. */
function PickInitialViewTarget();
function PickNextViewTarget();
function PickPrevViewTarget();

/** spectates the player with the highest score that we are allowed to view */
unreliable server function ServerViewBestPlayer()
{
	local float BestScore;
	local GearPawn GP, BestGP;

	if (IsSpectating())
	{
		foreach WorldInfo.AllPawns(class'GearPawn',GP)
		{
			if ( GP != None && GP.PlayerReplicationInfo != None && GP.Health > 0 && GP.PlayerReplicationInfo != None &&
				GP.PlayerReplicationInfo.Score >= BestScore && WorldInfo.Game.CanSpectate(self, GP.PlayerReplicationInfo) )
			{
				BestScore = GP.PlayerReplicationInfo.Score;
				BestGP = GP;
			}
		}
		if (BestGP != None)
		{
			SetViewTarget(BestGP.PlayerReplicationInfo);
		}
		else
		{
			ServerViewNextPlayer();
		}
	}
}

/** Caches ref to the levels BattleCamPath */
function CacheBattleCamPath()
{
	local int PlayerIndex;
	local GearGRI_MP GRI;

	GRI = GearGRI_MP(WorldInfo.GRI);

	if (GRI != None)
	{
		if (IsSplitScreenPlayer(PlayerIndex) && PlayerIndex != 0)
		{
			BattleCamPath = GRI.GetBattleCamPath(PlayerIndex);
			if (Role < ROLE_Authority)
			{
				ServerSetBattleCamPath(PlayerIndex);
			}
		}
		else
		{
			BattleCamPath = GRI.GetBattleCamPath(0);
		}
	}
}

reliable server function ServerSetBattleCamPath(int Id)
{
	BattleCamPath = GearGRI_MP(WorldInfo.GRI).GetBattleCamPath(Id);
}

// spectating stubs for subclasses
simulated function ViewFirstSpectatorPoint();
unreliable server function ServerViewFirstSpectatorPoint();
simulated function ViewNextSpectatorPoint();
unreliable server function ServerViewNextSpectatorPoint();
simulated function ViewPrevSpectatorPoint();
unreliable server function ServerViewPrevSpectatorPoint();

/** @return whether we want the spectator UI scene to be displayed */
function bool WantsSpectatorUI()
{
	// yes if spectating, unless in screenshotmode
	// bunch of extra checks for SP to turn off when viewing cinematics, in splitscreen, or stuff hasn't had time to replicate
	return ( IsSpectating() && !bInMatinee && !bCinematicMode && WorldInfo.TimeSeconds - CreationTime > 1.0 &&
		(WorldInfo.GRI == None || WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.NetMode == NM_Client || GearGameSP_Arcade(WorldInfo.Game) != None) &&
		 !PlayerInput.IsA('GearPlayerInput_Screenshot') );
}

/**
 * Spectating
 * Extends base Spectating functionality to add automated testing hooks.
 * @todo:  move this to a specialized Spectating state for automated perf testing
 **/
state Spectating
{
	function BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);

		// Follow bots around after they are spawned if automated perf testing is enabled.
		if( GearGame(WorldInfo.Game)!=None && GearGame(WorldInfo.Game).IsAutomatedPerfTesting() )
		{
			SetTimer( 10.0f, FALSE, nameof(SetServerViewNextPlayer) ); // get the spectating going asap instead of waiting for 30secs.  need to wait some as the player will not be spawned yet
			SetTimer( 30.0f, TRUE, nameof(ServerViewNextPlayer) );
		}

		// Deactivate the active tutorial if there is one
		if (TutorialMgr != none)
		{
			TutorialMgr.RebootSystem();
		}
	}


	function SetServerViewNextPlayer()
	{
		ServerViewNextPlayer();
	}
}

/**
 * Returns the ControllerId of a given Controller.
 * This only works for localplayers in split screen.
 */
simulated function int GetControllerId()
{
	local LocalPlayer		LP;

	LP = LocalPlayer(Player);
	if( LP != None )
	{
		return LP.ControllerId;
	}

	return -1;
}

/** used when the client needs to tell the server about raw button presses */
reliable server function ServerHandleButtonPress(name ButtonName);
reliable server function ServerHandleJoystickInput(byte ActiveMask);
function TriggerEngageLoop();

state Engaging extends PlayerWalking
{
	function EndState( Name NextStateName )
	{
		if (!IsDoingSpecialMove(SM_Engage_ForceOff) &&
			!IsDoingSpecialMove(SM_Engage_End) &&
			!MyGearPawn.IsDBNO())
		{
			// release the engage actor
			if (LocalPlayer(Player) != None)// && Role == ROLE_Authority)
			{
 				DoSpecialMove(SM_Engage_End, IsDoingSpecialMove(SM_Engage_Idle));
			}
		}
	}

	reliable server function ServerHandleButtonPress(name ButtonName)
	{
		local Trigger_Engage Engage;

		Engage = MyGearPawn.EngageTrigger;
		Engage.HandleEngageButtonInput(self, ButtonName);
	}

	reliable server function ServerHandleJoystickInput(byte ActiveMask)
	{
		local Trigger_Engage Engage;

		Engage = MyGearPawn.EngageTrigger;
		Engage.HandleEngageJoystickInput(self, ActiveMask);
	}

	function TriggerEngageLoop()
	{
		ServerDictateSpecialMove(SM_Engage_Loop);
	}

	/** Override and ignore */
	function HandleButtonRelease(coerce Name ButtonName);
	function CheckForInteractionEvents();

	function PlayerMove(float DeltaTime)
	{
		if( Pawn == None )
		{
			GotoState('dead');
			return;
		}

		UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);
}

function PawnDied(Pawn inPawn)
{
	// Make sure the berserker blind effects are turned off
	ClientToggleBlindEffects(false);

	if (inPawn != Pawn)
	{
		return;
	}

	// unclaim the cover if necessary
	if (MyGearPawn != None &&
		MyGearPawn.CurrentLink != None)
	{
		MyGearPawn.CurrentLink.UnClaim(MyGearPawn,-1,TRUE);
	}
	MyGearPawn = None;
	Super.PawnDied(inPawn);
}

/**
 * list important GearPController variables on canvas. HUD will call DisplayDebug() on the current ViewTarget when
 * the ShowDebug exec is used
 *
 * @param	HUD		- HUD with canvas to draw on
 * @input	out_YL		- Height of the current font
 * @input	out_YPos	- Y position on Canvas. out_YPos += out_YL, gives position to draw text for next debug line.
 */
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	Canvas.SetPos(0,0);

	if ( Enemy != None )
		Canvas.DrawText("     STATE: "$GetStateName()$" Timer: "$GetTimerCount()$" Enemy "$Enemy.GetHumanReadableName(), false);
	else
		Canvas.DrawText("     STATE: "$GetStateName()$" Timer: "$GetTimerCount()$" NO Enemy ", false);
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	if( PlayerReplicationInfo == None )
		Canvas.DrawText("     NO PLAYERREPLICATIONINFO", false);
	else
		PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);

	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	if (HUD.ShouldDisplayDebug('camera'))
	{
		if( PlayerCamera != None )
		{
			PlayerCamera.DisplayDebug( HUD, out_YL, out_YPos );
		}
		else
		{
			Canvas.SetDrawColor(255,0,0);
			Canvas.DrawText("NO CAMERA");
			out_YPos += out_YL;
			Canvas.SetPos(4, out_YPos);
		}
	}
	if ( HUD.ShouldDisplayDebug('input') )
	{
		HUD.Canvas.SetDrawColor(255,0,0);
		HUD.Canvas.DrawText("Input ignoremove "$bIgnoreMoveInput$" ignore look "$bIgnoreLookInput);
		out_YPos += out_YL;
		HUD.Canvas.SetPos(4, out_YPos);
	}

	if( Pawn == None )
	{
		super.DisplayDebug(HUD, out_YL, out_YPos);
		return;
	}

	Canvas.SetDrawColor(255,255,255,255);
	Canvas.DrawText("CONTROLLER "$GetItemName(string(self))$" Pawn "$GetItemName(string(Pawn)));
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	Canvas.DrawText("Team Num:"@GetTeamNum()@"Pawn Team Num:"@Pawn.GetTeamNum());
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);

	if (MyGearPawn != None && MyGearPawn.IsDBNO())
	{
		out_YPos += out_YL;
		Canvas.DrawText("StartTimeOfDBNO:"@MyGearPawn.TimeOfDBNO);
		out_YPos += out_YL;
		Canvas.SetPos(4, out_YPos);
	}
}

exec function SetRadius(float newradius)
{
	Pawn.SetCollisionSize(NewRadius,Pawn.GetCollisionHeight());
}

reliable server function ServerGiveItem(string InvClassName)
{
 	local class<Inventory> IClass;
	local Inventory Item;

    if ( InStr(InvClassName,".") == -1 )
	{
    	InvClassName = "GearGame." $ InvClassName;
	}

    if (Pawn==None)
    {
    	`log("ServerGiveItem: Needs a pawn");
		return;
    }

   	IClass = class<Inventory>(DynamicLoadObject(InvClassName, class'class'));
	if (IClass != None)
	{
		Item = Spawn(IClass,,, Pawn.Location);
		if (Item!=None)
		{
			Item.GiveTo(Pawn);
		}
    	else
		{
			`log("ServerGiveItem: Could Not Spawn");
		}
    }
}

/**
 * Called by PlayerController and PlayerInput to set bIsWalking flag, affecting Pawn's velocity
 */
function HandleWalking()
{
	if (MyGearPawn != None)
	{
		// if currently forced (scripting), input, weapon + targeting
		if ((bRun == 0 && !MyGearPawn.bIsRoadieJogging) || (bIsTargeting && MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.bForceWalkWhenTargeting))
		{
			MyGearPawn.SetWalking(true);
		}
		else
		{
			MyGearPawn.SetWalking(false);
		}
	}
}


/************************************************************************************
 * Targeting Mode
 ***********************************************************************************/

// Update Targeting Mode state
simulated function UpdateTargetingStatus()
{
	local bool bNewIsTargeting;
	local bool bWantsToTarget;

	if (!IsLocalPlayerController())
	{
		return;
	}

	bWantsToTarget = WantsToTarget();
	bNewIsTargeting = bWantsToTarget && CanTarget();
	if (bIsTargeting != bNewIsTargeting)
	{
		SetTargetingMode(bNewIsTargeting);
	}

	if( bIsTargeting )
	{
		LastTargetingTime = WorldInfo.TimeSeconds;
	}

	// Make sure we are not zoomed when we shouldn't be
	if (MyGearPawn != None &&
		MyGearPawn.bIsZoomed &&
		!bIsTargeting &&
		MyGearPawn.MyGearWeapon != None)
	{
		// Don't fix the weapon if we are reloading because some weapons
		// want to continue zooming after a reload if the player is
		// holding down the targeting trigger.
		// There's also the case where targeting is blocked after reloading
		// in cover while animating back out to a lean cover action
		if (!MyGearPawn.MyGearWeapon.IsReloading() && (!MyGearPawn.IsInCover() || !bWantsToTarget))
		{
			MyGearPawn.MyGearWeapon.SetZoomed(false);
		}
	}

}

/** return TRUE if wants to Target */
final function bool WantsToTarget()
{
	if ( !IsButtonActive(GB_LeftTrigger) &&
		( (MyGearPawn == None) || !MyGearPawn.ShouldForceTargeting() ) )
	{
		return FALSE;
	}

	if (IsDead())
	{
		return FALSE;
	}

	if (MyGearPawn != None)
	{
		if ( MyGearPawn.ShouldPreventTargeting() )
		{
			return FALSE;
		}
	}

	return TRUE;
}


/**
 * Returns TRUE if player is able to target.
 */
final function bool CanTarget()
{
	local GearTurret			GT;
	local GearWeap_HeavyBase	MyHeavyWeapon;

	if( MyGearPawn == None )
	{
		// check if it's a turret
		GT = GearTurret(Pawn);
		return (GT != None) && GT.bAllowTargetingCamera;
	}
	else
	{
		// Need to be alive and have a weapon to target.
		if( IsDead() || MyGearPawn.MyGearWeapon == None )
		{
			return FALSE;
		}

		// Reloading weapon breaks targeting mode.
		if( MyGearPawn.MyGearWeapon.ShouldReloadingPreventTargeting() && MyGearPawn.IsReloadingWeapon() )
		{
			return FALSE;
		}

		// See if we can fire weapon. Special test for targeting, as some weapons shouldn't block targeting while reloading. (heavy/shield).
		if( !MyGearPawn.CanFireWeapon(TRUE) )
		{
			return FALSE;
		}

		// If in cover and CA_Default can't target unless in 360 aiming.
		// Outside of 360 aiming, an action is required (blind firing or leaning).
		if( MyGearPawn.CoverType != CT_None && MyGearPawn.CoverAction == CA_Default && !MyGearPawn.bDoing360Aiming && !MyGearPawn.IsDoingLeaningTo360Transition() )
		{
			return FALSE;
		}

		// cannot target while jumping around
		MyHeavyWeapon = GearWeap_HeavyBase(MyGearPawn.MyGearWeapon);
		if( MyHeavyWeapon != None && (MyGearPawn.SpecialMove == SM_CoverSlip || MyGearPawn.SpecialMove == SM_MidLvlJumpOver || MyGearPawn.IsEvading()) )
		{
			return FALSE;
		}

		if (MyGearPawn.bPreventTargetingDueToShieldDrop)
		{
			return FALSE;
		}
	}

	return TRUE;
}


/**
 * Changes the state of the targeting mode flag, and replicates it to the server.
 */
final function SetTargetingMode(bool bNewIsTargeting)
{
	local GearPawn GP;
	local float Aim, BestAim;
	local vector CameraLoc;
	local rotator CameraRot;

	// special aim assist while zooming in targeting mode when playing Campaign on Casual
	if ( bNewIsTargeting && !bIsTargeting && WorldInfo.GRI != None && !WorldInfo.GRI.IsMultiplayerGame() &&
		GearPRI(PlayerReplicationInfo) != None &&
		GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel == DL_Casual )
	{
		GetPlayerViewPoint(CameraLoc, CameraRot);
		BestAim = 0.990; // ~8 degrees
		foreach WorldInfo.AllPawns(class'GearPawn', GP)
		{
			if (GP != Pawn && !WorldInfo.GRI.OnSameTeam(GP, self))
			{
				Aim = Normal(GP.Location - CameraLoc) dot vector(CameraRot);
				if (Aim > BestAim && LineOfSightTo(GP))
				{
					ForcedAdhesionTarget = GP;
					BestAim = Aim;
				}
			}
		}
		SetTimer(0.2, false, nameof(StopForcedAdhesion));
	}

	bIsTargeting = bNewIsTargeting;
	TargetingModeChanged();
	// update the server if necessary
	if( Role < Role_Authority )
	{
		ServerSetTargetingMode(bNewIsTargeting);
	}
}

/**
 * Server update of the targeting mode flag.
 */
reliable server final function ServerSetTargetingMode(bool bNewIsTargeting)
{
	if( bIsTargeting != bNewIsTargeting )
	{
		SetTargetingMode(bNewIsTargeting);
	}
}

/**
 * Called when TargetingMode state changes from SetTargetinMode().
 */
final function TargetingModeChanged()
{
	// Update Pawn with new flag. Which will get replicated to remote clients,
	// and affect things such as animations and camera.
	if( MyGearPawn != None )
	{
		MyGearPawn.SetTargetingMode(bIsTargeting);
	}
}


/************************************************************************************
 * Cover
 ***********************************************************************************/

/** Special cover debug log formatting */
function CoverLog(string msg, coerce string function)
{
	`log( "[" $ WorldInfo.TimeSeconds $"]" @ "(" $ GetStateName() $ "::" $ function $ ")" @ msg, bDebugCover);
}

/*
 * Cover acquisition pitch:
 * Cover can only be acquired on a client or standalone game by calling AcquireCover()
 * Cover is replicated to the server through GearServerMove(), and confirmed from the server in GearClientAdjustPosition()
 */

/**
 * Tell Player to acquire given cover spot.
 * @param	CovInfo				Desired cover spot
 * @param	bNoCameraAutoAlign	TRUE to forcibly deny camera reorientation upon entering cover
 */
function AcquireCover(CovPosInfo CovInfo, optional bool bNoCameraAutoAlign)
{
	// should only call AcquireCover() if locally controlled!
	if ( !IsLocalPlayerController() )
	{
		`log(WorldInfo.TimeSeconds@GetFuncName() @ "has to be called from local player!");
		ScriptTrace();
		return;
	}

	if( MyGearPawn == None )
	{
		return;
	}

	CoverLog("", GetFuncName());

	// Acquire cover
	CoverAcquired(CovInfo, bNoCameraAutoAlign);
}

function DumpCoverInfo(CovPosInfo CovInfo)
{
	`log(" Link:" @ CovInfo.Link @ "Location:" @ CovInfo.Location @ "Normal:" @ CovInfo.Normal);
	`log(" LtSlotIdx:" @ CovInfo.LtSlotIdx @ "RtSlotIdx:" @ CovInfo.RtSlotIdx @ "LtToRtPct:" @ CovInfo.LtToRtPct);
}

/**
 * Event called when cover has been acquired.
 */
function CoverAcquired(CovPosInfo CovInfo, optional bool bNoCameraAutoAlign)
{
	local rotator TowardsCoverRot, CamRot;
	local float CamTurnDelta;
	local vector CamLoc;
	local ECoverDirection InitialCoverDirection;
	local SeqEvt_EnteredCover Evt;

	foreach EnteredCoverEvents(Evt)
	{
		Evt.CheckActivate(self,MyGearPawn,FALSE);
	}

	CoverLog("Link:"@CovInfo.Link@"Slot:"@CovInfo.LtSlotIdx$"/"$CovInfo.RtSlotIdx@"LtToRt:"@CovInfo.LtToRtPct, GetFuncName());
	//DumpCoverInfo(CovInfo);

	// figure out the initial cover direction
	//@NOTE - THIS HAS TO HAPPEN BEFORE CoverAcquired() otherwise server will not have the corrected ReplicatedCoverDirection
	InitialCoverDirection = MyGearPawn.FindBestCoverSideFor( CovInfo );
	//`log(WorldInfo.TimeSeconds@GetFuncName()@InitialCoverDirection);
	if( InitialCoverDirection != CD_Default )
	{
		MyGearPawn.SetMirroredSide( InitialCoverDirection == CD_Left );
	}

	// Tell Pawn that we've acquired cover
	MyGearPawn.CoverAcquired(CovInfo);

	// Should we notify that we've reached a slot?
	if( CovInfo.LtToRtPct == 0.f || CovInfo.LtToRtPct == 1.f )
	{
		NotifyReachedCoverSlot(MyGearPawn.CurrentSlotIdx, -1);
	}

	// disable roadie run timer, which would pull player back in cover.
	ClearTimer('TryToRoadieRun');

	// experimental
	// spin camera to face cover wall
	if (!bNoCameraAutoAlign && ShouldAutoAlignCameraWithCover())
	{
		// spin camera, experimental
		GetPlayerViewPoint(CamLoc, CamRot);
		TowardsCoverRot = rotator(-CovInfo.Normal);
		CamTurnDelta = NormalizeRotAxis(TowardsCoverRot.Yaw - CamRot.Yaw);
		GearPlayerCamera(PlayerCamera).GameplayCam.BeginTurn(0, CamTurnDelta, 0.5f, 0.f, TRUE);
	}

	// transition to the cover state
	GotoState('PlayerTakingCover');

	// Call the AcquiredCover delegates
	TriggerGearEventDelegates( eGED_CoverAcquired );
}


simulated function bool ShouldAutoAlignCameraWithCover()
{
	local GearPawn	TestPawn;
	local vector	CoverNormal, PawnFVec, PawnRVec, PawnUVec;
	local vector	CamLoc, CamDir, TestDir;
	local rotator	CamRot;
	local int SlotIdx;

	if ( !IsLocalPlayerController() )
		return false;

	if (MyGearPawn == None)
	{
		// bah
		return FALSE;
	}

	// if player is doing something with the stick, don't fight him
	if ( (PlayerInput.aTurn != 0) || (PlayerInput.aLookUp != 0) )
	{
		return FALSE;
	}

	CoverNormal = MyGearPawn.AcquiredCoverInfo.Normal;
	SlotIdx = MyGearPawn.GetSlotIdxByPct();

	if (MyGearPawn.CurrentLink.Slots[SlotIdx].bLeanLeft)
	{
		GetAxes(rotator(MyGearPawn.Velocity), PawnFVec, PawnRVec, PawnUVec);

		if ( ( (VSizeSq(MyGearPawn.Velocity) == 0.f) || ((PawnRVec dot CoverNormal) > 0.f) ) && (RemappedJoyUp != 0 || RemappedJoyRight != 0) )
		{
			return FALSE;
		}
	}
	else if (MyGearPawn.CurrentLink.Slots[SlotIdx].bLeanRight)
	{
		GetAxes(rotator(MyGearPawn.Velocity), PawnFVec, PawnRVec, PawnUVec);

		if ( ( (VSizeSq(MyGearPawn.Velocity) == 0.f) || ((PawnRVec dot CoverNormal) < 0.f) ) && (RemappedJoyUp != 0 || RemappedJoyRight != 0) )
		{
			return FALSE;
		}
	}
	else
	{
		// can't lean
		return FALSE;
	}

	// am I, roughly, aiming at an enemy?
	// this is the slower check, do it last

	GetPlayerViewPoint(CamLoc, CamRot);
	CamDir = vector(CamRot);
	foreach WorldInfo.AllPawns(class'GearPawn', TestPawn)
	{
		// 0.9238f is cos(22.5 deg), making a detection fov of 45deg
		TestDir = TestPawn.Location - CamLoc;
		if ( VSize(TestDir) <= 8192.f && (CamDir dot TestDir) > 0.9238f &&
			LineOfSightTo(TestPawn) )
		{
			return false;
		}
	}

	// survived the gauntlet, return true!
	return TRUE;
}

/**
 * Clears the cover claim and resets the state.
 *
 * NET: Server/Client
 */
simulated function LeaveCover(optional bool bPushOut)
{
	local SeqEvt_LeftCover Evt;
	if( MyGearPawn != None )
	{
		CoverLog("Leaving cover"@MyGearPawn.CurrentLink, GetFuncName());

		// Call the LeaveCover delegates
		TriggerGearEventDelegates( eGED_CoverLeave );

		// revoke our claim on the cover
		if (MyGearPawn.CurrentLink != None)
		{
			MyGearPawn.CurrentLink.UnClaim( MyGearPawn, MyGearPawn.CurrentSlotIdx, TRUE );
		}

		foreach LeftCoverEvents(Evt)
		{
			Evt.CheckActivate(self,MyGearPawn,FALSE);
		}

		MyGearPawn.LeaveCover();
		MyGearPawn.SetAnchor(None);

		if (MyGearHud != None)
		{
			MyGearHud.ClearActionInfoByType(AT_SpecialMove);
		}

		// transition to proper state
		GotoState('PlayerWalking');
	}
}

/**
 * Called when we've reached a slot, checks for stationary slots.
 */
function NotifyReachedCoverSlot(int SlotIdx, int OldSlotIdx)
{
	local CoverLink Link;
	Link = MyGearPawn.CurrentLink;
	// Handle stationary slots
	if( Link != None )
	{
		CoverLog("Slot:"@SlotIdx,GetFuncName()@"Cur"@MyGearPawn.CurrentSlotIdx@"L"@MyGearPawn.LeftSlotIdx@"R"@MyGearPawn.RightSlotIdx@Link.IsStationarySlot(SlotIdx));

		// Unclaim old slot
		if( OldSlotIdx >= 0 )
		{
			Link.UnClaim( MyGearPawn, OldSlotIdx, FALSE );
		}

		// Claim slot
		Link.Claim( MyGearPawn, SlotIdx );

		// if doing an auto-coverrun
		if (IsLocalPlayerController() && IsDoingSpecialMove(SM_CoverRun) && !IsHoldingRoadieRunButton() && !bForcedRoadieRun)
		{
			// and no longer targeting, or hit a cover that we can pop up/out of
			if (!WantsToTarget() || Link.IsStationarySlot(SlotIdx) || Link.Slots[SlotIdx].bCanPopUp)
			{
				// stop the auto run
				EndSpecialMove();
			}
		}

		if( Link.IsStationarySlot(SlotIdx) )
		{
			// prevent movement to handle cover slot stickiness, but only where we have a transition (ie not on edges)
			if( !Link.IsEdgeSlot(SlotIdx) )
			{
				CoverTransitionCountHold = 0.f;
			}

			// this allows us to lean out when you have standing and then midlevel cover attached
			if( !IsDoingSpecialMove(SM_CoverRun) && !MyGearPawn.bDoing360Aiming )
			{
				SetIsInStationaryCover(TRUE);
			}
		}

		// stop evade move
		if( MyGearPawn.IsEvading() )
		{
			StopEvade();
		}
	}
}

function ClientUpdatePosition()
{
	local name CurrentStateName;

	CurrentStateName = GetStateName();
	Super.ClientUpdatePosition();
	if ( CurrentStateName != GetStateName() )
	{
		`log("switching back from "$GetStateName()$" to "$CurrentStateName);
		GotoState(CurrentStateName);
	}
}

/** notification that the server has rejected the cover transition supplied with the ServerMove() at the specified TimeStamp
 * clear the cover out of any previous moves and if we are still in that cover, leave it
 */
unreliable client function ClientInvalidCoverClaim(float TimeStamp)
{
	local bool bNeedToLeaveCover;
	local GearSavedMove CurrentMove;

	// if something goes wrong (don't find the SavedMove or whatever), assume we need to leave cover
	bNeedToLeaveCover = true;

	for (CurrentMove = GearSavedMove(SavedMoves); CurrentMove != None; CurrentMove = GearSavedMove(CurrentMove.NextMove))
	{
		if (CurrentMove.TimeStamp == TimeStamp)
		{
			CurrentMove.ClearCover();
		}
		else if (CurrentMove.TimeStamp > TimeStamp)
		{
			if (CurrentMove.Link == None || CurrentMove.bCoverTransition)
			{
				// this move left the original cover or transitioned to new cover
				bNeedToLeaveCover = false;
				break;
			}
			else
		{
				CurrentMove.ClearCover();
		}
	}
}

	if (bNeedToLeaveCover)
{
	LeaveCover();
	// turn off SM_Run2Cover if it's active
	if (MyGearPawn != None && (MyGearPawn.IsDoingSpecialMove(SM_Run2MidCov) || MyGearPawn.IsDoingSpecialMove(SM_Run2StdCov)))
	{
		EndSpecialMove();
	}
}
}

unreliable client function ClientRequestCoverTransition()
{
	if (MyGearPawn != None && MyGearPawn.CoverType != CT_None && MyGearPawn.CurrentLink != None)
	{
		// set the flag so it will be sent with the next ServerMove()
		bSendCoverTransition = true;
	}
}

function CallServerMove
(
 SavedMove NewMove,
 vector ClientLoc,
 byte ClientRoll,
 int View,
 SavedMove OldMove
 )
{
	local GearSavedMove PendingGearMove;

	// @TODO compress old move if it exists
	if ( OldMove != None )
	{
		PendingGearMove = GearSavedMove(OldMove);
		OldMove = None;
		SendServerMove(PendingGearMove, vect(1,2,3), ClientRoll, View, None);
	}

	// @TODO - combine pending move?
	// @TODO - compress cover info in CoverServerMove?
	if ( PendingMove != None )
	{
		PendingGearMove = GearSavedMove(PendingMove);
		PendingMove = None;
		SendServerMove(PendingGearMove, vect(1,2,3), ClientRoll, View, None);
	}
	SendServerMove(NewMove, ClientLoc, ClientRoll, View, OldMove);
}

final function SendServerMove
(
 SavedMove NewMove,
 vector ClientLoc,
 byte ClientRoll,
 int View,
 SavedMove OldMove
 )
{
	local GearSavedMove NewGearMove;

	NewGearMove = GearSavedMove(NewMove);
	if ( MyGearPawn != None )
	{
		// if we were performing an unsynchronized move at the START of this frame's movement, send only the view information
		// as this movement is automatic and will be corrected if necessary after both sides have completed the move
		// this is particularly important when chaining special moves, as the movement info prior to the current move starting may
		// modify the timing of the transition between moves
		if (MyGearPawn.PreviousSpecialMoveTime < NewMove.TimeStamp && MyGearPawn.IsDoingASpecialMove() && MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bUseUnsynchedServerMove)
		{
			UnsynchedServerMove(NewMove.TimeStamp, View);
		}
		// Make sure he is in cover state before servermove
		else if (NewGearMove.CoverType != CT_None && IsInCoverState() && (!NewMove.bForceRMVelocity || MyGearPawn.SpecialMove == SM_None))
		{
			//`log("CoverServerMove in state "$GetStateName());
			if (NewGearMove.bCoverTransition)
			{
				CoverServerMove
				(
				NewMove.TimeStamp,
				NewMove.bForceRMVelocity ? (NewMove.RMVelocity * 10) : (NewMove.Acceleration * 10),
				ClientLoc,
				NewMove.CompressedFlags(),
				ClientRoll,
				View,
				NewGearMove.CoverType,
				NewGearMove.CoverAction,
				NewGearMove.CoverDirection,
				NewGearMove.bWantsToBeMirrored,
				NewGearMove.CurrentSlotDirection,
				NewGearMove.bIsInStationaryCover,
				NewMove.bForceRMVelocity,
				true,
				NewGearMove.Link,
				NewGearMove.SlotIdx,
				NewGearMove.LeftIdx,
				NewGearMove.RightIdx,
				NewGearMove.SlotPct
				);
			}
			else
			{
				CoverServerMove
				(
				NewMove.TimeStamp,
				NewMove.bForceRMVelocity ? (NewMove.RMVelocity * 10) : (NewMove.Acceleration * 10),
				ClientLoc,
				NewMove.CompressedFlags(),
				ClientRoll,
				View,
				NewGearMove.CoverType,
				NewGearMove.CoverAction,
				NewGearMove.CoverDirection,
				NewGearMove.bWantsToBeMirrored,
				NewGearMove.CurrentSlotDirection,
				NewGearMove.bIsInStationaryCover,
				NewMove.bForceRMVelocity,
				false
				);
			}
		}
		else if (NewMove.bForceRMVelocity)
		{
			RMServerMove
			(
			NewMove.TimeStamp,
			NewMove.RMVelocity * 10,
			ClientLoc,
			NewMove.CompressedFlags(),
			ClientRoll,
			View,
			(NewGearMove.CoverType != CT_None)
			);
		}
		else if (MyGearPawn.SpecialMove != SM_None && GSM_RoadieRun(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]) != None)
		{
			RoadieServerMove
			(
			NewMove.TimeStamp,
			NewMove.Acceleration * 10,
			ClientLoc,
			NewMove.CompressedFlags(),
			ClientRoll,
			View,
			MyGearPawn.SpecialMove
			);
		}
		else
		{
			ServerMove
			(
			NewMove.TimeStamp,
			NewMove.Acceleration * 10,
			ClientLoc,
			NewMove.CompressedFlags(),
			ClientRoll,
			View
			);
		}
	}
	else
	{
		ServerMove
		(
		NewMove.TimeStamp,
		NewMove.Acceleration * 10,
		ClientLoc,
		NewMove.CompressedFlags(),
		ClientRoll,
		View
		);
	}
}

/**
 * Make sure server and client get synchronized properly in and out of reviving
 */
unreliable server event ServerVerifyState(name ClientState)
{
	if ( ClientState != GetStateName() )
	{
		bRequestClientVerifyState = TRUE;
	}
}


unreliable client event ClientVerifyState(name ServerState)
{
	UpdateStateFromAdjustment(ServerState);
}

/**
Called by LongClientAdjustPosition()
@param NewState is the state recommended by the server
*/
function UpdateStateFromAdjustment(name NewState)
{
	// don't change states between cover and playerwalking
	if( GetStateName() != NewState )
	{
		if ( MyGearPawn != None )
		{
			if ( MyGearPawn.IsDBNO() )
			{
				if ( NewState != 'Reviving' )
				{
					bRequestServerVerifyState = true;
					return;
				}
			}
			else if ( NewState == 'Reviving' )
			{
				bRequestServerVerifyState = true;
				return;
			}
		}
		if ( IsInCoverState() )
		{
			if ( NewState == 'PlayerWalking' )
			{
				return;
			}
		}
		else if ( GetStateName() == 'PlayerWalking' )
		{
			if (NewState == 'PlayerTakingCover')
				return;
		}
		GotoState(newstate);
	}
}

unreliable server function CoverServerMove
(
 float	TimeStamp,
 vector	InAccel,
 vector	ClientLoc,
 byte	MoveFlags,
 byte	ClientRoll,
 int		View,
 ECoverType InCoverType,
 ECoverAction InCoverAction,
 ECoverDirection InCoverDirection,
 bool InbWantsToBeMirrored,
 ECoverDirection InCurrentSlotDirection,
 bool InbIsInStationaryCover,
 bool bUsingRootMotion,
 bool bCoverTransition,
 // the following only replicated when bCoverTransition is true
 optional CoverLink NewLink,
 optional byte NewSlotIdx,
 optional byte NewLeftIdx,
 optional byte NewRightIdx,
 optional float SlotPct
 )
{
	local CovPosInfo CovInfo;

	// If this move is outdated, discard it.
	if( CurrentTimeStamp >= TimeStamp )
	{
		return;
	}

	if (MyGearPawn != None)
	{
		if (bCoverTransition)
		{
			if (NewLink == None)
			{
				// reference to object failed for some reason
				ClientRequestCoverTransition();
			}
			else
			{
				// if the Pawn can't be in this cover, tell the client to get out of it
				if ( MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield() || !NewLink.IsValidClaim(MyGearPawn, NewSlotIdx, true, true) ||
					VSize(MyGearPawn.Location - NewLink.GetSlotLocation(NewSlotIdx)) > MyGearPawn.Run2CoverMaxDist * 1.5 )
				{
					//`log("ClientInvalidCoverClaim because not valid claim");
					ClientInvalidCoverClaim(TimeStamp);
				}
				else
				{
					MyGearPawn.ReplicatedCoverDirection = InCoverDirection;
					MyGearPawn.FreshCoverDirectionTime = WorldInfo.TimeSeconds;

					// Acquire cover
					CovInfo.Link = NewLink;
					CovInfo.LtSlotIdx = NewLeftIdx;
					CovInfo.RtSlotIdx = NewRightIdx;
					CovInfo.LtToRtPct = SlotPct;
					MyGearPawn.SetCoverPosVectors(CovInfo);

					CoverAcquired(CovInfo, false);
				}
			}
		}

		if (MyGearPawn.CoverType == CT_None || !IsInCoverState())
		{
			// generally this means the CoverServerMove() that contained the transition was lost or delayed
			// ask the client to resend it
			// if bCoverTransition is true and we get here, that means the cover the client gave us is invalid
			// in that case we have already told the client to leave that cover, so do nothing here
			if (!bCoverTransition)
			{
				ClientRequestCoverTransition();
			}
		}
		else
		{
			//if ( InCoverType != MyGearPawn.CoverType )`log("set covertype "$Incovertype@timestamp);
			SetPawnCoverType( InCoverType );
			SetPawnCoverAction( InCoverAction );
			SetCoverDirection( InCoverDirection );
			// ignore the client's view of mirroring while performing a special move as we don't synchronize special moves
			// and their animations so the timing may be off, which would break the animation on the server
			if (!MyGearPawn.IsDoingASpecialMove())
			{
				MyGearPawn.SetMirroredSide(InbWantsToBeMirrored);
			}
			// checks here are to avoid setting bNetDirty to true unnecessarily
			if (MyGearPawn.CurrentSlotDirection != InCurrentSlotDirection)
			{
				MyGearPawn.CurrentSlotDirection = InCurrentSlotDirection;
			}
			if (MyGearPawn.bIsInStationaryCover != InbIsInStationaryCover)
			{
				MyGearPawn.bIsInStationaryCover = InbIsInStationaryCover;
			}
		}
	}
	bServerMoveCoverActive = true;
	if (bUsingRootMotion)
	{
		RMServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, true);
	}
	else
	{
		ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
	}
	bServerMoveCoverActive = false;
}

/* RMServerMove()
- replicated function sent by client to server - contains client movement and firing info.
 * This version sent when client has bForceRMVelocity
*/
unreliable server function RMServerMove
(
	float	TimeStamp,
	vector	InAccel,
	vector	ClientLoc,
	byte	MoveFlags,
	byte	ClientRoll,
	int		View,
	bool	bIsInCover
)
{
	// If this move is outdated, discard it.
	if( CurrentTimeStamp >= TimeStamp )
	{
		return;
	}

	if (MyGearPawn == None)
	{
		MyGearPawn = GearPawn(Pawn);
	}

	if (MyGearPawn != None)
	{
		//`log(TimeStamp@self$" RMservermove in state "$GetStateName());

		MyGearPawn.bForceRMVelocity = true;
		// force the root motion's direction to the server's view if we're in a special move that disables movement
		// (can't use server's magnitude because animation and special moves aren't synchronized,
		// meaning that some amount of the movement would get cut off if the server finishes first)
		if ( MyGearPawn.IsDoingASpecialMove() && MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].IsMovementDisabled() &&
			!IsZero(MyGearPawn.Mesh.RootMotionDelta.Translation) &&
			// hackish, but characters that are always in root motion have so many cheat opportunities already
			// it's not worth the sync errors to try to cheat protect them here
			MyGearPawn.default.Mesh.RootMotionMode == RMM_Ignore )
		{
			if (Pawn.Physics != PHYS_Falling || (MyGearPawn.Velocity.Z >= 0.0 && InAccel.Z >= 0.0))
			{
				MyGearPawn.RMVelocity = Normal(MyGearPawn.Mesh.RootMotionDelta.Translation) * (VSize(InAccel) * 0.1);
			}
			else
			{
				// if we are falling we need to account for gravity since it isn't a part of the animation
				MyGearPawn.RMVelocity = MyGearPawn.Mesh.RootMotionDelta.Translation;
				MyGearPawn.RMVelocity.Z = 0.0;
				MyGearPawn.RMVelocity = Normal(MyGearPawn.RMVelocity) * (VSize2D(InAccel) * 0.1);
				MyGearPawn.RMVelocity.Z = FMin(MyGearPawn.Velocity.Z, InAccel.Z * 0.1);
			}
			//@todo: bound to reasonable maximum speed?
		}
		else
		{
			MyGearPawn.RMVelocity = InAccel * 0.1;
		}

		if (bIsInCover && MyGearPawn.CoverType == CT_None)
		{
			ClientRequestCoverTransition();
		}
	}
	else
	{
		if ( bIsInCover && !IsInCoverState() )
		{
			ClientRequestCoverTransition();
		}
	}
	bServerMoveCoverActive = bIsInCover;
	ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
	bServerMoveCoverActive = false;

	if (MyGearPawn != None)
	{
		MyGearPawn.bForceRMVelocity = false;
	}
}
/* MantleServerMove()
 * - replicated function sent by client to server - contains client movement and firing info.
 * This version sent when client is doing a special move with bUseUnsynchedServerMove set
 * when this is the case, we update the special move independantly of the client and don't synchronize position until after
 * the special move is complete
 */
unreliable server function UnsynchedServerMove(float TimeStamp, int View)
{
	local rotator ViewRot;

	// If this move is outdated, discard it.
	if (CurrentTimeStamp >= TimeStamp)
	{
		return;
	}
	// make sure we're in the right state
	else if (!IsInState('PlayerWalking') && !IsInState('PlayerTakingCover'))
	{
		//`log(GetFuncName() @ "in state "$GetStateName());
		return;
	}
	// make sure we have a GearPawn
	else if ( MyGearPawn == None )
	{
		// client has incorrect Pawn
		if (Pawn != None)
		{
			GivePawn(Pawn);
		}
		return;
	}
	// make sure we're actually doing a mantle
	else if (!MyGearPawn.IsDoingASpecialMove() || !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bUseUnsynchedServerMove)
	{
		//`log(GetFuncName() @ "move with invalid special move "@MyGearPawn.SpecialMove);
		return;
	}


	// client and server update this move in parallel, only replicating Rotation updates,
	// then resyncronize position after the move is complete

	// just update timestamps and rotation
	CurrentTimeStamp = TimeStamp;
	LastActiveTime = WorldInfo.TimeSeconds;
	// ServerTimeStamp forced to current time during update in AGearPC::Tick() so no extra physics updates occur
	ViewRot.Pitch = (View & 65535);
	ViewRot.Yaw = (View >> 16);
	ViewRot.Roll = 0;
	SetRotation(ViewRot);

	// acknowledge receipt of this successful servermove()
	PendingAdjustment.TimeStamp = TimeStamp;
	PendingAdjustment.bAckGoodMove = 1;
}

/* RoadieServerMove()
- replicated function sent by client to server - contains client movement and firing info.
 * This version sent when client has RoadieRun active
*/
unreliable server function RoadieServerMove
(
	float	TimeStamp,
	vector	InAccel,
	vector	ClientLoc,
	byte	MoveFlags,
	byte	ClientRoll,
	int		View,
	ESpecialMove RRMove
)
{
	local vector X,Y,Z;
	local SMStruct	NewMoveStruct;

	// If this move is outdated, discard it.
	if( CurrentTimeStamp >= TimeStamp )
	{
		return;
	}

	// if we're not doing the roadie run move, start it now
	if ( MyGearPawn != None && ClassIsChildOf(MyGearPawn.SpecialMoveClasses[RRMove], class'GSM_RoadieRun') &&
		MyGearPawn.SpecialMove != RRMove && MyGearPawn.PendingSpecialMoveStruct.SpecialMove != RRMove )
	{
		GetAxes(Rotation, X, Y, Z);
		RemappedJoyUp = InAccel dot X;
		RemappedJoyRight = InAccel dot Y;

		NewMoveStruct = MyGearPawn.FillSMStructFromParams(RRMove);
		ClientToServerDoSpecialMove(NewMoveStruct, false, RemappedJoyUp, RemappedJoyRight, MyGearPawn.Rotation.Yaw, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
	}
	bServerMoveRoadieRunActive = true;
	ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
	bServerMoveRoadieRunActive = false;
}

/* ServerMove()
- replicated function sent by client to server - contains client movement and firing info.
*/
unreliable server function ServerMove(float TimeStamp, vector InAccel, vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
{
	local GearPawn_SilverbackArmedBase ArmedSilverback;

	// If this move is outdated, discard it.
	if( CurrentTimeStamp >= TimeStamp )
	{
		return;
	}

	ArmedSilverback = GearPawn_SilverbackArmedBase(MyGearPawn);
	if( ArmedSilverback != None && ArmedSilverback.bAnimIsDeployed )
	{
		// No movement allowed when deployed.
		// Even though the special move has IsMovementDisabled(), the client can move between get in and deployed states.
		InAccel = vect(0,0,0);
	}

	// if this ServerMove() didn't come from RoadieServerMove() and we are still in a roadie run, mirror the fact
	// that the client ended that move
	if ( !bServerMoveRoadieRunActive && MyGearPawn != None && MyGearPawn.SpecialMove != SM_None &&
		GSM_RoadieRun(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]) != None && MyGearPawn.QueuedRoadieRunMoveTimeStamp < TimeStamp )
	{
		MyGearPawn.EndSpecialMove();
	}

	// if we're still doing an unsychronized special move, continue to ignore position/acceleration updates
	// the client will be corrected once the move is complete on the server
	if (MyGearPawn != None && MyGearPawn.IsDoingASpecialMove() && MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bUseUnsynchedServerMove)
	{
		UnsynchedServerMove(TimeStamp, View);
		return;
	}

	// force the acceleration to be rejected if performing a special move that prevents controlled movement
	// (so the client can't lie to us)
	if (MyGearPawn != None && MyGearPawn.IsDoingASpecialMove() && MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].IsMovementDisabled())
	{
		InAccel = Pawn.Acceleration * 10.0; // Super expects real accel * 10
	}
	if (Pawn != None && !Pawn.bForceRMVelocity)
	{
		if ( (Pawn.Mesh != None) && ((Pawn.Mesh.RootMotionMode == RMM_Accel) || (Pawn.Mesh.RootMotionMode == RMM_Velocity)) )
		{
			//`log(TimeStamp@self$" Force regular velocity with specialmove "$Gearpawn(Pawn).SpecialMove@vsize(pawn.velocity)@vsize(0.1*inaccel)@Pawn.Physics);
			Pawn.bForceRegularVelocity = true;
		}

		bPreciseDestination = false;
	}
	Super.ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
	if ( Pawn != None )
	{
		Pawn.bForceRegularVelocity = false;
	}
}

unreliable client function LongClientAdjustPosition
(
	float TimeStamp,
	name newState,
	EPhysics newPhysics,
	float NewLocX,
	float NewLocY,
	float NewLocZ,
	float NewVelX,
	float NewVelY,
	float NewVelZ,
	Actor NewBase,
	float NewFloorX,
	float NewFloorY,
	float NewFloorZ
)
{
	local InterpActor_GearBasePlatform Platform;
	local vector NewLoc;

	// ignore if we are in an unsynched move... wait for a new update post-move
	if (MyGearPawn == None || MyGearPawn.SpecialMove == SM_None || !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bUseUnsynchedServerMove)
	{
		//@hack: ignore the call if we're already clamped to the correct base
		if (Pawn != None && Pawn.Physics == PHYS_None && Pawn.Base == NewBase)
		{
			Platform = InterpActor_GearBasePlatform(Pawn.Base);
			if (Platform != None && Platform.bDisallowPawnMovement)
			{
				NewLoc.X = NewLocX;
				NewLoc.Y = NewLocY;
				NewLoc.Z = NewLocZ;
				NewLoc += Platform.Location;
				if (VSize(NewLoc - Pawn.Location) < 50.0)
				{
					return;
				}
			}
		}

		Super.LongClientAdjustPosition(TimeStamp, NewState, NewPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, NewFloorX, NewFloorY, NewFloorZ);
	}
}

function UpdateRotation( float DeltaTime )
{
	local Rotator	DeltaRot, NewRotation, ViewRotation;

	ViewRotation	= Rotation;

	if (bLookingAtPointOfInterest && IsHoldingPOIButton(TRUE))
	{
		if ((PlayerInput.aForward != 0.f || PlayerInput.aStrafe != 0.f ) && !IsInState('PlayerTurreting'))
		{
			DeltaRot.Yaw = GearPlayerCamera(PlayerCamera).GameplayCam.LastYawAdjustment;
			DeltaRot.Pitch = GearPlayerCamera(PlayerCamera).GameplayCam.LastPitchAdjustment;
		}
	}
	else
	{
		// Calculate Delta to be applied on ViewRotation
		DeltaRot.Yaw	 = PlayerInput.aTurn;
		DeltaRot.Pitch	 = PlayerInput.aLookUp;
		if( WorldInfo.TimeDilation < 1.f )
		{
			DeltaRot *= WorldInfo.TimeDilation;
		}

		DeltaRot += ExtraRot;
		ExtraRot = rot(0,0,0);

		// Check that Adhesion target is still valid
		VerifyAdhesionTargets();

		// Apply adhesion
		ApplyAdhesion(DeltaTime, DeltaRot.Yaw, DeltaRot.Pitch);
	}

	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
	GearPlayerCamera(PlayerCamera).GameplayCam.AdjustFocusPointInterpolation(DeltaRot);			// adjust for focus points

	SetRotation( ViewRotation );

	ViewShake( DeltaTime );

	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;

	if( Pawn != None )
	{
		Pawn.FaceRotation(NewRotation, DeltaTime);
	}
}

final function ApplyAdhesion(float DeltaTime, out int out_YawRot, out int out_PitchRot)
{
	local rotator NewRotation, DeltaRot, CameraRot;
	local vector TargetCenter, CameraLoc;
	local float TargetWidth, TargetHeight;
	local GameThirdPersonCamera Cam3p;
	local GamePlayerCamera Cam;

	if ( (GearAimAssistActor(LastFrictionTarget) != None) && LastFrictionTarget.bCanBeAdheredTo )
	{
		GearPlayerInput(PlayerInput).ViewAdhesion(DeltaTime, GearWeapon(Pawn.Weapon), out_YawRot, out_PitchRot);
	}

	if ( ForcedAdhesionTarget != None && !ForcedAdhesionTarget.bDeleteMe )
	{
		// we've got "forced adhesion" going, do that
		ForcedAdhesionTarget.GetAimFrictionExtent(TargetWidth, TargetHeight, TargetCenter);

		Cam = GamePlayerCamera(PlayerCamera);
		Cam3p = (Cam != None) ? GameThirdPersonCamera(Cam.CurrentCamera) : None;
		if (Cam3p != None)
		{
			// for normal 3rd person cam, use pre-modifier loc/rot, as this is the "base"
			// location we want to perform adhesion from.  modifiers can introduce strange
			// effects (e.g. spinning)
			CameraLoc = Cam3p.LastPreModifierCameraLoc;
			CameraRot = Cam3p.LastPreModifierCameraRot;
		}
		else
		{
			GetPlayerViewPoint(CameraLoc, CameraRot);
		}

		NewRotation = rotator(TargetCenter - CameraLoc);
		// note this is more aggressive than for melee
		NewRotation = RInterpTo(Normalize(Rotation), Normalize(NewRotation), DeltaTime, 12.f);

		DeltaRot = NewRotation - Rotation;

		// hard override
		out_YawRot = DeltaRot.Yaw;
	}
	else if ( MyGearPawn != None && MeleeAdhesionTarget != None && !MeleeAdhesionTarget.bDeleteMe )
	{
		// do melee adhesion, which is distinct from "forced" adhesion in that it works
		// from the Pawn's loc

		MeleeAdhesionTarget.GetAimFrictionExtent(TargetWidth, TargetHeight, TargetCenter);

		NewRotation = rotator(TargetCenter - MyGearPawn.Location);
		NewRotation = RInterpTo(Normalize(Rotation), Normalize(NewRotation), DeltaTime, 8.f);

		DeltaRot = NewRotation - Rotation;

		// hard override
		out_YawRot = DeltaRot.Yaw;
	}
}

final simulated function bool WeaponHasAnyAmmo()
{
	return (MyGearPawn != None && MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.HasAnyAmmo());
}

reliable client function ClientBreakFromCover();

simulated function TransitionFromSwatToRoadieRun()
{
	// if still holding a and swat turning then interrupt the swat turn
	if (IsHoldingRoadieRunButton() && IsDoingSpecialMove(SM_StdLvlSwatTurn))
	{
		// if not too close to the destination
		if (VSize(GetDestinationPosition() - Pawn.Location) > Pawn.GetCollisionRadius() * 2.f)
		{
			// break from cover
			LeaveCover();
			// and transition directly into roadie run
			DoSpecialMove(SM_RoadieRun,TRUE);
		}
		// otherwise try to chain a slip/mantle
		else if (CanDoSpecialMove(SM_CoverSlip))
		{
			DoSpecialMove(SM_CoverSlip);
		}
		// check if we can do a mantle kick
		else if (CanDoSpecialMove(SM_MantleKick))
		{
			MyGearPawn.VerifySMHasBeenInstanced(SM_MantleKick);
			DoSpecialMove(SM_MantleKick, FALSE, None, GSM_MantleKick(MyGearPawn.SpecialMoves[SM_MantleKick]).PackSpecialMoveFlags());
		}
		else if (CanDoSpecialMove(SM_MidLvlJumpOver))
		{
			MyGearPawn.VerifySMHasBeenInstanced(SM_MidLvlJumpOver);
			DoSpecialMove(SM_MidLvlJumpOver, FALSE, None, GSM_MidLvlJumpOver(MyGearPawn.SpecialMoves[SM_MidLvlJumpOver]).PackSpecialMoveFlags());
		}
		// and if all else fails do nothing
	}
}

/**
 * Determines if there are enough human controlled squad members for a particular action
 * @param RequiredMembers - number of squad members needed
 * @return - true if there are enough human controlled squad members
 */
function bool HasRequiredHumanControlledPlayers(int NumRequired)
{
	local int PlayerCount;
	local GearPC PC;

	if (Squad != None)
	{
		// Count how many human players are in our squad
		foreach WorldInfo.AllControllers(class'GearPC', PC)
		{
			// Make sure they are in our squad
			if (PC != None &&
				PC.Squad != None &&
				PC.Squad.SquadName == Squad.SquadName)
			{
				PlayerCount++;
			}
		}
	}
	return (PlayerCount >= NumRequired);
}

/** Returns the closest AI squadmate */
function GearAI GetClosestAISquadmate()
{
	local GearAI CurrentAI;
	local GearAI ClosestAI;
	local float ClosestSqDist;
	local float CurrentSqDist;

	if (Squad != None)
	{
		// Find the closest AI in our squad
		CurrentSqDist = -1.0f;
		ClosestSqDist = -1.0f;
		foreach WorldInfo.AllControllers(class'GearAI', CurrentAI)
		{
			// Make sure they are in our squad
			if (CurrentAI != None &&
				CurrentAI.Squad != None &&
				CurrentAI.Squad.SquadName == Squad.SquadName)
			{
				// Do the distance check
				CurrentSqDist = VSizeSq(CurrentAI.MyGearPawn.Location - MyGearPawn.Location);
				if (ClosestSqDist < 0.0f || CurrentSqDist < ClosestSqDist)
				{
					ClosestSqDist = CurrentSqDist;
					ClosestAI = CurrentAI;
				}
			}
		}
	}
	return ClosestAI;
}

/** Returns the AI squadmate in our coverlink, if there is one */
function GearAI GetAISquadmateInMyCoverLink()
{
	local GearAI AIBuddy;
	local int SlotIdx;
	local CoverSlot CurrSlot;

	// Make sure we have a valid coverlink and that we're in a squad
	if (MyGearPawn != None && MyGearPawn.CurrentLink != None && Squad != None)
	{
		// Loop through the coverslots in our coverlink
		for (SlotIdx = 0; SlotIdx < MyGearPawn.CurrentLink.Slots.Length; SlotIdx++)
		{
			// Make sure there is a valid pawn in the slot
			CurrSlot = MyGearPawn.CurrentLink.Slots[SlotIdx];
			if (CurrSlot.SlotOwner != None)
			{
				// See if that pawn is controlled by AI and if it's in our squad
				AIBuddy = GearAI(CurrSlot.SlotOwner.Controller);
				if (AIBuddy != None &&
					AIBuddy.Squad != None &&
					AIBuddy.Squad.SquadName == Squad.SquadName)
				{
					return AIBuddy;
				}
			}
		}
	}
	return None;
}

/** If we are in pushable cover determine if we need AI to help us */
function CheckForPushableCoverHelp(bool bOnlyGetInPosition)
{
	local InterpActor_MovableCover MovableActor;
	local GearAI ClosestAI;

	// Make sure we have a valid coverlink and that we're in a squad
	if (MyGearPawn != None && MyGearPawn.CurrentLink != None && Squad != None)
	{
		// See if we are in cover on a movable actor that needs multiple pushers
		// and if we need help from the AI
		MovableActor = InterpActor_MovableCover(MyGearPawn.CurrentLink.Base);
		if (MovableActor != None &&
			MovableActor.bIsMovable &&
			MovableActor.NumRequiredPushers > 1 &&
			!HasRequiredHumanControlledPlayers(MovableActor.NumRequiredPushers))
		{
			// See if there is already an AI squadmate in our cover
			ClosestAI = GetAISquadmateInMyCoverLink();
			// If we have AI with us already and he is in cover, tell it to do a push
			if (ClosestAI != None &&
				ClosestAI.MyGearPawn != None &&
				ClosestAI.MyGearPawn.IsInCover())
			{
				// Don't push if this call was only intended to get the AI into position
				if (!bOnlyGetInPosition &&
					ClosestAI.MyGearPawn != None)
				{
					ClosestAI.MyGearPawn.DoSpecialMove(SM_PushCover, true);
				}
			}
			// We need help and we don't have AI in cover with us yet, tell the closest AI to come help
			else
			{
				// Have the closest AI to us move into cover with us
				ClosestAI = GetClosestAISquadmate();
				if (ClosestAI != None)
				{
					ClosestAI.MoveAction = new class'SeqAct_AIMove';
					ClosestAI.MoveAction.MoveTargets.AddItem(MyGearPawn.CurrentLink);
					ClosestAI.MoveAction.TetherDistance = 0.0f;
					ClosestAI.OnAIMove(ClosestAI.MoveAction);
				}
			}
		}
	}
}

/** Tells any AI that was helping us push cover that they are free to go */
function FreeAIFromCoverPushHelp()
{
	local InterpActor_MovableCover MovableActor;
	local GearAI AIBuddy;

	// Make sure we have a valid coverlink
	if (MyGearPawn != None && MyGearPawn.CurrentLink != None && Squad != None)
	{
		// See if we are in cover on a movable actor that needs multiple pushers
		// and if we needed help from the AI
		MovableActor = InterpActor_MovableCover(MyGearPawn.CurrentLink.Base);
		if (MovableActor != None &&
			MovableActor.NumRequiredPushers > 1 &&
			!HasRequiredHumanControlledPlayers(MovableActor.NumRequiredPushers))
		{
			// See if there is already an AI squadmate in our cover
			AIBuddy = GetAISquadmateInMyCoverLink();
			// If we have AI with us let him be free if his move action
			if (AIBuddy != None)
			{
				AIBuddy.ClearMoveAction();
			}
		}
	}
}

simulated state PlayerTakingCover extends PlayerWalking
{
	exec function bool TryASpecialMove(bool bRunActions)
	{
		local bool bDoMonkeyMoveChecks;

		`LogSM("Try a cover special move");

		// if swat turning
		if (IsDoingSpecialMove(SM_StdLvlSwatTurn))
		{
			if (!IsTimerActive('TransitionFromSwatToRoadieRun'))
			{
				// only set the timer once to prevent button mashing issues
				SetTimer( 0.2f,FALSE,nameof(TransitionFromSwatToRoadieRun) );
			}
			return TRUE;
		}
		else if (!Global.TryASpecialMove(bRunActions))
		{
			bDoMonkeyMoveChecks = !bUseAlternateControls || !bRunActions;

			if( bDoMonkeyMoveChecks && CanDoSpecialMove(SM_MantleUpLowCover) )
			{
				// try to jump up on cover
				DoSpecialMove(SM_MantleUpLowCover);
				return TRUE;
			}
			else if( bDoMonkeyMoveChecks && CanDoSpecialMove(SM_CoverSlip) )
			{				// break out of cover
				DoSpecialMove(SM_CoverSlip);
				return TRUE;
			}
			else if( bDoMonkeyMoveChecks && CanDoSpecialMove(SM_MantleKick) )
			{
				// try to mantle kick over cover
				MyGearPawn.VerifySMHasBeenInstanced(SM_MantleKick);
				DoSpecialMove(SM_MantleKick, FALSE, None, GSM_MantleKick(MyGearPawn.SpecialMoves[SM_MantleKick]).PackSpecialMoveFlags());
				return TRUE;
			}
			else if( bDoMonkeyMoveChecks && CanDoSpecialMove(SM_MidLvlJumpOver) )
			{
				// try to jump over cover
				MyGearPawn.VerifySMHasBeenInstanced(SM_MidLvlJumpOver);
				DoSpecialMove(SM_MidLvlJumpOver, FALSE, None, GSM_MidLvlJumpOver(MyGearPawn.SpecialMoves[SM_MidLvlJumpOver]).PackSpecialMoveFlags());
				return TRUE;
			}
			// swat turn
			else if( bDoMonkeyMoveChecks && CanDoSpecialMove(SM_StdLvlSwatTurn) )
			{
				DoSpecialMove(SM_StdLvlSwatTurn);
				return TRUE;
			}
			else if( bPressAToBreakFromCover && MyGearPawn.IsCarryingAHeavyWeapon() && (!bUseAlternateControls || bRunActions) )
			{
				ClientBreakFromCover();
				return TRUE;
			}
			else if (MyGearPawn.IsAtCoverEdge(MyGearPawn.bIsMirrored,TRUE,0.5f) && TryToEvade())
			{
				// TryToEvade will starts the special move if successful
			}
			else if( !bUseAlternateControls || bRunActions )
			{
				// setup the timer for evade/roadierun
				if ( MyGearPawn.bCanUseCover || MyGearPawn.SpecialMoveClasses[SM_EvadeFwd] != None || MyGearPawn.SpecialMoveClasses[SM_EvadeBwd] != None ||
					MyGearPawn.SpecialMoveClasses[SM_EvadeLt] != None || MyGearPawn.SpecialMoveClasses[SM_EvadeRt] != None )
				{
					SetTimer(RoadieRunTimer, FALSE, nameof(TryToRoadieRun));
				}
				else
				{
					// if there are no other A button actions because cover isn't an option, roadie run immediately
					TryToRoadieRun();
				}
			}
		}
		return FALSE;
	}

	reliable client function ClientBreakFromCover()
	{
		bBreakFromCover = TRUE;
	}

	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);

		// if we should break from cover, let's do it now
		if( bBreakFromCover )
		{
			CoverLog("bBreakFromCover == TRUE, LeaveCover."@MyGearPawn.CurrentLink, GetFuncName());
			bBreakFromCover = FALSE;
			LeaveCover();
		}

		if( bForcedRoadieRun )
		{
			TryASpecialMove(FALSE);
		}
	}

	/**
	 * Yes, we are in a cover state.
	 */
	simulated function bool IsInCoverState()
	{
		return TRUE;
	}

	/**
	 * @See GearPC::TryToEvade
	 */
	exec function bool TryToEvade( optional EDoubleClickDir DoubleClickInput )
	{
		if( IsLocalPlayerController() && MyGearPawn != None && CanEvade() && Abs(RemappedJoyRight) > DeadZoneThreshold )
		{
			// test on the right
			if( RemappedJoyRight > 0 )
			{
				ClientBreakFromCover();
				DoSpecialMove(SM_EvadeRt);
				return TRUE;
			}
			else
			{
				ClientBreakFromCover();
				DoSpecialMove(SM_EvadeLt);
				return TRUE;
			}
		}
		else
		{
			//`log(`showvar(CanEvade()));
		}

		return FALSE;
	}

	/* ServerMove()
	- replicated function sent by client to server - contains client movement and firing info.
	*/
	unreliable server function ServerMove
	(
		float	TimeStamp,
		vector	InAccel,
		vector	ClientLoc,
		byte	MoveFlags,
		byte	ClientRoll,
		int		View
	)
	{
		// If this move is outdated, discard it.
		if( CurrentTimeStamp >= TimeStamp )
		{
			return;
		}

		// if the client sent a ServerMove() that isn't CoverServerMove(), then it left cover
		if ( !bServerMoveCoverActive && (ClientLoc != vect(1,2,3)) )
		{
			CoverLog("Servermove LeaveCover.", GetFuncName());
			LeaveCover();
		}
		Global.ServerMove(TimeStamp,InAccel,ClientLoc,MoveFlags,ClientRoll,View);
	}

	/**
	 * Overridden to handle initial cover setup.
	 */
	function BeginState(Name PreviousStateName)
	{
		local vector	CamLoc;		//, CoverNormal;
		local rotator	CamRot;

		super.BeginState(PreviousStateName);

		//old: default to popup on every new cover entry as that is generally the safer choice to make
		//new: default to lean when possible
		// Prefer popup with mulcher.
		bPreferLeanOverPopup = MyGearPawn == None || MyGearPawn.MyGearWeapon == None || MyGearPawn.MyGearWeapon.WeaponID != WC_Minigun;

		CoverLog("PreviousStateName:" @ PreviousStateName, GetFuncName());
		CoverTransitionCountHold = 0.f;

		// Set initial rotation to remap controls
		GetPlayerViewPoint(CamLoc, CamRot);
		ControlsRemapRotation = CamRot;

		bBreakFromCover = FALSE;

		// Always cancel double click direction when getting into cover
		FinishDoubleClick( TRUE );

		// If this is the host we need to see if we are in pushable cover and determine if we need
		// to send AI to help us
		if (Role == ROLE_Authority)
		{
			CheckForPushableCoverHelp(true);
		}
	}

	function EndState(Name NextStateName)
	{
		super.EndState(NextStateName);

		CoverLog("NextStateName:" @ NextStateName, GetFuncName());

		// reset the cover state to be not in cover
		SetPawnCoverAction(CA_Default);
		SetCoverDirection(CD_Default);
		SetPawnCoverType(CT_None);
		SetIsInStationaryCover(FALSE);
	}

	/**
	 * Overridden to update controls.
	 */
	function PlayerMove(float DeltaTime)
	{
		local ECoverType		PawnCT;
		local ECoverAction		PawnCA;
		local ECoverDirection	PawnCD;
		local int				bNewLeftSided;

		// Update this first, this will set 360 aiming flag, that we need before doing all the cover action stuff.
		MyGearPawn.UpdateMeshBoneControllers(DeltaTime);

		if( !IsMoveInputIgnored() || bAllowDisabledMovementFiring )
		{
			// get the current state
			PawnCT			= MyGearPawn.FindCoverType();
			PawnCA			= MyGearPawn.CoverAction;
			PawnCD			= GetCoverDirection();
			bNewLeftSided	= int(MyGearPawn != None && MyGearPawn.bWantsToBeMirrored);
			// Update player posture
			// But not if breaking from cover
			if( !bBreakFromCover && !IsDoingSpecialMove(SM_PushOutOfCover) )
			{
				UpdatePlayerPosture(DeltaTime, PawnCT, PawnCA, PawnCD, bNewLeftSided);
			}
			else
			{
				// Force action to be default
				PawnCA = CA_Default;
				PawnCT = CT_None;
			}
			// update the state
			SetPawnCoverType(PawnCT);
			SetPawnCoverAction(PawnCA);
			SetCoverDirection(PawnCD);

			// If breaking from cover, don't mess with mirroring transitions.
			if( !bBreakFromCover )
			{
				if (bool(bNewLeftSided) != MyGearPawn.bWantsToBeMirrored)
				{
					// we do this here instead of in SetMirriredSide because that function gets called for
					// many other mirror-changing situations where we don't want to do the sound
					MyGearPawn.SoundGroup.PlayFoleySound(MyGearPawn, GearFoley_BodyTurnFX, TRUE);
				}

				MyGearPawn.SetMirroredSide(bool(bNewLeftSided));
			}
		}

		// normal update
		Super.PlayerMove(DeltaTime);
	}

	simulated function DetermineLeanDirection
	(
		GearPawn				P,
		bool					bIsAtSlot,
		out const CoverSlot		CurrentSlot,
		int						bNewLeftSided,
		out ECoverAction		OutPawnCA,
		out	ECoverDirection		OutPawnCD
	)
	{
		local bool bJoyUpDominant, bJoyRightDominant, bTargeting, bCanPopUp;

		// No actions while reloading or switching weapons
		if( (P.IsReloadingWeapon() && P.MyGearWeapon.ShouldReloadingPreventTargeting()) || P.bSwitchingWeapons || P.bDoing360Aiming )
		{
			OutPawnCD = CD_Default;
			OutPawnCA = CA_Default;
			return;
		}

		// Reset cover action by default
		OutPawnCD = CD_Default;
		OutPawnCA = CA_Default;

		// determine which direction is dominant
		bJoyUpDominant = Abs(RemappedJoyUp) > DeadZoneThreshold && Abs(RemappedJoyUp) > Abs(RemappedJoyRight);
		bJoyRightDominant = Abs(RemappedJoyRight) > DeadZoneThreshold && Abs(RemappedJoyRight) > Abs(RemappedJoyUp);
		bTargeting = WantsToTarget();
		// can we popup?  based on slot setting, and if it's midlevel cover.
		bCanPopUp = CurrentSlot.bCanPopUp && P.CoverType == CT_MidLevel;

		// if targeting,
		if( bTargeting )
		{
			// if we can popup, then by default popup
			if (bCanPopUp)
			{
				OutPawnCD = CD_Up;
				OutPawnCA = CA_PopUp;
			}
			// Otherwise, if we are at a left edge and facing left
			if( bIsAtSlot && bNewLeftSided == 1 && CurrentSlot.bLeanLeft )
			{
				// if we can lean or popup
				// Decide if we should lean or pop up
				// Lean if...
				if( !bCanPopUp
					|| (P.AimOffsetPct.X < 0.4f
						&& ((!bJoyRightDominant && !bJoyUpDominant && (bPreferLeanOverPopup || P.CoverType == CT_Standing))
							|| (bJoyRightDominant && RemappedJoyRight < -DeadZoneThreshold)
							)
						)
					)
				{
					// Set lean left
					OutPawnCD = CD_Left;
					OutPawnCA = CA_LeanLeft;
				}
			}
			else
			// Otherwise, if we are at a right edge and facing right and can lean right
			if( bIsAtSlot && bNewLeftSided == 0 && CurrentSlot.bLeanRight )
			{
				if( !bCanPopUp
					|| (P.AimOffsetPct.X > -0.4f
						&& ((!bJoyRightDominant && !bJoyUpDominant && (bPreferLeanOverPopup || P.CoverType == CT_Standing))
							|| (bJoyRightDominant && RemappedJoyRight > DeadZoneThreshold)
							)
						)
					)
				{
					// Set lean right
					OutPawnCD = CD_Right;
					OutPawnCA = CA_LeanRight;
				}
			}
		}
		// blindfiring
		else
		{
			// if attempting to fire, or recently blindfired (and not recently hurt),
			if( (WeaponHasAnyAmmo() && P.PawnCommitToFiring(0)) ||
				(`TimeSince(P.LastWeaponBlindFireTime) < P.AimTimeAfterFiring && `TimeSince(P.LastTookDamageTime) > 0.3f && IsBlindFiring(P.CoverAction)) )
			{
				// default to blind up if possible
				if( bCanPopUp && P.CoverType == CT_MidLevel )
				{
					OutPawnCD = CD_Up;
					OutPawnCA = CA_BlindUp;
				}

				if (bIsAtSlot)
				{
					if( bNewLeftSided == 1 && CurrentSlot.bLeanLeft )
					{
						// if we can't popup, or
						// if pressing left, or
						// not pressing anything and we prefer leans
						if( !bCanPopUp ||
							(P.AimOffsetPct.X < 0.2f &&
								((bJoyRightDominant && RemappedJoyRight < -DeadZoneThreshold) || (!bJoyRightDominant && !bJoyUpDominant && bPreferLeanOverPopup)) ) )
						{
							// blind left baby!
							OutPawnCD = CD_Left;
							OutPawnCA = CA_BlindLeft;
						}
					}
					else
					if( bNewLeftSided == 0 && CurrentSlot.bLeanRight )
					{
						if( !bCanPopUp ||
							(P.AimOffsetPct.X > -0.2f &&
								((bJoyRightDominant && RemappedJoyRight > DeadZoneThreshold) || (!bJoyRightDominant && !bJoyUpDominant && bPreferLeanOverPopup)) ) )
						{
							OutPawnCD = CD_Right;
							OutPawnCA = CA_BlindRight;
						}
					}
				}
			}
		}

		// If Pawn is not allowed to do a leaning transition, then prevent him from doing so.
		if( !P.CanDoLeaningTransition() )
		{
			if( P.CoverAction != OutPawnCA && P.IsALeaningAction(P.CoverAction) && P.IsALeaningAction(OutPawnCA) )
			{
				OutPawnCA = P.CoverAction;
				OutPawnCD = P.CoverDirection;
			}
		}

		if( OutPawnCD != CD_Default )
		{
			// set the lean preference based on our last action
			bPreferLeanOverPopup = (OutPawnCD != CD_Up);
		}
	}

	/**
	 * Update Player posture. Return true if allowed to move
	 *
	 * @param 	OutPawnCT	Pawn's Cover type
	 * @param 	OutPawnCA	Pawn's Cover Action
	 * @param 	OutPawnCD	Cover Direction
	 *
	 * @return true if allowed to move
	 */
	simulated function UpdatePlayerPosture
	(
			float				DeltaTime,
		out	ECoverType			OutPawnCT,
		out ECoverAction		OutPawnCA,
		out	ECoverDirection		OutPawnCD,
		out	int					bNewLeftSided
	)
	{
		local bool bIsAtSlot, bJoyUpDominant, bJoyRightDominant, bTargeting, bJoyIsLeft, bJoyIsRight;
		local CoverSlot CurrentSlot;
		local int SlotIdx, EdgeSlotIdx;
		local ECoverDirection NewSlotDirection;

		// grab the slot we're at
		SlotIdx		= MyGearPawn.PickClosestCoverSlot(TRUE,0.5f,TRUE);
		if (SlotIdx == -1)
		{
			bIsAtSlot = FALSE;
			SlotIdx = MyGearPawn.CurrentSlotIdx;
		}
		else
		{
			bIsAtSlot = TRUE;
		}
		CurrentSlot	= MyGearPawn.CurrentLink.Slots[SlotIdx];

		// Check which joy axis is dominant
		bJoyUpDominant		= Abs(RemappedJoyUp) > Abs(RemappedJoyRight);
		bJoyRightDominant	= Abs(RemappedJoyRight) > Abs(RemappedJoyUp);
		bJoyIsLeft			= RemappedJoyRight < -DeadZoneThreshold;
		bJoyIsRight			= RemappedJoyRight > DeadZoneThreshold;

		bTargeting			= MyGearPawn.bIsTargeting;

		// reset any pawn movement by default
		NewSlotDirection = CD_Default;

		// if not holding back
		if (!bJoyUpDominant || Abs(RemappedJoyUp) < DeadZoneThreshold)
		{
			// reset the break from cover timer
			BreakFromCoverHoldTimer = 0.f;
		}

		// vertical axis
		if( bJoyUpDominant )
		{
			// If pulling away from cover, then break from it
			if( RemappedJoyUp < -DeadZoneThreshold && IsLocalPlayerController() && (!IsDoingASpecialMove() || MyGearPawn.IsDoingMove2IdleTransition()) )
			{
				// Don't allow pushing out of cover if movement is disabled but shooting is allowed
				if ( !bAllowDisabledMovementFiring )
				{
					// disallow cover break when popping up with a heavy weapon, or holding movable cover
					if ( ( !MyGearPawn.IsCarryingAHeavyWeapon() || (MyGearPawn.CoverAction != CA_PopUp) ) &&
						 ( !MyGearPawn.bGrabbingMovableCover ) )
					{
						// increment the timer
						BreakFromCoverHoldTimer += DeltaTime;
						// if exceeded the threshold then break from cover now
						if (BreakFromCoverHoldTimer >= BreakFromCoverHoldTime)
						{
// @LD trying to compensate for Lean putting Pawn outside of collision cylinder
// in GSM_PushOutOfCover. So forcing that special move, but we disable animation when doing a pop up or a lean.
							// Don't play push out transition if popping up or leaning.
// 							if( MyGearPawn.CoverAction != CA_PopUp && !MyGearPawn.IsLeaning() && CanDoSpecialMove(SM_PushOutOfCover) )
// 							{
								DoSpecialMove(SM_PushOutOfCover, FALSE, None, MyGearPawn.CoverAction);
// 							}
// 							else
// 							{
// 								// otherwise delay a tick and do a normal leavecover
// 								ClientBreakFromCover();
// 							}
							// no need to process further
							return;
						}
					}
				}
			}
		}
		else
		// horizontal axis
		if( bJoyRightDominant && !MyGearPawn.bGrabbingMovableCover )
		{
			// if they are locked into a slot
			if( MyGearPawn.bIsInStationaryCover )
			{
				// if not actually at a slot origin
				if( !bIsAtSlot )
				{
					// then unlock them
					SetIsInStationaryCover(FALSE);
				}
				// if they are trying to move away from the slot
				else if ((CurrentSlot.bLeanLeft && bJoyIsRight && !MyGearPawn.IsAtRightEdgeSlot()) ||
						(CurrentSlot.bLeanRight && bJoyIsLeft && !MyGearPawn.IsAtLeftEdgeSlot()))
				{
					// then unlock them
					SetIsInStationaryCover(FALSE);
				}
				// if not currently targeting check for delayed transitions,
				else if( !bTargeting )
				{
					if( bJoyIsLeft )
					{
						// if we're allowed a transition
						if( MyGearPawn.CurrentLink.AllowLeftTransition(MyGearPawn.CurrentSlotIdx) )
						{
							// if this slot can't even lean left,
							if( !CurrentSlot.bLeanLeft || IsDoingSpecialMove(SM_CoverRun) )
							{
								// then unlock immediately
								SetIsInStationaryCover(FALSE);
							}
							else
							{
								// otherwise increment the counter
								CoverTransitionCountHold += DeltaTime;
								// if the counter has exceeded the threshold,
								if( CoverTransitionCountHold > CoverTransitionTime )
								{
									CoverTransitionCountHold = 0.f;
									// unlock them from cover
									SetIsInStationaryCover(FALSE);
								}
							}
						}
					}
					else if( bJoyIsRight )
					{
						// if we're allowed a transition
						if( MyGearPawn.CurrentLink.AllowRightTransition(MyGearPawn.CurrentSlotIdx) )
						{
							// if this slot can't even lean right, or is running
							if( !CurrentSlot.bLeanRight || IsDoingSpecialMove(SM_CoverRun) )
							{
								// then unlock immediately
								SetIsInStationaryCover(FALSE);
							}
							else
							{
								// otherwise increment the counter
								CoverTransitionCountHold += DeltaTime;
								// if the counter has exceeded the threshold,
								if( CoverTransitionCountHold > CoverTransitionTime )
								{
									CoverTransitionCountHold = 0.f;
									// unlock them from cover
									SetIsInStationaryCover(FALSE);
								}
							}
						}
					}
				}
			}

			if( !IsDoingSpecialMove(SM_CoverRun) )
			{
				// no movement while popping up in standing cover
				if( MyGearPawn.CoverType == CT_Standing && OutPawnCA == CA_PopUp )
				{
					OutPawnCD = CD_Default;
				}
				// check to see if the player is trying to switch directions
				// current right but pushing left?
				else if( !bTargeting && bJoyIsLeft && bNewLeftSided == 0 )
				{
					// Don't mirror in 360 aiming.
					if( !MyGearPawn.bDoing360Aiming )
					{
						//`log("Turn Left, Not in 360");
						bNewLeftSided = 1;
					}
					OutPawnCD = CD_Left;
				}
				// currently left but pushing right?
				else if( !bTargeting && bJoyIsRight && bNewLeftSided == 1 )
				{
					// Don't mirror in 360 aiming.
					if( !MyGearPawn.bDoing360Aiming )
					{
						//`log("Turn Right, Not in 360");
						bNewLeftSided = 0;
					}
					OutPawnCD = CD_Right;
				}
				else if( bJoyIsLeft || bJoyIsRight )
				{
					// otherwise pick direction based on joystick
					OutPawnCD = bJoyIsLeft ? CD_Left : CD_Right;
				}
				else
				{
					OutPawnCD = CD_Default;
				}
			}

			// if not locked into a slot
			if( !MyGearPawn.bIsInStationaryCover && !IsMoveInputIgnored() )
			{
				// then set the slot direction so physics will move the player
				NewSlotDirection = OutPawnCD;
			}
			else
			{
				// otherwise keep them stationary
				NewSlotDirection = CD_Default;
			}
		}

		// avoid setting bNetDirty to true unnecessarily
		if (MyGearPawn.CurrentSlotDirection != NewSlotDirection)
		{
			MyGearPawn.CurrentSlotDirection = NewSlotDirection;
		}

		// if not already performing a cover special move
		if (!IsDoingSpecialMove(SM_CoverRun) && !IsDoingSpecialMove(SM_CoverSlip) && !IsDoingSpecialMove(SM_MidLvlJumpOver))
		{
			// Setup lean/popup action and direction
			DetermineLeanDirection( MyGearPawn, bIsAtSlot, CurrentSlot, bNewLeftSided, OutPawnCA, OutPawnCD );

			// if we want to target in standing cover but can't,
			if( !MyGearPawn.IsReloadingWeapon() && !MyGearPawn.bDoing360Aiming && !MyGearPawn.bDoingMirrorTransition )
			{
				//`define automovedebug(msg)	`log(`msg)
				`define automovedebug(msg)
				if (WantsToTarget() && !CurrentSlot.bCanPopUp && CurrentSlot.CoverType == CT_Standing && MyGearPawn.CoverAction == OutPawnCA && OutPawnCA == CA_Default )
				{
					`automovedebug("blah:"@MyGearPawn.PickClosestCoverSlot(FALSE)@MyGearPawn.PickClosestCoverSlot(TRUE)@MyGearPawn.bIsMirrored);
					// if it's because we're in standing cover facing the wrong direction
					if (MyGearPawn.IsAtCoverEdge(!MyGearPawn.bIsMirrored,TRUE,0.5f,EdgeSlotIdx,SlotIdx))
					{
						`automovedebug("flipping player to cover edge"@EdgeSlotIdx);
						// then flip to the correct direction
						bNewLeftSided = MyGearPawn.CurrentLink.Slots[EdgeSlotIdx].bLeanLeft ? 1 : 0;
						//(EdgeSlotIdx <= SlotIdx ? 1 : 0);
					}
					else
					// otherwise trigger a cover run to the edge as long as the player isn't pushing the opposite direction
					if (!bIsAtSlot && MyGearPawn.IsAtCoverEdge(MyGearPawn.bIsMirrored,TRUE,2.f) && ((!MyGearPawn.bIsMirrored && !bJoyIsLeft) || (MyGearPawn.bIsMirrored && !bJoyIsRight)))
					{
						`automovedebug("triggering cover run to edge"@MyGearPawn.IsAtCoverEdge(MyGearPawn.bIsMirrored,TRUE,0.5f));
						MyGearPawn.bIsInStationaryCover = FALSE;
						DoSpecialMove(SM_CoverRun,FALSE,None,1);
					}
				}
				else if (CurrentSlot.CoverType == CT_Standing && MyGearPawn.PawnCommitToFiring(0) && OutPawnCA == CA_Default && MyGearPawn.IsAtCoverEdge(!MyGearPawn.bIsMirrored,TRUE,0.5f,EdgeSlotIdx,SlotIdx))
				{
					`automovedebug("mirroring to fire");
					bNewLeftSided = MyGearPawn.CurrentLink.Slots[EdgeSlotIdx].bLeanLeft ? 1 : 0;
				}
			}
		}

		// save the slot we're closest too
		MyGearPawn.ClosestSlotIdx = SlotIdx;
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		local GearPawn P;
		local vector CamLoc;
		local rotator CamRot;

		super.ProcessMove( DeltaTime, NewAccel, DoubleClickMove, DeltaRot );

		P = GearPawn(Pawn);
		if( P == None )
		{
			return;
		}

		if( IsLocalPlayerController() )
		{
			if( DoubleClickMove != DCLICK_None )
			{
				// remap the double clicks based on camera orientation
				GetPlayerViewPoint(CamLoc,CamRot);
				// if facing backwards then just swap them all
				if (vector(CamRot) dot vector(Pawn.Rotation) < -0.3)
				{
					if (DoubleClickMove == DCLICK_Forward)
					{
						DoubleClickMove = DCLICK_Back;
					}
					else if (DoubleClickMove == DCLICK_Back)
					{
						DoubleClickMove = DCLICK_Forward;
					}
					else if (DoubleClickMove == DCLICK_Left)
					{
						DoubleClickMove = DCLICK_Right;
					}
					else if (DoubleClickMove == DCLICK_Right)
					{
						DoubleClickMove = DCLICK_Left;
					}
				}
				// if facing to the side
				else if (vector(CamRot) dot vector(Pawn.Rotation) < 0.3)
				{
					//  if facing to the right
					if (Normal(vector(CamRot) cross vect(0,0,1)) dot vector(Pawn.Rotation) > 0)
					{
						// rotate to the right
						if (DoubleClickMove == DCLICK_Forward)
						{
							DoubleClickMove = DCLICK_Right;
						}
						else if (DoubleClickMove == DCLICK_Back)
						{
							DoubleClickMove = DCLICK_Left;
						}
						else if (DoubleClickMove == DCLICK_Left)
						{
							DoubleClickMove = DCLICK_Forward;
						}
						else if (DoubleClickMove == DCLICK_Right)
						{
							DoubleClickMove = DCLICK_Back;
						}
					}
					else
					{
						// rotate to the left
						if (DoubleClickMove == DCLICK_Forward)
						{
							DoubleClickMove = DCLICK_Left;
						}
						else if (DoubleClickMove == DCLICK_Back)
						{
							DoubleClickMove = DCLICK_Right;
						}
						else if (DoubleClickMove == DCLICK_Left)
						{
							DoubleClickMove = DCLICK_Back;
						}
						else if (DoubleClickMove == DCLICK_Right)
						{
							DoubleClickMove = DCLICK_Forward;
						}
					}
				}
				if( DoubleClickMove == DCLICK_Forward )
				{
					if( TryDoubleTapMove(SM_MantleUpLowCover) ||
						TryDoubleTapMove(SM_MantleKick) ||
						TryDoubleTapMove(SM_CoverSlip) ||
						TryDoubleTapMove(SM_MidLvlJumpOver)	)
					{
						// Successfully climbed up, over, or around
						FinishDoubleClick(TRUE);
					}
				}
				else if( DoubleClickMove == DCLICK_Left || DoubleClickMove == DCLICK_Right )
				{
					if( TryDoubleTapMove(SM_StdLvlSwatTurn) || TryToEvade(DoubleClickMove) )
					{
						// Successful swat turn or evade
						FinishDoubleClick(TRUE);
					}
				}

				if( DoubleClickMove == DCLICK_Active )
				{
					// If not giving any input once you get into cover, remove double click
					if( PlayerInput.RawJoyUp == 0 &&
						PlayerInput.RawJoyRight == 0 )
					{
						if( IsDoingSpecialMove(SM_CoverRun) || IsDoingSpecialMove(SM_RoadieRun) )
						{
							EndSpecialMove();
						}
						else
						{
							FinishDoubleClick( FALSE );
						}
					}
				}
				else if( DoubleClickMove != DCLICK_Done && DoubleClickDir  != DCLICK_Done )
				{
					// Set click direction as active
					CurrentDoubleClickDir = DoubleClickDir;
					DoubleClickDir = DCLICK_Active;
				}
			}
			else if( !MainPlayerInput.IsButtonActive(bUseAlternateControls?GB_X:GB_A) && PlayerInput.RawJoyUp == 0 && PlayerInput.RawJoyUp == 0 && MyGearPawn.SpecialMoveFlags == 0 )
			{
				if( !bBreakFromCover && ( IsDoingSpecialMove(SM_CoverRun) || IsDoingSpecialMove(SM_RoadieRun) ) )
				{
					EndSpecialMove();
				}
			}
		}
	}
}

/** For trying special moves when using the double tap movement */
function bool TryDoubleTapMove( ESpecialMove TapMove )
{
	if ( IsInCoverState() && CanDoSpecialMove(TapMove, true) )
	{
		DoSpecialMove( TapMove );
		return true;
	}
	return false;
}

final function FinishDoubleClick( bool bAllowInstant )
{
	if( PlayerInput != None )
	{
		MainPlayerInput.DoubleClickTimer = bAllowInstant ? -0.15f : 0.f;
	}
	DoubleClickDir = DCLICK_Done;
}

final function ResetDoubleClick()
{
	DoubleClickDir = DCLICK_None;
}

/** Whether the action button is being held or not */
simulated final function bool IsHoldingActionButton()
{
	return ((MainPlayerInput != None && MainPlayerInput.IsButtonActive(GB_A)) || DoubleClickDir == DCLICK_Active);
}

/** Whether the roadie run button is being held or not */
simulated final function bool IsHoldingRoadieRunButton()
{
	return ((MainPlayerInput != None && MainPlayerInput.IsButtonActive(bUseAlternateControls?GB_X:GB_A)) || DoubleClickDir == DCLICK_Active);
}

/** Whether the POI button is being held or not */
simulated final function bool IsHoldingPOIButton( optional bool bRaw )
{
	return (MainPlayerInput != None && MainPlayerInput.IsButtonActive(bUseAlternateControls?GB_RightStick_Push:GB_Y, true));
}

simulated function NotifyCoverDisabled( CoverLink Link, int SlotIdx, optional bool bAdjacentIdx )
{
	local bool bBreakCover;

	if( !bAdjacentIdx )
	{
		bBreakCover = TRUE;
	}
	else
	{
		// If given slot is to my right
		if( SlotIdx > MyGearPawn.CurrentSlotIdx ||
			(SlotIdx == 0 && MyGearPawn.CurrentSlotIdx == Link.Slots.length - 1) )
		{
			if( MyGearPawn.RightSlotIdx == SlotIdx )
			{
				bBreakCover = TRUE;
			}

		}

		// If given slot is to my left
		if(  SlotIdx < MyGearPawn.CurrentSlotIdx ||
			(MyGearPawn.CurrentSlotIdx == 0 && SlotIdx == Link.Slots.Length - 1) )
		{
			if( MyGearPawn.LeftSlotIdx == SlotIdx )
			{
				bBreakCover = TRUE;
			}
		}
	}

	if( bBreakCover )
	{
		// Heavy Weapons don't have animations for GSM_CoverDestroyed, but we need to unmount them
		if (MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.WeaponType == WT_Heavy)
		{
			if (MyGearPawn.IsMountingHeavyWeapon())
			{
				MyGearPawn.LocalEndSpecialMove();
			}
		}
		else
		{
			// Cover destroyed special move
			MyGearPawn.ServerDoSpecialMove(GSM_CoverDestroyed, TRUE);
		}

		// break from cover normally
		ClientBreakFromCover();
	}
}

simulated event NotifyCoverAdjusted()
{
	if (MyGearPawn != None)
	{
		MyGearPawn.SetCurrentCoverType();
	}
}

/**
 * Sets new cover direction.
 * Which represents where the camera is focusing.
 * (CD_Right for a right lean or right blind firing).
 *
 * @param	NewCD	new cover direction
 */

final function SetCoverDirection( ECoverDirection NewCD )
{
	if( MyGearPawn != None &&
		MyGearPawn.CoverDirection != NewCD )
	{
		CoverLog("NewCD:" @ NewCD, GetFuncName() );
		MyGearPawn.CoverDirection = NewCD;
	}
}

/**
 * Return cover direction
 * Which represents where the camera is focusing.
 * (CD_Right for a right lean or right blind firing).
 *
 * @return cover direction
 */
final native function ECoverDirection GetCoverDirection();

/**
 * Assign new cover action to Pawn. (Defined in CoverLink.uc)
 *
 * @param	NewCA	New CoverAction.
 */
final function SetPawnCoverAction( ECoverAction NewCA )
{
	if( MyGearPawn != None &&
		MyGearPawn.CoverAction != NewCA )
	{
		MyGearPawn.SetCoverAction( NewCA );
	}
}

/**
 * Assign new cover type to Pawn. (Defined in CoverLink.uc)
 *
 * @param	NewCT	New CoverType.
 */
final function SetPawnCoverType( ECoverType NewCT )
{
	if( MyGearPawn != None )
	{
		MyGearPawn.SetCoverType( NewCT );
	}
}

/**
 * Set the new is in stationary cover flag on the pawn, and update
 * the replication flag.
 */
final function SetIsInStationaryCover(bool NewbIsInStationaryCover)
{
	if (MyGearPawn != None &&
		NewbIsInStationaryCover != MyGearPawn.bIsInStationaryCover)
	{
		MyGearPawn.bIsInStationaryCover = NewbIsInStationaryCover;
	}
}

simulated event NotifyDirectorControl(bool bNowControlling)
{
	local GearPlayerCamera GearCam;

	bInMatinee = bNowControlling;

	// if we were waiting to spawn in to avoid interfering with matinee control, try it now
	if (!bNowControlling && (IsInState('PlayerWaiting') || IsTimerActive('ServerRestartPlayer')))
	{
		ClearTimer('ServerRestartPlayer');
		ServerRestartPlayer();
	}

	// sanity check that matinee didn't reset view to the PC when it should be the Pawn
	//@hackish: and that it didn't get left on the final camera (especially can happen when they do camera-related Kismet simultaneously)
	if (!bNowControlling && Pawn != None && (GetViewTarget() == self || CameraActor(GetViewTarget()) != None))
	{
		if (Role == ROLE_Authority)
		{
			SetViewTarget(Pawn);
		}
		else
		{
			ServerVerifyViewTarget();
		}
	}

	if (Role == ROLE_Authority && GearGame(WorldInfo.Game).bSkipAllMatinees)
	{
		`log( "bSkipAllMatinees == TRUE so we are canceling this cine" );
		SetTimer( 2.0f, FALSE, nameof(CancelCine) );
	}

	if (!bNowControlling)
	{
		GearCam = GearPlayerCamera(PlayerCamera);
		if (GearCam != None)
		{
			// cancel any camera shakes
			GearCam.ClearAllCameraShakes();
		}
	}

	super.NotifyDirectorControl(bNowControlling);
}

function TransitionFromRoadieRunToCover( CovPosInfo FoundCovInfo, optional bool bNoCameraAutoAlign )
{
	local bool bSeamlessTransition;

	bSeamlessTransition = FoundCovInfo.Normal dot vector(MyGearPawn.Rotation) > -0.83f;

	// temporarily disable the slam into cover to make it a seamless transition
	MyGearPawn.bCanDoRun2Cover = !bSeamlessTransition;

	EndSpecialMove();
	AcquireCover( FoundCovInfo, bNoCameraAutoAlign );

    // Play Wall impact effects
	MyGearPawn.DoRun2CoverWallHitEffects();

	if ( !bUseAlternateControls )
	{
		// if we didn't suck into an edge
		if (bSeamlessTransition && !MyGearPawn.IsAtLeftEdgeSlot() && !MyGearPawn.IsAtRightEdgeSlot())
		{
			// try a cover run
			DoSpecialMove(SM_CoverRun);
		}
		else
		{
			// otherwise release the 'A' button from roadie run to prevent getting popped out unintentionally
			ForceButtonRelease(bUseAlternateControls?GB_X:GB_A,TRUE);
		}
	}

	MyGearPawn.bCanDoRun2Cover = MyGearPawn.default.bCanDoRun2Cover;
}

/** determine player's fortification building ability based on their persistent data */
simulated function InitFortificationUpgradeLevels();

/** sets the upgrade level for the specified fortification class (client only) */
simulated final function SetFortificationUpgradeLevel(class<GearFortification> FortClass, int UpgradeLevel, float RepairPct)
{
	local int i;

	if (LocalPlayer(Player) == None)
	{
		`Warn("Only supported for local player");
	}
	else
	{
		i = FortificationUpgrades.Find('FortClass', FortClass);
		if (i == INDEX_NONE)
		{
			i = FortificationUpgrades.Add(1);
			FortificationUpgrades[i].FortClass = FortClass;
		}
		FortificationUpgrades[i].UpgradeLevel = UpgradeLevel;
		FortificationUpgrades[i].RepairPct = RepairPct;
	}
}

/** @return the upgrade level this player has for the specified fortification class (client only) */
native final function int GetFortificationUpgradeLevel(class<GearFortification> FortClass, optional out float RepairPct);


// cheats to manipulate unlocked fortifications; must be here because it's client side and CheatManager is on the server
`if(`notdefined(FINAL_RELEASE))

exec function SetFortUpgrade(name FortName, int UpgradeLevel, optional float RepairPct = 1.0)
{
	local class<GearFortification> FortClass;

	FortClass = class<GearFortification>(FindObject("GearGame.GearFortification_" $ FortName, class'Class'));
	SetFortificationUpgradeLevel(FortClass, UpgradeLevel, RepairPct);
}

exec function UnlockAllFortUpgrades()
{
	FortificationUpgrades.length = 0;
}

`endif

/** @return whether this player has enough points to buy the given fortification and is allowed to spend it
 * (e.g. not exceeding any spending caps)
 */
simulated final function bool CanPayFortificationCost(class<GearFortification> FortClass)
{
	return (PlayerReplicationInfo != None && PlayerReplicationInfo.Score >= FortClass.static.GetPurchaseCost(0, WorldInfo));
}

/** request to the server to spawn a fortification from the specified marker */
reliable server final function ServerPlaceFortificationFromMarker(GearFortificationMarker Marker)
{
	if ( MyGearPawn != None && MyGearPawn.Health > 0 && !MyGearPawn.IsInCover() && Marker != None && Marker.bCollideActors && GetTeamNum() == 0 &&
		GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications && CanPayFortificationCost(Marker.FortificationType) &&
		!Marker.FortificationType.static.IsEncroachingOnBuildLocation(Pawn, Marker.Location, Marker.Rotation) )
	{
		Marker.SpawnFortification(self, 0);
	}
}

/** Call made to inform the client that it successfully spent Amount on a fortification of the specified class
 *	@param FortificationType - What type of fortification was placed
 *	@param Amount - how much cash was spent
 */
reliable client final function ClientFortificationInvestment(class<GearFortification> FortificationType, int Amount)
{
	if (FortificationType != None && FortificationType.default.StatName != 'None')
	{
		ModifyStat('CashSpent', Amount);
		ModifyStat(name(string(FortificationType.default.StatName) $ "Spent"), Amount);
	}
}

/**
 * Cancels any current spot, pawn or pickup
 */
function CancelCurrentSpot()
{
	local int SpotterTeamNum;
	SpotterTeamNum = GetTeamNum();

	LastSpotTime = -1.f;
	if (GearPRI(PlayerReplicationInfo).SpottedPickup != None)
	{
		GearPRI(PlayerReplicationInfo).SpottedPickup = None;
	}
	if (SpottedEnemy != None)
	{
		switch (SpotterTeamNum)
		{
		case 0:
			SpottedEnemy.RemoveSpotTeam0();
			break;
		case 1:
			SpottedEnemy.RemoveSpotTeam1();
			break;
		case 2:
			SpottedEnemy.RemoveSpotTeam2();
			break;
		case 3:
			SpottedEnemy.RemoveSpotTeam3();
			break;
		}
		SpottedEnemy = None;
	}
}

/**
 * Mark a pawn spotted and set a timer to expire the spot
 *
 * @param SpottedPawn - the pawn that was spotted
 */
reliable server function ServerMarkPawnSpotted(GearPawn SpottedPawn)
{
	local GearPC GPC;
	local int SpotterTeamNum;

	SpotterTeamNum = GetTeamNum();

	if (LastSpotTime >= 0)
	{
		if (GearGame(WorldInfo.Game).SpotChangeDelay <= 0 || `TimeSince(LastSpotTime) < GearGame(WorldInfo.Game).SpotChangeDelay)
		{
			// Not ready to respot
			return;
		}
		CancelCurrentSpot();
	}

	if (SpottedPawn != None && SpottedPawn.SpottedByTeam[SpotterTeamNum] == 0)
	{
		LastSpotTime = WorldInfo.TimeSeconds;
		SpottedEnemy = SpottedPawn;
		SetTimer(GearGame(WorldInfo.Game).SpotLength, false, 'AllowSpotting');

		SpottedPawn.SpottedByTeam[SpotterTeamNum] = 1;
		SpottedPawn.SpottedBy[SpotterTeamNum] = GearPRI(PlayerReplicationInfo);
		SpottedPawn.SpottedTime[SpotterTeamNum] = WorldInfo.TimeSeconds;

		// Static array replication currently does not support autoset of bNetDirty
		SpottedPawn.bNetDirty = TRUE;

		switch (SpotterTeamNum)
		{
		case 0:
			SpottedPawn.SetTimer(GearGame(WorldInfo.Game).SpotLength, false, 'RemoveSpotTeam0');
			break;
		case 1:
			SpottedPawn.SetTimer(GearGame(WorldInfo.Game).SpotLength, false, 'RemoveSpotTeam1');
			break;
		case 2:
			SpottedPawn.SetTimer(GearGame(WorldInfo.Game).SpotLength, false, 'RemoveSpotTeam2');
			break;
		case 3:
			SpottedPawn.SetTimer(GearGame(WorldInfo.Game).SpotLength, false, 'RemoveSpotTeam3');
			break;
		}

		foreach LocalPlayerControllers(class'GearPC', GPC)
		{
			// the server doesn't get a repnotify, add the hud locators here
			GPC.AddedSpottedEnemyLocator(SpottedPawn);

			// Update the stats
			if (GPC.GetTeamNum() == SpotterTeamNum && GearPRI(GPC.PlayerReplicationInfo) == SpottedPawn.SpottedBy[SpotterTeamNum])
			{
				GPC.ModifyStat('SpottedPlayerMP');
			}
		}

		`RecordPlayerPlayerEvent(SPOTTEDENEMY, Self, Controller(SpottedPawn.PlayerReplicationInfo.Owner));

		if (Pawn != None)
		{
			if (GearGRI_Horde(WorldInfo.GRI) != None && SpottedPawn.NoticedGUDSEvent != GUDEvent_None && !SpottedPawn.bSuppressNoticedGUDSEvents)
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(SpottedPawn.NoticedGUDSEvent, Pawn, SpottedPawn);
			}
			else
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_EnemySpotted, Pawn, SpottedPawn);
			}
		}
	}
}

/** Let ServerMarkPawnSpotted succeed again */
function AllowSpotting()
{
	LastSpotTime = -1.f;
	SpottedEnemy = None;
}

/**
 * Add hud locator for a spotted enemy
 *
 * @param SpottedPawn - the pawn that was spotted
 */
function AddedSpottedEnemyLocator(GearPawn SpottedPawn)
{
	if (!GearPRI(SpottedPawn.PlayerReplicationInfo).bIsLeader && SpottedPawn.GetTeamNum() != GetTeamNum())
	{
		MyGearHud.AddHUDLocator(class'GearHUDLocator_Spotted', SpottedPawn);
	}
}

/** Add hud locators for any pawns that are currently spotted */
function PopulateSpottedEnemyLocators()
{
	local GearPawn GP;

	if (GetTeamNum() >= ArrayCount(GP.SpottedByTeam))
	{
		// We're a spectator
		return;
	}

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (GP.SpottedByTeam[GetTeamNum()] > 0 && GP.GetTeamNum() != GetTeamNum())
		{
			AddedSpottedEnemyLocator(GP);
		}
	}
}

/**
 * Mark a pickup spotted and set a timer to expire the spot
 *
 * @param SpottedPickup - the pickup that was spotted
 */
reliable server function ServerMarkPickupSpotted(Actor SpottedPickup)
{
	local GearPC GPC;
	local int SpotterTeamNum;
	local GearDroppedPickup DroppedPickup;
	local GearPickupFactory PickupFactory;
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);
	SpotterTeamNum = GetTeamNum();
	DroppedPickup = GearDroppedPickup(SpottedPickup);
	PickupFactory = GearPickupFactory(SpottedPickup);

	// Don't allow spotting of pickups if only 1 player is present
	if( !GRI.IsMultiplayerGame() && WorldInfo.Game.NumPlayers < 2 )
	{
		return;
	}

	// See if target is a valid pickup, and in correct state
	if (DroppedPickup != None)
	{
		if (!DroppedPickup.IsInState('Pickup'))
		{
			return;
		}
	}
	else if (PickupFactory != None)
	{
		if (!PickupFactory.IsInState('Pickup'))
		{
			return;
		}
	}
	else
	{
		return;
	}

	if (LastSpotTime >= 0)
	{
		if (GearGame(WorldInfo.Game).SpotChangeDelay <= 0 || `TimeSince(LastSpotTime) < GearGame(WorldInfo.Game).SpotChangeDelay)
		{
			// Not ready to respot
			return;
		}
		CancelCurrentSpot();
	}

	if (GRI != None && GRI.FindPRISpottingPickup(SpottedPickup, SpotterTeamNum) == None)
	{
		GearPRI(PlayerReplicationInfo).SpottedPickup =SpottedPickup;
		LastSpotTime = WorldInfo.TimeSeconds;
		SetTimer(GearGame(WorldInfo.Game).SpotLength, false, 'AllowPickupSpotting');

		// the server doesn't get a repnotify, add the hud locators here
		foreach LocalPlayerControllers(class'GearPC', GPC)
		{
			if (GetTeamNum() == GPC.GetTeamNum())
			{
				GPC.AddedSpottedPickupLocator(SpottedPickup);
			}
		}
	}
}

/** Let ServerMarkPickupSpotted succeed again */
function AllowPickupSpotting()
{
	LastSpotTime = -1.f;
	GearPRI(PlayerReplicationInfo).SpottedPickup = None;
}

/**
 * Add hud locator for a spotted pickup
 *
 * @param SpottedPickup - the pawn that was spotted
 */
function AddedSpottedPickupLocator(Actor SpottedPickup)
{
	MyGearHud.AddHUDLocator(class'GearHUDLocator_SpottedPickup', SpottedPickup);
}

/** Add hud locators for any pickups that are currently spotted */
function PopulateSpottedPickupLocators()
{
	local GearGRI GRI;
	local int i;
	local GearPRI GPRI;

	GRI = GearGRI(WorldInfo.GRI);

	if (GRI != None)
	{
		for (i = 0; i < GRI.PRIArray.Length; i++)
		{
			GPRI = GearPRI(GRI.PRIArray[i]);
			if (GPRI.GetTeamNum() == GetTeamNum() && GPRI.SpottedPickup != None)
			{
				AddedSpottedPickupLocator(GPRI.SpottedPickup);
			}
		}
	}
}

event PlayerTick(float DeltaTime)
{
	local CovPosInfo	FoundCovInfo;
	local vector		CheckDir, CamLoc;
	local rotator		CamRot;
	local GearPawn		GP;
	local Name			DesiredSoundMode;
	local GearFortification Fort;
	local float Dist, BestDist;


//  local vector hitLoc, hitNorm;
// 	local array<ReachSpec> ReachPoints;
// 	local vector CheckExtent;
// 	local int NavIdx;
// 	local ReachSpec CurrReach;
// 	local vector ClosestPoint;

/*
	// MT->DEBUG DEBUG DEBUG DEBUG
	if(!NavigationHandle.LineCheck(Pawn.Location+Vector(Pawn.Rotation)*200.f,Pawn.Location+Vector(Pawn.Rotation)*200.f+vect(0,0,-300),vect(0,0,0),hitLoc,hitNorm))
	{
		DrawDebugLine(hitLoc, hitLoc+hitNorm*50.0f,255,0,0);
	}

	if(!NavigationHandle.LineCheck(Pawn.Location+Vector(Pawn.Rotation)*200.f,Pawn.Location+Vector(Pawn.Rotation)*200.f+vect(0,0,-300),vect(10,10,10),hitLoc,hitNorm))
	{
		DrawDebugLine(hitLoc, hitLoc+hitNorm*50.0f,255,255,0);
	}

	if(!NavigationHandle.ObstacleLineCheck(Pawn.Location,Pawn.Location+vector(Pawn.Rotation)*10024.f,vect(10,10,10),hitLoc,hitNorm))
	{
		DrawDebugLine(hitLoc, hitLoc+hitNorm*50.0f,255,0,255);
	}

	if(!NavigationHandle.ObstacleLineCheck(Pawn.Location,Pawn.Location+vector(Pawn.Rotation)*10024.f,vect(0,0,0),hitLoc,hitNorm))
	{
		DrawDebugLine(hitLoc, hitLoc+hitNorm*50.0f,0,0,255);
	}
*/

	// if we were looking at a POI that got deleted (streamed out), stop it
	if ( bLookingAtPointOfInterest && (GetCameraFocusActor() == None) )
	{
		StopForceLookAtPointOfInterest(false);
	}

	// make sure to update isincombat, as this will revive any teammates that are dnbo
	// when combat is over
	IsInCombat();

	// Update Targeting Mode state
	// note: doing this early in the tick, since later code depends
	// on this being set properly (don't want 1-frame delays in stuff)
	UpdateTargetingStatus();

	ModifyFortification = None;
	if (MyGearPawn != None && MyGearPawn.Health > 0)
	{
		MyGearPawn.UpdateLambentDamageEffects();

		// cheat prevention - if they somehow evade the checks and get a shield + two handed weapon, kill them
		MyGearPawn.CheckShieldCheat();

		if ( GearGRI_Horde(WorldInfo.GRI) != None && GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications && GetTeamNum() == 0 &&
			GearPawnRidable_Base(MyGearPawn) == None && !MyGearPawn.IsAKidnapper() && !MyGearPawn.IsInCover() )
		{
			BestDist = 1000000.0;
			foreach MyGearPawn.CollidingActors(class'GearFortification', Fort, FortificationModifyRadius,, true)
			{
				if (NoZDot(vector(Pawn.Rotation), Normal(Fort.Location - Pawn.Location)) > 0.0)
				{
					Dist = VSize(Fort.Location - Pawn.Location);
					if (Dist < BestDist)
					{
						ModifyFortification = Fort;
						BestDist = Dist;
					}
				}
			}
		}
		// try to slide into cover when doing roadie run
		//@fixme - move this out of this tick and into GSM_RoadieRun
		if ( !bUseAlternateControls && MyGearPawn.bCanUseCover && IsDoingSpecialMove(SM_RoadieRun) && !MyGearPawn.IsCarryingShield() &&
			// delay is primarily for mantles so you don't get sucked into the cover you just mantled over when chaining
			(MyGearPawn.PreviousSpecialMove == SM_None || WorldInfo.TimeSeconds - MyGearPawn.PreviousSpecialMoveTime > 0.4) )
		{
			// Try to find cover to run to
			MyGearPawn.CoverAcquireFOV = MyGearPawn.RoadieRunCoverAcquireFOV;
			// if the stick is dramatically pushed then use that value for the check direction
			if (PlayerInput.RawJoyUp > DeadZoneThreshold || abs(PlayerInput.RawJoyRight) > DeadZoneThreshold)
			{
				GetPlayerViewPoint(CamLoc,CamRot);
				CheckDir.X = PlayerInput.RawJoyUp;
				CheckDir.Y = PlayerInput.RawJoyRight;
				CheckDir = Normal(CheckDir >> CamRot);
			}
			else
			{
				// otherwise default to the old style of player direction
				CheckDir = vector(Pawn.Rotation);
			}
			// if the check direction is relatively forward, then do the check for cover
			if( (CheckDir dot vector(Pawn.Rotation)) > 0.6 && MyGearPawn.CanPrepareRun2Cover(MyGearPawn.RoadieRun2CoverSlideDist, FoundCovInfo, CheckDir, MyGearPawn.PawnAcquireCoverFOVRoadieRun) )
			{
				TransitionFromRoadieRunToCover( FoundCovInfo );
			}
			MyGearPawn.CoverAcquireFOV = MyGearPawn.default.CoverAcquireFOV;
		}

		UpdateHUDActions(DeltaTime);

		// FIXME - this will only happen for local player on server and never on dedicated (playertick event only called for local player controller)
		if (Role == Role_Authority)
		{
			if (bCinematicMode)
			{
				MainPlayerInput.LastInputTime = WorldInfo.TimeSeconds;
			}
			else
			{
				if ( !MyGearPawn.bHidden && ((WorldInfo.TimeSeconds - MainPlayerInput.LastInputTime) > 60.f) && !IsActuallyPlayingCoop())
				{
					// throw guds event
					if (WorldInfo.Game != None)
					{
						GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_PlayerHasntMoved, MyGearPawn);
					}

					// don't throw again for awhile.
					MainPlayerInput.LastInputTime = WorldInfo.TimeSeconds;
				}
			}
		}
	}
	else
	{
		if ( Turret(Pawn) != None )
		{
			UpdateHUDActions(DeltaTime);
		}
	}

	DesiredSoundMode = FindBestSoundMode();
	if (DesiredSoundMode != CurrentSoundMode)
	{
		SetSoundMode(DesiredSoundMode);
	}

	Super.PlayerTick(DeltaTime);

	MaintainEnemyList();

	// Checks to see if the profile settings should update the player settings
	CheckForProfileUpdate();

	// do the RIMShader FOV checking here.  We need to do this for all cases
	if (WorldInfo.GRI != None && WorldInfo.GRI.IsMultiplayerGame())
	{
		// Each tick we have to update the FOV information for the material
		ForEach WorldInfo.AllPawns(class'GearPawn', GP)
		{
			if( GP.MPRimShader != None )
			{
				if( !IsSpectating() && !GP.bTearOff && !GP.IsAHostage() )
				{
					// if we are a wingman game we need to colorize everyone except our buddy
					if( ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameWingman_Base') )
					{
						if( WorldInfo.GRI.OnSameTeam(Pawn, GP) )
						{
							GP.MPRimShader.SetScalarParameterValue( 'LODDistanceFactor', 0 );
						}
						// we need to set to 0 here as the default value in the material is 1.0f
						else
						{
							GP.MPRimShader.SetScalarParameterValue( 'LODDistanceFactor', LODDistanceFactor );
						}
					}
					// else if we are not a wingman game then we colorize everyone
					else
					{
						GP.MPRimShader.SetScalarParameterValue( 'LODDistanceFactor', LODDistanceFactor );
					}

				}
				// if we are spectating then set the LODDistanceFactory on the RimShader to be 0 so we will have no rim shader at all
				else
				{
					GP.MPRimShader.SetScalarParameterValue( 'LODDistanceFactor', 0 );
				}
			}
		}
	}
}

/** Checks to see if the profile settings should update the player settings */
function CheckForProfileUpdate()
{
	// See if we need to update the game because of the profile setting being updated
	if ( bProfileSettingsUpdated && ProfileSettings != None && (ProfileSettings.ProfileSettings.length) > 0 && (GearPRI(PlayerReplicationInfo) != None) && (GearGRI(WorldInfo.GRI) != None) )
	{
		UpdateLocalCacheOfProfileSettings();
		bProfileSettingsUpdated = FALSE;
	}
}

/************************************************************************
	PROFILE/ONLINE FUNCTIONS
 ************************************************************************/
/** Registers a delegate so we get a callback when the player changes anything related to live. */
function RegisterOnlineDelegates()
{
	local OnlinePlayerInterface PlayerInterface;
	local LocalPlayer LocPlayer;

	Super.RegisterOnlineDelegates();

	LocPlayer = LocalPlayer(Player);

	// Figure out if we are a local player and have an online subsystem registered
	if (LocPlayer != None && OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Set the login delegate for the player
			PlayerInterface.AddLoginStatusChangeDelegate(OnLoginStatusChange,LocPlayer.ControllerId);
			PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
			PlayerInterface.AddLoginCancelledDelegate(OnLoginCancelled);
			PlayerInterface.AddReadProfileSettingsCompleteDelegate(LocPlayer.ControllerId,OnProfileReadComplete);
			PlayerInterface.AddReadPlayerStorageCompleteDelegate(LocPlayer.ControllerID,OnPersistentDataReadComplete);
		}

		if (OnlineSub.SystemInterface != None)
		{
			// Set the system wide connection changed callback
			OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
		}
	}
}

/** Clears the online delegates for this PC. */
function ClearOnlineDelegates()
{
	local OnlinePlayerInterface PlayerInterface;
	local LocalPlayer LocPlayer;

	Super.ClearOnlineDelegates();

	LocPlayer = LocalPlayer(Player);

	// Figure out if we are a local player and have an online subsystem registered
	if (LocPlayer != None && OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Clear our delegate
			PlayerInterface.ClearLoginStatusChangeDelegate(OnLoginStatusChange,LocPlayer.ControllerId);
			PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
			PlayerInterface.ClearLoginCancelledDelegate(OnLoginCancelled);
			PlayerInterface.ClearReadProfileSettingsCompleteDelegate(LocPlayer.ControllerId,OnProfileReadComplete);
			PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocPlayer.ControllerId,OnPersistentDataReadComplete);
		}

		if (OnlineSub.SystemInterface != None)
		{
			// Set the system wide connection changed callback
			OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
		}
	}
}

/** Returns whether we are on the title screen of the front end or not */
function bool IsOnTitleScreen()
{
	local GearMenuHUD MenuHUD;

	// See if we are on the title screen and
	MenuHUD = GearMenuHUD(myHUD);
	return (MenuHUD != None &&
			MenuHUD.FrontEndMovie != None &&
			MenuHUD.FrontEndMovie.bOnTitleScreen);
}

/**
 * Delegate called when a player's status changes but doesn't (shouldn't) change profiles
 *
 * @param NewStatus the new login status for the user
 * @param NewId the new id to associate with the user
 */
function OnLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId);

/**
 * Called when a system level connection change notification occurs. If we are
 * playing a Live match, we may need to notify and go back to the menu. Otherwise
 * silently ignore this.
 *
 * @param ConnectionStatus the
 */
function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
	local OnlineGameSettings GameSettings;
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local GearGRI_MP GRIMP;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	// We need to always bail in this case
	if (ConnectionStatus == OSCS_DuplicateLoginDetected)
	{
		ButtonAliases.AddItem('GenericAccept');

		UIManager.ShowUIMessage('ConfirmNetworkLost',
			Localize("MessageBoxErrorStrings","DuplicateSignin_Title","GearGameUI"),
			Localize("MessageBoxErrorStrings","DuplicateSignin_Message","GearGameUI"),
			ButtonAliases, None, LocalPlayer(Player),,,,,false);
		ReturnToMainMenu(true);
	}
	else if ( !IsCoop() )
	{
		// We know we have an online subsystem or this delegate wouldn't be called
		// Check the party session, because a Game session isn't always created
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Party');
		if (GameSettings != None || WorldInfo.NetMode == NM_Standalone)
		{
			// If we are a Live match, this really matters
			if ((GameSettings != None && !GameSettings.bIsLanMatch) ||
				(WorldInfo.NetMode == NM_Standalone && !IsSplitscreenPlayer() && !WorldInfo.bIsMenuLevel))
			{
				GRIMP = GearGRI_MP(WorldInfo.GRI);
				// Make sure this isn't Training Grounds
				if (GRIMP == None ||
					GRIMP.TrainingGroundsID < 0)
				{
					// We are playing a Live match. Determine whether the connection
					// status change requires us to drop and go to the menu
					switch (ConnectionStatus)
					{
						case OSCS_ConnectionDropped:
						case OSCS_NoNetworkConnection:
						case OSCS_ServiceUnavailable:
						case OSCS_UpdateRequired:
						case OSCS_ServersTooBusy:
							ButtonAliases.AddItem('GenericAccept');
							UIManager.ShowUIMessage('ConfirmNetworkLost',
								Localize("MessageBoxErrorStrings","XboxLive_Title","GearGameUI"),
								Localize("MessageBoxErrorStrings","LostLiveConnection_Message","GearGameUI"),
								ButtonAliases, None, LocalPlayer(Player),,,,,false);
							ReturnToMainMenu(true);
							break;
					}
				}
			}
		}
	}
}

/**
 * Displays a message when the physical network is lost during a networked game
 *
 * @param bIsConnected the new connection state
 */
function OnLinkStatusChange(bool bIsConnected);

/**
 * total hack - returns false in horde so that we don't pause the game in horde when the host's gamepad is disconnected
 */
function bool AllowPauseForControllerRemovalHack()
{
	return true;
}

/**
 * Displays the pause menu when the controller becomes disconnected
 *
 * @param ControllerId the controller id that was disconnected
 * @param bIsConnected whether the controller was removed or inserted
 */
function OnControllerChanged(int ControllerId,bool bIsConnected)
{
	local LocalPlayer LP/*, OtherPlayer*/;
	local bool bIsTraveling, bMenuLevel, bOpenPauseMenu, bApplyPostProcess;
	local OnlinePlayerInterface PlayerInterface;
	local byte PlayerID;
	local int /*PlayerIndex, */NumPlayers;
	local string ActiveMovieName;

	LP = LocalPlayer(Player);
	if ( LP != None && WorldInfo.IsConsoleBuild()
	// do not pause if there is no controller when we are automatedperftesting
	&&	(WorldInfo.Game == None || !WorldInfo.Game.IsAutomatedPerfTesting()))
	{
		PlayerID = LP.ControllerId;
		if ( PlayerID == ControllerId )
		{
			// Update our local state of the controller, used for the unpause delegate.
			bIsControllerConnected = bIsConnected;

			`log("Received gamepad connection change for player" @ class'UIInteraction'.static.GetPlayerIndex(ControllerId) $ ": gamepad" @ ControllerId @ "is now" @ (bIsConnected ? "connected" : "disconnected"));

			bMenuLevel = class'WorldInfo'.static.IsMenuLevel();

			// Figure out if we have an online subsystem registered
			if (OnlineSub != None)
			{
				// Grab the player interface to verify the subsystem supports it
				PlayerInterface = OnlineSub.PlayerInterface;
				if (PlayerInterface != None)
				{
					// Don't pause if we are getting ready to travel or playing a movie
					GetCurrentMovie(ActiveMovieName);
					bIsTraveling = GameEngine(LP.Outer).TravelURL != "" || ActiveMovieName ~= class'GameTypes'.const.LOADING_MOVIE;

					// if the gamepad was disconnected and we aren't travelling
					if ( !bIsTraveling && !bIsConnected )
					{
						bApplyPostProcess = !bMenuLevel;
						if ( WorldInfo.Game != None )
						{
							NumPlayers = GearGame(WorldInfo.Game).GetHumanPlayerCount();
							if ( NumPlayers == class'UIInteraction'.static.GetPlayerCount() || GearGRI(WorldInfo.GRI).bIsCoop )
							{
								bOpenPauseMenu = AllowPauseForControllerRemovalHack();
							}
							else
							{
								// we have one or more players connected to our machine - can't pause
							}
						}
						else
						{
							// we're a client - no pausing.
						}
					}
				}
			}

			if ( bOpenPauseMenu )
			{
				PauseGame(CanUnpauseControllerConnected);
			}
			else if ( bApplyPostProcess )
			{
				LP.OverridePostProcessSettings( PausePPSettings );
			}
			else if ( bIsConnected )
			{
				if ( bMenuLevel )
				{
					SetPause(false);
				}
				else if ((MyGearHUD == None || MyGearHUD.UI_PauseSceneInstance == None))
				{
					LP.ClearPostProcessSettingsOverride();

					// might have to start another post process
					CheckForPostProcessReset( Self );
				}
			}
		}
	}
}

/** Callback for when the player's profile is finished loading. */
function OnProfileReadComplete(byte LocalUserNum,bool bWasSuccessful)
{
	ProfileSettings = GearProfileSettings(OnlinePlayerData.ProfileProvider.Profile);

	bHasSigninChanged = false;
	// Update local profile cache next tick
	bProfileSettingsUpdated = TRUE;

	if ( WorldInfo.GRI == None || GearGRI(WorldInfo.GRI).IsMultiPlayerGame() )
	{
		SetShowSubtitles( FALSE );
	}

	// Check for whether we've posted to MCP yet or not
	if (bWasSuccessful && ProfileSettings != None)
	{
		CheckViralAchievement();
		ClientGetPlayerSkill();

		//If the main menu is open, update the bangs
		if (myHUD != none &&
			GearMenuHUD(myHUD).FrontEndMovie != none &&
			GearMenuHUD(myHUD).FrontEndMovie.MainMenuMovie != none)
		{
			GearMenuHUD(myHUD).FrontEndMovie.MainMenuMovie.UpdateMenuFromProfile();
		}
	}
}

/** Seed viral achievement (only Epic employees should get this achievement this way) */
simulated function CheckViralAchievement()
{
	if (ProfileSettings != None &&
		PersistentData != None &&
		AwardManager != None &&
		ProfileSettings.IsEpicDev() && !AwardManager.HasEarnedAwardByName('EPIC'))
	{
		AwardManager.AwardEarned(AwardManager.GetAwardByName('EPIC'));

		// @ACHIEVEMENT - Rustlung (viral)
		ClientUnlockAchievement(eGA_RUSTLUNG);
	}
}

/** Callback for when the player's persistent data has finished loading.
 *	@param LocalUserNum		The user whose player storage persistent data has finished loading
 *	@param bWasSuccessful	Whether or not the read was successful
 */
function OnPersistentDataReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
	PersistentData = GearPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
	bHasPersistentData = false;
	//If you don't have an stat manager..make one
	if (StatManager == None || AwardManager == None)
	{
		CreateStatAndAwardManager();
	}
	//Update any data necessary
	if (bWasSuccessful)
	{
		StatManager.ReadFromPersistentData();
		StatManager.UpdateLevelFromXP(false);
		StatManager.PrevXP = StatManager.GetStatValueByName('XP');

		InitFortificationUpgradeLevels();
		// Update the PRI with the proper level information
		ClientGetPlayerLevel();
		CheckViralAchievement();

		//If the main menu is open, update the bangs
		if (myHUD != none &&
			GearMenuHUD(myHUD).FrontEndMovie != none &&
			GearMenuHUD(myHUD).FrontEndMovie.MainMenuMovie != none)
		{
			GearMenuHUD(myHUD).FrontEndMovie.MainMenuMovie.UpdateMenuFromProfile();
		}
	}
}

/** Callback for when ANY player changes their currently signed in gamer tag */
function OnLoginChange(byte LocalUserNum)
{
	local LocalPlayer LP;
	local UniqueNetId NetId;
	local string Gamertag;

	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		LP = LocalPlayer(Player);
		if (LP != None &&
			LP.ControllerId == LocalUserNum)
		{
			// Get our local id from the online subsystem
			OnlineSub.PlayerInterface.GetUniquePlayerId(LP.ControllerId,NetId);
			// Set the new id on the player
			PlayerReplicationInfo.SetUniqueId(NetId);
			// Read the gamertag for this player and change our name to it
			Gamertag = OnlineSub.PlayerInterface.GetPlayerNickname(LP.ControllerId);
			if (Gamertag != "")
			{
				PlayerReplicationInfo.SetPlayerName(Gamertag);
			}
			// give default if none specified (no profile, etc)
			else if (PlayerReplicationInfo.PlayerName == PlayerReplicationInfo.default.PlayerName)
			{
				PlayerReplicationInfo.SetPlayerName(class'GearGame'.default.DefaultPlayerName@(LP.ControllerId + 1));
			}
		}

		// If the use is not logged in, we need to call the read delegates for the profile and the playerstorage
		if (OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum) == LS_NotLoggedIn)
		{
			OnPersistentDataReadComplete(LocalUserNum, true);
			OnProfileReadComplete(LocalUserNum, true);
			// Any time we're a client and we sign out we need to travel back to the menu
			if (WorldInfo.NetMode == NM_Client)
			{
				ShowLoginChangeError();
				ReturnToMainMenu(true);
			}
		}
		else
		{
			// Let each subclass process a new sign in
			OnNewLogin();
		}
	}
}

/**
 * Called when a new player signs in so each subclass can determine the proper course of action
 */
function OnNewLogin()
{
	ShowLoginChangeError();
}

/** Displays a message to the user that a login change is not allowed */
final function ShowLoginChangeError()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	// Show the user why we kicked them back
	if (UIManager != None)
	{
		ButtonAliases.AddItem('GenericAccept');
		UIManager.ShowUIMessage('ConnectionError',
			Localize("MessageBoxErrorStrings","IllegalSigninChange_Title","GearGameUI"),
			Localize("MessageBoxErrorStrings","IllegalSigninChange_Message","GearGameUI"),
			ButtonAliases,
			None,
			LocalPlayer(Player),,,,,false);
	}
}

/**
 * Callback for when a player cancels their login
 */
function OnLoginCancelled()
{
}

/**
 * Cancel any JIP game reservation started by a game invite
 * and eventually destroy the PendingJIPClientReservationBeacon.
 */
function CancelJIPGameReservation()
{
	`LogBeacon("Destroying JIP client beacon.");

	// Cleanup the JIP reservation beacon
	if (PendingJIPClientReservationBeacon != None)
	{
		PendingJIPClientReservationBeacon.OnReservationRequestComplete = None;

		// No longer need the beacon
		PendingJIPClientReservationBeacon.DestroyBeacon();
		PendingJIPClientReservationBeacon = None;
	}

	// Also remove the pending JIP game
	PendingJIPGameSearch = None;
}

/**
 * Cancel any persistent party reservation that was created on the party host for an invite
 * and eventually destroy the ClientPersistentPartyBeacon.
 *
 * Also cancels a JIP game reservation beacon if it was started.
 *
 * @param InviteErrorType type of error that occured during invite handling
 */
function CancelPersistentPartyReservation(EInviteAcceptanceError InviteErrorType)
{
	`LogBeacon("Destroying persistent party client beacon.");

	// Cleanup the persistent party beacon
	if (ClientPersistentPartyBeacon != None)
	{
		// No longer need the beacon
		ClientPersistentPartyBeacon.DestroyBeacon();
		ClientPersistentPartyBeacon = None;
	}
	// Also cancel the JIP game reservation that was started by the invite
	CancelJIPGameReservation();

	// Display error to user
	switch (InviteErrorType)
	{
		case eInviteError_NotAllPlayersCanJoinInvite:
			NotifyNotAllPlayersCanJoinInvite();
			break;
		case eInviteError_NotEnoughSpaceInPartyInvite:
			NotifyNotEnoughSpaceInPartyInvite();
			break;
		case eInviteError_NotEnoughSpaceInGameToJoin:
			NotifyNotEnoughSpaceInGameInvite();
			break;
		case eInviteError_GameJIPFailedMissingDLC:
			NotifyMissingContentForInvite();
			break;
		case eInviteError_GameJIPFailed:
		case eInviteError_DefaultError:
		default:
			NotifyInviteFailed();
			break;
	}
}

/**
 * Allow time for the client party beacon to destroy/unregister so that we can reuse the secure key to join
 */
function OnDestroyClientBeacon_JoinReservedPersistentPartySession()
{
	ClientPersistentPartyBeacon = None;
	// Join the party session
	JoinReservedPersistentPartySession();
}

/**
 * Delegate called once we join the new game session.
 * If the JIP game join was successful then we can also join the party session as well.
 *
 * @param SessionName the name of the session that was joined
 * @param bWasSuccessful whether the end completed properly or not
 */
function OnJIPGameSessionJoinComplete(name SessionName,bool bWasSuccessful)
{
	`LogOnline("Finished joining"
		$" SessionName="$SessionName
		$" bWasSuccessful="$bWasSuccessful);

	// Clear the join delegate
	OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJIPGameSessionJoinComplete);
	if (bWasSuccessful)
	{
		// if successfully joined the JIP game from the party host
		// then no longer need the party beacon since it was only kept around to cancel party reservation on failure
		if (ClientPersistentPartyBeacon != None)
		{
			ClientPersistentPartyBeacon.OnDestroyComplete = OnDestroyClientBeacon_JoinReservedPersistentPartySession;
			ClientPersistentPartyBeacon.DestroyBeacon();
		}
		else
		{
			// Join the party session
			JoinReservedPersistentPartySession();
		}
	}
	else
	{
		// if failed to join the JIP game returned by the party host
		// then cancel the party reservation as well
		CancelPersistentPartyReservation(eInviteError_GameJIPFailed);
	}
}

/**
 * Delegate called once the game session has been destroyed.
 * Joins the new pending JIP session from the PendingJIPGameSearch set by an invite.
 *
 * @param SessionName the name of the session that was destroyed
 * @param bWasSuccessful whether the destroy completed properly or not
 */
function OnDestroyGameForJIPGameSessionComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineGameSearchResult JIPSessionToJoin;

	`LogOnline("Finished destroy. Starting join of"
		$" SessionName="$SessionName);

	// Clear the destroy delegate
	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameForJIPGameSessionComplete);

	// join the pending game
	if (PendingJIPGameSearch != None &&
		PendingJIPGameSearch.Results.Length > 0)
	{
		// Get the pending JIP game session info so we can join it
		JIPSessionToJoin = PendingJIPGameSearch.Results[0];
		// Set the delegate for notification of the join completing
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJIPGameSessionJoinComplete);
		// This will have us join the pending JIP game session
		OnlineSub.GameInterface.JoinOnlineGame(LocalPlayer(Player).ControllerId,SessionName,JIPSessionToJoin);
	}
	else
	{
		`LogOnline("Missing pending JIP game search results.");
		// Missing pending game JIP session, so have to cancel the invite request
		CancelPersistentPartyReservation(eInviteError_DefaultError);
	}
}

/**
 * Delegate called once the game session has ended.
 *
 * @param SessionName the name of the session that was ended
 * @param bWasSuccessful whether the end completed properly or not
 */
function OnEndGameForJIPGameSessionComplete(name SessionName,bool bWasSuccessful)
{
	`LogOnline("Finished ending"
		$" SessionName="$SessionName);

	// Clear the end delegate
	OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndGameForJIPGameSessionComplete);
	// Set the destroy delegate so we can know when that is complete
	OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameForJIPGameSessionComplete);
	// Now we can destroy the game
	OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
}

/**
 * Ends the existing game session so that we can join.
 * assumes already have a reservation on the game session or a reservation wasn't required.
 */
function JoinReservedJIPGameSession()
{
	local OnlineGameSettings GameSettings;

	`LogOnline("Starting game cleanup for join... ");

	// destroying game session and losing secure keys so need to ignore network errors due to disconnect
	bIsReturningFromMatch = true;
	bIgnoreNetworkMessages = true;

	GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
	// End the current game session if it exists
	if (GameSettings != None)
	{
		// Write arbitration data, if required
		if (GameSettings.bUsesArbitration)
		{
			// Write out our version of the scoring before leaving
			ClientWriteOnlinePlayerScores(WorldInfo.GRI.GameClass != None ? WorldInfo.GRI.GameClass.default.ArbitratedLeaderBoardId : 0);
		}
		// Set the end delegate, where we'll destroy the game and then join
		OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndGameForJIPGameSessionComplete);
		// Force the flush of the stats
		OnlineSub.GameInterface.EndOnlineGame('Game');
	}
	else
	{
		// No game session active so handle as already destroyed
		OnDestroyGameForJIPGameSessionComplete('Game',true);
	}
}

/**
 * Create the client reservation beacon required for the given game search type.
 * If a game search type doesn't require a reservation beacon to join then return None.
 *
 * @param SearchClass the search type of the game we want to make a reservation on
 * @return new beacon corresponding to the game search type
 */
function PartyBeaconClient CreateGameClientReservationBeacon(class<OnlineGameSearch> SearchClass)
{
	local PartyBeaconClient JIPClientBeacon;

	`LogBeacon("Creating a game JIP client beacon"
		$" SearchClass="$SearchClass);

	// player match game sessions require a beacon reservation before a join is allowed
	if (SearchClass == class'GearPlayerVersusGameSearch')
	{
		JIPClientBeacon = new class'GearPlayerMatchBeaconClient';
		JIPClientBeacon.BeaconName = 'JIPGameClient';
	}
	// same for dedicated version of player match beacon
	else if (SearchClass == class'GearPlayerVersusGameSearchDedicated')
	{
		JIPClientBeacon = new class'GearPlayerMatchDedicatedBeaconClient';
		JIPClientBeacon.BeaconName = 'JIPGameDedicatedClient';
	}
	// coop match require a beacon reservation before a join is allowed
	else if (SearchClass == class'GearCoopGameSearch')
	{
		JIPClientBeacon = new class'GearPlayerMatchBeaconClient';
		JIPClientBeacon.BeaconName = 'JIPGameClient';
	}

	return JIPClientBeacon;
}

/**
 * Allow time for the client JIP beacon to destroy/unregister so that we can reuse the secure key to join
 */
function OnDestroyPendingJIPClientBeacon_JoinReservedJIPGameSession()
{
	PendingJIPClientReservationBeacon = None;
	// Join the game session
	JoinReservedJIPGameSession();
}

/**
 * Called by the JIP client beacon when a reservation request has been responded to by the game host
 *
 * @param ReservationResult whether there was space allocated for the party or not
 */
function OnJIPGameReservationUpdateRequestComplete(EPartyReservationResult ReservationResult)
{
	`LogBeacon("Game reservation request received"
		$" ReservationResult="$ReservationResult);

	if (ReservationResult == PRR_ReservationAccepted || ReservationResult == PRR_ReservationDuplicate)
	{
		// Reservation accepted so can join the game session
		if (PendingJIPClientReservationBeacon != None)
		{
			PendingJIPClientReservationBeacon.OnDestroyComplete = OnDestroyPendingJIPClientBeacon_JoinReservedJIPGameSession;
			PendingJIPClientReservationBeacon.DestroyBeacon();
		}
		else
		{
			JoinReservedJIPGameSession();
		}
	}
	else if (ReservationResult == PRR_PartyLimitReached ||
			 ReservationResult == PRR_IncorrectPlayerCount)
	{
		// cancel party reservation since the JIP reservation request on the game host failed
		CancelPersistentPartyReservation(eInviteError_NotEnoughSpaceInGameToJoin);
	}
	else
	{
		// cancel party reservation since the JIP reservation request on the game host failed
		CancelPersistentPartyReservation(eInviteError_GameJIPFailed);
	}
}

/**
 * Try to join the game session we have been invited to.
 * Uses the JIPClientReservationBeacon provided to update the reservation of an
 * existing party (party host's party) with the newly invited player.
 *
 * @param JIPClientReservationBeacon reservation beacon needed to join the game session
 * @return TRUE if a reservation request was successfully sent to the game host using the client beacon
 */
function bool RequestJIPGameSessionReservation(PartyBeaconClient JIPClientReservationBeacon)
{
	local GearPC PC;
	local LocalPlayer LocPlayer;
	local array<PlayerReservation> Party;
	local OnlineGameSearchResult JIPSessionToJoin;
	local PlayerReservation PlayerRes;
	local UniqueNetId PlayerId, ZeroId;
	local bool bResult;

	// final result
	bResult = false;

	// Cleanup the old pending JIP connection
	if (PendingJIPClientReservationBeacon != None)
	{
		PendingJIPClientReservationBeacon.DestroyBeacon();
	}

	// Maintain the game reservation beacon until we get a response from the game host
	// The persistent party beacon connection is also maintained in case we need to send a cancellation
	// to the party host on failure
	PendingJIPClientReservationBeacon = JIPClientReservationBeacon;

	if (PendingJIPClientReservationBeacon != None &&
		PendingJIPGameSearch != None &&
		PendingJIPGameSearch.Results.Length > 0 &&
		InvitePartyHostOwnerId != ZeroId)
	{
		// Get the pending JIP game session info so we can join it
		JIPSessionToJoin = PendingJIPGameSearch.Results[0];
		// Create a new reservation for all current players that can play online
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			LocPlayer = LocalPlayer(PC.Player);
			if (LocPlayer != None &&
				OnlineSub.PlayerInterface.GetUniquePlayerId(LocPlayer.ControllerId,PlayerId))
			{
				PlayerRes.NetId = PlayerId;
				// overriding player skill with XP level
				if (PC.PersistentData != None)
				{
					PlayerRes.XpLevel = PC.PersistentData.GetValue(`Level);
				}
				else
				{
					PlayerRes.XpLevel = 0;
				}
				//@todo sz - fill PlayerRes.Skill
				Party.AddItem(PlayerRes);
			}
		}
		// Update the existing reservation on the game host
		if (PendingJIPClientReservationBeacon.RequestReservationUpdate(JIPSessionToJoin,InvitePartyHostOwnerId,Party))
		{
			// successfully created the beacon for jip game reservation request
			bResult = true;
			// if no JIP game session then the party host will just send a reservation response
			PendingJIPClientReservationBeacon.OnReservationRequestComplete = OnJIPGameReservationUpdateRequestComplete;
		}
	}
	return bResult;
}

/**
 * Host persistent party beacon responded with a JIP game session that our party
 * needs to join since the party host is in an active game session.
 * Also implies that the reservation request was accepted by the party host
 * (ie. result of PRR_ReservationAccepted)
 *
 * A call to this delegate by the client beacon implies that there is a JIP game session
 * to join on when joining the party.
 *
 * Tries to join the game session that was returned either directly or after a JIP beacon reservation request.
 *
 * @param JIPResult extended results of the JIP response
 * @param SessionName the name of the session to register
 * @param SearchClass the search that should be populated with the session
 * @param GamePlaylistId current playlist id of the game session to join, -1 if not a public JIP match
 * @param PlatformSpecificInfo the binary data to place in the platform specific areas
 */
function OnPersistentPartyJIPGameSessionReceived(
	EGearPersistentPartyJIPResult JIPResult,
	name SessionName,
	class<OnlineGameSearch> SearchClass,
	int GamePlaylistId,
	int GamePlaylistMgrVer,
	byte PlatformSpecificInfo[80])
{
	local OnlineGameSettings GameSettings;
	local OnlineGameSearchResult JIPSessionToJoin;
	local PartyBeaconClient JIPClientReservationBeacon;
	local UniqueNetId ZeroId;
	local bool bHasRequiredDLC;
	local OnlinePlaylistManager PlaylistMan;

	`LogBeacon("Got JIP game session from party reservation request."
		$" SessionName="$SessionName
		$" SearchClass="$SearchClass
		$" PlaylistId="$GamePlaylistId
		$" PlaylistMgrVer="$GamePlaylistMgrVer
		$" JIPResult="$JIPResult);

	// Clear delegate references
	ClientPersistentPartyBeacon.OnJIPGameSessionReceived = None;
	ClientPersistentPartyBeacon.OnReservationRequestComplete = None;

	// Game search object contains information about the game session to join. Keep it around until we actually join the game
	PendingJIPGameSearch = new SearchClass;
	// Fill in the search with session info from platform specific results returned by the persistent party beacon
	if (OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(LocalPlayer(Player).ControllerId,PendingJIPGameSearch,PlatformSpecificInfo))
	{
		JIPSessionToJoin = PendingJIPGameSearch.Results[0];

		// ignore the JIP invite if we're already in the same game session
		GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
		if (GameSettings != None &&
			GameSettings.OwningPlayerId != ZeroId &&
			GameSettings.OwningPlayerId == JIPSessionToJoin.GameSettings.OwningPlayerId)
		{
			`LogOnline("Already in the game session. No need to join via invite. "
				$" OwningPlayerId="$OnlineSub.static.UniqueNetIdToString(JIPSessionToJoin.GameSettings.OwningPlayerId));

			// remove the reservation slot on the party host since we won't be joining
			CancelPersistentPartyReservation(eInviteError_DefaultError);
		}
		else
		{
			bHasRequiredDLC = true;
			if (GamePlaylistId >= 0)
			{
				bHasRequiredDLC = PlayerHasPlaylistDLC(GamePlaylistId);
			}
			if (GamePlaylistMgrVer >= 0)
			{
				PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
				if (PlaylistMan != None &&
					PlaylistMan.VersionNumber != GamePlaylistMgrVer)
				{
					bHasRequiredDLC = false;
				}
			}
			//@todo sz2 - check GamePlaylistMgrVer validity
			if (!bHasRequiredDLC)
			{
				`LogOnline("Dont have all the DLC for host. Can't join the invite. "
					$" OwningPlayerId="$OnlineSub.static.UniqueNetIdToString(JIPSessionToJoin.GameSettings.OwningPlayerId));

				// Failed invite due to missing DLC
				CancelPersistentPartyReservation(eInviteError_GameJIPFailedMissingDLC);
			}
			else
			{
				// Party host response says that the JIP game session needs a reservation in order to join the session
				if (JIPResult == GearPPJIP_GameReservationNeeded)
				{
					// Get the beacon to use based on the search class of the session
					JIPClientReservationBeacon = CreateGameClientReservationBeacon(SearchClass);
					if (JIPClientReservationBeacon != None)
					{
						`LogOnline("JIP reservation is required for invite.");

						// A reservation is required on the beacon of the JIP game session before we can join it
						// Note that the ClientPersistentPartyBeacon is maintaned while the JIP reservation is in flight
						// This is needed in case we need to cancel the persistent party reservation based on the JIP reservation
						if (!RequestJIPGameSessionReservation(JIPClientReservationBeacon))
						{
							// Failed to start the required reservation beacon, so fail the party reservation as well
							CancelPersistentPartyReservation(eInviteError_GameJIPFailed);
						}
					}
					else
					{
						// Failed to create the required reservation beacon, so fail the party reservation as well
						CancelPersistentPartyReservation(eInviteError_GameJIPFailed);
					}
				}
				else if (JIPResult == GearPPJIP_GameReservationNotRequired ||
					JIPResult == GearPPJIP_GameReservationAccepted)
				{
					`LogOnline("No JIP reservation is required. Just joining.");

					// No beacon reservation required so just join the game session directly
					if (ClientPersistentPartyBeacon != None)
					{
						ClientPersistentPartyBeacon.OnDestroyComplete = OnDestroyClientBeacon_JoinReservedJIPGameSession;
						ClientPersistentPartyBeacon.DestroyBeacon();
					}
					else
					{
						// Join the game session
						JoinReservedJIPGameSession();
					}
				}
				// GearPPJIP_GameReservationFailed implied
				else
				{
					// Failed the JIP request on the party host , so fail the party reservation as well
					CancelPersistentPartyReservation(eInviteError_GameJIPFailed);
				}
			}
		}
	}
	else
	{
		`LogOnline("BindPlatformSpecificSessionToSearch failed.");

		// remove the reservation slot on the party host since we won't be joining
		CancelPersistentPartyReservation(eInviteError_DefaultError);
	}
}

/**
 * Allow time for the client JIP beacon to destroy/unregister so that we can reuse the secure key to join
 */
function OnDestroyClientBeacon_JoinReservedJIPGameSession()
{
	ClientPersistentPartyBeacon = None;
	// Join the game session
	JoinReservedJIPGameSession();
}

/**
 * Called by the beacon when a reservation request has been responded to by the destination host.
 * Determines if the reservation on the party host succeeded or not.
 *
 * A call to this delegate by the client beacon implies that there was no JIP game session
 * to join on the party host.
 *
 * @param ReservationResult whether there was space allocated for the party or not
 */
function OnPersistentPartyReservationRequestComplete(EPartyReservationResult ReservationResult)
{
 	`LogBeacon("Party reservation responce received"
		$" ReservationResult="$ReservationResult);

	if (ReservationResult == PRR_ReservationAccepted)
	{
		// There was no game session to join so just destroy the beacon and cleanup its secure socket
		if (ClientPersistentPartyBeacon != None)
		{
			ClientPersistentPartyBeacon.OnDestroyComplete = OnDestroyClientBeacon_JoinReservedPersistentPartySession;
			ClientPersistentPartyBeacon.DestroyBeacon();
		}
		else
		{
			// Join the party session
			JoinReservedPersistentPartySession();
		}
	}
	else
	{
		if (ClientPersistentPartyBeacon != None)
		{
			ClientPersistentPartyBeacon.DestroyBeacon();
			ClientPersistentPartyBeacon = None;
		}

		if (ReservationResult == PRR_PartyLimitReached ||
			ReservationResult == PRR_IncorrectPlayerCount)
		{
			// Display an error message. Host party is full
			NotifyNotEnoughSpaceInPartyInvite();
		}
		else
		{
			// Display an error message. Timeout or other error
			NotifyInviteFailed();
		}
	}
}

/**
 * Try to join the session we have been invited to. Creates a persistent party
 * client beacon to connect to the party host session and request a reservation.
 *
 * @param SessionToJoin session that sent the invite that we want to try to join
 * @return TRUE if a reservation request was successfully sent to the party host using the client beacon
 */
function bool RequestPersistentPartyJoin(const out OnlineGameSearchResult SessionToJoin)
{
	local GearPC PC;
	local LocalPlayer LocPlayer;
	local array<PlayerReservation> Party;
	local PlayerReservation PlayerRes;
	local UniqueNetId PlayerId;
	local OnlineGameSettings PartySettings;
	local bool bResult;

	// Deep track of the party host player id
	InvitePartyHostOwnerId = SessionToJoin.GameSettings.OwningPlayerId;
	// Final result
	bResult = false;
	// Ignore invite if we're already in the party session
	PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
	if (PartySettings != None &&
		PartySettings.OwningPlayerId == SessionToJoin.GameSettings.OwningPlayerId)
	{
		`LogOnline("Already in the party session. no need to join via invite.");
	}
	else
	{
		LocPlayer = LocalPlayer(Player);
		if (LocPlayer != None)
		{
			`LogOnline("Attempting to reserve space in session owned by "
				$OnlineSub.static.UniqueNetIdToString(SessionToJoin.GameSettings.OwningPlayerId));

			// Clear out the previous invite if still in progress
			if (ClientPersistentPartyBeacon != None)
			{
				ClientPersistentPartyBeacon.DestroyBeacon();
			}
			// Use a client beacon to request a reservation on the party host
			ClientPersistentPartyBeacon = new class'GearPersistentPartyBeaconClient';
			ClientPersistentPartyBeacon.BeaconName = 'PersistentPartyClient';

			// New persistent party reservation consists of just a single player

			// Create a new reservation for all current players that can play online
			foreach LocalPlayerControllers(class'GearPC', PC)
			{
				LocPlayer = LocalPlayer(PC.Player);
				if (LocPlayer != None &&
					OnlineSub.PlayerInterface.GetUniquePlayerId(LocPlayer.ControllerId,PlayerId))
				{
					PlayerRes.NetId = PlayerId;
					// overriding player skill with XP level
					if (PC.PersistentData != None)
					{
						PlayerRes.XpLevel = PC.PersistentData.GetValue(`Level);
					}
					else
					{
						PlayerRes.XpLevel = 0;
					}
					//@todo sz - fill PlayerRes.Skill
					Party.AddItem(PlayerRes);
				}
			}
			// Trigger delegate when client join request has finished
			if (ClientPersistentPartyBeacon.RequestReservationUpdate(SessionToJoin,SessionToJoin.GameSettings.OwningPlayerId,Party))
			{
				// successfully created the persistent party beacon request
				bResult = true;
				// if the party host has an active JIP enabled game session, then it sends the game session to join
				ClientPersistentPartyBeacon.OnJIPGameSessionReceived = OnPersistentPartyJIPGameSessionReceived;
				// if no JIP game session then the party host will just send a reservation response
				ClientPersistentPartyBeacon.OnReservationRequestComplete = OnPersistentPartyReservationRequestComplete;
			}
		}
	}
	return bResult;
}

/** Display a message to the user */
function NotifyInviteFailed()
{
	ClientShowLoadingMovie(false);
	class'GearUIManager'.static.DisplayErrorMessage("InviteHandlingFailed_Message", "InviteHandlingFailed_Title", "GenericAccept");
}

/** Display a message to the user */
function NotifyNotAllPlayersCanJoinInvite()
{
	ClientShowLoadingMovie(false);
	class'GearUIManager'.static.DisplayErrorMessage("NotAllPlayersCanJoin_Message", "InviteHandlingFailed_Title", "GenericAccept");
}

/** Display a message to the user */
function NotifyNotEnoughSpaceInInvite()
{
	ClientShowLoadingMovie(false);
	class'GearUIManager'.static.DisplayErrorMessage("NotEnoughSpaceToJoin_Message", "InviteHandlingFailed_Title", "GenericAccept");
}

/** Display a message to the user */
function NotifyNotEnoughSpaceInPartyInvite()
{
	ClientShowLoadingMovie(false);
	class'GearUIManager'.static.DisplayErrorMessage("NotEnoughSpaceInPartyToJoin_Message", "InviteHandlingFailed_Title", "GenericAccept");
}

/** Display a message to the user */
function NotifyNotEnoughSpaceInGameInvite()
{
	ClientShowLoadingMovie(false);
	class'GearUIManager'.static.DisplayErrorMessage("NotEnoughSpaceInGameToJoin_Message", "InviteHandlingFailed_Title", "GenericAccept");
}

/** Display a message to the user about missing content */
function NotifyMissingContentForInvite()
{
	ClientShowLoadingMovie(false);
	class'GearUIManager'.static.DisplayErrorMessage("DLCNeeded_Message", "InviteHandlingFailed_Title", "GenericAccept");
}

/**
 * Delegate called when the user accepts a game invite externally. This allows
 * the game code a chance to clean up before joining the game via
 * AcceptGameInvite() call.
 *
 * NOTE: There must be space for all signed in players to join the game. All
 * players must also have permission to play online too.
 *
 * Players will request a reservation on the party host using the persistent party client beacon.
 * If the party host is also in an active game session then a JIP request is also handled.
 *
 * @param InviteResult the search/settings for the game we're to join
 */
function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
	local GearUIManager UIManager;

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		//Nuke all popups if we are trying to accept an invite.
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		if (UIManager != None)
		{
			UIManager.CloseAllUIMessageBoxes();
		}
		if (InviteResult.GameSettings != None)
		{
			// Make sure the new game has space
			if (InviteHasEnoughSpace(InviteResult.GameSettings))
			{
				// Make sure everyone logged in can play online
				if (CanAllPlayersPlayOnline())
				{
					// Attempt to join the party host that sent the invite
					if (!RequestPersistentPartyJoin(InviteResult))
					{
						// Display an error message
						NotifyInviteFailed();
					}
				}
				else
				{
					// Display an error message
					NotifyNotAllPlayersCanJoinInvite();
				}
			}
			else
			{
				// Display an error message
				NotifyNotEnoughSpaceInInvite();
			}
		}
		else
		{
			// Display an error message
			NotifyInviteFailed();
		}
	}
}

/**
 * Validates that each local player can play online
 *
 * @return true if there is sufficient space, false if not
 */
function bool CanAllPlayersPlayOnline()
{
	local GearPC PC;
	local LocalPlayer LocPlayer;

	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		LocPlayer = LocalPlayer(PC.Player);
		if (LocPlayer != None)
		{
			// Check their login status and permissions
			if (OnlineSub.PlayerInterface.GetLoginStatus(LocPlayer.ControllerId) != LS_LoggedIn ||
				OnlineSub.PlayerInterface.CanPlayOnline(LocPlayer.ControllerId) == FPL_Disabled ||
				// Don't let them play if they are banned
				PC.ProfileSettings.IsProfileBanned())
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	return true;
}

/**
 * End any active 'Game' and 'Party' sessions that player is in and
 * then join the new session from the invite by accepting the game invite.
 */
function JoinReservedPersistentPartySession()
{
	local OnlineGameSettings GameSettings, PartySettings;

	`LogOnline("Destroying old party/game and joining new party...");

	// Cleanup the JIP reservation beacon
	if (PendingJIPClientReservationBeacon != None)
	{
		PendingJIPClientReservationBeacon.DestroyBeacon();
		PendingJIPClientReservationBeacon = None;
	}
	// Make sure the persistent party beacon has been cleaned up
	if (ClientPersistentPartyBeacon != None)
	{
		ClientPersistentPartyBeacon.OnDestroyComplete = OnDestroyClientBeacon_JoinReservedPersistentPartySession;
		ClientPersistentPartyBeacon.DestroyBeacon();
		return;
	}

	bIsReturningFromMatch = true;
	bIgnoreNetworkMessages = true;
	if (WorldInfo.NetMode != NM_Standalone)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None &&
			// Don't destroy the JIP game we just joined
			PendingJIPGameSearch == None)
		{
			// Write arbitration data, if required
			if (GameSettings.bUsesArbitration)
			{
				// Write out our version of the scoring before leaving
				ClientWriteOnlinePlayerScores(WorldInfo.GRI.GameClass != None ? WorldInfo.GRI.GameClass.default.ArbitratedLeaderBoardId : 0);
			}
			// Set the end delegate, where we'll destroy the game and then join
			OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndGameForInviteComplete);
			// Force the flush of the stats
			OnlineSub.GameInterface.EndOnlineGame('Game');
		}
		else
		{
			// Check for party and clean up
			PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
			if (PartySettings != None)
			{
				// Destroy the party and then accept the invite
				OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForInviteComplete);
				OnlineSub.GameInterface.DestroyOnlineGame('Party');
			}
			else
			{
				// Set the delegate for notification of the join completing
				OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
				// We can immediately accept since there is no online game
				if (!OnlineSub.GameInterface.AcceptGameInvite(LocalPlayer(Player).ControllerId,'Party'))
				{
					OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
				}
			}
		}
	}
	else
	{
		// Set the delegate for notification of the join completing
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);

		// We can immediately accept since there is no online game
		if (!OnlineSub.GameInterface.AcceptGameInvite(LocalPlayer(Player).ControllerId,'Party'))
		{
			OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		}
	}
	// pending JIP game session should have been joined by now, so no longer need this
	PendingJIPGameSearch = None;
}

/**
 * Delegate called once the destroy of an online game before accepting an invite
 * is complete. From here, the game invite can be accepted
 *
 * @param SessionName the name of the session that was ended
 * @param bWasSuccessful whether the end completed properly or not
 */
function OnEndGameForInviteComplete(name SessionName,bool bWasSuccessful)
{
	`LogOnline("Finished ending"
		$" SessionName="$SessionName);

	// Clear the end delegate
	OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndGameForInviteComplete);
	// Set the destroy delegate so we can know when that is complete
	OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameForInviteComplete);
	// Now we can destroy the game
	OnlineSub.GameInterface.DestroyOnlineGame('Game');
}

/**
 * Delegate called once the destroy of an online game before accepting an invite
 * is complete. From here, the game invite can be accepted
 *
 * @param SessionName the name of the session that was destroyed
 * @param bWasSuccessful whether the destroy completed properly or not
 */
function OnDestroyGameForInviteComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineGameSettings PartySettings;

	`LogOnline("Finished destroying"
		$" SessionName="$SessionName);

	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameForInviteComplete);

	// Check for party and clean up
	PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
	if (PartySettings != None)
	{
		// Destroy the party and then accept the invite
		OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForInviteComplete);
		OnlineSub.GameInterface.DestroyOnlineGame('Party');
	}
	else
	{
		// Set the delegate for notification of the join completing
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		// This will have us join async
		if (!OnlineSub.GameInterface.AcceptGameInvite(LocalPlayer(Player).ControllerId,'Party'))
		{
			OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		}
	}
}

/**
 * Delegate called once the destroy of an online game before accepting an invite
 * is complete. From here, the game invite can be accepted
 *
 * @param SessionName the name of the session that was destroyed
 * @param bWasSuccessful whether the destroy completed properly or not
 */
function OnDestroyPartyForInviteComplete(name SessionName,bool bWasSuccessful)
{
	`LogOnline("Finished destroying"
		$" SessionName="$SessionName);

	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyForInviteComplete);
	// Set the delegate for notification of the join completing
	OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
	// This will have us join async
	if (!OnlineSub.GameInterface.AcceptGameInvite(LocalPlayer(Player).ControllerId,'Party'))
	{
		OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
	}
}

/**
 * Once the join completes, use the platform specific connection information
 * to connect to it
 *
 * @param SessionName the name of the session that was joined
 * @param bWasSuccessful whether the end completed properly or not
 */
function OnInviteJoinComplete(name SessionName,bool bWasSuccessful)
{
	local string URL;
	local string CurrentMovieName;

	`LogOnline("Finished join"
		$" SessionName="$SessionName);

	// Forcefully stop the movie, no matter what

	GetCurrentMovie(CurrentMovieName);
	if (CurrentMovieName != "LoadingMovie")
	{
		ClientStopMovie(0.0, false, true, true);
	}
	class'GearUIManager'.static.CloseAllUIMessageBoxes();

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		// Remove the delegate reference so we can GC
		OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		if (bWasSuccessful)
		{
			// Mark the party session as in progress if we're joining a game session already in progress
			if (OnlineSub.GameInterface.GetResolvedConnectString('Game',URL))
			{
				OnlineSub.GameInterface.AddStartOnlineGameCompleteDelegate(OnStartPartyForJoinComplete);
				if (!OnlineSub.GameInterface.StartOnlineGame('Party'))
				{
					OnlineSub.GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyForJoinComplete);
					OnStartPartyForJoinComplete('Party',false);
				}
			}
			else
			{
				// no need to start the party session as this will occur through the party lobby
				OnStartPartyForJoinComplete('Party',true);
			}
		}
		else
		{
			ClientShowLoadingMovie(false);
			// Do some error handling
			class'GearUIManager'.static.DisplayErrorMessage("InviteHandlingFailed_Message", "InviteHandlingFailed_Title", "GenericAccept");
		}
	}
}

/**
 * Party has been joined/started and we can travel to the invite
 */
function OnStartPartyForJoinComplete(name SessionName,bool bWasSuccessful)
{
	local string URL;
	local bool bValidURL;
	local GearPersistentPartyBeaconHost HostPersistentPartyBeacon;

	OnlineSub.GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyForJoinComplete);

	bValidURL = false;
	if (bWasSuccessful)
	{
		// If an invite came from a party that is currently in an active game session then
		// travel to the game session instead. This will only occur for game sessions that support JIP
		if (OnlineSub.GameInterface.GetResolvedConnectString('Game',URL))
		{
			`LogOnline("getting URL from Game session");
			bValidURL = true;
		}
		// Get the travel URL from the invited party session if no active game session
		else if (OnlineSub.GameInterface.GetResolvedConnectString('Party',URL))
		{
			`LogOnline("getting URL from Party session");
			bValidURL = true;
		}

		if (bValidURL)
		{
			// Since traveling because we were invited to a party as a client,
			// no longer need the persistent party host beacon
			HostPersistentPartyBeacon = GearPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
			if (HostPersistentPartyBeacon != None)
			{
				HostPersistentPartyBeacon.DestroyBeacon();
			}
			OnlineSub.SetNamedInterface('PersistentPartyHostBeacon',None);

			// Mark URL as invited
			URL $= "?bIsFromInvite";
			bIsReturningFromMatch = false;

			`LogOnline("Resulting url is ("$URL$")");
			// And now start the loading movie while we travel
			ClientShowLoadingMovie(true);
			ConsoleCommand("start "$URL);
		}
	}

	if (!bValidURL)
	{
		// Do some error handling
		class'GearUIManager'.static.DisplayErrorMessage("InviteHandlingFailed_Message", "InviteHandlingFailed_Title", "GenericAccept");
	}
}

/** Closes all message boxes that might be open */
function CloseAllUIMessageBoxes()
{
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.CloseAllUIMessageBoxes();
}

/**
 * Attempts to pause/unpause the game when the UI opens/closes. Note: pausing
 * only happens in standalone mode
 *
 * @param bIsOpening whether the UI is opening or closing
 */
function OnExternalUIChanged(bool bIsOpening)
{
	local UIInteraction UIController;
	local string CurrentMovieName;

	if ( bDeleteMe )
	{
		bIsOpening = false;
	}
	else if( bIsExternalUIOpen == bIsOpening )
	{
//		`log( "ERROR: Guide is already in that state"@bIsOpening );
		return;
	}

	if ( bIsOpening )
	{
		bRun = 0;
		bFire = 0;

		// Turn off targeting when you go to Guide
		bIsTargeting = FALSE;
		SetTargetingMode( FALSE );

		IgnoreMoveInput( TRUE );
		IgnoreLookInput( TRUE );
	}
	else
	{
		IgnoreMoveInput( FALSE );
		IgnoreLookInput( FALSE );
	}

	// Do pause the if you open a blade (even coop game - TTP 62072)
	UIController = class'UIRoot'.static.GetCurrentUIController();
	bIsExternalUIOpen = bIsOpening;

	if ( IsPrimaryPlayer() || !UIController.Outer.ShouldForceFullscreenViewport() )
	{
		// Don't pause the game if we're waiting on a load screen or watching a cutscene.  This
		// can actually cause a soft-lock due to how post-loading movie pausing works
		GetCurrentMovie(CurrentMovieName);
		if( CurrentMovieName == "" )
		{
			if ( bIsOpening )
			{
				PauseGame(CanUnpauseExternalUI);
			}
			else
			{
				SetPause(false);
			}
		}
	}
}

/** Callback that checks the external UI state before allowing unpause */
function bool CanUnpauseExternalUI()
{
	return Super.CanUnpauseExternalUI() && ( (MyGearHud == None) || (MyGearHud.GetPauseSceneReference() == None) );
}

/**
 * Calculate win/loss scores for the game from the GRI
 * @param PRI - player of interest
 * @param RoundCount - number of rounds
 * @param RoundsWon - number of rounds won
 * @param RoundsLost - number of rounds lost
 */
simulated function CalcWinLoss(GearPRI PRI, int RoundCount, out int RoundsWon, out int RoundsLost)
{
	local GearGRI GRI;
	local int TeamIndex;

	// Get the GRI so we can iterate players
	GRI = GearGRI(WorldInfo.GRI);

	// Update the round information
	RoundsWon = Min(RoundCount, PRI.Team.Score);
	RoundsLost = 0;
	// Figure out how many rounds lost to other team(s)
	for (TeamIndex = 0; TeamIndex < GRI.Teams.Length; TeamIndex++)
	{
		// If this is a different team, then add to the loss total
		if (PRI.Team.TeamIndex != GRI.Teams[TeamIndex].TeamIndex)
		{
			RoundsLost += GRI.Teams[TeamIndex].Score;
		}
	}
}

/**
 * Tells the clients to write the stats using the specified stats object
 *
 * @param OnlineStatsWriteClass the stats class to write with
 * @param bIsIncomplete TRUE if the match wasn't finished at the time of the write
 */
reliable client function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete=false)
{
 	local GearLeaderboardWriteBase Stats;
 	local GearPRI PRI;
 	local GearGRI GRI;
 	local int Index;
	local UniqueNetId ZeroId;
	local OnlineGameSettings GameSettings;
	local int RoundCount, RoundsWon, RoundsLost;

	// Only calc this if the subsystem can write stats
 	if (OnlineSub != None &&
 		OnlineSub.StatsInterface != None &&
 		OnlineSub.GameInterface != None &&
 		OnlineStatsWriteClass != None)
 	{
		// Get the game setting so we can determine whether to write stats for none, one or all players
		GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
		if (GameSettings != None)
		{
			// Store the score data for review in the party lobby
			StoreLastMatchData(OnlineStatsWriteClass, GameSettings.bUsesArbitration, bIsIncomplete);
			// Create the write object that we are going to submit to live
 			Stats = GearLeaderboardWriteBase(new OnlineStatsWriteClass);
			// Get the GRI so we can iterate players
			GRI = GearGRI(WorldInfo.GRI);

			// Incomplete implies round count off by one (round in progress)
			RoundCount = GRI.RoundCount;
			if (bIsIncomplete)
			{
				RoundCount++;
			}

			// Arbitration requires us to report for everyone, whereas non-arbitrated is just for ourselves
			if (GameSettings.bUsesArbitration)
			{
 				// Iterate through the active PRI list updating the stats
 				for (Index = 0; Index < GRI.PRIArray.Length; Index++)
 				{
 					PRI = GearPRI(GRI.PRIArray[Index]);
 					if (!PRI.bIsInactive &&
						PRI.UniqueId != ZeroId)
 					{
						if (bIsIncomplete && PRI == PlayerReplicationInfo)
						{
							// Penalize yourself
							PenalizeDroppedPlayer(PRI);
							RoundsWon = 0;
							RoundsLost = RoundCount;
						}
						else
						{
							CalcWinLoss(PRI, RoundCount, RoundsWon, RoundsLost);
						}

						// Copy the stats from the PRI to the object
						Stats.UpdateFromPRI(PRI, RoundCount, RoundsWon, RoundsLost);
 						// This will copy them into the online subsystem where they will be
 						// sent via the network in EndOnlineGame()
 						OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Stats);
 					}
 				}
			}
			else
			{
				PRI = GearPRI(PlayerReplicationInfo);

				CalcWinLoss(PRI, RoundCount, RoundsWon, RoundsLost);

				// Copy the stats from the PRI to the object
				Stats.UpdateFromPRI(PRI, RoundCount, RoundsWon, RoundsLost);
				// This will copy them into the online subsystem where they will be
				// sent via the network in EndOnlineGame()
				OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName,PRI.UniqueId,Stats);
			}
		}
 	}
}

/** Update the PRI to penalize the player appropriately */
simulated function PenalizeDroppedPlayer(GearPRI PRI)
{
	// Penalize score
	PRI.Score -= class'GearProfileSettings'.default.XPQuitPenalty;

	// Penalize kills
	PRI.Score_Kills = 0;

	// Penalize the player with an extra death for the drop
	PRI.Deaths += 1;
	PRI.DisconnectCount += 1;
}

/**
 * Immediately write out the stats for disconnected players
 * Server will determine if its necessary to actually call this function
 * @param OnlineStatsWriteClass - the stats class to write stats data for
 * @param PRI - the disconnected player
 */
client reliable function ClientWriteStatsForDroppedPlayer(class<OnlineStatsWrite> OnlineStatsWriteClass, GearPRI PRI)
{
	local GearLeaderboardWriteBase Stats;
	local GearGRI GRI;

	// Create a new instance of the write class to write out the dropped player
	Stats = GearLeaderboardWriteBase(new OnlineStatsWriteClass);
	if (Stats != None)
	{
		GRI = GearGRI(WorldInfo.GRI);

		PenalizeDroppedPlayer(PRI);

		// Copy the stats from the PRI to the object (penalize with all losses)
		if( ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameWingman_Base') )
		{
			Stats.UpdateFromPRI(PRI, 1, 0, 1);
		}
		else
		{
			Stats.UpdateFromPRI(PRI, GRI.RoundCount + 1, 0, GRI.RoundCount + 1);
		}

		// This will copy them into the online subsystem where they will be
		// sent via the network in EndOnlineGame()
		OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName,PRI.UniqueId,Stats);
	}
}


/**
 * Stores all of the stats from this match for view in the party lobby
 *
 * @param OnlineStatsWriteClass the stats class to write with
 * @param bUsesArbitration whether this is an arbitrated match or not
 * @param bIncompleteMatch whether the match was incomplete or not
 */
simulated function StoreLastMatchData(class<OnlineStatsWrite> OnlineStatsWriteClass, bool bUsesArbitration, optional bool bIncompleteMatch=false)
{
	local GearRecentPlayersList PlayersList;
	local GearMatchData MatchResults;
	local int Index;
	local GearPRI PRI;
	local UniqueNetId ZeroId;
	local GearLocalPlayer GLP;

	// Since the object is a singleton, it only needs to be done once per box
	if (IsPrimaryPlayer())
	{
		// Get the recent player data for the last match stats
		PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if (PlayersList != None)
		{
			MatchResults = PlayersList.GetCurrentMatchResults();
			// Update the final state for each player
			for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
			{
				PRI = GearPRI(WorldInfo.GRI.PRIArray[Index]);
				if (PRI.UniqueId != ZeroId)
				{
					MatchResults.UpdatePlayer(PRI);
				}
				else
				{
					MatchResults.AddBot(PRI);
				}
			}

			// Update the match duration
			if (bIncompleteMatch)
			{
				MatchResults.UpdateMatchTime( GearGRI(WorldInfo.GRI).MatchDuration + GearGRI(WorldInfo.GRI).RoundEndTime);
				MatchResults.bIncomplete = true;
			}
			else
			{
				MatchResults.UpdateMatchTime( GearGRI(WorldInfo.GRI).MatchDuration );
			}

			// Now add the ratio columns
			if (MatchResults.LastMatchResults != None)
			{
				MatchResults.LastMatchResults.OnReadComplete();
			}

			// Store it as the last match
			PlayersList.LastMatchData = MatchResults;
			PlayersList.CurrentMatchData = None;

			// Mark the local player so that the front end knows to display postgame stats when returning to front end
			GLP = GearLocalPlayer(Player);
			if (GLP != None)
			{
				GLP.bAutoDisplayPostGameStats = true;
			}
		}
	}
}

final event NoticeEnemy(Pawn Noticer, Pawn Noticee)
{
	if (GearGameSP_Base(WorldInfo.Game) != None || GearGameSiege_Base(WorldInfo.Game) != None)
	{
		GearGame(WorldInfo.Game).BattleMonitor.NotifyEnemyNoticed(Noticer, Noticee);
	}
}

/** Deal with list of nearby enemies, keep it up to date and all that. */
final native function MaintainEnemyList();

/** Returns which target we should use for friction (or adhesion), or None if none are appropriate. */
final native function Actor GetFrictionAdhesionTarget(float MaxDistance, optional bool bAdhesion);


/************************************************************************************
 * Firing Code
 ***********************************************************************************/

/**
 * Inherited, called from button bindings.
 */
exec function StartFire(optional byte FireModeNum)
{
	// @laurent -- Pawn is responsible for starting/stopping when bFire is set
	// do not call StartFire. See "Firing Code" in GearPawn.
}

/**
 * POIs need their icon durations zeroed out once the player hits the forcelook button
 */
function ClearPOIIconDurations()
{
	local GearPointOfInterest POI;
	foreach EnabledPointsOfInterest(POI)
	{
		POI.CurrIconDuration = 0.f;
	}
}

function bool FindVehicleToDrive()
{
	local Pawn PawnToRide;
	local Vehicle Vehic;
	local GearPawnRidable_Base RidablePawn;

	// See if there is a drivable pawn
	PawnToRide = GetFoundVehicleToDrive();
	if (PawnToRide != none)
	{
		// First see if it's a vehicle
		Vehic = Vehicle(PawnToRide);
		if (Vehic != none)
		{
			return Vehic.TryToDrive(Pawn);
		}
		else
		{
			// It wasn't a vehicle so now try a ridable pawn
			RidablePawn = GearPawnRidable_Base(PawnToRide);
			if (RidablePawn != none)
			{
				return RidablePawn.TryToDrive(Pawn);
			}
		}
	}
	// Nothing to report
	return false;
}

/** Tries to find a vehicle to drive within a limited radius. Returns true if successful
 *  This is a modified version of the one in PlayerController.uc which returns which vehicle
 *  you can interact with.  I would have put this change in PlayerController but we are locked out of engine.
 */
final function Pawn GetFoundVehicleToDrive()
{
	local Pawn Best;
	local Pawn OverlapPawn;
	local vector ViewDir, PawnLoc2D, VLoc2D;
	local float NewDot, BestDot;

	// See if we are already on a vehicle or ridable pawn
	if (Pawn.DrivenVehicle != None || (GearPawnRidable_Base(Pawn.Base) != None && GearPawnRidable_Base(Pawn.Base).CanEnterRidablePawn(MyGearPawn)))
	{
		return None;
	}

	// Can't drive while carrying heavy weapons and shields
	if (MyGearPawn.IsCarryingAHeavyWeapon() || MyGearPawn.IsCarryingShield())
	{
		return None;
	}

	// Can't drive while in Cover, player has to exit first.
	if( MyGearPawn.CoverType != CT_None )
	{
		return None;
	}

	// Pick best nearby vehicle or ridable pawn
	PawnLoc2D = Pawn.Location;
	PawnLoc2D.Z = 0;
	ViewDir = vector(Pawn.Rotation);

	ForEach Pawn.OverlappingActors(class'Pawn', OverlapPawn, Pawn.VehicleCheckRadius)
	{
		// Make sure this is either a vehicle or a ridable pawn
		if (Vehicle(OverlapPawn) != none || GearPawnRidable_Base(OverlapPawn) != none)
		{
			// Only vehicles that Pawn is facing
			VLoc2D = OverlapPawn.Location;
			if (OverlapPawn.IsA('GearTurret'))
			{
				VLoc2D += GearTurret(OverlapPawn).EntryTestOffset >> OverlapPawn.Rotation;
			}
			Vloc2D.Z = 0;
			NewDot = Normal(VLoc2D-PawnLoc2D) Dot ViewDir;
			if (NewDot > 0.0f &&
				(Best == None ||	NewDot > BestDot))
			{
				// check that vehicle is visible
				if ( FastTrace(OverlapPawn.Location,Pawn.Location) )
				{
					Best = OverlapPawn;
					BestDot = NewDot;
				}
			}
		}
	}

	// If we found one we need to see if we can enter it
	if (Best != None)
	{
		// First check if it's a vehicle then check ridable pawns
		if ((Vehicle(Best) != none && Vehicle(Best).CanEnterVehicle(Pawn)) ||
			(GearPawnRidable_Base(Best) != none && GearPawnRidable_Base(Best).CanEnterRidablePawn(MyGearPawn)))
		{
			return Best;
		}
	}
	return None;
}

/**
 * Checks for a SeqEvt_Interaction that the player could interact with and sets InteractEvent to it if so
 * for replication and for use later in UpdateHUDActions()
 * server only
 */
event CheckForInteractionEvents()
{
	local Actor TouchActor;
	local Trigger_Engage EngageTrigger;
	local int EvtIdx;

	InteractEvent = None;
	if (MyGearPawn != None)
	{
		// try to interact with anything the pawn is touching
		foreach Pawn.TouchingActors(class'Actor', TouchActor)
		{
			EngageTrigger = Trigger_Engage(TouchActor);
			if (!TouchActor.bDeleteMe && (EngageTrigger == None || EngageTrigger.bIsEngagable))
			{
				// iterate through each event looking for interaction
				for (EvtIdx = 0; EvtIdx < TouchActor.GeneratedEvents.Length; EvtIdx++)
				{
					InteractEvent = SeqEvt_Interaction(TouchActor.GeneratedEvents[EvtIdx]);
					if (InteractEvent != None && InteractEvent.CanDoInteraction(self) && InteractEvent.CheckActivate(TouchActor, Pawn, TRUE))
					{
						// we have an event!
						break;
					}
					// otherwise clear the event
					InteractEvent = None;
				}
				// if there is an event to interact with
				if (InteractEvent != None)
				{
					// stop looking
					break;
				}
			}
		}
	}
}

/** check for smoke grenade blocker in between the specified points */
final function bool IsSmokeGrenadeBlockingSight(vector StartTrace, vector EndTrace)
{
	local GearGRI GRI;
	local int i;
	local vector HitLocation, HitNormal;

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		for (i = 0; i < GRI.TargetingBlockingVolumes.length; i++)
		{
			if (TraceComponent(HitLocation, HitNormal, GRI.TargetingBlockingVolumes[i].CollisionComponent, EndTrace, StartTrace))
			{
				return true;
			}
		}
	}

	return false;
}

function bool CanPickupWeapons()
{
	return CanDoSpecialMove(SM_WeaponPickup);
}


// will update the cando status of one special move per frame, and we use the cached results
final private native function UpdateCanDoSpecialMoveCache(bool bInCover);

// checks cover and global action special moves and returns TRUE if one was found
final private native function bool CheckForSpecialMove();

//`define UpdateHudActionsPerf
`if(`isdefined(UpdateHudActionsPerf))
`define	CClock(Time) Clock(`Time)
`define CUnClock(Time) UnClock(`Time)
`else
`define CUnClock(Time)
`define	CClock(Time)
`endif

/**
*  Check to see if there is any possibility for a POI alert
*  Code broken out from UpdateHUDActions()
*/
final function CheckEnabledPointsOfInterest(float DeltaTime)
{
	local int Idx;

	// check to see if there's a poi force look available
	if (EnabledPointsOfInterest.Length > 0)
	{
		for (Idx = 0; Idx < EnabledPointsOfInterest.Length; Idx++)
		{
			// make sure the poi didn't get deleted behind our back
			if ( EnabledPointsOfInterest[Idx] == None )
			{
				// remove from the list, back the index up, and continue through loop
				EnabledPointsOfInterest.Remove( Idx, 1 );
				POILookedAtList.Remove( Idx, 1 );
				Idx--;
				continue;
			}

			// if this poi has an icon duration...
			if ( EnabledPointsOfInterest[Idx].bEnabled && EnabledPointsOfInterest[Idx].CurrIconDuration > 0.f &&
				(!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType > EnabledPointsOfInterest[Idx].ActionIconType) )
			{
				EnabledPointsOfInterest[Idx].CurrIconDuration -= DeltaTime;

				if ( EnabledPointsOfInterest[Idx].CurrIconDuration > 0.f )
				{
					if(Pawn != none && Pawn.IsLocallyControlled() && LastPoITime+PoIRepeatTime < WorldInfo.TimeSeconds)
					{
						PlaySound( PointOfInterestAdded, true );
						LastPoITime = WorldInfo.TimeSeconds;
					}
					if ( MyGearHud.SetActionInfo(EnabledPointsOfInterest[Idx].ActionIconType, EnabledPointsOfInterest[Idx].ActionLookAt) )
					{
						CurrLookedAtPOI = EnabledPointsOfInterest[Idx];
					}
				}
				else
				{
					MyGearHud.ClearActionInfoByType(EnabledPointsOfInterest[Idx].ActionIconType);
				}
			}
		}
	}
}

/**
*  Check to see if there is any possibility for interaction with a pickup
*  Code broken out from UpdateHUDActions(), expects that the CanPickupWeapons() function returns true
*/
final function CheckForPickups()
{
	local ActionInfo FoundAction;
	local Actor FoundActor;

	if (MyGearPawn.IsDoingSpecialMove(SM_WeaponPickup))
	{
		MyGearHud.ClearActionInfoByType(AT_Pickup);
		return;
	}

	FindBestPickup(FoundActor, FoundAction);

	if (FoundAction.ActionName != '')
	{
		MyGearHud.SetActionInfo(AT_Pickup, FoundAction);
	}
	else
	{
		// if we don't have an interaction then clear the last one
		MyGearHud.ClearActionInfoByType(AT_Pickup);
	}
}

/**
*  Check to see if there is any possibility for a special move hud icon
*  Code broken out from UpdateHUDActions(), expects that the bShowSpecialMoveTips flag is true
*/
final function CheckSpecialMoves()
{
	local class<GearSpecialMove> MoveClass;
	local GearPawn out_InteractionPawn;
	local ESpecialMove out_SpecialMove;
	local GSM_Kantus_ReviveScream ScreamMove;
	local int i;
	local bool bFoundDBNO;

	// Check for Pawn to Pawn interactions first
	if (MyGearPawn.CheckPawnToPawnInteractions(out_SpecialMove, out_InteractionPawn, true))
	{
		MoveClass = MyGearPawn.SpecialMoveClasses[out_SpecialMove];
		if (MoveClass.default.Action.ActionName == 'GrabMeatShield')
		{
			// Trigger the meatshield delegates
			TriggerGearEventDelegates( eGED_MeatShield );
		}

		// then notify the hud and stop looking
		MyGearHud.SetActionInfo(AT_SpecialMove, MoveClass.default.Action, MyGearPawn.bIsMirrored);
	}
	else if (CheckForSpecialMove())
	{
		// CheckForSpecialMove() sets the ActionInfo itself
	}
	// check special case of reviving while holding a hostage
	else if ( MyGearPawn.IsAKidnapper() && !MyGearPawn.InteractionPawn.CanBeSpecialMeleeAttacked(MyGearPawn) &&
			MyGearPawn.SpecialMoveClasses[SM_ReviveTeammate] != None && MyGearPawn.VerifySMHasBeenInstanced(SM_ReviveTeammate) )
	{
		if (GSM_ReviveTeammate(MyGearPawn.SpecialMoves[SM_ReviveTeammate]).FindPawnToRevive())
		{
			MyGearHud.SetActionInfo(AT_SpecialMove, MyGearPawn.SpecialMoves[SM_ReviveTeammate].Action, MyGearPawn.bIsMirrored);
		}
		else if (MyGearHud.ActiveAction.ActionName == MyGearPawn.SpecialMoves[SM_ReviveTeammate].Action.ActionName)
		{
			MyGearHud.ClearActionInfoByType(AT_SpecialMove);
		}
	}
	// if we don't have an interaction then clear the last one
	else
	{
		// special check for revive scream since it can be activated just to heal,
		// but we only want to show the icon when a nearby ally is DBNO
		if (MyGearPawn.CanDoSpecialMove(GSM_Kantus_ReviveScream))
		{
			ScreamMove = GSM_Kantus_ReviveScream(MyGearPawn.SpecialMoves[GSM_Kantus_ReviveScream]);
			for (i = 0; i < ScreamMove.PawnsToHeal.length; i++)
			{
				if (ScreamMove.PawnsToHeal[i].IsDBNO() || ScreamMove.PawnsToHeal[i].Health < ScreamMove.PawnsToHeal[i].HealthMax * 0.5)
				{
					MyGearHud.SetActionInfo(AT_SpecialMove, ScreamMove.Action, MyGearPawn.bIsMirrored);
					bFoundDBNO = true;
					break;
				}
			}
		}

		if (!bFoundDBNO)
		{
			// if not doing a special move
			if (!IsDoingASpecialMove() || IsDoingSpecialMove(SM_RoadieRun))
			{
				// clear the default
				MyGearHud.ClearActionInfoByType(AT_SpecialMove);
			}
			// otherwise check for the special case interactions
			else if (MyGearHud.ActiveAction.ActionName == 'PushObject' && !IsDoingSpecialMove(SM_PushObject))
			{
				MyGearHud.ClearActionInfoByType(AT_SpecialMove);
			}
			else if (MyGearHud.ActiveAction.ActionName == 'SawDuel' && !IsDoingSpecialMove(SM_ChainsawDuel_Follower) && !IsDoingSpecialMove(SM_ChainsawDuel_Leader) && !MyGearPawn.bInDuelingMiniGame)
			{
				MyGearHud.ClearActionInfoByType(AT_SpecialMove);
			}
		}
	}
}

/**
 *  Check to see if there is any possibility for interaction with a vehicle
 *  Code broken out from UpdateHUDActions(), expects that the bCheckForVehicles flag is true
 */
final function CheckForVehicles()
{
	local Pawn DrivablePawn;
	local Turret TurretVehicle;
	local GearVehicle GV;
	local GearPawnRidable_Base RidablePawn;

	// try to find a vehicle
	DrivablePawn = GetFoundVehicleToDrive();
	// see if we found a vehicle
	if (DrivablePawn != None)
	{
		TurretVehicle = Turret(DrivablePawn);
		GV = GearVehicle(DrivablePawn);
		RidablePawn = GearPawnRidable_Base(DrivablePawn);

		// now that we have a vehicle, see if it's a turret
		if (TurretVehicle != None)
		{
			MyGearHud.SetActionInfo(AT_Vehicle,TurretVehicle.InteractAction);
		}
		else if (GV != None)
		{
			MyGearHud.SetActionInfo(AT_Vehicle, GV.InteractAction);
		}
		// Try ridable pawn
		else if (RidablePawn != None)
		{
			MyGearHud.SetActionInfo(AT_Vehicle, RidablePawn.Action);
		}
	}
	// if we don't have a vehicle then clear the last one
	else
	{
		MyGearHud.ClearActionInfoByType(AT_Vehicle);
	}
}

final function AssignHitTargets(const vector StartTrace, const vector EndTrace, const vector TraceDir, out string HitPawnName)
{
	local vector HitLoc, HitNormal;
	local GearPawn HitWP;
	local Vehicle_Reaver_Base HitReaver;
	local GearProj_Grenade HitGrenade;
	local ImpactInfo Impact;
	local Actor HitActor;
	local int i;

	// Clear this flag unless we are looking at a movable cover object
	MyGearHud.bMovableCoverSpotted = FALSE;

	if (!IsSmokeGrenadeBlockingSight(StartTrace, EndTrace))
	{
		// prevent meat shield from being hit by aiming trace
		if (MyGearPawn != None && MyGearPawn.IsAKidnapper() && MyGearPawn.InteractionPawn != None)
		{
			MyGearPawn.InteractionPawn.Mesh.SetTraceBlocking(false, false);
		}

		// do the trace to see what's in our sights
		CalcWeaponFire(StartTrace, EndTrace, HitLoc, HitNormal, HitActor, Impact);

		HitWP = GearPawn(HitActor);
		HitReaver = Vehicle_Reaver_Base(HitActor);
		LastCrosshairHitLocation = Impact.HitLocation;

		// restore meat shield flags
		if (MyGearPawn != None && MyGearPawn.IsAKidnapper() && MyGearPawn.InteractionPawn != None)
		{
			MyGearPawn.InteractionPawn.Mesh.SetTraceBlocking(true, false);
		}

		// redirect to kidnapper when hitting hostage
		if (HitWP != None && HitWP.IsAHostage())
		{
			HitWP = HitWP.InteractionPawn;
		}

		// redirect to the ridable pawn if we're hitting the driver
		if (HitWP != None && HitWP.Base != None && HitWP.Base.IsA('GearPawnRidable_Base'))
		{
			HitWP = GearPawn(HitWP.Base);
		}

		//Record the name of the hit target
		if (HitWP != None && HitWP.PlayerReplicationInfo != None && !HitWP.bTearOff)
		{
			HitPawnName = HitWP.PlayerReplicationInfo.PlayerName;
		}

		// If a player is using a turret, the PRI sits on the turret
		if (HitWP != None && HitWP.DrivenVehicle != None && HitWP.DrivenVehicle.PlayerReplicationInfo != None)
		{
			HitPawnName = HitWP.DrivenVehicle.PlayerReplicationInfo.PlayerName;
		}

		TargetedPawn  = HitWP;
		TargetedActor = HitActor;

		// This code section moved inside the above IsSmokeGrenadeBlockingSight check because HitWP can only possibly be assigned inside it

		// Allow HUD to handle displaying UI for when a pawn is targeted
		if ( WorldInfo.GRI != None && bIsTargeting )
		{
			if ( WorldInfo.GRI.IsMultiplayerGame() && (HitWP != None) && ((HitWP.Health >= 0) || HitWP.IsDBNO()) && !HitWP.bTearOff )
			{
				MyGearHud.HandlePawnTargetted( HitWP );
			}
		}

		//debug log for what we hit to track down why its not turning
		`log( GetFuncName()@"Hit..."@HitActor, bDebug );

		// we only want enemy targets for this feature (pawn or vehicle reavers)
		if( (HitWP != None && HitWP.ShouldTurnCursorRedFor(self, HitLoc, Impact.HitInfo.BoneName, Impact.HitInfo.HitComponent)) ||
			(HitReaver != None && HitReaver.GetTeamNum() != 254 && !WorldInfo.GRI.OnSameTeam(self, HitReaver)) )
		{
			if ( ( HitWP != None && (HitWP.Health >= 0 || HitWP.IsDBNO()) && !HitWP.bTearOff &&
					(HitWP.EquippedShield == None || Impact.HitInfo.HitComponent != HitWP.EquippedShield.Mesh) &&
					( !HitWP.IsDBNO() || HitWP.bCanBeExecutedFromAfar || (Pawn != None && VSize(Pawn.Location - HitWP.Location) <= 256.0) ||
						(MyGearPawn != None && MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.bIgnoresExecutionRules) ) ) ||
				(HitReaver != None && HitReaver.Health >= 0 && !HitReaver.bTearOff) )
			{
				if ( WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.GRI.IsCoopMultiplayerGame() )
				{
					// the reavers don't get a MultiplayerCoverDamageAdjust
					if (HitWP != None)
					{
						MyGearHud.bUnfriendlySpotted = (HitWP.MultiplayerCoverDamageAdjust(TraceDir, Pawn, HitLoc, 100) != 0);
						MyGearHud.UnfriendlyReticleActor = HitWP;
					}
					else
					{
						MyGearHud.bUnfriendlySpotted = true;
						MyGearHud.UnfriendlyReticleActor = HitReaver;
					}
				}
				else
				{
					MyGearHud.bUnfriendlySpotted = true;
					MyGearHud.UnfriendlyReticleActor = (HitWP != None) ? HitWP : HitReaver;
				}
			}

			// clear so that we don't draw the name
			HitPawnName = "";
		}
		else
		{
			// display red crosshair if over an enemy planted grenade
			HitGrenade = GearProj_Grenade(HitActor);
			if ( HitGrenade != None && HitGrenade.TagVictim != None && !HitGrenade.TagVictim.IsA('Pawn') &&
				!WorldInfo.GRI.OnSameTeam(self, HitGrenade) )
			{
				MyGearHud.bUnfriendlySpotted = TRUE;
				MyGearHud.UnfriendlyReticleActor = HitGrenade;
			}
			// Hit skel mesh actor which can do thi
			else if ( (SkelMeshActor_Unfriendly(HitActor) != None) &&
					SkelMeshActor_Unfriendly(HitActor).HitAreaIsUnfriendly(Impact.HitInfo) )
			{
				MyGearHud.bUnfriendlySpotted = TRUE;
				MyGearHud.UnfriendlyReticleActor = HitActor;
			}
			// Hit crowd actor
			else if (GameCrowdAgent(HitActor) != None)
			{
				MyGearHud.bUnfriendlySpotted = TRUE;
				MyGearHud.UnfriendlyReticleActor = HitActor;
			}
			else if( GearSpawner_LambentPodBase(HitActor) != None )
			{
				MyGearHud.bUnfriendlySpotted = GearSpawner_LambentPodBase(HitActor).PodIsShootable();
				MyGearHud.UnfriendlyReticleActor = HitActor;
				HitPawnName = "";
			}
			// Hit InterpActor_MovableCover
			else if (InterpActor_MovableCover(HitActor) != None && !InterpActor_MovableCover(HitActor).bHidePushableIcon)
			{
				MyGearHud.bMovableCoverSpotted = TRUE;
			}
			// fortifications
			else if (GearFortification(HitActor) != None)
			{
				MyGearHud.bUnfriendlySpotted = !HitActor.IsInState('Crippled') && !WorldInfo.GRI.OnSameTeam(HitActor, self);
				MyGearHud.UnfriendlyReticleActor = HitActor;
			}
			// turrets
			else if (Vehicle(HitActor) != None && HitReaver == None && HitActor.bCanBeDamaged && (GearVehicle(HitActor) == None || !GearVehicle(HitActor).bDeadVehicle) )
			{
				MyGearHud.bUnfriendlySpotted = !WorldInfo.GRI.OnSameTeam(HitActor, self);
				MyGearHud.UnfriendlyReticleActor = HitActor;
			}
			// Underwater hazards (for Maelstrom)
			else if (GearUnderwaterRocket(HitActor) != None || GearUnderwaterMine(HitActor) != None)
			{
				MyGearHud.bUnfriendlySpotted = HitActor.bCollideActors;
				MyGearHud.UnfriendlyReticleActor = HitActor;
			}
			else if (HitActor != None)
			{
				// Actor is "unfriendly"
				for (i = 0; i < ArrayCount(UnfriendlyActorList); i++)
				{
					if (UnfriendlyActorList[i] == HitActor)
					{
						MyGearHud.bUnfriendlySpotted = TRUE;
						MyGearHud.UnfriendlyReticleActor = HitActor;
						break;
					}
				}
			}
		}

		// See if we should draw 'reticle plus'
		if( MyGearHud.bUnfriendlySpotted == TRUE && HitWP != None && HitWP.ShouldDisplayCrosshairPlus(self, HitLoc, Impact.HitInfo.BoneName, Impact.HitInfo.HitComponent) )
		{
			MyGearHud.bShowReticlePlus = TRUE;
		}
	}
}

simulated function OnMarkUnfriendlyActor( SeqAct_MarkUnfriendlyActor Action )
{
	local int Idx, LocalIdx;

	if( Action.bOverwriteExisting )
	{
		for (Idx = 0; Idx < ArrayCount(UnfriendlyActorList); Idx++)
		{
			UnfriendlyActorList[Idx] = None;
		}
	}

	for( Idx = 0; Idx < Action.UnfriendlyList.Length; Idx++ )
	{
		if (Action.UnfriendlyList[Idx] != None)
		{
			if (LocalIdx == ArrayCount(UnfriendlyActorList))
			{
				`Warn("Ran out of free UnfriendlyActorList entries"@Action);
`if(`notdefined(FINAL_RELEASE))
				ClientMessage( "Ran out of free UnfriendlyActorList entries"@Action );
`endif
			}
			else
			{
				for (LocalIdx = LocalIdx; LocalIdx < ArrayCount(UnfriendlyActorList); LocalIdx++)
				{
					if (UnfriendlyActorList[LocalIdx] == None || UnfriendlyActorList[LocalIdx].IsPendingKill())
					{
						UnfriendlyActorList[LocalIdx] = Action.UnfriendlyList[Idx];
						LocalIdx++;
						break;
					}
				}
			}
		}
	}
}

/**
 * Check if we're targeting near a friendly pawn
 * Reusing the spot buffer from the marking system
 *
 * @return TRUE if we're targeting near a friendly pawn
 */
function bool IsTargetingNearAFriendlyPawn()
{
	local GearPawn GP;
	local float CamTraceDist;
	local vector StartTrace, EndTrace;
	local rotator CamRot;

	// Going to do a fuzzy check by seeing if the camera trace is within SpotBuffer units of hitting the pawn
	GetPlayerViewPoint(StartTrace, CamRot);
	EndTrace = StartTrace + vector(CamRot) * DistanceForEnemyTrace;

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (GP.IsSameTeam(MyGearPawn))
		{
			CamTraceDist = PointDistToSegment(GP.Location, StartTrace, EndTrace);

			//`log(`showvar(GP) @ `showvar(CamTraceDist));
			if (CamTraceDist < GP.SpotBufferMin)
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

/**
* Checks various special moves to show the tip icon if necessary.
*/
final function UpdateHUDActions(float DeltaTime)
{
	local vector					StartTrace, EndTrace, TraceDir;
	local rotator					CamRot;
	local ActionInfo				Action;
	local bool						bShowingValve, bRecentlyTargeting;
	local Vehicle					VehicleTest;
	local Trigger_Engage			Engage;
	local string					HitPawnName;
	local GearTrackBomb Bomb;
	local GearFortification Fort;
	local GearMapSpecificInfo MapInfo;
	local GearFortification GF;
	local bool bFoundFortification;
	local GearFortificationMarker GFMarker;
	local GearWeapon GW;

`if(`isdefined(UpdateHudActionsPerf))
	local int	Idx;
	local float Overall,SumTotal;
	local float Time[20];
`endif

	if ( MyGearHUD == None )
	{
		return;
	}

	if ( CurrentPPType == eGPP_GameOver )
	{
		MyGearHud.ClearActiveActionInfo();
		return;
	}

	// If the player is DBNO
	if (IsInState('Reviving'))
	{
		return;
	}

	`CClock(Overall);
	VehicleTest = Vehicle(Pawn);

	// test the crosshair
	MyGearHud.bUnfriendlySpotted = false;
	MyGearHud.bShowReticlePlus = false;
	TargetedPawn = None;
	TargetedActor = None;
	bRecentlyTargeting = (`TimeSince(LastTargetingTime) <= 1.f);

	//Time[0] and Time[1] eliminated when code they were measuring was moved into if block below
	`CClock(Time[2]);

	//Figures out who/what we are hitting (HitPawn/Reaver)
	if ((MyGearPawn != None && MyGearPawn.bIsTargeting) || VehicleTest != None || bRecentlyTargeting )
	{
		// If we have a weapon, use that as the start of the trace to prevent false positives when turning the reticle red
		GW = GearWeapon(Pawn.Weapon);
		if (GW != None)
		{
			// start the trace from the camera location
			GetPlayerViewPoint(StartTrace, CamRot);
			TraceDir = vector(CamRot);

			if (GW.WeaponFireTypes[0] == EWFT_Projectile)
			{
				GW.GetProjectileFirePosition(StartTrace, TraceDir);
			}
			else
			{
				StartTrace = Pawn.GetWeaponStartTraceLocation();
			}

			// firing from the camera on scope weapons, need to add the postprocess from floor conform
			if (GW.bIsScopeWeapon && MyGearPawn.bIsZoomed)
			{
				StartTrace += MyGearPawn.FloorConformTranslation >> MyGearPawn.Rotation;
			}

			// limit the trace for the flamethrower so players can judge the damage effectiveness better
			if( GW.bOverrideDistanceForEnemyTrace )
			{
				EndTrace = StartTrace + (TraceDir * GW.GetWeaponDistanceForEnemyTrace());
			}
			else
			{
				MapInfo = GearMapSpecificInfo(WorldInfo.GetMapInfo());
				EndTrace = StartTrace + (TraceDir * (DistanceForEnemyTrace * ((MapInfo != None) ? MapInfo.VisibilityModifier : 1.0)));
			}
			AssignHitTargets(StartTrace, EndTrace, TraceDir, HitPawnName);
		}
	}

	`CUnClock(Time[2]);

	`CClock(Time[5]);
	// if we are showing a scripted icon and the poi for it was disabled, turn off the icon
	if ( CurrLookedAtPOI != None && MyGearHud.ActiveAction.bActive && MyGearHud.ActiveAction.ActionType == CurrLookedAtPOI.ActionIconType &&
		(!CurrLookedAtPOI.bEnabled || CurrLookedAtPOI.CurrIconDuration <= 0.0) )
	{
		MyGearHud.ClearActionInfoByType(CurrLookedAtPOI.ActionIconType);
	}

	// if we have a pawn, hud, and aren't looking at a POI, nor doing a special move already
	if ((MyGearPawn != None || VehicleTest != None)
		&& !bLookingAtPointOfInterest
		&& (MyGearPawn == None || IsInState('Engaging') || (!MyGearPawn.IsDoingASpecialMove() || MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bShowHUDActions))
		)
	{
		CheckEnabledPointsOfInterest(DeltaTime);
		`CUnClock(Time[5]);

		`CClock(Time[6]);
		// check to see if we're looking at a player or a movable cover object
		if (!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType >= AT_Player)
		{
			if (bIsTargeting)
			{
				// if we're looking at a friendly player
				if (HitPawnName != "")
				{
					Action.ToolTipText = HitPawnName;
					Action.bDrawBelowCrosshair = TRUE;
					MyGearHud.SetActionInfo(AT_Player, Action);
				}
				else
				{
					// otherwise clear any players
					MyGearHud.ClearActionInfoByType(AT_Player);
				}

				// if we're looking at a movable cover object
				if( MyGearHud.bMovableCoverSpotted )
				{
					MyGearHud.SetActionInfo(AT_MovableObject, Action);
				}
				else
				{
					MyGearHud.ClearActionInfoByType(AT_MovableObject);
				}

				// only allow coop interaction menu if we hit a pawn on our first targeting frame
				if (!bTargetingLastFrame && !bCanUseCoopInteractionMenu)
				{
					if (HitPawnName != "" || IsTargetingNearAFriendlyPawn())
					{
						bCanUseCoopInteractionMenu = TRUE;
					}
				}
			}
			else
			{
				// must clear action info if targeting was turned off
				if ( !MyGearHud.ClearActionInfoByType(AT_Player) )
				{
					MyGearHud.ClearActionInfoByType(AT_MovableObject);
				}
			}
		}

		// See if we need to show the engaging icon
		if ( IsInState('Engaging') )
		{
			if (!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType >= AT_StateAction)
			{
				Engage = MyGearPawn.EngageTrigger;
				// make sure we can still turn it and that we're in a position to turn it
				if ( (Engage != None) && Engage.bIsEngagable )
				{
					MyGearHud.SetActionInfo(AT_StateAction, Engage.ENGAGE_ActionInfo);
					bShowingValve = true;
				}
			}
		}
		if ( (MyGearHud.ActiveAction.ActionType == AT_StateAction) && !bShowingValve )
		{
			// clear the action
			MyGearHud.ClearActionInfoByType(AT_StateAction);
		}

		if ( MyGearPawn == None || MyGearPawn.MyGearWeapon == None || !MyGearPawn.MyGearWeapon.SetSpecialAction(self) )
		{
			MyGearHud.ClearActionInfoByType(AT_WeaponActions);
		}

		//@FIXME: Siege hack
		if (MyGearPawn != None && IsA('GearPC_Siege'))
		{
			if (MyGearPawn.CanEngageMelee())
			{
				foreach MyGearPawn.TouchingActors(class'GearFortification', GF)
				{
					if (GF.IsDesirableMeleeTarget(MyGearPawn))
					{
						MyGearHud.SetActionInfo(AT_FortificationMelee, ActionHitFortification);
						bFoundFortification = TRUE;
						break;
					}
				}
			}

			if (!bFoundFortification)
			{
				MyGearHud.ClearActionInfoByType(AT_FortificationMelee);
			}
		}

		`CUnClock(Time[6]);

		// At this point, if we're manning a vehicle, we don't want any icons below this
		// priority to show up.
		if ( VehicleTest == None )
		{
			// if not targeting and not conversing
			// Targeting does not keep the tips from updating anymore
			if (/*!bIsTargeting &&*/ (MyGearPawn == None || !MyGearPawn.bIsConversing))
			{
				`CClock(Time[8]);
				// look for any possible trigger interactions
				// we don't want trigger icons if we're in the Engaging state
				if ( !IsInState('Engaging') && (!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType >= AT_Trigger))
				{
					if (InteractEvent != None && !MyGearPawn.IsInCover())
					{
						MyGearHud.SetActionInfo(AT_Trigger, InteractEvent.InteractAction);
					}
					else if (MyGearPawn != None)
					{
						if ( GearBombDeliveryGRI(WorldInfo.GRI) != None )
						{
							// if there is an enemy bomb nearby show the action to disable it
							foreach MyGearPawn.VisibleCollidingActors(class'GearTrackBomb', Bomb, 128.0)
							{
								if (Bomb.Health > 0 && Bomb.TeamNum != GetTeamNum())
								{
									break;
								}
							}
						}
						if (Bomb != None)
						{
							MyGearHud.SetActionInfo(AT_Trigger, Bomb.InteractAction);
						}
						else
						{
							// check for fortifications to use
							if (GearPawnRidable_Base(MyGearPawn) == None && !MyGearPawn.IsCarryingAHeavyWeapon() && !MyGearPawn.IsAKidnapper())
							{
								foreach MyGearPawn.TouchingActors(class'GearFortification', Fort)
								{
									if (Fort.CanBeUsedBy(MyGearPawn))
									{
										break;
									}
								}
							}
							if (Fort != None)
							{
								MyGearHud.SetActionInfo(AT_Trigger, Fort.InteractAction);
							}
							else
							{
								// if we don't have an interaction then clear the last one
								MyGearHud.ClearActionInfoByType(AT_Trigger);
							}
						}


					}
				}
				`CUnClock(Time[8]);

				// look for any special moves
				`CClock(Time[10]);
				if ( bShowSpecialMoveTips && (!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType >= AT_SpecialMove) )
				{
					CheckSpecialMoves();
				}
				`CUnClock(Time[10]);

				// look for any pickups
				`CClock(Time[9]);
				if (CanPickupWeapons() && MyGearPawn != None && (!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType >= AT_Pickup))
				{
					CheckForPickups();
				}
				else
				{
					MyGearHud.ClearActionInfoByType(AT_Pickup);
				}
				`CUnClock(Time[9]);

				// check for fortifications to build/repair/upgrade/etc if we're in the deployment phase
				if (MyGearPawn != None && GearGRI_Horde(WorldInfo.GRI) != None && GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications)
				{
					if (!MyGearPawn.IsInCover())
					{
						foreach MyGearPawn.TouchingActors(class'GearFortificationMarker', GFMarker)
						{
							if ( NoZDot(vector(MyGearPawn.Rotation), Normal(GFMarker.Location - MyGearPawn.Location)) > 0.0 &&
								GetFortificationUpgradeLevel(GFMarker.FortificationType) >= 0 )
							{
								if (!GFMarker.FortificationType.static.IsEncroachingOnBuildLocation(MyGearPawn, GFMarker.Location, GFMarker.Rotation))
								{
									GFMarker.FortificationType.static.GetBuildActionInfo(self, Action);
									MyGearHud.SetActionInfo(AT_Fortification, Action);
									break;
								}
							}
						}
					}
					if (GFMarker == None)
					{
						if (ModifyFortification == None)
						{
							MyGearHud.ClearActionInfoByType(AT_Fortification);
						}
						else if (ModifyFortification.GetConditionPct() < 1.0)
						{
							if ( (ModifyFortification.Health > 0 || GetFortificationUpgradeLevel(ModifyFortification.Class) >= ModifyFortification.UpgradeLevel) &&
								!ModifyFortification.static.IsEncroachingOnBuildLocation(Pawn, ModifyFortification.Location, ModifyFortification.Rotation) )
							{
								ModifyFortification.GetRepairActionInfo(self, Action);
								MyGearHud.SetActionInfo(AT_Fortification, Action);
							}
							else
							{
								MyGearHud.ClearActionInfoByType(AT_Fortification);
							}
						}
						else if (ModifyFortification.UpgradeLevel + 1 < ModifyFortification.Cost.length)
						{
							ModifyFortification.GetUpgradeActionInfo(self, Action);
							MyGearHud.SetActionInfo(AT_Fortification, Action);
						}
						else
						{
							MyGearHud.ClearActionInfoByType(AT_Fortification);
						}
					}
				}
				else
				{
					MyGearHud.ClearActionInfoByType(AT_Fortification);
				}

				`CClock(Time[7]);
				// look for vehicles
				if ( bCheckVehicles && (!MyGearHud.ActiveAction.bActive || MyGearHud.ActiveAction.ActionType >= AT_Vehicle) )
				{
					CheckForVehicles();
				}
				`CUnClock(Time[7]);
			}
			/*
			else
			{
				`CClock(Time[11]);
				if ( (MyGearHud != None) && MyGearHUD.ActiveAction.bActive )
				{
					// clear the types not allowed when targeting
					MyGearHud.ClearActionInfoByType(AT_Trigger);
					MyGearHud.ClearActionInfoByType(AT_Pickup);
					MyGearHud.ClearActionInfoByType(AT_SpecialMove);
				}
				`CUnClock(Time[11]);
			}
			*/
		}
		else
		{
			`CClock(Time[13]);
			if ( (MyGearHud != None) && MyGearHUD.ActiveAction.bActive )
			{
				MyGearHud.ClearActionInfoByType(AT_Vehicle);
				MyGearHud.ClearActionInfoByType(AT_Trigger);
				MyGearHud.ClearActionInfoByType(AT_Pickup);
				MyGearHud.ClearActionInfoByType(AT_SpecialMove);
				MyGearHud.ClearActionInfoByType(AT_WeaponActions);
				MyGearHud.ClearActionInfoByType(AT_Fortification);
				MyGearHud.ClearActionInfoByType(AT_FortificationMelee);
			}
			`CUnClock(Time[13]);
		}
	}
	else if ( (MyGearHud != None) && MyGearHUD.ActiveAction.bActive )
	{
		// clear all types
		`CClock(Time[14]);
		MyGearHud.ClearActionInfoByType(AT_Player);
		MyGearHud.ClearActionInfoByType(AT_Trigger);
		MyGearHud.ClearActionInfoByType(AT_Pickup);
		MyGearHud.ClearActionInfoByType(AT_WeaponActions);
		MyGearHud.ClearActionInfoByType(AT_FortificationMelee);
		if (MyGearHud.ActiveAction.ActionName == 'PushObject' && !IsDoingSpecialMove(SM_PushObject))
		{
			MyGearHud.ClearActionInfoByType(AT_SpecialMove);
		}
		else if (MyGearHud.ActiveAction.ActionName == 'SawDuel' && !IsDoingSpecialMove(SM_ChainsawDuel_Follower) && !IsDoingSpecialMove(SM_ChainsawDuel_Leader) && !MyGearPawn.bInDuelingMiniGame)
		{
			MyGearHud.ClearActionInfoByType(AT_SpecialMove);
		}
		`CClock(Time[14]);
	}
	`CUnClock(Overall);

	if (MyGearPawn != None && MyGearPawn.bIsTargeting)
	{
		bTargetingLastFrame = TRUE;
	}
	else
	{
		bCanUseCoopInteractionMenu = FALSE;
		bTargetingLastFrame = FALSE;
	}

`if(`isdefined(UpdateHudActionsPerf))
	GearCheatManager(CheatManager).ForceLog(GetFuncName()@"STATS _--------------------------------------------------_");
	for(Idx=0;Idx<20;Idx++)
	{
		if (Time[Idx] > 0)
		{
			GearCheatManager(CheatManager).ForceLog(GetFuncName()@" -- STAT ["$Idx$"]"@Time[Idx]@"("@(Time[Idx]/Overall)*100.f@"%)");
			SumTotal += Time[Idx];
		}
	}
	GearCheatManager(CheatManager).ForceLog(GetFuncName()@"TOTALS --------------- Overall:"@Overall@"Error:"@Abs(Overall-SumTotal));
`endif
}

/**
 * Return true if player is in cover.
 */
simulated function bool IsInCoverState()
{
	return FALSE;
}

/**
 * Returns true if blind firing.
 */
simulated final function bool IsBlindFiring(ECoverAction PawnCA)
{
	return (PawnCA == CA_BlindRight || PawnCA == CA_BlindLeft || PawnCA == CA_BlindUp);
}

simulated function CalcWeaponFire( Vector StartTrace, Vector EndTrace, out Vector out_HitLocation, out Vector out_HitNormal, out Actor out_HitActor, out ImpactInfo out_HitImpact )
{
	if( Pawn != None && Pawn.Weapon != None)
	{
		out_HitImpact = Pawn.Weapon.CalcWeaponFire( StartTrace, EndTrace );
		out_HitLocation = out_HitImpact.HitLocation;
		out_HitNormal	= out_HitImpact.HitNormal;
		out_HitActor	= out_HitImpact.HitActor;
		if( out_HitActor == None )
		{
			out_HitLocation = EndTrace;
		}
	}
	else
	{
		// use old-school trace. this might hit triggers and such.
		out_HitActor = Trace(out_HitLocation, out_HitNormal, EndTrace, StartTrace, TRUE,, out_HitImpact.HitInfo, TRACEFLAG_Bullet);
	}
}

/**
 * Test code for bullet-attractor method of autoaim.  Experimental
 * for now, we'll see how it feels to the masses.
 */
function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	local Actor			BestTarget;
	local GearPawn		TargetWP;
	local GearWeapon	WW;
	local vector		AttractPt, BaseAimDir, ToAttractorNorm, BestToAttrNorm;
	local Rotator		BaseAimRot;
	local float			Alpha, BestAttrAlpha, AimAssistScale;
	local int			AttractorIdx, NumAttractors;
	local AimAttractor	Attr;
	local vector		UnusedVec1, UnusedVec2;
	local GearAimAssistActor TargetGAAA;
	local Pawn			ShootingPawn;

	ShootingPawn = Pawn;

	// Get default rot so we can return it or base
	// aim assistance calcs off of it, as necessary
	BaseAimRot = (ShootingPawn != None) ? ShootingPawn.GetBaseAimRotation() : Rotation;

	WW = GearWeapon(W);
	if (WW == None)
	{
		return BaseAimRot;
	}

	BestTarget = GetFrictionAdhesionTarget(WW.WeaponRange);
	ShotTarget = Pawn(BestTarget);

	// this is a bit kludgey, but for some weapons (hod), we want steady aiming
	// regardless of camera shake and stuff like that.
	if (WW.bUsePreModCameraRotForAiming)
	{
		BaseAimRot = GearPlayerCamera(PlayerCamera).GameplayCam.LastPreModifierCameraRot;
	}

	if (!WW.bInstantHit)
	{
		// not firing a Gearweapon, what's going on?
		return BaseAimRot;
	}

	// early out check, so we can maybe skip any traces or other geom queries.
	AimAssistScale = bIsTargeting ? WW.AimAssistScaleWhileTargeting : WW.AimAssistScale;
	if( AimAssistScale <= 0.f )
	{
		return BaseAimRot;
	}

	BaseAimDir = vector(BaseAimRot);

	if ( BestTarget == None )
	{
		// no one around worth autoaiming at
		return BaseAimRot;
	}

	TargetWP = GearPawn(BestTarget);
	TargetGAAA = GearAimAssistActor(BestTarget);

	// If no target OR is aiming and close to the target and not shotgun OR target is protected by cover
	if( ((TargetWP == None) && (TargetGAAA == None))
		|| ( VSize(BestTarget.Location - ShootingPawn.Location) < 128 )
		|| ( bIsTargeting && ( VSize(BestTarget.Location - ShootingPawn.Location) < 512 ) && ( GearWeap_ShotGun(WW) == none ) )
		|| ((TargetWP != None) && TargetWP.IsInCover() && TargetWP.IsProtectedByCover(Vector(BaseAimRot)))
		)
	{
		// No aim adjust
		return BaseAimRot;
	}

	// aim at target - help with leading also
	// @todo (if this passes poc stage)
	// - handle non-instant-hit weapons
	// - it's possible in multiplayer to have different autoaim params,
	//    it would be good to unify the values so this isn't a subtle bug later

	BaseAimDir = vector(BaseAimRot);

	if (TargetWP != None)
	{
		// don't do aim attraction if base aim will hit target (it's presumably unneeded
		if (!TraceComponent(UnusedVec1, UnusedVec2, TargetWP.Mesh, (StartFireLoc + BaseAimDir*50000), StartFireLoc))
		{
			NumAttractors = TargetWP.AimAttractors.Length;

			for (AttractorIdx=0; AttractorIdx<NumAttractors; ++AttractorIdx)
			{
				Attr = TargetWP.AimAttractors[AttractorIdx];

				// get world pos of attractor
				AttractPt = TargetWP.Mesh.GetBoneLocation(Attr.BoneName);

				EvalAimAttractor(Attr, Alpha, ToAttractorNorm, StartFireLoc, BaseAimDir, AttractPt, AimAssistScale);

				// decide which is the best attractor and use it
				if ( (Alpha > BestAttrAlpha) && FastTrace(AttractPt, StartFireLoc) )
				{
					//`log("Attr " @ AttractorIdx @ Alpha@BestTarget@AttractDot@DotExtentOuter@DotExtentInner@AttractPt);
					BestAttrAlpha = Alpha;
					BestToAttrNorm = ToAttractorNorm;
				}
			}
		}
	}
	else if (TargetGAAA != None)
	{
		TargetGAAA.GetAimAttractorRadii(Attr.InnerRadius, Attr.OuterRadius);
		EvalAimAttractor(Attr, BestAttrAlpha, BestToAttrNorm, StartFireLoc, BaseAimDir, TargetGAAA.Location, AimAssistScale);
	}

	//`log("AimAttracted to "@TargetWP@BestAttrAlpha);
	return RLerp(BaseAimRot, rotator(BestToAttrNorm), BestAttrAlpha, TRUE);
}

simulated protected final function EvalAimAttractor(const out AimAttractor Attr, out float AttractorAlpha, out vector ToAttractorNorm, vector StartFireLoc, vector BaseAimDir, vector AttractPt, float AimAssistScale)
{
	local float ToAttractorDist, DotExtentInner, DotExtentOuter;
	local float AttractDot, ToAttractorDistSq;

	// init to no attraction
	AttractorAlpha = 0.f;

	if (Attr.OuterRadius == 0.0f || Attr.InnerRadius == 0.0f)
	{
		return;
	}

	// vector from shot origin to attractor
	ToAttractorNorm = AttractPt - StartFireLoc;
	ToAttractorDist = VSize(ToAttractorNorm);
	if (ToAttractorDist >= 0.f)
	{
		ToAttractorDistSq = Square(ToAttractorDist);
		ToAttractorNorm /= ToAttractorDist;

		// actual dot of my aim
		AttractDot = BaseAimDir dot ToAttractorNorm;

		// in front?
		if (AttractDot > 0.0f)
		{
			// solving for cos(angle)
			DotExtentOuter = ToAttractorDist / Sqrt(Square(Attr.OuterRadius * AimAssistScale) + ToAttractorDistSq);
			DotExtentInner = ToAttractorDist / Sqrt(Square(Attr.InnerRadius * AimAssistScale) + ToAttractorDistSq);

			// how much attraction do we get?
			AttractorAlpha = (AttractDot - DotExtentOuter) / (DotExtentInner - DotExtentOuter);
			AttractorAlpha = FClamp(AttractorAlpha, 0.f, 1.f);
		}
	}
}


/************************************************************************************
 * Assess Mode
 ***********************************************************************************/

/**
 * Enables the assess mode, so as to notify the HUD that it should
 * start rendering all possible interactions.
 */
function EnableAssessMode()
{
	`assert(!bAssessMode);
	bAssessMode = true;
	// notify hud
	if (MyGearHud != None)
	{
		MyGearHud.EnableAssessMode();
	}
	StartPostProcessOverride(eGPP_Taccom, false, false);
	// play an opening sound
	PlaySound(SoundCue'Interface_Audio.Interface.TaccomOpen01Cue', true);

	// Don't fire weapons during taccom
	StopFiringWeapon();
	StopAltFiringWeapon();
	MyGearPawn.StopMeleeAttack();
}

/**
 * Disables the assess mode.
 */
function DisableAssessMode()
{
	if (bAssessMode)
	{
		bAssessMode = FALSE;
		// notify hud
		MyGearHud.DisableAssessMode();
		StopPostProcessOverride(eGPP_Taccom, MyGearHud.TotalTaccomFadeTime);
		CheckForPostProcessReset(self);
		// play closing sound
		PlaySound(SoundCue'Interface_Audio.Interface.TaccomClose01Cue', true);
	}
}

/**
 * Returns our GearPRI.  Wow.
 */
final function GearPRI GetPRI()
{
	return GearPRI(PlayerReplicationInfo);
}

/**
 * Disable any current input and set the flag that will prevent future input
 * @PARAM bIsPOI - whether we want to force the POI button to call it's release function,
 *		since the POI button CAN be one of the buttons that reenables the input we sometimes want
 *		to force it and sometimes not.
 */
function DisableInput(bool bDisableButtons, bool bDisableMovement, bool bDisableLook, bool bIsPOI=false)
{
	local GearPlayerInput_Base GPIB;

	if (bDisableButtons)
	{
		// If the input was previously enabled, disable it.
		if ( InputIsDisabledCount == 0 )
		{
			GPIB = GearPlayerInput_Base(PlayerInput);
			if (GPIB != none)
			{
				GPIB.DisableButtonInput(bIsPOI);
			}
			else
			{
//@todo joeg/matto - Remove once the bug is diagnosed properly
				ScriptTrace();
			}
		}
		// increment the disabled count
		InputIsDisabledCount++;
	}
	// disable movement input
	if (bDisableMovement)
	{
		IgnoreMoveInput(TRUE);
	}
	// disable camera input
	if (bDisableLook)
	{
		IgnoreLookInput(TRUE);
	}
}

/** Enable the input */
function EnableInput(bool bEnableButtons, bool bEnableMovement, bool bEnableLook)
{
	if (bEnableButtons && InputIsDisabledCount > 0)
	{
		// decrement the disabled counter
		InputIsDisabledCount--;
		if (InputIsDisabledCount == 0)
		{
			GearPlayerInput_Base(PlayerInput).EnableButtonInput();
//@todo joeg/matto - Remove once the bug is diagnosed properly
			if (GearPlayerInput_Base(PlayerInput) == None)
			{
				ScriptTrace();
			}
		}
	}
	// free movement input
	if (bEnableMovement)
	{
		IgnoreMoveInput(FALSE);
	}
	// free camera input
	if (bEnableLook)
	{
		IgnoreLookInput(FALSE);
	}
}

/** This will apply the values from the SensistivityScaling which are found in the .ini **/
function ApplySensitivityScaling()
{
	local float MultiPlier;

	MultiPlier = GetSensitivityMultiplier();

	PlayerInput.aTurn *= MultiPlier;
	PlayerInput.aLookUp	*= MultiPlier;
}

/** notification that client pressed the button to keep pushing an object */
reliable server function ServerKeepPushing()
{
	if (MyGearPawn != None)
	{
		// if we're already pushing an object
		if (MyGearPawn.IsDoingSpecialMove(SM_PushObject))
		{
			// then keep pushing
			GSM_PushObject(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]).ButtonPressed();
		}
		else if (MyGearPawn.CanDoSpecialMove(SM_PushObject))
		{
			// otherwise start a new push
			ServerDictateSpecialMove(SM_PushObject);
		}
		else
		{
			// can't do anything, force client to stop pushing
			ServerDictateSpecialMove(SM_None);
		}
	}
}

/** Returns TRUE if the button is currently held. */
final function bool IsButtonActive(EGameButtons Button, optional bool bRaw)
{
	if ( PlayerInput == None )
	{
		`warn("PlayerInput is NULL - should NOT be called on nonlocal players!");
		ScriptTrace();
		return false;
	}

	return GearPlayerInput_Base(PlayerInput).IsButtonActive( Button, bRaw );
}

/** Forces a button to release, optionally skipping the handler */
final function ForceButtonRelease(EGameButtons Button, optional bool bSilent)
{
	if (GearPlayerInput_Base(PlayerInput) != None)
	{
		GearPlayerInput_Base(PlayerInput).ForceButtonRelease( Button, bSilent );
	}
}

simulated final function bool CanSwitchWeapons()
{
	local GearWeapon Weap;
	local WalkVolume WV;
	local Weapon W;

	// First check the bool which overrides all weapon switching
	if (bPreventWeaponSwitching)
	{
		return false;
	}

	if (MyGearPawn != None)
	{
		if (GearPawn_SilverbackBase(MyGearPawn) != None)
		{
			return FALSE;
		}

		// check for walk volume that disallows using a weapon
		WV = WalkVolume(MyGearPawn.PhysicsVolume);
		if (WV != None && WV.bHolsterWeaponOnEnter && WV.bActive)
		{
			return false;
		}

		if (MyGearPawn.IsDBNO() || MyGearPawn.Physics == PHYS_RigidBody)
		{
			return FALSE;
		}

		// we can't switch if we're meleeing while holding a meatshield or boom shield because that changes the animations
		if (MyGearPawn.bDoingMeleeAttack && (MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield()))
		{
			return false;
		}

		// no changing weapons when about to pick one up
		if (IsTimerActive(nameof(PickingUpAWeapon)))
		{
			return false;
		}

		// no weapon switch if special move disallows it
		if (MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bDeferWeaponSwitch && (!MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bCanFireWeapon || !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bCanSwitchWeapons))
		{
			return FALSE;
		}
		Weap = MyGearPawn.MyGearWeapon;
		if (Weap != None &&
			Weap.CurrentFireMode == class'GearWeapon'.const.FIREMODE_FAILEDACTIVERELOAD || Weap.ShouldPreventWeaponSwitch() )
		{
			return FALSE;
		}
	}

	// if we have only one weapon and it is equipped, then we have nothing to switch to
	if (Pawn != None && Pawn.InvManager != None)
	{
		foreach Pawn.InvManager.InventoryActors(class'Weapon', W)
		{
			if (W != Pawn.Weapon)
			{
				return true;
			}
		}
		return false;
	}
	else
	{
		return true;
	}
}

/**
 * Overridden to remove the UT pickup message.
 */
function HandlePickup(Inventory Inv)
{
}

/**
 * Check if a weapon switch should be deferred
 *
 * @return TRUE if we're covering head or doing a special move that defers weapon switch
 */
function bool ShouldDeferWeaponSwitch()
{
	return MyGearPawn.bCoveringHead || (MyGearPawn.IsDoingASpecialMove() && MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].bDeferWeaponSwitch);
}

/** Switches the player's weapon based on the slot passed in */
final function ProcessWeaponSwitch( GearPawn.EAttachSlot Slot )
{
	local GearInventoryManager InvManager;
	local Inventory InvInSlot;
	local GearPawn InventoryPawn;
	local GearPawnRidable_Base RidablePawn;
	local bool bAnyDPadPressed;

	// if we can switch weapons at the moment
	if (MyGearPawn != None && CanSwitchWeapons())
	{
		// See if this is a ridable pawn, and if so we must grab the driver
		RidablePawn = GearPawnRidable_Base(MyGearPawn);
		InventoryPawn = (RidablePawn != None) ? RidablePawn.Driver : MyGearPawn;

		if (InventoryPawn != None)
		{
			// Bring up the selector UI
			InvManager = GearInventoryManager(InventoryPawn.InvManager);
			if (InvManager != None)
			{
				InvManager.bShowWeaponSlots = TRUE;
				InvManager.WeapSelHUDTimeCount = 0;
				InvInSlot = InvManager.GetInventoryInSlot(Slot);

				if (InvInSlot != None)
				{
					InvManager.SetHighlightedWeaponSlot(Slot);
				}
				else
				{
					InvManager.SetHighlightedWeaponSlot(GearWeapon(InventoryPawn.Weapon).CharacterSlot);
				}
				if (InvInSlot != InventoryPawn.Weapon)
				{
					// Drop a meatshield if we're a kidnapper
					if (InventoryPawn.IsAKidnapper())
					{
						ServerKidnapEndedByWeaponSwitch();
						EndSpecialMove();
					}
					// drop metal shield
					if (InventoryPawn.IsCarryingShield() && !GearWeapon(InvInSlot).bCanEquipWithShield)
					{
						InventoryPawn.DropShield();
						if (Role < ROLE_Authority)
						{
							InventoryPawn.ServerDropShield();
						}
					}

					// if you are covering head or doing a special move that requests the switch happen after the move, try back later!
					if (ShouldDeferWeaponSwitch())
					{
						//`log("deferring weapon switch" @ `showvar(MyGearPawn.SpecialMove));
						SetTimer(0.1, false, nameof(DeferredProcessWeaponSwitch));
					}
					//Otherwise, switch it!
					else
					{
						InvManager.SetWeaponFromSlot(Slot);

						bAnyDPadPressed = IsButtonActive(GB_DPad_Up) || IsButtonActive(GB_DPad_Left) || IsButtonActive(GB_DPad_Down) || IsButtonActive(GB_DPad_Right);

						// if not pressing any direction then turn off the selector
						if (!bAnyDPadPressed)
						{
							StopShowingWeaponSelector();
						}
					}
				}
			}
		}
	}
}

/** notification that the client is going to end the kidnapper special move by switching weapons, used to set the flag on the SM */
reliable server final function ServerKidnapEndedByWeaponSwitch()
{
	if (MyGearPawn != None && MyGearPawn.SpecialMove == SM_Kidnapper)
	{
		GSM_Kidnapper(MyGearPawn.SpecialMoves[SM_Kidnapper]).bEndedByWeaponSwitch = true;
	}
}

function DeferredProcessWeaponSwitch()
{
	local GearInventoryManager InvManager;
	local GearPawn InventoryPawn;
	local GearPawnRidable_Base RidablePawn;

	// if we can switch weapons at the moment
	if (MyGearPawn != None && CanSwitchWeapons())
	{
		// See if this is a ridable pawn, and if so we must grab the driver
		RidablePawn = GearPawnRidable_Base(MyGearPawn);
		InventoryPawn = (RidablePawn != None) ? RidablePawn.Driver : MyGearPawn;

		if (InventoryPawn != None)
		{
			InvManager = GearInventoryManager(InventoryPawn.InvManager);
			if (InvManager != None)
			{
				ProcessWeaponSwitch(InvManager.HighlightedWeaponSlot);
			}
		}
	}
	else
	{
		// the weapon select is most likely still showing, just nuke it
		StopShowingWeaponSelector();
	}
}

/** Hook called from HUD actor. Gives access to HUD and Canvas */
function DrawHUD( HUD H )
{
	local GearPawnRidable_Base RidablePawn;
	local Pawn InventoryPawn;

	RidablePawn = GearPawnRidable_Base(Pawn);
	InventoryPawn = (RidablePawn != None) ? RidablePawn.Driver : Pawn;

	if (InventoryPawn != None)
	{
		InventoryPawn.DrawHUD(H);
	}

	if (PlayerInput != None)
	{
		PlayerInput.DrawHUD(H);
	}
}

/** Closes the weapon switch selector UI */
final function StopShowingWeaponSelector()
{
	local GearInventoryManager InvManager;
	local GearPawnRidable_Base RidablePawn;

	// See if we need to grab the driver of a ridablepawn's inventory
	RidablePawn = GearPawnRidable_Base(Pawn);
	if (RidablePawn != None &&
		RidablePawn.Driver != None)
	{
		InvManager = GearInventoryManager(RidablePawn.Driver.InvManager);
	}
	else
	{
		InvManager = GearInventoryManager(Pawn.InvManager);
	}

	if (InvManager != None)
	{
		InvManager.bShowWeaponSlots = FALSE;
		InvManager.WeapSelHUDTimeCountSpeedMult = 1.0f;
	}
}

exec function PlayVehicleHorn()
{
	local GearVehicle V;

	V = GearVehicle(Pawn);
	if ( (V != None) && (V.Health > 0) && (WorldInfo.TimeSeconds - LastHornPlayedTime > 3.0)  )
	{
		ServerPlayVehicleHorn();
		LastHornPlayedTime = WorldInfo.TimeSeconds;
	}
}

unreliable server function ServerPlayVehicleHorn()
{
	local GearVehicle V;

	V = GearVehicle(Pawn);
	if ( (V != None) && (V.Health > 0) )
	{
		V.PlayHorn();
	}
}

/** The input system has detected the right bumper has been pressed */
function PressedRightBumper()
{
	local GearVehicleBase GV;
	local GearWeapon GW;
	local Turret_MultiTurretBase MT;

	if (IsSpectating())
	{
	}
	else if (MyGearPawn != None && MyGearPawn.MyGearWeapon != None)
	{
		MyGearPawn.MyGearWeapon.ForceReload();
	}
	else if (MyGearPawn == None)
	{
		GV = GearVehicleBase(Pawn);
		if (GV != None)
		{
			GW = GearWeapon(GV.Weapon);
			if (GW != None)
			{
				GW.ForceReload();
			}
		}

		MT = Turret_MultiTurretBase(Pawn);
		if (MT != None)
		{
			MT.ServerAttemptReload();
		}
	}
}

/** The input system has detected the right bumper has been released */
function ReleasedRightBumper()
{
	SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
	if (MyGearHud != None)
	{
		MyGearHud.UpdateOutOfAmmoTime(class'GearWeapon'.const.RELOAD_FIREMODE);
	}
}

/**
 * If a coop interaction offer is nearby, accept it.
 *
 * @return true if coop interaction attempted
 */
function bool AttemptCoopInteraction()
{
	if (CanDoSpecialMove(SM_TradeWeapons_Leader))
	{
		MyGearPawn.WeaponForWeaponSwap = MyGearPawn.MyGearWeapon;
		ServerTradeWeaponsAccept();
		return TRUE;
	}

	return FALSE;
}

/** Server side function for the trade weapons coop interaction */
reliable server function ServerTradeWeaponsAccept()
{
	local GearPawn GP;

	if (CanDoSpecialMove(SM_TradeWeapons_Leader))
	{
		foreach MyGearPawn.VisibleCollidingActors(class'GearPawn', GP, MyGearPawn.CoopInteractionDistance, MyGearPawn.Location, TRUE)
		{
			if (GP.IsDoingSpecialMove(SM_TradeWeapons))
			{
				MyGearPawn.WeaponForWeaponSwap = MyGearPawn.MyGearWeapon;
				// need to replicate animation info of finishing it
				GP.ServerDoSpecialMove(SM_TradeWeapons_Leader, TRUE, MyGearPawn, 1);
				break;
			}
		}
	}
}

/**
 * Server side function for the trade weapons w/ a bot coop interaction
 *
 * @param GP - the bot to trade with
 */
reliable server function ServerTradeWeaponsWithBot(GearPawn GP)
{
	local float Distance;

	// We're forcing the special move since we're trusting the client
	// Make sure that the AI didn't start a special move while this was in-flight
	if (GP.IsDoingASpecialMove())
	{
		return;
	}

	Distance = VSize(MyGearPawn.Location-GP.Location);
	GP.WeaponForWeaponSwap = GP.MyGearWeapon;
	if (Distance >= MyGearPawn.TradeAnimDistance)
	{
		MyGearPawn.ServerDoSpecialMove(SM_TradeWeapons_Leader, TRUE, GP, 2);
	}
	else
	{
		MyGearPawn.ServerDoSpecialMove(SM_TradeWeapons_Leader, TRUE, GP, 1);
	}
}

/**
 * Server side function for the trade weapons w/ a bot coop interaction
 *
 * @param GP - the bot to trade with
 */
reliable server function ServerTradeSecondaryWeaponsWithBot(GearPawn GP)
{
	local float Distance;

	// We're forcing the special move since we're trusting the client
	// Make sure that the AI didn't start a special move while this was in-flight
	if (GP.IsDoingASpecialMove())
	{
		return;
	}

	Distance = VSize(MyGearPawn.Location-GP.Location);
	if (Distance >= MyGearPawn.TradeAnimDistance)
	{
		MyGearPawn.ServerDoSpecialMove(SM_TradeWeaponsSecondaryAI, TRUE, GP, 2);
	}
	else
	{
		MyGearPawn.ServerDoSpecialMove(SM_TradeWeaponsSecondaryAI, TRUE, GP, 1);
	}
}

/** Called by GearPlayerInput to switch weapons */
function PressedDPad(EGameButtons Button)
{
	local GearPawn.EAttachSlot Slot;

	// Figure out which slot was pressed and start a timer for dropping the weapon
	if (CanSwitchWeapons())
	{
		switch (Button)
		{
			case GB_DPad_Up:
				Slot = EASlot_Belt;
				break;
			case GB_DPad_Left:
				Slot = EASlot_LeftShoulder;
				break;
			case GB_DPad_Right:
				Slot = EASlot_RightShoulder;
				break;
			case GB_DPad_Down:
				Slot = EASlot_Holster;
				break;
			default:
				Slot = EASlot_None;
				break;
		}

		ProcessWeaponSwitch( Slot );
	}
}

/** Released the Dpad - called by GearPlayerInput */
final function ReleasedDPad(EGameButtons Button)
{
	local bool bAnyDPadPressed;

	if (MyGearPawn != None)
	{
		bAnyDPadPressed = IsButtonActive(GB_DPad_Up) || IsButtonActive(GB_DPad_Left) || IsButtonActive(GB_DPad_Down) || IsButtonActive(GB_DPad_Right);

		// if not pressing any direction then turn off the selector
		if (!bAnyDPadPressed)
		{
			StopShowingWeaponSelector();
		}
	}
}

/**
 * Drops the weapon in a particular weapon slot of the inventory manager
 *
 * @param AttachSlot - The enum of the inventory slot we are dropping
 */
final server reliable function DropWeaponInInventorySlot(EAttachSlot AttachSlot)
{
	local GearInventoryManager InvManager;
	local bool bDroppedCurrWeapon;
	local GearWeapon Inv;

	// Make sure the slot is valid
	if (MyGearPawn != None && AttachSlot != EASlot_None && GearGame(WorldInfo.Game).bCanDropBasicWeapons)
	{
		// Make sure there's a valid inventory manager
		InvManager = GearInventoryManager(MyGearPawn.InvManager);
		if (InvManager != None)
		{
			// Make sure there's a valid weapon in the slot
			Inv = GearWeapon(InvManager.GetInventoryInSlot(AttachSlot));
			//DO NOT drop the gas tank, no matter what
			if (Inv != None && GearWeap_GasTankBase(Inv) == None)
			{
				// Determine if the weapon being dropped is the currently selected weapon
				bDroppedCurrWeapon = Inv == MyGearPawn.MyGearWeapon;
				// Drop the weapon
				MyGearPawn.TossInventory(Inv);
				// If the dropped weapon is the current weapon auto switch to a new one
				if (bDroppedCurrWeapon)
				{
					InvManager.AutoSwitchWeapon();
				}
			}
		}
	}
}

final function bool CheckWeaponSwitchByWheel()
{
	local GearInventoryManager InvManager;
	local GearPawn.EAttachSlot Slot;
	local bool bResult;

	if( (MyGearPawn != None) && !MyGearPawn.bIsConversing )
	{
		InvManager = GearInventoryManager(Pawn.InvManager);
		if( InvManager != None )
		{
			if( CanSwitchWeapons() )
			{
				Slot = InvManager.HighlightedWeaponSlot;
				if( (Slot != EASlot_None) && (InvManager.GetInventoryInSlot(Slot) != None) )
				{
					// Only switch weapons if it is actually a change in slots
					if( Slot != MyGearPawn.MyGearWeapon.CharacterSlot )
					{
						InvManager.WeapSelHUDTimeCountSpeedMult = 3.0f;
						ClientPlaySound( SoundCue'Interface_Audio.Interface.WeaponSelectConfirmCue' );
						InvManager.SetWeaponFromSlot( Slot );
						bResult = TRUE;
					}
				}
			}

			// Turn off selector
			InvManager.bShowWeaponSlots = FALSE;
		}
	}

	// Clear timer in case function was called before timer expired
	ClearTimer( 'CheckWeaponSwitchByWheel' );

	return bResult;
}

/** Switch weapon based on direction */
final function SwitchWeapon( bool bForward )
{
	local GearPawn.EAttachSlot Slot;
	local GearInventoryManager InvManager;
	local bool bWeaponOverride;

	// Check for weapon override
	if( MyGearPawn != None && MyGearPawn.MyGearWeapon != None )
	{
		bWeaponOverride = bForward ? MyGearPawn.MyGearWeapon.DoOverrideNextWeapon() : MyGearPawn.MyGearWeapon.DoOverridePrevWeapon();
	}

	if ( (MyGearPawn != None) && !MyGearPawn.bIsConversing && !bIsTargeting && !bWeaponOverride )
	{
		InvManager = GearInventoryManager(Pawn.InvManager);
		if( InvManager != None )
		{
			// init slot
			Slot = EASlot_None;

			if( `TimeSince( LastCycleWeaponTime ) > 0.f )
			{
				// Show slots
				InvManager.bShowWeaponSlots = TRUE;

				// Otherwise, grab previous weapon slot
				Slot = bForward ?  InvManager.GetNextSlot(InvManager.HighlightedWeaponSlot) : InvManager.GetPrevSlot(InvManager.HighlightedWeaponSlot);
			}
			LastCycleWeaponTime = WorldInfo.TimeSeconds;

			if( Slot != EASlot_None )
			{
				// Highlight the appropriate slot
				InvManager.SetHighlightedWeaponSlot( Slot );
				InvManager.WeapSelHUDTimeCount = 0;

				// Set timer to actually switch weapons
				SetTimer( 0.75f, FALSE, nameof(CheckWeaponSwitchByWheel) );
			}
		}
	}
	else if( bMouseWheelZoom && bIsTargeting )
	{
		// Otherwise, toggle zoom when targeting
		if( MyGearPawn.MyGearWeapon != None )
		{
			MyGearPawn.MyGearWeapon.HandleButtonPress( bForward ? 'ZoomOut' : 'ZoomIn' );
		}
	}
}

/** Overridden to support mouse wheel weapon switching and target zooming */
exec function PrevWeapon()
{
	if( CanSwitchWeapons() )
	{
		// If weapons are all loaded (debug) we will use the old weapon switch method
		if ( bWeaponsLoaded )
		{
			Super.PrevWeapon();
		}
		// Else use the new method which will clamp the weapons to the 4 slots
		else
		{
			SwitchWeapon( FALSE );
		}
	}
}

/** Overridden to support mouse wheel weapon switching and target zooming */
exec function NextWeapon()
{
	if( CanSwitchWeapons() )
	{
		// If weapons are all loaded (debug) we will use the old weapon switch method
		if ( bWeaponsLoaded )
		{
			Super.NextWeapon();
		}
		// Else use the new method which will clamp the weapons to the 4 slots
		else
		{
			SwitchWeapon( TRUE );
		}
	}
}

simulated function Pawn GetMyRealPawn()
{
	local Pawn MyPawn;
	local Vehicle WPVehicle;
	local GearPawn GP;

	MyPawn = Pawn;
	WPVehicle = Vehicle(Pawn);
	if ( WPVehicle != None )
	{
		GP = GearPawn(WPVehicle.Driver);
		if ( GP != None )
		{
			MyPawn = WPVehicle.Driver;
		}
		else
		{
			GP = GearPawn(ViewTarget);
			if ( GP != None )
			{
				MyPawn = Pawn(ViewTarget);
			}
		}
	}

	return MyPawn;
}

/** Player induced look at - pressed the "look at" input */
final function TryPOILookAt()
{
	ProcessPOI( None, true );
	ClearPOIIconDurations();
}

/** Player induced look away from POI - unpressed the "look at" input */
final function TryPOILookAway()
{
	local GearPointOfInterest CurrPOI;

	// See if there is a current POI
	CurrPOI = GearPointOfInterest(GetCameraFocusActor());
	if ( CurrPOI != None )
	{
		// See if the current POI is still being forced
		if ( IsTimerActive('ForceLookDurationExpired') )
		{
			return;
		}
	}

	StopForceLookAtPointOfInterest( true );
}

/** Timer callback function called when the force-look duration is over */
final function ForceLookDurationExpired()
{
	if ( !bLookingAtPointOfInterest || !IsHoldingPOIButton(TRUE) )
	{
		StopForceLookAtPointOfInterest( false );
	}
}


/**
 * Find the best POI to look at
 * @param POIToTest - a POI to test against, if the best POI has the same priorty as this one, the POIToTest will take precedence
 */
final simulated function GearPointOfInterest FindBestPOIToLookAt( optional GearPointOfInterest POIToTest )
{
	local GearPointOfInterest POI, BestPOI;
	local GearPawn GP;
	local int POIPriority, CurrPriority;
	local bool bSetBestPOI;
	local Pawn Myself;

	// set the initial ratings
	BestPOI = POIToTest;
	POIPriority = (BestPOI == None) ? -1 : BestPOI.LookAtPriority;

	// then look for an active point of interest based on priority
	foreach EnabledPointsOfInterest(POI)
	{
		bSetBestPOI = FALSE;
		Myself = GetMyRealPawn();
		// if enabled, and not attached or not attached to my pawn
		if ( POI.bEnabled && (POI.AttachedToActor == None || POI.AttachedToActor != Myself) )
		{
			CurrPriority = POI.GetLookAtPriority( self );
			if ( CurrPriority >= 0 )
			{
				if ( (BestPOI == None) ||
					(CurrPriority > POIPriority) ||
					((CurrPriority == POIPriority) && (POIToTest == None || BestPOI != POIToTest) && (VSizeSq(POI.Location - Pawn.Location) < VSizeSq(BestPOI.Location - Pawn.Location))) )
				{

					// If we're reviving, we only care about teammates
					if ( MyGearPawn != None && MyGearPawn.IsDBNO() )
					{
						// See if this is a gearpawn
						if ( POI.AttachedToActor != None )
						{
							GP = GearPawn(POI.AttachedToActor);
							if ( (GP != None) && (GP != Pawn) && GP.IsSameTeam(Pawn) )
							{
								bSetBestPOI = TRUE;
							}
						}
					}
					// if we're not reviving we care about all POIs
					else
					{
						bSetBestPOI = TRUE;
					}

					// set the best POI
					if ( bSetBestPOI )
					{
						BestPOI = POI;
						POIPriority = CurrPriority;
					}
				}
			}
		}
	}

	return BestPOI;
}

simulated function ReenableMovementDuringPOI()
{
	// do nothing if no longer looking at POI
	if (bLookingAtPointOfInterest)
	{
		EnableInput(false, true, false);
	}
}

final simulated function ForceLookAtPointOfInterest( optional bool bUserInstigated, optional GearPointOfInterest POIToForce )
{
	local GearPlayerCamera Cam;
	local ActionInfo Action;
	local float POICamFOV;
	local int IndexInList;
	local bool bDoForceLookTimer, bShouldDisableMovement;

	// disallow forcelook while chainsawing
	if ( bUserInstigated && (MeleeAdhesionTarget != None) )
	{
		return;
	}

	// If we have a camera
	Cam = GearPlayerCamera(PlayerCamera);
	if ( Cam != None )
	{
		// Find the best POI if one was not provided
		if ( POIToForce == None )
		{
			POIToForce = FindBestPOIToLookAt();
		}

		// Already looking at this POI so return
		if ( GetCameraFocusActor() == POIToForce )
		{
			return;
		}
		// Stop an already existing force look
		else if ( bLookingAtPointOfInterest )
		{
			StopForceLookAtPointOfInterest(FALSE);
		}

		// Focus the camera on the new POI
		if ( POIToForce != None )
		{
			// Set the camera up to look at the POI
			POICamFOV = (Vehicle(Pawn) == None || GearVehicle(Pawn) != None || GearWeaponPawn(Pawn) != None) ? POIToForce.GetDesiredFOV(Cam.Location) : 0.f;
			SetFocusPoint(FALSE, POIToForce, PointOfInterestLookatInterpSpeedRange, vect2d(1.f,1.f), POICamFOV, TRUE, TRUE, TRUE);
			bLookingAtPointOfInterest = TRUE;
			POIToForce.LookAtCount++;

			// Play a sound if the player pressed the button
			if( bUserInstigated )
			{
				Pawn.PlaySound( SoundCue'Interface_Audio.Forcelook_Enter_cue' );
			}

			// for userinstigated looks, only disable movement on first look
			bShouldDisableMovement = POIToForce.DisableMovementDuration > 0.f && (!bUserInstigated || POIToForce.LookAtCount == 1);
			if (bShouldDisableMovement)
			{
				// set timer to re-enable movement
				SetTimer(POIToForce.DisableMovementDuration,, nameof(ReenableMovementDuringPOI));
			}

			// Stop the player from pressing buttons
			DisableInput(true, bShouldDisableMovement, false, true);

			// Show the text to the HUD
			if ( MyGearHud != None )
			{
				Action.ToolTipText = POIToForce.GetDisplayName();
				MyGearHud.SetActionInfo( AT_ForceLook, Action );
			}

			// If there is a force look duration
			if ( (POIToForce.ForceLookType != ePOIFORCELOOK_None) && (POIToForce.ForceLookDuration > 0.0f) )
			{
				bDoForceLookTimer = true;

				// If this is a player-induced force look, make sure we haven't done it already
				if ( POIToForce.ForceLookType != ePOIFORCELOOK_None )
				{
					IndexInList = EnabledPointsOfInterest.Find( POIToForce );
					if ( (IndexInList == INDEX_NONE) || POILookedAtList[IndexInList] )
					{
						bDoForceLookTimer = false;
					}
				}

				if ( bDoForceLookTimer )
				{
					SetTimer( POIToForce.ForceLookDuration, FALSE, nameof(ForceLookDurationExpired) );
				}
			}

			// Mark this POI as having been seen
			IndexInList = EnabledPointsOfInterest.Find( POIToForce );
			if ( IndexInList != INDEX_NONE )
			{
				POILookedAtList[IndexInList] = true;
			}

			// Force head track if desired
			if (POIToForce.bAffectHead)
			{
				MyGearPawn.SetHeadTrackActor(POIToForce, '', TRUE);
			}

			// Have the server see if it needs to fire a kismet link
			ServerFirePOIActionOutputLink( POIToForce, eMPOIOUTPUT_LookAt );
		}
	}
}

/** Stop the current POI from being looked at */
final function StopForceLookAtPointOfInterest( optional bool bUserInstigated )
{
	local GearPlayerCamera Cam;
	local GearPointOfInterest POI;

	ClearTimer( nameof(ForceLookDurationExpired) );
	ClearTimer( nameof(ReenableMovementDuringPOI) );


	Cam = GearPlayerCamera(PlayerCamera);
	if ( bLookingAtPointOfInterest )
	{
		POI = GearPointOfInterest(GetCameraFocusActor());
		if ( POI != None )
		{
			// Have the server see if it needs to fire a kismet link
			ServerFirePOIActionOutputLink( POI, eMPOIOUTPUT_LookAway );
		}

		bLookingAtPointOfInterest = FALSE;

		if ( MyGearHud != None )
		{
			MyGearHud.ClearActionInfoByType( AT_ForceLook );
		}

		if ( Cam != None )
		{
			ClearFocusPoint(FALSE);
			ClientClearForcedCameraFOV();
			if( bUserInstigated == TRUE )
			{
				Pawn.PlaySound( SoundCue'Interface_Audio.Forcelook_Exit_cue' );
			}
			EnableInput(true,true,false);

			if (POI != None && POI.bAffectHead && MyGearPawn != None)
			{
				MyGearPawn.SetHeadTrackActor(None);
				if (MyGearPawn.HeadTrackDelayCountDown < 2.0f)
				{
					MyGearPawn.HeadTrackDelayCountDown = 2.0f;
				}
			}
		}
	}
}

/** Function that has the server fire the output link for the action of a POI */
final reliable server function ServerFirePOIActionOutputLink( GearPointOfInterest POI, int POIOutputType )
{
	if ( (POI != None) && (POI.POIAction != None) )
	{
		// Fire link
		POI.POIAction.OutputLinks[POIOutputType].bHasImpulse = true;

		// Set the enable flag false if we're looking away
		if ( POIOutputType == eMPOIOUTPUT_LookAway )
		{
			POI.POIAction.POI_bEnabled = false;
		}
	}
}

simulated function SetFocusPoint(bool bFromKismet, Actor FocusActor, vector2d InterpSpeedRange, vector2d InFocusFOV, optional float CameraFOV, optional bool bAlwaysFocus, optional bool bAdjustCamera, optional bool bIgnoreTrace, optional Name FocusBoneName)
{
	// tell camera to focus on the given actor
	GearPlayerCamera(PlayerCamera).GameplayCam.SetFocusOnActor(FocusActor, FocusBoneName, InterpSpeedRange, InFocusFOV, CameraFOV, bAlwaysFocus, bAdjustCamera, bIgnoreTrace);

	// needs to happen AFTER setfocuspoint, since setfocuspoint will clear it
	bCameraLookAtIsFromKismet = bFromKismet;
}

simulated function ClearFocusPoint(bool bFromKismet, optional bool bForceLeaveRotation)
{
	local bool bLeaveRotation;
	local GearPointOfInterest CurrPOI;

	if ( bFromKismet == bCameraLookAtIsFromKismet )
	{
		CurrPOI = GearPointOfInterest(GetCameraFocusActor());
		bLeaveRotation = bForceLeaveRotation ||
						( (CurrPOI != None) && CurrPOI.bLeavePlayerFacingPOI );

		// Don't force rotation of pawn when on a turret
		if (bLeaveRotation && GearTurret(Pawn) != None)
		{
			GearTurret(Pawn).UpdateAimToFocusPoint();
			bLeaveRotation = FALSE;
		}

		GearPlayerCamera(PlayerCamera).GameplayCam.ClearFocusPoint(bLeaveRotation);

		if (bLeaveRotation && GearPlayerCamera(PlayerCamera).GameplayCam.FocusPoint.bAdjustCamera)
		{
			UpdateRelativeToVehicleViewRot();
		}
	}
}

/** Update RelativeToVehicleViewRot to match the current view rotation */
simulated function UpdateRelativeToVehicleViewRot()
{
	local GearVehicle MyGearVehicle;
	local GearWeaponPawn MyWeapPawn;
	local bool bPassenger;
	local int MySeatIndex;

	MyWeapPawn = GearWeaponPawn(Pawn);
	if(MyWeapPawn != None)
	{
		MyGearVehicle = MyWeapPawn.MyVehicle;
		MySeatIndex = MyWeapPawn.MySeatIndex;
		bPassenger = TRUE;
	}
	else
	{
		MyGearVehicle = GearVehicle(Pawn);
		MySeatIndex = 0;
	}

	if (MyGearVehicle != None)
	{
		RelativeToVehicleViewRot = Rotation - MyGearVehicle.GetVehicleSpaceCamRotation(0, bPassenger, MySeatIndex);
		RelativeToVehicleViewRot.Roll = 0;
	}
}

simulated function OnForceCombatGUDS(SeqAct_ForceCombatGUDS Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		// enable
		if (GearGame(WorldInfo.Game).UnscriptedDialogueManager != None)
		{
			GearGame(WorldInfo.Game).UnscriptedDialogueManager.bForceInCombatGUDS = TRUE;
		}
		Action.OutputLinks[1].bHasImpulse = true;
	}
	else
	{
		// disable
		if (GearGame(WorldInfo.Game).UnscriptedDialogueManager != None)
		{
			GearGame(WorldInfo.Game).UnscriptedDialogueManager.bForceInCombatGUDS = FALSE;
		}
		Action.OutputLinks[2].bHasImpulse = true;
	}

	Action.OutputLinks[0].bHasImpulse = true;
}


/** Returns whether or not we think the player is in combat */
event bool IsInCombat( optional bool bForceCheck )
{
	local Controller C;
	local bool bWasInCombat, bNowInCombat;
	local GearPawn_LocustTickerBase TickerTest1, TickerTest2;

	// if we don't have a gear pawn we can't be in combast
	if (MyGearPawn == None)
	{
		return FALSE;
	}
	// server replicates combat state to client
	if (Role < ROLE_Authority)
	{
		// so just return the cached version
		return MyGearPawn.bIsInCombat;
	}
	bNowInCombat = MyGearPawn.bIsInCombat;
	// always return false in MP - kind of backwards but it was this way unintentionally for a long time
	// and we decided to keep it
	if (GearGameMP_Base(WorldInfo.Game) != None)
	{
		bNowInCombat = GearGameMP_Base(WorldInfo.Game).bUseOldCombatMovementSpeed;
	}
	// only update the cached value if it's been a while
	else if (WorldInfo.TimeSeconds - LastCheckIsInCombatTime > 1.0f)
	{
		bWasInCombat = bNowInCombat;
		LastCheckIsInCombatTime = WorldInfo.TimeSeconds;

		bNowInCombat = FALSE;
		foreach WorldInfo.AllControllers( class'Controller', C )
		{
			// Naked Tickers are not supposed to count toward the combat check now
			TickerTest1 = GearPawn_LocustTickerBase(C.Pawn);
			TickerTest2 = GearPawn_LocustTickerBase(C.Enemy);
			// If there is a controller that has an enemy on the other team
			if (C != self &&
				C.Pawn	!= None &&
				C.Enemy != None &&
				(TickerTest1 == None || !TickerTest1.bCanPickupInventory) &&
				(TickerTest2 == None || !TickerTest2.bCanPickupInventory) &&
				(GearPawn(C.Pawn) == None || !GearPawn(C.Pawn).IsAHostage()) &&
				!C.Enemy.IsSameTeam( C.Pawn ) )
			{
				// Consider them in combat
				bNowInCombat = TRUE;
				break;
			}
		}

		// if not in combat
		if( !PlayingDevLevel() && !bNowInCombat && bWasInCombat )
		{
			SetTimer( RandRange(5.f,15.f),FALSE,nameof(ReviveTeammates) );
			SetTimer( RandRange(5.f,10.f),FALSE,nameof(ExecuteMeatshields) );
		}
	}
	// this indirection is so that bNetDirty only gets set to true if the value actually changed
	if (bNowInCombat != MyGearPawn.bIsInCombat)
	{
		MyGearPawn.bIsInCombat = bNowInCombat;
	}
	return MyGearPawn.bIsInCombat;
}

function ExecuteMeatshields()
{
	local GearPawn GP;
	if (!IsInCombat() || bCinematicMode)
	{
		// delete any meatshields
		foreach WorldInfo.AllPawns(class'GearPawn',GP)
		{
			if (GP.IsAKidnapper())
			{
				GP.ServerDoSpecialMove(SM_Kidnapper_Execution,TRUE,GP.InteractionPawn);
			}
		}
    }
}

function ReviveTeammates()
{
	local GearAI_COGGear Gear;
	local GearPawn GP;

	// check to revive friendly AI
	foreach WorldInfo.AllControllers(class'GearAI_COGGear',Gear)
	{
		GP = GearPawn(Gear.Pawn);
		if( GP != None && GP.IsDBNO() )
		{
			GP.ReviveFromAutoRevive(MyGearPawn);
		}
	}
}

/* epic ===============================================
* ::GameHasEnded
*
* Called from game info upon end of the game, used to
* transition to proper state.
*
* =====================================================
*/
function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
}

event MayFall(bool bFloor, vector FloorNormal)
{
	local vector HitLocation, HitNormal;

	// if we have a clamped base and can't find it straight down, reverse the move so we don't fall
	if ( MyGearPawn != None && MyGearPawn.ClampedBase != None &&
		!TraceComponent(HitLocation, HitNormal, MyGearPawn.ClampedBase.CollisionComponent, Pawn.Location - vect(0,0,1000), Pawn.Location, Pawn.GetCollisionExtent() * vect(0.5,0.5,1)) )
	{
		Pawn.bCanJump = false;
	}
}

state PlayerFlying
{
	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(Rotation,X,Y,Z);

		Pawn.Acceleration = PlayerInput.aForward*X + PlayerInput.aStrafe*Y + PlayerInput.aUp*vect(0,0,1);
		Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);

		if (bCheatFlying && (Pawn.Acceleration == vect(0,0,0)))
			Pawn.Velocity = vect(0,0,0);

		// Allow pawn to adjust the acceleration
		MyGearPawn.AdjustFlyingAcceleration();

		// Update rotation.
		UpdateRotation( DeltaTime );

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
	}
}

state PlayerWalking
{
	exec function bool TryASpecialMove(bool bRunActions)
	{
		`LogSM("Try a walking special move");
		if (!Global.TryASpecialMove(bRunActions))
		{
			if ((!bUseAlternateControls || !bRunActions) && CanDoSpecialMove(SM_MidLvlJumpOver))
			{
				DoSpecialMove(SM_MidLvlJumpOver,,, GSM_MidLvlJumpOver(MyGearPawn.SpecialMoves[SM_MidLvlJumpOver]).PackSpecialMoveFlags());
			}
			else if (!bIsTargeting || (MyGearPawn != None && MyGearPawn.bCanRoadieRunWhileTargeting))
			{
				if ( !bUseAlternateControls || bRunActions )
				{
					// setup the timer for evade/roadierun
					if ( MyGearPawn.bCanUseCover || MyGearPawn.SpecialMoveClasses[SM_EvadeFwd] != None || MyGearPawn.SpecialMoveClasses[SM_EvadeBwd] != None ||
						MyGearPawn.SpecialMoveClasses[SM_EvadeLt] != None || MyGearPawn.SpecialMoveClasses[SM_EvadeRt] != None || MyGearPawn.SpecialMoveClasses[GSM_Silverback_CoverDeploy] != None )
					{
						SetTimer(RoadieRunTimer, FALSE, nameof(TryToRoadieRun));
					}
					else
					{
						// if there are no other A button actions because cover isn't an option, go to roadie run faster
						// note: keeping some delay here for consistency, else A taps result in a wierd in->out wobble
						SetTimer(RoadieRunTimer*0.5f, FALSE, nameof(TryToRoadieRun));
					}
				}
			}
		}
		return FALSE;
	}

	/**
	 * Overridden to not clobber PHYS_None when performing special moves as it will conflict
	 * with root motion.  If the origin of the PlayerController hack is ever discovered then
	 * hopefully this hack will be unnecessary.
	 */
	function BeginState(Name PreviousStateName)
	{
		GetPRI().PlayerStatus = WPS_Alive;

		// Reset double click if it's not active
		// (keep it if it is active so we can roadie run after a special move)
		if( DoubleClickDir != DCLICK_Active && DoubleClickDir != DCLICK_Back )
		{
			ResetDoubleClick();
		}

		// Kill post process overrides for all types except menus, which handle their own post process on close with custom blend out time
		// Don't clear post process for taccom if still in assess mode
		if (CurrentPPType != eGPP_Menu && (CurrentPPType != eGPP_Taccom || !bAssessMode))
		{
			StopPostProcessOverride(CurrentPPType);
		}

		bPressedJump = false;
		GroundPitch = 0;
		if ( Pawn != None )
		{
			Pawn.ShouldCrouch(false);
			if (MyGearPawn == None || MyGearPawn.SpecialMove == SM_None)
			{
				// FIXME HACK!!!
				if ( Pawn.Physics != PHYS_Falling && Pawn.Physics != PHYS_RigidBody &&
					( Pawn.Physics != PHYS_None || InterpActor_GearBasePlatform(Pawn.Base) == None ||
						!InterpActor_GearBasePlatform(Pawn.Base).bDisallowPawnMovement ) )
				{
					Pawn.SetPhysics(Pawn.WalkingPhysics);
				}
			}
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		local GearPawn P;

		super.ProcessMove( DeltaTime, NewAccel, DoubleClickMove, DeltaRot );

		P = GearPawn(Pawn);
		if( P == None )
		{
			return;
		}

		if( IsLocalPlayerController() )
		{
			if( DoubleClickMove != DCLICK_None )
			{
				if( IsDoingSpecialMove(SM_RoadieRun) &&
					DoubleClickMove != DCLICK_Back	 &&
					DoubleClickMove != DCLICK_Active &&
					DoubleClickMove != DCLICK_Done )
				{
					if( !TryToRunToCover( TRUE ) )
					{
						TryToEvade(DoubleClickMove);
					}
					else
					{
						FinishDoubleClick(TRUE);
					}
				}
				else if( DoubleClickMove == DCLICK_Forward )
				{
					// Try to get into cover OR mantle down
					if( TryDoubleTapMove(SM_MantleDown) )
					{
						// successfully ran to cover or hopped down
					}

					// Set timer to try Roadie Run - shorter for double tap
					SetTimer( RoadieRunTimer * 0.5, FALSE, nameof(TryToRoadieRun) );
				}
				else if( DoubleClickMove != DCLICK_Active && DoubleClickMove != DCLICK_Done )
				{
					if( !IsInCoverState() && TryToRunToCover(,, DoubleClickMove) )
					{
						// successfully ran to cover
					}
					else
					{
						TryToEvade(DoubleClickMove);
					}
					FinishDoubleClick(TRUE);
				}

				if( DoubleClickMove == DCLICK_Active )
				{
					if( IsDoingSpecialMove(SM_RoadieRun) )
					{
						if ( bUseAlternateControls )
						{
							if( !MainPlayerInput.IsButtonActive(GB_X) && PlayerInput.RawJoyUp == 0 )
							{
								MainPlayerInput.HandleButtonInput_X( false );
							}
						}
						else
						{
							if( !MainPlayerInput.IsButtonActive(GB_A) && PlayerInput.RawJoyUp == 0 )
							{
								MainPlayerInput.HandleButtonInput_A( false );
							}
						}
					}
					else if( !IsDoingASpecialMove() && PlayerInput.RawJoyUp == 0 )
							// JF: Commented this.  Seems intended to handle forward doubletaps, and we want to be able to
							// doubletap forward while running right or left.
							// && PlayerInput.RawJoyRight == 0 )
					{
						MainPlayerInput.HandleButtonInput_A( false );
						FinishDoubleClick(TRUE);
					}
				}
				else if( DoubleClickMove != DCLICK_Done && DoubleClickDir  != DCLICK_Done )
				{
					// Set click direction as active
					CurrentDoubleClickDir = DoubleClickDir;
					DoubleClickDir = DCLICK_Active;
				}
			}
			else if( IsDoingSpecialMove(SM_RoadieRun) )
			{
				if ( bUseAlternateControls )
				{
					if( !MainPlayerInput.IsButtonActive(GB_X) && PlayerInput.RawJoyUp == 0 )
					{
						MainPlayerInput.HandleButtonInput_X( false );
					}
				}
				else
				{
					if( !MainPlayerInput.IsButtonActive(GB_A) && PlayerInput.RawJoyUp == 0 )
					{
						MainPlayerInput.HandleButtonInput_A( false );
					}
				}
			}
		}
	}
}


/************************************************************************************
 * SpecialMoves
 ***********************************************************************************/

/** Returns TRUE if player is doing a special move */
function bool IsDoingASpecialMove()
{
	return (MyGearPawn != None && MyGearPawn.IsDoingASpecialMove());
}


/**
 * Returns TRUE if player is current performing TestMove.
 */
simulated function bool IsDoingSpecialMove(ESpecialMove AMove)
{
	return (MyGearPawn != None && MyGearPawn.IsDoingSpecialMove(AMove));
}

/**
 * Returns TRUE if player is current performing an execution.
 */
simulated function bool IsDoingExecution()
{
	return (MyGearPawn != None && MyGearPawn.IsDoingExecution());
}

/**
 * returns true if player can perform requested special move
 * @param bForceCheck - Allows you to skip the single frame condition (which will be incorrect on clients since LastCanDoSpecialMoveTime isn't replicated)
 */
final native function bool CanDoSpecialMove(ESpecialMove AMove, optional bool bForceCheck);

final event bool AllowEvadeOffLedge()
{
	local float ForwardDistance;
	local bool bResult;

	if (!MyGearPawn.IsEvading() || GSM_Evade(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]).bFailedLedgeCheck)
	{
		return false;
	}
	else
	{
		ForwardDistance = class'GSM_MantleDown'.default.ForwardDistance;
		bResult = MyGearPawn.CanPerformMantleDown(class'GSM_MantleDown'.default.MinMantleHeight, class'GSM_MantleDown'.default.MaxMantleHeight, ForwardDistance, rotator((!IsZero(Pawn.Acceleration)) ? Pawn.Acceleration : Pawn.Velocity));
		if (!bResult)
		{
			GSM_Evade(MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove]).bFailedLedgeCheck = true;
		}
		return bResult;
	}
}

reliable final server function ServerAbortRun2Cover()
{
	AbortRun2Cover();
}

simulated function AbortRun2Cover()
{
	if (Role < ROLE_Authority)
	{
		ServerAbortRun2Cover();
	}
	LeaveCover();
	if (MyGearPawn != None &&
		(MyGearPawn.IsDoingSpecialMove(SM_Run2MidCov) || MyGearPawn.IsDoingSpecialMove(SM_Run2StdCov)))
	{
		MyGearPawn.PendingSpecialMoveStruct = MyGearPawn.FillSMStructFromParams(SM_None);
		MyGearPawn.EndSpecialMove();
	}
}

/**
 * Perform a special move locally, and replicate it to server if necessary
 * @network: local player.
 */
final event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove=FALSE, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags=0)
{
	local SMStruct	NewMoveStruct;
	local bool bUpdatingSMFlags;

`if(`notdefined(FINAL_RELEASE))
	if( LocalPlayer(Player) == None )
	{
		`Warn(GetFuncName() @ "has to be called from local player!");
		ScriptTrace();
		return;
	}
`endif

	bUpdatingSMFlags = (MyGearPawn.SpecialMove == NewMove && MyGearPawn.InteractionPawn == InInteractionPawn);

	// if we're doing a move2idle then force the special move to start immediately
	bForceMove = bForceMove || MyGearPawn.IsDoingMove2IdleTransition();

	if (bForceMove || bUpdatingSMFlags || CanDoSpecialMove(NewMove))
	{
		// Build new move struct
		NewMoveStruct = MyGearPawn.FillSMStructFromParams(NewMove, InInteractionPawn, InSpecialMoveFlags);

		// simulate the move locally
		MyGearPawn.DoSpecialMoveFromStruct(NewMoveStruct, bForceMove);

		// Replicate action to the server w/ updated inputs
		if (Role < Role_Authority)
		{
			if (bUpdatingSMFlags)
			{
				ClientToServerUpdateSpecialMoveFlags(NewMoveStruct);
			}
			else
			{
				ClientToServerDoSpecialMove(NewMoveStruct, bForceMove, RemappedJoyUp, RemappedJoyRight, Pawn.Rotation.Yaw, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
			}
		}
	}
}

/** updates special move flags for the current special move
 * need to make sure the server hasn't already ended that special move
 */
reliable server private function ClientToServerUpdateSpecialMoveFlags(SMStruct NewMoveStruct)
{
	if (MyGearPawn != None && MyGearPawn.SpecialMove == NewMoveStruct.SpecialMove && MyGearPawn.InteractionPawn == NewMoveStruct.InteractionPawn)
	{
		MyGearPawn.DoSpecialMoveFromStruct(NewMoveStruct);
	}
}
/** Server to client version of ClientToServerUpdateSpecialMoveFlags() */
reliable client private function ServerToClientUpdateSpecialMoveFlags(SMStruct NewMoveStruct)
{
	if (MyGearPawn != None && MyGearPawn.SpecialMove == NewMoveStruct.SpecialMove && MyGearPawn.InteractionPawn == NewMoveStruct.InteractionPawn)
	{
		MyGearPawn.DoSpecialMoveFromStruct(NewMoveStruct);
	}
}

/**
 * Perform a special move on the server.
 * Called from DoSpecialMove().
 * @network: server.
 */
reliable server final function ClientToServerDoSpecialMove(SMStruct NewMoveStruct, bool bForceMove, float PlayerJoyUp, float PlayerJoyRight, int RotYaw, int CompPCYaw)
{
	local rotator NewRot;

	if (MyGearPawn != None)
	{
		// Copy over
		RemappedJoyRight = PlayerJoyRight;
		RemappedJoyUp = PlayerJoyUp;

		NewRot = Pawn.Rotation;
		NewRot.Yaw = RotYaw;
		Pawn.SetRotation(NewRot);

		NewRot.Pitch = (CompPCYaw & 65535);
		NewRot.Yaw = (CompPCYaw >> 16);
		NewRot.Roll = 0;
		SetRotation(Rotation);

		// ignore special moves that would abort the attack
		if (MyGearPawn.SpecialMove == SM_BayonetAttack)
		{
			return;
		}
		bForceMove = bForceMove || MyGearPawn.IsDoingMove2IdleTransition();
		// if we can't do the move, ask the client to send it again
		if (bForceMove || MyGearPawn.CanDoSpecialMove(NewMoveStruct.SpecialMove) || NewMoveStruct.SpecialMove == SM_None)
		{
			MyGearPawn.DoSpecialMoveFromStruct(NewMoveStruct, bForceMove);
		}
		else if (!IsLocalPlayerController() && !MyGearPawn.SpecialMoves[NewMoveStruct.SpecialMove].bCancelIfFailedOnServer)
		{
			ClientVerifySpecialMove(NewMoveStruct.SpecialMove);
		}
		else
		{
			`Log("ClientToServerDoSpecialMove() calling ServerEndSpecialMove"@MyGearPawn@NewMoveStruct.SpecialMove);
			MyGearPawn.ServerEndSpecialMove(NewMoveStruct.SpecialMove);
		}
	}
}

/** called when the server failed to do a special move we asked; i.e. we are out of sync. Re-send the current special move if necessary.
 * @todo: better would be to make SpecialMoves part of the ServerMove/ClientAdjustPosition structure, but that requires
 * 	more specific animation ticking control
 */
reliable client final function ClientVerifySpecialMove(ESpecialMove FailedMove)
{
	local SMStruct NewMoveStruct;

	if (MyGearPawn != None && (MyGearPawn.SpecialMove == FailedMove || MyGearPawn.SpecialMove == SM_None))
	{
		NewMoveStruct = MyGearPawn.FillSMStructFromParams(MyGearPawn.SpecialMove, MyGearPawn.InteractionPawn, MyGearPawn.SpecialMoveFlags);
		ClientToServerDoSpecialMove(NewMoveStruct, false, RemappedJoyUp, RemappedJoyRight, Pawn.Rotation.Yaw, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
	}
}
/** called when the client failed to do a special move forced by the server; if we're still doing that move, send the command again */
reliable server final function ServerVerifySpecialMove(ESpecialMove FailedMove)
{
	local SMStruct NewMoveStruct;

	if (MyGearPawn != None && MyGearPawn.SpecialMove == FailedMove)
	{
		NewMoveStruct = MyGearPawn.FillSMStructFromParams(MyGearPawn.SpecialMove, MyGearPawn.InteractionPawn, MyGearPawn.SpecialMoveFlags);
		ServerToClientDoSpecialMove(NewMoveStruct, true);
	}
}

/** Replicated function to owning client, called only from ServerDictateSpecialMove() */
reliable client final function ServerToClientDoSpecialMove(SMStruct NewMoveStruct, bool bForceMove)
{
	if (MyGearPawn != None)
	{
		MyGearPawn.DoSpecialMoveFromStruct(NewMoveStruct, bForceMove);
	}
	else if (bForceMove)
	{
		ServerVerifySpecialMove(NewMoveStruct.SpecialMove);
	}
}

/** Stop current special move */
final function EndSpecialMove()
{
	if( IsDoingASpecialMove() )
	{
		ResetDoubleClick();

		if( MyGearPawn != None )
		{
			if( MyGearPawn.IsLocallyControlled() )
			{
				MyGearPawn.LocalEndSpecialMove();
			}
			else
			{
				MyGearPawn.ServerEndSpecialMove();
			}
		}
	}
}


/** Server forces a special move to be replicated to the owning player. */
final event ServerDictateSpecialMove(ESpecialMove NewMove, optional GearPawn InInteractionPawn, optional INT InSpecialMoveFlags=0)
{
	local SMStruct	NewMoveStruct;

	if (WorldInfo.NetMode == NM_Client)
	{
		`warn(WorldInfo.TimeSeconds @ "Called on non server!!" );
		ScriptTrace();
		return;
	}

	// Build new move struct
	NewMoveStruct = MyGearPawn.FillSMStructFromParams(NewMove, InInteractionPawn, InSpecialMoveFlags);

	// if dedicated server, replicate special move to local player (client)
	if (LocalPlayer(Player) == None)
	{
		if (MyGearPawn.SpecialMove == NewMove)
		{
			ServerToClientUpdateSpecialMoveFlags(NewMoveStruct);
		}
		else
		{
			ServerToClientDoSpecialMove(NewMoveStruct, true);
		}
	}

	// Do special move right away on server.
	MyGearPawn.DoSpecialMoveFromStruct(NewMoveStruct, true);
}

/**
 * Notification called when a new special move is started.
 * Note: It is NOT safe to start a different special move from here!!
 */
function SpecialMoveStarted(ESpecialMove NewMove)
{
	// Clear roadie run timer when starting a new special move
	// besides a transition move, we still want to be able to abort it with a slide/evade
	if( NewMove != SM_Run2Idle && NewMove != SM_Walk2Idle )
	{
		ClearTimer('TryToRoadieRun');
	}
}

function bool TryALadderClimb()
{
	// Test for ladder climbing first.
	if ( CanDoSpecialMove(SM_LadderClimbDown) )
	{
		if (MyGearPawn.IsCarryingAHeavyWeapon())
		{
			MyGearPawn.ThrowActiveWeapon();
		}
		DoSpecialMove(SM_LadderClimbDown, TRUE);
		return TRUE;
	}
	if ( CanDoSpecialMove(SM_LadderClimbUp) )
	{
		if (MyGearPawn.IsCarryingAHeavyWeapon())
		{
			MyGearPawn.ThrowActiveWeapon();
		}
		DoSpecialMove(SM_LadderClimbUp, TRUE);
		return TRUE;
	}
	return FALSE;
}


/** For prototyping only, do not call directly */
exec function ProtoTest_Reload()
{
	if (MyGearPawn != None && MyGearPawn.MyGearWeapon != None)
	{
		MyGearPawn.MyGearWeapon.ForceReload();
	}
}

/** For prototyping only, do not call directly */
exec function ProtoTest_Spot()
{
	local GearPawn SpottedPawnCandidate;
	if (CanSpotAPawn(SpottedPawnCandidate))
	{
		ServerMarkPawnSpotted(SpottedPawnCandidate);
	}
}

/** For prototyping only, do not call directly */
exec function ProtoTest_MeatBag()
{
	local ESpecialMove out_SpecialMove;
	local GearPawn out_InteractionPawn;

	if(	MyGearPawn.CheckPawnToPawnInteractions(out_SpecialMove, out_InteractionPawn) )
	{
		MyGearPawn.DoPawnToPawnInteraction(out_SpecialMove, out_InteractionPawn);
	}
}

/** For prototyping only, do not call directly */
exec function ProtoTest_Revive()
{
	// Revive Special Move
	if( CanDoSpecialMove(SM_ReviveTeamMate) )
	{
		ServerDictateSpecialMove(SM_ReviveTeamMate);
	}
}

/** For prototyping only, do not call directly */
exec function ProtoTest_Use()
{
	ProtoTest_Use_Internal();
}

reliable server function ProtoTest_Use_Internal()
{
	local Actor							TouchActor;
	local array<SequenceEvent>			EngageEvents;
	local SeqEvt_Engage					EngageEvent;
	local array<SequenceEvent>		    DoorEvents;
	local SeqEvt_DoorOpen				DoorEvent;
	local GearPC						PC;
	local bool							bAlreadyInUse;
	local GearTrackBomb Bomb;

	if( MyGearPawn == None )
	{
		// normal use events. Like getting in/out of vehicles/turrets.
		Super.ServerUse();
		return;
	}

	// if we're doing any other special move
	if (MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.IsDoingSpecialMove(SM_UsingCommLink) && !MyGearPawn.IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
	{
		// then don't allow any other interactions
		return;
	}

	// do a bunch of other things if not in cover
	if( !MyGearPawn.IsInCover() )
	{
		// these special moves interrupt reloads, so prevent them if reloading
		if( MyGearPawn.Weapon == None ||
			(MyGearPawn.Weapon.CurrentFireMode != class'GearWeapon'.const.FIREMODE_ACTIVERELOADSUCCESS &&
			 MyGearPawn.Weapon.CurrentFireMode != class'GearWeapon'.const.FIREMODE_ACTIVERELOADSUPERSUCCESS) )
		{
			// check for door kick
			if (MyGearPawn.bInsideDoorTrigger && CanDoorOpen())
			{
				DoDoorOpen();
				return;
			}
			// If we can't do the door kick, check if we should play the disabled GUD
			else if (MyGearPawn.DoorTrigger != None && MyGearPawn.DoorTrigger.FindEventsOfClass(class'SeqEvt_DoorOpen', DoorEvents, TRUE))
			{
				DoorEvent = SeqEvt_DoorOpen(DoorEvents[0]);
				if (DoorEvent != None && !DoorEvent.bEnabled && DoorEvent.bPlayDisabledGUD)
				{
					GearGame(WorldInfo.Game).TriggerGUDEvent(DoorEvent.DisabledGUDEvent, MyGearPawn);
				}
			}
		}

		// look for interaction triggers
		if (!MyGearPawn.bIsConversing)
		{
			foreach MyGearPawn.TouchingActors(class'Actor', TouchActor)
			{
				if( Trigger_ButtonInteraction(TouchActor) != None )
				{
					if( TouchActor.TriggerEventClass(class'SeqEvt_Interaction', MyGearPawn) )
					{
						MyGearPawn.SpecialMoveLocation = TouchActor.Location;
						ServerDictateSpecialMove(SM_PushButton);
						Trigger_ButtonInteraction(TouchActor).NotifyTriggered();
						// no need to check further
						return;
					}
				}
				else if( (Trigger_Engage(TouchActor) != None) && Trigger_Engage(TouchActor).bIsEngagable && Trigger_Engage(TouchActor).EngagedPawn == None )
				{
					// make sure another player is not already activating this trigger
					bAlreadyInUse = FALSE;
					foreach WorldInfo.AllControllers(class'GearPC', PC)
					{
						if( PC.IsInState('Engaging') && GearPawn(PC.Pawn) != None && GearPawn(PC.Pawn).EngageTrigger == TouchActor )
						{
							bAlreadyInUse = TRUE;
							break;
						}
					}
					// we need to make sure the event can fire once for every turn, plus the finish, so increase the MaxTriggerCount
					if (!bAlreadyInUse && TouchActor.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents, TRUE))
					{
						EngageEvent = SeqEvt_Engage(EngageEvents[0]);
						if (EngageEvent != None && CanDoSpecialMove(SM_Engage_Start))
						{
							if (EngageEvent.bEnabled)
							{
								// will disable in the special move code when the turning is done, make sure this doesn't backdoor us
								EngageEvent.MaxTriggerCount = 0;
								// set the pawn for moving to the engage actor
								ServerDictateSpecialMove(SM_Engage_Start);
								GotoState('Engaging');
								ClientGotoState('Engaging');
								// no need to check further
								return;
							}
							else if (EngageEvent.bPlayDisabledGUD)
							{
								GearGame(WorldInfo.Game).TriggerGUDEvent(EngageEvent.DisabledGUDEvent, MyGearPawn);
								return;
							}
						}
					}
				}
			}
			if ( GearBombDeliveryGRI(WorldInfo.GRI) != None && !MyGearPawn.IsDoingASpecialMove() && MyGearPawn.CanDoSpecialMove(SM_PushButton))
			{
				// check for enemy bomb to trigger
				foreach MyGearPawn.CollidingActors(class'GearTrackBomb', Bomb, 128.0)
				{
					if (Bomb.Health > 0 && Bomb.TeamNum != GetTeamNum())
					{
						Bomb.UsedBy(Pawn);
						ServerDictateSpecialMove(SM_PushButton);
					}
				}
			}
		}
	}
	// check for push object
	else
	{
		// push object
		if( CanDoSpecialMove(SM_PushObject) )
		{
			ServerDictateSpecialMove(SM_PushObject);
			return;
		}
	}

	// check for leaving/entering a vehicle
	if (Vehicle(Pawn) != None)
	{
		Vehicle(Pawn).DriverLeave(FALSE);
		return;
	}
	// check for leaving ridable pawn (Pawn is the ridable pawn)
	else if (GearPawnRidable_Base(Pawn) != none)
	{
		GearPawnRidable_Base(Pawn).DriverLeave(FALSE);
		return;
	}

	if( !MyGearPawn.bIsConversing && FindVehicleToDrive() )
	{
		return;
	}

	// normal use events
	TriggerInteracted();

	// kantus revive; last because it can be used anytime allies are in range, even when not DBNO
	if (CanDoSpecialMove(GSM_Kantus_ReviveScream))
	{
		ServerDictateSpecialMove(GSM_Kantus_ReviveScream);
		return;
	}
}


/**
 * Tries to perform a context sensitive special move
 * @param bRunActions - Only used with alternate controls to determine if we are calling this from the action button or the run/evade button (TRUE means the Run/Evade variety)
 */
exec function bool TryASpecialMove(bool bRunActions)
{
	local GearPawn		out_InteractionPawn;
	local ESpecialMove	out_SpecialMove;

	`LogSM("Try a global special move");
	if (MyGearPawn != None && !bIsTargeting && (!bRunActions || !bUseAlternateControls) && !bChangeExecutionControls)
	{
		// Check Pawn to Pawn interactions
		if(	MyGearPawn.CheckPawnToPawnInteractions(out_SpecialMove, out_InteractionPawn) )
		{
			MyGearPawn.DoPawnToPawnInteraction(out_SpecialMove, out_InteractionPawn);
			return TRUE;
		}
	}

	return FALSE;
}

/** Tell the server to jog since we are roadie running in a walking volume */
unreliable server function ServerSetRoadieJog(bool bJog)
{
	MyGearPawn.bIsRoadieJogging = bJog;
}

/** Tries to set the flag for allowing players to jog when they are supposed to walk */
final function TryToRoadieJog()
{
	local WalkVolume WVolume;

	WVolume = WalkVolume(MyGearPawn.PhysicsVolume);
	// If we are in an active walking volume, mark him for jogging
	if ((WVolume != None && WVolume.bReducesMovementSpeed && WVolume.bCanRoadieJog) || MyGearPawn.bIsConversing)
	{
		ServerSetRoadieJog(true);
	}
	// if holding heavy weapon, allow roadie jog
	if ( MyGearPawn != none && MyGearPawn.MyGearWeapon.bUseHeavyWeaponSpeedMods )
	{
		ServerSetRoadieJog(true);
	}
}

/**
 * Tries to perform the Roadie Run special move.
 */
function TryToRoadieRun()
{
	// if still holding the 'a' button and can do the special move (skip while evading since that is handled via GSM_Evade.SpecialMoveEnded)
	if ((IsHoldingRoadieRunButton() || bForcedRoadieRun) && !MyGearPawn.IsEvading() && !MyGearPawn.IsDoingSpecialMove(SM_MidLvlJumpOver) && !MyGearPawn.IsDoingSpecialMove(SM_WeaponPickup) )
	{
		// then start running
		if (CanDoSpecialMove(SM_RoadieRun))
		{
			DoSpecialMove(SM_RoadieRun);
		}
		else if (CanDoSpecialMove(SM_CoverRun))
		{
			DoSpecialMove(SM_CoverRun);
		}
		else if (CanDoSpecialMove(SM_Berserker_Charge))
		{
			DoSpecialMove(SM_Berserker_Charge);
		}
		else
		{
			TryToRoadieJog();
		}
	}
}

/**
 * Tries to perform a long execution
 */
function TryToDoLongExecution()
{
	if(CanDoSpecialMove(SM_CQCMove_PunchFace))
	{
		ServerDoCQCMove(SM_CQCMove_PunchFace, class'GSM_CQCMove_PunchFace'.static.DetermineExecutionVariant(MyGearPawn, self));
	}
}



/** Return TRUE if Pawn can try to run to cover */
function bool CanTryToRunToCover()
{
	if( MyGearPawn == None || (MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.IsDoingMove2IdleTransition() && !MyGearPawn.IsDoingSpecialMove(SM_PushOutOfCover) &&
		(!bUseAlternateControls || !MyGearPawn.IsDoingSpecialMove(SM_RoadieRun))) )
	{
`if(`notdefined(FINAL_RELEASE))
		if( MyGearPawn != None && bDebugCover )
		{
			`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Failed to Run2Cover because doing SpecialMove:" @ MyGearPawn.SpecialMove );
		}
`endif
		return FALSE;
	}
	else if ( !MyGearPawn.bCanUseCover || MyGearPawn.bIsConversing || MyGearPawn.IsCarryingShield() ||
			(WalkVolume(Pawn.PhysicsVolume) != None && WalkVolume(Pawn.PhysicsVolume).bReducesMovementSpeed && WalkVolume(Pawn.PhysicsVolume).bActive) ||
			IsTimerActive(nameof(PickingUpAWeapon)) || MyGearPawn.CoopWeaponSyncActor != None || GearWeap_FireExtinguisherBase(MyGearPawn.MyGearWeapon)!=none )
	{
		return FALSE;
	}

	return TRUE;
}

/** See if player can perform run 2 cover move */
function bool TryToRunToCover(optional bool bSkipSpecialMoveCheck, optional float CheckScale, optional EDoubleClickDir DblClickDirToCheck=DCLICK_None, optional bool bPreventSideEntry)
{
	local CovPosInfo	FoundCovInfo;
	local int			NoCameraAutoAlign;

	if( CanRunToCover(FoundCovInfo, NoCameraAutoAlign, bSkipSpecialMoveCheck, CheckScale, DblClickDirToCheck,bPreventSideEntry) )
	{
		AcquireCover(FoundCovInfo, (NoCameraAutoAlign == 1));
		return TRUE;
	}

	return FALSE;
}

/**
 * See if player can perform run 2 cover move
 * @param CoverCanRunTo - set to the cover that you can run to if successful
 * @param NoCameraAutoAlign - set if successful (acts as a bool)
 */
function bool CanRunToCover(out CovPosInfo CoverCanRunTo, out int NoCameraAutoAlign, optional bool bSkipSpecialMoveCheck, optional float CheckScale, optional EDoubleClickDir DblClickDirToCheck=DCLICK_None, optional bool bPreventSideEntry)
{
	local vector		CheckDir, CamLoc;
	local rotator		CamRot;
	local bool          bEnteringCoverSideways;
	local float         DistanceToCheckToEnterCover;
	local Pawn          BlockingPawn;
	local GearPawn      BlockingGP;

	NoCameraAutoAlign		= 0;
	bEnteringCoverSideways	= FALSE;

	if( MyGearPawn != None && PlayerInput != None )
	{
		if( CheckScale <= 0.f )
		{
			CheckScale = 1.f;
		}

		// Check if move can be done
		if( MyGearPawn.CoverType != CT_None || (!bSkipSpecialMoveCheck && !CanTryToRunToCover()) )
		{
			return FALSE;
		}

		// Try to find cover to run to
		if (DblClickDirToCheck != DCLICK_None)
		{
			switch (DblClickDirToCheck)
			{
			case DCLICK_Back:
				CheckDir = vect(-1.f, 0.f, 0.f);
				break;
			case DCLICK_Forward:
				CheckDir = vect(1.f, 0.f, 0.f);
				break;
			case DCLICK_Left:
				CheckDir = vect(0.f, -1.f, 0.f);
				bEnteringCoverSideways = TRUE;
				break;
			case DCLICK_Right:
				CheckDir = vect(0.f, 1.f, 0.f);
				bEnteringCoverSideways = TRUE;
				break;
			}
			GetPlayerViewPoint(CamLoc,CamRot);
			CheckDir = Normal(CheckDir >> CamRot);

			NoCameraAutoAlign = 1;
		}
		else if( Sqrt(Square(PlayerInput.RawJoyRight) + Square(PlayerInput.RawJoyUp)) > DeadZoneThreshold )
		{
			// if any direction allowed then use the controls relative to the camera
			CheckDir.X = PlayerInput.RawJoyUp;
			CheckDir.Y = PlayerInput.RawJoyRight;
			GetPlayerViewPoint(CamLoc,CamRot);
			CheckDir = Normal(CheckDir >> CamRot);

			// Stick direction is horizontal
			if( Abs(PlayerInput.RawJoyRight) > Abs(PlayerInput.RawJoyUp) )
			{
				bEnteringCoverSideways = TRUE;
			}
			// Vertical
			else
			{
				if( PlayerInput.RawJoyUp < -DeadZonethreshold )
				{
					// backing up into cover, dont align camera
					//NoCameraAutoAlign = 1;
					return FALSE;
				}
			}

			NoCameraAutoAlign = 1;
		}
		else
		{
			// otherwise only check forward
			CheckDir = vector(Pawn.Rotation);
			NoCameraAutoAlign = 0;
		}


		if( bEnteringCoverSideways )
		{
			if (bPreventSideEntry)
			{
				return FALSE;
			}
			DistanceToCheckToEnterCover = MyGearPawn.Run2CoverPerpendicularMaxDist;
		}
		else
		{
			DistanceToCheckToEnterCover = MyGearPawn.Run2CoverMaxDist * CheckScale;
		}
		//`log( "bEnteringCoverSideways: " $ bEnteringCoverSideways );

		BlockingPawn = none;
		if( MyGearPawn.CanPrepareRun2Cover(DistanceToCheckToEnterCover, CoverCanRunTo, CheckDir,,,BlockingPawn) )
		{
			return TRUE;
		}
		else if(BlockingPawn != none)
		{
			BlockingGP = GearPawn(BlockingPawn);

			if( BlockingGP != none && BlockingGP.MyGearAI != none && !BlockingPawn.IsHumanControlled() && BlockingPawn.IsSameTeam(Pawn) )
			{
				BlockingGP.MyGearAI.VacateCoverForPlayer(self);
			}
		}
	}

	return FALSE;
}


/************************************************************************************
 * Evade
 ***********************************************************************************/

function ESpecialMove ChooseEvadeMoveBasedOnStickDir()
{
	local ESpecialMove EvadeMove;

	// fwd by default
	EvadeMove = SM_EvadeFwd;

	if (abs(RemappedJoyUp) > abs(RemappedJoyRight))
	{
		if (RemappedJoyUp > DeadZoneThreshold)
		{
			EvadeMove = SM_EvadeFwd;
		}
		else
			if (RemappedJoyUp < -DeadZoneThreshold)
			{
				EvadeMove = SM_EvadeBwd;
			}
	}
	else
	{
		if (RemappedJoyRight > DeadZoneThreshold)
		{
			EvadeMove = SM_EvadeRt;
		}
		else
			if (RemappedJoyRight < -DeadZoneThreshold)
			{
				EvadeMove = SM_EvadeLt;
			}
	}

	return EvadeMove;
}

exec function bool TryToEvade( optional EDoubleClickDir DoubleClickInput )
{
	local ESpecialMove	EvadeMove;
	local Rotator NewRotation;

	if( !CanEvade() )
	{
		return FALSE;
	}

	// By default: go forward
	EvadeMove = SM_EvadeFwd;
	if( DoubleClickInput != DCLICK_None )
	{
		if( DoubleClickInput == DCLICK_Forward )
		{
			EvadeMove = SM_EvadeFwd;
		}
		else if( DoubleClickInput == DCLICK_Back )
		{
			EvadeMove = SM_EvadeBwd;
		}
		else if( DoubleClickInput == DCLICK_Left )
		{
			EvadeMove = SM_EvadeLt;
		}
		else if( DoubleClickInput == DCLICK_Right )
		{
			EvadeMove = SM_EvadeRt;
		}
	}
	else
	{
		EvadeMove = ChooseEvadeMoveBasedOnStickDir();
	}

	CurrentDoubleClickDir = DoubleClickInput;

	// Trigger Evade
	CoverLog("Evade Move:" @ EvadeMove, "PlayerEvade");
	if( EvadeMove != SM_None )
	{
		NewRotation.Yaw = Rotation.Yaw;
		MyGearPawn.SetRotation(NewRotation);
		DoSpecialMove(EvadeMove);
		return TRUE;
	}

	return FALSE;
}


/**
 * Stop Evade Move.
 * Network: Local Player.
 */
final function StopEvade()
{
	if( MyGearPawn.IsEvading() )
	{
		EndSpecialMove();
	}
}


/**
 * Return true if Can perform an Evade move.
 * Network: LocalPlayer
 */
final function bool CanEvade()
{
	return(	MyGearPawn != None &&
			!MyGearPawn.bWantsToMelee &&
			!MyGearPawn.bIsConversing &&
			MyGearPawn.Weapon.CurrentFireMode != class'GearWeapon'.const.MELEE_ATTACK_FIREMODE &&
			MyGearPawn.bWantsToBeMirrored == MyGearPawn.bIsMirrored &&	            // can abort mirror transition, but only once the mesh has been mirrored.
			(!IsMoveInputIgnored() || MyGearPawn.IsDoingSpecialMove(SM_PushOutOfCover)) &&
			!IsTimerActive( 'CannotRetriggerEvade' ) &&
			!MyGearPawn.IsEvading() &&
			!MyGearPawn.IsCarryingAHeavyWeapon()
			);


}

/**
 * Called once our last evade has finished.
 */
simulated function NotifyEvadeFinished()
{
	// Set delay before allowing next evade move
	SetTimer( EvadeRetriggerDelay, FALSE, nameof(CannotRetriggerEvade) );
	CurrentDoubleClickDir = DCLICK_None;
}


/** Dummy functions, used for timers */
function CannotRetriggerEvade();


/************************************************************************************
 * CQC (Close Quarter Combat)
 ***********************************************************************************/

reliable server function ServerDoCQCMove(ESpecialMove WhichSpecialMove, optional int Variant)
{
	if( MyGearPawn != None )
	{
		MyGearPawn.ServerDoCQCMove(WhichSpecialMove, Variant);
	}
}

/**
 * 0 - curb stomp + revival
 * 1 - door kick
 * 2 - button push
 * 3 - push object
 * 4 - weapon pickup
 */
unreliable server function ServerUse()
{
	local Actor							TouchActor;
	local array<SequenceEvent>			EngageEvents;
	local SeqEvt_Engage					EngageEvent;
	local array<SequenceEvent>		    DoorEvents;
	local SeqEvt_DoorOpen				DoorEvent;
	local GearPC						PC;
	local bool							bAlreadyInUse;
	local GearTrackBomb Bomb;

	if( MyGearPawn == None )
	{
		// normal use events. Like getting in/out of vehicles/turrets.
		Super.ServerUse();
		return;
	}

	// if we're doing any other special move
	if (MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.IsDoingSpecialMove(SM_UsingCommLink) && !MyGearPawn.IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
	{
		// then don't allow any other interactions
		return;
	}

	// Revive Special Move
	if( CanDoSpecialMove(SM_ReviveTeamMate) )
	{
		ServerDictateSpecialMove(SM_ReviveTeamMate);
		return;
	}

	// Close Quarter Combat - CurbStomp or PunchFace
	if( !bChangeExecutionControls && CanDoSpecialMove(SM_CQCMove_CurbStomp) )
	{
		ServerDictateSpecialMove(SM_CQCMove_CurbStomp, GSM_CQC_Killer_Base(MyGearPawn.SpecialMoves[SM_CQCMove_CurbStomp]).Follower);
		return;
	}

	// do a bunch of other things if not in cover
	if( !MyGearPawn.IsInCover() )
	{
		// these special moves interrupt reloads, so prevent them if reloading
		if( MyGearPawn.Weapon == None ||
			(MyGearPawn.Weapon.CurrentFireMode != class'GearWeapon'.const.FIREMODE_ACTIVERELOADSUCCESS &&
			 MyGearPawn.Weapon.CurrentFireMode != class'GearWeapon'.const.FIREMODE_ACTIVERELOADSUPERSUCCESS) )
		{
			// check for door kick
			if (MyGearPawn.bInsideDoorTrigger && CanDoorOpen())
			{
				DoDoorOpen();
				return;
			}
			// If we can't do the door kick, check if we should play the disabled GUD
			else if (MyGearPawn.DoorTrigger != None && MyGearPawn.DoorTrigger.FindEventsOfClass(class'SeqEvt_DoorOpen', DoorEvents, TRUE))
			{
				DoorEvent = SeqEvt_DoorOpen(DoorEvents[0]);
				if (DoorEvent != None && !DoorEvent.bEnabled && DoorEvent.bPlayDisabledGUD)
				{
					GearGame(WorldInfo.Game).TriggerGUDEvent(DoorEvent.DisabledGUDEvent, MyGearPawn);
				}
			}
		}

		// look for interaction triggers
		if (!MyGearPawn.bIsConversing)
		{
			foreach MyGearPawn.TouchingActors(class'Actor', TouchActor)
			{
				if( Trigger_ButtonInteraction(TouchActor) != None )
				{
					if( TouchActor.TriggerEventClass(class'SeqEvt_Interaction', MyGearPawn) )
					{
						MyGearPawn.SpecialMoveLocation = TouchActor.Location;
						ServerDictateSpecialMove(SM_PushButton);
						Trigger_ButtonInteraction(TouchActor).NotifyTriggered();
						// no need to check further
						return;
					}
				}
				else if( (Trigger_Engage(TouchActor) != None) && Trigger_Engage(TouchActor).bIsEngagable && Trigger_Engage(TouchActor).EngagedPawn == None )
				{
					// make sure another player is not already activating this trigger
					bAlreadyInUse = FALSE;
					foreach WorldInfo.AllControllers(class'GearPC', PC)
					{
						if( PC.IsInState('Engaging') && GearPawn(PC.Pawn) != None && GearPawn(PC.Pawn).EngageTrigger == TouchActor )
						{
							bAlreadyInUse = TRUE;
							break;
						}
					}
					// we need to make sure the event can fire once for every turn, plus the finish, so increase the MaxTriggerCount
					if (!bAlreadyInUse && TouchActor.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents, TRUE))
					{
						EngageEvent = SeqEvt_Engage(EngageEvents[0]);
						if (EngageEvent != None && CanDoSpecialMove(SM_Engage_Start))
						{
							if (EngageEvent.bEnabled)
							{
								// will disable in the special move code when the turning is done, make sure this doesn't backdoor us
								EngageEvent.MaxTriggerCount = 0;
								// set the pawn for moving to the engage actor
								ServerDictateSpecialMove(SM_Engage_Start);
								GotoState('Engaging');
								ClientGotoState('Engaging');
								// no need to check further
								return;
							}
							else if (EngageEvent.bPlayDisabledGUD)
							{
								GearGame(WorldInfo.Game).TriggerGUDEvent(EngageEvent.DisabledGUDEvent, MyGearPawn);
								return;
							}
						}
					}
				}
			}
			if ( GearBombDeliveryGRI(WorldInfo.GRI) != None && !MyGearPawn.IsDoingASpecialMove() && MyGearPawn.CanDoSpecialMove(SM_PushButton))
			{
				// check for enemy bomb to trigger
				foreach MyGearPawn.CollidingActors(class'GearTrackBomb', Bomb, 128.0)
				{
					if (Bomb.Health > 0 && Bomb.TeamNum != GetTeamNum())
					{
						Bomb.UsedBy(Pawn);
						ServerDictateSpecialMove(SM_PushButton);
					}
				}
			}
		}
	}
	// check for push object
	else
	{
		// push object
		if( CanDoSpecialMove(SM_PushObject) )
		{
			ServerDictateSpecialMove(SM_PushObject);
			return;
		}
	}

	// check for leaving/entering a vehicle
	if (Vehicle(Pawn) != None)
	{
		Vehicle(Pawn).DriverLeave(FALSE);
		return;
	}
	// check for leaving ridable pawn (Pawn is the ridable pawn)
	else if (GearPawnRidable_Base(Pawn) != none)
	{
		GearPawnRidable_Base(Pawn).DriverLeave(FALSE);
		return;
	}

	if( !MyGearPawn.bIsConversing && FindVehicleToDrive() )
	{
		return;
	}

	// normal use events
	TriggerInteracted();

	// kantus revive; last because it can be used anytime allies are in range, even when not DBNO
	if (CanDoSpecialMove(GSM_Kantus_ReviveScream))
	{
		ServerDictateSpecialMove(GSM_Kantus_ReviveScream);
		return;
	}
}

/**
 * Attempts to do a ManipulateCover special move if MyGearPawn is in movable cover,
 * and if the left stick is tilted
 */
function bool TryManipulateCover()
{
	// If we have a ManipulateCoverMove, trigger ManipulateCover
	if (!MyGearPawn.IsDoingSpecialMove(SM_PushCover) &&
		CanDoSpecialMove(SM_PushCover))
	{
		ServerPerformCoverPush();
		DoSpecialMove(SM_PushCover, TRUE);
		return TRUE;
	}
	return FALSE;
}

/** Server call to perform some initial work before pushing an object (plays sound, sets flags, checks for AI help) */
reliable server function ServerPerformCoverPush()
{
	MyGearPawn.ServerGrabMovableCover();
	MyGearPawn.bGrabbingMovableCover = TRUE;

	// Determine if we need AI help, and if so, have the AI help us
	CheckForPushableCoverHelp(false);
}

reliable server function ServerDoShieldKickOver(GearDroppedPickup_Shield Shield)
{
	if (Shield.CanKickOver(MyGearPawn, false))
	{
		Shield.SetTimer(0.85f,FALSE,nameof(Shield.KickOver));
		MyGearPawn.ServerDoSpecialMove(SM_DoorKick, TRUE);
	}
}

/**
*  Checks the area for nearby pickups, and returns the best ActionInfo and Actor to pickup
*
*  @param BestActor If set, this is the actor that should be picked up. If set to None, then there is nothing that can be picked up
*  @param BestAction Returns the best possible interaction, which may be nothing at all (Name will = '') or a "can't pickup" interaction (BestActor will be None
*  @param bHidePurchaseItems If set, don't allow purchaseable items
*  @param bHideFreeItems If set, don't allow non-purchaseable items
*/
final function FindBestPickup(out Actor out_Actor, out ActionInfo out_Action, optional bool bHidePurchaseItems, optional bool bHideFreeItems)
{
	local ActionInfo Action;
	local Actor TouchActor;
	local GearDroppedPickup	DroppedPickup;
	local GearPickupFactory	FactoryPickup;
	local float Dist, BestDist;
	local Name Interaction;

	out_Actor = None;
	out_Action.ActionName = '';

	// look for any pickups. We prioritize any valid pickups over invalid
	BestDist = 1000000.0;
	foreach MyGearPawn.TouchingActors(class'Actor', TouchActor)
	{
		DroppedPickup = GearDroppedPickup(TouchActor);
		if (DroppedPickup != None && !bHideFreeItems && DroppedPickup.GetPickupAction(Action, Interaction, Pawn))
		{
			Dist = VSize(DroppedPickup.Location - MyGearPawn.Location);

			// Add biases for different interaction types
			if (Interaction == 'TakeAmmo')
			{
				Dist *= 1 / PickUpAmmoPreference;
			}
			else if (Interaction == 'SwapWithCurrent' || Interaction == 'SwapWithAttachment' || Interaction == 'SwapCarried')
			{
				Dist *= 1 / PickUpSwapWeaponPreference;
			}
			else
			{
				Dist *= 1 / PickUpNewWeaponPreference;
			}

			if (MyGearPawn.CanPickUpActor(TouchActor))
			{
				// If we're the first valid pickup, or are closer, set it
				if (out_Actor == None || Dist < BestDist)
				{
					out_Actor = TouchActor;
					out_Action = Action;
					BestDist = Dist;
				}
			}
			else
			{
				// Only set if no valid pickup and we're closer
				if (out_Actor == None && Dist < BestDist)
				{
					out_Action = Action;
					BestDist = Dist;
				}
			}
		}

		FactoryPickup = GearPickupFactory(TouchActor);
		if (FactoryPickup == None)
		{
			continue;
		}
		// Make sure Purchase matches up with requested flags
		if (FactoryPickup.RequiresPurchase())
		{
			if (bHidePurchaseItems)
			{
				continue;
			}
		}
		else
		{
			if (bHideFreeItems)
			{
				continue;
			}
		}

		if (FactoryPickup.GetPickupAction(Action, Interaction, Pawn))
		{
			Dist = VSize(FactoryPickup.Location - MyGearPawn.Location);

			// Add biases for different interaction types
			if (Interaction == 'TakeAmmo')
			{
				Dist *= 1 / PickUpAmmoPreference;
			}
			else if (Interaction == 'SwapWithCurrent' || Interaction == 'SwapWithAttachment' || Interaction == 'SwapCarried')
			{
				Dist *= 1 / PickUpSwapWeaponPreference;
			}
			else
			{
				Dist *= 1 / PickUpNewWeaponPreference;
			}

			if (MyGearPawn.CanPickUpActor(TouchActor))
			{
				// If we're the first valid pickup, or are closer, set it
				if (out_Actor == None || Dist < BestDist)
				{
					out_Actor = TouchActor;
					out_Action = Action;
					BestDist = Dist;
				}
			}
			else
			{
				// Only set if no valid pickup and we're closer
				if (out_Actor == None && Dist < BestDist)
				{
					out_Action = Action;
					BestDist = Dist;
				}
			}
		}
	}
	// Add a pawn-specific pickup if applicable
	MyGearPawn.GetSpecialPickupAction(out_Actor, out_Action, bHidePurchaseItems, bHideFreeItems);
}

//`define debugpickup(msg) `log(`msg)
`define debugpickup(msg)

/** see if we can pick up a weapon; if we think so, send request to server
 * @param bFindPurchaseItems - if true, find only items requiring purchase; if false, find only items that are free
 */
final function bool TryToPickupAWeapon(bool bFindPurchaseItems)
{
	local Actor A;
	local ActionInfo Action;
	local name PickupInteraction;
	local GearDroppedPickup_Shield Shield;

	`debugpickup("Looking for pickups"@`showvar(MyGearPawn.SpecialMove));
	// Pickups
	if (CanTryToPickupWeapons())
	{
		FindBestPickup(A, Action, !bFindPurchaseItems, bFindPurchaseItems);
		if( A != None )
		{
			`debugpickup("Found pickup"@`showvar(A));
			Shield = GearDroppedPickup_Shield(A);
			if (Shield != None && Shield.CanKickOver(MyGearPawn, false))
			{
				ServerDoShieldKickOver(Shield);
				return TRUE;
			}
			if (GearDiscoverablesPickupFactoryBase(A) == None)
			{
				// See if we can pick up that weapon.
				if( CanDoSpecialMove(SM_WeaponPickup) )
				{
					`debugpickup("Attempting to pickup"@`showvar(A));
					if (GearDroppedPickup(A) != None)
					{
						PickupInteraction = GearDroppedPickup(A).FindInteractionWith(Pawn,FALSE);
					}
					else
					{
						PickupInteraction = GearPickupFactory(A).FindInteractionWith(Pawn,FALSE);
					}
					if (PickupInteraction != 'SwapWithCurrent' && PickupInteraction != 'TakeAmmo' && MyGearPawn.IsCarryingShield())
					{
						MyGearPawn.DropShield();
						if (Role < ROLE_Authority)
						{
							MyGearPawn.ServerDropShield();
						}
					}
					// set a timer to delay further interactions to prevent special move interaction issues in situations with latency
					SetTimer(1.0, false, nameof(PickingUpAWeapon));
					// tell the server we want to pickup the item
					MyGearPawn.PickUpWeapon(A);
					// do a local claim to prevent icon shenanigans
					if (GearPickupFactory(A) != None)
					{
						GearPickupFactory(A).ClaimedBy = MyGearPawn;
					}
					return TRUE;
				}
			}
		}
	}
	return FALSE;
}

final function bool CanTryToPickupWeapons()
{
	return MyGearPawn != None && Vehicle(Pawn) == None && (!MyGearPawn.IsDoingASpecialMove() || MyGearPawn.IsDoingMove2IdleTransition() || MyGearPawn.IsDoingSpecialMove(SM_UsingCommLink));

}

function DisablePickupAction()
{
}

function PickingUpAWeapon()
{
	// just a stub
}

/** request from the client to tear down (salvage) a fortification */
reliable server final function ServerTearDownFortification(GearFortification Fort)
{
	if ( MyGearPawn != None && MyGearPawn.Health > 0 && Fort != None && Fort.Owner == self &&
		GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications && class'GearGameHorde_Base'.default.bCanSellFortifications )
	{
		Fort.TearDown(self);
	}
}
/** request from the client to repair a fortification */
reliable server final function ServerRepairFortification(GearFortification Fort, float RepairPct)
{
	// validate value given by client is within range
	RepairPct = FClamp(RepairPct, RepairPctRange.Y, RepairPctRange.X);

	if ( MyGearPawn != None && MyGearPawn.Health > 0 && Fort != None && WorldInfo.TimeSeconds - Fort.LastModifyTime > 1.0 &&
		GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications &&
		(Fort.Health > 0 || !Fort.IsEncroachingOnBuildLocation(Pawn, Fort.Location, Fort.Rotation)) )
	{
		Fort.Repair(self, RepairPct);
	}
}
/** request from the client to upgrade a fortification */
reliable server final function ServerUpgradeFortification(GearFortification Fort)
{
	if ( MyGearPawn != None && MyGearPawn.Health > 0 && Fort != None && WorldInfo.TimeSeconds - Fort.LastModifyTime > 1.0 &&
		GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications )
	{
		Fort.Upgrade(self);
	}
}
/** request from the client to use a fortification (fortification specfic action) */
reliable server final function ServerUseFortification(GearFortification Fort)
{
	if ( MyGearPawn != None && MyGearPawn.Health > 0 && Fort.Touching.Find(MyGearPawn) != INDEX_NONE &&
		!MyGearPawn.IsCarryingAHeavyWeapon() && !MyGearPawn.IsAKidnapper() && Fort.UsedBy(MyGearPawn) )
	{
		ServerDictateSpecialMove(SM_PushButton);
	}
}

/** Function called to see if there is any client-side-only pickups to grab */
function bool ClientUse()
{
	local Actor							TouchActor;
	local array<SequenceEvent>			EngageEvents;
	local SeqEvt_Engage					EngageEvent;
	local GearTrackBomb Bomb;
	local GearFortification Fort;
	local GearPawn		out_InteractionPawn;
	local ESpecialMove	out_SpecialMove;

	// no interactions when dead
	if (MyGearPawn != None && MyGearPawn.Health <= 0)
	{
		return TRUE;
	}

	// if recently attempted to pickup a weapon prevent any other interactions
	if (IsTimerActive('PickingUpAWeapon'))
	{
		return TRUE;
	}

	// do an extra client side check to make sure we revive/execute before picking anything up
	if( CanDoSpecialMove(SM_ReviveTeamMate) || (!bChangeExecutionControls && CanDoSpecialMove(SM_CQCMove_CurbStomp)))
	{
		// return false so that we still call the server version which starts the revive/execute
		return FALSE;
	}

	if (MyGearPawn != None && !bIsTargeting && bChangeExecutionControls)
	{
		// Check Pawn to Pawn interactions
		if(	MyGearPawn.CheckPawnToPawnInteractions(out_SpecialMove, out_InteractionPawn) )
		{
			MyGearPawn.DoPawnToPawnInteraction(out_SpecialMove, out_InteractionPawn);
			return TRUE;
		}
	}

	// check for potential interactions
	if (MyGearPawn != None)
	{
		foreach MyGearPawn.TouchingActors(class'Actor', TouchActor)
		{
			if (Trigger_ButtonInteraction(TouchActor) != None)
			{
				if (TouchActor.TriggerEventClass(class'SeqEvt_Interaction', MyGearPawn, -1, TRUE))
				{
					return FALSE;
				}
			}
			else if (Trigger_Engage(TouchActor) != None && Trigger_Engage(TouchActor).bIsEngagable && Trigger_Engage(TouchActor).EngagedPawn == None)
			{
				if (TouchActor.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents, TRUE))
				{
					EngageEvent = SeqEvt_Engage(EngageEvents[0]);
					if (EngageEvent != None && CanDoSpecialMove(SM_Engage_Start))
					{
						if (EngageEvent.bEnabled || EngageEvent.bPlayDisabledGUD)
						{
							return FALSE;
						}
					}
				}
			}
		}
	}

	if (TryALadderClimb())
	{
		return TRUE;
	}

	if ( GearBombDeliveryGRI(WorldInfo.GRI) != None && MyGearPawn != None)
	{
		// force ServerUse() if enemy bomb is nearby so it takes priority over pickups
		foreach MyGearPawn.CollidingActors(class'GearTrackBomb', Bomb, 128.0)
		{
			if (Bomb.Health > 0 && Bomb.TeamNum != GetTeamNum())
			{
				return false;
			}
		}
	}

	// check for fortifications to use
	if (GearPawnRidable_Base(MyGearPawn) == None &&
		MyGearPawn != None &&
		!MyGearPawn.IsCarryingAHeavyWeapon() && !MyGearPawn.IsAKidnapper())
	{
		foreach MyGearPawn.TouchingActors(class'GearFortification', Fort)
		{
			if (Fort.CanBeUsedBy(MyGearPawn))
			{
				ServerUseFortification(Fort);
				break;
			}
		}
	}

	if (MyGearPawn != None &&
		MyGearPawn.IsInCover() &&
		TryManipulateCover() )
	{
		return true;
	}

	//@warning: has to be in ClientUse() to avoid conflicts with weapon switching, which is client authoritative
	if (TryToPickupAWeapon(false))
	{
		return true;
	}

	return FALSE;
}

unreliable server function ServerReviveSelf()
{
	// if not MP DM  revive self
	if( /*!WorldInfo.GRI.IsMultiplayerGame() &&*/
	    MyGearPawn != None &&
		MyGearPawn.IsDBNO())
	{
		ServerReviveTeamMate(MyGearPawn);
	}
}

reliable server function ServerReviveTeamMate(GearPawn GP, optional bool bCheckDistance)
{
	//`log(self@GetFuncName()@P);

	//@note: distance check is not meant to be exact; just intended to validate revival attempt isn't really far away due to lag or whatever
	if (!bCheckDistance || (MyGearPawn != None && VSize(GP.Location - MyGearPawn.Location) <= class'GSM_ReviveTeammate'.default.ReviveSearchRadius * 2.0))
	{
		if (GP.IsDBNO())
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Revived, Pawn, GP);
		}

		GP.DoRevival(MyGearPawn);
	}
}


/**
 * TurretServerMove()
 * compressed version of server move for PlayerTurreting state
 */
unreliable server function TurretServerMove
(
	float	TimeStamp,
	vector	ClientLoc,
	bool	NewbDuck,
	byte	ClientRoll,
	int		View
)
{
	ServerMove(TimeStamp, Vect(0,0,0), ClientLoc, 0, ClientRoll, View);
}

/* DualTurretServerMove()
compressed version of server move for PlayerTurreting state
*/
unreliable server function DualTurretServerMove
(
	float	TimeStamp0,
	bool	NewbDuck0,
	byte	ClientRoll0,
	int		View0,
	float	TimeStamp,
	vector	ClientLoc,
	bool	NewbDuck,
	byte	ClientRoll,
	int		View
)
{
	ServerMove(TimeStamp0, vect(0,0,0), vect(0,0,0), 0, ClientRoll0, View0);
	ServerMove(TimeStamp, vect(0,0,0), ClientLoc, 0, ClientRoll, View);
}

/**
 * Only used in Kidnapped state
 *
 * @param PackedRotation - upper 16 bits are Yaw, lower 16 are Pitch
 */
unreliable server function ServerSetKidnappedRotation(int PackedRotation);

/**
 * Not moving during kidnapping, just replicate rotation over to the server
 */
state Kidnapped extends PlayerWalking
{
	ignores ProcessMove;

	/**
	 * Used to receive updated camera rotation from kidnapped client
	 *
	 * @param PackedRotation - upper 16 bits are Yaw, lower 16 are Pitch
	 */
	unreliable server function ServerSetKidnappedRotation(int PackedRotation)
	{
		local rotator UnpackedRotation;

		UnpackedRotation.Yaw = PackedRotation >> 16;
		UnpackedRotation.Pitch = PackedRotation & 65535;
		SetRotation(UnpackedRotation);
	}

	/**
	 * Let the server know which way we're rotated, using SavedMoves here can stomp our RelativeLocation
	 *
	 * @param DeltaTime - the length of the last frame
	 *
	 * @param NewAccel - any acceleration this frame
	 *
	 * @param DoubleClickMove - the double click move, if any, that is being done this frame
	 *
	 * @param DeltaRot - the change in rotation
	 */
	function ReplicateMove(float DeltaTime,	vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		ServerSetKidnappedRotation(((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));

		// make sure we still run physics, since we're in this state during the bag tag as well
		if (Pawn != None)
		{
			Pawn.AutonomousPhysics(DeltaTime);
		}
		else
		{
			AutonomousPhysics(DeltaTime);
		}
	}
}

state PlayerTurreting
{
ignores SeePlayer, HearNoise, Bump;

	unreliable server function TurretServerMove
	(
		float	TimeStamp,
		vector	ClientLoc,
		bool	NewbDuck,
		byte	ClientRoll,
		int		View
	)
	{
		Global.ServerMove(TimeStamp, Vect(0,0,0), ClientLoc, 0, ClientRoll, View);
	}

    function PlayerMove(float DeltaTime)
    {
		if( Pawn == None )
		{
			GotoState('dead');
			return;
		}

		UpdateRotation( DeltaTime );

		if( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
		else
		{
			ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		}
    }

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot);

    function BeginState(Name PreviousStateName)
    {
		Pawn.MaxPitchLimit = 16384; // extending pitch limit (limits network weapon aiming)

		if (Turret_MultiTurretBase(Pawn) != None)
		{
			TriggerGearEventDelegates(eGED_MultiTurret);
		}
		else
		{
			TriggerGearEventDelegates(eGED_Turret);
		}
    }

    function EndState(Name NextStateName)
    {
		if ( Pawn != None )
		{
			Pawn.MaxPitchLimit = Pawn.default.MaxPitchLimit; // restoring pitch limit
		}
	}

Begin:
}

reliable client function ClientColorFade(Color FadeColor, byte FromAlpha, byte ToAlpha, float FadeTime)
{
	if (MyGearHud != None)
	{
		MyGearHud.ColorFade( FadeColor, (FromAlpha == 0 ? MyGearHud.FadeAlpha : float(FromAlpha)), ToAlpha, FadeTime );
	}
}

reliable client event ClientSetViewTarget( Actor A, optional ViewTargetTransitionParams TransitionParams )
{
	//`log(GetFuncName() @ `showvar(A) @ `showvar(ViewTarget));

	if (A != None || ViewTarget == None)
	{
		Super.ClientSetViewTarget(A,TransitionParams);
	}
	else
	{
		if (!IsSpectating() || WorldInfo.GRI == None || !WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.GameClass.Name == 'GearGameTDM_Lambent')
		{
			//`log("Calling ServerVerifyViewTarget");
			ServerVerifyViewTarget();
		}
	}
}

function SetViewTarget( Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams  )
{
	local GearPlayerCamera GearCam;
	local GearSpectatorPoint SpectatorPt;

	//`log(WorldInfo.TimeSeconds@GetFuncName()@self@`showvar(NewViewTarget)@`showvar(ViewTarget));
	//ScriptTrace();

	Super.SetViewTarget(NewViewTarget, TransitionParams);

	// if viewing from a spectator point, align controller rot with it
	SpectatorPt = GearSpectatorPoint(NewViewTarget);
	if (SpectatorPt != None)
	{
		// init controller rot to the rot of the spectator point
		SetRotation(SpectatorPt.Rotation);
	}

	GearCam = GearPlayerCamera(PlayerCamera);
	if (GearCam != None)
	{
		// remove camera blood when switching viewtargets
		GearCam.ClearCameraLensEffects();
		if (TransitionParams.BlendTime <= 0.f)
		{
			// force immediate camera update
			GearCam.ResetInterpolation();
			GearCam.UpdateCamera(0.0);
		}
	}
}

/** Return the PRI of the player we are spectating, if applicable */
simulated function GearPRI GetSpectatingPRI()
{
	local Pawn PawnVT;
	PawnVT = Pawn(ViewTarget);
	if (PawnVT != None && PawnVT != Pawn)
	{
		return GearPRI(PawnVT.PlayerReplicationInfo);
	}

	return None;
}

simulated function bool IsViewingTarget(Actor TargetActor)
{
	if (GetViewTarget() == TargetActor)
	{
		// we don't consider "fixed" cameramode as viewing the target
		if ( (PlayerCamera != None) && (PlayerCamera.CameraStyle != 'Fixed') )
		{
			return TRUE;
		}
	}

	return FALSE;
};

// Possess a pawn
function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local GearPawn OtherP;

	MyGearPawn = GearPawn(aPawn);

	//`log(PlayerReplicationInfo.PlayerName$" Possess with old pawn "$Pawn$" targeting "$bIsTargeting$" assess "$bAssessMode);
	//`log(bBreakFromCover@bServerMoveCoverActive@bSuccessfullyTookCover@bSuccessfullyExitedCover@bHoldingAFromRoadieRun@CoverTransitionCountHold@CoverTransitionCountDown);
	bPreciseDestination = false;
	bIgnoreMoveInput = 0;
	bIgnoreLookInput = 0;
	bBreakFromCover = false;
	bServerMoveCoverActive = false;
	CoverTransitionCountHold = 0;
	CoverTransitionCountDown = 0;

	// Remove AI hacks in case a player controller is possessing us (ie dom in split screen!)
	// See GearAI::Possess()
	if( MyGearPawn != None )
	{
		MyGearPawn.bDoWalk2IdleTransitions = MyGearPawn.default.bDoWalk2IdleTransitions;
		MyGearPawn.bAllowSpeedInterpolation = MyGearPawn.default.bAllowSpeedInterpolation;
		MyGearPawn.Run2CoverMaxDist = MyGearPawn.default.Run2CoverMaxDist;
		MyGearPawn.bCanJump = MyGearPawn.default.bCanJump;
		MyGearPawn.bCanCrouch = MyGearPawn.default.bCanCrouch;

		// if our new pawn needs the health of its allies, mark them dirty so that the health is checked for replication
		//@todo: could do in C++ and only mark them dirty for this client - worth it?
		if (MyGearPawn.bSeesTaccomMeshForInjuredAllies)
		{
			foreach WorldInfo.AllPawns(class'GearPawn', OtherP)
			{
				if (OtherP.PlayerReplicationInfo != None && OtherP.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				{
					OtherP.bNetDirty = true;
				}
			}
		}
	}

	// If I'm a berserker, turn on the blind effects
	if (GearPawn_LocustBerserkerBase(aPawn) != None)
	{
		ClientToggleBlindEffects(true);
	}

	Super.Possess(aPawn, bVehicleTransition);
}

reliable client function ClientRestart(Pawn NewPawn)
{
	local bool bSkipFadeIn;

	//`log(PlayerReplicationInfo.PlayerName$" ClientRestart with old pawn "$Pawn$" targeting "$bIsTargeting$" assess "$bAssessMode);
	//`log(bBreakFromCover@bServerMoveCoverActive@bSuccessfullyTookCover@bSuccessfullyExitedCover@bHoldingAFromRoadieRun@CoverTransitionCountHold@CoverTransitionCountDown);
	bPreciseDestination = false;
	bIgnoreMoveInput = 0;
	bIgnoreLookInput = 0;
	InputIsDisabledCount = 0;
	bFire = 0;

	bBreakFromCover = false;
	bServerMoveCoverActive = false;
	CoverTransitionCountHold = 0;
	CoverTransitionCountDown = 0;
	ResetPlayerMovementInput();

	// The authority has already saved LastPawn in UnPossess() and overwritten Pawn with NewPawn in Possess()
	// We need to be careful for the multiple ClientRestart calls that could come from GivePawn
	if (Role != ROLE_Authority && NewPawn != Pawn)
	{
		LastPawn = Pawn;
	}

	Pawn = NewPawn;
	MyGearPawn = GearPawn(NewPawn);
	if ( (Pawn != None) && Pawn.bTearOff )
	{
		UnPossess();
		Pawn = None;
	}
	AcknowledgePossession(Pawn);
	if ( Pawn == None )
	{
		GotoState('WaitingForPawn');
		return;
	}

	Pawn.ClientRestart();

	`LogTrace( 'Gear_VehicleSystem', "GearPC: Setting ViewTarget for: " $ self $ " to pawn: " $ Pawn ) ;
	if (Role < ROLE_Authority)
	{
		SetViewTarget(Pawn);
		ResetCameraMode();

		EnterStartState();
	}
	CleanOutSavedMoves();

	// if we have a valid HUD and Pawn then force the scoreboard off
	if (MyGearHud != None && MyGearPawn != None)
	{
		MyGearHud.Reset();
		MyGearHud.bShowScores = FALSE;

		// Entering and exiting a non-GearPawn should skip the fade
		if ((LastPawn != None && !ClassIsChildOf(LastPawn.Class, class'GearPawn')) ||
			(Pawn != None && !ClassIsChildOf(Pawn.Class, class'GearPawn')))
		{
			bSkipFadeIn = TRUE;
		}

		// Entering and exiting the Silverback should skip the fade
		if ((LastPawn != None && ClassIsChildOf(LastPawn.Class, class'GearPawnRidable_Base')) ||
			(Pawn != None && ClassIsChildOf(Pawn.Class, class'GearPawnRidable_Base')))
		{
			bSkipFadeIn = TRUE;
		}

		// show the tac/com briefly at the beginning of a round
		if (!bSkipFadeIn && WorldInfo.GRI.IsMultiplayerGame())
		{
			// always fade in from black when spawning
			MyGearHud.SpectatorCameraFadeIn();
		}

		PopulateDBNOLocators();
		PopulateSpottedEnemyLocators();
		PopulateSpottedPickupLocators();
	}

	GearPlayerInput(PlayerInput).ForcePitchCentering(FALSE);

	StopForcedAdhesion();

	//@HACK: failsafe to make sure client doesn't get stuck faded to black due to
	//	matinee/Kismet/camera fighting over the same properties (plus network ordering issues)
	if (WorldInfo.NetMode == NM_Client && WorldInfo.GRI != None && !WorldInfo.GRI.IsMultiplayerGame())
	{
		SetTimer(1.0, true, nameof(CameraFadeVerificationHack));
	}
}

//@HACK: failsafe to make sure client doesn't get stuck faded to black due to
//	matinee/Kismet/camera fighting over the same properties (plus network ordering issues)
final simulated function CameraFadeVerificationHack()
{
	if ( WorldInfo.NetMode == NM_Client && !bCinematicMode && !bInMatinee && PlayerCamera != None &&
		PlayerCamera.bEnableFading && PlayerCamera.FadeAmount >= 1.0 && PlayerCamera.FadeTimeRemaining <= 0.0 )
	{
		ServerVerifyCameraFade();
	}
}
unreliable server function ServerVerifyCameraFade()
{
	local GearPC PC;

	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC.PlayerCamera != None && (!PC.PlayerCamera.bEnableFading || PC.PlayerCamera.FadeAmount <= 0.0))
		{
			ClientSetCameraFade(PC.PlayerCamera.bEnableFading, PC.PlayerCamera.FadeColor, PC.PlayerCamera.FadeAlpha, 0.01);
		}
	}
}

/** Overridden to clear any cover claims this pawn might have had. */
function UnPossess()
{
	// unclaim the cover if necessary
	if (MyGearPawn != None &&
		MyGearPawn.CurrentLink != None)
	{
		MyGearPawn.CurrentLink.UnClaim(MyGearPawn,-1,TRUE);
	}
	MyGearPawn = None;
	if (Pawn != None)
	{
		SetLocation(Pawn.Location);
		if (Role == ROLE_Authority)
		{
			Pawn.RemoteRole = ROLE_SimulatedProxy;
		}
		Pawn.UnPossessed();
		CleanOutSavedMoves();  // don't replay moves previous to unpossession
	}

	// Save the last Pawn used
	LastPawn = Pawn;

	Pawn = None;
	SetViewTarget(self);

	CachedCanDoCoverActionSpecialMoves.length=0;
	CachedCanDoGlobalActionSpecialMoves.length=0;

	// Make sure the berserker blind effects are turned off
	ClientToggleBlindEffects(false);
}

event ResetCameraMode()
{
	local GearPlayerCamera GearCam;

	// clear out any shakes when resetting the camera
	GearCam = GearPlayerCamera(PlayerCamera);
	if (GearCam != None)
	{
		GearCam.ClearAllCameraShakes();
	}

	if (Pawn == None)
	{
		SetCameraMode('Default');
	}
	else
	{
		Super.ResetCameraMode();
	}
}

/**
 * Additional console commands for killing various players, strictly for
 * testing purposes.
 */
exec function Kill(optional string type)
{
	local Controller chkPlayer;
	local GearPawn deadPawn;
	local Vehicle_Reaver_Base deadReaver;
	local Vehicle V;

	local AIController ai;
	if (type ~= "ai" || type ~= "bots" || type ~= "all")
	{
		foreach DynamicActors(class'AIController',ai)
		{
			V = Vehicle(ai.Pawn);
			if( V != None )
			{
				V.DriverLeave( TRUE );
			}

			deadPawn = GearPawn(ai.Pawn);
			if (deadPawn != None)
			{
				deadPawn.ScriptedDeath();
			}
			ai.Destroy();
		}
	}
	else if (type ~= "enemy" || type ~= "enemies" || type ~= "badguys")
	{
		foreach DynamicActors(class'Controller',chkPlayer)
		{
			if (chkPlayer.PlayerReplicationInfo.Team != PlayerReplicationInfo.Team)
			{
				// Handle reaver
				deadReaver = Vehicle_Reaver_Base(chkPlayer.Pawn);
				V = Vehicle(chkPlayer.Pawn);

				if( deadReaver != None)
				{
					deadReaver.VehicleScriptedDeath();
				}
				else if( V != None )
				{
					V.DriverLeave( TRUE );
				}

				deadPawn = GearPawn(chkPlayer.Pawn);
				if (deadPawn != None)
				{
					deadPawn.ScriptedDeath();
				}
				// only destroy non-player controllers since that drops their connection
				if (GearPC(chkPlayer) == None)
				{
					chkPlayer.Destroy();
				}
			}
		}
	}
	else if( type ~= "friend" || type ~= "friends" || type ~= "goodguys" || type ~= "friendlies" )
	{
		foreach DynamicActors( class'Controller', chkPlayer )
		{
			if( chkPlayer != self && chkPlayer.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team )
			{
				V = Vehicle(chkPlayer.Pawn);
				if( V != None )
				{
					V.DriverLeave( TRUE );
				}

				deadPawn = GearPawn(chkPlayer.Pawn);
				if( deadPawn != None )
				{
					chkPlayer.bGodMode = FALSE;
					deadPawn.TakeDamage(deadPawn.Health+1, None, deadPawn.Location, vect(0,0,0), class'GDT_ScriptedRagdoll');
					//deadPawn.Died( self, class'DamageType', deadPawn.Location + vect(0,0,32) );
					//deadPawn.Destroy();
				}
				//chkPlayer.Destroy();
			}
		}
	}
	else
	{
		foreach DynamicActors( class'Controller', chkPlayer )
		{
			if( chkPlayer != self &&
				(String(chkPlayer.Name) ~= type ||
				(chkPlayer.Pawn != None && String(chkPlayer.Pawn.Name) ~= type)) )
			{
				deadPawn = GearPawn(chkPlayer.Pawn);
				if( deadPawn != None )
				{
					deadPawn.ScriptedDeath();
				}
				chkPlayer.Destroy();
			}
		}
	}
}

reliable client function ClientResetCameraInterpolation()
{
	GearPlayerCamera(PlayerCamera).ResetInterpolation();
	StopCameraBoneAnim(0.f, FALSE);
}

// Player Driving a vehicle.
state PlayerDriving
{
	ignores SeePlayer, HearNoise, Bump;

	function BeginState( Name PreviousStateName )
	{
		local GearWeaponPawn GearWP;

		GetPRI().PlayerStatus = WPS_Alive;

		// Kill post process overrides for all types except menus, which handle their own post process on close with custom blend out time
		if (CurrentPPType != eGPP_Menu)
		{
			StopPostProcessOverride(CurrentPPType);
		}

		GearPlayerCamera(PlayerCamera).ResetInterpolation();
		Super.BeginState(PreviousStateName);

		// Reset gas pedal parameters to 0.0
		VehicleGasPressedAmount = 0.0f;
		VehicleReversePressedAmount = 0.0f;

		// See if we need to attach any components locally
		if (IsLocalPlayerController())
		{
			GearWP = GearWeaponPawn(Pawn);
			if (GearWP != None &&
				GearWP.MyVehicle != None)
			{
				GearWP.MyVehicle.AttachLocalComponents(self);
			}
		}
	}


	function EndState( Name NextStateName )
	{
		local GearWeaponPawn GearWP;

		// See if we need to Detach any components locally
		if (IsLocalPlayerController())
		{
			GearWP = GearWeaponPawn(Pawn);
			if (GearWP != None &&
				GearWP.MyVehicle != None)
			{
				GearWP.MyVehicle.DetachLocalComponents(self);
			}
		}

		Super.EndState( NextStateName );
	}

	function PlayerTick( float DeltaTime )
	{
		local float JRight, JUp;
		local GearVehicleBase GearV;
		local Name DesiredSoundMode;
		local bool bNewIsTargeting;

		local GearGameplayCamera Cam;
		Cam = GearPlayerCamera(PlayerCamera).GameplayCam;

		// Checks to see if the profile settings should update the player settings
		CheckForProfileUpdate();

		if (Cam != None && !WorldInfo.bPlayersOnly)
		{
			JRight = PlayerInput.RawJoyLookRight;
			JUp = PlayerInput.RawJoyLookUp;

			// pass arong right stick values to the camera
			if (JRight > 0.7f)
			{
				Cam.DirectLookYaw = 16384;
			}
			else if (JRight < -0.7f)
			{
				Cam.DirectLookYaw = -16384;
			}
			else if (JUp < -0.7f)
			{
				Cam.DirectLookYaw = 32768;
			}
			else
			{
				Cam.DirectLookYaw = 0;
			}
		}

		UpdateHUDActions(DeltaTime);

		GearV = GearVehicleBase(Pawn);
		if (GearV != None && GearV.IsLocallyControlled())
		{
			bNewIsTargeting = GearV.AllowTargetting() && WantsToTarget();
			if( bIsTargeting != bNewIsTargeting )
			{
				SetTargetingMode(bNewIsTargeting);
			}
		}

		// Need to do this so we can do aim-assist while aiming in a vehicle
		MaintainEnemyList();

		DesiredSoundMode = FindBestSoundMode();
		if (DesiredSoundMode != CurrentSoundMode)
		{
			SetSoundMode(DesiredSoundMode);
		}

		// @fixme: this won't eventually call the global GearPC.PlayerTick!
		Super.PlayerTick(DeltaTime);
	}

	function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
	{
		local GearVehicle		MyGearVehicle;
		local GearWeaponPawn	MyWeapPawn;
		local Rotator		BaseRot, DesiredViewRotation, LocalViewRot;
		local int			CamCenterDelta;
		local int           ViewPitchMin, ViewPitchMax;
		local bool			bPassenger;
		local quat			BaseQuat, RelViewQuat, ViewQuat;
		local bool			bVehicleSpaceCam;
		local int			MySeatIndex;

		// If in passenger seat - look to main vehicle for cam stuff
		MyWeapPawn = GearWeaponPawn(Pawn);
		if(MyWeapPawn != None)
		{
			MyGearVehicle = MyWeapPawn.MyVehicle;
			MySeatIndex = MyWeapPawn.MySeatIndex;
			bPassenger = TRUE;
			ViewPitchMin = MyWeapPawn.ViewPitchMin;
			ViewPitchMax = MyWeapPawn.ViewPitchMax;
		}
		else
		{
			MyGearVehicle = GearVehicle(Pawn);
			ViewPitchMin = MyGearVehicle.ViewPitchMin;
			ViewPitchMax = MyGearVehicle.ViewPitchMax;
			MySeatIndex = 0;
		}

		// Look at relevant 'vehicle space cam' flag.
		if (MyGearVehicle != None)
		{
			bVehicleSpaceCam = bPassenger ? MyGearVehicle.bPassengerVehicleSpaceCamera : MyGearVehicle.bVehicleSpaceCamera;
		}

		if (MyGearVehicle != None && !MyGearVehicle.bUsingLookSteer && bVehicleSpaceCam)
		{
			if(MyGearVehicle.ShouldCenterCamSpaceCamera())
			{
				// avoid overshoot
				if(RelativeToVehicleViewRot.Yaw > 0)
				{
					CamCenterDelta = -(DeltaTime * MyGearVehicle.VehicleSpaceCamCenterSpeed);
					CamCenterDelta = Max(CamCenterDelta, -RelativeToVehicleViewRot.Yaw);
				}
				else if(RelativeToVehicleViewRot.Yaw < 0)
				{
					CamCenterDelta = (DeltaTime * MyGearVehicle.VehicleSpaceCamCenterSpeed);
					CamCenterDelta = Min(CamCenterDelta, -RelativeToVehicleViewRot.Yaw);
				}

				RelativeToVehicleViewRot.Yaw += CamCenterDelta;
			}
			else
			{
				// Add Delta Rotation
				RelativeToVehicleViewRot += DeltaRot;

				// If desired, clamp yaw of cam relative to vehicle
				if(MyGearVehicle.MaxVehicleSpaceCamYaw != 0)
				{
					RelativeToVehicleViewRot.Yaw = Clamp(RelativeToVehicleViewRot.Yaw, -MyGearVehicle.MaxVehicleSpaceCamYaw, MyGearVehicle.MaxVehicleSpaceCamYaw);
				}
			}

			// Make sure in sensible range
			RelativeToVehicleViewRot = Normalize(RelativeToVehicleViewRot);

			// Limit pitch
			RelativeToVehicleViewRot = LimitViewRotation( RelativeToVehicleViewRot, ViewPitchMin, ViewPitchMax );

			// Limit yaw
			if (MyGearVehicle.Seats[MySeatIndex].ViewYawDelta != 0)
			{
				RelativeToVehicleViewRot.Yaw = ClampRotAxisFromBase(RelativeToVehicleViewRot.Yaw, MyGearVehicle.Seats[MySeatIndex].ViewYawCenter, MyGearVehicle.Seats[MySeatIndex].ViewYawDelta);
			}

			BaseRot = MyGearVehicle.GetVehicleSpaceCamRotation(DeltaTime, bPassenger, MySeatIndex);

			if (MyGearVehicle.bOnlyInheritVehicleSpaceYaw)
			{
				BaseRot.Pitch = 0;
				BaseRot.Roll = 0;
				DesiredViewRotation = BaseRot + RelativeToVehicleViewRot;
			}
			else
			{
				DesiredViewRotation = RTransform(RelativeToVehicleViewRot, BaseRot);
			}

			if (MyGearVehicle.VehicleSpaceCamBlendTime <= 0.0)
			{
				out_ViewRotation = DesiredViewRotation;
			}
			else
			{
				out_ViewRotation = RInterpTo(LastVehicleSpaceViewRotation, DesiredViewRotation, DeltaTime, 1.0/MyGearVehicle.VehicleSpaceCamBlendTime);
			}
			LastVehicleSpaceViewRotation = out_ViewRotation;

			DeltaRot = rot(0,0,0);
		}
		else if(MyGearVehicle != None && MyGearVehicle.bVehicleSpaceViewLimits)
		{
			// First, update view rotation
			out_ViewRotation += DeltaRot;

			// Get vehicle ref frame
			BaseRot = MyGearVehicle.GetVehicleSpaceCamRotation(DeltaTime, bPassenger);
			BaseQuat = QuatFromRotator(BaseRot);

			// Transform rotator into vehicle space
			ViewQuat = QuatFromRotator(out_ViewRotation);
			RelViewQuat = QuatProduct(QuatInvert(BaseQuat), ViewQuat);
			LocalViewRot = QuatToRotator(RelViewQuat);

			LocalViewRot.Roll = 0;

			// Limit yaw (vehicle space)
			MyGearVehicle.bPushingAgainstViewLimit = FALSE;
			if(MyGearVehicle.MaxVehicleSpaceCamYaw != 0)
			{
				// If beyond lower limit
				if( LocalViewRot.Yaw < -MyGearVehicle.MaxVehicleSpaceCamYaw )
				{
					// On owning client - And pushing left - set 'pushing' flag
					if(LocalPlayer(Player) != None && PlayerInput.RawJoyLookRight < -0.1)
					{
						MyGearVehicle.bPushingAgainstViewLimit = TRUE;
						// keep pitch constant when against the limit
						LocalViewRot.Pitch = LastVehicleSpaceViewRotation.Pitch;
					}
					LocalViewRot.Yaw = -MyGearVehicle.MaxVehicleSpaceCamYaw;
				}
				// If beyond upper limit
				else if( LocalViewRot.Yaw	> MyGearVehicle.MaxVehicleSpaceCamYaw )
				{
					// On owning client - And pushing right - set 'pushing' flag
					if(LocalPlayer(Player) != None && PlayerInput.RawJoyLookRight > 0.1)
					{
						MyGearVehicle.bPushingAgainstViewLimit = TRUE;
						LocalViewRot.Pitch = LastVehicleSpaceViewRotation.Pitch;
					}
					LocalViewRot.Yaw = MyGearVehicle.MaxVehicleSpaceCamYaw;
				}
			}

			// Limit pitch (vehicle space)
			LocalViewRot = LimitViewRotation( LocalViewRot, ViewPitchMin, ViewPitchMax );

			// Limit yaw
			if (MyGearVehicle.Seats[MySeatIndex].ViewYawDelta != 0)
			{
				LocalViewRot.Yaw = ClampRotAxisFromBase(LocalViewRot.Yaw, MyGearVehicle.Seats[MySeatIndex].ViewYawCenter, MyGearVehicle.Seats[MySeatIndex].ViewYawDelta);
			}

			// Save old rotation in case we want to keep pitch constant
			LastVehicleSpaceViewRotation = LocalViewRot;

			// Transform rotator into world space
			RelViewQuat = QuatFromRotator(LocalViewRot);
			ViewQuat = QuatProduct(BaseQuat, RelViewQuat);
			out_ViewRotation = QuatToRotator(ViewQuat);
			out_ViewRotation.Roll = 0;
		}
		else
		{
			Super.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
		}
	}

	function PlayerMove( float DeltaTime )
	{
		local GearVehicle	MyGearVehicle;
		local FLOAT			Forward, Strafe, Up;

		// update 'looking' rotation
		UpdateRotation(DeltaTime);

		// Remap input
		MyGearVehicle = GearVehicle(Pawn);
		if( MyGearVehicle != None )
		{
			MyGearVehicle.RemapPlayerInput(Self, Forward, Strafe, Up);
		}

		// TODO: Don't send things like aForward and aStrafe for gunners who don't need it
		// Only servers can actually do the driving logic.
		ProcessDrive(Forward, Strafe, Up, bPressedJump);
		if (Role < ROLE_Authority)
		{
			ServerDrive(Forward, Strafe, Up, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
		}

		bPressedJump = FALSE;
	}
}


/* epic ===============================================
* ::CheckNearMiss
*
* Check if bullet went close by my pawn.
*
* =====================================================
*/
function CheckNearMiss(Pawn Shooter, GearWeapon GearWeap, const out ImpactInfo Impact, class<DamageType> InDamageType)
{
	local float NearMissDist;
	local vector ClosestPoint;

	// Find closest distance to segment bullet travelled.
	NearMissDist = PointDistToSegment(MyGearPawn.Location, Impact.StartTrace, Impact.HitLocation, ClosestPoint);

	// Play bullet whip sounds
	if (GearWeap.BulletWhipArchetype != None && NearMissDist < Player_BulletWhipDistance && (MyGearPawn.LastBulletWhipTime + GearWeap.BulletWhipArchetype.MinTimeBetweenBulletWhips) < WorldInfo.TimeSeconds)
	{
		// only play the sound on the clients
		if (Impact.HitActor != MyGearPawn)
		{
			//`log( "Should Hear a Whip sound" @ GearWeapon(W).WeaponWhipSound );
			// only play a whip sound if the bullet flew past you and
			// if it did NOT impact something
			ClientHearSound(GearWeap.BulletWhipArchetype.WeaponWhipSound, Shooter, ClosestPoint, false, !FastTrace(MyGearPawn.Location, ClosestPoint));
		}

		MyGearPawn.LastBulletWhipTime = WorldInfo.TimeSeconds;
	}

	// Let our Pawn know we got a near miss.
	// Cringes
	if (NearMissDist < Player_NearMissDistance)
	{
		MyGearPawn.RegisterNearHitMiss(Impact, InDamageType);
	}
}

reliable server function ServerDebugCover(bool bNewDebugCover)
{
	bDebugCover = bNewDebugCover;
}

/** Set basic cover debugging flags */
function SetBasicCoverDebug(GearPawn P, bool bFlag)
{
	if( P != None )
	{
		P.bCoverDebug_PlayerFOV			= bFlag;
		P.bCoverDebug_CoverFOV			= bFlag;
		P.bCoverDebug_CoverVolume		= bFlag;
		P.bCoverDebug_FoundCover		= bFlag;
		P.bCoverDebug_ValidatedCover	= bFlag;
		P.bCoverDebug_ConsideredLinks	= bFlag;
	}
}

/**
 * Overridden to hook any debug draw functions.
 */
reliable client function ClientSetHUD(class<HUD> newHUDType)
{
	//local color FadeColor;

	Super.ClientSetHUD(newHUDType);

	MyGearHud = GearHud_Base(MyHud);
	if (MyGearHud != None)
	{
`if(`notdefined(FINAL_RELEASE))
		if (CheatManager != None)
		{
			MyGearHud.SetDebugDraw(GearCheatmanager(CheatManager).DebugDraw_Cover,bDebugCover);
			MyGearHud.SetDebugDraw(GearCheatManager(CheatManager).DebugDraw_AI,bDebugAI);
		}
`endif
		RefreshAllSafeZoneViewports();
	}
}

simulated protected function bool TargetIsValidMeleeAdhesionTarget(GearPawn TestGP)
{
	if (!TestGP.IsEvading())
	{
		return FALSE;
	}

	if (!MyGearPawn.TargetIsValidMeleeTarget(TestGP, FALSE))
	{
		return FALSE;
	}

	return TRUE;
}

/**
 * Try to find a nearby target to adhere to, used for melee attacks.  See also
 * StopMeleeAdhesion.
 * Returns Pawn we decided to adhere to, or None if there wasn't one
 */
simulated function GearPawn AttemptMeleeAdhesion()
{
	local GearPawn	TestWP;
	local vector	ToTestWPNorm;
	local float		ToTestWPDist;
	local GearPawn	BestTarget;
	local float		BestTargetScore, DotToTarget;
	local float		DistScore, DirScore, TotalScore, SearchRadius;

	SearchRadius = MyGearPawn.GetMeleeAttackRange();

	BestTargetScore = -99999.f;
	BestTarget = None;

	// @fixme, increase range a bit in case we are moving towards enemy?
	foreach MyGearPawn.CollidingActors( class'GearPawn', TestWP, SearchRadius )
	{
		//`log( "AttemptMeleeAdhesion TestWP: " $ TestWP );

		if( TargetIsValidMeleeAdhesionTarget(TestWP) )
		{
			// get mag and normalize with only 1 sqrt
			ToTestWPNorm = TestWP.Location - MyGearPawn.Location;
			ToTestWPDist = VSize(TestWP.Location - MyGearPawn.Location);
			ToTestWPNorm /= ToTestWPDist;

			// distance score (-1 pt per unit distance ftw)
			// maybe take velocity into account when determining distance score?
			DistScore = SearchRadius - ToTestWPDist;

			// directional score (512 dead ahead, -512 behind, 0 at the sides)
			DotToTarget = ToTestWPNorm dot vector(MyGearPawn.Rotation);

			// make sure dir is within limits
			if( DotToTarget < MinMeleeAdhesionDotValue )
			{
				continue;
			}
			DirScore = DotToTarget * SearchRadius;

			TotalScore = DirScore + DistScore;
			if( TotalScore > BestTargetScore )
			{
				BestTarget = TestWP;
				BestTargetScore = TotalScore;
			}
		}
	}

	// Only adhere if the target is evading
	if (BestTarget != None)
	{
		//`log("chose"@BestTarget@"as best melee target to lock onto.  Score:"@BestTargetScore);

		MeleeAdhesionTarget = BestTarget;
	}

	return BestTarget;
}

/**
 * Stops any melee adhesion that is going on.
 */
simulated function StopMeleeAdhesion()
{
	MeleeAdhesionTarget = None;
}

/**
 * Turns off forced adhesion.
 */
simulated function StopForcedAdhesion()
{
	ForcedAdhesionTarget = None;
}

simulated final protected function VerifyAdhesionTargets()
{
	if( ForcedAdhesionTarget != None && !ForcedAdhesionTarget.IsValidEnemyTargetFor( PlayerReplicationInfo, TRUE ) )
	{
		StopForcedAdhesion();
	}
	if( MeleeAdhesionTarget != None && !MeleeAdhesionTarget.IsValidEnemyTargetFor( PlayerReplicationInfo, TRUE ) )
	{
		StopMeleeAdhesion();
	}
}

native function ZoomToMap( string MapName );
native function string GetCurrMapName();

exec function Revive()
{
	ServerReviveSelf();
}

// our old friend "the rez system" has returned to pay us a visit
function GotoReviving()
{
	//`log( "GotoReviving" );
	GotoState( 'Reviving' );
}

function GotoPlayerWalking()
{
	ServerGotoPlayerWalking();
	//`log( "GotoPlayerWalking" );
	GotoState( 'PlayerWalking' );
	if (Pawn.Physics != PHYS_Walking)
	{
		Pawn.SetPhysics(PHYS_Falling);
	}

}

unreliable server function ServerGotoPlayerWalking()
{
	//`log( "ServerGotoPlayerWalking" );
	GotoState( 'PlayerWalking' );
	if (Pawn.Physics != PHYS_Walking)
	{
		Pawn.SetPhysics(PHYS_Falling);
	}
}

simulated function SetReviveIcon()
{
	local GearGRI GRI;
	local GearPawn GP;

	if (MyGearHUD != None)
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI.bAutoReviveOnBleedOut)
		{
			GP = GearPawn(Pawn);
			if (GP!=none)
			{
				// if it's not playing reviving animation yet - just playing default one
				if ( GP.bPlayingSelfReviving == FALSE )
				{
					MyGearHUD.SetActionInfo( AT_StayingAlive, ActionStayingAliveAutoRevive );
				}
				// if it's after stage 1, we just let it go - he's done
				else if ( GP.CurrentReviveStage >= 1 )
				{
 					MyGearHUD.SetActionInfo( AT_StayingAlive, ActionStayingAliveAutoRevived );
				}
				else // if not, it's reviving, so let it play reviving
				{
					MyGearHUD.SetActionInfo( AT_StayingAlive, ActionStayingAliveAutoReviving );
				}
			}
		}
		else
		{
			MyGearHUD.SetActionInfo( AT_StayingAlive, ActionStayingAlive );
		}
	}
}

simulated function SetReviveIconAnimationSpeed()
{
	local float PercentAlive, MinSpeed, MaxSpeed;

	if ( (MyGearPawn != None) && (MyGearHUD.ActiveAction.ActionType == AT_StayingAlive) )
	{
		MinSpeed = 0.5f;
		MaxSpeed = 0.05f;
		PercentAlive = MyGearHUD.CalculateRevivePercentAlive( MyGearPawn );
		MyGearHUD.ActiveAction.IconAnimationSpeed = (MinSpeed - MaxSpeed) * PercentAlive + MaxSpeed;
	}
}

/**
 *	Pass DBNO notification to squad for possible action
 */
final private function NotifySquadDBNO()
{
	if( Squad != None )
	{
		Squad.NotifyMemberDBNO( GearPawn(Pawn) );
	}
}

/** Handles logic for boosting the crawl speed when mashing the action button */
function PressedActionButton_Reviving()
{
	if (!IsTimerActive('CrawlSpeedRetriggerDelay'))
	{
		if (MyGearPawn.CrawlSpeedModifier < 0.7f)
		{
			MyGearPawn.AlterCrawlSpeed(0.1f);
		}
		// reset the retrigger delay even if speed didn't change to avoid spam at max modifier
		SetTimer( 0.2f,FALSE,nameof(CrawlSpeedRetriggerDelay) );
	}
	// reset the decay timer so that repeated mashes sustain the current speed
	SetTimer( 0.5f,FALSE,nameof(ReduceCrawlSpeed) );
}

/** Stub function to prevent retriggering the boost for a fixed period. */
function CrawlSpeedRetriggerDelay();

/** Reduces the crawl speed boost. */
function ReduceCrawlSpeed()
{
	if ( MyGearPawn!=none )
	{
		MyGearPawn.AlterCrawlSpeed(-0.1f);
		if (MyGearPawn.CrawlSpeedModifier > 0.f)
		{
			SetTimer( 0.3f,FALSE,nameof(ReduceCrawlSpeed) );
		}
	}
}

/** Internal.  Returns true if playing a debug/development level, false otherwise. */
simulated function bool PlayingDevLevel()
{
`if(`notdefined(FINAL_RELEASE))
	local string MapName;

	MapName = Locs(GetCurrMapName());

	if ( (InStr(MapName, 'poc_',,true) == 0) || (InStr(MapName, 'dp_',,true) == 0) ||
		 (InStr(MapName, 'stonehenge',,true) != INDEX_NONE) || (InStr(MapName, 'test',,true) != INDEX_NONE) )
	{
		return TRUE;
	}
`endif

	return FALSE;
}

final function CheckSurvivalChance()
{
	if (!PlayingDevLevel() && !GearGame(WorldInfo.Game).TeamHasAnyChanceOfSurvival(GetTeamNum()))
	{
		MyGearPawn.bCanRecoverFromDBNO = false;
		MyGearPawn.DoFatalDeath(self,class'GDT_BledOut',MyGearPawn.Location,vect(0,0,1));
		if (!IsTimerActive(nameof(ProcessGameOver)))
		{
			GameOverReason = "GearGame.GearGameSP_Base.PlayerDiedText";
			GameOverTarget = GearPRI(PlayerReplicationInfo);
			SetTimer(3.0, false, nameof(ProcessGameOver));
		}
		ClearTimer(nameof(CheckSurvivalChance));
	}
}

simulated state Reviving extends PlayerWalking
{
	event BeginState(Name PreviousStateName)
	{
		local GearInventoryManager	InvManager;
		local GearPawn GP;

		if ( (Role == ROLE_Authority) && !IsLocalPlayerController() )
		{
			bRequestClientVerifyState = true;
		}
		// Turn off targeting when you die
		bIsTargeting = FALSE;
		SetTargetingMode( FALSE );

		GP = GearPawn(Pawn);
		if (IsLocalPlayerController() && GP != None && GP.IsDoingSpecialMove(SM_DBNO))
		{
			StartPostProcessOverride(eGPP_BleedOut);
		}

		if( !WorldInfo.GRI.IsMultiplayerGame() )
		{
			// won't have HUD for remote clients on server
			if (MyGearHUD != None)
			{
				SetReviveIcon();
				SetReviveIconAnimationSpeed();
			}

			// if we are in a solo split, there is no one to revive us so this is game over
			if (Role == ROLE_Authority && !WorldInfo.IsPlayInEditor() && !PlayingDevLevel())
			{
				if (!PlayingDevLevel() && !GearGame(WorldInfo.Game).TeamHasAnyChanceOfSurvival(GetTeamNum()))
				{
					MyGearPawn.bCanRecoverFromDBNO = false;
					GameOverReason = "GearGame.GearGameSP_Base.PlayerDiedText";
					GameOverTarget = GearPRI(PlayerReplicationInfo);
					SetTimer(3.0, false, nameof(ProcessGameOver));
				}
				else
				{
					SetTimer(1.0, true, nameof(CheckSurvivalChance));
				}
			}
		}
		else if( MyGearHUD != None ) // won't have HUD for remote clients on server
		{
			if ( (MyGearPawn != None) && (MyGearPawn.MyGearWeapon != None) &&
				MyGearPawn.MyGearWeapon.CanMartyr() )
			{
				MyGearHUD.SetActionInfo(AT_SuicideBomb, ActionSuicideBomb);
			}
			else
			{
				SetReviveIcon();
				SetReviveIconAnimationSpeed();
			}
		}

		InvManager = GearInventoryManager(Pawn.InvManager);
		if ( InvManager != None )
		{
			InvManager.bShowWeaponSlots = FALSE;
		}

		bFire = 0;
		StopFire(0);

		// Notify squad that I need to be revived
		SetTimer( 0.5f, FALSE, nameof(NotifySquadDBNO) );

		// Trigger is crawling delegate
		TriggerGearEventDelegates( eGED_Crawling );

		if (Pawn != None)
		{
			Pawn.ShouldCrouch(false);
			if (Pawn.Physics != PHYS_Falling && Pawn.Physics != PHYS_RigidBody)
			{
				Pawn.SetPhysics(Pawn.WalkingPhysics);
			}
		}
	}

	event EndState(Name NextStateName)
	{
		ClearTimer(nameof(CheckSurvivalChance));

		GearPlayerCamera(PlayerCamera).SetDesiredColorScale(vect(1.0f,1.0f,1.0f),1.0f);

		BiggestThreatWP = None;
		ClearFocusPoint(FALSE);		// clear both kismet and nonkismet lookats
		ClearFocusPoint(TRUE);

		ClearTimer(nameof(CheckSurvivalChance));

		if (NextStateName != 'Dead' && CurrentPPType == eGPP_BleedOut)
		{
			StopPostProcessOverride(eGPP_BleedOut);
		}

		if (MyGearHUD != None) // won't have HUD for remote clients on server
		{
			if (!WorldInfo.GRI.IsMultiplayerGame())
			{
				MyGearHUD.ClearActionInfoByType(AT_StayingAlive);
			}
			else
			{
				// stop pp effect for bleed out
				MyGearHUD.ClearActionInfoByType(AT_StayingAlive);
				MyGearHUD.ClearActionInfoByType(AT_SuicideBomb);
			}
		}

		// unholster the weapon if needed
		if (MyGearPawn != None && NextStateName != 'Kidnapped')
		{
			MyGearPawn.UnHolsterWeapon();
		}

		// Clear notification
		ClearTimer( 'NotifySquadDBNO' );
	}

	event PlayerTick( float DeltaTime )
	{
		if( Pawn == None )
		{
			GotoState( 'Dead' );
		}
		else
		{
			// won't have HUD for remote clients on server
			if (MyGearHUD != None)
			{
				SetReviveIconAnimationSpeed();
			}

			// make sure to call parent so that we crawl around, as well as process input, etc
			Super.PlayerTick(DeltaTime);

			if (MyGearPawn != None && !MyGearPawn.IsAHostage() && MyGearPawn.IsDBNO(true))
			{
				if ( MyGearHUD.ActiveAction.ActionType == AT_SpecialMove || MyGearHUD.ActiveAction.ActionType == AT_StayingAlive ||
					!MyGearHUD.ActiveAction.bActive )
				{
					// reset icon to the usual DBNO options
					if ( WorldInfo.GRI.IsMultiplayerGame() && MyGearPawn.MyGearWeapon != None &&
						MyGearPawn.MyGearWeapon.CanMartyr() )
					{
						MyGearHUD.SetActionInfo(AT_SuicideBomb, ActionSuicideBomb);
					}
					else
					{
						SetReviveIcon();
						SetReviveIconAnimationSpeed();
					}
				}
			}
		}
	}

	function StartFire( optional byte FireModeNum )
	{
	}

	function StopFire( optional byte FireModeNum )
	{
	}

	function StartAltFire( optional byte FireModeNum )
	{
	}

	function StopAltFire( optional byte FireModeNum )
	{
	}

	function bool CanTryToEnterCover()
	{
		return FALSE;
	}

	exec function bool TryASpecialMove(bool bRunActions)
	{
		return FALSE;
	}

Begin:
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
	if( bPause )
	{
		if( MyGearPawn != None )
		{
			MyGearPawn.bWantsToMelee = FALSE;
		}
	}
	else
	{
		MainPlayerInput.LastInputTime = WorldInfo.TimeSeconds;
	}

	return super.SetPause(bPause,CanUnpauseDelegate);
}

/** @return the current DifficultyLevel */
final event EDifficultyLevel GetCurrentDifficultyLevel()
{
	return GearPRI(PlayerReplicationInfo).Difficulty.default.DifficultyLevel;
}

reliable client function ClientSetRotation( rotator NewRotation, optional bool bResetCamera )
{
	local GearPlayerCamera Cam;

	if (Turret(Pawn) != None)
	{
		// don't rotate the turret
		SetRotation(NewRotation);
	}
	else
	{
		Super.ClientSetRotation(NewRotation, bResetCamera);
	}

	if (bResetCamera)
	{
		// clear camera orientation as well
		Cam = GearPlayerCamera(PlayerCamera);
		if (Cam != None)
		{
			Cam.ResetInterpolation();
		}

		// @fixme gears 3: every place we reset the camera, consider doing this, as well as
		// killing all camera anims
		// only doing this much for g2 to fix a specific bug, since it's late.
		StopCameraBoneAnim(0.f, FALSE);
	}
}

reliable client function ClientSetJustControllerRotation(rotator NewRotation)
{
	SetRotation(NewRotation);
}

reliable client event ClientSetLocationAndBase(vector NewLocation, Actor NewBase)
{
	if (Pawn != None)
	{
		Pawn.SetLocation(NewLocation);
		Pawn.SetBase(NewBase);
	}
}

/** Kick player from turret before teleporting */
simulated function OnTeleport(SeqAct_Teleport Action)
{
	if( Action != None )
	{
		if( Turret(Pawn) != None )
		{
			Turret(Pawn).DriverLeave(true);
		}
		Super.OnTeleport(Action);
	}
}

event bool FindAvailableTeleportSpot( Pawn TestPawn, optional NavigationPoint TeleportAnchor, optional bool bSkipRadiusSearch)
{
	//local array<NavigationPoint> NavList;
	local array<vector> PolyCenters;
	local vector CurTestLoc;
	local vector ChkLoc;
	local GearAI AI;
	local Controller TestController;
	local GearPawn GP;
	local GearTurret GT;
	local GearVehicleBase GV;
	local int Idx;
	local bool bSecondPass;
	local rotator TeleportRot;
	local Vector ChkExtent;

	`log(`location@`showvar(TestPawn)@`showvar(TeleportAnchor)@`showvar(bSkipRadiusSearch));
	if (GearWeap_SniperRifle(TestPawn.Weapon) != None)
	{
		`log("- sniper no see hack for checkpoints");
		GearWeap_SniperRifle(TestPawn.Weapon).SetOwnerNoSee(FALSE);
	}

	GP = GearPawn(TestPawn);
	if( GP != None )
	{
		ServerReviveTeamMate(GP);
		GP.ServerEndSpecialMove();
		if (GearPC(GP.Controller) != None)
		{
			GearPC(GP.Controller).ClientBreakFromCover();
		}
		else
		{
			GP.BreakFromCover();
		}
	}

	// if we're on a troika, get off before the teleport
	GT = GearTurret(TestPawn);
	if( GT != None )
	{
		TestController = TestPawn.Controller;
		`log("Forcing "@TestController@"off turret for checkpoint teleport");
		GT.DriverLeave(TRUE);
		TestPawn = TestController.Pawn;
	}

	GV = GearVehicleBase(TestPawn);
	if( GV != None && GV.bKickDriverOnTeleport )
	{
		TestController = TestPawn.Controller;
		`log("Forcing "@TestController@"off vehicle for checkpoint teleport");
		GV.DriverLeave( TRUE );
		TestPawn = TestController.Pawn;
	}

	AI = GearAI(TestPawn.Controller);
	// if an anchor was specified
	if (TeleportAnchor != None)
	{
		// then attempt to spawn at that anchor
		ChkLoc = TeleportAnchor.Location;
		if ( class'SeqAct_AIFactory'.static.CanSpawnAtLocation(ChkLoc,TestPawn.GetCollisionExtent(),TeleportAnchor) )
		{
			if (AI != None)
			{
				if (AI.TeleportToLocation(ChkLoc,TeleportAnchor.Rotation))
				{
					return TRUE;
				}
			}
			else if (TestPawn.SetLocation(TeleportAnchor.Location))
			{
				if (TestPawn.Controller != None)
				{
					TeleportRot = TeleportAnchor.Rotation;
					TeleportRot.Roll = 0;
					TestPawn.Controller.SetRotation(TeleportRot);
					TestPawn.Controller.ClientSetLocation(TestPawn.Location, TeleportRot);
					TestPawn.Controller.ClientSetRotation(TeleportRot, TRUE);
				}
				TestPawn.SetPhysics(PHYS_Falling);
				return TRUE;
			}
		}
		// otherwise use the anchor as the check location
		ChkLoc = TeleportAnchor.Location;
	}
	else
	{
		// use current pawn location if possible
		ChkLoc = Pawn != None ? Pawn.Location : Location;
	}
	if (!bSkipRadiusSearch)
	{
		ChkExtent = TestPawn.GetCollisionExtent();
		ChkExtent *= vect(3,3,1);
		bSecondPass = FALSE;

		// grab nodes in a radius
		// first try to spawn behind this player - if that doesn't work try anything
		NavigationHandle.GetValidPositionsForBox(ChkLoc, 512.f, TestPawn.GetCollisionExtent(),true, PolyCenters);
		for (Idx = 0; Idx < PolyCenters.Length; Idx++)
		{
			CurTestLoc = PolyCenters[Idx];
			if (  bSecondPass || Pawn == None ||
					( VSize(CurTestLoc - Pawn.Location) > 100.0 &&
						vector(Rotation) dot Normal(CurTestLoc - Pawn.Location) < 0.0) )
			{
				if ( class'SeqAct_AIFactory'.static.CanSpawnAtLocation(CurTestLoc, ChkExtent, None, !bSecondPass ) )
				{
					if (AI != None)
					{
						if (AI.TeleportToLocation(CurTestLoc,Pawn.Rotation))
						{
							return TRUE;
						}
					}
					else if (TestPawn.SetLocation(CurTestLoc))
					{
						if (TestPawn.Controller != None)
						{
							TeleportRot = Pawn.Rotation;
							TeleportRot.Roll = 0;
							TestPawn.Controller.SetRotation(TeleportRot);
							TestPawn.Controller.ClientSetLocation(TestPawn.Location, TeleportRot);
							TestPawn.Controller.ClientSetRotation(TeleportRot, TRUE);
						}
						TestPawn.SetPhysics(PHYS_Falling);
						`Log("FindAvailableTeleportSpot: Successfully teleported" @ TestPawn @ "to" @ CurTestLoc);
						return TRUE;
					}
				}
			}

			if (Idx == PolyCenters.length - 1 && !bSecondPass)
			{
				ChkExtent = TestPawn.GetCollisionExtent();
				bSecondPass = true;
				Idx = -1;
			}
		}
	}
	`warn("Failed to find teleport destination for"@TestPawn@"near"@self@`showvar(PolyCenters.Length));
	return FALSE;
}

unreliable server function TeleportToPlayer()
{
	local GearPC PC;
	local bool bTeleportedToPlayer;
	local PlayerStart Start;
	local GearVehicleBase GV;

	ClientBreakFromCover();

	GV = GearVehicleBase(Pawn);
	if( GV != None && GV.bKickDriverOnTeleport )
	{
		GV.DriverLeave( TRUE );
	}

	// find another human player
	bTeleportedToPlayer = FALSE;
	foreach WorldInfo.AllControllers(class'GearPC',PC)
	{
		if (PC != self)
		{
			`log("- attempting teleport to:"@PC);
			// teleport the player's location
			if (PC.FindAvailableTeleportSpot(Pawn))
			{
				bTeleportedToPlayer = TRUE;
				break;
			}
		}
	}
	if (!bTeleportedToPlayer)
	{
		// teleport to the first available playerstart
		foreach WorldInfo.AllNavigationPoints(class'PlayerStart',Start)
		{
			if (Pawn.SetLocation(Start.Location))
			{
				Pawn.SetPhysics(PHYS_Falling);
				break;
			}
		}
	}
}

event CurrentLevelUnloaded()
{
	// only teleport if this is a multiplayer game
	if (Role == Role_Authority && WorldInfo.Game.NumPlayers > 1)
	{
		TeleportToPlayer();
	}
}

/** Special case for adding hit locators when in vehicles, normal locators are handled from GearDamageType */
unreliable client final function ClientAddHitLocator(Actor InstigatorA, int DamageDone, vector HitLocation, optional bool bDirLocked)
{
	if (MyGearHud != None)
	{
		MyGearHud.AddNewHitLocatorData(InstigatorA, DamageDone, HitLocation, bDirLocked);
	}
}

// @param bIgnoreForHUD - will not display in the HUD
reliable client final function bool AddDeathMessage( GearPawn Victim, PlayerReplicationInfo Killer, PlayerReplicationInfo Other, class<DamageType> damageType, EGearDeathType DeathType, bool bIsKnockdown, optional int PointsAwarded=0, optional bool bIgnoreForHUD, optional bool bSkipBlood, optional bool bAddToMessageQueue = TRUE)
{
	local class<GearDamageType> GDTClass;
	local HistoryItem HItem;
	local EGearExecutionType ExecutionType;
	local name StatName, WeaponName;
	local bool bIsMultiplayer, bIsArcade, bIsHorde, bIsSiege, bWasNemesisKill;
	local GearPRI GPRI;
	local bool bTDMMatch;

	// should display now?
	if (!ShouldDisplayDeathMessage(Victim))
	{
		// if not see if I should add this to death message queue
		if ( bAddToMessageQueue )
		{
			AddToDelayedDeathMessage(Victim, Killer, Other, DamageType, DeathType, bIsKnockdown, PointsAwarded, bIgnoreForHUD, bSkipBlood);

			// if timer isn't active, activate it
			if (!IsTimerActive('CheckDelayedDeathMessage'))
			{
				SetTimer(0.2, false, 'CheckDelayedDeathMessage');
			}
		}

		return false;
	}

	GDTClass = class<GearDamageType>(damageType);
	bIsMultiplayer = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameMP_Base');

	//Record all death-deaths in the history
	if (!bIsKnockdown)
	{
		HItem.damageType = GDTClass;
		HItem.DeathType = DeathType;
		HItem.Initiator = Killer;
		HItem.Target = Other;
		HItem.TimeOccurred = WorldInfo.TimeSeconds;
		GearGRI(WorldInfo.GRI).AddMatchHistoryItem(HItem);

		// Nemesis tracking
		// The leader can't die, but we still get GDT_Hostage coming over.
		// If this was server only, could use CanBeSpecialMeleeAttacked, I assume that's not client safe.
		if (Killer != None && IsPrimaryPlayer() && !GearPRI(Other).bIsLeader)
		{
			GearPRI(Other).RecordKilledBy(Killer);
		}

		// If we killed our nemesis, clear them
		GPRI = GearPRI(Killer);
		if (GPRI != None && Other != None && GPRI.IsNemesis(Other))
		{
			bWasNemesisKill = true;
			GPRI.ClearNemesis();
		}

		// If this is my death, record the stat
		if( Other == PlayerReplicationInfo )
		{
			bIsArcade = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSP_Arcade');
			bIsHorde = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base');
			bIsSiege = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base');

			if( bIsHorde )
			{
				ModifyStat('DeathsHorde');
			}
			else if( bIsSiege )
			{
				ModifyStat('DeathsSiege');
			}
			else if( bIsArcade )
			{
				ModifyStat('DeathsArcade');
			}
			else
			{
				ModifyStat('DeathsMP');
			}
		}
	}

	if( MyGearHud != None && !bIgnoreForHUD )
	{
		MyGearHud.AddDeathMessageData( Killer, Other, GDTClass, DeathType, bIsKnockdown, PointsAwarded, bSkipBlood );
	}

	//`log(GetFuncName()@`showvar(damageType)@`showvar(Killer == PlayerReplicationInfo));

	if (bIsMultiplayer)
	{
		if (PointsAwarded > 0)
		{
		   ModifyStat('ScoreMP',PointsAwarded);
		}
	}

	//Did I make this kill?
	if ( Killer != None && Killer == PlayerReplicationInfo )
	{
		// Make sure we don't give credit for killing teammates
		if ( Other == None || Killer.GetTeamNum() != Other.GetTeamNum() )
		{
			bIsArcade = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSP_Arcade');
			bIsHorde = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base');
			bIsSiege = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base');

			//Just a knockdown
			if (bIsKnockdown)
			{
				if (bIsMultiplayer)
				{
					ModifyStat('DownsMP');
					if (ClassIsChildOf(GDTClass, class'GDT_Melee'))
					{
						ModifyStat('MeleeKnockdownsMP');
					}

					if (bIsHorde)
					{
						ModifyStat('DownsHorde');
					}
					else if (bIsSiege)
					{
						ModifyStat('DownsSiege');
					}

					if (GearPawn(Pawn) != None && GearPawn(Pawn).CoverType != CT_None)
					{
						ModifyStat('DownsFromCoverMP');
					}
				}
				else if (bIsArcade)
				{
					ModifyStat('DownsArcade');
				}
			}
			//death
			else
			{
				//Modify MP-only stats
				if (bIsMultiplayer)
				{
					ModifyStat('KillsMP');

					if (GearPRI(PlayerReplicationInfo).bIsLeader && !GearPRI(Other).bIsLeader)
					{
						ModifyStat('KillsAsLeaderMP');
					}

					if (bIsHorde)
					{
						ModifyStat('KillsHorde');
						if (Other != None && class'GearLeaderboardArcadeWrite'.static.GetStatNameFromClassName(GearPRI(Other).PawnClass.Name, StatName))
						{
							ModifyStat(name(StatName $ "KillsHorde"));
						}
					}
					else if (bIsSiege)
					{
						ModifyStat('KillsSiege');
						if (Other != None && class'GearLeaderboardWriteSiege'.static.GetEnemyStatNameFromClassName(GearPRI(Other).PawnClass.Name, StatName))
						{
							// tracking killed pawns by type
							ModifyStat(name(StatName $ "KillsSiege"));
						}

						if (Killer != None && class'GearLeaderboardWriteSiege'.static.GetPlayerStatNameFromClassName(GearPRI(Killer).PawnClass.Name, StatName))
						{
							// tracking kills by pawn type
							ModifyStat(name(StatName $ "Kills"));
						}
					}

					//It was an execution
					if ( class'GearTypes'.static.GetExecutionType(GDTClass, ExecutionType) )
					{
						ModifyStat('ExecutionsMP');
						if (ExecutionType == eGET_Curbstomp)
						{
							ModifyStat('CurbStompsMP');
						}
						else if (ExecutionType == eGET_LongPunchFace)
						{
							if (bWasNemesisKill)
							{
								ModifyStat('FacePunchesMP');
							}
						}

						if (GearMPPRI(PlayerReplicationInfo) != None && !GearMPPRI(PlayerReplicationInfo).bHasViralAchievement &&
							GearMPPRI(Other) != None && GearMPPRI(Other).bHasViralAchievement)
						{
							// @ACHIEVEMENT - Rust Lung (viral)
							ServerSetViralSettings(false, true);
							ClientUnlockAchievement(eGA_RUSTLUNG);
						}
					}

					//Headshot
					if (DeathType == GDT_Headshot)
					{
						ModifyStat('HeadshotsMP');
					}

					//Type of weapon used to kill
					if (GDTClass == class'GDT_Chainsaw')
					{
						ModifyStat('ChainsawKillsMP');
					}
					else if (GDTClass == class'GDT_Shotgun' ||
							 GDTClass == class'GDT_Shotgun_SawedOff')
					{
						ModifyStat('ShotgunKillsMP');
					}
					else if (GDTClass == class'GDT_COGPistol' ||
							 GDTClass == class'GDT_LocustBurstPistol' ||
							 GDTClass == class'GDT_LocustPistol' ||
							 GDTClass == class'GDT_LocustPistol_Kantus')
					{
						ModifyStat('PistolKillsMP');
					}
					else if (GDTClass == class'GDT_Mulcher' ||
							 GDTClass == class'GDT_Mortar' ||
							 GDTClass == class'GDT_MortarUntargeted' ||
							 GDTClass == class'GDT_HeavySniperRifle' ||
							 GDTClass == class'GDT_Boomshot' ||
							 GDTClass == class'GDT_BoomshotBomblet' ||
							 GDTClass == class'GDT_HeavyCoopMG')
					{
						ModifyStat('HeavyKillsMP');
					}
					else if (ClassIsChildOf(GDTClass, Class'GDT_FragGrenade') ||
							 ClassIsChildOf(GDTClass, Class'GDT_InkGrenade') ||
							 ClassIsChildOf(GDTClass, Class'GDT_IncendiaryGrenade'))
					{
						ModifyStat('GrenadeKillsMP');
					}
				}
				else if (bIsArcade)
				{
					ModifyStat('KillsArcade');
					if (class'GearLeaderboardArcadeWrite'.static.GetStatNameFromClassName(GearPRI(Other).PawnClass.Name, StatName))
					{
						ModifyStat(name(StatName $ "KillsArcade"));
					}
				}

				//Set the SP and MP stats
				if(class<GearWeapon>(class'GearTypes'.default.WeaponClasses[GDTClass.default.WeaponID]) != None &&
					class<GearWeapon>(class'GearTypes'.default.WeaponClasses[GDTClass.default.WeaponID]).default.WeaponStatName != "")
				{
					WeaponName = name(class<GearWeapon>(class'GearTypes'.default.WeaponClasses[GDTClass.default.WeaponID]).default.WeaponStatName);
					ModifyStat(name(WeaponName $ "Kills" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix));

					if (bIsMultiplayer &&
						WeaponName != 'Lancer' &&
						WeaponName != 'Hammerburst' &&
						WeaponName != 'Gnasher' &&
						WeaponName != 'SawedOffShotgun'	&&
						WeaponName != 'RetroLancer' &&
						WeaponName != 'CogPistol')
					{
					   ModifyStat('PickupKillsMP');
					}
				}

				// Actual kill (not knockdown) progression
				if (ProfileSettings != None && GDTClass != class'GDT_KnockedDown')
				{
					bTDMMatch = WorldInfo.GRI.GameClass.Name == 'GearGameTDM_Newb_Content' ? true : false;
					ProfileSettings.UpdateKillingProgression( GDTClass, self, bTDMMatch );
				}
			}
		}
	}
	else if (bIsMultiplayer && PointsAwarded > 0)
	{
		// Credit for the assist (any score at all and not the killer)
		ModifyStat('AssistsMP');
	}

	return TRUE;
}

reliable client function AddScoreGameMessage(int Id, int Pts, optional GearPRI Victim)
{
	local bool bIsMultiplayer, bIsArcade, bIsHorde, bIsSiege;

	bIsMultiplayer = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameMP_Base');

	if (bIsMultiplayer)
	{
		ModifyStat('ScoreMP',Pts);
	}
	if (MyGearHud != None)
	{
		MyGearHud.AddScoreGameMessage(Id,Pts,Victim);
	}
	//If this is a revive, record it
	if (Id == 69) //Why god why is the arbitrary number 69 the revive id? Shouldn't there be a const or something?
	{
		bIsArcade = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSP_Arcade');
		bIsHorde = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base');
		bIsSiege = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base');

		if (bIsHorde)
		{
			ModifyStat('RevivesHorde');
		}
		else if (bIsSiege)
		{
			ModifyStat('RevivesSiege');
		}
		else if (bIsMultiplayer)
		{
			ModifyStat('RevivesMP');
		}
		else if (bIsArcade)
		{
			ModifyStat('RevivesArcade');
		}

		// Save info about the revival so the DBNO HUD locator can use it
		Victim.LastToReviveMePRI = PlayerReplicationInfo;
		Victim.LastToReviveMePoints = Pts;
		Victim.LastToReviveMeTime = WorldInfo.TimeSeconds;
	}
}

/** adds the passed in number of points to the floating score text on the HUD */
reliable client final function ClientAddKillPoints(int ScoringValue)
{
	MyGearHud.AddKillPoints(ScoringValue);
}

reliable client final function UpdateSeriously()
{
	if (ProfileSettings != None)
	{
		ProfileSettings.UpdateKillingProgression( None, self );
	}
}

reliable client final function AddWeaponTakenMessage(PlayerReplicationInfo WeaponTaker, class<DamageType> DamageType)
{
	if( MyGearHud != None )
	{
		MyGearHud.AddWeaponTakenMessage(WeaponTaker, class<GearDamageType>(DamageType));
	}
}


/* ClientReset()
reset actor to initial state - used when restarting level without reloading.
*/
reliable client function ClientReset()
{
	if ( MyGearHud != None )
	{
		MyGearHud.Reset();
	}

	Super.Reset();
}

function TakeMeleeDamage( Pawn DamageDealer )
{
}

function PawnReviving( GearPawn Victim )
{
}

/** called to replicate a Kismet animation action on a Pawn */
unreliable client function ClientPlayGearPlayerAnim(GearPawn AnimTarget, SeqAct_GearPlayerAnim InAction, bool bPlay)
{
	if (AnimTarget != None && InAction != None)
	{
		AnimTarget.ProcessGearPlayerAnim(InAction, bPlay);
	}
}

/** When the Controller is destroyed, the controlled pawn will need to be killed, but not the ridable pawn */
function CleanupPawn()
{
	local GearPawnRidable_Base  DrivenPawn;
	local Pawn		            Driver;

	// If driving a ridable pawn, just destroy the driver
	DrivenPawn = GearPawnRidable_Base(Pawn);
	if (DrivenPawn != None)
	{
		Driver = DrivenPawn.Driver;
		DrivenPawn.DriverLeave(TRUE); // Force the driver out of the car
		if (Driver != None)
		{
			Driver.Health = 0;
			Driver.Died(Self, class'GDT_Suicide', Driver.Location);
		}
	}
	else
	{
		Super.CleanupPawn();
	}
}

/**
 * Overridden to handle replacing players with AI in coop.
 */
event Destroyed()
{
	local SavedMove Next;
	local GearPawn_COGGear Gear;
	local GearAI_Dom AI;
	local Pawn OldPawn;
	local array<SequenceObject> AllLeavingEvents;
	local Sequence GameSeq;
	local int i;

	// in Arcade, we need to resurrect exiting players so they can be properly taken over by the AI;
	// if we wait to bring the AI back, various important properties on the controller and PRI would be lost
	if (Pawn == None && GearGameSP_Arcade(WorldInfo.Game) != None)
	{
		GearGameSP_Arcade(WorldInfo.Game).ResurrectExitingPlayer(self);
	}

	Gear = GearPawn_COGGear(Pawn);
	if (Gear == None && Vehicle(Pawn) != None)
	{
		Gear = GearPawn_COGGear(Vehicle(Pawn).Driver);
	}
	if (Gear == None && GearPawnRidable_Base(Pawn) != None)
	{
		Gear = GearPawn_COGGear(GearPawnRidable_Base(Pawn).Driver);
	}

	StopTutorialSystem();
	GearEventList.Length = 0;
	GearWeaponEquipDelegates.Length = 0;

	// check if we should do SP human->AI replacement
	if (!bCheckpointDummy && (!IsCoop() || GearGameSP_Base(WorldInfo.Game) == None || Gear == None))
	{
		// ask MP gametype if it wants to do its own replacement
		if (GearGameMP_Base(WorldInfo.Game) != None && IsA('GearPC_MP'))
		{
`if(`notdefined(FINAL_RELEASE))
			GearGameMP_Base(WorldInfo.Game).PrintTeamAssignments("Check Replace With Bot BEFORE");
`endif
			GearGameMP_Base(WorldInfo.Game).CheckReplaceWithBot(self);
		}
		Super.Destroyed();

`if(`notdefined(FINAL_RELEASE))
		if (GearGameMP_Base(WorldInfo.Game) != None && IsA('GearPC_MP'))
		{
			GearGameMP_Base(WorldInfo.Game).PrintTeamAssignments("Check Replace With Bot AFTER");
		}
`endif
	}
	// if you disconnect while chainsaw dueling, you die
	// this prevents various animation and AI issues and makes reasonable sense anyway
	else if (Gear.IsDoingSpecialMove(SM_ChainsawDuel_Leader) || Gear.IsDoingSpecialMove(SM_ChainsawDuel_Follower))
	{
		Gear.Health = 0;
		Gear.Died(self, class'GDT_ScriptedGib', Gear.Location);
	}
	else
	{
		// dismount from any turret or ridable first
		if (Turret(Pawn) != None)
		{
			Turret(Pawn).DriverLeave(true);
		}
		if (GearPawnRidable_Base(Pawn) != None)
		{
			GearPawnRidable_Base(Pawn).DriverLeave(true);
		}

		// stop doing any engage actions
		if ( Gear.IsDoingSpecialMove(SM_Engage_Idle) || Gear.IsDoingSpecialMove(SM_Engage_Loop) ||
			Gear.IsDoingSpecialMove(SM_Engage_Start) )
		{
			Gear.DoSpecialMove(SM_Engage_End, true);
		}
		// turn off conversing anim since it seems to get stuck in some cases
		Gear.SetConversing(false);
		// give up our pawn
		OldPawn = Pawn;
		UnPossess();
		// and make an AI for them
		AI = Spawn(class'GearAI_Dom');
		// put in the appropriate SP character slot
		i = GearGameSP_Base(WorldInfo.Game).PlayerSlots.Find('Owner', self);
		if (i != INDEX_NONE)
		{
			GearGameSP_Base(WorldInfo.Game).PlayerSlots[i].Owner = AI;
		}
		if (bCheckpointDummy)
		{
			// copy GUID in this case so AI gets hooked up to Kismet co-op player was connected to
			AI.MyGuid = MyGuid;
		}
		// set up the AI
		AI.SetTeam(PlayerReplicationInfo.Team.TeamIndex);
		AI.Possess(OldPawn, false);
		// have him join the previous squad
		AI.SetSquadName(GearPRI(PlayerReplicationInfo).SquadName, false);
		GearPRI(AI.PlayerReplicationInfo).bForceShowInTaccom = GearPRI(PlayerReplicationInfo).bForceShowInTaccom;
		// toggle cinematic mode if necessary
		if (bCinematicMode)
		{
			class'AICmd_WaitingForEvent'.static.Wait(AI, 'OnToggleCinematicMode');
		}
		// Carry over bGodMode
		AI.bGodMode = bGodMode;
		// fire off a Kismet event so the level can tell the AI what to do if progression requires it
		GameSeq = WorldInfo.GetGameSequence();
		if (GameSeq != None)
		{
			GameSeq.FindSeqObjectsByClass(class'SeqEvent_CoopPlayerLeft', true, AllLeavingEvents);
			for (i = 0; i < AllLeavingEvents.length; i++)
			{
				SeqEvent_CoopPlayerLeft(AllLeavingEvents[i]).CheckActivate(AI, AI);
			}
		}

		// since we're skipping the PlayerController implementation, need to call this again.
		ForceClearUnpauseDelegates();

		// PlayerController cleanup that we need to deal with
		if ( myHUD != None )
		{
			myHud.Destroy();
		}

		while ( FreeMoves != None )
		{
			Next = FreeMoves.NextMove;
			//FreeMoves.Destroy();
			FreeMoves = Next;
		}

		while ( SavedMoves != None )
		{
			Next = SavedMoves.NextMove;
			//SavedMoves.Destroy();
			SavedMoves = Next;
		}

		if( PlayerCamera != None )
		{
			PlayerCamera.Destroy();
			PlayerCamera = None;
		}

		// Clear the online delegates for this PC that was registered in PostBeginPlay.
		ClearOnlineDelegates();

		// remove this player's data store from the registered data stores..
		UnregisterPlayerDataStores();

		// Cleanup persistent party beacon
		if (ClientPersistentPartyBeacon	!= None)
		{
			ClientPersistentPartyBeacon.DestroyBeacon();
			ClientPersistentPartyBeacon = None;
		}
		// Cleanup JIP beacon
		if (PendingJIPClientReservationBeacon != None)
		{
			PendingJIPClientReservationBeacon.DestroyBeacon();
			PendingJIPClientReservationBeacon = None;
		}

		super(Controller).Destroyed();
	}
}

simulated function ActiveReloadSuccess( bool bDidSuperSweetReload )
{
	if( bDidSuperSweetReload == TRUE )
	{
		ClientPlayCameraShake(ARSuperSuccessScreenShake);
	}
}

/**
* Called to open any door we're able to interact with currently.
*/
reliable server function DoDoorOpen()
{
	if (MyGearPawn != None)
	{
		// if we can trigger this door and we're not already triggering one
		if (MyGearPawn.DoorTrigger != None && !IsTimerActive('DoDoorOpenCallback') &&
			MyGearPawn.CanDoSpecialMove(SM_DoorKick) && MyGearPawn.DoorTrigger.TriggerEventClass(class'SeqEvt_DoorOpen',Pawn,,TRUE))
		{
			if (IsDoingSpecialMove(SM_RoadieRun) || IsDoingSpecialMove(SM_RoadieRunStab))
			{
				EndSpecialMove();
			}
			ServerDictateSpecialMove(SM_DoorKick);
		}
	}
}

/**
 * Results only valid on the server
 *
 * @return TRUE if the door can be opened
 */
function bool CanDoorOpen()
{
	if (WorldInfo.NetMode == NM_Client)
	{
		`Warn(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "called on client!!");
		ScriptTrace();
		return FALSE;
	}

	if (MyGearPawn == None || MyGearPawn.DoorTrigger == None)
	{
		return FALSE;
	}

	return MyGearPawn.DoorTrigger.TriggerEventClass(class'SeqEvt_DoorOpen',Pawn,,TRUE);
}

/** Function for re-allowing the pawn to activate a door trigger after some delay */
function ReEnableDoorTrigger()
{
	if (MyGearPawn.DoorTrigger != None)
	{
		MyGearPawn.bInsideDoorTrigger = true;
	}
}

/**
* Delayed triggering of the event for opening a door.
*/
function DoDoorOpenCallback()
{
	local array<SequenceEvent> DoorEvents;
	local float TimerValue;
	local int EventIdx;

	if (MyGearPawn != None)
	{
		if (MyGearPawn.DoorTrigger != None && MyGearPawn.DoorTrigger.TriggerEventClass(class'SeqEvt_DoorOpen', Pawn, 0))
		{
			TimerValue = -1.0f;
			if (MyGearPawn.DoorTrigger.FindEventsOfClass(class'SeqEvt_DoorOpen', DoorEvents, true))
			{
				// Most likely there will only be 1 event in this array
				for (EventIdx = 0; EventIdx < DoorEvents.length; ++EventIdx)
				{
					// If we can't activate the event again right away, set a timer for when we can
					if (!DoorEvents[EventIdx].CheckActivate(self, Pawn, true))
					{
						if (TimerValue < 0.0f)
						{
							TimerValue = DoorEvents[EventIdx].ReTriggerDelay;
						}
						else
						{
							TimerValue = FMin(TimerValue, DoorEvents[EventIdx].ReTriggerDelay);
						}
					}
				}

				// If the trigger is disabled or has a timer...
				if (TimerValue != 0.0f)
				{
					MyGearPawn.bInsideDoorTrigger = false;
					if (TimerValue > 0.0f)
					{
						SetTimer(TimerValue, false, 'ReEnableDoorTrigger');
					}
				}
			}
			else
			{
				MyGearPawn.bInsideDoorTrigger = false;
			}
		}
	}
}

/**
* Called when the pawn touches a door trigger, sets up the data and checks
* for a roadie run kick open.
*/
simulated function OnEnterDoorTrigger( Trigger_DoorInteraction DoorTrigger )
{
	local array<SequenceEvent> DoorEvents;
	local int EventIdx;

	// A little ugly, but that trigger is only for SilverbackLoaders...
	if( DoorTrigger.IsA('Trigger_SilverbackKickInteraction') && !MyGearPawn.IsA('GearPawn_SilverbackBase') )
	{
		return;
	}

	// Save the info, if there is a valid event for it
	if (Role == ROLE_Authority)
	{
		MyGearPawn.DoorTrigger = DoorTrigger;
		if (DoorTrigger.FindEventsOfClass(class'SeqEvt_DoorOpen', DoorEvents, true))
		{
			// Most likely there will only be 1 event in this array
			for (EventIdx = 0; EventIdx < DoorEvents.length; ++EventIdx)
			{
				if( DoorEvents[EventIdx].MaxTriggerCount == 0 || DoorEvents[EventIdx].TriggerCount < DoorEvents[EventIdx].MaxTriggerCount )
				{
					// Found a valid event
					MyGearPawn.bInsideDoorTrigger = true;
					break;
				}
			}
		}
		// Check to see if we can activate the door trigger now
		if( IsDoingSpecialMove(SM_RoadieRun) && MyGearPawn.DoorTrigger != None && MyGearPawn.bInsideDoorTrigger )
		{
			DoDoorOpen();
		}
	}
}

/**
* Called when the pawn is no longer touching a door.
*/
simulated function OnExitDoorTrigger()
{
	// clear the info
	MyGearPawn.bInsideDoorTrigger = false;
	MyGearPawn.DoorTrigger = None;
}

/**
* Set the colorization settings for post process
*/
simulated function SetPausePostProcessColorizationSettings( out PostProcessSettings PPSettings )
{
	PPSettings.bEnableSceneEffect = true;
	PPSettings.Scene_InterpolationDuration = 1.f;
	PPSettings.Scene_Desaturation = 0.8f;
	PPSettings.Scene_HighLights = vect( 1.1f, 1.1f, 1.1f );
	PPSettings.Scene_MidTones = vect( 1.2f, 1.2f, 1.2f );
	PPSettings.Scene_Shadows = vect( 0.f, 0.f, 0.f );
}

/**
 * Set the blur effect for the pause and gameover screens.
 */
simulated function SetPostProcessBlurSettings( out PostProcessSettings PPSettings )
{
	PPSettings.bEnableBloom = true;
	PPSettings.Bloom_InterpolationDuration = 1.f;
	PPSettings.Bloom_Scale = 1.f;

	PPSettings.bEnableDOF = true;
	PPSettings.DOF_InterpolationDuration = 1.f;
	PPSettings.DOF_BlurKernelSize = 5.f;
	PPSettings.DOF_FalloffExponent = 1.f;
	PPSettings.DOF_FocusDistance = 0.f;
	PPSettings.DOF_FocusInnerRadius = 0.f;
	PPSettings.DOF_FocusPosition = vect(0,0,0);
	PPSettings.DOF_FocusType = FOCUS_Distance;
	PPSettings.DOF_MaxFarBlurAmount = 0.7f;
	PPSettings.DOF_MaxNearBlurAmount = 0.7f;
}

/**
 * Get the post process settings for the pause screen.
 */
simulated function InitPausePostProcessSettings()
{
	SetPostProcessBlurSettings( PausePPSettings );
	SetPausePostProcessColorizationSettings( PausePPSettings );
}

/**
 * Cancel cinematics, or if no cine's, then pause the game
 *
 * @InitialNoSkipTime Optional time to disallow skipping at the start of a cinematic
 */
exec function CancelCine(optional float InitialNoSkipTime)
{
	local string CurrentMovieName;
	//local string CancelResult;

	// if we are playing a movie, then cancel the movie now
	GetCurrentMovie(CurrentMovieName);
	if (CurrentMovieName != "")
	{
		// @todo: What about server/client issues?
//		ClientStopMovie("");
	}
	else
	{
		// if we are in a skippable matinee then cancel it
		ConsoleCommand("CANCELMATINEE " $ InitialNoSkipTime);
	}
}

event WarmupPause(bool bDesiredPauseState)
{
	local GearGameSP_Base Game;

	Super.WarmupPause(bDesiredPauseState);

	if (!bDesiredPauseState)
	{
		Game = GearGameSP_Base(WorldInfo.Game);
		if (Game != None && Game.HavePendingConnections())
		{
			PauseGame();
		}
	}
}

/**
 * Pause the game if there is no movie playing
 */
exec function ConditionalPauseGame()
{
	local string CurrentMovieName;
	//local string CancelResult;

	// if we are playing a movie, then don't pause
	GetCurrentMovie(CurrentMovieName);
	if (CurrentMovieName == "")
	{
		PauseGame();
	}
}

/** Whether we can open the pause screen or not */
function bool CanPauseGame( GearPC PC )
{
//	if ( (PC.MyWarHud != none) && !PC.IsTimerActive('OpenGameoverSceneFromDelay', PC) && !PC.IsTimerActive('StartProcessGameOverTimer', PC) && ((PC.OpenedUISceneGameover == None) || (PC.OpenedUISceneGameover.SceneTag != PC.GameoverScene.SceneTag)) )
//	{
		return true;
//	}

//	return false;
}

/**
 * Pause the game and open the pause screen.
 */
function PauseGame( optional delegate<PlayerController.CanUnpause> CanUnpauseDelegate=CanUnpause )
{
	local GearPC PC;
	local PlayerController APlayer;
	local bool bCanPauseGame;
	local delegate<PlayerController.CanUnpause> DefaultUnpauseDelegate;

	DefaultUnpauseDelegate = CanUnpause;

	// default this flag to true
	bCanPauseGame = true;

	// search for any local players that can't pause the game
	foreach LocalPlayerControllers(class'PlayerController', APlayer)
	{
		PC = GearPC(APlayer);
		if ( PC != None )
		{
			// duh, can't pause
			if ( !CanPauseGame(PC) )
			{
				bCanPauseGame = false;
			}
		}
	}

	if ( bCanPauseGame )
	{
		if ( MyGearHud != None )
		{
			if ( CanUnpauseDelegate == DefaultUnpauseDelegate )
			{
				// if we're using the HUD to pause the game, don't use the default delegate
				MyGearHUD.PauseGame();
			}
			else
			{
				MyGearHud.PauseGame(CanUnpauseDelegate);
			}
		}
		else
		{
			SetPause(true, CanUnpauseDelegate);
		}

		if ( Role == ROLE_Authority && WorldInfo.Pauser != None )
		{
			foreach WorldInfo.AllControllers(class'GearPC', PC)
			{
				if (LocalPlayer(PC.Player) == None)
				{
					PC.ClientUpdateHostPause(true);
				}
			}
		}
	}
}

/** input handler for the "host has paused the game" scene */
function ProcessClientPauseKey(int PlayerIndex)
{
	local GearPC PC;

	// Allow each splitscreen player to process his own input for bringing up the pause menu
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC.GetUIPlayerIndex() == PlayerIndex)
		{
			PC.PauseGame();
		}
	}
}

/** @hack: called on a timer while we think the host has paused the game to ask it for sure
 * because in rare cases it seems we get out of sync
 */
unreliable server final function ServerVerifyPausedState()
{
	if (WorldInfo.Pauser == None)
	{
		UnreliableClientClearHostPause();
	}
}
unreliable client final function UnreliableClientClearHostPause()
{
	ClientUpdateHostPause(false);
}

/** notification that the host paused a campaign game */
reliable client function ClientUpdateHostPause(bool bNowPaused)
{
	local array<name> ButtonArray;
	local UIScene_MessageBox MessageBox;
	local GearUIManager UIManager;

	if (WorldInfo.NetMode == NM_Client)
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		if (bNowPaused)
		{
			ButtonArray.length = 0; // shut up the compiler
			UIManager.ShowUIMessage( 'HostPaused',
				Localize("MessageBoxStrings","HostPaused_Title","GearGameUI"),
				Localize("MessageBoxStrings","HostPaused_Text","GearGameUI"),
				ButtonArray, DoNotClose,,
				MessageBox, class'GearGFxMoviePlayer'.const.GEAR_SCENE_PRIORITY_COOPSPECTATE,,false );
			if (MessageBox != None)
			{
				MessageBox.OnStartButtonPressed = ProcessClientPauseKey;
			}

			//@hack: periodically check that we didn't get out of sync somehow
			// note that this obviously won't update while paused, which is perfect
			// since we should be able to have the menu up incorrectly when unpaused
			// but we can't just check for that because we might simply be behind on variable replication
			SetTimer(0.5, true, nameof(ServerVerifyPausedState));
		}
		else
		{
			if( MyGearHud != None )
			{
				// Close the game over scene on clients if we're unpausing, to catch cases of cinematics playing for player deaths not clearing the menus
				MyGearHud.ConditionalCloseGameOverScene();
			}

			UIManager.ClearUIMessage('HostPaused');
			ClearTimer(nameof(ServerVerifyPausedState));
		}
	}
}

/** delegate function passed into ShowUIMessage to make the message unresponsive to input */
simulated function bool DoNotClose( UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex )
{
	return false;
}

/** Function to handle entering a UI scene that wants to hide the HUD */
simulated function HideHUDCleanup()
{
}

/** Function to handle coming back from a screen that wants to hide the hud */
simulated function UnHideHUDCleanup()
{
}

/**
 * Set the colorization settings for post process
 */
simulated function SetGameoverPostProcessColorizationSettings( out PostProcessSettings PPSettings )
{
	PPSettings.bEnableSceneEffect = true;
	PPSettings.Scene_InterpolationDuration = 1.f;
	PPSettings.Scene_Desaturation = 0.f;
	PPSettings.Scene_HighLights = vect( 0.5f, 1.f, 1.f );
	PPSettings.Scene_MidTones = vect( 1.f, 3.5f, 3.5f );
	PPSettings.Scene_Shadows = vect( 0.005f, 0.005f, 0.005f );
}

/**
* Get the post process settings for the gameover screen.
*/
simulated function InitGameoverPostProcessSettings()
{
	SetPostProcessBlurSettings( GameoverPPSettings );
	SetGameoverPostProcessColorizationSettings( GameoverPPSettings );
}

simulated function SetMenuPostProcessSettings(out PostProcessSettings NewSettings, optional bool bAllPlayers )
{
	MenuPPSettings = NewSettings;

	StartPostProcessOverride( eGPP_Menu, bAllPlayers );
}

/**
 * Attaches a post-process effect to the player's view.
 *
 * @param	PPType			the post-process type to attach.
 * @param	bAllPlayers		specify TRUE to force all local players to apply the post-process effect (only relevant in split-screen).
 */
simulated function StartPostProcessOverride( GearPostProcessFXType PPType, optional bool bAllPlayers, optional bool bRecoverFromPause )
{
	local LocalPlayer LP;
	local GearPC PC;
	local bool bIsMenu;
	local float BlendTime;

	if (PPType == CurrentPPType)
	{
		return;
	}
	CurrentPPType = PPType;

	bBlockCameraAnimsFromOverridingPostProcess = (CurrentPPType != eGPP_None);

	switch ( PPType )
	{
	case eGPP_Gameover:
		LP = LocalPlayer(Player);
		LP.OverridePostProcessSettings( GameoverPPSettings );
		break;

	case eGPP_Menu:
	case eGPP_Pause:
		bIsMenu = (PPType == eGPP_Menu);
		if ( bAllPlayers )
		{
			foreach LocalPlayerControllers(class'GearPC', PC)
			{
				// hide the hud
				PC.HideHUDCleanup();
				LP = LocalPlayer(PC.Player);
				LP.OverridePostProcessSettings( (bIsMenu ? PC.MenuPPSettings : PC.PausePPSettings) );
			}
		}
		else
		{
			LP = LocalPlayer(Player);

			HideHUDCleanup();
			LP.OverridePostProcessSettings( (bIsMenu ? MenuPPSettings : PausePPSettings) );
		}
		break;

	case eGPP_BleedOut:
		LP = LocalPlayer(Player);
		if (bRecoverFromPause)
		{
			if (MyGearPawn != None)
			{
				BlendTime = FMax(0.1f, MyGearPawn.GetRevivalTime() - (WorldInfo.RealTimeSeconds - BleedOutTimeStarted));
			}
		}
		else
		{
			BleedOutTimeStarted = WorldInfo.RealTimeSeconds;
			if (MyGearPawn != None)
			{
				BlendTime = MyGearPawn.GetRevivalTime();
			}
		}
		LP.OverridePostProcessSettings(MyGearHud.BleedOutPPSettings, BlendTime);
		break;
	case eGPP_Taccom:
		LP = LocalPlayer(Player);
		MyGearHud.SetTaccomPostProcessSettings();
		LP.OverridePostProcessSettings(MyGearHud.TaccomPPSettings);
		break;
	}
}

/** Stop the post process effect */
simulated function StopPostProcessOverride(GearPostProcessFXType PPType, optional float RecoveryTime = -1.0)
{
	local LocalPlayer LP;
	local GearPC PC;

	// there is no post process if we are not a local PC
	LP = LocalPlayer(Player);
	if (LP != None)
	{
		// None is always allowed;
		if (PPType != CurrentPPType && PPType != eGPP_None)
		{
			return;
		}
		CurrentPPType = eGPP_None;
		bBlockCameraAnimsFromOverridingPostProcess = FALSE;

		switch ( PPType )
		{
			case eGPP_Pause:
				if ( Role == ROLE_Authority || !MyGearHUD.UI_PauseSceneInstance.bOnlyOwnerFocusable )
				{
					ForEach LocalPlayerControllers(class'GearPC', PC)
					{
						LP = LocalPlayer(PC.Player);
						LP.ClearPostProcessSettingsOverride(RecoveryTime);
						// unhide the hud
						PC.UnHideHUDCleanup();
						// might have to start another post process
						CheckForPostProcessReset(PC,true);
					}
				}
				else
				{
					LP.ClearPostProcessSettingsOverride(RecoveryTime);
					UnhideHUDCleanup();
					CheckForPostProcessReset(Self,true);
				}
				break;

			case eGPP_Menu:
				//@FIXME:  Handle split screen case for menu overrides
				foreach LocalPlayerControllers(class'GearPC', PC)
				{
					LP = LocalPlayer(PC.Player);
					LP.ClearPostProcessSettingsOverride(RecoveryTime);
					// unhide the hud
					PC.UnHideHUDCleanup();
					// might have to start another post process
					CheckForPostProcessReset(PC);
				}
				break;

			//Default behavior is to JUST STOP IT.
			default:
				LP.ClearPostProcessSettingsOverride(RecoveryTime);
				break;
		}
	}
}

/** Deals with the case that a post process has been removed only to reveal another post process underneath
 *
 *  @param PC - the gearpc to check
 *  @param bIsClosingPause - Whether or not this is the closing down of the pause screen. Used to keep us from restarting the pause pp effect
 */
simulated function CheckForPostProcessReset(GearPC PC, optional bool bIsClosingPause)
{
	local GearPawn GP;
	local GearPRI GPRI;
	local bool bIsLeader;

	if (PC != None)
	{
		GP = GearPawn(PC.Pawn);
		if (GP == None && PC.Pawn == None)
		{
			//The player already lost his pawn, especially if he is dead and in deathcam, or meatbagged
			GP = GearPawn(PC.LastPawn);
		}
		if (GP != None && GP.Health <= 0)
		{
			if (WorldInfo.GRI.IsMultiplayerGame())
			{
				GPRI = GearPRI(PC.PlayerReplicationInfo);
				if (GPRI != None)
				{
					bIsLeader = GPRI.bIsLeader;
				}
				//If you are not spectating and are at 0 or below health and you are not both the leader and a hostage, you should be bleeding
				if (!IsSpectating() && !(GP.IsDoingSpecialMove(SM_Hostage) && bIsLeader))
				{
					PC.StartPostProcessOverride( eGPP_BleedOut, FALSE, TRUE );
				}
			}
			else
			{
				if (GP.IsDBNO())
				{
					PC.StartPostProcessOverride( eGPP_BleedOut, FALSE, TRUE );
				}
				else
				{
					PC.StartPostProcessOverride( eGPP_Gameover );
				}
			}
		}
		else if (PC.MyGearHUD != None)
		{
			if ( PC.MyGearHUD.UI_PauseSceneInstance != None)
			{
				if (!bIsClosingPause)
				{
					PC.StartPostProcessOverride( eGPP_Pause, !PC.MyGearHud.UI_PauseSceneInstance.bOnlyOwnerFocusable );
				}
			}
			else if (bAssessMode)
			{
				PC.StartPostProcessOverride(eGPP_Taccom, false, true);
			}
		}
	}
}

function SpawnDefaultHUD()
{
	if ( LocalPlayer(Player) == None )
		return;

	MyGearHUD = Spawn(class'GearHUD_Base',self);
	MyHud = MyGearHud;
}

/**
 * This should probably put you into CinematicMode
 *
 * @see OnToggleCinematicMode
 **/
simulated event ShowCinematic()
{
	MyGearHud.PlayCinematic();
}

native function Shot_360();

exec function Mofo()
{
	Shot_360();
}


/**
 * Sets invis mode based on the activated link.
 */
function OnToggleInvisMode( SeqAct_ToggleInvisMode inAction )
{
	if( inAction.InputLinks[0].bHasImpulse )
	{
		bInvisible = TRUE;
	}
	else
	if( inAction.InputLinks[1].bHasImpulse )
	{
		bInvisible = FALSE;
	}
	else
	{
		bInvisible = !bInvisible;
	}
}


/**
 * Sets the current gamma value.
 *
 * @param GammaValue, New value must be between 0.0 and 1.0
 */
native function SetGamma(float GammaValue);

/**
 * Sets the post process settings for this player.
 *
 * @param Preset	Preset to use to set the 4 PP values.
 */
native function SetPostProcessValues(ETVType Preset);

/**
 * Save the profile
 * @param WriteProfileSettingsCompleteDelegate - optional parameter that will allow a callback to be called when the save has completed
 *		- DELGATE MUST BE CLEARED ONCE CALLED
 */
function SaveProfile( optional delegate<OnlinePlayerInterface.OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate=OnProfileWriteComplete )
{
	local OnlinePlayerInterface PlayerInt;
	local int ControllerId;

	ControllerId = class'UIInteraction'.static.GetPlayerControllerId(GetUIPlayerIndex());

	// This will only upload once per day
	UploadProfileToMCP();

	if (OnlineSub != None && ProfileSettings.bShouldBeSaved)
	{
		//`log("ACTUALLY SAVED PROFILE");
		PlayerInt = OnlineSub.PlayerInterface;
		if (PlayerInt != None)
		{
			if ( ControllerId != INDEX_NONE )
			{
				if (!bHasSigninChanged)
				{
					PlayerInt.AddWriteProfileSettingsCompleteDelegate(ControllerId,WriteProfileSettingsCompleteDelegate);
					ProfileSettings.bShouldBeSaved = False;
					PlayerInt.WriteProfileSettings(ControllerId, ProfileSettings);
				}
				else
				{
					`Log("Ignoring write request because the profiles have changed");
					// Not signed in, so just act like it worked
					WriteProfileSettingsCompleteDelegate(ControllerId, true);
				}
			}
		}
	}
	else
	{
		if ( WriteProfileSettingsCompleteDelegate != None )
		{
			WriteProfileSettingsCompleteDelegate(ControllerId, true);
		}
	}

	// so this saveprofile gets called when things have been updated.  When that occurs we need to call this function
	// which will set all of the correct runtime settings.
	UpdateLocalCacheOfProfileSettings();
	bProfileSettingsUpdated = FALSE;
}

/**
 * Clear a SaveProfile delegate from the online player interface
 *
 * @param WriteProfileSettingsCompleteDelegate delegate function to clear
 */
function ClearSaveProfileDelegate( delegate<OnlinePlayerInterface.OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate )
{
	local OnlinePlayerInterface PlayerInt;
	local int ControllerId;

	if ( WriteProfileSettingsCompleteDelegate != None )
	{
		if (OnlineSub != None)
		{
			PlayerInt = OnlineSub.PlayerInterface;
			if (PlayerInt != None)
			{
				ControllerId = class'UIInteraction'.static.GetPlayerControllerId(GetUIPlayerIndex());
				if ( ControllerId != INDEX_NONE )
				{
					PlayerInt.ClearWriteProfileSettingsCompleteDelegate(ControllerId,WriteProfileSettingsCompleteDelegate);
				}
			}
		}
	}
}

/**
 * Called when the profile is done writing
 *
 * @param LocalUserNum User whose data was written.
 * @param bWasSuccessful Whether or not the write was successful
 */
function OnProfileWriteComplete(byte LocalUserNum,bool bWasSuccessful)
{
	`LogOnline(`showvar(LocalUserNum) @ `showvar(bWasSuccessful));
	if (!bWasSuccessful)
	{
		ProfileSettings.bShouldBeSaved = True;
	}
	ClearSaveProfileDelegate(OnProfileWriteComplete);
}

/**
 * Save the persistent data
 * @param WritePersistentDataCompleteDelegate - optional parameter that will allow a callback to be called when the save has completed
 *		- DELGATE MUST BE CLEARED ONCE CALLED
 */
function SavePersistentData(optional delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePersistentDataCompleteDelegate=OnPersistentDataWriteComplete )
{
	local OnlinePlayerInterface PlayerInt;
	local int ControllerId;

	ControllerId = class'UIInteraction'.static.GetPlayerControllerId(GetUIPlayerIndex());

	if (OnlineSub != None)
	{
		PlayerInt = OnlineSub.PlayerInterface;
		if (PlayerInt != None)
		{
			if ( ControllerId != INDEX_NONE )
			{
				if (!bHasPersistentData)
				{
					if (StatManager != None)
					{
						StatManager.WriteToPersistentData();
					}
					//This check has to be here because StatManager.WriterToPersistentData is what sets bShouldBeSaved
					if (PersistentData.bShouldBeSaved)
					{
						PersistentData.bShouldBeSaved = False;
						PlayerInt.AddWritePlayerStorageCompleteDelegate(ControllerID, WritePersistentDataCompleteDelegate);
						PlayerInt.WritePlayerStorage(ControllerId, PersistentData, PersistentData.DeviceId);
					}
					else
					{
						//Nothing to save, so just pretend.
						WritePersistentDataCompleteDelegate(ControllerId, true);
					}
				}
				else
				{
					`Log("Ignoring write request because the persistent data has not been received yet!");
					// Not signed in, so just act like it worked
					WritePersistentDataCompleteDelegate(ControllerId, true);
				}
			}
		}
	}
	else
	{
		WritePersistentDataCompleteDelegate(ControllerId, true);
	}
}

/**
 * Clear a SavePlayerStorage delegate from the online player interface
 *
 * @param WritePersistentDataCompleteDelegate delegate function to clear
 */
function ClearSavePersistentDataDelegate( delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePersistentDataCompleteDelegate )
{
	local OnlinePlayerInterface PlayerInt;
	local int ControllerId;

	if ( WritePersistentDataCompleteDelegate != None )
	{
		if (OnlineSub != None)
		{
			PlayerInt = OnlineSub.PlayerInterface;
			if (PlayerInt != None)
			{
				ControllerId = class'UIInteraction'.static.GetPlayerControllerId(GetUIPlayerIndex());
				if ( ControllerId != INDEX_NONE )
				{
					PlayerInt.ClearWritePlayerStorageCompleteDelegate(ControllerId,WritePersistentDataCompleteDelegate);
				}
			}
		}
	}
}

/**
 * Called when the persistent data is done writing
 *
 * @param LocalUserNum User whose data was written.
 * @param bWasSuccessful Whether or not the write was successful
 */
function OnPersistentDataWriteComplete(byte LocalUserNum,bool bWasSuccessful)
{
	`log(`location @ `showvar(LocalUserNum) @ `showvar(bWasSuccessful));
	if (!bWasSuccessful)
	{
		PersistentData.bShouldBeSaved = True;
	}
	ClearSavePersistentDataDelegate(OnPersistentDataWriteComplete);
}

/**
 * Sends the profile data up to MCP for stats gathering
 */
function UploadProfileToMCP()
{
	local OnlineEventsInterface Uploader;
	local UniqueNetId UniqueId;
	local int ControllerId;

	if (ProfileSettings != None &&
		// Don't try to update if a read is in progress
		ProfileSettings.AsyncState != OERS_InProgress &&
		PersistentData != None &&
		// Don't try to update if a read is in progress
		PersistentData.AsyncState != OPAS_Read &&
		!ProfileSettings.HasPlayerDataBeenUploaded())
	{
		if (OnlineSub != None &&
			OnlineSub.PlayerInterface != None)
		{
			// Ask for the interface by name and cast to our well known type
			Uploader = OnlineEventsInterface(OnlineSub.GetNamedInterface('McpUpload'));
			if (Uploader != None)
			{
				ControllerId = class'UIInteraction'.static.GetPlayerControllerId(GetUIPlayerIndex());
				// Don't upload local players
				if (!OnlineSub.PlayerInterface.IsLocalLogin(ControllerId) &&
					// And make sure the player is signed in properly
					OnlineSub.PlayerInterface.GetLoginStatus(ControllerId) == LS_LoggedIn)
				{
					OnlineSub.PlayerInterface.GetUniquePlayerId(ControllerId,UniqueId);
					Uploader.UploadPlayerData(UniqueId,OnlineSub.PlayerInterface.GetPlayerNickname(ControllerId),ProfileSettings,PersistentData);
					// Mark it as uploaded today so it doesn't happen twice
					ProfileSettings.MarkPlayerDataAsUploaded();
				}
			}
		}
	}
}

/**
 * Copies profile settings from the datastore and stores them in local variables.
 */
exec function UpdateLocalCacheOfProfileSettings()
{
	local int PlayerIndex;
	local PlayerController PC;
	local bool bEnableGore;
	local bool bUsingAutoTutorials;
	local GearPRI GPRI;
	local StaticMeshActorBasedOnExtremeContent SMAExtremeContent;
	local SkeletalMeshActorBasedOnExtremeContent SKAExtremeContent;

	PlayerIndex = GetUIPlayerIndex();

	`Log("Updating Local Cache of Profile Settings for UI PlayerIndex " $ PlayerIndex);
	GPRI = GearPRI(PlayerReplicationInfo);

	// the crazy the dynamic / static hud on whether to draw the weapon indicator or not (cept in cines)
	GPRI.bAlwaysDrawWeaponIndicatorInHUD = !ProfileSettings.GetHudOnOffConfigOption();

	GPRI.TrigConfig	= ProfileSettings.GetTrigConfigOption();
	GPRI.StickConfig	= ProfileSettings.GetStickConfigOption();

	UpdateControllerConfig();

	GPRI.bShowPictograms = ProfileSettings.GetPictogramTooltipsConfigOption();

	// Replicate the character / weapon settings to the server
	SetPlayerPreferences(ProfileSettings.GetPreferredClassIndex(0), ProfileSettings.GetPreferredClassIndex(1), ProfileSettings.GetPreferredMedalIndex());

	// Replicate the skins for the weapons
	SetWeaponSkins();

	GPRI.ControllerSensitivityConfig = ProfileSettings.GetControllerSensitivityValue();
	GPRI.TargetSensitivityConfig = ProfileSettings.GetTargetSensitivityValue();
	GPRI.ZoomSensitivityConfig = ProfileSettings.GetZoomSensitivityValue();

	ForceFeedbackManager.bAllowsForceFeedback = ProfileSettings.GetControllerVibrationOption();

	UpdateControlScheme();

	UpdateDifficultySetting();

	// Allow tutorial system to auto-initialize it's tutorials
	if ( TutorialMgr != None )
	{
		bUsingAutoTutorials = ProfileSettings.GetTutorialConfigOption();
		TutorialMgr.bGameIsUsingAutoTutorials = bUsingAutoTutorials;
		if (bUsingAutoTutorials)
		{
			TutorialMgr.AddAutoInitiatedTutorials();
		}
		else
		{
			TutorialMgr.RemoveAutoInitiatedTutorials();
		}
	}

	UpdateMutatorUnlocks();

	// Only allow player 0 to set shared options
	// Don't zero the options if there isn't an online subsystem to read the profile from
	if (PlayerIndex == 0 && OnlineSub != None)
	{
		RestoreShowSubtitles( );

		SetAudioGroupVolume( 'Voice', ProfileSettings.GetDialogVolume() );
		SetAudioGroupVolume( 'Effects', ProfileSettings.GetFxVolume() );
		SetAudioGroupVolume( 'Music', ProfileSettings.GetMusicVolume() );

		SetGamma(ProfileSettings.GetGammaSetting());
		SetAllowMatureLanguage( ProfileSettings.GetMatureLanguageConfigOption() );

		bEnableGore	= ProfileSettings.GetGoreConfigOption();
		// Loop through all PRI's and set gore.
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			GearPRI(PC.PlayerReplicationInfo).bShowGore = bEnableGore;
		}

		// this is rough, but after each change of the extreme content flag we need to iterate over all BasedOnExtremeContent actors
		// and all their function
		foreach AllActors( class'StaticMeshActorBasedOnExtremeContent', SMAExtremeContent )
		{
			SMAExtremeContent.SetMaterialBasedOnExtremeContent();
		}

		foreach AllActors( class'SkeletalMeshActorBasedOnExtremeContent', SKAExtremeContent )
		{
			SKAExtremeContent.SetMaterialBasedOnExtremeContent();
		}


		if ( LocalPlayer(Player) != None )
		{
			LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(eSST_2P_HORIZONTAL);
		}
	}

	SetPostProcessValues(ProfileSettings.GetTVType());

	// Make sure the currently selected weapon still exists (DLC could've been removed)
	CheckForWeaponAvailability();
}

/** Make sure the currently selected weapon still exists (DLC could've been removed), reset to default if not found */
function CheckForWeaponAvailability()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> WeaponList;
	local GearGameWeaponSummary WeaponInfo;
	local int Idx;
	local int CurrPrimaryWeaponId;
	local int CurrSecondaryWeaponId;
	local bool bFoundPrimaryWeapon;
	local bool bFoundSecondaryWeapon;

	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	if (GameResourceDS != None)
	{
		// Get the current setting from the profile
		CurrPrimaryWeaponId = ProfileSettings.GetPreferredPrimaryWeaponId();
		CurrSecondaryWeaponId = ProfileSettings.GetPreferredSecondaryWeaponId();
		// Get the weapon providers
		GameResourceDS.GetResourceProviders('Weapons', WeaponList);
		// Loop through the weapon providers and see if the one we are using is still available
		for (Idx = 0; Idx < WeaponList.Length; Idx++)
		{
			WeaponInfo = GearGameWeaponSummary(WeaponList[Idx]);
			if (WeaponInfo != none)
			{
				// If we found it break out
				if (CurrPrimaryWeaponId == WeaponInfo.WeaponId)
				{
					bFoundPrimaryWeapon = true;
					if (bFoundSecondaryWeapon)
					{
						break;
					}
				}
				if (CurrSecondaryWeaponId == WeaponInfo.WeaponId)
				{
					bFoundSecondaryWeapon = true;
					if (bFoundPrimaryWeapon)
					{
						break;
					}
				}
			}
		}
	}
	// If we didn't find it set the profile to it's default value (Lancer)
	if (!bFoundPrimaryWeapon)
	{
		ProfileSettings.SetPreferredPrimaryWeaponId(WC_Lancer);
	}
	// If we didn't find it set the profile to it's default value (Gnasher)
	if (!bFoundSecondaryWeapon)
	{
		ProfileSettings.SetPreferredSecondaryWeaponId(WC_Gnasher);
	}
}

/** Sets the difficulty on the PRI from the profile.  The PRI will then apply the difficulty on the server */
final function UpdateDifficultySetting()
{
	local int ValueId;
	local class<DifficultySettings> DiffSettingsClass;
	local GearPRI MyPRI;

	if ( WorldInfo.GRI != None &&
		 !WorldInfo.GRI.IsMultiplayerGame() )
	{
		if ( PlayerReplicationInfo != None &&
			 ProfileSettings != None &&
			 ProfileSettings.GetProfileSettingValueId(`GameIntensity, ValueId) )
		{
			switch ( ValueId )
			{
				case DL_Casual:
					DiffSettingsClass = class'DifficultySettings_Casual';
					break;
				case DL_Normal:
					DiffSettingsClass = class'DifficultySettings_Normal';
					break;
				case DL_Hardcore:
					DiffSettingsClass = class'DifficultySettings_Hardcore';
					break;
				case DL_Insane:
					DiffSettingsClass = class'DifficultySettings_Insane';
					break;
				default:
					`log(`location@"Illegal difficulty stored in profile!"@`showvar(ValueId));
					return;
			}

			MyPRI = GearPRI(PlayerReplicationInfo);
			if ( MyPRI != None && MyPRI.Difficulty != DiffSettingsClass )
			{
				ServerSetDifficulty( DiffSettingsClass );
			}
		}
	}
}

/** Sets the difficulty of the player on the server */
final reliable server function ServerSetDifficulty( class<DifficultySettings> DiffSettings )
{
	local GearPRI MyPRI, OtherPRI;
	local int i;

	if (WorldInfo.GRI != None && !WorldInfo.GRI.IsMultiplayerGame() && !GearGame(WorldInfo.Game).bURLDifficultyOverride)
	{
		MyPRI = GearPRI(PlayerReplicationInfo);
		if ( MyPRI != None )
		{
			MyPRI.Difficulty = DiffSettings;
			MyPRI.Difficulty.static.ApplyDifficultySettings( self );
			for (i = 0; i < WorldInfo.GRI.PRIArray.length; i++)
			{
				OtherPRI = GearPRI(WorldInfo.GRI.PRIArray[i]);
				if (OtherPRI != None && AIController(OtherPRI.Owner) != None)
				{
					OtherPRI.Difficulty = class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo);
					OtherPRI.Difficulty.static.ApplyDifficultySettings(Controller(OtherPRI.Owner));
				}
			}
		}
	}
}

/** Function called by the client when someone has set their difficulty in the UI
 *  @param bDifficultySelected - whether or not the client has selected or unselected their difficulty
 */
final reliable server function ServerDifficultySelected(bool bDifficultySelected)
{
	local GearPartyPRI MyPRI;
	local GearMenuHUD GMH;
	local GearPartyGRI PartyGRI;

	MyPRI = GearPartyPRI(PlayerReplicationInfo);
	if (MyPRI.bDifficultySelectionMade != bDifficultySelected)
	{
		MyPRI.bDifficultySelectionMade = bDifficultySelected;
		MyPRI.bNetDirty = true;
		MyPRI.bForceNetUpdate = true;
	}

	PartyGRI = GearPartyGRI(WorldInfo.GRI);

	//If this is the host....
	if (IsPrimaryPlayer() && IsLocalPlayerController())
	{
		if (bDifficultySelected) //If the host picked something, GO GO GO!
		{
			//If there is only one player just GO GO GO.
			if (WorldInfo.Game.NumPlayers == 1)
			{
				if (PartyGRI != None)
				{
					PartyGRI.ResetMainMenuCountdownTimer(0);
				}
			}
			else // Otherwise start the countdown.
			{
				GMH = GearMenuHUD(myHUD);
				if (GMH.FrontEndMovie != none && GMH.FrontEndMovie.DifficultyScene != None)
				{
					GMH.FrontEndMovie.DifficultyScene.StartDifficultySelectionTimer();
				}
			}
		}
		else //The host aborted! STOP STOP STOP!
		{
			if (PartyGRI != None)
			{
				PartyGRI.MainMenuCountdownTimer = -1;
			}
		}

	}
}

/** activates or deactivates the alternate control scheme and if we are client notifies the server of the change */
native final function SetAlternateControls(bool bNewUseAlternateControls);

reliable server event ServerSetAlternateControls(bool bNewUseAlternateControls)
{
	if (WorldInfo.NetMode != NM_Client && LocalPlayer(Player) == None)
	{
		SetAlternateControls(bNewUseAlternateControls);
	}
}

/**
 * Updates the server with the new omnidirectional evade value from the profile
 *
 * @param   bNewAllow360Evade   The new value of whether or not to allow omnidirectional evades
 */
reliable server function ServerSetOmniDirectionalEvade(bool bNewAllow360Evade)
{
	bAllow360Evade = bNewAllow360Evade;
}

/** Set the control scheme */
final function UpdateControlScheme()
{
	SetAlternateControls(ProfileSettings.GetControlScheme() == GCS_Alternate);
}

/**
 * This will set the bindings array with the updated key/value pair for the various controllers configs
 * we support.
 *
 * @todo:  when updating this look at the UTConsolePlayerController  LoadSettingsFromProfile
 **/
function UpdateControllerConfig()
{
	local GearPRI PRI;

	if (ProfileSettings != none)
	{
		PlayerInput.bInvertMouse = ProfileSettings.GetInvertMouseOption();
		PlayerInput.bInvertTurn = ProfileSettings.GetInvertTurnOption();

		bAllow360Evade = ProfileSettings.GetOmniDirEvadeOption();
		ServerSetOmniDirectionalEvade(bAllow360Evade);

	}

	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		if( PRI.StickConfig == WSCO_Default )
		{
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_Strafe" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_Movement" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_LookX" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_LookY" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftThumbstick', "GBA_Crouch" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightThumbstick', "GBA_Zoom" );
		}
		else if( PRI.StickConfig == WSCO_Legacy )
		{
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_LookX" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_Movement" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_Strafe" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_LookY" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftThumbstick', "GBA_Zoom" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightThumbstick', "GBA_Crouch" );
		}
		else if( PRI.StickConfig == WSCO_SouthPaw )
		{
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_LookX" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_LookY_Flip" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_Strafe" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_Movement_Flip" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftThumbstick', "GBA_Zoom" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightThumbstick', "GBA_Crouch" );
		}
		else if( PRI.StickConfig == WSCO_LegacySouthpaw )
		{
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftX', "GBA_Strafe" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftY', "GBA_LookY_Flip" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightX', "GBA_LookX" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightY', "GBA_Movement_Flip" );
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftThumbstick', "GBA_Crouch" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightThumbstick', "GBA_Zoom" );
		}

		if ( PRI.TrigConfig == WTCO_SouthPaw )
		{
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftTrigger', "GBA_Shoot" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightTrigger', "GBA_Target" );

			UpdateControllerSettings_Worker( 'XboxTypeS_LeftShoulder', "GBA_Reload" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightShoulder', "GBA_Taccom" );
		}
		// use defaults
		else
		{
			UpdateControllerSettings_Worker( 'XboxTypeS_LeftTrigger', "GBA_Target" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightTrigger', "GBA_Shoot" );

			UpdateControllerSettings_Worker( 'XboxTypeS_LeftShoulder', "GBA_Taccom" );
			UpdateControllerSettings_Worker( 'XboxTypeS_RightShoulder', "GBA_Reload" );
		}
	}
}

private function UpdateControllerSettings_Worker( name TheName, string TheCommand )
{
	local int BindIndex;

	for( BindIndex = 0;BindIndex < PlayerInput.Bindings.Length; ++BindIndex )
	{
		if( PlayerInput.Bindings[BindIndex].Name == TheName )
		{
			PlayerInput.Bindings[BindIndex].Command = TheCommand;
		}
	}
}


/** Set the preferred characters to the server PRI */
reliable server function ServerSetPlayerPreferences(int COGIndex, int LocustIndex, int MedalIndex)
{
	local GearPRI GPRI;
	local bool bFirstSet;

	GPRI = GearPRI(PlayerReplicationInfo);
	if (GPRI != None)
	{
		bFirstSet = (GPRI.PreferredCOGIndex == GPRI.default.PreferredCOGIndex && GPRI.PreferredLocustIndex == GPRI.default.PreferredLocustIndex);
		GPRI.PreferredCOGIndex = COGIndex;
		GPRI.PreferredLocustIndex = LocustIndex;
		GPRI.MedalID = MedalIndex;
		if (bFirstSet && WorldInfo.GRI.IsMultiplayerGame() && WorldInfo.Game.IsInState('PendingMatch'))
		{
		   	GearGame(WorldInfo.Game).SetPlayerClass(self, GetTeamNum());
		}
	}
}

/** Set the preferred characters to the PRI (replicates to server if necessary) */
function SetPlayerPreferences( int COGIndex, int LocustIndex, int MedalIndex )
{
	local GearPRI GPRI;

	GPRI = GearPRI(PlayerReplicationInfo);

	if (GPRI != None)
	{
		GPRI.PreferredCOGIndex = COGIndex;
		GPRI.PreferredLocustIndex = LocustIndex;
		GPRI.MedalID = MedalIndex;
	}

	if ( Role < ROLE_Authority )
	{
		ServerSetPlayerPreferences( COGIndex, LocustIndex, MedalIndex );
	}
}

/**
 * Handles the setting up of the weapon skin for both primary and secondary weapons
 */
function SetWeaponSkins()
{
	local GearWeaponSkinProvider PrimarySkinProv;
	local GearWeaponSkinProvider SecondarySkinProv;
	local EWeaponClass PrimWeapType;
	local EWeaponClass SecWeapType;
	local int PrimarySkinId;
	local int SecondarySkinId;
	local CoolSkin PrimarySkin;
	local CoolSkin SecondarySkin;

	// Get the weapon class types
	PrimWeapType = EWeaponClass(ProfileSettings.GetPreferredPrimaryWeaponId());
	SecWeapType = EWeaponClass(ProfileSettings.GetPreferredSecondaryWeaponId());

	// Get the unique ids for each weapon
	PrimarySkinId = ProfileSettings.GetProviderIndexForWeaponSkin(PrimWeapType);
	SecondarySkinId = ProfileSettings.GetProviderIndexForWeaponSkin(SecWeapType);

	// Get the providers
	class'GearUIDataStore_GameResource'.static.GetWeaponSkinByUniqueId(PrimarySkinId, PrimarySkinProv);
	class'GearUIDataStore_GameResource'.static.GetWeaponSkinByUniqueId(SecondarySkinId, SecondarySkinProv);

	// Set the data for the primary skin
	if (PrimarySkinProv != None)
	{
		PrimarySkin = PrimarySkinProv.WeaponSkin;
		PrimarySkin.WeapClass = class<GearWeapon>(class'GearTypes'.default.WeaponClasses[PrimarySkinProv.WeaponClassType]);
	}

	// Set the data for the secondary skin
	if (SecondarySkinProv != None)
	{
		SecondarySkin = SecondarySkinProv.WeaponSkin;
		SecondarySkin.WeapClass = class<GearWeapon>(class'GearTypes'.default.WeaponClasses[SecondarySkinProv.WeaponClassType]);
	}
	// Now send the data to the host so they can replicate it
	ServerSetWeaponSkins(PrimarySkin,SecondarySkin);
}

/**
 * Sets the weapon skin data on the server. Note that it sends the entire struct so that players
 * that have DLC that other players don't can play together and see each other's skins
 *
 * @param PrimarySkin the primary skin to set
 * @param SecondarySkin the secondary skin to set
 */
reliable server function ServerSetWeaponSkins(CoolSkin PrimarySkin,CoolSkin SecondarySkin)
{
	local GearPRI GPRI;

	GPRI = GearPRI(PlayerReplicationInfo);
	if (GPRI != None)
	{
		GPRI.PrimaryWeaponSkin = PrimarySkin;
		GPRI.SecondaryWeaponSkin = SecondarySkin;
	}
}

/** Debug function to print out the profile settings **/
exec function ShowProfileSettings()
{
	ClientMessage( "ShowGore Profile: " $ ProfileSettings.GetGoreConfigOption() );
	ClientMessage( "ShowGore Game: " $ GearPRI(PlayerReplicationInfo).bShowGore );
	ClientMessage( "AllowMatureLanguage: " $ ProfileSettings.GetMatureLanguageConfigOption() );
}

simulated function ClearBlurPP()
{
	local LocalPlayer LP;
	local GearPC PC;

	if( CurrentPPType != eGPP_Menu )
	{
		// Turn off the background blur
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			LP = LocalPlayer(PC.Player);
			LP.ClearPostProcessSettingsOverride();
		}
	}
}

simulated function CameraBoneAnimEndNotification()
{
	MainPlayerInput.ForcePitchCentering(FALSE);
}

/** Returns index of chosen camera anim, or -1 if nothing suitable could be found. */
private native function int ChooseCameraBoneAnim(const out array<CameraBoneAnimation> Anims);

/**
 * Returns index of chosen camera anim, or -1 if nothing suitable could be found.
 * bDoNotRandomize: start from index 0.
 */
simulated native final function int		ChooseRandomCameraAnim(out const array<CameraAnim> Anims, optional FLOAT Scale = 1.f, optional bool bDoNotRandomize);
/**
 * Returns true if there is enough space to play the camera anim
 */
simulated native final function bool	CameraAnimHasEnoughSpace( CameraAnim Anim, optional float  Scale = 1.f );

final function PlayRandomCameraBoneAnim
(
	const out array<CameraBoneAnimation> Anims,
	optional	float		Rate=1.f,
	optional	float		BlendInTime,
	optional	float		BlendOutTime,
	optional	bool		bLooping,
	optional	bool		bOverride,
	optional	bool		bSingleRayPenetrationOnly,
	optional	bool		bApplyFullMotion,
	optional	bool		bForceLevelCamera
 )
{
	local int AnimIdx;

	if( MyGearPawn != None && MainPlayerInput != None )
	{
		AnimIdx = ChooseCameraBoneAnim(Anims);
		if (AnimIdx >= 0)
		{
			MyGearPawn.PlayCustomCameraBoneAnim(Anims[AnimIdx].AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride, bSingleRayPenetrationOnly, bApplyFullMotion);

			if (bForceLevelCamera)
			{
				MainPlayerInput.ForcePitchCentering(TRUE);
			}
		}
	}
}


final function StopCameraBoneAnim(optional FLOAT BlendOutTime, optional bool bForceLevelCamera)
{
	if( MyGearPawn != None )
	{
		MyGearPawn.StopCustomCameraBoneAnim(BlendOutTime);
	}

	if( bForceLevelCamera && MainPlayerInput != None )
	{
		MainPlayerInput.ForcePitchCentering(FALSE);
	}
}

reliable client event Kismet_ClientPlaySound(SoundCue ASound, Actor SourceActor, float VolumeMultiplier, float PitchMultiplier, float FadeInTime, bool bSuppressSubtitles, bool bSuppressSpatialization)
{
	local GearGRI GRI;

	super.Kismet_ClientPlaySound(ASound, SourceActor, VolumeMultiplier, PitchMultiplier, FadeInTime, bSuppressSubtitles, bSuppressSpatialization);

	// assuming soundcues in Dialog* SoundClasses are speech
	if (InStr(ASound.SoundClass, "Dialog",, true) == 0)
	{
		GRI = GearGRI(WorldInfo.GRI);
		GRI.SpeechManager.NotifyDialogueStart(None, None, ASound, Speech_Scripted);
	}
}

reliable client event Kismet_ClientStopSound(SoundCue ASound, Actor SourceActor, float FadeOutTime)
{
	local GearGRI GRI;

	super.Kismet_ClientStopSound(ASound, SourceActor, FadeOutTime);

	if (InStr(ASound.SoundClass, "Dialog",, true) == 0)
	{
		GRI = GearGRI(WorldInfo.GRI);
		GRI.SpeechManager.NotifyDialogueFinish(None, ASound);
	}
}

/**
 * Extension of ClientPlaySound that allows you to specify location, volume, and pitch modifiers
 *
 * @param ASound - the sound to play
 * @param SourceActor - the Actor to attach the sound to (if None, attached to self)
 * @param bStopWhenOwnerDestroyed - whether the sound stops if SourceActor is destroyed
 * @param SourceLocation - if non-zero, the location for the sound
 * @param VolumeMultiplier - Volume multiplier attached to audio component
 * @param PitchMultiplier - Pitch multiplier attached to audio component
 */
unreliable client event ClientPlayModifiedSound(SoundCue ASound, Actor SourceActor, vector SourceLocation, bool bStopWhenOwnerDestroyed, float VolumeMultiplier, float PitchMultiplier)
{
	local AudioComponent AC;

	if ( SourceActor == None )
	{
		AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed, true, SourceLocation);
		if (AC == None)
		{
			return;
		}
		AC.bUseOwnerLocation = false;
		AC.Location = SourceLocation;
	}
	else if ( (SourceActor == GetViewTarget()) || (SourceActor == self) )
	{
		AC = GetPooledAudioComponent(ASound, None, bStopWhenOwnerDestroyed);
		if (AC == None)
		{
			return;
		}
		AC.bAllowSpatialization = false;
	}
	else
	{
		AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed);
		if (AC == None)
		{
			return;
		}
		if (!IsZero(SourceLocation) && SourceLocation != SourceActor.Location)
		{
			AC.bUseOwnerLocation = false;
			AC.Location = SourceLocation;
		}
	}
	AC.VolumeMultiplier = VolumeMultiplier;
	AC.PitchMultiplier = PitchMultiplier;
	AC.Play();
}

simulated function Name FindBestSoundMode()
{
	local GearGRI GRI;
	local name ModeName;
	local bool bOkToDoGameStateModes;
	local GearPawn BigHeadCheck;

	// Handle Big Head Mutator
	BigHeadCheck = GearPawn(WorldInfo.PawnList);
	if (BigHeadCheck != None && BigHeadCheck.SetBigHeadVoice(BigHeadCheck.HeadScale != BigHeadCheck.default.HeadScale))
	{
		// force sound mode switch to apply changes to classes.
		return 'Cover';
	}

	// kismet gets top billing, overriding everything
	if (KismetSpecifiedSoundMode != '' && bKismetSpecifiedSoundModeTopPriority)
	{
		return KismetSpecifiedSoundMode;
	}

	GRI = GearGRI(WorldInfo.GRI);

	bOkToDoGameStateModes = (!IsSplitscreenPlayer() && ((GRI == None) || !GRI.IsMultiplayerGame() || GRI.GameStatus == GS_RoundInProgress));

	// priority order
	// only do these if we're not in split screen and in SP or while an MP game is in progress
	if (bOkToDoGameStateModes)
	{
		if ( (MyGearPawn != None) && MyGearPawn.IsDBNO() )
		{
			return 'DBNO';
		}

		if (IsDead() && !IsSpectating())
		{
			return 'Death';
		}
	}

	// let speech manager decide which one to use for speech
	if ( (GRI != None) && (GRI.SpeechManager != None) )
	{
		ModeName = GRI.SpeechManager.GetDialogueSoundMode(self);
		if (ModeName != '')
		{
			return ModeName;
		}
	}

	// Use the kismet override if it wasn't already top priority
	if (KismetSpecifiedSoundMode != '')
	{
		return KismetSpecifiedSoundMode;
	}

	if (bOkToDoGameStateModes)
	{
		if (bAssessMode)
		{
			return 'TacCom';
		}

		if (IsDoingSpecialMove(SM_RoadieRun) || IsDoingSpecialMove(SM_RoadieRunStab))
		{
			return 'RoadieRun';
		}
	}

	if (IsInCoverState())
	{
		if (bIsTargeting)
		{
			return 'CoverLook';
		}
		else
		{
			return 'Cover';
		}
	}

	if (IsInCombat())
	{
		return 'Battle';
	}

	return 'Default';
}

/** Kismet handler. */
function OnSetSoundMode(SeqAct_SetSoundMode Action)
{
	if ( Action.InputLinks[0].bHasImpulse && (Action.SoundMode != None) )
	{
		KismetSpecifiedSoundMode = Action.SoundMode.Name;
		bKismetSpecifiedSoundModeTopPriority = Action.bTopPriority;
	}
	else
	{
		KismetSpecifiedSoundMode = '';
	}
}


/** GOW specific stuff to do when HUD is toggled */
simulated function OnToggleHUD(SeqAct_ToggleHUD inAction)
{
	local GearHUD_Base WH;

	Super.OnToggleHUD(inAction);

	// if we just toggled the hud back on, remove any old messages
	if ( (myHUD != None) && myHUD.bShowHUD )
	{
		WH = MyGearHud;
		WH.ClearHUDAfterShowToggle();
	}
}

/** Spawn a camera lens effect (e.g. blood).*/
unreliable client event ClientSpawnCameraLensEffect( class<EmitterCameraLensEffectBase> LensEffectEmitterClass )
{
	local GearWeap_AssaultRifle AR;

	AR = GearWeap_AssaultRifle(Pawn.Weapon);
	// Don't splash on the camera if we are in cover
	if ((MyGearPawn == None || !MyGearPawn.IsInCover()) &&
		//@hack - don't allow camera blood if chainsawing something w/o blood (this will obviously break in certain edge cases, but fixing this properly just isn't feasible at the moment)
		(LensEffectEmitterClass != class'Emit_CameraBlood_Chainsaw' || AR == None || !AR.bDisableChainsawBloodFX))
	{
		Super.ClientSpawnCameraLensEffect(LensEffectEmitterClass);
	}
}

function OnChangeSquad( SeqAct_ChangeSquad Action )
{
	SetSquadName( Action.SquadName );
}

function OnAISquadController( SeqAct_AISquadController inAction )
{
	if( Squad != None )
	{
		Squad.OnAISquadController( inAction );
	}
}

event SetSquadName(name NewSquadName)
{
	local GearPRI PRI;
	local GearTeamInfo Team;

	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		if (Squad != None)
		{
			Squad.UnregisterSquadMember(self);
		}

		PRI.SquadName = NewSquadName;
		Team = GearTeamInfo(PlayerReplicationInfo.Team);
		if (Team != None)
		{
			// players are always squad leaders
			Team.JoinSquad(PRI.SquadName, self, true);
		}
	}
}

/** Add DBNO teammate to the list */
simulated function AddDBNOTeammate(GearPawn WP)
{
	local GearPawn_COGGear COGPawn;
	local GearPRI PRI;

	COGPawn = GearPawn_COGGear(WP);
	// always allow teammates to be added in MP, but in campaign all teammates must be COGs (we don't
	// want and strandeds in taccom)
	if ((WorldInfo.GRI.IsMultiplayerGame() || COGPawn != None) && MyGearHud != None)
	{
		// don't use DBNO locator for leaders as the leader locator takes care of it
		PRI = GearPRI(WP.PlayerReplicationInfo);
		if (PRI == None || !PRI.bIsLeader)
		{
			MyGearHud.AddHUDLocator(class'GearHUDLocator_DBNO', WP);
		}
	}
}

// Make DBNO hud locators for all DBNO teammates
simulated function PopulateDBNOLocators()
{
	local GearPawn GP;

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (GP.GetTeamNum() == GetTeamNum())
		{
			AddDBNOTeammate(GP);
		}
	}
}

/**
 * Manually closes the progress message scene, if open.  Normally the progress message scene would be closed when the user
 * clicks one of its buttons.
 *
 * @param	bSimulateCancel		if TRUE, will set the message box's selection to the index of the Cancel button; otherwise,
 *								just closes the scene without touching the selection value.
 */
function ForceCloseUIMessageScene( optional name SceneTag='ProgressMessage', optional bool bSimulateCancel=true )
{
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( UIManager != None )
	{
		//@todo - implement simulating cancel
		UIManager.ClearUIMessage(SceneTag, LocalPlayer(Player));
	}
}

reliable simulated client event ClientWasKicked()
{
	bWasKicked = true;
	ClientSetProgressMessage(PMT_ConnectionFailure, Localize("GearPC", "KickedMsg", "GearGame"), Localize("GearPC", "NetworkDisconnectTitle", "GearGame"));
}

/** @return determines whether we should ignore or handle network errors */
native function bool ShouldIgnoreNetworkErrors();

/**
 * Iterates over the PRI array and unregisters voice for all players
 */
simulated function ClearVoiceRegistrants()
{
	local int PriIndex;
	local PlayerReplicationInfo PRI;
	local UniqueNetId ZeroId;

	if (OnlineSub != None &&
		OnlineSub.VoiceInterface != None)
	{
		// Remove each registered player from the voice channels
		for (PriIndex = 0; PriIndex < WorldInfo.GRI.PRIArray.Length; PriIndex++)
		{
			PRI = WorldInfo.GRI.PRIArray[PriIndex];
			if (PRI.UniqueId != ZeroId)
			{
				OnlineSub.VoiceInterface.UnregisterRemoteTalker(PRI.UniqueId);
			}
		}
	}
}

/**
 * Used when a host is telling a client to return to their party host from the
 * current session. It looks for the session named 'Party' and does a travel to
 * it. If it's not available, it just does a "disconnect"
 *
 * @param RequestingPlayerId net id of the player that is requesting the travel
 */
reliable client function ClientReturnToParty(UniqueNetId RequestingPlayerId)
{
	local OnlineGameSettings GameSettings;
	local bool bDestroySession;

	// Unregister all voice registrants
	ClearVoiceRegistrants();

	bIsReturningFromMatch = true;
	bIgnoreNetworkMessages = true;
	// Show the loading movie
	ClientShowLoadingMovie(true);

	// make sure we're not paused
	if (MyGearHUD != None && MyGearHUD.UI_PauseSceneInstance != None)
	{
		MyGearHUD.UnPauseGame();
	}
	else
	{
		SetPause(false);
	}

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		OnlineSub.PlayerInterface != None)
	{
		if (IsPrimaryPlayer())
		{
			GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');

			ReturnToPartyRequestingId = RequestingPlayerId;
			// Local and system link this is none, Private match otherwise
			bWasLocalSystemOrPrivate = GameSettings == None || !GameSettings.bUsesArbitration;

			if (GameSettings != None)
			{
				bDestroySession = WorldInfo.NetMode == NM_Client ? true : false;
				WriteStatsAndEndGameSession(true, bDestroySession, OnClientReturnToPartySessionCleanupComplete);
			}
			else
			{
				OnClientReturnToPartySessionCleanupComplete(true);
			}
		}
	}
}

/** Delegate called after game session cleanup to travel back to party or main menu */
function OnClientReturnToPartySessionCleanupComplete(bool bWasSuccessful)
{
	local string URL;
	local OnlineGameSettings Party;
	local GearRecentPlayersList PlayersList;
	local UniqueNetId ZeroId;

	// on the server, count the game as finished to stop stats being recorded for e.g. disconnection deaths
	if (WorldInfo.NetMode != NM_Client)
	{
		GearGRI(WorldInfo.GRI).GameStatus = GS_EndMatch;
	}

	Party = OnlineSub.GameInterface.GetGameSettings('Party');
	// Find the party settings to verify that a party is registered
	if (Party != None)
	{
		// Now see if we are the party host or not
		if (IsPartyLeader())
		{
			UnregisterRemotePlayers();
			// We are the party host so create the session and listen for returning clients
			URL = GetPartyMapName() $ "?game=" $ GetPartyGameTypeName() $ "?listen";

			// Server travel doesn't call PreClientTravel() so manually call it here
			PreClientTravel(URL,TRAVEL_Absolute,false);
			// Transition to being the party host without notifying clients and traveling absolute
			WorldInfo.ServerTravel(URL,true,true);
		}
		else
		{
			// See if the party leader completed the match or not
			PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));

			if (bWasLocalSystemOrPrivate ||
				// Horde match for this one
				GearHordePC(self) != None ||
				// Public match for this one
				(PlayersList != None && PlayersList.GetCurrentMatchResults().DidPlayerCompleteMatch(Party.OwningPlayerId)))
			{
				// party client initiated travel and should travel back to main menu on his own
				if (ReturnToPartyRequestingId == ZeroId || ReturnToPartyRequestingId == PlayerReplicationInfo.UniqueId
					//@todo sz - handle bPartyHostLost better by migrating party session/beacon instead
					// also if the party client lost his party host then can no longer travel back to that party session
					|| bPartyHostLost)
				{
					OnlineSub.GameInterface.DestroyOnlineGame('Party');
					ClientTravel("?closed", TRAVEL_Absolute);
				}
				// if the party or game host initiated the travel then have clients travel to their party hosts
				else
				{
					// We are joining so grab the connect string to use
					if (OnlineSub.GameInterface.GetResolvedConnectString('Party',URL))
					{
						ClientTravel(URL, TRAVEL_Absolute);
					}
					else
					{
						OnlineSub.GameInterface.DestroyOnlineGame('Party');
						ClientTravel("?closed", TRAVEL_Absolute);
					}
				}
			}
			else
			{
				OnlineSub.GameInterface.DestroyOnlineGame('Party');
				ClientTravel("?closed", TRAVEL_Absolute);
			}
		}
	}
	// If we are splitscreen or local, then return to the lobby
	else
	{
		URL = GetPartyMapName() $ "?game=" $ GetPartyGameTypeName() $ "?listen";
		// Server travel doesn't call PreClientTravel() so manually call it here
		PreClientTravel(URL,TRAVEL_Absolute,false);
		// Transition to being the party host without notifying clients and traveling absolute
		WorldInfo.ServerTravel(URL,true,true);
	}

	// Reset values for sanity
	ReturnToPartyRequestingId = ZeroId;
	bWasLocalSystemOrPrivate = false;
	CloseReturnToMainMenuCogSpin();
}

/**
 * Since LoadMap does not destroy PCs, we need to manually remove players
 */
simulated function UnregisterRemotePlayers()
{
	local GearPC OwnerPC;
	local GearPRI PRI;
	local int Index;

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
		{
			PRI = GearPRI(WorldInfo.GRI.PRIArray[Index]);
			OwnerPC = GearPC(PRI.Owner);

			// only unregister remote players that are a party of our party
			if ((OwnerPC == None || !OwnerPC.IsLocalPlayerController()) &&
				PRI.PartyOwnerUniqueId == GearPRI(PlayerReplicationInfo).PartyOwnerUniqueId)
			{
				PRI.UnregisterPlayerFromParty();
			}
		}
	}
}

/** Opens or restarts the updating scene (used for blocking input during async tasks) */
function OpenReturnToMainMenuCogSpin()
{
	class'GearUIManager'.static.OpenUpdatingScene("UpdatingTitle", "LiveStateDesc",false);
}

/** Begins the process of closing the updating scene (there is a min time the scene must be open) */
function CloseReturnToMainMenuCogSpin()
{
	class'GearUIManager'.static.CloseUpdatingScene(false);
}


/** Optional delegate called when stats writing and session ending have completed */
delegate OnWriteStatsAndEndSessionCompleteDelegate(bool bWasSuccessful);

/*
 * Writes stats (optionally) and destroy the session (optionally)
 * @param bWriteStats - should the game write stats for the PC before ending the session (only valid if match in progress)
 * @param bDestroySession - should the game destroy the session after everything is complete
 * @param EndDelegate - delegate to fire when everything is complete
 */
simulated function WriteStatsAndEndGameSession(bool bWriteStats, bool bDestroySession, delegate<OnWriteStatsAndEndSessionCompleteDelegate> EndDelegate)
{
	local GearGRI GRI;
	local OnlineGameSettings GameSettings;
	local OnlinePlaylistManager PlaylistMan;
	local LocalPlayer LP;
	local GearRecentPlayersList PlayersList;
	local GearMatchData MatchResults;
	local int LeaderboardId;

	// Setup the delegate
	WriteStatsAndEndSessionDelegate = EndDelegate;

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			OpenReturnToMainMenuCogSpin();
			if (GameSettings.GameState == OGS_InProgress)
			{
				GRI = GearGRI(WorldInfo.GRI);
				if (GRI != None && GRI.GameClass != None)
				{
					// Don't write stats or scores if not in progress
					if (bWriteStats)
					{
						PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
						if (PlayersList != None)
						{
							LP = LocalPlayer(Player);
							if (LP != None && !OnlineSub.PlayerInterface.IsGuestLogin(LP.ControllerId))
							{
								MatchResults = PlayersList.GetCurrentMatchResults();

								// Social / Ranked
								if (GRI.PlaylistId > 0)
								{
									PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
									if (PlaylistMan != None)
									{
										LeaderboardId = class'GearLeaderboardVersusSkill'.static.GetLeaderboardIdFromPlaylistId(PlaylistMan, GRI.PlaylistId);
										if (PlaylistMan.IsPlaylistArbitrated(GRI.PlaylistId))
										{
											// Penalize players who quit early in ranked
											ClientWriteLeaderboardStats(MatchResults.LastStatsWriteClass, true);
											ClientWriteOnlinePlayerScores(LeaderboardId);
										}
										else
										{
											// Check grace period allowed to quit (results are None after grace period)
											if (PlayersList.LastMatchData == None)
											{
												// Social doesn't write stats at all
												StoreLastMatchData(MatchResults.LastStatsWriteClass, false, true);
												ClientWriteOnlinePlayerScores(LeaderboardId);
											}
										}
									}
								}
								else
								{
									// Custom Match
									// Check grace period allowed to quit (results are None after grace period)
									if (PlayersList.LastMatchData == None)
									{
										// Write out our version of the scoring before leaving (no penalty)
										ClientWriteLeaderboardStats(MatchResults.LastStatsWriteClass, true);
									}
								}
							}
						}
					}
				}

				if (bDestroySession)
				{
					// Set the end delegate, where we'll destroy the game and then return to the menu
					OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndGameThenDestroyComplete);
				}
				else
				{
					// Set the end delegate, where we'll end the game only and then return to the menu
					OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnDestroyGameComplete);
				}

				OnlineSub.GameInterface.EndOnlineGame('Game');
			}
			else
			{
				// Session wasn't in progress, just go to the proper delegate (avoids spurious OnlineSub warning if you just call EndOnlineGame)
				if (bDestroySession)
				{
					OnEndGameThenDestroyComplete('Game', true);
				}
				else
				{
					OnDestroyGameComplete('Game', true);
				}
			}
		}
	}
}

/**
 * Called once the ending (flushing) of the game stats has completed
 *
 * @param SessionName the name of the session that was ended
 * @param bWasSuccessful whether the call succeeded or not
 */
function OnEndGameThenDestroyComplete(name SessionName,bool bWasSuccessful)
{
	if (SessionName == 'Game')
	{
	  // Set the end delegate, where we'll destroy the game and then join
	  if (OnlineSub != None && OnlineSub.GameInterface != None)
	  {
		  OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndGameThenDestroyComplete);
	  }

	  // Destroy the session
	  CheckOkToDeleteGameSession();
	}
}

/**
 * Called once the ending (flushing) of the game stats has completed
 *
 * @param SessionName the name of the session that was ended
 * @param bWasSuccessful whether the call succeeded or not
 */
function OnDestroyGameComplete(name SessionName,bool bWasSuccessful)
{
	if (SessionName == 'Game')
	{
		// Set the end delegate, where we'll destroy the game and then join
		if (OnlineSub != None && OnlineSub.GameInterface != None)
		{
			OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnDestroyGameComplete);
		}

		// Trigger our delegate
		WriteStatsAndEndSessionDelegate(bWasSuccessful);
	}
}

/**
 * Checks to see if it is safe to delete the session(s) and if not,
 * creates a timer until it is
 */
function CheckOkToDeleteGameSession()
{
	local OnlineGameSettings GameSettings;
	local bool bWaiting;

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		// Verify game settings destruction
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			bWaiting = true;
			if (GameSettings.GameState != OGS_Starting &&
				GameSettings.GameState != OGS_Ending)
			{
				OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameComplete);
				OnlineSub.GameInterface.DestroyOnlineGame('Game');
			}
			else
			{
				SetTimer(0.25,false,nameof(CheckOkToDeleteGameSession));
			}
		}
	}

	if (!bWaiting)
	{
		OnDestroyGameComplete('Game', true);
	}
}

/** Delegate called after party cleanup to travel to main menu */
simulated function OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
	if (SessionName == 'Party')
	{
		if (OnlineSub != None && OnlineSub.GameInterface != None)
		{
			OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnDestroyPartyComplete);
		}

		// Just close the spin and return
		CloseReturnToMainMenuCogSpin();
		ClientTravel("?Closed", TRAVEL_Absolute);
	}
}

/**
 * Checks to see if it is safe to delete the session(s) and if not,
 * creates a timer until it is
 */
function CheckOkToDeletePartySession()
{
	local OnlineGameSettings PartySettings;
	local bool bWaiting;

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		// Verify party settings destruction
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
		if (PartySettings != None)
		{
			bWaiting = true;
			if (PartySettings.GameState != OGS_Starting &&
				PartySettings.GameState != OGS_Ending)
			{
				OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyComplete);
				OnlineSub.GameInterface.DestroyOnlineGame('Party');
			}
			else
			{
				SetTimer(0.25,false,nameof(CheckOkToDeletePartySession));
			}
		}
	}

	if (!bWaiting)
	{
		OnDestroyPartyComplete('Party', true);
	}
}

/**
 * Tell this player to return to the main menu.  This version takes care of cleaning up the player's online sessions.
 *
 * @param bReturnToStartScreen if TRUE then return to the start screen instead of restoring menus via saved history
 */
simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
	local OnlineGameSettings GameSettings;
	local bool bShouldTravel;
	local GearLocalPlayer LP;

	`Log(`location @ ":"@"bReturnToStartScreen="$bReturnToStartScreen);
	if (bIsReturningFromMatch || bIsReturningToMainMenu)
	{
		`LogOnline("Client has already started returning to the main menu");
		return;
	}

	//Clear all post process override while we are at it!
	LP = GearLocalPlayer(Player);
	if (LP != None)
	{
		LP.ClearPostProcessSettingsOverride(0);
		LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
	}

	bShouldTravel = true;
	bIsReturningFromMatch = true;
	bIgnoreNetworkMessages = true;
	bIsReturningToMainMenu = true;
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			bShouldTravel = false;
			WriteStatsAndEndGameSession(true, true, ReturnToMainMenuCleanupComplete);
		}
		else
		{
			// Destroy party session on clients when backing out of a party in the menus
			bShouldTravel = false;
			ReturnToMainMenuCleanupComplete(true);
		}
	}

	if (bShouldTravel)
	{
		ClientTravel("?Closed", TRAVEL_Absolute);
	}
}

/** Delegate for the ReturnToMainMenu path that deletes party session before traveling */
simulated function ReturnToMainMenuCleanupComplete(bool bWasSuccessful)
{
	// Clean up the party session and return to lobby via the delegate
	CheckOkToDeletePartySession();
}

/** Callable version from the server to force the client out */
reliable client function ClientReturnToMainMenu()
{
	ReturnToMainMenu(false);
}

/** Client function to start the Countdown */
reliable client function StartCountdownTime(float CountdownAmount)
{
	if ( MyGearHud != None )
	{
		MyGearHud.CountdownEndTime = WorldInfo.TimeSeconds + CountdownAmount;
		MyGearHud.CountdownStartTime = WorldInfo.TimeSeconds;
		MyGearHud.CountdownStopTime = 0;
		MyGearHud.CountdownTimeToDraw = MyGearHud.CountdownEndTime;
	}
}

/** Client function to clear the Countdown */
reliable client function ClearCountdownTime(bool bInstantClear)
{
	if ( MyGearHud != None )
	{
		if ( bInstantClear )
		{
			MyGearHud.CountdownEndTime = 0.0f;
			MyGearHud.CountdownStartTime = 0.0f;
			MyGearHud.CountdownStopTime = 0.0f;
			MyGearHud.CountdownTimeToDraw = 0.0f;
		}
		else
		{
			MyGearHud.CountdownStopTime = WorldInfo.TimeSeconds;
		}
	}
}

/**
 * Retrieve the rotation sensitivity multiplier based on sensitivity level
 */
final simulated function float GetSensitivityMultiplier()
{
	local GearPRI WPRI;
	local bool bIsZooming;

	WPRI = GearPRI(PlayerReplicationInfo);
	bIsZooming = (MyGearPawn != None && MyGearPawn.bIsZoomed);

	if ( WPRI != None )
	{
		// See which sensitivity config we should use then return it
		if ( bIsZooming )
		{
			switch ( WPRI.ZoomSensitivityConfig )
			{
				case PCSO_Medium:	return ZoomRotationSensitivityMedium;
				case PCSO_Low:		return ZoomRotationSensitivityLow;
				case PCSO_High:		return ZoomRotationSensitivityHigh;
				default:			return ZoomRotationSensitivityMedium;
			}
		}
		else if ( bIsTargeting )
		{
			switch ( WPRI.TargetSensitivityConfig )
			{
				case PCSO_Medium:	return TargettingRotationSensitivityMedium;
				case PCSO_Low:		return TargettingRotationSensitivityLow;
				case PCSO_High:		return TargettingRotationSensitivityHigh;
				default:			return TargettingRotationSensitivityMedium;
			}
		}
		else
		{
			switch ( WPRI.ControllerSensitivityConfig )
			{
				case PCSO_Medium:	return RotationSensitivityMedium;
				case PCSO_Low:		return RotationSensitivityLow;
				case PCSO_High:		return RotationSensitivityHigh;
				default:			return RotationSensitivityMedium;
			}
		}
	}
	else
	{
		if ( bIsZooming )
		{
			return ZoomRotationSensitivityMedium;
		}
		else if ( bIsTargeting )
		{
			return TargettingRotationSensitivityMedium;
		}
		else
		{
			return RotationSensitivityMedium;
		}
	}
}



/**
 * Replicated call to tell client to keep playing the loading movie if it's currently playing,
 * and abort any StopMovie calls that may be pending through the FDelayedUnpauser.
 */
reliable client event ClientKeepPlayingLoadingMovie()
{
	if ( IsPrimaryPlayer() )
	{
		KeepPlayingLoadingMovie();
	}
}

/**
 * replicated call to tell client to start/stop the loading movie (for loading checkpoints, etc)
 * @param bShowMovie true to show the movie, false to stop it
 * @param bPauseAfterHide (optional) If TRUE, this will pause the game/delay movie stop to let textures stream in
 * @param PauseDuration (optional) allows overriding the default pause duration specified in .ini (only used if bPauseAfterHide is true)
 * @param KeepPlayingDuration (optional) keeps playing the movie for a specified more seconds after it's supposed to stop
 * @param bOverridePreviousDelays (optional) whether to cancel previous delayed StopMovie or not (defaults to FALSE)
 */
reliable client event ClientShowLoadingMovie(bool bShowMovie, optional bool bPauseAfterHide, optional float PauseDuration, optional float KeepPlayingDuration, optional bool bOverridePreviousDelays)
{
	local LocalPlayer LP;
	//Wipe all post process overrides if we are going to the movie!
	LP = LocalPlayer(Player);
	if (LP != None)
	{
		LP.ClearPostProcessSettingsOverride(0);
	}

	if ( IsPrimaryPlayer() )
	{
		ShowLoadingMovie(bShowMovie, bPauseAfterHide, PauseDuration, KeepPlayingDuration, bOverridePreviousDelays);
	}
}

/** notification from the client to the server that it has loaded the checkpoint locally */
reliable server event ServerNotifyClientLoadedCheckpoint()
{
	local Actor A;

	if (bClientLoadingCheckpoint)
	{
		bClientLoadingCheckpoint = false;

		if (LocalPlayer(Player) == None)
		{
			// force update all infrequently updated relevant actors
			foreach AllActors(class'Actor', A)
			{
				if (A.RemoteRole != ROLE_None)
				{
					if (A.NetUpdateFrequency < 1.0)
					{
						A.bForceNetUpdate = true;
					}
					// force a full update for matinees
					else if (A.IsA('MatineeActor'))
					{
						A.bNetDirty = true;
					}
				}
			}
		}
	}
}

/** == CHECKPOINT INTERFACE == */
function OnCheckpoint(SeqAct_Checkpoint Action)
{
	local Controller C;
	local GearPC PC, TeleportToPC;
	local GearAI AI;
	local name SquadName;
	local bool bTeleportOnly;

	bTeleportOnly = Action.InputLinks[2].bHasImpulse;
	if( Action.InputLinks[0].bHasImpulse || bTeleportOnly )
	{
		`Log("Save Checkpoint triggered from Kismet action" @ PathName(Action));

		if( !bTeleportOnly )
		{
			SaveCheckpoint( Action.CheckpointName );
		}

		// make sure squadmates are nearby; if not, teleport them
		TeleportToPC = GearPC(Action.GetController(Action.TeleportTargetPlayer));
		if (TeleportToPC == None || TeleportToPC.Pawn == None)
		{
			TeleportToPC = self;
		}
		if (TeleportToPC.Pawn != None)
		{
			foreach WorldInfo.AllControllers(class'Controller', C)
			{
				PC = GearPC(C);
				if (PC != None)
				{
					SquadName = (PC.Squad != None) ? PC.Squad.SquadName : '';
				}
				else
				{
					AI = GearAI(C);
					SquadName = (AI != None) ? AI.GetSquadName() : '';
				}
				if ( C != TeleportToPC && C.Pawn != None &&
					(Squad == None || GearPC(C) != None || Action.TeleportClasses.length > 0 || SquadName == Squad.SquadName) &&
					WorldInfo.GRI.OnSameTeam(C, self) &&
					Action.ShouldTeleport(C.Pawn, TeleportToPC.Pawn.Location) &&
					(Action.TeleportClasses.length == 0 || Action.TeleportClasses.Find(C.Pawn.Class) != INDEX_NONE) )
				{
					`Log("Attempting to teleport" @ C.Pawn @ "to" @ self @ "[" $ Pawn $ "]");
					if (!TeleportToPC.FindAvailableTeleportSpot(C.Pawn))
					{
						`Warn("Checkpoint failed to teleport" @ C.Pawn @ "to" @ TeleportToPC.Pawn);

						if( !C.Pawn.HandleTeleport( Action.FallbackTeleportActors, TRUE, TRUE ) )
						{
							`Warn("Checkpoint FALLBACK failed to teleport" @ C.Pawn @ "to" @ TeleportToPC.Pawn);
						}
					}
				}
			}
		}
	}
}

/**
 * Primary entry method for saving a checkpoint for this player.
 */
exec function SaveCheckpoint( optional Name InCheckpointName )
{
	local GearEngine Engine;
	local GearPC PC;
	local GearLocalPlayer LP;

	// don't allow checkpointing when dead/DBNO
	// don't allow multiple saves in a row to avoid wasted startup time, particularly in chapter starts
	// where we autosave but the LDs have sometimes also added a Kismet save shortly after startup
	if (IsPrimaryPlayer() && Pawn != None && Pawn.Health > 0 && Role == ROLE_Authority && WorldInfo.TimeSeconds - LastCheckpointSaveTime > 0.5)
	{
		// verify that we haven't actually lost the game and are just in the delay before the screen comes up
		foreach WorldInfo.AllControllers(class'GearPC', PC)
		{
			if (PC.IsTimerActive(nameof(PC.ProcessGameOver)) || (PC.Pawn != None && PC.Pawn.Health <= 0))
			{
				return;
			}
		}

		// if in Arcade mode, resurrect dead players
		if (GearGameSP_Arcade(WorldInfo.Game) != None)
		{
			GearGameSP_Arcade(WorldInfo.Game).ResurrectDeadPlayers();
		}

		Engine = GearEngine(class'Engine'.static.GetEngine());
		if (Engine != None)
		{
			LP = GearLocalPlayer(Player);
			if (LP != None)
			{
				// Toggle whether to write checkpoints
				Engine.bShouldWriteCheckpointToDisk = !LP.bWantsToSkipSaves;
				// Set their selected device id
				Engine.SetCurrentDeviceID(PersistentData.DeviceId);
				// Save the data
				SaveCheckpointWorker(InCheckpointName);
			}
		}
	}
}

/**
 * Performs the steps necessary to actually initiate the checkpoint save.  This method is called after all required conditions have been
 * checked and dealt with.
 */
private final function SaveCheckpointWorker( optional Name InCheckpointName )
{
	local GearEngine Engine;
	local GearPC PC;

	`assert(IsPrimaryPlayer());
	`assert(Pawn != None);
	`assert(Pawn.Health>0);
	`assert(Role == ROLE_Authority);

	Engine = GearEngine(class'Engine'.static.GetEngine());
	LastCheckpointSaveTime = WorldInfo.TimeSeconds;
	LastCheckpointSaveName = InCheckpointName;

	Engine.PendingCheckpointAction = Checkpoint_Save;
	Engine.PendingCheckpointLocation = MyGearPawn != None ? MyGearPawn.Location : Location;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.GuardianAngelReset();

		if ( LocalPlayer(PC.Player) == None )
		{
			PC.ClientNotifySavingCheckpoint();
		}
		else if ( PC.IsPrimaryPlayer() )
		{
			if (Engine.bShouldWriteCheckpointToDisk)
			{
				// Save the profile when we save checkpoints
				SaveProfile();
				class'Checkpoint'.static.ShowSavingContentWarning();
			}
			else
			{
				PC.ClientNotifySavingCheckpoint();
			}
		}
		else
		{
			PC.ClientNotifySavingCheckpoint();
		}
	}
}

/**
 * Notifies the HUD that a checkpoint has occurred so that it can draw the "CHECKPOINT" text.
 */
reliable client function ClientNotifySavingCheckpoint()
{
	if ( MyGearHud != None && IsPrimaryPlayer() )
	{
		MyGearHud.TimeOfLastCheckpoint = WorldInfo.TimeSeconds;
	}

	// Save the profile when we save checpoints
	SaveProfile();

	// Save the persistent data
	SavePersistentData();
}

exec function LoadCheckpoint( optional Name InCheckpointName )
{
	local GearGameSP_Base Game;
	local GearEngine Engine;

	if (Role == ROLE_Authority && WorldInfo.NextURL == "")
	{
		LastCheckpointSaveName = InCheckpointName;

		Game = GearGameSP_Base(WorldInfo.Game);
		if (Game != None)
		{
			// @STATS - End Logging due to user requested checkpoint load
			Game.EndLogging("LoadCheckpoint");
		}
		Engine = GearEngine(class'Engine'.static.GetEngine());
		`log(WorldInfo.TimeSeconds@GetFuncName()@"Engine:"@Engine);
		if (Engine != None)
		{
			// do the slow reload if we need to reclaim memory
			Engine.PendingCheckpointAction = Checkpoint_Load;
		}
	}
}

exec function RestartChapter()
{
	local GearGameSP_Base Game;

	Game = GearGameSP_Base(WorldInfo.Game);
	if (Game != None)
	{
		// @STATS - End Logging due to user requested chapter restart
		Game.EndLogging("RestartChapter");
		// explicit call to show loading movie because this transition occurs via ServerTravel, which doesn't always call ClientTravel
		ClientShowLoadingMovie(true);
		WorldInfo.ServerTravel("geargame_p?loadcheckpoint=0?chapter=" $ Game.CurrentChapter);
	}
}

native reliable client function ClientUpdateLevelStreamingStatus(Name PackageName, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad);

/** triggers the clientside part of loading checkpoints */
reliable client event ClientLoadCheckpoint(vector CheckpointLocation)
{
	local GearEngine Engine;

	Engine = GearEngine(class'Engine'.static.GetEngine());
	if (Engine != None)
	{
		Engine.PendingCheckpointAction = Checkpoint_Load;
		Engine.PendingCheckpointLocation = CheckpointLocation;
	}
}

function CreateCheckpointRecord( out CheckpointRecord Record )
{
	local InventoryRecord InvRecord;
	local GearWeapon Weapon;
	local GearShield Shield;
	local int i;
	local Pawn BasePawn, InvHolder;
	local GearPawn AnimPawn;
	local GearPawn_Infantry InfantryPawn;

	//@hack: kick the player off the troika here as that does bad things to the streaming for some reason
	if (Turret_TroikaBase(Pawn) != None)
	{
		Turret_TroikaBase(Pawn).DriverLeave(true);
	}
	if( GearVehicleBase(Pawn) != None && GearVehicleBase(Pawn).bKickDriverOnTeleport )
	{
		GearVehicleBase(Pawn).DriverLeave(true);
	}

	Record.SavedGuid = MyGuid;
	Record.CheckpointName = LastCheckpointSaveName;
	Record.PlayerSlotIndex = GearGameSP_Base(WorldInfo.Game).PlayerSlots.Find('Owner', self);
	if (MyGearPawn != None)
	{
		// create a GUID for our Pawn that is relative to ours
		//@warning: must match ApplyCheckpointRecord()
		if (GearPawnRidable_Base(Pawn) != None)
		{
			Record.PawnClassName = PathName(GearPawnRidable_Base(Pawn).Driver.Class);
			Record.RidableClassName = PathName(Pawn.Class);
		}
		else
		{
			Record.PawnClassName = PathName(Pawn.Class);
		}
		if (MyGearPawn.MutatedClass != None)
		{
			Record.MutatedClassName = PathName(MyGearPawn.MutatedClass);
		}
		Record.Location = Pawn.Location;
		Record.Rotation = Pawn.Rotation;
		if (Pawn.Base != None && Pawn.Base.bNoDelete && !Pawn.Base.bStatic && !Pawn.Base.bWorldGeometry)
		{
			Record.BasePathName = PathName(Pawn.Base);
		}
		// if we are in cover save the current cover slot
		if (IsInCoverState() && MyGearPawn.CurrentLink != None)
		{
			Record.SlotPathName = PathName(MyGearPawn.CurrentLink);
			Record.SlotIdx = MyGearPawn.CurrentSlotIdx;
		}
		AnimPawn = (GearPawnRidable_Base(MyGearPawn) != None) ? GearPawnRidable_Base(MyGearPawn).Driver : MyGearPawn;
		if (AnimPawn.Mesh != None && AnimPawn.Mesh.SkeletalMesh != None && AnimPawn.Mesh.SkeletalMesh.FaceFXAsset != None)
		{
			for (i = 0; i < ArrayCount(AnimPawn.ReplicatedFaceFXAnimSets); i++)
			{
				Record.MountedFaceFX[i] = PathName(AnimPawn.ReplicatedFaceFXAnimSets[i]);
			}
		}
		for (i = 0; i < ArrayCount(AnimPawn.KismetAnimSets); i++)
		{
			Record.KismetAnimSets[i] = PathName(AnimPawn.KismetAnimSets[i]);
		}
		Record.KismetAnimTree = PathName(MyGearPawn.ReplicatedKismetAnimTree);

		if (MyGearPawn.IsDoingSpecialMove(GSM_DragInjured_Leader))
		{
			Record.CarriedPawnGuid = MyGearPawn.InteractionPawn.MyGearAI.MyGuid;
		}
		Record.bWeaponHolstered = MyGearPawn.bWeaponHolstered && MyGearPawn.MyGearWeapon != None && MyGearPawn.MyGearWeapon.bTemporaryHolster;

		// If pawn is an infantry, save any attachments
		InfantryPawn = GearPawn_Infantry(MyGearPawn);
		if (InfantryPawn != None)
		{
			for (i = 0; i < ArrayCount(Record.AttachmentClassNames); ++i)
			{
				Record.AttachmentClassNames[i] = PathName(InfantryPawn.AttachmentClasses[i]);
			}
		}

		if (GearPawn_SilverbackLoaderBase(MyGearPawn) != None)
		{
			Record.CratePathName = PathName(GearPawn_SilverbackLoaderBase(MyGearPawn).PickedUpCrate);
		}
	}
	else
	{
		if (Pawn != None)
		{
			//@warning: assumption that player controlled non-GearPawns are level placed
			if (GearWeaponPawn(Pawn) != None)
			{
				Record.PawnPathName = PathName(Pawn.GetVehicleBase());
			}
			else
			{
				Record.PawnPathName = PathName(Pawn);
			}
			if (Vehicle(Pawn) != None)
			{
				// record driver class so we know who's in it
				Record.PawnClassName = PathName(Vehicle(Pawn).Driver.Class);
			}
			Record.Location = Pawn.Location;
			Record.Rotation = Pawn.Rotation;
		}
		else
		{
			Record.Location = Location;
			Record.Rotation = Rotation;
		}
	}
	if (Pawn != None)
	{
		// create records for each inventory item
		if (GearPawnRidable_Base(Pawn) != None)
		{
			InvHolder = GearPawnRidable_Base(Pawn).Driver;
		}
		else if (Vehicle(Pawn) != None)
		{
			InvHolder = Vehicle(Pawn).Driver;
		}
		else
		{
			InvHolder = Pawn;
		}
		foreach InvHolder.InvManager.InventoryActors(class'GearWeapon', Weapon)
		{
			Weapon.CreateCheckpointRecord(InvRecord);
			Record.InventoryRecords.AddItem(InvRecord);
		}
		foreach InvHolder.InvManager.InventoryActors(class'GearShield', Shield)
		{
			Shield.CreateCheckpointRecord(InvRecord);
			Record.InventoryRecords.AddItem(InvRecord);
		}
		// record health
		BasePawn = (GearWeaponPawn(Pawn) != None) ? Pawn.GetVehicleBase() : Pawn;
		Record.PawnHealthPct = float(BasePawn.Health) / float(BasePawn.HealthMax);
	}
	Record.TeamIndex = GetTeamNum();
	Record.SquadFormationName = string(GearPRI(PlayerReplicationInfo).SquadName);
	if (ObjectiveMgr != None)
	{
		Record.Objectives = ObjectiveMgr.Objectives;
	}
	Record.Music = WorldInfo.CurrentMusicTrack;
	Record.Music.TheSoundCuePath = PathName(Record.Music.TheSoundCue);
	Record.Music.TheSoundCue = None;
	Record.StoredKismetVariables = StoredKismetVariables;
	Record.GUDSFrequencyMultiplier = GearGame(WorldInfo.Game).UnscriptedDialogueManager.GlobalChanceToPlayMultiplier;
	Record.Score = PlayerReplicationInfo.Score;
}

/** this is used to delay entering cover after loading a checkpoint because it seems GearPawn's animations can't handle
 * being put into cover on the same tick it was spawned (various anim nodes get into a completely hosed state)
 */
function CheckpointCoverHack()
{
	local CovPosInfo RecordedCover;

	if (LocalPlayer(Player) != None)
	{
		if ( ServerDictatedCover.Link != None && ServerDictatedCover.Link.IsEnabled() &&
			ServerDictatedCover.Link.Slots[ServerDictatedCover.SlotIdx].bEnabled )
		{
			MyGearPawn.SetCoverInfoFromSlotInfo(RecordedCover, ServerDictatedCover);
			AcquireCover(RecordedCover);
		}
		else
		{
			ServerDictatedCover.Link = None;
		}
	}
}

/** called to recreate the player's camera */
final reliable client function ClientResetCamera()
{
	if (PlayerCamera != None)
	{
		PlayerCamera.Destroy();
		SpawnPlayerCamera();
	}

	RelativeToVehicleViewRot = rot(0,0,0);
	LastVehicleSpaceViewRotation = rot(0,0,0);
}

/** Resets the object pool to its initial state
 *  @param  bClearActive    If TRUE clear any active pooled objects, otherwise only compact the inactive elements
 */
reliable client final function ClientResetObjectPool(optional bool bClearActive)
{
	local int i;

	// clear emitter pool
	if (WorldInfo.MyEmitterPool != None)
	{
		WorldInfo.MyEmitterPool.ClearPoolComponents(bClearActive);
		GearEmitterPool(WorldInfo.MyEmitterPool).ClearPoolTracers(bClearActive);
	}
	// clear decal pool
	if (WorldInfo.MyDecalManager != None)
	{
		for (i = 0; i < WorldInfo.MyDecalManager.ActiveDecals.length; i++)
		{
			WorldInfo.MyDecalManager.DecalFinished(WorldInfo.MyDecalManager.ActiveDecals[i].Decal);
		}
		WorldInfo.MyDecalManager.ActiveDecals.length = 0;
		WorldInfo.MyDecalManager.PoolDecals.length = 0;
	}
	// clear physics pools
	WorldInfo.ClearPhysicsPools();
}

/** resets various state after loading a checkpoint */
reliable client final function ClientCheckpointReset()
{
	local FracturedStaticMeshActor FracActor;
	local GearPawn P;

	// clear cinematic flags
	bCinematicMode = false;
	bInvisible = FALSE;
	bInMatinee = false;
	if (myHUD != None)
	{
		myHUD.bShowHUD = true;
	}
	// clear HUD info
	StopPostProcessOverride(eGPP_BleedOut);
	if (MyGearHud != None)
	{
		MyGearHud.ClearActiveActionInfo();
	}
	// clear trigger flags
	if (MyGearPawn != None && MyGearPawn.bInsideDoorTrigger)
	{
		OnExitDoorTrigger();
	}
	// reset camera
	ClientResetCamera();
	// close any menus that were up
	ClientCloseAllMenus();
	// restore subtitles (game over screen turns them off)
	RestoreShowSubtitles();
	// Reset the tutorials
	if (TutorialMgr != none)
	{
		TutorialMgr.RebootSystem();
	}
	// reset object pools and fracturables
	ClientResetObjectPool(true);
	foreach DynamicActors(class'FracturedStaticMeshActor', FracActor)
	{
		FracActor.ResetVisibility();
	}
	if (WorldInfo.MyFractureManager != None)
	{
		WorldInfo.MyFractureManager.ResetPoolVisibility();
	}

	// destroy any old, dead, torn off Pawns
	foreach WorldInfo.AllPawns(class'GearPawn', P)
	{
		if (P.bTearOff)
		{
			P.Destroy();
		}
	}

	// if we got a Pawn, make sure it got a weapon
	if (Pawn != None && Pawn.Weapon == None)
	{
		ClientSwitchToBestWeapon();
	}

	// and stop the loading movie after a delay to let textures stream in
	ClientShowLoadingMovie(false, true);

	// slight delay to make sure we finish up any lingering streaming tasks
	SetTimer(0.5, false, nameof(ServerCheckpointResetComplete));

	// let the UI know that we're no longer in cinematic mode so it should update cached viewport sizes for any open scenes
	UpdateUIViewportSizes();
}

/** called after the client has done all its post-checkpoint tasks and is ready to go */
reliable server function ServerCheckpointResetComplete()
{
	local Actor A;
	local Weapon W;

	if (!IsLocalPlayerController())
	{
		// force networking update
		foreach AllActors(class'Actor', A)
		{
			if (A.NetUpdateFrequency < 1.0 && !A.bOnlyRelevantToOwner)
			{
				A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + 0.2 * FRand()));
			}
		}

		//@HACK: reselect weapon if it's not in the persistent level, since the replication might have failed
		//	due to client not having the level loaded yet
		//	need to make selecting initial weapon not rely on RPCs...
		if (Vehicle(Pawn) != None)
		{
			if (Pawn.Weapon != None)
			{
				Pawn.Weapon.ClientWeaponSet(false);
			}
			else
			{
				foreach Pawn.InvManager.InventoryActors(class'Weapon', W)
				{
					W.ClientWeaponSet(false);
					break;
				}
			}
		}
	}
}

/** converter from CheckpointMusicRecord to MusicTrackStruct as the script compiler can't do it automatically */
native final function CopyCheckpointMusicInfo(const out CheckpointMusicRecord SourceInfo, out MusicTrackStruct DestInfo);

/** applies inventory records to our Pawn */
private function ApplyInventoryRecords(const out array<InventoryRecord> Records)
{
	local class<Inventory> InvClass;
	local InventoryRecord InvRecord;
	local Inventory InvItem;
	local bool bFoundActiveWeapon;
	local GearWeapon W;

	// discard any current inventory
	Pawn.InvManager.DiscardInventory();
	// create any recorded inventory items
	foreach Records(InvRecord)
	{
		InvClass = class<Inventory>(FindObject(InvRecord.InventoryClassPath, class'Class'));
		if (InvClass == None)
		{
			`Warn("Failed to find class" @ InvRecord.InventoryClassPath @ "in memory");
		}
		else
		{
			InvItem = Pawn.InvManager.Spawn(InvClass);
			if (InvItem == None)
			{
				`Warn("Couldn't spawn inventory of class" @ InvClass);
			}
			else
			{
				if (GearWeapon(InvItem) != None)
				{
					GearWeapon(InvItem).ApplyCheckpointRecord(InvRecord);
				}
				Pawn.InvManager.AddInventory(InvItem, !InvRecord.bIsActiveWeapon);
				bFoundActiveWeapon = bFoundActiveWeapon || InvRecord.bIsActiveWeapon;
			}
		}
	}
	// make sure a valid weapon was selected
	if (!bFoundActiveWeapon)
	{
		foreach Pawn.InvManager.InventoryActors(class'GearWeapon', W)
		{
			if (W.HasAnyAmmo())
			{
				W.ClientWeaponSet(true);
			}
			break;
		}
	}
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	local Pawn FoundPawn;
	local Vehicle FoundVehicle;
	local MusicTrackStruct NewMusic;
	local int i;
	local FaceFXAnimSet FaceFXAnim;
	local Actor OldBase;
	local Guid EmptyGuid;
	local GearPawn_Infantry InfantryPawn;
	local class<GearPawnRidable_Base> RidableClass;
	local GearPawnRidable_Base Ridable;
	local KActor_SilverbackLoaderCrateBase Crate;
	local GearPC OtherPC;
	local GearDestructibleObject GDO;

	MyGuid = Record.SavedGuid;
	LastCheckpointSaveName = Record.CheckpointName;
	// if we were in cover then bail now
	if (IsInCoverState())
	{
		LeaveCover();
	}
	// eliminate our existing pawn
	if (MyGearPawn != None)
	{
		MyGearPawn.LifeSpan = 0.1;
	}
	else if (Vehicle(Pawn) != None)
	{
		Vehicle(Pawn).DriverLeft();
	}
	UnPossess();
	GearPRI(PlayerReplicationInfo).PawnClass = (Record.PawnClassName != "") ? class<GearPawn>(FindObject(Record.PawnClassName, class'Class')) : None;
	if (Record.PlayerSlotIndex != INDEX_NONE)
	{
		GearGameSP_Base(WorldInfo.Game).PlayerSlots[Record.PlayerSlotIndex].Owner = self;
		if (GearPRI(PlayerReplicationInfo).PawnClass != None)
		{
			GearGameSP_Base(WorldInfo.Game).PlayerSlots[Record.PlayerSlotIndex].PawnClass = GearPRI(PlayerReplicationInfo).PawnClass;
		}
	}
	if (Record.PawnPathName == "")
	{
		if (GearPRI(PlayerReplicationInfo).PawnClass != None)
		{
			// restart this player to create the pawn
			WorldInfo.Game.RestartPlayer(self);
			if (Pawn != None)
			{
				ApplyInventoryRecords(Record.InventoryRecords);

				WorldInfo.Game.ChangeTeam(self, Record.TeamIndex, false);
				SetSquadName(name(Record.SquadFormationName));
				if (Record.MutatedClassName != "")
				{
					class<GearPawn>(FindObject(Record.MutatedClassName, class'Class')).static.MutatePawn(MyGearPawn);
				}

				if (MyGearPawn != None)
				{
					if (MyGearPawn.Mesh != None && MyGearPawn.Mesh.SkeletalMesh != None && MyGearPawn.Mesh.SkeletalMesh.FaceFXAsset != None)
					{
						for (i = 0; i < ArrayCount(Record.MountedFaceFX); i++)
						{
							FaceFXAnim = FaceFXAnimSet(FindObject(Record.MountedFaceFX[i], class'FaceFXAnimSet'));
							if (FaceFXAnim != None)
							{
								MyGearPawn.Mesh.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(FaceFXAnim);
								MyGearPawn.ReplicatedFaceFXAnimSets[i] = FaceFXAnim;
							}
						}
					}

					MyGearPawn.ReplicatedKismetAnimTree = AnimTree(FindObject(Record.KismetAnimTree, class'AnimTree'));
					if( MyGearPawn.ReplicatedKismetAnimTree != None )
					{
						MyGearPawn.Mesh.SetAnimTreeTemplate( MyGearPawn.ReplicatedKismetAnimTree );
					}

					for (i = 0; i < ArrayCount(MyGearPawn.KismetAnimSets); i++)
					{
						MyGearPawn.KismetAnimSets[i] = AnimSet(FindObject(Record.KismetAnimSets[i], class'AnimSet'));
					}
					MyGearPawn.UpdateAnimSetList();
					if (Record.bWeaponHolstered && MyGearPawn.MyGearWeapon != None)
					{
						MyGearPawn.MyGearWeapon.HolsterWeaponTemporarily(true);
					}

					// If pawn is an infantry, restore any attachments
					InfantryPawn = GearPawn_Infantry(MyGearPawn);
					if (InfantryPawn != None)
					{
						for (i = 0; i < ArrayCount(Record.AttachmentClassNames); ++i)
						{
							InfantryPawn.AttachmentClasses[i] = class<ItemSpawnable>(FindObject(Record.AttachmentClassNames[i], class'Class'));
						}
						InfantryPawn.SetupAllAttachments();
					}
				}

				if (Record.RidableClassName != "")
				{
					RidableClass = class<GearPawnRidable_Base>(FindObject(Record.RidableClassName, class'Class'));
					if (RidableClass != None)
					{
						Ridable = Spawn(RidableClass,,, Record.Location, Record.Rotation,, true);
						if (Ridable != None)
						{
							DriveRidablePawn(Ridable, true);
							if (Record.CratePathName != "" && GearPawn_SilverbackLoaderBase(Pawn) != None)
							{
								Crate = KActor_SilverbackLoaderCrateBase(FindObject(Record.CratePathName, class'KActor_SilverbackLoaderCrateBase'));
								if (Crate != None)
								{
									GearPawn_SilverbackLoaderBase(Ridable).PickedUpCrate = Crate;
									Ridable.ServerDoSpecialMove(GSM_SilverbackLoaderCratePickup, TRUE);
								}
							}
						}
					}
				}

				// move the pawn to the correct location
				Pawn.SetLocation(Record.Location);
				Pawn.SetRotation(Record.Rotation);

				// ensure we don't have a stale anchor lying around from before we teleported
				if (!Pawn.ValidAnchor())
				{
					Pawn.SetAnchor(None);
				}

				if (Record.BasePathName != "")
				{
					Pawn.SetBase(Actor(FindObject(Record.BasePathName, class'Actor')));
				}
				// snap the camera to the pawn rotation, otherwise it will retain the previous direction at the time of load
				SetRotation(Record.Rotation);
				ClientSetRotation(Record.Rotation);

				if (Record.SlotPathName != "")
				{
					ServerDictatedCover.Link = CoverLink(FindObject(Record.SlotPathName, class'CoverLink'));
					ServerDictatedCover.SlotIdx = Record.SlotIdx;
					if ( ServerDictatedCover.Link != None && ServerDictatedCover.Link.IsEnabled() &&
						ServerDictatedCover.Link.Slots[ServerDictatedCover.SlotIdx].bEnabled )
					{
						SetTimer( 0.5, false, nameof(CheckpointCoverHack) );
					}
					else
					{
						ServerDictatedCover.Link = None;
					}
				}
				else if (GearPawnRidable_Base(Pawn) == None)
				{
					GotoState('PlayerWalking');
				}
			}
		}
		else
		{
			// this player's character isn't in the game; spectate whoever is
			foreach WorldInfo.AllControllers(class'GearPC', OtherPC)
			{
				if (OtherPC.Pawn != None)
				{
					SetViewTarget(OtherPC.Pawn);
					ClientSetViewTarget(OtherPC.Pawn);
				}
			}
		}
	}
	else
	{
		// find the pawn in the level
		FoundPawn = Pawn(FindObject(Record.PawnPathName, class'Pawn'));
		if (FoundPawn != None)
		{
			FoundPawn.SetHidden(false);
			FoundVehicle = Vehicle(FoundPawn);
			if (FoundVehicle != None)
			{
				if (FoundVehicle != Pawn)
				{
					WorldInfo.Game.RestartPlayer(self);
					ApplyInventoryRecords(Record.InventoryRecords);
					if (!FoundVehicle.TryToDrive(Pawn))
					{
						`Warn("Failed to enter vehicle" @ FoundVehicle @ "with driver" @ Pawn);
					}
				}
				if (Pawn == FoundVehicle)
				{
					OldBase = FoundPawn.Base;
					FoundPawn.SetLocation(Record.Location);
					//@HACK: ignore record rotation for the ride reaver, breaks the matinee for some reason
					if (Vehicle_RideReaver_Base(Pawn) == None)
					{
						FoundPawn.SetRotation(Record.Rotation);
					}
					if (SVehicle(FoundVehicle) != None)
					{
						FoundVehicle.Mesh.SetRBPosition(Record.Location);
						FoundVehicle.Mesh.SetRBRotation(Record.Rotation);
					}
					FoundPawn.SetBase(OldBase);
				}
			}
			else
			{
				FoundPawn.SetLocation(Record.Location);
				FoundPawn.SetRotation(Record.Rotation);
				if (FoundPawn != Pawn)
				{
					Possess(FoundPawn, false);
				}
			}
			// snap the camera to the pawn rotation, otherwise it will retain the previous direction at the time of load
			//@HACK: not for the ride reaver, causes the whole thing to rotate for some reason
			if (Vehicle_RideReaver_Base(Pawn) == None)
			{
				SetRotation(Record.Rotation);
				ClientSetRotation(Record.Rotation);
			}
			WorldInfo.Game.ChangeTeam(self, Record.TeamIndex, false);
			SetSquadName(name(Record.SquadFormationName));
		}
	}
	if (Pawn != None)
	{
		Pawn.Health = Record.PawnHealthPct * Pawn.HealthMax;
		if (GearVehicle(Pawn) != None)
		{
			GearVehicle(Pawn).ReceivedHealthChange(Pawn.default.Health);
		}
		if (Pawn.Health < Pawn.HealthMax && GearPawn(Pawn) != None)
		{
			GearPawn(Pawn).ResetHealthRecharge();
		}
	}
	if (ObjectiveMgr != None && LocalPlayer(Player) != None)
	{
		ObjectiveMgr.Objectives = Record.Objectives;
		// reset UpdateTime for objectives so that old ones never display and currently active ones start out onscreen
		for (i = 0; i < ObjectiveMgr.Objectives.length; i++)
		{
			ObjectiveMgr.Objectives[i].UpdatedTime = (ObjectiveMgr.Objectives[i].bCompleted) ? -100.0 : WorldInfo.TimeSeconds;
		}
	}
	if (LocalPlayer(Player) != None)
	{
		CopyCheckpointMusicInfo(Record.Music, NewMusic);
		NewMusic.TheSoundCue = SoundCue(FindObject(Record.Music.TheSoundCuePath, class'SoundCue'));
		WorldInfo.UpdateMusicTrack(NewMusic);

		StoredKismetVariables = Record.StoredKismetVariables;

		GearGame(WorldInfo.Game).UnscriptedDialogueManager.GlobalChanceToPlayMultiplier = Record.GUDSFrequencyMultiplier;
	}

	// restore Arcade score, reset multiplier
	//@todo: what if human is becoming AI?
	PlayerReplicationInfo.Score = Record.Score;

	// handle delayed application of someone we were carrying
	if (MyGearPawn != None && Record.CarriedPawnGuid != EmptyGuid)
	{
		MyGearPawn.PendingCarriedPawnGuid = Record.CarriedPawnGuid;
		MyGearPawn.SetTimer(0.001, false, nameof(MyGearPawn.ApplyPendingCarriedPawn));
	}

	// Shut down any overlapping GDOs, in case we were standing on a destroyed one when the checkpoint was saved
	foreach Pawn.OverlappingActors(class'GearDestructibleObject', GDO, Pawn.GetCollisionRadius())
	{
		GDO.ShutDownObject();
	}

	// if we were spawned just to parse the data, now destroy and let the AI take over
	if (bCheckpointDummy)
	{
		`Log("Destroying checkpoint dummy GearPC");
		Destroy();
	}
}

//@HACK: fix up mesh animtree and translation after a map transition because the vehicle exit code doesn't seem to
//	trigger/work correctly in some cases for some reason
reliable client function ClientMeshFixupHack(GearPawn P)
{
	if (P != None && P.Mesh != None)
	{
		if (P.Mesh.AnimTreeTemplate != P.default.Mesh.AnimTreeTemplate)
		{
			P.Mesh.SetAnimTreeTemplate(P.default.Mesh.AnimTreeTemplate);
		}
		P.Mesh.SetTranslation(P.default.Mesh.Translation);
	}

	//@HACK: workaround for weapon sometimes not showing up for client after transition
	if ( P != None && WorldInfo.NetMode == NM_Client && !P.IsLocallyControlled() &&
			P.InvManager != None && P.InvManager.Role == ROLE_Authority )
	{
		P.InvManager.Destroy();
		P.Weapon = None;
		P.MyGearWeapon = None;
		P.RefreshRemoteAttachments();
	}
}

/** Returns the number of pixels to move the dramatic text down for MP */
final function int NumPixelsToMoveDownForDramaText()
{
	if (IsSplitscreenPlayer())
	{
		return 10;
	}
	else
	{
		return 55;
	}
}

/**
 * Replicated function to use when setting the rich presence string for coop
 *
 * @param PawnClass the pawn this player is playing as
 * @param Chapter the chapter point to convert to act/chapter information
 */
reliable client function ClientSetCoopRichPresence(class<Pawn> PawnClass,int Chapter);

reliable server final function ServerAbortConversation()
{
	// Set the time that the conversation abort occurred.  The latent kismet action will detect this and properly abort everyone affected.
	ConversationAbortTime = WorldInfo.TimeSeconds;
}


simulated function MortarPitchAdjDone()
{
	EnableInput(FALSE, FALSE, TRUE);
}

simulated final protected function rotator ClampYaw(rotator Rot, int BaseYaw, int MaxDelta)
{
	local int	DeltaFromCenter, YawAdj;
	local rotator OutRot;

	DeltaFromCenter = NormalizeRotAxis(Rot.Yaw - BaseYaw);

	if( DeltaFromCenter > MaxDelta )
	{
		YawAdj	= MaxDelta - DeltaFromCenter;
	}
	else if( DeltaFromCenter < -MaxDelta )
	{
		YawAdj	= -(DeltaFromCenter + MaxDelta);
	}

	OutRot = Rot;
	OutRot.Yaw += YawAdj;
	return OutRot;
};

event Rotator LimitViewRotation( Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax )
{
	local Turret_TroikaBase GT;
	local Rotator Rot;
	local vector TurrX, TurrY, TurrZ;

	// Give a chance to Special Moves to limit view Rotation.
	if( MyGearPawn != None && MyGearPawn.SpecialMove != SM_None )
	{
		MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].LimitViewRotation(ViewRotation);
	}

	// handle non-level Turrets (e.g turrets on derricks in Gears 2)
	if (MyGearPawn == None)
	{
		GT = Turret_TroikaBase(Pawn);
		if (GT != None)		// && (GT->Base != None) && (GT->Base )
		{
			Rot = QuatToRotator(GT.Mesh.GetBoneQuaternion(GT.Pivot_Latitude_BoneName));
			GetAxes(Rot, TurrX, TurrY, TurrZ);
			Rot = Rotator(TurrY);		// compensates for base bone orientation
			ViewPitchMin += Rot.Pitch;
			ViewPitchMax += Rot.Pitch;
		}
	}

	return Super.LimitViewRotation(ViewRotation, ViewPitchMin, ViewPitchMax);
}

//stub
unreliable server function ServerPlayBrumakRoar();
function SetBloodmountRun(bool bStartRun);
reliable server function ServerSetBloodmountRun(bool bStartRun);

/** Player driving Silverback */
state PlayerDrivingSilverback extends PlayerWalking
{
	// Silverback has static weapons
	exec function PrevWeapon();
	exec function NextWeapon();
	function bool CanPickupWeapons();

	// Silverback cannot take cover
	function TransitionFromRoadieRunToCover( CovPosInfo FoundCovInfo, optional bool bNoCameraAutoAlign );
	function bool CanRunToCover(out CovPosInfo CoverCanRunTo, out int NoCameraAutoAlign, optional bool bSkipSpecialMoveCheck, optional float CheckScale, optional EDoubleClickDir DblClickDirToCheck=DCLICK_None, optional bool bPreventSideEntry);
	function AcquireCover(CovPosInfo CovInfo, optional bool bNoCameraAutoAlign)
	{
		`log( self@GetFuncName()@MyGearPawn@"NO GETTING INTO COVER IN SILVERBACK" );
		ScriptTrace();
	}

	// Don't want silverback to slow down when targeting
	function HandleWalking();

	/** @return FALSE since the client never uses anything in the Silverback */
	function bool ClientUse()
	{
		return FALSE;
	}
}

state PlayerRidingVehicle extends PlayerWalking
{
	function BeginState(Name PreviousStateName)
	{
	}

	/** Overridden to prevent movement */
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		Super.ProcessMove(DeltaTime, vect(0,0,0), DCLICK_None, DeltaRot);
	}

	function UpdateRotation(float DeltaTime)
	{
		local rotator NewRelRot;

		Super.UpdateRotation(DeltaTime);

		// Update relative rotation
		NewRelRot.Yaw = NormalizeRotAxis(Rotation.Yaw - Pawn.Base.Rotation.Yaw);
		Pawn.SetRelativeRotation(NewRelRot);
	}

	/** Overridden to prevent movement and changing Pawn's base */
 	function ReplicateMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
 	{
		local SavedMove NewMove, OldMove, LastMove;
		local byte ClientRoll;
		local float NetMoveDelta;

		// do nothing if we are no longer connected
		if (Player == None)
		{
			return;
		}

		MaxResponseTime = Default.MaxResponseTime * WorldInfo.TimeDilation;
		DeltaTime = ((Pawn != None) ? Pawn.CustomTimeDilation : CustomTimeDilation) * FMin(DeltaTime, MaxResponseTime);

		// find the most recent move (LastMove), and the oldest (unacknowledged) important move (OldMove)
		// a SavedMove is interesting if it differs significantly from the last acknowledged move
		if ( SavedMoves != None )
		{
			LastMove = SavedMoves;
			OldMove = None;
			while ( LastMove.NextMove != None )
			{
				// find first important unacknowledged move
				if ( (OldMove == None) && (Pawn != None) && LastMove.IsImportantMove(LastAckedAccel) )
				{
					OldMove = LastMove;
				}
				LastMove = LastMove.NextMove;
			}
		}

		// Get a SavedMove object to store the movement in.
		NewMove = GetFreeMove();
		if ( NewMove == None )
		{
			return;
		}
		NewMove.SetMoveFor(self, DeltaTime, vect(0,0,0), DoubleClickMove);

		// Simulate the movement locally.
		bDoubleJump = false;
		ProcessMove(NewMove.Delta, vect(0,0,0), DCLICK_None, DeltaRot);
		NewMove.PostUpdate(self);

		if( SavedMoves == None )
		{
			SavedMoves = NewMove;
		}
		else
		{
			LastMove.NextMove = NewMove;
		}

		if ( PendingMove == None )
		{
			// Decide whether to hold off on move
			// send moves more frequently in small games where server isn't likely to be saturated
			if( (Player.CurrentNetSpeed > 10000) && (WorldInfo.GRI != None) && (WorldInfo.GRI.PRIArray.Length <= 10) )
			{
				NetMoveDelta = 0.011;
			}
			else
			{
				NetMoveDelta = FMax(0.0222,2 * WorldInfo.MoveRepSize/Player.CurrentNetSpeed);
			}

			if( (WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation < NetMoveDelta )
			{
				PendingMove = NewMove;
				return;
			}
		}

		ClientUpdateTime = WorldInfo.TimeSeconds;

		// Send to the server
		ClientRoll = (Rotation.Roll >> 8) & 255;

		CallServerMove( NewMove,
				((Pawn == None) ? Location : Pawn.Location),
				ClientRoll,
				((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535),
				OldMove );

		PendingMove = None;
 	}
};

state PlayerDrivingSiegebeast extends PlayerDriving
{
	/**
	 * Force the camera yaw to look in the siegebeast's direction
	 *
	 * @param DeltaTime - how long the last frame was
	 */
	function UpdateRotation(float DeltaTime)
	{
		local Rotator	DeltaRot, NewRotation, ViewRotation;
		local Vehicle_Siegebeast_Base Siegebeast;

		Siegebeast = Vehicle_Siegebeast_Base(Pawn);
		if (Siegebeast == None)
		{
			return;
		}

		// Turn the siegebeast based on player input
		NewRotation.Yaw = Siegebeast.Rotation.Yaw + PlayerInput.aTurn;
		Siegebeast.FaceRotation(NewRotation, DeltaTime);

		ViewRotation = Rotation;
		DeltaRot.Pitch = PlayerInput.aLookUp;
		ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);

		// Take the siegebeast rotation and make it our camera rot
		ViewRotation.Yaw = Siegebeast.Rotation.Yaw;

		// adjust for focus points
		GearPlayerCamera(PlayerCamera).GameplayCam.AdjustFocusPointInterpolation(DeltaRot);

		SetRotation(ViewRotation);

		ViewShake(DeltaTime);
	}
}

state PlayerDrivingSubmarineTurret extends PlayerDriving
{
	/** Allow Submarine to scale view rotation speed */
	function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
	{
		local Vehicle_Submarine_Base Submarine;
		local float RateScale;

		Submarine = Vehicle_Submarine_Base(Pawn.Base);
		if( Submarine != None && !bLookingAtPointOfInterest)
		{
			RateScale = bIsTargeting ? Submarine.AimingTurretTurnRateScale : Submarine.TurretTurnRateScale;

			// Scale player turning input
			DeltaRot *= RateScale;
		}

		Super.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
	}
}

state PlayerBrumakDriver extends PlayerWalking
{
	exec function PrevWeapon();
	exec function NextWeapon();
	function bool CanPickupWeapons();
	function TransitionFromRoadieRunToCover( CovPosInfo FoundCovInfo, optional bool bNoCameraAutoAlign );
	function bool CanRunToCover(out CovPosInfo CoverCanRunTo, out int NoCameraAutoAlign, optional bool bSkipSpecialMoveCheck, optional float CheckScale, optional EDoubleClickDir DblClickDirToCheck=DCLICK_None, optional bool bPreventSideEntry);

	// Brumak is never walking
	function HandleWalking()
	{
		MyGearPawn.SetWalking( FALSE );
	}

	function AcquireCover(CovPosInfo CovInfo, optional bool bNoCameraAutoAlign)
	{
		`log( self@GetFuncName()@MyGearPawn@"NO GETTING INTO COVER ON BRUMAK" );
		ScriptTrace();
	}

	function BeginState(Name PreviousStateName)
	{
		super.BeginState( PreviousStateName );

		MyGearPawn.MyGearWeapon = GearWeapon(MyGearPawn.Weapon);
	}

	function UpdateRotation( float DeltaTime )
	{
		local Rotator	DeltaRot, NewRotation, ViewRotation;
		local GearPawn_LocustBrumakBase Brumak;

		Brumak = GearPawn_LocustBrumakBase(Pawn);
		if( Brumak == None )
			return;

		ViewRotation	= Rotation;

		// Calculate Delta to be applied on ViewRotation
		DeltaRot.Yaw	= PlayerInput.aTurn;
		DeltaRot.Pitch	= PlayerInput.aLookUp;

		DeltaRot += ExtraRot;
		ExtraRot = rot(0,0,0);

		// Check that Adhesion target is still valid
		VerifyAdhesionTargets();

		// Apply adhesion
		ApplyAdhesion(DeltaTime, DeltaRot.Yaw, DeltaRot.Pitch);

		ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
		GearPlayerCamera(PlayerCamera).GameplayCam.AdjustFocusPointInterpolation(DeltaRot);			// adjust for focus points

		SetRotation( ViewRotation );

		ViewShake( DeltaTime );

		NewRotation = ViewRotation;
		NewRotation.Roll = 0;
		if( Pawn != None )
		{
			Pawn.FaceRotation( NewRotation, DeltaTime );
		}
	}

	function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
	{
		local GearPawn_LocustBrumakBase Brumak;

		super.ProcessViewRotation( DeltaTime, out_ViewRotation, DeltaRot );

		Brumak = GearPawn_LocustBrumakBase(Pawn);
		if( Brumak.IsDoingSpecialMove(GSM_Brumak_CannonFire) )
		{
			ClampRotation( out_ViewRotation, Brumak.Rotation, rot(14563,8190,-1), rot(14563,8190,-1) );
		}
	}

	function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
	{
		local Rotator		CamRot;
		local Vector		HitLocation, HitNormal, EndTrace, StartTrace, CamLoc;
		local Actor			HitActor;
		local ImpactInfo	Impact;

		GetPlayerViewPoint( CamLoc, CamRot );
		StartTrace	= CamLoc;
		EndTrace	= CamLoc + vector(CamRot)*10000;
		CalcWeaponFire( StartTrace, EndTrace, HitLocation, HitNormal, HitActor, Impact );

		return rotator(HitLocation-StartFireLoc);
	}

	unreliable server function ServerPlayBrumakRoar()
	{
		local GearPawn_LocustBrumakBase Brumak;
		Brumak = GearPawn_LocustBrumakBase(Pawn);
		Brumak.UpdateRoarCount();
	}
}

unreliable server function ServerVerifyBrumak();
unreliable client function ClientSetBrumak(GearPawn_LocustBrumakBase Brumak);

state PlayerBrumakGunner
{
	exec function PrevWeapon();
	exec function NextWeapon();
	function bool CanPickupWeapons();

	function BeginState(Name PreviousStateName)
	{
		// Stop AI from targeting or damaging the gunner... brumak is the target
		bGodMode = TRUE;
		MyGearPawn.bIgnoreBaseRotation	= TRUE;
//		MyGearPawn.bNeverAValidEnemy	= TRUE;

		MyGearPawn.MyGearWeapon = GearWeapon(MyGearPawn.Weapon);
		SetViewTarget( Pawn.Base );
	}

	function EndState( Name NextStateName )
	{
		bGodMode = FALSE;
		MyGearPawn.bIgnoreBaseRotation	= FALSE;
//		MyGearPawn.bNeverAValidEnemy	= FALSE;
	}

	function PlayerMove( float DeltaTime )
	{
		// Update rotation.
		UpdateRotation( DeltaTime );

		if (Role < ROLE_Authority)
		{
			ServerUpdateRotation(((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
		}
	}

	//@HACK: workaround for issue where client's losing Pawn.Base and exploding
	unreliable server function ServerVerifyBrumak()
	{
		if (Pawn != None && GearPawn_LocustBrumakBase(Pawn.Base) != None)
		{
			ClientSetBrumak(GearPawn_LocustBrumakBase(Pawn.Base));
		}
	}
	unreliable client function ClientSetBrumak(GearPawn_LocustBrumakBase Brumak)
	{
		if (Pawn != None && Brumak != None)
		{
			Pawn.SetBase(Brumak);
		}
	}

	function UpdateRotation( float DeltaTime )
	{
		local Rotator	DeltaRot, ViewRotation;
		local GearPawn_LocustBrumakBase Brumak;

		Brumak = GearPawn_LocustBrumakBase(Pawn.Base);
		if( Brumak == None )
		{
			if (Role < ROLE_Authority)
			{
				ServerVerifyBrumak();
			}
			return;
		}

		ViewRotation	= Rotation;

		// Calculate Delta to be applied on ViewRotation
		DeltaRot.Yaw	= PlayerInput.aTurn;
		DeltaRot.Pitch	= PlayerInput.aLookUp;

		// Check that Adhesion target is still valid
		VerifyAdhesionTargets();

		// Apply adhesion
		ApplyAdhesion(DeltaTime, DeltaRot.Yaw, DeltaRot.Pitch);

		ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
		SetRotation( ViewRotation );

		ViewShake( DeltaTime );
	}

	function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
	{
		local GearPawn_LocustBrumakBase Brumak;

		super.ProcessViewRotation( DeltaTime, out_ViewRotation, DeltaRot );

		Brumak = GearPawn_LocustBrumakBase(Pawn.Base);
		ClampRotation( out_ViewRotation, Brumak.Rotation, rot(12000,14563,-1), rot(14563,14563,-1) );
	}

	function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
	{
		local Rotator		CamRot;
		local Vector		HitLocation, HitNormal, EndTrace, StartTrace, CamLoc;
		local Actor			HitActor;
		local ImpactInfo	Impact;

		GetPlayerViewPoint( CamLoc, CamRot );
		StartTrace	= CamLoc;
		EndTrace	= CamLoc + vector(CamRot)*10000;
		CalcWeaponFire( StartTrace, EndTrace, HitLocation, HitNormal, HitActor, Impact );

		return rotator(HitLocation-StartFireLoc);
	}
}

function OnDriveBrumak( SeqAct_DriveBrumak inAction )
{
	// Mount
	if( inAction.InputLinks[0].bHasImpulse )
	{
		DriveRidablePawn( GearPawn_LocustBrumakBase(inAction.BrumakPawn), (inAction.Driver == self || inAction.Driver == Pawn) );
	}
	else
	// Dismount
	if( inAction.InputLinks[1].bHasImpulse )
	{
		DismountRidablePawn( GearPawn_LocustBrumakBase(inAction.BrumakPawn), ((inAction.BrumakPawn == Pawn) ? inAction.DismountDest[0] : inAction.DismountDest[1]) );
	}

}

/** Prepare and mount to a ridable pawn */
function DriveRidablePawn(GearPawnRidable_Base RidablePawn, bool bTakeDriverSeat)
{
	local GearPawn OldPawn;

	if (RidablePawn == None)
	{
		return;
	}
	OldPawn = MyGearPawn;
	if (OldPawn == None)
	{
		return;
	}

	//`DLog("RidablePawn:" @ RidablePawn @ "bTakeDriverSeat:" @ bTakeDriverSeat);

	if (bTakeDriverSeat)
	{
		if (RidablePawn.Driver == None || !RidablePawn.IsHumanControlled())
		{
			RidablePawn.SetDriver(OldPawn, self);
		}
	}
	// TODO: Determine if we are going to support gunner seat for Gears3 before fixing this
	// Take gunner seat
// 	else if ((Brumak.LeftGunPawn  == None || !Brumak.LeftGunPawn.IsHumanControlled()) &&
// 			 (Brumak.RightGunPawn == None || !Brumak.RightGunPawn.IsHumanControlled()))
// 	{
// 		Brumak.SetGunner( OldPawn, 0 );
// 		EnterStartState();
// 	}
	else
	{
		`warn( "Failed to drive RidablePawn - already occupied by human" );
	}
}

/** Dismount from a ridable pawn and fixup our normal pawn */
function DismountRidablePawn(GearPawnRidable_Base RidablePawn, Actor Dest)
{
	local Pawn OldPawn;

	if (RidablePawn == None || Dest == None)
	{
		return;
	}

	`DLog("RidablePawn:" @ RidablePawn @ "Dest:" @ Dest @ "Pawn:" @ Pawn @ "MyGearPawn:" @ MyGearPawn);

	if (Pawn == RidablePawn)
	{
		OldPawn = RidablePawn.Driver;
	}
	else if (RidablePawn != none && Pawn == RidablePawn.Driver)
	{
		OldPawn = Pawn;
	}
	// TODO: Determine if we are supporting the gunner and fix this
// 	else if( Brumak.HumanGunner == Pawn )
// 	{
// 		OldPawn = Brumak.HumanGunner;
// 		Brumak.SetGunner( None, 0 );
// 		SetViewTarget(OldPawn);
// 		EnterStartState();
// 		ClientGotoState(GetStateName());
// 	}

	if (OldPawn != none)
	{
		RidablePawn.SetDriver(None, self);
		OldPawn.SetLocation(Dest.Location);
		OldPawn.DropToGround();
		OldPawn.SetCollision(TRUE, TRUE, FALSE);
		OldPawn.bCollideWorld = TRUE;
		OldPawn.SetPhysics(PHYS_Falling);
	}
}

/** used to replicate rotation to the server in places where we only care about rotation input */
unreliable server function ServerUpdateRotation(int View)
{
	local rotator ViewRot;

	ViewRot.Pitch = (View & 65535);
	ViewRot.Yaw = (View >> 16);
	SetRotation(ViewRot);
}

function EnterStartState()
{
	local GearPawn_LocustBrumakBase Brumak;
	local GearVehicleBase GVB;
	local name NewState;

	if (MyGearPawn != None && MyGearPawn.IsDBNO())
	{
		NewState = 'Reviving';
	}
	else if (Pawn.PhysicsVolume.bWaterVolume)
	{
		if (Pawn.HeadVolume.bWaterVolume)
		{
			Pawn.BreathTime = Pawn.UnderWaterTime;
		}
		NewState = Pawn.WaterMovementState;
	}
	else
	{
		// default to land movement
		NewState = Pawn.LandMovementState;

		Brumak = GearPawn_LocustBrumakBase(Pawn.Base);
		if (Brumak != None)
		{
			NewState = Brumak.GunnerState;
		}
		else if (Pawn.Base != None)
		{
			GVB = GearVehicleBase(Pawn.Base);
			if (GVB != None)
			{
				NewState = GVB.GetRiderState(Pawn);
			}

		}
	}
	if (GetStateName() == NewState)
	{
		BeginState(NewState);
	}
	else
	{
		GotoState(NewState);
	}

}

/** Handles the ObjectiveManager kismet action by forwarding the action to the objective manager on the client */
simulated function OnManageObjectives( SeqAct_ManageObjectives Action )
{
	if ( ObjectiveMgr != None )
	{
		ObjectiveMgr.OnManageObjectives( Action );
	}
}

/** Replicate the updated objective to the client */
reliable client final function ClientReplicateObjective(ObjectiveInfo UpdatedInfo, int ObjIdx)
{
	if (ObjectiveMgr != None)
	{
		ObjectiveMgr.Objectives[ObjIdx] = UpdatedInfo;
		ObjectiveMgr.Objectives[ObjIdx].UpdatedTime = WorldInfo.TimeSeconds;
		//If locators were sent but there are none, then rerequest that they be sent.
		if (UpdatedInfo.bLocatorWasSent && UpdatedInfo.Locators[0] == None)
		{
			ServerReReplicateObjective(ObjIdx);
		}
		//Otherwise it's all good.
		else
		{
			ObjectiveMgr.CreateLocatorsForObjective(ObjectiveMgr.Objectives[ObjIdx]);
		}
	}
}

/** A request from the client to send the objective data again, since a locator was missing */
reliable server final function ServerReReplicateObjective(int ObjIdx)
{
	if (ObjectiveMgr != None)
	{
		ClientReplicateObjective(ObjectiveMgr.Objectives[ObjIdx],ObjIdx);
	}
}

/** clears the objective list on the client */
reliable client final function ClientClearObjectives()
{
	if (ObjectiveMgr != None)
	{
		ObjectiveMgr.Objectives.length = 0;
	}
}

/** removes an objective from the client */
reliable client final function ClientRemoveObjective(name ObjName)
{
	local int Idx;

	Idx = ObjectiveMgr.Objectives.Find('ObjectiveName', ObjName);
	if (Idx != INDEX_NONE)
	{
		ObjectiveMgr.Objectives.Remove(Idx, 1);
	}
}

/** Have the HUD show a kismet message */
function OnDrawMessage(SeqAct_DrawMessage Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		ClientDrawKismetMessage( Action.MessageText, Action.DisplayTimeSeconds );
	}
	else
	{
		ClientClearKismetMessage();
	}
}

/** Start drawing a kismet message on the HUD */
reliable client final function ClientDrawKismetMessage( string MessageText, float DisplayTime )
{
	MyGearHud.KismetMessageText = MessageText;
	if ( DisplayTime > 0 )
	{
		MyGearHud.KismetMessageEndTime = WorldInfo.TimeSeconds + DisplayTime;
	}
	else
	{
		MyGearHud.KismetMessageEndTime = -1;
	}
}

/** Stop drawing a kismet message on the HUD */
reliable client final function ClientClearKismetMessage()
{
	MyGearHud.KismetMessageText = "";
	MyGearHud.KismetMessageEndTime = -1;
}

/**
 * Handles the call from kismet to the tutorial system.
 */
final function OnManageTutorials( SeqAct_ManageTutorials Action )
{
	local EManageTutorialInputs TutInput;

	if (TutorialMgr != None)
	{
		// Figure out which input was hit
		if (Action.InputLinks[eMTINPUT_AddTutorial].bHasImpulse)
		{
			TutInput = eMTINPUT_AddTutorial;
		}
		else if (Action.InputLinks[eMTINPUT_RemoveTutorial].bHasImpulse)
		{
			TutInput = eMTINPUT_RemoveTutorial;
		}
		else if (Action.InputLinks[eMTINPUT_StartTutorial].bHasImpulse)
		{
			TutInput = eMTINPUT_StartTutorial;
		}
		else if (Action.InputLinks[eMTINPUT_StopTutorial].bHasImpulse)
		{
			TutInput = eMTINPUT_StopTutorial;
		}
		else if (Action.InputLinks[eMTINPUT_CompleteTutorial].bHasImpulse)
		{
			TutInput = eMTINPUT_CompleteTutorial;
		}
		else if (Action.InputLinks[eMTINPUT_SystemOn].bHasImpulse)
		{
			TutInput = eMTINPUT_SystemOn;
		}
		else if (Action.InputLinks[eMTINPUT_SystemOff].bHasImpulse)
		{
			TutInput = eMTINPUT_SystemOff;
		}
		else if (Action.InputLinks[eMTINPUT_AutosOn].bHasImpulse)
		{
			TutInput = eMTINPUT_AutosOn;
		}
		else if (Action.InputLinks[eMTINPUT_AutosOff].bHasImpulse)
		{
			TutInput = eMTINPUT_AutosOff;
		}
		else if (Action.InputLinks[eMTINPUT_AttemptFailure].bHasImpulse)
		{
			TutInput = eMTINPUT_AttemptFailure;
		}

		HandleTutorials(Action, TutInput);
	}
}

/** Performs the action for triggering events in the tutorial system */
final function HandleTutorials( SeqAct_ManageTutorials Action, optional EManageTutorialInputs ForcedInput=eMTINPUT_MAX )
{
	local GearPC PC;

	// Loop through all players and process the tutorial action
	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.ClientManageTutorialsFromKismet(Action, ForcedInput);
	}
}

/** Handles the tutorial system functionality that was triggered by kismet on the server */
reliable client function ClientManageTutorialsFromKismet(SeqAct_ManageTutorials Action, EManageTutorialInputs TutInput)
{
	local bool bIsHostPlayer;

	bIsHostPlayer = (WorldInfo.NetMode < NM_Client) && IsPrimaryPlayer();

	if (TutorialMgr != None)
	{
		switch (TutInput)
		{
			// Add Tutorial
			case eMTINPUT_AddTutorial:
				Action.InputLinks[eMTINPUT_AddTutorial].bHasImpulse = false;
				// If the tutorial is already complete we will fire the "Already Complete" output and not add it
				if (TutorialMgr.IsTutorialCompleted(Action.Tutorial_Type))
				{
					Action.OutputLinks[eMTOUTPUT_AlreadyComplete].bHasImpulse = true;
					Action.bTutorialAlreadyCompleted = true;
					Action.bActionIsDone = true;
				}
				// Not complete yet so add the tutorial and start it if it should be started
				else
				{
					if (TutorialMgr.AddTutorial(Action.Tutorial_Type, bIsHostPlayer ? Action : None, true))
					{
						Action.OutputLinks[eMTOUTPUT_Added].bHasImpulse = true;
					}

					// Start the tutorial if the action says to
					if (Action.bStartTutorialWhenAdded)
					{
						TutorialMgr.StartTutorial(Action.Tutorial_Type);
					}
				}
				break;
			// Remove Tutorial
			case eMTINPUT_RemoveTutorial:
				Action.InputLinks[eMTINPUT_RemoveTutorial].bHasImpulse = false;
				if (TutorialMgr.RemoveTutorial(Action.Tutorial_Type))
				{
					Action.OutputLinks[eMTOUTPUT_Removed].bHasImpulse = true;
				}
				break;
			// Start Tutorial
			case eMTINPUT_StartTutorial:
				Action.InputLinks[eMTINPUT_StartTutorial].bHasImpulse = false;
				if (TutorialMgr.StartTutorial(Action.Tutorial_Type))
				{
					Action.OutputLinks[eMTOUTPUT_Started].bHasImpulse = true;
				}
				break;
			// Stop Tutorial
			case eMTINPUT_StopTutorial:
				Action.InputLinks[eMTINPUT_StopTutorial].bHasImpulse = false;
				if (TutorialMgr.StopTutorial(Action.Tutorial_Type))
				{
					Action.OutputLinks[eMTOUTPUT_Stopped].bHasImpulse = true;
				}
				break;
			// Complete Tutorial
			case eMTINPUT_CompleteTutorial:
				Action.InputLinks[eMTINPUT_CompleteTutorial].bHasImpulse = false;
				TutorialMgr.OnTutorialCompletedFromKismet(Action.Tutorial_Type, false);
				break;
			// System On
			case eMTINPUT_SystemOn:
				bTutorialSystemWasOn = true;
				RestartTutorialSystem(bTutorialSystemWasOn, Action.bWipeTutorialsOnSystemOn);
				TutorialMgr.AddAutoInitiatedTutorials();
				Action.OutputLinks[eMTOUTPUT_SystemOn].bHasImpulse = true;
				Action.bActionIsDone = true;
				break;
			// System Off
			case eMTINPUT_SystemOff:
				bTutorialSystemWasOn = false;
				StopTutorialSystem(Action.bWipeTutorialsOnSystemOff);
				Action.OutputLinks[eMTOUTPUT_SystemOff].bHasImpulse = true;
				Action.bActionIsDone = true;
				break;
			// Autos On
			case eMTINPUT_AutosOn:
				TutorialMgr.UnsuspendAutoTutorials();
				Action.OutputLinks[eMTOUTPUT_AutosOn].bHasImpulse = true;
				Action.bActionIsDone = true;
				break;
			// Autos Off
			case eMTINPUT_AutosOff:
				TutorialMgr.SuspendAutoTutorials();
				Action.OutputLinks[eMTOUTPUT_AutosOff].bHasImpulse = true;
				Action.bActionIsDone = true;
				break;
			// A failure was made when attempting the tutorial (does not complete, let's LD handle a failure w/o stopping the tutorial)
			case eMTINPUT_AttemptFailure:
				Action.OutputLinks[eMTOUTPUT_AttemptFailure].bHasImpulse = true;
				break;
		}
	}
}

/** The actual server RPC from TellServerTutorialCompletedFromClient in the tutorial manager */
reliable server function ServerClientHasCompletedTutorial(EGearTutorialType TutType)
{
	local GearPC PC;
	// Find the host and complete his tutorial
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC.IsPrimaryPlayer())
		{
			if (PC.TutorialMgr != None)
			{
				PC.TutorialMgr.OnTutorialCompletedFromKismet(TutType, false);
			}
			break;
		}
	}
}

/** Called by the host player when he has completed a tutorial so that the client can complete theirs on his behalf */
final function TellClientTutorialCompletedFromServer(EGearTutorialType TutType)
{
	local GearPC PC;

	// Find the client and complete his tutorial
	foreach WorldInfo.AllControllers( class'GearPC', PC )
	{
		if (!PC.IsPrimaryPlayer() ||
			LocalPlayer(PC.Player) == None)
		{
			PC.ClientServerHasCompletedTutorial(TutType);
		}
	}
}

/** The actual client RPC from TellServerTutorialCompletedFromClient in the tutorial manager */
reliable client function ClientServerHasCompletedTutorial(EGearTutorialType TutType)
{
	TutorialMgr.OnTutorialCompletedFromKismet(TutType, true);
}

/** Delegate fired when the player triggers an event in the GearEventDelegates array */
delegate OnGearEvent();

/**
 * Adds the delegate to the list to be notified when the player triggers an event
 *	@param GearEventType - the event type you want to add a delegate to
 *	@param GearEventDelegate - the delegate to add to the event
 */
final function AddGearEventDelegate( EGearEventDelegateType GearEventType, delegate<OnGearEvent> GearEventDelegate )
{
	// Set the size of the event list if we are outside the bounds of the array
	if ( GearEventList.length <= GearEventType )
	{
		GearEventList.length = eGED_NumTypes;
	}

	// Only add to the list once
	if ( GearEventList[GearEventType].GearEventDelegates.Find(GearEventDelegate) == INDEX_NONE )
	{
		GearEventList[GearEventType].GearEventDelegates.AddItem(GearEventDelegate);
	}
}

/**
* Removes the delegate from the list to be notified when the player triggers an event
*	@param GearEventType - the event type you want to add a delegate to
*	@param GearEventDelegate - the delegate to add to the event
*/
final function ClearGearEventDelegate( EGearEventDelegateType GearEventType, delegate<OnGearEvent> GearEventDelegate )
{
	// Set the size of the event list if we are outside the bounds of the array
	if ( GearEventList.length <= GearEventType )
	{
		GearEventList.length = eGED_NumTypes;
	}

	GearEventList[GearEventType].GearEventDelegates.RemoveItem( GearEventDelegate );
}

/**
 * Calls all of the delegates associated with an event
 *	@param GearEventType - the event type you want to trigger the delegates for
 */
final function TriggerGearEventDelegates( EGearEventDelegateType GearEventType )
{
	local int DelegateIdx;
	local delegate<OnGearEvent> OnEventDelegate;

	// Set the size of the event list if we are outside the bounds of the array
	if ( GearEventList.length <= GearEventType )
	{
		GearEventList.length = eGED_NumTypes;
	}

	for ( DelegateIdx = 0; DelegateIdx < GearEventList[GearEventType].GearEventDelegates.length; DelegateIdx++ )
	{
		OnEventDelegate = GearEventList[GearEventType].GearEventDelegates[DelegateIdx];
		OnEventDelegate();
	}
}

/** Delegate fired when the player picks up a weapon */
delegate OnGearWeaponEquip( class<GearWeapon> WeaponClass );

/**
 * Adds the delegate to the list to be notified when the player equips a weapon
 *	@param GearWeapEquipDelegate - the delegate to add
 */
final function AddGearWeaponEquipDelegate( delegate<OnGearWeaponEquip> GearWeapEquipDelegate )
{
	// Only add to the list once
	if ( GearWeaponEquipDelegates.Find(GearWeapEquipDelegate) == INDEX_NONE )
	{
		GearWeaponEquipDelegates.AddItem(GearWeapEquipDelegate);
	}
}

/**
 * Removes the delegate from the list to be notified when the player equips a weapon
 *	@param GearWeapEquipDelegate - the delegate to add to the event
 */
final function ClearGearWeaponEquipDelegate( delegate<OnGearWeaponEquip> GearWeapEquipDelegate )
{
	GearWeaponEquipDelegates.RemoveItem( GearWeapEquipDelegate );
}

/**
 * Calls all of the weapon equipped delegates
 */
final function TriggerGearWeaponEquipDelegates( class<GearWeapon> WeaponClass )
{
	local int DelegateIdx;
	local delegate<OnGearWeaponEquip> OnWeaponEquipDelegate;

	for ( DelegateIdx = 0; DelegateIdx < GearWeaponEquipDelegates.length; DelegateIdx++ )
	{
		OnWeaponEquipDelegate = GearWeaponEquipDelegates[DelegateIdx];
		OnWeaponEquipDelegate( WeaponClass );
	}
}

/**
 * Stub for a function implemented in GearPC_MP
 *
 * @param bActive - whether to turn on the overhead map
 */
simulated exec function SetOverheadMapActive(bool bActive);

/** closes all menus that are up */
reliable client function ClientCloseAllMenus()
{
	// @todo - ALL OLD UI SYSTEM. DELETE?
	/*
	local GearUIManager UIManager;
	local UIScene SceneToClose;

	// closing child scenes stops when it hits a scene that has a higher priority, so iterate backwards through the scene stack
	// closing each one individually.
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	foreach UIManager.AllActiveScenes(class'UIScene', SceneToClose, true, INDEX_NONE, UIManager.SCENEFILTER_ReceivesFocus)
	{
		// skip over any 'reconnect controller' scenes
		if ( SceneToClose.SceneTag != 'ReconnectController' )
		{
			UIManager.CloseScene(SceneToClose, false, true);
		}
	}
*/
}

/** Function called when the path choice action is initiated */
function OnDisplayPathChoice( SeqAct_DisplayPathChoice Action )
{
	local LocalPlayer LP;
	local GearPC PC;
	local int PlayerIndex;

	LP = LocalPlayer(Player);

	// only open the 'choose path' scene if we're the first player (relevant only in split-screen)
	if ( LP != None )
	{
		MainPlayerInput.ForceButtonRelease(bUseAlternateControls?GB_X:GB_A, true);
		DoubleClickDir = DCLICK_None;

		// Open the scene
		if ( MyGearHud != None && MyGearHud.PathChoicePlayerClass != None && Role == ROLE_Authority
		&&	(!IsSplitscreenPlayer(PlayerIndex) || PlayerIndex == 0) )
		{
			// Open the path selection screen locally
			MyGearHud.OpenPathChoiceScene(Action);

			// Tell clients to open the path selection screen
			foreach WorldInfo.AllControllers(class'GearPC', PC)
			{
				if( !PC.IsLocalPlayerController() )
				{
					PC.ClientDisplayPathChoice(Action);
				}
			}
		}
	}
}

/**
 * Called by the server to tell clients to display the path choice dialogue
 *
 * @param   Action  The action containing the path choice information
 */
reliable client function ClientDisplayPathChoice( SeqAct_DisplayPathChoice Action )
{
	if( (MyGearHud != None) && IsPrimaryPlayer() )
	{
		MyGearHud.OpenPathChoiceScene( Action );
	}
}

/**
 * Called to dispatch notification to clients that the host has selected a path choice
 *
 * @param  bSelectionWasLeft    TRUE if the host selected the left path, FALSE if they selected the right
 */
function HostSelectedPath( bool bSelectionWasLeft )
{
	local GearPC PC;

	// Tell remote clients which path was selected
	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		if( !PC.IsLocalPlayerController() )
		{
			PC.ClientReplicatePathChoice(bSelectionWasLeft);
		}
	}
}

/**
 * Called from the server to tell clients which path was selected, and close the menu
 *
 * @param   bSelectionWasLeft   TRUE if the left path option was selected, FALSE otherwise
 */
reliable client function ClientReplicatePathChoice( bool bSelectionWasLeft )
{
	if( MyGearHud != None )
	{
		MyGearHud.ClientActivatePathChoice(bSelectionWasLeft);
	}
}

/** Start showing the revival text */
final reliable client function ClientStartDrawingRevival( GearPawn PawnWhoRevivedMe )
{
	local string StringToDraw;

	if ( (PawnWhoRevivedMe != None) && (PawnWhoRevivedMe != MyGearPawn) && (MyGearHud != None) )
	{
		StringToDraw = RevivedString @ PawnWhoRevivedMe.PlayerReplicationInfo.PlayerName;
		StringToDraw = WorldInfo.GRI.Caps(StringToDraw);
		MyGearHud.StartDrawingSubtitleText( StringToDraw, 3.0f, 0.5f, 1.0f );
	}
}

simulated function StopWeatherEffects(EWeatherType WeatherType)
{
	if (WeatherEmitter != None)
	{
		WeatherEmitter.FadeOutRain();
		WeatherEmitter = None;
	}
}

simulated function StartWeatherEffects(EWeatherTYpe WeatherType)
{
	switch (WeatherType)
	{
	case WeatherType_Rain:
		WeatherEmitter = Spawn(class'Emit_Rain');
		break;
	case WeatherType_Clear:
		// nothing to do!
		break;
	}

	if (WeatherEmitter != None)
	{
		WeatherEmitter.SetBasedOnPlayer(self);
	}
}

simulated function SetWeatherEmitterHeight(float Height)
{
	if (WeatherEmitter != None)
	{
		WeatherEmitter.SetHeight(Height);
	}
}



// simulated function float DetermineWhichDecalToUse( out MaterialInstance out_MI_Decal )
// {
// 	local float Retval;
//
// 	local Vector Loc;
// 	local Rotator Rot;
// 	local float DirOfHit_L;
//
// 	local vector	AxisX, AxisY, AxisZ;
//
// 	local vector ShotDirection;
//
// 	local bool bIsInFront;
// 	local vector2D	AngularDist;
// 	local Pawn P;
// 	//local GearHud_Base WH;
//
// 	local float Multiplier;
// 	local float PositionInQuadrant;
// 	local float QuadrantStart;
//
// 	P = Pawn;
// 	P.GetAxes(P.Rotation, AxisX, AxisY, AxisZ);
//
// 	ShotDirection = -1.f * Normal( P.Location - LocationOfLastBloodTrail );
//
//
// 	bIsInFront = GetAngularDistance( AngularDist, ShotDirection, AxisX, AxisY, AxisZ );
// 	GetAngularDegreesFromRadians( AngularDist );
//
// 	Multiplier = 0.26f / 90.f;
//
// 	PositionInQuadrant = Abs(AngularDist.X) * Multiplier;
//
//
// //	Retval = ((abs(Pawn.Rotation.Yaw)%65535.0f)/65535.0f)*360.0f;
//
// 	if( Rotator(Pawn.Location - LocationOfLastBloodTrail).Yaw >= 0 )
// 	{
// 		Retval = abs((Rotator(Pawn.Location - LocationOfLastBloodTrail).Yaw)/65535.0f) * -360.0f;
// 	}
// 	else
// 	{
// 		Retval = abs((Rotator(Pawn.Location - LocationOfLastBloodTrail).Yaw)/65535.0f) * 360.0f;
// 	}
//
// 	//Retval = ((Rotator(Pawn.Location - LocationOfLastBloodTrail).Yaw)/65535.0f) * 360.0f;
//
// 	`log( "Rotation: " $ Pawn.Rotation.Yaw @ Retval );
//
// 	if( LocationOfLastBloodTrail == Vect(0,0,0) )
// 	{
// 		// leave a bloood pool
// 		`log( "leave a blood pool" );
// 		out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
// 	}
// 	else //if( PositionInQuadrant < 0.13 )
// 	{
// 		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_3' );
// 		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_6' );
// 		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
// 		//		out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_8' );  // awesome for crawling
//
// // 		if( FRand() > 0.40f )
// // 		{
// // 			out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_5' );
// // 		}
// // 		else
// // 		{
// // 			out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
// // 		}
//
//
//
// 		if( FRand() > 0.40f )
// 		{
// 			out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Decals.BloodSplatter02' );
// 		}
// 		else
// 		{
// 			out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_5' );
// 		}
// 	}
//
// 	if( FALSE ) //else
// 	{
//
// 		`log( "bIsInFront: " $ bIsInFront @ "AngularDist: " $ AngularDist.X @ "LocationOfLastBloodTrail" @ LocationOfLastBloodTrail @ "PositionInQuadrant" @ PositionInQuadrant );
//
//
// 		// 0 - .25  UpperRight
// 		// .25 - .50 LowerRight
// 		// .50 - .75 LowerLeft
// 		// .75 - 1 UpperLeft
// 		if( bIsInFront == TRUE )
// 		{
// 			if( AngularDist.X > 0 )
// 			{
// 				QuadrantStart = 0;
// 				DirOfHit_L = QuadrantStart + PositionInQuadrant;
// 				`log( "Lower Left" );
// 				out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_CurveLeft_3' );
// 			}
// 			else
// 			{
// 				QuadrantStart = 0;
// 				DirOfHit_L = QuadrantStart - PositionInQuadrant;
// 				`log( "Lower Right" );
// 				out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_CurveRight_3' );
// 			}
// 		}
// 		else
// 		{
// 			if( AngularDist.X > 0 )
// 			{
// 				QuadrantStart = 0.52;
// 				DirOfHit_L = QuadrantStart - PositionInQuadrant;
// 				`log( "Upper Left" );
// 				out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_CurveRight_3' );
// 			}
// 			else
// 			{
// 				QuadrantStart = 0.52;
// 				DirOfHit_L = QuadrantStart + PositionInQuadrant;
// 				`log( "Upper Right" );
// 				out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_CurveLeft_3' );
//
// 			}
// 		}
// 	}
//
// 	return Retval;
// }

state ScreenshotMode extends Spectating
{
	function BeginState(Name PreviousStateName)
	{
		LastPawn = MyGearPawn;
		Super.BeginState(PreviousStateName);
		SetPhysics(PHYS_Flying);
	}

	function PlayerMove(float DeltaTime)
	{
		if (!IsButtonActive(GB_LeftTrigger))
		{
			Super.PlayerMove(DeltaTime);
		}
	}

	function UpdateRotation(float DeltaTime )
	{
		Super(GearPC).UpdateRotation(DeltaTime);
	}

	function EndState(Name NextStateName)
	{
		SetPhysics(PHYS_None);
		Super.EndState(NextStateName);
		Possess(LastPawn,FALSE);
	}
};

exec function Stuck()
{
	`log("Player stuck:"@GetStateName()@MyGearPawn@MyGearPawn.GetStateName()@MyGearPawn.SpecialMove@IsMoveInputIgnored()@IsLookInputIgnored()@MyGearPawn.CurrentLink@MyGearPawn.CoverType@MyGearPawn.CoverAction);
	ClientBreakFromCover();
	DoSpecialMove(SM_None,TRUE);
	MyGearPawn.SetMovementPhysics();
}

/**
 * Returns the party map name for this game
 */
static function string GetPartyMapName()
{
	return "GearStart";
}

/**
 * Returns the party game info name for this game
 */
static function string GetPartyGameTypeName()
{
	return "GearGameContent.GearPartyGame";
}

/**
 * Get the completion amount for a game achievement.
 *
 * @param	AchievementId	the id for the achievement to get the completion percetage for
 * @param	CurrentValue	the current number of times the event required to unlock the achievement has occurred.
 * @param	MaxValue		the value that represents 100% completion.
 *
 * @return	TRUE if the AchievementId specified represents an progressive achievement.  FALSE if the achievement is a one-time event
 *			or if the AchievementId specified is invalid.
 */
event bool GetAchievementProgression( int AchievementId, out float CurrentValue, out float MaxValue )
{
	local bool bResult;

	if ( ProfileSettings != None )
	{
		bResult = ProfileSettings.GetAchievementProgression(self, EGearAchievement(AchievementId), CurrentValue, MaxValue);
	}

	return bResult;
}

/** called when seamless travelling and the specified PC is being replaced by this one
 * copy over data that should persist
 * (not called if PlayerControllerClass is the same for the from and to gametypes)
 */
function SeamlessTravelFrom(PlayerController OldPC)
{
	local GearTeamInfo MyTeamInfo;
	local int Idx;

	Super.SeamlessTravelFrom(OldPC);

	if (!PlayerReplicationInfo.bOnlySpectator)
	{
		MyTeamInfo = GearTeamInfo(PlayerReplicationInfo.Team);
		Idx = MyTeamInfo.TeamMembers.Find( OldPC );
		if ( Idx != INDEX_NONE )
		{
			MyTeamInfo.TeamMembers[Idx] = self;
		}
    }

	// Ensure the profile settings are initially set
	bProfileSettingsUpdated = TRUE;

	RefreshAllSafeZoneViewports();
}

/** Loop through all controllers and refresh their safe zone values */
function RefreshAllSafeZoneViewports()
{
	local GearPC PC;

	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC.MyGearHud != none)
		{
			PC.MyGearHud.bRefreshSafeZone = true;
		}
	}
}

/** Scripting hook for kismet driven achievement unlocking */
function OnGearAchievementUnlock(SeqAct_GearAchievementUnlock inAction)
{
	local EGearAchievement AchievementToUnlock;

	if ( inAction.InputLinks[0].bHasImpulse && inAction.Achievement != eGLACHIEVE_None )
	{
		AchievementToUnlock = inAction.AchievementMap[inAction.Achievement];
		ClientUnlockAchievement( AchievementToUnlock );
	}
}

/** Scripting hook for kismet driven unlockable unlocking */
function OnGearUnlockableUnlock(SeqAct_GearUnlockableUnlock inAction)
{
}

/** Client RPC to unlock an achievement - first adds an "achievement complete" delegate then unlocks it */
reliable client function ClientUnlockAchievement(EGearAchievement Achievement)
{
	local LocalPlayer LocPlayer;
	local bool bHasCompletedAchievement;

	`log("Unlocked the " $ Achievement $ " achievement!");
	bHasCompletedAchievement = ProfileSettings != None ? ProfileSettings.HasCompletedAchievement(Achievement) : false;
	if ( !bHasCompletedAchievement )
	{
		if ( OnlineSub != None )
		{
			// if the extended interface is supported
			if ( OnlineSub.PlayerInterfaceEx != None )
			{
				LocPlayer = LocalPlayer(Player);
				if ( !OnlineSub.PlayerInterface.UnlockAchievement(LocPlayer.ControllerId, Achievement) )
				{
					`log("UnlockAchievement("$LocPlayer.ControllerId$","$Achievement$") failed");
				}
			}
			else
			{
				`Log("Interface is not supported. Can't unlock an achievement");
			}
		}
		else
		{
			`Log("No online subsystem. Can't unlock an achievement");
		}

		if ( ProfileSettings != None )
		{
			ProfileSettings.MarkAchievementAsCompleted(Achievement, Self);
		}
	}
	else
	{
		`log("Previously unlocked, skipping...");
	}
}

/** Called by GSM_TargetMinigun so we know when the minigun is mounted and unmounted */
simulated function MinigunCoverMountedStateChanged( bool bMounted )
{
	bIsMountedWithMinigun = bMounted;
}

/**
 * Sets the player's skill with the value the host has and saves the profile so it persists
 *
 * @param PlayerSkill the new skill to store for the player
 */
reliable client function ClientSetPlayerSkill(int PlayerSkill)
{
	if (ProfileSettings != None)
	{
		ProfileSettings.SetProfileSettingValueInt(`PlayerSkill,PlayerSkill);
	}
}

/**
 * Sends the player's persistent skill to the host to be replicated to everyone
 *
 * @param PlayerSkill the new skill to replicate to everyone
 */
reliable server function ServerSetPlayerSkill(int PlayerSkill)
{
	local GearGameMP_Base MPGame;
	local UniqueNetId ZeroId;

	GearPRI(PlayerReplicationInfo).PlayerSkill = PlayerSkill;

	// Update skill on the player match beacon as well
	MPGame = GearGameMP_Base(WorldInfo.Game);
	if (MPGame != None &&
		MPGame.HostPlayerMatchBeacon != None &&
		PlayerReplicationInfo.UniqueId != ZeroId)
	{
		MPGame.HostPlayerMatchBeacon.UpdatePlayerReservationSkills(
			PlayerReplicationInfo.UniqueId,
			GearPRI(PlayerReplicationInfo).PlayerSkill,
			GearPRI(PlayerReplicationInfo).PlayerLevel
			);
	}
}

/**
 * Tells the client that the server needs the player's persistent skill information
 */
reliable client function ClientGetPlayerSkill()
{
	local int PlayerSkill;

	if (ProfileSettings != None)
	{
		ProfileSettings.GetProfileSettingValueInt(`PlayerSkill,PlayerSkill);
		ServerSetPlayerSkill(PlayerSkill);
	}
	else
	{
		// No profile means no skill
		ServerSetPlayerSkill(0);
	}
}

/**
 * Sends the player's persistent level to the host to be replicated to everyone
 *
 * @param PlayerLevel the new level to replicate to everyone
 */
reliable server function ServerSetPlayerLevel(int PlayerLevel)
{
	local GearGameMP_Base MPGame;
	local UniqueNetId ZeroId;
	local GearPRI PRI;

	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		PRI.PlayerLevel = PlayerLevel;

		// Update skill on the player match beacon as well
		MPGame = GearGameMP_Base(WorldInfo.Game);
		if (MPGame != None &&
			MPGame.HostPlayerMatchBeacon != None &&
			PlayerReplicationInfo.UniqueId != ZeroId)
		{
			MPGame.HostPlayerMatchBeacon.UpdatePlayerReservationSkills(
				PlayerReplicationInfo.UniqueId,
				PRI.PlayerSkill,
				PRI.PlayerLevel);
		}
	}
	else
	{
		SetTimer(0.5,false,nameof(DelayedGetPlayerSkill));
	}
}

/** Timer function to retry the skill information gathering */
function DelayedGetPlayerSkill()
{
	ClientGetPlayerSkill();
}

/**
 * Tells the client that the server needs the player's persistent level information
 */
reliable client function ClientGetPlayerLevel()
{
	local int Level;

	if (PersistentData != None)
	{
		Level = PersistentData.GetValue(`Level);
		//If you have a level, it must be at least 1
		Level = Max(Level,1);
		ServerSetPlayerLevel(Level);
	}
	else
	{
		// No persistent data means no level
		ServerSetPlayerLevel(0);
	}
}

/**
 * Whether the player has the required DLCs needed for this playlist or not
 *
 * @param PlaylistId playlist to use when fetching content ids
 */
function bool PlayerHasPlaylistDLC(int PlaylistId)
{
	local int DLCIdx;
	local OnlinePlaylistManager PlaylistMan;
	local array<int> ContentIds;
	local int PlayerDLCFlags;
	local bool bResult;

	bResult = true;
	if (OnlineSub != None)
	{
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != None)
		{
			// Get the content ids required for this playlist
			PlaylistMan.GetContentIdsFromPlaylist(PlaylistId, ContentIds);
			// If the content id list is empty then this playlist only uses shipped maps,
			// so we only need to do the content check if this list is > 0 in length
			if (ContentIds.length > 0)
			{
				// Supported DLC for the player
				PlayerDLCFlags = GetPlayerAvailableDLCFlag();
				// Loop through all the content ids and break out and return false if one fails
				for (DLCIdx = 0; DLCIdx < ContentIds.length; DLCIdx++)
				{
					if (ContentIds[DLCIdx] != 0 &&
						((PlayerDLCFlags & (1 << ContentIds[DLCIdx])) == 0))
					{
						bResult = false;
						break;
					}
				}
			}
		}
	}
	return bResult;
}

/**
 * Determine the available DLC for the player and return the combined flags
 *
 * @return DLCFLags supported by the player represented as a bitmask
 */
function int GetPlayerAvailableDLCFlag()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> MapProviders;
	local GearGameMapSummary MapData;
	local int ProvIdx, DLCFlagResult;

	// First build the DLCFlag for this machine
	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	if ( GameResourceDS != None )
	{
		if ( GameResourceDS.GetResourceProviders('Maps', MapProviders) )
		{
			for ( ProvIdx = 0; ProvIdx < MapProviders.length; ProvIdx++ )
			{
				MapData = GearGameMapSummary(MapProviders[ProvIdx]);
				if ( MapData != None && MapData.DLCId > 0 )
				{
					DLCFlagResult = DLCFlagResult | (1 << MapData.DLCId);
				}
			}
		}
	}
	return DLCFlagResult;
}

/** Sends a server RPC for each local player so that the players can communicate what DLC that have */
function UpdateLocalPlayersDLCValues()
{
	local GearPC PC;
	local int DLCFlagResult;

	// Get the player's supported DLC bits
	DLCFlagResult = GetPlayerAvailableDLCFlag();

	// Set the DLCFlag on all local controller PRIs via server RPC if the value is different
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		// Splitscreen players may not have their PRI yet
		if ((PC.PlayerReplicationInfo != None) && (DLCFlagResult != GearPRI(PC.PlayerReplicationInfo).DLCFlag))
		{
			PC.ServerSetDLCFlag(DLCFlagResult);
		}
	}
}

/** Sets the DLC flag value of the player on the PRI on the server */
reliable server function ServerSetDLCFlag( int DLCFlag )
{
	GearPRI(PlayerReplicationInfo).DLCFlag = DLCFlag;
}

/**
 * Turns a special action icon on and off
 */
function OnToggleButtonMash( SeqAct_ToggleButtonMash inAction )
{
	// Start
	if( inAction.InputLinks[0].bHasImpulse )
	{
		ClientToggleKismetIcon( true, inAction.IconToDisplay, inAction.AnimationSpeed );
	}
	// Stop
	else
	{
		ClientToggleKismetIcon( false, inAction.IconToDisplay, inAction.AnimationSpeed );
	}
}

/** Client function that turns a special action icon on induced by kismet */
reliable client function ClientToggleKismetIcon( bool bTurnOn, eGearKismetIconType IconType, float AnimationSpeed )
{
	if ( bTurnOn )
	{
		// Wipe any old icons
		ActionKismetButton.ActionIconDatas.length = 0;
		ActionKismetButton.IconAnimationSpeed = 0;

		// Make a new icon data
		ActionKismetButton.ActionIconDatas.length = 1;
		switch ( IconType )
		{
		case eGEARBUTTON_A:
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 1;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_A];
			break;
		case eGEARBUTTON_A_MASH:
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 2;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_A];
			ActionKismetButton.ActionIconDatas[0].ActionIcons[1] = GearIcons[eGEARICON_A_PRESSED];
			ActionKismetButton.IconAnimationSpeed = AnimationSpeed;
			break;
		case eGEARBUTTON_B:
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 1;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_B];
			break;
		case eGEARBUTTON_B_MASH:
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 2;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_B];
			ActionKismetButton.ActionIconDatas[0].ActionIcons[1] = GearIcons[eGEARICON_B_PRESSED];
			ActionKismetButton.IconAnimationSpeed = AnimationSpeed;
			break;
		case eGEARBUTTON_X:
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 1;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_X];
			break;
		case eGEARBUTTON_Y:
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 1;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_Y];
			break;
		case eGEARBUTTON_ChainsawMash:
			ActionKismetButton.ActionIconDatas.length = 2;
			ActionKismetButton.ActionIconDatas[0].ActionIcons.length = 2;
			ActionKismetButton.ActionIconDatas[0].ActionIcons[0] = GearIcons[eGEARICON_B];
			ActionKismetButton.ActionIconDatas[0].ActionIcons[1] = GearIcons[eGEARICON_B_PRESSED];
			if (GearWeap_AssaultRifle(MyGearPawn.Weapon) != None)
			{
				ActionKismetButton.ActionIconDatas[1].ActionIcons.length = 2;
				ActionKismetButton.ActionIconDatas[1].ActionIcons[0] = GearIcons[eGEARICON_Chainsaw];
				ActionKismetButton.ActionIconDatas[1].ActionIcons[1] = GearIcons[eGEARICON_Chainsaw_PRESSED];
			}
			else
			{
				ActionKismetButton.ActionIconDatas.length = 1;
			}
			ActionKismetButton.IconAnimationSpeed = AnimationSpeed;
			break;
		}

		MyGearHUD.SetActionInfo( AT_KismetButton, ActionKismetButton );
	}
	else
	{
		MyGearHUD.ClearActionInfoByType( AT_KismetButton );
	}
}

/**
 * This is a function which is called when sentinel is able to start TravelTheWorld.  This allows the specific game
 * to do things such as turning off UI/HUD and to not enter some default starting the game state.
 **/
function Sentinel_SetupForGamebasedTravelTheWorld()
{
	MyGearHud.bShowHUD = FALSE;
	GearGame(WorldInfo.Game).bAllowTutorials = FALSE;
	StopTutorialSystem( TRUE );
	MyGearHud.ToggleScoreboard( FALSE );
	GearHUDMP_Base(MyGearHud).CloseScoreboardScene(TRUE);
	// need to do this here to escape the clutches of spectator cameras
	GotoState( 'BaseSpectating' );
	SetViewTarget( self );
}

/**
 * This function is called before we acquire the travel points.
 **/
function Sentinel_PreAcquireTravelTheWorldPoints()
{
	Kill( "all" ); // kills off AI's spawned on level loaded and visible
}

/**
 * This function is called after we acquire the travel points right before we start traveling.
 **/
function Sentinel_PostAcquireTravelTheWorldPoints()
{
	Kill( "all" ); // kills off AI's spawned on level loaded and visible
	// need to do this here to escape the clutches of spectator cameras
	GotoState( 'BaseSpectating' );
	SetViewTarget( self );
}

// client cheat commands for debugging
exec function Cheat(string Cmd)
{
	ServerCheat(Cmd);
}

reliable server final function ServerCheat(string Cmd)
{
	ClientMessage(ConsoleCommand(Cmd));
}

/** Set the viral settings for earning the achievement */
reliable server function ServerSetViralSettings(bool bIsEpicDev, bool bHasViralAchievement);

/**
 * Called when the join for the travel destination has completed
 *
 * @param SessionName the name of the session the event is for
 * @param bWasSuccessful whether it worked or not
 */
function OnJoinTravelToSessionComplete(name SessionName,bool bWasSuccessful)
{
	if (bWasSuccessful)
	{
		bIgnoreNetworkMessages = true;
	}

	Super.OnJoinTravelToSessionComplete(SessionName,bWasSuccessful);
}

reliable client function ClientTravelToSession(name SessionName,class<OnlineGameSearch> SearchClass,byte PlatformSpecificInfo[80])
{
	bIgnoreNetworkMessages = true;
	Super.ClientTravelToSession(SessionName,SearchClass,PlatformSpecificInfo);
}

/**
 * loads/unloads GUD banks and updates ClientGUDSReferences to keep a reference to them
 * Client only, should not be called on server, even if that server is also a client
 */
reliable client native event ClientLoadGUDBank(name BankName);
reliable client native event ClientUnloadGUDBank(name BankName);

reliable client event ClientClearGUDSReferences()
{
	local int GUDRefIdx, GUDRefCount;
	local string GUDPackageName;

	// Remove all GUDS references (and unmount FaceFX data)
	GUDRefCount = ClientGUDSReferences.length;
	for (GUDRefIdx=0; GUDRefIdx < GUDRefCount; GUDRefIdx++)
	{
		// Always get the first one because UnloadGUDBank removes from the array
		GUDPackageName = string(ClientGUDSReferences[0].PackageName);
		ReplaceText(GUDPackageName, "_SF", "");
		ClientUnloadGUDBank(name(GUDPackageName));
	}

	ClientGUDSReferences.length = 0;
}

/**
 * Common method for setting the rich presence string
 *
 * @param StringId the rich presence string to set
 */
simulated function SetRichPresenceString(int StringId)
{
	local LocalPlayer LP;
	local array<LocalizedStringSetting> StringSettings;
	local array<SettingsProperty> Properties;

	LP = LocalPlayer(Player);
	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId,StringId,StringSettings,Properties);
	}
}

/**
 * Common method for the host to use to set the rich presence string
 *
 * @param StringId the rich presence string to set
 */
reliable client function ClientSetRichPresenceString(int StringId)
{
	SetRichPresenceString(StringId);
}

/**
 * Common method for the host to use to set the rich presence string including map and game mode
 *
 * @param StringId the rich presence string to set
 * @param MpType the mp context that we use
 * @param MapNameId the map name id to set
 */
reliable client function ClientSetVersusRichPresenceString(byte StringId,byte MpType,byte MapNameId)
{
	local LocalPlayer LP;
	local array<LocalizedStringSetting> StringSettings;
	local array<SettingsProperty> Properties;

	LP = LocalPlayer(Player);
	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		StringSettings.Length = 2;
		// Set the map name for rich presence
		StringSettings[0].AdvertisementType = ODAT_OnlineService;
		StringSettings[0].Id = class'GearGame'.const.CONTEXT_MAPNAME;
		StringSettings[0].ValueIndex = MapNameId;
		// Add the game mode
		StringSettings[1].AdvertisementType = ODAT_OnlineService;
		StringSettings[1].Id = class'GearGame'.const.CONTEXT_VERSUSMODES;
		StringSettings[1].ValueIndex = int(MpType);

		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId,StringId,StringSettings,Properties);
	}
}

/** forces the client to keep Marcus/Dom's textures in memory for the duration of the game because we are playing SP */
reliable client function ClientForceStreamSPTextures()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		class'GearPawn_COGMarcus'.default.Mesh.PrestreamTextures(float(MaxInt / 2), false);
		class'GearPawn_COGDom'.default.Mesh.PrestreamTextures(float(MaxInt / 2), false);
	}
}

/** forces the client to preload textures for the specified pawn class */
reliable client function ClientPrestreamTexturesFor(class<Pawn> PawnClass)
{
	if (PawnClass != None && WorldInfo.NetMode != NM_DedicatedServer)
	{
		PawnClass.default.Mesh.PrestreamTextures(5.0, false);
	}
}

/**
 * Sets the invite flags for the party so that clients can match what the host has set
 *
 * @param bAllowInvites whether invites are allowed or not
 * @param bAllowJoinViaPresence whether join via presence is allowed or not
 * @param bAllowJoinViaPresenceFriendsOnly whether friends only join via presence is allowed or not
 */
reliable client function ClientSetPartyInviteFlags(bool bAllowInvites,bool bAllowJoinViaPresence,bool bAllowJoinViaPresenceFriendsOnly)
{
	local OnlineGameSettings PartySettings;

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		IsPrimaryPlayer())
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
		//@todo sz - handle bPartyHostLost better by migrating party session/beacon instead
		if (PartySettings != None && !bPartyHostLost &&
			(PartySettings.bAllowInvites != bAllowInvites ||
			 PartySettings.bAllowJoinViaPresence != bAllowJoinViaPresence ||
			 PartySettings.bAllowJoinViaPresenceFriendsOnly != bAllowJoinViaPresenceFriendsOnly))
		{
			PartySettings.bAllowInvites = bAllowInvites;
			PartySettings.bAllowJoinViaPresence = bAllowJoinViaPresence;
			PartySettings.bAllowJoinViaPresenceFriendsOnly = bAllowJoinViaPresenceFriendsOnly;
			// Now update the Live state
			OnlineSub.GameInterface.UpdateOnlineGame('Party',PartySettings,true);
		}
	}
}

/** reloads config files for the specified gametype on the client */
reliable client final function ClientLoadGameTypeConfigs(string GameTypeExtension)
{
	class'GearEngine'.static.LoadGameTypeConfigs(GameTypeExtension);
}

/**
 * Notify client that their party host has exited.
 * This forces invites to be off for the duration of the match and map cycling
 * and forces the client back to the main menu on exit.
 */
reliable client function ClientLogoutPartyHost(UniqueNetId PartyHostNetId)
{
	if (OnlineSub != None &&
		PlayerReplicationInfo != None &&
		// ignore if the client is the party host
		PlayerReplicationInfo.UniqueId != PartyHostNetId &&
		IsPrimaryPlayer())
	{
		`LogOnline("Player lost his party host. Disabling invites!: "
			$" PartyHostNetId="$OnlineSub.static.UniqueNetIdToString(PartyHostNetId)
			$" UniqueId="$OnlineSub.static.UniqueNetIdToString(PlayerReplicationInfo.UniqueId));

		// disable any future party invite updates since this client lost his party host
		ClientSetPartyInviteFlags(false,false,false);
		bPartyHostLost = true;
	}
}

/**
 * Update the persistent party on logout.
 */
reliable client function ClientLogoutPersistentParty()
{
	local GearPersistentPartyBeaconHost HostPersistentPartyBeacon;

	if (OnlineSub != None &&
		IsLocalPlayerController() &&
		IsPrimaryPlayer())
	{
		HostPersistentPartyBeacon = GearPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
		if (HostPersistentPartyBeacon != None)
		{
			`LogBeacon("stopping HostPersistentPartyBeacon session updates UniqueId="
				$class'OnlineSubsystem'.static.UniqueNetIdToString(PlayerReplicationInfo.UniqueId));

			// reset elapsed session times and stop updating them
			// to allow for the party host to travel and for his clients to catch up without timing out
			HostPersistentPartyBeacon.bUpdateElapsedSessionTimes = false;
		}
	}
}

/**
 * Update the persistent party on login.
 * This only occurs on the party host
 */
reliable client function ClientLoginPersistentParty()
{
	local GearPersistentPartyBeaconHost HostPersistentPartyBeacon;

	if (OnlineSub != None &&
		IsLocalPlayerController() &&
		IsPrimaryPlayer())
	{
		HostPersistentPartyBeacon = GearPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
		if (HostPersistentPartyBeacon != None)
		{
			`LogBeacon("restarting HostPersistentPartyBeacon session updates ");

			// once party host has logged back in then turn updates back on
			// in order to detect clients that never connected or dropped
			// and need to be logged out of the beacon
			HostPersistentPartyBeacon.ResetElapsedSessionUpdateTimes();
			HostPersistentPartyBeacon.bUpdateElapsedSessionTimes = true;
		}
	}
}

simulated function OnOverrideRedReticleTraceDistance(SeqAct_OverrideRedReticleTraceDistance Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		DistanceForEnemyTrace = Action.TraceDistance;
	}
	else
	{
		DistanceForEnemyTrace = default.DistanceForEnemyTrace;
	}
}

/** Needed to pass a start IE_Released event to the UI **/
native function Sentinel_PressStartKeyAtStartMenu();

/** This will make a bugit with the current language.  So we can then copy them to the PC without them over writing each other **/
native function Sentinel_DoBugitWithLang();

simulated function OnToggleTargetingDOF(SeqAct_ToggleTargetingDOF Action)
{
	bDisableCameraTargetingDOF = Action.InputLinks[1].bHasImpulse;
}


/** Only spawn one MP friend of each type **/
protected simulated function AutomationSpawnAnMPFriend( const string MPPawnClassName, const string SpawnCommand )
{
	local GearPawn_COGGear GP;
	local bool bNotAliveYet;

	bNotAliveYet = TRUE;

	foreach WorldInfo.AllPawns( class'GearPawn_COGGear', GP )
	{
		if( string(GP.Class) == MPPawnClassName )
		{
			bNotAliveYet = FALSE;
			break;
		}
	}

	if( bNotAliveYet == TRUE )
	{
		ConsoleCommand( "spawnpawn " @ SpawnCommand );
	}

	foreach WorldInfo.AllPawns( class'GearPawn_COGGear', GP )
	{
		GP.bUnlimitedHealth = TRUE;
	}

}

exec simulated function Automation_KillMobs( optional float TimeBetweenKills )
{
	if( TimeBetweenKills == 0.0f )
	{
		TimeBetweenKills = 20.0f;
	}

	 GearPawn(Pawn).bUnlimitedHealth = TRUE;

	 // every round try to spawn our friends
	 AutomationSpawnAnMPFriend( "GearPawn_COGDizzyMP", "DizzyMP" );
	 AutomationSpawnAnMPFriend( "GearPawn_COGDomMP", "DomMP" );
	 AutomationSpawnAnMPFriend( "GearPawn_COGGusMP", "GusMP" );
	 AutomationSpawnAnMPFriend( "GearPawn_COGTaiMP", "TaiMP" );


	 SetTimer( TimeBetweenKills, TRUE, nameof( Automation_KillAMob) );

	 ConsoleCommand( "FractureAllMeshesToMaximizeMemoryUsage" );
}


/** Function to wrap all of the memory checking / tracking that we do **/
exec simulated function Automation_MemoryChecking()
{
	local int WarmUpEvents;
	local int EveryNEvents;
	local int DumpAllocsEvent;


	Automation_NumMemoryEvents++;

	if( WorldInfo.Game.IsCheckingForMemLeaks() )
	{
		ConsoleCommand( "memleakcheck" );
	}

	// these will just "pass" through if we are not running the MallocProfiler
	if( WorldInfo.Game.IsCheckingForMemLeaks() )
	{
		// here we need to check for which game type we are playing and adjust the snapshotting accordingly

		// horde
		if( GearGameHorde_Base(WorldInfo.Game) != None )
		{
			WarmUpEvents = 2;
			EveryNEvents = 10;
			DumpAllocsEvent = 49;
		}
		// annex
		else if( GearGameRing_Base(WorldInfo.Game) != None )
		{
			WarmUpEvents = 2;
			EveryNEvents = 5;
			DumpAllocsEvent = 20;
		}
		// other MP
		else
		{
			WarmUpEvents = 1;
			EveryNEvents = 1;
			DumpAllocsEvent = 5;
		}


		// allow for Events to "warmup some"
		if( Automation_NumMemoryEvents == WarmUpEvents )
		{
			ConsoleCommand( "SNAPSHOTMEMORY" );
		}

		// every 10 Events snap shot
		if( (Automation_NumMemoryEvents % EveryNEvents) == 0 )
		{
			ConsoleCommand( "SNAPSHOTMEMORY" );
		}

		// last Event dump out
		if( Automation_NumMemoryEvents == DumpAllocsEvent )
		{
			ConsoleCommand( "DUMPALLOCSTOFILE" );
			ClearTimer( nameof( Automation_KillAMob) );  // so we don't go back to main menu and have mem issues/defrag issues and will allow the mem profiler data to copy
		}
	}

	if( WorldInfo.Game.IsCheckingForFragmentation() )
	{
		ConsoleCommand( "MemFragCheck" );
	}
}


exec simulated function Automation_KillAMob()
{
	local GearPawn GP;

	// look at all pawns and see if we should kill it!
	foreach WorldInfo.AllPawns( class'GearPawn', GP )
	{
		// don't kill yourself
		// nor ragdolled pawns
		// nor your COGGear friends
		if( !GP.IsHumanControlled() && !GP.bTearOff && GearPawn_COGGear(GP) == none )
		{
			GP.TakeDamage( 10000.0f, self, GP.Location, vect(0,0,1), class'GDT_Explosive' );
			break;
		}
	}
}

function RestoreShowSubtitles()
{
	SetShowSubtitles( ProfileSettings.GetSubtitleConfigOption() );
}

exec reliable client event ClientFlushGUDSVarietyBanks()
{
	// disable guds during cinematics
	if (GearGame(WorldInfo.Game).UnscriptedDialogueManager != None)
	{
		GearGame(WorldInfo.Game).UnscriptedDialogueManager.FlushOutAllVarietyBanks();
	}
}

/**
 * Tells the client to play a waveform for the specified damage type
 *
 * @param FFWaveform The forcefeedback waveform to play
 * @param FFWaveformInstigator the actor causing the waveform to play
 */
reliable client event ClientPlayForceFeedbackWaveform(ForceFeedbackWaveform FFWaveform,optional Actor FFWaveformInstigator)
{
	local string MovieName;

	GetCurrentMovie(MovieName);
	if (MovieName == "" || MovieName != class'GameTypes'.const.LOADING_MOVIE)
	{
		Super.ClientPlayForceFeedbackWaveform(FFWaveform,FFWaveformInstigator);
	}
}

/** Create this client's Award Manager */
function CreateStatAndAwardManager()
{
	ClientCreateStatAndAwardManager();
}

/** Clientside of CreateAwardManager */
reliable client function ClientCreateStatAndAwardManager()
{
	if (StatManager == None)
	{
		StatManager = new class'GearStatManager';
		StatManager.InitializeManager(self);
	}
	StatManager.ClearManager();
	if (AwardManager == None)
	{
		AwardManager = new class'GearAwardManager';
		AwardManager.InitializeManager(self, StatManager);
	}
}

/** Modifies a stat in the stat manager
 *	@param Stat The stat to be recorded
 *	@param Amount The amount the stat has changed
 *	@param ModType The type of modification (delta-change the stat by the Amount, set-set the stat to the amount, etc)
 *
 *  @return Returns true if the stat was successfully modified
 */
function bool ModifyStat(name Stat, optional int Amount=1, optional EStatModificationType ModType=GEARSTATMODTYPE_Delta)
{
	if (StatManager != None)
	{
		return StatManager.ModifyStat(Stat,Amount, ModType);
	}
	return false;
}

/** Clears out all stat data in the stat manager */
function ClearStatManager()
{
	if (StatManager != None)
	{
		StatManager.ClearManager(true);
	}
}

/** Notifies the client that a recording period has started, and wipes out the stats for that period
 *	@param RecordingPeriod The period that just started
 */
reliable client function ClientPeriodStarted(ERecordingPeriodType RecordingPeriod)
{
	if (StatManager != None)
	{
		StatManager.PeriodStarted(RecordingPeriod);
	}
}

/** Resets the match history for this client */
reliable client function ClientResetMatchHistory()
{
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);

	if (GRI != None)
	{
		GRI.ResetMatchHistory();
	}
}

/** Server function called by a client who has just earned an award
 *	Server then notifies all other clients about it so that they can show it in the  UI
 *
 *	@param AwardName - The name of the award. Should be consistent across all players
 *	@param ExpBonus - The amount of Exp this player has gained by earning this award
 *	@param AwardId - The persistent ID of the award (used for stats tracking)
 */
reliable server function ServerPlayerEarnedAward(name AwardName, optional int ExpBonus, optional int AwardID)
{
	local GearPawn_Infantry GPI;
	local GearPRI GPRI;

	GPRI = GearPRI(PlayerReplicationInfo);
	if (GPRI != None)
	{
		GPRI.ExpBuckets[eEXP_Awards] += ExpBonus;
	}

	GPI = GearPawn_Infantry(Pawn);
	if (GPI != None)
	{
		//This will replicate down
		GPI.AwardEarned = AwardName;
		//If there actually is an award, prepare to remove the award at some point in the future
		if (AwardName != '')
		{
			SetTimer(CoopAwardDisplayTime, FALSE, nameof(RemoveEarnedAward));
		}
	}

	if (AwardName != '' && AwardID >= 0)
	{
		// @STATS - Award Given
		`RecordPlayerIntStat(AWARD_GIVEN, self, AwardID);
	}
}

/**
 * Called by the server to authoritatively tell the client that he has earned an award
 * added as a catchall for MCP stats recording
 * @param AwardName - The name of the award. Should be consistent across all players
 */
function NotifyEarnedAward(name AwardName)
{
	ClientNotifyAwardEarned(AwardName);
}

/**
 * Client function called by the server to authoritatively tell the client that he has earned an award
 *  @param AwardName - The name of the award. Should be consistent across all players
 */
reliable client function ClientNotifyAwardEarned(name AwardName)
{
	if (AwardManager != None)
	{
		AwardManager.AwardEarned(AwardManager.GetAwardByName(AwardName));
	}
}

/**
 * Client function called by the server to authoritatively tell the client that he should update a stat value
 * @param Stat - The name of the stat to modify. Should be consistent across all players
 * @Amount - amount to modify it by
 * @ModType - operation to apply to the stat
 */
reliable client function ClientModifyStat(name Stat, optional int Amount=1, optional EStatModificationType ModType=GEARSTATMODTYPE_Delta)
{
	ModifyStat(Stat, Amount, ModType);
}

/** Function called to remove the notification of an earned award from the UI */
function RemoveEarnedAward()
{
	ServerPlayerEarnedAward('');
}

/**
 * Used for the game to update a player's XP. Shows progression toasts
 * and level toasts as needed
 *
 * @param ExpBuckets - The exp that the client has earned over the past match divided up into categories
 */
reliable client function ClientUpdateXP(int ExpBuckets[EExperienceBuckets])
{
	local int CurrentLevel, XPStart, XPEnd, XPDelta, CurrentXP, NewXP;
	local int Index;
	local int QuitXPPenalty;
	local GearPRI PRI;

	PRI = GearPRI(PlayerReplicationInfo);

	for (Index = 0; Index < ArrayCount(ExpBuckets); Index++)
	{
		// apply to PRI locally for UI use
		PRI.ExpBuckets[Index] = ExpBuckets[Index];
		// count total XP gained or lost
		XPDelta += ExpBuckets[Index];
	}

	// Get ranges needed for advancing
	CurrentLevel = StatManager.DetermineLevel(StatManager.GetStatValueByName('XP'),XPStart, XPEnd);

	// Don't let suicides demote you
	XPDelta = Max(XPDelta, 0);

	// Get their penalty amount
	QuitXPPenalty = ProfileSettings.GetQuitPenalty();
	ProfileSettings.ClearQuitCount();

	// Put this in the PRI so it can be displayed (and the XP delta)
	PRI.ExpBuckets[eEXP_QuitPenalty] = -QuitXPPenalty;
	XPDelta	+= PRI.ExpBuckets[eEXP_QuitPenalty];

	// Total their delta with their current and their quit penalty
	CurrentXP = StatManager.GetStatValueByName('XP');
	NewXP = CurrentXP + XPDelta;

	// Apply the change
	StatManager.ModifyStat('XP', XPDelta, GEARSTATMODTYPE_Delta);

	// Figure out if we changed level or not
	if (NewXP > XPEnd || NewXP < XPStart)
	{
		// Level changed, so we need to recalc things
		StatManager.UpdateLevelFromXP();
		CurrentLevel = StatManager.DetermineLevel(StatManager.GetStatValueByName('XP'), XPStart, XPEnd);
		ServerSetPlayerLevel(CurrentLevel);
	}
}

/**
 * Whether the Guardian Angel score is past the threshold
 *
 * @return true if GuardianAngelScore is past the threshold for the given difficulty
 */
event bool IsGuardianAngelActive()
{
	return GearPRI(PlayerReplicationInfo).Difficulty.default.GuardianAngelThreshold > 0 && GuardianAngelScore >= GearPRI(PlayerReplicationInfo).Difficulty.default.GuardianAngelThreshold;
}

/** Reset the GA score and all assists */
function GuardianAngelReset()
{
	`log("GA:" @ Pawn @ "score reset");

	GuardianAngelScore = 0;
	GearPRI(PlayerReplicationInfo).Difficulty.static.ResetGuardianAngel(Self);
}

/** Add to the GA score and turn on assists if it is time */
function GuardianAngelWasKilled()
{
	if (WorldInfo.GRI.IsMultiPlayerGame())
		return;

	if (!IsGuardianAngelActive())
	{
		GuardianAngelScore += GuardianAngelKilledBonus;

		`log("GA:" @ Pawn @ "killed. Added" @ GuardianAngelKilledBonus @ "points. Total:" @ GuardianAngelScore @ "/" @ GearPRI(PlayerReplicationInfo).Difficulty.default.GuardianAngelThreshold);

		if (IsGuardianAngelActive())
		{
			GearPRI(PlayerReplicationInfo).Difficulty.static.EnableGuardianAngel(Self);
		}
	}
}

/** Add to the GA score and turn on assists if it is time */
function GuardianAngelWasDowned()
{
	if (WorldInfo.GRI.IsMultiPlayerGame())
		return;

	if (!IsGuardianAngelActive())
	{
		GuardianAngelScore += GuardianAngelDownedBonus;

		`log("GA:" @ Pawn @ "downed. Added" @ GuardianAngelDownedBonus @ "points. Total:" @ GuardianAngelScore @ "/" @ GearPRI(PlayerReplicationInfo).Difficulty.default.GuardianAngelThreshold);

		if (IsGuardianAngelActive())
		{
			GearPRI(PlayerReplicationInfo).Difficulty.static.EnableGuardianAngel(Self);
		}
	}
}

/**
 * Used to mark a player as having committed a standby cheat
 *
 * @param NumDemerits the amount to increment by
 */
reliable client function ClientIncrementStandbyDemerits(int NumDemerits)
{
	if (ProfileSettings != None)
	{
		ProfileSettings.AdjustStandByDemeritsCount(NumDemerits);
		// Commit the changes
		SaveProfile();
	}
}

/** Debug function to quickly toggle all skel meshes with alternate weights */
exec native function ToggleSkelMeshWeights();

/** Debug function to quickly toggle cinematic mode weights on and off */
exec function ToggleCineModeWeights()
{
	local GearPawn_COGGear COGPawn;
	local int LODIdx;
	foreach WorldInfo.AllPawns(class'GearPawn_COGGear', COGPawn)
	{
		for (LODIdx=0; LODIdx<COGPawn.Mesh.LODInfo.length;LODIdx++)
		{
			if (COGPawn.Mesh.LODInfo[LODIdx].InstanceWeightUsage == IWU_FullSwap)
			{
				COGPawn.Mesh.ToggleInstanceVertexWeights(!COGPawn.Mesh.LODInfo[LODIdx].bAlwaysUseInstanceWeights,LODIdx);
			}
		}
	}
}

/** Toggle animation debugging - moved from cheat manager to here so that we can debug each client*/
exec function DebugAnimation()
{
 `if(`notdefined(FINAL_RELEASE))
	FlushPersistentDebugLines();

	// Toggle
	bDebugAnimation = !bDebugAnimation;
	// and hook/unhook our debug draw
	MyGearHud.SetDebugDraw(DebugDraw_Animation, bDebugAnimation);
`endif

}

function DebugDraw_Animation(GearHUD_Base H)
{
	//DebugDraw_Animation_Worker(H, TRUE);
	DebugDraw_Animation_Worker(H, FALSE);
}

function DrawDebugText(GearHUD_Base H, bool bShadowPass, coerce String Text)
{
	local float XL, YL;

	if( H.Canvas.CurY >= H.Canvas.SizeY * 0.95f )
	{
		H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
		DebugTextMaxLen = 0.f;

		if( bShadowPass )
		{
			H.Canvas.SetPos(H.Canvas.CurX, H.Canvas.CurY + 1.f);
		}
	}

	H.Canvas.StrLen(Text, XL, YL);
	if( XL > DebugTextMaxLen )
	{
		DebugTextMaxLen = XL;
	}

	H.Canvas.DrawText(Text);
}

/**
 * Do the heavy lifting for DebugAnimations screen output
 *
 * @param H - the HUD to write text on
 *
 * @param bShadowPass - whether this is the shadow pass
 */
function DebugDraw_Animation_Worker(GearHUD_Base H, bool bShadowPass)
{
	local Canvas							Canvas;
	local GearPawn							DebugPawn;
	local AnimNode							Node;
	local GearAnim_BlendAnimsByDirection	BlendByDirNode;
	local GearAnim_UpperBodyIKHack			IKHackNode;
	local int								i;
	local FLOAT								XO, YO, XD, YD;
	local SkelControlBase					SkelControl;
	local String							Text;
	local AnimNodeSequence					SeqNode;
	local AnimTree.AnimGroup				AnimGroup;
	local AnimNodeBlendList					BlendListNode;
	local AnimNodeSlot                      SlotNode;
	local Name                              AnimName;
	local SkeletalMeshComponent             DebugMesh;
	local AnimTree                          DebugAnimTree;
	local AnimNodeAimOffset                 AimOffsetNode;

	Canvas = H.Canvas;
	if (PlayerCamera != None && PlayerCamera.ViewTarget.Target != None)
	{
		DebugPawn = GearPawn(PlayerCamera.ViewTarget.Target);
		if (DebugPawn == None && Controller(PlayerCamera.ViewTarget.Target) != None)
		{
			DebugPawn = GearPawn(Controller(PlayerCamera.ViewTarget.Target).Pawn);
		}

		if (DebugPawn == None)
		{
			// if debug pawn is none, check weapon or vehicle
			if (GearWeapon(PlayerCamera.ViewTarget.Target) != None)
			{
				DebugMesh = SkeletalMeshComponent(GearWeapon(PlayerCamera.ViewTarget.Target).Mesh);
			}
			else if (GearVehicle(PlayerCamera.ViewTarget.Target) != None)
			{
				DebugMesh = GearVehicle(PlayerCamera.ViewTarget.Target).Mesh;
			}
			else if (GearTurret(PlayerCamera.ViewTarget.Target) != None)
			{
				DebugMesh = GearTurret(PlayerCamera.ViewTarget.Target).Mesh;
			}
			else if (SkeletalMeshActor(PlayerCamera.ViewTarget.Target) != None)
			{
				DebugMesh = SkeletalMeshActor(PlayerCamera.ViewTarget.Target).SkeletalMeshComponent;
			}
		}
	}
	else
	{
		DebugPawn = MyGearPawn;
	}

	if( GearWeaponPawn(Pawn) != None )
	{
		DebugPawn = GearPawn(GearWeaponPawn(Pawn).Driver);
		DebugMesh = DebugPawn.Mesh;
	}

	if (DebugPawn != None)
	{
		DebugMesh = DebugPawn.Mesh;
		DebugAnimTree = DebugPawn.AnimTreeRootNode;
	}

	if (DebugMesh == None)
	{
		return;
	}

	if (DebugAnimTree == None)
	{
		DebugAnimTree = AnimTree(DebugMesh.Animations);
	}

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

	if (bShadowPass)
	{
		Canvas.SetPos(Canvas.CurX + 1.f, Canvas.CurY + 1.f);
		Canvas.SetDrawColor(0, 0, 0, 255);
	}

	DebugTextMaxLen = 0.f;

	DrawDebugText(H, bShadowPass, "* DebugPawn *");
	DrawDebugText(H, bShadowPass, DebugPawn );
	if( DebugPawn != None )
	{
		DrawDebugText(H, bShadowPass, "* Phys"@DebugPawn.Physics@"Vel"@DebugPawn.Velocity@"SM:"@DebugPawn.SpecialMove@"*" );
	}

	DrawDebugText(H, bShadowPass, "* AnimTree *");
	DrawDebugText(H, bShadowPass, DebugMesh.AnimTreeTemplate);

	DrawDebugText(H, bShadowPass, "RMM:"@DebugMesh.RootMotionMode@"RMRM:"@DebugMesh.RootMotionRotationMode);
	DrawDebugText(H, bShadowPass, "* RMVel"@DebugMesh.RootMotionVelocity@"RMAccelScale"@DebugMesh.RootMotionAccelScale@"*" );

	ForEach DebugMesh.AllAnimNodes(class'AnimNode', Node)
	{
		// Skip non relevant nodes
		if (Node.NodeTotalWeight < 0.00001f)
		{
			if (!bShadowPass)
			{
				Canvas.SetDrawColor(255, 0, 0, 255);
			}
			continue;
		}
		else if (!bShadowPass)
		{
			Canvas.SetDrawColor(0, 255, 0, 255);
		}

		SeqNode = AnimNodeSequence(Node);
		if (SeqNode != None)
		{
			// Display name in red and NONE if AnimSeq couldn't be found. So it's easier to spot problems.
			if (!bShadowPass)
			{
				if (SeqNode.AnimSeq != None)
				{
					Canvas.SetDrawColor(255, 0, 255, 255);
				}
				else
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
			}

			AnimName = SeqNode.AnimSeq != None ? SeqNode.AnimSeq.SequenceName : 'None';
			DrawDebugText(H, bShadowPass, Node.Class $ " (" $ AnimName $") W:" $ int(Node.NodeTotalWeight*100.f));
		}
		else
		{
			Text = ((Node.NodeName != '' && Node.NodeName != 'None') ? Node.Class $ " (" $ Node.NodeName $ ")" : String(Node.Class));

			BlendListNode = AnimNodeBlendList(Node);
			if (BlendListNode != None)
			{
				DrawDebugText(H, bShadowPass, Text @ "W:" $ int(Node.NodeTotalWeight*100.f) @ "C:" $ BlendListNode.ActiveChildIndex @ "W:" $ int(BlendListNode.Children[BlendListNode.ActiveChildIndex].Weight*100.f));
			}
			else
			{
				DrawDebugText(H, bShadowPass, Text @ "W:" $ int(Node.NodeTotalWeight*100.f));
			}
		}

		BlendByDirNode = GearAnim_BlendAnimsByDirection(Node);
		if (BlendByDirNode != None)
		{
			DrawDebugText(H, bShadowPass, "  DirAngle:" @ int(BlendByDirNode.DirAngle*100) @ BlendByDirNode.AnimSeqName);
			/*
			for(i=0; i<BlendByDirNode.Anims.Length; i++)
			{
				DrawDebugText(H, "    " @ i @ int(BlendByDirNode.Anims[i].Weight * 100) @ BlendByDirNode.Anims[i].AnimName);
			}
			*/

			if (!bShadowPass)
			{
				// Draw Direction on a circle.
				XO = Canvas.CurX + Canvas.SizeX * 0.1f;
				YO = Canvas.CurY - Canvas.SizeY * 0.1f;
				XD = XO - 32 * Sin(BlendByDirNode.DirAngle);
				YD = YO - 32 * Cos(BlendByDirNode.DirAngle);
				Canvas.Draw2DLine(XO, YO, XD, YD, MakeColor(255, 0, 0, 255));
			}
		}

		IKHackNode = GearAnim_UpperBodyIKHack(Node);
		if (IKHackNode != None)
		{
			DrawDebugText(H, bShadowPass, "  bNodeDisabled:" @ IKHackNode.bNodeDisabled);
		}

		SlotNode = AnimNodeSlot(Node);
		if (SlotNode != None)
		{
			Canvas.SetDrawColor(0, 255, 0, 255);

			if ( SlotNode.Children[0].Anim!=none )
			{
				DrawDebugText(H, bShadowPass, " Source Weight: "@SlotNode.Children[0].Weight@", NodeTotalWeight: "@SlotNode.Children[0].Anim.NodeTotalWeight );
			}
			else
			{
				DrawDebugText(H, bShadowPass, " Source Weight: "@SlotNode.Children[0].Weight@", No anim" );
			}
			for (i=1; i<SlotNode.Children.Length; ++i)
			{
				SeqNode = AnimNodeSequence(SlotNode.Children[i].Anim);
				if ( SeqNode != none )
				{
					if( SeqNode.AnimSeq != None )
					{
						Canvas.SetDrawColor(255, 0, 255, 255);
					}
					else
					{
						Canvas.SetDrawColor(255, 0, 0, 255);
					}

					if (SeqNode.AnimSeq != none)
					{
						AnimName = SeqNode.AnimSeq != None ? SeqNode.AnimSeq.SequenceName : 'None';
						Text = " "@i@". " @ AnimName $ " W:" $ int(SeqNode.NodeTotalWeight*100.f) @ "P:" $ int(SeqNode.GetNormalizedPosition()*100.f) @ "R:"$SeqNode.Rate;
						DrawDebugText(H, bShadowPass, Text);
						if (SeqNode.RootBoneOption[0]!=RBA_Default || SeqNode.RootBoneOption[1]!=RBA_Default || SeqNode.RootBoneOption[2]!=RBA_Default || SeqNode.RootRotationOption[0]!=RRO_Default || SeqNode.RootRotationOption[1]!=RRO_Default || SeqNode.RootRotationOption[2]!=RRO_Default)
						{
							Text = "   RBO:"@SeqNode.RootBoneOption[0]$"/"$SeqNode.RootBoneOption[1]$"/"$SeqNode.RootBoneOption[2] @ "RRO:"@"RBO:"@SeqNode.RootRotationOption[0]$"/"$SeqNode.RootRotationOption[1]$"/"$SeqNode.RootRotationOption[2];
							DrawDebugText(H, bShadowPass, Text);
						}
					}
					else
					{
						DrawDebugText(H, bShadowPass, " "@i@". (no anim)" @ SeqNode.AnimSeqName@"(W:"@SlotNode.Children[i].Weight@")");
					}
				}
			}
		}

		AimOffsetNode = AnimNodeAimOffset(Node);
		if ( AimOffsetNode != none && AimOffsetNode.TemplateNode!=none && AimOffsetNode.TemplateNode.Profiles.Length>AimOffsetNode.CurrentProfileIndex )
		{
			DrawDebugText(H, bShadowPass, " [Active Profile: "@AimOffsetNode.TemplateNode.Profiles[AimOffsetNode.CurrentProfileIndex].ProfileName@"](X:" @ AimOffsetNode.Aim.X@",Y:"@AimOffsetNode.Aim.Y@")");
		}
	}

	Canvas.SetDrawColor(0, 255, 0, 255);
	DrawDebugText(H, bShadowPass, " ");
	DrawDebugText(H, bShadowPass, "* AnimNodeSequences *");
	ForEach DebugMesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
	{
		// Skip non relevant nodes
		if (SeqNode.NodeTotalWeight < 0.00001f)
		{
			continue;
		}

		// Display name in red and NONE if AnimSeq couldn't be found. So it's easier to spot problems.
		if (!bShadowPass)
		{
			if (SeqNode.AnimSeq != None)
			{
				Canvas.SetDrawColor(255, 0, 255, 255);
			}
			else
			{
				Canvas.SetDrawColor(255, 0, 0, 255);
			}
		}

		AnimName = SeqNode.AnimSeq != None ? SeqNode.AnimSeq.SequenceName : 'None';
		Text = (SeqNode.Class != class'AnimNodeSequence') ? String(SeqNode.Class) @ "" : "";
		Text = Text $ "(" $ AnimName $ ") W:" $ int(SeqNode.NodeTotalWeight*100.f) @ "P:" $ int(SeqNode.GetNormalizedPosition()*100.f) @ "R:"$SeqNode.Rate;
		DrawDebugText(H, bShadowPass, Text);
		// moving lines below since now with this, we can't see skelcontrols
		if ( SeqNode.RootBoneOption[0]!=RBA_Default || SeqNode.RootBoneOption[1]!=RBA_Default || SeqNode.RootBoneOption[0]!=RBA_Default )
		{
			Text = " *RBO:"@SeqNode.RootBoneOption[0]$"/"$SeqNode.RootBoneOption[1]$"/"$SeqNode.RootBoneOption[2];
			DrawDebugText(H, bShadowPass, Text);
		}

		if ( SeqNode.RootRotationOption[0]!=RRO_Default || SeqNode.RootRotationOption[1]!=RRO_Default || SeqNode.RootRotationOption[2]!=RRO_Default )
		{
			Text = " *RRO:"@SeqNode.RootRotationOption[0]$"/"$SeqNode.RootRotationOption[1]$"/"$SeqNode.RootRotationOption[2];
			DrawDebugText(H, bShadowPass, Text);
		}
	}

	if (!bShadowPass)
	{
		Canvas.SetDrawColor(0, 255, 0, 255);
	}

	H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
	DebugTextMaxLen = 0.f;
	if (bShadowPass)
	{
		H.Canvas.SetPos(H.Canvas.CurX, H.Canvas.CurY + 1.f);
	}

	DrawDebugText(H, bShadowPass, "* Bone Controllers *");
	if (DebugAnimTree != None)
	{
		for (i=0; i< DebugAnimTree.SkelControlLists.Length; i++)
		{
			SkelControl = DebugAnimTree.SkelControlLists[i].ControlHead;

			if (SkelControl == None)
			{
				continue;
			}

			// Bone name
			if (!bShadowPass)
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
			DrawDebugText(H, bShadowPass, String(DebugAnimTree.SkelControlLists[i].BoneName));

			while (SkelControl != None)
			{
				if (!bShadowPass)
				{
					if (SkelControl.ControlStrength < 0.00001f)
					{
						Canvas.SetDrawColor(255, 0, 0, 255);
					}
					else
					{
						Canvas.SetDrawColor(0, 255, 0, 255);
					}
				}

				if (TRUE) //SkelControl.ControlStrength > 0.00001f )
				{
					DrawDebugText(H, bShadowPass, "  " @ SkelControl.Class $ " (" $ SkelControl.ControlName $") W:" $ int(SkelControl.ControlStrength*100.f));
				}

				SkelControl = SkelControl.NextControl;
			}
		}
	}

	H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
	DebugTextMaxLen = 0.f;
	if (bShadowPass)
	{
		H.Canvas.SetPos(H.Canvas.CurX, H.Canvas.CurY + 1.f);
	}

	DrawDebugText(H, bShadowPass, "* Anim Groups *");

	if (DebugAnimTree != None)
	{
		for (i = 0; i < DebugAnimTree.AnimGroups.Length; i++)
		{
			AnimGroup = DebugAnimTree.AnimGroups[i];
			if (!bShadowPass)
			{
				if (AnimGroup.SynchMaster == None || AnimGroup.SynchMaster.NodeTotalWeight < 0.00001f)
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
				else
				{
					Canvas.SetDrawColor(0, 255, 0, 255);
				}
			}

			DrawDebugText(H, bShadowPass, AnimGroup.GroupName @ "RateScale:" $ AnimGroup.RateScale @ "NumNodes:" $ AnimGroup.SeqNodes.Length @ "P:" $ DebugAnimTree.GetGroupRelativePosition(AnimGroup.GroupName));
			if (AnimGroup.SynchMaster != None)
			{
				DrawDebugText(H, bShadowPass, "  SynchMaster:" $ AnimGroup.SynchMaster @ "W:" $ int(AnimGroup.SynchMaster.NodeTotalWeight*100.f));
			}
			else
			{
				DrawDebugText(H, bShadowPass, "  SynchMaster:None");
			}

			if (AnimGroup.NotifyMaster != None)
			{
				DrawDebugText(H, bShadowPass, "  NotifyMaster:" $ AnimGroup.NotifyMaster @ "W:" $ int(AnimGroup.NotifyMaster.NodeTotalWeight*100.f));
			}
			else
			{
				DrawDebugText(H, bShadowPass, "  NotifyMaster:None");
			}
		}
	}

	if (DebugPawn != none && DebugPawn.InteractionPawn != None)
	{
		DrawDebugText(H, bShadowPass, "* InteractionPawn AnimGroups *");

		DebugPawn = DebugPawn.InteractionPawn;
		for (i=0; i<DebugPawn.AnimTreeRootNode.AnimGroups.Length; i++)
		{
			AnimGroup = DebugPawn.AnimTreeRootNode.AnimGroups[i];
			if (!bShadowPass)
			{
				if (AnimGroup.SynchMaster == None || AnimGroup.SynchMaster.NodeTotalWeight < 0.00001f)
				{
					Canvas.SetDrawColor(255, 0, 0, 255);
				}
				else
				{
					Canvas.SetDrawColor(0, 255, 0, 255);
				}
			}

			DrawDebugText(H, bShadowPass, AnimGroup.GroupName @ "RateScale:" $ AnimGroup.RateScale @ "NumNodes:" $ AnimGroup.SeqNodes.Length @ "P:" $ DebugPawn.AnimTreeRootNode.GetGroupRelativePosition(AnimGroup.GroupName));
			if (AnimGroup.SynchMaster != None)
			{
				DrawDebugText(H, bShadowPass, "  SynchMaster:" $ AnimGroup.SynchMaster @ "W:" $ int(AnimGroup.SynchMaster.NodeTotalWeight*100.f));
			}
			else
			{
				DrawDebugText(H, bShadowPass, "  SynchMaster:None");
			}

			if (AnimGroup.NotifyMaster != None)
			{
				DrawDebugText(H, bShadowPass, "  NotifyMaster:" $ AnimGroup.NotifyMaster @ "W:" $ int(AnimGroup.NotifyMaster.NodeTotalWeight*100.f));
			}
			else
			{
				DrawDebugText(H, bShadowPass, "  NotifyMaster:None");
			}
		}
	}

	Canvas.SetDrawColor(0, 255, 0, 255);

	if (DebugMesh.ActiveMorphs.Length > 0)
	{
		DrawDebugText(H, bShadowPass, "* Morph Targets *");

		// Morph if exists
		for (i = 0; i < DebugMesh.ActiveMorphs.Length; ++i)
		{
			DrawDebugText(H, bShadowPass, "  Active Morphs: (" $ DebugMesh.ActiveMorphs[i].Target @ ":" $ DebugMesh.ActiveMorphs[i].Weight);
		}

	}

	if (DebugMesh.ActiveCurveMorphs.Length > 0)
	{
		DrawDebugText(H, bShadowPass, "* Morph Target Animations *");

		// Morph if exists
		for (i = 0; i < DebugMesh.ActiveCurveMorphs.Length; ++i)
		{
			DrawDebugText(H, bShadowPass, "  Active Curve Morphs: (" $ DebugMesh.ActiveCurveMorphs[i].Target @ ":" $ DebugMesh.ActiveCurveMorphs[i].Weight);
		}
	}
}

/** Tell the client to setup the blind effects */
reliable client function ClientToggleBlindEffects(bool bVal)
{
	if (MyGearHUD != None)
	{
		MyGearHUD.ToggleBlindEffects(bVal);
	}
}

/**
 * Updates other members of your Xbox Live Party with your newly earned award
 *
 * @param Award the award you just earned
 */
function UpdatePartyWithAwardInfo(GearAward Award);

/** Let's the controller know that he killed a lambent stalk pod */
reliable client function ClientKilledLambentStalkPod()
{
	TriggerGearEventDelegates(eGED_KilledStalkPod);
}

simulated function GearAlertManager GetAlertManager()
{
	local GearLocalPlayer GLP;

	GLP = GearLocalPlayer(Player);

	if (GLP != None)
	{
		return GLP.AlertManager;
	}
	return None;
}

/**
 * Check if we can spot any pawns
 *
 * @param SpottedPawnCandidate - the pawn that should be sent to the server as spotted
 *
 * @return TRUE if SpottedPawnCandidate is a valid spot
 */
function bool CanSpotAPawn(out GearPawn SpottedPawnCandidate)
{
	local GearPawn GP;
	local float CamTraceDist;
	local vector StartTrace, EndTrace, ClosestPoint, TracePoint;
	local rotator CamRot;
	local float BestDist, TestDist, SpotBuffer;

	// must be targeting or a ghost cam spectator in horde mode
	if (!bIsTargeting && (GearGRI_Horde(WorldInfo.GRI) == None || !IsInState('GhostSpectating')))
	{
		return FALSE;
	}

	if (TargetedPawn != None)
	{
		// Crosshair is over a pawn, easy mode
		if (TargetedPawn.SpottedByTeam[GetTeamNum()] == 0 && TargetedPawn.GetTeam() != None && !TargetedPawn.IsSameTeam(Pawn) && !TargetedPawn.bPlayedDeath)
		{
			SpottedPawnCandidate = TargetedPawn;

			return TRUE;
		}
	}

	// Going to do a fuzzy check by seeing if the camera trace is within SpotBuffer units of hitting the pawn
	GetPlayerViewPoint(StartTrace, CamRot);
	EndTrace = StartTrace + vector(CamRot) * DistanceForEnemyTrace;

	BestDist = DistanceForEnemyTrace;

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (!GP.bNotSpottable && GP.GetTeam() != None && GP.SpottedByTeam[GetTeamNum()] == 0 && !GP.bPlayedDeath && !GP.IsSameTeam(Pawn))
		{
			TestDist = VSize(GP.Location - StartTrace);
			if (TestDist < BestDist)
			{
				SpotBuffer = Lerp(GP.SpotBufferMin, GP.SpotBufferMax, TestDist / DistanceForEnemyTrace);
				CamTraceDist = PointDistToSegment(GP.Location, StartTrace, EndTrace, ClosestPoint);
				//`log(`showvar(GP) @ `showvar(CamTraceDist) @ `showvar(SpotBuffer));

				if (CamTraceDist < SpotBuffer)
				{
					TracePoint = GP.Location;
					if (!(GP.IsInCover() && GP.CoverType == CT_MidLevel && GP.CoverAction == CA_Default))
					{
						TracePoint.Z += GP.BaseEyeHeight;
					}

					//DrawDebugLine(StartTrace, TracePoint, 255, 0, 0, TRUE);

					if (FastTrace(StartTrace, TracePoint, , TRUE) && !IsSmokeGrenadeBlockingSight(StartTrace, TracePoint))
					{
						BestDist = TestDist;
						SpottedPawnCandidate = GP;
					}
				}
			}
		}
	}

	return SpottedPawnCandidate != None;
}

/**
 * Check if we can spot any pickups
 *
 * @param SpottedPickupCandidate - the pickup that should be sent to the server as spotted
 *
 * @return TRUE if SpottedPickupCandidate is a valid spot
 */
function bool CanSpotAPickup(out Actor SpottedPickupCandidate)
{
	local float BestDist;
	local GearDroppedPickup Pickup;
	local GearPickupFactory Factory;
	local float DistSquared;

	// must be targeting or a ghost cam spectator
	if (!bIsTargeting && !IsInState('GhostSpectating'))
	{
		return FALSE;
	}

	// Check the game type to make sure we're allowed to spot pickups
	if (!GearGRI(WorldInfo.GRI).bAllowPickupSpotting)
	{
		return false;
	}

	BestDist = MyGearPawn.SpotBufferMax * MyGearPawn.SpotBufferMax + 1;

	foreach WorldInfo.RadiusNavigationPoints(class'GearPickupFactory', Factory, LastCrosshairHitLocation, MyGearPawn.SpotBufferMax)
	{
		DistSquared = VSizeSq(Factory.Location - LastCrosshairHitLocation);
		if (Factory.IsInState('Pickup') && DistSquared < BestDist)
		{
			SpottedPickupCandidate = Factory;
			BestDist = DistSquared;
		}
	}
	foreach WorldInfo.CollidingActors(class'GearDroppedPickup', Pickup, MyGearPawn.SpotBufferMax, LastCrosshairHitLocation, false)
	{
		DistSquared = VSizeSq(Pickup.Location - LastCrosshairHitLocation);
		if (Pickup.IsInState('Pickup') && DistSquared < BestDist)
		{
			SpottedPickupCandidate = Pickup;
			BestDist = DistSquared;
		}
	}

	return SpottedPickupCandidate != None;
}

/** function that tells the client to lock input to the main menu */
final reliable client function ClientLockMainMenuInput()
{
	local GearPC GPC;
	local GearMenuHUD GMH;

	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		GMH = GearMenuHUD(GPC.myHUD);
		if (GMH != None && GMH.FrontEndMovie != None)
		{
			GMH.FrontEndMovie.LockMainMenuInput();
		}
	}
}

/**
 * Function that informs the server about which mutators have been unlocked by this player
 */
simulated function UpdateMutatorUnlocks()
{
	local class<GearMutator> MutatorClass;
	local bool bHasUnlockedMutator;
	local int MutatorsUnlockedBitfield, i;

	for(i =0; i < class'UIWidget_MainMenu'.default.MutatorClassArray.Length; i++)
	{
		MutatorClass = none;
		bHasUnlockedMutator = false;
		if (class'UIWidget_MainMenu'.default.MutatorClassArray[i] != "")
		{
			MutatorClass = class<GearMutator>(DynamicLoadObject(class'UIWidget_MainMenu'.default.MutatorClassArray[i],class'Class'));
		}
		if (MutatorClass != none)
		{
			bHasUnlockedMutator = (MutatorClass.default.UnlockAwardName == "") || (AwardManager.HasEarnedAwardByName(name(MutatorClass.default.UnlockAwardName)));
		}
		if (bHasUnlockedMutator)
		{
			MutatorsUnlockedBitfield = MutatorsUnlockedBitfield | (1 << i);
		}
	}

	ServerUnlockedMutatorsNotification(MutatorsUnlockedBitfield);
}

/**
 * Server function called to inform the server of the unlock state of the client's mutators
 *
 * @param MutatorsUnlockedBitfield - bitfield representing whether or not a mutator is unlocked. Corresponds to the MutatorClassArray in UIWidget_MainMenu
 */
reliable server function ServerUnlockedMutatorsNotification(int MutatorsUnlockedBitfield)
{
	local GearPartyGRI PartyGRI;
	local GearPartyPRI PartyPRI;

	PartyPRI = GearPartyPRI(PlayerReplicationInfo);
	PartyGRI = GearPartyGRI(WorldInfo.GRI);

	if (PartyGRI != none && PartyPRI != none)
	{
		PartyPRI.MutatorsUnlockedBitfield = MutatorsUnlockedBitfield;
		PartyGRI.RecomputeMutatorsUnlocked();
	}
}

/** shortcut for the lazy :) */
// Intentionally here for testers
exec function UH()
{
	UnlimitedHealth();
}

/** Allows pawn to take damage, but never die. */
// Intentionally here for testers
exec function UnlimitedHealth()
{
	local int i;
	local GearPawn APawn;
	local GearVehicle AVehicle;

	APawn = GearPawn(Pawn);
	if (APawn == None)
	{
		AVehicle = GearVehicle(Pawn);
		if (AVehicle != None)
		{
			for (i=0; i<AVehicle.Seats.length; i++)
			{
				APawn = GearPawn(AVehicle.Seats[i].StoragePawn);
				if (APawn != None)
				{
					APawn.bUnlimitedHealth = !APawn.bUnlimitedHealth;
					ClientMessage("UnlimitedHealth"@APawn@APawn.bUnlimitedHealth);
				}
			}
		}
	}
	else
	{
		APawn.bUnlimitedHealth = !APawn.bUnlimitedHealth;
		ClientMessage("UnlimitedHealth"@APawn@APawn.bUnlimitedHealth);
	}
}

// Intentionally here for testers
exec function PlayersOnly()
{
	if (WorldInfo.bPlayersOnly || WorldInfo.bPlayersOnlyPending)
	{
		WorldInfo.bPlayersOnly = false;
		WorldInfo.bPlayersOnlyPending = false;
	}
	else
	{
		WorldInfo.bPlayersOnlyPending = !WorldInfo.bPlayersOnlyPending;
		// WorldInfo.bPlayersOnly is set after next tick of UWorld::Tick
	}
}

// These cheat functions are intentionally here for tester use, should possibly be removed later
exec function Fly()
{
	if ( (Pawn != None) && Pawn.CheatFly() )
	{
		ClientMessage("You feel much lighter");
		bCheatFlying = true;
		GotoState('PlayerFlying');
	}
}

exec function Walk()
{
	bCheatFlying = false;
	if (Pawn != None && Pawn.CheatWalk())
	{
		Restart(false);
	}
}

exec function Ghost()
{
	if ( (Pawn != None) && Pawn.CheatGhost() )
	{
		bCheatFlying = true;
		GotoState('PlayerFlying');
	}
	else
	{
		bCollideWorld = false;
	}

	ClientMessage("You feel ethereal");
}

exec function God()
{
	if ( bGodMode )
	{
		bGodMode = false;
		ClientMessage("God mode off");
		return;
	}

	bGodMode = true;
	ClientMessage("God Mode on");
}

/** Unlocks all the chapters for all difficulties */
exec function UnlockAllChapters()
{
	local GearPC PC;
	local int ChapIndex, TotalChapters;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ChapterProviders;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if ( GameResourceDS.GetResourceProviders('Chapters', ChapterProviders) )
	{
		TotalChapters = ChapterProviders.Length;
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			for (ChapIndex = 0; ChapIndex < TotalChapters; ChapIndex++)
			{
				PC.ClientCompleteChapter(ChapIndex,DL_Insane,false,1);
			}
		}
	}
	`log("Unlocked all Chapters for all difficulties");
}

/** @return the device id for this player */
function int GetDeviceId()
{
	if (PersistentData != None)
	{
		return PersistentData.DeviceId;
	}
	return -1;
}

/**
 * Sets the device id for this player
 *
 * @param DeviceId the new device id to use
 */
function SetDeviceId(int DeviceId)
{
	if (PersistentData != None)
	{
		PersistentData.DeviceId = DeviceId;
	}
}

/** @return true if the currently selected device is valid, false otherwise */
function bool IsStorageDeviceValid()
{
	if (OnlineSub.PlayerInterfaceEx != None)
	{
		return OnlineSub.PlayerInterfaceEx.IsDeviceValid(GetDeviceId());
	}
	return true;
}

/**
 * Marks the chapter as being completed at a particular difficulty
 *
 * @param CompletedChapter - the chapter to mark as complete
 * @param Difficulty - the difficulty level that was completed
 * @param bWasArcade - is this arcade mode
 * @param NumCoopPlayers - number of players at time of the call
 */
reliable client function ClientCompleteChapter(int CompletedChapter, EDifficultyLevel Difficulty, bool bWasArcade, int NumCoopPlayers)
{
	local GearHUD_Base  GearHUD;

	ProfileSettings.CompleteChapterByDifficulty(CompletedChapter, Difficulty, self, bWasArcade, NumCoopPlayers);

	if (bWasArcade)
	{
		// Piggyback arcade stats write on chapter complete message
		// @TODO JM - possibly move this to where EOR UI shows itself when done
		ClientWriteLeaderboardStats(class'GearLeaderboardArcadeWrite');

		GearHUD = GearHUD_Base(myHUD);
		if( GearHUD != None )
		{
			GearHUD.OpenEndOfRoundScene();
		}
	}
}

reliable client final function ClientExecutionXPMessage(int AwardedPoints)
{
	local int Index;

	if (MyGearHud.AddHUDMessage(None, None, Index))
	{
		MyGearHud.PriorityHUDMessages[Index].TimeRemaining = MyGearHud.DeathDataTime;
		MyGearHud.PriorityHUDMessages[Index].bUseMessageText = true;
		MyGearHud.PriorityHUDMessages[Index].MessageText = ExecutionBonusMessage @ "+" $ AwardedPoints;
		MyGearHud.PriorityHUDMessages[Index].bAlwaysShow = true;
	}
	else
	{
		MyGearHud.HUDMessages[Index].TimeRemaining = MyGearHud.DeathDataTime;
		MyGearHud.HUDMessages[Index].bUseMessageText = true;
		MyGearHud.HUDMessages[Index].MessageText = ExecutionBonusMessage @ "+" $ AwardedPoints;
		MyGearHud.HUDMessages[Index].bAlwaysShow = true;
	}
}

/** Check to see if it should add death messages in the queue **/
simulated function CheckDelayedDeathMessage()
{
	local int i;
	local bool bMessageLeft;
	local DeathMessage DM;

	for (i=0; i<DelayedDeathMessages.Length; ++i)
	{
		if ( DelayedDeathMessages[i].bSentToHud == FALSE )
		{
			DM = DelayedDeathMessages[i];

			if ( AddDeathMessage(DM.Victim, DM.Killer, DM.Other,
				DM.DamageType, DM.DeathType, DM.bIsKnockdown, DM.PointsAwarded, DM.bIgnoreForHUD, DM.bSkipBlood, FALSE) )
			{
				DelayedDeathMessages[i].bSentToHud = TRUE;
			}
			else
			{
				// still not sent yet
				bMessageLeft = TRUE;
			}
		}
	}

	// if message is done, clear it
	if (bMessageLeft == FALSE)
	{
		// clear all
		DelayedDeathMessages.Length = 0;
	}
	else
	{
		// if not, set next timer
		// set another timer
		SetTimer(0.2f, FALSE, 'CheckDelayedDeathMessage');
	}
}

/** Should display death message
 *  return TRUE if it should
 */
simulated function bool ShouldDisplayDeathMessage(GearPawn Victim)
{
	// if not ready yet, add to queue
	return (Victim == None || Victim.ShouldDisplayDeathMessage());
}

/** Add Death Message to HUD. Called @ server
 *  return TRUE if successfully added
 *  return FALSE otherwise
 */
simulated function AddToDelayedDeathMessage( GearPawn Victim, PlayerReplicationInfo Killer, PlayerReplicationInfo Other, class<DamageType> damageType, EGearDeathType DeathType, bool bIsKnockdown, optional int PointsAwarded=0, optional bool bIgnoreForHUD, optional bool bSkipBlood )
{
	local DeathMessage DM;
	local int i;

	DM.Victim = Victim;
	DM.Killer = Killer;
	DM.Other = Other;
	DM.DamageType = DamageType;
	DM.DeathType = DeathType;
	DM.bIsKnockdown = bIsKnockdown;
	DM.PointsAwarded = PointsAwarded;
	DM.bIgnoreForHUD = bIgnoreForHUD;
	DM.bSkipBlood = bSkipBlood;
	DM.bSentToHud = FALSE;

	for (i=0; i<DelayedDeathMessages.Length; ++i)
	{
		// if I find something used already, fill that up
		// can't delete element from script freely
		// so need to reuse, when empty, just clear all up
		if ( DelayedDeathMessages[i].bSentToHud )
		{
			DelayedDeathMessages[i] = DM;
			return;
		}
	}

	// add at the end
	DelayedDeathMessages[DelayedDeathMessages.Length] = DM;
}

/**
 * Initializes the object that tracks post game stats so we can track people that drop
 *
 * @param OnlineStatsWriteClass the stats class to write with
 * @param bUsesArbitration whether this is an arbitrated match or not
 */
reliable client function ClientInitLastMatchResults(class<OnlineStatsWrite> OnlineStatsWriteClass,bool bUsesArbitration)
{
	local GearRecentPlayersList PlayersList;
	local GearMatchData MatchResults;
	local int Index;
	local GearPRI PRI;
	local UniqueNetId ZeroId;
	local OnlineGameSettings GameSettings;

	// Since the object is a singleton, it only needs to be done once per box
	if (IsPrimaryPlayer() && OnlineSub != None && OnlineSub.GameInterface != None)
	{
		// Get the recent player data for the last match stats
		PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if (PlayersList != None)
		{
			// Get the game setting so we can determine whether to write stats for none, one or all players
			GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
			if (GameSettings != None)
			{
				PlayersList.InitRecentMatchResults(OnlineStatsWriteClass,WorldInfo.GetMapName(),bUsesArbitration);
				MatchResults = PlayersList.GetCurrentMatchResults();
				if( StatManager != None )
				{
					MatchResults.SetPreviousHighScore( StatManager.GetHighScore() );
					MatchResults.SetPreviousHighWave( StatManager.GetMaxWaveCompleted() );
				}
				// Add each player so we can track those that drop
				for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
				{
					PRI = GearPRI(WorldInfo.GRI.PRIArray[Index]);
					// Ignore bots, because they get handled at match end
					if (PRI.UniqueId != ZeroId)
					{
						MatchResults.AddPlayer(PRI);
					}
				}
			}
		}
	}
}

/**
 * Clears the previous match results after a mapcycle
 */
reliable client function ClientClearLastMatchResults()
{
	local GearRecentPlayersList PlayersList;

	// Since the object is a singleton, it only needs to be done once per box
	if (IsPrimaryPlayer() && OnlineSub != None && OnlineSub.GameInterface != None)
	{
		// Get the recent player data for the last match stats
		PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if (PlayersList != None)
		{
			PlayersList.ClearLastMatchResults();
		}
	}
}

/**
 * Adjusts the client's quit count up or down depending on completing a match or not
 *
 * @param Adjustment the amount to change the quit count by
 */
reliable client function ClientAdjustQuitCount(int Adjustment)
{
	if (ProfileSettings != None)
	{
		ProfileSettings.AdjustQuitCount(Adjustment);
	}
}

defaultproperties
{
	FovAngle=+00085.000000
	CameraClass=class'GearPlayerCamera'
	CheatClass=class'MSCheatManager'
	InputClass=class'GearPlayerInput'
	MinRespawnDelay=3.0

	MinMeleeAdhesionDotValue=0.2588f		// 75 deg

	InputIsDisabledCount = 0
	bCinemaDisableInputButtons = false

	PostProcessPresets(0)=(Preset=TVT_Default,Shadows=1.0, Midtones=1.0, Highlights=1.0, Desaturation=1.0)
	PostProcessPresets(1)=(Preset=TVT_Soft,Shadows=0.8, Midtones=0.9, Highlights=1.1, Desaturation=1.1)
	PostProcessPresets(2)=(Preset=TVT_Lucent,Shadows=0.7, Midtones=0.8, Highlights=1.2, Desaturation=1.2)
	PostProcessPresets(3)=(Preset=TVT_Vibrant,Shadows=1.0, Midtones=1.0, Highlights=0.8, Desaturation=0.8)

	SavedMoveClass=class'GearSavedMove'

	PointOfInterestLookatInterpSpeedRange=(X=7.f,Y=7.f)

	DeathCameraEnemyMaxDistance=2048

	Begin Object Class=GearCameraShake Name=ARSuperSuccessScreenShake0
		OscillationDuration=0.3f
		RotOscillation={(Yaw=(Amplitude=35.f,Frequency=125.f),
						Roll=(Amplitude=35.f,Frequency=125.f))}
	End Object
	ARSuperSuccessScreenShake=ARSuperSuccessScreenShake0

	ActionHitFortification={(
			 ActionName=HitFortification,
			 IconAnimationSpeed=0.1f,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32),	// mash B button
											  (Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=33,UL=45,VL=32)))),
			)}

	ActionValveTurn={(
		ActionName=ValveTurnable,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))	),
		)}

	ActionStayingAlive={(
		ActionName=StayingAlive,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90), // Stick move icon
										  (Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=145,V=275,UL=75,VL=49), // Can move icon
										  (Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=145,V=275,UL=75,VL=49))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43),	// mash A button
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=248,V=314,UL=35,VL=43))) ),
		)}

	ActionStayingAliveAutoRevive={(
		ActionName=StayingAlive,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90), // Stick move icon
										  (Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=134,V=327,UL=93,VL=90))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=155,V=0,UL=100,VL=85), // Revive icon
										  (Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=155,V=0,UL=100,VL=85))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43),	// mash A button
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=248,V=314,UL=35,VL=43))) ),
		)}

	// during reviving stage, if you move, it will get cancelled, so I removed movement icon
	ActionStayingAliveAutoReviving={(
		ActionName=StayingAlive,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=155,V=85,UL=100,VL=85), // Revive icon
										  (Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=155,V=85,UL=100,VL=85))),
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43),	// mash A button
										  (Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=248,V=314,UL=35,VL=43))) ),
		)}

	// once revived, A button mash doesn't matter.
	ActionStayingAliveAutoRevived={(
		ActionName=StayingAlive,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=155,V=170,UL=100,VL=85), // Revive icon
										  (Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=155,V=170,UL=100,VL=85))) ),
		)}

	ActionSuicideBomb={(
		ActionName=SuicideBomb,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=99,V=375,UL=34,VL=42))), // Right trigger
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=57,V=299,UL=78,VL=80)))	),
		)}

	ActionKismetButton=(ActionName=KismetButton)

	GearIcons(eGEARICON_A)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43)
	GearIcons(eGEARICON_A_PRESSED)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=248,V=314,UL=35,VL=43)
	GearIcons(eGEARICON_B)=(Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32)
	GearIcons(eGEARICON_B_PRESSED)=(Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=33,UL=45,VL=32)
	GearIcons(eGEARICON_X)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32)
	GearIcons(eGEARICON_X_PRESSED)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=376,V=314,UL=45,VL=32)
	GearIcons(eGEARICON_Y)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=389,V=421,UL=35,VL=43)
	GearIcons(eGEARICON_Y_PRESSED)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64) // Y button actions currently uses these icons interchangeably, there is no "mash y" button
	GearIcons(eGEARICON_RS)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=425,V=422,UL=35,VL=64)
	GearIcons(eGEARICON_RS_PRESSED)=(Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=460,V=422,UL=36,VL=64)
	GearIcons(eGEARICON_LS)=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=223,V=269,UL=35,VL=64)
	GearIcons(eGEARICON_LS_PRESSED)=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=258,V=269,UL=35,VL=64)
	GearIcons(eGEARICON_RT)=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=99,V=375,UL=34,VL=42)
	GearIcons(eGEARICON_LT)=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=62,V=375,UL=34,VL=42)
	GearIcons(eGEARICON_Chainsaw)=(Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=0,V=0,UL=83,VL=66)
	GearIcons(eGEARICON_Chainsaw_PRESSED)=(Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=0,V=68,UL=83,VL=66)

	CurrentSoundMode=None

	PointOfInterestAdded=SoundCue'Interface_Audio.Objectives.PointOfInterestAdded'
	LastPoITime= 0.0f
	PoIRepeatTime = 15.0f

	Begin Object Class=AudioComponent Name=GameoverComp
		//SoundCue=SoundCue'Interface_Audio.Interface.ObjectiveFailLoopCue'
	End Object
	GameoverLoop=GameoverComp
	Components.Add(GameoverComp)

	OpenGameoverCue=SoundCue'Interface_Audio.Interface.ObjectiveFailEnterCue'
	LoadCheckpointCue=SoundCue'Interface_Audio.Interface.ObjectiveFailExitCue'

	InUseNodeCostMultiplier=10.0

	RotationRate=(Pitch=0,Yaw=0,Roll=0)

	LastCheckpointSaveTime=-10000.0
	LastSpotTime=-1.f

	DefaultSpectateType=Spectating
}
