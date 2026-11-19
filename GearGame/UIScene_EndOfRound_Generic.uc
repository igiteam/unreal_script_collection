/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * UIScene_EndOfRound_Generic.uc
 * Base class for the generic, simple end of round scoreboard used in versus, etc.
 */

class UIScene_EndOfRound_Generic extends UIScene_EndOfRound;

// --- Widget references ---------------------------------------
/** Reference to the team logo to display on the EOR scoreboard */
var transient GFxObject     icon_mc;

/** Menu title labels */
var transient UIWidget_CachedUILabel  lbl_title;
var transient UIWidget_CachedUILabel  lbl_teamscore;
var transient UIWidget_CachedUILabel  lbl_time;

/** Body text labels */
var transient UIWidget_CachedUILabel  lbl_bodyText1;
var transient UIWidget_CachedUILabel  lbl_bodyText2;
var transient UIWidget_CachedUILabel  lbl_bodyText3;
var transient UIWidget_CachedUILabel  lbl_bodyText4;
var transient UIWidget_CachedUILabel  lbl_bodyText5;
var transient UIWidget_CachedUILabel  lbl_bodyText6;
var transient UIWidget_CachedUILabel  lbl_bodyText7;

// --- Localized Strings ---------------------------------------
var localized string        TeamMatchWin;
var localized string        TeamRoundWin;
var localized string        TeamDraw;
var localized string        TeamCOG;
var localized string        TeamLOC;
var localized string        FinalKill;
var localized string        FinalTakedown;
var localized string        FinalExecute;
var localized string        FinalLeaderSuicide;
var localized string		FinalPlayerSuicide;
var localized string        FinalEnvironmentDeath;
var localized string        FinalDisconnectString;
var localized string		FinalTimeRanOut;
var localized string        FinalFriendly;
var localized string        FinalCapture;
var localized string        RespawnsRemaining;
var localized string        ScoreMsg;

// --- Misc. Variables -----------------------------------------
/** TRUE if the scoreboard logo has been set, FALSE if it has not */
var transient bool          bScoreboardHasBeenSet;

//==============================================================
// Movie Player function overrides
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
		case 'icon_mc':
			icon_mc = Widget;
			break;
		case 'lbl_title':
			lbl_title = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_teamscore':
			lbl_teamscore = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_time':
			lbl_time = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText1':
			lbl_bodyText1 = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText2':
			lbl_bodyText2 = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText3':
			lbl_bodyText3 = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText4':
			lbl_bodyText4 = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText5':
			lbl_bodyText5 = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText6':
			lbl_bodyText6 = UIWidget_CachedUILabel(Widget);
			break;
		case 'lbl_bodyText7':
			lbl_bodyText7 = UIWidget_CachedUILabel(Widget);
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

//==============================================================
// Widget Handling
//==============================================================

/** Initializes the values for the movie, based on the current gametype */
function InitializeWidgetValues()
{
	local EGearMPTypes  GameType;

	GameType = GetGearMPGameType(GRI);

	switch(GameType)
	{
		case eGEARMP_Warzone:
		case eGEARMP_Execution:
			PopulateScoreboard_Warzone();
			break;
		case eGEARMP_Newbie:
		case eGEARMP_KOTH:
			PopulateScoreboard_KOTH();
			break;
		case eGEARMP_CTL:
			PopulateScoreboard_CTL();
			break;
		default:
			`log("Unhandled gametype for UIScene_EndOfRound_Generic: " $ GameType);
			break;
	}
}

/** Can be overloaded in child classes to check for updates due to replication, etc, and update as necessary */
function CheckForUpdates()
{
	InitializeWidgetValues();
}

/**
 *  Sets the icon of the scoreboard to reflect the COG, Locust, or a draw.
 *
 *  @param  LogoType    Type of logo to set the board to: (cog, locust, draw)
 */
function SetScoreboardLogo(name LogoType)
{
	// Bail early if we've already had the logo set, so we don't get animations replaying
	if( bScoreboardHasBeenSet )
	{
		return;
	}

	switch( LogoType )
	{
		case 'cog':
			icon_mc.GotoAndPlay("cog");
			break;
		case 'locust':
			icon_mc.GotoAndPlay("locust");
			break;
		case 'draw':
			icon_mc.GotoAndPlay("draw");
			break;
		default:
			`log("Unhandled logo type: " $ LogoType,, 'GearsUI');
			break;
	}

	bScoreboardHasBeenSet = TRUE;
}

//==============================================================
// Scoring Handling
//==============================================================

/** Handles populating the scoreboard with the appropriate information for Warzone and Execution game types */
function PopulateScoreboard_Warzone()
{
	local TeamInfo TeamWinner;
	local string TeamString, LastAliveName, KillMessage, FormattedString, StateMessage;
	local GearPRI PRIWinner, MyGearPRI1, MyGearPRI2, PRIKilled, DBNOPRI, KillerPRI, LastToDiePRI;
	local EGearRaceTypes WinningRace;
	local int TeamIdx, HighestLossCount;

	// Grab the team
	TeamWinner = TeamInfo(GRI.Winner);

	// If there was a stalemate, set the widgets and exit
	if ( TeamWinner == None )
	{
		SetWidgetsForStalemate();
		return;
	}

	// Grab the last PRI killer
	PRIWinner = GearPRI(GRI.FinalKiller);

	// Determine the race of the winner
	WinningRace = GetRaceUsingPRIOnly( FindPRIOnTeam(TeamWinner.TeamIndex, GRI) );

	// Get the team string for the title label
	TeamString = ((WinningRace == eGEARRACE_COG) ? TeamCOG : TeamLOC);

	// Title string - (TEAM HAS WON THE MATCH!)
	if ( GRI.GameStatus == GS_EndMatch )
	{
		lbl_title.SetCachedText( Repl(TeamMatchWin, "*t", TeamString) );
	}
	// Title string - (TEAM VICTORY!)
	else
	{
		lbl_title.SetCachedText( Repl(TeamRoundWin, "*t", TeamString) );
	}

	// Score string
	lbl_teamscore.SetCachedText( string(int(TeamWinner.Score)) );

	// Time round took
	lbl_time.SetCachedText( FormatTime(GRI.RoundEndTime) );

	// Set the team styles
	SetScoreboardLogo( (WinningRace == eGEARRACE_COG) ? 'cog' : 'locust' );

	// Grab a reference to the local player's PRI
	GetLocalPRIs( MyGearPRI1, MyGearPRI2 );

	// Set strings and styles for the players involved with the win
	if ( PRIWinner != None )
	{
		PRIKilled = GearPRI(PRIWinner.LastIKilledPRI);
		if ( PRIKilled != None )
		{
			KillerPRI = GearPRI(PRIKilled.LastToKillMePRI);
			DBNOPRI = (PRIKilled.LastToDBNOMePRI != None) ? GearPRI(PRIKilled.LastToDBNOMePRI) : KillerPRI;
		}
	}

	if ( (PRIWinner != None) && GRI.bGameIsExecutionRules && !GRI.bFinalFriendlyKill )
	{
		// Check for suicide
		if ( (PRIKilled == KillerPRI) && (PRIKilled == DBNOPRI) )
		{
			// Suicide title/player
			FormattedString = GetFormattedPlayerName(PRIKilled, MyGearPRI1, MyGearPRI2);

			lbl_bodyText1.SetCachedText( GetSuicideString(PRIKilled) );
			lbl_bodyText2.SetCachedHTMLText(FormattedString);
		}
		// Execution rules (and not a suicide) so hide the alternate panel since we need both player spots that the main panel provides
		else
		{
			// Note who made the final takedown
			FormattedString = GetFormattedPlayerName(DBNOPRI, MyGearPRI1, MyGearPRI2);
			lbl_bodyText1.SetCachedText( FinalTakedown );
			lbl_bodyText2.SetCachedHTMLText(FormattedString);

			// Note who made the final execution
			FormattedString = GetFormattedPlayerName(KillerPRI, MyGearPRI1, MyGearPRI2);
			lbl_bodyText3.SetCachedText( FinalExecute );
			lbl_bodyText4.SetCachedHTMLText(FormattedString);
		}
	}
	else
	{
		// Suicide/Disconnect title/player
		if ( PRIWinner == None )
		{
			for ( TeamIdx = 0; TeamIdx < GRI.Teams.length; TeamIdx++ )
			{
				// Figure out which team died last and record the name of the last player standing from that team
				if ( TeamIdx < ArrayCount(GRI.TeamIndexLossOrder) &&
					HighestLossCount < GRI.TeamIndexLossOrder[TeamIdx] )
				{
					LastAliveName = GRI.LastStandingOnTeamName[TeamIdx];
					HighestLossCount = GRI.TeamIndexLossOrder[TeamIdx];
				}
			}

			// See if this was an environment death
			if ( LastAliveName == "" || (LastAliveName != "" && GRI.FinalVictim != None && GearPRI(GRI.FinalVictim).PlayerName == LastAliveName) )
			{
				LastToDiePRI = GearPRI(GRI.FinalVictim);
				if (LastToDiePRI != None)
				{
					LastAliveName = LastToDiePRI.PlayerName;
				}
			}

			// Killer title/player
			// Manually format the string, since we don't necessarily have the PRI corresponding to the player name
			if( (MyGearPRI1 != None) && (LastAliveName == MyGearPRI1.PlayerName) )
			{
				FormattedString = Repl( LocalPlayer1FormatString, "*p", LastAliveName );
			}
			else if( (MyGearPRI2 != None) && (LastAliveName == MyGearPRI2.PlayerName) )
			{
				FormattedString = Repl( LocalPlayer2FormatString, "*p", LastAliveName );
			}
			else
			{
				FormattedString = LastAliveName;
			}

			if ( IsEnvironmentDamageDeath(LastToDiePRI) )
			{
				StateMessage = FinalEnvironmentDeath;
			}
			else if (!GRI.bRoundTimeRanOut)
			{
				StateMessage = FinalDisconnectString;
			}
			else
			{
				StateMessage = FinalTimeRanOut;
			}

			//lbl_bodyText1.SetCachedText(  ? FinalEnvironmentDeath : FinalDisconnectString );
			lbl_bodyText1.SetCachedText(StateMessage);
			lbl_bodyText2.SetCachedHTMLText(FormattedString);
		}
		else
		{
			// Killer title/player
			if (KillerPRI == None)
			{
				KillerPRI = PRIWinner;
			}
			if (KillerPRI == KillerPRI.LastIKilledPRI)
			{
				KillMessage = GetSuicideString(KillerPRI); 
			}
			else if (GRI.bFinalFriendlyKill)
			{
				KillMessage = FinalFriendly;
			}
			else
			{
				KillMessage = FinalKill;
			}

			lbl_bodyText1.SetCachedText( KillMessage );
			lbl_bodyText2.SetCachedHTMLText(GetFormattedPlayerName(KillerPRI, MyGearPRI1, MyGearPRI2));
		}
	}
}

/**
 * Looks at a PRI and returns a suicide message that depends on if they were the leader or not 
 */
function string GetSuicideString(GearPRI Pri)
{
	if (PRI.bIsLeader)
	{
		return FinalLeaderSuicide;
	}
	else
	{
		return FinalPlayerSuicide;
	}
}

/** Handles populating the scoreboard with the appropriate information for KOTH and Newbie game types */
function PopulateScoreboard_KOTH()
{
	local TeamInfo TeamWinner;
	local string TeamString;
	local EGearRaceTypes WinningRace;
	local int WinningTeamSize, i;

	// Grab the team
	TeamWinner = TeamInfo(GRI.Winner);

	// If there was a stalemate, set the widgets and exit
	if ( TeamWinner == None )
	{
		SetWidgetsForStalemate();
		return;
	}

	// Determine the race of the winner
	WinningRace = GetRaceUsingPRIOnly( FindPRIOnTeam(TeamWinner.TeamIndex, GRI) );
	// Get the team string for the title label
	TeamString = (WinningRace == eGEARRACE_COG) ? TeamCOG : TeamLOC;

	// Title string - (TEAM HAS WON THE MATCH!)
	if ( GRI.GameStatus == GS_EndMatch )
	{
		lbl_title.SetCachedText( Repl(TeamMatchWin, "*t", TeamString) );
	}
	// Title string - (TEAM VICTORY!)
	else
	{
		lbl_title.SetCachedText( Repl(TeamRoundWin, "*t", TeamString) );
	}

	// Score string
	lbl_teamscore.SetCachedText( string(int(TeamWinner.Score)) );

	// Time round took
	lbl_time.SetCachedText( FormatTime(GRI.RoundEndTime) );

	// Winner title
	if (GetGearMPGameType(GRI) == eGEARMP_Newbie)
	{
		// If this is TDM, set the text to be respawns remaining
		lbl_bodyText1.SetCachedText(RespawnsRemaining);
		for (i = 0; i < GRI.PRIArray.length; i++)
		{
			if ( GRI.PRIArray[i].Team == TeamWinner && GearPRI(GRI.PRIArray[i]).PlayerStatus != WPS_Dead &&
				GearPRI(GRI.PRIArray[i]).PlayerStatus != WPS_Spectating )
			{
				WinningTeamSize++;
			}
		}
		lbl_bodyText2.SetCachedText(string(int(Abs(GRI.GameScore[0] - GRI.GameScore[1])) + WinningTeamSize));
	}
	else
	{
		lbl_bodyText1.SetCachedText( ScoreMsg );
		// Set the team styles
		lbl_bodyText2.SetCachedText(string(int(Abs(GRI.GameScore[0] - GRI.GameScore[1]))));
	}

	SetScoreboardLogo( (WinningRace == eGEARRACE_COG) ? 'cog' : 'locust' );
}

/** Handles populating the scoreboard with the appropriate information for the Capture the Leader gametype */
function PopulateScoreboard_CTL()
{
	local TeamInfo TeamWinner;
	local string TeamString;
	local EGearRaceTypes WinningRace;
	local GearPRI MyGearPRI1, MyGearPRI2;

	// Grab the team
	TeamWinner = TeamInfo(GRI.Winner);

	// Determine the race of the winner
	WinningRace = GetRaceUsingPRIOnly( FindPRIOnTeam(TeamWinner.TeamIndex, GRI) );
	// Get the team string for the title label
	TeamString = (WinningRace == eGEARRACE_COG) ? TeamCOG : TeamLOC;

	// Title string - (TEAM HAS WON THE MATCH!)
	if ( GRI.GameStatus == GS_EndMatch )
	{
		lbl_title.SetCachedText( Repl(TeamMatchWin, "*t", TeamString) );
	}
	// Title string - (TEAM VICTORY!)
	else
	{
		lbl_title.SetCachedText( Repl(TeamRoundWin, "*t", TeamString) );
	}

	// Score string
	lbl_teamscore.SetCachedText( string(int(TeamWinner.Score)) );

	// Time round took
	lbl_time.SetCachedText( FormatTime(GRI.RoundEndTime) );

	// Set the team styles
	SetScoreboardLogo( (WinningRace == eGEARRACE_COG) ? 'cog' : 'locust' );

	// Grab a reference to the local player's PRI
	GetLocalPRIs( MyGearPRI1, MyGearPRI2 );

	// Winner title
	lbl_bodyText1.SetCachedText( FinalCapture );
	lbl_bodyText2.SetCachedHTMLText(GetFormattedPlayerName(GearGRI_CTL(GRI).MeatflagKidnapper, MyGearPRI1, MyGearPRI2));
}

/** Handles the stalemate case */
function SetWidgetsForStalemate()
{
	// Title
	lbl_title.SetCachedText( TeamDraw );

	// Team score (hide)
	lbl_teamscore.SetCachedText("");

	// Time round took
	lbl_time.SetCachedText( FormatTime(GRI.RoundEndTime) );

	// Set the logo
	SetScoreboardLogo('draw');
}

//==============================================================
// Helper functions
//==============================================================

/**
 *  Whether the damage type is from the environment or not
 *
 *  @param  DeadPRI     PRI of the player who died
 *
 *  @return TRUE if the player died of environmental damage, FALSE if not
 */
final function bool IsEnvironmentDamageDeath( GearPRI DeadPRI )
{
	if ( DeadPRI != None )
	{
		if ( DeadPRI.DamageTypeToKillMe.default.bEnvironmentalDamage )
		{
			return TRUE;
		}
	}

	return FALSE;
}

defaultproperties
{
	WidgetBindings(0)=(WidgetName=lbl_title,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(1)=(WidgetName=lbl_teamscore,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(2)=(WidgetName=lbl_time,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(3)=(WidgetName=lbl_bodyText1,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(4)=(WidgetName=lbl_bodyText2,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(5)=(WidgetName=lbl_bodyText3,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(6)=(WidgetName=lbl_bodyText4,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(7)=(WidgetName=lbl_bodyText5,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(8)=(WidgetName=lbl_bodyText6,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
	WidgetBindings(9)=(WidgetName=lbl_bodyText7,WidgetClass=class'GearGame.UIWidget_CachedUILabel')
}
