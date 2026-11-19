/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMPlayerReplicationInfo extends PlayerReplicationInfo
	native
	nativereplication;

/** Whether this PRI is holding special game object. */
var bool				bHasFlag;

/** True if player is female */
var bool				bIsFemale;

/** True if associated bot is currently holding its position */
var bool bHolding;

var int 		spree;
var int			MultiKillLevel;
var float		LastKillTime;

var TMLinkedReplicationInfo CustomReplicationInfo;	// for use by mod authors
var TMSquadAI Squad;
var private TMCarriedObject		HasFlag;

var class<TMVoice>		VoiceClass;

var repnotify TMGameObjective StartObjective;
var TMGameObjective TemporaryStartObjective;

var TMPlayerReplicationInfo LastKillerPRI;	/** Used for revenge reward, and for avoiding respawning near killer */

var color DefaultHudColor;

/** Set when pawn with this PRI has been rendered on HUD map, to avoid drawing it twice */
var bool bHUDRendered;

/** Replicated class of pawn controlled by owner of this PRI.  Replicated when drawing HUD Map */
var class<Pawn> HUDPawnClass;

var vector HUDLocation, HUDPawnLocation;
var byte HUDPawnYaw;
var MaterialInstanceConstant HUDMaterialInstance;

/** Determines which character this player will be in the single player game */
var int SinglePlayerCharacterIndex;

/************************************
 *  Character class related variables
 ************************************/

/** Class that the player has chosen to be */
var repnotify class<TMFamilyInfo> CharClassInfo;

var int	Character;

/** Texture of render of custom character head. */
var	Texture		CharPortrait;

/** The clan tag for this player */
var databinding string ClanTag;

/************************************
 *  Stats related variables
 ************************************/
struct native IntStat
{
	var name	StatName;
	var int		StatValue;
};

/** holds all kill stats (this player's kills, sorted by weapon/damagetype) */
var Array<IntStat> KillStats;

/** holds all death stats (this player's deaths instigated by another player, sorted by weapon/damagetype)*/
var Array<IntStat> DeathStats;

/** holds all suicide stats (this player's suicides, sorted by weapon/damagetype)*/
var Array<IntStat> SuicideStats;

/** holds event stats (mostly reward announcer related */
var Array<IntStat> EventStats;

/** holds node captured/built/healed and core damaged/destroyed stats */
var Array<IntStat> NodeStats;

/** Stats of vehicles killed by this player */
var Array<IntStat> VehicleKillStats;

/** Armor, health, and powerups picked up by this player */
var Array<IntStat> PickupStats;

struct native TimeStat
{
	var name StatName;
	var float TotalTime;
	var float CurrentStart;
};

/** Time spent driving, sorted by vehicle */
var Array<TimeStat> DrivingStats;

/** Time spent holding powerups and flag/orb */
var Array<TimeStat> PowerupTimeStats;

var localized string OrdersString[8];
var byte OrdersIndex;

var int			Rank;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if (bNetDirty)
		CustomReplicationInfo, bHolding, Squad, OrdersIndex, ClanTag,
		SinglePlayerCharacterIndex, CharClassInfo, Character, Rank;

	if ( bNetOwner && ROLE==ROLE_Authority )
		StartObjective;

	if ( !bNetOwner ) // && TMPlayerController(ReplicationViewer).bViewingMap (if so, in C++ HUDLocationRep = HUDLocation, HUDPawnClass updated too);
		HUDPawnClass, HUDPawnLocation, HUDPawnYaw;
}

simulated event Destroyed()
{
	Super.Destroyed();
}

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
	local TMGame Game;

	Game = TMGame(WorldInfo.Game);
	return (!bBot || Game == None || Game.SinglePlayerMissionID == INDEX_NONE) && Super.ShouldBroadcastWelcomeMessage(bExiting);
}

function int IncrementKillStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = KillStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( KillStats[i].StatName == NewStatName )
		{
			KillStats[i].StatValue++;
			return KillStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	KillStats[Len] = NewStat;
	return 1;
}

function int IncrementDeathStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = DeathStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( DeathStats[i].StatName == NewStatName )
		{
			DeathStats[i].StatValue++;
			return DeathStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	DeathStats[Len] = NewStat;
	return 1;
}

function int IncrementSuicideStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = SuicideStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( SuicideStats[i].StatName == NewStatName )
		{
			SuicideStats[i].StatValue++;
			return SuicideStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	SuicideStats[Len] = NewStat;
	return 1;
}

function int IncrementEventStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = EventStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( EventStats[i].StatName == NewStatName )
		{
			EventStats[i].StatValue++;
			return EventStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	EventStats[Len] = NewStat;
	return 1;
}

function int IncrementNodeStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = NodeStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( NodeStats[i].StatName == NewStatName )
		{
			NodeStats[i].StatValue++;
			return NodeStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	NodeStats[Len] = NewStat;
	return 1;
}

function int AddToNodeStat(name NewStatName, int Amount)
{
	local int i, Len;
	local IntStat NewStat;

	Len = NodeStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( NodeStats[i].StatName == NewStatName )
		{
			NodeStats[i].StatValue += Amount;
			return NodeStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = Amount;
	NodeStats[Len] = NewStat;
	return Amount;
}

function StartDrivingStat(name NewStatName)
{
	local int i, Len;
	local TimeStat NewStat;

	Len = DrivingStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( DrivingStats[i].StatName == NewStatName )
		{
			DrivingStats[i].CurrentStart = WorldInfo.TimeSeconds;
			return;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.CurrentStart = WorldInfo.TimeSeconds;
	DrivingStats[Len] = NewStat;
	return;
}

function StopDrivingStat(name NewStatName)
{
	local int i, Len;

	Len = DrivingStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( DrivingStats[i].StatName == NewStatName )
		{
			DrivingStats[i].TotalTime = DrivingStats[i].TotalTime + WorldInfo.TimeSeconds - DrivingStats[i].CurrentStart;
			return;
		}
	}

	// didn't find it - just fail
	;
	return;
}

function int IncrementVehicleKillStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = VehicleKillStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( VehicleKillStats[i].StatName == NewStatName )
		{
			VehicleKillStats[i].StatValue++;
			return VehicleKillStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	VehicleKillStats[Len] = NewStat;
	return 1;
}

function int IncrementPickupStat(name NewStatName)
{
	local int i, Len;
	local IntStat NewStat;

	Len = PickupStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( PickupStats[i].StatName == NewStatName )
		{
			PickupStats[i].StatValue++;
			return PickupStats[i].StatValue;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.StatValue = 1;
	PickupStats[Len] = NewStat;
	return 1;
}

function StartPowerupTimeStat(name NewStatName)
{
	local int i, Len;
	local TimeStat NewStat;

	Len = PowerupTimeStats.Length;
	for (i=0; i<Len; i++ )
	{
		if ( PowerupTimeStats[i].StatName == NewStatName )
		{
			PowerupTimeStats[i].CurrentStart = WorldInfo.TimeSeconds;
			return;
		}
	}

	// didn't find it - add a new one
	NewStat.StatName = NewStatName;
	NewStat.CurrentStart = WorldInfo.TimeSeconds;
	PowerupTimeStats[Len] = NewStat;
	return;
}

function StopPowerupTimeStat(name NewStatName)
{
	local int i, Len;

	Len = PowerupTimeStats.Length;
	for (i=0; i<Len; i++ )
	{
		if (PowerupTimeStats[i].StatName == NewStatName)
		{
			if (PowerupTimeStats[i].CurrentStart >= 0.0)
			{
				PowerupTimeStats[i].TotalTime = PowerupTimeStats[i].TotalTime + WorldInfo.TimeSeconds - PowerupTimeStats[i].CurrentStart;
				//Mark the current start in case we call stop twice
				PowerupTimeStats[i].CurrentStart = -1.0;
			}

			return;
		}
	}

	// didn't find it - just fail
	;
	return;
}

simulated function RenderMapIcon(TMMapInfo MP, Canvas Canvas, TMPlayerController HUDPlayerOwner, LinearColor FinalColor)
{
	local class<TMVehicle> VClass;
	local class<TMPawn> PClass;
	local float MapSize;
	local TextureCoordinates UVs;

	if ( HUDPawnClass == None )
	{
		return;
	}

	PClass = class<TMPawn>(HUDPawnClass);
	if ( PClass != None )
	{
		MapSize = PClass.Default.MapSize;
		UVs = PClass.Default.IconCoords;
	}
	else
	{
		VClass = class<TMVehicle>(HUDPawnClass);
		if ( VClass != None )
		{
			MapSize = VClass.Default.MapSize;
			UVs = VClass.Default.IconCoords;
		}
		else
		{
			;
			return;
		}
	}

	Canvas.SetPos(HUDLocation.X - 0.5*MapSize* MP.MapScale, HUDLocation.Y - 0.5* MapSize* MP.MapScale * Canvas.ClipY / Canvas.ClipX);
	MP.DrawRotatedTile(Canvas,class'TMHUD'.default.IconHudTexture, HUDLocation, HUDPawnYaw, MapSize, UVs, FinalColor);
}

function UpdatePlayerLocation()
{
	local TMBot B;
	local TMPlayerController PC;
	local name BotOrders;

	B = TMBot(Owner);
	if ( B != None )
	{
		BotOrders = B.GetOrders();
		if ( BotOrders == 'ATTACK' )
		{
			OrdersIndex = 2;
		}
		else if ( BotOrders == 'DEFEND' )
		{
			OrdersIndex = 3;
		}
		else if ( BotOrders == 'FOLLOW' )
		{
			OrdersIndex = 6;
		}
		else if ( BotOrders == 'HOLD' )
		{
			OrdersIndex = 7;
		}
		else
		{
			OrdersIndex = 0;
		}
		return;
	}

	PC = TMPlayerController(Owner);
	if ( PC != None )
	{
		OrdersIndex = PC.AutoObjectivePreference;
	}
}

simulated function string GetLocationName()
{
	return OrdersString[OrdersIndex];
}

reliable server function SetStartObjective(TMGameObjective Objective, bool bTemporary)
{
	if ( Objective == None || Objective.ValidSpawnPointFor(Team.TeamIndex))
	{
		// make sure old StartSpot isn't used by the spawning code since it might not be valid for the new start objective
		Controller(Owner).StartSpot = None;
		if (bTemporary)
		{
			TemporaryStartObjective = Objective;
		}
		else
		{
			StartObjective = Objective;
		}
	}
}

function TMGameObjective GetStartObjective()
{
	local TMBot B;
	local TMGameObjective SelectedPC;

	SelectedPC = TemporaryStartObjective;
	TemporaryStartObjective = None;
	if (SelectedPC != None && SelectedPC.ValidSpawnPointFor(Team.TeamIndex))
	{
		return SelectedPC;
	}
	else
	{
		B = TMBot(Owner);
		if (B != None && B.Squad != None)
		{
			return B.Squad.GetStartObjective(B);
		}
		else
		{
			return (StartObjective != None && StartObjective.ValidSpawnPointFor(Team.TeamIndex)) ? StartObjective : None;
		}
	}
}

function SetFlag(TMCarriedObject NewFlag)
{
	HasFlag = NewFlag;
	bHasFlag = (HasFlag != None);
}

function TMCarriedObject GetFlag()
{
	return HasFlag;
}

function IncrementKills(bool bEnemyKill )
{
	if ( bEnemyKill )
	{
		if ( WorldInfo.TimeSeconds - LastKillTime < 4 )
		{
			MultiKillLevel++;
			IncrementEventStat(class'TMLeaderboardWriteDM'.Default.MULTIKILL[Min(MultiKillLevel-1, 4)]);
		}
		else
		{
			MultiKillLevel = 0;
		}

		if ( bEnemyKill )
			LastKillTime = WorldInfo.TimeSeconds;

		spree++;
		if ( spree > 4 )
		{
			TMGame(WorldInfo.Game).NotifySpree(self, spree);
		}
	}
	else
	{
		MultiKillLevel = 0;
	}
}

/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	SetFlag(None);
	Spree = 0;

	KillStats.length = 0;
	DeathStats.length = 0;
	SuicideStats.length = 0;
	EventStats.length = 0;
	NodeStats.length = 0;
	VehicleKillStats.length = 0;
	PickupStats.length = 0;
	DrivingStats.length = 0;
	PowerupTimeStats.length = 0;
}

simulated function string GetCallSign()
{
	return PlayerName;
}

/* epic ===============================================
* ::OverrideWith
Get overridden properties from old PRI
*/
function OverrideWith(PlayerReplicationInfo PRI)
{
	local TMPlayerReplicationInfo TMPRI;

	Super.OverrideWith(PRI);

	TMPRI = TMPlayerReplicationInfo(PRI);
	if ( TMPRI == None )
		return;
}

/* epic ===============================================
* ::CopyProperties
Copy properties which need to be saved in inactive PRI
*/
function CopyProperties(PlayerReplicationInfo PRI)
{
	local TMPlayerReplicationInfo TMPRI;

	Super.CopyProperties(PRI);

	TMPRI = TMPlayerReplicationInfo(PRI);
	if ( TMPRI == None )
		return;

    TMPRI.CharClassInfo = CharClassInfo;

	TMPRI.CustomReplicationInfo = CustomReplicationInfo;
	TMPRI.bIsFemale = bIsFemale;

	TMPRI.KillStats = KillStats;
	TMPRI.DeathStats = DeathStats;
	TMPRI.SuicideStats = SuicideStats;
	TMPRI.Rank = Rank;
	TMPRI.Character = Character;
}

function SeamlessTravelTo(PlayerReplicationInfo NewPRI)
{
	local TMPlayerReplicationInfo TMPRI;

	Super.SeamlessTravelTo(NewPRI);

	// copy constructed character data directly
	TMPRI = TMPlayerReplicationInfo(NewPRI);
	if (TMPRI != None)
	{
        TMPRI.CharClassInfo = CharClassInfo;

		TMPRI.CharPortrait = CharPortrait;
		TMPRI.VoiceClass = VoiceClass;
		TMPRI.SinglePlayerCharacterIndex = SinglePlayerCharacterIndex;
	}
}

/**********************************************************************************************
 Teleporting
 *********************************************************************************************/

/**
 * The function is used to setup the conditions that allow a teleport.  It also defers to the gameinfo
 *
 * @Param		DestinationActor 	The actor to teleport to
 * @param		OwnerPawn			returns the pawn owned by the controlling owner casts to TMPawn
 *
 * @returns		True if the teleport is allowed
 */

function bool AllowClientToTeleport(Actor DestinationActor, out TMPawn OwnerPawn)
{
	local Controller OwnerC;

	OwnerC = Controller(Owner);

//	`log("##"@OwnerC@DestinationActor@TMGame(WorldInfo.Game).AllowClientToTeleport(Self, DestinationActor));


	if ( OwnerC != none && DestinationActor != None &&
			TMGame(WorldInfo.Game) != none && TMGame(WorldInfo.Game).AllowClientToTeleport(Self, DestinationActor) )
	{
		// Cast the Pawn as we know we need it.
		OwnerPawn = TMPawn(OwnerC.Pawn);
		if ( OwnerPawn != none )
		{
			if (bHasFlag)
			{
				GetFlag().Drop();
			}
			return true;
		}
	}

	return false;
}

/**
 * This function is used to teleport directly to actor.  Currently, only 2 types of actors
 * support teleporting.  TMGameObjectives and TMVehicle_Leviathans.
 *
 * @param	DestinationActor	This is the Actor the player is trying to teleport to
 */

server reliable function ServerTeleportToActor(Actor DestinationActor)
{
	local TMPawn OwnedPawn;

	if ( AllowClientToTeleport(DestinationActor, OwnedPawn) )
	{
		// Handle teleporting to Game Objectives
		if ( TMGameObjective(DestinationActor) != none )
		{
			TMGameObjective(DestinationActor).TeleportTo( OwnedPawn );
		}
	}
}

simulated event color GetHudColor()
{
	if ( Team != none )
	{
		return TMTeamInfo(Team).GetHudColor();
	}
	else
	{
		return DefaultHudColor;
	}
}

simulated event ReplicatedEvent(name VarName)
{
	local TMPawn TMP;

	if ( VarName == 'Team' )
	{
		foreach WorldInfo.AllPawns(class'TMPawn', TMP)
		{
			if (TMP.PlayerReplicationInfo == self || (TMP.DrivenVehicle != None && TMP.DrivenVehicle.PlayerReplicationInfo == self))
			{
				TMP.NotifyTeamChanged();
			}
		}
	}
    else if ( VarName == 'CharClassInfo' )
    {
		foreach WorldInfo.AllPawns(class'TMPawn', TMP)
		{
			if (TMP.PlayerReplicationInfo == self || (TMP.DrivenVehicle != None && TMP.DrivenVehicle.PlayerReplicationInfo == self))
			{
				TMP.SetCharacterClassFromInfo(CharClassInfo);
			}
		}
    }

	Super.ReplicatedEvent(VarName);
}

reliable simulated client function ShowMidGameMenu(bool bInitial)
{
	if ( !AttemptMidGameMenu() )
	{
		SetTimer(0.2,true,'AttemptMidGameMenu');
	}
}

simulated function bool AttemptMidGameMenu()
{
// 	local TMPlayerController PlayerOwner;
// 	local TMGameReplicationInfo GRI;
//
// 	PlayerOwner = TMPlayerController(Owner);
//
// 	if ( PlayerOwner != none )
// 	{
// 		GRI = TMGameReplicationInfo(WorldInfo.GRI);
// 		if (GRI != none)
// 		{
// 			GRI.ShowMidGameMenu(PlayerOwner,'ScoreTab',true);
// 			if ( GRI.CurrentMidGameMenu != none )
// 			{
// 				GRI.CurrentMidGameMenu.bInitial = true;
//
// 			}
// 			ClearTimer('AttemptMidGameMenu');
// 			return true;
// 		}
// 	}

	return false;
}

