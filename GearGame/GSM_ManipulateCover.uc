
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GSM_ManipulateCover extends GearSpecialMove
	abstract
	native(SpecialMoves)
	config(Pawn);

/** Cover movement animation */
var() GearPawn.BodyStance BS_ManipulateCover;

/** Direction the pawn was facing at the start of the special move */
var vector Direction;


/**
* Allow chaining with other ManipulateCover special moves
*/
simulated function bool CanChainMove(ESpecialMove NextMove)
{
	return ( NextMove == SM_PushCover );
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local InterpActor_MovableCover InterpCoverObject;

	// Set the direction for push or pull
	Direction = vector(PawnOwner.Rotation);
	Direction.Z = 0.f;
	Direction = Normal(Direction);

	InterpCoverObject = GetMovableInterpActor();
	if( InterpCoverObject != None )
	{
		// Start movement sounds if we were not already manipulating cover
		if( PrevMove != SM_PushCover )
		{
			PawnOwner.StartMoveCoverLoop();
			InterpCoverObject.ApplyMovement(PawnOwner);
		}
	}

	Super.SpecialMoveStarted(bForced,PrevMove);
	PawnOwner.BS_Play(BS_ManipulateCover, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier);
	// Get notification when anim ends, so we can properly chain the run_fwd loop.
	PawnOwner.BS_SetAnimEndNotify(BS_ManipulateCover, TRUE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local InterpActor_MovableCover InterpCoverObject;

	// Handle coverlink updates and stopping sounds if we are no longer manipulating cover
	if( NextMove != SM_PushCover )
	{
		InterpCoverObject = GetMovableInterpActor();
		if( InterpCoverObject != None )
		{
			if( NextMove != SM_PushCover )
			{
				PawnOwner.StopMoveCoverLoop();
				InterpCoverObject.UpdateCoverLinks();
			}
		}
	}
	PawnOwner.BS_Stop(BS_ManipulateCover, 0.2f);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

protected function InterpActor_MovableCover GetMovableInterpActor()
{
	return ((PawnOwner != None) && (PawnOwner.CurrentLink != None)) ? InterpActor_MovableCover(PawnOwner.CurrentLink.Base) : None;
}


defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
}
