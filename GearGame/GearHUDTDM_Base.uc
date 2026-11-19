/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDTDM_Base extends GearHUDMP_Base
	abstract;

/** Materials for drawing the main scoreboard */
var Material MainScoreMaterialCOG;
var Material MainScoreMaterialLOC;
/** Material Instances for drawing the main scoreboard */
var MaterialInstanceConstant MainScoreMatInstanceCOG;
var MaterialInstanceConstant MainScoreMatInstanceLOC;

/** offsets for player icons when drawing the last players alive */
var array<vector2d> PlayerIconPos;

/** Initialize some data */
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// initialize the scoreboard
	MainScoreMatInstanceCOG = new(self) class'MaterialInstanceConstant';
	MainScoreMatInstanceCOG.SetParent(MainScoreMaterialCOG);
	MainScoreMatInstanceLOC = new(self) class'MaterialInstanceConstant';
	MainScoreMatInstanceLOC.SetParent(MainScoreMaterialLOC);
}

/** Draw the main scoreboard for a specific team */
simulated function DrawTeamScoreBoard(float DrawX, float DrawY, MaterialInstanceConstant MainScoreMIC, string ScoreString, bool bLocalPlayerTeam, byte Team)
{
	local float TextWidth, TextHeight;
	local byte Alpha;
	local int PlayerIndex, i;
	local GearPRI PRI;

	Alpha = 255 * (1.0 - TaccomFadeOpacity);
	if (Alpha > 0)
	{
		// Draw the scoreboard
		`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha);
		Canvas.SetPos(DrawX, DrawY);
		MainScoreMIC.SetScalarParameterValue((MainScoreMIC == MainScoreMatInstanceCOG) ? 'ScoreBoardOpacityCOG' : 'ScoreBoardOpacityLOC', 0.4);
		MainScoreMIC.SetScalarParameterValue('Opacity', 1.0 - TaccomFadeOpacity);
		MainScoreMIC.SetScalarParameterValue('TimerFill', bLocalPlayerTeam ? 1.0 : 0.0);
		Canvas.DrawMaterialTile(MainScoreMIC, 128, 128);

		if (GRI.GameScore[Team] > 0)
		{
			// Draw the score
			`SetHUDDrawColor(HudColors[eWARHUDCOLOR_WHITE], Alpha );
			Canvas.Font = class'Engine'.static.GetAdditionalFont( FONT_Euro20 );
			Canvas.TextSize( ScoreString, TextWidth, TextHeight );
			TextWidth *= 1.2;
			TextHeight *= 1.2;
			DrawX += 42.0 - (TextWidth / 2);
			DrawY += 43.0 - (TextHeight / 2);
			Canvas.SetPos(DrawX, DrawY);
			Canvas.DrawText(ScoreString,, 1.2, 1.2);
		}
		else
		{
			// draw character icons for remaining players alive
			for (i = 0; i < GRI.PRIArray.length; i++)
			{
				PRI = GearPRI(GRI.PRIArray[i]);
				if ( PRI != None && PRI.PawnClass != None && PRI.GetTeamNum() == Team &&
					(PRI.PlayerStatus == WPS_Respawning || PRI.PlayerStatus == WPS_Alive || PRI.PlayerStatus == WPS_Down) )
				{
					Canvas.SetPos(DrawX + 32 + PlayerIconPos[PlayerIndex].X, DrawY + 32 + PlayerIconPos[PlayerIndex].Y);
					Canvas.DrawMaterialTile(PRI.PawnClass.default.HeadIcon, 24.0, 24.0, 0.0, 0.0, 1.0, 1.0);
					PlayerIndex++;
				}
			}
		}
	}
}

function DrawHUD()
{
	local MaterialInstanceConstant MainScoreMIC;
	local String ScoreString;
	local float LocalDrawX, LocalDrawY;
	local int MyTeam;

	Super.DrawHUD();

	// draw the main scoreboard
	if (bShowHud && !HideHUDFromScenes() && GRI != None && GRI.GameStatus == GS_RoundInProgress && PlayerOwner.PlayerReplicationInfo != None)
	{
		// default to team zero for players with no team (spectators, demo playback)
		MyTeam = (PlayerOwner.PlayerReplicationInfo.Team != None) ? PlayerOwner.PlayerReplicationInfo.Team.TeamIndex : 0;

		// Set the draw position for our scoreboard
		LocalDrawX = SafeZoneLeft;
		LocalDrawY = SafeZoneTop;
		// Grab the scoreboard material instance for our scoreboard
		MainScoreMIC = (MyTeam == 0) ? MainScoreMatInstanceCOG : MainScoreMatInstanceLOC;
		// Grab the score string for our scoreboard
		ScoreString = string(int(GRI.GameScore[MyTeam]));
		// Draw our scoreboard
		DrawTeamScoreBoard(LocalDrawX, LocalDrawY, MainScoreMIC, ScoreString, true, MyTeam);

		// Set the draw position for the enemy scoreboard
		LocalDrawX = SafeZoneLeft + 104.f;
		LocalDrawY = SafeZoneTop;
		// Grab the scoreboard material instance for the enemy scoreboard
		MainScoreMIC = (MyTeam == 1) ? MainScoreMatInstanceCOG : MainScoreMatInstanceLOC;
		// Grab the score string for the enemy scoreboard
		ScoreString = string(int(GRI.GameScore[1 - MyTeam]));
		// Draw the enemy scoreboard
		DrawTeamScoreBoard(LocalDrawX, LocalDrawY, MainScoreMIC, ScoreString, false, 1 - MyTeam);
	}
}

defaultproperties
{
	PlayerIconPos[0]=(X=0,Y=0)
	PlayerIconPos[1]=(X=-24,Y=0)
	PlayerIconPos[2]=(X=24,Y=0)
	PlayerIconPos[3]=(X=0,Y=-24)
	PlayerIconPos[4]=(X=0,Y=24)
}
