/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPRI extends PlayerReplicationInfo
	config(Pawn)
	native
	nativereplication;

/** Logging pre-processor macros */
/** GoW global macros */
`include( GearGame\GearStats.uci )

/** Natively, the GearPRI monitors it's pawn and adjusts it's PlayerStatus as needed. */
enum EGearPlayerStatus
{
	WPS_Spectating,		// Controller is spectating
	WPS_Alive,			// Controller is alive and in the world
	WPS_Down,			// Controller is down but not dead
	WPS_Dead,			// controller is dead
	WPS_Respawning,		// controller is respawning
};

var EGearPlayerStatus PlayerStatus;

/** This is pretty ugly.  At the end of the round, since all players are killed and the PC is returned to
    the spectating status we have to store off a second copy of their status before getting killed so the
    scoreboard can be correct.  This get's set in GearGameTDM.KillRemainingPlayers() */

var EGearPlayerStatus EndOfRoundPlayerStatus;

/** Is this player dead? */
var repnotify bool bIsDead;

/** Is the player the team leader (for gametypes like kill the leader */
var bool bIsLeader;

/** definitive record of tags collected is stored in GearProfileSettings */
var int NumberOfCOGTagsCollected;

/** point values for various actions against this player
 * defaults are copied from the GameInfo, but a copy exists here so the game/mutators can have per-player/monster values
 */
var float PointsFor_TakeDowns, PointsFor_Executions, PointsFor_InstantKills, PointsFor_Revives, PointsFor_DamagePct, PointsFor_SpottedKill;

/** List of players who have damaged this player */
struct native PlayerDamageInfo
{
	var GearPRI PRI;
	var float DamageTotal;
};
var array<PlayerDamageInfo> PlayerDamageList;

/** List of players who have killed this player */
struct native PlayerKillInfo
{
	var PlayerReplicationInfo PRI;
	var int KillCount;
	var float LastKillTime;
};
var array<PlayerKillInfo> PlayerKillList;

/** Only allow one nemesis per match */
var transient PlayerReplicationInfo CurrentNemesis;

/** Name of the squad this player belongs to. */
var Name SquadName;
var bool bSquadLeader;

/** Should this player always appear in TacCom for its team regardless of squad? */
var bool bForceShowInTaccom;

/** Pawn class used */
var repnotify class<GearPawn> PawnClass;
/** Weapon selection, 0 == Lancer, 1 == HB */
var	byte	InitialPrimaryWeaponType;
var	byte	InitialSecondaryWeaponType;

var bool bHostIsReady;

/** Whether this PRI is talking in voice chat */
var bool bIsTalking;

/** The last time this PRI talked in voice chat */
var float LastTalkTime;

///////// PROFILE SETTINGS ///////////
/** This will determine whether or not we show gore.  This will be set from the Player' ProfileSettings. **/
var bool bShowGore;
/** This will determine whether or not we show the HUD.  This will be set from the Player' ProfileSettings. **/
var bool bShowHUD;
/** This will determine if the HUD always draws the weapon indicator in the hud (except in cines and other crazy places **/
var bool bAlwaysDrawWeaponIndicatorInHUD;
/** Determines if trigger controls should be flipped */
var EGearTriggerConfigOpts TrigConfig;
/** Determines if there are modifications to default controls */
var EGearStickConfigOpts	  StickConfig;

/** Index to the preferred COG character for versus */
var int PreferredCOGIndex;
/** Index to the preferred Locuat character for versus */
var int PreferredLocustIndex;
/** Determines if we show the tooltip pictograms */
var bool bShowPictograms;
/** The current sensitivity level of the controller */
var EProfileControllerSensitivityOptions ControllerSensitivityConfig;
/** The current sensitivity level for targetting */
var EProfileControllerSensitivityOptions TargetSensitivityConfig;
/** The current sensitivity level for zooming */
var EProfileControllerSensitivityOptions ZoomSensitivityConfig;
/** Whether the player receives the team bonus multiplier for scoring (for CombatTrials) */
var bool bReceivesTeamScoringBonus;

/** struct to store inventory that we would like to persist from one round to another in MP games */
struct native PersistentInventoryData
{
	var class<Inventory>	LeftShoulderWeaponClass;
	var class<Inventory>	RightShoulderWeaponClass;
	var class<Inventory>	HolsterWeaponClass;
	var class<Inventory>	BeltWeaponClass;
	var class<Inventory>	ShieldClass;
};
/** Instance of the above PersistentInventory struct so that we can have persistent inventory across MP rounds */
var PersistentInventoryData	PersistentInventory;

/** Difficulty setting for this player */
var class<DifficultySettings> Difficulty;

/** Whether or not this player has made a difficulty selection yet */
var bool bDifficultySelectionMade;

// Publically replicated properties for EndOfRound screen
/** PRI of the last player to DBNO me */
var PlayerReplicationInfo LastToDBNOMePRI;
/** PRI of the last player to kill me */
var PlayerReplicationInfo LastToKillMePRI;
/** PRI of the last player I killed */
var PlayerReplicationInfo LastIKilledPRI;
/** The damage type to kill me */
var class<GearDamageType> DamageTypeToKillMe;

// Publically replicated stats for players
/** Number of players I have killed. */
var int Score_Kills;
/** Number of players I have knocked DBNO. */
var int Score_Takedowns;
/** Number of times I have revived teammates. */
var int Score_Revives;
/** Number of times I assisted in a kill */
var int Score_Assists;
/** Game specific scoring properties. */
var int Score_GameSpecific1; // Horde/Siege - wave kills, Ring - RingCaps, CTL - Leader Capture Wins
var int Score_GameSpecific2; // Ring - RingBreaks, KTL - surviving leader, CTL - Survives as Leader
var int Score_GameSpecific3; // KOTH - RingPoints, CTL - Leader pickups
var int Score_GameSpecific4; // CTL - Leader Releases

/** Generic point accumulator used by different game types */
var float PointAccumulator;

/** Disconnect count replicated for leaderboards */
var int DisconnectCount;

/**
 * The bit-shifted variable which communicates which DLC packs the player possesses
 * NOTE: only the first 31 bits will be valid and -1 must be tested against before
 *       trying to determine what DLC the player has as -1 means that this variable
 *		 has not replicated yet
 */
var int DLCFlag;

/** List of currently planted grenades for this player to limit the number active */
var transient array<GearProj_Grenade> PlantedGrenades;

/** Currently attained level based on experience. Replicated to clients */
var int PlayerLevel;
/** Holds the player's skill for this game type */
var int PlayerSkill;

/** PRI of the last player to revive me, not replicated and only used by DBNO HUD locator */
var PlayerReplicationInfo LastToReviveMePRI;
/** Points that the last player received for reviving me, not replicated and only used by DBNO HUD locator */
var int LastToReviveMePoints;
/** The last time we were revived, not replicated and only used by DBNO HUD locator */
var int LastToReviveMeTime;

/** Net id of the owner for this player's party. If no party then ZeroId. */
var repnotify UniqueNetId	PartyOwnerUniqueId;

/** The identifier that points to the medal that this player has selected to represent themselves in the UI */
var int MedalID;

/** All exp this player has earned by category
 * @note: only valid on server or on the owning client after the game has ended (via RPC GearPC_MP::ClientUpdateXP())
 */
var int ExpBuckets[EExperienceBuckets];

/** This is the primary weapon skin index, so that everyone sees the player's customized skin */
var	CoolSkin PrimaryWeaponSkin;
/** This is the secondary weapon skin index, so that everyone sees the player's customized skin */
var	CoolSkin SecondaryWeaponSkin;

/** The GearDroppedPickup/GearPickupFactory that is currently spotted by this PRI */
var repnotify Actor SpottedPickup;

cpptext
{
	// Networking
	INT* GetOptimizedRepList( BYTE* InDefault, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );
}

replication
{
	// sent to everyone
	if (bNetDirty)
		bIsLeader, bIsDead, InitialPrimaryWeaponType, InitialSecondaryWeaponType, PlayerStatus, EndOfRoundPlayerStatus,
		Difficulty, bDifficultySelectionMade, bReceivesTeamScoringBonus, LastToDBNOMePRI, LastToKillMePRI, LastIKilledPRI,
		DamageTypeToKillMe, Score_Kills, Score_Takedowns, Score_Assists, Score_Revives, Score_GameSpecific1, Score_GameSpecific2, Score_GameSpecific3, Score_GameSpecific4,
		DLCFlag, SquadName, bForceShowInTaccom, PlayerLevel, PlayerSkill, MedalID, SpottedPickup,
		// Needs replication to clients to register the correct remote party members
		PartyOwnerUniqueId,
		// Player's weapon customization choices
		PrimaryWeaponSkin, SecondaryWeaponSkin,
		// Disconnect count for leaderboards
		DisconnectCount;
	// don't send a reference to a dynamically loaded pawn class during the countdown to the first round of an MP match
	// so that clients behind on async loading don't get that loading flushed unnecessarily
	if ( GearGameMP_Base(WorldInfo.Game) == None || GearGameMP_Base(WorldInfo.Game).CharacterStore.LoadedClasses.Find(PawnClass) == INDEX_NONE ||
		(!WorldInfo.Game.IsInState('PendingMatch') && (!WorldInfo.Game.IsInState('PreRound') || GearGRI(WorldInfo.GRI).RoundCount != 0)) )
		PawnClass;
}

function PreBeginPlay()
{
	Difficulty = class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo);

	// initialize scoring values from GameInfo
	ScaleScoringValues(1.0);

	InitialPrimaryWeaponType = WC_Lancer;
	InitialSecondaryWeaponType = WC_Gnasher;

	Super.PreBeginPlay();
}

event SetPlayerName(string S)
{
	PlayerName = S;

	if ( !(PlayerName ~= OldName) )
	{
		// ReplicatedEvent() won't get called by net code if we are the server
		if (WorldInfo.NetMode == NM_Standalone || WorldInfo.NetMode == NM_ListenServer)
		{
			ReplicatedEvent('PlayerName');
		}

		bForceNetUpdate = true;
	}
	OldName = PlayerName;
}

simulated final function GearPRI FindLocalPRI()
{
	local GameReplicationInfo GRI;
	local PlayerReplicationInfo PRI;
	GRI = WorldInfo.GRI;
	if (GRI != None)
	{
		foreach GRI.PRIArray(PRI)
		{
			if (GearPRI(PRI) != None && PRI.Owner != None)
			{
				return GearPRI(PRI);
			}
		}
	}
	return None;
}

simulated event ReplicatedEvent(Name VarName)
{
	local GearGRI_Horde GRI;

	if (VarName == nameof(PawnClass))
	{
		CheckForPrestreamingTextures();
	}
	else if (VarName == nameof(Score))
	{
		if (Owner != None && Controller(Owner).IsLocalPlayerController())
		{
			GRI = GearGRI_Horde(WorldInfo.GRI);
			if (GRI != None && GRI.bCanPlaceFortifications)
			{
				GRI.UpdateFortificationGhostImages();
			}
		}
	}
	else if (VarName == nameof(PartyOwnerUniqueId))
	{
		// Register remote clients party owners matching our party session
		RegisterPlayerWithParty();
	}
	else if (VarName == nameof(SpottedPickup))
	{
		if (SpottedPickup != None)
		{
			UpdateLocalSpottedPickupList();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}


simulated final function SetPawnClass(class<GearPawn> NewPawnClass)
{
	if (PawnClass != NewPawnClass)
	{
		PawnClass = NewPawnClass;
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			CheckForPrestreamingTextures();
		}
	}
}

simulated final function CheckForPrestreamingTextures()
{
	local GearPRI PRI;
	// ignore SP versions of Marcus/Dom since those are set to never stream and this would overwrite that
	if (PawnClass != None && PawnClass != class'GearPawn_COGMarcus' && PawnClass != class'GearPawn_COGDom')
	{
		PRI = FindLocalPRI();
		if (PRI == None || PRI.Team == Team)
		{
			`log("Streaming textures for"@`showvar(PawnClass));
			PawnClass.default.Mesh.PrestreamTextures(25.f,TRUE);
		}
	}
}

/**
 * Setter for PlayerStatus
 *
 */
simulated function SetPlayerStatus( EGearPlayerStatus NewStatus )
{
	PlayerStatus = NewStatus;
}

/** scales all the scoring values (PointsFor_*) by the specified multiplier
 * used by e.g. Horde to give weaker/stronger enemies appropriately scaled point values
 */
final function ScaleScoringValues(float Multiplier)
{
	local GearGame Game;

	Game = GearGame(WorldInfo.Game);
	if (Game != None)
	{
		PointsFor_TakeDowns = Game.default.PointsFor_TakeDowns * Multiplier;
		PointsFor_Executions = Game.default.PointsFor_Executions *  Multiplier;
		PointsFor_InstantKills = Game.default.PointsFor_InstantKills *  Multiplier;
		PointsFor_Revives = Game.default.PointsFor_Revives *  Multiplier;
		PointsFor_DamagePct = Game.default.PointsFor_DamagePct *  Multiplier;
		PointsFor_SpottedKill = Game.default.PointsFor_SpottedKill * Multiplier;
	}
}

final function AddPlayerDamage(GearPRI InstigatorPRI, float Damage, class<GearDamageType> DamageType)
{
	local int PlayerIdx;

	PlayerIdx = PlayerDamageList.Find('PRI',InstigatorPRI);
	if (PlayerIdx == INDEX_NONE)
	{
		// add new entry
		PlayerIdx = PlayerDamageList.Add(1);
		PlayerDamageList[PlayerIdx].PRI = InstigatorPRI;
		PlayerDamageList[PlayerIdx].DamageTotal = 0;
	}

	PlayerDamageList[PlayerIdx].DamageTotal += Damage;

	if (InstigatorPRI != None && DamageType != None)
	{
		if ( ClassIsChildOf(DamageType, class'GDT_Melee') )
		{
			//@STATS - Record Melee Damage (InstigatorPRI -> self)
			`RecordDamage(WEAPON_DAMAGE_MELEE, Controller(InstigatorPRI.Owner), DamageType, Controller(Owner), Damage);
		}
		else
		{
			//@STATS - Record Weapon Damage (InstigatorPRI -> self)
			`RecordDamage(WEAPON_DAMAGE, Controller(InstigatorPRI.Owner), DamageType, Controller(Owner), Damage);
		}
	}

	if (InstigatorPRI != None && InstigatorPRI != self && InstigatorPRI.Team == Team && Team != None)
	{
		SetTimer(60.0, false, nameof(RemoveTeamDamageEntries));
	}
}

/** called on a timer to remove team damage entries from the PlayerDamageList array if the player doesn't take team damage for a long time
 * (so players aren't losing points for some irrelevant team hits they don't even remember)
 */
function RemoveTeamDamageEntries()
{
	local int i;

	if (Team != None)
	{
		while (i < PlayerDamageList.length)
		{
			if (PlayerDamageList[i].PRI != None && PlayerDamageList[i].PRI != self && PlayerDamageList[i].PRI.Team == Team)
			{
				PlayerDamageList.Remove(i, 1);
			}
			else
			{
				i++;
			}
		}
	}
}

/**
 * Player has been damaged, track the total done to be scored on execution.
 */
final function ScoreHit(GearPRI InstigatorPRI, float MaxHealth, float CurrentHealth, float DamageInflicted, class<GearDamageType> DamageType, Actor DamageCauser)
{
	local float ActualDamageInflicted;

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress && InstigatorPRI != self)
	{
		ActualDamageInflicted = Clamp(DamageInflicted, 1, CurrentHealth);
		if ( (GearWeapon(DamageCauser) == None || !GearWeapon(DamageCauser).ModifyDamageScoring(self, InstigatorPRI, ActualDamageInflicted, DamageType)) &&
			(GearFortification(DamageCauser) == None || !GearFortification(DamageCauser).ModifyDamageScoring(self, InstigatorPRI, ActualDamageInflicted, DamageType)) )
		{
			AddPlayerDamage(InstigatorPRI, ActualDamageInflicted, DamageType);
		}
	}
}

/** player has been healed, give score to the healer */
function ScoreHeal(GearPRI InstigatorPRI, float HealthPct);

/** Central point to modify a player's score. */
function int ModifyScore(int Amt, EExperienceBuckets Bucket)
{
	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		Score += Amt;
		if (Bucket != eEXP_MAX)
		{
			ExpBuckets[Bucket] += Amt;
		}
		// kinda hacky but it seems overly complicated to call into the GameInfo just to end up back in here
		// really this function itself should be in GearGame :)
		if (GearGameHorde_Base(WorldInfo.Game) != None || GearGameSiege_Base(WorldInfo.Game) != None)
		{
			//@STATS - @TODO Record Team Score Update? (HORDE)
			Score_GameSpecific2 += Amt;
			if (Team != None)
			{
				Team.Score += Amt;
			}
		}

		//@STATS - Record Player Score Update
		`RecordPlayerFloatStat(SCORE_UPDATE,Controller(Owner),Amt);

		bForceNetUpdate = TRUE;

		if (GearGRI_SP_Arcade(WorldInfo.GRI) != None && GearPC(Owner) != None)
		{
			GearPC(Owner).ModifyStat('HighScoreArcade', Score, GEARSTATMODTYPE_Maximum);
		}

		return Amt;
	}
	else
	{
		return 0;
	}
}

/** Called from ScoreKnockdown() as a result of damaging somebody to the DBNO state. */
function ScoreTakeDown(GearPRI VictimPRI, class<GearDamageType> TakedownType)
{
	local GearPC PC;
	local int Points;

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		if ( Team == VictimPRI.Team )
		{
			// negative score for friendly takedowns
			ModifyScore(-VictimPRI.PointsFor_TakeDowns,eEXP_Kills);
		}
		else
		{
			Score_Takedowns++;

			// no points for downing leaders if they are immortal so you can't farm points that way
			if (!VictimPRI.bIsLeader || GearGRI_MP(WorldInfo.GRI).bLeadersAreKillable)
			{
				Points = VictimPRI.PointsFor_TakeDowns;
			}
			if (Points > 0)
			{
				Points = ModifyScore(VictimPRI.PointsFor_TakeDowns,eEXP_Kills);
			}
			PC = GearPC(Owner);
			if (PC != None)
			{
				AddDeathMessage(PC, self, VictimPRI, TakedownType, GDT_NORMAL, true, Points, false, true);
			}
		}
	}
}

/** Called when player is knocked to DBNO via damage, automatically calls ScoreTakedown() for the instigator. */
function ScoreKnockdown(GearPRI InstigatorPRI, class<GearDamageType> KnockdownType)
{
	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		// @STATS - Record player dbno event (player DBNO'd target)
		`RecordPlayerPlayerEvent(DBNO, Controller(InstigatorPRI.Owner), Controller(Owner));
		// @STATS - Record the damage type responsible for the knockdown
		`RecordDamage(WEAPON_DBNO, Controller(InstigatorPRI.Owner), KnockdownType, Controller(Owner), 1);

		if (InstigatorPRI != None)
		{
			InstigatorPRI.ScoreTakeDown(self, KnockdownType);
		}
		// Mark the last player to DBNO me
		LastToDBNOMePRI = InstigatorPRI;
	}
}

/** Called when this player revives another. */
function ScoreRevive(GearPRI VictimPRI)
{
	local int Amt;

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		Amt = ModifyScore(VictimPRI.PointsFor_Revives,eEXP_Revives);
		if (GearPC(Owner) != None)
		{
			GearPC(Owner).AddScoreGameMessage(69, Amt, VictimPRI);
		}

		// @STATS - Record player revived event (player reviving victim)
		`RecordPlayerPlayerEvent(REVIVED,Controller(Owner), Controller(VictimPRI.Owner));

		Score_Revives++;
		// clear the player damage list on the target
		if (VictimPRI != None)
		{
			VictimPRI.PlayerDamageList.Length = 0;
		}
	}
}

/** Called when a player is normally executed from a DBNO. */
function ScoreExecution(GearPRI VictimPRI, class<GearDamageType> KillType, EGearDeathType DeathType)
{
	local int Pts;

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress && VictimPRI != None && VictimPRI.PlayerStatus != WPS_Dead)
	{
		Pts = VictimPRI.PointsFor_Executions;
		if ( Team == VictimPRI.Team )
		{
			// negative score for friendly takedowns
			Pts = -Pts;
		}
		else
		{
			Score_Kills++;
		}

		// Suicides handled inside ScoreDeath
		if (self != VictimPRI)
		{
			if (KillType == class'GDT_BledOut')
			{
				//@STATS Record a bleed out
				`RecordKillEvent(BLEDOUT,Controller(Owner),KillType,Controller(VictimPRI.Owner));
				Pts = 0;
			}
			else if ( ClassIsChildOf(KillType, class'GDT_Execution_Base')  )
			{
				//@STATS Record Execution
				`RecordKillEvent(EXECUTION,Controller(Owner),KillType,Controller(VictimPRI.Owner));
			}
			else
			{
				//@STATS Record normal execution death
				`RecordKillEvent(NORMAL,Controller(Owner),KillType,Controller(VictimPRI.Owner));
			}
		}

		// track the death for the victim
		VictimPRI.ScoreDeath(self, KillType, DeathType, Pts);
	}
	else
	{
		`log("Discarded kill!"@`showvar(VictimPRI)@`showvar(self));
	}
}

/** Called when a player is killed instantly, bypassing DBNO. */
function ScoreInstantKill(GearPRI VictimPRI, class<GearDamageType> KillType, EGearDeathType DeathType)
{
	local GearPawn Victim;
	local int Pts;

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress && VictimPRI != None && VictimPRI.PlayerStatus != WPS_Dead)
	{
		// only award points if it isn't the final down rule
		Victim = GearPawn(Controller(VictimPRI.Owner).Pawn);
		if (Victim == None || Victim.DownCount < Victim.MaxDownCount)
		{
			Pts = VictimPRI.PointsFor_InstantKills;
		}
		if (Team == VictimPRI.Team)
		{
			Pts = -Pts;
		}
		else
		{
			Score_Kills++;
		}

		// Suicides handled inside ScoreDeath
		if (VictimPRI != self)
		{
			if (DeathType == GDT_Headshot)
			{
				// @STATS Record HEADSHOT
				`RecordKillEvent(HEADSHOT,Controller(Owner),KillType,Controller(VictimPRI.Owner));
			}
			else if (ClassIsChildOf(KillType, class'GDT_IncendiaryGrenade') ||
					 KillType == class'GDT_Bayonet')
			{
				// @STATS Record NORMAL
				`RecordKillEvent(NORMAL,Controller(Owner),KillType,Controller(VictimPRI.Owner));
			}
			else
			{
				// @STATS Record GIB
				`RecordKillEvent(GIB,Controller(Owner),KillType,Controller(VictimPRI.Owner));
			}
		}

		// track the death for the victim
		VictimPRI.ScoreDeath(self, KillType, DeathType, Pts);
	}
	else
	{
		`log("Discarded kill!"@`showvar(VictimPRI)@`showvar(self));
	}
}

function IncrementDeaths(optional int Amt = 1)
{
	// this is handled via ScoreDeath
}


/** Add Death Message to HUD. Called @ server
 *  return TRUE if successfully added
 *  return FALSE otherwise
 */
final function bool AddDeathMessage( GearPC OwnerPC, PlayerReplicationInfo Killer, PlayerReplicationInfo Other, class<DamageType> damageType, EGearDeathType DeathType, bool bIsKnockdown, optional int PointsAwarded=0, optional bool bIgnoreForHUD, optional bool bSkipBlood)
{
	local Controller Victim;
	local GearPawn VictimPawn;

	Victim = Controller(Other.Owner);
	if (Victim != none)
	{
		VictimPawn = GearPawn(Victim.Pawn);
	}

	OwnerPC.AddDeathMessage(VictimPawn, Killer, Other, damagetype, DeathType, bIsKnockdown, PointsAwarded, bIgnoreForHUD, bSkipBlood);
	return TRUE;
}

/** Called when this player is killed, gives out points to all players contributing to the kill. */
function ScoreDeath(GearPRI KillerPRI, class<GearDamageType> KillType, EGearDeathType DeathType, optional int AdditionalPts)
{
	local float TotalDamage, AwardedScore;
	local int Idx;
	local GearPRI AssistPRI;
	local GearPC PC;
	local array<GearPC> NotifiedPCs;
	local bool bProcessedKiller;
	local GearMutator GMut;
	local Controller PawnController;
	local GearPawn GP;
	local GearPRI SpottedByPRI;

	// mark this PRI as dead to prevent extra points awarded if someone gibs the person being executed/chainsawed/etc
	SetPlayerStatus(WPS_Dead);
	bForceNetUpdate = true;

	if (GearGRI(WorldInfo.GRI).GameStatus != GS_RoundInProgress)
	{
		return;
	}

	Deaths += 1;

	// give mutators a chance to do their own thing
	GMut = GearGame(WorldInfo.Game).GetBaseGearMutator();
	if (GMut != None && GMut.OverrideDeathScoring(KillerPRI, self, KillType, DeathType, AdditionalPts))
	{
		return;
	}

	// and award assists
	AssistPRI = None;

	// calculate the total first
	for (Idx = 0; Idx < PlayerDamageList.Length; Idx++)
	{
		TotalDamage += PlayerDamageList[Idx].DamageTotal;
	}

	if (KillerPRI != None && KillerPRI != self && WorldInfo.GRI.OnSameTeam(KillerPRI, self))
	{
		// @STATS - Score stats for a team kill
		`RecordKillEvent(TEAMKILL,Controller(KillerPRI.Owner),KillType,Controller(Owner));
	}

	PawnController = Controller(Owner);
	if (PawnController != None)
	{
		GP = GearPawn(PawnController.Pawn);
	}

	if (KillerPRI != None && KillerPRI != self && PlayerDamageList.length > 0 && GP != None && GP.SpottedByTeam[KillerPRI.GetTeamNum()] > 0)
	{
		SpottedByPRI = GP.SpottedBy[KillerPRI.GetTeamNum()];

		// Want to get into the point pool below without rearranging the flow a ton
		if (PlayerDamageList.Find('PRI', SpottedByPRI) == INDEX_NONE)
		{
			Idx = PlayerDamageList.Add(1);
			PlayerDamageList[Idx].PRI = SpottedByPRI;
			PlayerDamageList[Idx].DamageTotal = 0;
		}
	}

	// award point pool based on each players damage contribution
	for (Idx = 0; Idx < PlayerDamageList.Length; Idx++)
	{
		if (PlayerDamageList[Idx].PRI != None)
		{
			AwardedScore = PlayerDamageList[Idx].DamageTotal/TotalDamage * PointsFor_DamagePct;
			if (PlayerDamageList[Idx].PRI != KillerPRI)
			{
				AssistPRI = PlayerDamageList[Idx].PRI;
			}
			else
			{
				AssistPRI = None;
			}

			if (WorldInfo.GRI.OnSameTeam(PlayerDamageList[Idx].PRI, self))
			{
				AwardedScore = -AwardedScore;
			}

			if (PlayerDamageList[Idx].PRI == KillerPRI || (KillerPRI == None && PlayerDamageList[Idx].PRI == self))
			{
				AwardedScore += AdditionalPts;
				bProcessedKiller = true;
			}

			// Give extra points for spotting a killed player, don't give extra points to the killer
			if (SpottedByPRI != None && SpottedByPRI == PlayerDamageList[Idx].PRI && KillerPRI != SpottedByPRI)
			{
				AwardedScore += PointsFor_SpottedKill;
			}

			AwardedScore = PlayerDamageList[Idx].PRI.ModifyScore(AwardedScore,eEXP_Kills);

			// send the death message to the player
			//@note - skip for negative, font doesn't support that character, so just skip pts for those messages
			PC = GearPC(PlayerDamageList[Idx].PRI.Owner);
			if (PC != None && AwardedScore != 0)
			{
				AddDeathMessage(PC, KillerPRI, self, KillType, DeathType, false, AwardedScore);
				NotifiedPCs.AddItem(PC);
			}

			//@STATS - Record player kill assist
			if (AssistPRI != None && AwardedScore > 0)
			{
				`RecordPlayerIntStat(ASSIST,Controller(AssistPRI.Owner),1);
				AssistPRI.Score_Assists++;
				if (GearMPPRI(AssistPRI) != None)
				{
					GearMPPRI(AssistPRI).AssistStreak++;
					if (PC != None && GearMPPRI(AssistPRI).AssistStreak >= 5)
					{
						// @AWARD - Helping Hand
						PC.NotifyEarnedAward('SpreeAssists');
						GearMPPRI(AssistPRI).AssistStreak = 0;
					}
				}
			}
		}
	}
	if (!bProcessedKiller)
	{
		if (KillerPRI != None)
		{
			AwardedScore = KillerPRI.ModifyScore(AdditionalPts,eEXP_Kills);
			if (GearPC(KillerPRI.Owner) != None)
			{
				AddDeathMessage(GearPC(KillerPRI.Owner), KillerPRI, self, KillType, DeathType, false, AwardedScore);
			}
			NotifiedPCs.AddItem(GearPC(KillerPRI.Owner));
		}
		else
		{
			ModifyScore(AdditionalPts,eEXP_Kills);
		}
	}

	// empty list just to be safe
	PlayerDamageList.Length = 0;
	bForceNetUpdate = TRUE;
	// notify other players who didn't contribute
	foreach WorldInfo.AllControllers(class'GearPC',PC)
	{
		if (NotifiedPCs.Find(PC) == INDEX_NONE)
		{
			AddDeathMessage(PC, KillerPRI,self,KillType,DeathType,false);
		}
	}
}

/** Generic accessor for game specific scoring */
protected final function ScoreGameSpecific(int Type, float Points, out int GameSpecificScore, optional int Id, optional bool bSkipHUDUpdate)
{
	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		GameSpecificScore++;
		//@STATS - Record game specific score (only 1 because of ++)
		`RecordPlayerIntStatRaw(Type, Controller(Owner), 1);

		if (Points != 0)
		{
			Points = ModifyScore(Points,eEXP_Objectives);
		}
		if (GearPC(Owner) != None && !bSkipHUDUpdate)
		{
			GearPC(Owner).AddScoreGameMessage(Id, Points);
		}
	}
}
final function ScoreGameSpecific1(int Type, optional float Points, optional bool bSkipHUDUpdate) { ScoreGameSpecific(Type,Points,Score_GameSpecific1,0,bSkipHUDUpdate); }
final function ScoreGameSpecific2(int Type, optional float Points, optional bool bSkipHUDUpdate) { ScoreGameSpecific(Type,Points,Score_GameSpecific2,1,bSkipHUDUpdate); }
final function ScoreGameSpecific3(int Type, optional float Points, optional bool bSkipHUDUpdate) { ScoreGameSpecific(Type,Points,Score_GameSpecific3,2,bSkipHUDUpdate); }
final function ScoreGameSpecific4(int Type, optional float Points, optional bool bSkipHUDUpdate) { ScoreGameSpecific(Type,Points,Score_GameSpecific4,3,bSkipHUDUpdate); }

/** === Begin Stat accessor functions === */

simulated final function int GetKills()			{ return Score_Kills; }
simulated final function int GetTakeDowns()		{ return Score_Takedowns; }
simulated final function int GetDeaths()		{ return Deaths; }
simulated final function int GetRevives()		{ return Score_Revives; }
simulated final function int GetAssists()		{ return Score_Assists; }
simulated final function int GetScore()			{ return Score; }
simulated final function int GetGameScore1()	{ return Score_GameSpecific1; }
simulated final function int GetGameScore2()	{ return Score_GameSpecific2; }
simulated final function int GetGameScore3()	{ return Score_GameSpecific3; }
simulated final function int GetGameScore4()	{ return Score_GameSpecific4; }

/** === End Stat accessor functions === */

/** Called from client to change team selection */
reliable server function MenuTeamChange(int NewTeam)
{
	WorldInfo.Game.ChangeTeam( PlayerController(Owner), NewTeam, true);
	bForceNetUpdate = TRUE;
}

/**
 * Put a kill on us into PlayerKillList for safe keeping
 *
 * @param PRI - the player replication info of the player that killed us
 */
simulated function RecordKilledBy(PlayerReplicationInfo PRI)
{
	local int PlayerIdx;
	local int OldestKillTime;
	local int i;
	local class<GearGameMP_Base> MPClass;

	MPClass = class<GearGameMP_Base>(WorldInfo.GRI.GameClass);
	if (MPClass == None)
	{
		return;
	}

	// don't care about team kills or suicides
	if (PRI.Team.TeamIndex == Team.TeamIndex)
	{
		return;
	}

	PlayerIdx = PlayerKillList.Find('PRI', PRI);

	if (PlayerIdx == INDEX_NONE)
	{
		if (PlayerKillList.Length < 5)
		{
			PlayerIdx = PlayerKillList.Add(1);
		}
		else
		{
			// more than 5 players tracked, just reuse someone's slot to keep memory down
			PlayerIdx = 0;
			OldestKillTime = PlayerKillList[0].LastKillTime;

			for (i = 1; i < PlayerKillList.Length; i++)
			{
				if (PlayerKillList[i].LastKillTime < OldestKillTime)
				{
					PlayerIdx = i;
					OldestKillTime = PlayerKillList[i].LastKillTime;
				}
			}
		}

		PlayerKillList[PlayerIdx].PRI = PRI;
		PlayerKillList[PlayerIdx].KillCount = 0;
	}

	PlayerKillList[PlayerIdx].KillCount++;
	PlayerKillList[PlayerIdx].LastKillTime = WorldInfo.TimeSeconds;

	if (CurrentNemesis == None && PlayerKillList[PlayerIdx].KillCount >= MPClass.default.NemesisThreshold)
	{
		CurrentNemesis = PRI;
		if (CurrentNemesis != None && GearPC(CurrentNemesis.Owner) != None && GearPC(CurrentNemesis.Owner).IsLocalPlayerController())
		{
			// @AWARD - Nemesis
			GearPC(CurrentNemesis.Owner).NotifyEarnedAward('Nemesis');
		}
	}
}

/**
 * Check if the player in question is our nemesis
 *
 * @param PRI - the player replication info to check against
 *
 * @return TRUE if they have killed us enough times
 */
simulated function bool IsNemesis(PlayerReplicationInfo PRI)
{
	return (CurrentNemesis != None && PRI == CurrentNemesis);
}

/** Just reset the amount of kills they had on you */
simulated function ClearNemesis()
{
	local int PlayerIdx;

	if (CurrentNemesis != None)
	{
		PlayerIdx = PlayerKillList.Find('PRI', CurrentNemesis);
		if (PlayerIdx != INDEX_NONE)
		{
			PlayerKillList[PlayerIdx].KillCount = 0;
		}

		CurrentNemesis = None;
	}
}

/** Clear all variables dealing with someone killing this PRI */
final function ClearDeathVariables()
{
	LastIKilledPRI = None;
	LastToDBNOMePRI = None;
	LastToKillMePRI = None;
	DamageTypeToKillMe = None;
	bIsDead = false;
	ReplicatedEvent('bIsDead');
	PlayerDamageList.Length = 0;
}

/**
 * Changes the player's default weapon class.
 *
 * @param	PrimaryWeaponId	    the id of the primary weapon to switch to
 * @param	SecondaryWeaponId	the id of the secondary weapon to switch to
 */
reliable server function ServerSetWeaponId( byte PrimaryWeaponId, byte SecondaryWeaponId )
{
	InitialPrimaryWeaponType = PrimaryWeaponId;
	InitialSecondaryWeaponType = SecondaryWeaponId;
}

reliable server function MenuSetReady(bool bIsReadyToPlay)
{
	bReadyToPlay = bIsReadyToPlay;
	bForceNetUpdate = TRUE;
}

reliable server function HostIsReady()
{
	bHostIsReady = true;
	bForceNetUpdate = TRUE;
}

function Reset()
{
	Super.Reset();

	bHostIsReady = FALSE;
}

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
	return !bExiting && (GearPC(Owner) != None) && !GearPC(Owner).bCheckpointDummy && Super.ShouldBroadCastWelcomeMessage(bExiting);
}

reliable client simulated function ClientPlayEncouragementSound(int TeamIndex, EEncouragementType EncType, byte SoundIndex)
{
	local class<GearGameMP_Base> TheGameClass;
	local int NumSounds;
	local SoundCue Cue;
	local AudioComponent AC, ACEndGameMusic;

	//@todo: FIXME: what about splitscreen? Do we really want to play two sounds?
	if (PlayerController(Owner) != None)
	{
		TheGameClass = class<GearGameMP_Base>(WorldInfo.GRI.GameClass);

		if ( TeamIndex == 0 )
		{
			NumSounds = TheGameClass.default.MPResourceClass.default.EncouragementData[EncType].COGSounds.Length;
			if ( NumSounds > 0 )
			{
				SoundIndex = SoundIndex % byte(NumSounds);
				Cue = TheGameClass.default.MPResourceClass.default.EncouragementData[EncType].COGSounds[ SoundIndex ];
			}
		}
		else
		{
			NumSounds = TheGameClass.default.MPResourceClass.default.EncouragementData[EncType].LocustSounds.Length;
			if ( NumSounds > 0 )
			{
				SoundIndex = SoundIndex % byte(NumSounds);
				Cue = TheGameClass.default.MPResourceClass.default.EncouragementData[EncType].LocustSounds[ SoundIndex ];
			}
		}

		if ( Cue != None )
		{
			AC = Owner.CreateAudioComponent(Cue, false, true);
		}

		if (AC != None)
		{
			AC.bUseOwnerLocation = TRUE;
			AC.bAutoDestroy = TRUE;
			AC.bSuppressSubtitles = TRUE;
			AC.VolumeMultiplier = 1.25f;
			AC.bAllowSpatialization = FALSE;
			AC.Play();
		}
	}

	//Play the end game music
	ACEndGameMusic = Owner.CreateAudioComponent(TheGameClass.default.MPResourceClass.default.EndOfGameMusic, false, true);
	if (ACEndGameMusic != None)
	{
		ACEndGameMusic.Play();
	}
}

function EndOfGameEncouragement(byte EncouragementIndex)
{
	local int MyTeam, OtherTeam, ScoreDiff;
	local EEncouragementType EncType;

	if (Team == None)
	{
		return;
	}

	MyTeam = Team.TeamIndex;
	OtherTeam = MyTeam == 0 ? 1 : 0;

	`log("ENCOURAGEMENT myteam"@MyTeam@WorldInfo.GRI.Teams[MyTeam].Score@"othertheam"@OtherTeam@WorldInfo.GRI.Teams[OtherTeam].Score);

	if (WorldInfo.GRI.Teams[MyTeam].Score == 0)
	{
		// shutout loss
		EncType = ET_LostMatchByShutout;
	}
	else if (WorldInfo.GRI.Teams[OtherTeam].Score == 0)
	{
		// shutout win
		EncType = ET_WonMatchByShutout;
	}
	else
	{
		ScoreDiff = WorldInfo.GRI.Teams[MyTeam].Score - WorldInfo.GRI.Teams[OtherTeam].Score;
		if (ScoreDiff == 0)
		{
			EncType = ET_MatchOrRoundDraw;
		}
		else if (ScoreDiff > 0)
		{
			EncType = ET_WonMatch;
		}
		else
		{
			EncType = ET_LostMatch;
		}
	}

	// play dialogue
	ClientPlayEncouragementSound(MyTeam, EncType, EncouragementIndex);
}


function EndOfRoundEncouragement(byte EncouragementIndex)
{
	local EEncouragementType EncType;
	local TeamInfo WinningTeam;

	if (Team == None)
	{
		return;
	}

	WinningTeam = TeamInfo(GearGRI(WorldInfo.GRI).Winner);

	if (WinningTeam == None)
	{
		// draw
		EncType = ET_MatchOrRoundDraw;
	}
	else if (Team == WinningTeam)
	{
		// my team won, yay for me
		EncType = ET_WonRound;
	}
	else
	{
		// we lost, boo lag teamz
		EncType = ET_LostRound;
	}

	// play dialogue
	ClientPlayEncouragementSound(Team.TeamIndex, EncType, EncouragementIndex);
}

simulated function ClientInitialize(Controller C)
{
	Super.ClientInitialize(C);

	// MP has no subtitles!
	if (GearGRI(WorldInfo.GRI) != None && GearGRI(WorldInfo.GRI).IsMultiPlayerGame())
	{
		PlayerController(C).SetShowSubtitles( false );
	}
}

function CopyProperties(PlayerReplicationInfo PRI)
{
	local GearPRI GPRI;

	Super.CopyProperties(PRI);

	GPRI = GearPRI(PRI);
	if (GPRI != None)
	{
		GPRI.SetPawnClass(PawnClass);
		GPRI.InitialPrimaryWeaponType = InitialPrimaryWeaponType;
		GPRI.InitialSecondaryWeaponType = InitialSecondaryWeaponType;
		GPRI.PreferredCOGIndex = PreferredCOGIndex;
		GPRI.PreferredLocustIndex = PreferredLocustIndex;

		GPRI.DLCFlag = DLCFlag;
		GPRI.PlayerSkill = PlayerSkill;
		GPRI.MedalID = MedalID;
		GPRI.PlayerLevel = PlayerLevel;
	}
}

/**
 * Called when PRI is destroyed to unregister all remote players from the game session(s).
 */
simulated function UnregisterPlayerFromSession()
{
	Super.UnregisterPlayerFromSession();

	// Unregister PRI of dropped player from the party session if available.
	// Traveling players will get re-registered when starting the match.
	UnregisterPlayerFromParty();
}

/**
 * All PRIs will be register with the party session
 * iff the PartyOwnerUniqueId matches the current party session owner.
 * This is called whenever both the UniqueId and the PartyOwnerUniqueId are replicated.
 */
simulated function RegisterPlayerWithParty()
{
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings PartySettings;
	local UniqueNetId ZeroId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		PartyOwnerUniqueId != ZeroId &&
		UniqueId != ZeroId)
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
		if (PartySettings != None &&
			PartySettings.OwningPlayerId == PartyOwnerUniqueId)
		{
			`LogOnline(""
				$" UniqueId="$OnlineSub.static.UniqueNetIdToString(UniqueId)
				$" PartyOwnerUniqueId="$OnlineSub.static.UniqueNetIdToString(PartyOwnerUniqueId));

			OnlineSub.GameInterface.RegisterPlayer('Party',UniqueId,true);
		}
	}
}

/**
 * All PRIs will be unregistered from the party session when destroyed.
 */
simulated function UnregisterPlayerFromParty()
{
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings PartySettings;
	local UniqueNetId ZeroId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None &&
		UniqueId != ZeroId)
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
		if (PartySettings != None)
		{
			`LogOnline(""
				$" UniqueId="$OnlineSub.static.UniqueNetIdToString(UniqueId)
				$" PartyOwnerUniqueId="$OnlineSub.static.UniqueNetIdToString(PartyOwnerUniqueId));

			OnlineSub.GameInterface.UnregisterPlayer('Party',UniqueId);
		}
	}
}

/**
 * Returns the weapon skin for the specified class based upon a user's customization
 *
 * @param WeapClass the weapon class that wants to be customized
 *
 * @return the skin to use or none if none is set
 */
simulated function MaterialInterface GetWeaponSkinForClass(class<GearWeapon> WeapClass)
{
	// Check the primary weapon
	if (PrimaryWeaponSkin.WeapClass == WeapClass &&
		PrimaryWeaponSkin.WeaponSkinIndex < WeapClass.default.WeaponSkins.Length)
	{
		return WeapClass.default.WeaponSkins[PrimaryWeaponSkin.WeaponSkinIndex];
	}
	// And now the secondary
	if (SecondaryWeaponSkin.WeapClass == WeapClass &&
		SecondaryWeaponSkin.WeaponSkinIndex < WeapClass.default.WeaponSkins.Length)
	{
		return WeapClass.default.WeaponSkins[SecondaryWeaponSkin.WeaponSkinIndex];
	}
	return None;
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
	// Check the primary weapon
	if (PrimaryWeaponSkin.WeapClass == WeapClass)
	{
		SkinParams = PrimaryWeaponSkin;
		return true;
	}
	// And now the secondary
	if (SecondaryWeaponSkin.WeapClass == WeapClass)
	{
		SkinParams = SecondaryWeaponSkin;
		return true;
	}
	return false;
}

/** Add a hud locator for this PRI's spotted pickup to local player controllers */
final simulated function UpdateLocalSpottedPickupList()
{
	local GearPC GPC;

	ForEach LocalPlayerControllers(class'GearPC', GPC)
	{
		if (GetTeamNum() == GPC.GetTeamNum())
		{
			GPC.AddedSpottedPickupLocator(SpottedPickup);
		}
	}
}

defaultproperties
{
	GameMessageClass=class'GearGameMessage'

	bDifficultySelectionMade=TRUE
	bShowGore=TRUE
	bShowHUD=TRUE
	bShowPictograms=TRUE
	bAlwaysDrawWeaponIndicatorInHUD=FALSE
	ControllerSensitivityConfig=PCSO_Medium
	TargetSensitivityConfig=PCSO_Medium
	ZoomSensitivityConfig=PCSO_Medium

	Difficulty=class'GearGame.DifficultySettings_Hardcore'
	DLCFlag=-1

	LastTalkTime=-5

	PreferredCOGIndex=-1
	PreferredLocustIndex=-1

	PlayerSkill=-1
	MedalID=-1
}
