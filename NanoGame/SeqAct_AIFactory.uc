/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AIFactory extends SequenceAction
	native(Sequence);

enum EAITypes
{
	// !!!! add NEW entries below here MET == MetaCorp  REB == Rebels !!!!
	AIType_MET_RiotCop,
	AIType_MET_AssassinationTarget, // VIP that is hard to kill
	AIType_REB_King,
	AIType_MET_RiotCop_BulletProof,
	AIType_MET_TattlerBot,
	AIType_MET_RiotCop_Shield,
	AIType_MET_SkyPatrol,
	AIType_MET_PacifierBot,
	AIType_REB_ShopKeeper,
	AIType_MET_RiotCop_Captain,
	AIType_MET_BullRam,
	AIType_MET_TrooperWall,
	AIType_MET_OrbitalBot,
	AIType_REB_Owen,
	AIType_REB_RabbleRouser,
	// !!!! add NEW entries below here MET == MetaCorp  REB == Rebels !!!!
};

var transient NanoFormation_Wall WallFormation;

enum EInventoryTypes
{	
	// !!!! add NEW entries below here !!!!
	WEAP_None,
	WEAP_MP7,
	WEAP_SUITCASE,
	// !!!! add NEW entries below here !!!!
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
	var class<Pawn> NanoPawnClass;
	var class<AIController> ControllerClass;
	var array<class<Inventory> > LoadoutClasses;

	/** Squad this AI should join */
	var() Name SquadName;
	var() bool bSquadLeader;
	/** Actor Tag to apply to spawned AI */
	var() Name ActorTag;

	/** Automatically acquire the nearest enemy after spawning */
	var() bool bAutoAcquireEnemy;
	/** Automatically notify enemies of spawn event */
	var() bool bAutoNotifyEnemy;

    var const int SetVersion;

	/** String displayed above any AI spawned from this set */
	var() string AutoDebugText;


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
			SpawnTotal=1;
			MaxAlive=1;
			bAssignMoveTarget=TRUE;
			bAutoAcquireEnemy=FALSE;
			bAutoNotifyEnemy=FALSE;
			SquadName=FName(TEXT("Alpha"));
		}
		FAISpawnInfo(ENativeConstructor)
		{
			InitToDefaults();
		}
	}

	structdefaultproperties
	{
		SpawnTotal=1
		MaxAlive=1
		bAssignMoveTarget=TRUE
		bAutoAcquireEnemy=FALSE
		bAutoNotifyEnemy=FALSE
		SquadName=Alpha
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

/** Should we Disable any further spawns? (this allows this AIFactory to be toggled on/off for spawning) */
var bool bDisableSpawns;

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
/** Is the move interruptible? */
var(Move) bool bMoveInterruptible;
/** For use with EA_Shared */
var int MoveTargetIdx;


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

cpptext
{
	virtual void PostLoad();

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/**
	 * This will set the hard references for this Factory.  We need to only have the enums be by name
	 * and then when the user chooses what to spawn then we set the reference so we don't have
	 * to have in memory every possible thing we can spawn (due to the hard references).
	 **/
	void SetTheHardReferences();

	virtual void UpdateDynamicLinks();

	virtual void Activated();
	virtual UBOOL UpdateOp(FLOAT DeltaTime);
	virtual void DeActivated();
	void ResetSpawnSets();
	void UpdateSpawnSets(FLOAT DeltaTime);
	AActor* PickSpawnPoint(FVector& SpawnExtent, FVector& SpawnLocation, FRotator& SpawnRotation, INanoInterface_Spawner** Spawner, INT& SpawnerSlotIdx, INT& SpawnPointIdx, UBOOL bSkipCollisionCheck = FALSE);

	/** If we are using a DoNotUse enum then we need to set it to a valid enum **/
	void RepairAITypeSetToDoNotUseEnum();

	/** Remove dead pawns from the watchlist */
	void RemoveDeadSpawnsFromWatchList();

	/**
	 * Called when a spawn is killed.  Increments the Death counter, removes the spawn from the watch list of the set
	 * and decrements the number of spawns to kill in the GRI.
	 * @SpawnSet - the spawn set of the spawn who died
	 * @WatchListIdx - the index in the WatchList array of the SpawnSet of the spawn who died
	 */
	void SpawnHasDied( FAISpawnInfo &SpawnSet, INT WatchListIdx );
}


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
	return Super.GetObjClassVersion() + 55;
}


native function NotifySpawnerDisabled(NanoSpawner Spawner);

native function NotifyCombatEntered();

static native function bool CanSpawnAtLocation(out vector ChkLocation, vector ChkExtent, Actor SpawnPointActor );



defaultproperties
{
	ObjName="AI Factory"
	ObjCategory="AI"

	TeleportDistance=4096.f
	TeleportZDistance=512.f
	ActivateDeadLinkCount=1

	bLatentExecution=TRUE
	bAutoActivateOutputLinks=FALSE

	InputLinks(0)=(LinkDesc="Spawn")
	InputLinks(1)=(LinkDesc="Abort Spawn") // never spawn anything from here again
	InputLinks(2)=(LinkDesc="Kill All")
	InputLinks(3)=(LinkDesc="Stop Spawning")  // stop spawning shizzle

	OutputLinks(0)=(LinkDesc="All Spawned")
	OutputLinks(1)=(LinkDesc="All Dead")
	OutputLinks(2)=(LinkDesc="Spawns Disabled",bHidden=TRUE)
	OutputLinks(3)=(LinkDesc="Spawned",bHidden=TRUE)
	OutputLinks(4)=(LinkDesc="# Dead",bHidden=TRUE)
	OutputLinks(5)=(LinkDesc="Entered Combat", bHidden=TRUE)

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Spawn Points",PropertyName=SpawnPoints)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Last Spawned",bHidden=TRUE)
	VariableLinks(2)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Spawned",bHidden=TRUE)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Int',LinkDesc="Num Dead",bWriteable=TRUE,bHidden=TRUE,PropertyName=NumDead)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Object',LinkDesc="Formation",bHidden=TRUE)

	SpawnInfo(AIType_MET_RiotCop)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_MetaCorp_RiotCop",TeamIdx=1)
	SpawnInfo(AIType_MET_AssassinationTarget)=(ControllerClassName="NanoAI_AssassinationTarget",PawnClassName="NanoPawn_MetaCorp_AssassinationTarget",TeamIdx=1)
	SpawnInfo(AIType_REB_King)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_Rebels_King",TeamIdx=0)
	SpawnInfo(AIType_MET_RiotCop_BulletProof)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_MetaCorp_RiotCop_BulletProof",TeamIdx=1)
	SpawnInfo(AIType_MET_TattlerBot)=(ControllerClassName="NanoAI_SentryBot",PawnClassName="NanoPawn_MetaCorp_SentryBot",TeamIdx=1)
	SpawnInfo(AIType_MET_RiotCop_Shield)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_MetaCorp_RiotCop_Shield",TeamIdx=1)
	SpawnInfo(AIType_MET_SkyPatrol)=(ControllerClassName="NanoAI_SkyPatrol",PawnClassName="NanoPawn_MetaCorp_SkywayPatrol",TeamIdx=1)
	SpawnInfo(AIType_MET_PacifierBot)=(ControllerClassName="NanoAI_PacifierBot",PawnClassName="NanoPawn_MetaCorp_PacifierBot",TeamIdx=1)	
	SpawnInfo(AIType_REB_ShopKeeper)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_Rebels_ShopKeeper",TeamIdx=0)
	SpawnInfo(AIType_MET_RiotCop_Captain)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_MetaCorp_RiotCop_Captain",TeamIdx=1)
	SpawnInfo(AIType_MET_BullRam)=(ControllerClassName="NanoAI_BullRam",PawnClassName="NanoPawn_MetaCorp_BullRam",TeamIdx=1)
	SpawnInfo(AIType_MET_TrooperWall)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_MetaCorp_RiotCop_BulletProof",TeamIdx=1)
	SpawnInfo(AIType_MET_OrbitalBot)=(ControllerClassName="NanoAI_OrbitalBot",PawnClassName="NanoPawn_MetaCorp_OrbitalBotBase",TeamIdx=1)	
	SpawnInfo(AIType_REB_Owen)=(ControllerClassName="NanoAI_Trooper",PawnClassName="NanoPawn_Rebels_Lyrik",TeamIdx=0)	
	SpawnInfo(AIType_REB_RabbleRouser)=(ControllerClassName="NanoGameContent.NanoAI_Rebels_RabbleRouser",PawnClassName="NanoGameContent.NanoPawn_Rebels_PublicRabbleRouser",TeamIdx=0)	
	

	bMoveInterruptible=TRUE
	
	InventoryTypeNames(WEAP_None)="None"
	InventoryTypeNames(WEAP_MP7)="NanoWeap_MP7"
    InventoryTypeNames(WEAP_SUITCASE)="NanoWeap_Suitcase"

}

