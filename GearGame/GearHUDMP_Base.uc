/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDMP_Base extends GearHUD_Base
	abstract;

var GearGRI_MP GRI;

var localized String RoundString;
var localized String FinalRoundString;
var localized String COGString;
var localized String LocustString;
var localized String VsString;
var localized String WinRoundString;
var localized String WinMatchString;
var localized String FinalKillString;
var localized String FinalSuicideString;
var localized String LeaderKillsString, LeaderPointsString, LeaderDeathsString, LeaderGoalString, LeaderRoundTime;
var localized String LeaderMatchStatus, LeaderMatchTime;
var localized String RoundWasADrawString;

var const float TotalScoreTime;
var float EndRoundSceneDelayTime;
var const float TotalEndRoundTime;

var float DisplayNameTime;
var const float DisplayNameTotalTime;
var bool bDisplayingName;

var localized string ViewingPlayerMsg;

/** The content reference to the GFx movie for the scoreboard */
var const class<UIScene_Scoreboard> ScoreboardPlayerClass;
var transient UIScene_Scoreboard    ScoreboardPlayer;

/** Last known game status when there was a valid GRI */
var byte LastValidGameStatus;
/** The instance reference to the UI scene for the progression scene */
var UIScene_PersonalProgression PPUISceneInstance;

/** stores a MIC to a given player's head icon for use in some HUD displays */
struct PawnHeadMIC
{
	/** PRI of the target */
	var GearPRI PRI;
	/** MIC to draw */
	var MaterialInstanceConstant MIC;
};

event Destroyed()
{
	if ( ScoreboardPlayer != None )
	{
		ScoreboardPlayer.Close(TRUE);
		ScoreboardPlayer = None;
	}

	if (PPUISceneInstance != None)
	{
		PPUISceneInstance.Close();
		PPUISceneInstance = none;
	}

	Super.Destroyed();
}

function GearGRI_MP GetGRI()
{
	if (GRI == None)
	{
		GRI = GearGRI_MP(WorldInfo.GRI);
	}
	return GRI;
}

/** @return true if the game settings dictate that the match is arbitrated */
simulated function bool IsArbitrated()
{
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings GameSettings;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
	}

	// Don't let arbitrated matches quit
	return (GameSettings != None && GameSettings.bUsesArbitration);
}

simulated function bool IsMapCycleTransitioning()
{
	return (GRI != None && GRI.GameStatus == GS_Loading && !IsArbitrated());
}

function bool ShouldDrawTeamColor(PlayerReplicationInfo OtherPRI)
{
	return (OtherPRI.GetTeamNum() <= 1);
}

function DrawHUD()
{
	local GearPC PC;

	PC = GearPC(PlayerOwner);

	if ( !DrawScoreboard() )
	{
		Super.DrawHUD();
	}
	else
	{
		// Allow the hud messages to draw if the end of round screen is open
		if (EndOfRoundSceneIsOpen())
		{
			DrawHUDMessages(0.0f);
		}
	}

	if (bInMultiplayerMode)
	{
		if (PC.IsInState('Reviving') || PC.IsInState('Kidnapped'))
		{
			// make sure we can draw the button mash action icon
			DrawActions(RenderDelta);
		}
	}
}

function DrawActions(float DeltaTime)
{
	if (!EndOfRoundSceneIsOpen())
	{
		Super.DrawActions(DeltaTime);
	}
}

/** See if we should open or close the scoreboard */
function bool DrawScoreboard()
{
	local bool bShowScoreboard, bDrewEndRound, bDrewScoreboard;
	local bool bForceClose;

	// Cache the value in class variable GRI
	GetGRI();

	// First try and draw the start/end round UI
	if ( GRI != None )
	{
		bDrewEndRound = EndOfRoundSceneIsOpen();
		bDrewScoreboard = bDrewEndRound;
		LastValidGameStatus = GRI.GameStatus;
	}

	// See if the scoreboard should be gone
 	if (LastValidGameStatus == GS_Loading && !bDrewEndRound)
 	{
 		bShowScoreboard = WorldInfo.IsInSeamlessTravel();
 	}
 	else if ( GRI == None || bRestrictScoreboard || bDrawOverheadMPMap || bDrewEndRound || ProgressionSceneIsOpen() || UI_PauseSceneInstance != None
		 || (GRI.RoundTime == 0 && GRI.GameStatus != GS_RoundInProgress) || WorldInfo.GRI == None || WorldInfo.GRI.PRIArray.length == 0 )
	{
		bShowScoreboard = false;
	}
	// See if the scoreboard should be shown
	else if ( ShouldShowScoreboardBasedOnGameStatus() || bShowScores )
	{
		bShowScoreboard = true;
	}

	// Open or close the scoreboard
	if ( bShowScoreboard )
	{
		OpenScoreboardScene();
		bDrewScoreboard = true;
	}
	else
	{
		// If we are in the middle of the game we will not force close the scoreboard
		// we will just hide it instead
		if (WorldInfo.GRI != None &&
			GearGRI(WorldInfo.GRI).GameStatus != GS_RoundInProgress)
		{
			bForceClose = TRUE;
		}
		CloseScoreboardScene(bForceClose);
	}

	return bDrewScoreboard;
}

/** Uses the game status to determine if the scoreboard should be showing or not */
function bool ShouldShowScoreboardBasedOnGameStatus()
{
	if ( GRI != None && GearGRI(WorldInfo.GRI).GameStatus != GS_RoundInProgress )
	{
		return true;
	}

	return false;
}

/**
* bUseAtoContinueVersion - whether to show the "Press A to Continue" string or not... if not
* then the "B Back" string shows instead.
*/

function ToggleScoreboard(bool bOn)
{
	bShowScores = bOn;
}

/** Whether the show the hud or not based on screens showing in front of it */
function bool HideHUDFromScenes()
{
	return (Super.HideHUDFromScenes() ||
			(ScoreboardPlayer != none && ScoreboardPlayer.bIsVisible) ||
			PPUISceneInstance != none);
}

/** Open the scoreboard scene */
final function OpenScoreboardScene()
{
	// Spawn a new instance of the scoreboard if this is the first time, or call the opening sequence for fading in the scoreboard if one already exists
	if( ScoreboardPlayer == None )
	{
		ScoreboardPlayer = new(self) ScoreboardPlayerClass;
		ScoreboardPlayer.Init(LocalPlayer(PlayerOwner.Player));
	}
	else
	{
		ScoreboardPlayer.OpenScoreboard();
	}
}

/** Close the scoreboard scene */
final function CloseScoreboardScene(bool bForceClosed)
{
	if( ScoreboardPlayer != None )
	{
		// Do a hide of the scoreboard, which will stop updating, but not actually remove the instance
		ScoreboardPlayer.HideScoreboard();

		if( bForceClosed )
		{
			// Close and hide the scoreboard immediately, no transition out
			ScoreboardPlayer.Callback_FadeOutComplete();
			bShowScores = FALSE;
		}
	}
}

/**
 * Possibly draw the overhead map
 *
 * @return TRUE if the map was drawn, FALSE if not
 */
protected function bool MaybeDrawOverheadMPMap()
{
	local bool bDrewOverheadMap;

	bDrewOverheadMap = Super.MaybeDrawOverheadMPMap();

	if( bDrewOverheadMap && ScoreboardPlayer != None )
	{
		CloseScoreboardScene(FALSE);
	}

	return bDrewOverheadMap;
}

/**
 * Make sure the GRI has been replicated to this player before opening this scene.  This could happen if a player comes in late to the game and the end of round screen opens before
 * the replication of the GRI happens.
 *
 * Overloaded here to add in a check that the game status is GS_EndMatch, which is invalid in arcade mode
 *
 * @return TRUE if the GRI is valid, and allows for the EOR scene to be up, FALSE if not
 */
function bool DoesGRIAllowEndOfRoundScene()
{
	return ( ((GearGRI(WorldInfo.GRI) != None && GearGRI(WorldInfo.GRI).GameStatus == GS_EndMatch )	|| (WorldInfo.GRI != None && WorldInfo.GRI.PRIArray.length >= 1)) );
}

/**
 *  Open the EndOfRound scene
 */
function OpenEndOfRoundScene()
{
	Super.OpenEndOfRoundScene();

	// Make sure the normal scoreboard is down when opening up the EOR scene
	CloseScoreboardScene(TRUE);
}

/**
 *  Close the EndOfRound scene
 *
 *  @return Whether or not there will be a personal progression scene shown
 */
function bool CloseEndOfRoundScene()
{
	local bool bWillShowPPScene;

	// If this is not the post-game wingman scoreboard, then close it as normal.  Wingman keeps the EOR up during travel
	if( GRI == None || !ClassIsChildOf(GRI.GameClass, class'GearGameWingman_Base') || (GRI.GameStatus < GS_EndMatch) )
	{
		Super.CloseEndOfRoundScene();
	}

	bWillShowPPScene = OpenProgressionScene();

	// If we are showing the PP scene, hide the end of round player
	if( bWillShowPPScene && EndRoundUIScenePlayerInstance != None )
	{
		EndRoundUIScenePlayerInstance.GetVariableObject("_root").SetBool("_visible", FALSE);
	}

	return bWillShowPPScene;
}

/** Open the Progression scene
 *  @return Whether or not there will be a personal progression scene shown
 */
final function bool OpenProgressionScene()
{
	local bool bWillShowPPScene;
	local GearGRI_MP GRIMP;
	local class<GearGameMP_Base> GGameClass;

	GRIMP = GetGRI();

	if (GRIMP != None && GRIMP.GameStatus == GS_EndMatch )
	{
		GGameClass = class<GearGameMP_Base>(GRIMP.GameClass);
		if (GGameClass != none)
		{
			GRIMP.ResetRoundClock(GGameClass.default.EndOfGameDelay);
		}
		CloseScoreboardScene(TRUE);
		if (GGameClass.default.MPResourceClass != none &&
			GGameClass.default.MPResourceClass.default.PPUISceneClass != None)
		{
			PPUISceneInstance = new(self) GGameClass.default.MPResourceClass.default.PPUISceneClass;
			PPUISceneInstance.Init();
			bWillShowPPScene = true;
		}
	}

	return bWillShowPPScene;
}

/** Close the Progression scene */
function CloseProgressionScene()
{
	if ( PPUISceneInstance != None )
	{
		PPUISceneInstance.Close();
		PPUISceneInstance = None;

		// If this is wingman, make the EOR scoreboard visible again
		if( GRI != None && ClassIsChildOf(GRI.GameClass, class'GearGameWingman_Base') && (EndRoundUIScenePlayerInstance != None) )
		{
			EndRoundUIScenePlayerInstance.GetVariableObject("_root").SetBool("_visible", TRUE);
		}
		// Otherwise, open up the scoreboard after the personal progression screen closes
		else
		{
			OpenScoreboardScene();
		}
	}
}

/** Whether the Progression scene is drawing or not */
final function bool ProgressionSceneIsOpen()
{
	return (PPUISceneInstance != None);
}

/** Sets a timer to close the end of round scene */
function SetCloseEndOfRoundSceneTimer()
{
	SetTimer( TotalEndRoundTime, FALSE, nameof(CloseEndOfRoundScene) );
}

function SignalEndofRoundOrMatch(GearGRI CurGRI)
{
	//We need this timer even if we don't show the end of round scene, since otherwise we won't get the progression scene
	SetCloseEndOfRoundSceneTimer();

	// Don't show the who won on the server if there was a network error
	if (WorldInfo.Game != None && WorldInfo.Game.bHasNetworkError)
	{
		return;
	}

	if (CurGRI.GameStatus == GS_EndMatch || EndRoundSceneDelayTime <= 0.0)
	{
		OpenEndOfRoundScene();
	}
	else
	{
		SetTimer(EndRoundSceneDelayTime, false, nameof(OpenEndOfRoundScene));
	}
}

function SignalStartofRoundOrMatch(GearGRI CurGRI)
{
	// Don't show if there's a network error
	if (WorldInfo.Game != None && WorldInfo.Game.bHasNetworkError)
	{
		return;
	}
}

/** Overridden to handle MP special cases */
simulated function bool UpdateCountdown()
{
	local GearGRI_MP GGRI;
	local bool bDoingMPTimeExpiring;

	GGRI = GearGRI_MP(WorldInfo.GRI);

	// See if we should start the countdown for an MP game expiring
	if (bInMultiplayerMode &&
		GGRI != None &&
		GGRI.GameStatus == GS_RoundInProgress &&
		!GGRI.bInfiniteRoundDuration &&
		GGRI.RoundTime > 0 && GGRI.RoundTime <= 60 )
	{
		if (!CountdownTimerIsShowing())
		{
			GearPC(PlayerOwner).StartCountdownTime(GGRI.RoundTime);
		}
		bDoingMPTimeExpiring = TRUE;
	}

	if (CountdownTimerIsShowing())
	{
		// Stop tutorial system if the timer just started
		if (!bDrewCountdownLastFrame &&
			GGRI.TrainingGroundsID > 0)
		{
			GearPC(PlayerOwner).StopTutorialSystem();
		}
		bDrewCountdownLastFrame = TRUE;

		if (bDoingMPTimeExpiring)
		{
			CountdownTimeToDraw = max(GGRI.RoundTime, 0.0f);
		}
		else if (CountdownStopTime <= 0.0f)
		{
			CountdownTimeToDraw = max(CountdownEndTime - WorldInfo.TimeSeconds, 0.0f);
		}

		return DrawCountdown();
	}
	else if (bDrewCountdownLastFrame)
	{
		// Restart the tutorial system if the timer just expired
		GearPC(PlayerOwner).RestartTutorialSystem(GearPC(PlayerOwner).bTutorialSystemWasOn);
		bDrewCountdownLastFrame = FALSE;
	}

	return FALSE;
}

/** Allow the HUD to close any scenes or cleanup any UI for when the pause screen is opened */
function CleanUIForPauseScreen()
{
	CloseScoreboardScene(TRUE);
}

defaultproperties
{
	TotalScoreTime=3.f

	TotalEndRoundTime=5.f;

	DisplayNameTime=0.f
	DisplayNameTotalTime=2.f
	bDisplayingName=false
	bDrawKillPoints=true
}

