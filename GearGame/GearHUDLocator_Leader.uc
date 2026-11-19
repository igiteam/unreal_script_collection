/**
 * GearHUDLocator_Leader
 *
 * Class that controls and draws a single UI HUD locator for the leader of our team
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_Leader extends GearHUDLocator_DBNO;

/** icon to draw when not down based on team */
var Texture TeamIcon;
/** Reference to the down icon */
var const Texture DownedIconTexture;

/** MIC set to the other team's color, for drawing the dual team effect for leader on leader cases */
var MaterialInstanceConstant OtherTeamLocatorMI;


simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	local Texture2D OtherTeamIcon;

	if (Subject.GetTeamNum() == 0)
	{
		TeamIcon = Texture2D'Warfare_HUD.HUD.HUD_Leader_COG';
		OtherTeamIcon = Texture2D'Warfare_HUD.HUD.HUD_Leader_Locust';
	}
	else
	{
		TeamIcon = Texture2D'Warfare_HUD.HUD.HUD_Leader_Locust';
		OtherTeamIcon = Texture2D'Warfare_HUD.HUD.HUD_Leader_COG';
	}
	SquareIconTexture = TeamIcon;
	if (Super.InitializeLocator(Subject, TheHUD))
	{
		OtherTeamLocatorMI = new(self) class'MaterialInstanceConstant';
		OtherTeamLocatorMI.SetParent(LocatorMI);
		OtherTeamLocatorMI.SetTextureParameterValue('Icon', OtherTeamIcon);
		return true;
	}
	else
	{
		return false;
	}
}

function DrawLocatorMI()
{
	local GearPawn ComradeGP;

	ComradeGP = GearPawn(LocatorSubject);
	if ((ComradeGP.IsAKidnapper() || ComradeGP.IsAHostage()) && GearPRI(ComradeGP.InteractionPawn.PlayerReplicationInfo).bIsLeader)
	{
		// draw half with one color
		OwningHUD.Canvas.SetPos(LocatorCoord.X, LocatorCoord.Y);
		OwningHUD.Canvas.DrawMaterialTile(LocatorMI, LocatorWidth * LocatorScale * 0.5, LocatorHeight * LocatorScale, 0.0, 0.0, 0.5, 1.0);

		// draw the second half with the other color
		OwningHUD.Canvas.SetPos(LocatorCoord.X + LocatorWidth * LocatorScale * 0.5, LocatorCoord.Y);
		OwningHUD.Canvas.DrawMaterialTile(OtherTeamLocatorMI, LocatorWidth * LocatorScale * 0.5, LocatorHeight * LocatorScale, 0.5, 0.0, 0.5, 1.0);
	}
	else
	{
		Super.DrawLocatorMI();
	}
}

/** Overloaded to add a red pulse when they are DBNO */
function UpdateLocator()
{
	local GearPawn ComradeGP;

	ComradeGP = GearPawn(LocatorSubject);

	// Make sure the HUD's PC and the subject's pawn are intact
	if (ComradeGP != None)
	{
		// If the subject is DBNO show a red glow effect
		if (ComradeGP.IsDBNO() && GlowStartTime == -1)
		{
			StartGlowEffect(1, BloomBloodRed, 0.05f, 0.0f, 0.5f);
		}
	}

	Super.UpdateLocator();
};

function DrawLocator()
{
	local GearGRI_CTL GRI;
	local float DrawWidth, DrawHeight;
	local string StringToDraw;
	local GearPawn SubjectPawn;

	Super.DrawLocator();

	GRI = GearGRI_CTL(OwningHUD.WorldInfo.GRI);
	if (GRI != None)
	{
		SubjectPawn = GearPawn(LocatorSubject);
		if ( SubjectPawn.IsAHostage() ||
			(SubjectPawn.IsAKidnapper() && GearPRI(SubjectPawn.InteractionPawn.PlayerReplicationInfo) != None && GearPRI(SubjectPawn.InteractionPawn.PlayerReplicationInfo).bIsLeader) )
		{
			// Draw the amount of time left
			StringToDraw = string(GRI.CaptureTimeRemaining[SubjectPawn.IsAHostage() ? (1 - LocatorSubject.GetTeamNum()) : int(LocatorSubject.GetTeamNum())]);
			OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
			OwningHUD.Canvas.TextSize(StringToDraw, DrawWidth, DrawHeight);
			OwningHUD.Canvas.SetPos( LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale) - (DrawWidth * 0.5f * LocatorScale),
						LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale) - (DrawHeight * 0.5f * LocatorScale) );
			`SetHUDDrawColorExt(OwningHUD, OwningHUD.HudColors[eWARHUDCOLOR_WHITE], byte(255.0f * LocatorAlpha));
			OwningHUD.Canvas.DrawText(StringToDraw, false, LocatorScale, LocatorScale);
		}
	}
}

/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	return ( SubjectPawn == None || (SubjectPawn.PlayerReplicationInfo == None && SubjectPawn.DrivenVehicle == None) ||
		(SubjectPawn.TimeOfDeath != 0.0f && OwningHUD.WorldInfo.TimeSeconds - SubjectPawn.TimeOfDeath >= 2.0f) );
}

/** Sets the locator timer for bleedout */
function SetTimerValues()
{
	local GearPawn ComradeGP;
	local GearPC PC;

	PC = GearPC(OwningHUD.PlayerOwner);
	ComradeGP = GearPawn(LocatorSubject);

	// Make sure the HUD's PC and the subject's pawn are intact
	if (PC != None &&
		ComradeGP != None &&
		Pawn(ComradeGP.Base) == None)
	{
		// If the subject is DBNO show the down icon
		if (ComradeGP.IsDBNO())
		{
			TimerFillValue = OwningHUD.CalculateRevivePercentAlive(GearPawn(LocatorSubject));
		}
		else
		{
			TimerFillValue = 1.0f;
		}
	}

	TimerBGAlpha = 1.0f;
	TimerAlpha = 1.0f;
	TimerColor = BloodRed;
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	local GearPawn ComradeGP;

	ComradeGP = GearPawn(LocatorSubject);
	if (ComradeGP != None && ComradeGP.IsDBNO())
	{
		SquareIconTexture = DownedIconTexture;
		Super.SetIconValues();
	}
	else
	{
		SquareIconTexture = TeamIcon;
		SquareIconColor = NormalWhite;
	}

	SquareIconAlpha = 1.0;

	if (GearPC(OwningHUD.PlayerOwner).bAssessMode)
	{
		ContextLabel = None;
	}
	else
	{
		ContextLabel = ComradeGP.IsAHostage() ? Texture2D'Warfare_HUD.HUD_Icon_Rescue' : Texture2D'Warfare_HUD.HUD_Icon_Defend';
	}
}

function DrawText()
{
	local GearPRI PRI;

	if (GearPC(OwningHUD.PlayerOwner).bAssessMode)
	{
		PRI = GearPRI(Pawn(LocatorSubject).PlayerReplicationInfo);
		if (PRI != None)
		{
			Text = PRI.PlayerName;
		}
		// readjust Y value to be centered
		TextCoord.Y = (LocatorCoord.Y + (0.1 * LocatorHeight * LocatorScale)) + (TextCoord.Y - LocatorCoord.Y - TextVertOffset*LocatorScale)/2;
		Super.DrawText();
	}
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	DownedIconTexture=Texture'Warfare_HUD.Location.HUD_revive'
	bShouldGlowWhenCreated=false
	bShouldFadeAfterRevive=false
	Priority=100
}
