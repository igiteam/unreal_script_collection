
/**
 * GearGameSP_Base
 * Gear Game single player base
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameSP_Base extends GearGame
	native
	dependson(GearPRI)
	config(Game);


/** set when URL option passed to load checkpoint immediately after level load */
var bool bStartupLoadCheckpoint;
/** set when we should save at startup (e.g. when loading a chapter point) */
var bool bStartupSaveCheckpoint;

/** current chapter we are on */
var int CurrentChapter;

/** set during the checkpoint loading process */
var transient const bool bCheckpointLoadInProgress;

/** if true and the player skips a full screen movie, replace it with the loading movie */
var transient bool bNeedBackupLoadingMovie;

/** defines a slot for a Pawn that may be human controlled */
struct native PlayerSlotInfo
{
	/** class of Pawn to use for this slot */
	var class<GearPawn> PawnClass;
	/** Controller currently controlling a Pawn of PawnClass (may be human or AI) */
	var Controller Owner;
};
var array<PlayerSlotInfo> PlayerSlots;

/** displayed in the game over screen when failing due to critical character death */
var localized string PlayerDiedText;

/** multiplier applied to damage against human players when playing co-op to adjust the difficulty a bit based on player count
 * elements correspond to player count - 2
 */
var config array<float> CoopEnemyDamageMultiplier;

/** base amount of XP to award for completing a chapter, indexed by difficulty */
var config array<int> ChapterCompletionXP;
/** percent additional XP to award for co-op
 * elements correspond to player count - 2
 */
var config array<float> CoopXPBonusPercent;

/** The beacon that is used to control JIP reservations from invites/matchmaking for coop matches */
var GearPlayerMatchBeaconHost HostCoopReservationBeacon;

/**
 * Resets the actor channel associated with the actor.  USE AT YOUR OWN RISK.
 */
native final function ResetActorChannel(Actor ChannelOwner);

event PreBeginPlay()
{
	class'GearEngine'.static.LoadGameTypeConfigs("");

	Super.PreBeginPlay();
}

/**
 * Destroy the JIP host reservation beacon
 */
function DestroyHostBeacon()
{
	// Cleanup the host beacon so socket doesn't leak
	if (HostCoopReservationBeacon != None)
	{
		HostCoopReservationBeacon.DestroyBeacon();
		HostCoopReservationBeacon = None;
	}
}

/**
 * Clear references at end of game
 */
function GameEnding()
{
	DestroyHostBeacon();

	Super.GameEnding();
}

function TeamInfo GetTeamInfo( int TeamIdx )
{
	local int i;
	for( i = 0; i < Teams.Length; i++ )
	{
		if( Teams[i].TeamIndex == TeamIdx )
		{
			return Teams[i];
		}
	}

	return None;
}

/**
* Handles moving players from one team to another, or for the initial
* team assignment.
*
* @return          true if the team change was successful
*/
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local TeamInfo Team;

	// check to see if we need to initialize teams
	if (Teams.Length < NumTeams)
	{
		InitializeTeams();
	}

	if (Other != None)
	{
		N = GetForcedTeam(Other,N);

		Team = GetTeamInfo( N );
		// if not already on that team
		if( Other.PlayerReplicationInfo.Team == None ||
			Other.PlayerReplicationInfo.Team != Team )
		{
			// remove from their current team
			if( Other.PlayerReplicationInfo.Team != None )
			{
				Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
			}

			//@STATS - Record player team change
			`RecordPlayerIntStat(TEAMCHANGE,Other,N);

			// and attempt to add them to their new team
			return Team.AddToTeam(Other);
		}
		else
		{
			return true;
		}
	}
	return false;
}

function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	if (NumPlayers > 1 && Injured.IsHumanControlled())
	{
		Damage *= CoopEnemyDamageMultiplier[NumPlayers - 2];
	}
	Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType)
{
	local GearPawn GP;

	// if our AI buddies ever die, fail the game (don't worry, they shouldn't be able to die unless we're in hardcore/insane) :P
	GP = GearPawn(KilledPawn);
	if (GP != none && PlayerController(KilledPlayer) == None)
	{
		// if this AI is in the player's squad, the player just let him die! FAIL!
		if (GP.MyGearAI != None && GP.MyGearAI.Squad.bPlayerSquad)
		{
			//@fixme - find a better method for this
			GearPawn(KilledPawn).EndGameCondition( FALSE );
		}
	}
	Super.Killed(Killer,KilledPlayer,KilledPawn,damageType);
}

function bool AutoReviveOnBleedOut(Pawn TestPawn)
{
	local GearMutator GMut;
	local GearPawn GP;
	local GearPRI GPRI;

	GP = GearPawn(TestPawn);

	if (GP != None)
	{
		GPRI = GearPRI(GP.PlayerReplicationInfo);
	}

	if (GPRI != None && GPRI.Difficulty.default.bSPSelfRevive)
	{
		return true;
	}

	GMut = GetBaseGearMutator();
	return (GMut != None && GMut.AutoReviveOnBleedOut(TestPawn));
}

function bool CanBeShotFromAfarAndKilledWhileDownButNotOut(Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType)
{
	local GearMutator GMut;
	local bool bResult;

	bResult = (TestPawn.GetTeamNum() == 1 || !GearPawn(TestPawn).bCanRechargeHealth);
	GMut = GetBaseGearMutator();
	return (GMut == None) ? bResult : GMut.CanRangeKillDBNO(bResult, TestPawn, InstPawn, TheDamageType);
}

function StartMatch()
{
	local GearPC_SP PC;

	Super.StartMatch();

	if (bStartupLoadCheckpoint)
	{
		foreach LocalPlayerControllers(class'GearPC_SP', PC)
		{
			PC.LoadCheckpoint();
			break;
		}
		bStartupLoadCheckpoint = false;
	}
	else if (bStartupSaveCheckpoint)
	{
		foreach LocalPlayerControllers(class'GearPC_SP', PC)
		{
			PC.SaveCheckpoint();
			break;
		}
		bStartupSaveCheckpoint = false;
	}
}

auto State PendingMatch
{
	function PostLogin(PlayerController NewPlayer)
	{
		Global.PostLogin(NewPlayer);

		StartMatch();
	}

	function CheckStartMatch()
	{
		// start the match immediately
		StartMatch();
	}

	function BeginState(Name PreviousStateName)
	{
		GetGRI().GameStatus = GS_PreMatch;

		// reset the visibility manager
		AIVisman.Reset();

		Super.BeginState(PreviousStateName);
	}
}

/** We wait a while to let the level stream in all of the sub levels **/
function DoMemStartupStats()
{
	SetTimer( 20.0f, FALSE, nameof(DelayedExit) );
}


/** Only 2 players allowed for coop. */
function bool AtCapacity(bool bSpectator)
{
	return (NumPlayers >= 4);
}

/**
 * Returns a pawn of the default pawn class, and player controllers will never
 * fail to spawn due to collision
 *
 * @param	NewPlayer - Controller for whom this pawn is spawned
 * @param	StartSpot - PlayerStart at which to spawn pawn
 *
 * @return	pawn
 */
function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
	local class<Pawn> DefaultPlayerClass;
	local Rotator StartRotation;
	local Pawn ResultPawn;

	// for non-player controllers, do like normal
	if (PlayerController(NewPlayer) == none)
	{
		return Super.SpawnDefaultPawnFor(NewPlayer, StartSpot);
	}

	DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);

	// don't allow pawn to be spawned with any pitch or roll
	StartRotation.Yaw = StartSpot.Rotation.Yaw;

	// don't allow spawn fails because of collision
	ResultPawn = Spawn(DefaultPlayerClass,,,StartSpot.Location,StartRotation,,true);
	if ( ResultPawn == None )
	{
		`log("Couldn't spawn player of type "$DefaultPlayerClass$" at "$StartSpot);
	}
	return ResultPawn;
}

/**
 * Changes the character class for a player when the player chooses to switch characters.
 *
 * @param	WPRI				the PlayerReplicationInfo for the player changing character
 * @param	DesiredCharacterId	the id of the character to switch to; will be one of the values from either the ECogMPCharacter
 *								or ELocustMPCharacter enums, depending on the player's team.
 */
function SetPlayerClassFromPlayerSelection( GearPRI WPRI, byte DesiredCharacterId );

// Spring cleaning before we switch maps
function PreCommitMapChange(string PreviousMapName, string NextMapName)
{
	local GearPC_SP PC;
	local Vehicle V;
	local GearPawn GP;
	local GearWeapon W;
	local int i;

	foreach WorldInfo.AllControllers(class'GearPC_SP', PC)
	{
		// make sure marcus is not in vehicle
		V = Vehicle(PC.Pawn);
		if (V != none)
		{
			GP = GearPawn(V.Driver);
			V.DriverLeave(TRUE);
			if (GP != None && !PC.IsLocalPlayerController())
			{
				GP.ForceClientStopDriving(V);
			}
		}
		else
		{
			GP = GearPawn(PC.Pawn);
			if (GP != None)
			{
				if (GP.IsCarryingAHeavyWeapon())
				{
					GP.ThrowActiveWeapon();
				}
			}
		}

		// make sure they have a valid weapon selected
		if (GearPawn(PC.Pawn) != None && PC.Pawn.Weapon == None)
		{
			foreach PC.Pawn.InvManager.InventoryActors(class'GearWeapon', W)
			{
				if (W.HasAnyAmmo())
				{
					W.ClientWeaponSet(true);
				}
				break;
			}
		}

		PC.ClientResetObjectPool(true);
	}

	// make sure we disabled any force walks, etc
	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		GP.SetConversing(false, false);
	}

	// players shouldn't be automatically destroyed on map change
	for (i = 0; i < PlayerSlots.length; i++)
	{
		if (PlayerSlots[i].Owner != None)
		{
			PlayerSlots[i].Owner.bKillDuringLevelTransition = false;
			if (PlayerSlots[i].Owner.Pawn != None)
			{
				PlayerSlots[i].Owner.Pawn.bKillDuringLevelTransition = false;
			}
		}
	}
}

function PostCommitMapChange()
{
	local GearPC_SP PC;
	local GearPawn P;

	foreach WorldInfo.AllPawns(class'GearPawn', P)
	{
		foreach WorldInfo.AllControllers(class'GearPC_SP', PC)
		{
			PC.ClientMeshFixupHack(P);
		}
	}

	//@HACK: trying to work around bug in Escape where you end up with no Marcus Pawn only when playing from the start of the game...
	foreach LocalPlayerControllers(class'GearPC_SP', PC)
	{
		if ((PC.Pawn == None || PC.Pawn.bDeleteMe) && !PC.IsInState('Dead'))
		{
			`Warn("Attempting Escape missing Pawn hack!!!!!!!!");
			PC.Pawn = None;
			RestartPlayer(PC);
		}
		break;
	}
}

function StartHumans()
{
	local PlayerController P;
	local array<PlayerController> PCList;
	local int i;

	// the ControllerList will be in the reverse of the order the controllers were spawned
	// so we start humans in reverse so that Player 1 gets Marcus and Player 2 gets Dom
	foreach WorldInfo.AllControllers(class'PlayerController', P)
	{
		PCList[PCList.length] = P;
	}

	for (i = PCList.length - 1; i >= 0; i--)
	{
		if (PCList[i].Pawn == None)
		{
			if (PCList[i].CanRestartPlayer())
			{
				RestartPlayer(PCList[i]);
			}
		}
	}
}

/** syncs up Kismet properties to the given PC from the first other one found in the level */
function SyncKismetSetProperties(GearPC_SP PC)
{
	local GearPC_SP OtherPC;

	// copy parameters that may have already been set by Kismet
	//@warning: assumes at least one local player (dedicated server not supported)
	foreach LocalPlayerControllers(class'GearPC_SP', OtherPC)
	{
		if (OtherPC != PC)
		{
			// apply on server
			PC.bCinematicMode = OtherPC.bCinematicMode;
			PC.bInvisible = OtherPC.bInvisible;
			PC.bCinemaDisableInputButtons = OtherPC.bCinemaDisableInputButtons;
			PC.bCinemaDisableInputMove = OtherPC.bCinemaDisableInputMove;
			PC.bCinemaDisableInputLook = OtherPC.bCinemaDisableInputLook;
			//@hack: don't want to copy god mode from the crane as in that case Dom needs to fight on the platform
			PC.bGodMode = OtherPC.bGodMode && (Vehicle_Crane_Base(OtherPC.Pawn) == None);
			// apply on client
			PC.ClientSetCinematicMode(OtherPC.bCinematicMode, OtherPC.bCinemaDisableInputMove, OtherPC.bCinemaDisableInputLook, !OtherPC.bCinematicMode || (OtherPC.myHUD != None ? !OtherPC.myHUD.bShowHUD : false));
			if (OtherPC.bCinemaDisableInputButtons)
			{
				PC.ClientDisableButtons();
			}
			break;
		}
	}
}

/**
 * When the player clicks this will be called.  This will then look to see what pawn should be
 * used for Restarting the Player.  If there are no players then it will spawn a marcus.  If
 * there is a marcus and no dom.  Then spawn a dom.  If there is marcus and a dom then possess the dom.
 **/
function RestartPlayer(Controller NewPlayer)
{
	local GearPC_SP HumanPlayer, OtherPC;
	local Pawn CoopPawn;
	local Inventory Inv;
	local GearPawn WP;
	local Actor ChkActor;
	local Vehicle V;
	local Weapon W;
	local Name OldSquadName;
	local GearPRI PRI;
	local int SlotIndex;

	if ( class'WorldInfo'.static.IsMenuLevel() )
	{
		`log("Not starting player because in menu level"@NewPlayer);
		return;
	}

	HumanPlayer = GearPC_SP(NewPlayer);

	// Human player joined game, find him a suitable pawn class
	if (HumanPlayer != None)
	{
		GearPRI(HumanPlayer.PlayerReplicationInfo).PawnClass = class<GearPawn>(SuggestPawnClassFor(HumanPlayer));
	}

	// players beyond the first possess an existing Pawn instead of spawning a new one
	if (HumanPlayer != None && GetNumPlayerControllersActive() > 1)
	{
		// make sure Kismet stuff is synced, as some actions that happened after join and before this
		// may not have affected this player since he hasn't actually possessed Dom yet
		SyncKismetSetProperties(HumanPlayer);
		if (!HumanPlayer.bInMatinee && !HumanPlayer.bCinematicMode && IsInState('MatchInProgress'))
		{
			// look for the coop AI and set the view target
			SlotIndex = PlayerSlots.Find('PawnClass', GearPRI(HumanPlayer.PlayerReplicationInfo).PawnClass);
			if ( SlotIndex != INDEX_NONE && AIController(PlayerSlots[SlotIndex].Owner) != None &&
				PlayerSlots[SlotIndex].Owner.Pawn != None )
			{
				CoopPawn = PlayerSlots[SlotIndex].Owner.Pawn;
			}

			// if given a specific pawn to use,
			if (CoopPawn != None && InterpActor_ZiplineHookBase(CoopPawn.Base) == None)
			{
				// revive him if he's DBNO
				if (CoopPawn.IsInState('DBNO'))
				{
					GearPawn(CoopPawn).DoRevival(None);
				}

				PRI = GearPRI(CoopPawn.PlayerReplicationInfo);
				if( PRI != None )
				{
					OldSquadName = PRI.SquadName;
					GearPRI(HumanPlayer.PlayerReplicationInfo).bForceShowInTaccom = PRI.bForceShowInTaccom;
				}

				foreach DynamicActors(class'Actor', ChkActor)
				{
					if (ChkActor.RemoteRole != ROLE_None && !ChkActor.IsA('Controller') && !ChkActor.IsA('GearVehicle') &&
						(ChkActor.IsOwnedBy(CoopPawn) || ChkActor.IsOwnedBy(CoopPawn.Controller)))
					{
						ResetActorChannel(ChkActor);
					}
				}
				// if there was a previous controller, copy bGodMode setting and detach
				if (CoopPawn.Controller != None)
				{
					HumanPlayer.bGodMode = CoopPawn.Controller.bGodMode;
					CoopPawn.DetachFromController(true);
				}
				// take over the new pawn
				NewPlayer.PlayerReplicationInfo.bOnlySpectator = false;
				NewPlayer.Possess(CoopPawn, false);

				if( OldSquadName != '' )
				{
					HumanPlayer.SetSquadName( OldSquadName );
				}

				CoopPawn.InvManager.ClearAllPendingFire(CoopPawn.Weapon);

				// make sure the pawn sets its weapons up clientside
				foreach CoopPawn.InvManager.InventoryActors(class'Weapon', W)
				{
					W.ClientWeaponSet(false);
				}
				CoopPawn.ClientRestart();
			}
		}

		if (NewPlayer.Pawn != None)
		{
			// clear any gameplay flags
			GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();

			NewPlayer.Pawn.SetHidden(false); // just in case something in Kismet gets confused by the swap
			SetPlayerDefaults(NewPlayer.Pawn);
			WP = GearPawn(NewPlayer.Pawn);
			V = Vehicle(NewPlayer.Pawn);
			if (WP != None)
			{
				// turn off infinite ammo on the weapons
				for (Inv = WP.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
				{
					if (GearWeapon(Inv) != None)
					{
						GearWeapon(Inv).bInfiniteSpareAmmo = GearWeapon(Inv).default.bInfiniteSpareAmmo;

						// unless the pawn is scripted to have unlimited clips
						if( WP.bUnlimitedClips )
						{
							GearWeapon(Inv).bInfiniteSpareAmmo = true;
						}

						// or unless a mutator insists
						CheckRelevance(Inv);
					}
				}

				NewPlayer.ClientSetRotation(WP.Rotation);

				foreach WorldInfo.AllControllers(class'GearPC_SP', OtherPC)
				{
					if (OtherPC != HumanPlayer && OtherPC.Pawn != None && OtherPC.IsInState('PlayerDrivingCrate'))
					{
						HumanPlayer.GotoState('PlayerDrivingCrate');
						HumanPlayer.ClientGotoState('PlayerDrivingCrate');
					}
				}

				// update brumak gunner if necessary
				if( GearPawn_LocustBrumakBase(WP.Base) != None )
				{
					GearPawn_LocustBrumakBase(WP.Base).SetHumanGunner( HumanPlayer != None ? GearPawn(HumanPlayer.Pawn) : None );
				}

				// set up zipline special move if necessary
				if (WP.IsDoingSpecialMove(SM_ZiplineIdle))
				{
					HumanPlayer.ServerToClientDoSpecialMove(WP.FillSMStructFromParams(WP.SpecialMove, WP.InteractionPawn, WP.SpecialMoveFlags), true);
				}
			}
			else if (V != none && V.Driver != None)
			{
				// if we're jumping into a vehicle the AI was in, we need to set defaults on the vehicle's driver
				SetPlayerDefaults(V.Driver);
				// clear any gameplay flags

				// turn off infinite ammo on the weapons
				for (Inv = V.Driver.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
				{
					if (GearWeapon(Inv) != None)
					{
						GearWeapon(Inv).bInfiniteSpareAmmo = GearWeapon(Inv).default.bInfiniteSpareAmmo;
					}
				}

				NewPlayer.ClientSetRotation(V.Rotation);
			}
		}
		else
		{
			// spawn right away if loading a checkpoint
			// or in POC maps for debug testing
			if (GearPRI(HumanPlayer.PlayerReplicationInfo).PawnClass != None && (bCheckpointLoadInProgress || HumanPlayer.PlayingDevLevel()))
			{
				Super.RestartPlayer(NewPlayer);
			}
			else
			{
				// make player try again later
				HumanPlayer.GotoState('PlayerWaiting');
				HumanPlayer.ClientGotoState('PlayerWaiting');
				HumanPlayer.SetTimer(0.5, false, nameof(HumanPlayer.ServerRestartPlayer));
			}
		}
	}
	else
	{
		// do restart normally which should restart us as our DefaultPawnClass
		Super.RestartPlayer(NewPlayer);
	}

	if (HumanPlayer != None && HumanPlayer.Pawn != None)
	{
		// the human now owns this slot
		SlotIndex = PlayerSlots.Find('PawnClass', GearPRI(HumanPlayer.PlayerReplicationInfo).PawnClass);
		if (SlotIndex != INDEX_NONE)
		{
			PlayerSlots[SlotIndex].Owner = HumanPlayer;
		}
	}
}

/**
 * Get the game settings object driving this game (online settings only)
 */
static simulated function GearCoopGameSettings GetGameSettingsObject()
{
	local OnlineSubsystem OnlineSubsystem;
	local GearCoopGameSettings CoopGameSettings;

	OnlineSubsystem = class'GameEngine'.static.GetOnlineSubsystem();
	//@todo sz - private matches don't have a 'Game' session created
	if (OnlineSubsystem != None && OnlineSubsystem.GameInterface != None)
	{
		CoopGameSettings = GearCoopGameSettings(OnlineSubsystem.GameInterface.GetGameSettings('Game'));
	}

	return CoopGameSettings;
}

event InitGame(string Options, out string ErrorMessage)
{
	local int ChapterOption, RecentPartyIdx;;
	local GearCoopGameSettings GameSettings;
	local GearRecentPlayersList RecentPlayersList;

	Super.InitGame(Options, ErrorMessage);

	if (HasOption(Options, "loadcheckpoint") && ParseOption(Options, "loadcheckpoint") != "0")
	{
		bStartupLoadCheckpoint = true;
	}
	ChapterOption = GetIntOption(Options, "chapter", -1);
	if (ChapterOption == -1)
	{
		ChapterOption = 0;
	}
	else
	{
		// always save a checkpoint immediately after loading a chapter point
		bStartupSaveCheckpoint = true;
	}
	CurrentChapter = ChapterOption;

	MaxPlayers = 4;

	// fewer players in co-op, so allow a little more bandwidth
	MaxDynamicBandwidth = 7000;

	GameSettings = GetGameSettingsObject();
	if (GameSettings.bShouldAdvertise)
	{
		// Reopen the available connections once the match starts
		GameSettings.NumPublicConnections = class'GearCoopGameSettings'.default.NumPublicConnections;
		GameInterface.UpdateOnlineGame('Game', GameSettings, false);

		// create a host beacon for accepting join in progress members
		HostCoopReservationBeacon = new class'GearPlayerMatchBeaconHost';
		HostCoopReservationBeacon.BeaconName = 'GearPlayerMatchHost';
		HostCoopReservationBeacon.OnReservationChange = OnHostBeaconReservationChange;

		// Initialize the beacon and start listening for client reservation requests
		HostCoopReservationBeacon.InitHostBeacon(1,GameSettings.NumPublicConnections,GameSettings.NumPublicConnections,'Game');

		// Add the initial reservation for members of the host party
		// The host party is stored in GearRecentPlayersList during the party lobby
		// The GearRecentPlayersList also persists prior beacon party reservations during map cycles
		RecentPlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if (RecentPlayersList != None)
		{
`if(`notdefined(FINAL_RELEASE))
			RecentPlayersList.DumpGearParties();
`endif
			// Populate host beacon with existing party reservation entries that have persisted
			for (RecentPartyIdx=0; RecentPartyIdx < RecentPlayersList.LastGearParties.Length; RecentPartyIdx++)
			{
				HostCoopReservationBeacon.AddGearPartyReservation(
					RecentPlayersList.LastGearParties[RecentPartyIdx].PartyLeader,
					RecentPlayersList.LastGearParties[RecentPartyIdx].PartyMembers,
					GameSettings.OwningPlayerId == RecentPlayersList.LastGearParties[RecentPartyIdx].PartyLeader);
			}
		}
	}
}

function InitGameReplicationInfo()
{
	Super.InitGameReplicationInfo();

	GearGRI_SP(GameReplicationInfo).ChapterNum = CurrentChapter;
}

/**
 * Sync the current reservation state of the host beacon with what
 * is advertised for the game session searches.
 */
function OnHostBeaconReservationChange()
{
	// Update party sizes we can handle
	UpdateCoopNeedWantsStatus();
}

/**
 * Updates what we have advertised for the session in terms of slots available for matchmaking.
 * Includes counts from remote parties that will fill in our game.
 * These player slots are updated whenever a player joins/leaves the current game.
 */
final private function UpdateCoopNeedWantsStatus()
{
	local int NeedSize;

	if (GameInterface != None &&
		HostCoopReservationBeacon != None)
	{
		// Host beacon maintains the team assignments
		NeedSize = HostCoopReservationBeacon.GetMaxAvailableTeamSize();
		// Update the game settings object with the new needs size
		SetGameSettingNeedsSize('Game',NeedSize);
	}
}

function PostLogin(PlayerController NewPlayer)
{
	local GearPC_SP PC;
	local Controller C;
	local bool bFoundPawn;
	local Vehicle V;
	local string MovieName;
	local GearPC_SP OtherPC;
	local int SlotIndex;
	local GearPickupFactory GPF;
	local GearPRI PRI;

	PC = GearPC_SP(NewPlayer);
	// Due to the crazy way we check capacity, a player can sneak in
	// so check at this point and kick them if they made it
	if (AtCapacity(false))
	{
		PC.ClientSetProgressMessage(PMT_ConnectionFailure,
			"<Strings:Engine.GameMessage.MaxedOutMessage>",
			"<Strings:Engine.Errors.ConnectionFailed_Title>",
			true);
		PC.ClientReturnToMainMenu();
		return;
	}

	if (LocalPlayer(NewPlayer.Player) == None)
	{
		PC.ClientLoadGameTypeConfigs("");
	}

	Super.PostLogin(NewPlayer);

	// see if we need to display the game over screen
	foreach LocalPlayerControllers(class'GearPC_SP', OtherPC)
	{
		if (OtherPC.MyGearHud.GameOverPlayer != None)
		{
			PC.ClientGameOver(OtherPC.GameOverReason, OtherPC.GameOverTarget);
			break;
		}
	}

	if ((GameReplicationInfo.bMatchHasBegun || NumPlayers > 1) && PC.Pawn == None)
	{
		PRI = GearPRI(PC.PlayerReplicationInfo);
		// if a Pawn of the desired class exists, set the player to start out spectating it
		// otherwise, restart the player immediately to spawn them a pawn
		PRI.PawnClass = class<GearPawn>(SuggestPawnClassFor(PC));
		if (PRI.PawnClass != None)
		{
			SlotIndex = PlayerSlots.Find('PawnClass', PRI.PawnClass);
			if ( SlotIndex != INDEX_NONE && PlayerSlots[SlotIndex].Owner != None &&
				PlayerSlots[SlotIndex].Owner.Pawn != None )
			{
				PC.SetViewTarget(PlayerSlots[SlotIndex].Owner.Pawn);
				PC.ClientSetViewTarget(PlayerSlots[SlotIndex].Owner.Pawn);
				bFoundPawn = true;
			}
			else
			{
				//@todo: remove this once the new slots system is up and running
				foreach WorldInfo.AllControllers(class'Controller', C)
				{
					V = Vehicle(C.Pawn);
					if ( (C.Pawn != None && C.Pawn.Class == PRI.PawnClass) ||
						(V != None && V.Driver != None && V.Driver.Class == PRI.PawnClass) )
					{
						PC.SetViewTarget(C.Pawn);
						PC.ClientSetViewTarget(C.Pawn);
						bFoundPawn = true;
						break;
					}
				}
			}
		}
		if (!bFoundPawn)
		{
			// if we couldn't find a co-op pawn to spectate, try to find some other player to spectate at least
			foreach WorldInfo.AllControllers(class'GearPC_SP', OtherPC)
			{
				if (OtherPC != PC && OtherPC.Pawn != None)
				{
					PC.SetViewTarget(OtherPC.Pawn);
					PC.ClientSetViewTarget(OtherPC.Pawn);
					break;
				}
			}
		}
		// force location of player to viewtarget in case viewtarget doesn't get received immediately
		PC.ClientSetLocation(PC.ViewTarget.Location, PC.ViewTarget.Rotation);
		SyncKismetSetProperties(PC);
		if (!bFoundPawn || LocalPlayer(PC.Player) != None) // spawn second player in splitscreen immediately, even if he joined late
		{
			RestartPlayer(PC);
		}
		else if (PC.bCinematicMode)
		{
			// set timer so player restarts as soon as the cinematic is over
			PC.SetTimer( 0.5, false, nameof(PC.ServerRestartPlayer) );
		}
	}

	// skip movies/cinematics, unless the client joins in at the beginning (party travel)
	if (LocalPlayer(PC.Player) == None && WorldInfo.TimeSeconds > 15.0)
	{
		foreach LocalPlayerControllers(class'GearPC_SP', OtherPC)
		{
			// cancel any non-loading movies
			OtherPC.GetCurrentMovie(MovieName);
			`Log("Client logged in; server is playing movie " $ MovieName);
			if (MovieName != "" && MovieName != class'GameTypes'.const.LOADING_MOVIE)
			{
				`Log("Server skipping movie " $ MovieName);
				OtherPC.ClientStopMovie(0.0, false, true, false);
			}
			else
			{
				// cancel any matinees also
				OtherPC.ConsoleCommand("CANCELCINE");
			}
		}
	}
	else
	{
		foreach LocalPlayerControllers(class'GearPC_SP', OtherPC)
		{
			// cancel any non-loading movies
			OtherPC.GetCurrentMovie(MovieName);
			if (MovieName != "" && MovieName != class'GameTypes'.const.LOADING_MOVIE)
			{
				`Log("Telling client to play movie" @ MovieName);
				PC.ClientPlayMovie(MovieName,-1,-1,false,true,true);
			}
			break;
		}
	}

	if ( (NumPlayers > 1) && !class'WorldInfo'.static.IsMenuLevel() )
	{
		// the first player controller is the host and should handle coop initialization
		ForEach LocalPlayerControllers(class'GearPC_SP', OtherPC)
		{
			// update joining player's objectives
			CopyObjectives(OtherPC, PC);

			OtherPC.CoopPlayerJoinedCampaign();
			break;
		}
	}

	// copy camera settings for splitscreen
	if (LocalPlayer(OtherPC.Player) != None && OtherPC.PlayerCamera != None)
	{
		PC.ClientSetCameraFade(OtherPC.PlayerCamera.bEnableFading, OtherPC.PlayerCamera.FadeColor, OtherPC.PlayerCamera.FadeAlpha, OtherPC.PlayerCamera.FadeTime);
	}

	//Spawn or despawn pickup factories that are dependant on the number of players
	foreach WorldInfo.AllNavigationPoints(class'GearPickupFactory', GPF)
	{
		GPF.CoopPlayerNumberChange();
	}

	// Have the client set their rich presence
	PC.ClientSetCoopRichPresence(SuggestPawnClassFor(PC),CurrentChapter);
	// Have the client start their session if it isn't already
	PC.ClientStartOnlineGame();

	PC.ClientForceStreamSPTextures();
}

/**
 * Checks to see if the PC that is logging out is a temporary one created for
 * the checkpoint handling
 *
 * @param Exiting the controller that is leaving
 */
function Logout(Controller Exiting)
{
	local GearPC_SP PC;
	local GearPickupFactory GPF;

	PC = GearPC_SP(Exiting);
	if (PC != None)
	{
		// Do not logout a player for check point dummies as this causes the NumPlayers
		// value to be incorrect allowing more players to join than are allowed
		if (!PC.bCheckpointDummy)
		{
			Super.Logout(Exiting);
		}

		// spawn or despawn pickup factories that are dependant on the number of players
		foreach WorldInfo.AllNavigationPoints(class'GearPickupFactory', GPF)
		{
			GPF.CoopPlayerNumberChange();
		}
	}
	else
	{
		Super.Logout(Exiting);
	}
}

final function CopyObjectives(GearPC_SP SourcePC, GearPC_SP DestPC)
{
	local int i;

	if (DestPC.ObjectiveMgr != None && SourcePC.ObjectiveMgr != None)
	{
		DestPC.ClientClearObjectives();
		for (i = 0; i < SourcePC.ObjectiveMgr.Objectives.length; i++)
		{
			SourcePC.ObjectiveMgr.Objectives[i].bLocatorWasSent = false;
			if (SourcePC.ObjectiveMgr.Objectives[i].Locators[0] != None)
			{
				SourcePC.ObjectiveMgr.Objectives[i].bLocatorWasSent = true;
			}
			DestPC.ClientReplicateObjective(SourcePC.ObjectiveMgr.Objectives[i], i);
		}
		if (LocalPlayer(DestPC.Player) == None)
		{
			DestPC.ObjectiveMgr.Objectives = SourcePC.ObjectiveMgr.Objectives;
		}
	}
}

/**
 * Suggests a Pawn class to use for a human player.
 *
 */
function class<Pawn> SuggestPawnClassFor(GearPC_SP Player)
{
	local int i;
	local GearPC_SP OtherPC;

	if (bCheckpointLoadInProgress)
	{
		// already set by GearPC::ApplyCheckpointRecord()
		return GearPRI(Player.PlayerReplicationInfo).PawnClass;
	}

	// see if this player has a slot already
	i = PlayerSlots.Find('Owner', Player);
	if (i != INDEX_NONE)
	{
		return PlayerSlots[i].PawnClass;
	}

	// check for an empty slot or a slot currently occupied by AI
	for (i = 0; i < PlayerSlots.length; i++)
	{
		if (PlayerController(PlayerSlots[i].Owner) == None)
		{
			// check that another pending player hasn't already been assigned this Pawn
			if (PlayerSlots[i].Owner != None)
			{
				foreach WorldInfo.AllControllers(class'GearPC_SP', OtherPC)
				{
					if (OtherPC != Player && OtherPC.ViewTarget == PlayerSlots[i].Owner.Pawn)
					{
						break;
					}
				}
			}
			if (OtherPC == None)
			{
				return PlayerSlots[i].PawnClass;
			}
		}
	}

	// otherwise return default gear class...
	return class'GearPawn_COGGear';
}

/** Returns TRUE if Player is the only player controller in game. */
function int GetNumPlayerControllersActive()
{
	local PlayerController PC;
	local int Retval;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		++Retval;
	}

	return Retval;
}

/**
 * Returns the ControllerId of a given Controller.
 * This only works for localplayers in split screen.
 */
function int GetControllerId(PlayerController PC)
{
	local LocalPlayer		LP;

	LP = LocalPlayer(PC.Player);
	if( LP != None )
	{
		return LP.ControllerId;
	}

	return -1;
}


/**
 * Returns the default pawn class for the specified controller,
 *
 * @param	C - controller to figure out pawn class for
 * @return	default pawn class
 */
function class<Pawn> GetDefaultPlayerClass(Controller C)
{
	local GearPC_SP	PC;

	PC = GearPC_SP(C);
	if (PC != None)
	{
		// use default Pawn class if it exists.
		if (GearPRI(PC.PlayerReplicationInfo).PawnClass != None)
		{
			return GearPRI(PC.PlayerReplicationInfo).PawnClass;
		}
	}

	// default to the game specified pawn class
	return DefaultPawnClass;
}

function InitializeTeams()
{
	local GearTeamInfo Team;
	local int i;
	
	Super.InitializeTeams();

	// Create neutral team if one doesn't exist
	for( i = 0; i < Teams.Length; i++ )
	{
		if( Teams[i].TeamIndex == 254 )
		{
			Team = Teams[i];
			break;
		}
	}

	if( Team == None )
	{
		Team = Spawn( class'GearTeamInfo', self );
		Team.TeamIndex = 254;
		Teams.AddItem(Team);
	}
}


function int GetForcedTeam(Controller Other, int Team)
{
	if( Team == 254 )
	{
		return Team;
	}

	// make sure a valid team is specified, defaulting to enemy team
	if( Other.IsA('PlayerController') )
	{
		return 0;
	}
	else if( Team < 0 || Team >= NumTeams )
	{
		return 1;
	}
	else
	{
		return Team;
	}
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
	return (GearAI_COGGear(ViewTarget.Owner) != None || GearPC_SP(ViewTarget.Owner) != None);
}

function bool IsValidStartSpot(NavigationPoint Nav)
{
	local Controller CheckPlayer;

	foreach WorldInfo.AllControllers(class'Controller', CheckPlayer)
	{
		if (CheckPlayer.Pawn != None && VSize(CheckPlayer.Pawn.Location - Nav.Location) < 2.f * (CheckPlayer.Pawn.CylinderComponent.CollisionRadius + CheckPlayer.Pawn.CylinderComponent.CollisionHeight))
		{
			return false;
		}
		else if (bWaitingToStartMatch && CheckPlayer.StartSpot == Nav)
		{
			// so we avoid starting two players in the same place
			return false;
		}
	}

	return true;
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Result;

	Result = Super.RatePlayerStart(P, Team, Player);
	if (!IsValidStartSpot(P))
	{
		Result *= 0.4;
	}
	return Result;
}

/** @return whether the passed in player's death should cause the game to end in failure */
function bool ShouldDeathCauseFailure(GearPC DeadPC)
{
	return true;
}

function StartBots();

/** @return multiplier to XP earned from this mode due to mutators, co-op bonuses, etc */
final function float GetXPMultiplier()
{
	local float Result;
	local GearMutator GMut;

	Result = 1.0;
	// co-op bonus
	if (NumPlayers > 1)
	{
		Result += CoopXPBonusPercent[NumPlayers - 2];
	}
	// mutator bonus or penalty
	for (GMut = GetBaseGearMutator(); GMut != None; GMut = GMut.GetNextGearMutator())
	{
		Result += GMut.SPXPBonusPercent;
	}

	// clamp so you always get at least a little XP
	return FMax(Result, 0.1);
}

event Tick(float DeltaTime)
{
	local GearPC_SP PC;
	local string MovieName;
	local bool bForceLoadingMovie;

	Super.Tick(DeltaTime);

	if (bNeedBackupLoadingMovie)
	{
		foreach LocalPlayerControllers(class'GearPC_SP', PC)
		{
			PC.GetCurrentMovie(MovieName);
			if (MovieName == "")
			{
				bForceLoadingMovie = true;
				break;
			}
		}
		if (bForceLoadingMovie)
		{
			foreach WorldInfo.AllControllers(class'GearPC_SP', PC)
			{
				PC.ClientStopMovie(0.0, false, false, false);
				PC.ClientShowLoadingMovie(true);
			}
			bNeedBackupLoadingMovie = false; // so we don't spam it if movie playing fails (e.g. "-nomovie" command line option)
		}
	}
}

state MatchInProgress
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		GetGRI().bIsCoop = true;
	}
}

/** Iterate over all the GearPCs doing a 'fade in' when you skip the cinematic. */
event MatineeCancelled()
{
	local GearPC_SP WPC;
	local color FadeColor;

	foreach WorldInfo.AllControllers(class'GearPC_SP',WPC)
	{
		WPC.ClientColorFade(FadeColor, 255, 0, 2.0);
	}
}

/** notification that we have finished loading a checkpoint */
event CheckpointLoadComplete()
{
	local GearPC_SP PC, HostPC;
	local GearAI AI;
	local array<SequenceObject> AllCheckpointEvents;
	local Sequence GameSeq;
	local int i;
	local Pawn P;
	local array<GearPC_SP> Players;
	local Name LastCheckpointName;
	local SeqEvent_CheckpointLoaded Evt;

	// reinit the AI visibility manager
	AIVisMan = new(self) default.AIVisMan.Class(default.AIVisMan);

	// clear any old countdown timer
	GearGRI(GameReplicationInfo).StopCountdown(true, false);

	// trigger any pending AI move actions that were loaded from the checkpoint
	foreach WorldInfo.AllControllers(class'GearAI', AI)
	{
		if (AI.PendingCheckpointMoveAction != None)
		{
			AI.OnAIMove(AI.PendingCheckpointMoveAction);
			AI.PendingCheckpointMoveAction = None;
		}
	}

	foreach LocalPlayerControllers(class'GearPC_SP', HostPC)
	{
		break;
	}

	// block to handle any first frame load requests from Kismet (for checkpoints saved at level startup)
	HostPC.SetTimer(0.01, false, nameof(HostPC.ClientSetBlockOnAsyncLoading));

	// reverse the order of the PCs so that we do the below processing in order of joins (important for matching up player slots consistently)
	foreach WorldInfo.AllControllers(class'GearPC_SP', PC)
	{
		Players.InsertItem(0, PC);

		if( PC.IsPrimaryPlayer() )
		{
			LastCheckpointName = PC.LastCheckpointSaveName;
		}
	}
	foreach Players(PC)
	{
		// spawn them in if they didn't get a Pawn (e.g. because the checkpoint was saved with the AI controlling that pawn)
		if (PC.Pawn == None || PC.Pawn.bDeleteMe)
		{
			RestartPlayer(PC);
		}

		if (PC != HostPC)
		{
			CopyObjectives(HostPC, PC);
		}

		// reset cinematic flags
		PC.bGodMode = PC.IsInState('PlayerBrumakGunner');
		PC.bCinematicMode = false;
		PC.bInMatinee = false;
		PC.bInvisible = false;
		// clear trigger flags
		if (PC.MyGearPawn != None && PC.MyGearPawn.bInsideDoorTrigger)
		{
			PC.OnExitDoorTrigger();
		}
		// reset the camera
		if (PC.PlayerCamera != None)
		{
			PC.PlayerCamera.Destroy();
			PC.SpawnPlayerCamera();
		}
		// tell client to reset stuff
		PC.bClientLoadingCheckpoint = true;
		PC.ClientCheckpointReset();

		// force texture loading for all the characters that were in the checkpoint
		foreach WorldInfo.AllPawns(class'Pawn', P)
		{
			// ignore Marcus/Dom because they're already hardcoded to be streamed in all the time
			if (P.Class != class'GearPawn_COGMarcus' && P.Class != class'GearPawn_COGDom')
			{
				PC.ClientPrestreamTexturesFor(P.Class);
			}
		}
	}

	// trigger Kismet event
	GameSeq = WorldInfo.GetGameSequence();
	if (GameSeq != None)
	{
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_CheckpointLoaded', true, AllCheckpointEvents);
		for (i = 0; i < AllCheckpointEvents.length; i++)
		{
			Evt = SeqEvent_CheckpointLoaded(AllCheckpointEvents[i]);
			if( Evt.FindCheckPointName == '' || Evt.FindCheckPointName == LastCheckpointName )
			{
				Evt.CheckActivate(self, None);
			}
		}
	}

	// @STATS - Start logging after checkpoint load
	StartLogging();
	StartOnlineGame();
}

function bool ShouldRespawn( PickupFactory Other )
{
	return false;
}

defaultproperties
{
	StatGametypeSuffix="SP"

	bWaitingToStartMatch=true
	bTeamGame=true
	bShouldDisplayWeaponPickupsViaTaccom=false
	bShouldDisplayTaggedGrenadesViaTaccom=false
	bShouldDisplayAlliesViaTaccom=false

	// We support 4 player coop now
	MaxPlayersAllowed=4

	LeaderboardId=0xFFFE0000
	ArbitratedLeaderboardId=0xFFFF0000

	// Specify the campaign lobby specific PC
	PlayerControllerClass=class'GearGame.GearPC_SP'

	// Use the campaign lobby game PRI
	PlayerReplicationInfoClass=class'GearGame.GearPRI_SP'

	GameReplicationInfoClass=class'GearGame.GearGRI_SP'
}
