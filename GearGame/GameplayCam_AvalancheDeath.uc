/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_AvalancheDeath extends GameplayCam_Death
	config(Camera);

simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	return Super(GameplayCam_Default).GetCameraWorstCaseLoc(TargetPawn, CurrentViewTarget);
}

defaultproperties
{
	BlendTime=0.0f

	ViewOffset={(
		OffsetHigh=(X=-650,Y=0,Z=25),
		OffsetLow=(X=-650,Y=0,Z=100),
		OffsetMid=(X=-650,Y=0,Z=100),
		)}
	
	bInterpLocation=FALSE

	bValidateWorstLoc=FALSE
	WorstLocOffset=(X=-650,Y=0,Z=140)
}