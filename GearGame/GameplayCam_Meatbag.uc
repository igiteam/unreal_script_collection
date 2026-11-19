/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Meatbag extends GameplayCam_Default
	config(Camera);

//var() vector2d FocusInterpSpeedRange;
// var() bool bFocusOnOrigin;
// 
// simulated function bool SetFocusPoint(Pawn ViewedPawn)
// {
// 	if (bFocusOnOrigin)
// 	{
// 		GameplayCam.SetFocusOnLoc( GameplayCam.LastActualCameraOrigin, FocusInterpSpeedRange, vect2d(3,3) );
// 		return true;
// 	}
// 
// 	return false;
// }

simulated protected function vector GetDOFFocusLoc(Actor TraceOwner, vector StartTrace, vector EndTrace)
{
	return GameplayCam.LastActualCameraOrigin;
}


defaultproperties
{
//	FocusInterpSpeedRange=(x=5,y=5)

	bAdjustDOF=true
	DOF_RadiusDistRange=(X=1,Y=1)
	DOF_RadiusRange=(X=1500,Y=1500)
	DOF_BlurKernelSize=15

	TargetRelativeCameraOriginOffset=(X=-15,Y=15)
	WorstLocOffset=(X=-15,Y=15,Z=75)

	ViewOffset={(
		OffsetHigh=(X=-100,Y=40,Z=30),
		OffsetLow=(X=-110,Y=40,Z=40),
		OffsetMid=(X=-100,Y=30,Z=16),
		)}

// 	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
// 		OffsetHigh=(X=0,Y=0,Z=-40),
// 		OffsetLow=(X=0,Y=0,Z=-40),
// 		OffsetMid=(X=0,Y=0,Z=-40),
// 		)}
// 	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
// 		OffsetHigh=(X=0,Y=0,Z=0),
// 		OffsetLow=(X=0,Y=0,Z=0),
// 		OffsetMid=(X=0,Y=0,Z=0),
// 		)}
// 	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
// 		OffsetHigh=(X=20,Y=0,Z=15),
// 		OffsetLow=(X=20,Y=0,Z=15),
// 		OffsetMid=(X=20,Y=0,Z=15),
// 		)}
// 	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
// 		OffsetHigh=(X=0,Y=0,Z=-40),
// 		OffsetLow=(X=0,Y=0,Z=-40),
// 		OffsetMid=(X=0,Y=0,Z=-40),
// 		)}
// 	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
// 		OffsetHigh=(X=0,Y=0,Z=0),
// 		OffsetLow=(X=0,Y=0,Z=0),
// 		OffsetMid=(X=0,Y=0,Z=0),
// 		)}

	BlendTime=0.15f

	bDoPredictiveAvoidance=FALSE
	bValidateWorstLoc=FALSE
}
