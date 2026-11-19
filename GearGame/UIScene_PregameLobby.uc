/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIScene_PregameLobby.uc
 * 
 * Class that governs the functionality of the pregame lobby.  For its equivalent ActionScript class, see GearGame/Flash/ActionScript/gears/views/PregameLobbyView.as
 */

class UIScene_PregameLobby extends GearGFxMoviePlayer;

// --- Player and Game References ------------------------------
/** Reference to the GRI in charge of this match */
var transient GearPreGameGRI    GRI;

/** Local players that are currently being managed by the lobby */
var transient GearPregameLobbyPRI   PlayerPRI[2];

/** Number of local players */
var transient int               NumPlayers;

// --- Widget References ---------------------------------------
/** The main pregame lobby header */
var transient UIWidget_MenuHeader       MenuHeader;

/** The sub header that appears for map selection, map vote, etc */
var transient GFxObject                 MapVoteSubHeader;

/** Text label at the bottom containing the  */
var transient GFxObject                 ControllerMap;

/** Map selection widget for custom matches without map voting */
var transient UIWidget_MPCustomMap      CustomMap;

/** Map vote widgets for each player */
var transient UIWidget_MapVoteControl   MapVoteWidget[2];

/** Loadout controls for each player */
var transient UIWidget_MPLoadOutControl LoadoutControl[2];

/** Widget that contains the information on the gametype / map that won the vote */
var transient UIWidget_MPGamePreview    GamePreview;

/** Reference to the small party panel */
var transient UIWidget_SmallPartyPanel  SmallPartyPanel;

/** Reference to the whats up scene */
var transient UIScene_WhatsUp           WhatsUpScene;
var class<UIScene_WhatsUp>              WhatsUpSceneClass;

// --- State Variables -----------------------------------------
/** TRUE if we're currently in the mapvote stage, FALSE if not */
var transient bool bIsInMapVoting;

/** TRUE if we're currently in the loadout selection stage, FALSE if not */
var transient bool bIsInLoadoutSelection;

/** TRUE if we're currently in custom map selection, FALSE if not */
var transient bool bIsInCustomMapSelection;

// --- Player and Loadout Info ---------------------------------
/** List of available COG characters to choose from */
var transient array<COGCharacterSummary>    COGCharacters;

/** List of available Locust characters to choose from */
var transient array<LocustCharacterSummary> LocustCharacters;

/** List of available weapons to choose from (primary and secondary) */
var transient array<GearGameWeaponSummary>  WeaponSelection;

// --- Game Description ----------------------------------------
/** Container struct that contains an array of the game settings we want to display for the various game types */
struct GameDescriptionInfo
{
	/** The settings ID to display the name and value for.  See GearVersusGameSettings.uc for definition of most of these, or the specific game setting class for more choices */
	var array<int>  SettingId;
};

/** An array containg the settings to display for the various game types, indexed by EGearMPTypes */
var array<GameDescriptionInfo>  GametypeDescriptions;

// --- Localized Strings ---------------------------------------
var localized string    PregameLobbyTitle;
var localized string    VotingHeader;
var localized string    MPLoadoutHeader;
var localized string    MapSelectionHeader;
var localized string    WaitingForPlayersTitle;
var localized string    VotingDescription;
var localized string    MapSelectionDescription;
var localized string    PlayerLoadoutDescription;
var localized string    MatchCountdownTitle;

var localized string    Controller_ReturnToLobby;
var localized string    Controller_ReturnToMapSelect;
var localized string    Controller_SwitchTeams;
var localized string    Controller_HostStart;
var localized string    Controller_HostSelectMap;

// --- Delegates -----------------------------------------------
/** Delegate that will be called when the current scene fades out */
delegate OnSceneCloseComplete();


//==============================================================
// Initialization and Setup
//==============================================================

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *  
 *  @param LocPlay  Local player that is the owner of this scene
 */
function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	// Move on to check to see if the pregame GRI and players are valid and replicated
	PostInitialize();

	// Turn chat tracking on (talk bubbles)
	TrackChat(true);
}


/** Overloaded to turn off hook into chat tracking */
event OnClose()
{
	// Turn off chat tracking (talk bubbles)
	TrackChat(false);

	// Clear the callbacks for the PreGameGRI
	GRI.OnGameVoteSubmitted = None;
	GRI.OnHostSelectedMapChanged = None;
	GRI.OnLobbyStateChanged = None;
	GRI.OnSelectionCountdownTick = None;
	GRI.OnHostStartedPregameCountdown = None;
	GRI.OnMapSelectionUpdate = None;

	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.CleanupPartyPanel();
	}

	Super.OnClose();
}


/** Initialize the widget by counting and storing references to the players controlled by this loadout.  Will hold in this function until GRI/PRI are valid */
function PostInitialize()
{
	local GearPregamePC PregamePC;
	local GearPregameLobbyPRI GPRI;
	local WorldInfo WI;
	local bool  bNeedsToWaitForInit;

	// See if the GRI has replicated yet.
	GRI = GearPreGameGRI(GetGRI());
	bNeedsToWaitForInit = (GRI == None);

	// Iterate over the local players and get a count, and cache references to it
	WI = GetWorldInfo();
	NumPlayers = 0;
	ForEach WI.LocalPlayerControllers(class'GearPregamePC', PregamePC)
	{
		GPRI = GearPregameLobbyPRI(PregamePC.PlayerReplicationInfo);
		if( GPRI != None )
		{
			// If we have a valid PRI, add it to the array and continue on
			PlayerPRI[NumPlayers] = GPRI;
			NumPlayers++;
		}
		else
		{
			// PRI hasn't replicated yet, wait for it before launching lobby
			bNeedsToWaitForInit = TRUE;
			NumPlayers = 0;
			break;
		}
	}

	// If the GRI hasn't replicated yet, or PRIs are invalid, then wait until it they become valid
	if( bNeedsToWaitForInit )
	{
		`log("UIScene_PregameLobby - Deferring starting scene until Pregame GRI is available...",,'GearsUI');
		GetPC().SetTimer(0.1f, FALSE, nameof(PostInitialize), self);
		return;
	}
	else
	{
		`log("UIScene_PregameLobby - Got Pregame GRI, beginning scene...",,'GearsUI');
	}

	// Map the controller IDs to the primary and secondary players
	MapControllersToPlayers();

	// Grab information for the characters and weapons we'll be choosing from
	InitializeGameDataStores();

	// Set up the callbacks for the PreGameGRI
	GRI.OnGameVoteSubmitted = ReceivedGameVote;
	GRI.OnHostSelectedMapChanged = SelectedMapChangedByHost;
	GRI.OnLobbyStateChanged = LobbyStateChanged;
	GRI.OnSelectionCountdownTick = SelectionCountdownTick;
	GRI.OnHostStartedPregameCountdown = BeginPregameCountdown;
	GRI.OnMapSelectionUpdate = UpdateMapSelectionImageAndTitle;

	// Make sure the initial lobby state changed call gets through
	LobbyStateChanged( GRI.PreGameLobbyState );

	// Notify the server that we have opened the scene, so that the state may progress
	ForEach WI.LocalPlayerControllers(class'GearPregamePC', PregamePC)
	{
		PregamePC.SetTimer(1.f, TRUE, nameof(PregamePC.NotifyLobbySceneOpened), PregamePC);
	}
}

/**
 * Called whenever a new widget is initialized in the movie
 * 
 * @param   WidgetName      Flash instance name of the widget being initialized
 * @param   WidgetPath      Full path of the widget in the movie
 * @param   Widget          Reference to the widget that was initialized.  If this widget is bound via WidgetBindings, it will be of the appropriate subclass
 * 
 * @return  Whether or not this widget was handled
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch( WidgetName )
	{
		case 'MenuHeader':
			MenuHeader = UIWidget_MenuHeader(Widget);
			SetWidgetPathBinding(MenuHeader, WidgetPath);
			MenuHeader.SetCurrentTitle("");
			MenuHeader.SetPreviousTitle("");
			break;
		case 'ControllerMap':
			ControllerMap = Widget;
			SetControllerButtons();
			break;
		case 'CustomMap':
			CustomMap = UIWidget_MPCustomMap(Widget);
			SetWidgetPathBinding(CustomMap, WidgetPath);
			CustomMap.Initialize();
			if( GRI.Role == ROLE_Authority )
			{
				CustomMap.PopulateMapList(GRI);
			}
			else
			{
				SelectedMapChangedByHost();
			}
			ActionScript_SetSelectionFocus(Widget, TRUE);
			break;
		case 'MapVote1':
			MapVoteWidget[0] = UIWidget_MapVoteControl(Widget);
			SetWidgetPathBinding(MapVoteWidget[0], WidgetPath);
			MapVoteWidget[0].Initialize(GetLocalPlayer(0));
			// Set focus to the MapVoteList within MapVote1 for Player 1
			ActionScript_SetSelectionFocus(Widget.GetObject("MapVoteList"), TRUE);			
			break;
		case 'MapVote2':
			MapVoteWidget[1] = UIWidget_MapVoteControl(Widget);
			SetWidgetPathBinding(MapVoteWidget[1], WidgetPath);
			MapVoteWidget[1].Initialize(GetLocalPlayer(1));
			// Set focus to the MapVoteList within MapVote2 for Player 2
			ActionScript_SetSelectionFocus(Widget.GetObject("MapVoteList"), FALSE);
			break;
		case 'PlayerLoadoutSingle':
		case 'PlayerLoadout1':
			LoadoutControl[0] = UIWidget_MPLoadoutControl(Widget);
			ActionScript_SetSelectionFocus(Widget, TRUE);
			SetWidgetPathBinding(LoadoutControl[0], WidgetPath);
			InitializePlayerLoadout(0);
			break;
		case 'PlayerLoadout2':
			LoadoutControl[1] = UIWidget_MPLoadoutControl(Widget);
			ActionScript_SetSelectionFocus(Widget, FALSE);
			SetWidgetPathBinding(LoadoutControl[1], WidgetPath);
			InitializePlayerLoadout(1);
			break;
		case 'GamePreview':
			GamePreview = UIWidget_MPGamePreview(Widget);
			SetWidgetPathBinding(GamePreview, WidgetPath);
			InitializeGamePreview();
			break;
		case 'mc_SmallPPanelContainer':
			if( SmallPartyPanel != None )
			{
				// If we already have a small party panel, give it a chance to clean itself up
				SmallPartyPanel.CleanupPartyPanel();
			}
			SmallPartyPanel = UIWidget_SmallPartyPanel(Widget);
			SetWidgetPathBinding(SmallPartyPanel, WidgetPath);
			SmallPartyPanel.InitializePartyPanel(PPC_PreGameLobby, self);
			break;
		case 'MapVoteSubHeader':
			MapVoteSubHeader = Widget;
			SetMenuSubheader();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

/** 
 * Can be overridden to filter input to this movie.  Return TRUE to trap the input, FALSE to let it pass through to Gfx
 *
 * @param   ControllerId    The Id of the controller that the input came from
 * @param   ButtonName      The name of the button that was hit
 * @param   InputEvent      What type of input event was this (e.g. pressed, released)
 * 
 * @return  TRUE if the input should be trapped and not passed on, FALSE to pass it on to GFx for handling
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if( GRI != None )
	{
		// Eat all input as soon as the character select is done
		if( GRI.PreGameLobbyState > eGPGLSTATE_CharacterSelect )
		{
			return TRUE;
		}
		// Eat all A button input in character selection when in wingman
		else if( (GRI.PreGameLobbyState == eGPGLSTATE_CharacterSelect) && IsWingmanGametype(GRI) && (ButtonName == 'XboxTypeS_A') )
		{
			return TRUE;
		}
	}

	// Check for if we're the primary player
	if( GearPC(PlayerPRI[0].Owner).GetControllerId() == ControllerId )
	{
		// B Button Pressed, try to back up to map selection, or leave lobby
		if( (ButtonName == 'XboxTypeS_B' && InputEvent == IE_Pressed) && (!bIsInLoadoutSelection || (LoadoutControl[0] != None &&  !LoadoutControl[0].IsInCharacterLoadout())) )
		{
			if( CanBackUpToMapSelect() )
			{
				OnGotoMapSelect();
				return TRUE;
			}
			else if( CanLeaveGame() )
			{
				OnLeaveGame();
				return TRUE;
			}
			
		}
		else if( (ButtonName == 'XboxTypeS_Start' && InputEvent == IE_Pressed) && CanHostStartGame() )
		{
			OnHostStartGame();
			return TRUE;
		}
	}
	
	// If we handle team switching eat the input and perform the switch
	if (ButtonName == 'XboxTypeS_Y' &&
		InputEvent == IE_Pressed &&
		PlayersCanChangeTeams())
	{
		OnChangeTeam(ControllerId);
		return TRUE;
	}

	// Check for opening the what's up screen
	if (ButtonName == 'XboxTypeS_X' &&
		InputEvent == IE_Pressed && 
		SmallPartyPanel != None)
	{
		WhatsUpScene = SmallPartyPanel.OpenWhatsUpScene(WhatsUpSceneClass, self, GetLPForControllerId(ControllerId), OnCloseWhatsUp);
		return TRUE;
	}

	// Only the host should be able to give input to the scene when in custom map selection
	if( bIsInCustomMapSelection && GetWorldInfo().Role != ROLE_Authority )
	{
		return TRUE;
	}

	return FALSE;
}

/** Called when a player requests to change teams */
function bool OnChangeTeam(int ControllerId)
{
	local GearMenuPC PC;
	local LocalPlayer LP;

	foreach GetWorldInfo().LocalPlayerControllers(class'GearMenuPC', PC)
	{
		LP = LocalPlayer(PC.Player);
		if (PC.Player != None)
		{
			if (LP.ControllerId == ControllerId)
			{
				break;
			}
		}
	}

	if (PC != None && GRI != None)
	{
		PC.ServerRequestChangeTeam(SmallPartyPanel.NumPlayersPerTeam);
	}

	return true;
}

/**
 * Called when the what's up scene is closed
 */
function OnCloseWhatsUp()
{
	// Clear the reference to the whats up scene
	WhatsUpScene = None;
}

//==============================================================
// Flow Control
//==============================================================

/** Opens the map vote menu, calling the appropriate ActionScript setup function for the number of players */
function OpenMapVote()
{
	if( NumPlayers == 1 )
	{
		ActionScript_OpenSingleMapVote();
	}
	else
	{
		ActionScript_OpenDoubleMapVote();
	}

	// Set up the title for the map voting
	MenuHeader.SetCurrentTitle( PregameLobbyTitle );
	MenuHeader.PushTitleOnStack( VotingHeader );

	bIsInMapVoting = TRUE;
}

/** Closes the map vote menu, calling the appropriate ActionScript setup function for the number of players */
function CloseMapVote()
{
	if( NumPlayers == 1 )
	{
		ActionScript_CloseSingleMapVote();
	}
	else
	{
		ActionScript_CloseDoubleMapVote();
	}

	bIsInMapVoting = FALSE;
}

/** Opens up custom map selection if we're in a gametype that doesn't support map vote */
function OpenCustomMapSelection()
{
	ActionScript_OpenCustomMapControl();

	// Set up the title for the map voting
	MenuHeader.SetCurrentTitle( PregameLobbyTitle );
	MenuHeader.PushTitleOnStack( MapSelectionHeader );

	bIsInCustomMapSelection = TRUE;
}

/** Closes custom map selection */
function CloseCustomMapSelection()
{
	ActionScript_CloseCustomMapControl();

	bIsInCustomMapSelection = FALSE;
}

/** Opens the character loadout selection, calling the appropriate ActionScript setup function for the number of players */
function OpenLoadoutSelection()
{
	if( NumPlayers == 1 )
	{
		ActionScript_OpenSingleLoadOut();
	}
	else
	{
		ActionScript_OpenDoubleLoadOut();
	}
	
	// Set up the title for the map voting
	MenuHeader.SetCurrentTitle( PregameLobbyTitle );
	MenuHeader.PushTitleOnStack( MPLoadoutHeader );

	bIsInLoadoutSelection = TRUE;
}

/** Animates out the loadout selection, so we can animate in the next stage */
function CloseLoadoutSelection()
{
	if( NumPlayers == 1 )
	{
		ActionScript_CloseSingleLoadOut();
	}
	else
	{
		ActionScript_CloseDoubleLoadOut();
	}

	bIsInLoadoutSelection = FALSE;
}

/** Closes the character loadout selection, calling the appropriate ActionScript setup function for the number of players */
function LockLoadoutSelection()
{
	// Lock the loadout for the first player
	LoadoutControl[0].LockLoadout();
	SaveProfile(None, GearPC(PlayerPRI[0].Owner));

	if( NumPlayers > 1 )
	{
		// Lock the loadout for the second player, if any
		LoadoutControl[1].LockLoadout();
		SaveProfile(None, GearPC(PlayerPRI[1].Owner));
	}
	
	bIsInLoadoutSelection = FALSE;
}

/** Opens the game summary only screen for modes that don't have character selection */
function OpenGameSummary()
{
	ActionScript_OpenGameSummary();
}

/** Closes the game summary only screen for modes that don't have character selection */
function CloseGameSummary()
{
	ActionScript_CloseGameSummary();
}

//==============================================================
// Update and flow control
//==============================================================

/**
 * Update function called for the UIScene.  Will handle updating the timer, etc
 * 
 * @param   DeltaTime   Time since the last advance
 */
function UpdatePregameLobby(float DeltaTime)
{
	// Bail early if we haven't passed initialization
	if( GRI == None )
	{
		return;
	}

	// === Header Updates ===
	// --- Game Selection ---
	if( GRI.PreGameLobbyState == eGPGLSTATE_GameSelection )
	{
		if( GRI.bGameVoteEnabled )
		{
			MenuHeader.SetPregameTimerVisibility(TRUE);
			MenuHeader.SetPregameTime(GRI.RemainingGameVoteSeconds);
		}
		else
		{
			MenuHeader.SetPregameTimerVisibility(FALSE);
		}
	}
	// --- Character Selection ---
	else if ( GRI.PreGameLobbyState == eGPGLSTATE_CharacterSelect )
	{
		MenuHeader.SetPregameTimerVisibility( GRI.bGameVoteEnabled ? TRUE : GRI.bHostTriggeredGameStart );
		MenuHeader.SetPregameTime(GRI.RemainingSecondsForLoadoutSelection);
		
		// Check to see if we've changed teams.  If so, reconfigure the loadout
		if( bIsInLoadoutSelection )
		{
			// Check for team change on player 1
			if( PlayerPRI[0].GetTeamNum() != PlayerPRI[0].LastCheckedTeamNum )
			{
				PlayerPRI[0].LastCheckedTeamNum = PlayerPRI[0].GetTeamNum();
				InitializePlayerLoadout(0);
			}

			// Check for team change on player 2
			if( (PlayerPRI[1] != None) && (PlayerPRI[1].GetTeamNum() != PlayerPRI[1].LastCheckedTeamNum) )
			{
				PlayerPRI[1].LastCheckedTeamNum = PlayerPRI[1].GetTeamNum();
				InitializePlayerLoadout(1);
			}
		}
	}
	// --- Match Starting ---
	else if( GRI.PreGameLobbyState == eGPGLSTATE_StartingMatch )
	{
		MenuHeader.SetPregameTimerVisibility(FALSE);
	}

	// Let the party panel update
	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.UpdatePartyPanel(DeltaTime);
	}
}

/**
 * Sets new text in the submenu header based on the current UI state
 */
function SetMenuSubheader()
{
	local GFxObject Label;

	if( MapVoteSubHeader != None )
	{
		Label = MapVoteSubHeader.GetObject("lbl_MenuItem");
		if( bIsInMapVoting )
		{
			Label.SetString("htmlText", "<font color='#999999'>" $ VotingDescription $ "</font>");
		}
		else if( bIsInLoadoutSelection )
		{
			Label.SetString("htmlText", "<font color='#999999'>" $ PlayerLoadoutDescription $ "</font>");
		}
		else if( bIsInCustomMapSelection )
		{
			Label.SetString("htmlText", "<font color='#999999'>" $ MapSelectionDescription $ "</font>");
		}
	}
}

/**
 * Sets the controller button bar at the bottom of the screen to have the appropriate contextual buttons for the current state of the lobby
 */
function SetControllerButtons()
{
	local GFxObject TextLabel;
	local string ButtonString, ButtonSpacing;

	ButtonString = "";
	ButtonSpacing = "     ";

	// B Button...can host go back to map select, or failing that, can players leave the game?
	if( CanBackUpToMapSelect() )
	{
		ButtonString = Controller_ReturnToMapSelect;
	}
	else if( CanLeaveGame() )
	{
		ButtonString = Controller_ReturnToLobby;
	}

	// Start Button...can host start game or select map?
	if( CanHostStartGame() && !GRI.bHostTriggeredGameStart )
	{
		ButtonString $= ButtonSpacing $ Controller_HostStart;
	}
	else if( (GRI.Role == ROLE_Authority) && GRI.PreGameLobbyState == eGPGLSTATE_GameSelection && !GRI.bGameVoteEnabled )
	{
		ButtonString $= ButtonSpacing $ Controller_HostSelectMap;
	}

	TextLabel = ControllerMap.GetObject("textField");
	// Only one state now
	TextLabel.SetBool("html", TRUE);
	TextLabel.SetString("htmlText", ButtonString);
}

/**
 * Called when a player wants to leave the game
 *
 * @param   ControllerIdx   Index of the controller that hit the button
 */
function OnLeaveGame()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local bool bCanLeave;

	// See if they can actually leave
	if( IsOfficialMatch() || IsPlayerMatch() )
	{
		bCanLeave = (GRI.Role == ROLE_Authority);
	}
	else
	{
		bCanLeave = CanLeaveGame();
	}

	// If they can leave prompt them first
	if (bCanLeave)
	{
		ButtonAliases.AddItem('AcceptLeave');
		ButtonAliases.AddItem('CancelStay');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage('ConfirmQuit',
			"<Strings:GearGameUI.MessageBoxStrings.LeavePregameLobby_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.LeavePregameLobby_" $ (IsPartyLeader() ? "Leader" : "Member") $ "Message>",
			ButtonAliases, OnLeaveLobby_Confirmed, GetLP());
	}
}

/**
 * Handler for the confirmation dialog's OnSelection delegate.  Leaves the lobby if the user confirmed.
 *
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnLeaveLobby_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local bool bCanLeave;

	if ( SelectedInputAlias == 'AcceptLeave' )
	{
		// Make sure it's still ok for them to leave (time has passed since they first clicked!!!!
		if( IsOfficialMatch() || IsPlayerMatch() )
		{
			bCanLeave = (PlayerIndex == 0) && (GRI.Role == ROLE_Authority);
		}
		else
		{
			bCanLeave = CanLeaveGame();
		}

		if (bCanLeave)
		{
			// this call will trigger the loading movie
			LeaveMatch();
		}
	}

	return true;
}

/**
 * Called when the host should start the game.
 */
function OnHostStartGame()
{
	local GearUIManager UIManager;
	local array<name>   ButtonAliases;

	// Only the match host (not the splitscreen player) should be able to start the match;
	if ( CanHostStartGame() )
	{
		if ( AtLeastTwoTeamsAreAvailable() || IsHordeGametype(GRI) )
		{
			StartPregameCountdown();

			// Update the controller buttons on the host, since the start option is no longer available
			SetControllerButtons();
		}
		else
		{
			ButtonAliases.AddItem('GenericContinue');
			UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
			UIManager.ShowUIMessage('NotEnoughPlayers',
				"<Strings:GearGameUI.MessageBoxErrorStrings.NotEnoughTeams_Title>",
				"<Strings:GearGameUI.MessageBoxErrorStrings.NotEnoughTeams_Message>",
				ButtonAliases,
				OnNotEnoughTeams_Confirmed);
		}
	}
}

/**
 * Called when the error message closes for not enough teams
 * 
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnNotEnoughTeams_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	return true;
}

/**
 * Start the brief 5-second countdown in a private match
 */
function StartPregameCountdown(optional bool bStartImmediately=false)
{
	if ( !GRI.bHostTriggeredGameStart )
	{
		if (bStartImmediately && GRI.Role == ROLE_Authority)
		{
			GRI.SetLobbyState( eGPGLSTATE_StartingMatch );
		}
		else
		{
			GRI.CountdownTime = 5;
			GRI.RemainingSecondsForLoadoutSelection = 5;
		}
		GRI.bHostTriggeredGameStart = TRUE;

		BeginPregameCountdown();
	}
}

/**
 * Notification function that gets called when players swap teams
 * 
 * @param   PRI1    PRI of the first player that changed teams
 * @param   PRI2    PRI of the second player that changed teams
 */
function NotifyTeamChanged(GearPRI PRI1, GearPRI PRI2)
{
	// Let the party panel know
	if( SmallPartyPanel != None )
	{
		SmallPartyPanel.TeamChangeOccuredCallback(PRI1, PRI2);
		if (WhatsUpScene != None && WhatsUpScene.PartyList != None)
		{
			WhatsUpScene.PartyList.TeamChangeOccuredCallback(PRI1, PRI2);
		}
	}

	// If the PRI is local, we've changed teams and need to refresh the character select, if applicable
	if( bIsInLoadoutSelection )
	{
		// Check for Player 1
		if( PRI1 == PlayerPRI[0] || PRI2 == PlayerPRI[0] )
		{
			InitializePlayerLoadout(0);
		}

		// Check for Player 2
		if( (PlayerPRI[1] != None) && (PRI1 == PlayerPRI[1] || PRI2 == PlayerPRI[1]) )
		{
			InitializePlayerLoadout(1);
		}
	}
}

//==============================================================
// Pregame PRI Callbacks
//==============================================================

function ReceivedGameVote()
{
	local array<ASValue> args;	
	args.length = 0;
	
	if( MapVoteWidget[0] != None )
	{
		MapVoteWidget[0].UpdateVoteCount(0, GRI.FirstGameVoteCount);
		MapVoteWidget[0].UpdateVoteCount(1, GRI.SecondGameVoteCount);
		MapVoteWidget[0].UpdateVoteCount(2, GRI.ThirdGameVoteCount);
		MapVoteWidget[0].Invoke("InvalidateList", args);
	}

	if( MapVoteWidget[1] != None )
	{
		MapVoteWidget[1].UpdateVoteCount(0, GRI.FirstGameVoteCount);
		MapVoteWidget[1].UpdateVoteCount(1, GRI.SecondGameVoteCount);
		MapVoteWidget[1].UpdateVoteCount(2, GRI.ThirdGameVoteCount);
		MapVoteWidget[1].Invoke("InvalidateList", args);
	}
}

function SelectedMapChangedByHost()
{
 	local GearGameMapSummary MapSummary;

 	MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(GRI.SelectedMapName);
 	if( MapSummary != None )
 	{
 		CustomMap.SetMapNameAndImage( MapSummary.DisplayName, MapSummary.ScreenshotPathName );
 	}
}

function LobbyStateChanged( EGearPGLState NewLobbyState )
{
	switch( NewLobbyState )
	{
		case eGPGLSTATE_Initialize:
			// Set the header to the initial state
			MenuHeader.SetCurrentTitle( PregameLobbyTitle );
			MenuHeader.PushTitleOnStack( WaitingForPlayersTitle );
			MenuHeader.SetPregameTimerVisibility(FALSE);
			break;
		case eGPGLSTATE_GameSelection:
			// If we're coming back from character loadout, clear that flag
			if( bIsInLoadoutSelection )
			{
				CloseLoadoutSelection();
				OnSceneCloseComplete = (GRI.bGameVoteEnabled ? OpenMapVote : OpenCustomMapSelection );
			}
			else if( GRI.bGameVoteEnabled )
			{
				OpenMapVote();
			}
			else
			{
				OpenCustomMapSelection();
			}
			break;
		case eGPGLSTATE_PreCharacterSelect:
			if( bIsInMapVoting )
			{
				// Close map voting, then transition to loadout selection
				CloseMapVote();
				OnSceneCloseComplete = OpenLoadoutSelection;
			}
			else if( bIsInCustomMapSelection )
			{
				// Close map selection, then transition to loadout selection
				CloseCustomMapSelection();
				OnSceneCloseComplete = OpenLoadoutSelection;
			}
			else
			{
				// Nothing is currently open, jump right to the loadout selection
				OpenLoadoutSelection();
			}
			break;
		case eGPGLSTATE_PostCharacterSelect:
			LockLoadoutSelection();
			break;
		case eGPGLSTATE_StartingMatch:
			MenuHeader.SetSpinningCogVisibility(TRUE);
			MenuHeader.PushTitleOnStack(MatchCountdownTitle);

			// If this is siege, bring up a game summary screen, since we never got to the loadout state with the summary on it
			if( IsSiegeGametype(GRI) )
			{
				OpenGameSummary();
			}
			break;
		default:
			break;
	}

	// Update the controller buttons for our current state
	SetControllerButtons();
}

function SelectionCountdownTick();

function BeginPregameCountdown();

function UpdateMapSelectionImageAndTitle( bool bMapSelectSuspended );

//==============================================================
// Callbacks
//==============================================================

/**
 * Called from ActionScript when a scene has been closed, and the game is ready to open the next
 */
function Callback_OnSceneClosed()
{
	// If there was a pending scene to open, do so now.
	if( OnSceneCloseComplete != None )
	{
		OnSceneCloseComplete();

		// Set this to "None" so we don't get repeated calls
		OnSceneCloseComplete = None;
	}
}

/**
 * Callback that occurs when the host changes the selection of a custom map
 * 
 * @param   MapId   Index into the Pregame GRI's MapFileNames that was selected
 */
function OnCustomMapChanged(int MapId)
{
	GRI.SubmitMapSelectionByName( GRI.MapFileNames[MapId] );
}

/**
 * Callback that occurs when the host selects a custom map
 * 
 * @param   MapId   Index into the Pregame GRI's MapFileNames that was selected
 */
function OnCustomMapSelected(int MapId)
{
	GRI.SubmitMapSelectionByName( GRI.MapFileNames[MapId] );
	GRI.SubmitHostFinishedMapSelection();
}


//==============================================================
// ActionScript Function Stubs
//==============================================================

private function ActionScript_SetPrimaryController(int PrimaryControllerIdx)
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.SetPrimaryController");
}

private function ActionScript_SetSecondaryController(int SecondaryControllerIdx)
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.SetSecondaryController");
}

private function ActionScript_SetSelectionFocus(GFxObject MovieClip, bool bIsPrimary)
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.SetSelectionFocus");
}

private function ActionScript_OpenCustomMapControl()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.OpenCustomMapControl");
}

private function ActionScript_CloseCustomMapControl()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.CloseCustomMapControl");
}

private function ActionScript_OpenSingleMapVote()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.OpenSingleMapVote");
}

private function ActionScript_CloseSingleMapVote()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.CloseSingleMapVote");
}

private function ActionScript_OpenDoubleMapVote()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.OpenDoubleMapVote");
}

private function ActionScript_CloseDoubleMapVote()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.CloseDoubleMapVote");
}

private function ActionScript_OpenSingleLoadOut()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.OpenSingleLoadOut");
}

private function ActionScript_CloseSingleLoadOut()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.CloseSingleLoadOut");
}

private function ActionScript_OpenDoubleLoadOut()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.OpenDoubleLoadOut");
}

private function ActionScript_CloseDoubleLoadOut()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.CloseDoubleLoadOut");
}

private function ActionScript_OpenGameSummary()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.OpenGameSummary");
}

private function ActionScript_CloseGameSummary()
{
	ActionScriptVoid("PregameLobbySP.PregameLobby.CloseGameSummary");
}

//==============================================================
// Helper functions
//==============================================================

/**
 * Maps a controller number to the primary and secondary players, so that GFx can properly associate input with the primary and secondary player 
 */
function MapControllersToPlayers()
{
	// Set the primary player's controller mask
	ActionScript_SetPrimaryController( GearPC(PlayerPRI[0].Owner).GetControllerId() );

	// If we have more than one player, set their mask as well
	if( NumPlayers > 1 )
	{
		ActionScript_SetSecondaryController( GearPC(PlayerPRI[1].Owner).GetControllerId() );
	}
}

/**
 * Sets up and filters the game data stores to be used in weapon and character selection 
 */
function InitializeGameDataStores()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> TempData;
	local int i;

	GameResourceDS = GetGameResourceDataStore();
	if( GameResourceDS != None )
	{
		// Convert the COG characters
		GameResourceDS.GetResourceProviders('COGs', TempData);
		for( i = 0; i < TempData.Length; i++ )
		{
			COGCharacters[i] = COGCharacterSummary(TempData[i]);
		}
		
		// Convert the Locust characters
		GameResourceDS.GetResourceProviders('Locusts', TempData);
		for( i = 0; i < TempData.Length; i++ )
		{
			LocustCharacters[i] = LocustCharacterSummary(TempData[i]);
		}

		// Convert the weapon options
		GameResourceDS.GetResourceProviders('Weapons', TempData);
		for( i = 0; i < TempData.Length; i++ )
		{
			WeaponSelection[i] = GearGameWeaponSummary(TempData[i]);
		}
	}
	else
	{
		`log("UIScene_PregameLobby::InitializeGameDataStores() - Failed to retrieve game datastore!",,'GearsUI');
	}
}

/**
 * Initializes a player's loadout widget with characters and weapons available to them
 *
 * @param   PlayerIdx   Index of the player into the PRI array to update the loadout for
 */
function InitializePlayerLoadout(int PlayerIdx)
{
	local int TeamNum;

	// Set the profile for this loadout control, which will also set hooks into the profile settings for updating as the player changes options
	LoadoutControl[PlayerIdx].SetProfile( PlayerPRI[PlayerIdx], GearPC(PlayerPRI[PlayerIdx].Owner).ProfileSettings );

	// Setup the character selection, depending on which race the player is
	TeamNum = PlayerPRI[PlayerIdx].GetTeamNum();
	if( TeamNum % 2 == 0 )
	{
		LoadoutControl[PlayerIdx].SetCharacterData(COGCharacters, TRUE, TeamNum);
	}
	else
	{
		LoadoutControl[PlayerIdx].SetCharacterData(LocustCharacters, FALSE, TeamNum);
	}

	// Set up the weapon selection.  These will be filtered into primary and secondary weapons by the widget
	LoadoutControl[PlayerIdx].SetWeaponData(WeaponSelection);

	// Set the weapon descriptions (perhaps this should just be static in the FLA?)
	LoadoutControl[PlayerIdx].SetWeaponSlotDescriptions("1", "2");
}

/**
 * Called after the game preview widget has initialized.  Populate it with game information here 
 */
function InitializeGamePreview()
{
	local GearVersusGameSettings GameSettings;
	local GearVersusGameSettings PlaylistGameSettings;
	local GearGameMapSummary SelectedMap;
	local EGearMPTypes GameType;
	local OnlineSubsystem OnlineSub;
	local int StatIndex, StatCount;
	local string DescString, FontSizeString, FontSizeEndString;
	local int MatchMode;
	local GearGameInfoSummary GameSummary;
	local int SettingValue;
	local int PlaylistId;
	local GearGamePlaylistGameTypeProvider GameTypeProv;
	local OnlinePlaylistManager PlaylistMan;

	SelectedMap = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(GRI.WinningMapName);
	GamePreview.SetMapImage( SelectedMap.ScreenshotPathName );

	// Get the game settings from the game interface
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = GearVersusGameSettings(OnlineSub.GameInterface.GetGameSettings('Game'));
	}

	if (GameSettings != None &&
		GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode) &&
		(MatchMode == eGVMT_Official || MatchMode == eGVMT_Player))
	{
		// If this is a playlist style match we need to get the settings object from the playlist manager
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != None)
		{
			// Grab the playlist property from the settings object
			GameSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTID, PlaylistId);
			// Get the winnding game's gametype provider
			GameTypeProv = class'GearUIDataStore_GameResource'.static.GetPlaylistGameTypeProvider(GRI.WinningGameIndex);
			// Attempt to get the settings object from the playlist manager
			PlaylistGameSettings = GearVersusGameSettings(PlaylistMan.GetGameSettings(PlaylistId, GameTypeProv.GameTypeId));
			// If we succeeded, we set the game settings object to the one from the playlist manager
			if (PlaylistGameSettings != None)
			{
				GameSettings = PlaylistGameSettings;
			}
		}
	}
	// If it wasn't ranked or social, get it again from the datastore
	else
	{
		GameSettings = GearVersusGameSettings(GetCurrentGameSettings());
		GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode);
	}

	// Create the game description from the map game data store
	if( GameSettings != None )
	{
		// Get the formatting strings we need
		FontSizeString = Localize("FontSizing", "FontSize18", "GearGameUI");
		FontSizeEndString = Localize("FontSizing", "FontSizeEnd", "GearGameUI");

		// === Begin Font 18 Block ===
		DescString = FontSizeString;

		// Set the game type
		GameSummary = class'GearUIDataStore_GameResource'.static.GetGameSummaryFromProviderIndex(GRI.WinningGameIndex, EGearVersusMatchType(MatchMode));
		GameType = GameSummary.MPGameMode;
		DescString = Caps( GetGameModeString(GameType) ) $ "<br>";

		// Set the map name
		DescString $= "<font color='#999999'>" $ Caps(SelectedMap.DisplayName) $ "</font>";

		// === End Font 18 Block ===
		DescString $= FontSizeEndString;

		// === Begin Font 16 Block ===
		FontSizeString = Localize("FontSizing", "FontSize16", "GearGameUI");
		DescString $= FontSizeString;

		// Iterate over the game-specific description stats, and print them out
		foreach GametypeDescriptions[GameType].SettingId(StatIndex)
		{
			if( GameSettings.GetStringSettingValue(StatIndex, SettingValue) )
			{
				if( (StatCount % 2) == 0 )
				{
					// If this is a new row, add a break (two stats per row)
					DescString $= "<br>";
				}
				else
				{
					// Otherwise, add some spacing
					DescString $= "  ";
				}

				// Write out the stat description, and then its value
				DescString $= Caps( GameSettings.GetSettingOptionName(StatIndex) ) $ ": ";
				DescString $= "<font color='#999999'>" $ Caps(GameSettings.GetStringSettingValueName(StatIndex, SettingValue)) $ "</font>";

				StatCount++;
			}
		}

		// === End Font 16 Block ===
		DescString $= FontSizeEndString;

		// Set the string
		GamePreview.SetGameInfo( DescString );
	}
}

/** Whether players can leave the game or not */
function bool CanLeaveGame()
{
	local GearPreGameGRI PreGameGRI;

	PreGameGRI = GearPreGameGRI(GetGRI());

	if ( !IsOfficialMatch() &&
		 !IsPlayerMatch() &&
		 PreGameGRI != None &&
		 PreGameGRI.bAllPlayerArePresentForDisplay &&
		 PreGameGRI.PreGameLobbyState > eGPGLSTATE_Initialize &&
		 PreGameGRI.PreGameLobbyState < eGPGLSTATE_PostCharacterSelect &&
		 !PreGameGRI.bHostTriggeredGameStart)
	{
		return true;
	}

	return false;
}

/**
 * Kicks off an async task to end the 'Game' session.
 */
function LeaveMatch()
{
	local GearPC PC;

	PC = GetGearPC();

	if (PC.WorldInfo.NetMode != NM_Client)
	{
		PC.WorldInfo.Game.TellClientsToReturnToPartyHost();
	}
	else
	{
		PC.ClientReturnToMainMenu();
	}
}

/**
 * Whether or not the host can send the lobby back to the map selection state
 * 
 * @return TRUE if the host can send the pregame lobby back to map selection, FALSE if not
 */
function bool CanBackUpToMapSelect()
{
	if( GetWorldInfo().Role == ROLE_Authority && 
		GRI.PreGameLobbyState == eGPGLSTATE_CharacterSelect &&
		!GRI.bGameVoteEnabled && 
		!GRI.bHostTriggeredGameStart )
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Tells the pregame GRI to go back to the game selection state
 */
function OnGotoMapSelect()
{
	if( GRI.Role == ROLE_Authority )
	{
		GRI.SetLobbyState( eGPGLSTATE_GameSelection );
	}
}

/**
 * Whether or not this is a gametype that supports host start, and whether or not this is the host
 *
 * @return  TRUE if the host can start the match with the start button, FALSE if not
 */
function bool CanHostStartGame()
{
	return (    GetWorldInfo().NetMode != NM_Client && 
				GRI != None &&
				!GRI.bGameVoteEnabled &&
				!GRI.bHostTriggeredGameStart &&
				GRI.PreGameLobbyState == eGPGLSTATE_CharacterSelect );
}

/** Whether players can change teams or not */
function bool PlayersCanChangeTeams()
{
	if (!IsOfficialMatch() &&
		!IsPlayerMatch() &&
		GRI != None &&
		GRI.bAllPlayerArePresentForDisplay &&
		GRI.PreGameLobbyState > eGPGLSTATE_Initialize &&
		GRI.PreGameLobbyState < eGPGLSTATE_PostCharacterSelect &&
		!GRI.bHostTriggeredGameStart &&
		!IsHordeGametype(GRI) )
	{
		return true;
	}

	return false;
}

/** Returns whether there are at least 2 teams available for starting the match */
function bool AtLeastTwoTeamsAreAvailable()
{
	local int NumTeams;
	local int TotalNumPlayers;
	local int TeamIdx;
	local int ValidTeamCount;

	GetNumTeamsToDisplay( NumTeams, TotalNumPlayers );
	for (TeamIdx = 0; TeamIdx < NumTeams; TeamIdx++)
	{
		if (SmallPartyPanel.GetNumPlayersOnTeam(TeamIdx, true) > 0)
		{
			ValidTeamCount++;
			if (ValidTeamCount > 1)
			{
				return true;
			}
		}
	}
	return false;
}

/** Gets the nth controller in the local player array */
function GearPC GetLocalPlayer(int Index)
{
	local WorldInfo WI;
	local GearPC GPC;
	local int Count;

	WI = GetWorldInfo();
	ForEach WI.LocalPlayerControllers(class'GearPC', GPC)
	{
		if (Count == Index)
		{
			return GPC;
		}
		Count++;
	}
	return None;
}


defaultproperties
{
	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_Start
	CaptureKeys(1)=XboxTypeS_A
	CaptureKeys(2)=XboxTypeS_B
	CaptureKeys(3)=XboxTypeS_X
	CaptureKeys(4)=XboxTypeS_Y
	CaptureKeys(5)=XboxTypeS_DPad_Up
	CaptureKeys(6)=XboxTypeS_DPad_Down
	CaptureKeys(7)=XboxTypeS_DPad_Right
	CaptureKeys(8)=XboxTypeS_DPad_Left
	CaptureKeys(9)=Gamepad_LeftStick_Up
	CaptureKeys(10)=Gamepad_LeftStick_Down
	CaptureKeys(11)=Gamepad_LeftStick_Right
	CaptureKeys(12)=Gamepad_LeftStick_Left

	bCloseOnLevelChange=true

	WidgetBindings.Add((WidgetName=MenuHeader,WidgetClass=class'GearGame.UIWidget_MenuHeader'))
	WidgetBindings.Add((WidgetName=CustomMap,WidgetClass=class'GearGame.UIWidget_MPCustomMap'))
	WidgetBindings.Add((WidgetName=MapVote1,WidgetClass=class'GearGame.UIWidget_MapVoteControl'))
	WidgetBindings.Add((WidgetName=MapVote2,WidgetClass=class'GearGame.UIWidget_MapVoteControl'))
	WidgetBindings.Add((WidgetName=PlayerLoadoutSingle,WidgetClass=class'GearGame.UIWidget_MPLoadoutControl'))
	WidgetBindings.Add((WidgetName=PlayerLoadout1,WidgetClass=class'GearGame.UIWidget_MPLoadoutControl'))
	WidgetBindings.Add((WidgetName=PlayerLoadout2,WidgetClass=class'GearGame.UIWidget_MPLoadoutControl'))
	WidgetBindings.Add((WidgetName=GamePreview,WidgetClass=class'GearGame.UIWidget_MPGamePreview'))
	WidgetBindings.Add((WidgetName="mc_SmallPPanelContainer",WidgetClass=class'UIWidget_SmallPartyPanel'))

	OnPostAdvance=UpdatePregameLobby

	GametypeDescriptions(eGEARMP_Warzone)=(SettingId=(CONTEXT_ROUNDTIME, CONTEXT_ROUNDSTOWIN))
	GametypeDescriptions(eGEARMP_Execution)=(SettingId=(CONTEXT_ROUNDTIME, CONTEXT_ROUNDSTOWIN))
	GametypeDescriptions(eGEARMP_Horde)=(SettingId=(CONTEXT_ENEMYDIFFICULTY, CONTEXT_HORDE_WAVE))
	GametypeDescriptions(eGEARMP_Wingman)=(SettingId=(CONTEXT_ROUNDTIME, CONTEXT_ROUNDSTOWIN, CONTEXT_WINGMAN_SCOREGOAL))
	GametypeDescriptions(eGEARMP_KOTH)=(SettingId=(CONTEXT_ROUNDSTOWIN, CONTEXT_ROUNDSCORE_KOTH))
	GametypeDescriptions(eGEARMP_CTL)=(SettingId=(CONTEXT_ROUNDSTOWIN))
	GametypeDescriptions(eGEARMP_Newbie)=(SettingId=(CONTEXT_ROUNDSTOWIN, CONTEXT_ROUNDSCORE_NEWB))
	GametypeDescriptions(eGEARMP_Siege)=(SettingId=(CONTEXT_SIEGE_ENEMYDIFFICULTY, CONTEXT_SIEGE_WAVE))
}
