/**
 * GearHUDLocator_Wingman
 *
 * Class that controls and draws a single UI HUD locator for our wingman
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_Wingman extends GearHUDLocator_DBNO;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Reference to the COG wingman icon */
var const Texture COGWingmanIconTexture;
/** Reference to the Locust wingman icon */
var const Texture LocustWingmanIconTexture;


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Overloaded to add a red pulse when they are DBNO */
function UpdateLocator()
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
		if (ComradeGP.IsDBNO() &&
			GlowStartTime == -1)
		{
			StartGlowEffect(1, BloomBloodRed, 0.05f, 0.0f, 0.5f);
		}
	}

	Super.UpdateLocator();
};

/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	return (SubjectPawn == None ||
			(SubjectPawn.TimeOfDeath != 0.0f &&
			 OwningHUD.WorldInfo.TimeSeconds - SubjectPawn.TimeOfDeath >= 2.0f));
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
			SquareIconAlpha = 1.0f;
			SquareIconColor = NormalWhite;
			RectangleIconAlpha = 0.0f;
		}
		// Else show the wingman icon
		else
		{
			SquareIconAlpha = 0.0f;
			RectangleIconAlpha = 1.0f;
			RectangleIconColor = NormalWhite;
			RectangleIconTexture = (ComradeGP.GetTeamNum() == 0) ? COGWingmanIconTexture : LocustWingmanIconTexture;
		}
	}
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	SquareIconTexture=Texture'Warfare_HUD.Location.HUD_revive'
	bShouldGlowWhenCreated=false
	bShouldFadeAfterRevive=false
	COGWingmanIconTexture=Texture'Warfare_HUD.UI_HUD_WMCog'
	LocustWingmanIconTexture=Texture'Warfare_HUD.UI_HUD_WMLocust'
	Priority=100
}
