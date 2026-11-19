class SeqAct_AIFactory extends SequenceAction
	native(TGSequence)
	dependson(TGAI);

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

enum EAITypes
{
	AIType_PLA,
	AIType_PLA_01,
	AIType_PLA_03,

	AIType_Enemy,
	AIType_US_01,
	AIType_US_02,

	AIType_PLA_02,
	AIType_PLA_04,
	AIType_PLA_05,
	AIType_PLA_06,

	AIType_Hostage_01,

	AIType_PLA_07,
	AIType_PLA_08,
	AIType_PLA_11,

	AIType_US_Commander_01,
	AIType_US_03,
	AIType_US_09,
};

enum EInventoryTypes
{
	WEAP_Lancer,
	WEAP_MyLancer,
	WEAP_Longshot,
	WEAP_MyLongshot,
	WEAP_MyLongshotSilencer,
	WEAP_NPC_M16A4,
	WEAP_NPC_AK74M,
	WEAP_NPC_M110,
	WEAP_NPC_VSS,
	WEAP_NPC_R95,
	WEAP_NPC_R03,
	WEAP_NPC_S88,
	WEAP_NPC_S85,
	WEAP_NPC_R95Silencer,
	WEAP_NPC_LMG88,
	WEAP_NPC_S88_Cloth,
};

var const array<Name> InventoryTypeNames;

/**
 * Contains info about an AI type to spawn.
 */
struct native AISpawnInfo
{
	/** What type of AI should be spawned? */
	var() EAITypes AIType<Sorted>;

	/** How many should be spawned of this type? */
	var() int SpawnTotal;

	/** How many should be alive at any one point? */
	var() int MaxAlive;

	/** Total number that have been spawned from this set */
	var int SpawnedCount;

	/** List of currently spawned */
	var array<Pawn> WatchList;

	/** Delay between spawns */
	var() float MaxSpawnDelay, MinSpawnDelay;

	/** Current delay before allowed to try spawning again */
	var float CurrentDelay;

	/**
	 * What inventory items should be given to the AI.
	 * This can not be named "LoadOut" or "LoadOutNames" until content has been resaved to
	 * remove maps with the older AIFactories which have those named properties
	 */
	var() array<EInventoryTypes> WeaponLoadOut;

	/** List of variable links associated with this set */
	var array<string> VarLinkDescs;

	/** List of output links associated with this set */
	var array<string> OutLinkDescs;

	/** AI in the spawning process (ex. crawling out of a hole) */
	var array<Pawn> CurrentSpawns;

	/** Use the move targets? */
	var() bool bAssignMoveTarget;

	/** Use the cover groups? */
	var() bool bAssignCombatZones;

	// these are private vars which we store the actual hard reference to the
	// classes we need for this spawn
	var class<Pawn> TGPawnClass;
	var class<AIController> ControllerClass;
	var array<class<Inventory> > LoadoutClasses;

	/** Should this AI drop inventory on death? */
	var() bool bAllowInventoryDrops;

	/** Should this AI allow hit impact decals on its skel mesh**/
	var() bool bAllowHitImpactDecalsOnSkelMesh;

	/** Should this AI spawn hit effect decals **/
	var() bool bSpawnHitEffectDecals;

	/** Should this AI spawn blood trail decals **/
	var() bool bSpawnBloodTrailDecals;

	/** Squad this AI should join */
	var() Name SquadName;
	var() bool bSquadLeader;
	/** Actor Tag to apply to spawned AI */
	var() Name ActorTag;

	/** Automatically acquire the nearest enemy after spawning */
	var() bool bAutoAcquireEnemy;
	/** Automatically notify enemies of spawn event */
	var() bool bAutoNotifyEnemy;

	/** Spawn only if coop */
	var() bool bSpawnOnlyIfCoop;

    var const int SetVersion;

	/** String displayed above any AI spawned from this set */
	var() string AutoDebugText;

	/** turn this on to disable this pawn from ever going DBNO */
	var() bool bDontAllowDBNO;

	/** turn this on to allow this pawn to be removed when it hasn't done anything useful in a long time */
	var() bool bAllowDeleteWhenStale;

	/** Shadow mode to set on the spawned pawn */
	var() ELightShadowMode ShadowMode;

	/** Chance AI should play an initial reaction animation when they first spot enemies */
	var() float PlayIntialCombatReactionChance;

	/** whether or not to disable shadow casting on this pawn */
	var() bool bDisableShadowCasting;

	/** Whether or not this pawn should play the death scream. (i.e. aerial combat or mobs that are far away don't need this on at all)**/
	var() bool bDisableDeathScreams;

	/** Should this player always appear in TacCom for its team regardless of squad? */
	var() bool bForceShowInTaccom;

	structcpptext
	{
		/** Constructors */
		FAISpawnInfo() {}
		FAISpawnInfo(EEventParm)
		{
			appMemzero(this, sizeof(FAISpawnInfo));
		}
		void InitToDefaults()
		{
			appMemzero(this, sizeof(FAISpawnInfo));
			bAllowDeleteWhenStale=FALSE;
			SpawnTotal=1;
			MaxAlive=1;
			bAssignMoveTarget=TRUE;
			bAssignCombatZones=TRUE;
			bAllowInventoryDrops=TRUE;
			bAllowHitImpactDecalsOnSkelMesh=TRUE;
			bSpawnHitEffectDecals=TRUE;
			bSpawnBloodTrailDecals=TRUE;
			bAutoAcquireEnemy=FALSE;
			bAutoNotifyEnemy=FALSE;
			SquadName=FName(TEXT(""));
			ShadowMode=LightShadow_Modulate;
			bDisableShadowCasting=FALSE;
			bDisableDeathScreams=FALSE;
			PlayIntialCombatReactionChance=0.5;
		}
		FAISpawnInfo(ENativeConstructor)
		{
			InitToDefaults();
		}
	}

	structdefaultproperties
	{
		bAllowDeleteWhenStale=FALSE
		SpawnTotal=1
		MaxAlive=1
		bAssignMoveTarget=TRUE
		bAssignCombatZones=TRUE
		bAllowInventoryDrops=TRUE
		bAllowHitImpactDecalsOnSkelMesh=TRUE
		bSpawnHitEffectDecals=TRUE
		bSpawnBloodTrailDecals=TRUE
		bAutoAcquireEnemy=FALSE
		bAutoNotifyEnemy=FALSE
		ShadowMode=LightShadow_Modulate
		bDisableShadowCasting=FALSE
		PlayIntialCombatReactionChance=0.5
	}
};

/** List of groups of AIs to spawn */
var(Spawn) array<AISpawnInfo> SpawnSets;

/** List of info associated with the AITypes enum used for spawning */
struct native AITypeInfo
{
	var name ControllerClassName;
	var name PawnClassName;
	var int TeamIdx;
	var bool bUnique;
};
var const array<AITypeInfo> SpawnInfo;

/** List of points to spawn AI at */
var(Spawn) array<Actor> SpawnPoints;

/** Have we spawned everything? */
var bool bAllSpawned;

/** Has everything we spawned died? */
var bool bAllDead;

/** Should we prevent any further spawns? */
var bool bAbortSpawns;

/** Should we suppress the AllDead output? */
var bool bSuppressAllDead;

/** Number of dudes dead from this spawner */
var int DeadCount;
/** Number dead in last frame before firing Num Dead output */
var int NumDead;

/** Number of dudes to die before activating matching link */
var() int ActivateDeadLinkCount;

/** Have we activated the dead link? */
var bool bActivatedDeadLink;
/** Reset the dead link count after each firing */
var() bool bResetDeadLinkCount;

/** How are move targets and cover assigned? */
enum EAIAssignment
{
	EA_UniquePerSpawn,		/** Assigned out once per spawn til none are left */
	EA_Shared,				/** Shared across all spawned */
};

/** Move targets to give the spawned AI */
var(Move) EAIAssignment MoveAssignment;
var(Move) array<Actor> MoveTargets;
/** Is the move interruptable? */
var(Move) bool bMoveInterruptable;
/** For use with EA_Shared */
var int MoveTargetIdx;

/** Combat zones to assign */
var(Cover) array<CombatZone> CombatZones;

/** Perception mood to start in */
var() EPerceptionMood	PerceptionMood;
/** Combat mood to start in */
var() ECombatMood		CombatMood;

enum ESpawnPointSelectionMethod
{
	SPSM_Shuffle,
	SPSM_Linear,
};
var() ESpawnPointSelectionMethod SpawnPointSelectionMethod;

/**
 * If a unique character is greater than this distance then
 * teleport them to the spawn point.
 */
var() float TeleportDistance;
var() float TeleportZDistance;
/**
 * If a unique character isn't teleported, then force them
 * to move to the spawn location.
 */
var() bool bForceMoveToSpawnLocation;

/** Used to set the bEnableEncroachCheckOnRagdoll flag on the spawned Pawn. */
var() bool bEnableEncroachCheckOnRagdoll;

/** Use damage for kill all instead of calling died directly */
var() bool bUseDamageForKillAll;

/** Check if we've fixed up the defaults for Auto Acquire/Notify Enemy, remove some day */
var const bool bFixedUpAutoEnemyDefaults;

/**
 * The round(wave) that the spawned characters from this factory will count toward
 * the total enemy count displayed in the HUD. 0 means the factory will not count toward the count.
 */
var() int RoundToCountSpawnsInHUD;

/** Prevents Combat Entered output from firing more than once */
var	bool bEnteredCombat;

/*When CleanUp(removed/unloaded), kill all*/
var() bool bKillAllWhenCleanUp;

var() bool bOnlySpawnHidden;
var() bool bHiddenIgnoreCamera;

native function NotifyCombatEntered();

static native function bool CanSpawnAtLocation(out vector ChkLocation, vector ChkExtent, Actor SpawnPointActor );

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 47;
}

