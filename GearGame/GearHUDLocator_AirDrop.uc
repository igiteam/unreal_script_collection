/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHUDLocator_AirDrop extends GearHUDLocator;

simulated function bool InitializeLocator(Actor Subject, GearHUD_Base TheHUD)
{
	local bool bResult;
	
	bResult = Super.InitializeLocator(Subject, TheHUD);

	if (bResult)
	{
		StartGlowEffect(3, BloomWhite, 0.5, 0.0, 0.5);
	}
	return bResult;
}

function bool ShouldDeleteLocator()
{
	return (LocatorSubject == None || LocatorSubject.bDeleteMe);
}

function DrawLocator()
{
	local string DrawText;
	local float DrawX, DrawY, DrawWidth, DrawHeight;

	Super.DrawLocator();

	// draw the icon
	//@FIXME: temp text
	DrawText = "$";

	OwningHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
	OwningHUD.Canvas.TextSize(DrawText, DrawWidth, DrawHeight);
	DrawX = LocatorCoord.X + (0.5f * LocatorWidth * LocatorScale) - (DrawWidth * 0.5f * LocatorScale);
	DrawY = LocatorCoord.Y + (0.5f * LocatorHeight * LocatorScale) - (DrawHeight * 0.5f * LocatorScale);
	OwningHUD.Canvas.SetPos(DrawX, DrawY);
	`SetHUDDrawColorExt(OwningHUD,OwningHUD.HudColors[eWARHUDCOLOR_WHITE], byte(255.0f * LocatorAlpha));
	OwningHUD.Canvas.DrawText(DrawText, false, LocatorScale, LocatorScale);
}

defaultproperties
{
	bUpdateOutsideOfTacCom=true
	Priority=50
}
