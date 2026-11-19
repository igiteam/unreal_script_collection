/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearDroppedPickup_PHYSFalling extends GearDroppedPickup
	native;

/** Save a reference to the collision cylinder */
var CylinderComponent ColCylinder;

/** Keep track of the original collision settings */
var protected float OriginalCollisionRadius, OriginalCollisionHeight;

/** Keep track of the original collision component */
var PrimitiveComponent OriginalCollisionComponent;

cpptext
{
	/**
	 * Restore the original collision when going PHYS_None
	 * 
	 * @param NewPhysics - the new physics mode to use
	 * 
	 * @param NewFloor - Not used.
	 * 
	 * @param NewFloorV - Not used.
	 */
	virtual void setPhysics(BYTE NewPhysics, AActor *NewFloor, FVector NewFloorV);
	
	/**
	 * Stop the rigid body sim on first collision so we don't roll down hills
	 * 
	 * @param MyInfo - info about the collision with our rigid body
	 * 
	 * @param OtherInfo - info about the collision with the other body
	 * 
	 * @param RigidCollisionData - info about the impact
	 */
	virtual void OnRigidBodyCollision(const FRigidBodyCollisionInfo& MyInfo, const FRigidBodyCollisionInfo& OtherInfo, const FCollisionImpactData& RigidCollisionData);
}

/**
 * Change from rigid body physics to falling physics
 * Make it cylinder collision with a tiny cylinder
 * 
 * @param NewPickupMesh - the mesh of the pickup
 */
simulated function SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
	Super.SetPickupMesh(NewPickupMesh);
	
	OriginalCollisionRadius = ColCylinder.CollisionRadius;
	OriginalCollisionHeight = ColCylinder.CollisionHeight;

	ColCylinder.SetCylinderSize(1, OriginalCollisionHeight);

	OriginalCollisionComponent = CollisionComponent;
	CollisionComponent = ColCylinder;

	SetPhysics(PHYS_Falling);
}

defaultproperties
{
	ColCylinder=CollisionCylinder
}