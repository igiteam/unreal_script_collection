/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_DropTheHammer extends NanoThirdPersonCameraMode
	config(Camera)
	native(Camera);

defaultproperties
{
	bInterpToIdealLocThenLock=TRUE
	InterpLocTime=0.25f
	bInterpLocByTime=TRUE

	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=TRUE
	bInterpToIdealRotThenLock=TRUE

	bUseCameraBoneRotation=TRUE
	OriginRotInterpSpeed=20


	BlendTime=0.2f

	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
	)}
}