/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWIdget_WingmanTeamInfo.uc
 * An interface to the team info widget displaying one team's worth of scores in Wingman.  Corresponds to the ActionScript class WingmanTeamInfo
 */

class UIWidget_WingmanTeamInfo extends GFxObject;

const MAX_HEADSHOT_PORTRAITS = 9;

// --- Widget References ----------------------------------
var transient GFxObject lbl_TeamName;
var transient GFxObject lbl_TeamScore;
var transient GFxObject lbl_Player1Name;
var transient GFxObject lbl_Player2Name;
var transient GFxObject lbl_Player1Score;
var transient GFxObject lbl_Player2Score;

// --- Misc. Variables ------------------------------------
/** Current index of activation for headshot portraits */
var transient int       HeadshotActivationIndex;

/** Number of headshot columns we need to activate */
var transient int       MaxHeadshots;


//==============================================================
// Movie player functions
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
	switch( WidgetName )
	{
		case 'lbl_TeamName':
			lbl_TeamName = Widget;
			break;
		case 'lbl_TeamScore':
			lbl_TeamScore = Widget;
			break;
		case 'lbl_Player1Name':
			lbl_Player1Name = Widget;
			break;
		case 'lbl_Player2Name':
			lbl_Player2Name = Widget;
			break;
		case 'lbl_Player1Score':
			lbl_Player1Score = Widget;
			break;
		case 'lbl_Player2Score':
			lbl_Player2Score = Widget;
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

//==============================================================
// Control functions
//==============================================================

/**
 * Sets the team header information for the team scoreboard
 * 
 * @param   TeamName    Name of the team, usually the character played by the team
 * @param   TeamScore   Score of the team
 */
function SetTeamInformation(string TeamName, int TeamScore)
{
	lbl_TeamName.SetText( TeamName );
	lbl_TeamScore.SetText( string(TeamScore) );
}

/**
 * Sets the information for the players in the scoreboard
 * 
 * @param   bIsCOG             TRUE if the team is a COG team, FALSE if they're Locust
 * @param   bIsLocalPlayer     TRUE if the player is local.  This will hide the headshots when they are set up, so they can be counted in  
 * 
 * @param   Player1Name        Name of the first player
 * @param   Player1Score       Score of the first player as a string
 * @param   Player1Headshots   An array of string paths to texture resources for the headshots array for the first player
 * 
 * @param   Player2Name        Name of the second player
 * @param   Player2Score       Score of the second player as a string
 * @param   Player2Headshots   An array of string paths to texture resources for the headshots array for the second player
 */
function SetPlayerInformation(bool bIsCOG, bool bIsLocalPlayer, string Player1Name, string Player1Score, array<string> Player1Headshots, string Player2Name, string Player2Score, array<string> Player2Headshots)
{
	local GFxObject P1Headshots, P2Headshots;
	local int i;
	local bool bHasPlayer2;

	// Update the team theme
	ActionScript_SetTeamTheme(bIsCOG);

	// Set up player 1's info
	lbl_Player1Name.SetString("htmlText", Player1Name);
	lbl_Player1Score.SetString("htmlText", Player1Score);

	// Set up player 2's info, if he exists
	bHasPlayer2 = (Player2Name != "");
	if( bHasPlayer2 )
	{
		lbl_Player2Name.SetString("htmlText", Player2Name);
		lbl_Player2Score.SetString("htmlText", Player2Score);
	}
	else
	{
		lbl_Player2Name.SetBool("_visible", FALSE);
		lbl_Player2Score.SetBool("_visible", FALSE);
	}

	// Create the GFx version of the headshots array for player 1
	P1Headshots = CreateArray();
	for( i = 0; i < Player1Headshots.length; i++ )
	{
		P1Headshots.SetElementString( i, Player1Headshots[i] );
	}

	// Create the GFx version of the headshots array for player 2
	P2Headshots = CreateArray();
	for( i = 0; i < Player2Headshots.length; i++ )
	{
		P2Headshots.SetElementString( i, Player2Headshots[i] );
	}

	// Store the max number of headshots we have to reveal
	MaxHeadshots = Max(Player1Headshots.length, Player2Headshots.length);

	// Send the arrays to GFx
	ActionScript_SetPlayerHeadshots(P1Headshots, P2Headshots, bIsLocalPlayer);
}

/**
 * Activates the next in the sequence of headshots
 * 
 * @return TRUE if a new index was activated, FALSE if not 
 */
function bool ActivateNextIndex()
{
	if( HeadshotActivationIndex < MaxHeadshots )
	{
		ActionScript_ActivateHeadshotIndex( HeadshotActivationIndex++ );
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/**
 * Tweens the scoreboard to the specified position, in the specified time
 * 
 * @param   XPos        X position to tween to
 * @param   YPos        Y position to tween to
 * @param   BlendTime   Time to take tweening to the new position
 */
function TweenIntoScoreboard(float XPos, float YPos, float BlendTime)
{
	ActionScript_BlendPlayerScoreIntoScoreboard(XPos, YPos, BlendTime);
}

//==============================================================
// ActionScript stubs
//==============================================================

private function ActionScript_SetTeamTheme(bool bIsCOG)
{
	ActionScriptVoid("SetTeamTheme");
}

private function ActionScript_SetPlayerHeadshots(GFxObject Player1Shots, GFxObject Player2Shots, bool bShouldHideHeadshots)
{
	ActionScriptVoid("SetPlayerHeadshots");
}

private function ActionScript_ActivateHeadshotIndex(int Index)
{
	ActionScriptVoid("ActivateHeadshotIndex");
}

private function ActionScript_BlendPlayerScoreIntoScoreboard(float XPos, float YPos, float BlendTime)
{
	ActionScriptVoid("BlendPlayerScoreIntoScoreboard");
}