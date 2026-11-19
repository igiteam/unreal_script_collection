/**
 * This class must be used for our Fan Volumes so we can modify it later
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoBounceMeshBase extends StaticMeshActor
	native
	abstract;

/** Incoming velocity will be multiplied by this factor and reflected around the hit normal */
var() float SpringFactor;

/** If TRUE, velocity will be reflected around the normal of the impact.  If FALSE, the pawn's Z-velocity will be locked positive */
var() bool  bReflectVelocity;

/** The minimum velocity of the pawn when leaving the bounce pad.  Prevents the player from getting stuck, or having a weak bounce */
var() float MinimumVelocity;

native function BouncePawn( NanoPawn Bouncee, vector HitLocation, vector HitNormal );

defaultproperties
{
	bBlockActors=TRUE
	bCollideActors=TRUE

	MinimumVelocity=500.f
}