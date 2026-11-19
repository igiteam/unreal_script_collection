/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoVolume_OrbitalsOnGround extends Volume;



// these don't work
/*
event PawnEnteredVolume( Pawn Other )
{
	`log( self @ "PawnEnteredVolume" @ Other );

	if( NanoInterface_SlickifyAffect(Other) != none )
	{
		// here we want to notify the pawn that it is has touched a slicked area
		NanoInterface_SlickifyAffect(Other).OnSlickify();
	}
}

event PawnLeavingVolume( Pawn Other )
{
	`log( self @ "PawnLeavingVolume" @ Other );
}
*/


simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

    //`log( self @ "Touched" @ Other );

	if( NanoInterface_SlickifyAffect(Other) != none )
	{
		// here we want to notify the pawn that it is has touched a slicked area
		NanoInterface_SlickifyAffect(Other).OnSlickify();
	}
}




defaultproperties
{
	bNoDelete=FALSE // for spawnability
    bStatic=FALSE 

	bCollideActors=TRUE
	bBlockActors=FALSE
	bHidden=TRUE
	bProjTarget=FALSE
	RemoteRole=ROLE_SimulatedProxy
	//Priority=100000
	//bPainCausing=FALSE

    bNetInitialRotation=TRUE

    // we can't generate arbitrary volumes so we need to use a mesh and scale it.
	Components.Remove(BrushComponent0)
	BrushComponent=None

	//128 128 128
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockActors=FALSE
		CollideActors=TRUE
		BlockRigidBody=FALSE
		CastShadow=FALSE
		HiddenGame=FALSE
		Scale3D=(X=1.0f,Y=1.0f,Z=0.50f)
	End Object
	CollisionComponent=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)



	// for now just leave these around for 30 seconds
	LifeSpan=30.0f
}


