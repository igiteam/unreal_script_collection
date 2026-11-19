/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * blocks only AI visibility and human "red crosshair" checks 
 */
class GearTargetingVisBlocker extends Actor
	native;

cpptext
{
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags);
}

event PostBeginPlay()
{
	local GearGRI GRI;

	Super.PostBeginPlay();

	// add to list to block player LOS checks
	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.TargetingBlockingVolumes.AddItem(self);
	}
}

event Destroyed()
{
	local GearGRI GRI;

	Super.Destroyed();

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.TargetingBlockingVolumes.RemoveItem(self);
	}
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=BlockingMesh
		StaticMesh=StaticMesh'AA_Test.Mesh.S_Fog_Sphere_Large'
		CollideActors=true
		BlockActors=false
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		BlockRigidBody=false
		HiddenGame=true
		Scale=2.5
	End Object
	Components.Add(BlockingMesh)
	CollisionComponent=BlockingMesh

	RemoteRole=ROLE_None
	bCollideActors=true
	bBlockActors=false
}
