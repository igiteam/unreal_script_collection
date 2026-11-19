/**
 * GearHUDLocator_Ring
 *
 * Class that controls and draws a single UI HUD locator for the ring in Annex and KOTH
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_Ring extends GearHUDLocator;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** The distance to the ring we must be for the locator to fade out */
var const float DistanceForFade;

/** The alpha region for when we are close to the ring */
var LocatorAlphaRegion RingAlphaRegion;


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Overloaded to check for reviving and death */
function UpdateLocator()
{
	local float RingDistance;
	local GearPawn MyPawn;
	local int RegionIdx;

	// Determine the distance from the ring and fade the locator
	// if we are close by using a fullscreen alpha region
	MyPawn = GearPawn(OwningHUD.PlayerOwner.Pawn);
	if (MyPawn != None)
	{
		RegionIdx = AlphaRegions.Find('RegionName', 'RingRegion');
		RingDistance = VSizeSq2D(LocatorSubject.Location - MyPawn.Location);

		// If we are close to the bomb
		if (RingDistance <= DistanceForFade * DistanceForFade)
		{
			// If we don't have a ring alpha region on, add it
			if (RegionIdx == INDEX_NONE)
			{
				RingAlphaRegion.TopLeft.X = 0.0f;
				RingAlphaRegion.TopLeft.Y = 0.0f;
				RingAlphaRegion.BottomRight.X = OwningHUD.Canvas.ClipX;
				RingAlphaRegion.BottomRight.Y = OwningHUD.Canvas.ClipY;
				AlphaRegions.AddItem(RingAlphaRegion);
			}
		}
		// Not close to the ring so remove the ring alpha region
		else
		{
			if (RegionIdx != INDEX_NONE)
			{
				AlphaRegions.RemoveItem(RingAlphaRegion);
			}
		}
	}

	Super.UpdateLocator();
}

/** Overloaded to draw the blood splat when the subject dies */
function DrawLocator()
{
	// Call superclass first since the splat needs drawn over it
	Super.DrawLocator();

	// Draw the resource point
	DrawResourcePoints();
}

/** Draw the resource points for the command point */
function DrawResourcePoints()
{
	local float DrawX;
	local float DrawY;
	local float DrawWidth;
	local float DrawHeight;
	local string StringToDraw;
	local GearGRI_Annex GRI;

	GRI = GearGRI_Annex(OwningHUD.WorldInfo.GRI);
	if (GRI != None &&
		GRI.CommandPoint != None)
	{
		// Draw the amount of points left
		if (GRI.CPResourceLeft < 0)
		{
			StringToDraw = "0";
		}
		else
		{
			StringToDraw = String(GRI.CPResourceLeft);
		}

		OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		OwningHUD.Canvas.TextSize(StringToDraw, DrawWidth, DrawHeight);
		DrawX = LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale) - (DrawWidth * 0.5f * LocatorScale);
		DrawY = LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale) - (DrawHeight * 0.5f * LocatorScale);
		OwningHUD.Canvas.SetPos(DrawX, DrawY);
		`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_WHITE], byte(255.0f * LocatorAlpha));
		OwningHUD.Canvas.DrawText(StringToDraw, false, LocatorScale, LocatorScale);
	}
}

/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	local GearGRI_MP GRI;

	GRI = GearGRI_MP(OwningHUD.WorldInfo.GRI);
	if (GRI != None &&
		(GRI.GameStatus > GS_RoundInProgress ||
		 GRI.CommandPoint == None ||
		 GRI.CommandPoint != LocatorSubject))
	{
		return true;
	}
	return false;
}

/**
 * Sets the world space where this locator should draw (center point)
 *
 * @return - Whether a world location was found to draw at
 */
function bool GetWorldSpaceLocation()
{
	if (LocatorSubject != None)
	{
		SubjectWorldLocation = LocatorSubject.Location;
		SubjectWorldLocation.Z -= -10;
		SubjectWorldDrawLocation = LocatorSubject.Location;
		SubjectWorldDrawLocation.Z += 30;
		return true;
	}

	return false;
}

/** Sets the locator timer for bleedout */
function SetTimerValues()
{
	local GearGRI_MP GRI;

	GRI = GearGRI_MP(OwningHUD.WorldInfo.GRI);
	if (GRI != None)
	{
		// If a team is controlling the command point
		if (GRI.CPControlTeam != -1)
		{
			TimerFillValue = 1.0f - float(GRI.CPControlPct) / 100.0f;
			TimerColor = (GRI.CPControlTeam == 0) ? COGBlue : LocustRed;
		}
		else
		{
			TimerColor = NormalWhite;
			TimerFillValue = 1.0f;
		}
	}

	TimerBGAlpha = 1.0f;
	TimerAlpha = 1.0f;
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	SquareIconColor = NormalWhite;
	SquareIconAlpha = 0.0f;
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	bUpdateInTacCom=true
	DistanceForFade=512.0f
	RingAlphaRegion=(RegionName=RingRegion,DestinationAlpha=0.4f,DestinationTime=2.0f)
	Priority=100
}
