/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_EndOfRound_Wingman extends UIScene_EndOfRound;

const MAX_WINGMAN_TEAM_SCOREBOARDS = 5;

// --- Widget References ---------------------------------------
/** Header labels */
var transient GFxObject lbl_GameTitle;
var transient GFxObject lbl_VictoryString;
var transient GFxObject lbl_Time;

/** References to the scoreboards for each team */
var transient UIWidget_WingmanTeamInfo  TeamScoreboard[MAX_WINGMAN_TEAM_SCOREBOARDS];

// --- Localized Strings ---------------------------------------
var localized string RoundVictoryString;
var localized string MatchVictoryString;

// --- Misc. Variables -----------------------------------------
/** Number of scoreboards that actually have team data in them */
var transient int   NumTeams;

/** Index of the next scoreboard index to activate when flashing them in */
var transient int   NextScoreboardToActivate;

/** Index into the TeamScoreboard[] array of the local player's team */
var transient int   LocalScoreboardIndex;

/** The original X and Y positions of the local player's scoreboard, this will be the target to blend back to when fading back into the scoreboard */
var transient float LocalScoreboard_OriginalX;
var transient float LocalScoreboard_OriginalY;

/** Scale factor to upscale the local player's scoreboard */
var float           LocalScoreboard_ScaleFactor;

/** Time to tween the local player's scoreboard into the normal scoreboard */
var float           LocalScoreboard_TweenTime;

/** Time between scoreboards flashing in sequence as they appear in the final scoreboard */
var float           ScoreboardFlashDelay;

/** Delay after all the scoreboards have flashed in before the scoreboard closes */
var float           ScoreboardCloseDelay;

/** Time that the local player scoreboard will remain up after all the headshots have faded in */
var float           LocalScoreboardDelay;

/** Time between headshots popping in on the local player's scoreboard */
var float           LocalScoreboardHeadshotFlashDelay;

//==============================================================
// MoviePlayer Functions
//==============================================================

/** Called when a movie is closed to allow cleanup and handling */
event OnClose()
{
	Super.OnClose();

	//Go straight to the next round, do not show the scoreboard.
	if (GRI.Role == ROLE_Authority)
	{
		GRI.ResetRoundClock(0);
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
	local int Index;

	switch( WidgetName )
	{
		case 'lbl_GameTitle':
			lbl_GameTitle = Widget;
			break;
		case 'lbl_VictoryString':
			lbl_VictoryString = Widget;
			break;
		case 'lbl_Time':
			lbl_Time = Widget;
			break;
		default:
			if( InStr(WidgetName, "ScoreboardTeam") != INDEX_NONE )
			{
				Index = int( Right(WidgetName, 1) );
				TeamScoreboard[Index] = UIWidget_WingmanTeamInfo(Widget);
				SetWidgetPathBinding(TeamScoreboard[Index], WidgetPath);
			}
			else
			{
				return FALSE;
			}
	}

	return TRUE;
}

/** Overridden to prevent the wingman scoreboard from closing automagically between rounds */
function AllDoneWaitTimeComplete()
{
	local GearPC MyGearPC;

	MyGearPC = GetGearPC();
	if (MyGearPC != none && MyGearPC.MyGearHud != none)
	{
		GearHUDMP_Base(MyGearPC.MyGearHud).CloseEndOfRoundScene();
	}
}

/** Initializes the widget values for the scoreboard */
function InitializeWidgetValues()
{
	local array<int> SortedTeams;
	local int SortedIdx, TeamIndex, PlayerIndex, i;
	local float LocalScoreboard_OriginalWidth, LocalScoreboard_OriginalHeight;
	local bool bIsCOGTeam;
	local GearPRI   Player1, Player2, LocalPlayer1, LocalPlayer2;
	local array<string> P1Headshots, P2Headshots;
	local ASDisplayInfo DI;

	GetLocalPRIs( LocalPlayer1, LocalPlayer2 );

	// Set the title of the scoreboard
	lbl_GameTitle.SetString("htmlText", GetGameTitleAndDescription());

	// Set the round time
	lbl_Time.SetText( FormatTime(GRI.RoundEndTime) );

	// Initialize the victory string to nothing...we'll set it when / if needed
	lbl_VictoryString.SetText("");

	// Sort the teams, in order of team score
	for (PlayerIndex = 0; PlayerIndex < GRI.PRIArray.length; PlayerIndex++)
	{
		if (GRI.PRIArray[PlayerIndex] != None 
			&& !GRI.PRIArray[PlayerIndex].bIsInactive
			&& GRI.Teams[GRI.PRIArray[PlayerIndex].Team.TeamIndex] != None )
		{
			TeamIndex = GRI.PRIArray[PlayerIndex].Team.TeamIndex;
			//If it isn't already in there...
			if (SortedTeams.Find(TeamIndex) == -1)
			{
				for (SortedIdx = 0; SortedIdx < SortedTeams.length; SortedIdx++)
				{
					if (GRI.Teams[TeamIndex].Score > GRI.Teams[SortedTeams[SortedIdx]].Score)
					{
						SortedTeams.InsertItem(SortedIdx, TeamIndex);
						break;
					}
				}

				// Didn't find a place to insert so append
				if (SortedIdx >= SortedTeams.length)
				{
					SortedTeams.AddItem(TeamIndex);
				}
			}
		}
	}

	// Store off how many teams we have
	NumTeams = SortedTeams.length;
	LocalScoreboardIndex = INDEX_NONE;

	// Iterate over the scoreboards, populating them with data
	for( i = 0; i < MAX_WINGMAN_TEAM_SCOREBOARDS; i++ )
	{
		if( i < SortedTeams.length )
		{
			GetPlayersOnTeam(SortedTeams[i], Player1, Player2);

			// Since both players are on the same team, test whether LocalPlayer1 is in this scoreboard
			if( (Player1 == LocalPlayer1) || (Player2 == LocalPlayer1) )
			{
				// Move the local player's scoreboard into the middle of the screen, so it can fade back into place
				LocalScoreboardIndex = i;

				DI = TeamScoreboard[i].GetDisplayInfo();
				LocalScoreboard_OriginalX = DI.X;
				LocalScoreboard_OriginalY = DI.Y;
				
				LocalScoreboard_OriginalWidth = TeamScoreboard[i].GetFloat("_width");
				LocalScoreboard_OriginalHeight = TeamScoreboard[i].GetFloat("_height");

				DI.XScale = LocalScoreboard_ScaleFactor * 100.f;
				DI.YScale = LocalScoreboard_ScaleFactor * 100.f;

				DI.X = 640.f - 0.5f * LocalScoreboard_ScaleFactor * LocalScoreboard_OriginalWidth;
				DI.Y = 320.f - 0.5f * LocalScoreboard_ScaleFactor * LocalScoreboard_OriginalHeight;
				
				TeamScoreboard[i].SetDisplayInfo(DI);
			}
			else
			{
				// Hide scoreboards that aren't the player's...they'll fade in in sequence
				TeamScoreboard[i].SetBool("_visible", FALSE);
			}

			// If this is the first team, set the victory string while we have the player's PRI
			if( i == 0 )
			{
				lbl_VictoryString.SetText( Caps(Player1.PawnClass.default.CharacterName) @ (GRI.GameStatus == GS_EndMatch ? MatchVictoryString : RoundVictoryString) );
			}

			P1Headshots = GetHeadshotsForPlayer( Player1 );
			P2Headshots = GetHeadshotsForPlayer( Player2 );

			// Note that Player1 should always be valid, but not necessarily player 2
			bIsCOGTeam = (GetRaceUsingPRIOnly(Player1) == eGEARRACE_COG);
			TeamScoreboard[i].SetTeamInformation( Caps(Player1.PawnClass.default.CharacterName), GRI.Teams[SortedTeams[i]].Score );
			TeamScoreboard[i].SetPlayerInformation( bIsCOGTeam, (i == LocalScoreboardIndex), 
													GetFormattedPlayerName(Player1, LocalPlayer1, LocalPlayer2), GetFormattedLocalPlayerString(string(int(Player1.Score)), Player1, LocalPlayer1, LocalPlayer2), P1Headshots,
													((Player2 != None) ? GetFormattedPlayerName(Player2, LocalPlayer1, LocalPlayer2) : ""), ((Player2 != None) ? GetFormattedLocalPlayerString(string(int(Player2.Score)), Player2, LocalPlayer1, LocalPlayer2) : ""), P2Headshots );

			// Set the timer to start fading in the headshots
			GetPC().SetTimer(LocalScoreboardHeadshotFlashDelay, TRUE, nameof(ActivateNextHeadshotIndex), self);
			// Set the timer to start tweening the scoreboard into the normal scoreboard
			GetPC().SetTimer(LocalScoreboardDelay, FALSE, nameof(TweenLocalScoreboard), self);
		}
		else
		{
			// Hide scoreboards for teams that do not exist
			TeamScoreboard[i].SetBool("_visible", FALSE);
		}
	}
}


//==============================================================
// Flow Control Functions
//==============================================================

function ActivateNextHeadshotIndex()
{
	if( TeamScoreboard[LocalScoreboardIndex].ActivateNextIndex() )
	{
		// Activated a headshot, play a sound!
		PlaySoundFromTheme('Bonus');
	}
	else
	{
		// We're done activating indices, stop trying!
		GetPC().ClearTimer( nameof(ActivateNextHeadshotIndex), self );
	}
}


/** Called to tween the local player's scoreboard into the rest of the scoreboard after the headshots have counted up */
function TweenLocalScoreboard()
{
	TeamScoreboard[LocalScoreboardIndex].TweenIntoScoreboard(LocalScoreboard_OriginalX, LocalScoreboard_OriginalY, LocalScoreboard_TweenTime);
	PlaySoundFromTheme('Bonus');
}

/** Callback in the scoreboard to indicate that we've finished blending the local player's score into the scoreboard */
function Callback_ScoreboardBlendComplete()
{
	// Now that the player's scoreboard has faded back in, start flashing in all of the scoreboards
	GetPC().SetTimer(ScoreboardFlashDelay, TRUE, nameof(ActivateNextScoreboard), self);
}

/** Flashes in the next scoreboard in sequence */
function ActivateNextScoreboard()
{
	if( NextScoreboardToActivate < NumTeams )
	{
		// Make the next scoreboard visible
		TeamScoreboard[NextScoreboardToActivate++].SetBool("_visible", TRUE);
		PlaySoundFromTheme('Bonus');
	}
	else
	{
		// We're done, so move on
		GetPC().ClearTimer(nameof(ActivateNextScoreboard), self);
		GetPC().SetTimer(ScoreboardCloseDelay, FALSE, nameof(AllDoneWaitTimeComplete), self);
	}
}

//==============================================================
// Gametype Helper Functions
//==============================================================

/**
 * Returns the game name, difficulty descriptor, and map name for the current match
 * 
 * @return  String filled out with the game name, description, and map name
 */
function string GetGameTitleAndDescription()
{
	local string LabelString;

	// Update the gamemode/mapname label
	if ( GRI != None )
	{
		LabelString = GetGameModeString(eGEARMP_Wingman) @ "<font color='#999999'>" $ GameToMapConjunction @ GetMapNameString(GRI.GetURLMap()) $ "</font>";	
	}

	return Caps(LabelString);
}

/**
 * Iterates through the PRI array in the GRI, and grabs out the players on that team
 * 
 * @param   TeamIndex   Index of the team to get the players for
 * @param   Player1     PRI of the first player on the team
 * @param   Player2     PRI of the second player on the team
 */
function GetPlayersOnTeam(int TeamIndex, out GearPRI Player1, out GearPRI Player2)
{
	local PlayerReplicationInfo CurrentPRI;

	Player1 = None;
	Player2 = None;

	// Iterate over the PRI array, stopping and saving to one of our two out vars if we find a match
	foreach GRI.PRIArray(CurrentPRI)
	{
		if( CurrentPRI.Team.TeamIndex == TeamIndex )
		{
			if( Player1 == None )
			{
				Player1 = GearPRI(CurrentPRI);
			}
			else
			{
				Player2 = GearPRI(CurrentPRI);
				break;
			}
		}
	}
}

/**
 * Parses through the match history, pulling out kills for this player, and adding the paths to the array
 * 
 * @param   PlayerPRI   PRI of the player to get the kill shots for
 * 
 * @return  Array of strings representing the paths to the headshot textures to load for this player
 */
function array<string> GetHeadshotsForPlayer(GearPRI PlayerPRI)
{
 	local HistoryItem HItem;
	local array<string> RetVal;

	if( PlayerPRI == None )
	{
		RetVal.length = 0;
		return RetVal;
	}

 	// For each player, iterate over the match history and match kills
 	foreach GRI.MatchHistory(HItem)
 	{
 		if (HItem.Initiator == PlayerPRI
 			&& HItem.Initiator.Team != HItem.Target.Team)
 		{
 			RetVal.AddItem( "img://" $ PathName(GearPRI(HItem.Target).PawnClass.default.SmallCharacterHeadshot) );
 		}
 	}

	return RetVal;
}

defaultproperties
{
	LocalScoreboard_ScaleFactor = 1.15f
	LocalScoreboard_TweenTime=0.35f

	ScoreboardFlashDelay=0.3f
	ScoreboardCloseDelay=3.f

	LocalScoreboardDelay=4.f
	LocalScoreboardHeadshotFlashDelay=0.33f

	WidgetBindings.Add((WidgetName=ScoreboardTeam0,WidgetClass=class'GearGame.UIWidget_WingmanTeamInfo'))
	WidgetBindings.Add((WidgetName=ScoreboardTeam1,WidgetClass=class'GearGame.UIWidget_WingmanTeamInfo'))
	WidgetBindings.Add((WidgetName=ScoreboardTeam2,WidgetClass=class'GearGame.UIWidget_WingmanTeamInfo'))
	WidgetBindings.Add((WidgetName=ScoreboardTeam3,WidgetClass=class'GearGame.UIWidget_WingmanTeamInfo'))
	WidgetBindings.Add((WidgetName=ScoreboardTeam4,WidgetClass=class'GearGame.UIWidget_WingmanTeamInfo'))
}
