/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_CorpserLarva extends GearGameplayCameraMode
	config(Camera);

var() protected const vector OffsetAdjustmentWhileEmerging;

/** Last known world time our pawn was emerging */
var protected float LastEmergingTime;

var() protected const float EmergeCamCarryoverTime;

/** Internal */
protected function bool ShouldDoEmergeCam(Pawn P)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase C;

	C = GearPawn_LocustCorpserLarvaUndergroundBase(P);
	if ( (C != None) && 
		  (  C.IsDoingSpecialMove(SM_Emerge_Type1) || 
		     (C.WorldInfo.TimeSeconds < (LastEmergingTime + EmergeCamCarryoverTime)) ) 
		)
	{
		return TRUE;
	}

	return FALSE;
}

/** 
 * Allows mode to make any final situational adjustments to the base view offset.
 */
simulated function vector AdjustViewOffset( Pawn P, vector Offset )
{
	// keep track of when emerging
	if ( (GearPawn(P) != None) && GearPawn(P).IsDoingSpecialMove(SM_Emerge_Type1) )
	{
		LastEmergingTime = P.WorldInfo.TimeSeconds;
	}

	if (ShouldDoEmergeCam(P))
	{
		return Super.AdjustViewOffset(P, Offset) + OffsetAdjustmentWhileEmerging;
	}

	return Super.AdjustViewOffset(P, Offset);
}

/**
 * Camera mode has a chance to set a focus point, if it so chooses.
 * Return true if setting one, false if not.
 */
simulated function bool SetFocusPoint(Pawn ViewedPawn)
{
	if (ShouldDoEmergeCam(ViewedPawn))
	{
		GameplayCam.SetFocusOnActor( ViewedPawn, 'Upper_Spine_2', vect2d(2,2), vect2d(2,2),, TRUE, FALSE, TRUE );
		return TRUE;
	}

	// no focus point by default
	return FALSE;
}


defaultproperties
{
	EmergeCamCarryoverTime=0.5f
	OffsetAdjustmentWhileEmerging=(X=-50,Z=300)
	OffsetAdjustmentInterpSpeed=1.5f

	WorstLocOffset=(X=-8,Y=1,Z=95)
	bValidateWorstLoc=FALSE

	OriginLocInterpSpeed=7.f
	bSmoothViewOffsetPitchChanges=true

	ViewOffset={(
		OffsetHigh=(X=-200,Y=0,Z=90),
		OffsetLow=(X=-225,Y=0,Z=35),
		OffsetMid=(X=-260,Y=0,Z=20),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-12),
		OffsetLow=(X=0,Y=0,Z=-12),
		OffsetMid=(X=0,Y=0,Z=-12),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=0,Y=-20,Z=0),
		OffsetLow=(X=0,Y=-20,Z=0),
		OffsetMid=(X=0,Y=-20,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=0,Y=0,Z=17),
		OffsetLow=(X=0,Y=0,Z=17),
		OffsetMid=(X=0,Y=0,Z=17),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-15),
		OffsetLow=(X=0,Y=0,Z=-15),
		OffsetMid=(X=0,Y=0,Z=-15),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	BlendTime=0.25
}



