/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMGameReplicationInfo extends GameReplicationInfo
	config(Game)
	native;

var float WeaponBerserk;
var int MinNetPlayers;
var int BotDifficulty;		// for bPlayersVsBots

var bool		bWarmupRound;	// Amount of Warmup Time Remaining
/** forces other players to be viewed on this machine with the default character */
var globalconfig bool bForceDefaultCharacter;

/** We hold a reference to the live scoreboard to adapt for split screen */
//var TMUIScene_Scoreboard ScoreboardScene;

var string SinglePlayerBotNames[4];

enum EFlagState
{
    FLAG_Home,
    FLAG_HeldFriendly,
    FLAG_HeldEnemy,
    FLAG_Down,
};

var EFlagState FlagState[2];

/** If this is set, the game is running in story mode */
var bool bStoryMode;

/** Holds the Mission index of the current mission */
var int SinglePlayerMissionID;

/** whether the server is a console so we need to make adjustments to sync up */
var bool bConsoleServer;

/** Which input types are allowed for this game **/
var bool bAllowKeyboardAndMouse;

/** set by level Kismet to disable announcements during tutorials/cinematics/etc */
var bool bAnnouncementsDisabled;

var repnotify bool bShowMOTD;

var databinding string MutatorList;
var databinding string RulesString;

/** weapon overlays that are available in this map - figured out in PostBeginPlay() from TMPowerupPickupFactories in the level
 * each entry in the array represents a bit in TMPawn's WeaponOverlayFlags property
 * @see TMWeapon::SetWeaponOverlayFlags() for how this is used
 */
var array<MaterialInterface> WeaponOverlays;
/** vehicle weapon effects available in this map - works exactly like WeaponOverlays, except these are meshes
 * that get attached to the vehicle mesh when the corresponding bit is set on the driver's WeaponOverlayFlags
 */
struct native MeshEffect
{
	/** mesh for the effect */
	var StaticMesh Mesh;
	/** material for the effect */
	var MaterialInterface Material;
};
var array<MeshEffect> VehicleWeaponEffects;


//===================================================================
/*	These are client-side variables that hold references to the mid game menu.
    We store them here so that split-screen doesn't double up						*/
//===================================================================

/** Holds the current Mid Game Menu Scene */
//var TMUIScene_MidGameMenu CurrentMidGameMenu;
var name LastUsedMidgameTab;

var bool bShowMenuOnDeath;

var bool bRequireReady;

//[ WK ADD: Firendly Fire Flag
var globalconfig bool   bFirendlyFire;

var bool                bLocalDisablePawnCastShadow;
// WK ADD]

replication
{
	if (bNetInitial)
		WeaponBerserk, MinNetPlayers, BotDifficulty, bStoryMode, bConsoleServer, bShowMOTD, MutatorList, RulesString, bRequireReady, bFirendlyFire;

	if (bNetDirty)
		bWarmupRound, FlagState, bAnnouncementsDisabled, bAllowKeyboardAndMouse;
}

simulated function PostBeginPlay()
{
	//local TMPowerupPickupFactory Powerup;
	local Sequence GameSequence;
	local array<SequenceObject> AllFactoryActions;
	local SeqAct_ActorFactory FactoryAction;
	local TMActorFactoryPickup Factory;
	local int i;
	//local TMGameUISceneClient SC;
	//local UIScene NextScene;

	Super.PostBeginPlay();

	// using DynamicActors here so the overlays don't break if the LD didn't build paths
	//foreach DynamicActors(class'TMPowerupPickupFactory', Powerup)
	//{
	//	Powerup.AddWeaponOverlay(self);
	//}

	// also check if any Kismet actor factories spawn powerups
	GameSequence = WorldInfo.GetGameSequence();
	if (GameSequence != None)
	{
		GameSequence.FindSeqObjectsByClass(class'SeqAct_ActorFactory', true, AllFactoryActions);
		for (i = 0; i < AllFactoryActions.length; i++)
		{
			FactoryAction = SeqAct_ActorFactory(AllFactoryActions[i]);
			Factory = TMActorFactoryPickup(FactoryAction.Factory);
			if (Factory != None && ClassIsChildOf(Factory.InventoryClass, class'TMInventory'))
			{
				class<TMInventory>(Factory.InventoryClass).static.AddWeaponOverlay(self);
			}
		}
	}

	// Look for a mid game menu and if it's there fix it up
// 	SC = TMGameUISceneClient(class'UIRoot'.static.GetSceneClient());
// 	if (SC != none)
// 	{
// 		CurrentMidGameMenu = TMUIScene_MidGameMenu(SC.FindSceneByTag('MidGameMenu'));
// 		if ( CurrentMidGameMenu != none )
// 		{
// 			CurrentMidGameMenu.Reset();
// 		}
//
// 		// also close any scoreboards that are up
// 		i = 0;
// 		while ( i < SC.GetActiveSceneCount() )
// 		{
// 			NextScene = SC.GetSceneAtIndex(i);
// 			if ( TMUIScene_Scoreboard(NextScene) == None || !NextScene.CloseScene(NextScene, false, true))
// 			{
// 				i++;
// 			}
// 		}
// 	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		SetTimer(1.0, false, 'CharacterProcessingComplete');
	}
}

//Signal that all player controllers character processing is complete
simulated function CharacterProcessingComplete()
{
	local TMPlayerController TMPC;

	foreach LocalPlayerControllers(class'TMPlayerController', TMPC)
	{
		TMPC.CharacterProcessingComplete();
	}
}

simulated function ReplicatedEvent(name VarName)
{
	if ( VarName == 'bShowMOTD' )
	{
		DisplayMOTD();
	}
}

function SetFlagHome(int TeamIndex)
{
	FlagState[TeamIndex] = FLAG_Home;
	bForceNetUpdate = TRUE;
}

simulated function bool FlagIsHome(int TeamIndex)
{
	return ( FlagState[TeamIndex] == FLAG_Home );
}

simulated function bool FlagsAreHome()
{
	return ( FlagState[0] == FLAG_Home && FlagState[1] == FLAG_Home );
}

function SetFlagHeldFriendly(int TeamIndex)
{
	FlagState[TeamIndex] = FLAG_HeldFriendly;
}

simulated function bool FlagIsHeldFriendly(int TeamIndex)
{
	return ( FlagState[TeamIndex] == FLAG_HeldFriendly );
}

function SetFlagHeldEnemy(int TeamIndex)
{
	FlagState[TeamIndex] = FLAG_HeldEnemy;
}

simulated function bool FlagIsHeldEnemy(int TeamIndex)
{
	return ( FlagState[TeamIndex] == FLAG_HeldEnemy );
}

function SetFlagDown(int TeamIndex)
{
	FlagState[TeamIndex] = FLAG_Down;
}

simulated function bool FlagIsDown(int TeamIndex)
{
	return ( FlagState[TeamIndex] == FLAG_Down );
}

simulated function Timer()
{
	local byte TimerMessageIndex;
	local PlayerController PC;

	super.Timer();

	if ( WorldInfo.NetMode == NM_Client )
	{
		if ( bWarmupRound && RemainingTime > 0 )
			RemainingTime--;
	}

	// check if we should broadcast a time countdown message
	if (WorldInfo.NetMode != NM_DedicatedServer && (bMatchHasBegun || bWarmupRound) && !bStopCountDown && !bMatchIsOver && Winner == None)
	{
		switch (RemainingTime)
		{
			case 300:
				TimerMessageIndex = 16;
				break;
			case 180:
				TimerMessageIndex = 15;
				break;
			case 120:
				TimerMessageIndex = 14;
				break;
			case 60:
				TimerMessageIndex = 13;
				break;
			case 30:
				TimerMessageIndex = 12;
				break;
			default:
				if (RemainingTime <= 10 && RemainingTime > 0)
				{
					TimerMessageIndex = RemainingTime;
				}
				break;
		}
		if (TimerMessageIndex != 0)
		{
			foreach LocalPlayerControllers(class'PlayerController', PC)
			{
				PC.ReceiveLocalizedMessage(class'TMTimerMessage', TimerMessageIndex);
			}
		}
	}
}

/**
 * Displays the message of the day by finding a hud and passing off the call.
 */
simulated function DisplayMOTD()
{
	local PlayerController PC;
	local TMPlayerController TMPC;

	return;

	ForEach LocalPlayerControllers(class'PlayerController', PC)
	{
		TMPC = TMPlayerController(PC);
		if ( TMPC != none )
		{
			TMHud(TMPC.MyHud).DisplayMOTD();
		}

		break;
	}
}

// simulated function PopulateMidGameMenu(TMSimpleMenu Menu)
// {
// 	if ( CanChangeTeam() )
// 	{
// 		Menu.AddItem("<Strings:TMGameUI.MidGameMenu.ChangeTeam>",0);
// 	}
//
// 	Menu.AddItem("<Strings:TMGameUI.MidGameMenu.Settings>",1);
//
// 	if ( WorldInfo.NetMode == NM_Client )
// 	{
// 		Menu.AddItem("<Strings:TMGameUI.MidGameMenu.Reconnect>",2);
// 	}
//
// 	Menu.AddItem("<Strings:TMGameUI.MidGameMenu.LeaveGame>",3);
// }

/** Whether a player can change teams or not.  Used by menus and such. */
simulated function bool CanChangeTeam()
{
	if (TMGame(WorldInfo.Game) != None && TMGame(WorldInfo.Game).IsConsoleDedicatedServer())
	{
		return false;
	}
	else
	{
		return (GameClass.default.bTeamGame && !bStoryMode);
	}
}

// simulated function bool MidMenuMenu(TMPlayerController TMPC, TMSimpleList List, int Index)
// {
// 	//local TMUIScene S;
// 	switch ( List.List[Index].Tag)
// 	{
// 		case 0:
// 			TMPC.ChangeTeam();
// 			return true;
// 			break;
//
// 		case 1:
// 			/*
// 			S = TMUIScene( List.GetScene() );
// 			S.CloseScene(,,true);
// 			TMPC.OpenUIScene(class'TMUIFrontEnd_MainMenu'.default.SettingsScene);
// 			*/
// 			break;
//
// 		case 2:
// 			TMPC.ConsoleCommand("Reconnect");
// 			break;
//
// 		case 3:
// 			TMPC.QuitToMainMenu();
// 			return true;
// 			break;
// 	}
//
//
// 	return false;
// }

/** @return whether the given team is Necris (used by e.g. vehicle factories to control whether they can activate for this team) */
simulated function bool IsNecrisTeam(byte TeamNum);


/**
 * In a single player campaign, this function will be called to insure all of
 * the players are properly assigned to a given team.  It insure that the host
 * of the game is assigned to Reaper, and then assigns the other players in order.
 *
 *@Param	PRI		The PRI of the player to Assign a character for
 */


function AssignSinglePlayerCharacters(TMPlayerReplicationInfo PRI)
{
	local int i, CharIndex;
	local TMPlayerController PC;
	local TMPlayerReplicationInfo Chars[4], OtherPRI;
	local CharacterInfo CharInfo;
	local TMBot B;

    // We only do this in story mode

	if ( !bStoryMode )
	{
		return;
	}

	PC = TMPlayerController(PRI.Owner);
	if (PC != None && !PRI.bOnlySpectator)
	{
		if ( PRI.SinglePlayerCharacterIndex >= 0 )
		{
			// We already have an assigned player.  Validate it.
			if (PRI.SinglePlayerCharacterIndex == 0) 	// Reaper
			{
				if ( PC.Player != none && LocalPlayer(PC.Player) != None )
				{
					Chars[0] = PRI;
				}
				else
				{
					// We are not the local host, or there is already local
					// Reaper, so reset this player.
					PRI.SinglePlayerCharacterIndex = -1;
				}
			}
		}

		// figure out who we already have
		for (i = 0; i < PRIArray.length; i++)
		{
			OtherPRI = TMPlayerReplicationInfo(PRIArray[i]);
			if (OtherPRI != None && OtherPRI.SinglePlayerCharacterIndex >= 0)
			{
				if ( OtherPRI != PRI && OtherPRI.SinglePlayerCharacterIndex != PRI.SinglePlayerCharacterIndex &&
					PRI.SinglePlayerCharacterIndex != 0 )
				{
					PRI.SinglePlayerCharacterIndex = -1;
				}
				Chars[OtherPRI.SinglePlayerCharacterIndex] = OtherPRI;
			}
		}

		// At this point, a player is either seeded correctly
		// or waiting for a seed (Index <0).  If needed, seed him now

		if ( PRI.SinglePlayerCharacterIndex < 0 )
		{
			for (i=0;i<4;i++)
			{
				if ( Chars[i] == none )
				{
					PRI.SinglePlayerCharacterIndex = i;
					Chars[i] = PRI;
					break;
				}
			}

		}

		// One final check.  If we get here and the player
		// hasn't been seeded, there are too many players in the game.
		// If this occurs, set them to spectators for now.  The game
		// will attempt to reseed them next map.


		if ( PRI.SinglePlayerCharacterIndex < 0 )
		{
			;
			TMGame(WorldInfo.Game).BecomeSpectator(PC);
			return;
		}

		// Set the player's Character
		CharIndex = class'TMCharInfo'.default.PLACharacters.Find('CharName', SinglePlayerBotNames[PRI.SinglePlayerCharacterIndex]);
		CharInfo  = class'TMCharInfo'.default.PLACharacters[CharIndex];
		PRI.CharClassInfo = class'TMCharInfo'.static.FindFamilyInfo(CharInfo.FamilyID);

		// kick the bot playing this character, if it's present
		foreach WorldInfo.AllControllers(class'TMBot', B)
		{
			if (B.PlayerReplicationInfo.PlayerName ~= SinglePlayerBotNames[PRI.SinglePlayerCharacterIndex])
			{
				B.Destroy();
			}
		}
	}
}

/**
 * Open the mid-game menu
 */
// simulated function TMUIScene_MidGameMenu ShowMidGameMenu(TMPlayerController InstigatorPC, optional name TabTag,optional bool bEnableInput)
// {
// 	local UIScene Scene;
// 	local TMUIScene Template;
// 	local class<TMGame> TMGameClass;
//
// 	if (TabTag == '')
// 	{
// 		if (LastUsedMidgameTab != '')
// 		{
// 			TabTag = LastUsedMidGameTab;
// 		}
// 	}
//
// 	if ( CurrentMidGameMenu != none )
// 	{
// 		if ( TabTag != '' && TabTag != 'ChatTab' )
// 		{
// //			CurrentMidGameMenu.ActivateTab(TabTag);
// 		}
// 		return CurrentMidGameMenu;
// 	}
//
// 	if ( ScoreboardScene != none )	// Force the scoreboards to close
// 	{
// 		ShowScores(false, none, none );
// 	}
//
//
// 	TMGameClass = class<TMGame>(GameClass);
// 	if (TMGameClass == none)
// 	{
// 		return None;
// 	}
//
// 	Template = TMGameClass.Default.MidGameMenuTemplate;
//
// 	if ( Template != none )
// 	{
// 		Scene = OpenUIScene(InstigatorPC,Template);
// 		if ( Scene != none )
// 		{
// 			CurrentMidGameMenu = TMUIScene_MidGameMenu(Scene);
// 			ToggleViewingMap(true);
//
// 			if (bMatchIsOver)
// 			{
// 				CurrentMidGameMenu.TabControl.RemoveTabByTag('SettingsTab');
// 			}
//
// 			if ( TabTag != '' )
// 			{
// 				CurrentMidGameMenu.ForceTabPageReady(TabTag);
// 				CurrentMidGameMenu.ActivateTab(TabTag);
// 			}
// 		}
// 		else
// 		{
// 			`log("ERROR - Could not open the mid-game menu:"@Template);
// 		}
// 	}
//
// 	if ( CurrentMidGameMenu != none && bEnableInput)
// 	{
// 		CurrentMidGameMenu.SetSceneInputMode(INPUTMODE_Free);
// 	}
//
// 	return CurrentMidGameMenu;
// }

/**
 * Clean up
 */
function simulated MidGameMenuClosed( )
{
	ToggleViewingMap(false);
	//CurrentMidGameMenu = none;
}

function ToggleViewingMap(bool bIsViewing)
{
	local TMPlayerController PC;

	foreach WorldInfo.AllControllers(class'TMPlayerController',PC)
	{
		if ( LocalPlayer(PC.Player) != none )
		{
			PC.ServerViewingMap(bIsViewing);
		}
	}
}

/** wrapper for opening UI scenes
 * @param InstigatorPC - player to open it for
 * @param Template - the scene to open
 */
// simulated function UIScene OpenUIScene(TMPlayerController InstigatorPC, UIScene Template)
// {
// 	local LocalPlayer LP;
// 	local UIScene s;
//
// 	// Check all replication conditions
// 	LP = LocalPlayer(InstigatorPC.Player);
// 	if ( LP != None )
// 	{
// 		S = Template.OpenScene(Template, LP);
// 	}
//
// 	return S;
// }

// simulated function ShowScores(bool bShow, TMPlayerController Host, TMUIScene_Scoreboard Template)
// {
// 	local UIScene Scene;
//
// 	// Regardless of what's going on, if the mid game menu is up, don't ever show scores
// 	if ( CurrentMidGameMenu != none )
// 	{
// 		bShow = false;
// 	}
//
// 	if ( bShow )
// 	{
// 		if (ScoreboardScene == none )
// 		{
// 			Scene = OpenUIScene(Host, Template);
// 			ScoreboardScene = TMUIScene_Scoreboard(Scene);
// 			ScoreboardScene.Host = Host;
// 			SetHudShowScores(true);
// 		}
// 	}
// 	else
// 	{
// 		if (ScoreboardScene != none && (Host == none || ScoreboardScene.Host == Host) )
// 		{
// 			ScoreboardScene.Host = none;
// 			ScoreboardScene.CloseScene();
// 			ScoreboardScene = none;
// 			SetHudShowScores(false);
// 		}
// 	}
// }

simulated function SetHudShowScores(bool bShow)
{
	local TMPlayerController PC;
	foreach WorldInfo.AllControllers(class'TMPlayerController',PC)
	{
		if ( PC.MyHUD != none )
		{
			PC.MyHud.bShowScores = bShow;
		}
	}
}

function AddGameRule(string Rule)
{
	RulesString $= ((RulesString != "") ? "\n" : "")$Rule;
}

/**
  * Sort the PRI Array based on InOrder() prioritization
  */
simulated function SortPRIArray()
{
	local int i, j;
	local PlayerReplicationInfo P1, P2;

	for (i=0; i<PRIArray.Length-1; i++)
	{
		P1 = PRIArray[i];
		for (j=i+1; j<PRIArray.Length; j++)
		{
			P2 = PRIArray[j];
			if( !InOrder( P1, P2 ) )
			{
				PRIArray[i] = P2;
				PRIArray[j] = P1;
				P1 = P2;
			}
		}
	}
}

/**
  * returns true if P1 should be sorted before P2
  */
simulated function bool InOrder( PlayerReplicationInfo P1, PlayerReplicationInfo P2 )
{
	local LocalPlayer LP1, LP2;

	// spectators are sorted last
    if( P1.bOnlySpectator )
    {
		return P2.bOnlySpectator;
    }
    else if ( P2.bOnlySpectator )
	{
		return true;
	}

	// sort by Score
    if( P1.Score < P2.Score )
	{
		return false;
	}
    if( P1.Score == P2.Score )
    {
		// if score tied, use deaths to sort
		if ( P1.Deaths > P2.Deaths )
			return false;

		// keep local player highest on list
		if ( (P1.Deaths == P2.Deaths) && (PlayerController(P2.Owner) != None) )
		{
			LP2 = LocalPlayer(PlayerController(P2.Owner).Player);
			if ( LP2 != None )
			{
				if ( !class'Engine'.static.IsSplitScreen() || (LP2.ViewportClient.Outer.GamePlayers[0] == LP2) )
				{
					return false;
				}
				// make sure ordering is consistent for splitscreen players
				LP1 = LocalPlayer(PlayerController(P2.Owner).Player);
				return ( LP1 != None );
			}
		}
	}
    return true;
}

