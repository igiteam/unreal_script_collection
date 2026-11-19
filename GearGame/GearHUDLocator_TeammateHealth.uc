/*
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_TeammateHealth extends GearHUDLocator;

var Texture XButtonIconTexture;
var Texture YButtonIconTexture;

/** used to detect when Kantus has healed this target */
var float LastKantusFadeVal;

/** @return whether LocatorSubject is the owning player's current healing target (i.e. pressing X will heal this Pawn) */
final function bool IsCurrentHealTarget()
{
	local GearPawn OwningPawn;

	OwningPawn = GearPawn(OwningHUD.PlayerOwner.Pawn);
	if (OwningPawn == None)
	{
		return false;
	}
	else if (OwningPawn.CanDoSpecialMove(SM_ReviveTeammate) && GSM_ReviveTeammate(OwningPawn.SpecialMoves[SM_ReviveTeammate]).PawnToRevive == LocatorSubject)
	{
		return true;
	}
	else
	{
		return (OwningPawn.CanDoSpecialMove(GSM_Kantus_ReviveScream) && GSM_Kantus_ReviveScream(OwningPawn.SpecialMoves[GSM_Kantus_ReviveScream]).PawnsToHeal.Find(LocatorSubject) != INDEX_NONE);
	}
}

/** Overloaded to check for reviving and death */
function UpdateLocator()
{
	local GearPawn SubjectPawn;

	if (OwningHUD.ActiveAction.ActionName == 'ReviveTeammate' && OwningHUD.ActiveAction.bActive && IsCurrentHealTarget())
	{
		if (GearPC(OwningHUD.PlayerOwner) != None && GearPC(OwningHUD.PlayerOwner).bUseAlternateControls)
		{
			LocatorMI.SetTextureParameterValue('Icon', YButtonIconTexture);
		}
		else
		{
			LocatorMI.SetTextureParameterValue('Icon', XButtonIconTexture);
		}
	}
	else
	{
		LocatorMI.SetTextureParameterValue('Icon', SquareIconTexture);
	}

	SubjectPawn = GearPawn(LocatorSubject);
	if (SubjectPawn.DesiredKantusFadeVal != LastKantusFadeVal)
	{
		if (SubjectPawn.DesiredKantusFadeVal != 0.0)
		{
			StartGlowEffect(1, BloomWhite, 0.25, 0.25, 0.25);
		}
		LastKantusFadeVal = SubjectPawn.DesiredKantusFadeVal;
	}

	Super.UpdateLocator();
}

function bool ShouldDeleteLocator()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	return (SubjectPawn == None || SubjectPawn == OwningHUD.PlayerOwner.Pawn || SubjectPawn.Health <= 0 || OwningHUD.PlayerOwner.Pawn == None);
}

/** Sets the locator timer for bleedout */
function SetTimerValues()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	TimerFillValue = 1.0 - float(SubjectPawn.Health) / float(SubjectPawn.HealthMax);
	TimerBGAlpha = 1.0;
	TimerAlpha = 1.0;

	TimerColor = BloodRed;
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues();

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	XButtonIconTexture=Texture2D'Warfare_HUD.HUD_Dir_ButtonX'
	YButtonIconTexture=Texture2D'Warfare_HUD.HUD_Dir_ButtonY'
	SquareIconAlpha=1.0
	SquareIconColor=(R=0.0,G=0.0,B=0.0,A=1.0)
	Priority=100000
}
