/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMGib_VehiclePiece extends TMGib_Vehicle
	notplaceable;


simulated event PreBeginPlay()
{
	// we skip TMGib as TMGib will do ChooseGib().  For the VehiclePieces we know they are only StaticMeshes 
	// and that StaticMesh is stored in the SkelControl_Damage so when we spawn one of these we call SetGibStaticMesh( Mesh )
	Super(Actor).PreBeginPlay();
}



