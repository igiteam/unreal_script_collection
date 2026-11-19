/**
 * GearHUDLocator_DBNO
 *
 * Class that controls and draws a single UI HUD locator for a DBNO comrade
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_DBNO extends GearHUDLocator;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** The material resource for drawing a blood splat over the locator when the subject is killed */
var MaterialInterface BloodSplatMaterial;
/** The material instance this locator will create to draw the blood splat */
var transient MaterialInstanceConstant BloodSplatMI;
/** Time we started showing the blood splat */
var transient float BloodSplatStartTime;
/** Amount of time to fade in the splat */
var const float TotalSplatStartTime;
/** Amount of time to sustain the splat */
var const float TotalSplatSustainTime;
/** Amount of time to fade out the splat */
var const float TotalSplatEndTime;

/** Whether the locator should immediately start a glow effect when first initialized */
var const bool bShouldGlowWhenCreated;
/** Whether the locator should fade out once the subject is revived */
var const bool bShouldFadeAfterRevive;

//Icon representing the button to be pressed to revive the player
var transient Texture XButtonIconTexture;
var transient Texture YButtonIconTexture;

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Overloaded to initialize the blood splat material */
simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	local bool bResult;

	// Create the blood splat material instance and set it
	if (BloodSplatMI == None)
	{
		BloodSplatMI = new(self) class'MaterialInstanceConstant';
		BloodSplatMI.SetParent(BloodSplatMaterial);
	}

	bResult = Super.InitializeLocator(Subject, TheHUD);

	// Do a red pulse when they first go down
	if (bResult &&
		bShouldGlowWhenCreated)
	{
		StartGlowEffect(1, BloomBloodRed, 0.05f, 1.45f, 0.5f);
	}

	// Clear any stale reviver information
	if (GearPawn(LocatorSubject) != None && GearPRI(GearPawn(LocatorSubject).PlayerReplicationInfo) != None)
	{
		GearPRI(GearPawn(LocatorSubject).PlayerReplicationInfo).LastToReviveMePRI = None;
	}

	return bResult;
}

/** @return whether LocatorSubject is the owning player's current revive target (i.e. pressing X will revive this Pawn) */
final function bool IsCurrentReviveTarget()
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

	SubjectPawn = GearPawn(LocatorSubject);

	// Start the revive glow when a player is revived
	if (SubjectPawn != None &&
		SubjectPawn.TimeOfRevival > 0.0f &&
		SubjectPawn.TimeOfRevival + 2.0f > OwningHUD.WorldInfo.TimeSeconds &&
		GlowStartTime == -1)
	{
		StartGlowEffect(1, BloomWhite, 0.5f, 1.5f, 0.0f);
	}

	// Start the fadeout when revived
	if (bShouldFadeAfterRevive &&
		SubjectPawn != None &&
		SubjectPawn.TimeOfRevival > 0.0f &&
		SubjectPawn.TimeOfRevival + 2.0f > OwningHUD.WorldInfo.TimeSeconds &&
		SubjectPawn.TimeOfRevival + 1.5f < OwningHUD.WorldInfo.TimeSeconds &&
		StartFadingOutTime == -1)
	{
		StartCompleteFadeOut();
	}

	// Start the fadeout when killed
	if ( SubjectPawn != None && SubjectPawn.TimeOfDeath != 0.0 &&
		BloodSplatStartTime != -1 && StartFadingOutTime == -1 &&
		BloodSplatStartTime + 1.5f < OwningHUD.WorldInfo.TimeSeconds )
	{
		StartCompleteFadeOut();
	}

	if (OwningHUD.ActiveAction.ActionName == 'ReviveTeammate' && OwningHUD.ActiveAction.bActive && IsCurrentReviveTarget())
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

	Super.UpdateLocator();
}

/** Overloaded to draw the blood splat when the subject dies */
function DrawLocator()
{
	local GearPawn SubjectPawn;

	// Call superclass first since the splat needs drawn over it
	Super.DrawLocator();

	SubjectPawn = GearPawn(LocatorSubject);

	// Start the blood splat since the subject was killed
	if (SubjectPawn != None && (SubjectPawn.TimeOfDeath != 0.0f || SubjectPawn.IsAHostage()))
	{
		if (BloodSplatStartTime == -1)
		{
			BloodSplatStartTime = OwningHUD.WorldInfo.TimeSeconds;
		}
	}
	else if (BloodSplatStartTime > -1)
	{
		BloodSplatStartTime = -1;
	}

	// If we are supposed to draw the blood splat
	if (BloodSplatStartTime != -1)
	{
		DrawBloodSplat();
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

/** Set the text to the subject's name, then draw it */
function DrawText()
{
	local GearPRI PRI;

	// only draw text in taccom
	if (GearPC(OwningHUD.PlayerOwner).bAssessMode)
	{
		PRI = GetPRI();
		if (PRI != None)
		{
			Text = PRI.PlayerName;
		}
		//Readjust Y value to be centered
		TextCoord.Y = (LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale)) + (TextCoord.Y - LocatorCoord.Y - TextVertOffset*LocatorScale)/2;
		Super.DrawText();
	}
}

/** Draws the blood splat for the locator when the subject is dying */
function DrawBloodSplat()
{
	local float DrawX, DrawY;
	local float SplatAlpha;

	if (GearPawn(LocatorSubject).TimeOfDeath > 0.0)
	{
		// See if we just finished the splat
		if (BloodSplatStartTime + TotalSplatStartTime + TotalSplatSustainTime + TotalSplatEndTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			BloodSplatStartTime = -1;
			SplatAlpha = 0.0f;
		}
		// If the splat is ramping down (ending)
		if (BloodSplatStartTime + TotalSplatStartTime + TotalSplatSustainTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			if (TotalSplatEndTime > 0.0f)
			{
				SplatAlpha = 1.0f - (OwningHUD.WorldInfo.TimeSeconds - (BloodSplatStartTime + TotalSplatStartTime + TotalSplatSustainTime)) / TotalSplatEndTime;
			}
			else
			{
				BloodSplatStartTime = -1;
				SplatAlpha = 0.0f;
			}
		}
		// If the splat is sustaining
		else if (BloodSplatStartTime + TotalSplatStartTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			SplatAlpha = 1.0f;
		}
		// If the splat is ramping up (starting)
		else if (BloodSplatStartTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			SplatAlpha = 0.0f + (OwningHUD.WorldInfo.TimeSeconds - BloodSplatStartTime) / TotalSplatStartTime;
		}
	}
	else
	{
		// if the target isn't dead yet (or isn't actually going to die), then use full alpha
		SplatAlpha = 1.0;
	}

	// Apply the global locator alpha to the splat one
	SplatAlpha *= LocatorAlpha;

	// Set the alpha parameter for the splat
	BloodSplatMI.SetScalarParameterValue('TaccomDead_Fade', 1.0f - SplatAlpha);

	DrawX = LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale) - (64.f * LocatorScale);
	DrawY = LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale) - (128.f * LocatorScale);
	OwningHUD.Canvas.SetPos(DrawX, DrawY);
	OwningHUD.Canvas.DrawMaterialTile(BloodSplatMI, 128.f * LocatorScale, 256.f * LocatorScale);
}

/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	return (SubjectPawn == None || SubjectPawn == OwningHUD.PlayerOwner.Pawn ||
		SubjectPawn.IsAHostage() ||
		!OwningHUD.ShouldDrawDBNOIndicator(SubjectPawn)) ||
		(BloodSplatStartTime != -1 && BloodSplatStartTime + 2.0f < OwningHUD.WorldInfo.TimeSeconds);
}

/** Sets the locator timer for bleedout */
function SetTimerValues()
{
	local GearPawn SubjectPawn;

	SubjectPawn = GearPawn(LocatorSubject);
	TimerFillValue = OwningHUD.CalculateRevivePercentAlive(SubjectPawn);
	TimerBGAlpha = 1.0f;
	TimerAlpha = 1.0f;

	// The fill needs to go white after being revived to signal teammates during the fade out period.
	if (!SubjectPawn.IsDBNO() && SubjectPawn.TimeOfRevival > 0.0f && SubjectPawn.TimeOfRevival + 2.0f > OwningHUD.WorldInfo.TimeSeconds)
	{
		TimerFillValue = 0;
		TimerColor = NormalWhite;
	}
	else
	{
		TimerColor = BloodRed;
	}
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	SquareIconAlpha = 1.0f;
	SquareIconColor = NormalWhite;
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	SquareIconTexture=Texture'Warfare_HUD.Location.HUD_revive'
	XButtonIconTexture=Texture2D'Warfare_HUD.HUD_Dir_ButtonX'
	YButtonIconTexture=Texture2D'Warfare_HUD.HUD_Dir_ButtonY'
	BloodSplatMaterial=Material'Warfare_HUD.M_HUD_Taccom_Dead'
	TotalSplatStartTime=0.05f
	TotalSplatSustainTime=1.45f
	TotalSplatEndTime=0.5f
	BloodSplatStartTime=-1
	bShouldGlowWhenCreated=true
	bShouldFadeAfterRevive=true
	bUpdateInTacCom=true
	Priority=100000
}
