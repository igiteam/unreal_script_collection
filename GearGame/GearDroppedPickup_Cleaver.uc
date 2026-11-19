/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearDroppedPickup_Cleaver extends GearDroppedPickup;

/** This is different mesh than the one spawned in the level. This one happens when you throw **/
var SkeletalMeshComponent CleaverDroppedMesh;

simulated event ReplicatedEvent(name VarName)
{
	if( VarName == 'InventoryClass' )
	{
		SetDefaultMesh();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Force mesh update - otherwise you'll have ref pose mesh at the first frame **/
simulated function  ForceMeshUpdate()
{
	if (MyMeshComp!=none)
	{
		MyMeshComp.LastRenderTime = WorldInfo.TimeSeconds;
	}
}

/** This is default mesh for cleaver throw drop **/
simulated function SetDefaultMesh()
{
	SetPickupMesh( CleaverDroppedMesh );
	SetPickupParticles( InventoryClass.default.DroppedPickupParticles );
	ForceMeshUpdate();
}

defaultproperties
{
}
