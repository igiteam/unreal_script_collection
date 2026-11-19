/**
 * Base class for GearInv_GrapplingHook
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearInv_GrapplingHookBase extends GearMeleeTarget
	config(Pawn);

/** The grappling hook mesh */
var SkeletalMeshComponent		GrapplingHookMesh;

/** How much damage it takes to detach. */
var config protected float		Health;

/** Tweakable params for controlling how the hook looks when it detaches. */
var() protected const vector	DetachImpulseExtra;
var() protected const float		DetachImpulseMag;

/**
 * Knock off the grappling hook if enough damage has been taken
 * 
 * @param DamageAmount - the amount of damage inflicted
 * 
 * @param EventInstigator - the damage instigator
 * 
 * @param HitLocation - the location the damage occurred
 * 
 * @param Momentum - the direction of the damage
 * 
 * @param HitInfo - misc info about the damage
 * 
 * @param DamageCauser - the actor that inflicted the damage
 */
function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (WorldInfo.NetMode != NM_Client)
	{
		// Melee should always knock it off
		if (ClassIsChildOf(DamageType, class'GDT_Melee'))
		{
			DamageAmount = Health;
		}

		Health -= DamageAmount;

		if (Health <= 0 && Physics != PHYS_RigidBody)
		{
			KnockOff(EventInstigator);
		}
	}
}

/**
 * Kill the climber and make the grappling hook go ragdoll
 * 
 * @param EventInstigator - the controller that knocked off the grappling hook
 */
simulated final function KnockOff(Controller EventInstigator)
{
	local GearPawn OwnerGP;
	local GearAnim_Slot AnimSlot;
	local vector DetachMomentum;

	// go "ragdoll"
	GrapplingHookMesh.PhysicsWeight = 1.0f;
	GrapplingHookMesh.SetHasPhysicsAssetInstance(TRUE);

	SetPhysics(PHYS_RigidBody);

	// Make sure all motors are off on joints.
	GrapplingHookMesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, GrapplingHookMesh, TRUE);
	GrapplingHookMesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

	// Set physics to NOT be updated from Kinematic data
	GrapplingHookMesh.bUpdateJointsFromAnimation = FALSE;
	GrapplingHookMesh.bUpdateKinematicBonesFromAnimation = FALSE;

	OwnerGP = GearPawn(Owner);
	if (OwnerGP != None)
	{
		AnimSlot = OwnerGP.GetGrapplingHookAnimSlot();

		// stop any animations
		if (AnimSlot != None)
		{
			AnimSlot.StopAnim();
		}

		if (OwnerGP.Role == ROLE_Authority)
		{
			// kill the climbing pawn, let him fall
			OwnerGP.TakeDamage(99999.f, EventInstigator, OwnerGP.Location, -vector(Rotation), class'GDT_FallOffGrappleRope');
		}
	}

	// Wake up rigid body
	GrapplingHookMesh.WakeRigidBody();

	DetachMomentum = -vector(Rotation) * DetachImpulseMag + DetachImpulseExtra;
	GrapplingHookMesh.AddImpulse(DetachMomentum);

	// die soon
	LifeSpan = 5.f;
}