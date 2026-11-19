/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GameplayCam_RoadieRunStab extends GameplayCam_Default
	config(Camera);

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=0,Y=56,Z=50),
		OffsetMid=(X=-40,Y=48,Z=-40),
		OffsetLow=(X=-40,Y=56,Z=-40),
		)}
		ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=30,Y=0,Z=0),
		OffsetLow=(X=30,Y=0,Z=0),
		OffsetMid=(X=30,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	
	FOVAngle_ViewportAdjustments(CVT_16to9_VertSplit)=20

	RunFwdAdjustment=(X=0,Y=0,Z=0)
	RunBackAdjustment=(X=0,Y=0,Z=0)

	WorstLocOffset=(X=-20,Y=10,Z=60)

	bDoPredictiveAvoidance=FALSE
	bValidateWorstLoc=FALSE

	BlendTime = 0.25

	bUsePerAxisOriginLocInterp = TRUE
	PerAxisOriginLocInterpSpeed=(X=8,Y=20,Z=20)
}

