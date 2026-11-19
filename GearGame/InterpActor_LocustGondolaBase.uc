/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpActor_LocustGondolaBase extends InterpActor_GearBasePlatform
	abstract
	notplaceable
	deprecated;

var protected StaticMeshComponent HighCollision;
var protected StaticMeshComponent LowCollision;

defaultproperties
{
	BlockRigidBody=TRUE
	bCollideActors=TRUE
	bBlockActors=TRUE

	// no clamp so we can do the gondola switch
	bClampedBaseEnabled=FALSE

	Begin Object Name=MyLightEnvironment
		bEnabled=TRUE
	End Object

	// this obj is for all collision except rbs
	// has high walls, used everywhere except during mantle sequence
	Begin Object Class=StaticMeshComponent Name=HighWallCollision0
	End Object
	// don't attach this one by default.  this way the mantle stuff will build properly.
	// LDs will bring up high wall collision on demand
	HighCollision=HighWallCollision0

	// this obj is for all collision except rbs
	// has low walls, used during mantle sequence
	Begin Object Class=StaticMeshComponent Name=LowWallCollision0
	End Object
	Components.Add(LowWallCollision0)
	LowCollision=LowWallCollision0

	// this obj is designed solely to provide collision for rigid bodies
	Begin Object Class=StaticMeshComponent Name=RBCollision0
	End Object
	Components.Add(RBCollision0)
}