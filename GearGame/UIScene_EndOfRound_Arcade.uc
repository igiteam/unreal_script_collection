/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIScene_EndOfRound_Arcade.uc
 * End of Chapter summary for Arcade mode
 */

class UIScene_EndOfRound_Arcade extends UIScene_EndOfRound;

const MAX_ENDOFROUND_ARCADE_SCOREBOARDS = 4;

// --- Widget References ---------------------------------------

/** References to the widgets for the actual scoreboard for each player */
var transient UIWidget_ArcadeEOC_PlayerScore    Scoreboards[MAX_ENDOFROUND_ARCADE_SCOREBOARDS];

/** Reference to the GFxObject that contains the animations (keyframe labels) for the Scene. */
var transient GFxObject ScoreboardControl;

// --- Leader Tracking -----------------------------------------

/** Keeps track the current high score for each stat (last value is for total score) */
var transient int   StatLeaders[10];

// --- Misc. Variables -----------------------------------------

/** Reference to the SP GRI for this game.  NOTE:  Super class's GRI is NOT valid for arcade, since it's a SP GRI... */
var transient GearGRI_SP_Arcade ArcadeGRI;

/** Number of players currently in the game */
var transient int   NumPlayers;

/** References to the PRIs for human players in this game */
var transient array<GearPRI_SP>     Players;

/** Number of seconds to leave the menu up before closing */
var float               ScoreboardDisplayTime;
/** Number of seconds the scoreboard has been displayed for so far */
var transient float     CurrentScoreboardDisplayTime;

//==============================================================
// Movie Player function overrides
//==============================================================

/** 
 *  Called when the scene is first opened
 *  
 *  @param  Player  The LocalPlayer that opened this scene, or is responsible for it
 */
function Init(optional LocalPlayer Player)
{
	Super.Init(Player);

	ArcadeGRI = GearGRI_SP_Arcade(class'WorldInfo'.static.GetWorldInfo().GRI);

	// Jump to the appropriate movie state to create enough scoreboards for us
	UpdateNumberOfPlayers();
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
	// Note:  The first frame of the movie is blank, and none of these widgets exist.  Until we tell the movie a frame to jump to with the appropriate number of scoreboards in
	//          UpdateNumberOfPlayers(), these callbacks will not happen.  Since UpdateNumberOfPlayers() fills out the Players[] array before jumping the movie, we should have
	//          references to their corresponding PRIs before these callbacks come in

	switch( WidgetName )
	{
		case 'ScoreboardControl':
			ScoreboardControl = Widget;
			break;
		case 'mc_PlayerScoreboard0':
			Scoreboards[0] = UIWidget_ArcadeEOC_PlayerScore(Widget);
			Scoreboards[0].OwningScoreboard = self;
			SetWidgetPathBinding( Scoreboards[0], WidgetPath );
			if( NumPlayers > 0 )
			{
				Scoreboards[0].SetPlayerPRI( Players[0] );
			}
			break;
		case 'mc_PlayerScoreboard1':
			Scoreboards[1] = UIWidget_ArcadeEOC_PlayerScore(Widget);
			Scoreboards[1].OwningScoreboard = self;
			SetWidgetPathBinding( Scoreboards[1], WidgetPath );
			if( NumPlayers > 1 )
			{
				Scoreboards[1].SetPlayerPRI( Players[1] );
			}
			break;
		case 'mc_PlayerScoreboard2':
			Scoreboards[2] = UIWidget_ArcadeEOC_PlayerScore(Widget);
			Scoreboards[2].OwningScoreboard = self;
			SetWidgetPathBinding( Scoreboards[2], WidgetPath );
			if( NumPlayers > 2 )
			{
				Scoreboards[2].SetPlayerPRI( Players[2] );
			}
			break;
		case 'mc_PlayerScoreboard3':
			Scoreboards[3] = UIWidget_ArcadeEOC_PlayerScore(Widget);
			Scoreboards[3].OwningScoreboard = self;
			SetWidgetPathBinding( Scoreboards[3], WidgetPath );
			if( NumPlayers > 3 )
			{
				Scoreboards[3].SetPlayerPRI( Players[3] );
			}
			break;
		default:
			return FALSE;
	}

	return TRUE;
}


//==============================================================
// Movie Interface functions
//==============================================================

/** Fills out the Players array with references to the players we care about (non-bots on your team), and then jumps the movie to a frame with the correct number of scoreboards */
function UpdateNumberOfPlayers()
{
	local int PRIIdx;
	local GearPRI_SP CurrPRI;

	// Count the number of players we have in the match, and update the players array
	Players.length = 0;
	for (PRIIdx = 0; PRIIdx < ArcadeGRI.PRIArray.length; PRIIdx++)
	{
		CurrPRI = GearPRI_SP(ArcadeGRI.PRIArray[PRIIdx]);
		if (CurrPRI != None &&
			!CurrPRI.bIsInactive &&
			!CurrPRI.bIsSpectator &&
			!CurrPRI.bBot &&
			(CurrPRI.GetTeamNum() == 0) )
		{
			Players.AddItem(CurrPRI);
		}
	}

	// Update the cached value of players
	NumPlayers = Players.Length;

	if( NumPlayers <= 4 )
	{
		`log(">>>>>>>> AnimationControl: " @ ScoreboardControl);
		ScoreboardControl.GotoAndPlay("PlayerCount" $ NumPlayers);
	}
}

/**
 *  Advances the scoreboard, since the world is paused when the arcade EOR scoreboard is up to prevent the world from doing crazy things
 *  
 *  @param  DeltaTime   Time that the movie was advanced
 */
function AdvanceScoreboard(float DeltaTime)
{
	CurrentScoreboardDisplayTime += DeltaTime;

	// If we've lasted through the wait time, then close the menu
	if( CurrentScoreboardDisplayTime >= ScoreboardDisplayTime )
	{
		AllDoneWaitTimeComplete();
	}
}

/**
 *  Determines if the score for the stat index is the leader for a given stat, and updates the StatLeaders if so
 *  
 *  @param  StatIndex   Index of the stat to test (as defined by UIWidget_ArcadeEOC_PlayerScore
 *  @param  StatValue   Value to test to see if it's a new or current record
 *  
 *  @return             TRUE if the stat is the leader, or tied for the lead, FALSE if not
 */
function bool IsPlayerStatLeader(int StatIndex, int StatValue)
{
	// Set the stat leader to the max of the old value and the test value
	StatLeaders[StatIndex] = Max(StatValue, StatLeaders[StatIndex]);
	
	// We are the leader, or tied for the lead if our test value matches the leader value
	return (StatValue == StatLeaders[StatIndex]);
}

defaultproperties
{
	bPauseGameWhileActive=TRUE

	OnPostAdvance=AdvanceScoreboard
	ScoreboardDisplayTime=10.f

	// Widget bindings for the actual scoreboard widgets
	WidgetBindings.Add((WidgetName=mc_PlayerScoreboard0,WidgetClass=class'UIWidget_ArcadeEOC_PlayerScore'))
	WidgetBindings.Add((WidgetName=mc_PlayerScoreboard1,WidgetClass=class'UIWidget_ArcadeEOC_PlayerScore'))
	WidgetBindings.Add((WidgetName=mc_PlayerScoreboard2,WidgetClass=class'UIWidget_ArcadeEOC_PlayerScore'))
	WidgetBindings.Add((WidgetName=mc_PlayerScoreboard3,WidgetClass=class'UIWidget_ArcadeEOC_PlayerScore'))
}