/**
 * GearHUD_Base
 * Gear Heads Up Display
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDInvasion_Base extends GearHUDMP_Base
	abstract
	config(Game);

/** Time when ai factory informed us of last killed spawn */
var float TimeOfLastKilledSpawn;
/** world time the current wave began */
var float WaveStartTime;

var float LastScore, LastCash;

/** last time displayed for the deployment phase countdown, for playing sounds when it nears zero */
var int LastDeploymentCountdownTime;
/** the sound to play as the deployment phase is ending */
var SoundCue DeploymentCountdownBeepSound;

/** Localized strings for displaying the beginning of wave text */
var localized string BeginWaveTitle, BeginWaveMessage;
var localized string BeginMiniBossWaveMessage, BeginBossWaveMessage;
var localized string HUDWaveString;
var localized string ScoreString;
var localized string CashString;
var localized string EnemiesString;
var localized string BuyBackText, BuyBackCantAffordText;

/** Stinger to play when a new round starts */
var SoundCue BeginRoundStinger;
/** Stinger to play when a round is beat */
var array<SoundCue> EndRoundSuccessStingers;
var SoundCue EndRoundStingerFailed;

/** HUD score BG */
var CanvasIcon ScoreBG;
/** HUD progress bar */
var CanvasIcon ProgressBar;
/** Wave display BG */
var CanvasIcon WaveBG;
/** cash display BG */
var CanvasIcon CashBG;
/** Top padding between the BG and the elements within it */
var const int BGPaddingTop;
/** Left padding between the BG and the elements within it */
var const int BGPaddingLeft;
/** Right padding between the BG and the elements within it */
var const int BGPaddingRight;
/** Vertical pixel location of the Score in relation to the BG */
var const int ScorePositionV;
/** Vertical pixel location of the enemy count in relation to the BG */
var const int EnemyPositionV;
/** vertical pixel location of the cash display in relation to the BG */
var const int CashPositionV;

/** Draw Progress Bar Size that tries to approach the actual; provides smooth animation of progress bar */
var int DrawProgressBarSize;

/** Content reference for the poisons scene */
var class<UIScene_HordePoisons> PoisonsPlayerClass;
var transient UIScene_HordePoisons PoisonsPlayerInstance;
var config float PoisonSceneDisplayTime;

/** Played when the horde mod scene is opened **/
var SoundCue HordeStrongerSound;
/** played when starting a boss wave */
var SoundCue BossWaveSound;
/** played when a new bonus objective is added */
var SoundCue BonusObjectiveSound;
/** sound played every time player reaches certain cash intervals */
var SoundCue CashAcquiredSound;

/** used to render text showing current Cash */
var FontRenderInfo CashRenderInfo;

/** The localized string to prepend to the high score announcement */
var localized string HighScoreString;

event Destroyed()
{
	Super.Destroyed();

	CloseHordeModScene();
}


// Called by the super class so we can draw to the canvas.
function DrawHUD()
{
	local GearPC PC;

	// Set the GRI
	GetGRI();

	// Draw the scoreboard
	if (!DrawScoreboard() && !HideHUDFromScenes() && bShowHUD)
	{
		// If we didn't draw the scoreboard then draw the enemy count
		DrawStatusDisplay();

		// allow the deployment phase countdown to draw even while the next wave announcement is being drawn
		if (IsDramaticTextDrawing())
		{
			UpdateCountdown();
		}

		// always show bonus when spectating
		PC = GearPC(PlayerOwner);
		if (PC.IsSpectating() && PC.ObjectiveMgr.Objectives.length > 0)
		{
			DrawObjectives(1.0, true);
		}
	}

	Super.DrawHUD();
}

function DrawObjectives(float Alpha, bool bUseUpdateCheck)
{
	local GearPC PC;

	PC = GearPC(PlayerOwner);
	// if objective is still active, draw it on the screen all the time
	if (PC.ObjectiveMgr.Objectives.length > 0 && !PC.ObjectiveMgr.Objectives[0].bCompleted && !PC.ObjectiveMgr.Objectives[0].bFailed)
	{
		bUseUpdateCheck = false;
	}
	PC.ObjectiveMgr.DrawObjectives(self, Alpha, 96.0, bUseUpdateCheck);
}

/** Returns the score of all players on the team combined */
final function float GetTeamScoreValue()
{
	local float CurrentScore, DrawScore;
	local GearPRI PRI;

	DrawScore = 0;
	PRI = GearPRI(PlayerOwner.PlayerReplicationInfo);

	if ( PRI != None && PRI.Team != None )
	{
		CurrentScore = PRI.Team.Score;
		if (Abs(LastScore - CurrentScore) > 2.f)
		{
			// interpolate the draw score
			DrawScore = FMin(LastScore + (CurrentScore - LastScore) * RenderDelta * 2.f, CurrentScore);
		}
		else
		{
			// otherwise just equalize
			DrawScore = CurrentScore;
		}
	}

	return DrawScore;
}

/** Sets the color and alpha values for drawing the number of enemies remaining */
final function SetNumEnemiesLeftColorAndAlpha(byte OverallAlpha)
{
	local float FadeInTime, FadeOutTime, Percent, SustainTime;
	local byte Alpha, WhiteColorValue, NormalAlpha, NormalWhiteColorValue;

	// Color and Alpha values
	NormalAlpha = 180;
	NormalWhiteColorValue = 200;

	// Timing values
	FadeInTime = 0.25f;
	FadeOutTime = 0.5f;
	SustainTime = 0.25f;

	// Make count brighten
	if ( TimeOfLastKilledSpawn+FadeInTime >= WorldInfo.TimeSeconds )
	{
		Percent = (TimeOfLastKilledSpawn+FadeInTime-WorldInfo.TimeSeconds) / FadeInTime;
		WhiteColorValue = NormalWhiteColorValue + (1.f-Percent)*(255-NormalWhiteColorValue);
		Alpha = NormalAlpha + (1.f-Percent)*(255-NormalAlpha);
	}
	// Make count sustain brightness
	else if ( TimeOfLastKilledSpawn+FadeInTime+SustainTime >= WorldInfo.TimeSeconds )
	{
		WhiteColorValue = 255;
		Alpha = 255;
	}
	// Make count dull back down to normal
	else if ( TimeOfLastKilledSpawn+FadeInTime+FadeOutTime+SustainTime > WorldInfo.TimeSeconds )
	{
		Percent = (TimeOfLastKilledSpawn+FadeInTime+FadeOutTime+SustainTime-WorldInfo.TimeSeconds) / FadeOutTime;
		WhiteColorValue = 255 - (1.f-Percent)*(255-NormalWhiteColorValue);
		Alpha = 255 - (1.f-Percent)*(255-NormalAlpha);
	}
	// Count is normal brightness
	else
	{
		WhiteColorValue = NormalWhiteColorValue;
		Alpha = NormalAlpha;
	}

	Canvas.SetDrawColor( WhiteColorValue, WhiteColorValue, WhiteColorValue, Alpha*(float(OverallAlpha)/255.0f) );
}

/** draws game status display in the upper left (score, enemy count, etc) */
final function DrawStatusDisplay()
{
	local float BackGroundWidth, DrawX, DrawY, TextSizeX, TextSizeY, BackgroundX, BackgroundY;
	local string StringToDraw, TempScoreString;
	local byte OverallAlpha;
	local float DrawScore;
	local LinearColor LC;
	local GearGRI_Horde GRIHorde;

	GRIHorde = GearGRI_Horde(GRI);
	// We must have replicated data for the HUD
	if (GRIHorde != None && GRIHorde.GameStatus == GS_RoundInProgress)
	{
		// Calculate the opacity
		OverallAlpha = 255 * (1.0f - TaccomFadeOpacity);
		// Set the font we will be using
		Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);

		// Get the draw score
		DrawScore = GetTeamScoreValue();

		// Determine the width of the Horde HUD based on a potentially big score and/or cash value
		TempScoreString = ScoreString @ int(DrawScore);
		Canvas.TextSize(TempScoreString, TextSizeX, TextSizeY);
		BackGroundWidth = FMax(TextSizeX, ScoreBG.UL);
		TempScoreString = CashString @ int(PlayerOwner.PlayerReplicationInfo.Score);
		Canvas.TextSize(TempScoreString, TextSizeX, TextSizeY);
		BackGroundWidth = FMax(BackGroundWidth, TextSizeX);

		// Set the HUD color white
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], OverallAlpha);

		// draw wave background
		DrawX = SafeZoneLeft;
		DrawY = SafeZoneTop;
		LC = MakeLinearColor(0.94, 0.94, 0.94, float(OverallAlpha) / 384.0);
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(WaveBG.Texture, WaveBG.UL, WaveBG.VL, WaveBG.U, WaveBG.V, WaveBG.UL, WaveBG.VL, LC);
		BackgroundX = DrawX;
		BackgroundY = DrawY - 4;

		// Draw the scoring background
		LC.A = float(OverallAlpha) / 255.0;
		DrawY += WaveBG.VL;
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(ScoreBG.Texture, BackGroundWidth, ScoreBG.VL, ScoreBG.U, ScoreBG.V, ScoreBG.UL, ScoreBG.VL, LC);

		// Draw the Score string
		DrawX = BackgroundX + BGPaddingLeft;
		DrawY = BackgroundY + ScorePositionV;
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawText(ScoreString);

		// Draw the wave number string
		Canvas.DrawColor = Canvas.DrawColor * 0.8;
		StringToDraw = HUDWaveString @ ((GRIHorde.ExtendedRestartCount * class'GearGameHorde_Base'.default.MaxWaves) + GRIHorde.InvasionCurrentWaveIndex);
		DrawX = SafeZoneLeft + BGPaddingLeft;
		DrawY = BackgroundY + BGPaddingTop;
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawText(StringToDraw);
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], OverallAlpha);

		// Draw team score
		StringToDraw = String(int(DrawScore));
		Canvas.TextSize(StringToDraw, TextSizeX, TextSizeY);
		DrawX = BackgroundX + BackGroundWidth - TextSizeX - BGPaddingRight;
		DrawY = BackgroundY + ScorePositionV;
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawText(StringToDraw);

		SetNumEnemiesLeftColorAndAlpha(OverallAlpha);

		// Draw the Enemy count string
		DrawX = BackgroundX + BGPaddingLeft;
		DrawY = BackgroundY + EnemyPositionV;
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawText(EnemiesString);

		// Draw the number of enemies left since we are close to the end
		if ( GRIHorde.EnemiesLeftThisRound < 255 )
		{
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_RED], OverallAlpha);
			StringToDraw = String(GRIHorde.EnemiesLeftThisRound);
			Canvas.TextSize(StringToDraw, TextSizeX, TextSizeY);
			DrawX = BackgroundX + BackGroundWidth - BGPaddingRight - TextSizeX;
			DrawY = BackgroundY + EnemyPositionV;
			Canvas.SetPos(DrawX, DrawY);
			Canvas.DrawText(StringToDraw);
		}
		// Draw the progress bar
		else
		{
			DrawEnemyProgressBar(BackgroundX, BackgroundY, BackGroundWidth, OverallAlpha);
		}

		// Store the last score drawn
		LastScore = DrawScore;

		DrawCash(BackgroundX, BackgroundY, BackGroundWidth, OverallAlpha);
	}
}

/** draws the player cash display (background and cash text) */
function DrawCash(float BackgroundX, float BackgroundY, float BackGroundWidth, byte OverallAlpha)
{
	local float DrawX, DrawY, TimeSinceStart, TextSizeX, TextSizeY;
	local string StringToDraw;
	local LinearColor LC;
	local int RespawnCost;

	if (PlayerOwner.PlayerReplicationInfo != None)
	{
		// draw the cash background
		DrawX = SafeZoneLeft;
		DrawY = SafeZoneTop + WaveBG.VL + ScoreBG.VL;
		LC = MakeLinearColor(0.94, 0.94, 0.94, float(OverallAlpha) / 255.0);
		Canvas.SetPos(DrawX, DrawY);
		Canvas.DrawTileStretched(CashBG.Texture, BackGroundWidth, CashBG.VL, CashBG.U, CashBG.V, CashBG.UL, CashBG.VL, LC);

		// draw cash
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], OverallAlpha);
		Canvas.SetPos(BackgroundX + BGPaddingLeft, BackgroundY + CashPositionV);
		TimeSinceStart = WorldInfo.TimeSeconds - WaveStartTime;
		CashRenderInfo.GlowInfo.bEnableGlow = (GRI != None && TimeSinceStart < 3.0 && GearGRI_Horde(GRI).bCanPlaceFortifications && PlayerOwner.PlayerReplicationInfo.Score >= 2000);
		if (CashRenderInfo.GlowInfo.bEnableGlow)
		{
			CashRenderInfo.GlowInfo.GlowColor.A = Abs(Sin(Pi * TimeSinceStart));
		}
		StringToDraw = CashString;
		Canvas.DrawText(StringToDraw,,,, CashRenderInfo);
		StringToDraw = string(int(PlayerOwner.PlayerReplicationInfo.Score));
		Canvas.TextSize(StringToDraw, TextSizeX, TextSizeY);
		Canvas.SetPos(BackgroundX + BackGroundWidth - BGPaddingRight - TextSizeX, BackgroundY + CashPositionV);
		Canvas.DrawText(StringToDraw,,,, CashRenderInfo);

		// draw respawn info if necessary
		if ( PlayerOwner.Pawn == None && !PlayerOwner.IsInState('Dead') && GRI.GameStatus == GS_RoundInProgress &&
			!GearHordePC(PlayerOwner).bRespawnedThisWave )
		{
			Canvas.SetPos(BackgroundX + BGPaddingLeft, BackgroundY + CashPositionV + TextSizeY + 4);
			RespawnCost = class'GearGameHorde_Base'.static.GetRespawnCost(GearGRI_Horde(GRI).ExtendedRestartCount * class'GearGameHorde_Base'.default.MaxWaves + GearGRI_Horde(GRI).InvasionCurrentWaveIndex);
			if (PlayerOwner.PlayerReplicationInfo.Score >= RespawnCost)
			{
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Xbox360_18pt);
				if (GearPC(PlayerOwner).bUseAlternateControls)
				{
					Canvas.DrawText("h", false);
				}
				else
				{
					Canvas.DrawText("Y", false);
				}
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				StringToDraw = BuyBackText @ RespawnCost;
			}
			else
			{
				StringToDraw = BuyBackCantAffordText @ RespawnCost;
				`SetHUDDrawColor((HudColors[eWARHUDCOLOR_WHITE] * 0.6), 255);
			}

			Canvas.DrawText(StringToDraw,,,, Text_NoClipShadowed);
		}

		// play sound every X cash acquired
		if (PlayerOwner.PlayerReplicationInfo.Score >= LastCash + 500)
		{
			PlayerOwner.ClientPlaySound(CashAcquiredSound);
			LastCash = PlayerOwner.PlayerReplicationInfo.Score;
		}
		else if (PlayerOwner.PlayerReplicationInfo.Score < LastCash)
		{
			LastCash = PlayerOwner.PlayerReplicationInfo.Score;
		}
	}
}

/** draws the enemy progress bar showing how much of the wave has been completed */
function DrawEnemyProgressBar(float BackgroundX, float BackgroundY, float BackGroundWidth, byte OverallAlpha)
{
	local int ActualProgressBarSize;
	local float DrawX, DrawY;

	ActualProgressBarSize = ProgressBar.UL * ByteToFloat(GearGRI_Horde(GRI).WavePointsAlivePct);

	// If the DrawProgressBarSize is invalid
	if (DrawProgressBarSize < 0)
	{
		// then set it to the actual size immediately
		DrawProgressBarSize = ActualProgressBarSize;
	}
	// If it's larger than desired size
	else if (DrawProgressBarSize > ActualProgressBarSize)
	{
		// keep decrementing it until it's the correct size for a smooth animation effect
		DrawProgressBarSize -= 1;
	}


	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], OverallAlpha);
	DrawX = BackgroundX + BackGroundWidth - BGPaddingRight - DrawProgressBarSize;
	DrawY = BackgroundY + EnemyPositionV + 4;
	Canvas.SetPos(DrawX, DrawY);
	Canvas.DrawTile(ProgressBar.Texture, DrawProgressBarSize, ProgressBar.VL, ProgressBar.U + (ProgressBar.UL - DrawProgressBarSize), ProgressBar.V, DrawProgressBarSize, ProgressBar.VL);
}

/** Called when an AI factory spawn has been killed */
final function EnemyCountChanged()
{
	TimeOfLastKilledSpawn = WorldInfo.TimeSeconds;
}

/** gets the currently loaded enemy lists from the appropriate place depending on whether we're the server or client */
function GetCurrentEnemyLists(out array<GearHordeEnemyList> EnemyLists)
{
	local GearHordePC PC;
	local GearHordeEnemyList CoreSet;
	local int i;

	if (WorldInfo.NetMode != NM_Client)
	{
		EnemyLists = GearGameHorde_Base(WorldInfo.Game).EnemyLists;
	}
	else
	{
		// only primary player has enemy lists, find it
		foreach LocalPlayerControllers(class'GearHordePC', PC)
		{
			if (PC.EnemyLists.length > 0)
			{
				break;
			}
		}
		if (PC != None)
		{
			for (i = 0; i < PC.EnemyLists.length; i++)
			{
				EnemyLists.AddItem(PC.EnemyLists[i].List);
			}
		}
		// core set not referenced in PC because its content is directly referenced by the GameInfo's default object, but we need the .ini data here
		CoreSet = GearHordeEnemyList(FindObject("Transient.CoreSet", class'GearHordeEnemyList'));
		if (CoreSet == None)
		{
			CoreSet = new(None, "CoreSet") class'GearHordeEnemyList';
		}
		EnemyLists.AddItem(CoreSet);
	}
}

/** Start the begin round screen */
function SignalStartofRoundOrMatch(GearGRI CurGRI)
{
	local int i, j;
	local array<GearHordeEnemyList> EnemyLists;
	local string EnemyPathName;
	local class<Pawn> EnemyClass;
	local GearGRI_Horde GRIHorde;

	// Don't show if there's a network error
	if (WorldInfo.Game != None && WorldInfo.Game.bHasNetworkError)
	{
		return;
	}

	DrawProgressBarSize = -1;

	DrawStartRound();

	WaveStartTime = WorldInfo.TimeSeconds;

	// prestream the textures for the enemies in the next wave
	GRIHorde = GearGRI_Horde(CurGRI);
	GetCurrentEnemyLists(EnemyLists);
	for (i = 0; i < EnemyLists.length; i++)
	{
		for (j = 0; j < EnemyLists[i].EnemyList.length; j++)
		{
			if ( GRIHorde.InvasionCurrentWaveIndex >= EnemyLists[i].EnemyList[j].MinWave &&
				GRIHorde.InvasionCurrentWaveIndex <= EnemyLists[i].EnemyList[j].MaxWave )
			{
				EnemyPathName = "GearGame." $ class'SeqAct_AIFactory'.default.SpawnInfo[EnemyLists[i].EnemyList[j].EnemyType].PawnClassName;
				EnemyClass = class<Pawn>(FindObject(EnemyPathName, class'Class'));
				if (EnemyClass == None)
				{
					EnemyPathName = "GearGameContent." $ class'SeqAct_AIFactory'.default.SpawnInfo[EnemyLists[i].EnemyList[j].EnemyType].PawnClassName;
					EnemyClass = class<Pawn>(FindObject(EnemyPathName, class'Class'));
				}
				if (EnemyClass != None && EnemyClass.default.Mesh != None)
				{
					EnemyClass.default.Mesh.PrestreamTextures(120.0, true);
				}
			}
		}
	}
}

/** Return whether someone is alive or not */
function bool HasGameEndedInSuccess()
{
	local int PRIIdx;
	local GearPRI CurrPRI;

	// Find all of the alive players and sort them from highest to lowest scores
	for ( PRIIdx = 0; PRIIdx < WorldInfo.GRI.PRIArray.length; PRIIdx++ )
	{
		if ( WorldInfo.GRI.PRIArray[PRIIdx] != None )
		{
			CurrPRI = GearPRI(WorldInfo.GRI.PRIArray[PRIIdx]);
			if ( CurrPRI.GetTeamNum() == 0 )
			{
				if ( !CurrPRI.bIsDead )
				{
					return TRUE;
				}
			}
		}
	}

	return FALSE;
}

/** Overload to play a sound */
function SignalEndofRoundOrMatch(GearGRI CurGRI)
{
	local SoundCue SuccessStinger;
	local GearGRI_Horde GRIHorde;

	// Don't show the who won on the server if there was a network error
	if (WorldInfo.Game != None && WorldInfo.Game.bHasNetworkError)
	{
		return;
	}

	if (HasGameEndedInSuccess())
	{
		GRIHorde = GearGRI_Horde(CurGRI);
		if (GRIHorde.InvasionCurrentWaveIndex < EndRoundSuccessStingers.length)
		{
			SuccessStinger = EndRoundSuccessStingers[GRIHorde.InvasionCurrentWaveIndex];
		}
		else if (EndRoundSuccessStingers.length > 0)
		{
			SuccessStinger = EndRoundSuccessStingers[EndRoundSuccessStingers.length - 1];
		}
		if (SuccessStinger != None)
		{
			PlayerOwner.PlaySound(SuccessStinger, true);
		}
	}
	else
	{
		PlayerOwner.PlaySound(EndRoundStingerFailed, true);
	}

	Super.SignalEndofRoundOrMatch(CurGRI);
}

/** Start wave screen */
final function DrawStartRound()
{
	local String Title, Message;
	local GearPC PC;
	local GearHordePRI HordePRI;
	local int YOffset;
	local GearGRI_Horde GRIHorde;
	local int i, j, HighScore;
	local array<GearHordeEnemyList> EnemyLists;
	local bool bWaveHasBosses;

	GRIHorde = GearGRI_Horde(GRI);

	// don't display if replication of the wave number hasn't happened in time (may happen for join in progress)
	if (GRIHorde != None &&
		GRIHorde.InvasionCurrentWaveIndex > 0)
	{
		PC = GearPC(PlayerOwner);
		if (PC != None)
		{
			Title = Localize("FrontEndStrings", "HordeLabel", "GearGameUI");
			YOffset = GetCountdownYPosition() + CountdownSize.Y + PC.NumPixelsToMoveDownForDramaText();
			HordePRI = GearHordePRI(PC.PlayerReplicationInfo);
			// If we haven't shown the previous high score, do that instead of the wave number
			if (HordePRI != None)
			{
				HighScore = PC.StatManager.GetHighScore();
				// Skip showing this on your first play through of a given level
				if (HighScore <= 0)
				{
					HordePRI.bHasShownHighScore = true;
				}
				if(!HordePRI.bHasShownHighScore)
				{
					HordePRI.bHasShownHighScore = true;
					Message = HighScoreString @ HighScore;
				}
				else
				{
					GetCurrentEnemyLists(EnemyLists);
					for (i = 0; i < EnemyLists.length; i++)
					{
						for (j = 0; j < EnemyLists[i].EnemyList.length; j++)
						{
							if ( EnemyLists[i].EnemyList[j].bIsBoss &&
								GRIHorde.InvasionCurrentWaveIndex >= EnemyLists[i].EnemyList[j].MinWave &&
								GRIHorde.InvasionCurrentWaveIndex <= EnemyLists[i].EnemyList[j].MaxWave )
							{
								bWaveHasBosses = true;
								break;
							}
						}
						if (bWaveHasBosses)
						{
							break;
						}
					}
					if (bWaveHasBosses)
					{
						if (GRIHorde.InvasionCurrentWaveIndex == class'GearGameHorde_Base'.default.MaxWaves)
						{
							Message = BeginBossWaveMessage;
						}
						else
						{
							Message = BeginMiniBossWaveMessage;
						}
					}
					else
					{
						Message = BeginWaveMessage;
					}
					Message @= ((GRIHorde.ExtendedRestartCount * class'GearGameHorde_Base'.default.MaxWaves) + GRIHorde.InvasionCurrentWaveIndex);
				}
				StartDrawingDramaticText( Title, Message, 8.0f, 2.0f, 2.0f, YOffset, 2.0f, 2.0f );
				// Play a stinger
				PlayerOwner.PlaySound(bWaveHasBosses ? BossWaveSound : BeginRoundStinger, true);
			}
		}
	}
}

/** Sets a timer to close the end of round scene
 *	Overriding this to NOT set a timer, let the EOR scene close itself.
 */
function SetCloseEndOfRoundSceneTimer()
{
}

/** Uses the game status to determine if the scoreboard should be showing or not */
function bool ShouldShowScoreboardBasedOnGameStatus()
{
	if ( GearGRI(WorldInfo.GRI).GameStatus != GS_RoundInProgress &&
		 GearGRI(WorldInfo.GRI).GameStatus != GS_RoundOver &&
		 GearGRI(WorldInfo.GRI).GameStatus != GS_EndMatch &&
		 GearGRI(WorldInfo.GRI).GameStatus != GS_Loading )
	{
		return true;
	}

	return false;
}

/** See if it's time to show the "Locust get stronger" screen */
function AttemptHordeModOpen()
{
	OpenHordeModScene();
}

/** Opens the horde mod scene and holds a reference to the scene instance */
function OpenHordeModScene()
{
	if( (PoisonsPlayerInstance == None) && (PoisonsPlayerClass != None) )
	{
		PoisonsPlayerInstance = new(self) PoisonsPlayerClass;
		PoisonsPlayerInstance.Init(LocalPlayer(PlayerOwner.Player));

		// Set a timer to close the scene at the appropriate time
		SetTimer(PoisonSceneDisplayTime, FALSE, nameof(PoisonsPlayerInstance.CloseView), PoisonsPlayerInstance);
	}
}

/** Called when the horde mod scene is deactivated */
function CloseHordeModScene()
{
	if( PoisonsPlayerInstance != None )
	{
		PoisonsPlayerInstance.Close(TRUE);
		PoisonsPlayerInstance = None;
	}
}

simulated function float GetCountdownYPosition()
{
	// extra for the deployment phase text
	return Super.GetCountdownYPosition() + 32.0;
}

simulated function bool UpdateCountdown()
{
	local class<GearGameHorde_Base> HordeClass;
	local float XL, YL;
	local int CountdownTime;

	// make sure the countdown timer is enabled if we're in the deployment phase
	CountdownEndTime = 0.0;
	if (GRI != None && GearGRI_Horde(GRI).bCanPlaceFortifications && (GRI.RoundCount > 1 || GearGRI_Horde(GRI).FortificationFlags.length > 0)) //@hack: don't show when "build a base" objective is pausing the timer
	{
		HordeClass = class<GearGameHorde_Base>(GRI.GameClass);
		if (HordeClass != None && GRI.RoundTime < HordeClass.default.DeploymentPhaseDuration)
		{
			CountdownStartTime = WorldInfo.TimeSeconds - CountdownTotalFadeInTime;
			CountdownStopTime = 0.0;
			CountdownEndTime = WorldInfo.TimeSeconds + HordeClass.default.DeploymentPhaseDuration - CountdownTotalFadeInTime - GRI.RoundTime;

			CountdownTime = int(CountdownEndTime - WorldInfo.TimeSeconds);
			if (CountdownTime != LastDeploymentCountdownTime)
			{
				LastDeploymentCountdownTime = CountdownTime;
				// play warning beep if time is running out
				if (CountdownTime <= 5)
				{
					PlayerOwner.ClientPlaySound(DeploymentCountdownBeepSound);
				}
			}

			//@FIXME: temp description text for the timer
			Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			Canvas.DrawColor = WhiteColor;
			Canvas.StrLen("DEPLOYMENT TIME REMAINING:", XL, YL);
			Canvas.SetPos((Canvas.ClipX - XL) * 0.5, GetCountdownYPosition() - YL - 2.0);
			Canvas.DrawText("DEPLOYMENT TIME REMAINING:");
		}
	}

	return Super.UpdateCountdown();
}

/* experiment with cost on the icon tooltip
function DrawFortificationInfo()
{
	local bool bFoundPickup;
	local string FortCostText;
	local GearPC PC;
	local float XL, YL;
	local GearWeaponPickupFactory WeaponFactory;
	local GearAmmoPickup_AmmoCase AmmoFactory;
	local EGearHUDColor TextColor;
	local int Cost;

	PC = GearPC(PlayerOwner);
	if (PC.MyGearPawn != None && !PC.MyGearPawn.IsDBNO() && ActiveAction.ActionType == AT_Pickup)
	{
		foreach PC.Pawn.TouchingActors(class'GearWeaponPickupFactory', WeaponFactory)
		{
			if ( !WeaponFactory.bHidden && WeaponFactory.WeaponPickupClass != None &&
				WeaponFactory.WeaponPickupClass.default.HordeCost > 0 &&
				!WeaponFactory.bPurchaseExempt &&
				WeaponFactory.FindInteractionWith(PC.Pawn, false) != '' )
			{
				FortCostText = "COST TO BUY:" @ string(WeaponFactory.WeaponPickupClass.default.HordeCost);
				Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
				TextColor = (PC.PlayerReplicationInfo.Score >= WeaponFactory.WeaponPickupClass.default.HordeCost) ? eWARHUDCOLOR_WHITE : eWARHUDCOLOR_RED;
				`SetHUDDrawColor(HudColors[TextColor],255);
				Canvas.StrLen(FortCostText, XL, YL);
				Canvas.SetPos(Canvas.ClipX * 0.5 - XL * 0.5, Canvas.ClipY * 0.7 - YL * 0.5);
				Canvas.DrawText(FortCostText);
				bFoundPickup = true;
				break;
			}
		}
		if (WeaponFactory == None)
		{
			foreach PC.Pawn.TouchingActors(class'GearAmmoPickup_AmmoCase', AmmoFactory)
			{
				if ( !AmmoFactory.bHidden && AmmoFactory.FindInteractionWith(PC.Pawn, false) != '' )
				{
					AmmoFactory.FindPickupAmmoTypes(PC.MyGearPawn,, Cost);
					FortCostText = "COST TO BUY:" @ string(Cost);
					Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
					TextColor = (PC.PlayerReplicationInfo.Score >= Cost) ? eWARHUDCOLOR_WHITE : eWARHUDCOLOR_RED;
					`SetHUDDrawColor(HudColors[TextColor],255);
					Canvas.StrLen(FortCostText, XL, YL);
					Canvas.SetPos(Canvas.ClipX * 0.5 - XL * 0.5, Canvas.ClipY * 0.7 - YL * 0.5);
					Canvas.DrawText(FortCostText);
					bFoundPickup = true;
					break;
				}
			}
		}
	}

	// picking things up takes priority over building
	if (!bFoundPickup)
	{
		Super.DrawFortificationInfo();
	}
}
*/

defaultproperties
{
	bDrawKillPoints=true

	TotalScoreTime=3.f
	TotalEndRoundTime=10.f
	EndRoundSceneDelayTime=0.75 // give some time for final team score to replicate

	WaveBG=(Texture=Texture2D'Warfare_HUD.HUD.Siege_Horde_TimerTokens',U=0,V=0,UL=173,VL=20)
	ScoreBG=(Texture=Texture2D'Warfare_HUD.HUD.Siege_Horde_TimerTokens',U=0,V=22,UL=192,VL=36)
	CashBG=(Texture=Texture2D'Warfare_HUD.HUD.Siege_Horde_TimerTokens',U=0,V=41,UL=192,VL=18)
	ProgressBar=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=257,V=494,UL=111,VL=15)
	BGPaddingTop=4
	BGPaddingLeft=4
	BGPaddingRight=3
	ScorePositionV=24
	EnemyPositionV=41
	CashPositionV=58

	CashRenderInfo=(bEnableShadow=true,GlowInfo=(GlowColor=(R=1.0,G=1.0,A=1.0),GlowOuterRadius=(X=0.3,Y=0.45),GlowInnerRadius=(X=0.45,Y=0.5)))
}
