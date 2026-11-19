/**
 * Camera for use on the zipline
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Zipline extends GameplayCam_Default
	native(Camera)
	config(Camera);

/** The FOV when the camera is zoomed */
var config float FOVZoom;

cpptext
{
	/**
	 * Returns View relative offsets 
	 * 
	 * @param ViewedPawn - the pawn the camera is viewing
	 * 
	 * @param ViewportConfig - configuration flags
	 * 
	 * @param DeltaTime - the time since last frame
	 * 
	 * @param out_Low - the low offsets for the camera
	 * 
	 * @param out_Mid - the mid offsets for the camera
	 * 
	 * @param out_High - the high offsets for the camera
	 */
	virtual void GetBaseViewOffsets(class APawn* ViewedPawn, BYTE ViewportConfig, FLOAT DeltaTime, FVector& out_Low, FVector& out_Mid, FVector& out_High);
}

/**
 * Change the FOV when zoomed in
 * 
 * @param ViewedPawn - the pawn being viewed
 * 
 * @return the FOV angle
 */
function float GetDesiredFOV(Pawn ViewedPawn)
{
	local GearPawn GP;

	GP = GearPawn(ViewedPawn);
	if (GP.bIsZoomed)
	{
		return FOVZoom + FOVAngle_ViewportAdjustments[CurrentViewportType];
	}
	else
	{
		return Super.GetDesiredFOV(ViewedPawn);
	}
}

defaultproperties
{
	bInterpLocation=FALSE

	StrafeOffsetInterpSpeedIn=20.f
	StrafeOffsetInterpSpeedOut=20.f
	RunOffsetInterpSpeedIn=20.f
	RunOffsetInterpSpeedOut=20.f

	TargetRelativeCameraOriginOffset=(X=10,Y=30)

	ViewOffset={(
		OffsetHigh=(X=-150,Y=32,Z=50),
		OffsetLow=(X=-160,Y=32,Z=66),
		OffsetMid=(X=-160,Y=32,Z=26),
		)}
}

