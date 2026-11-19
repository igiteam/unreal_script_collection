/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GameplayCam_SwatTurn extends GameplayCam_Cover;

var transient vector LastCoverViewOffsetAdjustment;
var() protected const float CoverViewOffsetAdjustmentInterpSpeed;

var transient vector GoalViewOffsetAdjustment;


function OnBecomeActive(Pawn CameraTarget, GameThirdPersonCameraMode PrevMode)
{
	Super.OnBecomeActive(CameraTarget, PrevMode);

	// destination viewoffset should just be mirror of departure offset
	GoalViewOffsetAdjustment = ThirdPersonCam.LastOffsetAdjustment;
	GoalViewOffsetAdjustment.Y = -GoalViewOffsetAdjustment.Y;

	LastCoverViewOffsetAdjustment = ThirdPersonCam.LastOffsetAdjustment;
}

function vector AdjustViewOffset( Pawn P, vector Offset )
{
	local vector ActualCoverAdjustment;

	// We're just interpolating from our offset when we left to the offset we expect to have when we 
	// arrive at the swat turn destination.
	ActualCoverAdjustment = VInterpTo(LastCoverViewOffsetAdjustment, GoalViewOffsetAdjustment, P.WorldInfo.DeltaSeconds, CoverViewOffsetAdjustmentInterpSpeed);
	LastCoverViewOffsetAdjustment = ActualCoverAdjustment;
 	
	return ActualCoverAdjustment + Offset;
}


defaultproperties
{
	bUsePerAxisOriginLocInterp=FALSE

	bInterpRotation=true
	OriginRotInterpSpeed=8

	CoverViewOffsetAdjustmentInterpSpeed=7.f
}
