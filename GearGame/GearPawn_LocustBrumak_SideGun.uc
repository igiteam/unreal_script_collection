/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustBrumak_SideGun extends GearPawn_LocustBrumakHelper_Base;

var bool bIsLeftGun;

replication
{
	if (bNetInitial)
		bIsLeftGun;
}

function AddDefaultInventory();
simulated function BuildAnimSetList();

simulated event Vector GetAimOffsetOrigin()
{
	return Weapon.GetPhysicalFireStartLoc();
}

defaultproperties
{
	ControllerClass=class'GearAI_Brumak_SideGun'
	RemoteRole=ROLE_SimulatedProxy
	bNeverAValidEnemy=TRUE

	Mesh=None
	Components.Remove(GearPawnMesh)
	bCollideActors=FALSE
	bCollideWorld=FALSE
	bBlockActors=FALSE
	bProjTarget=FALSE

	SightRadius=0
}

