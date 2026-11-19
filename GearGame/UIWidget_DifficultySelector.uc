/**
 * Widget for the difficulty selector in the Difficulty scene
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIWidget_DifficultySelector extends GFxObject
	Config(UI);

/** References to the gfx objects */

/** Reference to the list of difficulties */
var GFxObject DifficultyList;

var GFxObject GamerTagLabel;
var GFxObject ControllerIconLabel;


/** The gearpc that controls this widget */
var GearPC  OwningPlayer;

var localized array<string> DifficultyNames;
var localized array<string> DifficultyTips;

/** Difficulty pic paths */
var config array<string> DifficultyPicPaths;

/** 
 *  Initialization callback for widgets in the scene
 *  
 *  @param WidgetName - Name of the widget
 *  @param WidgetPath - Path of the widget
 *  @param Widget - The widget itself
 *  
 *  @return Whether or not this function has handled the callback
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{	
	local string TempString;

	`log("DifficultySelector WidgetInitialized: "$WidgetName,,'GearsUI');
	switch(WidgetName)
	{   
		//The list of difficulties
		case ('difficultyList'):
			DifficultyList = Widget;
			PopulateDifficultyList();
			break;
		//The player's gamertag
		case 'lblGamerTag':
			TempString = "NO PLAYER";
			if (OwningPlayer != none)
			{
				TempString = OwningPlayer.PlayerReplicationInfo.PlayerName;
			}
			Widget.SetString("htmlText",TempString);
			break;
		//The controller icon
		case 'lblControllerIcon':
			TempString = "";
			if (OwningPlayer != none)
			{
				TempString = class'GearGFxMoviePlayer'.static.GetControllerIcon(LocalPlayer(OwningPlayer.Player).ControllerId);
			}
			Widget.SetString("htmlText",TempString);
			break;
		default:
			`log("Unhandled widget in UIWidget_DifficultySelector: " @ WidgetPath,, 'GearsUI');
			return false;
	}

	return true;
}

/** 
 *  Initialization function called after all widgets have been initialized
 *  Constructs all of the menu data, sets the localization, and tells gfx to initialize itself off of that data
 */
function SubPostWidgetInit()
{
}

/**
 * Populate the given DifficultyList
 */
function PopulateDifficultyList()
{
	local int i;
	local GFxObject Obj, DataProvider;
	local int DifficultyIndex;

	if (OwningPlayer != none)
	{
		//Get the difficulty from the profile
		OwningPlayer.ProfileSettings.GetProfileSettingValueId(`GameIntensity,DifficultyIndex);
	}

	DataProvider = CreateArray();

	for (i = 0; i < 4; i++)
	{
		// Set the appropriate values on the option's object
		Obj = CreateObject("Object");
		Obj.SetString("label", DifficultyNames[i]);
		Obj.SetString("toolTip", DifficultyTips[i]);
		Obj.SetString("image", "img://"$DifficultyPicPaths[i]);
		Obj.SetFloat("numSelected", 0);

		//if this is for the primary host player, don't do anything!
		if (OwningPlayer != none && 
			OwningPlayer.Role == ROLE_Authority && 
			class'Engine'.static.GetEngine().GamePlayers[0] == OwningPlayer.Player)
		{
			Obj.SetBool("bIsChosen",false);
		}
		else 
		{
			//Otherwise if this is the selected difficulty, choose this one!
			if (i == DifficultyIndex)
			{
				//TODO: Need to mark this as chosen in the pri so other players know
				Obj.SetBool("bIsChosen",true);
			}
			else //It's not the selected difficulty
			{
				Obj.SetBool("bIsChosen",false);
			}
		}
		//TODO: handle locking insane
		Obj.SetBool("bIsLocked",false);
		// Set the element into the dataProvider
		DataProvider.SetElementObject(i, Obj);
	}

	// Set the data provider to generate the menu
	DifficultyList.SetObject("dataProvider", DataProvider);
	DifficultyList.SetFloat("selectedIndex",DifficultyIndex);
}


/**
 * Function called to update the list with the number of players who have selected each difficulty
 * 
 * @param NumPlayersSelected - Array of how many players have selected each difficulty
 * 
 * @return whether or not anything has changed from last time
 */
function bool UpdateNumPlayersSelected(array<int> NumPlayersSelected)
{
	local GFxObject DataProvider;
	local array<ASValue> args;
	local int i;
	local bool bNeedsToUpdate;

	DataProvider = DifficultyList.GetObject("dataProvider");

	for (i = 0; i<NumPlayersSelected.Length; i++)
	{
		if (DataProvider.GetElementMemberFloat(i,"numSelected") != NumPlayersSelected[i])
		{
			DataProvider.SetElementMemberFloat(i,"numSelected",NumPlayersSelected[i]);
			bNeedsToUpdate = true;
		}
	}
	
	if (bNeedsToUpdate)
	{
		args.Length = 0;
		DifficultyList.Invoke("invalidateData",args);
	}

	return bNeedsToUpdate;
}

defaultproperties
{
}
