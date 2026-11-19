/**
 * Special move for quickly jumping out of holes
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EmergeQuickJump extends GSM_BaseVariableFall
	native(SpecialMoves);

// Constraints for the initial velocity given to the jump
var float TakeoffVelocityHorizMin;
var float TakeoffVelocityHorizMax;
var float TakeoffVelocityVertMin;
var float TakeoffVelocityVertMax;

// how far guy needs to move before collision gets turned back on, and the cached location where the jump started
var transient vector StartJumpLoc;
var() float JumpDistBeforeCollisionRestoreSq;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	//Remove collision
	PawnOwner.SetCollision(PawnOwner.bCollideActors, FALSE);
	PawnOwner.bCollideWorld = FALSE;

	StartJumpLoc = PawnOwner.Location;
	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function vector GetJumpVelocity()
{
	local vector TakeoffVector;
	local vector X,Y,Z;
	local float HorizontalMagnitude;
	
	//Vertical component
	TakeoffVector.Z = RandRange(TakeoffVelocityVertMin,TakeoffVelocityVertMax);
	
	//Horizontal component
	HorizontalMagnitude = RandRange(TakeoffVelocityHorizMin,TakeoffVelocityHorizMax);

	GetAxes(PawnOwner.Rotation,X,Y,Z);
	TakeoffVector.X = X.X*HorizontalMagnitude;
	TakeoffVector.Y = X.Y*HorizontalMagnitude;	
	return TakeoffVector;
}

/** Play the jump portion of the SM */
simulated function PlayJump()
{
	PawnOwner.Velocity = GetJumpVelocity();
	
	Super.PlayJump();
}

simulated event RestoreCollision()
{
	// restore collision
	PawnOwner.SetCollision(PawnOwner.default.bCollideActors, PawnOwner.default.bBlockActors);
	PawnOwner.bCollideWorld = TRUE;

	PawnOwner.FitCollision();
}

simulated function bool IsFallLooping()
{
	return TRUE;
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_start")))
	BS_Transition=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_fall_start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="Emerge_Burst_land")))
	
	PreImpactTime=0.12f
	
	TakeoffVelocityHorizMin=100.0
	TakeoffVelocityHorizMax=200.0
	TakeoffVelocityVertMin=1200.0
	TakeoffVelocityVertMax=1400.0

	JumpDistBeforeCollisionRestoreSq=5625.0
}
