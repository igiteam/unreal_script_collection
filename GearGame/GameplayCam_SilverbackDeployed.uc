
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Camera mode for when player is on a bloodmount.
 */

class GameplayCam_SilverbackDeployed extends GameplayCam_Default
	native(Camera)
	config(Camera);

/** How long should it take to blend between FOVs */
var float FOVBlendTime;

cpptext
{
	/**
	 * Return the blend time for the FOV
	 * 
	 * @param Pawn - the pawn we're viewing
	 *
	 * @return the blend time
	 */
	virtual FLOAT GetFOVBlendTime(class APawn* Pawn);
}

/**
 * Returns camera mode desired FOV
 * 
 * @param ViewedPawn - the pawn being viewed
 * 
 * @return the FOV
 */
function float GetDesiredFOV(Pawn ViewedPawn)
{
	local GearPawn_SilverbackBase Silverback;

	Silverback = GearPawn_SilverbackBase(ViewedPawn);
	if (Silverback != None)
	{
		return Silverback.GetCameraFOV() + FOVAngle_ViewportAdjustments[CurrentViewportType];
	}
	else
	{
		return Super.GetDesiredFOV(ViewedPawn);
	}
}

defaultproperties
{
	BlendTime=0.5f
	FOVBlendTime=0.25f

	bInterpViewOffsetOnlyForCamTransition=TRUE

	ViewOffset={(
		OffsetHigh=(X=-100,Y=0,Z=91),
		OffsetLow=(X=-318,Y=0,Z=51),
		OffsetMid=(X=-310,Y=0,Z=35),
		)}
	
	WorstLocOffset=(X=-8,Y=1,Z=110)
}
