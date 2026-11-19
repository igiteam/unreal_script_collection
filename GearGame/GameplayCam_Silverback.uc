
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Camera mode for when player is on a bloodmount.
 */

class GameplayCam_Silverback extends GameplayCam_Default
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

function vector AdjustViewOffset(Pawn P, vector Offset)
{
	local GearPawn_SilverbackBase Silverback;
	local Vector RootBoneOffset;

	// Offset by driver's root bone location, to help with transitions
	Silverback = GearPawn_SilverbackBase(P);
	if( Silverback != None && Silverback.Driver != None )
	{
		RootBoneOffset = (Silverback.Driver.Mesh.GetBoneLocation('b_MF_Root') - Silverback.Driver.Location) << Silverback.Driver.Rotation;
		RootBoneOffset.Z = 0.f;
		
		Offset += RootBoneOffset;
	}

	return Super.AdjustViewOffset(P, Offset);
}

simulated function bool SetFocusPoint(Pawn ViewedPawn)
{
	local GearPawn_SilverbackBase Silverback;

	Silverback = GearPawn_SilverbackBase(ViewedPawn);
	if( Silverback.IsDoingSpecialMove(GSM_Silverback_GetIn) || Silverback.IsDoingSpecialMove(GSM_Silverback_GetOut) )
	{
		GameplayCam.SetFocusOnActor( Silverback, '', vect2d(4,4), vect2d(8,11),, TRUE, FALSE, TRUE );
		return TRUE;
	}

	// no focus point by default
	return FALSE;
}

defaultproperties
{
	BlendTime=0.5f
	FOVBlendTime=0.25f

	ViewOffset={(
		OffsetHigh=(X=-128,Y=42,Z=65),
		OffsetLow=(X=-160,Y=42,Z=75),
		OffsetMid=(X=-160,Y=42,Z=32),
	)}
	
	WorstLocOffset=(X=-8,Y=1,Z=120)
}
