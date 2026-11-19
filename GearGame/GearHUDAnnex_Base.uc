/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDAnnex_Base extends GearHUDMP_Base;

var localized string NumRespawnsString;

var CanvasIcon	ShieldIcon;

/** Materials for drawing the main scoreboard */
var Material MainScoreMaterialCOG;
var Material MainScoreMaterialLOC;
/** Material Instances for drawing the main scoreboard */
var MaterialInstanceConstant MainScoreMatInstanceCOG;
var MaterialInstanceConstant MainScoreMatInstanceLOC;

/** Variables for controlling the pulsing effect in the Command Point Indicator */
var int NumPulsesToDisplay;
var float PulseStartTime;
var float TotalPulseTime;

/** Played when one team is about to win */
var SoundCue AnnexSound_TeamAboutToWin[2];
/** Variables for controlling the pulsing effect in the Scoreboard */
var float ScorePulseStartTime;
var float ScoreTotalPulseTime;

/** Initialize some data */
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// initialize the scoreboard
	if( MainScoreMatInstanceCOG == None )
	{
		MainScoreMatInstanceCOG = new(outer) class'MaterialInstanceConstant';
		MainScoreMatInstanceCOG.SetParent( MainScoreMaterialCOG );
	}
	if( MainScoreMatInstanceLOC == None )
	{
		MainScoreMatInstanceLOC = new(outer) class'MaterialInstanceConstant';
		MainScoreMatInstanceLOC.SetParent( MainScoreMaterialLOC );
	}
}

/** Reset the HUD */
function Reset()
{
	Super.Reset();

	NumPulsesToDisplay = 0;
	PulseStartTime = 0;
}

/** Overloaded Draw call */
function DrawHUD()
{
	local float DrawX, DrawY;

	Super.DrawHUD();

	if ( bShowHud &&
		!HideHUDFromScenes() &&
		(GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress) )
	{
		DrawX = SafeZoneLeft;
		DrawY = SafeZoneTop;

		// draw the main scoreboard
		DrawMainScoreBoard( DrawX, DrawY );

		// draw the command point indicator
		DrawCommandPointIndicator( DrawX, DrawY );
	}
}

/** Draws the main scoreboard for annex */
simulated function DrawMainScoreBoard( out float DrawX, out float DrawY )
{
	local MaterialInstanceConstant MainScoreMIC;
	local string ScoreString;
	local float LocalDrawX, LocalDrawY, XL, YL;
	local int ControlTeam, MyTeam, ResourceGoal;
	local bool bHasCPControl;

	if (PlayerOwner.PlayerReplicationInfo != None && GRI != None)
	{
		// default to team zero for players with no team (spectators, demo playback)
		MyTeam = (PlayerOwner.PlayerReplicationInfo.Team != None) ? PlayerOwner.PlayerReplicationInfo.Team.TeamIndex : 0;

		// See if one of the teams has control of the CP
		ControlTeam = GRI.CPControlTeam;
		if (GRI.CPControlPct < 100.0)
		{
			ControlTeam = -1;
		}

		ResourceGoal = GearGRI_Annex(GRI).AnnexResourceGoal;

		// Set the draw position for our scoreboard
		LocalDrawX = DrawX;
		LocalDrawY = DrawY;
		// Grab the scoreboard material instance for our scoreboard
		MainScoreMIC = (MyTeam == 0) ? MainScoreMatInstanceCOG : MainScoreMatInstanceLOC;
		// Grab the score string for our scoreboard
		ScoreString = (MyTeam == 0) ? string(int(GRI.GameScore[0])) : string(int(GRI.GameScore[1]));
		// See if our team has control of the command point
		bHasCPControl = (MyTeam == ControlTeam);
		// Draw our scoreboard
		DrawTeamScoreBoard(LocalDrawX, LocalDrawY, MainScoreMIC, ScoreString, bHasCPControl, (GRI.CPControlTeam == MyTeam) ? (GRI.CPControlPct * 0.01) : 0.0);

		// Set the draw position for the enemy scoreboard
		LocalDrawX = DrawX + 104.f;
		LocalDrawY = DrawY;
		// Grab the scoreboard material instance for the enemy scoreboard
		MainScoreMIC = (MyTeam == 1) ? MainScoreMatInstanceCOG : MainScoreMatInstanceLOC;
		// Grab the score string for the enemy scoreboard
		ScoreString = (MyTeam == 1) ? string(int(GRI.GameScore[0])) : string(int(GRI.GameScore[1]));
		// See if our team has control of the command point
		bHasCPControl = ((MyTeam != ControlTeam) && (ControlTeam != -1));
		// Draw the enemy scoreboard
		DrawTeamScoreBoard(LocalDrawX, LocalDrawY, MainScoreMIC, ScoreString, bHasCPControl, (GRI.CPControlTeam == 1 - MyTeam) ? (GRI.CPControlPct * 0.01) : 0.0);

		ScoreString = string(ResourceGoal);
		Canvas.TextSize(ScoreString, XL, YL);
		LocalDrawX = DrawX + 90.0 - (XL + 32.0) * 0.5;
		LocalDrawY = DrawY + 80.0;
		Canvas.DrawIcon(GameSpecificIcon[0], LocalDrawX, LocalDrawY);
		Canvas.SetPos(LocalDrawX + 32.0, LocalDrawY + 2.0);
		Canvas.DrawText(ScoreString);
	}
}

/** Calculate the opacity of the scoreboard */
simulated function float CalculateTeamScoreboardOpacity( bool bHasCPControl )
{
	local float MinOpacityNormal, MaxOpacityNormal, MinOpacityPulse, MaxOpacityPulse, NewOpacity;

	MinOpacityNormal = 0.4f;
	MaxOpacityNormal = 0.85f;
	MinOpacityPulse = 0.4f;
	MaxOpacityPulse = 1.0f;

	if ( !bHasCPControl )
	{
		return MinOpacityNormal;
	}

	if ( ScorePulseStartTime + ScoreTotalPulseTime < WorldInfo.TimeSeconds )
	{
		ScorePulseStartTime = 0.f;
		ScoreTotalPulseTime = 0.f;
		return MaxOpacityNormal;
	}

	if ( (WorldInfo.TimeSeconds - ScorePulseStartTime) < (0.2f * ScoreTotalPulseTime) )
	{
		NewOpacity = MaxOpacityNormal + (MaxOpacityPulse - MaxOpacityNormal) * ((WorldInfo.TimeSeconds - ScorePulseStartTime) / (0.2f * ScoreTotalPulseTime));
	}
	else if ( (WorldInfo.TimeSeconds - ScorePulseStartTime) < (0.6f * ScoreTotalPulseTime) )
	{
		NewOpacity = MaxOpacityPulse - (MaxOpacityPulse - MinOpacityPulse) * ((WorldInfo.TimeSeconds - ScorePulseStartTime - 0.2f*ScoreTotalPulseTime) / (0.4f * ScoreTotalPulseTime));
	}
	else
	{
		NewOpacity = MinOpacityPulse + (MaxOpacityNormal - MinOpacityPulse) * ((WorldInfo.TimeSeconds - ScorePulseStartTime - 0.6f*ScoreTotalPulseTime) / (0.4f * ScoreTotalPulseTime));
	}

	return NewOpacity;
}

/** Draw the main scoreboard for a specific team */
simulated function DrawTeamScoreBoard(out float DrawX, out float DrawY, MaterialInstanceConstant MainScoreMIC, String ScoreString, bool bHasCPControl, float ControlPct)
{
	local float LocalDrawX, LocalDrawY, TextWidth, TextHeight, SBOpacity;
	local byte Alpha;
	local EGearHUDColor TextColor;

	LocalDrawX = DrawX;
	LocalDrawY = DrawY;
	Alpha = 255 * (1.0f - TaccomFadeOpacity);

	// Draw the scoreboard
	`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);
	Canvas.SetPos(LocalDrawX, LocalDrawY);
	SBOpacity = CalculateTeamScoreboardOpacity(bHasCPControl);
	MainScoreMIC.SetScalarParameterValue((MainScoreMIC == MainScoreMatInstanceCOG) ? 'ScoreBoardOpacityCOG' : 'ScoreBoardOpacityLOC', SBOpacity);
	MainScoreMIC.SetScalarParameterValue('Opacity', 1.f - TaccomFadeOpacity );
	MainScoreMIC.SetScalarParameterValue('TimerFill', ControlPct);
	Canvas.DrawMaterialTile(MainScoreMIC, 128, 128);

	// Draw the score
	TextColor = eWARHUDCOLOR_WHITE;
	`SetHUDDrawColor(HudColors[TextColor],Alpha);
	Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
	Canvas.TextSize(ScoreString, TextWidth, TextHeight);
	TextWidth *= 1.2;
	TextHeight *= 1.2;
	LocalDrawX = DrawX + 42.0 - (TextWidth / 2);
	LocalDrawY = DrawY + 44.0 - (TextHeight / 2);
	Canvas.SetPos(LocalDrawX, LocalDrawY);
	Canvas.DrawText(ScoreString,, 1.2, 1.2);
}

/** Set the glow material to start pulsing */
function SetCommandPointIndicatorGlow( int NumPulses, float PulseLength )
{
	local int LocatorIdx;

	for (LocatorIdx = 0; LocatorIdx < HUDLocators.length; LocatorIdx++)
	{
		if (HUDLocators[LocatorIdx].Class == class'GearHUDLocator_Ring')
		{
			HUDLocators[LocatorIdx].StartGlowEffect(NumPulses, HUDLocators[LocatorIdx].BloomWhite, PulseLength * 0.5f, 0.0f, PulseLength * 0.5f);
			break;
		}
	}
}

/**
 * Draws the Command Point indicator which tells the player what/where the current command point is
 * NOTE: DrawX and DrawY is the center point of where this will draw.
 */
simulated function DrawCommandPointIndicator( out float DrawX, out float DrawY )
{
	local GearGRI_MP GGRI;

 	GGRI = GearGRI_MP(WorldInfo.GRI);

	if (PlayerOwner.PlayerReplicationInfo != None && GGRI != None)
	{
		if ( GGRI.CommandPoint != None )
		{
			AddHUDLocator(class'GearHUDLocator_Ring', GGRI.CommandPoint);
 		}
	}
}

/** Play a sound and have the scoreboard pulse for an end of game warning */
function DoEndOfGameWarning(int ScoreDiff, int TeamIndex)
{
	PlaySound(AnnexSound_TeamAboutToWin[TeamIndex], true);

	// start the pulse
	ScorePulseStartTime = WorldInfo.TimeSeconds;
	ScoreTotalPulseTime = 1.0f;
}

/** Defaults properties */
defaultproperties
{
	NumPulsesToDisplay=1000;
	PulseStartTime=100000000;
	TotalPulseTime=1.f;

	ShieldIcon=(U=128,V=68,UL=128,VL=40)
}
