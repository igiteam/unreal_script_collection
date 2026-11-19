/**
 * Class that manages the UI for the game
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearUIManager extends UIManager
	within GearUIInteraction
	dependson(UIScene_MessageBox)
	config(UI);
	
/** Hard reference to the Updating scene used for blocking input */
var transient class<UIScene_Busy> UpdatingSceneClass;

/** Reference to the updating scene itself if it is open */
var transient UIScene_Busy UpdatingScene;

/** Hard reference to the Updating scene used for blocking input */
var transient class<UIScene_Checkpoint> CheckpointUpdatingSceneClass;

/** Reference to the updating scene itself if it is open */
var transient UIScene_Checkpoint CheckpointScene;



//==========GFx Messagebox===========
/** List of open messageboxes to handle duplication */
var array<UIScene_MessageBox> OpenMessageBoxes;

/** The class to use for displaying message boxes. */
var transient class<UIScene_MessageBox> MessageBoxClass;

//==========Main Menu History==============
//Element in the MainMenuHistory array.
struct MMHistoryItem
{
	//The screen a selection was made on
	var byte Screen;
	//The index into the selected options
	var byte SelectedOption;
};

//List of all selections made
var MMHistoryItem MainMenuHistory[`MAX_HISTORY_LENGTH];
//Length of the history in the history array
var byte MainMenuHistoryLength;
//Last Selection
var byte LastSelectedIndex;


/** A struct representing one change in menu flow */
struct MMFlowModification
{
	var byte BaseScreen;
	var byte SelectionIdx;
	var byte ModifiedNext;
};
/** Array of all flow modifications */
var MMFlowModification MainMenuFlowMods[`MAX_FLOWMOD_LENGTH];
/** Amount of flow mods in existance atm */
var byte MainMenuFlowModLength;

/** Representation of a disabled (or undisabled) item */
struct MMDisabledItem
{
	//The screen
	var byte Screen;
	//The index into the selected options
	var byte SelectionIdx;
	//Whether or not it is disabled
	var bool bIsDisabled;
};
/**Array of all disabled items */
var MMDisabledItem MainMenuDisabled[`MAX_DISABLED_LENGTH];
/** Amount of disabled items */
var byte MainMenuDisabledLength;

/** Representation of a removed item */
struct MMRemovedItem
{
	//The screen
	var byte Screen;
	//The index of the option to be removed
	var byte SelectionIdx;
	//Whether or not this is the removal or the undo of a removal
	var bool bIsUndone;
};
/**Array of all disabled items */
var MMRemovedItem MainMenuRemoved[`MAX_REMOVED_LENGTH];
/** Amount of removed items */
var byte MainMenuRemovedLength;

/** Representation of a save slot */
struct MMSaveSlotData
{
	var bool bIsCorrupted;
	var bool bContainsData;
	var EDifficultyLevel Difficulty;
	var byte ChapterNum;
	var int Day;
	var int Month;
	var int Year;
	var int SecondsSinceMidnight;
};
/** Array of all of the save slot datums */
var MMSaveSlotData SaveSlotData[`NUM_SAVE_SLOTS];

/** How long to leave the speaker icon after a player has stopped talking */
var const float ChatIconHoldTime;

/** How long it takes to fade out the speaker icon after a player has stopped talking */
var const float ChatIconFadeTime;

//What acts and chapters have been unlocked
var int CompletedChaptersCasual[`NUM_CHAPTER_BITFIELD_INTS];
var int CompletedChaptersNormal[`NUM_CHAPTER_BITFIELD_INTS];
var int CompletedChaptersHard[`NUM_CHAPTER_BITFIELD_INTS];
var int CompletedChaptersInsane[`NUM_CHAPTER_BITFIELD_INTS];
var int UnlockedChapters[`NUM_CHAPTER_BITFIELD_INTS];


/*==================================================================================
 * Functions
 *=================================================================================*/


/**
 * Opens a generic scene that blocks input until StopUpdate is called and the scene closes
 */
static function OpenUpdatingScene(optional string WaitingString = "", optional string ExplanationString = "", optional bool bIsCheckpoint)
{
	local GearUIManager Manager;
	local UIScene_Busy Retval;

	Manager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( Manager != None )
	{
		if (bIsCheckpoint)
		{
			Retval = Manager.CheckpointScene;
		}
		else
		{
			Retval = Manager.UpdatingScene;
		}
		if (Retval == none)
		{
			// Open a new instance
			if (bIsCheckpoint)
			{
				Retval = new(class'Engine'.static.GetEngine().GamePlayers[0]) default.CheckpointUpdatingSceneClass;
			}
			else
			{
				Retval = new(class'Engine'.static.GetEngine().GamePlayers[0]) default.UpdatingSceneClass;
			}
			if ( Retval != None )
			{
				if (WaitingString != "")
				{
					Retval.WaitingString = WaitingString;
				}
				if (ExplanationString != "")
				{
					Retval.ExplanationString = ExplanationString;
				}

				Retval.Init(class'Engine'.static.GetEngine().GamePlayers[0]);
				
				if (bIsCheckpoint)
				{
					Manager.CheckpointScene = UIScene_Checkpoint(Retval);
				}
				else
				{
					Manager.UpdatingScene = Retval;
				}
			}
		}
	}
}


/** Closes the generic scene that blocks input from OpenUpdatingScene */
static function CloseUpdatingScene( optional bool bIsCheckpoint )
{
	local GearUIManager Manager;

	Manager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (Manager != None)
	{
		if (bIsCheckpoint)
		{
			if (Manager.CheckpointScene != none)
			{
				Manager.CheckpointScene.CloseWaitScreen();
			}
		}
		else
		{
			if (Manager.UpdatingScene != none)
			{
				Manager.UpdatingScene.CloseWaitScreen();
			}
		}
	}
}

/*
 * Called from the scene itself when it is closing to inform the UISceneClient to null it's references
 */
function UpdatingSceneClosed(UIScene_Busy ClosedScene)
{
	if (ClosedScene == UpdatingScene)
	{
		UpdatingScene = None;
	}
	if (ClosedScene == CheckpointScene)
	{
		CheckpointScene = None;
	}
}

/**
 * Handler for the OnOptionSelected delegate of the "too many profiles signed-in" error message.  Only allows the message box to be closed
 * if the number of signed in players is <= MAX_SPLITSCREEN_PLAYERS.
 *
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnTooManyProfilesErrorAccepted( UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex )
{
	if ( class'UIInteraction'.static.GetLoggedInPlayerCount() <= `MAX_SPLITSCREEN_PLAYERS )
	{
		return true;
	}

	//PlayUISound('GenericError');
	return false;
}

/**
 * Called when a new player has been added to the list of active players (i.e. split-screen join)
 *
 * @param	PlayerIndex		the index [into the GamePlayers array] where the player was inserted
 * @param	AddedPlayer		the player that was added
 */
function NotifyPlayerAdded( int PlayerIndex, LocalPlayer AddedPlayer )
{
	super.NotifyPlayerAdded(PlayerIndex, AddedPlayer);
	RefreshPlayerDeadZone();
}

/**
 * Called when a player has been removed from the list of active players (i.e. split-screen players)
 *
 * @param	PlayerIndex		the index [into the GamePlayers array] where the player was located
 * @param	RemovedPlayer	the player that was removed
 */
function NotifyPlayerRemoved( int PlayerIndex, LocalPlayer RemovedPlayer )
{
	local LocalPlayer PrimaryPlayer;
	local GearPC PCOwner;

	super.NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);

	if ( PlayerIndex == `PRIMARY_PLAYER_INDEX )
	{
		PrimaryPlayer =class'UIInteraction'.static.GetLocalPlayer(`PRIMARY_PLAYER_INDEX);
		if ( PrimaryPlayer != None && PrimaryPlayer != RemovedPlayer )
		{
			// a new player is the primary player so tell them to reload their profile settings as there are some global settings that
			// are only taken from the primary player's profile.
			PCOwner = GearPC(PrimaryPlayer.Actor);
			PCOwner.bProfileSettingsUpdated = true;
		}
	}

	RefreshPlayerDeadZone();
}

/**
*  Called when local player has been added or removed
*  Refresh DeadZone for all players
*/
function RefreshPlayerDeadZone()
{
	local int Idx, NumPlayers;
	local GearPC PC;

	NumPlayers = class'UIInteraction'.static.GetPlayerCount();
	for ( Idx = 0; Idx < NumPlayers; Idx++ )
	{
		PC = GearPC(class'UIInteraction'.static.GetLocalPlayer(Idx).Actor);
		if ( PC != None && PC.MyGearHUD != None )
		{
			PC.MyGearHUD.bRefreshSafeZone = true;
		}
	}
}

/**
 * Displays a message box using the default message box class.
 *
 * @param	SceneTag			the name to use for the message box scene.  useful for e.g. preventing multiple copies of the same message from appearing.
 * @param	Title				the string or datastore markup to use as the message box title
 * @param	Body				the string or datastore markup to use for the message box text
 * @param	ButtonAliases		the list of aliases to use in the message box's button bar; this determines which options are available as well
 *								as which input keys the message box responds to.  Aliases must be registered in the Engine.UIDataStore_InputAlias
 *								section of the input .ini file.
 * @param	SelectionCallback	the function to call when the user selects an option
 * @param	LocalPlayerOwner	the local player to associate the message box with.  only this player will be able to dismiss the message box.
 * @param	out_CreatedBox  	allows the caller to receive a reference to the scene that was opened. 
 * @param	Priority    		allows the player to override the message box class's default scene priority. 0 means to use the default priority.
 * @param   bCloseOnLevelChange Whether or not this message box should be automatically dismissed upon a level change. Defaults to TRUE
 *
 * @return	TRUE if the message box was successfully shown.
 */
static function bool ShowUIMessage( name SceneTag, string Title, string Body, array<name> ButtonAliases, optional delegate<UIScene_MessageBox.OnOptionSelected> SelectionCallback=None, optional LocalPlayer LocalPlayerOwner, optional out UIScene_MessageBox out_CreatedBox, optional byte Priority=0, optional bool bPauseGameWhileActive, optional bool bOnlyOwnerFocusable=true, optional bool bCloseOnLevelChange=true)
{
	local UIScene_MessageBox MessageBox;
	local GearUIManager Manager;
	local bool bResult;
	local int i;
	local string ButtonAliasString;

	local DataStoreClient DSClient;
	local UIDataStore_InputAlias InputAliasDS;

	DSClient = class'UIInteraction'.static.GetDataStoreClient();
	if ( DSClient != None )
	{
		InputAliasDS = UIDataStore_InputAlias(DSClient.FindDataStore('ButtonCallouts'));
	}
	if (InputAliasDS == none)
	{
		`log("Unable to access Input Alias DataStore");
		return false;
	}

	Manager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( Manager != None )
	{
		// see if there is already a message box with the specified tag
		for (i =0; i < Manager.OpenMessageBoxes.Length; i++)
		{
			if (Manager.OpenMessageBoxes[i].MessageName == SceneTag &&
				Manager.OpenMessageBoxes[i].LocalPlayerOwnerIndex == Manager.FindLocalPlayerIndex(LocalPlayerOwner))
			{
				MessageBox = Manager.OpenMessageBoxes[i];
				break;
			}
		}
		//If one does not already exist
		if ( MessageBox == None )
		{
			//Make one
			MessageBox = new(Manager) default.MessageBoxClass;
			if ( MessageBox != None )
			{
				MessageBox.MessageName = SceneTag;
				//Set the strings
				MessageBox.TitleString = Title;
				MessageBox.BodyString = Body;
				
				if (ButtonAliases.Length > 0)
				{
					MessageBox.ContinueInputAlias = ButtonAliases[0];
					ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[0]);
					MessageBox.ContinueString = ButtonAliasString;
				}

				if (ButtonAliases.Length > 1)
				{
					MessageBox.CancelInputAlias = ButtonAliases[1];
					ButtonAliasString = InputAliasDS.GetAliasFontMarkup(ButtonAliases[1]);
					MessageBox.CancelString = ButtonAliasString;
				}

				if (SelectionCallback != none)
				{
					MessageBox.OnOptionSelected = SelectionCallback;
				}
				
				if (Priority != 0)
				{
					MessageBox.SetPriority(Priority);
				}
		
				//If this scene pauses the game, set it up!
				if (bPauseGameWhileActive)
				{
					MessageBox.bPauseGameWhileActive = bPauseGameWhileActive;
					Manager.PauseGame( bPauseGameWhileActive, Manager.FindLocalPlayerIndex(LocalPlayerOwner) );
				}

				MessageBox.bOnlyOwnerFocusable = bOnlyOwnerFocusable;
				MessageBox.bCloseOnLevelChange = bCloseOnLevelChange;

				//Start it up
				MessageBox.Init(LocalPlayerOwner);
				//Save a reference so it doesn't get GC'd
				Manager.OpenMessageBoxes.AddItem(MessageBox);
				//Pass it out to the caller
				out_CreatedBox = MessageBox;

				bResult = true;
			}
		}
	}

	return bResult;
}

/**
 * Closes a message box opened with ShowUIMessage.
 *
 * @param	SceneTag			the name of the scene to close; should be the same value passed for SceneTag to ShowUIMessage
 * @param	LocalPlayerOwner	the player associated with the message box
 *
 * @return	TRUE if the scene was successfully closed.
 */
static final function bool ClearUIMessage( name SceneTag, optional LocalPlayer LocalPlayerOwner, optional bool bCloseChildScenes=false, optional byte ForcedPriority )
{
	local GearUIManager Manager;
	local bool bResult;
	local int i;

	Manager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( Manager != None )
	{
		// see if there is already a message box with the specified tag
		for (i =0; i < Manager.OpenMessageBoxes.Length; i++)
		{
			if (Manager.OpenMessageBoxes[i].MessageName == SceneTag && //Tag must match
				(LocalPlayerOwner == none || //if we pass in none, then we don't care, close it!
				Manager.OpenMessageBoxes[i].LocalPlayerOwnerIndex == INDEX_NONE || //or if the scene doesnt have an owner, than anyone can close it!
				Manager.OpenMessageBoxes[i].GetLP() == LocalPlayerOwner) ) //Otherwise only the matching player can close it
			{
				Manager.OpenMessageBoxes[i].StartExit();
				//Manager.OpenMessageBoxes[i].Close();
				bResult = true;
				break;
			}
		}
	}

	return bResult;
}

/**
 * Closes all Messageboxes for a specified LocalPlayer
 * @param LP - The LocalPlayer to close all messageboxes for. If none, it will close all of them
 */
static final function CloseAllUIMessageBoxes(optional LocalPlayer LP)
{
	local int i;
	local GearUIManager Manager;

	Manager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( Manager != None )
	{
		i = 0;
		//While there are open messageboxes and we haven't looked at all of them
		while(i < Manager.OpenMessageBoxes.Length)
		{
			//if we want to close this messagebox, then do not update the index
			if (LP == none || LP == Manager.OpenMessageBoxes[i].GetLP())
			{
				Manager.OpenMessageBoxes[i].Close();				
			}
			else //update the index and skip past it
			{
				i++;
			}
		}
	}
}

/**
 * Function to clean up the reference to a messagebox in the OpenMessageBoxes array
 * Called by the messagebox itself when it closes
 * 
 * @param MessageBox - the message box object you want to remove references to
 */
static final function RemoveUIMessageReference(UIScene_MessageBox MessageBox)
{
	local GearUIManager Manager;

	Manager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( Manager != None )
	{
		// Remove any messagebox matching the one you passed in
		Manager.OpenMessageBoxes.RemoveItem(MessageBox);
	}
}

/**
 * Wrapper for displaying a message box containing an error message.
 *
 * @param	MessageKey				a key from the MessageBoxStrings section of the GearGameUI.int to use for the message text.
 * @param	TitleKey				a key from the MessageBoxErrorStrings section of the GearGameUI.int to use as the message title.  If not
 *									specified, the generic error string will be used.
 * @param	ButtonAliasString		a comma-delimited string containing the buttonbar aliases to use in the message box.  The order of the
 *									button aliases should be in reverse order (i.e. the button that should be farthest right should be first)
 * @param	OwningPlayer			the player to associate with the message box (makes it so that the message box can only be dismissed by that
 *									player
 * @param	SelectionCallback		specifies the function that should be called when the player selects an option.
 * @param	bClearExistingMessages	specify TRUE to close all existing message boxes before displaying this error
 */
static final function UIScene_MessageBox DisplayErrorMessage( string MessageKey,
				optional string TitleKey, optional string ButtonAliasString, optional LocalPlayer OwningPlayer,
				optional delegate<UIScene_MessageBox.OnOptionSelected> SelectionCallback=None, 
				optional bool bClearExistingMessages, optional byte ForcedScenePriority )
{
	local int i;
	local name ErrorSceneTag;
	local array<name> ButtonAliases;
	local array<string> ButtonAliasStringArray;
	local UIScene_MessageBox ErrorMessageScene;

	ButtonAliasStringArray = SplitString(ButtonAliasString);
	for ( i = 0; i < ButtonAliasStringArray.Length; i++ )
	{
		ButtonAliases[i] = name(ButtonAliasStringArray[i]);
	}

	if ( TitleKey == "" )
	{
		TitleKey = "ErrorTitle";
		ErrorSceneTag = 'ErrorMessage';
	}
	else
	{
		ErrorSceneTag = name(TitleKey);
	}

	class'GearUIManager'.static.ShowUIMessage(ErrorSceneTag, 
		Localize("MessageBoxErrorStrings",TitleKey,"GearGameUI"),
		Localize("MessageBoxErrorStrings",MessageKey,"GearGameUI"),
		ButtonAliases, SelectionCallback, OwningPlayer, ErrorMessageScene,  ForcedScenePriority);

	if ( ErrorMessageScene != None )
	{
		ErrorMessageScene.bCloseOnLevelChange = false;
	}

	return ErrorMessageScene;
}

/**
 * Helper function to deduce the PlayerIndex of a Player
 * 
 * @param P - The LocalPlayer for whom you wish to deduce their PlayerIndex
 * 
 * @return Returns the index into the GamePlayers array that references this Player. If it cannot find the player, it returns 0.
 */
function int FindLocalPlayerIndex(Player P)
{
	local Engine Engine;
	local int i;

	Engine = class'Engine'.static.GetEngine();
	for (i = 0; i < Engine.GamePlayers.length; i++)
	{
		if (Engine.GamePlayers[i] == P)
		{
			return i;
		}
	}
	return 0;
}

`if(`notdefined(ShippingPC))
/**
 * Handler for debug message box OnOptionSelected delegate.
 *
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool DebugMessageOptionSelected( UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex )
{
	`log(`location @ `showobj(Sender) @ `showvar(SelectedInputAlias) @ `showvar(PlayerIndex));
	return true;
}

/**
 * Debug function to just show a messagebox
 * 
 * @param Message - The Body text
 * @param Aliases - The button aliases to use
 * @param Title - The title text to use
 * @param Question - Unused, only here to override the function signature from GameUISceneClient
 */
exec function DebugShowMessage( string Message, string Aliases, string Title, byte Priority, byte LocalPlayerIdx )
{
	local array<string> ButtonAliasStrings;
	local array<name> ButtonAliases;
	local int i;
	local LocalPlayer LP;

	if ( Message != "" )
	{
		ParseStringIntoArray(Aliases, ButtonAliasStrings, ",", true);
		ButtonAliases.Length = ButtonAliasStrings.Length;
		for ( i = 0; i < ButtonAliasStrings.Length; i++ )
		{
			ButtonAliases[i] = name(ButtonAliasStrings[i]);
		}

		LP = class'Engine'.static.GetEngine().GamePlayers[0];
		if (LocalPlayerIdx > 0 && LocalPlayerIdx < class'Engine'.static.GetEngine().GamePlayers.Length)
		{
			LP = class'Engine'.static.GetEngine().GamePlayers[LocalPlayerIdx];
			`log(LP);
		}
		ShowUIMessage(name(Title), Title, Message, ButtonAliases, DebugMessageOptionSelected,LP,, Priority);
//		ShowUIMessage('DebugTestMessage', Title, Message, ButtonAliases, DebugMessageOptionSelected,,, Priority);
	}
}
`endif


//======================================================================================
//======================================================================================
//  STUFF FROM GEARUISCENE_BASE
//======================================================================================
//======================================================================================

/**
 * @return	a reference to the gear-specific static game resource data store.
 */
static final function GearUIDataStore_GameResource GetGameResourceDataStore()
{
	return GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
}

/**
 * @return	a reference to the gear-specific online game settings data store.
 */
static final function GearUIDataStore_GameSettings GetGameSettingsDataStore()
{
	return GearUIDataStore_GameSettings(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag));
}

/**
 * @return	a reference to the dynamic game resource data store.
 */
static final function UIDataStore_DynamicResource GetDynamicResourceDataStore( LocalPlayer OwningPlayer )
{
	return UIDataStore_DynamicResource(StaticResolveDataStore(class'UIDataStore_DynamicResource'.default.Tag, OwningPlayer));
}

/**
 * Wrapper for displaying a movie while the game thread is blocked for loading.  All params are passed through to GearPC.ClientShowLoadingMovie().
 */
static final function ShowLoadingMovie( bool bShowMovie, optional bool bPauseAfterHide, optional float PauseDuration )
{
	local GearPC PC;
	local LocalPlayer LP;

	LP = class'UIInteraction'.static.GetLocalPlayer(`PRIMARY_PLAYER_INDEX);
	if ( LP != None )
	{
		PC = GearPC(LP.Actor);
		if ( PC != None )
		{
			PC.ClientShowLoadingMovie(bShowMovie, bPauseAfterhide, PauseDuration);
		}
		else
		{
			`warn("GearUIManager::ShowLoadingMovie - player is None or not a GearPC!");
		}
	}
	else
	{
		`warn("GearUIManager::ShowLoadingMovie - no valid players!");
	}
}

/**
 * Compute the opacity of the chat icon given whether a player is talking and how long it's been since they last talked
 *
 * @param PlayerPRI - the chatting player
 *
 * @return the opacity value the chat icon should be rendered between 0 and 1
 *
 */
static function float GetChatIconOpacity(GearPRI PlayerPRI)
{
	if (PlayerPRI.bIsTalking || (class'WorldInfo'.static.GetWorldInfo().TimeSeconds - PlayerPRI.LastTalkTime) < default.ChatIconHoldTime)
		return 1.0f;

	return FMax(0.0f, 1.0f - (class'WorldInfo'.static.GetWorldInfo().TimeSeconds - PlayerPRI.LastTalkTime - default.ChatIconHoldTime) / default.ChatIconFadeTime);
}

/** Sets the value of a scene transition data */
static function SetTransitionValue(string VariableName, string NewValue)
{
	local string VarName;

	VarName = "<Registry:" $ VariableName $ ">";
	SetDataStoreStringValue(VarName, NewValue);
}

/**
 * Returns the GearPC associated with the specified player index.
 *
 * @param	PlayerIndex		the index of the player to get a reference to; if not specified, uses the scene's player owner.
 *
 * @return	a ref to the player specified, or None if invalid.
 */
final static function GearPC GetGearPlayerOwner( optional int PlayerIndex=INDEX_NONE )
{
	local LocalPlayer PO;

	if (PlayerIndex < 0 || PlayerIndex >= class'Engine'.static.GetEngine().GamePlayers.Length)
	{
		return none;
	}

	PO = class'Engine'.static.GetEngine().GamePlayers[PlayerIndex];
	if (PO != none)
	{
		return GearPC(PO.Actor);
	}

	return None;
}

/**
 * Get the profile associated with the specified player.
 */
final function GearProfileSettings GetPlayerProfile( optional int PlayerIndex=INDEX_NONE )
{
	local GearProfileSettings Result;
	local GearPC GPC;

	GPC = GetGearPlayerOwner(PlayerIndex);
	if ( GPC != None )
	{
		Result = GPC.ProfileSettings;
	}

	return Result;
}

/** Get the enum value from a string */
static function byte ConvertEnumStringToValue( string EnumString, int MaxEnumValue, Object EnumType )
{
	local int Idx;
	local byte Result;

	if ( EnumType != None )
	{
		if ( EnumType.Class == class'Core.Enum' )
		{
			for ( Idx = 0; Idx < MaxEnumValue; Idx++ )
			{
				if ( EnumString == string(GetEnum(EnumType,Idx)) )
				{
					Result = Idx;
					break;
				}
			}
		}
		else
		{
			`log("ConvertEnumStringToByte - Invalid enum object specified!  Should pass in a literal reference to an enum (i.e. enum'ERemoteRole'):" @ EnumType);
		}
	}
	else
	{
		`log("ConvertEnumStringToByte - Null enum object specified!  Should pass in a literal reference to an enum (i.e. enum'ERemoteRole')");
	}

	return Result;
}

/** Returns the MP game type being played */
static function EGearMPTypes GetMPGameTypeStatic(GearGRI GGRI)
{
	local name ClassName;

	if ( GGRI == None )
	{
		return eGEARMP_Warzone;
	}

	ClassName = GGRI.GameClass.Name;

	if ( ClassName == 'GearGameCTL' )
	{
		return eGEARMP_CTL;
	}
	else if ( ClassName == 'GearGameHorde' )
	{
		return eGEARMP_Horde;
	}
	else if ( ClassName == 'GearGameSiege' || ClassName == 'GearGameSiege_E3' )
	{
		return eGEARMP_Siege;
	}
	else if (ClassName == 'GearGameKOTH')
	{
		return eGEARMP_KOTH;
	}
	else if ( ClassName == 'GearGameWingman' )
	{
		return eGEARMP_Wingman;
	}
	else if (ClassName == 'GearGameTDM_Newb_Content' )
	{
		return eGEARMP_Newbie;
	}
	else
	{
		return (GGRI.bGameIsExecutionRules ? eGEARMP_Execution : eGEARMP_Warzone);
	}
}



DefaultProperties
{
	MessageBoxClass=class'GearGame.UIScene_MessageBox'

	UpdatingSceneClass=class'GearGame.UIScene_Busy'
	CheckpointUpdatingSceneClass=class'GearGame.UIScene_Checkpoint'

	ChatIconHoldTime=0.5f
	ChatIconFadeTime=1.5f
}
