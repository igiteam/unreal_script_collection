/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SZI_Jump_Down extends SafeZoneInfo;

defaultproperties
{
	Bounds_U=(Points=((InVal=0.f,OutVal=(X=0.17f,Y=0.83f))))
	Bounds_V=(Points=((InVal=0.f,OutVal=(X=0.13f,Y=0.80f)),(InVal=0.5f,OutVal=(X=0.13f,Y=0.43f))))
	Bounds_W=(Points=((InVal=0.f,OutVal=(X=128.f,Y=196.f))))
	
	bUsePitchBounds=TRUE
	Bounds_PitchHigh=-8000
	Bounds_PitchLow=-16384
	
	ZoneName="Jump_Down"
}