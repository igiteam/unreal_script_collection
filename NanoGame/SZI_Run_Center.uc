/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SZI_Run_Center extends SafeZoneInfo;

defaultproperties
{
	Bounds_U=(Points=((InVal=0.f,OutVal=(X=0.17f,Y=0.83f))))
	Bounds_V=(Points=((InVal=0.f,OutVal=(X=0.13f,Y=0.80f))))
	Bounds_W=(Points=((InVal=0.f,OutVal=(X=128.f,Y=196.f))))

//	Bounds_U=(Points=((InVal=0.f,OutVal=(X=0.17f,Y=0.83f))))
//	Bounds_V=(Points=((InVal=0.f,OutVal=(X=0.3f,Y=0.50f))))
//	Bounds_W=(Points=((InVal=0.f,OutVal=(X=96.f,Y=596.f))))
	ViolationOffsetInterpSpeed=(X=8.f,Y=8.f,Z=10.f)
	
	ZoneName="Run_Center"
}