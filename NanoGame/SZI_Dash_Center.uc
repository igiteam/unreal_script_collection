/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SZI_Dash_Center extends SafeZoneInfo;

defaultproperties
{
	Bounds_U=(Points=((InVal=0.f,OutVal=(X=0.17f,Y=0.83f)),(InVal=3.f,OutVal=(X=0.45f,Y=0.55f))))
	Bounds_V=(Points=((InVal=0.f,OutVal=(X=0.13f,Y=0.80f)),(InVal=3.f,OutVal=(X=0.5f,Y=0.80f))))
	Bounds_W=(Points=((InVal=0.f,OutVal=(X=128.f,Y=512.f)),(InVal=5.f,OutVal=(X=128.f,Y=196.f))))

	bUsePitchBounds=TRUE
	Bounds_PitchHigh=0
	Bounds_PitchLow=0

	ZoneName="Dash_Center"
}