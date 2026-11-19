/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Specialized GRI for dealing with party game informaton */
class GearPartyGRI extends GearGRI;

/** Enum of the different states in matchmaking process */
enum EMatchmakingState
{
	MMS_NotMatchmaking,
	// One or more users have requested to cancel matchmaking
	MMS_CancelingMatchmaking,
	// Reading the skill data from live so we can search using it
	MMS_ReadingSkills,	
	//  Looking for a dedicated server with an exact fit need
	MMS_FindingBestDedicated,
	//  Looking for a dedicated server with any need
	MMS_FindingAnyDedicated,
	//  Looking for a dedicated server that can be configured to client need
	MMS_FindingEmptyDedicated,
	// When you are a partial party, it searches for an exact fit for your size first
	MMS_FindingBestParty,
	// When you are a partial party and a best fit fails, it searches any party that can hold
	MMS_FindingAnyParty,
	// Past the point of no return, traveling to the party match
	MMS_ConnectingToOpposingParty,
	// The partial party host has cancelled, so we need to start looking again
	MMS_HostCancelingMatchmaking
};

/** Whether there is currently an error in advancing from the party lobby or not */
var bool bPartyLobbyErrorExists;

/** The current state of our matchmaking process */
var repnotify EMatchmakingState MatchmakingState;

/** The number of slots filled by external parties (to update the UI list with which ones are still needed) */
var repnotify int PartySlotsFilled;

/** The total number of players on a team for this game */
var repnotify int TeamSize;

/** The total number of teams invovled with this game */
var repnotify int TeamCount;

/** The max party size for this playlist */
var repnotify int MaxPartySize;

/** The number of slots filled by people that are loading into the game */
var int ConnectingPlayerCount;

/** True whenever a bandwidth test is currently active */
var bool bBandwidthTestActive;

/** The current value of the match mode on the server */
var repnotify int MatchMode;

/** The current value of the versus game mode on the server */
var repnotify int VersusGameType;

/** The current screen the host is on */
var byte CurrMenuSelection;

/** Whether or not the difficulty selection screen should be up */
var repnotify bool bDifficultySelection;

/** The number of mutators that can be selected */
const NUM_SELECTED_MUTATORS = 3;
/** The value that denotes an unused mutator selection slot */
const NO_MUTATOR = 255;
/** Array of indices into the MutatorClassArray that denotes which mutators are selected */
var repnotify byte SelectedMutators[NUM_SELECTED_MUTATORS];

/** Constant used for iterating over the GameSettingsValues array */
const NUM_GAMESETTINGS_VALUES = 15;
/** Array of the current values of the versus game settings */
var repnotify int GameSettingsValues[NUM_GAMESETTINGS_VALUES];

/** Main menu countdown timer */
var int MainMenuCountdownTimer;

/** The number of clients that have unlocked each mutator on a per mutator basis
 *  Correlates to MutatorClassArray in UIScene_MainMenu
 */
var repnotify byte NumClientsUnlockedMutators[`TOTAL_MUTATORS];


replication
{
	if (bNetDirty)
		MatchmakingState, PartySlotsFilled, TeamSize, TeamCount, MaxPartySize, bPartyLobbyErrorExists,
		ConnectingPlayerCount, bBandwidthTestActive, CurrMenuSelection, bDifficultySelection, GameSettingsValues, MatchMode, VersusGameType,
		MainMenuCountdownTimer, SelectedMutators, NumClientsUnlockedMutators;
}

/** Called when a value in GameSettingsValues array is changed */
delegate OnMatchMakingStateChanged();

/** Called when a value in GameSettingsValues array is changed */
delegate OnCustomGameSettingsChanged();

/** Called when the MatchMode is replicated */
delegate OnMatchModeChanged(EGearVersusMatchType NewMatchMode);

/** Called when the Versus game type is replicated */
delegate OnVersusGameTypeChanged(int GameContextId);


/** Overridden to initialize SelectedMutators */
simulated event PostBeginPlay()
{
	local int i;

	super.PostBeginPlay();
	
	for (i = 0; i < NUM_SELECTED_MUTATORS; i++)
	{
		SelectedMutators[i]=NO_MUTATOR;
	}
}

/**
 * Sets the playlist that is being used and determines the team sizes
 *
 * @param NewPlaylistId the playlist to switch to
 */
function SetPlaylist(int NewPlaylistId)
{
	local OnlinePlaylistManager PlaylistMan;
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlaylistId = NewPlaylistId;
		// Read the playlist information
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != None)
		{
			PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId,TeamSize,TeamCount,MaxPartySize);
		}
	}
}

/**
 * Does per replicated variable handling on the client
 *
 * @param VarName the variable that was just replicated
 */
simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case nameof(MatchmakingState):
			OnMatchMakingStateChanged();
			break;
		case nameof(GameSettingsValues):
			OnCustomGameSettingsChanged();
			break;
		case nameof(MatchMode):
			OnMatchModeChanged(EGearVersusMatchType(MatchMode));
			break;
		case nameof(VersusGameType):
			OnVersusGameTypeChanged(VersusGameType);
			break;
		case nameof(SelectedMutators):
			OnSelectedMutatorsChanged();
			break;
		case nameof(NumClientsUnlockedMutators):
			OnClientsUnlockedMutatorsChanged();
			break;
		case nameof(bDifficultySelection):
			OnDifficultySelectionChanged();
			break;
		default:
			Super.ReplicatedEvent(VarName);
			break;
	}
}

/** Function to reset the main menu countdown timer
 *  @param StartTime - the time to start the countdown timer at
 */
function ResetMainMenuCountdownTimer(int StartTime)
{
	MainMenuCountdownTimer = StartTime;

	if (StartTime > 0)
	{
		SetTimer(1,true,nameof(DecrementCountdownTimer));
	}
}

function DecrementCountdownTimer()
{
	if (Role == ROLE_Authority)
	{
		//Decrement and notify everyone.
		if (MainMenuCountdownTimer > 0)
		{
			MainMenuCountdownTimer = MainMenuCountdownTimer - 1;
			bForceNetUpdate = true;
		}

		//If we are done, stop calling it.
		if (MainMenuCountdownTimer <= 0)
		{
			ClearTimer(nameof(DecrementCountdownTimer));
		}
	}
}

/**
 * Function called when the selected mutators array has been changed
 */
simulated function OnSelectedMutatorsChanged()
{
	local GearPC GPC;
	local GearMenuHUD GMH;

	//Find the player controller with the front end movie and tell the movie to update
	foreach WorldInfo.LocalPlayerControllers(class'GearPC', GPC)
	{
		GMH = GearMenuHUD(GPC.myHUD);
		if (GMH.FrontEndMovie != none)
		{
			GMH.FrontEndMovie.UpdateMutatorSelection();
			break;
		}
	}
}

/**
 * Function called when the clients unlocked mutators array has been changed
 */
simulated function OnClientsUnlockedMutatorsChanged()
{
	local GearPC GPC;
	local GearMenuHUD GMH;

	//Find the player controller with the front end movie and tell the movie to update
	foreach WorldInfo.LocalPlayerControllers(class'GearPC', GPC)
	{
		GMH = GearMenuHUD(GPC.myHUD);
		if (GMH != None && GMH.FrontEndMovie != none)
		{
			GMH.FrontEndMovie.UpdateMutatorClientNumbers();
			break;
		}
	}
}

/** 
 *  Function checks the MutatorsUnlockedBitfields in all clients PRI's and constructs the NumClientsUnlockedMutators array
 */
function RecomputeMutatorsUnlocked()
{
	local int i,j;
	local GearPartyPRI PartyPRI;

	for(i = 0; i < `TOTAL_MUTATORS; i++)
	{
		NumClientsUnlockedMutators[i] = 0;
	}

	for( i = 0; i < PRIArray.Length; i++)
	{
		PartyPRI = GearPartyPRI(PRIArray[i]);
		//Don't count the host!
		if (PartyPRI != none && !PartyPRI.bIsInactive && !(GearPC(PartyPRI.Owner).IsPrimaryPlayer() && (LocalPlayer(GearPC(PartyPRI.Owner).Player) != None)))
		{
			for (j = 0; j < `TOTAL_MUTATORS; j++)
			{
				if ((PartyPRI.MutatorsUnlockedBitfield & (1 << j)) > 0)
				{
					NumClientsUnlockedMutators[j]++;
				}
			}
		}
	}

	bNetDirty = true;
	bForceNetUpdate = true;
	OnClientsUnlockedMutatorsChanged();
}

/**
 * Function called when the difficulty selection screen's visibility has changed
 */
simulated function OnDifficultySelectionChanged()
{
	local GearPC GPC;
	local GearMenuHUD GMH;

	//Find the player controller with the front end movie
	foreach WorldInfo.LocalPlayerControllers(class'GearPC', GPC)
	{
		GMH = GearMenuHUD(GPC.myHUD);
		if (GMH.FrontEndMovie != none)
		{
			if (bDifficultySelection == false)
			{
				if (GMH.FrontEndMovie.DifficultyScene != none)
				{
					GMH.FrontEndMovie.DifficultyScene.CloseSceneGracefully();
				}
			}
			else
			{
				GMH.FrontEndMovie.OpenDifficultySelectionScreen();
			}
			break;
		}
	}
}
	

DefaultProperties
{
	PartySlotsFilled=1
	VersusGameType=-1
	MatchMode=-1
	MainMenuCountdownTimer=-1

	GameSettingsValues(eGEARVERSUSSETTING_WingmanScore)=255
	GameSettingsValues(eGEARVERSUSSETTING_KOTHRoundScore)=255
	GameSettingsValues(eGEARVERSUSSETTING_NoobRoundScore)=255
	GameSettingsValues(eGEARVERSUSSETTING_EnemyDiff)=255
	GameSettingsValues(eGEARVERSUSSETTING_HordeWave)=255
	GameSettingsValues(eGEARVERSUSSETTING_RoundsToWin)=255
	GameSettingsValues(eGEARVERSUSSETTING_RoundTime)=255
	GameSettingsValues(eGEARVERSUSSETTING_NumBots)=255
	GameSettingsValues(eGEARVERSUSSETTING_BotDiff)=255
	GameSettingsValues(eGEARVERSUSSETTING_Bleedout)=255
	GameSettingsValues(eGEARVERSUSSETTING_FriendlyFire)=255
	GameSettingsValues(eGEARVERSUSSETTING_MapSelection)=255
	GameSettingsValues(eGEARVERSUSSETTING_WeaponSwap)=255
}
