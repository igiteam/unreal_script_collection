/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Vehicle_KingRaven extends GameplayCam_Vehicle
	config(Camera);

/** returns camera mode desired FOV */
simulated function float GetDesiredFOV(Pawn ViewedPawn)
{	
 	local GearWeaponPawn GearWP;

	GearWP = GearWeaponPawn(ViewedPawn);
	if (GearWP.ShouldTargetingModeZoomCamera())
	{
		return 40 + FOVAngle_ViewportAdjustments[CurrentViewportType];
	}

	return Super.GetDesiredFOV(ViewedPawn);
}