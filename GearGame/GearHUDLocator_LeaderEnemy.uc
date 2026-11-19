/**
 * GearHUDLocator_LeaderEnemy
 *
 * Class that controls and draws a single UI HUD locator for the leader of the other team
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_LeaderEnemy extends GearHUDLocator_DBNO;

/** Keep track of leader spotted */
var bool bLeaderSpotted;

simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	SquareIconTexture = (Subject.GetTeamNum() == 0) ? Texture2D'Warfare_HUD.HUD.HUD_Leader_COG' : Texture2D'Warfare_HUD.HUD.HUD_Leader_Locust';
	return Super.InitializeLocator(Subject, TheHUD);
}

/** Overloaded to check for reviving and death */
function UpdateLocator()
{
	local GearPawn ComradeGP;

	ComradeGP = GearPawn(LocatorSubject);

	// Make sure the HUD's PC and the subject's pawn are intact
	if (ComradeGP != None)
	{
		// if the viewed player is holding the leader, don't show the icon
		// also don't show for leader on leader (in that case friendly leader icon handles both)
		if ( (!ComradeGP.IsAHostage() || ComradeGP.InteractionPawn != OwningHUD.PlayerOwner.ViewTarget) &&
			((!ComradeGP.IsAHostage() && !ComradeGP.IsAKidnapper()) || !GearPRI(ComradeGP.InteractionPawn.PlayerReplicationInfo).bIsLeader) )
		{
			// If the subject is DBNO show a red glow effect
			if (ComradeGP.IsDBNO() && GlowStartTime == -1)
			{
				StartGlowEffect(1, BloomBloodRed, 0.05f, 0.0f, 0.5f);
			}

			Super.UpdateLocator();
		}

		if (ComradeGP.SpottedByTeam[OwningHUD.PlayerOwner.GetTeamNum()] > 0)
		{
			if (!bLeaderSpotted)
			{
				bLeaderSpotted = TRUE;
				OwningHUD.PlayerOwner.PlaySound(SoundCue'Interface_Audio.Interface.TargetMarked_01_Cue', TRUE);
				if (GlowStartTime == -1)
				{
					StartGlowEffect(1, BloomWhite, 0.05f, 0.0f, 3.0f);
				}
			}
		}
		else
		{
			bLeaderSpotted = FALSE;
		}
	}
}

function DrawLocator()
{
	local GearGRI_CTL GRI;
	local float DrawWidth, DrawHeight;
	local string StringToDraw;

	Super.DrawLocator();

	GRI = GearGRI_CTL(OwningHUD.WorldInfo.GRI);
	if (GRI != None && GearPawn(LocatorSubject).IsAHostage())
	{
		// Draw the amount of time left
		StringToDraw = string(GRI.CaptureTimeRemaining[1 - LocatorSubject.GetTeamNum()]);
		OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		OwningHUD.Canvas.TextSize(StringToDraw, DrawWidth, DrawHeight);
		OwningHUD.Canvas.SetPos( LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale) - (DrawWidth * 0.5f * LocatorScale),
					LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale) - (DrawHeight * 0.5f * LocatorScale) );
		`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_WHITE], byte(255.0f * LocatorAlpha));
		OwningHUD.Canvas.DrawText(StringToDraw, false, LocatorScale, LocatorScale);
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
	TimerFillValue = 1.0f;
	TimerBGAlpha = 1.0f;
	TimerAlpha = 1.0f;
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	SquareIconColor = NormalWhite;
	SquareIconAlpha = 1.0f;
}

function DrawText();

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	ContextLabel=Texture2D'Warfare_HUD.HUD_Icon_Capture'
	bShouldGlowWhenCreated=false
	bShouldFadeAfterRevive=false
	Priority=100
}
