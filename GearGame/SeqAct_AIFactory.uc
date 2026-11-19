/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AIFactory extends SequenceAction
	native(Sequence);

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
	UBOOL SpawnAI(FAISpawnInfo &Set, AActor *SpawnPoint, FVector &SpawnLocation, FRotator &SpawnRotation, INT &SpawnerSlotIdx, INT &SetIdx);
	AActor* PickSpawnPoint(TArrayNoInit<AActor*> &SetSpawnPoints, FVector& SpawnExtent, FVector& SpawnLocation, FRotator& SpawnRotation, AGearSpawner** Spawner, INT& SpawnerSlotIdx, INT& SpawnPointIdx, UBOOL bSkipCollisionCheck = FALSE);

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

#if WITH_EDITOR
	virtual void CheckForErrors();
#endif

	virtual void Initialize();

	/** Functions used to handle kill watch events */
	void AddKillWatchEvent(USeqEvt_KillWatch* KillEvent);
	void NotifyKillWatchEventsOfSpawn();
	void NotifyKillWatchEventsOfDeath();

	//When a variable is connected
	virtual void OnVariableConnect(USequenceVariable *Var, INT LinkIdx);
	//When a variable is disconnected
	virtual void OnVariableDisconnect(USequenceVariable *Var, INT LinkIdx);
}

// @WARN - MT->DON'T REMOVE FROM THIS! it's not safe to remove entries from this list.  The indexes matter, and you end up breaking content..
enum EAITypes
{
	// !!!! add NEW entries at the end !!!!
	AIType_Drone,
	AIType_Wretch,
	AIType_Boomer,
	AIType_Berserker,
	AIType_Nemacyst,
	AIType_DarkWretch,
	AIType_Theron,
	AIType_Dom,
	AIType_Baird,
	AIType_Gus,
	AIType_Redshirt,
	AIType_SummerRedshirt,
	AIType_Serapede,
	AIType_DroneGrenadier,
	AIType_DroneSniper,
	AIType_HunterArmorNoGrenades,
	AIType_HunterNoArmorNoGrenades,
	AIType_Hoffman,
	AIType_TroikaGunner,
	AIType_TroikaSpotter,
	AIType_Carmine,
	AIType_NPCFranklin,
	AIType_NPCMaleWithHatAndBag,
	AIType_NPCMaleOld,
	AIType_NPCGirl,
	AIType_NPCMaleWithDoorag,
	AIType_NPCBoy,
	AIType_NPCWomanWithBun,
	AIType_NPCFemaleWithBackpackOfCans,
	AIType_NPCMaleWithHeadband,
	AIType_ReaverWithDrone,
	AIType_ReaverWithTheron,
	AIType_ReaverLowHealth,
	AIType_ReaverBig,
	AIType_NPCCOGMaleWithHatAndBag,
	AIType_Kantus,
	AIType_NPCCOGFranklinWithNoDreads,
	AIType_NPCCOGDrunkMan,
	AIType_NPCCOGManWithBandana,
	AIType_NPCCOGOldMan,
	AIType_AnyaUnarmed,
	AIType_UNUSED4,
	AIType_LambentDrudgeHeadWorm,
	AIType_Brumak,
	AIType_BoomerFlail,
	AIType_BoomerGatling,
	AIType_FlameDrone,
	AIType_PalaceGuard,
	AIType_BoomerFlame,
	AIType_ChiggerBomb,
	AIType_BloodMountWithDrone,
	AIType_NemaSlug,
	AIType_SecurityNemacyst,
	AIType_FlyingSecurityBot,
	AIType_Jack,
	AIType_TaiKaliso,
	AIType_BenjaminCarmine,
	AIType_Anya,
	AIType_Alyx,
	AIType_Dizzy,
	AIType_LocustBeastRider,
	AIType_LocustSpeedy,
	AIType_Ithycus,
	AIType_LocustLancerGuard,
	AIType_Brumak_Big,
	AIType_LocustGrapplingDrone,
	AIType_BloodMountRiderless,
	AIType_DroneNoHelmet,
	AIType_BoomerButcher,
	AIType_BoomerMechanic,
	AIType_BloodMountWithPalaceGuard,
	AIType_DroneMortar,
	AIType_Brumak_Kadar,
	AIType_ReaverNoGunner,
	AIType_Brumak_ResistSmallArms,
	AIType_MasterBoomer,
	AIType_Sam,
	AIType_LambentZerker,
	AIType_LambentPolyp,
	AIType_LambentGunk,
	AIType_LambentDrudge,
	AIType_LambentDrudgeMutant,
	AIType_LambentFormer,
	AIType_SavageDrone,
	AIType_SavageBoomer,
	AIType_KantusArmored,
	AIType_UnUsed1,
	AIType_SilverbackArmed,
	AIType_Stranded,
	AIType_FlameGuard,
	AIType_AdamFenix,
	AIType_SavageFlameDrone,
	AIType_Jace,
	AIType_Prescott,
	AIType_PrescottGuard,
	AIType_ClaytonCarmine,
	AIType_NakedTicker,
	AIType_Marcus,
	AIType_CorpserLarvaUnderground,
	AIType_SavageDroneNoSmoke,
	AIType_Myrrah,
	AIType_SilverbackLoader,
	AIType_SavageDroneSandstorm,
	AIType_BloodMountChaseWithDrone,
	AIType_BloodMountChaseWithFlameDrone,
	AIType_Tempest,
	AIType_LambentFormerFemale,
	AIType_ReaverDismountable,
	AIType_NPCRavensTrog,
	AIType_NPCRavensTums,
	AIType_NPCRavensHarry,
	AIType_NPCRavensFreckles,
	AIType_NPCRavensScarf,
	AIType_NPCRavensDark,
	AIType_LambentDrudgeMutantHorde,
	AIType_LambentLocustFormer,
	AIType_NakedTickerNoAmmoDrops,
	AIType_PalaceNinja,
	AIType_SavageDroneUndergroundSquad,
	AIType_NPCRavensBeardsly,
	AIType_NPCRavensMechanic,
	AIType_NPCRavensMechanic2,
	AIType_NPCRavensFreckles_Alt,
	AIType_NPCRavensRedPants,
	AIType_NPCRavensHoodie,
	AIType_NPCRavensOveralls,
	AIType_NPCRavensHoodieArmored,
	AIType_CorpserLarvaLockedUnderground,
	AIType_SavageTheron,
	AIType_GusStadium,
	AIType_SavageGrenadier,
	AIType_NakedTickerScavenger,
	AIType_BabyCorpser,
	AIType_MomCorpser,
	AIType_NakedCorpser,
	AIType_BabyCorpserBig,
	AIType_LambentGunkCloseQuarters,
	AIType_NPCChar_F_Dweller_1,
	AIType_NPCChar_F_Dweller_2,
	AIType_NPCChar_F_Goon_1,
	AIType_NPCChar_M_Ashman,
	AIType_NPCChar_M_Bouncer,
	AIType_NPCChar_M_Dweller_1,
	AIType_NPCChar_M_Dweller_2,
	AIType_NPCChar_M_Goon_1,
	AIType_NPCChar_M_Goon_2,
	AIType_ReaverWithPalaceGuard,
	AIType_TempestBoss,
	AIType_Nightmare_Hunter,
	AIType_Nightmare_Boomer,
	AIType_Nightmare_Reaver,
	AIType_Nightmare_FlameDrone,
	AIType_NPC_Chicken,
	AIType_NPC_Chicken_EasterEgg,
	AIType_NPCFortFemale1,
	AIType_NPCFortFemale2,
	AIType_NPCFortFemale3,
	AIType_NPCFortMale1,
	AIType_NPCFortMale2,
	AIType_NPCFortMale3,
	AIType_NPCFortMale4,
	AIType_Bernie,
	AIType_NPCHanoverFemale1,
	AIType_NPCHanoverFemale2,
	AIType_NPCHanoverFemale3,
	AIType_NPCHanoverFemale4,
	AIType_NPCHanoverFemale5,
	AIType_NPCHanoverMale1,
	AIType_NPCHanoverMale2,
	AIType_NPCHanoverMale3,
	AIType_NPCHanoverMale4,
	AIType_NPCHanoverMale5,
	AIType_ReaverWithTheronSmall,
	AIType_LambentDrudge_Stadium,
	AIType_SavageButcher,
	AIType_Griffin,
	AIType_Faraday,
	AIType_NPCMercySickGuyCompanion,
	AIType_ReaverWithDrone_Convoy,
	AIType_FlyingSecurityBot_Tempest,
	AIType_SavageTheronWithCleaver,
	AIType_KantusNoTickers,
	// !!!! add NEW entries below here (and when you do move this comment down ;) ) !!!!
};

enum EInventoryTypes
{
	WEAP_Lancer,
	WEAP_Gnasher,
	WEAP_Longshot,
	WEAP_Hammerburst,
	WEAP_Boltock,
	WEAP_Boomshot,
	WEAP_Snub,
	WEAP_TorqueBow,
	WEAP_HOD,
	WEAP_Mortar,
	WEAP_Minigun,
	WEAP_FragGrenade,
	WEAP_InkGrenade,
	WEAP_SmokeGrenade,
	WEAP_IncendiaryGrenade,
	WEAP_RetroLancer,
	WEAP_BurstPistol,
	WEAP_Flamethrower,
	WEAP_SawedOff,
	WEAP_Box,
	WEAP_GasTank,
	WEAP_Ripper,
	WEAP_Cleaver
};

/** Options for whether or not an AI can recharge health */
enum EHealthRechargeOptions
{
	RECHARGE_Default,
	RECHARGE_On,
	RECHARGE_Off,
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

	/** SpawnTotal override if 3 or 4 humans are in the game when the factory is first triggered (ignored if <= 0) */
	var() int SpawnTotal_3And4Coop;

	/** How many should be alive at any one point? */
	var() int MaxAlive;

	/** Threshold below which we need to begin respawning */
	var() int MinAlive;

	/** If true, will not spawn until we are below MinAlive */
	var transient bool bPostponeSpawn;

	/** Total number that have been spawned from this set */
	var int SpawnedCount;

	/** List of currently spawned */
	var array<Pawn> WatchList;

	/** Delay between spawns */
	var() float MaxSpawnDelay, MinSpawnDelay;

	/** Delay before initial spawn */
	var() float InitSpawnDelay;

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

	/** List of points to spawn AI at */
	var() array<Actor> SpawnPoints;

	/** Array of Gearspawns, supporting delayed spawns, that have been promised AIs to spawn */
	var transient array<GearSpawner> PromisedEntrances;

	/** Use the move targets? */
	var() bool bAssignMoveTarget;

	/** Use the cover groups? */
	var() bool bAssignCombatZones;

	// these are private vars which we store the actual hard reference to the
	// classes we need for this spawn
	var class<Pawn> GearPawnClass;
	var class<AIController> ControllerClass;
	var array<class<Inventory> > LoadoutClasses;

	/** Should this AI drop inventory on death? */
	var() bool bAllowInventoryDrops;

	/** Squad this AI should join */
	var() Name SquadName;
	var() bool bSquadLeader;
	/** Actor Tag to apply to spawned AI */
	var() Name ActorTag;
	/** Custom player name for spawned AI. Looks up localized name in GearGameContent.int under NPC_Names */
	var() Name PlayerNameLocalized;

	/** Automatically acquire the nearest enemy after spawning */
	var() bool bAutoAcquireEnemy;
	/** Automatically notify enemies of spawn event */
	var() bool bAutoNotifyEnemy;

	/** Force team to be COG */
	var() bool bForceTeamCOG;
	/** Force team to be Locust */
	var() bool bForceTeamLocust;

	/** Spawn only if coop */
	var() bool bSpawnOnlyIfCoop;

    var const int SetVersion;

	/** String displayed above any AI spawned from this set */
	var() string AutoDebugText;

	/** turn this on to disable this pawn from ever going DBNO */
	var() bool bDontAllowDBNO;

	/** turn this on to allow this pawn to be removed when it hasn't done anything useful in a long time */
	var() bool bAllowDeleteWhenStale;

	/** amount of time this AI can do nothing before he's deleted */
	var() float StaleTimeout;

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

	/** Whether or not to allow health recharging */
	var() EHealthRechargeOptions HealthRecharge;

	/** Location to shoot the spawned creature to (used when you want to have the creature shoot from the spawn location) */
	var() array<GearSpawnerDestination> SpawnDestinations;

	/** Maximum time to keep creature's ragdoll / gibs around after death, even if in view of the player */
	var() float CorpseMaxLifeSpan;

	/** Lambent Drudge: If true, this drudge can mutate multiple times */
	var() bool bDrudgeAllowMultipleMutations;
	/** Lambent Drudge: Chance of a head mutation occurring */
	var() float DrudgeHeadMutationChance;
	/** Lambent Drudge: Chance of an arms mutation occurring */
	var() float DrudgeArmsMutationChance;
	/** Lambent Drudge: Chance of a legs mutation occurring */
	var() float DrudgeLegsMutationChance;

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
			StaleTimeout=30.f;
			SpawnTotal=1;
			MaxAlive=1;
			MinAlive=-1;
			bPostponeSpawn=FALSE;
			bAssignMoveTarget=TRUE;
			bAssignCombatZones=TRUE;
			bAllowInventoryDrops=TRUE;
			bAutoAcquireEnemy=FALSE;
			bAutoNotifyEnemy=FALSE;
			SquadName=FName(TEXT("Alpha"));
			ShadowMode=LightShadow_Modulate;
			bDisableShadowCasting=FALSE;
			bDisableDeathScreams=FALSE;
			PlayIntialCombatReactionChance=0.5;
			HealthRecharge=RECHARGE_Default;
			bDrudgeAllowMultipleMutations=TRUE;
			CorpseMaxLifeSpan=20.f;
			DrudgeHeadMutationChance=0.34f;
			DrudgeArmsMutationChance=0.33f;
			DrudgeLegsMutationChance=0.33f;
		}
		FAISpawnInfo(ENativeConstructor)
		{
			InitToDefaults();
		}
	}

	structdefaultproperties
	{
		bAllowDeleteWhenStale=FALSE
		StaleTimeout=30.f
		SpawnTotal=1
		MaxAlive=1
		MinAlive=-1
		bPostponeSpawn=FALSE
		bAssignMoveTarget=TRUE
		bAssignCombatZones=TRUE
		bAllowInventoryDrops=TRUE
		bAutoAcquireEnemy=FALSE
		bAutoNotifyEnemy=FALSE
		SquadName=Alpha
		ShadowMode=LightShadow_Modulate
		bDisableShadowCasting=FALSE
		PlayIntialCombatReactionChance=0.5
		HealthRecharge=RECHARGE_Default
		bDrudgeAllowMultipleMutations=TRUE
		CorpseMaxLifeSpan=20.f
		DrudgeHeadMutationChance=0.34f
		DrudgeArmsMutationChance=0.33f
		DrudgeLegsMutationChance=0.33f
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

/** List of points to spawn AI at */
var(Spawn) array<GearSpawnerDestination> SpawnDestinations;

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
/** Number of dudes dead from this spawner as of last frame */
var int LastFrameDeadCount;
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

/** If true, use a line trace to determine if a spawn point should be used */
var() bool bStealthySpawn;

/** Used to set the bEnableEncroachCheckOnRagdoll flag on the spawned Pawn. */
var() bool bEnableEncroachCheckOnRagdoll;

/** Use damage for kill all instead of calling died directly */
var() bool bUseDamageForKillAll;

/** Prevents Combat Entered output from firing more than once */
var bool bEnteredCombat;
/** prevents SpawnTotal from being overridden from co-op values more than once */
var bool bInitializedSpawnTotal;

/** if the character spawned from this factory can be taken over by a human player, set the player slot for that here (1 to 4)
 * if set, this spawn should then be referenced by a Player variable with the same index so that it can keep track of the target
 * even if it swaps between human and AI control
 */
var() int PlayerSlotIdx;

/** List of kill watch events to be triggered as characters spawn and die */
var array<SeqEvt_KillWatch> KillWatchEventList;

native function NotifySpawnerDisabled(GearSpawner Spawner);
native function NotifyCombatEntered();

static native function bool CanSpawnAtLocation(out vector ChkLocation, vector ChkExtent, Actor SpawnPointActor, optional bool bUseCameraChecks );

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
	return Super.GetObjClassVersion() + 57;
}

/** called when we spawn a Pawn and PlayerSlotIndex > 0 - put the Pawn in the appropriate slot, giving any human in that slot control */
event AssignToPlayerSlot(GearPawn GP, name SquadName)
{
	local GearGameSP_Base SPGame;
	local Controller C;
	local Pawn OldPawn;
	local int RealPlayerIdx;

	SPGame = GearGameSP_Base(GetWorldInfo().Game);
	if (SPGame != None)
	{
		RealPlayerIdx = PlayerSlotIdx - 1; // since the LDs wanted 1-4
		SPGame.PlayerSlots[RealPlayerIdx].PawnClass = GP.Class;
		C = SPGame.PlayerSlots[RealPlayerIdx].Owner;
		if (AIController(C) != None)
		{
			// just destroy AI completely and let the factory spawn a new one
			if (C.Pawn != None)
			{
				C.Pawn.Destroy();
			}
			C.Destroy();
			SPGame.PlayerSlots[RealPlayerIdx].Owner = None; // native factory code will put new AI in
		}
		else if (GearPC(C) != None)
		{
			// get rid of old pawn
			OldPawn = C.Pawn;
			if (OldPawn != None)
			{
				C.UnPossess();
				OldPawn.Destroy();
			}

			// take over new one
			C.Possess(GP, false);
			GearPC(C).SetSquadName(SquadName);
			SPGame.SetPlayerDefaults(GP);

			// Reset client player rotation and camera
			GP.SetDesiredRotation(C.Rotation);
			C.ClientSetRotation(C.Rotation, TRUE);
		}
	}
}

/**
 * Accessor for adding to a SpawnSet's WatchList
 * @param WatchingSI - The spawn info that contains the watch list (is out param so we aren't copying the entire struct)
 * @param PawnToAdd - The pawn to add to the watch list
 */
native function AddPawnToSetWatchList(out AISpawnInfo WatchingSI, Pawn PawnToAdd);

/**
 * Accessor for adding to a SpawnSet's WatchList
 * @param SpawnInfoIdx - The index of the spawn info that contains the watch list
 * @param PawnToAdd - The pawn to add to the watch list
 */
native function AddPawnToSetWatchListByIndex(int SpawnInfoIdx, Pawn PawnToAdd);


defaultproperties
{
	ObjName="AI Factory"
	ObjCategory="AI"

	TeleportDistance=4096.f
	TeleportZDistance=512.f
	ActivateDeadLinkCount=1
	PlayerSlotIdx=-1

	bLatentExecution=TRUE
	bAutoActivateOutputLinks=FALSE

	InputLinks(0)=(LinkDesc="Spawn")
	InputLinks(1)=(LinkDesc="Abort Spawn")
	InputLinks(2)=(LinkDesc="Kill All")

	OutputLinks(0)=(LinkDesc="All Spawned")
	OutputLinks(1)=(LinkDesc="All Dead")
	OutputLinks(2)=(LinkDesc="Spawns Disabled",bHidden=TRUE)
	OutputLinks(3)=(LinkDesc="Spawned",bHidden=TRUE)
	OutputLinks(4)=(LinkDesc="# Dead",bHidden=TRUE)
	OutputLinks(5)=(LinkDesc="Entered Combat", bHidden=TRUE)
	OutputLinks(6)=(LinkDesc="Died",bHidden=TRUE)

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Spawn Points",PropertyName=SpawnPoints)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Last Spawned",bHidden=TRUE)
	VariableLinks(2)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Spawned",bHidden=TRUE)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Int',LinkDesc="Num Dead",bWriteable=TRUE,bHidden=TRUE,PropertyName=NumDead)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Int',LinkDesc="Player Slot",bHidden=TRUE,PropertyName=PlayerSlotIdx)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Object',LinkDesc="Spawn Destinations",bHidden=TRUE,PropertyName=SpawnDestinations)

	EventLinks(0)=(LinkDesc="KillWatch",ExpectedType=class'SeqEvt_KillWatch')

	SpawnInfo(AIType_Drone)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_LocustDrone",TeamIdx=1)
	SpawnInfo(AIType_Boomer)=(ControllerClassName="GearAI_Boomer",PawnClassName="GearPawn_LocustBoomer",TeamIdx=1)
	SpawnInfo(AIType_BoomerFlail)=(ControllerClassName="GearAI_Boomer_Shield",PawnClassName="GearPawn_LocustBoomerFlail",TeamIdx=1)
	SpawnInfo(AIType_BoomerGatling)=(ControllerClassName="GearAI_Boomer_Gatling",PawnClassName="GearPawn_LocustBoomerGatling",TeamIdx=1)
	SpawnInfo(AIType_BoomerFlame)=(ControllerClassName="GearAI_Boomer_Flame",PawnClassName="GearPawn_LocustBoomerFlame",TeamIdx=1)
	SpawnInfo(AIType_BoomerButcher)=(ControllerClassName="GearAI_Boomer_Melee",PawnClassName="GearPawn_LocustBoomerButcher",TeamIdx=1)
	SpawnInfo(AIType_BoomerMechanic)=(ControllerClassName="GearAI_Boomer_Melee",PawnClassName="GearPawn_LocustBoomerMechanic",TeamIdx=1)

	SpawnInfo(AIType_Berserker)=(ControllerClassName="GearAI_Berserker",PawnClassName="GearPawn_LocustBerserker",TeamIdx=1)
	SpawnInfo(AIType_Nemacyst)=(ControllerClassName="GearAI_Nemacyst",PawnClassName="GearPawn_LocustNemacyst",TeamIdx=1)
	SpawnInfo(AIType_Theron)=(ControllerClassName="GearAI_Theron",PawnClassName="GearPawn_LocustTheron",TeamIdx=1)
	SpawnInfo(AIType_PalaceGuard)=(ControllerClassName="GearAI_Theron",PawnClassName="GearPawn_LocustPalaceGuard",TeamIdx=1)
	SpawnInfo(AIType_PalaceNinja)=(ControllerClassName="GearAI_Theron",PawnClassName="GearPawn_LocustPalaceGuard",TeamIdx=1)
	SpawnInfo(AIType_FlameGuard)=(ControllerClassName="GearAI_FlameDrone",PawnClassName="GearPawn_LocustFlameGuard",TeamIdx=1)
	SpawnInfo(AIType_Kantus)=(ControllerClassName="GearAI_Kantus",PawnClassName="GearPawn_LocustKantus",TeamIdx=1)
	SpawnInfo(AIType_KantusNoTickers)=(ControllerClassName="GearAI_KantusNoTickers",PawnClassName="GearPawn_LocustKantus",TeamIdx=1)

	SpawnInfo(AIType_Wretch)=(ControllerClassName="GearAI_Wretch",PawnClassName="GearPawn_LocustWretch",TeamIdx=1)
	SpawnInfo(AIType_DarkWretch)=(ControllerClassName="GearAI_Wretch",PawnClassName="GearPawn_LocustDarkWretch",TeamIdx=2)
	SpawnInfo(AIType_ChiggerBomb)=(ControllerClassName="GearAI_Ticker",PawnClassName="GearPawn_LocustTicker",TeamIdx=1)

	SpawnInfo(AIType_Marcus)=(ControllerClassName="GearAI_Marcus",PawnClassName="GearPawn_COGMarcus",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Dom)=(ControllerClassName="GearAI_Dom",PawnClassName="GearPawn_COGDom",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Gus)=(ControllerClassName="GearAI_Gus",PawnClassName="GearPawn_COGGus",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_GusStadium)=(ControllerClassName="GearAI_Gus",PawnClassName="GearPawn_COGGusStadium",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Baird)=(ControllerClassName="GearAI_Baird",PawnClassName="GearPawn_COGBaird",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Dizzy)=(ControllerClassName="GearAI_Dizzy",PawnClassName="GearPawn_COGDizzy",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Redshirt)=(ControllerClassName="GearAI_Dom",PawnClassName="GearPawn_COGRedShirt",TeamIdx=0)
	SpawnInfo(AIType_SummerRedshirt)=(ControllerClassName="GearAI_Dom",PawnClassName="GearPawn_COGSummerRedshirt",TeamIdx=0)
	SpawnInfo(AIType_Carmine)=(ControllerClassName="GearAI_Carmine",PawnClassName="GearPawn_COGBenjaminCarmine",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_BenjaminCarmine)=(ControllerClassName="GearAI_Carmine",PawnClassName="GearPawn_COGBenjaminCarmine",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_TaiKaliso)=(ControllerClassName="GearAI_Tai",PawnClassName="GearPawn_COGTai",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Sam)=(ControllerClassName="GearAI_Sam",PawnClassName="GearPawn_COGSam",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Hoffman)=(ControllerClassName="GearAI_Hoffman",PawnClassName="GearPawn_COGHoffman",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_AdamFenix)=(ControllerClassName="GearAI_NPCUnarmed",PawnClassName="GearPawn_COGAdamFenix",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Jace)=(ControllerClassName="GearAI_Jace",PawnClassName="GearPawn_COGJace",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Prescott)=(ControllerClassName="GearAI_COGGear",PawnClassName="GearPawn_COGPrescott",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_PrescottGuard)=(ControllerClassName="GearAI_COGGear",PawnClassName="GearPawn_COGOnyxGuard",TeamIdx=0)
	SpawnInfo(AIType_ClaytonCarmine)=(ControllerClassName="GearAI_Carmine",PawnClassName="GearPawn_CCarmine",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Anya)=(ControllerClassName="GearAI_Anya",PawnClassName="GearPawn_COGAnya",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Alyx)=(ControllerClassName="GearAI_Alyx",PawnClassName="GearPawn_COGAlyx",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Bernie)=(ControllerClassName="GearAI_Bernie",PawnClassName="GearPawn_COGBernie",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_Griffin)=(ControllerClassName="GearAI_COGGear",PawnClassName="GearPawn_NPCGriffin",TeamIdx=0,bUnique=true)
	SpawnInfo(AIType_Faraday)=(ControllerClassName="GearAI_COGGear",PawnClassName="GearPawn_NPCFaraday",TeamIdx=0,bUnique=true)

	SpawnInfo(AIType_DroneSniper)=(ControllerClassName="GearAI_Locust",PawnClassName="GearPawn_LocustSniper",TeamIdx=1)

	// can modify GearAI_Hunter into different types to have different strategies based on visuals maybe :-)
	SpawnInfo(AIType_DroneGrenadier)=(ControllerClassName="GearAI_Hunter",PawnClassName="GearPawn_LocustHunterArmorNoGrenades",TeamIdx=1)
	SpawnInfo(AIType_HunterArmorNoGrenades)=(ControllerClassName="GearAI_Hunter",PawnClassName="GearPawn_LocustHunterArmorNoGrenades",TeamIdx=1)
	SpawnInfo(AIType_HunterNoArmorNoGrenades)=(ControllerClassName="GearAI_Hunter",PawnClassName="GearPawn_LocustHunterNoArmorNoGrenades",TeamIdx=1)
	SpawnInfo(AIType_FlameDrone)=(ControllerClassName="GearAI_FlameDrone",PawnClassName="GearPawn_LocustFlameDrone",TeamIdx=1)



	SpawnInfo(AIType_TroikaGunner)=(ControllerClassName="GearAI_Locust",PawnClassName="GearPawn_LocustTroikaGunner",TeamIdx=1)
	SpawnInfo(AIType_TroikaSpotter)=(ControllerClassName="GearAI_Locust",PawnClassName="GearPawn_LocustTroikaSpotter",TeamIdx=1)

	SpawnInfo(AIType_AnyaUnarmed)=(ControllerClassName="GearAI_NPCUnarmed",PawnClassName="GearPawn_COGAnyaUnarmed",TeamIdx=0,bUnique=TRUE)
	SpawnInfo(AIType_NPCFranklin)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCFranklin",TeamIdx=0)
	SpawnInfo(AIType_NPCMaleWithHatAndBag)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCMaleWithHatAndBag",TeamIdx=0)
	SpawnInfo(AIType_NPCMaleOld)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCMaleOld",TeamIdx=0)
	SpawnInfo(AIType_NPCGirl)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCGirl",TeamIdx=0)
	SpawnInfo(AIType_NPCMaleWithDoorag)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCMaleWithDoorag",TeamIdx=0)
	SpawnInfo(AIType_NPCBoy)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCBoy",TeamIdx=0)
	SpawnInfo(AIType_NPCWomanWithBun)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCWomanWithBun",TeamIdx=0)
	SpawnInfo(AIType_NPCFemaleWithBackpackOfCans)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCFemaleWithBackpackOfCans",TeamIdx=0)
	SpawnInfo(AIType_NPCMaleWithHeadband)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCMaleWithHeadband",TeamIdx=0)

	SpawnInfo(AIType_ReaverWithDrone)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverWithDrone",TeamIdx=1)
	SpawnInfo(AIType_ReaverWithTheron)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverWithTheron",TeamIdx=1)
	SpawnInfo(AIType_ReaverWithPalaceGuard)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverWithPalaceGuard",TeamIdx=1)
	SpawnInfo(AIType_ReaverNoGunner)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverNoGunner",TeamIdx=1)
	SpawnInfo(AIType_ReaverLowHealth)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverLowHealth",TeamIdx=1)
	SpawnInfo(AIType_ReaverBig)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverBig",TeamIdx=1)
	SpawnInfo(AIType_ReaverDismountable)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverDismountable",TeamIdx=1)
	SpawnInfo(AIType_ReaverWithTheronSmall)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_ReaverWithTheronSmall",TeamIdx=1)
	SpawnInfo(AIType_ReaverWithDrone_Convoy)=(ControllerClassName="GearAI_Reaver_Convoy",PawnClassName="Vehicle_Reaver_Convoy",TeamIdx=1)
	SpawnInfo(AIType_Ithycus)=(ControllerClassName="GearAI_Ithycus",PawnClassName="GearPawn_LocustIthycus",TeamIdx=1)

	SpawnInfo(AIType_NPCCOGMaleWithHatAndBag)=(ControllerClassName="GearAI_NPCCOG",PawnClassName="GearPawn_NPCCOGMaleWithHatAndBag",TeamIdx=0)

	SpawnInfo(AIType_NPCCOGFranklinWithNoDreads)=(ControllerClassName="GearAI_NPCCOG",PawnClassName="GearPawn_NPCCOGFranklinWithNoDreads",TeamIdx=0)
	SpawnInfo(AIType_NPCCOGDrunkMan)=(ControllerClassName="GearAI_NPCCOG",PawnClassName="GearPawn_NPCCOGDrunkMan",TeamIdx=0)
	SpawnInfo(AIType_NPCCOGManWithBandana)=(ControllerClassName="GearAI_NPCCOG",PawnClassName="GearPawn_NPCCOGManWithBandana",TeamIdx=0)
	SpawnInfo(AIType_NPCCOGOldMan)=(ControllerClassName="GearAI_NPCCOG",PawnClassName="GearPawn_NPCCOGOldMan",TeamIdx=0,bUnique=TRUE)

	SpawnInfo(AIType_Brumak)=(ControllerClassName="GearAI_Brumak",PawnClassName="GearPawn_LocustBrumak",TeamIdx=1)
	SpawnInfo(AIType_Brumak_Big)=(ControllerClassName="GearAI_Brumak",PawnClassName="GearPawn_LocustBrumak_Big",TeamIdx=1)
	SpawnInfo(AIType_Brumak_Kadar)=(ControllerClassName="GearAI_Brumak_Kadar",PawnClassName="GearPawn_LocustBrumak",TeamIdx=1)
	SpawnInfo(AIType_Brumak_ResistSmallArms)=(ControllerClassName="GearAI_Brumak",PawnClassName="GearPawn_LocustBrumak_ResistSmallArms",TeamIdx=1)

	SpawnInfo(AIType_BloodMountWithDrone)=(ControllerClassName="GearAI_Bloodmount",PawnClassname="GearPawn_LocustBloodMountWithDrone",TeamIdx=1)
	SpawnInfo(AIType_BloodMountRiderless)=(ControllerClassName="GearAI_Bloodmount",PawnClassname="GearPawn_LocustBloodMountRiderless",TeamIdx=1)
	SpawnInfo(AIType_BloodMountWithPalaceGuard)=(ControllerClassName="GearAI_Bloodmount",PawnClassname="GearPawn_LocustBloodMountWithPalaceGuard",TeamIdx=1)
	SpawnInfo(AIType_BloodMountChaseWithDrone)=(ControllerClassName="GearAI_BloodmountChase",PawnClassname="GearPawn_LocustBloodMountWithDrone",TeamIdx=1)
	SpawnInfo(AIType_BloodMountChaseWithFlameDrone)=(ControllerClassName="GearAI_BloodmountChase",PawnClassname="GearPawn_LocustBloodMountWithFlameDrone",TeamIdx=1)

	SpawnInfo(AIType_Serapede)=(ControllerClassName="GearAI_Serapede",PawnClassName="GearPawn_LocustSerapede",TeamIdx=1)

	SpawnInfo(AIType_NemaSlug)=(ControllerClassname="GearAI_NemaSlug",PawnClassName="GearPawn_LocustNemaSlug",TeamIdx=1)

	SpawnInfo(AIType_SecurityNemacyst)=(ControllerClassname="GearAI_SecurityNemacyst",PawnClassName="GearPawn_LocustSecurityNemacyst",TeamIdx=1)
	SpawnInfo(AIType_FlyingSecurityBot)=(ControllerClassname="GearAI_SecurityBotFlying",PawnClassName="GearPawn_SecurityBotFlying",TeamIdx=1)
	SpawnInfo(AIType_FlyingSecurityBot_Tempest)=(ControllerClassname="GearAI_SecurityBotFlying",PawnClassName="GearPawn_SecurityBotFlying_Tempest",TeamIdx=1)

	SpawnInfo(AIType_Jack)=(ControllerClassname="GearAI_Jack",PawnClassName="Vehicle_Jack",TeamIdx=0,bUnique=TRUE)


	SpawnInfo(AIType_LocustSpeedy)=(ControllerClassName="GearAI_Speedy",PawnClassName="GearPawn_LocustSpeedy",TeamIdx=1)
	SpawnInfo(AIType_LocustBeastRider)=(ControllerClassName="GearAI_Hunter",PawnClassName="GearPawn_LocustBeastRider",TeamIdx=1)
	SpawnInfo(AIType_LocustLancerGuard)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_LocustLancerGuard",TeamIdx=1)
	SpawnInfo(AIType_LocustGrapplingDrone)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_LocustGrapplingDrone",TeamIdx=1)
	SpawnInfo(AIType_Myrrah)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_LocustMyrrah",TeamIdx=1,bUnique=TRUE)

	SpawnInfo(AIType_DroneNoHelmet)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_LocustDroneNoHelmet",TeamIdx=1)

	SpawnInfo(AIType_DroneMortar)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_LocustDroneMortar",TeamIdx=1)

	SpawnInfo(AIType_LambentZerker)=(ControllerClassName="GearAI_BerserkerLambent",PawnClassName="GearPawn_LocustBerserkerLambent",TeamIdx=2)
	SpawnInfo(AIType_LambentPolyp)=(ControllerClassName="GearAI_LambentPolyp",PawnClassName="GearPawn_LambentPolyp",TeamIdx=2)
	SpawnInfo(AIType_LambentGunk)=(ControllerClassName="GearAI_Gunker",PawnClassName="GearPawn_LocustGunker",TeamIdx=2)
	SpawnInfo(AIType_LambentGunkCloseQuarters)=(ControllerClassName="GearAI_GunkerCloseQuarters",PawnClassName="GearPawn_LocustGunker_CloseQuarters",TeamIdx=2)
	SpawnInfo(AIType_LambentDrudge)=(ControllerClassName="GearAI_LambentDrone",PawnClassName="GearPawn_LambentDrone",TeamIdx=2)
	SpawnInfo(AIType_LambentDrudge_Stadium)=(ControllerClassName="GearAI_LambentDrone",PawnClassName="GearPawn_LambentDrone_Stadium",TeamIdx=2)
	SpawnInfo(AIType_LambentDrudgeMutant)=(ControllerClassName="GearAI_LambentDrudge",PawnClassName="GearPawn_Drudge",TeamIdx=2)
	SpawnInfo(AIType_LambentDrudgeMutantHorde)=(ControllerClassName="GearAI_LambentDrudge",PawnClassName="GearPawn_DrudgePolypSpawning",TeamIdx=2)
	SpawnInfo(AIType_LambentDrudgeHeadWorm)=(ControllerClassName="GearAI_DrudgeHeadWorm",PawnClassName="GearPawn_DrudgeHeadWorm",TeamIdx=2)
	SpawnInfo(AIType_LambentFormer)=(ControllerClassName="GearAI_LambentHuman",PawnClassName="GearPawn_LambentHuman",TeamIdx=2)
	SpawnInfo(AIType_LambentFormerFemale)=(ControllerClassName="GearAI_LambentHuman",PawnClassName="GearPawn_LambentHumanFemale",TeamIdx=2)
	SpawnInfo(AIType_LambentLocustFormer)=(ControllerClassName="GearAI_Locust",PawnClassName="GearPawn_LambentLocustFormer",TeamIdx=2)

	SpawnInfo(AIType_SavageDrone)=(ControllerClassName="GearAI_SavageDrone",PawnClassName="GearPawn_LocustDroneSavage",TeamIdx=1)
	SpawnInfo(AIType_SavageDroneUndergroundSquad)=(ControllerClassName="GearAI_SavageDroneUnderground",PawnClassName="GearPawn_LocustDroneSavageUnderground",TeamIdx=1)
	SpawnInfo(AIType_SavageFlameDrone)=(ControllerClassName="GearAI_FlameDrone",PawnClassName="GearPawn_LocustFlameDrone",TeamIdx=1)
	SpawnInfo(AIType_SavageBoomer)=(ControllerClassName="GearAI_Boomer",PawnClassName="GearPawn_LocustBoomerSavage",TeamIdx=1)
	SpawnInfo(AIType_SavageButcher)=(ControllerClassName="GearAI_Boomer_Melee",PawnClassName="GearPawn_LocustBoomerSavageButcher",TeamIdx=1)

	// These used to be savage drone variants. Keeping this around to avoid breaking content
	SpawnInfo(AIType_SavageDroneSandstorm)=(ControllerClassName="GearAI_SavageDrone",PawnClassName="GearPawn_LocustDroneSavage",TeamIdx=1)
	SpawnInfo(AIType_SavageDroneNoSmoke)=(ControllerClassName="GearAI_SavageDrone",PawnClassName="GearPawn_LocustDroneSavageNoSmoke",TeamIdx=1)

	SpawnInfo(AIType_KantusArmored)=(ControllerClassName="GearAI_KantusArmor",PawnClassName="GearPawn_LocustKantusArmor",TeamIdx=1)
	SpawnInfo(AIType_CorpserLarvaUnderground)=(ControllerClassName="GearAI_CorpserLarvaUnderground",PawnClassName="GearPawn_LocustCorpserLarvaUndergroundContent",TeamIdx=1)
	SpawnInfo(AIType_CorpserLarvaLockedUnderground)=(ControllerClassName="GearAI_CorpserLarvaUnderground",PawnClassName="GearPawn_LocustCorpserLarvaLockedUndergroundContent",TeamIdx=1)
	SpawnInfo(AIType_SilverbackArmed)=(ControllerClassName="",PawnClassName="GearPawn_COGSilverbackArmed",TeamIdx=0)
	SpawnInfo(AIType_SilverbackLoader)=(ControllerClassName="",PawnClassName="GearPawn_COGSilverbackLoader",TeamIdx=0)
	SpawnInfo(AIType_NakedTicker)=(ControllerClassName="GearAI_NakedTicker",PawnClassName="GearPawn_LocustNakedTicker",TeamIdx=1)
	SpawnInfo(AIType_NakedTickerNoAmmoDrops)=(ControllerClassName="GearAI_NakedTicker",PawnClassName="GearPawn_LocustNakedTickerNoAmmo",TeamIdx=1)
	SpawnInfo(AIType_NakedTickerScavenger)=(ControllerClassName="GearAI_NakedTickerScavenger",PawnClassName="GearPawn_LocustNakedTicker",TeamIdx=1)

	SpawnInfo(AIType_NPCRavensTrog)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensTrog",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensTums)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensTumsy",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensHarry)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensHarry",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensFreckles)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensFreckles",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensScarf)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensScarf",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensDark)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensDark",TeamIdx=0)

	SpawnInfo(AIType_NPCRavensBeardsly)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensBeardsly",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensMechanic)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensMechanic",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensMechanic2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensMechanic2",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensFreckles_Alt)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensFrecklesAlt",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensRedPants)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensRedPants",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensHoodie)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensHoodie",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensOveralls)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensOveralls",TeamIdx=0)
	SpawnInfo(AIType_NPCRavensHoodieArmored)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCRavensHoodieArmored",TeamIdx=0)

	SpawnInfo(AIType_NPCHanoverFemale1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverFemale1",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverFemale2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverFemale2",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverFemale3)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverFemale3",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverFemale4)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverFemale4",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverFemale5)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverFemale5",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverMale1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverMale1",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverMale2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverMale2",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverMale3)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverMale3",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverMale4)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverMale4",TeamIdx=0)
	SpawnInfo(AIType_NPCHanoverMale5)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCHanoverMale5",TeamIdx=0)

	SpawnInfo(AIType_NPCFortFemale1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortFemale1",TeamIdx=0)
	SpawnInfo(AIType_NPCFortFemale2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortFemale2",TeamIdx=0)
	SpawnInfo(AIType_NPCFortFemale3)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortFemale3",TeamIdx=0)
	SpawnInfo(AIType_NPCFortMale1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortMale1",TeamIdx=0)
	SpawnInfo(AIType_NPCFortMale2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortMale2",TeamIdx=0)
	SpawnInfo(AIType_NPCFortMale3)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortMale3",TeamIdx=0)
	SpawnInfo(AIType_NPCFortMale4)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCFortMale4",TeamIdx=0)


	SpawnInfo(AIType_NPCChar_F_Dweller_1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_F_Dweller_1",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_F_Dweller_2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_F_Dweller_2",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_F_Goon_1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_F_Goon_1",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_M_Ashman)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_M_Ashman",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_M_Bouncer)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_M_Bouncer",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_M_Dweller_1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_M_Dweller_1",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_M_Dweller_2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_M_Dweller_2",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_M_Goon_1)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_M_Goon_1",TeamIdx=0)
	SpawnInfo(AIType_NPCChar_M_Goon_2)=(ControllerClassName="GearAI_NPCCog",PawnClassName="GearPawn_NPCChar_M_Goon_2",TeamIdx=0)

	SpawnInfo(AIType_NPCMercySickGuyCompanion)=(ControllerClassName="GearAI_NPC",PawnClassName="GearPawn_NPCMercySickGuyCompanion",TeamIdx=0)

	SpawnInfo(AIType_Stranded)=(ControllerClassName="GearAI_Stranded",PawnClassName="GearPawn_Stranded",TeamIdx=0)

	SpawnInfo(AIType_Tempest)=(ControllerClassName="GearAI_LocustTempest",PawnClassName="GearPawn_LocustTempest",TeamIdx=1)
	SpawnInfo(AIType_TempestBoss)=(ControllerClassName="GearAI_LocustTempest",PawnClassName="GearPawn_LocustTempestBoss",TeamIdx=1)

	SpawnInfo(AIType_SavageTheron)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_SavageTheron",TeamIdx=1)
	SpawnInfo(AIType_SavageGrenadier)=(ControllerClassName="GearAI_Hunter",PawnClassName="GearPawn_LocustHunterSavageFlame",TeamIdx=1)
	SpawnInfo(AIType_SavageTheronWithCleaver)=(ControllerClassName="GearAI_LocustDrone",PawnClassName="GearPawn_SavageTheronWithCleaver",TeamIdx=1)

	SpawnInfo(AIType_BabyCorpser)=(ControllerClassName="GearAI_BabyCorpser",PawnClassName="GearPawn_LocustBabyCorpser",TeamIdx=1)
	SpawnInfo(AIType_MomCorpser)=(ControllerClassName="GearAI_MomCorpser",PawnClassName="GearPawn_LocustMomCorpser",TeamIdx=1)
	SpawnInfo(AIType_BabyCorpserBig)=(ControllerClassName="GearAI_BabyCorpser",PawnClassName="GearPawn_LocustBabyCorpserBig",TeamIdx=1)
	SpawnInfo(AIType_NakedCorpser)=(ControllerClassName="GearAI_CorpserLarvaUnderground",PawnClassName="GearPawn_LocustCorpserLarvaUndergroundNakedContent",TeamIdx=1)

	SpawnInfo(AIType_Nightmare_Hunter)=(ControllerClassName="GearAI_Hunter",PawnClassName="GearPawn_LocustHunterNoArmorNoGrenades_Nightmare",TeamIdx=1)
	SpawnInfo(AIType_Nightmare_Boomer)=(ControllerClassName="GearAI_Boomer",PawnClassName="GearPawn_LocustBoomer_Nightmare",TeamIdx=1)
	SpawnInfo(AIType_Nightmare_Reaver)=(ControllerClassName="GearAI_Reaver",PawnClassName="Vehicle_Reaver_Nightmare",TeamIdx=1)
	SpawnInfo(AIType_Nightmare_FlameDrone)=(ControllerClassName="GearAI_FlameDrone",PawnClassName="GearPawn_LocustFlameDrone_Nightmare",TeamIdx=1)

	SpawnInfo(AIType_NPC_Chicken)=(ControllerClassName="GearAI_Chicken",PawnClassName="GearPawn_Chicken",TeamIdx=254)
	SpawnInfo(AIType_NPC_Chicken_EasterEgg)=(ControllerClassName="GearAI_Chicken",PawnClassName="GearPawn_Chicken_Attack",TeamIdx=254)

	bMoveInterruptable=TRUE

	InventoryTypeNames(WEAP_Lancer)="GearWeap_AssaultRifle"
	InventoryTypeNames(WEAP_Gnasher)="GearWeap_Shotgun"
	InventoryTypeNames(WEAP_Longshot)="GearWeap_SniperRifle"
	InventoryTypeNames(WEAP_Hammerburst)="GearWeap_LocustAssaultRifle"
	InventoryTypeNames(WEAP_Boltock)="GearWeap_LocustPistol"
	InventoryTypeNames(WEAP_Boomshot)="GearGame.GearWeap_Boomshot"
	InventoryTypeNames(WEAP_Snub)="GearWeap_COGPistol"
	InventoryTypeNames(WEAP_TorqueBow)="GearGame.GearWeap_Bow"
	InventoryTypeNames(WEAP_HOD)="GearGameContentWeapons.GearWeap_HOD"
	InventoryTypeNames(WEAP_Mortar)="GearGameContentWeapons.GearWeap_HeavyMortar"
	InventoryTypeNames(WEAP_Minigun)="GearGameContentWeapons.GearWeap_HeavyMiniGun"
	InventoryTypeNames(WEAP_FragGrenade)="GearWeap_FragGrenade"
	InventoryTypeNames(WEAP_RetroLancer)="GearWeap_RetroLancer"
	InventoryTypeNames(WEAP_BurstPistol)="GearGameContentWeapons.GearWeap_LocustBurstPistol"
	InventoryTypeNames(WEAP_Flamethrower)="GearGameContentWeapons.GearWeap_FlameThrower"
	InventoryTypeNames(WEAP_SawedOff)="GearWeap_Shotgun_SawedOff"
	InventoryTypeNames(WEAP_Box)="GearGameContent.GearWeap_Box"
	InventoryTypeNames(WEAP_GasTank)="GearGameContent.GearWeap_GasTank"
	InventoryTypeNames(WEAP_InkGrenade)="GearGameContentWeapons.GearWeap_InkGrenade"
	InventoryTypeNames(WEAP_SmokeGrenade)="GearWeap_SmokeGrenade"
	InventoryTypeNames(WEAP_IncendiaryGrenade)="GearGameContentWeapons.GearWeap_IncendiaryGrenade"
	InventoryTypeNames(WEAP_Ripper)="GearGameContentWeapons.GearWeap_Ripper_Content"
	InventoryTypeNames(WEAP_Cleaver)="GearGameContentWeapons.GearWeap_Cleaver"
}

