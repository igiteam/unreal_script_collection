/**
 * GearHUDLocator_Bomb
 *
 * Class that controls and draws a single UI HUD locator for the bomb
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator_Bomb extends GearHUDLocator;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** The distance to the bomb we must be for the locator to fade out */
var const float DistanceForFade;

/** The alpha region for when we are close to the bomb */
var LocatorAlphaRegion BombAlphaRegion;

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Overloaded to check for reviving and death */
function UpdateLocator()
{
	local float BombDistance;
	local GearPawn MyPawn;
	local int RegionIdx;
	local float TrackPercent;
	local GearTrackBomb TheBomb;

	// Determine the distance from the bomb and fade out the locator
	// if we are close by using a fullscreen alpha region
	MyPawn = GearPawn(OwningHUD.PlayerOwner.Pawn);
	TheBomb = GearTrackBomb(LocatorSubject);
	if (MyPawn != None)
	{
		RegionIdx = AlphaRegions.Find('RegionName', 'BombRegion');
		BombDistance = VSizeSq2D(LocatorSubject.Location - MyPawn.Location);

		// If we are close to the bomb
		if (BombDistance <= DistanceForFade * DistanceForFade)
		{
			// If the bomb is health
			if (TheBomb.Health == TheBomb.DefaultHealth &&
				TheBomb.CountdownRemaining <= 0)
			{
				// If we don't have a bomb alpha region on, add it
				if (RegionIdx == INDEX_NONE)
				{
					BombAlphaRegion.TopLeft.X = 0.0f;
					BombAlphaRegion.TopLeft.Y = 0.0f;
					BombAlphaRegion.BottomRight.X = OwningHUD.Canvas.ClipX;
					BombAlphaRegion.BottomRight.Y = OwningHUD.Canvas.ClipY;
					AlphaRegions.AddItem(BombAlphaRegion);
				}
			}
			// Unhealthy bomb
			else
			{
				AlphaRegions.RemoveItem(BombAlphaRegion);
			}
		}
		// Not close to the bomb so remove the bomb alpha region
		else
		{
			if (RegionIdx != INDEX_NONE)
			{
				AlphaRegions.RemoveItem(BombAlphaRegion);
			}
		}
	}

	// See if we should show any pulse effects
	TheBomb = GearTrackBomb(LocatorSubject);
	if (TheBomb != None)
	{
		// First see if we should show a red pulse for the bomb blowing up
		if (TheBomb.CountdownRemaining > 0)
		{
			if (GlowStartTime == -1)
			{
				StartGlowEffect(1, BloomBloodRed, 0.5f, 0.0f, 0.5f);
			}
		}
		// Else see if we should do a white pulse for being near the end of the bomb track
		else
		{
			TrackPercent = TheBomb.TrackMatinee.Position / TheBomb.TrackMatinee.InterpData.InterpLength;
			if (TrackPercent > 0.9f &&
				GlowStartTime == -1)
			{
				StartGlowEffect(1, BloomWhite, 0.5f, 0.0f, 0.5f);
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

	// Draw the countdown for the explosion
	DrawBombCountdown();
}

/** Draw the countdown for the explosion */
function DrawBombCountdown()
{
	local float DrawX;
	local float DrawY;
	local GearTrackBomb TheBomb;
	local float DrawWidth;
	local float DrawHeight;
	local string StringToDraw;

	TheBomb = GearTrackBomb(LocatorSubject);
	if (TheBomb != None &&
		TheBomb.CountdownRemaining > 0)
	{
		OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		StringToDraw = string(TheBomb.CountdownRemaining);
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
	local GearGRI GRI;

	GRI = GearGRI(OwningHUD.WorldInfo.GRI);
	if (GRI != None &&
		(GRI.GameStatus > GS_RoundInProgress ||
		 LocatorSubject == None))
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
		SubjectWorldDrawLocation.Z += 80;
		return true;
	}

	return false;
}

/** Sets the locator timer for bleedout */
function SetTimerValues()
{
	local GearTrackBomb TheBomb;

	if (OwningHUD != None)
	{
		TheBomb = GearTrackBomb(LocatorSubject);

		// Don't show the timer if the bomb is counting down
		if (TheBomb != None &&
			TheBomb.CountdownRemaining <= 0)
		{
			TimerFillValue = 1.0f - float(TheBomb.Health) / float(TheBomb.DefaultHealth);
			TimerColor = (TheBomb.TeamNum == 0) ? COGBlue : LocustRed;
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
	local GearTrackBomb TheBomb;

	TheBomb = GearTrackBomb(LocatorSubject);
	// Don't show the icon if the bomb is counting down
	if (TheBomb != None &&
		TheBomb.CountdownRemaining > 0)
	{
		SquareIconAlpha = 0.0f;
	}
	else
	{
		SquareIconColor = NormalWhite;
		SquareIconAlpha = 1.0f;
	}
}

defaultproperties
{
	bLocatorIsSubjectAndTypeUnique=true
	SquareIconTexture=Texture'Warfare_HUD.HUD.UI_HUD_Leader'
	DistanceForFade=512.0f
	BombAlphaRegion=(RegionName=BombRegion,DestinationAlpha=0.0f,DestinationTime=1.5f)
	Priority=100
}
