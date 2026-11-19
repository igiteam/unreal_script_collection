/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoVehicleSpline_Elevator extends NanoVehicleSpline
	placeable;

simulated event bool IsValidSplineForVehicle(NanoVehicleAgent Vehicle)
{
	return (NanoVehicle_ElevatorBase(Vehicle) != None);
}

defaultproperties
{
	DeformMesh=None
	BoundaryMesh=None

	bManageTraffic=FALSE
}