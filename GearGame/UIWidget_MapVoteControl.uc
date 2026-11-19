/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MapVoteControl.uc
 * 
 * Supporting class for the map voting widget in the pregame lobby.  Corresponds with the ActionScript class gears.controls.MapVoteControl
 */

class UIWidget_MapVoteControl extends GFxClikWidget;

/** Maximum number of options supported by the voting widget */
const MAX_MAP_VOTING_OPTIONS = 3;

/** Stores a reference to the elements of the data provider corresponding to each map voting option to allow for quick updating without reallocating */
var transient private GFxObject OptionDataProviderEntry[MAX_MAP_VOTING_OPTIONS];

/** Structure representing a single map voting option */
struct MapVoteInfo
{
	/** A string containing the game type and the map name */
	var string  OptionInfo;
	/** The number of votes that the option has in total */
	var int     VoteCount;
	/** A path to a texture with a screenshot of the map */
	var string  MapShot;
	/** The x-coordinate pixel offset for the image within the mask. */
	var int XOffset;
	/** The y-coordinate pixel offset for the image within the mask. */
	var int YOffset;
};

/** The player controller that is driving this widget */
var transient GearPC OwningPC;

/** Cache of the pregamegri */
var transient GearPreGameGRI PreGameGRI;

/** Callback prototype to define the callbacks for when characters and weapons change, so we can update the profile. */
private delegate SelectionUpdated(int NewId);

/**
 *	Called when the widget is first initialized so we can prepare it for voting
 *
 *	@param	PC - The GearPC of the player who interacts with this control
 */
function Initialize(GearPC PC)
{
	local GearPRI PRI;
	local WorldInfo WI;

	// Cache the player controller
	OwningPC = PC;

	// Cache the GRI
	WI = class'WorldInfo'.static.GetWorldInfo();
	PreGameGRI = GearPreGameGRI(WI.GRI);


	// Set the name of this player to the widget header
	PRI = GearPRI(OwningPC.PlayerReplicationInfo);
	if (PRI != None)
	{
		SetPlayerName(PRI.PlayerName);
	}

	// Build the info array that will feed the voting data to the UI
	BuildMapVotingChoices();

	// Set up the callback to be fired off when the player chooses a map
	SetMapVoteSelectedCallback(MapVoteSelected);
}

/**
 * Handles the player's map vote selection
 * 
 * @param   SelectedIndex   Index of the game / map combo that the player selected
 */
function MapVoteSelected(int SelectedIndex)
{
	local GearPreGameLobbyPRI PRI;

	PRI = GearPreGameLobbyPRI(OwningPC.PlayerReplicationInfo);

	// only allow a vote if this player has not yet voted
	if ( PRI != None && !PRI.bSubmittedGameVote )
	{
		PRI.SubmitGameVote( SelectedIndex );
		if (PRI.bSubmittedGameVote)
		{
			`log("Player submitted a vote: " $ SelectedIndex);
		}
	}
}

/**
 *  Sets the player name of the player that is associated with this map vote widget
 * 
 *  @param  PlayerName  Name of the player to be displayed
 */
function SetPlayerName( string PlayerName )
{
	SetString("PlayerNameText", PlayerName);
}

/** Build the info array that will feed the voting data to the UI */
function BuildMapVotingChoices()
{
	local array<MapVoteInfo> VotingOptions;
	local int VoteIdx;
	local GearGameInfoSummary GameSummary;
	local GearGameMapSummary MapSummary;
	local OnlineGameSettings CurrentSettings;
	local int SettingValue;
	local EGearVersusMatchType MatchMode;
	local OnlineSubsystem OnlineSub;

	// Figure out which match mode this is
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		CurrentSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (CurrentSettings != None)
		{
			CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, SettingValue);
		}
	}
	// Convert to enum
	MatchMode = EGearVersusMatchType(SettingValue);

	// Determine how many maps we will vote on
	 VotingOptions.Length = Min(PreGameGRI.NumSupportedMaps, MAX_MAP_VOTING_OPTIONS);


	// Loop through the options and fill them in
	for (VoteIdx = 0; VoteIdx < VotingOptions.Length; VoteIdx++)
	{
		switch (VoteIdx)
		{
			case 0:
				GameSummary = class'GearUIDataStore_GameResource'.static.GetGameSummaryFromProviderIndex(PreGameGRI.FirstGameIndex, MatchMode);
				MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(PreGameGRI.FirstMapName);
				VotingOptions[VoteIdx].VoteCount = PreGameGRI.FirstGameVoteCount;
				break;
			case 1:
				GameSummary = class'GearUIDataStore_GameResource'.static.GetGameSummaryFromProviderIndex(PreGameGRI.SecondGameIndex, MatchMode);
				MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(PreGameGRI.SecondMapName);
				VotingOptions[VoteIdx].VoteCount = PreGameGRI.SecondGameVoteCount;
				break;
			case 2:
				GameSummary = class'GearUIDataStore_GameResource'.static.GetGameSummaryFromProviderIndex(PreGameGRI.ThirdGameIndex, MatchMode);
				MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(PreGameGRI.ThirdMapName);
				VotingOptions[VoteIdx].VoteCount = PreGameGRI.ThirdGameVoteCount;
				break;
		}
		
		VotingOptions[VoteIdx].MapShot = "img://" $ MapSummary.ScreenshotPathName;
		VotingOptions[VoteIdx].OptionInfo = GameSummary.GameName $ " / " $ MapSummary.DisplayName;
		VotingOptions[VoteIdx].XOffset = MapSummary.XOffset;
		VotingOptions[VoteIdx].YOffset = MapSummary.YOffset;
	}

	// Set the options
	SetMapVoteChoices(VotingOptions);
}

/**
 *  Sets the options for the map / gametype choice, including a screenshot reference for the potential maps
 *  
 *  @param  Options Array of options, one for each voting option
 */
function SetMapVoteChoices(array<MapVoteInfo> Options)
{
	local GFxObject DataProvider;
	local int VoteIdx;
	local GFxObject MapVoteList;

	// Sanity check:  make sure we only have three options, log out if not
	if( Options.Length > MAX_MAP_VOTING_OPTIONS )
	{
		`log("Warning - Too many options specified for map voting widget...only the first " $ MAX_MAP_VOTING_OPTIONS $ " will be used.",, 'GearsUI');
	}

	// Iterate over the number of options, and populate the dataprovider array with the information
	DataProvider = CreateArray();
	for (VoteIdx = 0; VoteIdx < Options.Length; VoteIdx++)
	{
		OptionDataProviderEntry[VoteIdx] = CreateObject("Object");
		OptionDataProviderEntry[VoteIdx].SetString("GameInfo", Options[VoteIdx].OptionInfo);
		OptionDataProviderEntry[VoteIdx].SetString("VoteCount", string(Options[VoteIdx].VoteCount));
		OptionDataProviderEntry[VoteIdx].SetString("MapImageMarkup", Options[VoteIdx].MapShot);
		OptionDataProviderEntry[VoteIdx].SetFloat("XOffset", Options[VoteIdx].XOffset);
		OptionDataProviderEntry[VoteIdx].SetFloat("YOffset", Options[VoteIdx].YOffset);

		DataProvider.SetElementObject(VoteIdx, OptionDataProviderEntry[VoteIdx]);
	}

	MapVoteList = GetObject("MapVoteList");
	// Set the list's dataprovider to the one we just filled out.  This forces a refresh of the list	
	MapVoteList.SetObject("dataProvider", DataProvider);
	// Set the selectedIndex to ensure that the map image is updated immediately.
	MapVoteList.SetFloat("selectedIndex", 0);
}

/**
 * Updates the vote count for a given index, based on things like new data from the server
 * 
 * @param   Index       The index of the option to change the votecount for
 * @param   NewCount    The value to set the count to
 */
function UpdateVoteCount(int Index, int NewCount)
{
	if( Index < MAX_MAP_VOTING_OPTIONS )
	{
		OptionDataProviderEntry[Index].SetString( "VoteCount", string(NewCount) );
	}
}

/**
 * Sets an ActionScript function hook so we can handle the player changing their primary weapon selection
 * 
 * @param   Callback    Function that will handle changing the primary weapon in the profile 
 */
function SetMapVoteSelectedCallback(delegate<SelectionUpdated> Callback)
{
	ActionScriptSetFunction("Callback_OnMapVoteSelected");
}


defaultproperties
{
}
