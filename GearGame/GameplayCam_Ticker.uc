/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Ticker extends GearGameplayCameraMode
	dependson(GearPawn_LocustTickerBase)
	config(Camera);

var() protected const vector OffsetAdjustmentWhileExploding;
var() protected const vector OffsetAdjustmentWhileRagdolled;

var() protected const float OffsetAdjustmentInterpSpeed_Ragdoll;
var() protected const float OffsetAdjustmentInterpSpeed_Exploding;

/** 
 * Allows mode to make any final situational adjustments to the base view offset.
 */
function vector AdjustViewOffset( Pawn P, vector Offset )
{
	local GearPawn_LocustTickerBase T;

	// this one by default
	OffsetAdjustmentInterpSpeed = OffsetAdjustmentInterpSpeed_Exploding;

	T = GearPawn_LocustTickerBase(P);
	if (T != None)
	{
		if (T.bExplode)
		{
			return Super.AdjustViewOffset(P, Offset) + OffsetAdjustmentWhileExploding;
		}
		else if (T.Physics == PHYS_RigidBody)
		{
			// faster interp for this one
			OffsetAdjustmentInterpSpeed = OffsetAdjustmentInterpSpeed_Ragdoll;
			return Super.AdjustViewOffset(P, Offset) + OffsetAdjustmentWhileRagdolled;
		}
	}

	return Super.AdjustViewOffset(P, Offset);
}

/**
 * Camera mode has a chance to set a focus point, if it so chooses.
 * Return true if setting one, false if not.
 */
simulated function bool SetFocusPoint(Pawn ViewedPawn)
{
	local GearPawn_LocustTickerBase T;

	T = GearPawn_LocustTickerBase(ViewedPawn);

	// focus on pawn if blowing up or flying through the air
	if ( (T != None) && (T.bExplode || T.Physics == PHYS_RigidBody) )
	{
		GameplayCam.SetFocusOnActor( T, 'body', vect2d(6,6), vect2d(8,11),, TRUE, FALSE, TRUE );
		return TRUE;
	}

	// no focus point by default
	return FALSE;
}


defaultproperties
{
	OffsetAdjustmentWhileExploding=(X=-200,Z=200)
	OffsetAdjustmentWhileRagdolled=(X=-100,Z=100)

	OriginLocInterpSpeed=10.f

	WorstLocOffset=(X=-8,Y=0,Z=45)
	bValidateWorstLoc=FALSE

	ViewOffset={(
		OffsetHigh=(X=-170,Y=0,Z=45),
		OffsetLow=(X=-100,Y=0,Z=80),
		OffsetMid=(X=-170,Y=0,Z=25),
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

	PerPawnViewOffsetAdjustments.Empty

	BlendTime=0.25

	OffsetAdjustmentInterpSpeed=1.5f
	OffsetAdjustmentInterpSpeed_Exploding=1.5f
	OffsetAdjustmentInterpSpeed_Ragdoll=10.f
}
