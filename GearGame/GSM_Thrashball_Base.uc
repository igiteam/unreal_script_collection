/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Thrashball_Base extends GearSpecialMove;

var const	GearPawn.BodyStance	BS_Animation;
var float   InterpTimeToAdd;

protected function bool InternalCanDoSpecialMove()
{
	return !PawnOwner.IsDoingASpecialMove() || PawnOwner.IsDoingSpecialMove(SM_RoadieRun); 
}

/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == SM_RoadieRun);
}

/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return (NewMove == SM_RoadieRun);
}

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_RoadieRun);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.StopFiring();

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, -1.f, FALSE, TRUE);

	// Turn on root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPC PC;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);
	PawnOwner.BS_Stop( BS_Animation, 0.5f/SpeedModifier );

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	PC = GearPC(PawnOwner.Controller);
	if (PC != None && (PC.IsHoldingRoadieRunButton() || PC.bForcedRoadieRun) )
	{
		PawnOwner.ServerDoSpecialMove( SM_RoadieRun, TRUE );
	}

}

function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	Super.AnimNotify( SeqNode, NotifyObject );

	if( PawnOwner.InteractionPawn != None )
	{
		PawnOwner.InteractionPawn.TakeDamage( 10000, PawnOwner.Controller, PawnOwner.InteractionPawn.Location, vector(PawnOwner.InteractionPawn.Rotation) * -500, class'GDT_Shotgun' );
		PawnOwner.InteractionPawn.SetCollision( FALSE, FALSE );
	}
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	Input.aTurn = 0.f;
}

defaultproperties
{
	bShouldAbortWeaponReload=FALSE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=TRUE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE
	bRestoreMovementAfterMove=TRUE

	InterpTimeToAdd=0.25f
}
