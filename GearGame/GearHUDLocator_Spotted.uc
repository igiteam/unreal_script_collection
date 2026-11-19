/**
 * GearHUDLocator_DBNO
 *
 * Class that controls and draws a single UI HUD locator for an enemy that has been spotted
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_Spotted extends GearHUDLocator;

/** Nemesis icon for COGs */
var Texture2D NemesisIconCOG;

/** Nemesis icon for Locust */
var Texture2D NemesisIconLocust;

/** Whether the icon is over a nemesis */
var bool bNemesis;

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
	local GearPawn SubjectPawn, HUDOwningPawn;
	local GearPC PC;
	local GearPRI GPRI;
	local bool bResult;

	TheHUD.PlayerOwner.PlaySound(SoundCue'Interface_Audio.Interface.TargetMarked_01_Cue', TRUE);

	PC = GearPC(TheHUD.PlayerOwner);
	if (PC != None)
	{
		HUDOwningPawn = GearPawn(PC.Pawn);
		GPRI = GearPRI(PC.PlayerReplicationInfo);
	}

	LocatorSubject = Subject;
	SubjectPawn = GearPawn(LocatorSubject);

	if (HUDOwningPawn != None && SubjectPawn != None && !SubjectPawn.IsSameTeam(HUDOwningPawn))
	{
		if (GPRI.IsNemesis(GetPRI()))
		{
			if (SubjectPawn.GetTeamNum() == 0)
			{
				SquareIconTexture = NemesisIconCOG;
			}
			else
			{
				SquareIconTexture = NemesisIconLocust;
			}

			bNemesis = TRUE;
		}
	}	
	bResult = Super.InitializeLocator(Subject, TheHUD);

	if (bResult)
	{
		if (SubjectPawn.GetTeamNum() == 0)
		{
			StartGlowEffect(2, COGBlue, 0.5, 0.0, 0.5);
		}
		else
		{		
			StartGlowEffect(2, BloomBloodRed, 0.5, 0.0, 0.5);
		}
	}
	return bResult;
}

/**
 * Whether or not this locator should be removed from the HUD
 *
 * @return TRUE if it should be removed
 */
function bool ShouldDeleteLocator()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	return (SubjectPawn == None || SubjectPawn == OwningHUD.PlayerOwner.Pawn ||
		    SubjectPawn.IsAHostage() || SubjectPawn.SpottedByTeam[OwningHUD.PlayerOwner.GetTeamNum()] == 0 ||
		    (SubjectPawn.PlayerReplicationInfo == None && SubjectPawn.DrivenVehicle == None) || SubjectPawn.TimeOfDeath > 0);
}

function UpdateArrowValues();

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	ArrowPulseAlpha = 0;

	SquareIconAlpha = 1.0f;

	TimerBGAlpha = 0.0f;

	if (bNemesis)
	{
		SquareIconColor = NormalWhite;
	}
	else
	{
		if (LocatorSubject.GetTeamNum() == 0)
		{
			SquareIconColor = COGBlue;
		}
		else
		{
			SquareIconColor = LocustRed;
		}
	}
}

/** Only show spotted locators when the subject is on screen or still pulsing */
function DrawLocator()
{	
	if (bSubjectIsInScreen || NumGlowPulses > 0)
	{
		Super.DrawLocator();
	}
}

// Gets the PRI for this locator. Will check for the locator being on a pawn driving a vehicle
function GearPRI GetPRI()
{
	local GearPRI PRI;
	local Pawn P;

	P = Pawn(LocatorSubject);

	if (P != none)
	{
		PRI = GearPRI(P.PlayerReplicationInfo);

		//If the pawn does not have a PRI, it may be controlling a vehicle, so check for that
		if (PRI == none)
		{
			if (P.DrivenVehicle != none)
			{
				PRI = GearPRI(P.DrivenVehicle.PlayerReplicationInfo);
			}
		}
	}

	return PRI;
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	SquareIconTexture=Texture2D'Warfare_HUD.HUD.T_HUD_Spotted_Icon'

	bUpdateInTacCom=true
	bUpdateWhileSpectating=true

	NemesisIconCOG=Texture2D'Warfare_HUD.HUD.T_HUD_Nemesis_IsCOG'
	NemesisIconLocust=Texture2D'Warfare_HUD.HUD.T_HUD_Nemesis_IsLocust'
	
	TotalVisibilityInterpTime=0.25f
	ResetAlphaTotalTime=0.25f
}
