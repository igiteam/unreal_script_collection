
/**
 * GSM_SilverbackLoaderDropCrate
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SilverbackLoaderDropCrate extends GearSpecialMove;

var GearPawn_SilverbackLoaderBase	SilverbackLoader;
var BodyStance DropAnimation;
var float BlendInTime;
var float DropTime;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	SilverbackLoader = GearPawn_SilverbackLoaderBase(PawnOwner);
	PlayDropAnimation();
}

function PlayDropAnimation()
{
	SilverbackLoader.BS_Play(DropAnimation, 1.f, BlendInTime, BlendInTime);
	SilverbackLoader.Driver.BS_Play(DropAnimation, 1.f, BlendInTime, BlendInTime);
	SilverbackLoader.SetTimer(DropTime, FALSE, nameof(Self.DropCrate), Self);
	PawnOwner.BS_SetAnimEndNotify(DropAnimation, TRUE);
}

function DropCrate()
{
	local StaticMeshComponent CrateMesh;
	local Rotator	NewRotation;

	SilverbackLoader.SetCollisionSize(SilverbackLoader.default.CylinderComponent.CollisionRadius, SilverbackLoader.default.CylinderComponent.CollisionHeight);

	// Ramp on the BoxAttachedBlendNode
	SilverbackLoader.BoxAttachedBlendNode.SetBlendTarget(0, 0.2f);
	SilverbackLoader.DriverBoxAttachedBlendNode.SetBlendTarget(0, 0.2f);

	// Detach crate 
	CrateMesh = SilverbackLoader.PickedUpCrate.StaticMeshComponent;
	// Backup rotation first, because SetRBPosition is going to cause a rotation update as well :(
	NewRotation = CrateMesh.GetRotation();
	CrateMesh.SetRBPosition( CrateMesh.GetPosition() );
	CrateMesh.SetRBRotation( NewRotation );

	SilverbackLoader.PickedUpCrate.SetBase(None);
	SilverbackLoader.PickedUpCrate.SetPhysics(PHYS_RigidBody);
	CrateMesh.WakeRigidBody();

	SilverbackLoader.PickedUpCrate.ResolveRBState();
	SilverbackLoader.PickedUpCrate = None;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Clear timer if it's been set.
	PawnOwner.ClearTimer(nameof(Self.DropCrate), Self);
	// Disable end of animation notification, so it doesn't interfere with future special moves
	// using that same animation channel.
	PawnOwner.BS_SetAnimEndNotify(DropAnimation, FALSE);

	if( PawnOwner.MyGearAI != None )
	{
		PawnOwner.MyGearAI.ClearTether();
		PawnOwner.MyGearAI.SilverbackCrateAction.ActivateOutputLink(0);
		PawnOwner.MyGearAI.SilverbackCrateAction = None;
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	DropAnimation=(Stance=((Slot=BS_FullBody,AnimName="Loader_DropPayload")))
	BlendInTime=0.33f
	DropTime=0.67f
	bDisableMovement=TRUE
}

