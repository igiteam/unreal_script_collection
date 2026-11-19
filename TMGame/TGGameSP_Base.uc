/**
 * TGGameSP_Base
 * TM Game single player base
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGGameSP_Base extends TGGame
	native(TGGame)
	dependson(TGPRI)
	config(Game);

///** If this is true, skip all handling of Dom leaving, otherwise do the normal code */
//var bool bHasHostAcceptedAnInvite;
//
///** set when URL option passed to load checkpoint immediately after level load */
//var bool bStartupLoadCheckpoint;
///** set when we should save at startup (e.g. when loading a chapter point) */
//var bool bStartupSaveCheckpoint;
//
///** current chapter we are on */
//var EChapterPoint CurrentChapter;

/** set during the checkpoint loading process */
var transient const bool bCheckpointLoadInProgress;

///** if true and the player skips a full screen movie, replace it with the loading movie */
//var transient bool bNeedBackupLoadingMovie;


var class<TMFamilyInfo>     SPFamliyInfo;

var   HDGFxMilitary   MilitaryMoive;
var   int             MilitaryLevel;
var   int             NextLevel;

/**
 * Resets the actor channel associated with the actor.  USE AT YOUR OWN RISK.
 */
native final function ResetActorChannel(Actor ChannelOwner);

event PreBeginPlay()
{
	LoadGameTypeConfigs("");

	Super.PreBeginPlay();
}

/**
* Handles moving players from one team to another, or for the initial
* team assignment.
*
* @return          true if the team change was successful
*/
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	// check to see if we need to initialize teams
	if (Teams.Length < NumTeams)
	{
		InitializeTeams();
	}
	if (Other != None)
	{
		N = GetForcedTeam(Other,N);
		// if not already on that team
		if (Other.PlayerReplicationInfo.Team == None ||
			Other.PlayerReplicationInfo.Team != Teams[N])
		{
			// remove from their current team
			if (Other.PlayerReplicationInfo.Team != None)
			{
				Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
			}
			// and attempt to add them to their new team
			return Teams[N].AddToTeam(Other);
		}
		else
		{
			return true;
		}
	}
	return false;
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType)
{
	local TGPawn GP;

	// if our AI buddies ever die, fail the game (don't worry, they shouldn't be able to die unless we're in hardcore/insane) :P
	GP = TGPawn(KilledPawn);
	if (GP != none && PlayerController(KilledPlayer) == None)
	{
		// if this AI is in the player's squad, the player just let him die! FAIL!
		if (GP.MyTGAI != None && GP.MyTGAI.Squad.bPlayerSquad)
		{
			//@fixme - find a better method for this
			TGPawn(KilledPawn).EndGameCondition( FALSE );
		}
	}
	Super.Killed(Killer,KilledPlayer,KilledPawn,damageType);
}

function StartMatch()
{
	//local TGPC PC;

	Super.StartMatch();

	//if (bStartupLoadCheckpoint)
	//{
	//  foreach LocalPlayerControllers(class'TGPC', PC)
	//  {
	//      PC.LoadCheckpoint();
	//      break;
	//  }
	//  bStartupLoadCheckpoint = false;
	//}
	//else if (bStartupSaveCheckpoint)
	//{
	//  foreach LocalPlayerControllers(class'TGPC', PC)
	//  {
	//      PC.SaveCheckpoint();
	//      break;
	//  }
	//  bStartupSaveCheckpoint = false;
	//}
}

auto State PendingMatch
{
	function PostLogin(PlayerController NewPlayer)
	{
		Global.PostLogin(NewPlayer);

		//StartMatch();
	}

	function CheckStartMatch()
	{
		//[WK:
		bPendingMatch = True;

		// start the match immediately
		if(!bKismetWaitToStartMatch)
			StartMatch();

		bPendingMatch = False;
		//WK]
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
	return (NumPlayers == 2);
}

/**
 * Returns a pawn of the default pawn class, and player controllers will never
 * fail to spawn due to collision
 *
 * @param   NewPlayer - Controller for whom this pawn is spawned
 * @param   StartSpot - PlayerStart at which to spawn pawn
 *
 * @return  pawn
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
		;
	}
	return ResultPawn;
}

/**
 * Changes the character class for a player when the player chooses to switch characters.
 *
 * @param   WPRI                the PlayerReplicationInfo for the player changing character
 * @param   DesiredCharacterId  the id of the character to switch to; will be one of the values from either the ECogMPCharacter
 *                              or ELocusTGPCharacter enums, depending on the player's team.
 */
function SetPlayerClassFromPlayerSelection( TGPRI WPRI, byte DesiredCharacterId );

// Spring cleaning before we switch maps
function PreCommitMapChange(string PreviousMapName, string NextMapName)
{
	local TGPC PC;
	//local Vehicle V;
	local TGPawn GP;
	//local TGWeapon W;

	foreach WorldInfo.AllControllers(class'TGPC', PC)
	{
		//// make sure marcus is not in vehicle
		//V = Vehicle(PC.Pawn);
		//if (V != none)
		//{
		//  GP = TGPawn(V.Driver);
		//  V.DriverLeave(TRUE);
		//  if (GP != None && !PC.IsLocalPlayerController())
		//  {
		//      GP.ForceClientStopDriving(V);
		//  }
		//}
		//else
		//{
		//  GP = TGPawn(PC.Pawn);
		//  if (GP != None)
		//  {
		//      if (GP.IsCarryingAHeavyWeapon())
		//      {
		//          GP.ThrowActiveWeapon();
		//      }
		//  }
		//}

		//// make sure they have a valid weapon selected
		//if (TGPawn(PC.Pawn) != None && PC.Pawn.Weapon == None)
		//{
		//  foreach PC.Pawn.InvManager.InventoryActors(class'TGWeapon', W)
		//  {
		//      if (W.HasAnyAmmo())
		//      {
		//          W.ClientWeaponSet(true);
		//      }
		//      break;
		//  }
		//}

		PC.ClientResetObjectPool();
	}

	// make sure we disabled any force walks, etc
	foreach WorldInfo.AllPawns(class'TGPawn', GP)
	{
		GP.bScriptedWalking = false;
		GP.SetConversing(false, false);
	}
}

function PostCommitMapChange()
{
	local TGPC PC;
	local TGPawn P;

	foreach WorldInfo.AllPawns(class'TGPawn', P)
	{
		foreach WorldInfo.AllControllers(class'TGPC', PC)
		{
			PC.ClientMeshFixupHack(P);
		}
	}

	//@HACK: trying to work around bug in Escape where you end up with no Marcus Pawn only when playing from the start of the game...
	foreach LocalPlayerControllers(class'TGPC', PC)
	{
		if ((PC.Pawn == None || PC.Pawn.bDeleteMe) && !PC.IsInState('Dead'))
		{
			;
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
function SyncKismetSetProperties(TGPC PC)
{
	local TGPC OtherPC;

	// copy parameters that may have already been set by Kismet
	foreach WorldInfo.AllControllers(class'TGPC', OtherPC)
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
			//PC.bGodMode = OtherPC.bGodMode && (Vehicle_Crane_Base(OtherPC.Pawn) == None);
			PC.bGodMode = OtherPC.bGodMode;
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
	//local Controller C;
	local TGPC HumanPlayer;//, OtherPC;
	//local Pawn CoopPawn;
	//local Inventory Inv;
	//local TGPawn WP;
	//local Actor ChkActor;
	//local Vehicle V;
	//local Weapon W;
	//local Name OldSquadName;
	//local TGPRI PRI;

	if ( class'WorldInfo'.static.IsMenuLevel() )
	{
		;
		return;
	}

	//`log( "RestartingPlayer: " $ NewPlayer );

	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ NewPlayer @ "ControllerId:" @ GetControllerId(PlayerController(NewPlayer)) );

	//ScriptTrace();

	HumanPlayer = TGPC(NewPlayer);

	// Human player joined game, find him a suitable pawn class
	if( HumanPlayer != None )
	{
		HumanPlayer.DefaultPawnClass = SuggestPawnClassFor(HumanPlayer);
	}


	//`log(`location@`showobj(HumanPlayer)@`showobj(HumanPlayer.Pawn)@`showobj(HumanPlayer.DefaultPawnClass));


	// NOTE:  with this type of mechanic we should be able to have an "if" statement
	//        for each COG member.  so we could have a Baird and Gus check also
	//        AS LONG as they get the correct SuggestPawnClassFor we should be gtg
	//        aka coop 4 players!!!!!

	// if we were assigned Dom by the SuggestPawnClassFor and there is more than one
	// PlayerController  look for a dom to possess
	//if (GetNumPlayerControllersActive() > 1 && HumanPlayer != None && HumanPlayer.DefaultPawnClass == class'TGPawn_COGDom' )
	//{
	//    // make sure Kismet stuff is synced, as some actions that happened after join and before this
	//    // may not have affected this player since he hasn't actually possessed Dom yet
	//    SyncKismetSetProperties(HumanPlayer);
	//    if (!HumanPlayer.bInMatinee && !HumanPlayer.bCinematicMode && IsInState('MatchInProgress'))
	//    {
	//        // look for the coop AI and set the view target
	//        foreach WorldInfo.AllControllers(class'Controller', C)
	//        {
	//            if (C.Pawn != None && C.Pawn.IsA('TGPawn_COGDom'))
	//            {
	//                CoopPawn = C.Pawn;
	//                break;
	//            }
	//            else
	//            {
	//                V = Vehicle(C.Pawn);
	//                if (V != None && V.Driver != None && V.Driver.IsA('TGPawn_COGDom'))
	//                {
	//                    CoopPawn = V;
	//                    break;
	//                }
	//            }
	//        }

	//        // if given a specific pawn to use,
	//        if (CoopPawn != None)
	//        {
	//            // revive him if he's DBNO
	//            if (CoopPawn.IsInState('DBNO'))
	//            {
	//                TGPawn(CoopPawn).DoRevival(None);
	//            }

	//            PRI = TGPRI(CoopPawn.PlayerReplicationInfo);
	//            if( PRI != None )
	//            {
	//                OldSquadName = PRI.SquadName;
	//                TGPRI(HumanPlayer.PlayerReplicationInfo).bForceShowInTaccom = PRI.bForceShowInTaccom;
	//            }

	//            foreach DynamicActors(class'Actor', ChkActor)
	//            {
	//                if (ChkActor.RemoteRole != ROLE_None && !ChkActor.IsA('Controller') && !ChkActor.IsA('TGVehicle') &&
	//                    (ChkActor.IsOwnedBy(CoopPawn) || ChkActor.IsOwnedBy(CoopPawn.Controller)))
	//                {
	//                    ResetActorChannel(ChkActor);
	//                }
	//            }
	//            // if there was a previous controller,
	//            if (CoopPawn.Controller != None)
	//            {
	//                CoopPawn.DetachFromController(true);
	//            }
	//            // take over the new pawn
	//            NewPlayer.PlayerReplicationInfo.bOnlySpectator = false;
	//            NewPlayer.Possess(CoopPawn, false);

	//            if( OldSquadName != '' )
	//            {
	//                HumanPlayer.SetSquadName( OldSquadName );
	//            }

	//            CoopPawn.InvManager.ClearPendingFire(none, 0);
	//            CoopPawn.InvManager.ClearPendingFire(none, 1);

	//            // make sure the pawn sets its weapons up clientside
	//            foreach CoopPawn.InvManager.InventoryActors(class'Weapon', W)
	//            {
	//                W.ClientWeaponSet(false);
	//            }
	//            CoopPawn.ClientRestart();
	//        }
	//    }

	//    if (NewPlayer.Pawn != None)
	//    {
	//        SetPlayerDefaults(NewPlayer.Pawn);
	//        WP = TGPawn(NewPlayer.Pawn);
	//        V = Vehicle(NewPlayer.Pawn);
	//        if (WP != None)
	//        {
	//            // clear any gameplay flags

	//            // turn off infinite ammo on the weapons
	//            for (Inv = WP.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
	//            {
	//                if (TGWeapon(Inv) != None)
	//                {
	//                    TGWeapon(Inv).bInfiniteSpareAmmo = FALSE;
	//                }
	//            }

	//            NewPlayer.ClientSetRotation(WP.Rotation);

	//            foreach WorldInfo.AllControllers(class'TGPC', OtherPC)
	//            {
	//                if (OtherPC != HumanPlayer && OtherPC.Pawn != None && OtherPC.IsInState('PlayerDrivingCrate'))
	//                {
	//                    HumanPlayer.GotoState('PlayerDrivingCrate');
	//                    HumanPlayer.ClientGotoState('PlayerDrivingCrate');
	//                }
	//            }

	//            // update brumak gunner if necessary
	//            //if( TGPawn_LocustBrumakBase(WP.Base) != None )
	//            //{
	//            //  TGPawn_LocustBrumakBase(WP.Base).SetHumanGunner( HumanPlayer != None ? TGPawn(HumanPlayer.Pawn) : None );
	//            //}
	//        }
	//        else if(V != none && V.Driver != none)
	//        {
	//            // if we're jumping into a vehicle the AI was in, we need to set defaults on the vehicle's driver
	//            SetPlayerDefaults(V.Driver);
	//            // clear any gameplay flags

	//            // turn off infinite ammo on the weapons
	//            for (Inv = V.Driver.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
	//            {
	//                if (TGWeapon(Inv) != None)
	//                {
	//                    TGWeapon(Inv).bInfiniteSpareAmmo = FALSE;
	//                }
	//            }

	//            NewPlayer.ClientSetRotation(V.Rotation);
	//        }
	//    }
	//    else
	//    {
	//        // spawn right away if loading a checkpoint
	//        // or in POC maps for debug testing
	//        if (bCheckpointLoadInProgress || Left(WorldInfo.GetMapName(true), 4) ~= "POC_")
	//        {
	//            Super.RestartPlayer(NewPlayer);
	//        }
	//        else
	//        {
	//            // make player try again later
	//            HumanPlayer.GotoState('PlayerWaiting');
	//            HumanPlayer.ClientGotoState('PlayerWaiting');
	//            HumanPlayer.SetTimer( 0.5, false, nameof(HumanPlayer.ServerRestartPlayer) );
	//        }
	//    }
	//}
	//else
	//{
		// do restart normally which should restart us as our DefaultPawnClass
		Super.RestartPlayer(NewPlayer);
	//}
}

event InitGame(string Options, out string ErrorMessage)
{
	//local int ChapterOption;

	Super.InitGame(Options, ErrorMessage);

	//if (HasOption(Options, "loadcheckpoint") && ParseOption(Options, "loadcheckpoint") != "0")
	//{
	//  bStartupLoadCheckpoint = true;
	//}
	//ChapterOption = GetIntOption(Options, "chapter", -1);
	//if (ChapterOption == -1)
	//{
	//  ChapterOption = 0;
	//}
	//else
	//{
	//  // always save a checkpoint immediately after loading a chapter point
	//  bStartupSaveCheckpoint = true;
	//}
	//CurrentChapter = EChapterPoint(ChapterOption);

	MaxPlayers = 2;

	// fewer players in co-op, so allow a little more bandwidth
	MaxDynamicBandwidth = 7000;
}

//function PostLogin(PlayerController NewPlayer)
//{
//  local TGPC PC;
//  local Controller C;
//  local bool bFoundPawn;
//  local Vehicle V;
//  local string MovieName;
//  local TGPC OtherPC;
//
//  PC = TGPC(NewPlayer);
//  // Due to the crazy way we check capacity, a player can sneak in
//  // so check at this point and kick them if they made it
//  if (AtCapacity(false))
//  {
//      PC.ClientSetProgressMessage(PMT_ConnectionFailure,
//          "<Strings:Engine.GameMessage.MaxedOutMessage>",
//          "<Strings:Engine.Errors.ConnectionFailed_Title>",
//          true);
//      PC.ClientReturnToMainMenu();
//      return;
//  }
//
//  if (LocalPlayer(NewPlayer.Player) == None)
//  {
//      TGPC(NewPlayer).ClientLoadGameTypeConfigs("");
//  }
//
//  Super.PostLogin(NewPlayer);
//
//  // see if we need to display the game over screen
//  foreach LocalPlayerControllers(class'TGPC', OtherPC)
//  {
//      if (OtherPC.MyUTHUD.GameoverUISceneInstance != None)
//      {
//          PC.ClientGameOver();
//          break;
//      }
//  }
//
//  if ((GameReplicationInfo.bMatchHasBegun || NumPlayers > 1) && PC.Pawn == None)
//  {
//      // if a Pawn of the desired class exists, set the player to start out spectating it
//      // otherwise, restart the player immediately to spawn them a pawn
//      PC.DefaultPawnClass = SuggestPawnClassFor(PC);
//      if (PC.DefaultPawnClass != None)
//      {
//          foreach WorldInfo.AllControllers(class'Controller', C)
//          {
//              V = Vehicle(C.Pawn);
//              if ( (C.Pawn != None && C.Pawn.Class == PC.DefaultPawnClass) ||
//                  (V != None && V.Driver != None && V.Driver.Class == DefaultPawnClass) )
//              {
//                  PC.SetViewTarget(C.Pawn);
//                  PC.ClientSetViewTarget(C.Pawn);
//                  bFoundPawn = true;
//                  break;
//              }
//          }
//      }
//      if (!bFoundPawn)
//      {
//          // if we couldn't find a co-op pawn to spectate, try to find some other player to spectate at least
//          foreach WorldInfo.AllControllers(class'TGPC', OtherPC)
//          {
//              if (OtherPC != PC && OtherPC.Pawn != None)
//              {
//                  PC.SetViewTarget(OtherPC.Pawn);
//                  PC.ClientSetViewTarget(OtherPC.Pawn);
//                  break;
//              }
//          }
//      }
//      // force location of player to viewtarget in case viewtarget doesn't get received immediately
//      PC.ClientSetLocation(PC.ViewTarget.Location, PC.ViewTarget.Rotation);
//      SyncKismetSetProperties(PC);
//      if (!bFoundPawn || LocalPlayer(PC.Player) != None) // spawn second player in splitscreen immediately, even if he joined late
//      {
//          RestartPlayer(PC);
//      }
//      else if (PC.bCinematicMode)
//      {
//          // set timer so player restarts as soon as the cinematic is over
//          PC.SetTimer( 0.5, false, nameof(PC.ServerRestartPlayer) );
//      }
//  }
//
//  // skip movies/cinematics, unless the client joins in at the beginning (party travel)
//  if (LocalPlayer(PC.Player) == None && WorldInfo.TimeSeconds > 15.0)
//  {
//      foreach LocalPlayerControllers(class'TGPC', OtherPC)
//      {
//          // cancel any non-loading movies
//          OtherPC.GetCurrentMovie(MovieName);
//          `Log("Client logged in; server is playing movie " $ MovieName);
//          if (MovieName != "" && MovieName != class'UTUIInteraction'.const.LOADING_MOVIE)
//          {
//              `Log("Server skipping movie " $ MovieName);
//              OtherPC.ClientStopMovie(0.0, false, true, false);
//          }
//          else
//          {
//              // cancel any matinees also
//              OtherPC.ConsoleCommand("CANCELCINE");
//          }
//      }
//  }
//  else
//  {
//      foreach LocalPlayerControllers(class'TGPC', OtherPC)
//      {
//          // cancel any non-loading movies
//          OtherPC.GetCurrentMovie(MovieName);
//          if (MovieName != "" && MovieName != class'UTUIInteraction'.const.LOADING_MOVIE)
//          {
//              `Log("Telling client to play movie" @ MovieName);
//              PC.ClientPlayMovie(MovieName);
//          }
//          break;
//      }
//  }
//
//  if ( (NumPlayers > 1) && !class'WorldInfo'.static.IsMenuLevel() )
//  {
//      // the first player controller is the host and should handle coop initialization
//      ForEach LocalPlayerControllers(class'TGPC', OtherPC)
//      {
//          // update joining player's objectives
//          CopyObjectives(OtherPC, PC);
//
//          OtherPC.CoopPlayerJoinedCampaign();
//          break;
//      }
//  }
//
//  // copy camera settings for splitscreen
//  if (LocalPlayer(OtherPC.Player) != None && OtherPC.PlayerCamera != None)
//  {
//      PC.ClientSetCameraFade(OtherPC.PlayerCamera.bEnableFading, OtherPC.PlayerCamera.FadeColor, OtherPC.PlayerCamera.FadeAlpha, OtherPC.PlayerCamera.FadeTime);
//  }
//
//  // Have the client set their rich presence
//  PC.ClientSetCoopRichPresence(SuggestPawnClassFor(PC),CurrentChapter);
//  // Have the client start their session if it isn't already
//  PC.ClientStartOnlineGame();
//
//  PC.ClientForceStreamSPTextures();
//}
//
///**
// * Checks to see if the PC that is logging out is a temporary one created for
// * the checkpoint handling
// *
// * @param Exiting the controller that is leaving
// */
//function Logout(Controller Exiting)
//{
//  local TGPC PC;
//
//  PC = TGPC(Exiting);
//  if (PC != None)
//  {
//      // Do not logout a player for check point dummies as this causes the NumPlayers
//      // value to be incorrect allowing more players to join than are allowed
//      if (!PC.bCheckpointDummy)
//      {
//          Super.Logout(Exiting);
//      }
//  }
//  else
//  {
//      Super.Logout(Exiting);
//  }
//}
//
//final function CopyObjectives(TGPC SourcePC, TGPC DestPC)
//{
//  local int i;
//
//  if (DestPC.ObjectiveMgr != None && SourcePC.ObjectiveMgr != None)
//  {
//      DestPC.ClientClearObjectives();
//      for (i = 0; i < SourcePC.ObjectiveMgr.Objectives.length; i++)
//      {
//          DestPC.ClientReplicateObjective(SourcePC.ObjectiveMgr.Objectives[i], i);
//      }
//      if (LocalPlayer(DestPC.Player) == None)
//      {
//          DestPC.ObjectiveMgr.Objectives = SourcePC.ObjectiveMgr.Objectives;
//      }
//  }
//}

/**
 * Suggests a Pawn class to use for a human player.
 *
 */
function class<Pawn> SuggestPawnClassFor(TGPC Player)
{
	return class'HDPawn';
	//local TGPC                    PC;
	//local Array<Class<Pawn> > ExistingPawnClasses;


	////`log( "SuggestPawnClassFor(TGPC Player)" );

	//foreach WorldInfo.AllControllers(class'TGPC', PC)
	//{
	//  if( PC != Player )
	//  {
	//      ExistingPawnClasses[ExistingPawnClasses.Length] = PC.DefaultPawnClass;
	//  }
	//}

	//// first player should be marcus
	//if( ExistingPawnClasses.Find(class'TGPawn_COGMarcus') == -1 )
	//{
	//  return class'TGPawn_COGMarcus';
	//}

	//// second player should be Dom
	//if( ExistingPawnClasses.Find(class'TGPawn_COGDom') == -1 )
	//{
	//  return class'TGPawn_COGDom';
	//}

	//// otherwise return default gear class...
	//return class'TGPawn_COGGear';
}


/**
 * Returns TRUE if Player is the only player controller in game.
 */
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
	local LocalPlayer       LP;

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
 * @param   C - controller to figure out pawn class for
 * @return  default pawn class
 */
function class<Pawn> GetDefaultPlayerClass(Controller C)
{
	//local TGPC    PC;

	//PC = TGPC(C);
	//if( PC != None )
	//{
	//  // use default Pawn class if it exists.
	//  if( PC.DefaultPawnClass != None )
	//  {
	//      return PC.DefaultPawnClass;
	//  }
	//}

	// default to the game specified pawn class
	return DefaultPawnClass;
}

function int GetForcedTeam(Controller Other, int Team)
{
	// make sure a valid team is specified, defaulting to enemy team
	if (Other.IsA('PlayerController'))
	{
		return 0;
	}
	else
	if (Team < 0 ||
		Team >= NumTeams)
	{
		return 1;
	}
	return Team;
}

//function bool CanSpectate( PlayerController Viewer, PlayerReplicationInfo ViewTarget )
//{
//  return (TGAI_COGGear(ViewTarget.Owner) != None || TGPC(ViewTarget.Owner) != None);
//}

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

//function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
//{
//  local float Result;
//
//  Result = Super.RatePlayerStart(P, Team, Player);
//  if (!IsValidStartSpot(P))
//  {
//      Result *= 0.4;
//  }
//  return Result;
//}
//
//function StartBots();
//
//event Tick(float DeltaTime)
//{
//  local TGPC PC;
//  local string MovieName;
//  local bool bForceLoadingMovie;
//
//  Super.Tick(DeltaTime);
//
//  if (bNeedBackupLoadingMovie)
//  {
//      foreach LocalPlayerControllers(class'TGPC', PC)
//      {
//          PC.GetCurrentMovie(MovieName);
//          if (MovieName == "")
//          {
//              bForceLoadingMovie = true;
//              break;
//          }
//      }
//      if (bForceLoadingMovie)
//      {
//          foreach WorldInfo.AllControllers(class'TGPC', PC)
//          {
//              PC.ClientStopMovie(0.0, false, false, false);
//              PC.ClientShowLoadingMovie(true);
//          }
//          bNeedBackupLoadingMovie = false; // so we don't spam it if movie playing fails (e.g. "-nomovie" command line option)
//      }
//  }
//}

state MatchInProgress
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		GetGRI().bIsCoop = TRUE;
	}

	function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
	{
		local array<NavigationPoint> NavList;
		local NavigationPoint Nav, CheckNav;
		local int Idx, PathIdx;
		local PlayerController OtherPlayer;

		if (Player.IsA('PlayerController'))
		{
			// first look for team mates who are already in the world
			foreach WorldInfo.AllControllers(class'PlayerController', OtherPlayer)
			{
				if (OtherPlayer != Player && OtherPlayer.Pawn != None && OtherPlayer.PlayerReplicationInfo.Team == Player.PlayerReplicationInfo.Team)
				{
					// find a navigation point near the player
					if (OtherPlayer.Pawn.Anchor != None)
					{
						Idx = 0;
						NavList[NavList.Length] = OtherPlayer.Pawn.Anchor;
						while (Idx < NavList.Length)
						{
							// grab the next node in the list
							Nav = NavList[Idx];
							Idx++;
							// add all linked nav points that are within range
							for (PathIdx = 0; PathIdx < Nav.PathList.Length; PathIdx++)
							{
								CheckNav = Nav.PathList[PathIdx].GetEnd();
								if (CheckNav != None &&
									VSize(CheckNav.Location - OtherPlayer.Pawn.Anchor.Location) < 1024.f)
								{
									// make sure it's not already in the list
									if (NavList.Find(CheckNav) == INDEX_NONE)
									{
										NavList[NavList.Length] = CheckNav;
									}
								}
							}
							// return this nav if it's valid
							if (!Nav.IsA('CoverSlotMarker') && IsValidStartSpot(Nav))
							{
								return Nav;
							}
						}
					}
				}
			}
		}
		return Super.FindPlayerStart(Player,InTeam,incomingName);
	}
}

/** Iterate over all the TGPCs doing a 'fade in' when you skip the cinematic. */
//event MatineeCancelled()
//{
//  local TGPC WPC;
//  local color FadeColor;
//
//  foreach WorldInfo.AllControllers(class'TGPC',WPC)
//  {
//      WPC.ClientColorFade(FadeColor, 255, 0, 2.0);
//  }
//}

///** notification that we have finished loading a checkpoint */
//event CheckpointLoadComplete()
//{
//  local TGPC PC, HostPC;
//  local TGAI AI;
//  local array<SequenceObject> AllCheckpointEvents;
//  local Sequence GameSeq;
//  local int i;
//  local Pawn P;
//
//  // reinit the AI visibility manager
//  AIVisMan = new(self) default.AIVisMan.Class(default.AIVisMan);
//
//  // clear any old countdown timer
//  TGGRI(GameReplicationInfo).StopCountdown(true, false);
//
//  // trigger any pending AI move actions that were loaded from the checkpoint
//  foreach WorldInfo.AllControllers(class'TGAI', AI)
//  {
//      if (AI.PendingCheckpointMoveAction != None)
//      {
//          AI.OnAIMove(AI.PendingCheckpointMoveAction);
//          AI.PendingCheckpointMoveAction = None;
//      }
//  }
//
//  foreach LocalPlayerControllers(class'TGPC', HostPC)
//  {
//      break;
//  }
//
//  // block to handle any first frame load requests from Kismet (for checkpoints saved at level startup)
//  HostPC.SetTimer(0.01, false, nameof(HostPC.ClientSetBlockOnAsyncLoading));
//
//  foreach WorldInfo.AllControllers(class'TGPC', PC)
//  {
//      // spawn them in if they didn't get a Pawn (e.g. because the checkpoint was saved with the AI controlling that pawn)
//      if (PC.Pawn == None || PC.Pawn.bDeleteMe)
//      {
//          RestartPlayer(PC);
//      }
//
//      if (PC != HostPC)
//      {
//          CopyObjectives(HostPC, PC);
//      }
//
//      // reset cinematic flags
//      PC.bGodMode = PC.IsInState('PlayerBrumakGunner');
//      PC.bCinematicMode = false;
//      PC.bHavingAnAbortableConversation = false;
//      PC.bInMatinee = false;
//      PC.bInvisible = FALSE;
//      // clear trigger flags
//      if (PC.DoorTriggerDatum.bInsideDoorTrigger)
//      {
//          PC.OnExitDoorTrigger();
//      }
//      // reset the camera
//      if (PC.PlayerCamera != None)
//      {
//          PC.PlayerCamera.Destroy();
//          PC.SpawnPlayerCamera();
//      }
//      // tell client to reset stuff
//      PC.bClientLoadingCheckpoint = true;
//      PC.ClientCheckpointReset();
//
//      // force texture loading for all the characters that were in the checkpoint
//      foreach WorldInfo.AllPawns(class'Pawn', P)
//      {
//          // ignore Marcus/Dom because they're already hardcoded to be streamed in all the time
//          if (P.Class != class'TGPawn_COGMarcus' && P.Class != class'TGPawn_COGDom')
//          {
//              PC.ClientPrestreamTexturesFor(P.Class);
//          }
//      }
//  }
//
//  // trigger Kismet event
//  GameSeq = WorldInfo.GetGameSequence();
//  if (GameSeq != None)
//  {
//      GameSeq.FindSeqObjectsByClass(class'SeqEvent_CheckpointLoaded', true, AllCheckpointEvents);
//      for (i = 0; i < AllCheckpointEvents.length; i++)
//      {
//          SeqEvent_CheckpointLoaded(AllCheckpointEvents[i]).CheckActivate(self, None);
//      }
//  }
//}

function bool ShouldRespawn( PickupFactory Other )
{
	return false;
}

//`if(`notdefined(FINAL_RELEASE))
//function bool AllowCheats(PlayerController P)
//{
//  return true;
//}
//`endif

/** ChoosePlayerStart()
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */
 //???bEnabled?TeamIndex(????)
function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	local PlayerStart P, BestStart;
	local array<playerstart> PlayerStarts;
	local int i, MinTeam;

	// make array of enabled playerstarts
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
	{
		if( P.bEnabled )
			PlayerStarts[PlayerStarts.Length] = P;
	}

	MinTeam = MaxInt;

	for( i=0; i<PlayerStarts.Length; i++ )
	{
		P = PlayerStarts[i];
		if ( P.TeamIndex < MinTeam )
		{
			MinTeam = P.TeamIndex;
			BestStart = P;
		}
	}

	return BestStart;
}


//
// Log a player in.
// Fails login if you set the Error string.
// PreLogin is called before Login, but significant game time may pass before
// Login is called, especially if content is downloaded.
//
event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
	local PlayerController      PC;
	PC = Super.Login( Portal, Options, UniqueID, ErrorMessage );

	if( PC != none && TMPlayerReplicationInfo( PC.PlayerReplicationInfo ) != none && ParseOption( Options, "SpectatorOnly" ) != "1" )
	{
		TMPlayerReplicationInfo( PC.PlayerReplicationInfo ).CharClassInfo =  SPFamliyInfo;
	}

	return PC;
}

function EndGame( PlayerReplicationInfo Winner, string Reason )
{
	local LoginPlayerInfo currentPlayer;
	local string mapName;
	local LoginPlayerManager PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();
	currentPlayer = playerManager.getPlayer(playerManager.currentPlayerName);
	currentPlayer.PlayerScore += Winner.Score;
	currentPlayer.getRankLevelAndMilitaryRank ();

	mapName = GetMapFilename ();
	mapName = Caps(mapName);

	if (Right(mapName, 4) == ".UDK")
	{
	 mapName = Left(mapName, Len(mapName)-4);
	}

	// if this level is training, goto mainmenu
	if (mapName == "TMTP-RANGE02" || mapName == "TMSP-TRAINING" ||
		mapName == "TMTP-RANGE01" || mapName == "TMSP-CAMP")
	{
	 currentPlayer.SaveConfig ();
	 return ;
	}

	// Single Level
	switch (mapName)
	{
	case "TMTP-RANGE02":
	   currentPlayer.bFinishedTraining = true;
	   NextLevel = 1;
	   ConsoleCommand("open TMFrontEnd");
	   break;
	case "TMSP-BEACH01":
	   NextLevel = 1; MilitaryLevel = 1;
	   ConsoleCommand("open TMSP-Beach02?game=TMGame.TGGameSP_Base?NumPlay=0");
	   break;
	case "TMSP-BEACH02":
	   NextLevel = 2; MilitaryLevel = 1; break;
	case "TMSP-BEACH03":
	   NextLevel = 3; MilitaryLevel = 2; break;
	case "TMSP-HILL":
	   NextLevel = 4; MilitaryLevel = 3; break;
	case "TMSP-CLIFF01":
	   NextLevel = 5; MilitaryLevel = 4; break;
	case "TMSP-SEIGE":
	   NextLevel = 6; MilitaryLevel = 5; break;
	case "TMSP-FACTORY":
	   NextLevel = 7; MilitaryLevel = 6; break;
	case "TMSP-VILLAGE":
	   NextLevel = 7; MilitaryLevel = 7; break;
	case "TMSP-VILLAGE2":
	   NextLevel = 8; MilitaryLevel = 7; break;
	case "TMSP-CITY":
	   NextLevel = 9; MilitaryLevel = 8; break;
	}

	if (currentPlayer.LevelInSinglePlay < NextLevel)
	{
	 currentPlayer.LevelInSinglePlay = NextLevel;
	}
	currentPlayer.SaveConfig ();

	if (mapName == "TMSP-BEACH01")
	{
	 ConsoleCommand("open TMSP-Beach02?game=TMGame.TGGameSP_Base?NumPlay=0");
	}
	else if (mapName == "TMSP-VILLAGE")
	{
	 ConsoleCommand("open TMSP-VILLAGE2?game=TMGame.TGGameSP_Base?NumPlay=0");
	}
	else if(mapName == "TMSP-END")
	{
	 ConsoleCommand("open TMFrontEnd?game=TMGame.TGGameSP_Base?NumPlay=0");
	}
	else
	{
	DisplayMilitary();
	}
}

function DisplayMilitary()
{
	local int DifficultyLevel;
	local string mapName;

	MilitaryMoive = new class'HDGFxMilitary';   //EM class
	MilitaryMoive.MovieInfo = SwfMovie'HD_FrontEnd.HD_GFx_Military';
	MilitaryMoive.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(MilitaryMoive.GetPC().Player));
	MilitaryMoive.SetTimingMode(TM_Real);

	// difficulty level Def 1.0  Easy 1.0 Normal 1.5 Hard 2.0
	DifficultyLevel = Round(5.0-GameDifficulty*2.0);
	MilitaryMoive.GetRankAndLevel(DifficultyLevel, MilitaryLevel);

	mapName = Caps(GetMapFilename());
	if (Right(mapName, 4) == ".UDK")
	{
	 mapName = Left(mapName, Len(mapName)-4);
	}

	MilitaryMoive.SetMapName(mapName);
	MilitaryMoive.SetNextLevel(NextLevel);

	MilitaryMoive.Start ();
}


function ScoreKill(Controller Killer, Controller Other)
{
	if( (killer == Other) || (killer == None) )
	{
		if ( (Other!=None) && (Other.PlayerReplicationInfo != None) )
		{
			//-Other.PlayerReplicationInfo.Score -= 1;
			Other.PlayerReplicationInfo.bForceNetUpdate = TRUE;
		}
	}
	else if ( killer.PlayerReplicationInfo != None )
	{
		Killer.PlayerReplicationInfo.Score += 50;            // ?????? ???50
		Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
		Killer.PlayerReplicationInfo.Kills++;
	}

	ModifyScoreKill(Killer, Other);

	if (Killer != None || MaxLives > 0)
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
}

