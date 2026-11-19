/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIWidget_ArcadeEOC_PlayerScore extends GFxObject;

/** Player replication info of the player displayed on this scoreboard */
var transient GearPRI_SP        MyPRI;

/** Reference to the scoreboard that owns this player info */
var transient UIScene_EndOfRound_Arcade     OwningScoreboard;

// --- Widget References ---------------------------------------
var transient GFxObject                 lbl_PlayerName;
var transient UIWidget_CachedUILabel    lbl_TotalScore;
var transient GFxObject                 CharacterImageLoader;

var transient GFxObject                 lbl_Description[9];
var transient UIWidget_CachedUILabel    lbl_Stat[9];
var transient GFxObject                 mc_Star[9];

// --- Localized Strings ---------------------------------------
var localized string            StatDescription0;
var localized string            StatDescription1;
var localized string            StatDescription2;
var localized string            StatDescription3;
var localized string            StatDescription4;
var localized string            StatDescription5;
var localized string            StatDescription6;
var localized string            StatDescription7;
var localized string            StatDescription8;

// --- Misc.Variables ------------------------------------------
/** TRUE if the scoreboard initialized callback has been received  */
var transient bool              bInitialized;

/** TRUE if static scoreboard elements have been set (i.e. static values that are not updated by replication */
var transient bool              bInitializedStaticElements;

/** Bitfield with bits corresponding if we currently think we're leading a stat category, and are drawing the high-score star marker and using coloured text */
var transient int               CurrentLeaderBitmask;


//==============================================================
// GFxObject function overrides
//==============================================================

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
	local string WidgetString;
	local int Idx;

	switch( WidgetName )
	{
		case 'lbl_PlayerName':
			lbl_PlayerName = Widget;
			break;
		case 'lbl_TotalScore':
			lbl_TotalScore = UIWidget_CachedUILabel(Widget);
			break;
		case 'CharacterImageLoader':
			CharacterImageLoader = Widget;
			break;
		default:
			WidgetString = string(WidgetName);
			if( InStr(WidgetString, "lbl_Description") != INDEX_NONE )
			{
				Idx = int( Right(WidgetString, 1) );
				lbl_Description[Idx] = Widget;
			}
			else if( InStr(WidgetString, "lbl_Stat") != INDEX_NONE ) 
			{
				Idx = int( Right(WidgetString, 1) );
				lbl_Stat[Idx] = UIWidget_CachedUILabel(Widget);
			}
			else if( InStr(WidgetString, "mc_Star") != INDEX_NONE ) 
			{
				Idx = int( Right(WidgetString, 1) );
				mc_Star[Idx] = Widget;
			}
			else
			{
				return FALSE;
			}
			break;
	}

	return TRUE;
}

/** Stub delegate to use for an initialized callback */
delegate InitializationCallback();

/** 
 *  Sets a callback on this widget to run after the widgets have been initialized
 *  
 *  @param  Callback    The funciton to call when the scoreboard has been initialized
 */
function SetInitializedCallback(delegate<InitializationCallback> Callback)
{
	ActionScriptSetFunction("ScoreboardInitialized");
}

//==============================================================
// Player and Scoring Handling
//==============================================================

/**
 *  Callback from ActionScript on Frame 0, which will let us know that the widget has been initialized and is able to be populated with data * 
 */
function Callback_ScoreboardInitialized()
{
	bInitialized = TRUE;

	// If we already have a PRI registered, go ahead and fill out the data
	if( MyPRI != None )
	{
		FillOutScoreboard();
	}
}

/**
 *  Sets the player associated with this scoreboard.  All information displayed on the scoreboard will be pulled from this PRI 
 * 
 *  @param  PlayerPRI   The Player Replication Info associated with the player associated with this scoreboard
 */
function SetPlayerPRI( GearPRI_SP PlayerPRI )
{
	MyPRI = PlayerPRI;

	if( bInitialized )
	{
		// If the scoreboard has already been initialized, fill it out now
		FillOutScoreboard();
	}
	else
	{
		// If not, set the callback so we get notification and can fill it out when it's ready
		SetInitializedCallback( Callback_ScoreboardInitialized );
	}
}

/**
 *  Fills out the scoreboard with all the player's stats
 */
function FillOutScoreboard()
{
	if( !bInitializedStaticElements )
	{
		// Set the player's name
		lbl_PlayerName.SetText( MyPRI.PlayerName );

		// Set stats descriptions
		lbl_Description[0].SetText(StatDescription0);
		lbl_Description[1].SetText(StatDescription1);
		lbl_Description[2].SetText(StatDescription2);
		lbl_Description[3].SetText(StatDescription3);
		lbl_Description[4].SetText(StatDescription4);
		lbl_Description[5].SetText(StatDescription5);
		lbl_Description[6].SetText(StatDescription6);
		lbl_Description[7].SetText(StatDescription7);
		lbl_Description[8].SetText(StatDescription8);

		// Set the player's character portrait
		if( MyPRI.PawnClass.default.ArcadeCharacterPortrait != None )
		{
			CharacterImageLoader.SetString("source", "img://" $ PathName(MyPRI.PawnClass.default.ArcadeCharacterPortrait) );
		}

		bInitializedStaticElements = TRUE;
	}
	
	// --- Stats ------------------------------------

	// 0 - Enemies Killed
	UpdateStat( 0, MyPRI.GetKills() );

	// 1 - Executions
	lbl_Stat[1].SetCachedText("N/A");

	// 2 - Hit %
	lbl_Stat[2].SetCachedText("N/A" $ "%");

	// 3 - Headshots
	lbl_Stat[3].SetCachedText("N/A");

	// 4 - Downed
	UpdateStat( 4, MyPRI.GetTakeDowns() );

	// 5 - Deaths
	UpdateStat( 5, MyPRI.GetDeaths() );

	// 6 - Revives
	UpdateStat( 6, MyPRI.GetRevives() );

	// 7 - Ammo Taken
	lbl_Stat[7].SetCachedText("N/A");

	// 8 - Weapons Taken
	lbl_Stat[8].SetCachedText("N/A");

	// Overall Score
	UpdateStat( 9, MyPRI.GetScore() );
}

/**
 *  Checks to see if the leader status for the specified stat has changed, and updates the stat if needed.  Also, update the text for the stat
 *  
 *  @param  StatIndex   Index for the stat to check
 *  @param  StatValue   Current value of the stat to test against other players
 */
function UpdateStat(int StatIndex, int StatValue)
{
	local bool bIsLeading;
	local UIWidget_CachedUILabel StatLabel;

	// See if this player is better than other players for this stat
	bIsLeading = IsScoreboardLeaderForStat(StatIndex, StatValue);

	// If we're newly the leader (or not the leader), update the bitfield cache, and set the icon appropriately
	if( IsCurrentlyLeadingStat(StatIndex) != bIsLeading )
	{
		SetCurrentlyLeadingStat(StatIndex, bIsLeading);
	}

	// Since StatIndex 9 is a special case (total score), grab a reference to the stat we want to update
	StatLabel = (StatIndex == 9) ? lbl_TotalScore : lbl_Stat[StatIndex];
	StatLabel.SetCachedHTMLText( GetFormattedStatString(StatValue, bIsLeading) );
}

/** 
 *  Checks the parent scoreboard to see if this player is currently leading the pack in the specified stat
 *  
 *  @param  StatIndex   Index for the stat to check
 *  @param  StatValue   Current value of the stat to test against other players
 *  
 *  @return             TRUE if the player is currently leading the stat
 */
function bool IsScoreboardLeaderForStat(int StatIndex, int StatValue)
{
	return OwningScoreboard.IsPlayerStatLeader(StatIndex, StatValue);
}

/**
 *  Checks the CurrentLeaderBitmask to see if we are currently leading the stats for a specified index
 *  
 *  @param  StatIndex   Index of the stat to check to see if we're a current leader for
 *  
 *  @return             TRUE if we're currently the leader, FALSE if not
 */
function bool IsCurrentlyLeadingStat(int StatIndex)
{
	return ((CurrentLeaderBitmask & (2 << StatIndex)) != 0);
}

/**
 *  Sets the bit in the CurrentLeaderBitmask corresponding to the StatIndex specified to the value specified, and updates the star icon next to the stat
 *  
 *  @param  StatIndex   Index of the stat we want to set
 *  @param  bIsLeading  The value to set the bit to
 */
function SetCurrentlyLeadingStat(int StatIndex, bool bIsLeading)
{
	// If the value is different than current, then toggle the bit in question
	if( IsCurrentlyLeadingStat(StatIndex) != bIsLeading )
	{
		CurrentLeaderBitmask = CurrentLeaderBitmask ^ (2 << StatIndex);

		// If the stat isn't StatIndex 9 (total score), update the star
		if( StatIndex < 9 )
		{
			mc_Star[StatIndex].GotoAndPlay( bIsLeading ? "on" : "off" );
		}
	}
}

/**
 *  Gets an HTML formatted string with the appropriate colour based on whether or not the player is a leader
 *  
 *  @param  StatValue   Value of the stat to format
 *  @param  bIsLeader   TRUE if the player is a leader for this stat
 *  
 *  @return             A string formatted with the appropriate colour for the stat
 */
function string GetFormattedStatString(coerce string StatValue, bool bIsLeader)
{
	if( bIsLeader )
	{
		return "<font color='#d57447'>" $ StatValue $ "</font>";
	}
	else
	{
		return StatValue;
	}
}


defaultproperties
{
	SubWidgetBindings.Add((WidgetName=lbl_Stat0,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat1,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat2,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat3,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat4,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat5,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat6,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat7,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_Stat8,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
	SubWidgetBindings.Add((WidgetName=lbl_TotalScore,WidgetClass=class'GearGame.UIWidget_CachedUILabel'))
}
