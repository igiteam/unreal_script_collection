//=============================================================================
// The GameInfo defines the game being played: the game rules, scoring, what actors
// are allowed to exist in this game type, and who may enter the game.  While the
// GameInfo class is the public interface, much of this functionality is delegated
// to several classes to allow easy modification of specific game components.  These
// classes include GameInfo, AccessControl, Mutator, BroadcastHandler, and GameRules.
// A GameInfo actor is instantiated when the level is initialized for gameplay (in
// C++ UGameEngine::LoadMap() ).  The class of this GameInfo actor is determined by
// (in order) either the URL, or the
// DefaultGame entry in the game's .ini file (in the Engine.Engine section), unless
// its a network game in which case the DefaultServerGame entry is used.
// The GameType used can be overridden in the GameInfo script event SetGameType(), called
// on the game class picked by the above process.
//
// Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class TPGameInfo extends GameInfo
	config(Game)
	native;

// Bullet Decal Manager
//var BulletDecalManager BulletDecalManager;


//var TPDebugInfo DebugInfo;
var bool bKynapseEnabled;

var config bool bOutputTPAIToLogWindow;

/** Array of nazi attractors we maintain for efficiency. */
var() array<TPNaziAttractor>		NaziAttractorCache;

var() array<TPWeapon>				G47SniperCache;
var bool bLastGoggleSetting;

// Stuff for intel pickups
const NumTotalIntelPickups=19;
var	localized string IntelPickupTitle[NumTotalIntelPickups];
var	localized string IntelPickupText[NumTotalIntelPickups];
var int CurrentIntelPickup;

var string GameHostURL;

// variables for difficulty levels
var OnlineProfileSettings.EProfileDifficultyOptions CurrentDifficulty;

var config float EasyMinAccuracyMultiplier;
var config float NormalMinAccuracyMultiplier;
var config float HardMinAccuracyMultiplier;
var config float InsaneMinAccuracyMultiplier;
var float CurrMinAccuracyMultiplier;

var config float EasyMaxAccuracyMultiplier;
var config float NormalMaxAccuracyMultiplier;
var config float HardMaxAccuracyMultiplier;
var config float InsaneMaxAccuracyMultiplier;
var float CurrMaxAccuracyMultiplier;

var config float EasyPlayerHealthMultiplier;
var config float NormalPlayerHealthMultiplier;
var config float HardPlayerHealthMultiplier;
var config float InsanePlayerHealthMultiplier;
var float CurrPlayerHealthMultiplier;

var config float EasyNPCHealthMultiplier;
var config float NormalNPCHealthMultiplier;
var config float HardNPCHealthMultiplier;
var config float InsaneNPCHealthMultiplier;
var float CurrNPCHealthMultiplier;

// List of Multiplayer Weapon Strings
var config array<string> WeaponList;

native function CloseTPAILog();
//native function SetEngineDebugInfo();

native final function array<string> GetAllMasterMaps();

native final function String GetLocalMapName();

//function PreBeginPlay()
//{
//	super.PreBeginPlay();
//
//	// Initialize the DecalManager for Bullets;
//	/*if (BulletDecalManager == none)
//	{
//		BulletDecalManager = new(Outer) class'BulletDecalManager';
//		BulletDecalManager.Initialize();
//	}*/
//
//	/*if( DebugInfo == None )
//	{
//		DebugInfo = new(Outer) class'TPDebugInfo';
//		SetEngineDebugInfo();
//	}*/
//
//}

/**
 * @Returns true if we should show a lobby on login
 */
function bool ShowLobby(TPPlayerController LobbyTarget)
{
	return false;
}

function HandleLobby(TPPlayerController LobbyPC)
{
	local TPGameReplicationInfo TPGRI;
	TPGRI = GetGRI();

	if (ShowLobby( LobbyPC ) )
	{
		LobbyPC.ClientLoadingScreen(false);
		if (TPGRI.GameStatus == GS_Lobby)
			LobbyPC.ClientOpenLobby(bTeamGame);
		else if (TPGRI.GameStatus > GS_Lobby)
			LobbyPC.ClientOpenCharacterSelectScreen(bTeamGame);
	}
}

/**
 * Bring up any lobbies if needed.
 */
event PostLogin( PlayerController NewPlayer )
{
	local TPPlayerController PC;

	Super.PostLogin(NewPlayer);

	PC = TPPlayerController(NewPlayer);
	if (PC != None)
	{
		HandleLobby(PC);
	}
}

function PlayerDeath(Controller C);


final function TPGameReplicationInfo GetGRI()
{
	return TPGameReplicationInfo(GameReplicationInfo);
}

//-----------------------------------------------------------------------
// Function:
// Description:	Override InitGame() to do our own inits...
//-----------------------------------------------------------------------
event InitGame( string Options, out string ErrorMessage )
{
	//We want a warning if we are not running with final_release scripts.  This is as good a place as any...






	//Close any outstanding AI logs...
	CloseTPAILog();
	Super.InitGame(Options, ErrorMessage);
}

auto State PendingMatch
{
Begin:
	StartMatch();
}

/**
 * Notification that we have a new kryll repulsor, add it to out list.
 * Server only, clients shouldn't care.
 */
function RegisterNaziAttractor(TPNaziAttractor KRC)
{
	local int Idx;

	// clean up list here to make sure it doesn't run away
	for (Idx=0; Idx<NaziAttractorCache.Length; ++Idx)
	{
		if (NaziAttractorCache[Idx] == None)
		{
			NaziAttractorCache.Remove(Idx, 1);
			Idx--;
		}
	}

	// add our new one
	NaziAttractorCache[NaziAttractorCache.Length] = KRC;
}

native function bool InNaziAttractorDanger(vector TestLocation);

function RegisterG47Sniper(TPWeapon myG47)
{
	local int Idx;
	// clean up list here to make sure it doesn't run away
	for (Idx=0; Idx<G47SniperCache.Length; ++Idx)
	{
		if (G47SniperCache[Idx] == None)
		{
			G47SniperCache.Remove(Idx, 1);
			Idx--;
		}
	}

	// add our new one
	G47SniperCache[G47SniperCache.Length] = myG47;
}

function ToggleG47UVLights(bool flag)
{
	local int Idx;
	// clean up list here to make sure it doesn't run away
	for (Idx=0; Idx<G47SniperCache.Length; ++Idx)
	{
		if (G47SniperCache[Idx] == None)
		{
			G47SniperCache.Remove(Idx, 1);
			Idx--;
		}
		else
		{
			G47SniperCache[Idx].ToggleUVLight(flag);
		}
	}

	bLastGoggleSetting=flag;
}

/** When restarting from a Checkpoint this is called from the CheckpointManager **/
event RestartFromCheckpoint( TPPlayerController NewPlayer )
{
	WorldInfo.Game.bRestartLevel = true;
	if (NewPlayer.Pawn == None)
	{
		RestartPlayer( NewPlayer );
	}
	else
	{
		NewPlayer.Restart(false);
	}
}

function CleanupBeforeCheckpointTransition()
{
	local TPPlayerController PC;
	local TPPawn P;
	local bool bHasKilledAI;
	local Trigger chkTrigger;
	local TriggerVolume chkTriggerVol;
	local int idx;

	if ( true )	// temp, for grouping
	{
		// make sure non-player characters don't drop their weapons, since they are about to get killed
	 	foreach DynamicActors(class'TPPawn', P)
	 	{
			if (TPPlayerController(P.Controller) == None)
			{
				P.bAllowInventoryDrops = FALSE;
			}
	 	}
	}

	// do this as a second pass because the Cleanup function may destroy the pawns that hold the weapons
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
        // Shut Off BARPH Factories if Active
        TPSinglePlayerGameInfo(PC.WorldInfo.Game).DeactivateBARPH();
           
		// If the player was in aim-down sight mode, then toggle it off
		P = TPPawn(PC.Pawn);
		if (P != None && P.bIsAimDownSight)
		{
			PC.ToggleAimDownSight();
		}

        if ( !bHasKilledAI )
		{
			// this code (killing ai) must happen before we start cleanup on the player controllers
			bHasKilledAI = true;

			// Kill all enemies and friendlies
			PC.Kill( "enemies" );
			PC.Kill( "ai" );
			PC.Kill("grenade");
			PC.Kill("gear");
		}


		;
		PC.PlayerCleanupBeforeCheckpointOrTransition();

		// make sure to turn off any red death PP
		LocalPlayer(PC.Player).ClearPostProcessSettingsOverride();
		// PC.ClientStopPostProcessOverride(eWPP_Gameover);
	}


	// kill off player pawns so they are not in the world and GC will actually collect them
	foreach WorldInfo.AllPawns( class'TPPawn', P )
	{
		if( PlayerPawn(P) != none )
		{
			;
			P.Destroy();
		}
	}

	// kill player pawns
	foreach WorldInfo.AllControllers( class'TPPlayerController', PC )
	{
		if (PC.Pawn != none)
		{
			;
			PC.Pawn.Destroy();

			// now clear the player's Pawn so that when we call StartHumans, the player gets a new pawn.  Since we don't garbage collect
			// between now and then, the player's Pawn would otherwise still be pointing to this destroyed pawn when RestartPlayer is called
			// and the player would not get a new pawn.
			PC.Pawn = None;
		}

		// reset the camera
		TPPlayerCamera(PC.PlayerCamera).Reset();
	}

	// flush battlestatus
//	BattleMonitor.Reset();

	class'SeqAct_CrossFadeMusicTracks'.static.StopAllMusicManagerSounds();

	// kill player pawn timers
/*	foreach WorldInfo.AllControllers( class'TPPlayerController', PC )
	{
		// clear the gameover timers; this must occur after we've called all of the Destroy-type functions on all
		// PlayerControllers and Pawns because those functions may decide to set these timers again
		PC.ClearTimer('OpenGameoverSceneFromDelay');
		PC.ClearTimer('StartProcessGameOverTimer');
	}*/

	// Reset the triggers
	foreach AllActors(class'Trigger',chkTrigger)
	{
		for (idx = 0; idx < chkTrigger.GeneratedEvents.Length; idx++)// evtList.Length; idx++)
		{
//			`Log("Resetting"@chkTrigger.GeneratedEvents[idx]);
			chkTrigger.GeneratedEvents[idx].Reset();
		}
//		`Log("Resetting"@chkTrigger);
		chkTrigger.Reset();
	}
	foreach AllActors(class'TriggerVolume',chkTriggerVol)
	{
		for (idx = 0; idx < chkTriggerVol.GeneratedEvents.Length; idx++)// evtList.Length; idx++)
		{
//			`Log("Resetting"@chkTriggerVol.GeneratedEvents[idx]);
			chkTriggerVol.GeneratedEvents[idx].Reset();
		}
//		`Log("Resetting"@chkTriggerVol);
		chkTriggerVol.Reset();
	}
	
	StartHumans();
}

/**
 * Overidden so we can have our pawn just be reset nicely as there is all kinds of logic
 * that shorts circuits the call to ClientRestart
 **/
function RestartPlayer(Controller NewPlayer)
{
	Super.RestartPlayer(NewPlayer);

	// our pawn will not be killed can prob call NewPlayer.Reset()
	NewPlayer.Pawn.ClientRestart();
}

// Spring cleaning before we switch maps
event PreCommitMapChange(string PreviousMapName, string NextMapName)
{
	local TPPlayerController PC;
	local TPWeapon Weapon;
	local TPInventoryManager InvManager;
	local Vehicle V;
	local int Slot;

	// we'll only set the ckp_loadout's bIsValid flag to TRUE if we successfully stored the player's current weapons
	local bool bFoundValidWeapon;

	bFoundValidWeapon = false;

	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		// make sure marcus is not in vehicle
		V = Vehicle(PC.Pawn);
		if (V != none)
		{
			V.DriverLeave(TRUE);
		}

		if ( PC.Pawn != None )
		{
			// get the war inventory manager
			InvManager = TPInventoryManager(PC.Pawn.InvManager);
			if ( InvManager != None )
			{
				for (Slot = 0; Slot < 4; Slot++)
				{
					// remember the weapons the players had
					Weapon = TPWeapon(InvManager.GetWeaponInSlot(Slot));
					bFoundValidWeapon = bFoundValidWeapon || Weapon != None;

					if (Weapon != None)
					{
						PC.CKP_Loadout.WeaponName[Slot] = PathName(Weapon.Class);
						PC.CKP_Loadout.AmmoInMagazine[Slot] = Weapon.AmmoInMagazine;
						PC.CKP_Loadout.AmmoCount[Slot] = Weapon.AmmoCount;

                        if (PC.Pawn.Weapon == Weapon)
                            PC.CKP_Loadout.SelectedWeapon = Slot;
					}
				}
				
			    if ( bFoundValidWeapon )
			    {
				    PC.CKP_Loadout.bIsValid = true;
			    }
			}

            TPPawn(PC.Pawn).bAllowInventoryDrops = false;
		}
	}

	CleanupBeforeCheckpointTransition();
}

/** applies the given player's saved loadout, if any */
function ApplyCheckpointLoadout(TPPlayerController PC)
{
	local int Idx;
	local class<Inventory> InvClass;
	local Inventory Inv;
	local TPPawn WP;
	local TPWeapon Weapon;
    local TPWeapon ActiveWeapon;
    local bool     bPrevAllowInventoryDrops;

	if ( PC.CKP_Loadout.bIsValid )
	{
		WP = TPPawn(PC.Pawn);
		if (WP == None && Vehicle(PC.Pawn) != None)
		{
			WP = TPPawn(Vehicle(PC.Pawn).Driver);
		}

		if ( WP != None )
		{
			// clear out current inventory
            bPrevAllowInventoryDrops = WP.bAllowInventoryDrops;

            WP.bAllowInventoryDrops  = false;
			WP.InvManager.DiscardInventory();
            WP.bAllowInventoryDrops = bPrevAllowInventoryDrops;

			// spawn new one that exist in this level
			for (Idx = 0; Idx < 4; Idx++)
			{
				// make sure the weapon is usable (some non-native weapons aren't in all maps)
				InvClass = class<Inventory>(FindObject(PC.CKP_Loadout.WeaponName[Idx],class'class'));
				if (InvClass != None)
				{
					Inv = WP.InvManager.CreateInventory(InvClass, (Idx != PC.CKP_Loadout.SelectedWeapon));
					Weapon = TPWeapon(Inv);

                    if (Weapon != None)
					{
						Weapon.AmmoInMagazine = PC.CKP_Loadout.AmmoInMagazine[Idx];
						Weapon.AmmoCount      = PC.CKP_Loadout.AmmoCount[Idx];

                        if (Idx == PC.CKP_Loadout.SelectedWeapon)
                            ActiveWeapon = Weapon;
					}
				}
			}

			PC.CKP_Loadout.bIsValid = false;

            WP.Weapon.GoToState('Active');                 // To ensure weapon will be switched
		    WP.InvManager.SetCurrentWeapon(ActiveWeapon);  // Make wanted weapon pending
            TPWeapon(WP.Weapon).WeaponIsDown();            // Put down current weapon
            WP.Weapon.GoToState('Active');                 // bypass equip anims
		}
	}
}

// Spring cleaning after we switch maps
function PostCommitMapChange()
{
	local TPPlayerController PC;

	// restore the weapons/ammo
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.bCommitMapChangePending = false;
		ApplyCheckpointLoadout(PC);
	}
}

function SetDifficultyLevel(int NewDifficulty)
{
	CurrentDifficulty = EProfileDifficultyOptions(NewDifficulty);

	switch (CurrentDifficulty)
	{
		case PDO_Normal:
			CurrMinAccuracyMultiplier = NormalMinAccuracyMultiplier;
			CurrMaxAccuracyMultiplier = NormalMaxAccuracyMultiplier;
			CurrPlayerHealthMultiplier = NormalPlayerHealthMultiplier;
			CurrNPCHealthMultiplier = NormalNPCHealthMultiplier;
			break;
		case PDO_Easy:
			CurrMinAccuracyMultiplier = EasyMinAccuracyMultiplier;
			CurrMaxAccuracyMultiplier = EasyMaxAccuracyMultiplier;
			CurrPlayerHealthMultiplier = EasyPlayerHealthMultiplier;
			CurrNPCHealthMultiplier = EasyNPCHealthMultiplier;
			break;
		case PDO_Hard:
			CurrMinAccuracyMultiplier = HardMinAccuracyMultiplier;
			CurrMaxAccuracyMultiplier = HardMaxAccuracyMultiplier;
			CurrPlayerHealthMultiplier = HardPlayerHealthMultiplier;
			CurrNPCHealthMultiplier = HardNPCHealthMultiplier;
			break;
		case PDO_Insane:
			CurrMinAccuracyMultiplier = InsaneMinAccuracyMultiplier;
			CurrMaxAccuracyMultiplier = InsaneMaxAccuracyMultiplier;
			CurrPlayerHealthMultiplier = InsanePlayerHealthMultiplier;
			CurrNPCHealthMultiplier = InsaneNPCHealthMultiplier;
			break;
	}

// 	`log("Difficulty set to"@CurrentDifficulty);
// 	`log("CurrMinAccuracyMultiplier"@CurrMinAccuracyMultiplier);
// 	`log("CurrMaxAccuracyMultiplier"@CurrMaxAccuracyMultiplier);
// 	`log("CurrPlayerHealthMultiplier"@CurrPlayerHealthMultiplier);
// 	`log("CurrNPCHealthMultiplier"@CurrNPCHealthMultiplier);
}


// Here you define the properties and classes your game type will use
// Such as the HUD, scoreboard, player controller, replication (networking) controller

