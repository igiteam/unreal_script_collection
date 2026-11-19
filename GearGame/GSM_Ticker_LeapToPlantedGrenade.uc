
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Ticker_LeapToPlantedGrenade extends GSM_BasePlaySingleAnim;

/** Actor to pickup */
var Actor PickupActor;

protected function bool InternalCanDoSpecialMove()
{
	return ( PawnOwner.Physics != PHYS_RigidBody );
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Turn on root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	PawnOwner.SetTimer(0.5f, FALSE, 'DoPickUp', Self);
}

function DoPickUp()
{
	if( GearProj_Grenade(PickupActor) != None )
	{
		PawnOwner.GrabPickup(PickupActor);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	PawnOwner.ZeroMovementVariables();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="jump_on_wall_grenade")))

	BlendInTime=0.25f
	BlendOutTime=0.25f
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
}
