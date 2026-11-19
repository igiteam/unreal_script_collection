/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_Fortification extends GearHUDLocator;

/** health value of the subject the last time we looked (for detecting changes to show the icon and do pulses) */
var int LastHealth;

function bool ShouldDeleteLocator()
{
	return (LocatorSubject == None || LocatorSubject.bDeleteMe);
}

function SetTimerValues()
{
	local GearFortification TheFort;

	if (OwningHUD != None)
	{
		TheFort = GearFortification(LocatorSubject);

		// Don't show the timer if the bomb is counting down
		if (TheFort != None)
		{
			TimerFillValue = 1.0f - GearFortification(LocatorSubject).GetConditionPct();
			TimerColor = COGBlue;
		}
	}

	TimerBGAlpha = 1.0;
	TimerAlpha = 1.0;
}

function DrawLocator()
{
	local int CurrHealth;
	local GearFortification Fort;
	local string DrawText;
	local float DrawX, DrawY, DrawWidth, DrawHeight;
	local array<string> NamePieces;

	Fort = GearFortification(LocatorSubject);

	// see if the fortification's condition has changed
	if (OwningHUD.WorldInfo.GRI != None)
	{
		CurrHealth = Fort.Health;
		if (LastHealth != CurrHealth)
		{
			StartGlowEffect(3, BloomBloodRed, 0.5f, 0.0f, 0.5f);
			LastHealth = CurrHealth;
		}
	}

	if (NumGlowPulses > 0 || GearPC(OwningHUD.PlayerOwner).bAssessMode)
	{
		Super.DrawLocator();

		// draw the fortification type and level

		//@FIXME: temp designation since we have no icons
		ParseStringIntoArray(string(Fort.Class.Name), NamePieces, "_", false);
		DrawText = Left(NamePieces[1], 1) $ string(Fort.UpgradeLevel + 1);

		OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		OwningHUD.Canvas.TextSize(DrawText, DrawWidth, DrawHeight);
		DrawX = LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale) - (DrawWidth * 0.5f * LocatorScale);
		DrawY = LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale) - (DrawHeight * 0.5f * LocatorScale);
		OwningHUD.Canvas.SetPos(DrawX, DrawY);
		`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_WHITE], byte(255.0f * LocatorAlpha));
		OwningHUD.Canvas.DrawText(DrawText, false, LocatorScale, LocatorScale);
	}
}

defaultproperties
{
	bUpdateInTacCom=true
	TimerColor=(R=0,G=0.5f,B=1.0f)
	Priority=0
}
