/**
 * Special move for the Silverback jumping down ledges
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Silverback_MantleDown extends GSM_MantleDown;

/**
 * Move the Silverback past the ledge and let it drop for now since we don't have an animation
 * 
 * @param bForced - was the special move forced
 * 
 * @param PrevMove - the special move that transitioned to this one
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local float CollisionRad, CollisionHeight;
	local vector NewLoc;

	// Don't run GSM_MantleDown.SpecialMoveStarted at this time since we don't have an animation
	Super(GearSpecialMove).SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.GetBoundingCylinder(CollisionRad, CollisionHeight);
	NewLoc = PawnOwner.Location + CollisionRad * vector(PawnOwner.Rotation);
	PawnOwner.SetLocation(NewLoc);
	PawnOwner.EndSpecialMove();
}

/**
 * Don't run GSM_MantleDown.SpecialMoveEnded at this time since we don't have an animation
 * 
 * @param PrevMove - the special move that transitioned to this one
 * 
 * @param NextMove - the special move to transition to after this one
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super(GearSpecialMove).SpecialMoveEnded(PrevMove,NextMove);
}