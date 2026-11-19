/**
 * GearHUDLocator_SpottedPickup
 *
 * Class that controls and draws a single UI HUD locator for a pickup that has been spotted
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_SpottedPickup extends GearHUDLocator;

/** PRI that initially spotted this actor */
var GearPRI SpottingPRI;

/**
 * Play an init sound and hook up nemesis icons
 *
 * @param Subject - The object the locator points to (GearPawn, Annex Ring, etc.)
 *
 * @param TheHUD - The HUD which created and owns this locator
 *
 * @return - Whether the locator was able to be initialized
 */
simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{	
	local GearGRI GRI;
	local bool bResult;
	local GearPickupFactory PickupFactory;
	local GearDroppedPickup DroppedPickup;	

	PickupFactory = GearPickupFactory(Subject);
	DroppedPickup = GearDroppedPickup(Subject);

	if (PickupFactory != None)
	{
		Text = PickupFactory.GetDisplayName();
	}
	else if (DroppedPickup != None)
	{
		Text = DroppedPickup.GetDisplayName();
	}	

	GRI = GearGRI(TheHud.WorldInfo.GRI);

	TheHUD.PlayerOwner.PlaySound(SoundCue'Interface_Audio.Interface.TargetMarked_01_Cue', TRUE);

	if (GRI != None)
	{
		SpottingPRI = GRI.FindPRISpottingPickup(Subject,TheHud.PlayerOwner.GetTeamNum());
	}

	bResult = Super.InitializeLocator(Subject, TheHUD);

	if (bResult)
	{
		StartGlowEffect(2, BloomWhite, 0.5, 0.0, 0.5);
	}
	return bResult;
}

/** Draw the text */
function DrawText()
{
	if (bSubjectIsInScreen || NumGlowPulses > 0)
	{
		Super.DrawText();
	}
}

/**
 * Whether or not this locator should be removed from the HUD
 *
 * @return TRUE if it should be removed
 */
function bool ShouldDeleteLocator()
{
	return (LocatorSubject == None || SpottingPRI == None || SpottingPRI.SpottedPickup != LocatorSubject);
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	SquareIconAlpha = 1.0f;
	SquareIconColor = NormalWhite;
}

/** Only show spotted locators when the subject is on screen or still pulsing */
function DrawLocator()
{	
	if (bSubjectIsInScreen || NumGlowPulses > 0)
	{
		Super.DrawLocator();
	}
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	SquareIconTexture=Texture2D'Warfare_HUD.HUD.T_HUD_Spotted_Icon'

	bUpdateInTacCom=true
	bUpdateWhileSpectating=true
}
