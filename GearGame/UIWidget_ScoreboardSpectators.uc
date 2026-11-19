/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIWidget_ScoreboardSpectators extends GFxObject;

// --- Scene Widgets ---------------------------------

/** Reference to the title of the specator list */
var transient GFxObject     ListTitle;

/** Reference to the actual list of spectators, which we publish a list of spectators to */
var transient GFxObject     SpectatorList;

// --- Misc. Variables -------------------------------

/** Data provider that contains a list of players in it, so we don't have to reallocate it all the time */
var transient GFxObject DataProvider;

/** TRUE if the spectator list is visible (has more than one spectator), FALSE if not */
var transient bool  bIsVisible;

/** List of the current PRI entries */
var transient string    PlayerNames[10];

/** Cache of references to the elements in the data provider */
var transient GFxObject ListEntries[10];

/** Number of spectators we have */
var transient int       SpectatorCount;


// --- Localized Strings -----------------------------
var localized string    OneSpectatorLabel;
var localized string    MultipleSpectatorsLabel;

/**
 * Widget Initialized handlers
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch( WidgetName )
	{
		case 'lbl_WaitingToSpawn':
			ListTitle = Widget;
			break;
		case 'JoinInProgressList':
			SpectatorList = Widget;
			CreateListDataProvider();
			break;
		default:
			return FALSE;
	}
	return TRUE;
}

/**
 * Creates a list data provider
 */
function CreateListDataProvider()
{
	local int i;

	// If we have no data provider, add one here
	if( DataProvider == None )
	{
		DataProvider = CreateArray();
		for( i = 0; i < 10; i++ )
		{
			ListEntries[i] = CreateObject("Object");
			DataProvider.SetElementObject(i, ListEntries[i]);
		}

		SpectatorList.SetObject("dataProvider", DataProvider);
	}
}

/**
 * Main update function that updates the list if necessary, and populates the list
 */
function UpdateSpectatorList(GearGRI GRI)
{
	local int i, TmpSpectatorCount;
	local GearPRI CurrentPRI;
	local bool bNeedsRefresh;

 	TmpSpectatorCount = 0;
 	for( i = 0; i < GRI.PRIArray.Length; i++ )
	{
 		CurrentPRI = GearPRI(GRI.PRIArray[i]);
 
 		// If this person is a spectator...
 		if( (CurrentPRI != None) && (CurrentPRI.Team == None || CurrentPRI.Team.TeamIndex == 255) )
 		{
 			// See if this person is the same as last time, and update if necessary
 			if( PlayerNames[TmpSpectatorCount] != CurrentPRI.PlayerName )
 			{
 				PlayerNames[TmpSpectatorCount] = CurrentPRI.PlayerName;
 				bNeedsRefresh = TRUE;
 			}
 
 			TmpSpectatorCount++;
 
 			// We can only handle 10 spectators, dump the rest
 			if( SpectatorCount >= 10 )
 			{
 				break;
 			}
 		}
 	}

	// See if we've had a change in the number of spectators
	if( TmpSpectatorCount != SpectatorCount )
	{
		SpectatorCount = TmpSpectatorCount;
		
		// Clear the remaining entries
		for( i = SpectatorCount; i < 10; i++ )
		{
			PlayerNames[i] = "";
		}

		// Update the label
		ListTitle.SetString("htmlText", SpectatorCount @ (SpectatorCount == 1 ? OneSpectatorLabel : MultipleSpectatorsLabel));

		bNeedsRefresh = TRUE;
	}

	// Refresh the data provider if necessary
	if( bNeedsRefresh )
	{
		for( i = 0; i < 10; i++ )
		{
			ListEntries[i].SetString("label", PlayerNames[i]);
		}

		RefreshList();
	}

	// Show the spectator screen if there's more than one person joining
	ShowSpectatorScreen( SpectatorCount > 0 );
}

/**
 * Shows or hides the spectator screen if needed
 * 
 * @param   bNewShow    TRUE if we should show the spectator screen, FALSE otherwise
 */
function ShowSpectatorScreen(bool bNewShow)
{
	if( bNewShow != bIsVisible )
	{
		GotoAndPlay( bNewShow ? "on" : "off" );
		bIsVisible = bNewShow;
	}
}

/**
 * Forces a refresh of the list, which will update its contents
 */
function RefreshList()
{
	SpectatorList.ActionScriptVoid("invalidateData");
}

defaultproperties
{
}
