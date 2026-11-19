/**
 * GearHUDLocator
 *
 * Class that controls and draws a single UI HUD locator for an object in 3D space
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearHUDLocator extends Object
	config(Game)
	transient;


/************************************************************************/
/* Constants															*/
/************************************************************************/

/** The width of the locator material */
var const int LocatorWidth;
/** The Height of the locator material */
var const int LocatorHeight;
/** The minimum scale the locator will draw at */
var const config float MinLocatorScale;
/** The maximum scale the locator will draw at */
var const config float MaxLocatorScale;
/** The distance away from the camera the subject must be to reach the MinLocatorScale */
var const config float DistanceForMinScale;

/** Whether this locator must be the only locator for the LocatorSubject */
var const bool bLocatorIsSubjectUnique;
/** Whether this locator must be the only locator of this class */
var const bool bLocatorIsTypeUnique;
/** Whether this locator must be the only locator of this class and for only LocatorSubject */
var const bool bLocatorIsSubjectAndTypeUnique;

/**
 * The priority of this locator (used for things like rendering last so that it appears on top of other locators etc.)
 * NOTE: Small number is lower priorty than larger number
 */
var int Priority;

/** Colors to use for locators (made constants for consistency across locators) */
var const LinearColor COGBlue;
var const LinearColor LocustRed;
var const LinearColor BloodRed;
var const LinearColor BloomWhite;
var const LinearColor NormalWhite;
var const LinearColor BloomBloodRed;

/** Structure to hold all data pertaining to an area on the screen where the locator should alpha/hide itself */
struct LocatorAlphaRegion
{
	/** The name of this region */
	var Name RegionName;
	/** Whether this region is currently active or not */
	var bool bIsActive;
	/** The top left corner of the rectangle to alpha behind */
	var Vector2D TopLeft;
	/** The bottom right corner of the rectangle to alpha behind */
	var Vector2D BottomRight;
	/** The destination alpha for this region */
	var float DestinationAlpha;
	/** The amount of time it should take to reach the destinatino alpha */
	var float DestinationTime;
};

/** Array of regions where we need to alpha the locator behind */
var Array<LocatorAlphaRegion> AlphaRegions;

/** Enum of the interpolation states */
enum ELocatorInterpState
{
	LISTATE_None,
	LISTATE_Up,
	LISTATE_Down,
};

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Reference to the HUD this locator was created for */
var transient GearHUD_Base OwningHUD;

/** The object this locator is pointing to */
var transient Actor LocatorSubject;

/** The material resource this locator uses to create the material instance for this locator */
var MaterialInterface LocatorMaterial;
/** The material instance this locator will create to draw the locator */
var transient MaterialInstanceConstant LocatorMI;

/** Screen coordinates of where to draw the locator */
var transient vector2D LocatorCoord;
/** The scale to draw the locator */
var transient float LocatorScale;
/** Amount to raise the locator from the top of the subject if it is a pawn */
var transient float LocatorPawnVertOffset;

/** The current alpha of the entire locator */
var transient float LocatorAlpha;
/** The time the alpha interp started */
var transient float StartTimeForAlphaInterp;
/** The alpha when the interp started */
var transient float StartAlphaInterpValue;
/** The direction the alpha is interpolating */
var transient ELocatorInterpState InterpState;
/** The current alpha region being applied to the locator */
var transient LocatorAlphaRegion CurrAlphaRegion;
/** The alpha called for due to visibility check */
var const float VisibilityAlpha;
/** The total interp time called for by the visibility check */
var const float TotalVisibilityInterpTime;
/** The total time it takes to reset the alpha back to full opacity */
var const float ResetAlphaTotalTime;
/** Start time for fading the locator completely */
var transient float StartFadingOutTime;
/** Total fade out time for the locator */
var const float TotalFadeOutTime;
/** Starting alpha for the fade out */
var transient float StartFadingOutAlpha;

/** Variables to store the arrow information */
/** The direction the arrow is pointing (0=up, 0.25=right, 0.5=down, 0.75=left */
var transient float ArrowDirection;
var transient float ArrowPulseAlpha;
/** Current value of which arrow is showing (0 = off screen-arrow, 1 = on-screen arrow */
var transient float OnScreenArrowValue;
/** Total amount of time to interp from 0 to 1 for the arrow */
var const float TotalArrowInterpTime;
/** Start time of the arrow interp */
var transient float StartTimeForArrowInterp;
/** The starting value for the arrow interp */
var transient float StartValueForArrowInterp;
/** The interp state for the arrow interp */
var transient ELocatorInterpState ArrowInterpState;

/** Variables to control the glow effect that surrounds the locator */
var transient float GlowValue;
var transient LinearColor GlowColor;
var transient float GlowTotalStartTime;
var transient float GlowTotalSustainTime;
var transient float GlowTotalEndTime;
var transient float GlowStartTime;
var transient int NumGlowPulses;

/** Variables to store the timer information */
var transient float TimerFillValue;
var transient float TimerBGAlpha;
var transient float TimerAlpha;
var transient LinearColor TimerColor;

/** Variables to store the data for the icon in the center of the locator (1 for square icon and 1 for rectangle) */
var transient Texture SquareIconTexture;
var transient Texture RectangleIconTexture;
var transient LinearColor SquareIconColor;
var transient LinearColor RectangleIconColor;
var transient float SquareIconAlpha;
var transient float RectangleIconAlpha;

/** texture for label that appears above the icon */
var Texture ContextLabel;

/** The world location where the locator should point to */
var transient vector SubjectWorldLocation;
/** The world location the locator should use for draw position */
var transient vector SubjectWorldDrawLocation;

/** Whether or not the icon's subject is within screenspace */
var transient bool bSubjectIsInScreen;
/** Whether or not the icon's subject is visible */
var transient bool bSubjectIsVisible;
/** The last time the visibility was checked for this icon's subject */
var transient float TimeOfLastVisibilityCheck;

/** whether this locator should be updated/drawn when in tac-com */
var transient bool bUpdateInTacCom;

/** Whether this locator should be updated/draw when NOT in tac-com...for tac-com only locators */
var transient bool bUpdateOutsideOfTacCom;

/** Whether this locator type should update while spectating */
var const bool bUpdateWhileSpectating;

/** The text to draw */
var transient string Text;
var transient vector2D TextCoord;
var transient float TextScale;
var transient EFontType TextFontType;
var transient EGearHUDColor TextColor;
var transient EGearHUDColor TextBackgroundColor;
var transient float TextAlpha;
var transient float TextVertOffset;

//Whether or not this is the first frame
var transient bool bIsNotFirstFrame;


/************************************************************************/
/* Script functions (not meant to be overloaded)                        */
/************************************************************************/

/** Calculates and returns the current scale of the locator to draw */
final function float GetCurrentLocatorScale()
{
	local GearPC PC;
	local vector CameraLoc;
	local Rotator CameraRot;
	local float Distance;
	local float ScaleResult;

	ScaleResult = 1.0f;

	PC = GearPC(OwningHUD.PlayerOwner);
	if (PC != None &&
		LocatorSubject != None)
	{
		PC.GetPlayerViewpoint(CameraLoc, CameraRot);
		Distance = VSize(LocatorSubject.Location - CameraLoc);
		if (Distance >= DistanceForMinScale)
		{
			ScaleResult = MinLocatorScale;
		}
		else
		{
			ScaleResult = MaxLocatorScale - ((Distance / DistanceForMinScale) * (MaxLocatorScale - MinLocatorScale));
		}
	}

	return ScaleResult;
}

/** Calculates the screen coordinates to draw the locator (top-left corner) */
function CalculateLocatorScreenCoordinatesAndScale()
{
	local GearPC PC;
	local vector ScreenLoc;
	local vector CameraLoc;
	local Rotator CameraRot;
	local int CurrWidth;
	local int CurrHeight;
	local int CurrHalfWidth;
	local bool bIsInFront;
	local vector ScreenDiff;
	local float TextX, TextY;
	local float DeltaTime;
	local float NewArrowDirection;
	local Vector ScreenVect;
	local float InterpSpeed;

	PC = GearPC(OwningHUD.PlayerOwner);

	// Get the world location of where to draw the locator and make sure the subject is valid
	if (PC != None &&
		LocatorSubject != None &&
		GetWorldSpaceLocation())
	{
		LocatorScale = GetCurrentLocatorScale();
		CurrWidth = LocatorWidth * LocatorScale;
		CurrHeight = LocatorHeight * LocatorScale;
		CurrHalfWidth = CurrWidth * 0.5f;

		// Get the location of the subject and the location/rotation of the camera
		PC.GetPlayerViewpoint(CameraLoc, CameraRot);

		// Get the screen coords for the subject location
		bIsInFront = OwningHUD.GetScreenCoordsOfSubject(OwningHUD.Canvas, SubjectWorldDrawLocation, ScreenLoc);
		ScreenLoc.Z = 0;

		// The subject is in front so project the draw location to the canvas
		if (bIsInFront)
		{
			// Subject is in front so set to true
			bSubjectIsInScreen = true;
		}
		// Subject is not in front of the camera so figure out where to place the locator on the bottom edge
		else
		{
			ScreenLoc.X = -ScreenLoc.X;
			ScreenLoc.Y = 10000;
		}

		// ScreenLoc is the center point to draw the locator so pull it back for drawing
		ScreenLoc.X -= CurrHalfWidth;
		ScreenLoc.Y -= CurrHeight;

		// Clip the top
		if (ScreenLoc.Y < OwningHUD.SafeZoneTop)
		{
			if (ScreenLoc.Y < 0)
			{
				bSubjectIsInScreen = false;
			}
			ScreenLoc.Y = OwningHUD.SafeZoneTop;
		}
		// Clip the bottom
		else if (ScreenLoc.Y + CurrHeight > OwningHUD.Canvas.ClipY - OwningHUD.SafeZoneBottom)
		{
			if (ScreenLoc.Y + CurrHeight > OwningHUD.Canvas.ClipY)
			{
				bSubjectIsInScreen = false;
			}
			ScreenLoc.Y = OwningHUD.Canvas.ClipY - OwningHUD.SafeZoneBottom - CurrHeight;
		}

		// Clip the left side
		if (ScreenLoc.X < OwningHUD.SafeZoneLeft)
		{
			if (ScreenLoc.X < 0)
			{
				bSubjectIsInScreen = false;
			}
			ScreenLoc.X = OwningHUD.SafeZoneLeft;
		}
		// Clip the right side
		else if (ScreenLoc.X + CurrWidth > OwningHUD.Canvas.ClipX - OwningHUD.SafeZoneRight)
		{
			if (ScreenLoc.X + CurrWidth > OwningHUD.Canvas.ClipX)
			{
				bSubjectIsInScreen = false;
			}
			ScreenLoc.X = OwningHUD.Canvas.ClipX - OwningHUD.SafeZoneRight - CurrWidth;
		}

		// Set the coordinates
		DeltaTime = OwningHUD.WorldInfo.TimeSeconds - OwningHUD.LastHUDRenderTime;
		InterpSpeed = bSubjectIsInScreen ? 10000 : 20;
		LocatorCoord.X = FInterpTo(LocatorCoord.X, ScreenLoc.X, DeltaTime, InterpSpeed);
		LocatorCoord.Y = FInterpTo(LocatorCoord.Y, ScreenLoc.Y, DeltaTime, InterpSpeed);

		// Calculate the text position
		OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(TextFontType);
		OwningHUD.Canvas.TextSize( Text, TextX, TextY );
		//X is centered
		TextCoord.X = (LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale)) - TextX*TextScale/2;
		//Y is above the locator
		TextCoord.Y = LocatorCoord.Y - TextY*TextScale + TextVertOffset*LocatorScale;

		// Point the arrow at the subject
		if (bIsInFront)
		{
			ScreenLoc.X += CurrHalfWidth;
			ScreenLoc.Y += CurrHeight;
			ScreenVect.X = OwningHUD.Canvas.ClipX/2;
			ScreenVect.Y = OwningHUD.Canvas.ClipY/2;
			ScreenDiff = Normal(ScreenLoc - ScreenVect);
			NewArrowDirection = ((Atan2(ScreenDiff.Y,-ScreenDiff.X) + PI) - (PI/2.0f)) / (2.0f*PI) - 0.015f;
		}
		else
		{
			NewArrowDirection = Lerp(0.375, 0.675, (ScreenLoc.X - OwningHUD.SafeZoneLeft) / (OwningHUD.Canvas.ClipX - OwningHUD.SafeZoneRight - OwningHUD.SafeZoneLeft - CurrWidth));
		}

		// Hack: only interpolate the arrow at the bottom of the screen to round the corners
		if (LocatorCoord.Y + CurrHeight > OwningHUD.Canvas.ClipY * 0.75f)
		{
			ArrowDirection = FInterpTo(ArrowDirection, NewArrowDirection, DeltaTime, 30);
		}
		else
		{
			ArrowDirection = NewArrowDirection;
		}
	}
}

/**
 * Sets the direction that the arrow should point, swaps between on/offscreen arrows and sets their alpha
 *  NOTE: the ArrowDirection is handled by the CalculateLocatorScreenCoordinatesAndScale() function
 */
function UpdateArrowValues()
{
	ArrowPulseAlpha = 1.0f;

	if (bSubjectIsInScreen)
	{
		// If we are not showing the locator pointing down already
		if (OnScreenArrowValue != 1.0f)
		{
			// If we just finished an interp
			if (StartTimeForArrowInterp != -1 &&
				StartTimeForArrowInterp + TotalArrowInterpTime < OwningHUD.WorldInfo.TimeSeconds)
			{
				OnScreenArrowValue = 1.0f;
				StartTimeForArrowInterp = -1;
				ArrowInterpState = LISTATE_None;
			}
			else
			{
				//Do not lerp if this is the first frame, just set it.
				if (!bIsNotFirstFrame)
				{
					OnScreenArrowValue = 1.0;
				}
				else
				{
					// If we never started an interp or we were doing one in the opposite direction start one
					if (StartTimeForArrowInterp == -1 ||
						ArrowInterpState == LISTATE_Down)
					{
						StartTimeForArrowInterp = OwningHUD.WorldInfo.TimeSeconds;
						StartValueForArrowInterp = OnScreenArrowValue;
						ArrowInterpState = LISTATE_Up;
					}

					// Set the new value via interping
					OnScreenArrowValue = StartValueForArrowInterp + ((1.0f - StartValueForArrowInterp) * ((OwningHUD.WorldInfo.TimeSeconds - StartTimeForArrowInterp) / TotalArrowInterpTime));
				}
			}
		}
	}
	else
	{
		// If we are not showing the locator pointing to subject
		if (OnScreenArrowValue != 0.0f)
		{
			// If we just finished an interp
			if (StartTimeForArrowInterp != -1 &&
				StartTimeForArrowInterp + TotalArrowInterpTime < OwningHUD.WorldInfo.TimeSeconds)
			{
				OnScreenArrowValue = 0.0f;
				StartTimeForArrowInterp = -1;
				ArrowInterpState = LISTATE_None;
			}
			else
			{
				//Do not lerp if this is the first frame, just set it.
				if (!bIsNotFirstFrame)
				{
					OnScreenArrowValue = 0.0;
				}
				else
				{
					// If we never started an interp or we were doing one in the opposite direction start one
					if (StartTimeForArrowInterp == -1 ||
						ArrowInterpState == LISTATE_Up)
					{
						StartTimeForArrowInterp = OwningHUD.WorldInfo.TimeSeconds;
						StartValueForArrowInterp = OnScreenArrowValue;
						ArrowInterpState = LISTATE_Down;
					}

					// Set the new value via interping
					OnScreenArrowValue = StartValueForArrowInterp - (StartValueForArrowInterp * ((OwningHUD.WorldInfo.TimeSeconds - StartTimeForArrowInterp) / TotalArrowInterpTime));
				}
			}
		}
	}
}

/** Initializes the icon textures in the material */
final function InitializeIconTextures()
{
	// Set the square texture if there is one
	if (SquareIconTexture != None)
	{
 		LocatorMI.SetTextureParameterValue('Icon', SquareIconTexture);
	}

	// Set the rectangle texture if there is one
	if (RectangleIconTexture != None)
	{
 		LocatorMI.SetTextureParameterValue('WingmanIcon', RectangleIconTexture);
	}
}

/** Checks to see if we can see the subject and sets the visibility flag if not */
final function UpdateSubjectVisibility()
{
	bSubjectIsVisible = false;

	if (OwningHUD != None &&
		OwningHUD.PlayerOwner != None)
	{
		bSubjectIsVisible = GearPC(OwningHUD.PlayerOwner).LineOfSightTo(LocatorSubject);
	}

	// Update the time we did the check
	TimeOfLastVisibilityCheck = OwningHUD.WorldInfo.TimeSeconds;
}

/**
 * Kicks off a glow effect pulse on the locator
 *
 * @param NumPulses - number of time this glow effect should happen in succession
 * @param GlowEffectColor - The color the glow effect should have
 * @param TotalStartTime - Amount of time it takes to fade the glow in
 * @param TotalSustainTime - Amount of time the glow should stay fully lit
 * @param TotalEndTime - Amount of time it takes to fade the glow out
 */
final function StartGlowEffect(int NumPulses, LinearColor GlowEffectColor, float TotalStartTime, float TotalSustainTime, float TotalEndTime)
{
	GlowValue = 0.0f;
	GlowColor = GlowEffectColor;
	GlowTotalStartTime = TotalStartTime;
	GlowTotalSustainTime = TotalSustainTime;
	GlowTotalEndTime = TotalEndTime;
	GlowStartTime = OwningHUD.WorldInfo.TimeSeconds;
	NumGlowPulses = NumPulses;
}

/** Kicks off a complete fade out of the locator to 0 alpha */
final function StartCompleteFadeOut()
{
	StartFadingOutAlpha = LocatorAlpha;
	StartFadingOutTime = OwningHUD.WorldInfo.TimeSeconds;
}

/** Updates the glow effect started by StartGlowEffect() */
final function UpdateGlowEffect()
{
	// If there is a glow effect happening
	if (GlowStartTime != -1)
	{
		// A glow effect just finished
		if (GlowStartTime + GlowTotalStartTime + GlowTotalSustainTime + GlowTotalEndTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			FinishedGlowEffectNotify();
		}
		// A glow effect is ramping down (ending)
		else if (GlowStartTime + GlowTotalStartTime + GlowTotalSustainTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			if (GlowTotalEndTime > 0.0f)
			{
				GlowValue = 1.0f - (OwningHUD.WorldInfo.TimeSeconds - (GlowStartTime + GlowTotalStartTime + GlowTotalSustainTime)) / GlowTotalEndTime;
			}
			else
			{
				FinishedGlowEffectNotify();
			}
		}
		// A glow effect is sustaining its' glow
		else if (GlowStartTime + GlowTotalStartTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			GlowValue = 1.0f;
		}
		// A glow effect is ramping up (starting)
		else if (GlowStartTime < OwningHUD.WorldInfo.TimeSeconds)
		{
			GlowValue = 0.0f + (OwningHUD.WorldInfo.TimeSeconds - GlowStartTime) / GlowTotalStartTime;
		}
	}
}

/** Determines what the current global alpha of the locator should be by taking AlphaRegions and Visibility into consideration */
final function UpdateGlobalAlphaValue()
{
	local float NewDestinationAlpha;
	local float NewInterpTime;
	local bool bVisibilityAlphaActive;
	local ELocatorInterpState OldInterpState;
	local bool bIsInterpingAlpha;

	// First see if we are doing a total fade out of the locator
	if (StartFadingOutTime != -1)
	{
		// If we are finished fading the locator out, set the locator to 0
		if (OwningHUD.WorldInfo.TimeSeconds > StartFadingOutTime + TotalFadeOutTime)
		{
			LocatorAlpha = 0.0f;
			StartFadingOutTime = -1.0f;
			FinishedFadingOut();
		}
		// Else interp to 0
		else
		{
			LocatorAlpha = StartFadingOutAlpha - (OwningHUD.WorldInfo.TimeSeconds - StartFadingOutTime) / TotalFadeOutTime;
		}
	}
	else
	{
		NewDestinationAlpha = 1.0f;
		NewInterpTime = 1.0f;

		// See if the visibility alpha should be active
		bVisibilityAlphaActive = (bSubjectIsInScreen && !bSubjectIsVisible);

		// See if there is a valid alpha region to consider
		if (CurrAlphaRegion.bIsActive)
		{
			NewDestinationAlpha = CurrAlphaRegion.DestinationAlpha;
			NewInterpTime = CurrAlphaRegion.DestinationTime;
			bIsInterpingAlpha = true;
		}

		// If there is visibility alpha to consider
		if (bVisibilityAlphaActive)
		{
			// See if we should use the visibility alpha or not (might not if we are in an alpha region)
			if (!CurrAlphaRegion.bIsActive ||
				NewDestinationAlpha > VisibilityAlpha)
			{
				NewDestinationAlpha = VisibilityAlpha;
				// We are using the visibility alpha but will use the smaller of the 2 values for the interp time
				if (!CurrAlphaRegion.bIsActive ||
					NewInterpTime > TotalVisibilityInterpTime)
				{
					NewInterpTime = TotalVisibilityInterpTime;
				}
			}

			bIsInterpingAlpha = true;
		}

		// If we are NOT interping the alpha, we need to interp it back to full opacity
		if (!bIsInterpingAlpha)
		{
			NewDestinationAlpha = 1.0f;
			NewInterpTime = ResetAlphaTotalTime;
		}

		// See if we need to interpolate to the alpha
		if (LocatorAlpha != NewDestinationAlpha)
		{
			// If the interp time expired, set the value and reset the start time
			if (StartTimeForAlphaInterp != -1 &&
				(StartTimeForAlphaInterp + NewInterpTime < OwningHUD.WorldInfo.TimeSeconds))
			{
				LocatorAlpha = NewDestinationAlpha;
				StartTimeForAlphaInterp = -1;
				StartAlphaInterpValue = LocatorAlpha;
				InterpState = LISTATE_None;
			}
			else
			{
				// Keep track of the old interp state
				OldInterpState = InterpState;
				// Set which direction we are interpolating
				InterpState = (NewDestinationAlpha > LocatorAlpha) ? LISTATE_Up : LISTATE_Down;

				// If there is no start time already or we are changing interp directions we must start a new interp
				if (StartTimeForAlphaInterp == -1 ||
					OldInterpState != InterpState)
				{
					StartTimeForAlphaInterp = OwningHUD.WorldInfo.TimeSeconds;
					StartAlphaInterpValue = LocatorAlpha;
				}

				// Calculate the alpha
				if (InterpState == LISTATE_Up)
				{
					LocatorAlpha = StartAlphaInterpValue + ((NewDestinationAlpha - StartAlphaInterpValue) * ((OwningHUD.WorldInfo.TimeSeconds - StartTimeForAlphaInterp) / NewInterpTime));
				}
				else
				{
					LocatorAlpha = StartAlphaInterpValue - ((StartAlphaInterpValue - NewDestinationAlpha) * ((OwningHUD.WorldInfo.TimeSeconds - StartTimeForAlphaInterp) / NewInterpTime));
				}
			}
		}
		else
		{
			StartTimeForAlphaInterp = -1;
			StartAlphaInterpValue = LocatorAlpha;
			InterpState = LISTATE_None;
		}
	}
}

/** Allows the locator to add/update alpha regions for the locator */
final function UpdateAlphaRegions()
{
	local int RegionIdx;
	local int TestIdx;
	local int OmenRegionIdx;
	local Vector2D LocatorTest;
	local bool bAlphaRegionIsActive;

	// Update the crimson omen region
	OmenRegionIdx = AlphaRegions.Find('RegionName', 'OmenRegion');
	if (OmenRegionIdx != INDEX_NONE)
	{
		AlphaRegions[OmenRegionIdx].TopLeft.X = OwningHUD.SafeZoneFriendlyCenterX - 0.5f * 177;
		AlphaRegions[OmenRegionIdx].TopLeft.Y = OwningHUD.SafeZoneFriendlyCenterY - 0.5f * 158;
		AlphaRegions[OmenRegionIdx].BottomRight.X = AlphaRegions[OmenRegionIdx].TopLeft.X + 177;
		AlphaRegions[OmenRegionIdx].BottomRight.Y = AlphaRegions[OmenRegionIdx].TopLeft.Y + 158;
	}

	// Reset the current alpha region
	CurrAlphaRegion.bIsActive = false;

	// Loop through the alpha regions
	for (RegionIdx = 0; RegionIdx < AlphaRegions.length; RegionIdx++)
	{
		bAlphaRegionIsActive = false;
		// Go through all 4 corners of the locator region
		for (TestIdx = 0; TestIdx < 4; TestIdx++)
		{
			switch (TestIdx)
			{
				// First test the top right corner
				case 0:
					LocatorTest.X = LocatorCoord.X;
					LocatorTest.Y = LocatorCoord.Y;
					break;
				// Then bottom right
				case 1:
					LocatorTest.X = LocatorCoord.X + LocatorWidth * LocatorScale;
					LocatorTest.Y = LocatorCoord.Y + LocatorHeight * LocatorScale;
					break;
				// Then top right
				case 2:
					LocatorTest.X = LocatorCoord.X + LocatorWidth * LocatorScale;
					LocatorTest.Y = LocatorCoord.Y;
					break;
				// Then bottom left
				case 3:
					LocatorTest.X = LocatorCoord.X;
					LocatorTest.Y = LocatorCoord.Y + LocatorHeight * LocatorScale;
					break;
			}

			// See if this region affects the alpha
			if (LocatorTest.X > AlphaRegions[RegionIdx].TopLeft.X &&
				LocatorTest.X < AlphaRegions[RegionIdx].BottomRight.X &&
				LocatorTest.Y > AlphaRegions[RegionIdx].TopLeft.Y &&
				LocatorTest.Y < AlphaRegions[RegionIdx].BottomRight.Y)
			{
				bAlphaRegionIsActive = true;
				break;
			}
		}

		// If the region is active see if we should update the current alpha region
		if (bAlphaRegionIsActive)
		{
			// If there isn't a current alpha region or the current region is more opaque than this region
			if (!CurrAlphaRegion.bIsActive ||
				CurrAlphaRegion.DestinationAlpha > AlphaRegions[RegionIdx].DestinationAlpha)
			{
				CurrAlphaRegion = AlphaRegions[RegionIdx];
				CurrAlphaRegion.bIsActive = true;
			}
		}
	}
}

/************************************************************************/
/* Script functions (can be overloaded)                                 */
/************************************************************************/

/**
 * Initialize the locator
 *
 * @param Subject - The object the locator points to (GearPawn, Annex Ring, etc.)
 * @param TheHUD - The HUD which created and owns this locator
 * @return - Whether the locator was able to be initialized
 */
simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	// Set the HUD that owns us
	OwningHUD = TheHUD;
	// Set the object this locator is pointing to
	LocatorSubject = Subject;

	// Create the material instance and set it
	if (LocatorMI == None)
	{
		LocatorMI = new(self) class'MaterialInstanceConstant';
		LocatorMI.SetParent(LocatorMaterial);
		// Initializes the icon textures in the material
		InitializeIconTextures();
	}

	return true;
}

/**
 * Called every frame so the locator can update itself, draw itself, and mark
 *	itself for deletion
 */
function UpdateLocator()
{
	if (!ShouldDeleteLocator())
	{
		// Update the screen coords for where to draw the locator
		CalculateLocatorScreenCoordinatesAndScale();

		// Draw the locator
		DrawLocator();

		// Draw the text
		DrawText();

		//Clearly this is no longer the first frame
		bIsNotFirstFrame = true;
	}
}

/** calls DrawMaterialTile() with the locator MIC; separated out so subclasses can easily change the parameters of the final draw call */
function DrawLocatorMI()
{
	// Set the position and draw
	OwningHUD.Canvas.SetPos(LocatorCoord.X, LocatorCoord.Y);
	OwningHUD.Canvas.DrawMaterialTile(LocatorMI, LocatorWidth * LocatorScale, LocatorHeight * LocatorScale, 0, 0, 1.f, 1.f);
}

/**
 * Called every frame so we can draw the locator on the canvas
 */
function DrawLocator()
{
	// Set arrow direction
	UpdateArrowValues();
	LocatorMI.SetScalarParameterValue('ArrowDirection', 1.0f-ArrowDirection);
	LocatorMI.SetScalarParameterValue('LocationArrowAlpha', ArrowPulseAlpha);
	LocatorMI.SetScalarParameterValue('OnScreen', OnScreenArrowValue);

	// Set the glow values
	UpdateGlowEffect();
	LocatorMI.SetScalarParameterValue('GlowFade', GlowValue);
	LocatorMI.SetVectorParameterValue('GlowColor', GlowColor);

	// Set timer
	SetTimerValues();
	LocatorMI.SetScalarParameterValue('TimerFill', 1.01f-TimerFillValue);
	LocatorMI.SetScalarParameterValue('TimerBGAlpha', TimerBGAlpha);
	LocatorMI.SetScalarParameterValue('TimerAlpha', TimerAlpha);
	LocatorMI.SetVectorParameterValue('TimerColor', TimerColor);

	// Set the icons
	SetIconValues();
 	LocatorMI.SetVectorParameterValue('IconTeamColor', SquareIconColor);
	LocatorMI.SetVectorParameterValue('WingmanTeamColor', RectangleIconColor);
	LocatorMI.SetScalarParameterValue('IconAlpha', SquareIconAlpha);
	LocatorMI.SetScalarParameterValue('WingmanIconAlpha', RectangleIconAlpha);
	LocatorMI.SetTextureParameterValue('ContextLabel', ContextLabel);
	LocatorMI.SetScalarParameterValue('ContextLabelFader', (ContextLabel != None) ? 1.0 : 0.0);

	// Update the alpha regions (must be done before the update of the global alpha since regions are considered)
	UpdateAlphaRegions();
	// Set the global alpha of the locator
	UpdateGlobalAlphaValue();
	// Set the alpha on the locator
	LocatorMI.SetScalarParameterValue('Alpha', LocatorAlpha);

	DrawLocatorMI();
}

/** Draw the text */
function DrawText()
{
	// Draw the text
	if (Text != "")
	{
		OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(TextFontType);
		//Background
		`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[TextBackgroundColor], LocatorAlpha*TextAlpha*255);
		OwningHUD.Canvas.SetPos(TextCoord.X-2, TextCoord.Y-2);
		OwningHUD.Canvas.DrawText(Text, FALSE, TextScale, TextScale);
		OwningHUD.Canvas.SetPos(TextCoord.X+2, TextCoord.Y+2);
		OwningHUD.Canvas.DrawText(Text, FALSE, TextScale, TextScale);
		//Foreground
		`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[TextColor], LocatorAlpha*TextAlpha*255);
		OwningHUD.Canvas.SetPos(TextCoord.X, TextCoord.Y);
		OwningHUD.Canvas.DrawText(Text, FALSE, TextScale, TextScale);
	}
}

/** Function called when a glow effect is finished */
function FinishedGlowEffectNotify()
{
	GlowValue = 0.0f;
	NumGlowPulses--;
	if (NumGlowPulses > 0)
	{
		GlowStartTime = OwningHUD.WorldInfo.TimeSeconds;
	}
	else
	{
		GlowStartTime = -1;
	}
}

/** Function to modify the world space location when the LocatorSubject is a GearPawn to deal with GearPawn states */
function ModifyWorldSpaceLocationForPawns()
{
	local GearPawn GP;

	GP = GearPawn(LocatorSubject);
	// If the subject is a gearpawn...
	if (GP != None && GP.HeadBoneNames.Length > 0)
	{
		SubjectWorldDrawLocation = GP.Mesh.GetBoneLocation(GP.HeadBoneNames[0]);
		SubjectWorldDrawLocation.Z += LocatorPawnVertOffset;
	}
}

/************************************************************************/
/* Script functions (should be overloaded by subclass)                  */
/************************************************************************/

/** Whether or not this locator should be removed from the HUD */
function bool ShouldDeleteLocator()
{
	return false;
}

/**
 * Sets the world space where this locator should draw (center point)
 *
 * @return - Whether a world location was found to draw at
 */
function bool GetWorldSpaceLocation()
{
	SubjectWorldLocation = LocatorSubject.Location;
	SubjectWorldDrawLocation = SubjectWorldLocation;
	ModifyWorldSpaceLocationForPawns();
	return true;
}

/** Sets the locator timer (bleedout, annex possession, etc.) */
function SetTimerValues()
{
	TimerFillValue = 1.0f;
	TimerBGAlpha = 0.0f;
	TimerAlpha = 0.0f;
	TimerColor = NormalWhite;
}

/** Sets the icon values up (textures, colors, alphas, etc.) */
function SetIconValues()
{
	SquareIconColor = NormalWhite;
	RectangleIconColor = NormalWhite;
	SquareIconAlpha = 0.0f;
	RectangleIconAlpha = 0.0f;
}

/** Called when the locator finishes a full fade out */
function FinishedFadingOut()
{
}

defaultproperties
{
	COGBlue=(R=0,G=0.5f,B=1.0f)
	LocustRed=(R=0.61f, G=0.0f, B=0.0f)
	BloodRed=(R=0.61f, G=0.0f, B=0.0f)
	BloomWhite=(R=2.0f, G=2.0f, B=2.0f)
	NormalWhite=(R=1.0f, G=1.0f, B=1.0f)
	BloomBloodRed=(R=1.0f, G=0.0f, B=0.0f)

	LocatorMaterial=Material'Warfare_HUD.Location.HUD_Location_Master'

	LocatorWidth=128
	LocatorHeight=128

	LocatorPawnVertOffset=10.f

	VisibilityAlpha=0.4f
	TotalVisibilityInterpTime=0.5f
	StartTimeForAlphaInterp=-1
	ResetAlphaTotalTime=0.5f
	TotalArrowInterpTime=0.25f
	StartTimeForArrowInterp=-1
	GlowStartTime=-1
	TotalFadeOutTime=0.5f
	StartFadingOutTime=-1

	AlphaRegions=((RegionName=OmenRegion,DestinationAlpha=0.3f,DestinationTime=0.25f))

	Text=""
	TextScale=1.0f
	TextFontType=FONT_Euro20
	TextColor=eWARHUDCOLOR_WHITE
	TextBackgroundColor=eWARHUDCOLOR_BLACK
	TextAlpha=1.0f
	TextVertOffset=37.0f

	bUpdateOutsideOfTacCom=true
	Priority=1
}
