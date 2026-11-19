/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_EndOfRound_Wave extends UIScene_EndOfRound
	dependson(UIWidget_EORPlayerScoreboardList);

/** Delay after the score total finishes ticking up before the scoreboard closes */
var float               ScoreboardCloseDelay;

/** Delay between flashing in entries on the final scoreboard */
var float               ScoreboardFlashDelay;

/** Stores the index of the scoreboard entry to activate next when cycling through the player list */
var transient int	    ScoreboardIndexToActivate;

/** Team index of the player */
var int                 PlayerTeamNum;

/** PRI of the locally controlled player */
var transient GearPRI   LocalPRI;

/** Index of the locally controlled player in the scoreboard, so we can blend the player info into the appropriate scoreboard slot */
var transient int       LocalPlayerScoreboardIndex;

/** Number of players left alive on the team.  Valid after bEndOfRoundInitialized == true */
var transient int       NumPlayersAlive;

/** Number of players in the game.  Valid after bEndOfRoundInitialized == true */
var transient int       NumPlayersInGame;

/** If TRUE, the COG logo will be used for the scoreboard.  If FALSE, the locust logo will be used */
var bool                bUseCogGameLogo;

/** Localized strings used in end of round scoreboard */
var localized string    GameNameString;
var localized string    WaveHeaderString;
var localized string    HordeDefeated;
var localized string    WaveComplete;
var localized string    WaveIncomplete;
var localized string    TokensEarnedText;

var localized string    TeamScoreString;
var localized string    SurvivalBonusString;
var localized string    DifficultyString;
var localized string    WaveScoreString;

/** Reference to the original _root for this Scene which was converted into a bag. */
var transient protected	GFxObject	SiegeEOR;

/** --- Header Widgets --------------------------------- */
var transient protected   GFxObject   lbl_GameType;
var transient protected   GFxObject   lbl_WaveInfo;
var transient protected   GFxObject   lbl_RoundTime;
var transient protected   GFxObject   mc_WaitForHost;
var transient protected   GFxObject   img_GameIcon;
var transient protected   UIWidget_EORPlayerScoreInfo   mc_FloatingPlayerScore;

/** --- Team Scoreboard Widgets ------------------------ */
var transient protected   UIWidget_EORPlayerScoreboardList ScoreboardWidget;

/** --- Score Summary Widgets ---------------------------*/
var transient protected   GFxObject   lbl_TokensEarned;

var transient protected   GFxObject   mc_TeamScoreContainer;
var transient protected   GFxObject   lbl_TeamScoreText;
var transient protected   GFxObject   lbl_TeamScore;

var transient protected   GFxObject   mc_SurvivalContainer;
var transient protected   GFxObject   lbl_SurvivalText;
var transient protected   GFxObject   lbl_Survival;

var transient protected   GFxObject   mc_DifficultyContainer;
var transient protected   GFxObject   lbl_DifficultyText;
var transient protected   GFxObject   lbl_Difficulty;

var transient protected   GFxObject   mc_WaveScoreContainer;
var transient protected   GFxObject   lbl_WaveScoreText;
var transient protected   GFxObject   lbl_WaveScore;

var transient protected   GFxObject   mc_TotalScoreContainer;
var transient protected   GFxObject   lbl_TotalScore;


event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local string WidgetPathString;

	// --- Handle the score text widgets -------------
	if( WidgetName == 'lbl_ScoreText' )
	{
		WidgetPathString = string(WidgetPath);

		if( InStr(WidgetPathString, "waveScore") != INDEX_NONE )
		{
			lbl_WaveScoreText = Widget;
			mc_WaveScoreContainer = GetVariableObject("_root.SiegeEOR_SP.SiegeEOR_Panel.SiegeEOR.EOR_Panel.bottomRackup.waveScore");
		}
		else if( InStr(WidgetPathString, "difficulty") != INDEX_NONE )
		{
			lbl_DifficultyText = Widget;
			mc_DifficultyContainer = GetVariableObject("_root.SiegeEOR_SP.SiegeEOR_Panel.SiegeEOR.EOR_Panel.bottomRackup.difficulty");
		}
		else if( InStr(WidgetPathString, "survival") != INDEX_NONE )
		{
			lbl_SurvivalText = Widget;
			mc_SurvivalContainer = GetVariableObject("_root.SiegeEOR_SP.SiegeEOR_Panel.SiegeEOR.EOR_Panel.bottomRackup.survival");
		}
		else if( InStr(WidgetPathString, "teamScore") != INDEX_NONE )
		{
			lbl_TeamScoreText = Widget;
			mc_TeamScoreContainer = GetVariableObject("_root.SiegeEOR_SP.SiegeEOR_Panel.SiegeEOR.EOR_Panel.bottomRackup.teamScore");
		}
		else
		{
			`log("UIScene_EndOfRound:  Unhandled widget " $ WidgetName $ "(" $ WidgetPath $ ")",, 'GearUI');
			return FALSE;
		}
	}
	// --- Handle the score spinner widgets ----------
	else if( WidgetName == 'lbl_score' )
	{
		WidgetPathString = string(WidgetPath);

		if( InStr(WidgetPathString, "waveScore") != INDEX_NONE )
		{
			lbl_WaveScore = Widget;
		}
		else if( InStr(WidgetPathString, "difficulty") != INDEX_NONE )
		{
			lbl_Difficulty = Widget;
		}
		else if( InStr(WidgetPathString, "survival") != INDEX_NONE )
		{
			lbl_Survival = Widget;
		}
		else if( InStr(WidgetPathString, "teamScore") != INDEX_NONE )
		{
			lbl_TeamScore = Widget;
		}
		else
		{
			`log("UIScene_EndOfRound:  Unhandled widget " $ WidgetName $ "(" $ WidgetPath $ ")",, 'GearUI');
			return FALSE;
		}
	}
	// --- Handle all top-level widgets --------------
	else
	{
		switch( WidgetName )
		{
			case 'SiegeEOR':
				SiegeEOR = Widget;
				break;
			case 'mc_WaitForHost':
				mc_WaitForHost = Widget;
				break;
			case 'lbl_RoundTime':
				lbl_RoundTime = Widget;
				break;
			case 'lbl_GameType':
				lbl_GameType = Widget;
				break;
			case 'lbl_WaveInfo':
				lbl_WaveInfo = Widget;
				break;
			case 'lbl_TokensSpent':
				lbl_TokensEarned = Widget;  // Note:  poor naming
				break;
			case 'img_GameIcon':
				img_GameIcon = Widget;
				break;
			case 'lbl_TotalScore':
				lbl_TotalScore = Widget;
				mc_TotalScoreContainer = GetVariableObject("_level0.SiegeEOR_SP.SiegeEOR_Panel.SiegeEOR.EOR_Panel.bottomRackup.totalScore");
				break;
			case 'mc_PlayerList':
				ScoreboardWidget = UIWidget_EORPlayerScoreboardList(Widget);
				break;
			case 'mc_FloatingPlayerScore':
				mc_FloatingPlayerScore = UIWidget_EORPlayerScoreInfo(Widget);
				break;
			default:
				`log("UIScene_EndOfRound:  Unhandled widget " $ WidgetName $ "(" $ WidgetPath $ ")",, 'GearUI');
				return FALSE;
		}
	}

	return TRUE;
}

/** Called after all scoring events are finished.  Closes the scene, and starts the next wave on the host */
function AllDoneWaitTimeComplete()
{
	local GearGameMP_Base Game;
	local GearPC MyGearPC;
	local GearHUDInvasion_Base WaveHUD;
	local ASDisplayInfo DI;

	bIsPendingClose = TRUE;

	Game = GearGameMP_Base(GRI.WorldInfo.Game);
	// If this is the end of the wave/match and everyone died the host will display an option menu while the clients wait
	if ( GRI.GameStatus >= GS_RoundOver && GRI.Winner.GetTeamNum() != PlayerTeamNum )
	{
		if ( GRI.Role == ROLE_Authority )
		{
			if (Game != None && !Game.bUsingArbitration)
			{
				WaveHUD = GearHUDInvasion_Base(GetPC().myHUD);
				if( WaveHUD != None )
				{
					WaveHUD.ShowGameOverScreen("", None);
				}

				Close();
			}
			else
			{
				Game.TellClientsToReturnToPartyHost();
			}

			//Go straight to the next round, do not show the scoreboard.
			GRI.ResetRoundClock(0);
		}
		else
		{
			DI = mc_WaitForHost.GetDisplayInfo();
			DI.Visible = TRUE;
			mc_WaitForHost.SetDisplayInfo(DI);
		}
	}
	else
	{
		MyGearPC = GetGearPC();
		// start the next wave immediately after the host's menu is done
		if (GRI.Role == ROLE_Authority)
		{
			// Start the next wave for the specific gametype
			ImmediateStartNextWave(Game);
		}

		if (MyGearPC != none && MyGearPC.MyGearHud != none)
		{
			GearHUDMP_Base(MyGearPC.MyGearHud).CloseEndOfRoundScene();
		}
	}
}

/** Immediately starts the next wave with the appropriate gametype */
function ImmediateStartNextWave(GearGameMP_Base Game);

/** Hook for marking profile data related to wave completion */
function MarkWaveAsCompleted(int WaveIndex);

//==============================================================
// Label and image accessors
//==============================================================
function InitializeWidgetValues()
{
	local string StringToDraw;
	local int WaveNumber;
	local int PRIIdx, SortedIdx;
	local array<GearPRI> SortedPRIs;
	local GearPRI CurrPRI;
	local ASDisplayInfo DI;

	ScoreboardIndexToActivate = 0;

	// Find all of the players and sort them from highest to lowest scores
	for (PRIIdx = 0; PRIIdx < GRI.PRIArray.length; PRIIdx++)
	{
		if (GRI.PRIArray[PRIIdx] != None && !GRI.PRIArray[PRIIdx].bIsInactive)
		{
			CurrPRI = GearPRI(GRI.PRIArray[PRIIdx]);

			if( (LocalPRI == None) && (CurrPRI.Owner != None) && GearPC(CurrPRI.Owner).IsLocalPlayerController() )
			{
				// Store off the local player's PRI, when encountered
				LocalPRI = CurrPRI;
			}

			if ( (CurrPRI.GetTeamNum() == PlayerTeamNum) && (CurrPRI.SquadName != 'Fortification') && !CurrPRI.bBot )
			{
				for (SortedIdx = 0; SortedIdx < SortedPRIs.length; SortedIdx++)
				{
					if (GetPlayerSortScore(CurrPRI) > GetPlayerSortScore(SortedPRIs[SortedIdx]))
					{
						SortedPRIs.InsertItem(SortedIdx, CurrPRI);
						break;
					}
				}

				// Didn't find a place to insert so append
				if (SortedIdx >= SortedPRIs.length)
				{
					SortedPRIs.AddItem(CurrPRI);
				}

				// Keep track of how many are alive
				if (!CurrPRI.bIsDead && !CurrPRI.bIsSpectator)
				{
					NumPlayersAlive++;
				}
				NumPlayersInGame++;
			}
		}
	}

	// --- Local player score information ------------
	LocalPlayerScoreboardIndex = SortedPRIs.Find(LocalPRI);

	// Update the local player's singleton scoreboard
	BeginSpin_LocalPlayerInfo();

	// --- Header Information ------------------------
	// Set the game type description
	lbl_GameType.SetText(GameNameString);

	// Waiting for host label
	DI = mc_WaitForHost.GetDisplayInfo();
	DI.Visible = FALSE;
	mc_WaitForHost.SetDisplayInfo(DI);

	// Wave Status
	WaveNumber = (GearGRI_Horde(GRI).ExtendedRestartCount * class'GearGameHorde_Base'.default.MaxWaves) + GearGRI_Horde(GRI).InvasionCurrentWaveIndex;
	StringToDraw = WaveHeaderString @ WaveNumber;
	StringToDraw $= "<font color='#787878'>";
	if (GRI.Winner.GetTeamNum() == PlayerTeamNum)
	{
		if (WaveNumber >= 50)
		{
			StringToDraw @= HordeDefeated;
		}
		else
		{
			StringToDraw @= WaveComplete;
		}

		/* Mark profile completion (0 based) */
		MarkWaveAsCompleted(WaveNumber-1);
	}
	else
	{
		StringToDraw @= WaveIncomplete;
	}
	StringToDraw $= "</font>";
	lbl_WaveInfo.SetBool("html", TRUE);
	lbl_WaveInfo.SetString("htmlText", StringToDraw);

	// Time label
	lbl_RoundTime.SetText( FormatTime(GRI.RoundEndTime) );

	// Tokens spent
	if( !ShouldShowTokensEarned() )
	{
		DI = lbl_TokensEarned.GetDisplayInfo();
		DI.Visible = FALSE;
		lbl_TokensEarned.SetDisplayInfo(DI);
	}

	// Game icon
	SetGameLogo(bUseCogGameLogo);

	// Update the scoreboard widget
	PopulateScoreboardData(SortedPRIs);


	// --- Total score values -------------------------
	// Set the initial value for the score, which we'll blend up from
	lbl_TotalScore.SetText( CreateThousandsSeparatedString(int(GearTeamInfo(GRI.Teams[PlayerTeamNum]).TotalScore - GearTeamInfo(GRI.Teams[PlayerTeamNum]).Score)) );
}

/**
 *  Sets the logo for the upper left of the EOR scoreboard
 *
 *  @param  bIsCOG  If TRUE, the COG logo will be displayed, if FALSE, the locust logo will be displayed
 */
function SetGameLogo(bool bIsCog)
{
	SiegeEOR.ActionScriptVoid("SetGameLogo");
}

//==============================================================
// Spinup Callbacks
//==============================================================
delegate SpinupCallback();

/** Sets a callback function to fire off when the spinup of a score label is complete */
function SetSpinupCompleteCallbackOn(GFxObject SpinupObject, delegate<SpinupCallback> Callback)
{
	ActionScriptSetFunction(SpinupObject, "SpinupComplete");
}

/** Sets the kill count tally up finished callback */
function SetKillTallyCompleteCallback(delegate<SpinupCallback> Callback)
{
	ActionScriptSetFunction(mc_FloatingPlayerScore, "FinishedKillCountup");
}

/** Sets the callback for when the local player's score has blended into the main list */
function SetLocalPlayerToScoreboardCallback(delegate<SpinupCallback> Callback)
{
	ActionScriptSetFunction(mc_FloatingPlayerScore, "BlendPlayerScoreIntoScoreboardComplete");
}

function BeginSpin_LocalPlayerInfo()
{
	local ASDisplayInfo DI;

	if( LocalPlayerScoreboardIndex != INDEX_NONE )
	{
		// Make the player visible
		DI = mc_FloatingPlayerScore.GetDisplayInfo();
		DI.Visible = TRUE;
		mc_FloatingPlayerScore.SetDisplayInfo(DI);

		mc_FloatingPlayerScore.GotoAndPlay("on");

		// Fires off when the kill count tally up is completed
		SetKillTallyCompleteCallback(KillTallyComplete);

		// Set up the game-specific information for the floating scoring panel
		SetLocalPlayerFloatingScoreInfo();
	}
	else
	{
		// Immediately begin counting through the scoreboard entries
		ActivateNextScoreboardIndex();
	}
}

function KillTallyComplete()
{
	// All done with scoring effects, set the timer to close the scene and move on
	GetPC().SetTimer(2.f, FALSE, nameof(BeginBlend_LocalPlayerToScoreboard), self);
}

function BeginBlend_LocalPlayerToScoreboard()
{
	SetLocalPlayerToScoreboardCallback(ActivateNextScoreboardIndex);

	InternalBeginBlend_LocalPlayerToScoreboard(LocalPlayerScoreboardIndex);
}

function InternalBeginBlend_LocalPlayerToScoreboard(int PlayerPosition)
{
	ActionScriptVoid("_global.BlendPlayerScoreIntoScoreboard");
}

function ActivateNextScoreboardIndex()
{
	if( ScoreboardIndexToActivate < 5 )
	{
		if( (mc_FloatingPlayerScore != None) && (ScoreboardIndexToActivate == LocalPlayerScoreboardIndex) )
		{
			// If this is the local player's index, flash the local player's floating score and continue
			mc_FloatingPlayerScore.GotoAndPlay("on");
		}
		else
		{
			// Activate the next scoreboard entry in the sequence if this is not the local player
			InternalActivateScoreboardIndex(ScoreboardIndexToActivate);
		}

		ScoreboardIndexToActivate++;
		PlaySoundFromTheme('Bonus');

		if( !GetPC().IsTimerActive(nameof(ActivateNextScoreboardIndex), self) )
		{
			// Set the timer, if not already set
			GetPC().SetTimer(ScoreboardFlashDelay, TRUE, nameof(ActivateNextScoreboardIndex), self);
		}
	}
	else
	{
		// We're done, move on to the next!
		GetPC().SetTimer(0.f, FALSE, nameof(ActivateNextScoreboardIndex), self);
		BeginSpin_WaveProgress();
	}
}

function InternalActivateScoreboardIndex(int Index)
{
	ActionScriptVoid("_global.ActivateScoreboardIndex");
}

function BeginSpin_WaveProgress()
{
	PlaySoundFromTheme('Bonus');

	SetSpinupCompleteCallbackOn(lbl_TeamScore, BeginSpin_Survival);

	lbl_TeamScoreText.SetText(TeamScoreString);
	lbl_TeamScore.SetFloat("GoalValue", GetTeamWaveScore(true, true));
	mc_TeamScoreContainer.GotoAndPlay("rackup");
}

function BeginSpin_Survival()
{
	local int Score;

	PlaySoundFromTheme('Bonus');

	mc_TeamScoreContainer.GotoAndPlay("done");

 	SetSpinupCompleteCallbackOn(lbl_Survival, BeginSpin_Difficulty);

	Score = GetSurvivalBonus();
	lbl_SurvivalText.SetText( SurvivalBonusString  $ ((Score>0) ? " [" $ GetSurvivalBonusQualifier() $ "]:" : ":") );
 	lbl_Survival.SetFloat("GoalValue", GetSurvivalBonus());
	mc_SurvivalContainer.GotoAndPlay("rackup");
}

function BeginSpin_Difficulty()
{
	PlaySoundFromTheme('Bonus');

	mc_SurvivalContainer.GotoAndPlay("done");

	SetSpinupCompleteCallbackOn(lbl_Difficulty, BeginSpin_WaveScore);

	lbl_DifficultyText.SetText(DifficultyString);
	lbl_Difficulty.SetString("PrependString", GetDifficultyMultiplierDescription() @ "x");
	lbl_Difficulty.SetFloat("GoalValue", GetDifficultyMultiplier());
	mc_DifficultyContainer.GotoAndPlay("rackup");
}

function BeginSpin_WaveScore()
{
	PlaySoundFromTheme('Bonus');

	mc_DifficultyContainer.GotoAndPlay("done");

 	SetSpinupCompleteCallbackOn(lbl_WaveScore, BeginSpin_TotalScore);

	lbl_WaveScoreText.SetText(WaveScoreString);
 	lbl_WaveScore.SetFloat("GoalValue", GetTeamWaveScore(false, false));
	mc_WaveScoreContainer.GotoAndPlay("rackup");
}

function BeginSpin_TotalScore()
{
	local GearTeamInfo GTI;
	local array<ASValue> args;
	local ASValue argval;

	PlaySoundFromTheme('Bonus');

	SetSpinupCompleteCallbackOn(lbl_TotalScore, ScoringComplete);

	mc_WaveScoreContainer.GotoAndPlay("done");
	mc_TotalScoreContainer.GotoAndPlay("rackup");

	GTI = GearTeamInfo(GRI.Teams[PlayerTeamNum]);

	// Initial value
	argval.Type = AS_Number;
	argval.n = GTI.TotalScore - GTI.Score;
	args.AddItem(argval);

	// Current value to spin to
	argval.Type = AS_Number;
	argval.n = GTI.TotalScore;
	args.AddItem(argval);

	// Tell the spinner to spin up over the specified range
	lbl_TotalScore.Invoke("SpinupFromValue", args);
}

function ScoringComplete()
{
	PlaySoundFromTheme('Bonus');
	mc_TotalScoreContainer.GotoAndPlay("done");

	if( ScoreboardCloseDelay >= 0.f )
	{
		// All done with scoring effects, set the timer to close the scene and move on
		GetPC().SetTimer(ScoreboardCloseDelay, FALSE, nameof(AllDoneWaitTimeComplete), self);
	}
	else
	{
		// No delay set, go directly to the all done function
		AllDoneWaitTimeComplete();
	}
}

//==============================================================
// Scoring Functions
//==============================================================

/** Gets the score used for sorting the players from top to bottom */
function int GetPlayerSortScore(GearPRI Player)
{
	return Player.GetGameScore2();
}

/** Sets up the game-specific info for the floating scoreboard widget with the local player's score */
function SetLocalPlayerFloatingScoreInfo();

/** Sets up the game-specific info for the list of players in the scoreboard */
function PopulateScoreboardData(array<GearPRI> SortedPRIs);

/** If TRUE, this EOR board needs to have the tokens spent label visible */
function bool ShouldShowTokensEarned()
{
	return FALSE;
}

/** Returns the team score with the option to remove bonuses and multipliers */
function int GetTeamWaveScore( bool bRemoveDifficulty, bool bRemoveSurvival )
{
	local int ScoreResult;

	ScoreResult = GRI.Teams[PlayerTeamNum].Score;

	if (bRemoveDifficulty)
	{
		ScoreResult /= GetDifficultyMultiplier();
	}

	if (bRemoveSurvival)
	{
		ScoreResult -= GetSurvivalBonus();
	}

	return ScoreResult;
}

function int GetSurvivalBonus()
{
	local class<GearGameSiege_Base> SiegeClass;

	if( GRI.Winner.GetTeamNum() == PlayerTeamNum )
	{
		// The team won, grab the bonus!
		SiegeClass = class<GearGameSiege_Base>(GRI.GameClass);
		return (SiegeClass.default.MaxTimeBonus * FMax(0.0, float(SiegeClass.default.RoundDuration - GRI.RoundEndTime) / float(SiegeClass.default.RoundDuration)));
	}
	else
	{
		// If the team failed the wave, there is no bonus...
		return 0;
	}
}

/** Returns a qualifier for the description of the survival bonus (seconds, number of players left alive, etc */
function string GetSurvivalBonusQualifier();

/** Get Difficulty Multiplier description string */
function string GetDifficultyMultiplierDescription()
{
	return GearGRI_Horde(GRI).EnemyDifficulty.default.DifficultyName;
}

/** Returns the Difficulty Multiplier earned this wave */
function int GetDifficultyMultiplier()
{
	 return GearGRI_Horde(GRI).EnemyDifficulty.default.HordeScoreMultiplier;
}

defaultproperties
{
	ScoreboardCloseDelay=3.f
	ScoreboardFlashDelay=0.3f

	WidgetBindings(0)=(WidgetName=mc_PlayerList,WidgetClass=class'UIWidget_EORPlayerScoreboardList')
	WidgetBindings(1)=(WidgetName=mc_FloatingPlayerScore,WidgetClass=class'UIWidget_EORPlayerScoreInfo')
}
