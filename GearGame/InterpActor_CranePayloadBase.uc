/** 
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class InterpActor_CranePayloadBase extends InterpActor
	notplaceable;

var transient Vehicle_Crane_Base Crane;

defaultproperties
{
	bCollideWorld=TRUE
	bBlockActors=TRUE
	bCollideActors=TRUE

	Begin Object Name=StaticMeshComponent0
		CollideActors=TRUE
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=TRUE
	End Object
	StaticMeshComponent=StaticMeshComponent0
	CollisionComponent=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)
}
